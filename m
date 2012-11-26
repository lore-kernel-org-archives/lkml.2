Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2KZOZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:25:17 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37472 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab2KZOZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:25:15 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [RFC][PATCH 2/2] modsig: differentiate between ephemeral and persistent key names
Date: Mon, 26 Nov 2012 09:23:06 -0500
Message-Id: <1353939786-4829-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1353939786-4829-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1353939786-4829-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112614-5806-0000-0000-00001C29F840
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the same name for ephemeral and "persistent" keys results
in deleting the "persistent" key.  This patch renames the normal
kbuild asymmetric key pair name to "default_signing_key" and the
ephemeral key pair name to "ephemeral_signing_key".

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 Makefile        |   14 +++++++++-----
 kernel/Makefile |   12 ++++++++----
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index d0dd777..525f512 100644
--- a/Makefile
+++ b/Makefile
@@ -721,15 +721,17 @@ export mod_strip_cmd
 export KBUILD_MODSIG := 0
 
 ifeq ($(CONFIG_MODULE_SIG),y)
-MODSECKEY = ./signing_key.priv
-MODPUBKEY = ./signing_key.x509
-
 # Use 'make MODSIG=1 modules_install' to use ephemeral keys for module signing
 ifeq ("$(origin MODSIG)", "command line")
 KBUILD_MODSIG := $(MODSIG)
+MODSECKEY = ./ephemeral_signing_key.priv
+MODPUBKEY = ./ephemeral_signing_key.x509
+else
+MODSECKEY = ./default_signing_key.priv
+MODPUBKEY = ./default_signing_key.x509
 endif
 
-export MODPUBKEY
+export MODPUBKEY MODSECKEY
 mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
 else
 mod_sign_cmd = true
@@ -1037,7 +1039,9 @@ MRPROPER_DIRS  += include/config usr/include include/generated          \
                   arch/*/include/generated
 MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
-		  signing_key.priv signing_key.x509 x509.genkey		\
+		  default_signing_key.priv default_signing_key.x509	\
+		  ephemeral_signing_key.priv ephemeral_signing_key.x509 \
+		  signing_key.x509 x509.genkey				\
 		  extra_certificates signing_key.x509.keyid		\
 		  signing_key.x509.signer
 
diff --git a/kernel/Makefile b/kernel/Makefile
index 86e3285..34107d9 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -139,7 +139,11 @@ ifeq ($(CONFIG_MODULE_SIG),y)
 extra_certificates:
 	touch $@
 
-kernel/modsign_pubkey.o: signing_key.x509 extra_certificates
+signing_key.x509: FORCE
+	ln -fs $(MODPUBKEY) $@
+	touch $@
+
+kernel/modsign_pubkey.o: $(MODPUBKEY) signing_key.x509 extra_certificates 
 
 ###############################################################################
 #
@@ -168,7 +172,7 @@ ifeq ($(sign_key_with_hash),)
 $(error Could not determine digest type to use from kernel config)
 endif
 
-signing_key.priv signing_key.x509: x509.genkey
+$(MODSECKEY) $(MODPUBKEY): x509.genkey
 	@echo "###"
 	@echo "### Now generating an X.509 key pair to be used for signing modules."
 	@echo "###"
@@ -179,8 +183,8 @@ signing_key.priv signing_key.x509: x509.genkey
 	@echo "###"
 	openssl req -new -nodes -utf8 $(sign_key_with_hash) -days 36500 -batch \
 		-x509 -config x509.genkey \
-		-outform DER -out signing_key.x509 \
-		-keyout signing_key.priv
+		-outform DER -out $(MODPUBKEY) \
+		-keyout $(MODSECKEY)
 	@echo "###"
 	@echo "### Key pair generated."
 	@echo "###"
-- 
1.7.7.6

