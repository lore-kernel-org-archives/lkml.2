Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab0DOXLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:11:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241Ab0DOXHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:07:06 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 24/35] VFS: Split inode_permission() and create path_permission()
Date: Thu, 15 Apr 2010 16:04:31 -0700
Message-Id: <1271372682-21225-25-git-send-email-vaurora@redhat.com>
In-Reply-To: <1271372682-21225-24-git-send-email-vaurora@redhat.com>
References: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
 <1271372682-21225-2-git-send-email-vaurora@redhat.com>
 <1271372682-21225-3-git-send-email-vaurora@redhat.com>
 <1271372682-21225-4-git-send-email-vaurora@redhat.com>
 <1271372682-21225-5-git-send-email-vaurora@redhat.com>
 <1271372682-21225-6-git-send-email-vaurora@redhat.com>
 <1271372682-21225-7-git-send-email-vaurora@redhat.com>
 <1271372682-21225-8-git-send-email-vaurora@redhat.com>
 <1271372682-21225-9-git-send-email-vaurora@redhat.com>
 <1271372682-21225-10-git-send-email-vaurora@redhat.com>
 <1271372682-21225-11-git-send-email-vaurora@redhat.com>
 <1271372682-21225-12-git-send-email-vaurora@redhat.com>
 <1271372682-21225-13-git-send-email-vaurora@redhat.com>
 <1271372682-21225-14-git-send-email-vaurora@redhat.com>
 <1271372682-21225-15-git-send-email-vaurora@redhat.com>
 <1271372682-21225-16-git-send-email-vaurora@redhat.com>
 <1271372682-21225-17-git-send-email-vaurora@redhat.com>
 <1271372682-21225-18-git-send-email-vaurora@redhat.com>
 <1271372682-21225-19-git-send-email-vaurora@redhat.com>
 <1271372682-21225-20-git-send-email-vaurora@redhat.com>
 <1271372682-21225-21-git-send-email-vaurora@redhat.com>
 <1271372682-21225-22-git-send-email-vaurora@redhat.com>
 <1271372682-21225-23-git-send-email-vaurora@redhat.com>
 <1271372682-21225-24-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split inode_permission() into inode and file-system-dependent parts.
Create path_permission() to check permission based on the path to the
inode.  This is for union mounts, in which an inode can be located on
a read-only lower layer file system but is still writable, since we
will copy it up to the writable top layer file system.  So in that
case, we want to ignore MS_RDONLY on the lower layer.  To make this
decision, we must know the path (vfsmount, dentry) of both the target
and its parent.
---
 fs/namei.c         |   92 ++++++++++++++++++++++++++++++++++++++++++++--------
 include/linux/fs.h |    1 +
 2 files changed, 79 insertions(+), 14 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 900df0f..24e0cb2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -241,29 +241,20 @@ int generic_permission(struct inode *inode, int mask,
 }
 
 /**
- * inode_permission  -  check for access rights to a given inode
+ * __inode_permission  -  check for access rights to a given inode
  * @inode:	inode to check permission on
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
  *
  * Used to check for read/write/execute permissions on an inode.
- * We use "fsuid" for this, letting us set arbitrary permissions
- * for filesystem access without changing the "normal" uids which
- * are used for other things.
+ *
+ * This does not check for a read-only file system.  You probably want
+ * inode_permission().
  */
-int inode_permission(struct inode *inode, int mask)
+static int __inode_permission(struct inode *inode, int mask)
 {
 	int retval;
 
 	if (mask & MAY_WRITE) {
-		umode_t mode = inode->i_mode;
-
-		/*
-		 * Nobody gets write access to a read-only fs.
-		 */
-		if (IS_RDONLY(inode) &&
-		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
-			return -EROFS;
-
 		/*
 		 * Nobody gets write access to an immutable file.
 		 */
@@ -288,6 +279,79 @@ int inode_permission(struct inode *inode, int mask)
 }
 
 /**
+ * sb_permission  -  check superblock-level permissions
+ * @sb: superblock of inode to check permission on
+ * @mask: right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ *
+ * Separate out file-system wide checks from inode-specific permission
+ * checks.  In particular, union mounts want to check the read-only
+ * status of the top-level file system, not the lower.
+ */
+int sb_permission(struct super_block *sb, struct inode *inode, int mask)
+{
+	if (mask & MAY_WRITE) {
+		umode_t mode = inode->i_mode;
+
+		/*
+		 * Nobody gets write access to a read-only fs.
+		 */
+		if ((sb->s_flags & MS_RDONLY) &&
+		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
+			return -EROFS;
+	}
+	return 0;
+}
+
+/**
+ * inode_permission  -  check for access rights to a given inode
+ * @inode:	inode to check permission on
+ * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ *
+ * Used to check for read/write/execute permissions on an inode.
+ * We use "fsuid" for this, letting us set arbitrary permissions
+ * for filesystem access without changing the "normal" uids which
+ * are used for other things.
+ */
+int inode_permission(struct inode *inode, int mask)
+{
+	int retval;
+
+	retval = sb_permission(inode->i_sb, inode, mask);
+	if (retval)
+		return retval;
+	return __inode_permission(inode, mask);
+}
+
+/**
+ * path_permission - check for inode access rights depending on path
+ * @path: path of inode to check
+ * @parent_path: path of inode's parent
+ * @mask: right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ *
+ * Like inode_permission, but used to check for permission when the
+ * file may potentially be copied up between union layers.
+ */
+
+int path_permission(struct path *path, struct path *parent_path, int mask)
+{
+	struct vfsmount *mnt;
+	int retval;
+
+	/* Catch some reversal of args */
+	BUG_ON(!S_ISDIR(parent_path->dentry->d_inode->i_mode));
+
+	if (IS_MNT_UNION(parent_path->mnt))
+		mnt = parent_path->mnt;
+	else
+		mnt = path->mnt;
+
+	retval = sb_permission(mnt->mnt_sb, path->dentry->d_inode, mask);
+	if (retval)
+		return retval;
+	return __inode_permission(path->dentry->d_inode, mask);
+}
+
+/**
  * file_permission  -  check for additional access rights to a given file
  * @file:	file to check access rights for
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4dae882..0b1c811 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2114,6 +2114,7 @@ extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
 extern int inode_permission(struct inode *, int);
+extern int path_permission(struct path *, struct path *, int);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
 
-- 
1.6.3.3

