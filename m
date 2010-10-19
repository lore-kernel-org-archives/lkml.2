Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710Ab0JSD4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:56:24 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28439 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933673Ab0JSD4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaCeIJRBIpKhQA
Message-Id: <20101019034658.963540555@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:49 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 33/35] fs: icache introduce inode_get/inode_get_ilock
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode-rationalize-iget.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor open coded inode lock, increment, unlock into a function inode_get().
Rename __iget to inode_get_ilock.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/9p/vfs_inode.c           |    4 +---
 fs/affs/inode.c             |    4 +---
 fs/afs/dir.c                |    4 +---
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
 45 files changed, 72 insertions(+), 150 deletions(-)

Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/drop_caches.c	2010-10-19 14:19:00.000000000 +1100
@@ -24,7 +24,7 @@
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		__iget(inode);
+		inode_get_ilock(inode);
 		spin_unlock(&inode->i_lock);
 		rcu_read_unlock();
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:16.000000000 +1100
@@ -288,7 +288,7 @@
 
 /*
  * Write out an inode's dirty pages. Either the caller has ref on the inode
- * (either via __iget or via syscall against an fd) or the inode has
+ * (either via inode_get or via syscall against an fd) or the inode has
  * I_WILL_FREE set (via generic_forget_inode)
  *
  * If `wait' is set, wait on the writeout.
@@ -511,7 +511,7 @@
 		}
 
 		BUG_ON(inode->i_state & I_FREEING);
-		__iget(inode);
+		inode_get_ilock(inode);
 		pages_skipped = wbc->pages_skipped;
 		writeback_single_inode(wb, inode, wbc);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -1089,7 +1089,7 @@
 			continue;
 		}
 
- 		__iget(inode);
+ 		inode_get_ilock(inode);
 		spin_unlock(&inode->i_lock);
 		rcu_read_unlock();
 		/*
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:16.000000000 +1100
@@ -603,7 +603,7 @@
 			 */
 			list_move(&inode->i_lru, &zone->inode_lru);
 			spin_unlock(&zone->inode_lru_lock);
-			__iget(inode);
+			inode_get_ilock(inode);
 			spin_unlock(&inode->i_lock);
 
 			if (remove_inode_buffers(inode))
@@ -682,7 +682,7 @@
 static void __wait_on_freeing_inode(struct inode *inode);
 /*
  * Called with the inode lock held.
- * NOTE: we are not increasing the inode-refcount, you must call __iget()
+ * NOTE: we are not increasing the inode-refcount, you must call inode_get_ilock()
  * by hand after calling find_inode now! This simplifies iunique and won't
  * add any additional branch in the common code.
  */
@@ -1023,7 +1023,7 @@
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		__iget(old);
+		inode_get_ilock(old);
 		spin_unlock(&old->i_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -1070,7 +1070,7 @@
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		__iget(old);
+		inode_get_ilock(old);
 		spin_unlock(&old->i_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -1145,7 +1145,7 @@
 
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_WILL_FREE)))
-		__iget(inode);
+		inode_get_ilock(inode);
 	else
 		/*
 		 * Handle the case where s_op->clear_inode is not been
@@ -1187,7 +1187,7 @@
 
 	inode = find_inode(sb, b, test, data);
 	if (inode) {
-		__iget(inode);
+		inode_get_ilock(inode);
 		spin_unlock(&inode->i_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
@@ -1219,7 +1219,7 @@
 
 	inode = find_inode_fast(sb, b, ino);
 	if (inode) {
-		__iget(inode);
+		inode_get_ilock(inode);
 		spin_unlock(&inode->i_lock);
 		wait_on_inode(inode);
 		return inode;
@@ -1408,7 +1408,7 @@
 
 found_old:
 	spin_unlock_bucket(b);
-	__iget(old);
+	inode_get_ilock(old);
 	spin_unlock(&old->i_lock);
 	wait_on_inode(old);
 	if (unlikely(!hlist_bl_unhashed(&old->i_hash))) {
@@ -1453,7 +1453,7 @@
 
 found_old:
 	spin_unlock_bucket(b);
-	__iget(old);
+	inode_get_ilock(old);
 	spin_unlock(&old->i_lock);
 	wait_on_inode(old);
 	if (unlikely(!hlist_bl_unhashed(&old->i_hash))) {
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-19 14:19:15.000000000 +1100
@@ -2462,12 +2462,20 @@
 extern void save_mount_options(struct super_block *sb, char *options);
 extern void replace_mount_options(struct super_block *sb, char *options);
 
-static inline void __iget(struct inode *inode)
+static inline void inode_get_ilock(struct inode *inode)
 {
 	assert_spin_locked(&inode->i_lock);
+	BUG_ON(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE));
 	inode->i_count++;
 }
 
+static inline void inode_get(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	inode_get_ilock(inode);
+	spin_unlock(&inode->i_lock);
+}
+
 static inline ino_t parent_ino(struct dentry *dentry)
 {
 	ino_t res;
Index: linux-2.6/fs/nfs/write.c
===================================================================
--- linux-2.6.orig/fs/nfs/write.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/nfs/write.c	2010-10-19 14:19:00.000000000 +1100
@@ -390,7 +390,7 @@
 	error = radix_tree_insert(&nfsi->nfs_page_tree, req->wb_index, req);
 	BUG_ON(error);
 	if (!nfsi->npages) {
-		__iget(inode);
+		inode_get_ilock(inode);
 		if (nfs_have_delegation(inode, FMODE_WRITE))
 			nfsi->change_attr++;
 	}
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/notify/inode_mark.c	2010-10-19 14:19:16.000000000 +1100
@@ -245,7 +245,7 @@
 
 		spin_lock(&inode->i_lock);
 		/*
-		 * We cannot __iget() an inode in state I_FREEING,
+		 * We cannot inode_get() an inode in state I_FREEING,
 		 * I_WILL_FREE, or I_NEW which is fine because by that point
 		 * the inode cannot have any associated watches.
 		 */
@@ -256,7 +256,7 @@
 
 		/*
 		 * If i_count is zero, the inode cannot have any watches and
-		 * doing an __iget/iput with MS_ACTIVE clear would actually
+		 * doing an inode_get/iput with MS_ACTIVE clear would actually
 		 * evict all inodes with zero i_count from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
@@ -270,7 +270,7 @@
 
 		/* In case fsnotify_inode_delete() drops a reference. */
 		if (inode != need_iput_tmp)
-			__iget(inode);
+			inode_get_ilock(inode);
 		else
 			need_iput_tmp = NULL;
 		spin_unlock(&inode->i_lock);
@@ -280,7 +280,7 @@
 			spin_lock(&next_i->i_lock);
 			if (next_i->i_count &&
 			    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
-				__iget(next_i);
+				inode_get_ilock(next_i);
 				need_iput = next_i;
 			}
 			spin_unlock(&next_i->i_lock);
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/quota/dquot.c	2010-10-19 14:19:00.000000000 +1100
@@ -917,7 +917,7 @@
 			continue;
 		}
 
-		__iget(inode);
+		inode_get_ilock(inode);
 		spin_unlock(&inode->i_lock);
 		rcu_read_unlock();
 
Index: linux-2.6/fs/affs/inode.c
===================================================================
--- linux-2.6.orig/fs/affs/inode.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/affs/inode.c	2010-10-19 14:19:00.000000000 +1100
@@ -388,9 +388,7 @@
 		affs_adjust_checksum(inode_bh, block - be32_to_cpu(chain));
 		mark_buffer_dirty_inode(inode_bh, inode);
 		inode->i_nlink = 2;
-		spin_lock(&inode->i_lock);
-		inode->i_count++;
-		spin_unlock(&inode->i_lock);
+		inode_get(inode);
 	}
 	affs_fix_checksum(sb, bh);
 	mark_buffer_dirty_inode(bh, inode);
Index: linux-2.6/fs/anon_inodes.c
===================================================================
--- linux-2.6.orig/fs/anon_inodes.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/anon_inodes.c	2010-10-19 14:19:00.000000000 +1100
@@ -114,9 +114,7 @@
 	 * so we can avoid doing an igrab() and we can use an open-coded
 	 * atomic_inc().
 	 */
-	spin_lock(&anon_inode_inode->i_lock);
-	anon_inode_inode->i_count++;
-	spin_unlock(&anon_inode_inode->i_lock);
+	inode_get(anon_inode_inode);
 
 	path.dentry->d_op = &anon_inodefs_dentry_operations;
 	d_instantiate(path.dentry, anon_inode_inode);
Index: linux-2.6/fs/bfs/dir.c
===================================================================
--- linux-2.6.orig/fs/bfs/dir.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/bfs/dir.c	2010-10-19 14:19:00.000000000 +1100
@@ -176,9 +176,7 @@
 	inc_nlink(inode);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 	d_instantiate(new, inode);
 	mutex_unlock(&info->bfs_lock);
 	return 0;
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/block_dev.c	2010-10-19 14:19:16.000000000 +1100
@@ -557,11 +557,7 @@
  */
 struct block_device *bdgrab(struct block_device *bdev)
 {
-	struct inode *inode = bdev->bd_inode;
-
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(bdev->bd_inode);
 
 	return bdev;
 }
@@ -592,9 +588,7 @@
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
@@ -610,9 +604,7 @@
 			 * So, we can access it via ->i_mapping always
 			 * without igrab().
 			 */
-			spin_lock(&inode->i_lock);
-			bdev->bd_inode->i_count++;
-			spin_unlock(&inode->i_lock);
+			inode_get(bdev->bd_inode);
 			inode->i_bdev = bdev;
 			inode->i_mapping = bdev->bd_inode->i_mapping;
 			list_add(&inode->i_devices, &bdev->bd_inodes);
Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/btrfs/inode.c	2010-10-19 14:19:16.000000000 +1100
@@ -4763,9 +4763,7 @@
 	}
 
 	btrfs_set_trans_block_group(trans, dir);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 
 	err = btrfs_add_nondir(trans, dentry, inode, 1, index);
 
Index: linux-2.6/fs/coda/dir.c
===================================================================
--- linux-2.6.orig/fs/coda/dir.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/coda/dir.c	2010-10-19 14:19:00.000000000 +1100
@@ -303,9 +303,7 @@
 	}
 
 	coda_dir_update_mtime(dir_inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 	d_instantiate(de, inode);
 	inc_nlink(inode);
 
Index: linux-2.6/fs/exofs/inode.c
===================================================================
--- linux-2.6.orig/fs/exofs/inode.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/exofs/inode.c	2010-10-19 14:19:16.000000000 +1100
@@ -1162,9 +1162,7 @@
 	/* increment the refcount so that the inode will still be around when we
 	 * reach the callback
 	 */
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 
 	ios->done = create_done;
 	ios->private = inode;
Index: linux-2.6/fs/exofs/namei.c
===================================================================
--- linux-2.6.orig/fs/exofs/namei.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/exofs/namei.c	2010-10-19 14:19:00.000000000 +1100
@@ -153,9 +153,7 @@
 
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 
 	return exofs_add_nondir(dentry, inode);
 }
Index: linux-2.6/fs/ext2/namei.c
===================================================================
--- linux-2.6.orig/fs/ext2/namei.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/ext2/namei.c	2010-10-19 14:19:00.000000000 +1100
@@ -206,9 +206,7 @@
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 
 	err = ext2_add_link(dentry, inode);
 	if (!err) {
Index: linux-2.6/fs/ext3/namei.c
===================================================================
--- linux-2.6.orig/fs/ext3/namei.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/ext3/namei.c	2010-10-19 14:19:00.000000000 +1100
@@ -2260,9 +2260,7 @@
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inc_nlink(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 
 	err = ext3_add_entry(handle, dentry, inode);
 	if (!err) {
Index: linux-2.6/fs/ext4/namei.c
===================================================================
--- linux-2.6.orig/fs/ext4/namei.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/ext4/namei.c	2010-10-19 14:19:00.000000000 +1100
@@ -2312,9 +2312,7 @@
 
 	inode->i_ctime = ext4_current_time(inode);
 	ext4_inc_count(handle, inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 
 	err = ext4_add_entry(handle, dentry, inode);
 	if (!err) {
Index: linux-2.6/fs/gfs2/ops_inode.c
===================================================================
--- linux-2.6.orig/fs/gfs2/ops_inode.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/gfs2/ops_inode.c	2010-10-19 14:19:00.000000000 +1100
@@ -253,9 +253,7 @@
 	gfs2_holder_uninit(ghs);
 	gfs2_holder_uninit(ghs + 1);
 	if (!error) {
-		spin_lock(&inode->i_lock);
-		inode->i_count++;
-		spin_unlock(&inode->i_lock);
+		inode_get(inode);
 		d_instantiate(dentry, inode);
 		mark_inode_dirty(inode);
 	}
Index: linux-2.6/fs/hfsplus/dir.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/dir.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/hfsplus/dir.c	2010-10-19 14:19:00.000000000 +1100
@@ -301,9 +301,7 @@
 
 	inc_nlink(inode);
 	hfsplus_instantiate(dst_dentry, inode, cnid);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 	HFSPLUS_SB(sb).file_count++;
Index: linux-2.6/fs/jffs2/dir.c
===================================================================
--- linux-2.6.orig/fs/jffs2/dir.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/jffs2/dir.c	2010-10-19 14:19:00.000000000 +1100
@@ -289,9 +289,7 @@
 		mutex_unlock(&f->sem);
 		d_instantiate(dentry, old_dentry->d_inode);
 		dir_i->i_mtime = dir_i->i_ctime = ITIME(now);
-		spin_lock(&old_dentry->d_inode->i_lock);
-		old_dentry->d_inode->i_count++;
-		spin_unlock(&old_dentry->d_inode->i_lock);
+		inode_get(old_dentry->d_inode);
 	}
 	return ret;
 }
@@ -866,9 +864,7 @@
 		printk(KERN_NOTICE "jffs2_rename(): Link succeeded, unlink failed (err %d). You now have a hard link\n", ret);
 		/* Might as well let the VFS know */
 		d_instantiate(new_dentry, old_dentry->d_inode);
-		spin_lock(&old_dentry->d_inode->i_lock);
-		old_dentry->d_inode->i_count++;
-		spin_unlock(&old_dentry->d_inode->i_lock);
+		inode_get(old_dentry->d_inode);
 		new_dir_i->i_mtime = new_dir_i->i_ctime = ITIME(now);
 		return ret;
 	}
Index: linux-2.6/fs/jfs/jfs_txnmgr.c
===================================================================
--- linux-2.6.orig/fs/jfs/jfs_txnmgr.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/jfs/jfs_txnmgr.c	2010-10-19 14:19:00.000000000 +1100
@@ -1279,9 +1279,7 @@
 	 * lazy commit thread finishes processing
 	 */
 	if (tblk->xflag & COMMIT_DELETE) {
-		spin_lock(&tblk->u.ip->i_lock);
-		tblk->u.ip->i_count++;
-		spin_unlock(&tblk->u.ip->i_lock);
+		inode_get(tblk->u.ip);
 		/*
 		 * Avoid a rare deadlock
 		 *
Index: linux-2.6/fs/jfs/namei.c
===================================================================
--- linux-2.6.orig/fs/jfs/namei.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/jfs/namei.c	2010-10-19 14:19:00.000000000 +1100
@@ -839,9 +839,7 @@
 	ip->i_ctime = CURRENT_TIME;
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	mark_inode_dirty(dir);
-	spin_lock(&ip->i_lock);
-	ip->i_count++;
-	spin_unlock(&ip->i_lock);
+	inode_get(ip);
 
 	iplist[0] = ip;
 	iplist[1] = dir;
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/libfs.c	2010-10-19 14:19:00.000000000 +1100
@@ -255,9 +255,7 @@
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inc_nlink(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 	dget(dentry);
 	d_instantiate(dentry, inode);
 	return 0;
Index: linux-2.6/fs/logfs/dir.c
===================================================================
--- linux-2.6.orig/fs/logfs/dir.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/logfs/dir.c	2010-10-19 14:19:00.000000000 +1100
@@ -569,9 +569,7 @@
 		return -EMLINK;
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 	inode->i_nlink++;
 	mark_inode_dirty_sync(inode);
 
Index: linux-2.6/fs/minix/namei.c
===================================================================
--- linux-2.6.orig/fs/minix/namei.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/minix/namei.c	2010-10-19 14:19:00.000000000 +1100
@@ -101,9 +101,7 @@
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 	return add_nondir(dentry, inode);
 }
 
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/namei.c	2010-10-19 14:19:00.000000000 +1100
@@ -2290,11 +2290,8 @@
 		if (nd.last.name[nd.last.len])
 			goto slashes;
 		inode = dentry->d_inode;
-		if (inode) {
-			spin_lock(&inode->i_lock);
-			inode->i_count++;
-			spin_unlock(&inode->i_lock);
-		}
+		if (inode)
+			inode_get(inode);
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/nfs/dir.c	2010-10-19 14:19:00.000000000 +1100
@@ -1580,9 +1580,7 @@
 	d_drop(dentry);
 	error = NFS_PROTO(dir)->link(inode, dir, &dentry->d_name);
 	if (error == 0) {
-		spin_lock(&inode->i_lock);
-		inode->i_count++;
-		spin_unlock(&inode->i_lock);
+		inode_get(inode);
 		d_add(dentry, inode);
 	}
 	return error;
Index: linux-2.6/fs/nfs/getroot.c
===================================================================
--- linux-2.6.orig/fs/nfs/getroot.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/nfs/getroot.c	2010-10-19 14:19:00.000000000 +1100
@@ -54,10 +54,8 @@
 			iput(inode);
 			return -ENOMEM;
 		}
-		/* Circumvent igrab(): we know the inode is not being freed */
-		spin_lock(&inode->i_lock);
-		inode->i_count++;
-		spin_unlock(&inode->i_lock);
+		/* We know the inode is not being freed */
+		inode_get(inode);
 		/*
 		 * Ensure that this dentry is invisible to d_find_alias().
 		 * Otherwise, it may be spliced into the tree by
Index: linux-2.6/fs/nilfs2/namei.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/namei.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/nilfs2/namei.c	2010-10-19 14:19:00.000000000 +1100
@@ -219,9 +219,7 @@
 
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 
 	err = nilfs_add_nondir(dentry, inode);
 	if (!err)
Index: linux-2.6/fs/ntfs/super.c
===================================================================
--- linux-2.6.orig/fs/ntfs/super.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/ntfs/super.c	2010-10-19 14:19:16.000000000 +1100
@@ -2930,9 +2930,7 @@
 	}
 	if ((sb->s_root = d_alloc_root(vol->root_ino))) {
 		/* We increment i_count simulating an ntfs_iget(). */
-		spin_lock(&vol->root_ino->i_lock);
-		vol->root_ino->i_count++;
-		spin_unlock(&vol->root_ino->i_lock);
+		inode_get(vol->root_ino);
 		ntfs_debug("Exiting, status successful.");
 		/* Release the default upcase if it has no users. */
 		mutex_lock(&ntfs_lock);
Index: linux-2.6/fs/ocfs2/namei.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/namei.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/ocfs2/namei.c	2010-10-19 14:19:00.000000000 +1100
@@ -741,9 +741,7 @@
 		goto out_commit;
 	}
 
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 	dentry->d_op = &ocfs2_dentry_ops;
 	d_instantiate(dentry, inode);
 
Index: linux-2.6/fs/reiserfs/namei.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/namei.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/reiserfs/namei.c	2010-10-19 14:19:00.000000000 +1100
@@ -1156,9 +1156,7 @@
 	inode->i_ctime = CURRENT_TIME_SEC;
 	reiserfs_update_sd(&th, inode);
 
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 	d_instantiate(dentry, inode);
 	retval = journal_end(&th, dir->i_sb, jbegin_count);
 	reiserfs_write_unlock(dir->i_sb);
Index: linux-2.6/fs/sysv/namei.c
===================================================================
--- linux-2.6.orig/fs/sysv/namei.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/sysv/namei.c	2010-10-19 14:19:00.000000000 +1100
@@ -126,9 +126,7 @@
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 
 	return add_nondir(dentry, inode);
 }
Index: linux-2.6/fs/ubifs/dir.c
===================================================================
--- linux-2.6.orig/fs/ubifs/dir.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/ubifs/dir.c	2010-10-19 14:19:00.000000000 +1100
@@ -550,9 +550,7 @@
 
 	lock_2_inodes(dir, inode);
 	inc_nlink(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 	inode->i_ctime = ubifs_current_time(inode);
 	dir->i_size += sz_change;
 	dir_ui->ui_size = dir->i_size;
Index: linux-2.6/fs/udf/namei.c
===================================================================
--- linux-2.6.orig/fs/udf/namei.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/udf/namei.c	2010-10-19 14:19:00.000000000 +1100
@@ -1101,9 +1101,7 @@
 	inc_nlink(inode);
 	inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 	d_instantiate(dentry, inode);
 	unlock_kernel();
 
Index: linux-2.6/fs/ufs/namei.c
===================================================================
--- linux-2.6.orig/fs/ufs/namei.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/ufs/namei.c	2010-10-19 14:19:00.000000000 +1100
@@ -180,9 +180,7 @@
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 
 	error = ufs_add_nondir(dentry, inode);
 	unlock_kernel();
Index: linux-2.6/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_iops.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_iops.c	2010-10-19 14:19:00.000000000 +1100
@@ -352,9 +352,7 @@
 	if (unlikely(error))
 		return -error;
 
-	spin_lock(&inode->i_lock);
-	inode->i_count++;
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 	d_instantiate(dentry, inode);
 	return 0;
 }
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/xfs/xfs_inode.h	2010-10-19 14:19:16.000000000 +1100
@@ -481,10 +481,8 @@
 
 #define IHOLD(ip) \
 do { \
-	spin_lock(&VFS_I(ip)->i_lock); \
 	ASSERT(VFS_I(ip)->i_count > 0) ; \
-	VFS_I(ip)->i_count++; \
-	spin_unlock(&VFS_I(ip)->i_lock); \
+	inode_get(VFS_I(ip)); \
 	trace_xfs_ihold(ip, _THIS_IP_); \
 } while (0)
 
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/ipc/mqueue.c	2010-10-19 14:19:00.000000000 +1100
@@ -775,11 +775,8 @@
 	}
 
 	inode = dentry->d_inode;
-	if (inode) {
-		spin_lock(&inode->i_lock);
-		inode->i_count++;
-		spin_unlock(&inode->i_lock);
-	}
+	if (inode)
+		inode_get(inode);
 	err = mnt_want_write(ipc_ns->mq_mnt);
 	if (err)
 		goto out_err;
Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/kernel/futex.c	2010-10-19 14:19:00.000000000 +1100
@@ -168,9 +168,7 @@
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		spin_lock(&key->shared.inode->i_lock);
-		key->shared.inode->i_count++;
-		spin_unlock(&key->shared.inode->i_lock);
+		inode_get(key->shared.inode);
 		break;
 	case FUT_OFF_MMSHARED:
 		atomic_inc(&key->private.mm->mm_count);
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/mm/shmem.c	2010-10-19 14:19:00.000000000 +1100
@@ -1903,9 +1903,7 @@
 	dir->i_size += BOGO_DIRENT_SIZE;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inc_nlink(inode);
-	spin_lock(&inode->i_lock);
-	inode->i_count++;	/* New dentry reference */
-	spin_unlock(&inode->i_lock);
+	inode_get(inode);
 	dget(dentry);		/* Extra pinning count for the created dentry */
 	d_instantiate(dentry, inode);
 out:
Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/net/socket.c	2010-10-19 14:19:00.000000000 +1100
@@ -378,9 +378,7 @@
 		  &socket_file_ops);
 	if (unlikely(!file)) {
 		/* drop dentry, keep inode */
-		spin_lock(&path.dentry->d_inode->i_lock);
-		path.dentry->d_inode->i_count++;
-		spin_unlock(&path.dentry->d_inode->i_lock);
+		inode_get(path.dentry->d_inode);
 		path_put(&path);
 		put_unused_fd(fd);
 		return -ENFILE;
Index: linux-2.6/fs/9p/vfs_inode.c
===================================================================
--- linux-2.6.orig/fs/9p/vfs_inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/9p/vfs_inode.c	2010-10-19 14:19:16.000000000 +1100
@@ -1798,9 +1798,7 @@
 		/* Caching disabled. No need to get upto date stat info.
 		 * This dentry will be released immediately. So, just i_count++
 		 */
-		spin_lock(&old_dentry->d_inode->i_lock);
-		old_dentry->d_inode->i_count++;
-		spin_unlock(&old_dentry->d_inode->i_lock);
+		inode_get(old_dentry->d_inode);
 	}
 
 	dentry->d_op = old_dentry->d_op;
Index: linux-2.6/fs/afs/dir.c
===================================================================
--- linux-2.6.orig/fs/afs/dir.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/afs/dir.c	2010-10-19 14:19:00.000000000 +1100
@@ -1045,9 +1045,7 @@
 	if (ret < 0)
 		goto link_error;
 
-	spin_lock(&vnode->vfs_inode.i_lock);
-	vnode->vfs_inode.i_count++;
-	spin_unlock(&vnode->vfs_inode.i_lock);
+	inode_get(&vnode->vfs_inode);
 	d_instantiate(dentry, &vnode->vfs_inode);
 	key_put(key);
 	_leave(" = 0");


