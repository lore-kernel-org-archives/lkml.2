Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab1AKGn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 01:43:59 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:40635
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755438Ab1AKGnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 01:43:50 -0500
Date: Tue, 11 Jan 2011 06:45:09 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Bastian Blank <bastian@waldi.eu.org>
Subject: [PATCH 08/08] userns: check user namespace for task->file uid
 equivalence checks
Message-ID: <20110111064509.GI27515@mail.hallyn.com>
References: <20110111064342.GA27515@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111064342.GA27515@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cheat for now and say all files belong to init_user_ns.  Next
step will be to let superblocks belong to a user_ns, and derive
inode_userns(inode) from inode->i_sb->s_user_ns.  Finally we'll
introduce more flexible arrangements.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
---
 fs/inode.c         |   17 +++++++++++++++++
 fs/namei.c         |   20 +++++++++++++++-----
 include/linux/fs.h |    9 +++++++--
 3 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 4a924c7..ebb2b85 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -25,6 +25,7 @@
 #include <linux/async.h>
 #include <linux/posix_acl.h>
 #include <linux/ima.h>
+#include <linux/cred.h>
 
 /*
  * This is needed for the following functions:
@@ -1710,6 +1711,22 @@ void inode_init_owner(struct inode *inode, const struct inode *dir,
 }
 EXPORT_SYMBOL(inode_init_owner);
 
+/*
+ * return 1 if current either has CAP_FOWNER to the
+ * file, or owns the file.
+ */
+int is_owner_or_cap(struct inode *inode)
+{
+	struct user_namespace *ns = inode_userns(inode);
+
+	if (current_user_ns() == ns && current_fsuid() == inode->i_uid)
+		return 1;
+	if (ns_capable(ns, CAP_FOWNER))
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL(is_owner_or_cap);
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/vfs.h>
 
diff --git a/fs/namei.c b/fs/namei.c
index b020c45..d956ce3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -176,6 +176,9 @@ static int acl_permission_check(struct inode *inode, int mask,
 
 	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
 
+	if (current_user_ns() != inode_userns(inode))
+		goto other_perms;
+
 	if (current_fsuid() == inode->i_uid)
 		mode >>= 6;
 	else {
@@ -189,6 +192,7 @@ static int acl_permission_check(struct inode *inode, int mask,
 			mode >>= 3;
 	}
 
+other_perms:
 	/*
 	 * If the DACs are ok we don't need any capability check.
 	 */
@@ -225,7 +229,7 @@ int generic_permission(struct inode *inode, int mask,
 	 * Executable DACs are overridable if at least one exec bit is set.
 	 */
 	if (!(mask & MAY_EXEC) || execute_ok(inode))
-		if (capable(CAP_DAC_OVERRIDE))
+		if (ns_capable(inode_userns(inode), CAP_DAC_OVERRIDE))
 			return 0;
 
 	/*
@@ -233,7 +237,7 @@ int generic_permission(struct inode *inode, int mask,
 	 */
 	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
 	if (mask == MAY_READ || (S_ISDIR(inode->i_mode) && !(mask & MAY_WRITE)))
-		if (capable(CAP_DAC_READ_SEARCH))
+		if (ns_capable(inode_userns(inode), CAP_DAC_READ_SEARCH))
 			return 0;
 
 	return -EACCES;
@@ -463,6 +467,7 @@ force_reval_path(struct path *path, struct nameidata *nd)
 static int exec_permission(struct inode *inode)
 {
 	int ret;
+	struct user_namespace *ns = inode_userns(inode);
 
 	if (inode->i_op->permission) {
 		ret = inode->i_op->permission(inode, MAY_EXEC);
@@ -474,7 +479,7 @@ static int exec_permission(struct inode *inode)
 	if (!ret)
 		goto ok;
 
-	if (capable(CAP_DAC_OVERRIDE) || capable(CAP_DAC_READ_SEARCH))
+	if (ns_capable(ns, CAP_DAC_OVERRIDE) || ns_capable(ns, CAP_DAC_READ_SEARCH))
 		goto ok;
 
 	return ret;
@@ -1262,11 +1267,15 @@ static inline int check_sticky(struct inode *dir, struct inode *inode)
 
 	if (!(dir->i_mode & S_ISVTX))
 		return 0;
+	if (current_user_ns() != inode_userns(inode))
+		goto other_userns;
 	if (inode->i_uid == fsuid)
 		return 0;
 	if (dir->i_uid == fsuid)
 		return 0;
-	return !capable(CAP_FOWNER);
+
+other_userns:
+	return !ns_capable(inode_userns(inode), CAP_FOWNER);
 }
 
 /*
@@ -1954,7 +1963,8 @@ int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 	if (error)
 		return error;
 
-	if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
+	if ((S_ISCHR(mode) || S_ISBLK(mode)) &&
+	    !ns_capable(inode_userns(dir), CAP_MKNOD))
 		return -EPERM;
 
 	if (!dir->i_op->mknod)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 090f0ea..674c06a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1437,8 +1437,13 @@ enum {
 #define put_fs_excl() atomic_dec(&current->fs_excl)
 #define has_fs_excl() atomic_read(&current->fs_excl)
 
-#define is_owner_or_cap(inode)	\
-	((current_fsuid() == (inode)->i_uid) || capable(CAP_FOWNER))
+/*
+ * until VFS tracks user namespaces for inodes, just make all files
+ * belong to init_user_ns
+ */
+extern struct user_namespace init_user_ns;
+#define inode_userns(inode) (&init_user_ns)
+extern int is_owner_or_cap(struct inode *inode);
 
 /* not quite ready to be deprecated, but... */
 extern void lock_super(struct super_block *);
-- 
1.7.0.4

