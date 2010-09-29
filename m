Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab0I2MTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:19:37 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:41840 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755655Ab0I2MTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:32 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/17] fs: Clean up inode reference counting
Date: Wed, 29 Sep 2010 22:18:49 +1000
Message-Id: <1285762729-17928-18-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Lots of filesystem code open codes the act of getting a reference to
an inode.  Factor the open coded inode lock, increment, unlock into
a function iget().  Then rename __iget to iget_ilock so that nothing
is directly incrementing the inode reference count for trivial
operations.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/affs/inode.c             |    4 +---
 fs/anon_inodes.c            |    4 +---
 fs/bfs/dir.c                |    4 +---
 fs/block_dev.c              |   14 +++-----------
 fs/btrfs/inode.c            |    4 +---
 fs/coda/dir.c               |    4 +---
 fs/drop_caches.c            |    2 +-
 fs/exofs/inode.c            |    4 +---
 fs/exofs/namei.c            |    4 +---
 fs/ext2/namei.c             |    4 +---
 fs/ext3/namei.c             |    4 +---
 fs/ext4/namei.c             |    4 +---
 fs/fs-writeback.c           |    6 +++---
 fs/gfs2/ops_inode.c         |    4 +---
 fs/hfsplus/dir.c            |    4 +---
 fs/inode.c                  |   18 +++++++++---------
 fs/jffs2/dir.c              |    8 ++------
 fs/jfs/jfs_txnmgr.c         |    4 +---
 fs/jfs/namei.c              |    4 +---
 fs/libfs.c                  |    4 +---
 fs/logfs/dir.c              |    4 +---
 fs/minix/namei.c            |    4 +---
 fs/namei.c                  |    7 ++-----
 fs/nfs/dir.c                |    4 +---
 fs/nfs/getroot.c            |    6 ++----
 fs/nfs/write.c              |    2 +-
 fs/nilfs2/namei.c           |    4 +---
 fs/notify/inode_mark.c      |    8 ++++----
 fs/ntfs/super.c             |    4 +---
 fs/ocfs2/namei.c            |    4 +---
 fs/quota/dquot.c            |    2 +-
 fs/reiserfs/namei.c         |    4 +---
 fs/sysv/namei.c             |    4 +---
 fs/ubifs/dir.c              |    4 +---
 fs/udf/namei.c              |    4 +---
 fs/ufs/namei.c              |    4 +---
 fs/xfs/linux-2.6/xfs_iops.c |    4 +---
 fs/xfs/xfs_inode.h          |    4 +---
 include/linux/fs.h          |   10 +++++++++-
 ipc/mqueue.c                |    7 ++-----
 kernel/futex.c              |    4 +---
 mm/shmem.c                  |    4 +---
 net/socket.c                |    4 +---
 43 files changed, 70 insertions(+), 144 deletions(-)

diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index cb9e773..f892be2 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -388,9 +388,7 @@ affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s3
 		affs_adjust_checksum(inode_bh, block - be32_to_cpu(chain));
 		mark_buffer_dirty_inode(inode_bh, inode);
 		inode->i_nlink = 2;
-		spin_lock(&inode->i_lock);
-		inode->i_count++;
-		spin_unlock(&inode->i_lock);
+		iget(inode);
 	}
 	affs_fix_checksum(sb, bh);
 	mark_buffer_dirty_inode(bh, inode);
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index c50dc2a..517286c 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -114,9 +114,7 @@ struct file *anon_inode_getfile(const char *name,
 	 * so we can avoid doing an igrab() and we can use an open-coded
 	 * atomic_inc().
 	 */
-	spin_lock(&anon_inode_inode->i_lock);
-	anon_inode_inode->i_count++;
-	spin_unlock(&anon_inode_inode->i_lock);
+	iget(anon_inode_inode);
 
 	path.dentry->d_op = &anon_inodefs_dentry_operations;
 	d_instantiate(path.dentry, anon_inode_inode);
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index d42fc72..0a42a91 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -176,9 +176,7 @@ static int bfs_link(struct dentry *old, struct inode *dir,
 	inc_nlink(inode);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 	d_instantiate(new, inode);
 	mutex_unlock(&info->bfs_lock);
 	return 0;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 140451c..276a641 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -550,11 +550,7 @@ EXPORT_SYMBOL(bdget);
  */
 struct block_device *bdgrab(struct block_device *bdev)
 {
-	struct inode *inode = bdev->bd_inode;
-
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(bdev->bd_inode);
 
 	return bdev;
 }
@@ -585,9 +581,7 @@ static struct block_device *bd_acquire(struct inode *inode)
 	spin_lock(&bdev_lock);
 	bdev = inode->i_bdev;
 	if (bdev) {
-		spin_lock(&inode->i_lock);
-		bdev->bd_inode->i_count++;
-		spin_unlock(&inode->i_lock);
+		bdgrab(bdev);
 		spin_unlock(&bdev_lock);
 		return bdev;
 	}
@@ -603,9 +597,7 @@ static struct block_device *bd_acquire(struct inode *inode)
 			 * So, we can access it via ->i_mapping always
 			 * without igrab().
 			 */
-			spin_lock(&inode->i_lock);
-			bdev->bd_inode->i_count++;
-			spin_unlock(&inode->i_lock);
+			iget(bdev->bd_inode);
 			inode->i_bdev = bdev;
 			inode->i_mapping = bdev->bd_inode->i_mapping;
 			list_add(&inode->i_devices, &bdev->bd_inodes);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7675f0c..6664ddf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4769,9 +4769,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	}
 
 	btrfs_set_trans_block_group(trans, dir);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 
 	err = btrfs_add_nondir(trans, dentry, inode, 1, index);
 
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 2e52ad6..f97bc3b 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -303,9 +303,7 @@ static int coda_link(struct dentry *source_de, struct inode *dir_inode,
 	}
 
 	coda_dir_update_mtime(dir_inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 	d_instantiate(de, inode);
 	inc_nlink(inode);
 
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 0884447..af0b6da 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -24,7 +24,7 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		__iget(inode);
+		iget_ilock(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 3e7f967..fd0b9f2 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1156,9 +1156,7 @@ struct inode *exofs_new_inode(struct inode *dir, int mode)
 	/* increment the refcount so that the inode will still be around when we
 	 * reach the callback
 	 */
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 
 	ios->done = create_done;
 	ios->private = inode;
diff --git a/fs/exofs/namei.c b/fs/exofs/namei.c
index 506778a..9bdc11f 100644
--- a/fs/exofs/namei.c
+++ b/fs/exofs/namei.c
@@ -153,9 +153,7 @@ static int exofs_link(struct dentry *old_dentry, struct inode *dir,
 
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 
 	return exofs_add_nondir(dentry, inode);
 }
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index a5b9a54..499326b 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -206,9 +206,7 @@ static int ext2_link (struct dentry * old_dentry, struct inode * dir,
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 
 	err = ext2_add_link(dentry, inode);
 	if (!err) {
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 4e3b5ff..3742e5a 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2260,9 +2260,7 @@ retry:
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inc_nlink(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 
 	err = ext3_add_entry(handle, dentry, inode);
 	if (!err) {
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 4dbb5e5..9752c00 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2312,9 +2312,7 @@ retry:
 
 	inode->i_ctime = ext4_current_time(inode);
 	ext4_inc_count(handle, inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 
 	err = ext4_add_entry(handle, dentry, inode);
 	if (!err) {
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 348cc18..9c10fdc 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -294,7 +294,7 @@ static void inode_wait_for_writeback(struct inode *inode)
 
 /*
  * Write out an inode's dirty pages. Either the caller has ref on the inode
- * (either via __iget or via syscall against an fd) or the inode has
+ * (either via iget or via syscall against an fd) or the inode has
  * I_WILL_FREE set (via generic_forget_inode)
  *
  * If `wait' is set, wait on the writeout.
@@ -505,7 +505,7 @@ again:
 		}
 
 		BUG_ON(inode->i_state & I_FREEING);
-		__iget(inode);
+		iget_ilock(inode);
 		pages_skipped = wbc->pages_skipped;
 		writeback_single_inode(inode, wbc);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -1075,7 +1075,7 @@ static void wait_sb_inodes(struct super_block *sb)
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		__iget(inode);
+		iget_ilock(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
 		/*
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 49c38dc..4f1719a 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -253,9 +253,7 @@ out_parent:
 	gfs2_holder_uninit(ghs);
 	gfs2_holder_uninit(ghs + 1);
 	if (!error) {
-		spin_lock(&inode->i_lock);
-		inode->i_count++;
-		spin_unlock(&inode->i_lock);
+		iget(inode);
 		d_instantiate(dentry, inode);
 		mark_inode_dirty(inode);
 	}
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 55fa48d..f163fab 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -301,9 +301,7 @@ static int hfsplus_link(struct dentry *src_dentry, struct inode *dst_dir,
 
 	inc_nlink(inode);
 	hfsplus_instantiate(dst_dentry, inode, cnid);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 	HFSPLUS_SB(sb).file_count++;
diff --git a/fs/inode.c b/fs/inode.c
index a91efab..57eb850 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -533,7 +533,7 @@ again:
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
 			list_move(&inode->i_list, &inode_unused);
 			spin_unlock(&wb_inode_list_lock);
-			__iget(inode);
+			iget_ilock(inode);
 			spin_unlock(&inode->i_lock);
 
 			if (remove_inode_buffers(inode))
@@ -591,7 +591,7 @@ static struct shrinker icache_shrinker = {
 static void __wait_on_freeing_inode(struct inode *inode);
 /*
  * Called with the inode lock held.
- * NOTE: we are not increasing the inode-refcount, you must call __iget()
+ * NOTE: we are not increasing the inode-refcount, you must call iget_ilock()
  * by hand after calling find_inode now! This simplifies iunique and won't
  * add any additional branch in the common code.
  */
@@ -855,7 +855,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		__iget(old);
+		iget_ilock(old);
 		spin_unlock(&old->i_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -904,7 +904,7 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		__iget(old);
+		iget_ilock(old);
 		spin_unlock(&old->i_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -975,7 +975,7 @@ struct inode *igrab(struct inode *inode)
 
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_WILL_FREE))) {
-		__iget(inode);
+		iget_ilock(inode);
 	} else {
 		/*
 		 * Handle the case where s_op->clear_inode is not been
@@ -1018,7 +1018,7 @@ static struct inode *ifind(struct super_block *sb,
 
 	inode = find_inode(sb, b, test, data);
 	if (inode) {
-		__iget(inode);
+		iget_ilock(inode);
 		spin_unlock(&inode->i_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
@@ -1050,7 +1050,7 @@ static struct inode *ifind_fast(struct super_block *sb,
 
 	inode = find_inode_fast(sb, b, ino);
 	if (inode) {
-		__iget(inode);
+		iget_ilock(inode);
 		spin_unlock(&inode->i_lock);
 		wait_on_inode(inode);
 		return inode;
@@ -1239,7 +1239,7 @@ repeat:
 			return 0;
 		}
 		spin_unlock_bucket(b);
-		__iget(old);
+		iget_ilock(old);
 		spin_unlock(&old->i_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_bl_unhashed(&old->i_hash))) {
@@ -1284,7 +1284,7 @@ repeat:
 			return 0;
 		}
 		spin_unlock_bucket(b);
-		__iget(old);
+		iget_ilock(old);
 		spin_unlock(&old->i_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_bl_unhashed(&old->i_hash))) {
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 4d1bcfa..85f523b 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -289,9 +289,7 @@ static int jffs2_link (struct dentry *old_dentry, struct inode *dir_i, struct de
 		mutex_unlock(&f->sem);
 		d_instantiate(dentry, old_dentry->d_inode);
 		dir_i->i_mtime = dir_i->i_ctime = ITIME(now);
-		spin_lock(&old_dentry->d_inode->i_lock);
-		old_dentry->d_inode->i_count++;
-		spin_unlock(&old_dentry->d_inode->i_lock);
+		iget(old_dentry->d_inode);
 	}
 	return ret;
 }
@@ -866,9 +864,7 @@ static int jffs2_rename (struct inode *old_dir_i, struct dentry *old_dentry,
 		printk(KERN_NOTICE "jffs2_rename(): Link succeeded, unlink failed (err %d). You now have a hard link\n", ret);
 		/* Might as well let the VFS know */
 		d_instantiate(new_dentry, old_dentry->d_inode);
-		spin_lock(&old_dentry->d_inode->i_lock);
-		old_dentry->d_inode->i_count++;
-		spin_unlock(&old_dentry->d_inode->i_lock);
+		iget(old_dentry->d_inode);
 		new_dir_i->i_mtime = new_dir_i->i_ctime = ITIME(now);
 		return ret;
 	}
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 820212f..d5764b7 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -1279,9 +1279,7 @@ int txCommit(tid_t tid,		/* transaction identifier */
 	 * lazy commit thread finishes processing
 	 */
 	if (tblk->xflag & COMMIT_DELETE) {
-		spin_lock(&tblk->u.ip->i_lock);
-		tblk->u.ip->i_count++;
-		spin_unlock(&tblk->u.ip->i_lock);
+		iget(tblk->u.ip);
 		/*
 		 * Avoid a rare deadlock
 		 *
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 3259008..7b1c8ea 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -839,9 +839,7 @@ static int jfs_link(struct dentry *old_dentry,
 	ip->i_ctime = CURRENT_TIME;
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	mark_inode_dirty(dir);
-	spin_lock(&ip->i_lock);
-	ip->i_count++;
-	spin_unlock(&ip->i_lock);
+	iget(ip);
 
 	iplist[0] = ip;
 	iplist[1] = dir;
diff --git a/fs/libfs.c b/fs/libfs.c
index 0fa4dbe..1269ddb 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -255,9 +255,7 @@ int simple_link(struct dentry *old_dentry, struct inode *dir, struct dentry *den
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inc_nlink(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 	dget(dentry);
 	d_instantiate(dentry, inode);
 	return 0;
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 90eb51f..4a09080 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -569,9 +569,7 @@ static int logfs_link(struct dentry *old_dentry, struct inode *dir,
 		return -EMLINK;
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 	inode->i_nlink++;
 	mark_inode_dirty_sync(inode);
 
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index a4a160f..0d5a830 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -101,9 +101,7 @@ static int minix_link(struct dentry * old_dentry, struct inode * dir,
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 	return add_nondir(dentry, inode);
 }
 
diff --git a/fs/namei.c b/fs/namei.c
index 817d6bb..e905661 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2290,11 +2290,8 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 		if (nd.last.name[nd.last.len])
 			goto slashes;
 		inode = dentry->d_inode;
-		if (inode) {
-			spin_lock(&inode->i_lock);
-			inode->i_count++;
-			spin_unlock(&inode->i_lock);
-		}
+		if (inode)
+			iget(inode);
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 375b6b5..c1435a9 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1580,9 +1580,7 @@ nfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 	d_drop(dentry);
 	error = NFS_PROTO(dir)->link(inode, dir, &dentry->d_name);
 	if (error == 0) {
-		spin_lock(&inode->i_lock);
-		inode->i_count++;
-		spin_unlock(&inode->i_lock);
+		iget(inode);
 		d_add(dentry, inode);
 	}
 	return error;
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index c6db37e..89e4ab8 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -54,10 +54,8 @@ static int nfs_superblock_set_dummy_root(struct super_block *sb, struct inode *i
 			iput(inode);
 			return -ENOMEM;
 		}
-		/* Circumvent igrab(): we know the inode is not being freed */
-		spin_lock(&inode->i_lock);
-		inode->i_count++;
-		spin_unlock(&inode->i_lock);
+		/* We know the inode is not being freed */
+		iget(inode);
 		/*
 		 * Ensure that this dentry is invisible to d_find_alias().
 		 * Otherwise, it may be spliced into the tree by
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 129ebaa..346a9db 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -390,7 +390,7 @@ static int nfs_inode_add_request(struct inode *inode, struct nfs_page *req)
 	error = radix_tree_insert(&nfsi->nfs_page_tree, req->wb_index, req);
 	BUG_ON(error);
 	if (!nfsi->npages) {
-		__iget(inode);
+		iget_ilock(inode);
 		if (nfs_have_delegation(inode, FMODE_WRITE))
 			nfsi->change_attr++;
 	}
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 9e287ea..99dedf3 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -219,9 +219,7 @@ static int nilfs_link(struct dentry *old_dentry, struct inode *dir,
 
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 
 	err = nilfs_add_nondir(dentry, inode);
 	if (!err)
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index e51d065..ecc8c18 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -244,7 +244,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 
 		spin_lock(&inode->i_lock);
 		/*
-		 * We cannot __iget() an inode in state I_FREEING,
+		 * We cannot iget() an inode in state I_FREEING,
 		 * I_WILL_FREE, or I_NEW which is fine because by that point
 		 * the inode cannot have any associated watches.
 		 */
@@ -255,7 +255,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 
 		/*
 		 * If i_count is zero, the inode cannot have any watches and
-		 * doing an __iget/iput with MS_ACTIVE clear would actually
+		 * doing an iget/iput with MS_ACTIVE clear would actually
 		 * evict all inodes with zero i_count from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
@@ -269,7 +269,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 
 		/* In case fsnotify_inode_delete() drops a reference. */
 		if (inode != need_iput_tmp) {
-			__iget(inode);
+			iget_ilock(inode);
 		} else
 			need_iput_tmp = NULL;
 		spin_unlock(&inode->i_lock);
@@ -279,7 +279,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 			spin_lock(&next_i->i_lock);
 			if (next_i->i_count &&
 			    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
-				__iget(next_i);
+				iget_ilock(next_i);
 				need_iput = next_i;
 			}
 			spin_unlock(&next_i->i_lock);
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 2e380ba..a0e45f3 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2930,9 +2930,7 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 	}
 	if ((sb->s_root = d_alloc_root(vol->root_ino))) {
 		/* We increment i_count simulating an ntfs_iget(). */
-		spin_lock(&vol->root_ino->i_lock);
-		vol->root_ino->i_count++;
-		spin_unlock(&vol->root_ino->i_lock);
+		iget(vol->root_ino);
 		ntfs_debug("Exiting, status successful.");
 		/* Release the default upcase if it has no users. */
 		mutex_lock(&ntfs_lock);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 9c46feb..d2d972b 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -741,9 +741,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 		goto out_commit;
 	}
 
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 	dentry->d_op = &ocfs2_dentry_ops;
 	d_instantiate(dentry, inode);
 
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 69bc754..697bd6e 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -910,7 +910,7 @@ static void add_dquot_ref(struct super_block *sb, int type)
 			reserved = 1;
 #endif
 
-		__iget(inode);
+		iget_ilock(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
 
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index 1efebb2..1de28a0 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -1156,9 +1156,7 @@ static int reiserfs_link(struct dentry *old_dentry, struct inode *dir,
 	inode->i_ctime = CURRENT_TIME_SEC;
 	reiserfs_update_sd(&th, inode);
 
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 	d_instantiate(dentry, inode);
 	retval = journal_end(&th, dir->i_sb, jbegin_count);
 	reiserfs_write_unlock(dir->i_sb);
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index d63da9b..1620948 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -126,9 +126,7 @@ static int sysv_link(struct dentry * old_dentry, struct inode * dir,
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 
 	return add_nondir(dentry, inode);
 }
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index c204b5c..7ccb249 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -550,9 +550,7 @@ static int ubifs_link(struct dentry *old_dentry, struct inode *dir,
 
 	lock_2_inodes(dir, inode);
 	inc_nlink(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 	inode->i_ctime = ubifs_current_time(inode);
 	dir->i_size += sz_change;
 	dir_ui->ui_size = dir->i_size;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index d8b0dc8..acd070b 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1101,9 +1101,7 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
 	inc_nlink(inode);
 	inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 	d_instantiate(dentry, inode);
 	unlock_kernel();
 
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index 8cbf920..f6e9232 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -180,9 +180,7 @@ static int ufs_link (struct dentry * old_dentry, struct inode * dir,
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 
 	error = ufs_add_nondir(dentry, inode);
 	unlock_kernel();
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 332cdf5..8e9652f 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -352,9 +352,7 @@ xfs_vn_link(
 	if (unlikely(error))
 		return -error;
 
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 	d_instantiate(dentry, inode);
 	return 0;
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 859628b..820a791 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -481,10 +481,8 @@ void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 
 #define IHOLD(ip) \
 do { \
-	spin_lock(&VFS_I(ip)->i_lock); \
 	ASSERT(VFS_I(ip)->i_count > 0) ; \
-	VFS_I(ip)->i_count++; \
-	spin_unlock(&VFS_I(ip)->i_lock); \
+	iget(VFS_I(ip)); \
 	trace_xfs_ihold(ip, _THIS_IP_); \
 } while (0)
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d2ee5d0..b07847c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2394,12 +2394,20 @@ extern int generic_show_options(struct seq_file *m, struct vfsmount *mnt);
 extern void save_mount_options(struct super_block *sb, char *options);
 extern void replace_mount_options(struct super_block *sb, char *options);
 
-static inline void __iget(struct inode *inode)
+static inline void iget_ilock(struct inode *inode)
 {
 	assert_spin_locked(&inode->i_lock);
+	BUG_ON(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE));
 	inode->i_count++;
 }
 
+static inline void iget(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	iget_ilock(inode);
+	spin_unlock(&inode->i_lock);
+}
+
 static inline ino_t parent_ino(struct dentry *dentry)
 {
 	ino_t res;
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 7fe9efb..625dcfa 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -768,11 +768,8 @@ SYSCALL_DEFINE1(mq_unlink, const char __user *, u_name)
 	}
 
 	inode = dentry->d_inode;
-	if (inode) {
-		spin_lock(&inode->i_lock);
-		inode->i_count++;
-		spin_unlock(&inode->i_lock);
-	}
+	if (inode)
+		iget(inode);
 	err = mnt_want_write(ipc_ns->mq_mnt);
 	if (err)
 		goto out_err;
diff --git a/kernel/futex.c b/kernel/futex.c
index e9dfa00..b587a8b 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -168,9 +168,7 @@ static void get_futex_key_refs(union futex_key *key)
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		spin_lock(&key->shared.inode->i_lock);
-		key->shared.inode->i_count++;
-		spin_unlock(&key->shared.inode->i_lock);
+		iget(key->shared.inode);
 		break;
 	case FUT_OFF_MMSHARED:
 		atomic_inc(&key->private.mm->mm_count);
diff --git a/mm/shmem.c b/mm/shmem.c
index b83b442..b24943a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1903,9 +1903,7 @@ static int shmem_link(struct dentry *old_dentry, struct inode *dir, struct dentr
 	dir->i_size += BOGO_DIRENT_SIZE;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inc_nlink(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;	/* New dentry reference */
-	spin_unlock(&inode->i_lock);
+	iget(inode);
 	dget(dentry);		/* Extra pinning count for the created dentry */
 	d_instantiate(dentry, inode);
 out:
diff --git a/net/socket.c b/net/socket.c
index 5431af1..c5afc82 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -377,9 +377,7 @@ static int sock_alloc_file(struct socket *sock, struct file **f, int flags)
 		  &socket_file_ops);
 	if (unlikely(!file)) {
 		/* drop dentry, keep inode */
-		spin_lock(&path.dentry->d_inode->i_lock);
-		path.dentry->d_inode->i_count++;
-		spin_unlock(&path.dentry->d_inode->i_lock);
+		iget(path.dentry->d_inode);
 		path_put(&path);
 		put_unused_fd(fd);
 		return -ENFILE;
-- 
1.7.1

