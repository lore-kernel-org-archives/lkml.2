Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab2KAHnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 03:43:11 -0400
Received: from ozlabs.org ([203.10.76.45]:52212 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab2KAHnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 03:43:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Bruno Wolff III <bruno@wolff.to>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: Only sign modules if built in-tree
In-Reply-To: <20121031132749.GH6627@hansolo.jdub.homelinux.org>
References: <20121031132749.GH6627@hansolo.jdub.homelinux.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 01 Nov 2012 17:38:15 +1030
Message-ID: <87390t6bs0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@redhat.com> writes:
> When building out-of-tree modules, the current modules_install target
> will attempt to sign them if module signing is enabled.  This will only
> work if the signing keys are present in the build tree.  That will
> often not be the case for modules that are built out-of-tree against
> distribution kernel development packages.  This distros will not include
> the signing keys, and build errors such as:
>
>     INSTALL /home/bruno/rpmbuild/BUILD/dahdi-linux-2.6.1/drivers/dahdi/dahdi_dyamic_eth.ko
>     Can't read private key
>     make[2]: *** [/home/bruno/rpmbuild/BUILD/dahdi-linux-2.6.1/drivers/dahdi/dahdi_dynamic.ko] Error 2
>
> will prevent such modules from successfully being installed.  This changes
> the mod_sign_cmd to only sign the modules if they are built in-tree.  Those
> built externally can sign them manually.

I prefer something like this (untested):

diff --git a/Makefile b/Makefile
index 42d0e56..cb66c8d 100644
--- a/Makefile
+++ b/Makefile
@@ -722,8 +722,14 @@ export mod_strip_cmd
 ifeq ($(CONFIG_MODULE_SIG),y)
 MODSECKEY = ./signing_key.priv
 MODPUBKEY = ./signing_key.x509
+ifeq ($(KBUILD_EXTMOD),)
+SIGNFAIL = false
+else
+# External builds might not have a signing key, don't break module_install.
+SIGNFAIL = true
+endif # KBUILD_EXTMOD
 export MODPUBKEY
-mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
+mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY) || $(SIGNFAIL)
 else
 mod_sign_cmd = true
 endif
