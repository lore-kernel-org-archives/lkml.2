Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab0LRCDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 21:03:34 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60804 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757010Ab0LRCCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 21:02:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQHAH+jC015LdJm/2dsb2JhbACXH40TdL44hUoEhSCFYYUg
Message-Id: <20101218015117.759480620@kernel.dk>
User-Agent: quilt/0.48-1
Date: Sat, 18 Dec 2010 12:46:42 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 8/8] fs: add i_op->sync_inode
References: <20101218014634.943276411@kernel.dk>
Content-Disposition: inline; filename=fs-add-sync_inode.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a sync_inode i_op, for filesystems that can fsync with the inode and
not requiring the file (which is most of them), and use it in filesystems
and nfsd to correctly sync things.

Get rid of sync_inode, unexport sync_inodes_sb and make it internal, remove the
'wait' parameter from sync_inode_metadata, and document these things a little
better.

The core of the problem is that ->write_inode(inode, sync==1) is not
guaranteed to have the inode metadata on disk. This is because filesystems
that do asynchronous ->write_inode stuff don't "obey" sync==1. Thus, generic
code cannot assume that ->write_inode is all that is required for a full
sync. (filesystem specific code can, but that's a bit ugly I'd like to phase
it out or clarify with different function names).

Not signed off yet

---
 Documentation/filesystems/porting |    6 ++++
 drivers/staging/pohmelfs/inode.c  |    2 -
 fs/ext2/dir.c                     |    4 ++
 fs/ext2/ext2.h                    |    4 +-
 fs/ext2/file.c                    |   32 +++------------------
 fs/ext2/inode.c                   |   38 ++++++++++++++++++++++++-
 fs/ext2/namei.c                   |    1 
 fs/ext2/xattr.c                   |    4 ++
 fs/fat/file.c                     |   33 ++++++++++------------
 fs/fat/inode.c                    |   21 +++++---------
 fs/fs-writeback.c                 |   23 ---------------
 fs/internal.h                     |    5 +++
 fs/libfs.c                        |   57 ++++++++++++++++++++++++++++++++++++++
 fs/nfs/write.c                    |   16 ++++------
 fs/nfsd/vfs.c                     |    3 ++
 fs/sync.c                         |    8 +++++
 include/linux/fs.h                |   12 +++++++-
 include/linux/writeback.h         |    1 
 18 files changed, 172 insertions(+), 98 deletions(-)

Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c	2010-12-18 02:08:49.000000000 +1100
+++ linux-2.6/fs/libfs.c	2010-12-18 03:51:40.000000000 +1100
@@ -880,6 +880,64 @@ struct dentry *generic_fh_to_parent(stru
 EXPORT_SYMBOL_GPL(generic_fh_to_parent);
 
 /**
+ * generic_sync_inode - generic sync implementation for simple filesystems
+ * @inode:	inode to synchronize
+ * @flags:	INODE_SYNC_ flag
+ * @start:	start range (if INODE_SYNC_DATA is set)
+ * @end:	end range (if INODE_SYNC_DATA is set)
+ * @Returns:	0 on success, otherwise -errno.
+ *
+ * This is a generic implementation of the sync_inode method for simple
+ * filesystems which track all non-inode metadata in the buffers list
+ * hanging off the address_space structure. Their ->write_inode call must
+ * _always_ synchronously write back inode metadata (regardless if it was
+ * called for sync or async, because there is no other way to get it on
+ * disk).
+ *
+ * More advanced filesystems will want to always asynchronously dirty inode
+ * metadata in ->write_inode (regardless if it is sync or async), and then
+ * synchronously verify that it is on disk in their ->fsync, ->sync_inode,
+ * and ->sync_fs routines. generic_sync_inode could still be used in their
+ * sync_inode call, so long as they subsequently verify the metadata is on
+ * disk.
+ */
+int generic_sync_inode(struct inode *inode, unsigned int flags,
+			loff_t start, loff_t end)
+{
+	struct address_space *mapping = inode->i_mapping;
+	int err, ret = 0;
+
+	if (flags & INODE_SYNC_DATA) {
+		err = filemap_write_and_wait_range(mapping, start, end);
+		if (!ret)
+			ret = err;
+	}
+
+	if (flags & INODE_SYNC_DATA_METADATA) {
+		/*
+		 * We need to protect against concurrent writers, which could
+		 * cause livelocks in fsync_buffers_list().
+		 */
+		mutex_lock(&inode->i_mutex);
+		err = sync_mapping_buffers(mapping);
+		if (!ret)
+			ret = err;
+		mutex_unlock(&inode->i_mutex);
+	}
+
+	if (flags & (INODE_SYNC_DATA_METADATA | INODE_SYNC_METADATA)) {
+		int datasync = !(flags & INODE_SYNC_METADATA);
+
+		err = sync_inode_metadata(inode, datasync);
+		if (!ret)
+			ret = err;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(generic_sync_inode);
+
+/**
  * generic_file_fsync - generic fsync implementation for simple filesystems
  * @file:	file to synchronize
  * @datasync:	only synchronize essential metadata if true
@@ -895,7 +953,7 @@ int generic_file_fsync(struct file *file
 	int ret;
 
 	ret = sync_mapping_buffers(inode->i_mapping);
-	err = sync_inode_metadata(inode, datasync, 1);
+	err = sync_inode_metadata(inode, datasync);
 	if (ret == 0)
 		ret = err;
 	return ret;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-12-18 02:08:49.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-12-18 03:51:40.000000000 +1100
@@ -1545,6 +1545,16 @@ struct file_operations {
 	int (*setlease)(struct file *, long, struct file_lock **);
 };
 
+#define INODE_SYNC_DATA			0x01
+#define INODE_SYNC_DATA_METADATA	0x02
+#define INODE_SYNC_METADATA		0x04
+
+#define INODE_SYNC_FSYNC		(INODE_SYNC_DATA |		\
+					 INODE_SYNC_DATA_METADATA |	\
+					 INODE_SYNC_METADATA )
+#define INODE_SYNC_FDATASYNC		(INODE_SYNC_DATA |		\
+					 INODE_SYNC_DATA_METADATA)
+
 struct inode_operations {
 	int (*create) (struct inode *,struct dentry *,int, struct nameidata *);
 	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameidata *);
@@ -1573,6 +1583,7 @@ struct inode_operations {
 			  loff_t len);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
+	int (*sync_inode)(struct inode *, unsigned int, loff_t, loff_t);
 };
 
 struct seq_file;
@@ -1764,10 +1775,11 @@ static inline void file_accessed(struct
 		touch_atime(file->f_path.mnt, file->f_path.dentry);
 }
 
-int sync_inode(struct inode *inode, struct writeback_control *wbc);
-int sync_inode_metadata(struct inode *inode, int datasync, int wait);
+int sync_inode_metadata(struct inode *inode, int datasync);
 int inode_writeback_begin(struct inode *inode, int wait);
 int inode_writeback_end(struct inode *inode);
+int generic_sync_inode(struct inode *inode, unsigned int flags,
+			loff_t start, loff_t end);
 
 struct file_system_type {
 	const char *name;
Index: linux-2.6/fs/ext2/ext2.h
===================================================================
--- linux-2.6.orig/fs/ext2/ext2.h	2010-12-18 02:08:42.000000000 +1100
+++ linux-2.6/fs/ext2/ext2.h	2010-12-18 03:51:40.000000000 +1100
@@ -124,10 +124,10 @@ extern int ext2_get_block(struct inode *
 extern int ext2_setattr (struct dentry *, struct iattr *);
 extern void ext2_set_inode_flags(struct inode *inode);
 extern void ext2_get_inode_flags(struct ext2_inode_info *);
-extern struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
-					struct buffer_head **p);
 extern int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len);
+extern int ext2_sync_inode(struct inode *inode, unsigned int flags,
+			loff_t start, loff_t end);
 
 /* ioctl.c */
 extern long ext2_ioctl(struct file *, unsigned int, unsigned long);
Index: linux-2.6/fs/ext2/file.c
===================================================================
--- linux-2.6.orig/fs/ext2/file.c	2010-12-18 02:08:42.000000000 +1100
+++ linux-2.6/fs/ext2/file.c	2010-12-18 03:51:40.000000000 +1100
@@ -43,35 +43,12 @@ static int ext2_release_file (struct ino
 
 int ext2_fsync(struct file *file, int datasync)
 {
-	int ret;
 	struct inode *inode = file->f_mapping->host;
-	ino_t ino = inode->i_ino;
-	struct super_block *sb = inode->i_sb;
-	struct address_space *sb_mapping = sb->s_bdev->bd_inode->i_mapping;
-	struct buffer_head *bh;
-	struct ext2_inode *raw_inode;
+	unsigned int flags = INODE_SYNC_DATA;
+	if (!datasync)
+		flags |= INODE_SYNC_METADATA;
 
-	ret = generic_file_fsync(file, datasync);
-	if (ret == -EIO || test_and_clear_bit(AS_EIO, &sb_mapping->flags)) {
-		/* We don't really know where the IO error happened... */
-		ext2_error(sb, __func__,
-			   "detected IO error when writing metadata buffers");
-		return -EIO;
-	}
-
-	raw_inode = ext2_get_inode(sb, ino, &bh);
-	if (IS_ERR(raw_inode))
- 		return -EIO;
-
-	sync_dirty_buffer(bh);
-	if (buffer_req(bh) && !buffer_uptodate(bh)) {
-		printk ("IO error syncing ext2 inode [%s:%08lx]\n",
-			sb->s_id, (unsigned long) ino);
-		ret = -EIO;
-	}
-	brelse (bh);
-
-	return ret;
+	return ext2_sync_inode(inode, flags, 0, LLONG_MAX);
 }
 
 /*
@@ -122,4 +99,5 @@ const struct inode_operations ext2_file_
 	.setattr	= ext2_setattr,
 	.check_acl	= ext2_check_acl,
 	.fiemap		= ext2_fiemap,
+	.sync_inode	= ext2_sync_inode,
 };
Index: linux-2.6/fs/ext2/inode.c
===================================================================
--- linux-2.6.orig/fs/ext2/inode.c	2010-12-18 02:08:49.000000000 +1100
+++ linux-2.6/fs/ext2/inode.c	2010-12-18 03:51:40.000000000 +1100
@@ -1202,13 +1202,14 @@ static int ext2_setsize(struct inode *in
 
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
 	if (inode_needs_sync(inode)) {
-		sync_mapping_buffers(inode->i_mapping);
-		sync_inode_metadata(inode, 0, 1);
+		error = inode->i_op->sync_inode(inode,
+				INODE_SYNC_DATA_METADATA | INODE_SYNC_METADATA,
+				0, LLONG_MAX);
 	} else {
 		mark_inode_dirty(inode);
 	}
 
-	return 0;
+	return error;
 }
 
 struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
@@ -1515,6 +1516,39 @@ int ext2_write_inode(struct inode *inode
 	return __ext2_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
 }
 
+int ext2_sync_inode(struct inode *inode, unsigned int flags,
+			loff_t start, loff_t end)
+{
+	int ret;
+	ino_t ino = inode->i_ino;
+	struct super_block *sb = inode->i_sb;
+	struct address_space *sb_mapping = sb->s_bdev->bd_inode->i_mapping;
+	struct buffer_head *bh;
+	struct ext2_inode *raw_inode;
+
+	ret = generic_sync_inode(inode, flags, start, end);
+	if (ret == -EIO || test_and_clear_bit(AS_EIO, &sb_mapping->flags)) {
+		/* We don't really know where the IO error happened... */
+		ext2_error(sb, __func__,
+			   "detected IO error when syncing inode");
+		return -EIO;
+	}
+
+	raw_inode = ext2_get_inode(sb, ino, &bh);
+	if (IS_ERR(raw_inode))
+ 		return -EIO;
+
+	sync_dirty_buffer(bh);
+	if (buffer_req(bh) && !buffer_uptodate(bh)) {
+		printk ("IO error syncing ext2 inode [%s:%08lx]\n",
+			sb->s_id, (unsigned long) ino);
+		ret = -EIO;
+	}
+	brelse (bh);
+
+	return ret;
+}
+
 int ext2_setattr(struct dentry *dentry, struct iattr *iattr)
 {
 	struct inode *inode = dentry->d_inode;
Index: linux-2.6/fs/ext2/namei.c
===================================================================
--- linux-2.6.orig/fs/ext2/namei.c	2010-12-18 00:32:44.000000000 +1100
+++ linux-2.6/fs/ext2/namei.c	2010-12-18 03:51:40.000000000 +1100
@@ -418,6 +418,7 @@ const struct inode_operations ext2_dir_i
 #endif
 	.setattr	= ext2_setattr,
 	.check_acl	= ext2_check_acl,
+	.sync_inode	= ext2_sync_inode,
 };
 
 const struct inode_operations ext2_special_inode_operations = {
Index: linux-2.6/fs/ext2/dir.c
===================================================================
--- linux-2.6.orig/fs/ext2/dir.c	2010-12-18 02:08:49.000000000 +1100
+++ linux-2.6/fs/ext2/dir.c	2010-12-18 03:51:40.000000000 +1100
@@ -98,7 +98,9 @@ static int ext2_commit_chunk(struct page
 	if (IS_DIRSYNC(dir)) {
 		err = write_one_page(page, 1);
 		if (!err)
-			err = sync_inode_metadata(dir, 0, 1);
+			err = dir->i_op->sync_inode(dir,
+				INODE_SYNC_DATA_METADATA | INODE_SYNC_METADATA,
+				0, LLONG_MAX);
 	} else {
 		unlock_page(page);
 	}
Index: linux-2.6/fs/ext2/xattr.c
===================================================================
--- linux-2.6.orig/fs/ext2/xattr.c	2010-12-18 02:08:49.000000000 +1100
+++ linux-2.6/fs/ext2/xattr.c	2010-12-18 03:51:40.000000000 +1100
@@ -699,7 +699,9 @@ ext2_xattr_set2(struct inode *inode, str
 	EXT2_I(inode)->i_file_acl = new_bh ? new_bh->b_blocknr : 0;
 	inode->i_ctime = CURRENT_TIME_SEC;
 	if (IS_SYNC(inode)) {
-		error = sync_inode_metadata(inode, 0, 1);
+		error = inode->i_op->sync_inode(inode,
+				INODE_SYNC_METADATA,
+				0, LLONG_MAX);
 		/* In case sync failed due to ENOSPC the inode was actually
 		 * written (only some dirty data were not) so we just proceed
 		 * as if nothing happened and cleanup the unused block */
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2010-12-18 03:04:10.000000000 +1100
+++ linux-2.6/fs/nfsd/vfs.c	2010-12-18 03:51:40.000000000 +1100
@@ -287,7 +287,10 @@ commit_metadata(struct svc_fh *fhp)
 
 	if (export_ops->commit_metadata)
 		return export_ops->commit_metadata(inode);
-	return sync_inode_metadata(inode, 0, 1);
+	if (inode->i_op->sync_inode)
+		return inode->i_op->sync_inode(inode, INODE_SYNC_METADATA,
+						0, 0);
+	return sync_inode_metadata(inode, 0);
 }
 
 /*
Index: linux-2.6/fs/sync.c
===================================================================
--- linux-2.6.orig/fs/sync.c	2010-12-18 00:32:44.000000000 +1100
+++ linux-2.6/fs/sync.c	2010-12-18 03:51:40.000000000 +1100
@@ -142,8 +142,16 @@ void emergency_sync(void)
 int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
 	int err, ret;
 
+	if (inode->i_op->sync_inode) {
+		unsigned int flags = INODE_SYNC_DATA | INODE_SYNC_DATA_METADATA;
+		if (!datasync)
+			flags |= INODE_SYNC_METADATA;
+		return inode->i_op->sync_inode(inode, flags, start, end);
+	}
+
 	if (!file->f_op || !file->f_op->fsync) {
 		ret = -EINVAL;
 		goto out;
Index: linux-2.6/drivers/staging/pohmelfs/inode.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/inode.c	2010-12-18 03:04:10.000000000 +1100
+++ linux-2.6/drivers/staging/pohmelfs/inode.c	2010-12-18 03:51:40.000000000 +1100
@@ -884,7 +884,7 @@ static int pohmelfs_fsync(struct file *f
 {
 	struct inode *inode = file->f_mapping->host;
 
-	return sync_inode_metadata(inode, datasync, 1);
+	return sync_inode_metadata(inode, datasync);
 }
 
 ssize_t pohmelfs_write(struct file *file, const char __user *buf,
@@ -1951,7 +1951,7 @@ static struct dentry *pohmelfs_mount(str
  */
 static void pohmelfs_kill_super(struct super_block *sb)
 {
-	sync_inodes_sb(sb);
+	sync_filesystem(sb);
 	kill_anon_super(sb);
 }
 
Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h	2010-12-18 00:32:44.000000000 +1100
+++ linux-2.6/fs/internal.h	2010-12-18 03:51:40.000000000 +1100
@@ -108,3 +108,8 @@ extern void release_open_intent(struct n
 extern int get_nr_dirty_inodes(void);
 extern void evict_inodes(struct super_block *);
 extern int invalidate_inodes(struct super_block *);
+
+/*
+ * fs-writeback.c
+ */
+extern void sync_inodes_sb(struct super_block *);
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h	2010-12-18 00:32:44.000000000 +1100
+++ linux-2.6/include/linux/writeback.h	2010-12-18 03:51:40.000000000 +1100
@@ -61,7 +61,6 @@ void writeback_inodes_sb(struct super_bl
 void writeback_inodes_sb_nr(struct super_block *, unsigned long nr);
 int writeback_inodes_sb_if_idle(struct super_block *);
 int writeback_inodes_sb_nr_if_idle(struct super_block *, unsigned long nr);
-void sync_inodes_sb(struct super_block *);
 void writeback_inodes_wb(struct bdi_writeback *wb,
 		struct writeback_control *wbc);
 long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-12-18 02:08:49.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-12-18 03:51:40.000000000 +1100
@@ -1229,7 +1229,8 @@ EXPORT_SYMBOL(writeback_inodes_sb_nr_if_
  * @sb: the superblock
  *
  * This function writes and waits on any dirty inode belonging to this
- * super_block. The number of pages synced is returned.
+ * super_block. Metadata may not be guaranteed to be on disk until a
+ * subsequent ->sync_fs call. The number of pages synced is returned.
  */
 void sync_inodes_sb(struct super_block *sb)
 {
@@ -1249,15 +1250,19 @@ void sync_inodes_sb(struct super_block *
 
 	wait_sb_inodes(sb);
 }
-EXPORT_SYMBOL(sync_inodes_sb);
 
 /**
- * write_inode_now	-	write an inode to disk
+ * write_inode_now	-	write an inode to disk (maybe)
  * @inode: inode to write to disk
  * @sync: whether the write should be synchronous or not
  *
- * This function commits an inode to disk immediately if it is dirty. This is
- * primarily needed by knfsd.
+ * This function writes an inode's data to disk, and then calls ->write_inode
+ * on the metadata if the inode metadata dirty bits are set. This doesn't
+ * necessarily sync the inode to disk, depending on whether the filesystem
+ * syncs its inode at ->write_inode time or not. So this function is not
+ * portable outside a specific filesystem when sync == 1.
+ *
+ * Do not add any new users of this function.
  *
  * The caller must either have a ref on the inode or must have set I_WILL_FREE.
  */
@@ -1285,41 +1290,17 @@ int write_inode_now(struct inode *inode,
 EXPORT_SYMBOL(write_inode_now);
 
 /**
- * sync_inode - write an inode and its pages to disk.
+ * sync_inode_metadata - call ->write_inode if needed
  * @inode: the inode to sync
- * @wbc: controls the writeback mode
- *
- * sync_inode() will write an inode and its pages to disk.  It will also
- * correctly update the inode on its superblock's dirty inode lists and will
- * update inode->i_state.
- *
- * The caller must have a ref on the inode.
- */
-int sync_inode(struct inode *inode, struct writeback_control *wbc)
-{
-	int ret;
-
-	spin_lock(&inode_lock);
-	ret = writeback_single_inode(inode, wbc);
-	spin_unlock(&inode_lock);
-	return ret;
-}
-EXPORT_SYMBOL(sync_inode);
-
-/**
- * sync_inode_metadata - write an inode to disk
- * @inode: the inode to sync
- * @wait: wait for I/O to complete.
- *
- * Write an inode to disk and adjust it's dirty state after completion.
+ * @datasync: look at datasync bits only
  *
- * Note: only writes the actual inode, no associated data or other metadata.
+ * This only calls ->write_inode, which doesn't necessarily ensure anything
+ * on disk. It should only be used as an fs helper.
  */
-int sync_inode_metadata(struct inode *inode, int datasync, int wait)
+int sync_inode_metadata(struct inode *inode, int datasync)
 {
-	struct address_space *mapping = inode->i_mapping;
 	struct writeback_control wbc = {
-		.sync_mode = wait ? WB_SYNC_ALL : WB_SYNC_NONE,
+		.sync_mode = WB_SYNC_ALL,
 		.nr_to_write = 0, /* metadata-only */
 	};
 	unsigned dirty, mask;
@@ -1330,7 +1311,7 @@ int sync_inode_metadata(struct inode *in
 	 * Keep them in sync.
 	 */
 	spin_lock(&inode_lock);
-	if (!inode_writeback_begin(inode, wait))
+	if (!inode_writeback_begin(inode, 1))
 		goto out;
 
 	if (datasync)
Index: linux-2.6/fs/fat/file.c
===================================================================
--- linux-2.6.orig/fs/fat/file.c	2010-12-18 00:32:44.000000000 +1100
+++ linux-2.6/fs/fat/file.c	2010-12-18 03:51:40.000000000 +1100
@@ -160,7 +160,6 @@ int fat_file_fsync(struct file *filp, in
 	return res ? res : err;
 }
 
-
 const struct file_operations fat_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
@@ -192,22 +191,9 @@ static int fat_cont_expand(struct inode
 	if (IS_SYNC(inode)) {
 		int err2;
 
-		/*
-		 * Opencode syncing since we don't have a file open to use
-		 * standard fsync path.
-		 */
-		err = filemap_fdatawrite_range(mapping, start,
-					       start + count - 1);
-		err2 = sync_mapping_buffers(mapping);
-		if (!err)
-			err = err2;
-		err2 = write_inode_now(inode, 1);
-		if (!err)
-			err = err2;
-		if (!err) {
-			err =  filemap_fdatawait_range(mapping, start,
-						       start + count - 1);
-		}
+		err = inode->i_op->sync_inode(inode,
+				INODE_SYNC_DATA | INODE_SYNC_DATA_METADATA |
+				INODE_SYNC_METADATA, start, start + count - 1);
 	}
 out:
 	return err;
@@ -440,7 +426,20 @@ int fat_setattr(struct dentry *dentry, s
 }
 EXPORT_SYMBOL_GPL(fat_setattr);
 
+static int fat_inode_sync_inode(struct inode *inode, unsigned int flags,
+			loff_t start, loff_t end)
+{
+	int err;
+
+	err = generic_sync_inode(inode, flags, start, end);
+	if (err)
+		return err;
+	err = sync_mapping_buffers(MSDOS_SB(inode->i_sb)->fat_inode->i_mapping);
+	return err;
+}
+
 const struct inode_operations fat_file_inode_operations = {
 	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
+	.sync_inode	= fat_inode_sync_inode,
 };
Index: linux-2.6/Documentation/filesystems/porting
===================================================================
--- linux-2.6.orig/Documentation/filesystems/porting	2010-12-18 00:32:44.000000000 +1100
+++ linux-2.6/Documentation/filesystems/porting	2010-12-18 03:51:40.000000000 +1100
@@ -318,3 +318,9 @@ if it's zero is not *and* *never* *had*
 may happen while the inode is in the middle of ->write_inode(); e.g. if you blindly
 free the on-disk inode, you may end up doing that while ->write_inode() is writing
 to it.
+
+--
+[mandatory]
+	Inode writeback and syncing has undergone an overhaul.
+write_inode_now doesn't sync (unless ->write_inode *always* syncs)
+
Index: linux-2.6/fs/fat/inode.c
===================================================================
--- linux-2.6.orig/fs/fat/inode.c	2010-12-18 02:08:42.000000000 +1100
+++ linux-2.6/fs/fat/inode.c	2010-12-18 03:51:40.000000000 +1100
@@ -1534,20 +1534,15 @@ EXPORT_SYMBOL_GPL(fat_fill_super);
  */
 static int writeback_inode(struct inode *inode)
 {
-
-	int ret;
 	struct address_space *mapping = inode->i_mapping;
-	struct writeback_control wbc = {
-	       .sync_mode = WB_SYNC_NONE,
-	      .nr_to_write = 0,
-	};
-	/* if we used WB_SYNC_ALL, sync_inode waits for the io for the
-	* inode to finish.  So WB_SYNC_NONE is sent down to sync_inode
-	* and filemap_fdatawrite is used for the data blocks
-	*/
-	ret = sync_inode(inode, &wbc);
-	if (!ret)
-	       ret = filemap_fdatawrite(mapping);
+	int ret;
+
+	ret = sync_inode_metadata(inode, 0);
+	if (ret)
+		return ret;
+
+	ret = filemap_fdatawrite(mapping);
+
 	return ret;
 }
 
Index: linux-2.6/fs/nfs/write.c
===================================================================
--- linux-2.6.orig/fs/nfs/write.c	2010-12-18 00:32:44.000000000 +1100
+++ linux-2.6/fs/nfs/write.c	2010-12-18 03:51:40.000000000 +1100
@@ -1416,8 +1416,7 @@ int nfs_commit_inode(struct inode *inode
 	return res;
 	/* Note: If we exit without ensuring that the commit is complete,
 	 * we must mark the inode as dirty. Otherwise, future calls to
-	 * sync_inode() with the WB_SYNC_ALL flag set will fail to ensure
-	 * that the data is on the disk.
+	 * ->write_inode() will fail to ensure that the data is on the disk.
 	 */
 out_mark_dirty:
 	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
@@ -1472,14 +1471,13 @@ int nfs_write_inode(struct inode *inode,
  */
 int nfs_wb_all(struct inode *inode)
 {
-	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_ALL,
-		.nr_to_write = LONG_MAX,
-		.range_start = 0,
-		.range_end = LLONG_MAX,
-	};
+	int ret;
 
-	return sync_inode(inode, &wbc);
+	ret = filemap_fdatawrite(inode->i_mapping);
+	if (ret)
+		return ret;
+	ret = sync_inode_metadata(inode, 0);
+	return ret;
 }
 
 int nfs_wb_page_cancel(struct inode *inode, struct page *page)
Index: linux-2.6/fs/exofs/file.c
===================================================================
--- linux-2.6.orig/fs/exofs/file.c	2010-12-18 02:08:49.000000000 +1100
+++ linux-2.6/fs/exofs/file.c	2010-12-18 03:51:40.000000000 +1100
@@ -48,7 +48,7 @@ static int exofs_file_fsync(struct file
 	struct inode *inode = filp->f_mapping->host;
 	struct super_block *sb;
 
-	ret = sync_inode_metadata(inode, datasync, 1);
+	ret = sync_inode_metadata(inode, datasync);
 
 	/* This is a good place to write the sb */
 	/* TODO: Sechedule an sb-sync on create */
Index: linux-2.6/fs/ubifs/file.c
===================================================================
--- linux-2.6.orig/fs/ubifs/file.c	2010-12-18 03:04:10.000000000 +1100
+++ linux-2.6/fs/ubifs/file.c	2010-12-18 03:51:40.000000000 +1100
@@ -1313,7 +1313,7 @@ int ubifs_fsync(struct file *file, int d
 	 * VFS has already synchronized dirty pages for this inode. Synchronize
 	 * the inode unless this is a 'datasync()' call.
 	 */
-	err = sync_inode_metadata(inode, datasync, 1);
+	err = sync_inode_metadata(inode, datasync);
 	if (err)
 		return err;
 


