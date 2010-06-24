Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0FXSMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 14:12:19 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51468 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab0FXSMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 14:12:14 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 14/15] ima: add ima_inode_setxattr and ima_inode_removexattr
Date: Thu, 24 Jun 2010 14:10:30 -0400
Message-Id: <1277403031-3080-15-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on xattr_permission comments, the restriction to modify
'security' xattr is left up to the underlying fs or lsm. Ensure
that not just anyone can modify or remove 'security.ima'.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/ima.h               |   13 +++++++++++++
 security/integrity/ima/ima_main.c |   26 ++++++++++++++++++++++++++
 security/security.c               |    6 ++++++
 3 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/include/linux/ima.h b/include/linux/ima.h
index ce82e29..3307420 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -20,6 +20,9 @@ extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
 extern void ima_counts_get(struct file *file);
 extern void ima_inode_post_setattr(struct dentry *dentry);
+extern int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
+		       const void *xattr_value, size_t xattr_value_len);
+extern int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name);
 
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
@@ -52,5 +55,15 @@ static inline void ima_inode_post_setattr(struct dentry *dentry)
 	return;
 }
 
+int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
+		       const void *xattr_value, size_t xattr_value_len)
+{
+	return 0;
+}
+
+int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name)
+{
+	return 0;
+}
 #endif /* CONFIG_IMA_H */
 #endif /* _LINUX_IMA_H */
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 9aae59e..62a7cf6 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -371,6 +371,32 @@ void ima_inode_post_setattr(struct dentry *dentry)
 	return;
 }
 
+/*
+ * ima_protect_xattr - protect 'security.ima'
+ *
+ * Ensure that not just anyone can modify or remove 'security.ima'.
+ */
+int ima_protect_xattr(struct dentry *dentry, const char *xattr_name,
+		      const void *xattr_value, size_t xattr_value_len)
+{
+	if ((strcmp(xattr_name, XATTR_NAME_IMA) == 0)
+	    && !capable(CAP_MAC_ADMIN))
+		return -EPERM;
+	return 0;
+}
+
+int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
+		       const void *xattr_value, size_t xattr_value_len)
+{
+	return ima_protect_xattr(dentry, xattr_name, xattr_value,
+				 xattr_value_len);
+}
+
+int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name)
+{
+	return ima_protect_xattr(dentry, xattr_name, NULL, 0);
+}
+
 static int __init init_ima(void)
 {
 	int error;
diff --git a/security/security.c b/security/security.c
index c373c5f..53c6285 100644
--- a/security/security.c
+++ b/security/security.c
@@ -556,6 +556,9 @@ int security_inode_setxattr(struct dentry *dentry, const char *name,
 	ret = security_ops->inode_setxattr(dentry, name, value, size, flags);
 	if (ret)
 		return ret;
+	ret = ima_inode_setxattr(dentry, name, value, size);
+	if (ret)
+		return ret;
 	return evm_inode_setxattr(dentry, name, value, size);
 }
 
@@ -591,6 +594,9 @@ int security_inode_removexattr(struct dentry *dentry, const char *name)
 	ret = security_ops->inode_removexattr(dentry, name);
 	if (ret)
 		return ret;
+	ret = ima_inode_removexattr(dentry, name);
+	if (ret)
+		return ret;
 	return evm_inode_removexattr(dentry, name);
 }
 
-- 
1.6.6.1

