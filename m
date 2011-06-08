Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1FHJEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:04:09 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:61323 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab1FHJEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iKnn7Boy8pjcO/PTBOco8T+gBMgRXbMtqSHq2SBBWSd/80pvigFDu0mvnlOFMUP32z
         fGYghTC3tEdi/qCxnGwZyo5r55LVJcJfuyVyNgthMscAspRzp8NdBpUZpIsl0du67N2s
         vIGGTDEwd4B64EywWyH6WLngujJ3qX8yDpnq4=
From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: [RFC v1 5/5] evm: creates dedicated evm keyring to store public keys
Date: Wed,  8 Jun 2011 12:03:20 +0300
Message-Id: <91c60b69df5c63fdccb993569c91ba2f2e36bd04.1307522457.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1307522457.git.dmitry.kasatkin@intel.com>
References: <cover.1307522457.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1307522457.git.dmitry.kasatkin@intel.com>
References: <cover.1307522457.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

EVM/IMA might perform lots of signature verification operations.
For that reason performance is very critical. This patch adds
evm_keyring to store public keys used by EVM only.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/evm/evm.h      |    4 +++-
 security/integrity/evm/evm_main.c |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index 9e1bcba..4f4ba20 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -32,6 +32,8 @@ extern struct crypto_shash *hash_tfm;
 /* List of EVM protected security xattrs */
 extern char *evm_config_xattrnames[];
 
+extern struct key *evm_keyring;
+
 extern int evm_init_key(void);
 extern int evm_update_evmxattr(struct dentry *dentry,
 			       const char *req_xattr_name,
@@ -53,7 +55,7 @@ extern void evm_cleanup_secfs(void);
 static inline int evm_sign_verify(const char *sig, int siglen,
 		       const char *digest, int digestlen)
 {
-	return ksign_verify(NULL, sig, siglen, digest, digestlen);
+	return ksign_verify(evm_keyring, sig, siglen, digest, digestlen);
 }
 
 #else
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 65518fb..96794a0 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -20,6 +20,7 @@
 #include <linux/integrity.h>
 #include <linux/evm.h>
 #include <crypto/hash.h>
+#include <linux/init_task.h>
 #include "evm.h"
 
 int evm_initialized;
@@ -38,6 +39,8 @@ char *evm_config_xattrnames[] = {
 	NULL
 };
 
+struct key *evm_keyring;
+
 static int evm_fixmode;
 static int __init evm_set_fixmode(char *str)
 {
@@ -382,18 +385,33 @@ static int __init init_evm(void)
 {
 	int error;
 
+#ifdef CONFIG_EVM_DIGSIG
+	evm_keyring = keyring_alloc("_evm", 0, 0, &init_cred,
+					KEY_ALLOC_NOT_IN_QUOTA, NULL);
+	if (IS_ERR(evm_keyring))
+		return PTR_ERR(evm_keyring);
+#endif
+
 	error = evm_init_secfs();
 	if (error < 0) {
 		printk(KERN_INFO "EVM: Error registering secfs\n");
 		goto err;
 	}
+
+	return 0;
 err:
+#ifdef CONFIG_EVM_DIGSIG
+	key_put(evm_keyring);
+#endif
 	return error;
 }
 
 static void __exit cleanup_evm(void)
 {
 	evm_cleanup_secfs();
+#ifdef CONFIG_EVM_DIGSIG
+	key_put(evm_keyring);
+#endif
 	if (hmac_tfm)
 		crypto_free_shash(hmac_tfm);
 	if (hash_tfm)
-- 
1.7.4.1

