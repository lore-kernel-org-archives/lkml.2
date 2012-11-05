Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2KEDYV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 22:24:21 -0500
Received: from ozlabs.org ([203.10.76.45]:32932 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab2KEDYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 22:24:19 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Bruno Wolff III <bruno@wolff.to>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MODSIGN: Only sign modules if built in-tree
In-Reply-To: <20121102123404.GO6627@hansolo.jdub.homelinux.org>
References: <20121031132749.GH6627@hansolo.jdub.homelinux.org> <87390t6bs0.fsf@rustcorp.com.au> <20121101112655.GM6627@hansolo.jdub.homelinux.org> <20121101145013.GN6627@hansolo.jdub.homelinux.org> <87liek4rt5.fsf@rustcorp.com.au> <20121102123404.GO6627@hansolo.jdub.homelinux.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 05 Nov 2012 12:31:39 +1030
Message-ID: <87vcdkyfi4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@redhat.com> writes:
> diff --git a/Makefile b/Makefile
> index 14c93b3..7e27d51 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -722,8 +722,14 @@ export mod_strip_cmd
>  ifeq ($(CONFIG_MODULE_SIG),y)
>  MODSECKEY = ./signing_key.priv
>  MODPUBKEY = ./signing_key.x509
> +ifeq ($(KBUILD_EXTMOD),)
> +SIGNFAIL = false
> +else
> +# External builds might not have a signing key, don't break module_install.
> +SIGNFAIL = true
> +endif # KBUILD_EXTMOD
>  export MODPUBKEY
> -mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
> +mod_sign_cmd = $(SIGNFAIL) || perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
>  else
>  mod_sign_cmd = true
>  endif

Huh?  'true || perl' never runs perl due to short circuiting.

Let's do this instead.  Tested here, please ack.

Thanks,
Rusty.

modules: don't break modules_install on external modules with no key.

The script still spits out an error ("Can't read private key") but we
don't break modules_install.

Reported-by: Bruno Wolff III <bruno@wolff.to>
Original-patch-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index dda4b2b..ecbb447 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -16,8 +16,9 @@ PHONY += $(modules)
 __modinst: $(modules)
 	@:
 
+# Don't stop modules_install if we can't sign external modules.
 quiet_cmd_modules_install = INSTALL $@
-      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) $(2)/$(notdir $@) ; $(mod_sign_cmd) $(2)/$(notdir $@)
+      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) $(2)/$(notdir $@) ; $(mod_sign_cmd) $(2)/$(notdir $@) $(patsubst %,|| true,$(KBUILD_EXTMOD))
 
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
