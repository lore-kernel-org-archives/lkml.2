Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab1F2Txd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 15:53:33 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50073 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab1F2Twz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 15:52:55 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v7 09/16] evm: add evm_inode_init_security to initialize new files
Date: Wed, 29 Jun 2011 15:50:31 -0400
Message-Id: <1309377038-4550-10-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize 'security.evm' for new files.

Changelog v7:
- renamed evm_inode_post_init_security to evm_inode_init_security
- moved struct xattr definition to earlier patch
- allocate xattr name
Changelog v6:
- Use 'struct evm_ima_xattr_data'

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/evm.h                 |   11 ++++++++++
 security/integrity/evm/evm.h        |    3 ++
 security/integrity/evm/evm_crypto.c |   20 ++++++++++++++++++
 security/integrity/evm/evm_main.c   |   38 +++++++++++++++++++++++++++++++++++
 4 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/include/linux/evm.h b/include/linux/evm.h
index 33a9247..7c10761 100644
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
+extern int evm_inode_init_security(struct inode *inode,
+				   const struct xattr *xattr_array,
+				   struct xattr *evm);
 #else
 #ifdef CONFIG_INTEGRITY
 static inline enum integrity_status evm_verifyxattr(struct dentry *dentry,
@@ -67,5 +71,12 @@ static inline void evm_inode_post_removexattr(struct dentry *dentry,
 	return;
 }
 
+static inline int evm_inode_init_security(struct inode *inode,
+					  const struct xattr *xattr_array,
+					  struct xattr *evm)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_EVM_H */
 #endif /* LINUX_EVM_H */
diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index 375dc3e..a45d0d6 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -12,6 +12,7 @@
  * File: evm.h
  *
  */
+#include <linux/xattr.h>
 #include <linux/security.h>
 #include "../integrity.h"
 
@@ -29,5 +30,7 @@ extern int evm_update_evmxattr(struct dentry *dentry,
 extern int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
 			 const char *req_xattr_value,
 			 size_t req_xattr_value_len, char *digest);
+extern int evm_init_hmac(struct inode *inode, const struct xattr *xattr,
+			 char *hmac_val);
 extern int evm_init_secfs(void);
 extern void evm_cleanup_secfs(void);
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index c631b99..c9902bd 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -157,6 +157,26 @@ int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
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
index 1746c36..2348635 100644
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
+ * evm_inode_init_security - initializes security.evm
+ */
+int evm_inode_init_security(struct inode *inode,
+				 const struct xattr *lsm_xattr,
+				 struct xattr *evm_xattr)
+{
+	struct evm_ima_xattr_data *xattr_data;
+	int rc;
+
+	if (!evm_initialized || !evm_protected_xattr(lsm_xattr->name))
+		return -EOPNOTSUPP;
+
+	xattr_data = kzalloc(sizeof(*xattr_data), GFP_NOFS);
+	if (!xattr_data)
+		return -ENOMEM;
+
+	xattr_data->type = EVM_XATTR_HMAC;
+	rc = evm_init_hmac(inode, lsm_xattr, xattr_data->digest);
+	if (rc < 0)
+		goto out;
+
+	evm_xattr->value = xattr_data;
+	evm_xattr->value_len = sizeof(*xattr_data);
+	evm_xattr->name = kstrdup(XATTR_EVM_SUFFIX, GFP_NOFS);
+	return 0;
+out:
+	kfree(xattr_data);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(evm_inode_init_security);
+
 static struct crypto_hash *tfm_hmac;	/* preload crypto alg */
 static int __init init_evm(void)
 {
-- 
1.7.3.4

