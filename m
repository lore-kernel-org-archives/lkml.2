Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab0JUNZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:25:37 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:50996 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757951Ab0JUNWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+CeYJRBIpNhQE
Message-Id: <20101021131016.103895484@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:31 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 02/14] fs: icache lock i_count
References: <20101021130829.442910807@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect inode->i_count with i_lock, rather than having it atomic. This
requires some ugliness until lazy lru is implemented.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 arch/powerpc/platforms/cell/spufs/file.c |    2 
 drivers/staging/pohmelfs/inode.c         |   10 +--
 fs/9p/vfs_inode.c                        |    2 
 fs/affs/inode.c                          |    2 
 fs/afs/dir.c                             |    2 
 fs/anon_inodes.c                         |    2 
 fs/bfs/dir.c                             |    2 
 fs/block_dev.c                           |    7 +-
 fs/btrfs/inode.c                         |   15 +++--
 fs/ceph/mds_client.c                     |    2 
 fs/cifs/inode.c                          |    2 
 fs/coda/dir.c                            |    2 
 fs/drop_caches.c                         |    2 
 fs/exofs/inode.c                         |   10 ++-
 fs/exofs/namei.c                         |    2 
 fs/ext2/namei.c                          |    2 
 fs/ext3/ialloc.c                         |    4 -
 fs/ext3/namei.c                          |    2 
 fs/ext4/ialloc.c                         |    4 -
 fs/ext4/namei.c                          |    2 
 fs/fs-writeback.c                        |   12 ++--
 fs/gfs2/ops_inode.c                      |    2 
 fs/hfsplus/dir.c                         |    2 
 fs/hpfs/inode.c                          |    2 
 fs/inode.c                               |   78 ++++++++++++++++++++++---------
 fs/jffs2/dir.c                           |    4 -
 fs/jfs/jfs_txnmgr.c                      |    2 
 fs/jfs/namei.c                           |    2 
 fs/libfs.c                               |    2 
 fs/locks.c                               |    4 -
 fs/logfs/dir.c                           |    2 
 fs/logfs/readwrite.c                     |    2 
 fs/minix/namei.c                         |    2 
 fs/namei.c                               |    2 
 fs/nfs/dir.c                             |    2 
 fs/nfs/getroot.c                         |    4 -
 fs/nfs/inode.c                           |    4 -
 fs/nfs/nfs4state.c                       |    2 
 fs/nfs/write.c                           |    2 
 fs/nilfs2/mdt.c                          |    2 
 fs/nilfs2/namei.c                        |    2 
 fs/notify/inode_mark.c                   |   12 ++--
 fs/ntfs/super.c                          |    2 
 fs/ocfs2/namei.c                         |    2 
 fs/quota/dquot.c                         |    2 
 fs/reiserfs/namei.c                      |    2 
 fs/reiserfs/stree.c                      |    2 
 fs/sysv/namei.c                          |    2 
 fs/ubifs/dir.c                           |    2 
 fs/ubifs/super.c                         |    2 
 fs/udf/namei.c                           |    2 
 fs/ufs/namei.c                           |    2 
 fs/xfs/linux-2.6/xfs_iops.c              |    2 
 fs/xfs/linux-2.6/xfs_trace.h             |    2 
 fs/xfs/xfs_inode.h                       |    4 -
 include/linux/fs.h                       |    7 +-
 ipc/mqueue.c                             |    2 
 kernel/futex.c                           |    2 
 mm/shmem.c                               |    2 
 net/socket.c                             |    2 
 60 files changed, 159 insertions(+), 110 deletions(-)

Index: linux-2.6/arch/powerpc/platforms/cell/spufs/file.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/file.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/file.c	2010-10-21 23:50:27.000000000 +1100
@@ -1549,7 +1549,7 @@ static int spufs_mfc_open(struct inode *
 	if (ctx->owner != current->mm)
 		return -EINVAL;
 
-	if (atomic_read(&inode->i_count) != 1)
+	if (inode->i_count != 1)
 		return -EBUSY;
 
 	mutex_lock(&ctx->mapping_lock);
Index: linux-2.6/fs/affs/inode.c
===================================================================
--- linux-2.6.orig/fs/affs/inode.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/affs/inode.c	2010-10-21 23:50:41.000000000 +1100
@@ -388,7 +388,7 @@ affs_add_entry(struct inode *dir, struct
 		affs_adjust_checksum(inode_bh, block - be32_to_cpu(chain));
 		mark_buffer_dirty_inode(inode_bh, inode);
 		inode->i_nlink = 2;
-		atomic_inc(&inode->i_count);
+		__inode_get(inode);
 	}
 	affs_fix_checksum(sb, bh);
 	mark_buffer_dirty_inode(bh, inode);
Index: linux-2.6/fs/afs/dir.c
===================================================================
--- linux-2.6.orig/fs/afs/dir.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/afs/dir.c	2010-10-21 23:50:41.000000000 +1100
@@ -1045,7 +1045,7 @@ static int afs_link(struct dentry *from,
 	if (ret < 0)
 		goto link_error;
 
-	atomic_inc(&vnode->vfs_inode.i_count);
+	__inode_get(&vnode->vfs_inode);
 	d_instantiate(dentry, &vnode->vfs_inode);
 	key_put(key);
 	_leave(" = 0");
Index: linux-2.6/fs/anon_inodes.c
===================================================================
--- linux-2.6.orig/fs/anon_inodes.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/anon_inodes.c	2010-10-21 23:50:41.000000000 +1100
@@ -114,7 +114,7 @@ struct file *anon_inode_getfile(const ch
 	 * so we can avoid doing an igrab() and we can use an open-coded
 	 * atomic_inc().
 	 */
-	atomic_inc(&anon_inode_inode->i_count);
+	__inode_get(anon_inode_inode);
 
 	path.dentry->d_op = &anon_inodefs_dentry_operations;
 	d_instantiate(path.dentry, anon_inode_inode);
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/block_dev.c	2010-10-21 23:50:41.000000000 +1100
@@ -550,7 +550,8 @@ EXPORT_SYMBOL(bdget);
  */
 struct block_device *bdgrab(struct block_device *bdev)
 {
-	atomic_inc(&bdev->bd_inode->i_count);
+	__inode_get(bdev->bd_inode);
+
 	return bdev;
 }
 
@@ -580,7 +581,7 @@ static struct block_device *bd_acquire(s
 	spin_lock(&bdev_lock);
 	bdev = inode->i_bdev;
 	if (bdev) {
-		atomic_inc(&bdev->bd_inode->i_count);
+		bdgrab(bdev);
 		spin_unlock(&bdev_lock);
 		return bdev;
 	}
@@ -596,7 +597,7 @@ static struct block_device *bd_acquire(s
 			 * So, we can access it via ->i_mapping always
 			 * without igrab().
 			 */
-			atomic_inc(&bdev->bd_inode->i_count);
+			__inode_get(bdev->bd_inode);
 			inode->i_bdev = bdev;
 			inode->i_mapping = bdev->bd_inode->i_mapping;
 			list_add(&inode->i_devices, &bdev->bd_inodes);
Index: linux-2.6/fs/ext2/namei.c
===================================================================
--- linux-2.6.orig/fs/ext2/namei.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/ext2/namei.c	2010-10-21 23:50:41.000000000 +1100
@@ -206,7 +206,7 @@ static int ext2_link (struct dentry * ol
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 
 	err = ext2_add_link(dentry, inode);
 	if (!err) {
Index: linux-2.6/fs/ext3/ialloc.c
===================================================================
--- linux-2.6.orig/fs/ext3/ialloc.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/ext3/ialloc.c	2010-10-21 23:50:27.000000000 +1100
@@ -100,9 +100,9 @@ void ext3_free_inode (handle_t *handle,
 	struct ext3_sb_info *sbi;
 	int fatal = 0, err;
 
-	if (atomic_read(&inode->i_count) > 1) {
+	if (inode->i_count > 1) {
 		printk ("ext3_free_inode: inode has count=%d\n",
-					atomic_read(&inode->i_count));
+					inode->i_count);
 		return;
 	}
 	if (inode->i_nlink) {
Index: linux-2.6/fs/ext3/namei.c
===================================================================
--- linux-2.6.orig/fs/ext3/namei.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/ext3/namei.c	2010-10-21 23:50:41.000000000 +1100
@@ -2260,7 +2260,7 @@ static int ext3_link (struct dentry * ol
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 
 	err = ext3_add_entry(handle, dentry, inode);
 	if (!err) {
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-21 23:50:46.000000000 +1100
@@ -297,8 +297,8 @@ static void inode_wait_for_writeback(str
 
 /*
  * Write out an inode's dirty pages.  Called under inode_lock.  Either the
- * caller has ref on the inode (either via __iget or via syscall against an fd)
- * or the inode has I_WILL_FREE set (via generic_forget_inode)
+ * caller has ref on the inode (either via inode_get or via syscall against an
+ * fd) or the inode has I_WILL_FREE set (via generic_forget_inode)
  *
  * If `wait' is set, wait on the writeout.
  *
@@ -315,7 +315,7 @@ writeback_single_inode(struct inode *ino
 	unsigned dirty;
 	int ret;
 
-	if (!atomic_read(&inode->i_count))
+	if (!inode->i_count)
 		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
 	else
 		WARN_ON(inode->i_state & I_WILL_FREE);
@@ -408,7 +408,7 @@ writeback_single_inode(struct inode *ino
 			 * completion.
 			 */
 			redirty_tail(inode);
-		} else if (atomic_read(&inode->i_count)) {
+		} else if (inode->i_count) {
 			/*
 			 * The inode is clean, inuse
 			 */
@@ -499,7 +499,7 @@ static int writeback_sb_inodes(struct su
 			return 1;
 
 		BUG_ON(inode->i_state & I_FREEING);
-		__iget(inode);
+		inode_get(inode);
 		pages_skipped = wbc->pages_skipped;
 		writeback_single_inode(inode, wbc);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -1045,7 +1045,7 @@ static void wait_sb_inodes(struct super_
 		mapping = inode->i_mapping;
 		if (mapping->nrpages == 0)
 			continue;
-		__iget(inode);
+		inode_get(inode);
 		spin_unlock(&inode_lock);
 		/*
 		 * We hold a reference to 'inode' so it couldn't have
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-21 23:50:22.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-21 23:50:46.000000000 +1100
@@ -31,9 +31,12 @@
  * Usage:
  * inode_lock protects:
  *   everything
+ * inode->i_lock protects:
+ *   i_count
  *
  * Ordering:
  * inode_lock
+ *   i_lock
  */
 /*
  * This is needed for the following functions:
@@ -142,7 +145,7 @@ int inode_init_always(struct super_block
 	inode->i_sb = sb;
 	inode->i_blkbits = sb->s_blocksize_bits;
 	inode->i_flags = 0;
-	atomic_set(&inode->i_count, 1);
+	inode->i_count = 1;
 	inode->i_op = &empty_iops;
 	inode->i_fop = &empty_fops;
 	inode->i_nlink = 1;
@@ -286,18 +289,48 @@ static void init_once(void *foo)
 	inode_init_once(inode);
 }
 
+void __inode_get_ilock(struct inode *inode)
+{
+ 	assert_spin_locked(&inode->i_lock);
+	BUG_ON(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE));
+	BUG_ON(inode->i_count == 0);
+	inode->i_count++;
+}
+EXPORT_SYMBOL(__inode_get_ilock);
+
+void __inode_get(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	__inode_get_ilock(inode);
+	spin_unlock(&inode->i_lock);
+}
+EXPORT_SYMBOL(__inode_get);
+
 /*
  * inode_lock must be held
  */
-void __iget(struct inode *inode)
+void inode_get_ilock(struct inode *inode)
 {
-	if (atomic_inc_return(&inode->i_count) != 1)
+ 	assert_spin_locked(&inode_lock);
+ 	assert_spin_locked(&inode->i_lock);
+	BUG_ON(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE));
+	inode->i_count++;
+	if (inode->i_count != 1)
 		return;
 
 	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 		list_move(&inode->i_list, &inode_in_use);
 	inodes_stat.nr_unused--;
 }
+EXPORT_SYMBOL(inode_get_ilock);
+
+void inode_get(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	inode_get_ilock(inode);
+	spin_unlock(&inode->i_lock);
+}
+EXPORT_SYMBOL(inode_get);
 
 void end_writeback(struct inode *inode)
 {
@@ -389,7 +422,7 @@ static int invalidate_list(struct list_h
 		if (inode->i_state & I_NEW)
 			continue;
 		invalidate_inode_buffers(inode);
-		if (!atomic_read(&inode->i_count)) {
+		if (!inode->i_count) {
 			list_move(&inode->i_list, dispose);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
@@ -435,7 +468,7 @@ static int can_unuse(struct inode *inode
 		return 0;
 	if (inode_has_buffers(inode))
 		return 0;
-	if (atomic_read(&inode->i_count))
+	if (inode->i_count)
 		return 0;
 	if (inode->i_data.nrpages)
 		return 0;
@@ -472,12 +505,12 @@ static void prune_icache(int nr_to_scan)
 
 		inode = list_entry(inode_unused.prev, struct inode, i_list);
 
-		if (inode->i_state || atomic_read(&inode->i_count)) {
+		if (inode->i_state || inode->i_count) {
 			list_move(&inode->i_list, &inode_unused);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
-			__iget(inode);
+			inode_get(inode);
 			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
@@ -539,9 +572,9 @@ static struct shrinker icache_shrinker =
 static void __wait_on_freeing_inode(struct inode *inode);
 /*
  * Called with the inode lock held.
- * NOTE: we are not increasing the inode-refcount, you must call __iget()
- * by hand after calling find_inode now! This simplifies iunique and won't
- * add any additional branch in the common code.
+ * NOTE: we are not increasing the inode-refcount, you must call
+ * inode_get_ilock() by hand after calling find_inode now! This simplifies
+ * iunique and won't add any additional branch in the common code.
  */
 static struct inode *find_inode(struct super_block *sb,
 				struct hlist_head *head,
@@ -745,7 +778,7 @@ static struct inode *get_new_inode(struc
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		__iget(old);
+		inode_get(old);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -792,7 +825,7 @@ static struct inode *get_new_inode_fast(
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		__iget(old);
+		inode_get(old);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -845,7 +878,7 @@ struct inode *igrab(struct inode *inode)
 {
 	spin_lock(&inode_lock);
 	if (!(inode->i_state & (I_FREEING|I_WILL_FREE)))
-		__iget(inode);
+		inode_get(inode);
 	else
 		/*
 		 * Handle the case where s_op->clear_inode is not been
@@ -886,7 +919,7 @@ static struct inode *ifind(struct super_
 	spin_lock(&inode_lock);
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
-		__iget(inode);
+		inode_get(inode);
 		spin_unlock(&inode_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
@@ -919,7 +952,7 @@ static struct inode *ifind_fast(struct s
 	spin_lock(&inode_lock);
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
-		__iget(inode);
+		inode_get(inode);
 		spin_unlock(&inode_lock);
 		wait_on_inode(inode);
 		return inode;
@@ -1102,7 +1135,7 @@ int insert_inode_locked(struct inode *in
 			spin_unlock(&inode_lock);
 			return 0;
 		}
-		__iget(old);
+		inode_get(old);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1141,7 +1174,7 @@ int insert_inode_locked4(struct inode *i
 			spin_unlock(&inode_lock);
 			return 0;
 		}
-		__iget(old);
+		inode_get(old);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1270,13 +1303,16 @@ void iput(struct inode *inode)
 		BUG_ON(inode->i_state & I_CLEAR);
 
 		/* open-code atomic_dec_and_lock */
-		if (atomic_add_unless(&inode->i_count, -1, 1))
-			return;
 		spin_lock(&inode_lock);
-		if (atomic_dec_and_test(&inode->i_count))
+		spin_lock(&inode->i_lock);
+		inode->i_count--;
+		if (inode->i_count == 0) {
+			spin_unlock(&inode->i_lock);
 			iput_final(inode);
-		else
+		} else {
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
+		}
 	}
 }
 EXPORT_SYMBOL(iput);
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c	2010-10-21 23:49:57.000000000 +1100
+++ linux-2.6/fs/libfs.c	2010-10-21 23:50:41.000000000 +1100
@@ -255,7 +255,7 @@ int simple_link(struct dentry *old_dentr
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 	dget(dentry);
 	d_instantiate(dentry, inode);
 	return 0;
Index: linux-2.6/fs/locks.c
===================================================================
--- linux-2.6.orig/fs/locks.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/locks.c	2010-10-21 23:50:27.000000000 +1100
@@ -1375,8 +1375,8 @@ int generic_setlease(struct file *filp,
 		if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
 			goto out;
 		if ((arg == F_WRLCK)
-		    && ((atomic_read(&dentry->d_count) > 1)
-			|| (atomic_read(&inode->i_count) > 1)))
+		    && (atomic_read(&dentry->d_count) > 1
+			|| inode->i_count > 1))
 			goto out;
 	}
 
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/namei.c	2010-10-21 23:50:40.000000000 +1100
@@ -2291,7 +2291,7 @@ static long do_unlinkat(int dfd, const c
 			goto slashes;
 		inode = dentry->d_inode;
 		if (inode)
-			atomic_inc(&inode->i_count);
+			__inode_get(inode);
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/nfs/dir.c	2010-10-21 23:50:41.000000000 +1100
@@ -1580,7 +1580,7 @@ nfs_link(struct dentry *old_dentry, stru
 	d_drop(dentry);
 	error = NFS_PROTO(dir)->link(inode, dir, &dentry->d_name);
 	if (error == 0) {
-		atomic_inc(&inode->i_count);
+		__inode_get(inode);
 		d_add(dentry, inode);
 	}
 	return error;
Index: linux-2.6/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_iops.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_iops.c	2010-10-21 23:50:41.000000000 +1100
@@ -352,7 +352,7 @@ xfs_vn_link(
 	if (unlikely(error))
 		return -error;
 
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 	d_instantiate(dentry, inode);
 	return 0;
 }
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/xfs/xfs_inode.h	2010-10-21 23:50:41.000000000 +1100
@@ -481,8 +481,8 @@ void		xfs_mark_inode_dirty_sync(xfs_inod
 
 #define IHOLD(ip) \
 do { \
-	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
-	atomic_inc(&(VFS_I(ip)->i_count)); \
+	ASSERT(VFS_I(ip)->i_count > 0) ; \
+	__inode_get(VFS_I(ip)); \
 	trace_xfs_ihold(ip, _THIS_IP_); \
 } while (0)
 
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-21 23:50:44.000000000 +1100
@@ -728,7 +728,7 @@ struct inode {
 	struct list_head	i_sb_list;
 	struct list_head	i_dentry;
 	unsigned long		i_ino;
-	atomic_t		i_count;
+	unsigned int		i_count;
 	unsigned int		i_nlink;
 	uid_t			i_uid;
 	gid_t			i_gid;
@@ -2181,7 +2181,10 @@ extern int insert_inode_locked4(struct i
 extern int insert_inode_locked(struct inode *);
 extern void unlock_new_inode(struct inode *);
 
-extern void __iget(struct inode * inode);
+extern void inode_get(struct inode *inode);
+extern void inode_get_ilock(struct inode *inode);
+extern void __inode_get(struct inode *inode);
+extern void __inode_get_ilock(struct inode *inode);
 extern void iget_failed(struct inode *);
 extern void end_writeback(struct inode *);
 extern void destroy_inode(struct inode *);
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/ipc/mqueue.c	2010-10-21 23:50:40.000000000 +1100
@@ -769,7 +769,7 @@ SYSCALL_DEFINE1(mq_unlink, const char __
 
 	inode = dentry->d_inode;
 	if (inode)
-		atomic_inc(&inode->i_count);
+		__inode_get(inode);
 	err = mnt_want_write(ipc_ns->mq_mnt);
 	if (err)
 		goto out_err;
Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/kernel/futex.c	2010-10-21 23:50:40.000000000 +1100
@@ -168,7 +168,7 @@ static void get_futex_key_refs(union fut
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		atomic_inc(&key->shared.inode->i_count);
+		__inode_get(key->shared.inode);
 		break;
 	case FUT_OFF_MMSHARED:
 		atomic_inc(&key->private.mm->mm_count);
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/mm/shmem.c	2010-10-21 23:50:40.000000000 +1100
@@ -1903,7 +1903,7 @@ static int shmem_link(struct dentry *old
 	dir->i_size += BOGO_DIRENT_SIZE;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);	/* New dentry reference */
+	__inode_get(inode);
 	dget(dentry);		/* Extra pinning count for the created dentry */
 	d_instantiate(dentry, inode);
 out:
Index: linux-2.6/fs/bfs/dir.c
===================================================================
--- linux-2.6.orig/fs/bfs/dir.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/bfs/dir.c	2010-10-21 23:50:41.000000000 +1100
@@ -176,7 +176,7 @@ static int bfs_link(struct dentry *old,
 	inc_nlink(inode);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 	d_instantiate(new, inode);
 	mutex_unlock(&info->bfs_lock);
 	return 0;
Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/btrfs/inode.c	2010-10-21 23:50:41.000000000 +1100
@@ -1964,8 +1964,13 @@ void btrfs_add_delayed_iput(struct inode
 	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct delayed_iput *delayed;
 
-	if (atomic_add_unless(&inode->i_count, -1, 1))
+	spin_lock(&inode->i_lock);
+	if (inode->i_count > 1) {
+		inode->i_count--;
+		spin_unlock(&inode->i_lock);
 		return;
+	}
+	spin_unlock(&inode->i_lock);
 
 	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
 	delayed->inode = inode;
@@ -2718,10 +2723,10 @@ static struct btrfs_trans_handle *__unli
 		return ERR_PTR(-ENOSPC);
 
 	/* check if there is someone else holds reference */
-	if (S_ISDIR(inode->i_mode) && atomic_read(&inode->i_count) > 1)
+	if (S_ISDIR(inode->i_mode) && inode->i_count > 1)
 		return ERR_PTR(-ENOSPC);
 
-	if (atomic_read(&inode->i_count) > 2)
+	if (inode->i_count > 2)
 		return ERR_PTR(-ENOSPC);
 
 	if (xchg(&root->fs_info->enospc_unlink, 1))
@@ -3939,7 +3944,7 @@ int btrfs_invalidate_inodes(struct btrfs
 		inode = igrab(&entry->vfs_inode);
 		if (inode) {
 			spin_unlock(&root->inode_lock);
-			if (atomic_read(&inode->i_count) > 1)
+			if (inode->i_count > 1)
 				d_prune_aliases(inode);
 			/*
 			 * btrfs_drop_inode will have it removed from
@@ -4758,7 +4763,7 @@ static int btrfs_link(struct dentry *old
 	}
 
 	btrfs_set_trans_block_group(trans, dir);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 
 	err = btrfs_add_nondir(trans, dentry, inode, 1, index);
 
Index: linux-2.6/fs/coda/dir.c
===================================================================
--- linux-2.6.orig/fs/coda/dir.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/coda/dir.c	2010-10-21 23:50:41.000000000 +1100
@@ -303,7 +303,7 @@ static int coda_link(struct dentry *sour
 	}
 
 	coda_dir_update_mtime(dir_inode);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 	d_instantiate(de, inode);
 	inc_nlink(inode);
 
Index: linux-2.6/fs/exofs/inode.c
===================================================================
--- linux-2.6.orig/fs/exofs/inode.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/exofs/inode.c	2010-10-21 23:50:41.000000000 +1100
@@ -1107,7 +1107,9 @@ static void create_done(struct exofs_io_
 
 	set_obj_created(oi);
 
-	atomic_dec(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count--;
+	spin_unlock(&inode->i_lock);
 	wake_up(&oi->i_wq);
 }
 
@@ -1160,14 +1162,16 @@ struct inode *exofs_new_inode(struct ino
 	/* increment the refcount so that the inode will still be around when we
 	 * reach the callback
 	 */
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 
 	ios->done = create_done;
 	ios->private = inode;
 	ios->cred = oi->i_cred;
 	ret = exofs_sbi_create(ios);
 	if (ret) {
-		atomic_dec(&inode->i_count);
+		spin_lock(&inode->i_lock);
+		inode->i_count--;
+		spin_unlock(&inode->i_lock);
 		exofs_put_io_state(ios);
 		return ERR_PTR(ret);
 	}
Index: linux-2.6/fs/exofs/namei.c
===================================================================
--- linux-2.6.orig/fs/exofs/namei.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/exofs/namei.c	2010-10-21 23:50:41.000000000 +1100
@@ -153,7 +153,7 @@ static int exofs_link(struct dentry *old
 
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 
 	return exofs_add_nondir(dentry, inode);
 }
Index: linux-2.6/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.orig/fs/ext4/ialloc.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/ext4/ialloc.c	2010-10-21 23:50:27.000000000 +1100
@@ -189,9 +189,9 @@ void ext4_free_inode(handle_t *handle, s
 	struct ext4_sb_info *sbi;
 	int fatal = 0, err, count, cleared;
 
-	if (atomic_read(&inode->i_count) > 1) {
+	if (inode->i_count > 1) {
 		printk(KERN_ERR "ext4_free_inode: inode has count=%d\n",
-		       atomic_read(&inode->i_count));
+		       inode->i_count);
 		return;
 	}
 	if (inode->i_nlink) {
Index: linux-2.6/fs/ext4/namei.c
===================================================================
--- linux-2.6.orig/fs/ext4/namei.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/ext4/namei.c	2010-10-21 23:50:41.000000000 +1100
@@ -2312,7 +2312,7 @@ static int ext4_link(struct dentry *old_
 
 	inode->i_ctime = ext4_current_time(inode);
 	ext4_inc_count(handle, inode);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 
 	err = ext4_add_entry(handle, dentry, inode);
 	if (!err) {
Index: linux-2.6/fs/gfs2/ops_inode.c
===================================================================
--- linux-2.6.orig/fs/gfs2/ops_inode.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/gfs2/ops_inode.c	2010-10-21 23:50:41.000000000 +1100
@@ -253,7 +253,7 @@ static int gfs2_link(struct dentry *old_
 	gfs2_holder_uninit(ghs);
 	gfs2_holder_uninit(ghs + 1);
 	if (!error) {
-		atomic_inc(&inode->i_count);
+		__inode_get(inode);
 		d_instantiate(dentry, inode);
 		mark_inode_dirty(inode);
 	}
Index: linux-2.6/fs/hfsplus/dir.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/dir.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/hfsplus/dir.c	2010-10-21 23:50:41.000000000 +1100
@@ -301,7 +301,7 @@ static int hfsplus_link(struct dentry *s
 
 	inc_nlink(inode);
 	hfsplus_instantiate(dst_dentry, inode, cnid);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 	HFSPLUS_SB(sb).file_count++;
Index: linux-2.6/fs/hpfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hpfs/inode.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/hpfs/inode.c	2010-10-21 23:50:27.000000000 +1100
@@ -183,7 +183,7 @@ void hpfs_write_inode(struct inode *i)
 	struct hpfs_inode_info *hpfs_inode = hpfs_i(i);
 	struct inode *parent;
 	if (i->i_ino == hpfs_sb(i->i_sb)->sb_root) return;
-	if (hpfs_inode->i_rddir_off && !atomic_read(&i->i_count)) {
+	if (hpfs_inode->i_rddir_off && !i->i_count) {
 		if (*hpfs_inode->i_rddir_off) printk("HPFS: write_inode: some position still there\n");
 		kfree(hpfs_inode->i_rddir_off);
 		hpfs_inode->i_rddir_off = NULL;
Index: linux-2.6/fs/jffs2/dir.c
===================================================================
--- linux-2.6.orig/fs/jffs2/dir.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/jffs2/dir.c	2010-10-21 23:50:40.000000000 +1100
@@ -289,7 +289,7 @@ static int jffs2_link (struct dentry *ol
 		mutex_unlock(&f->sem);
 		d_instantiate(dentry, old_dentry->d_inode);
 		dir_i->i_mtime = dir_i->i_ctime = ITIME(now);
-		atomic_inc(&old_dentry->d_inode->i_count);
+		__inode_get(old_dentry->d_inode);
 	}
 	return ret;
 }
@@ -864,7 +864,7 @@ static int jffs2_rename (struct inode *o
 		printk(KERN_NOTICE "jffs2_rename(): Link succeeded, unlink failed (err %d). You now have a hard link\n", ret);
 		/* Might as well let the VFS know */
 		d_instantiate(new_dentry, old_dentry->d_inode);
-		atomic_inc(&old_dentry->d_inode->i_count);
+		__inode_get(old_dentry->d_inode);
 		new_dir_i->i_mtime = new_dir_i->i_ctime = ITIME(now);
 		return ret;
 	}
Index: linux-2.6/fs/jfs/jfs_txnmgr.c
===================================================================
--- linux-2.6.orig/fs/jfs/jfs_txnmgr.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/jfs/jfs_txnmgr.c	2010-10-21 23:50:41.000000000 +1100
@@ -1279,7 +1279,7 @@ int txCommit(tid_t tid,		/* transaction
 	 * lazy commit thread finishes processing
 	 */
 	if (tblk->xflag & COMMIT_DELETE) {
-		atomic_inc(&tblk->u.ip->i_count);
+		__inode_get(tblk->u.ip);
 		/*
 		 * Avoid a rare deadlock
 		 *
Index: linux-2.6/fs/jfs/namei.c
===================================================================
--- linux-2.6.orig/fs/jfs/namei.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/jfs/namei.c	2010-10-21 23:50:41.000000000 +1100
@@ -839,7 +839,7 @@ static int jfs_link(struct dentry *old_d
 	ip->i_ctime = CURRENT_TIME;
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	mark_inode_dirty(dir);
-	atomic_inc(&ip->i_count);
+	__inode_get(ip);
 
 	iplist[0] = ip;
 	iplist[1] = dir;
Index: linux-2.6/fs/minix/namei.c
===================================================================
--- linux-2.6.orig/fs/minix/namei.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/minix/namei.c	2010-10-21 23:50:41.000000000 +1100
@@ -101,7 +101,7 @@ static int minix_link(struct dentry * ol
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 	return add_nondir(dentry, inode);
 }
 
Index: linux-2.6/fs/nfs/inode.c
===================================================================
--- linux-2.6.orig/fs/nfs/inode.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/nfs/inode.c	2010-10-21 23:50:27.000000000 +1100
@@ -384,7 +384,7 @@ nfs_fhget(struct super_block *sb, struct
 	dprintk("NFS: nfs_fhget(%s/%Ld ct=%d)\n",
 		inode->i_sb->s_id,
 		(long long)NFS_FILEID(inode),
-		atomic_read(&inode->i_count));
+		inode->i_count);
 
 out:
 	return inode;
@@ -1190,7 +1190,7 @@ static int nfs_update_inode(struct inode
 
 	dfprintk(VFS, "NFS: %s(%s/%ld ct=%d info=0x%x)\n",
 			__func__, inode->i_sb->s_id, inode->i_ino,
-			atomic_read(&inode->i_count), fattr->valid);
+			inode->i_count, fattr->valid);
 
 	if ((fattr->valid & NFS_ATTR_FATTR_FILEID) && nfsi->fileid != fattr->fileid)
 		goto out_fileid;
Index: linux-2.6/fs/nilfs2/mdt.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/mdt.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/nilfs2/mdt.c	2010-10-21 23:50:39.000000000 +1100
@@ -480,7 +480,7 @@ nilfs_mdt_new_common(struct the_nilfs *n
 		inode->i_sb = sb; /* sb may be NULL for some meta data files */
 		inode->i_blkbits = nilfs->ns_blocksize_bits;
 		inode->i_flags = 0;
-		atomic_set(&inode->i_count, 1);
+		inode->i_count = 1;
 		inode->i_nlink = 1;
 		inode->i_ino = ino;
 		inode->i_mode = S_IFREG;
Index: linux-2.6/fs/nilfs2/namei.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/namei.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/nilfs2/namei.c	2010-10-21 23:50:40.000000000 +1100
@@ -219,7 +219,7 @@ static int nilfs_link(struct dentry *old
 
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 
 	err = nilfs_add_nondir(dentry, inode);
 	if (!err)
Index: linux-2.6/fs/ocfs2/namei.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/namei.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/ocfs2/namei.c	2010-10-21 23:50:41.000000000 +1100
@@ -741,7 +741,7 @@ static int ocfs2_link(struct dentry *old
 		goto out_commit;
 	}
 
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 	dentry->d_op = &ocfs2_dentry_ops;
 	d_instantiate(dentry, inode);
 
Index: linux-2.6/fs/reiserfs/namei.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/namei.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/reiserfs/namei.c	2010-10-21 23:50:41.000000000 +1100
@@ -1156,7 +1156,7 @@ static int reiserfs_link(struct dentry *
 	inode->i_ctime = CURRENT_TIME_SEC;
 	reiserfs_update_sd(&th, inode);
 
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 	d_instantiate(dentry, inode);
 	retval = journal_end(&th, dir->i_sb, jbegin_count);
 	reiserfs_write_unlock(dir->i_sb);
Index: linux-2.6/fs/reiserfs/stree.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/stree.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/reiserfs/stree.c	2010-10-21 23:50:27.000000000 +1100
@@ -1477,7 +1477,7 @@ static int maybe_indirect_to_direct(stru
 	 ** reading in the last block.  The user will hit problems trying to
 	 ** read the file, but for now we just skip the indirect2direct
 	 */
-	if (atomic_read(&inode->i_count) > 1 ||
+	if (inode->i_count > 1 ||
 	    !tail_has_to_be_packed(inode) ||
 	    !page || (REISERFS_I(inode)->i_flags & i_nopack_mask)) {
 		/* leave tail in an unformatted node */
Index: linux-2.6/fs/sysv/namei.c
===================================================================
--- linux-2.6.orig/fs/sysv/namei.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/sysv/namei.c	2010-10-21 23:50:41.000000000 +1100
@@ -126,7 +126,7 @@ static int sysv_link(struct dentry * old
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 
 	return add_nondir(dentry, inode);
 }
Index: linux-2.6/fs/ubifs/dir.c
===================================================================
--- linux-2.6.orig/fs/ubifs/dir.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/ubifs/dir.c	2010-10-21 23:50:41.000000000 +1100
@@ -550,7 +550,7 @@ static int ubifs_link(struct dentry *old
 
 	lock_2_inodes(dir, inode);
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 	inode->i_ctime = ubifs_current_time(inode);
 	dir->i_size += sz_change;
 	dir_ui->ui_size = dir->i_size;
Index: linux-2.6/fs/ubifs/super.c
===================================================================
--- linux-2.6.orig/fs/ubifs/super.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/ubifs/super.c	2010-10-21 23:50:27.000000000 +1100
@@ -342,7 +342,7 @@ static void ubifs_evict_inode(struct ino
 		goto out;
 
 	dbg_gen("inode %lu, mode %#x", inode->i_ino, (int)inode->i_mode);
-	ubifs_assert(!atomic_read(&inode->i_count));
+	ubifs_assert(!inode->i_count);
 
 	truncate_inode_pages(&inode->i_data, 0);
 
Index: linux-2.6/fs/udf/namei.c
===================================================================
--- linux-2.6.orig/fs/udf/namei.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/udf/namei.c	2010-10-21 23:50:41.000000000 +1100
@@ -1101,7 +1101,7 @@ static int udf_link(struct dentry *old_d
 	inc_nlink(inode);
 	inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 	d_instantiate(dentry, inode);
 	unlock_kernel();
 
Index: linux-2.6/fs/ufs/namei.c
===================================================================
--- linux-2.6.orig/fs/ufs/namei.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/ufs/namei.c	2010-10-21 23:50:41.000000000 +1100
@@ -180,7 +180,7 @@ static int ufs_link (struct dentry * old
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 
 	error = ufs_add_nondir(dentry, inode);
 	unlock_kernel();
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/notify/inode_mark.c	2010-10-21 23:50:46.000000000 +1100
@@ -244,7 +244,7 @@ void fsnotify_unmount_inodes(struct list
 		struct inode *need_iput_tmp;
 
 		/*
-		 * We cannot __iget() an inode in state I_FREEING,
+		 * We cannot inode_get() an inode in state I_FREEING,
 		 * I_WILL_FREE, or I_NEW which is fine because by that point
 		 * the inode cannot have any associated watches.
 		 */
@@ -253,11 +253,11 @@ void fsnotify_unmount_inodes(struct list
 
 		/*
 		 * If i_count is zero, the inode cannot have any watches and
-		 * doing an __iget/iput with MS_ACTIVE clear would actually
+		 * doing an inode_get/iput with MS_ACTIVE clear would actually
 		 * evict all inodes with zero i_count from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		if (!atomic_read(&inode->i_count))
+		if (!inode->i_count)
 			continue;
 
 		need_iput_tmp = need_iput;
@@ -265,15 +265,15 @@ void fsnotify_unmount_inodes(struct list
 
 		/* In case fsnotify_inode_delete() drops a reference. */
 		if (inode != need_iput_tmp)
-			__iget(inode);
+			inode_get(inode);
 		else
 			need_iput_tmp = NULL;
 
 		/* In case the dropping of a reference would nuke next_i. */
 		if ((&next_i->i_sb_list != list) &&
-		    atomic_read(&next_i->i_count) &&
+		    next_i->i_count &&
 		    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
-			__iget(next_i);
+			inode_get(next_i);
 			need_iput = next_i;
 		}
 
Index: linux-2.6/fs/ntfs/super.c
===================================================================
--- linux-2.6.orig/fs/ntfs/super.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/ntfs/super.c	2010-10-21 23:50:41.000000000 +1100
@@ -2930,7 +2930,7 @@ static int ntfs_fill_super(struct super_
 	}
 	if ((sb->s_root = d_alloc_root(vol->root_ino))) {
 		/* We increment i_count simulating an ntfs_iget(). */
-		atomic_inc(&vol->root_ino->i_count);
+		__inode_get(vol->root_ino);
 		ntfs_debug("Exiting, status successful.");
 		/* Release the default upcase if it has no users. */
 		mutex_lock(&ntfs_lock);
Index: linux-2.6/fs/cifs/inode.c
===================================================================
--- linux-2.6.orig/fs/cifs/inode.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/cifs/inode.c	2010-10-21 23:50:27.000000000 +1100
@@ -1641,7 +1641,7 @@ int cifs_revalidate_dentry(struct dentry
 	}
 
 	cFYI(1, "Revalidate: %s inode 0x%p count %d dentry: 0x%p d_time %ld "
-		 "jiffies %ld", full_path, inode, inode->i_count.counter,
+		 "jiffies %ld", full_path, inode, inode->i_count,
 		 dentry, dentry->d_time, jiffies);
 
 	if (CIFS_SB(sb)->tcon->unix_ext)
Index: linux-2.6/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_trace.h	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_trace.h	2010-10-21 23:50:27.000000000 +1100
@@ -599,7 +599,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->count = atomic_read(&VFS_I(ip)->i_count);
+		__entry->count = VFS_I(ip)->i_count;
 		__entry->pincount = atomic_read(&ip->i_pincount);
 		__entry->caller_ip = caller_ip;
 	),
Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/net/socket.c	2010-10-21 23:50:41.000000000 +1100
@@ -377,7 +377,7 @@ static int sock_alloc_file(struct socket
 		  &socket_file_ops);
 	if (unlikely(!file)) {
 		/* drop dentry, keep inode */
-		atomic_inc(&path.dentry->d_inode->i_count);
+		__inode_get(path.dentry->d_inode);
 		path_put(&path);
 		put_unused_fd(fd);
 		return -ENFILE;
Index: linux-2.6/fs/nfs/nfs4state.c
===================================================================
--- linux-2.6.orig/fs/nfs/nfs4state.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/nfs/nfs4state.c	2010-10-21 23:50:27.000000000 +1100
@@ -506,8 +506,8 @@ nfs4_get_open_state(struct inode *inode,
 		state->owner = owner;
 		atomic_inc(&owner->so_count);
 		list_add(&state->inode_states, &nfsi->open_states);
-		state->inode = igrab(inode);
 		spin_unlock(&inode->i_lock);
+		state->inode = igrab(inode);
 		/* Note: The reclaim code dictates that we add stateless
 		 * and read-only stateids to the end of the list */
 		list_add_tail(&state->open_states, &owner->so_states);
Index: linux-2.6/fs/nfs/write.c
===================================================================
--- linux-2.6.orig/fs/nfs/write.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/nfs/write.c	2010-10-21 23:50:27.000000000 +1100
@@ -390,7 +390,7 @@ static int nfs_inode_add_request(struct
 	error = radix_tree_insert(&nfsi->nfs_page_tree, req->wb_index, req);
 	BUG_ON(error);
 	if (!nfsi->npages) {
-		igrab(inode);
+		inode_get_ilock(inode);
 		if (nfs_have_delegation(inode, FMODE_WRITE))
 			nfsi->change_attr++;
 	}
Index: linux-2.6/fs/nfs/getroot.c
===================================================================
--- linux-2.6.orig/fs/nfs/getroot.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/nfs/getroot.c	2010-10-21 23:50:41.000000000 +1100
@@ -54,8 +54,8 @@ static int nfs_superblock_set_dummy_root
 			iput(inode);
 			return -ENOMEM;
 		}
-		/* Circumvent igrab(): we know the inode is not being freed */
-		atomic_inc(&inode->i_count);
+		/* We know the inode is not being freed */
+		__inode_get(inode);
 		/*
 		 * Ensure that this dentry is invisible to d_find_alias().
 		 * Otherwise, it may be spliced into the tree by
Index: linux-2.6/drivers/staging/pohmelfs/inode.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/inode.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/drivers/staging/pohmelfs/inode.c	2010-10-21 23:50:27.000000000 +1100
@@ -1289,11 +1289,11 @@ static void pohmelfs_put_super(struct su
 		dprintk("%s: ino: %llu, pi: %p, inode: %p, count: %u.\n",
 				__func__, pi->ino, pi, inode, count);
 
-		if (atomic_read(&inode->i_count) != count) {
+		if (inode->i_count != count) {
 			printk("%s: ino: %llu, pi: %p, inode: %p, count: %u, i_count: %d.\n",
 					__func__, pi->ino, pi, inode, count,
-					atomic_read(&inode->i_count));
-			count = atomic_read(&inode->i_count);
+					inode->i_count);
+			count = inode->i_count;
 			in_drop_list++;
 		}
 
@@ -1305,7 +1305,7 @@ static void pohmelfs_put_super(struct su
 		pi = POHMELFS_I(inode);
 
 		dprintk("%s: ino: %llu, pi: %p, inode: %p, i_count: %u.\n",
-				__func__, pi->ino, pi, inode, atomic_read(&inode->i_count));
+				__func__, pi->ino, pi, inode, inode->i_count);
 
 		/*
 		 * These are special inodes, they were created during
@@ -1313,7 +1313,7 @@ static void pohmelfs_put_super(struct su
 		 * so they live here with reference counter being 1 and prevent
 		 * umount from succeed since it believes that they are busy.
 		 */
-		count = atomic_read(&inode->i_count);
+		count = inode->i_count;
 		if (count) {
 			list_del_init(&inode->i_sb_list);
 			while (count--)
Index: linux-2.6/fs/9p/vfs_inode.c
===================================================================
--- linux-2.6.orig/fs/9p/vfs_inode.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/9p/vfs_inode.c	2010-10-21 23:50:41.000000000 +1100
@@ -1791,7 +1791,7 @@ v9fs_vfs_link_dotl(struct dentry *old_de
 		/* Caching disabled. No need to get upto date stat info.
 		 * This dentry will be released immediately. So, just i_count++
 		 */
-		atomic_inc(&old_dentry->d_inode->i_count);
+		__inode_get(old_dentry->d_inode);
 	}
 
 	dentry->d_op = old_dentry->d_op;
Index: linux-2.6/fs/ceph/mds_client.c
===================================================================
--- linux-2.6.orig/fs/ceph/mds_client.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/ceph/mds_client.c	2010-10-21 23:50:27.000000000 +1100
@@ -1102,7 +1102,7 @@ static int trim_caps_cb(struct inode *in
 		spin_unlock(&inode->i_lock);
 		d_prune_aliases(inode);
 		dout("trim_caps_cb %p cap %p  pruned, count now %d\n",
-		     inode, cap, atomic_read(&inode->i_count));
+		     inode, cap, inode->i_count);
 		return 0;
 	}
 
Index: linux-2.6/fs/logfs/dir.c
===================================================================
--- linux-2.6.orig/fs/logfs/dir.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/logfs/dir.c	2010-10-21 23:50:40.000000000 +1100
@@ -569,7 +569,7 @@ static int logfs_link(struct dentry *old
 		return -EMLINK;
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-	atomic_inc(&inode->i_count);
+	__inode_get(inode);
 	inode->i_nlink++;
 	mark_inode_dirty_sync(inode);
 
Index: linux-2.6/fs/logfs/readwrite.c
===================================================================
--- linux-2.6.orig/fs/logfs/readwrite.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/logfs/readwrite.c	2010-10-21 23:50:27.000000000 +1100
@@ -1002,7 +1002,7 @@ static int __logfs_is_valid_block(struct
 {
 	struct logfs_inode *li = logfs_inode(inode);
 
-	if ((inode->i_nlink == 0) && atomic_read(&inode->i_count) == 1)
+	if ((inode->i_nlink == 0) && inode->i_count == 1)
 		return 0;
 
 	if (bix < I0_BLOCKS)
Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c	2010-10-21 23:49:57.000000000 +1100
+++ linux-2.6/fs/drop_caches.c	2010-10-21 23:50:46.000000000 +1100
@@ -22,7 +22,7 @@ static void drop_pagecache_sb(struct sup
 			continue;
 		if (inode->i_mapping->nrpages == 0)
 			continue;
-		__iget(inode);
+		inode_get(inode);
 		spin_unlock(&inode_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c	2010-10-21 23:49:55.000000000 +1100
+++ linux-2.6/fs/quota/dquot.c	2010-10-21 23:50:46.000000000 +1100
@@ -909,7 +909,7 @@ static void add_dquot_ref(struct super_b
 		if (!dqinit_needed(inode, type))
 			continue;
 
-		__iget(inode);
+		inode_get(inode);
 		spin_unlock(&inode_lock);
 
 		iput(old_inode);


