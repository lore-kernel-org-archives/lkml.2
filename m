Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab1EPOqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:46:37 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35752 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab1EPOqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:46:35 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v5 06/21] security: imbed evm calls in security hooks
Date: Mon, 16 May 2011 10:45:00 -0400
Message-Id: <1305557115-15652-7-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imbed the evm calls evm_inode_setxattr(), evm_inode_post_setxattr(),
evm_inode_removexattr() in the security hooks.  evm_inode_setxattr()
protects security.evm xattr.  evm_inode_post_setxattr() and
evm_inode_removexattr() updates the hmac associated with an inode.

(Assumes an LSM module protects the setting/removing of xattr.)

Changelog:
  - Don't define evm_verifyxattr(), unless CONFIG_INTEGRITY is enabled.
  - xattr_name is a 'const', value is 'void *'

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 include/linux/evm.h               |   56 +++++++++++++++++++++++++++++++++++++
 security/integrity/evm/evm_main.c |    1 +
 security/security.c               |   16 +++++++++-
 3 files changed, 71 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/evm.h

diff --git a/include/linux/evm.h b/include/linux/evm.h
new file mode 100644
index 0000000..8b4e9e3
--- /dev/null
+++ b/include/linux/evm.h
@@ -0,0 +1,56 @@
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
+					     const char *xattr_name,
+					     void *xattr_value,
+					     size_t xattr_value_len);
+extern int evm_inode_setxattr(struct dentry *dentry, const char *name,
+			      const void *value, size_t size);
+extern void evm_inode_post_setxattr(struct dentry *dentry,
+				    const char *xattr_name,
+				    const void *xattr_value,
+				    size_t xattr_value_len);
+extern int evm_inode_removexattr(struct dentry *dentry, const char *xattr_name);
+#else
+#ifdef CONFIG_INTEGRITY
+static inline enum integrity_status evm_verifyxattr(struct dentry *dentry,
+						    const char *xattr_name,
+						    void *xattr_value,
+						    size_t xattr_value_len)
+{
+	return INTEGRITY_UNKNOWN;
+}
+#endif
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
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 42c792f..e89ceb1 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -18,6 +18,7 @@
 #include <linux/crypto.h>
 #include <linux/xattr.h>
 #include <linux/integrity.h>
+#include <linux/evm.h>
 #include "evm.h"
 
 int evm_initialized;
diff --git a/security/security.c b/security/security.c
index d0c6576..635bcc9 100644
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
1.7.3.4

