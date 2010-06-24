Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab0FXSL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 14:11:28 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40537 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab0FXSLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 14:11:24 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 06/15] security: imbed evm calls in security hooks
Date: Thu, 24 Jun 2010 14:10:22 -0400
Message-Id: <1277403031-3080-7-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
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
---
 include/linux/evm.h |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++
 security/security.c |   16 +++++++++++++-
 2 files changed, 68 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/evm.h

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
index 36a0de3..c373c5f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -18,6 +18,7 @@
 #include <linux/security.h>
 #include <linux/integrity.h>
 #include <linux/ima.h>
+#include <linux/evm.h>
 
 /* Boot-time LSM user choice */
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
@@ -548,9 +549,14 @@ int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
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
@@ -559,6 +565,7 @@ void security_inode_post_setxattr(struct dentry *dentry, const char *name,
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return;
 	security_ops->inode_post_setxattr(dentry, name, value, size, flags);
+	evm_inode_post_setxattr(dentry, name, value, size);
 }
 
 int security_inode_getxattr(struct dentry *dentry, const char *name)
@@ -577,9 +584,14 @@ int security_inode_listxattr(struct dentry *dentry)
 
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

