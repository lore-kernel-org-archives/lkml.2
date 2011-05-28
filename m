Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1E1P1e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:27:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:3692 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab1E1P0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:26:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,285,1304319600"; 
   d="scan'208";a="8935160"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, chris.mason@oracle.com,
        josef@redhat.com, agruen@linbit.com,
        "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH 1/4] Cache xattr security drop check for write v2
Date: Sat, 28 May 2011 08:25:51 -0700
Message-Id: <1306596354-18453-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Some recent benchmarking on btrfs showed that a major scaling bottleneck
on large systems on btrfs is currently the xattr lookup on every write.

Why xattr lookup on every write I hear you ask?

write wants to drop suid and security related xattrs that could set o
capabilities for executables.  To do that it currently looks up
security.capability on EVERY write (even for non executables) to decide
whether to drop it or not.

In btrfs this causes an additional tree walk, hitting some per file system
locks and quite bad scalability. In a simple read workload on a 8S
system I saw over 90% CPU time in spinlocks related to that.

Chris Mason tells me this is also a problem in ext4, where it hits
the global mbcache lock.

This patch adds a simple per inode to avoid this problem.  We only
do the lookup once per file and then if there is no xattr cache
the decision. All xattr changes clear the flag.

I also used the same flag to avoid the suid check, although
that one is pretty cheap.

A file system can also set this flag when it creates the inode,
if it has a cheap way to do so.  This is done for some common file systems
in followon patches.

With this patch a major part of the lock contention disappears
for btrfs. Some testing on smaller systems didn't show significant
performance changes, but at least it helps the larger systems
and is generally more efficient.

v2: Rename is_sgid. add file system helper.
Cc: chris.mason@oracle.com
Cc: josef@redhat.com
Cc: viro@zeniv.linux.org.uk
Cc: agruen@linbit.com
Cc: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/attr.c          |    7 +++++++
 fs/xattr.c         |    7 +++++--
 include/linux/fs.h |   13 +++++++++++++
 mm/filemap.c       |   14 ++++++++++++--
 4 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 91dbe2a..caf2aa5 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -175,6 +175,13 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 			return -EPERM;
 	}
 
+	if ((ia_valid & ATTR_MODE)) {
+		mode_t amode = attr->ia_mode;
+		/* Flag setting protected by i_mutex */
+		if (is_sxid(amode))
+			inode->i_flags &= ~S_NOSEC;
+	}
+
 	now = current_fs_time(inode->i_sb);
 
 	attr->ia_ctime = now;
diff --git a/fs/xattr.c b/fs/xattr.c
index f1ef949..1f0cb40 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -87,7 +87,11 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
 {
 	struct inode *inode = dentry->d_inode;
 	int error = -EOPNOTSUPP;
+	int issec = !strncmp(name, XATTR_SECURITY_PREFIX,
+				   XATTR_SECURITY_PREFIX_LEN);
 
+	if (issec)
+		inode->i_flags &= ~S_NOSEC;
 	if (inode->i_op->setxattr) {
 		error = inode->i_op->setxattr(dentry, name, value, size, flags);
 		if (!error) {
@@ -95,8 +99,7 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
 			security_inode_post_setxattr(dentry, name, value,
 						     size, flags);
 		}
-	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
-				XATTR_SECURITY_PREFIX_LEN)) {
+	} else if (issec) {
 		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
 		error = security_inode_setsecurity(inode, suffix, value,
 						   size, flags);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index cdf9495..1bca00b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -236,6 +236,7 @@ struct inodes_stat_t {
 #define S_PRIVATE	512	/* Inode is fs-internal */
 #define S_IMA		1024	/* Inode has an associated IMA struct */
 #define S_AUTOMOUNT	2048	/* Automount/referral quasi-directory */
+#define S_NOSEC		4096	/* no suid or xattr security attributes */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -272,6 +273,7 @@ struct inodes_stat_t {
 #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
 #define IS_IMA(inode)		((inode)->i_flags & S_IMA)
 #define IS_AUTOMOUNT(inode)	((inode)->i_flags & S_AUTOMOUNT)
+#define IS_NOSEC(inode)		((inode)->i_flags & S_NOSEC)
 
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
@@ -2578,5 +2580,16 @@ int __init get_filesystem_list(char *buf);
 #define OPEN_FMODE(flag) ((__force fmode_t)(((flag + 1) & O_ACCMODE) | \
 					    (flag & __FMODE_NONOTIFY)))
 
+static inline int is_sxid(mode_t mode)
+{
+	return (mode & S_ISUID) || ((mode & S_ISGID) && (mode & S_IXGRP));
+}
+
+static inline void inode_has_no_xattr(struct inode *inode)
+{
+	if (!is_sxid(inode->i_mode))
+		inode->i_flags |= S_NOSEC;
+}
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
diff --git a/mm/filemap.c b/mm/filemap.c
index c641edf..5893a88 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1943,16 +1943,26 @@ static int __remove_suid(struct dentry *dentry, int kill)
 int file_remove_suid(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
-	int killsuid = should_remove_suid(dentry);
-	int killpriv = security_inode_need_killpriv(dentry);
+	struct inode *inode = dentry->d_inode;
+	int killsuid;
+	int killpriv;
 	int error = 0;
 
+	/* Fast path for nothing security related */
+	if (IS_NOSEC(inode))
+		return 0;
+
+	killsuid = should_remove_suid(dentry);
+	killpriv = security_inode_need_killpriv(dentry);
+
 	if (killpriv < 0)
 		return killpriv;
 	if (killpriv)
 		error = security_inode_killpriv(dentry);
 	if (!error && killsuid)
 		error = __remove_suid(dentry, killsuid);
+	if (!error)
+		inode->i_flags |= S_NOSEC;
 
 	return error;
 }
-- 
1.7.4.4

