Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab0K0KbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:31:18 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34786 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948Ab0K0K0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIphhRQ
Message-Id: <8cbc64c4c8ab6be0ae5a7fa00ebabc7a8d60641a.1290852960.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:45:10 +1100
Subject: [PATCH 40/46] fs: provide rcu-walk aware permission i_ops
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/namei.c         |  131 ++++++++++++++++++++++++++++++++++++++++------------
 include/linux/fs.h |    6 ++
 2 files changed, 107 insertions(+), 30 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d8f7ece..7fa6119 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -169,8 +169,36 @@ EXPORT_SYMBOL(putname);
 /*
  * This does basic POSIX ACL permission checking
  */
-static inline int __acl_permission_check(struct inode *inode, int mask,
-		int (*check_acl)(struct inode *inode, int mask), int rcu)
+static int acl_permission_check_rcu(struct inode *inode, int mask, unsigned int flags,
+		int (*check_acl_rcu)(struct inode *inode, int mask, unsigned int flags))
+{
+	umode_t			mode = inode->i_mode;
+
+	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
+
+	if (current_fsuid() == inode->i_uid)
+		mode >>= 6;
+	else {
+		if (IS_POSIXACL(inode) && (mode & S_IRWXG) && check_acl_rcu) {
+			int error = check_acl_rcu(inode, mask, flags);
+			if (error != -EAGAIN)
+				return error;
+		}
+
+		if (in_group_p(inode->i_gid))
+			mode >>= 3;
+	}
+
+	/*
+	 * If the DACs are ok we don't need any capability check.
+	 */
+	if ((mask & ~mode) == 0)
+		return 0;
+	return -EACCES;
+}
+
+static int acl_permission_check(struct inode *inode, int mask, unsigned int flags,
+		int (*check_acl)(struct inode *inode, int mask))
 {
 	umode_t			mode = inode->i_mode;
 
@@ -180,7 +208,7 @@ static inline int __acl_permission_check(struct inode *inode, int mask,
 		mode >>= 6;
 	else {
 		if (IS_POSIXACL(inode) && (mode & S_IRWXG) && check_acl) {
-			if (rcu) {
+			if (flags) {
 				return -ECHILD;
 			} else {
 				int error = check_acl(inode, mask);
@@ -201,10 +229,52 @@ static inline int __acl_permission_check(struct inode *inode, int mask,
 	return -EACCES;
 }
 
-static inline int acl_permission_check(struct inode *inode, int mask,
-		int (*check_acl)(struct inode *inode, int mask))
+/**
+ * generic_permission_rcu  -  check for access rights on a Posix-like filesystem
+ * @inode:	inode to check access rights for
+ * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ * @check_acl_rcu: optional callback to check for Posix ACLs
+ * @flags	IPERM_FLAG_ flags.
+ *
+ * Used to check for read/write/execute permissions on a file.
+ * We use "fsuid" for this, letting us set arbitrary permissions
+ * for filesystem access without changing the "normal" uids which
+ * are used for other things.
+ *
+ * generic_permission_rcu must be rcu-walk aware. It should return
+ * -ECHILD in case an rcu-walk request cannot be satisfied (eg.
+ * requires blocking or too much thought!). It would then be called
+ * again in ref-walk mode.
+ */
+int generic_permission_rcu(struct inode *inode, int mask, unsigned int flags,
+	int (*check_acl_rcu)(struct inode *inode, int mask, unsigned int flags))
 {
-	return __acl_permission_check(inode, mask, check_acl, 0);
+	int ret;
+
+	/*
+	 * Do the basic POSIX ACL permission checks.
+	 */
+	ret = acl_permission_check_rcu(inode, mask, flags, check_acl_rcu);
+	if (ret != -EACCES)
+		return ret;
+
+	/*
+	 * Read/write DACs are always overridable.
+	 * Executable DACs are overridable if at least one exec bit is set.
+	 */
+	if (!(mask & MAY_EXEC) || execute_ok(inode))
+		if (capable(CAP_DAC_OVERRIDE))
+			return 0;
+
+	/*
+	 * Searching includes executable on directories, else just read.
+	 */
+	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
+	if (mask == MAY_READ || (S_ISDIR(inode->i_mode) && !(mask & MAY_WRITE)))
+		if (capable(CAP_DAC_READ_SEARCH))
+			return 0;
+
+	return -EACCES;
 }
 
 /**
@@ -226,7 +296,7 @@ int generic_permission(struct inode *inode, int mask,
 	/*
 	 * Do the basic POSIX ACL permission checks.
 	 */
-	ret = acl_permission_check(inode, mask, check_acl);
+	ret = acl_permission_check(inode, mask, 0, check_acl);
 	if (ret != -EACCES)
 		return ret;
 
@@ -282,8 +352,14 @@ int inode_permission(struct inode *inode, int mask)
 
 	if (inode->i_op->permission)
 		retval = inode->i_op->permission(inode, mask);
+	else if (inode->i_op->permission_rcu)
+		retval = inode->i_op->permission_rcu(inode, mask, 0);
+	else if (inode->i_op->check_acl_rcu)
+		retval = generic_permission_rcu(inode, mask, 0,
+				inode->i_op->check_acl_rcu);
 	else
-		retval = generic_permission(inode, mask, inode->i_op->check_acl);
+		retval = generic_permission(inode, mask,
+				inode->i_op->check_acl);
 
 	if (retval)
 		return retval;
@@ -622,22 +698,26 @@ force_reval_path(struct path *path, struct nameidata *nd)
  * short-cut DAC fails, then call ->permission() to do more
  * complete permission check.
  */
-static inline int __exec_permission(struct inode *inode, int rcu)
+static inline int exec_permission(struct inode *inode, unsigned int flags)
 {
 	int ret;
 
-	if (inode->i_op->permission) {
-		if (rcu)
+	if (inode->i_op->permission_rcu) {
+		ret = inode->i_op->permission_rcu(inode, MAY_EXEC, flags);
+	} else if (inode->i_op->permission) {
+		if (flags)
 			return -ECHILD;
 		ret = inode->i_op->permission(inode, MAY_EXEC);
-		if (!ret)
-			goto ok;
-		return ret;
+	} else if (inode->i_op->check_acl_rcu) {
+		ret = acl_permission_check_rcu(inode, MAY_EXEC, flags,
+				inode->i_op->check_acl_rcu);
+	} else {
+		ret = acl_permission_check(inode, MAY_EXEC, flags,
+				inode->i_op->check_acl);
 	}
-	ret = __acl_permission_check(inode, MAY_EXEC, inode->i_op->check_acl, rcu);
-	if (!ret)
+	if (likely(!ret))
 		goto ok;
-	if (rcu && ret == -ECHILD)
+	if (ret == -ECHILD)
 		return ret;
 
 	if (capable(CAP_DAC_OVERRIDE) || capable(CAP_DAC_READ_SEARCH))
@@ -648,16 +728,6 @@ ok:
 	return security_inode_permission(inode, MAY_EXEC); /* XXX: ok for RCU? */
 }
 
-static int exec_permission(struct inode *inode)
-{
-	return __exec_permission(inode, 0);
-}
-
-static int exec_permission_rcu(struct inode *inode)
-{
-	return __exec_permission(inode, 1);
-}
-
 static __always_inline void set_root(struct nameidata *nd)
 {
 	if (!nd->root.mnt)
@@ -1126,7 +1196,7 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 
 		nd->flags |= LOOKUP_CONTINUE;
 		if (nd->flags & LOOKUP_RCU) {
-			err = exec_permission_rcu(nd->inode);
+			err = exec_permission(nd->inode, IPERM_FLAG_RCU);
 			if (err == -ECHILD) {
 				if (nameidata_drop_rcu(nd))
 					return -ECHILD;
@@ -1134,7 +1204,7 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 			}
 		} else {
 exec_again:
-			err = exec_permission(nd->inode);
+			err = exec_permission(nd->inode, 0);
 		}
  		if (err)
 			break;
@@ -1567,7 +1637,7 @@ static struct dentry *__lookup_hash(struct qstr *name,
 	struct dentry *dentry;
 	int err;
 
-	err = exec_permission(inode);
+	err = exec_permission(inode, 0);
 	if (err)
 		return ERR_PTR(err);
 
@@ -3352,6 +3422,7 @@ EXPORT_SYMBOL(vfs_follow_link);
 EXPORT_SYMBOL(vfs_link);
 EXPORT_SYMBOL(vfs_mkdir);
 EXPORT_SYMBOL(vfs_mknod);
+EXPORT_SYMBOL(generic_permission_rcu);
 EXPORT_SYMBOL(generic_permission);
 EXPORT_SYMBOL(vfs_readlink);
 EXPORT_SYMBOL(vfs_rename);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 07e8a50..490eedd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1549,11 +1549,15 @@ struct file_operations {
 	int (*setlease)(struct file *, long, struct file_lock **);
 };
 
+#define IPERM_FLAG_RCU	0x0001
+
 struct inode_operations {
 	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameidata *);
 	void * (*follow_link) (struct dentry *, struct nameidata *);
 	int (*permission) (struct inode *, int);
+	int (*permission_rcu) (struct inode *, int, unsigned int);
 	int (*check_acl)(struct inode *, int);
+	int (*check_acl_rcu)(struct inode *, int, unsigned int);
 
 	int (*readlink) (struct dentry *, char __user *,int);
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
@@ -2164,6 +2168,8 @@ extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
 extern int inode_permission(struct inode *, int);
+extern int generic_permission_rcu(struct inode *, int, unsigned int,
+		int (*check_acl_rcu)(struct inode *, int, unsigned int));
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
 
-- 
1.7.1

