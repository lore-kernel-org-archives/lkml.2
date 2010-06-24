Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0FXDQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:48449 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab0FXDPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:48 -0400
Message-Id: <20100624030730.245992858@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:41 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 29/52] fs: icache lock i_count
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect inode->i_count with i_lock, rather than having it atomic.
Next step should also be to move things together (eg. the refcount increment
into d_instantiate, which will remove a lock/unlock cycle on i_lock).

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 arch/powerpc/platforms/cell/spufs/file.c |    2 -
 fs/affs/inode.c                          |    4 ++-
 fs/afs/dir.c                             |    4 ++-
 fs/anon_inodes.c                         |    4 ++-
 fs/bfs/dir.c                             |    4 ++-
 fs/block_dev.c                           |   15 ++++++++++--
 fs/btrfs/inode.c                         |    4 ++-
 fs/cifs/inode.c                          |    2 -
 fs/coda/dir.c                            |    4 ++-
 fs/exofs/inode.c                         |   12 +++++++---
 fs/exofs/namei.c                         |    4 ++-
 fs/ext2/namei.c                          |    4 ++-
 fs/ext3/ialloc.c                         |    4 +--
 fs/ext3/namei.c                          |    4 ++-
 fs/ext4/ialloc.c                         |    4 +--
 fs/ext4/namei.c                          |    4 ++-
 fs/fs-writeback.c                        |    4 +--
 fs/gfs2/ops_inode.c                      |    4 ++-
 fs/hfsplus/dir.c                         |    4 ++-
 fs/hpfs/inode.c                          |    2 -
 fs/inode.c                               |   37 ++++++++++++++++++++-----------
 fs/jffs2/dir.c                           |    8 +++++-
 fs/jfs/jfs_txnmgr.c                      |    4 ++-
 fs/jfs/namei.c                           |    4 ++-
 fs/libfs.c                               |    4 ++-
 fs/locks.c                               |    3 --
 fs/minix/namei.c                         |    4 ++-
 fs/namei.c                               |    7 ++++-
 fs/nfs/dir.c                             |    4 ++-
 fs/nfs/getroot.c                         |    4 ++-
 fs/nfs/inode.c                           |    4 +--
 fs/nilfs2/mdt.c                          |    2 -
 fs/nilfs2/namei.c                        |    4 ++-
 fs/notify/inode_mark.c                   |   22 +++++++++++-------
 fs/notify/inotify/inotify.c              |   28 +++++++++++++----------
 fs/ntfs/super.c                          |    4 ++-
 fs/ocfs2/namei.c                         |    4 ++-
 fs/reiserfs/file.c                       |    4 +--
 fs/reiserfs/namei.c                      |    4 ++-
 fs/reiserfs/stree.c                      |    2 -
 fs/sysv/namei.c                          |    4 ++-
 fs/ubifs/dir.c                           |    4 ++-
 fs/ubifs/super.c                         |    2 -
 fs/udf/namei.c                           |    4 ++-
 fs/ufs/namei.c                           |    4 ++-
 fs/xfs/linux-2.6/xfs_iops.c              |    4 ++-
 fs/xfs/xfs_iget.c                        |    2 -
 fs/xfs/xfs_inode.h                       |    6 +++--
 include/linux/fs.h                       |    2 -
 ipc/mqueue.c                             |    7 ++++-
 kernel/futex.c                           |    4 ++-
 mm/shmem.c                               |    4 ++-
 52 files changed, 201 insertions(+), 96 deletions(-)

Index: linux-2.6/arch/powerpc/platforms/cell/spufs/file.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/file.c
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/file.c
@@ -1549,7 +1549,7 @@ static int spufs_mfc_open(struct inode *
 	if (ctx->owner != current->mm)
 		return -EINVAL;
 
-	if (atomic_read(&inode->i_count) != 1)
+	if (inode->i_count != 1)
 		return -EBUSY;
 
 	mutex_lock(&ctx->mapping_lock);
Index: linux-2.6/fs/affs/inode.c
===================================================================
--- linux-2.6.orig/fs/affs/inode.c
+++ linux-2.6/fs/affs/inode.c
@@ -380,7 +380,9 @@ affs_add_entry(struct inode *dir, struct
 		affs_adjust_checksum(inode_bh, block - be32_to_cpu(chain));
 		mark_buffer_dirty_inode(inode_bh, inode);
 		inode->i_nlink = 2;
-		atomic_inc(&inode->i_count);
+		spin_lock(&inode->i_lock);
+		inode->i_count++;
+		spin_unlock(&inode->i_lock);
 	}
 	affs_fix_checksum(sb, bh);
 	mark_buffer_dirty_inode(bh, inode);
Index: linux-2.6/fs/afs/dir.c
===================================================================
--- linux-2.6.orig/fs/afs/dir.c
+++ linux-2.6/fs/afs/dir.c
@@ -1002,7 +1002,9 @@ static int afs_link(struct dentry *from,
 	if (ret < 0)
 		goto link_error;
 
-	atomic_inc(&vnode->vfs_inode.i_count);
+	spin_lock(&vnode->vfs_inode.i_lock);
+	vnode->vfs_inode.i_count++;
+	spin_unlock(&vnode->vfs_inode.i_lock);
 	d_instantiate(dentry, &vnode->vfs_inode);
 	key_put(key);
 	_leave(" = 0");
Index: linux-2.6/fs/anon_inodes.c
===================================================================
--- linux-2.6.orig/fs/anon_inodes.c
+++ linux-2.6/fs/anon_inodes.c
@@ -114,7 +114,9 @@ struct file *anon_inode_getfile(const ch
 	 * so we can avoid doing an igrab() and we can use an open-coded
 	 * atomic_inc().
 	 */
-	atomic_inc(&anon_inode_inode->i_count);
+	spin_lock(&anon_inode_inode->i_lock);
+	anon_inode_inode->i_count++;
+	spin_unlock(&anon_inode_inode->i_lock);
 
 	path.dentry->d_op = &anon_inodefs_dentry_operations;
 	d_instantiate(path.dentry, anon_inode_inode);
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c
+++ linux-2.6/fs/block_dev.c
@@ -549,7 +549,12 @@ EXPORT_SYMBOL(bdget);
  */
 struct block_device *bdgrab(struct block_device *bdev)
 {
-	atomic_inc(&bdev->bd_inode->i_count);
+	struct inode *inode = bdev->bd_inode;
+
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
+
 	return bdev;
 }
 
@@ -579,7 +584,9 @@ static struct block_device *bd_acquire(s
 	spin_lock(&bdev_lock);
 	bdev = inode->i_bdev;
 	if (bdev) {
-		atomic_inc(&bdev->bd_inode->i_count);
+		spin_lock(&inode->i_lock);
+		bdev->bd_inode->i_count++;
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&bdev_lock);
 		return bdev;
 	}
@@ -595,7 +602,9 @@ static struct block_device *bd_acquire(s
 			 * So, we can access it via ->i_mapping always
 			 * without igrab().
 			 */
-			atomic_inc(&bdev->bd_inode->i_count);
+			spin_lock(&inode->i_lock);
+			bdev->bd_inode->i_count++;
+			spin_unlock(&inode->i_lock);
 			inode->i_bdev = bdev;
 			inode->i_mapping = bdev->bd_inode->i_mapping;
 			list_add(&inode->i_devices, &bdev->bd_inodes);
Index: linux-2.6/fs/ext2/namei.c
===================================================================
--- linux-2.6.orig/fs/ext2/namei.c
+++ linux-2.6/fs/ext2/namei.c
@@ -206,7 +206,9 @@ static int ext2_link (struct dentry * ol
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	err = ext2_add_link(dentry, inode);
 	if (!err) {
Index: linux-2.6/fs/ext3/ialloc.c
===================================================================
--- linux-2.6.orig/fs/ext3/ialloc.c
+++ linux-2.6/fs/ext3/ialloc.c
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
--- linux-2.6.orig/fs/ext3/namei.c
+++ linux-2.6/fs/ext3/namei.c
@@ -2261,7 +2261,9 @@ retry:
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	err = ext3_add_entry(handle, dentry, inode);
 	if (!err) {
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -427,7 +427,7 @@ writeback_single_inode(struct inode *ino
 	unsigned dirty;
 	int ret;
 
-	if (!atomic_read(&inode->i_count))
+	if (!inode->i_count)
 		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
 	else
 		WARN_ON(inode->i_state & I_WILL_FREE);
@@ -551,7 +551,7 @@ select_queue:
 				inode->i_state |= I_DIRTY_PAGES;
 				redirty_tail(inode);
 			}
-		} else if (atomic_read(&inode->i_count)) {
+		} else if (inode->i_count) {
 			/*
 			 * The inode is clean, inuse
 			 */
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -33,14 +33,13 @@
  * inode_hash_lock protects:
  *   inode hash table, i_hash
  * inode->i_lock protects:
- *   i_state
+ *   i_state, i_count
  *
  * Ordering:
  * inode_lock
  *   sb_inode_list_lock
  *     inode->i_lock
- * inode_lock
- *   inode_hash_lock
+ *       inode_hash_lock
  */
 /*
  * This is needed for the following functions:
@@ -151,7 +150,7 @@ int inode_init_always(struct super_block
 	inode->i_sb = sb;
 	inode->i_blkbits = sb->s_blocksize_bits;
 	inode->i_flags = 0;
-	atomic_set(&inode->i_count, 1);
+	inode->i_count = 1;
 	inode->i_op = &empty_iops;
 	inode->i_fop = &empty_fops;
 	inode->i_nlink = 1;
@@ -306,7 +305,8 @@ void __iget(struct inode *inode)
 {
 	assert_spin_locked(&inode->i_lock);
 
-	if (atomic_inc_return(&inode->i_count) != 1)
+	inode->i_count++;
+	if (inode->i_count > 1)
 		return;
 
 	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
@@ -412,7 +412,7 @@ static int invalidate_list(struct list_h
 			continue;
 		}
 		invalidate_inode_buffers(inode);
-		if (!atomic_read(&inode->i_count)) {
+		if (!inode->i_count) {
 			list_move(&inode->i_list, dispose);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
@@ -463,7 +463,7 @@ static int can_unuse(struct inode *inode
 		return 0;
 	if (inode_has_buffers(inode))
 		return 0;
-	if (atomic_read(&inode->i_count))
+	if (inode->i_count)
 		return 0;
 	if (inode->i_data.nrpages)
 		return 0;
@@ -501,7 +501,7 @@ static void prune_icache(int nr_to_scan)
 		inode = list_entry(inode_unused.prev, struct inode, i_list);
 
 		spin_lock(&inode->i_lock);
-		if (inode->i_state || atomic_read(&inode->i_count)) {
+		if (inode->i_state || inode->i_count) {
 			list_move(&inode->i_list, &inode_unused);
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -1290,8 +1290,6 @@ void generic_delete_inode(struct inode *
 {
 	const struct super_operations *op = inode->i_sb->s_op;
 
-	spin_lock(&sb_inode_list_lock);
-	spin_lock(&inode->i_lock);
 	list_del_init(&inode->i_list);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
@@ -1336,8 +1334,6 @@ int generic_detach_inode(struct inode *i
 {
 	struct super_block *sb = inode->i_sb;
 
-	spin_lock(&sb_inode_list_lock);
-	spin_lock(&inode->i_lock);
 	if (!hlist_unhashed(&inode->i_hash)) {
 		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
@@ -1436,8 +1432,24 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state == I_CLEAR);
 
-		if (atomic_dec_and_lock(&inode->i_count, &inode_lock))
+retry:
+		spin_lock(&inode->i_lock);
+		if (inode->i_count == 1) {
+			if (!spin_trylock(&inode_lock)) {
+				spin_unlock(&inode->i_lock);
+				goto retry;
+			}
+			if (!spin_trylock(&sb_inode_list_lock)) {
+				spin_unlock(&inode_lock);
+				spin_unlock(&inode->i_lock);
+				goto retry;
+			}
+			inode->i_count--;
 			iput_final(inode);
+		} else {
+			inode->i_count--;
+			spin_unlock(&inode->i_lock);
+		}
 	}
 }
 EXPORT_SYMBOL(iput);
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -277,7 +277,9 @@ int simple_link(struct dentry *old_dentr
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	dget(dentry);
 	d_instantiate(dentry, inode);
 	return 0;
Index: linux-2.6/fs/locks.c
===================================================================
--- linux-2.6.orig/fs/locks.c
+++ linux-2.6/fs/locks.c
@@ -1375,8 +1375,7 @@ int generic_setlease(struct file *filp,
 		if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
 			goto out;
 		if ((arg == F_WRLCK)
-		    && (dentry->d_count > 1
-			|| (atomic_read(&inode->i_count) > 1)))
+		    && (dentry->d_count > 1 || inode->i_count > 1))
 			goto out;
 	}
 
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -2306,8 +2306,11 @@ static long do_unlinkat(int dfd, const c
 		if (nd.last.name[nd.last.len])
 			goto slashes;
 		inode = dentry->d_inode;
-		if (inode)
-			atomic_inc(&inode->i_count);
+		if (inode) {
+			spin_lock(&inode->i_lock);
+			inode->i_count++;
+			spin_unlock(&inode->i_lock);
+		}
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c
+++ linux-2.6/fs/nfs/dir.c
@@ -1570,7 +1570,9 @@ nfs_link(struct dentry *old_dentry, stru
 	d_drop(dentry);
 	error = NFS_PROTO(dir)->link(inode, dir, &dentry->d_name);
 	if (error == 0) {
-		atomic_inc(&inode->i_count);
+		spin_lock(&inode->i_lock);
+		inode->i_count++;
+		spin_unlock(&inode->i_lock);
 		d_add(dentry, inode);
 	}
 	return error;
Index: linux-2.6/fs/nfs/getroot.c
===================================================================
--- linux-2.6.orig/fs/nfs/getroot.c
+++ linux-2.6/fs/nfs/getroot.c
@@ -55,7 +55,9 @@ static int nfs_superblock_set_dummy_root
 			return -ENOMEM;
 		}
 		/* Circumvent igrab(): we know the inode is not being freed */
-		atomic_inc(&inode->i_count);
+		spin_lock(&inode->i_lock);
+		inode->i_count++;
+		spin_unlock(&inode->i_lock);
 		/*
 		 * Ensure that this dentry is invisible to d_find_alias().
 		 * Otherwise, it may be spliced into the tree by
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -404,23 +404,28 @@ void inotify_unmount_inodes(struct list_
 		 * evict all inodes with zero i_count from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		if (!atomic_read(&inode->i_count))
+		if (!inode->i_count)
 			continue;
 
 		need_iput_tmp = need_iput;
 		need_iput = NULL;
 		/* In case inotify_remove_watch_locked() drops a reference. */
-		if (inode != need_iput_tmp)
+		if (inode != need_iput_tmp) {
+			spin_lock(&inode->i_lock);
 			__iget(inode);
-		else
+			spin_unlock(&inode->i_lock);
+		} else
 			need_iput_tmp = NULL;
 		/* In case the dropping of a reference would nuke next_i. */
-		if ((&next_i->i_sb_list != list) &&
-				atomic_read(&next_i->i_count) &&
-				!(next_i->i_state & (I_CLEAR | I_FREEING |
-					I_WILL_FREE))) {
-			__iget(next_i);
-			need_iput = next_i;
+		if (&next_i->i_sb_list != list) {
+			spin_lock(&next_i->i_lock);
+			if (next_i->i_count &&
+				!(next_i->i_state &
+					(I_CLEAR|I_FREEING|I_WILL_FREE))) {
+				__iget(next_i);
+				need_iput = next_i;
+			}
+			spin_unlock(&next_i->i_lock);
 		}
 
 		/*
@@ -439,11 +444,10 @@ void inotify_unmount_inodes(struct list_
 		mutex_lock(&inode->inotify_mutex);
 		watches = &inode->inotify_watches;
 		list_for_each_entry_safe(watch, next_w, watches, i_list) {
-			struct inotify_handle *ih= watch->ih;
+			struct inotify_handle *ih = watch->ih;
 			get_inotify_watch(watch);
 			mutex_lock(&ih->mutex);
-			ih->in_ops->handle_event(watch, watch->wd, IN_UNMOUNT, 0,
-						 NULL, NULL);
+			ih->in_ops->handle_event(watch, watch->wd, IN_UNMOUNT, 0, NULL, NULL);
 			inotify_remove_watch_locked(ih, watch);
 			mutex_unlock(&ih->mutex);
 			put_inotify_watch(watch);
Index: linux-2.6/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_iops.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_iops.c
@@ -360,7 +360,9 @@ xfs_vn_link(
 	if (unlikely(error))
 		return -error;
 
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	d_instantiate(dentry, inode);
 	return 0;
 }
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h
+++ linux-2.6/fs/xfs/xfs_inode.h
@@ -483,8 +483,10 @@ void		xfs_mark_inode_dirty_sync(xfs_inod
 
 #define IHOLD(ip) \
 do { \
-	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
-	atomic_inc(&(VFS_I(ip)->i_count)); \
+	spin_lock(&VFS_I(ip)->i_lock); \
+	ASSERT(VFS_I(ip)->i_count > 0) ; \
+	VFS_I(ip)->i_count++; \
+	spin_unlock(&VFS_I(ip)->i_lock); \
 	trace_xfs_ihold(ip, _THIS_IP_); \
 } while (0)
 
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -729,7 +729,7 @@ struct inode {
 	struct list_head	i_sb_list;
 	struct list_head	i_dentry;
 	unsigned long		i_ino;
-	atomic_t		i_count;
+	unsigned int		i_count;
 	unsigned int		i_nlink;
 	uid_t			i_uid;
 	gid_t			i_gid;
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c
+++ linux-2.6/ipc/mqueue.c
@@ -769,8 +769,11 @@ SYSCALL_DEFINE1(mq_unlink, const char __
 	}
 
 	inode = dentry->d_inode;
-	if (inode)
-		atomic_inc(&inode->i_count);
+	if (inode) {
+		spin_lock(&inode->i_lock);
+		inode->i_count++;
+		spin_unlock(&inode->i_lock);
+	}
 	err = mnt_want_write(ipc_ns->mq_mnt);
 	if (err)
 		goto out_err;
Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -168,7 +168,9 @@ static void get_futex_key_refs(union fut
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		atomic_inc(&key->shared.inode->i_count);
+		spin_lock(&key->shared.inode->i_lock);
+		key->shared.inode->i_count++;
+		spin_unlock(&key->shared.inode->i_lock);
 		break;
 	case FUT_OFF_MMSHARED:
 		atomic_inc(&key->private.mm->mm_count);
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c
+++ linux-2.6/mm/shmem.c
@@ -1877,7 +1877,9 @@ static int shmem_link(struct dentry *old
 	dir->i_size += BOGO_DIRENT_SIZE;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);	/* New dentry reference */
+	spin_lock(&inode->i_lock);
+	inode->i_count++;	/* New dentry reference */
+	spin_unlock(&inode->i_lock);
 	dget(dentry);		/* Extra pinning count for the created dentry */
 	d_instantiate(dentry, inode);
 out:
Index: linux-2.6/fs/bfs/dir.c
===================================================================
--- linux-2.6.orig/fs/bfs/dir.c
+++ linux-2.6/fs/bfs/dir.c
@@ -176,7 +176,9 @@ static int bfs_link(struct dentry *old,
 	inc_nlink(inode);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	d_instantiate(new, inode);
 	mutex_unlock(&info->bfs_lock);
 	return 0;
Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c
+++ linux-2.6/fs/btrfs/inode.c
@@ -4753,7 +4753,9 @@ static int btrfs_link(struct dentry *old
 	}
 
 	btrfs_set_trans_block_group(trans, dir);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	err = btrfs_add_nondir(trans, dentry, inode, 1, index);
 
Index: linux-2.6/fs/coda/dir.c
===================================================================
--- linux-2.6.orig/fs/coda/dir.c
+++ linux-2.6/fs/coda/dir.c
@@ -303,7 +303,9 @@ static int coda_link(struct dentry *sour
 	}
 
 	coda_dir_update_mtime(dir_inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	d_instantiate(de, inode);
 	inc_nlink(inode);
 
Index: linux-2.6/fs/exofs/inode.c
===================================================================
--- linux-2.6.orig/fs/exofs/inode.c
+++ linux-2.6/fs/exofs/inode.c
@@ -1124,7 +1124,9 @@ static void create_done(struct exofs_io_
 
 	set_obj_created(oi);
 
-	atomic_dec(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count--;
+	spin_unlock(&inode->i_lock);
 	wake_up(&oi->i_wq);
 }
 
@@ -1177,14 +1179,18 @@ struct inode *exofs_new_inode(struct ino
 	/* increment the refcount so that the inode will still be around when we
 	 * reach the callback
 	 */
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
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
--- linux-2.6.orig/fs/exofs/namei.c
+++ linux-2.6/fs/exofs/namei.c
@@ -153,7 +153,9 @@ static int exofs_link(struct dentry *old
 
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	return exofs_add_nondir(dentry, inode);
 }
Index: linux-2.6/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.orig/fs/ext4/ialloc.c
+++ linux-2.6/fs/ext4/ialloc.c
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
--- linux-2.6.orig/fs/ext4/namei.c
+++ linux-2.6/fs/ext4/namei.c
@@ -2340,7 +2340,9 @@ retry:
 
 	inode->i_ctime = ext4_current_time(inode);
 	ext4_inc_count(handle, inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	err = ext4_add_entry(handle, dentry, inode);
 	if (!err) {
Index: linux-2.6/fs/gfs2/ops_inode.c
===================================================================
--- linux-2.6.orig/fs/gfs2/ops_inode.c
+++ linux-2.6/fs/gfs2/ops_inode.c
@@ -253,7 +253,9 @@ out_parent:
 	gfs2_holder_uninit(ghs);
 	gfs2_holder_uninit(ghs + 1);
 	if (!error) {
-		atomic_inc(&inode->i_count);
+		spin_lock(&inode->i_lock);
+		inode->i_count++;
+		spin_unlock(&inode->i_lock);
 		d_instantiate(dentry, inode);
 		mark_inode_dirty(inode);
 	}
Index: linux-2.6/fs/hfsplus/dir.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/dir.c
+++ linux-2.6/fs/hfsplus/dir.c
@@ -301,7 +301,9 @@ static int hfsplus_link(struct dentry *s
 
 	inc_nlink(inode);
 	hfsplus_instantiate(dst_dentry, inode, cnid);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 	HFSPLUS_SB(sb).file_count++;
Index: linux-2.6/fs/hpfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hpfs/inode.c
+++ linux-2.6/fs/hpfs/inode.c
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
--- linux-2.6.orig/fs/jffs2/dir.c
+++ linux-2.6/fs/jffs2/dir.c
@@ -290,7 +290,9 @@ static int jffs2_link (struct dentry *ol
 		mutex_unlock(&f->sem);
 		d_instantiate(dentry, old_dentry->d_inode);
 		dir_i->i_mtime = dir_i->i_ctime = ITIME(now);
-		atomic_inc(&old_dentry->d_inode->i_count);
+		spin_lock(&old_dentry->d_inode->i_lock);
+		old_dentry->d_inode->i_count++;
+		spin_unlock(&old_dentry->d_inode->i_lock);
 	}
 	return ret;
 }
@@ -871,7 +873,9 @@ static int jffs2_rename (struct inode *o
 		printk(KERN_NOTICE "jffs2_rename(): Link succeeded, unlink failed (err %d). You now have a hard link\n", ret);
 		/* Might as well let the VFS know */
 		d_instantiate(new_dentry, old_dentry->d_inode);
-		atomic_inc(&old_dentry->d_inode->i_count);
+		spin_lock(&old_dentry->d_inode->i_lock);
+		old_dentry->d_inode->i_count++;
+		spin_unlock(&old_dentry->d_inode->i_lock);
 		new_dir_i->i_mtime = new_dir_i->i_ctime = ITIME(now);
 		return ret;
 	}
Index: linux-2.6/fs/jfs/jfs_txnmgr.c
===================================================================
--- linux-2.6.orig/fs/jfs/jfs_txnmgr.c
+++ linux-2.6/fs/jfs/jfs_txnmgr.c
@@ -1279,7 +1279,9 @@ int txCommit(tid_t tid,		/* transaction
 	 * lazy commit thread finishes processing
 	 */
 	if (tblk->xflag & COMMIT_DELETE) {
-		atomic_inc(&tblk->u.ip->i_count);
+		spin_lock(&tblk->u.ip->i_lock);
+		tblk->u.ip->i_count++;
+		spin_unlock(&tblk->u.ip->i_lock);
 		/*
 		 * Avoid a rare deadlock
 		 *
Index: linux-2.6/fs/jfs/namei.c
===================================================================
--- linux-2.6.orig/fs/jfs/namei.c
+++ linux-2.6/fs/jfs/namei.c
@@ -839,7 +839,9 @@ static int jfs_link(struct dentry *old_d
 	ip->i_ctime = CURRENT_TIME;
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	mark_inode_dirty(dir);
-	atomic_inc(&ip->i_count);
+	spin_lock(&ip->i_lock);
+	ip->i_count++;
+	spin_unlock(&ip->i_lock);
 
 	iplist[0] = ip;
 	iplist[1] = dir;
Index: linux-2.6/fs/minix/namei.c
===================================================================
--- linux-2.6.orig/fs/minix/namei.c
+++ linux-2.6/fs/minix/namei.c
@@ -101,7 +101,9 @@ static int minix_link(struct dentry * ol
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	return add_nondir(dentry, inode);
 }
 
Index: linux-2.6/fs/nfs/inode.c
===================================================================
--- linux-2.6.orig/fs/nfs/inode.c
+++ linux-2.6/fs/nfs/inode.c
@@ -377,7 +377,7 @@ nfs_fhget(struct super_block *sb, struct
 	dprintk("NFS: nfs_fhget(%s/%Ld ct=%d)\n",
 		inode->i_sb->s_id,
 		(long long)NFS_FILEID(inode),
-		atomic_read(&inode->i_count));
+		inode->i_count);
 
 out:
 	return inode;
@@ -1123,7 +1123,7 @@ static int nfs_update_inode(struct inode
 
 	dfprintk(VFS, "NFS: %s(%s/%ld ct=%d info=0x%x)\n",
 			__func__, inode->i_sb->s_id, inode->i_ino,
-			atomic_read(&inode->i_count), fattr->valid);
+			inode->i_count, fattr->valid);
 
 	if ((fattr->valid & NFS_ATTR_FATTR_FILEID) && nfsi->fileid != fattr->fileid)
 		goto out_fileid;
Index: linux-2.6/fs/nilfs2/mdt.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/mdt.c
+++ linux-2.6/fs/nilfs2/mdt.c
@@ -479,7 +479,7 @@ nilfs_mdt_new_common(struct the_nilfs *n
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
--- linux-2.6.orig/fs/nilfs2/namei.c
+++ linux-2.6/fs/nilfs2/namei.c
@@ -219,7 +219,9 @@ static int nilfs_link(struct dentry *old
 
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	err = nilfs_add_nondir(dentry, inode);
 	if (!err)
Index: linux-2.6/fs/ocfs2/namei.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/namei.c
+++ linux-2.6/fs/ocfs2/namei.c
@@ -722,7 +722,9 @@ static int ocfs2_link(struct dentry *old
 		goto out_commit;
 	}
 
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	dentry->d_op = &ocfs2_dentry_ops;
 	d_instantiate(dentry, inode);
 
Index: linux-2.6/fs/reiserfs/file.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/file.c
+++ linux-2.6/fs/reiserfs/file.c
@@ -39,7 +39,7 @@ static int reiserfs_file_release(struct
 	BUG_ON(!S_ISREG(inode->i_mode));
 
 	/* fast out for when nothing needs to be done */
-	if ((atomic_read(&inode->i_count) > 1 ||
+	if ((inode->i_count > 1 ||
 	     !(REISERFS_I(inode)->i_flags & i_pack_on_close_mask) ||
 	     !tail_has_to_be_packed(inode)) &&
 	    REISERFS_I(inode)->i_prealloc_count <= 0) {
@@ -94,7 +94,7 @@ static int reiserfs_file_release(struct
 	if (!err)
 		err = jbegin_failure;
 
-	if (!err && atomic_read(&inode->i_count) <= 1 &&
+	if (!err && inode->i_count <= 1 &&
 	    (REISERFS_I(inode)->i_flags & i_pack_on_close_mask) &&
 	    tail_has_to_be_packed(inode)) {
 		/* if regular file is released by last holder and it has been
Index: linux-2.6/fs/reiserfs/namei.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/namei.c
+++ linux-2.6/fs/reiserfs/namei.c
@@ -1156,7 +1156,9 @@ static int reiserfs_link(struct dentry *
 	inode->i_ctime = CURRENT_TIME_SEC;
 	reiserfs_update_sd(&th, inode);
 
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	d_instantiate(dentry, inode);
 	retval = journal_end(&th, dir->i_sb, jbegin_count);
 	reiserfs_write_unlock(dir->i_sb);
Index: linux-2.6/fs/reiserfs/stree.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/stree.c
+++ linux-2.6/fs/reiserfs/stree.c
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
--- linux-2.6.orig/fs/sysv/namei.c
+++ linux-2.6/fs/sysv/namei.c
@@ -126,7 +126,9 @@ static int sysv_link(struct dentry * old
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	return add_nondir(dentry, inode);
 }
Index: linux-2.6/fs/ubifs/dir.c
===================================================================
--- linux-2.6.orig/fs/ubifs/dir.c
+++ linux-2.6/fs/ubifs/dir.c
@@ -550,7 +550,9 @@ static int ubifs_link(struct dentry *old
 
 	lock_2_inodes(dir, inode);
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	inode->i_ctime = ubifs_current_time(inode);
 	dir->i_size += sz_change;
 	dir_ui->ui_size = dir->i_size;
Index: linux-2.6/fs/ubifs/super.c
===================================================================
--- linux-2.6.orig/fs/ubifs/super.c
+++ linux-2.6/fs/ubifs/super.c
@@ -342,7 +342,7 @@ static void ubifs_delete_inode(struct in
 		goto out;
 
 	dbg_gen("inode %lu, mode %#x", inode->i_ino, (int)inode->i_mode);
-	ubifs_assert(!atomic_read(&inode->i_count));
+	ubifs_assert(!inode->i_count);
 	ubifs_assert(inode->i_nlink == 0);
 
 	truncate_inode_pages(&inode->i_data, 0);
Index: linux-2.6/fs/udf/namei.c
===================================================================
--- linux-2.6.orig/fs/udf/namei.c
+++ linux-2.6/fs/udf/namei.c
@@ -1101,7 +1101,9 @@ static int udf_link(struct dentry *old_d
 	inc_nlink(inode);
 	inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	d_instantiate(dentry, inode);
 	unlock_kernel();
 
Index: linux-2.6/fs/ufs/namei.c
===================================================================
--- linux-2.6.orig/fs/ufs/namei.c
+++ linux-2.6/fs/ufs/namei.c
@@ -180,7 +180,9 @@ static int ufs_link (struct dentry * old
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	error = ufs_add_nondir(dentry, inode);
 	unlock_kernel();
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c
+++ linux-2.6/fs/notify/inode_mark.c
@@ -382,24 +382,30 @@ void fsnotify_unmount_inodes(struct list
 		 * evict all inodes with zero i_count from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		if (!atomic_read(&inode->i_count))
+		if (!inode->i_count)
 			continue;
 
 		need_iput_tmp = need_iput;
 		need_iput = NULL;
 
 		/* In case fsnotify_inode_delete() drops a reference. */
-		if (inode != need_iput_tmp)
+		if (inode != need_iput_tmp) {
+			spin_lock(&inode->i_lock);
 			__iget(inode);
-		else
+			spin_unlock(&inode->i_lock);
+		} else
 			need_iput_tmp = NULL;
 
 		/* In case the dropping of a reference would nuke next_i. */
-		if ((&next_i->i_sb_list != list) &&
-		    atomic_read(&next_i->i_count) &&
-		    !(next_i->i_state & (I_CLEAR | I_FREEING | I_WILL_FREE))) {
-			__iget(next_i);
-			need_iput = next_i;
+		if (&next_i->i_sb_list != list) {
+			spin_lock(&next_i->i_lock);
+			if (next_i->i_count &&
+				!(next_i->i_state &
+					(I_CLEAR | I_FREEING | I_WILL_FREE))) {
+				__iget(next_i);
+				need_iput = next_i;
+			}
+			spin_unlock(&next_i->i_lock);
 		}
 
 		/*
Index: linux-2.6/fs/ntfs/super.c
===================================================================
--- linux-2.6.orig/fs/ntfs/super.c
+++ linux-2.6/fs/ntfs/super.c
@@ -2930,7 +2930,9 @@ static int ntfs_fill_super(struct super_
 	}
 	if ((sb->s_root = d_alloc_root(vol->root_ino))) {
 		/* We increment i_count simulating an ntfs_iget(). */
-		atomic_inc(&vol->root_ino->i_count);
+		spin_lock(&vol->root_ino->i_lock);
+		vol->root_ino->i_count++;
+		spin_unlock(&vol->root_ino->i_lock);
 		ntfs_debug("Exiting, status successful.");
 		/* Release the default upcase if it has no users. */
 		mutex_lock(&ntfs_lock);
Index: linux-2.6/fs/cifs/inode.c
===================================================================
--- linux-2.6.orig/fs/cifs/inode.c
+++ linux-2.6/fs/cifs/inode.c
@@ -1612,7 +1612,7 @@ int cifs_revalidate_dentry(struct dentry
 	}
 
 	cFYI(1, "Revalidate: %s inode 0x%p count %d dentry: 0x%p d_time %ld "
-		 "jiffies %ld", full_path, inode, inode->i_count.counter,
+		 "jiffies %ld", full_path, inode, inode->i_count,
 		 dentry, dentry->d_time, jiffies);
 
 	if (CIFS_SB(sb)->tcon->unix_ext)
Index: linux-2.6/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_trace.h
+++ linux-2.6/fs/xfs/linux-2.6/xfs_trace.h
@@ -576,7 +576,7 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
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
--- linux-2.6.orig/net/socket.c
+++ linux-2.6/net/socket.c
@@ -386,7 +386,9 @@ static int sock_alloc_file(struct socket
 		  &socket_file_ops);
 	if (unlikely(!file)) {
 		/* drop dentry, keep inode */
-		atomic_inc(&path.dentry->d_inode->i_count);
+		spin_lock(&path.dentry->d_inode->i_lock);
+		path.dentry->d_inode->i_count++;
+		spin_unlock(&path.dentry->d_inode->i_lock);
 		path_put(&path);
 		put_unused_fd(fd);
 		return -ENFILE;


