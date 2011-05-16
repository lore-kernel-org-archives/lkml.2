Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab1EPOrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:47:20 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46775 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab1EPOrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:47:16 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v5 11/21] evm: crypto hash replaced by shash
Date: Mon, 16 May 2011 10:45:05 -0400
Message-Id: <1305557115-15652-12-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

Using shash is more efficient, because the algorithm is allocated only
once. Only the descriptor to store the hash state needs to be allocated
for every operation.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/evm/evm.h        |    2 +
 security/integrity/evm/evm_crypto.c |   94 ++++++++++++++++++++---------------
 security/integrity/evm/evm_main.c   |    6 +-
 3 files changed, 58 insertions(+), 44 deletions(-)

diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index 65ab9db..08b0a84 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -20,6 +20,8 @@ extern int evm_initialized;
 extern char *evm_hmac;
 extern int evm_hmac_size;
 
+extern struct crypto_shash *hmac_tfm;
+
 /* List of EVM protected security xattrs */
 extern char *evm_config_xattrnames[];
 
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index e029a37..4b2d040 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -17,7 +17,7 @@
 #include <linux/crypto.h>
 #include <linux/xattr.h>
 #include <keys/encrypted-type.h>
-#include <linux/scatterlist.h>
+#include <crypto/hash.h>
 #include "evm.h"
 
 #define EVMKEY "evm-key"
@@ -25,23 +25,41 @@
 static unsigned char evmkey[MAX_KEY_SIZE];
 static int evmkey_len = MAX_KEY_SIZE;
 
-static int init_desc(struct hash_desc *desc)
+struct crypto_shash *hmac_tfm;
+
+static struct shash_desc *init_desc(void)
 {
 	int rc;
+	struct shash_desc *desc;
+
+	if (hmac_tfm == NULL) {
+		hmac_tfm = crypto_alloc_shash(evm_hmac, 0, CRYPTO_ALG_ASYNC);
+		if (IS_ERR(hmac_tfm)) {
+			pr_err("Can not allocate %s (reason: %ld)\n",
+			       evm_hmac, PTR_ERR(hmac_tfm));
+			rc = PTR_ERR(hmac_tfm);
+			hmac_tfm = NULL;
+			return ERR_PTR(rc);
+		}
+	}
+
+	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(hmac_tfm),
+			GFP_KERNEL);
+	if (!desc)
+		return ERR_PTR(-ENOMEM);
+
+	desc->tfm = hmac_tfm;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	crypto_shash_setkey(hmac_tfm, evmkey, evmkey_len);
 
-	desc->tfm = crypto_alloc_hash(evm_hmac, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(desc->tfm)) {
-		pr_info("Can not allocate %s (reason: %ld)\n",
-			evm_hmac, PTR_ERR(desc->tfm));
-		rc = PTR_ERR(desc->tfm);
-		return rc;
+	rc = crypto_shash_init(desc);
+	if (rc) {
+		kfree(desc);
+		return ERR_PTR(rc);
 	}
-	desc->flags = 0;
-	crypto_hash_setkey(desc->tfm, evmkey, evmkey_len);
-	rc = crypto_hash_init(desc);
-	if (rc)
-		crypto_free_hash(desc->tfm);
-	return rc;
+
+	return desc;
 }
 
 /* Protect against 'cutting & pasting' security.evm xattr, include inode
@@ -50,7 +68,7 @@ static int init_desc(struct hash_desc *desc)
  * (Additional directory/file metadata needs to be added for more complete
  * protection.)
  */
-static void hmac_add_misc(struct hash_desc *desc, struct inode *inode,
+static void hmac_add_misc(struct shash_desc *desc, struct inode *inode,
 			  char *digest)
 {
 	struct h_misc {
@@ -60,7 +78,6 @@ static void hmac_add_misc(struct hash_desc *desc, struct inode *inode,
 		gid_t gid;
 		umode_t mode;
 	} hmac_misc;
-	struct scatterlist sg[1];
 
 	memset(&hmac_misc, 0, sizeof hmac_misc);
 	hmac_misc.ino = inode->i_ino;
@@ -68,9 +85,8 @@ static void hmac_add_misc(struct hash_desc *desc, struct inode *inode,
 	hmac_misc.uid = inode->i_uid;
 	hmac_misc.gid = inode->i_gid;
 	hmac_misc.mode = inode->i_mode;
-	sg_init_one(sg, &hmac_misc, sizeof hmac_misc);
-	crypto_hash_update(desc, sg, sizeof hmac_misc);
-	crypto_hash_final(desc, digest);
+	crypto_shash_update(desc, (const u8 *)&hmac_misc, sizeof hmac_misc);
+	crypto_shash_final(desc, digest);
 }
 
 /*
@@ -85,8 +101,7 @@ int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
 		  char *digest)
 {
 	struct inode *inode = dentry->d_inode;
-	struct hash_desc desc;
-	struct scatterlist sg[1];
+	struct shash_desc *desc;
 	char **xattrname;
 	size_t xattr_size = 0;
 	char *xattr_value = NULL;
@@ -95,17 +110,17 @@ int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
 
 	if (!inode->i_op || !inode->i_op->getxattr)
 		return -EOPNOTSUPP;
-	error = init_desc(&desc);
-	if (error)
-		return error;
+	desc = init_desc();
+	if (IS_ERR(desc))
+		return PTR_ERR(desc);
 
 	error = -ENODATA;
 	for (xattrname = evm_config_xattrnames; *xattrname != NULL; xattrname++) {
 		if ((req_xattr_name && req_xattr_value)
 		    && !strcmp(*xattrname, req_xattr_name)) {
 			error = 0;
-			sg_init_one(sg, req_xattr_value, req_xattr_value_len);
-			crypto_hash_update(&desc, sg, req_xattr_value_len);
+			crypto_shash_update(desc, (const u8 *)req_xattr_value,
+					     req_xattr_value_len);
 			continue;
 		}
 		size = vfs_getxattr_alloc(dentry, *xattrname,
@@ -119,13 +134,13 @@ int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
 
 		error = 0;
 		xattr_size = size;
-		sg_init_one(sg, xattr_value, xattr_size);
-		crypto_hash_update(&desc, sg, xattr_size);
+		crypto_shash_update(desc, (const u8 *)xattr_value, xattr_size);
 	}
-	hmac_add_misc(&desc, inode, digest);
-	kfree(xattr_value);
+	hmac_add_misc(desc, inode, digest);
+
 out:
-	crypto_free_hash(desc.tfm);
+	kfree(xattr_value);
+	kfree(desc);
 	return error;
 }
 
@@ -156,20 +171,17 @@ int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
 int evm_init_hmac(struct inode *inode, const struct xattr *lsm_xattr,
 		  char *hmac_val)
 {
-	struct hash_desc desc;
-	struct scatterlist sg[1];
-	int error;
+	struct shash_desc *desc;
 
-	error = init_desc(&desc);
-	if (error != 0) {
+	desc = init_desc();
+	if (IS_ERR(desc)) {
 		printk(KERN_INFO "init_desc failed\n");
-		return error;
+		return PTR_ERR(desc);
 	}
 
-	sg_init_one(sg, lsm_xattr->value, lsm_xattr->value_len);
-	crypto_hash_update(&desc, sg, lsm_xattr->value_len);
-	hmac_add_misc(&desc, inode, hmac_val);
-	crypto_free_hash(desc.tfm);
+	crypto_shash_update(desc, lsm_xattr->value, lsm_xattr->value_len);
+	hmac_add_misc(desc, inode, hmac_val);
+	kfree(desc);
 	return 0;
 }
 
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 98941ab..af1bc6a 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -19,6 +19,7 @@
 #include <linux/xattr.h>
 #include <linux/integrity.h>
 #include <linux/evm.h>
+#include <crypto/hash.h>
 #include "evm.h"
 
 int evm_initialized;
@@ -283,12 +284,10 @@ out:
 }
 EXPORT_SYMBOL_GPL(evm_inode_post_init_security);
 
-static struct crypto_hash *tfm_hmac;	/* preload crypto alg */
 static int __init init_evm(void)
 {
 	int error;
 
-	tfm_hmac = crypto_alloc_hash(evm_hmac, 0, CRYPTO_ALG_ASYNC);
 	error = evm_init_secfs();
 	if (error < 0) {
 		printk(KERN_INFO "EVM: Error registering secfs\n");
@@ -301,7 +300,8 @@ err:
 static void __exit cleanup_evm(void)
 {
 	evm_cleanup_secfs();
-	crypto_free_hash(tfm_hmac);
+	if (hmac_tfm)
+		crypto_free_shash(hmac_tfm);
 }
 
 /*
-- 
1.7.3.4

