Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0JRGZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 02:25:43 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:37396 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753361Ab0JRGVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 02:21:41 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/20] fs: Clean up inode reference counting
Date: Mon, 18 Oct 2010 17:20:42 +1100
Message-Id: <1287382856-29529-7-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287382856-29529-1-git-send-email-david@fromorbit.com>
References: <1287382856-29529-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Lots of filesystem code open codes the act of getting a reference to
an inode.  Factor the open coded inode lock, increment, unlock into
a function iref(). This removes most direct external references to
the inode reference count.

Originally based on a patch from Nick Piggin.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/9p/vfs_inode.c           |    5 +++--
 fs/affs/inode.c             |    2 +-
 fs/afs/dir.c                |    2 +-
 fs/anon_inodes.c            |    7 +------
 fs/bfs/dir.c                |    2 +-
 fs/block_dev.c              |   13 ++++++-------
 fs/btrfs/inode.c            |    2 +-
 fs/coda/dir.c               |    2 +-
 fs/drop_caches.c            |    2 +-
 fs/exofs/inode.c            |    2 +-
 fs/exofs/namei.c            |    2 +-
 fs/ext2/namei.c             |    2 +-
 fs/ext3/namei.c             |    2 +-
 fs/ext4/namei.c             |    2 +-
 fs/fs-writeback.c           |    7 +++----
 fs/gfs2/ops_inode.c         |    2 +-
 fs/hfsplus/dir.c            |    2 +-
 fs/inode.c                  |   34 ++++++++++++++++++++++------------
 fs/jffs2/dir.c              |    4 ++--
 fs/jfs/jfs_txnmgr.c         |    2 +-
 fs/jfs/namei.c              |    2 +-
 fs/libfs.c                  |    2 +-
 fs/logfs/dir.c              |    2 +-
 fs/minix/namei.c            |    2 +-
 fs/namei.c                  |    2 +-
 fs/nfs/dir.c                |    2 +-
 fs/nfs/getroot.c            |    2 +-
 fs/nfs/write.c              |    2 +-
 fs/nilfs2/namei.c           |    2 +-
 fs/notify/inode_mark.c      |    8 ++++----
 fs/ntfs/super.c             |    4 ++--
 fs/ocfs2/namei.c            |    2 +-
 fs/quota/dquot.c            |    2 +-
 fs/reiserfs/namei.c         |    2 +-
 fs/sysv/namei.c             |    2 +-
 fs/ubifs/dir.c              |    2 +-
 fs/udf/namei.c              |    2 +-
 fs/ufs/namei.c              |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c |    2 +-
 fs/xfs/xfs_inode.h          |    2 +-
 include/linux/fs.h          |    2 +-
 ipc/mqueue.c                |    2 +-
 kernel/futex.c              |    2 +-
 mm/shmem.c                  |    2 +-
 net/socket.c                |    2 +-
 45 files changed, 80 insertions(+), 76 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 9e670d5..1f76624 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1789,9 +1789,10 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 		kfree(st);
 	} else {
 		/* Caching disabled. No need to get upto date stat info.
-		 * This dentry will be released immediately. So, just i_count++
+		 * This dentry will be released immediately. So, just take
+		 * a reference.
 		 */
-		atomic_inc(&old_dentry->d_inode->i_count);
+		iref(old_dentry->d_inode);
 	}
 
 	dentry->d_op = old_dentry->d_op;
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 3a0fdec..2100852 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -388,7 +388,7 @@ affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s3
 		affs_adjust_checksum(inode_bh, block - be32_to_cpu(chain));
 		mark_buffer_dirty_inode(inode_bh, inode);
 		inode->i_nlink = 2;
-		atomic_inc(&inode->i_count);
+		iref(inode);
 	}
 	affs_fix_checksum(sb, bh);
 	mark_buffer_dirty_inode(bh, inode);
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 0d38c09..87d8c03 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1045,7 +1045,7 @@ static int afs_link(struct dentry *from, struct inode *dir,
 	if (ret < 0)
 		goto link_error;
 
-	atomic_inc(&vnode->vfs_inode.i_count);
+	iref(&vnode->vfs_inode);
 	d_instantiate(dentry, &vnode->vfs_inode);
 	key_put(key);
 	_leave(" = 0");
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index e4b75d6..451be78 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -109,12 +109,7 @@ struct file *anon_inode_getfile(const char *name,
 		goto err_module;
 
 	path.mnt = mntget(anon_inode_mnt);
-	/*
-	 * We know the anon_inode inode count is always greater than zero,
-	 * so we can avoid doing an igrab() and we can use an open-coded
-	 * atomic_inc().
-	 */
-	atomic_inc(&anon_inode_inode->i_count);
+	iref(anon_inode_inode);
 
 	path.dentry->d_op = &anon_inodefs_dentry_operations;
 	d_instantiate(path.dentry, anon_inode_inode);
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index d967e05..6e93a37 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -176,7 +176,7 @@ static int bfs_link(struct dentry *old, struct inode *dir,
 	inc_nlink(inode);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 	d_instantiate(new, inode);
 	mutex_unlock(&info->bfs_lock);
 	return 0;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 63b1c4c..11ad53d 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -565,7 +565,7 @@ EXPORT_SYMBOL(bdget);
  */
 struct block_device *bdgrab(struct block_device *bdev)
 {
-	atomic_inc(&bdev->bd_inode->i_count);
+	iref(bdev->bd_inode);
 	return bdev;
 }
 
@@ -595,7 +595,7 @@ static struct block_device *bd_acquire(struct inode *inode)
 	spin_lock(&bdev_lock);
 	bdev = inode->i_bdev;
 	if (bdev) {
-		atomic_inc(&bdev->bd_inode->i_count);
+		bdgrab(bdev);
 		spin_unlock(&bdev_lock);
 		return bdev;
 	}
@@ -606,12 +606,11 @@ static struct block_device *bd_acquire(struct inode *inode)
 		spin_lock(&bdev_lock);
 		if (!inode->i_bdev) {
 			/*
-			 * We take an additional bd_inode->i_count for inode,
-			 * and it's released in clear_inode() of inode.
-			 * So, we can access it via ->i_mapping always
-			 * without igrab().
+			 * We take an additional bdev reference here so
+			 * we can access it via ->i_mapping always
+			 * without first needing to grab a reference.
 			 */
-			atomic_inc(&bdev->bd_inode->i_count);
+			bdgrab(bdev);
 			inode->i_bdev = bdev;
 			inode->i_mapping = bdev->bd_inode->i_mapping;
 			list_add(&inode->i_devices, &bdev->bd_inodes);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c038644..80e28bf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4758,7 +4758,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	}
 
 	btrfs_set_trans_block_group(trans, dir);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 
 	err = btrfs_add_nondir(trans, dentry, inode, 1, index);
 
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index ccd98b0..ac8b913 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -303,7 +303,7 @@ static int coda_link(struct dentry *source_de, struct inode *dir_inode,
 	}
 
 	coda_dir_update_mtime(dir_inode);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 	d_instantiate(de, inode);
 	inc_nlink(inode);
 
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 2195c21..c2721fa 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -22,7 +22,7 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 			continue;
 		if (inode->i_mapping->nrpages == 0)
 			continue;
-		__iget(inode);
+		atomic_inc(&inode->i_count);
 		spin_unlock(&inode_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index eb7368e..b631ff3 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1154,7 +1154,7 @@ struct inode *exofs_new_inode(struct inode *dir, int mode)
 	/* increment the refcount so that the inode will still be around when we
 	 * reach the callback
 	 */
-	atomic_inc(&inode->i_count);
+	iref(inode);
 
 	ios->done = create_done;
 	ios->private = inode;
diff --git a/fs/exofs/namei.c b/fs/exofs/namei.c
index b7dd0c2..f2a30a0 100644
--- a/fs/exofs/namei.c
+++ b/fs/exofs/namei.c
@@ -153,7 +153,7 @@ static int exofs_link(struct dentry *old_dentry, struct inode *dir,
 
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 
 	return exofs_add_nondir(dentry, inode);
 }
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 71efb0e..b15435f 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -206,7 +206,7 @@ static int ext2_link (struct dentry * old_dentry, struct inode * dir,
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 
 	err = ext2_add_link(dentry, inode);
 	if (!err) {
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 2b35ddb..6c7a5d6 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2260,7 +2260,7 @@ retry:
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 
 	err = ext3_add_entry(handle, dentry, inode);
 	if (!err) {
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 314c0d3..a406a85 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2312,7 +2312,7 @@ retry:
 
 	inode->i_ctime = ext4_current_time(inode);
 	ext4_inc_count(handle, inode);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 
 	err = ext4_add_entry(handle, dentry, inode);
 	if (!err) {
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 92d73b6..595dfc6 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -298,8 +298,7 @@ static void inode_wait_for_writeback(struct inode *inode)
 
 /*
  * Write out an inode's dirty pages.  Called under inode_lock.  Either the
- * caller has ref on the inode (either via __iget or via syscall against an fd)
- * or the inode has I_WILL_FREE set (via generic_forget_inode)
+ * caller has a reference on the inode or the inode has I_WILL_FREE set.
  *
  * If `wait' is set, wait on the writeout.
  *
@@ -500,7 +499,7 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 			return 1;
 
 		BUG_ON(inode->i_state & I_FREEING);
-		__iget(inode);
+		atomic_inc(&inode->i_count);
 		pages_skipped = wbc->pages_skipped;
 		writeback_single_inode(inode, wbc);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -1046,7 +1045,7 @@ static void wait_sb_inodes(struct super_block *sb)
 		mapping = inode->i_mapping;
 		if (mapping->nrpages == 0)
 			continue;
-		__iget(inode);
+		atomic_inc(&inode->i_count);
 		spin_unlock(&inode_lock);
 		/*
 		 * We hold a reference to 'inode' so it couldn't have
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 1009be2..508407d 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -253,7 +253,7 @@ out_parent:
 	gfs2_holder_uninit(ghs);
 	gfs2_holder_uninit(ghs + 1);
 	if (!error) {
-		atomic_inc(&inode->i_count);
+		iref(inode);
 		d_instantiate(dentry, inode);
 		mark_inode_dirty(inode);
 	}
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 764fd1b..e2ce54d 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -301,7 +301,7 @@ static int hfsplus_link(struct dentry *src_dentry, struct inode *dst_dir,
 
 	inc_nlink(inode);
 	hfsplus_instantiate(dst_dentry, inode, cnid);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 	HFSPLUS_SB(sb).file_count++;
diff --git a/fs/inode.c b/fs/inode.c
index 964d2d9..4f0e56c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -314,13 +314,23 @@ static void init_once(void *foo)
 	inode_init_once(inode);
 }
 
-/*
- * inode_lock must be held
+/**
+ * iref - increment the reference count on an inode
+ * @inode:	inode to take a reference on
+ *
+ * iref() should be called to take an extra reference to an inode. The inode
+ * must already have a reference count obtained via igrab() as iref() does not
+ * do checks for the inode being freed and hence cannot be used to initially
+ * obtain a reference to the inode.
  */
-void __iget(struct inode *inode)
+void iref(struct inode *inode)
 {
+	WARN_ON(atomic_read(&inode->i_count) < 1);
+	spin_lock(&inode_lock);
 	atomic_inc(&inode->i_count);
+	spin_unlock(&inode_lock);
 }
+EXPORT_SYMBOL_GPL(iref);
 
 void inode_lru_list_add(struct inode *inode)
 {
@@ -510,7 +520,7 @@ static void prune_icache(int nr_to_scan)
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
-			__iget(inode);
+			atomic_inc(&inode->i_count);
 			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
@@ -578,7 +588,7 @@ static struct shrinker icache_shrinker = {
 static void __wait_on_freeing_inode(struct inode *inode);
 /*
  * Called with the inode lock held.
- * NOTE: we are not increasing the inode-refcount, you must call __iget()
+ * NOTE: we are not increasing the inode-refcount, you must take a reference
  * by hand after calling find_inode now! This simplifies iunique and won't
  * add any additional branch in the common code.
  */
@@ -782,7 +792,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		__iget(old);
+		atomic_inc(&old->i_count);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -829,7 +839,7 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		__iget(old);
+		atomic_inc(&old->i_count);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -882,7 +892,7 @@ struct inode *igrab(struct inode *inode)
 {
 	spin_lock(&inode_lock);
 	if (!(inode->i_state & (I_FREEING|I_WILL_FREE)))
-		__iget(inode);
+		atomic_inc(&inode->i_count);
 	else
 		/*
 		 * Handle the case where s_op->clear_inode is not been
@@ -923,7 +933,7 @@ static struct inode *ifind(struct super_block *sb,
 	spin_lock(&inode_lock);
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
-		__iget(inode);
+		atomic_inc(&inode->i_count);
 		spin_unlock(&inode_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
@@ -956,7 +966,7 @@ static struct inode *ifind_fast(struct super_block *sb,
 	spin_lock(&inode_lock);
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
-		__iget(inode);
+		atomic_inc(&inode->i_count);
 		spin_unlock(&inode_lock);
 		wait_on_inode(inode);
 		return inode;
@@ -1139,7 +1149,7 @@ int insert_inode_locked(struct inode *inode)
 			spin_unlock(&inode_lock);
 			return 0;
 		}
-		__iget(old);
+		atomic_inc(&old->i_count);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1178,7 +1188,7 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 			spin_unlock(&inode_lock);
 			return 0;
 		}
-		__iget(old);
+		atomic_inc(&old->i_count);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index ed78a3c..797a034 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -289,7 +289,7 @@ static int jffs2_link (struct dentry *old_dentry, struct inode *dir_i, struct de
 		mutex_unlock(&f->sem);
 		d_instantiate(dentry, old_dentry->d_inode);
 		dir_i->i_mtime = dir_i->i_ctime = ITIME(now);
-		atomic_inc(&old_dentry->d_inode->i_count);
+		iref(old_dentry->d_inode);
 	}
 	return ret;
 }
@@ -864,7 +864,7 @@ static int jffs2_rename (struct inode *old_dir_i, struct dentry *old_dentry,
 		printk(KERN_NOTICE "jffs2_rename(): Link succeeded, unlink failed (err %d). You now have a hard link\n", ret);
 		/* Might as well let the VFS know */
 		d_instantiate(new_dentry, old_dentry->d_inode);
-		atomic_inc(&old_dentry->d_inode->i_count);
+		iref(old_dentry->d_inode);
 		new_dir_i->i_mtime = new_dir_i->i_ctime = ITIME(now);
 		return ret;
 	}
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index d945ea7..3e6dd08 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -1279,7 +1279,7 @@ int txCommit(tid_t tid,		/* transaction identifier */
 	 * lazy commit thread finishes processing
 	 */
 	if (tblk->xflag & COMMIT_DELETE) {
-		atomic_inc(&tblk->u.ip->i_count);
+		iref(tblk->u.ip);
 		/*
 		 * Avoid a rare deadlock
 		 *
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index a9cf8e8..3d3566e 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -839,7 +839,7 @@ static int jfs_link(struct dentry *old_dentry,
 	ip->i_ctime = CURRENT_TIME;
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	mark_inode_dirty(dir);
-	atomic_inc(&ip->i_count);
+	iref(ip);
 
 	iplist[0] = ip;
 	iplist[1] = dir;
diff --git a/fs/libfs.c b/fs/libfs.c
index 0a9da95..f190d73 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -255,7 +255,7 @@ int simple_link(struct dentry *old_dentry, struct inode *dir, struct dentry *den
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 	dget(dentry);
 	d_instantiate(dentry, inode);
 	return 0;
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 9777eb5..8522edc 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -569,7 +569,7 @@ static int logfs_link(struct dentry *old_dentry, struct inode *dir,
 		return -EMLINK;
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-	atomic_inc(&inode->i_count);
+	iref(inode);
 	inode->i_nlink++;
 	mark_inode_dirty_sync(inode);
 
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index f3f3578..7563a82 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -101,7 +101,7 @@ static int minix_link(struct dentry * old_dentry, struct inode * dir,
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 	return add_nondir(dentry, inode);
 }
 
diff --git a/fs/namei.c b/fs/namei.c
index 24896e8..5fb93f3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2291,7 +2291,7 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 			goto slashes;
 		inode = dentry->d_inode;
 		if (inode)
-			atomic_inc(&inode->i_count);
+			iref(inode);
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index e257172..5482ede 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1580,7 +1580,7 @@ nfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 	d_drop(dentry);
 	error = NFS_PROTO(dir)->link(inode, dir, &dentry->d_name);
 	if (error == 0) {
-		atomic_inc(&inode->i_count);
+		iref(inode);
 		d_add(dentry, inode);
 	}
 	return error;
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index a70e446..5aaa2be 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -55,7 +55,7 @@ static int nfs_superblock_set_dummy_root(struct super_block *sb, struct inode *i
 			return -ENOMEM;
 		}
 		/* Circumvent igrab(): we know the inode is not being freed */
-		atomic_inc(&inode->i_count);
+		iref(inode);
 		/*
 		 * Ensure that this dentry is invisible to d_find_alias().
 		 * Otherwise, it may be spliced into the tree by
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 874972d..d1c2f08 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -390,7 +390,7 @@ static int nfs_inode_add_request(struct inode *inode, struct nfs_page *req)
 	error = radix_tree_insert(&nfsi->nfs_page_tree, req->wb_index, req);
 	BUG_ON(error);
 	if (!nfsi->npages) {
-		igrab(inode);
+		iref(inode);
 		if (nfs_have_delegation(inode, FMODE_WRITE))
 			nfsi->change_attr++;
 	}
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index ad6ed2c..fbd3348 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -219,7 +219,7 @@ static int nilfs_link(struct dentry *old_dentry, struct inode *dir,
 
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 
 	err = nilfs_add_nondir(dentry, inode);
 	if (!err)
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 33297c0..fa7f3b8 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -244,7 +244,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		struct inode *need_iput_tmp;
 
 		/*
-		 * We cannot __iget() an inode in state I_FREEING,
+		 * We cannot iref() an inode in state I_FREEING,
 		 * I_WILL_FREE, or I_NEW which is fine because by that point
 		 * the inode cannot have any associated watches.
 		 */
@@ -253,7 +253,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 
 		/*
 		 * If i_count is zero, the inode cannot have any watches and
-		 * doing an __iget/iput with MS_ACTIVE clear would actually
+		 * doing an iref/iput with MS_ACTIVE clear would actually
 		 * evict all inodes with zero i_count from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
@@ -265,7 +265,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 
 		/* In case fsnotify_inode_delete() drops a reference. */
 		if (inode != need_iput_tmp)
-			__iget(inode);
+			atomic_inc(&inode->i_count);
 		else
 			need_iput_tmp = NULL;
 
@@ -273,7 +273,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		if ((&next_i->i_sb_list != list) &&
 		    atomic_read(&next_i->i_count) &&
 		    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
-			__iget(next_i);
+			atomic_inc(&next_i->i_count);
 			need_iput = next_i;
 		}
 
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 5128061..52b48e3 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2929,8 +2929,8 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 		goto unl_upcase_iput_tmp_ino_err_out_now;
 	}
 	if ((sb->s_root = d_alloc_root(vol->root_ino))) {
-		/* We increment i_count simulating an ntfs_iget(). */
-		atomic_inc(&vol->root_ino->i_count);
+		/* Simulate an ntfs_iget() call */
+		iref(vol->root_ino);
 		ntfs_debug("Exiting, status successful.");
 		/* Release the default upcase if it has no users. */
 		mutex_lock(&ntfs_lock);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index a00dda2..0e002f6 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -741,7 +741,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 		goto out_commit;
 	}
 
-	atomic_inc(&inode->i_count);
+	iref(inode);
 	dentry->d_op = &ocfs2_dentry_ops;
 	d_instantiate(dentry, inode);
 
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index aad1316..38d4304 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -909,7 +909,7 @@ static void add_dquot_ref(struct super_block *sb, int type)
 		if (!dqinit_needed(inode, type))
 			continue;
 
-		__iget(inode);
+		atomic_inc(&inode->i_count);
 		spin_unlock(&inode_lock);
 
 		iput(old_inode);
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index ee78d4a..f19bb3d 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -1156,7 +1156,7 @@ static int reiserfs_link(struct dentry *old_dentry, struct inode *dir,
 	inode->i_ctime = CURRENT_TIME_SEC;
 	reiserfs_update_sd(&th, inode);
 
-	atomic_inc(&inode->i_count);
+	iref(inode);
 	d_instantiate(dentry, inode);
 	retval = journal_end(&th, dir->i_sb, jbegin_count);
 	reiserfs_write_unlock(dir->i_sb);
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index 33e047b..765974f 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -126,7 +126,7 @@ static int sysv_link(struct dentry * old_dentry, struct inode * dir,
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 
 	return add_nondir(dentry, inode);
 }
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 87ebcce..9e8281f 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -550,7 +550,7 @@ static int ubifs_link(struct dentry *old_dentry, struct inode *dir,
 
 	lock_2_inodes(dir, inode);
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 	inode->i_ctime = ubifs_current_time(inode);
 	dir->i_size += sz_change;
 	dir_ui->ui_size = dir->i_size;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index bf5fc67..f6e232a 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1101,7 +1101,7 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
 	inc_nlink(inode);
 	inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 	d_instantiate(dentry, inode);
 	unlock_kernel();
 
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index b056f02..2a598eb 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -180,7 +180,7 @@ static int ufs_link (struct dentry * old_dentry, struct inode * dir,
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	iref(inode);
 
 	error = ufs_add_nondir(dentry, inode);
 	unlock_kernel();
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index b1fc2a6..b7ec465 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -352,7 +352,7 @@ xfs_vn_link(
 	if (unlikely(error))
 		return -error;
 
-	atomic_inc(&inode->i_count);
+	iref(inode);
 	d_instantiate(dentry, inode);
 	return 0;
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0898c54..cbb4791 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -482,7 +482,7 @@ void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 #define IHOLD(ip) \
 do { \
 	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
-	atomic_inc(&(VFS_I(ip)->i_count)); \
+	iref(VFS_I(ip)); \
 	trace_xfs_ihold(ip, _THIS_IP_); \
 } while (0)
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 90d2b47..6eb94b0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2184,7 +2184,7 @@ extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struc
 extern int insert_inode_locked(struct inode *);
 extern void unlock_new_inode(struct inode *);
 
-extern void __iget(struct inode * inode);
+extern void iref(struct inode *inode);
 extern void iget_failed(struct inode *);
 extern void end_writeback(struct inode *);
 extern void destroy_inode(struct inode *);
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index c60e519..d53a2c1 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -769,7 +769,7 @@ SYSCALL_DEFINE1(mq_unlink, const char __user *, u_name)
 
 	inode = dentry->d_inode;
 	if (inode)
-		atomic_inc(&inode->i_count);
+		iref(inode);
 	err = mnt_want_write(ipc_ns->mq_mnt);
 	if (err)
 		goto out_err;
diff --git a/kernel/futex.c b/kernel/futex.c
index 6a3a5fa..3bb418c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -168,7 +168,7 @@ static void get_futex_key_refs(union futex_key *key)
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		atomic_inc(&key->shared.inode->i_count);
+		iref(key->shared.inode);
 		break;
 	case FUT_OFF_MMSHARED:
 		atomic_inc(&key->private.mm->mm_count);
diff --git a/mm/shmem.c b/mm/shmem.c
index 080b09a..7d0bc16 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1903,7 +1903,7 @@ static int shmem_link(struct dentry *old_dentry, struct inode *dir, struct dentr
 	dir->i_size += BOGO_DIRENT_SIZE;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);	/* New dentry reference */
+	iref(inode);
 	dget(dentry);		/* Extra pinning count for the created dentry */
 	d_instantiate(dentry, inode);
 out:
diff --git a/net/socket.c b/net/socket.c
index 2270b94..715ca57 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -377,7 +377,7 @@ static int sock_alloc_file(struct socket *sock, struct file **f, int flags)
 		  &socket_file_ops);
 	if (unlikely(!file)) {
 		/* drop dentry, keep inode */
-		atomic_inc(&path.dentry->d_inode->i_count);
+		iref(path.dentry->d_inode);
 		path_put(&path);
 		put_unused_fd(fd);
 		return -ENFILE;
-- 
1.7.1

