Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab1EPOqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:46:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46660 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab1EPOqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:46:51 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v5 09/21] evm: evm_inode_post_init
Date: Mon, 16 May 2011 10:45:03 -0400
Message-Id: <1305557115-15652-10-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize 'security.evm' for new files. Reduce number of arguments
by defining 'struct xattr'.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 include/linux/evm.h                 |   11 ++++++++++
 include/linux/xattr.h               |    6 +++++
 security/integrity/evm/evm.h        |    3 ++
 security/integrity/evm/evm_crypto.c |   20 ++++++++++++++++++
 security/integrity/evm/evm_main.c   |   38 +++++++++++++++++++++++++++++++++++
 5 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/include/linux/evm.h b/include/linux/evm.h
index 33a9247..c3bc089 100644
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
 #ifdef CONFIG_INTEGRITY
 static inline enum integrity_status evm_verifyxattr(struct dentry *dentry,
@@ -67,5 +71,12 @@ static inline void evm_inode_post_removexattr(struct dentry *dentry,
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
index 61a9a349..32d934e 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -70,6 +70,12 @@ struct xattr_handler {
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
index f2bbe43..65ab9db 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -12,6 +12,7 @@
  * File: evm.h
  *
  */
+#include <linux/xattr.h>
 #include <linux/security.h>
 #include "../integrity.h"
 
@@ -30,5 +31,7 @@ extern int evm_update_evmxattr(struct dentry *dentry,
 extern int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
 			 const char *req_xattr_value,
 			 size_t req_xattr_value_len, char *digest);
+extern int evm_init_hmac(struct inode *inode, const struct xattr *xattr,
+			 char *hmac_val);
 extern int evm_init_secfs(void);
 extern void evm_cleanup_secfs(void);
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 644df7e..e029a37 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -153,6 +153,26 @@ int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
 	return rc;
 }
 
+int evm_init_hmac(struct inode *inode, const struct xattr *lsm_xattr,
+		  char *hmac_val)
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
index e89ceb1..98941ab 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -98,6 +98,12 @@ static int evm_protected_xattr(const char *req_xattr_name)
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
@@ -245,6 +251,38 @@ void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
 	return;
 }
 
+/*
+ * evm_inode_post_init_security - initializes security.evm
+ */
+int evm_inode_post_init_security(struct inode *inode,
+				 const struct xattr *lsm_xattr,
+				 struct xattr *evm_xattr)
+{
+	u8 *hmac_val;
+	int rc;
+
+	if (!evm_initialized || !evm_protected_xattr(lsm_xattr->name))
+		return -EOPNOTSUPP;
+
+	hmac_val = kzalloc(evm_hmac_size + 1, GFP_NOFS);
+	if (!hmac_val)
+		return -ENOMEM;
+
+	hmac_val[0] = EVM_XATTR_HMAC;
+	rc = evm_init_hmac(inode, lsm_xattr, hmac_val + 1);
+	if (rc < 0)
+		goto out;
+
+	evm_xattr->value = hmac_val;
+	evm_xattr->value_len = evm_hmac_size + 1;
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
1.7.3.4

