Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab1IFNKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 09:10:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:64974 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab1IFNJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 09:09:53 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com
Subject: [RFC v2.0 3/3] evm: digital signature support
Date: Tue,  6 Sep 2011 16:11:07 +0300
Message-Id: <850024352ce936b429c82aaf26b437b7332344dc.1315313377.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1315314576.git.dmitry.kasatkin@intel.com>
References: <cover.1315314576.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1315313377.git.dmitry.kasatkin@intel.com>
References: <cover.1315313377.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building an image, which has to be flashed to different devices,
an HMAC cannot be used to sign file metadata, as the HMAC key is different
on every device. File metadata can be protected using digital signature.
This patch enables RSA signature based integrity verification.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/evm/Kconfig      |   14 ++++
 security/integrity/evm/evm.h        |   12 ++++
 security/integrity/evm/evm_crypto.c |   66 ++++++++++++++-----
 security/integrity/evm/evm_main.c   |  125 +++++++++++++++++++++++++++++++----
 4 files changed, 187 insertions(+), 30 deletions(-)

diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
index 884617d..84eea75 100644
--- a/security/integrity/evm/Kconfig
+++ b/security/integrity/evm/Kconfig
@@ -12,3 +12,17 @@ config EVM
 	  integrity attacks.
 
 	  If you are unsure how to answer this question, answer N.
+
+config EVM_DIGSIG
+	boolean "EVM Digital Signature support"
+	depends on EVM
+	default n
+	select CRYPTO_KSIGN_RSA
+	help
+	  When building an image, which has to be flashed to different
+	  devices, an HMAC cannot be used to sign file metadata, as
+	  the HMAC key is different on every device.
+	  File metadata can be protected using digital signature.
+	  This option enables RSA signature based integrity verification.
+
+	  If unsure, say N.
diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index d320f51..c885247 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -12,14 +12,21 @@
  * File: evm.h
  *
  */
+
+#ifndef __INTEGRITY_EVM_H
+#define __INTEGRITY_EVM_H
+
 #include <linux/xattr.h>
 #include <linux/security.h>
+
 #include "../integrity.h"
 
 extern int evm_initialized;
 extern char *evm_hmac;
+extern char *evm_hash;
 
 extern struct crypto_shash *hmac_tfm;
+extern struct crypto_shash *hash_tfm;
 
 /* List of EVM protected security xattrs */
 extern char *evm_config_xattrnames[];
@@ -32,7 +39,12 @@ extern int evm_update_evmxattr(struct dentry *dentry,
 extern int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
 			 const char *req_xattr_value,
 			 size_t req_xattr_value_len, char *digest);
+extern int evm_calc_hash(struct dentry *dentry, const char *req_xattr_name,
+			 const char *req_xattr_value,
+			 size_t req_xattr_value_len, char *digest);
 extern int evm_init_hmac(struct inode *inode, const struct xattr *xattr,
 			 char *hmac_val);
 extern int evm_init_secfs(void);
 extern void evm_cleanup_secfs(void);
+
+#endif
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 5dd5b140..847a2d7 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -26,34 +26,48 @@ static unsigned char evmkey[MAX_KEY_SIZE];
 static int evmkey_len = MAX_KEY_SIZE;
 
 struct crypto_shash *hmac_tfm;
+struct crypto_shash *hash_tfm;
 
-static struct shash_desc *init_desc(void)
+static struct shash_desc *init_desc(const char type)
 {
 	int rc;
+	char *algo;
+	struct crypto_shash **tfm;
 	struct shash_desc *desc;
 
-	if (hmac_tfm == NULL) {
-		hmac_tfm = crypto_alloc_shash(evm_hmac, 0, CRYPTO_ALG_ASYNC);
-		if (IS_ERR(hmac_tfm)) {
+	if (type == EVM_XATTR_HMAC) {
+		tfm = &hmac_tfm;
+		algo = evm_hmac;
+	} else {
+		tfm = &hash_tfm;
+		algo = evm_hash;
+	}
+
+	if (*tfm == NULL) {
+		*tfm = crypto_alloc_shash(algo, 0, CRYPTO_ALG_ASYNC);
+		if (IS_ERR(*tfm)) {
 			pr_err("Can not allocate %s (reason: %ld)\n",
-			       evm_hmac, PTR_ERR(hmac_tfm));
-			rc = PTR_ERR(hmac_tfm);
-			hmac_tfm = NULL;
+			       algo, PTR_ERR(*tfm));
+			rc = PTR_ERR(*tfm);
+			*tfm = NULL;
 			return ERR_PTR(rc);
 		}
 	}
 
-	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(hmac_tfm),
+	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(*tfm),
 			GFP_KERNEL);
 	if (!desc)
 		return ERR_PTR(-ENOMEM);
 
-	desc->tfm = hmac_tfm;
+	desc->tfm = *tfm;
 	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	rc = crypto_shash_setkey(hmac_tfm, evmkey, evmkey_len);
-	if (rc)
-		goto out;
+	if (type == EVM_XATTR_HMAC) {
+		rc = crypto_shash_setkey(*tfm, evmkey, evmkey_len);
+		if (rc)
+			goto out;
+	}
+
 	rc = crypto_shash_init(desc);
 out:
 	if (rc) {
@@ -97,9 +111,11 @@ static void hmac_add_misc(struct shash_desc *desc, struct inode *inode,
  * the hmac using the requested xattr value. Don't alloc/free memory for
  * each xattr, but attempt to re-use the previously allocated memory.
  */
-int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
-		  const char *req_xattr_value, size_t req_xattr_value_len,
-		  char *digest)
+static int evm_calc_hmac_or_hash(struct dentry *dentry,
+				const char *req_xattr_name,
+				const char *req_xattr_value,
+				size_t req_xattr_value_len,
+				char type, char *digest)
 {
 	struct inode *inode = dentry->d_inode;
 	struct shash_desc *desc;
@@ -111,7 +127,7 @@ int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
 
 	if (!inode->i_op || !inode->i_op->getxattr)
 		return -EOPNOTSUPP;
-	desc = init_desc();
+	desc = init_desc(type);
 	if (IS_ERR(desc))
 		return PTR_ERR(desc);
 
@@ -145,6 +161,22 @@ out:
 	return error;
 }
 
+int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
+		  const char *req_xattr_value, size_t req_xattr_value_len,
+		  char *digest)
+{
+	return evm_calc_hmac_or_hash(dentry, req_xattr_name, req_xattr_value,
+				req_xattr_value_len, EVM_XATTR_HMAC, digest);
+}
+
+int evm_calc_hash(struct dentry *dentry, const char *req_xattr_name,
+		  const char *req_xattr_value, size_t req_xattr_value_len,
+		  char *digest)
+{
+	return evm_calc_hmac_or_hash(dentry, req_xattr_name, req_xattr_value,
+				req_xattr_value_len, IMA_XATTR_DIGEST, digest);
+}
+
 /*
  * Calculate the hmac and update security.evm xattr
  *
@@ -175,7 +207,7 @@ int evm_init_hmac(struct inode *inode, const struct xattr *lsm_xattr,
 {
 	struct shash_desc *desc;
 
-	desc = init_desc();
+	desc = init_desc(EVM_XATTR_HMAC);
 	if (IS_ERR(desc)) {
 		printk(KERN_INFO "init_desc failed\n");
 		return PTR_ERR(desc);
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 8b2eff9..d8ac109 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -18,6 +18,8 @@
 #include <linux/crypto.h>
 #include <linux/xattr.h>
 #include <linux/integrity.h>
+#include <linux/key-type.h>
+#include <linux/crypto/ksign.h>
 #include <linux/evm.h>
 #include <crypto/hash.h>
 #include "evm.h"
@@ -25,6 +27,7 @@
 int evm_initialized;
 
 char *evm_hmac = "hmac(sha1)";
+char *evm_hash = "sha1";
 
 char *evm_config_xattrnames[] = {
 #ifdef CONFIG_SECURITY_SELINUX
@@ -40,6 +43,8 @@ char *evm_config_xattrnames[] = {
 	NULL
 };
 
+static struct key *evm_keyring;
+
 static int evm_fixmode;
 static int __init evm_set_fixmode(char *str)
 {
@@ -49,6 +54,56 @@ static int __init evm_set_fixmode(char *str)
 }
 __setup("evm=", evm_set_fixmode);
 
+static int evm_find_protected_xattrs(struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	char **xattr;
+	int error;
+	int count = 0;
+
+	if (!inode->i_op || !inode->i_op->getxattr)
+		return -EOPNOTSUPP;
+
+	for (xattr = evm_config_xattrnames; *xattr != NULL; xattr++) {
+		error = inode->i_op->getxattr(dentry, *xattr, NULL, 0);
+		if (error < 0) {
+			if (error == -ENODATA)
+				continue;
+			return error;
+		}
+		count++;
+	}
+
+	return count;
+}
+
+#ifdef CONFIG_EVM_DIGSIG
+
+int evm_sign_verify(const char *sig, int siglen,
+		       const char *digest, int digestlen)
+{
+	if (!evm_keyring) {
+		evm_keyring = request_key(&key_type_keyring, "_evm", NULL);
+		if (IS_ERR(evm_keyring)) {
+			pr_err("no evm keyring: %ld\n", PTR_ERR(evm_keyring));
+			evm_keyring = NULL;
+			return PTR_ERR(evm_keyring);
+		}
+	}
+
+	return ksign_verify(evm_keyring, sig, siglen, digest, digestlen);
+}
+
+#else
+
+static inline int evm_sign_verify(const char *sig, int siglen,
+		       const char *digest, int digestlen)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* CONFIG_EVM_DIGSIG */
+
 /*
  * evm_verify_hmac - calculate and compare the HMAC with the EVM xattr
  *
@@ -68,32 +123,71 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 					     size_t xattr_value_len,
 					     struct integrity_iint_cache *iint)
 {
-	struct evm_ima_xattr_data xattr_data;
+	struct evm_ima_xattr_data *xattr_data = NULL;
+	struct evm_ima_xattr_data calc;
 	enum integrity_status evm_status = INTEGRITY_PASS;
-	int rc;
+	int rc, xattr_len;
 
 	if (iint && iint->evm_status == INTEGRITY_PASS)
 		return iint->evm_status;
 
 	/* if status is not PASS, try to check again - against -ENOMEM */
 
-	rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
-			   xattr_value_len, xattr_data.digest);
-	if (rc < 0) {
-		evm_status = (rc == -ENODATA)
-		    ? INTEGRITY_NOXATTRS : INTEGRITY_FAIL;
+	/* first need to know the sig type */
+	rc = vfs_getxattr_alloc(dentry, XATTR_NAME_EVM, (char **)&xattr_data, 0,
+				GFP_NOFS);
+	if (rc <= 0) {
+		if (rc == 0)
+			evm_status = INTEGRITY_FAIL; /* empty */
+		else if (rc == -ENODATA) {
+			rc = evm_find_protected_xattrs(dentry);
+			if (rc > 0)
+				evm_status = INTEGRITY_NOLABEL;
+			else if (rc == 0)
+				evm_status = INTEGRITY_NOXATTRS; /* new file */
+		}
 		goto out;
 	}
 
-	xattr_data.type = EVM_XATTR_HMAC;
-	rc = vfs_xattr_cmp(dentry, XATTR_NAME_EVM, (u8 *)&xattr_data,
-			   sizeof xattr_data, GFP_NOFS);
-	if (rc < 0)
-		evm_status = (rc == -ENODATA)
-		    ? INTEGRITY_NOLABEL : INTEGRITY_FAIL;
+	xattr_len = rc - 1;
+
+	/* check value type */
+	switch (xattr_data->type) {
+	case EVM_XATTR_HMAC:
+		rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
+				   xattr_value_len, calc.digest);
+		if (rc)
+			break;
+		rc = memcmp(xattr_data->digest, calc.digest,
+			    sizeof(calc.digest));
+		if (rc)
+			rc = -EINVAL;
+		break;
+	case EVM_IMA_XATTR_DIGSIG:
+		rc = evm_calc_hash(dentry, xattr_name, xattr_value,
+				xattr_value_len, calc.digest);
+		if (rc)
+			break;
+		rc = evm_sign_verify(xattr_data->digest, xattr_len,
+				     calc.digest, sizeof(calc.digest));
+		if (!rc) {
+			/* we probably want to replace rsa with hmac here */
+			evm_update_evmxattr(dentry, xattr_name, xattr_value,
+				   xattr_value_len);
+		}
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+
+	if (rc)
+		evm_status = (rc == -ENODATA) ?
+				INTEGRITY_NOXATTRS : INTEGRITY_FAIL;
 out:
 	if (iint)
 		iint->evm_status = evm_status;
+	kfree(xattr_data);
 	return evm_status;
 }
 
@@ -357,6 +451,8 @@ static int __init init_evm(void)
 		printk(KERN_INFO "EVM: Error registering secfs\n");
 		goto err;
 	}
+
+	return 0;
 err:
 	return error;
 }
@@ -364,8 +460,11 @@ err:
 static void __exit cleanup_evm(void)
 {
 	evm_cleanup_secfs();
+	key_put(evm_keyring);
 	if (hmac_tfm)
 		crypto_free_shash(hmac_tfm);
+	if (hash_tfm)
+		crypto_free_shash(hash_tfm);
 }
 
 /*
-- 
1.7.4.1

