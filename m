Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422861Ab2JaN14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:27:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935556Ab2JaN1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:27:54 -0400
Date: Wed, 31 Oct 2012 09:27:50 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Bruno Wolff III <bruno@wolff.to>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MODSIGN: Only sign modules if built in-tree
Message-ID: <20121031132749.GH6627@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

    INSTALL /home/bruno/rpmbuild/BUILD/dahdi-linux-2.6.1/drivers/dahdi/dahdi_dyamic_eth.ko
    Can't read private key
    make[2]: *** [/home/bruno/rpmbuild/BUILD/dahdi-linux-2.6.1/drivers/dahdi/dahdi_dynamic.ko] Error 2

will prevent such modules from successfully being installed.  This changes
the mod_sign_cmd to only sign the modules if they are built in-tree.  Those
built externally can sign them manually.

Reported-by: Bruno Wolff III <bruno@wolff.to>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index 42d0e56..3d10a87 100644
--- a/Makefile
+++ b/Makefile
@@ -720,6 +720,7 @@ export mod_strip_cmd
 
 
 ifeq ($(CONFIG_MODULE_SIG),y)
+ifeq ($(KBUILD_EXTMOD),)
 MODSECKEY = ./signing_key.priv
 MODPUBKEY = ./signing_key.x509
 export MODPUBKEY
@@ -727,6 +728,9 @@ mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
 else
 mod_sign_cmd = true
 endif
+else
+mod_sign_cmd = true
+endif
 export mod_sign_cmd
 
 
-- 
1.7.12.1

