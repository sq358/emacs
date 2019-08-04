;; init.el --- Emacs configuration

(setq gc-cons-threshold 50000000)
(setq large-file-warning-threshold 100000000)
(setq inhibit-startup-message t) ;; hide the startup message
(setq-default indent-tabs-mode nil) ;; don't use tab for indentation
(setq-default tab-width 4) ;; set default tab char's display width to 4 spaces
(setq explicit-shell-file-name "/bin/zsh")


;; INSTALL PACKAGES
;; --------------------------------------

;;; Code:
(require 'package)

(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(defvar my-packages
  '(better-defaults
    elpy
    material-theme))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      my-packages)

;; BASIC CUSTOMIZATION
;; --------------------------------------


;;; Make Emacs UI Slick
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)

;;; Configure backups

(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2)

;;; Tune revert-buffer
(global-set-key [(control c) r] 'revert-buffer)
(global-auto-revert-mode 1)

;;; For Max. Use CMD for Meta
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

(setq-default tab-width 4
              indent-tabs-mode nil)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(add-hook 'before-save-hook 'whitespace-cleanup)

(add-hook 'text-mode-hook 'turn-on-auto-fill)

(use-package ace-window
  :ensure t
  :config
  (global-set-key (kbd "M-o") 'ace-window)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package diminish
  :ensure t)

(use-package edit-server
  :ensure t)

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode 1)
    (show-paren-mode t)))

(use-package expand-region
  :ensure t
  :bind ("M-m" . er/expand-region))

(use-package smart-mode-line-powerline-theme
  :ensure t)

(use-package smart-mode-line
  :ensure t
  :config
  (setq sml/theme 'powerline)
  (add-hook 'after-init-hook 'sml/setup))

(use-package company
  :ensure t
  :diminish company-mode
  :config
  (add-hook 'after-init-hook #'global-company-mode))

(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package magit
  :bind (("C-M-g" . magit-status)))

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config))

;; Use neo-tree
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(custom-enabled-themes (quote (doom-one)))
 '(custom-safe-themes
   (quote
    ("84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" "732b807b0543855541743429c9979ebfb363e27ec91e82f463c91e68c772f6e3" default)))
 '(hl-sexp-background-color "#1c1f26")
 '(jdee-db-active-breakpoint-face-colors (cons "#1B2229" "#51afef"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1B2229" "#98be65"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1B2229" "#3f444a"))
 '(objed-cursor-color "#ff6c6b")
 '(package-selected-packages
   (quote
    (magit neotree 0blayout elpy material-theme company better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(global-hl-line-mode +1)
(line-number-mode +1)
(global-display-line-numbers-mode 1)
(column-number-mode t)
(size-indication-mode t)

;; SETUP 2-SPACE TABS
;; --------------------------------------

;; sets up 2-space indent for the required modes
(defun setup-2-space-indent ()
  (interactive)
  (setq sh-basic-offset 2
    sh-indentation 2))

;; sets up 4-space indent for the required modes
(defun setup-4-space-indent ()
  (interactive)
  (setq sh-basic-offset 4
    sh-indentation 4))


(add-hook 'sh-mode-hook 'setup-2-space-indent)
(add-hook 'ruby-mode-hook 'setup-2-space-indent)
(add-hook 'conf-mode-hook 'setup-4-space-indent)

(desktop-save-mode 1)
(elpy-enable)
(setq python-shell-interpreter "/usr/local/bin/ipython")

;; Show the full path of the file in title bar
(setq frame-title-format
      '(:eval (if (buffer-file-name)
                  (abbreviate-file-name (buffer-file-name))
                "%b")))

(require 'server)
(require 'edit-server)
(if (not (server-running-p)) (server-start))
(edit-server-start)

;; SETUP RULLER
;; ------------------------------------------

(defun sanityinc/fci-enabled-p () (symbol-value 'fci-mode))

(defvar sanityinc/fci-mode-suppressed nil)
(make-variable-buffer-local 'sanityinc/fci-mode-suppressed)

(defadvice popup-create (before suppress-fci-mode activate)
"Suspend fci-mode while popups are visible"
(let ((fci-enabled (sanityinc/fci-enabled-p)))
  (when fci-enabled
    (setq sanityinc/fci-mode-suppressed fci-enabled)
    (turn-off-fci-mode))))

(defadvice popup-delete (after restore-fci-mode activate)
"Restore fci-mode when all popups have closed"
(when (and sanityinc/fci-mode-suppressed
           (null popup-instances))
  (setq sanityinc/fci-mode-suppressed nil)
  (turn-on-fci-mode)))

;; INDENT/UN-INDENT BINDINGS
(defun my-indent-region (N)
  (interactive "p")
  (if (use-region-p)
      (progn (indent-rigidly (region-beginning) (region-end) (* N 4))
             (setq deactivate-mark nil))
    (self-insert-command N)))

(defun my-unindent-region (N)
  (interactive "p")
  (if (use-region-p)
      (progn (indent-rigidly (region-beginning) (region-end) (* N -4))
             (setq deactivate-mark nil))
    (self-insert-command N)))

(global-set-key ">" 'my-indent-region)
(global-set-key "<" 'my-unindent-region)
