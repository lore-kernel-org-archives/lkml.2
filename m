Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab1GYSHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:07:21 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:41918 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1GYSHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:07:15 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH 2/2] fs/9p: Don't update file type when updating file attributes
Date: Mon, 25 Jul 2011 23:36:33 +0530
Message-Id: <1311617193-11682-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311617193-11682-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1311617193-11682-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should only update attributes that we can change on stat2inode.
Also do file type initialization in v9fs_init_inode.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/v9fs_vfs.h       |    4 +-
 fs/9p/vfs_inode.c      |   91 ++++++++++++++++++++++++++---------------------
 fs/9p/vfs_inode_dotl.c |   23 ++++++++----
 fs/9p/vfs_super.c      |    2 +-
 4 files changed, 68 insertions(+), 52 deletions(-)

diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index 4014160..bd86d22 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -54,9 +54,9 @@ extern struct kmem_cache *v9fs_inode_cache;
 
 struct inode *v9fs_alloc_inode(struct super_block *sb);
 void v9fs_destroy_inode(struct inode *inode);
-struct inode *v9fs_get_inode(struct super_block *sb, int mode);
+struct inode *v9fs_get_inode(struct super_block *sb, int mode, dev_t);
 int v9fs_init_inode(struct v9fs_session_info *v9ses,
-		    struct inode *inode, int mode);
+		    struct inode *inode, int mode, dev_t);
 void v9fs_evict_inode(struct inode *inode);
 ino_t v9fs_qid2ino(struct p9_qid *qid);
 void v9fs_stat2inode(struct p9_wstat *, struct inode *, struct super_block *);
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 6d2278f..dc645a3 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -95,15 +95,18 @@ static int unixmode2p9mode(struct v9fs_session_info *v9ses, int mode)
 /**
  * p9mode2unixmode- convert plan9 mode bits to unix mode bits
  * @v9ses: v9fs session information
- * @mode: mode to convert
+ * @stat: p9_wstat from which mode need to be derived
+ * @rdev: major number, minor number in case of device files.
  *
  */
-
-static int p9mode2unixmode(struct v9fs_session_info *v9ses, int mode)
+static int p9mode2unixmode(struct v9fs_session_info *v9ses,
+			   struct p9_wstat *stat, dev_t *rdev)
 {
 	int res;
+	int mode = stat->mode;
 
-	res = mode & 0777;
+	res = mode & S_IALLUGO;
+	*rdev = 0;
 
 	if ((mode & P9_DMDIR) == P9_DMDIR)
 		res |= S_IFDIR;
@@ -116,9 +119,26 @@ static int p9mode2unixmode(struct v9fs_session_info *v9ses, int mode)
 		 && (v9ses->nodev == 0))
 		res |= S_IFIFO;
 	else if ((mode & P9_DMDEVICE) && (v9fs_proto_dotu(v9ses))
-		 && (v9ses->nodev == 0))
-		res |= S_IFBLK;
-	else
+		 && (v9ses->nodev == 0)) {
+		char type = 0, ext[32];
+		int major = -1, minor = -1;
+
+		strncpy(ext, stat->extension, sizeof(ext));
+		sscanf(ext, "%c %u %u", &type, &major, &minor);
+		switch (type) {
+		case 'c':
+			res |= S_IFCHR;
+			break;
+		case 'b':
+			res |= S_IFBLK;
+			break;
+		default:
+			P9_DPRINTK(P9_DEBUG_ERROR,
+				"Unknown special type %c %s\n", type,
+				stat->extension);
+		};
+		*rdev = MKDEV(major, minor);
+	} else
 		res |= S_IFREG;
 
 	if (v9fs_proto_dotu(v9ses)) {
@@ -131,7 +151,6 @@ static int p9mode2unixmode(struct v9fs_session_info *v9ses, int mode)
 		if ((mode & P9_DMSETVTX) == P9_DMSETVTX)
 			res |= S_ISVTX;
 	}
-
 	return res;
 }
 
@@ -242,13 +261,13 @@ void v9fs_destroy_inode(struct inode *inode)
 }
 
 int v9fs_init_inode(struct v9fs_session_info *v9ses,
-		    struct inode *inode, int mode)
+		    struct inode *inode, int mode, dev_t rdev)
 {
 	int err = 0;
 
 	inode_init_owner(inode, NULL, mode);
 	inode->i_blocks = 0;
-	inode->i_rdev = 0;
+	inode->i_rdev = rdev;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	inode->i_mapping->a_ops = &v9fs_addr_operations;
 
@@ -335,7 +354,7 @@ error:
  *
  */
 
-struct inode *v9fs_get_inode(struct super_block *sb, int mode)
+struct inode *v9fs_get_inode(struct super_block *sb, int mode, dev_t rdev)
 {
 	int err;
 	struct inode *inode;
@@ -348,7 +367,7 @@ struct inode *v9fs_get_inode(struct super_block *sb, int mode)
 		P9_EPRINTK(KERN_WARNING, "Problem allocating inode\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	err = v9fs_init_inode(v9ses, inode, mode);
+	err = v9fs_init_inode(v9ses, inode, mode, rdev);
 	if (err) {
 		iput(inode);
 		return ERR_PTR(err);
@@ -435,11 +454,12 @@ void v9fs_evict_inode(struct inode *inode)
 static int v9fs_test_inode(struct inode *inode, void *data)
 {
 	int umode;
+	dev_t rdev;
 	struct v9fs_inode *v9inode = V9FS_I(inode);
 	struct p9_wstat *st = (struct p9_wstat *)data;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
 
-	umode = p9mode2unixmode(v9ses, st->mode);
+	umode = p9mode2unixmode(v9ses, st, &rdev);
 	/* don't match inode of different type */
 	if ((inode->i_mode & S_IFMT) != (umode & S_IFMT))
 		return 0;
@@ -473,6 +493,7 @@ static struct inode *v9fs_qid_iget(struct super_block *sb,
 				   struct p9_wstat *st,
 				   int new)
 {
+	dev_t rdev;
 	int retval, umode;
 	unsigned long i_ino;
 	struct inode *inode;
@@ -496,8 +517,8 @@ static struct inode *v9fs_qid_iget(struct super_block *sb,
 	 * later.
 	 */
 	inode->i_ino = i_ino;
-	umode = p9mode2unixmode(v9ses, st->mode);
-	retval = v9fs_init_inode(v9ses, inode, umode);
+	umode = p9mode2unixmode(v9ses, st, &rdev);
+	retval = v9fs_init_inode(v9ses, inode, umode, rdev);
 	if (retval)
 		goto error;
 
@@ -1000,7 +1021,7 @@ v9fs_vfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		return PTR_ERR(st);
 
 	v9fs_stat2inode(st, dentry->d_inode, dentry->d_inode->i_sb);
-		generic_fillattr(dentry->d_inode, stat);
+	generic_fillattr(dentry->d_inode, stat);
 
 	p9stat_free(st);
 	kfree(st);
@@ -1084,6 +1105,7 @@ void
 v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 	struct super_block *sb)
 {
+	mode_t mode;
 	char ext[32];
 	char tag_name[14];
 	unsigned int i_nlink;
@@ -1119,31 +1141,9 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 				inode->i_nlink = i_nlink;
 		}
 	}
-	inode->i_mode = p9mode2unixmode(v9ses, stat->mode);
-	if ((S_ISBLK(inode->i_mode)) || (S_ISCHR(inode->i_mode))) {
-		char type = 0;
-		int major = -1;
-		int minor = -1;
-
-		strncpy(ext, stat->extension, sizeof(ext));
-		sscanf(ext, "%c %u %u", &type, &major, &minor);
-		switch (type) {
-		case 'c':
-			inode->i_mode &= ~S_IFBLK;
-			inode->i_mode |= S_IFCHR;
-			break;
-		case 'b':
-			break;
-		default:
-			P9_DPRINTK(P9_DEBUG_ERROR,
-				"Unknown special type %c %s\n", type,
-				stat->extension);
-		};
-		inode->i_rdev = MKDEV(major, minor);
-		init_special_inode(inode, inode->i_mode, inode->i_rdev);
-	} else
-		inode->i_rdev = 0;
-
+	mode = stat->mode & S_IALLUGO;
+	mode |= inode->i_mode & ~S_IALLUGO;
+	inode->i_mode = mode;
 	i_size_write(inode, stat->length);
 
 	/* not real number of blocks, but 512 byte ones ... */
@@ -1409,6 +1409,8 @@ v9fs_vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
 
 int v9fs_refresh_inode(struct p9_fid *fid, struct inode *inode)
 {
+	int umode;
+	dev_t rdev;
 	loff_t i_size;
 	struct p9_wstat *st;
 	struct v9fs_session_info *v9ses;
@@ -1417,6 +1419,12 @@ int v9fs_refresh_inode(struct p9_fid *fid, struct inode *inode)
 	st = p9_client_stat(fid);
 	if (IS_ERR(st))
 		return PTR_ERR(st);
+	/*
+	 * Don't update inode if the file type is different
+	 */
+	umode = p9mode2unixmode(v9ses, st, &rdev);
+	if ((inode->i_mode & S_IFMT) != (umode & S_IFMT))
+		goto out;
 
 	spin_lock(&inode->i_lock);
 	/*
@@ -1428,6 +1436,7 @@ int v9fs_refresh_inode(struct p9_fid *fid, struct inode *inode)
 	if (v9ses->cache)
 		inode->i_size = i_size;
 	spin_unlock(&inode->i_lock);
+out:
 	p9stat_free(st);
 	kfree(st);
 	return 0;
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 0a17235..818bf6f 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -153,7 +153,8 @@ static struct inode *v9fs_qid_iget_dotl(struct super_block *sb,
 	 * later.
 	 */
 	inode->i_ino = i_ino;
-	retval = v9fs_init_inode(v9ses, inode, st->st_mode);
+	retval = v9fs_init_inode(v9ses, inode,
+				 st->st_mode, new_decode_dev(st->st_rdev));
 	if (retval)
 		goto error;
 
@@ -414,7 +415,7 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 		 * inode with stat. We need to get an inode
 		 * so that we can set the acl with dentry
 		 */
-		inode = v9fs_get_inode(dir->i_sb, mode);
+		inode = v9fs_get_inode(dir->i_sb, mode, 0);
 		if (IS_ERR(inode)) {
 			err = PTR_ERR(inode);
 			goto error;
@@ -540,6 +541,7 @@ int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 void
 v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode)
 {
+	mode_t mode;
 	struct v9fs_inode *v9inode = V9FS_I(inode);
 
 	if ((stat->st_result_mask & P9_STATS_BASIC) == P9_STATS_BASIC) {
@@ -552,11 +554,10 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode)
 		inode->i_uid = stat->st_uid;
 		inode->i_gid = stat->st_gid;
 		inode->i_nlink = stat->st_nlink;
-		inode->i_mode = stat->st_mode;
-		inode->i_rdev = new_decode_dev(stat->st_rdev);
 
-		if ((S_ISBLK(inode->i_mode)) || (S_ISCHR(inode->i_mode)))
-			init_special_inode(inode, inode->i_mode, inode->i_rdev);
+		mode = stat->st_mode & S_IALLUGO;
+		mode |= inode->i_mode & ~S_IALLUGO;
+		inode->i_mode = mode;
 
 		i_size_write(inode, stat->st_size);
 		inode->i_blocks = stat->st_blocks;
@@ -664,7 +665,7 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 		fid = NULL;
 	} else {
 		/* Not in cached mode. No need to populate inode with stat */
-		inode = v9fs_get_inode(dir->i_sb, S_IFLNK);
+		inode = v9fs_get_inode(dir->i_sb, S_IFLNK, 0);
 		if (IS_ERR(inode)) {
 			err = PTR_ERR(inode);
 			goto error;
@@ -820,7 +821,7 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
 		 * Not in cached mode. No need to populate inode with stat.
 		 * socket syscall returns a fd, so we need instantiate
 		 */
-		inode = v9fs_get_inode(dir->i_sb, mode);
+		inode = v9fs_get_inode(dir->i_sb, mode, rdev);
 		if (IS_ERR(inode)) {
 			err = PTR_ERR(inode);
 			goto error;
@@ -886,6 +887,11 @@ int v9fs_refresh_inode_dotl(struct p9_fid *fid, struct inode *inode)
 	st = p9_client_getattr_dotl(fid, P9_STATS_ALL);
 	if (IS_ERR(st))
 		return PTR_ERR(st);
+	/*
+	 * Don't update inode if the file type is different
+	 */
+	if ((inode->i_mode & S_IFMT) != (st->st_mode & S_IFMT))
+		goto out;
 
 	spin_lock(&inode->i_lock);
 	/*
@@ -897,6 +903,7 @@ int v9fs_refresh_inode_dotl(struct p9_fid *fid, struct inode *inode)
 	if (v9ses->cache)
 		inode->i_size = i_size;
 	spin_unlock(&inode->i_lock);
+out:
 	kfree(st);
 	return 0;
 }
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index feef6cd..c70251d 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -149,7 +149,7 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 	else
 		sb->s_d_op = &v9fs_dentry_operations;
 
-	inode = v9fs_get_inode(sb, S_IFDIR | mode);
+	inode = v9fs_get_inode(sb, S_IFDIR | mode, 0);
 	if (IS_ERR(inode)) {
 		retval = PTR_ERR(inode);
 		goto release_sb;
-- 
1.7.4.1

