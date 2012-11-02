Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2KBMeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 08:34:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab2KBMeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 08:34:10 -0400
Date: Fri, 2 Nov 2012 08:34:04 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Bruno Wolff III <bruno@wolff.to>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] MODSIGN: Only sign modules if built in-tree
Message-ID: <20121102123404.GO6627@hansolo.jdub.homelinux.org>
References: <20121031132749.GH6627@hansolo.jdub.homelinux.org>
 <87390t6bs0.fsf@rustcorp.com.au>
 <20121101112655.GM6627@hansolo.jdub.homelinux.org>
 <20121101145013.GN6627@hansolo.jdub.homelinux.org>
 <87liek4rt5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87liek4rt5.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building out-of-tree modules, the current modules_install target
will attempt to sign them if module signing is enabled.  This will only
work if the signing keys are present in the build tree.  That will
often not be the case for modules that are built out-of-tree against
distribution kernel development packages.  This distros will not include
the signing keys, and build errors such as:

    INSTALL /home/bruno/rpmbuild/BUILD/dahdi-linux-2.6.1/drivers/dahdi/dahdi_dya
mic_eth.ko
    Can't read private key
    make[2]: *** [/home/bruno/rpmbuild/BUILD/dahdi-linux-2.6.1/drivers/dahdi/dah
di_dynamic.ko] Error 2

will prevent such modules from successfully being installed.  This changes
the mod_sign_cmd to only sign the modules if they are built in-tree.  Those
built externally can sign them manually.

Reported-by: Bruno Wolff III <bruno@wolff.to>
Suggested-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 Makefile | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 14c93b3..7e27d51 100644
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
+mod_sign_cmd = $(SIGNFAIL) || perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
 else
 mod_sign_cmd = true
 endif
-- 
1.7.12.1

