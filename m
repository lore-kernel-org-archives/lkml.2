Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab0DUVv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:51:26 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:44796 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab0DUVvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:51:23 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 09/14] evm: inode_post_init
Date: Wed, 21 Apr 2010 17:49:49 -0400
Message-Id: <1271886594-3719-10-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize 'security.evm' for new files. Reduce number of arguments
by defining 'struct xattr'.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>

diff --git a/include/linux/evm.h b/include/linux/evm.h
index 8626263..3602bd1 100644
--- a/include/linux/evm.h
+++ b/include/linux/evm.h
@@ -9,6 +9,7 @@
 #define _LINUX_EVM_H
 
 #include <linux/integrity.h>
+#include <linux/xattr.h>
 
 #ifdef CONFIG_EVM
 extern enum integrity_status evm_verifyxattr(struct dentry *dentry,
@@ -25,6 +26,9 @@ extern void evm_inode_post_setxattr(struct dentry *dentry,
 extern int evm_inode_removexattr(struct dentry *dentry, const char *xattr_name);
 extern void evm_inode_post_removexattr(struct dentry *dentry,
 				       const char *xattr_name);
+extern int evm_inode_post_init_security(struct inode *inode,
+					const struct xattr *new,
+					struct xattr *evm);
 #else
 static enum integrity_status evm_verifyxattr(struct dentry *dentry,
 					     char *xattr_name,
@@ -65,5 +69,12 @@ static inline void evm_inode_post_removexattr(struct dentry *dentry,
 	return;
 }
 
+static inline int evm_inode_post_init_security(struct inode *inode,
+					       const struct xattr *new,
+					       struct xattr *evm)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_EVM_H */
 #endif /* LINUX_EVM_H */
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index d1afa51..e90377e 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -60,6 +60,12 @@ struct xattr_handler {
 		   size_t size, int flags, int handler_flags);
 };
 
+struct xattr {
+	char *name;
+	void *value;
+	size_t value_len;
+};
+
 ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
 ssize_t vfs_getxattr(struct dentry *, const char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index 0b6f7b2..a4b6907 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -12,6 +12,7 @@
  * File: evm.h
  *
  */
+#include <linux/xattr.h>
 #include <linux/security.h>
 #include "../integrity.h"
 
@@ -31,5 +32,7 @@ extern int evm_update_evmxattr(struct dentry *dentry,
 extern int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
 			 const char *req_xattr_value,
 			 size_t req_xattr_value_len, char *digest);
+extern int evm_init_hmac(struct inode *inode, struct xattr *xattr,
+			 char *hmac_val);
 extern int evm_init_secfs(void);
 extern void evm_cleanup_secfs(void);
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 4f1be71..5fe322d 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -150,6 +150,25 @@ int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
 	return rc;
 }
 
+int evm_init_hmac(struct inode *inode, struct xattr *lsm_xattr, char *hmac_val)
+{
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	int error;
+
+	error = init_desc(&desc);
+	if (error != 0) {
+		printk(KERN_INFO "init_desc failed\n");
+		return error;
+	}
+
+	sg_init_one(sg, lsm_xattr->value, lsm_xattr->value_len);
+	crypto_hash_update(&desc, sg, lsm_xattr->value_len);
+	hmac_add_misc(&desc, inode, hmac_val);
+	crypto_free_hash(desc.tfm);
+	return 0;
+}
+
 /*
  * Get the key from the TPM for the SHA1-HMAC
  */
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 59dc148..acc5176 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -96,6 +96,12 @@ static int evm_protected_xattr(const char *req_xattr_name)
 			found = 1;
 			break;
 		}
+		if (strncmp(req_xattr_name,
+			    *xattrname + XATTR_SECURITY_PREFIX_LEN,
+			    strlen(req_xattr_name)) == 0) {
+			found = 1;
+			break;
+		}
 	}
 	return found;
 }
@@ -256,6 +262,36 @@ void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
 	return;
 }
 
+/*
+ * evm_inode_post_init_security - initializes security.evm
+ */
+int evm_inode_post_init_security(struct inode *inode, struct xattr *lsm_xattr,
+				 struct xattr *evm_xattr)
+{
+	u8 *hmac_val;
+	int rc;
+
+	if (!evm_initialized || !evm_protected_xattr(lsm_xattr->name))
+		return -EOPNOTSUPP;
+
+	hmac_val = kzalloc(MAX_DIGEST_SIZE, GFP_NOFS);
+	if (!hmac_val)
+		return -ENOMEM;
+
+	rc = evm_init_hmac(inode, lsm_xattr, hmac_val);
+	if (rc < 0)
+		goto out;
+
+	evm_xattr->value = hmac_val;
+	evm_xattr->value_len = evm_hmac_size;
+	evm_xattr->name = XATTR_EVM_SUFFIX;
+	return 0;
+out:
+	kfree(hmac_val);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(evm_inode_post_init_security);
+
 static struct crypto_hash *tfm_hmac;	/* preload crypto alg */
 static int __init init_evm(void)
 {
-- 
1.6.6.1

