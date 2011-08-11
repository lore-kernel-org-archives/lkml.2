Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1HKR2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:28:45 -0400
Received: from mga05.intel.com ([192.55.52.89]:42002 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751260Ab1HKR2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:28:43 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Aug 2011 13:28:43 EDT
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com
Subject: [RFC v1.1 3/5] evm: digital signature support
Date: Thu, 11 Aug 2011 20:20:06 +0300
Message-Id: <d6ca3779df5a812a1b838b0a707a994a341846ed.1313082284.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1313082284.git.dmitry.kasatkin@intel.com>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1313082284.git.dmitry.kasatkin@intel.com>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

When building an image, which has to be flashed to different devices,
an HMAC cannot be used to sign file metadata, as the HMAC key is different
on every device. File metadata can be protected using digital signature.
This patch enables RSA signature based integrity verification.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/evm/Kconfig      |   14 +++++++
 security/integrity/evm/evm.h        |   31 ++++++++++++++++
 security/integrity/evm/evm_crypto.c |   66 ++++++++++++++++++++++++++---------
 security/integrity/evm/evm_main.c   |   65 ++++++++++++++++++++++++++--------
 4 files changed, 144 insertions(+), 32 deletions(-)

diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
index 73f6540..92221b1 100644
--- a/security/integrity/evm/Kconfig
+++ b/security/integrity/evm/Kconfig
@@ -10,3 +10,17 @@ config EVM
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
index d320f51..6d297a1 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -12,14 +12,22 @@
  * File: evm.h
  *
  */
+
+#ifndef __INTEGRITY_EVM_H
+#define __INTEGRITY_EVM_H
+
 #include <linux/xattr.h>
 #include <linux/security.h>
+#include <linux/crypto/ksign.h>
+
 #include "../integrity.h"
 
 extern int evm_initialized;
 extern char *evm_hmac;
+extern char *evm_hash;
 
 extern struct crypto_shash *hmac_tfm;
+extern struct crypto_shash *hash_tfm;
 
 /* List of EVM protected security xattrs */
 extern char *evm_config_xattrnames[];
@@ -32,7 +40,30 @@ extern int evm_update_evmxattr(struct dentry *dentry,
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
+#ifdef CONFIG_EVM_DIGSIG
+
+static inline int evm_sign_verify(const char *sig, int siglen,
+		       const char *digest, int digestlen)
+{
+	return ksign_verify(sig, siglen, digest, digestlen);
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
index 8fc5b5d..a99c644 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -25,6 +25,7 @@
 int evm_initialized;
 
 char *evm_hmac = "hmac(sha1)";
+char *evm_hash = "sha1";
 
 char *evm_config_xattrnames[] = {
 #ifdef CONFIG_SECURITY_SELINUX
@@ -65,39 +66,71 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 					     size_t xattr_value_len,
 					     struct integrity_iint_cache *iint)
 {
-	struct evm_ima_xattr_data xattr_data;
+	struct evm_ima_xattr_data *xattr_data = NULL;
+	struct evm_ima_xattr_data calc;
 	enum integrity_status evm_status;
-	int rc;
+	int rc, xattr_len;
 
 	if (iint && iint->evm_status == INTEGRITY_PASS)
 		return iint->evm_status;
 
 	/* if status is not PASS, try to check again - against -ENOMEM */
 
-	rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
-			   xattr_value_len, xattr_data.digest);
-	if (rc < 0)
-		goto err_out;
+	/* first need to know the sig type */
+	rc = vfs_getxattr_alloc(dentry, XATTR_NAME_EVM, (char **)&xattr_data, 0,
+				GFP_NOFS);
+	if (rc <= 0) {
+		if (rc == 0)
+			rc = -EINVAL;
+		goto out;
+	}
 
-	xattr_data.type = EVM_XATTR_HMAC;
-	rc = vfs_xattr_cmp(dentry, XATTR_NAME_EVM, (u8 *)&xattr_data,
-			   sizeof xattr_data, GFP_NOFS);
-	if (rc < 0)
-		goto err_out;
-	evm_status = INTEGRITY_PASS;
-	goto out;
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
 
-err_out:
+out:
 	switch (rc) {
+	case 0:
+		evm_status = INTEGRITY_PASS;
+		break;
 	case -ENODATA:		/* file not labelled */
 		evm_status = INTEGRITY_NOLABEL;
 		break;
 	default:
 		evm_status = INTEGRITY_FAIL;
 	}
-out:
 	if (iint)
 		iint->evm_status = evm_status;
+	kfree(xattr_data);
 	return evm_status;
 }
 
@@ -363,6 +396,8 @@ static void __exit cleanup_evm(void)
 	evm_cleanup_secfs();
 	if (hmac_tfm)
 		crypto_free_shash(hmac_tfm);
+	if (hash_tfm)
+		crypto_free_shash(hash_tfm);
 }
 
 /*
-- 
1.7.4.1

