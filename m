Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab0DUVvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:51:20 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58921 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab0DUVvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:51:16 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 06/14] security: imbed evm calls in security hooks
Date: Wed, 21 Apr 2010 17:49:46 -0400
Message-Id: <1271886594-3719-7-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imbed the evm calls evm_inode_setxattr(), evm_inode_post_setxattr(),
evm_inode_removexattr() in the security hooks.  evm_inode_setxattr()
protects security.evm xattr.  evm_inode_post_setxattr() and
evm_inode_removexattr() updates the hmac associated with an inode.

(Assumes an LSM module protects the setting/removing of xattr.)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>

diff --git a/include/linux/evm.h b/include/linux/evm.h
new file mode 100644
index 0000000..1a30beb
--- /dev/null
+++ b/include/linux/evm.h
@@ -0,0 +1,54 @@
+/*
+ * evm.h
+ *
+ * Copyright (c) 2009 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ */
+
+#ifndef _LINUX_EVM_H
+#define _LINUX_EVM_H
+
+#include <linux/integrity.h>
+
+#ifdef CONFIG_EVM
+extern enum integrity_status evm_verifyxattr(struct dentry *dentry,
+					     char *xattr_name,
+					     char *xattr_value,
+					     size_t xattr_value_len);
+extern int evm_inode_setxattr(struct dentry *dentry, const char *name,
+			      const void *value, size_t size);
+extern void evm_inode_post_setxattr(struct dentry *dentry,
+				    const char *xattr_name,
+				    const void *xattr_value,
+				    size_t xattr_value_len);
+extern int evm_inode_removexattr(struct dentry *dentry, const char *xattr_name);
+#else
+static enum integrity_status evm_verifyxattr(struct dentry *dentry,
+					     char *xattr_name,
+					     char *xattr_value,
+					     size_t xattr_value_len)
+{
+	return INTEGRITY_UNKNOWN;
+}
+
+static inline int evm_inode_setxattr(struct dentry *dentry, const char *name,
+				     const void *value, size_t size)
+{
+	return 0;
+}
+
+static inline void evm_inode_post_setxattr(struct dentry *dentry,
+					   const char *xattr_name,
+					   const void *xattr_value,
+					   size_t xattr_value_len)
+{
+	return;
+}
+
+static inline int evm_inode_removexattr(struct dentry *dentry,
+					const char *xattr_name)
+{
+	return 0;
+}
+#endif /* CONFIG_EVM_H */
+#endif /* LINUX_EVM_H */
diff --git a/security/security.c b/security/security.c
index e42a78e..6b1e50e 100644
--- a/security/security.c
+++ b/security/security.c
@@ -18,6 +18,7 @@
 #include <linux/security.h>
 #include <linux/integrity.h>
 #include <linux/ima.h>
+#include <linux/evm.h>
 
 /* Boot-time LSM user choice */
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
@@ -549,9 +550,14 @@ int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 int security_inode_setxattr(struct dentry *dentry, const char *name,
 			    const void *value, size_t size, int flags)
 {
+	int ret;
+
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_setxattr(dentry, name, value, size, flags);
+	ret = security_ops->inode_setxattr(dentry, name, value, size, flags);
+	if (ret)
+		return ret;
+	return evm_inode_setxattr(dentry, name, value, size);
 }
 
 void security_inode_post_setxattr(struct dentry *dentry, const char *name,
@@ -560,6 +566,7 @@ void security_inode_post_setxattr(struct dentry *dentry, const char *name,
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return;
 	security_ops->inode_post_setxattr(dentry, name, value, size, flags);
+	evm_inode_post_setxattr(dentry, name, value, size);
 }
 
 int security_inode_getxattr(struct dentry *dentry, const char *name)
@@ -578,9 +585,14 @@ int security_inode_listxattr(struct dentry *dentry)
 
 int security_inode_removexattr(struct dentry *dentry, const char *name)
 {
+	int ret;
+
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_removexattr(dentry, name);
+	ret = security_ops->inode_removexattr(dentry, name);
+	if (ret)
+		return ret;
+	return evm_inode_removexattr(dentry, name);
 }
 
 int security_inode_need_killpriv(struct dentry *dentry)
-- 
1.6.6.1

