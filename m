Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0FXSLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 14:11:37 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33992 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab0FXSLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 14:11:31 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 07/15] evm: inode post removexattr
Date: Thu, 24 Jun 2010 14:10:23 -0400
Message-Id: <1277403031-3080-8-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an EVM protected extended attribute is removed, update 'security.evm'.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 fs/xattr.c          |    5 ++++-
 include/linux/evm.h |    9 +++++++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index e1f6b8b..ad7cdc6 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -14,6 +14,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/security.h>
+#include <linux/evm.h>
 #include <linux/syscalls.h>
 #include <linux/module.h>
 #include <linux/fsnotify.h>
@@ -294,8 +295,10 @@ vfs_removexattr(struct dentry *dentry, const char *name)
 	error = inode->i_op->removexattr(dentry, name);
 	mutex_unlock(&inode->i_mutex);
 
-	if (!error)
+	if (!error) {
 		fsnotify_xattr(dentry);
+		evm_inode_post_removexattr(dentry, name);
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(vfs_removexattr);
diff --git a/include/linux/evm.h b/include/linux/evm.h
index 1a30beb..93edadd 100644
--- a/include/linux/evm.h
+++ b/include/linux/evm.h
@@ -22,6 +22,8 @@ extern void evm_inode_post_setxattr(struct dentry *dentry,
 				    const void *xattr_value,
 				    size_t xattr_value_len);
 extern int evm_inode_removexattr(struct dentry *dentry, const char *xattr_name);
+extern void evm_inode_post_removexattr(struct dentry *dentry,
+				       const char *xattr_name);
 #else
 static enum integrity_status evm_verifyxattr(struct dentry *dentry,
 					     char *xattr_name,
@@ -50,5 +52,12 @@ static inline int evm_inode_removexattr(struct dentry *dentry,
 {
 	return 0;
 }
+
+static inline void evm_inode_post_removexattr(struct dentry *dentry,
+					      const char *xattr_name)
+{
+	return;
+}
+
 #endif /* CONFIG_EVM_H */
 #endif /* LINUX_EVM_H */
-- 
1.6.6.1

