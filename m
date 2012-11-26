Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab2KZO0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:26:21 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48230 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab2KZO0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:26:20 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [RFC][PATCH 1/2] modsig: add support to sign kernel modules using ephemeral keys
Date: Mon, 26 Nov 2012 09:23:05 -0500
Message-Id: <1353939786-4829-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112614-9360-0000-0000-00000D2B0A86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

Signed modules are only as secure as the private key used to sign
them.  This patch limits access to the private key by limiting the
private key's existence to 'modules_install'(ie. this is meant for
local developers, not distros.)

This patch defines a new kernel build command line parameter
called MODSIG (eg. make MODSIG=1 modules_install) and adds
support for ephemeral keys.

MODSIG=1 creates an ephemeral key pair during 'modules_install',
forcing the rebuilding of the bzImage containing the new ephemeral
builtin public key, signs the kernel modules with the private key,
and then destroys the private key, limiting the existance of the
private key to the 'modules_install' execution time.  (The private
key's existence could be further limited, if the key generation
wasn't tied to a specific file, but defined as a separate target.)

Another possible MODSIG option would be to password protect the
private key.  Although this option is not as safe as removing the
private key, it would not require rebuilding the bzImage, as the
key pair is generated during 'make'.

Changelog v1:
- rebased on the upsteamed kernel module support

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 Makefile |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 9f6ca12..d0dd777 100644
--- a/Makefile
+++ b/Makefile
@@ -718,10 +718,17 @@ mod_strip_cmd = true
 endif # INSTALL_MOD_STRIP
 export mod_strip_cmd
 
+export KBUILD_MODSIG := 0
 
 ifeq ($(CONFIG_MODULE_SIG),y)
 MODSECKEY = ./signing_key.priv
 MODPUBKEY = ./signing_key.x509
+
+# Use 'make MODSIG=1 modules_install' to use ephemeral keys for module signing
+ifeq ("$(origin MODSIG)", "command line")
+KBUILD_MODSIG := $(MODSIG)
+endif
+
 export MODPUBKEY
 mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
 else
@@ -957,8 +964,27 @@ modules_prepare: prepare scripts
 
 # Target to install modules
 PHONY += modules_install
+
+# Create an ephemeral keypair before module install
+ifeq ($(KBUILD_MODSIG),1)
+modules_install: _newmodpubkey_
+endif
+
 modules_install: _modinst_ _modinst_post
 
+ifeq ($(KBUILD_MODSIG),1)
+modules_install:  _rmprivkey_
+endif
+
+PHONY += _newmodpubkey_
+_newmodpubkey_: 
+	@rm -f $(MODSECKEY) $(MODPUBKEY)
+	$(Q)$(MAKE) -W kernel/modsign_pubkey.o
+
+PHONY += _rmprivkey_ 
+_rmprivkey_: 
+	@rm -f $(MODSECKEY)
+
 PHONY += _modinst_
 _modinst_:
 	@rm -rf $(MODLIB)/kernel
-- 
1.7.7.6

