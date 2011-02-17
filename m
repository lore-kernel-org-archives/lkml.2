Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab1BQSCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:02:37 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36073 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab1BQSCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:32 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 08/14] fs/9p: Add support for marking inode attribute invalid
Date: Thu, 17 Feb 2011 23:31:59 +0530
Message-Id: <1297965725-25603-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cached mode some of the file system operation result
in updating inode attributes (ctime). Add support for
marking inode attribute invalid in such cases so that
we fetch the updated inode attribute on dentry revalidation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/v9fs.h           |    4 ++++
 fs/9p/v9fs_vfs.h       |   10 ++++++++++
 fs/9p/vfs_dentry.c     |   34 ++++++++++++++++++++++++++++++++++
 fs/9p/vfs_inode.c      |   16 ++++++++++++++++
 fs/9p/vfs_inode_dotl.c |   15 +++++++++++++++
 5 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index aed2a25..64acf72 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -112,6 +112,9 @@ struct v9fs_session_info {
 	struct p9_fid *root_fid; /* Used for file system sync */
 };
 
+/* cache_validity flags */
+#define V9FS_INO_INVALID_ATTR 0x01
+
 struct v9fs_inode {
 #ifdef CONFIG_9P_FSCACHE
 	spinlock_t fscache_lock;
@@ -120,6 +123,7 @@ struct v9fs_inode {
 #endif
 	struct p9_fid *writeback_fid;
 	struct inode vfs_inode;
+	unsigned int cache_validity;
 };
 
 static inline struct v9fs_inode *V9FS_I(const struct inode *inode)
diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index db3c00e..3ac13b4 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -70,4 +70,14 @@ int v9fs_vfs_setattr_dotl(struct dentry *, struct iattr *);
 int v9fs_file_fsync_dotl(struct file *filp, int datasync);
 ssize_t v9fs_file_write_internal(struct inode *, struct p9_fid *, char *,
 				 size_t, loff_t *);
+int v9fs_refresh_inode(struct p9_fid *fid, struct inode *inode);
+int v9fs_refresh_inode_dotl(struct p9_fid *fid, struct inode *inode);
+static inline void v9fs_invalidate_inode_attr(struct inode *inode)
+{
+	struct v9fs_inode *v9inode;
+	v9inode = V9FS_I(inode);
+	v9inode->cache_validity |= V9FS_INO_INVALID_ATTR;
+	return;
+}
+
 #define P9_LOCK_TIMEOUT (30*HZ)
diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
index a4ae4be..b6a3b9f 100644
--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -100,7 +100,41 @@ static void v9fs_dentry_release(struct dentry *dentry)
 	}
 }
 
+static int v9fs_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
+{
+	struct p9_fid *fid;
+	struct inode *inode;
+	struct v9fs_inode *v9inode;
+
+	if (nd->flags & LOOKUP_RCU)
+		return -ECHILD;
+
+	inode = dentry->d_inode;
+	if (!inode)
+		goto out_valid;
+
+	v9inode = V9FS_I(inode);
+	if (v9inode->cache_validity & V9FS_INO_INVALID_ATTR) {
+		int retval;
+		struct v9fs_session_info *v9ses;
+		fid = v9fs_fid_lookup(dentry);
+		if (IS_ERR(fid))
+			return PTR_ERR(fid);
+
+		v9ses = v9fs_inode2v9ses(inode);
+		if (v9fs_proto_dotl(v9ses))
+			retval = v9fs_refresh_inode_dotl(fid, inode);
+		else
+			retval = v9fs_refresh_inode(fid, inode);
+		if (retval <= 0)
+			return retval;
+	}
+out_valid:
+	return 1;
+}
+
 const struct dentry_operations v9fs_cached_dentry_operations = {
+	.d_revalidate = v9fs_lookup_revalidate,
 	.d_delete = v9fs_cached_dentry_delete,
 	.d_release = v9fs_dentry_release,
 };
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index d72cabe..21d36c7 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -220,6 +220,7 @@ struct inode *v9fs_alloc_inode(struct super_block *sb)
 	spin_lock_init(&v9inode->fscache_lock);
 #endif
 	v9inode->writeback_fid = NULL;
+	v9inode->cache_validity = 0;
 	return &v9inode->vfs_inode;
 }
 
@@ -1021,6 +1022,7 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 	char tag_name[14];
 	unsigned int i_nlink;
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
+	struct v9fs_inode *v9inode = V9FS_I(inode);
 
 	inode->i_nlink = 1;
 
@@ -1080,6 +1082,7 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 
 	/* not real number of blocks, but 512 byte ones ... */
 	inode->i_blocks = (i_size_read(inode) + 512 - 1) >> 9;
+	v9inode->cache_validity &= ~V9FS_INO_INVALID_ATTR;
 }
 
 /**
@@ -1334,6 +1337,19 @@ v9fs_vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
 	return retval;
 }
 
+int v9fs_refresh_inode(struct p9_fid *fid, struct inode *inode)
+{
+	struct p9_wstat *st;
+	st = p9_client_stat(fid);
+	if (IS_ERR(st))
+		return PTR_ERR(st);
+
+	spin_lock(&inode->i_lock);
+	v9fs_stat2inode(st, inode, inode->i_sb);
+	spin_unlock(&inode->i_lock);
+	return 0;
+}
+
 static const struct inode_operations v9fs_dir_inode_operations_dotu = {
 	.create = v9fs_vfs_create,
 	.lookup = v9fs_vfs_lookup,
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index b0fa56a..1cab2b5 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -495,6 +495,7 @@ int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 void
 v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode)
 {
+	struct v9fs_inode *v9inode = V9FS_I(inode);
 
 	if ((stat->st_result_mask & P9_STATS_BASIC) == P9_STATS_BASIC) {
 		inode->i_atime.tv_sec = stat->st_atime_sec;
@@ -553,6 +554,7 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode)
 	/* Currently we don't support P9_STATS_BTIME and P9_STATS_DATA_VERSION
 	 * because the inode structure does not have fields for them.
 	 */
+	v9inode->cache_validity &= ~V9FS_INO_INVALID_ATTR;
 }
 
 static int
@@ -833,6 +835,19 @@ ndset:
 	return NULL;
 }
 
+int v9fs_refresh_inode_dotl(struct p9_fid *fid, struct inode *inode)
+{
+	struct p9_stat_dotl *st;
+	st = p9_client_getattr_dotl(fid, P9_STATS_ALL);
+	if (IS_ERR(st))
+		return PTR_ERR(st);
+
+	spin_lock(&inode->i_lock);
+	v9fs_stat2inode_dotl(st, inode);
+	spin_unlock(&inode->i_lock);
+	return 0;
+}
+
 const struct inode_operations v9fs_dir_inode_operations_dotl = {
 	.create = v9fs_vfs_create_dotl,
 	.lookup = v9fs_vfs_lookup,
-- 
1.7.1

