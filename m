Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab0JSECS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:02:18 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28444 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932230Ab0JSD4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSoUA
Message-Id: <20101019034656.303425354@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:24 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 08/35] fs: icache lock i_count
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect inode->i_count with i_lock, rather than having it atomic.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 arch/powerpc/platforms/cell/spufs/file.c |    2 -
 drivers/staging/pohmelfs/inode.c         |   10 ++++----
 fs/9p/vfs_inode.c                        |    4 ++-
 fs/affs/inode.c                          |    4 ++-
 fs/afs/dir.c                             |    4 ++-
 fs/anon_inodes.c                         |    4 ++-
 fs/bfs/dir.c                             |    4 ++-
 fs/block_dev.c                           |   15 ++++++++++--
 fs/btrfs/inode.c                         |   17 ++++++++++----
 fs/ceph/mds_client.c                     |    2 -
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
 fs/inode.c                               |   36 +++++++++++++++++++++----------
 fs/jffs2/dir.c                           |    8 +++++-
 fs/jfs/jfs_txnmgr.c                      |    4 ++-
 fs/jfs/namei.c                           |    4 ++-
 fs/libfs.c                               |    4 ++-
 fs/locks.c                               |    4 +--
 fs/logfs/dir.c                           |    4 ++-
 fs/logfs/readwrite.c                     |    2 -
 fs/minix/namei.c                         |    4 ++-
 fs/namei.c                               |    7 ++++--
 fs/nfs/dir.c                             |    4 ++-
 fs/nfs/getroot.c                         |    4 ++-
 fs/nfs/inode.c                           |    4 +--
 fs/nfs/nfs4state.c                       |    2 -
 fs/nfs/write.c                           |    2 -
 fs/nilfs2/mdt.c                          |    2 -
 fs/nilfs2/namei.c                        |    4 ++-
 fs/notify/inode_mark.c                   |    4 +--
 fs/ntfs/super.c                          |    4 ++-
 fs/ocfs2/namei.c                         |    4 ++-
 fs/reiserfs/namei.c                      |    4 ++-
 fs/reiserfs/stree.c                      |    2 -
 fs/sysv/namei.c                          |    4 ++-
 fs/ubifs/dir.c                           |    4 ++-
 fs/ubifs/super.c                         |    2 -
 fs/udf/namei.c                           |    4 ++-
 fs/ufs/namei.c                           |    4 ++-
 fs/xfs/linux-2.6/xfs_iops.c              |    4 ++-
 fs/xfs/linux-2.6/xfs_trace.h             |    2 -
 fs/xfs/xfs_inode.h                       |    6 +++--
 include/linux/fs.h                       |    2 -
 ipc/mqueue.c                             |    7 ++++--
 kernel/futex.c                           |    4 ++-
 mm/shmem.c                               |    4 ++-
 net/socket.c                             |    4 ++-
 58 files changed, 200 insertions(+), 90 deletions(-)

Index: linux-2.6/arch/powerpc/platforms/cell/spufs/file.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/file.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/file.c	2010-10-19 14:19:16.000000000 +1100
@@ -1549,7 +1549,7 @@
 	if (ctx->owner != current->mm)
 		return -EINVAL;
 
-	if (atomic_read(&inode->i_count) != 1)
+	if (inode->i_count != 1)
 		return -EBUSY;
 
 	mutex_lock(&ctx->mapping_lock);
Index: linux-2.6/fs/affs/inode.c
===================================================================
--- linux-2.6.orig/fs/affs/inode.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/affs/inode.c	2010-10-19 14:19:18.000000000 +1100
@@ -388,7 +388,9 @@
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
--- linux-2.6.orig/fs/afs/dir.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/afs/dir.c	2010-10-19 14:19:19.000000000 +1100
@@ -1045,7 +1045,9 @@
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
--- linux-2.6.orig/fs/anon_inodes.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/anon_inodes.c	2010-10-19 14:19:22.000000000 +1100
@@ -114,7 +114,9 @@
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
--- linux-2.6.orig/fs/block_dev.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/block_dev.c	2010-10-19 14:19:28.000000000 +1100
@@ -550,7 +550,12 @@
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
 
@@ -580,7 +585,9 @@
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
@@ -596,7 +603,9 @@
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
--- linux-2.6.orig/fs/ext2/namei.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/ext2/namei.c	2010-10-19 14:19:18.000000000 +1100
@@ -206,7 +206,9 @@
 
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
--- linux-2.6.orig/fs/ext3/ialloc.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/ext3/ialloc.c	2010-10-19 14:19:16.000000000 +1100
@@ -100,9 +100,9 @@
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
--- linux-2.6.orig/fs/ext3/namei.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/ext3/namei.c	2010-10-19 14:19:19.000000000 +1100
@@ -2260,7 +2260,9 @@
 
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
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:34.000000000 +1100
@@ -317,7 +317,7 @@
 	unsigned dirty;
 	int ret;
 
-	if (!atomic_read(&inode->i_count))
+	if (!inode->i_count)
 		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
 	else
 		WARN_ON(inode->i_state & I_WILL_FREE);
@@ -414,7 +414,7 @@
 			 * completion.
 			 */
 			redirty_tail(inode);
-		} else if (atomic_read(&inode->i_count)) {
+		} else if (inode->i_count) {
 			/*
 			 * The inode is clean, inuse
 			 */
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:34.000000000 +1100
@@ -32,14 +32,13 @@
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
@@ -150,7 +149,7 @@
 	inode->i_sb = sb;
 	inode->i_blkbits = sb->s_blocksize_bits;
 	inode->i_flags = 0;
-	atomic_set(&inode->i_count, 1);
+	inode->i_count = 1;
 	inode->i_op = &empty_iops;
 	inode->i_fop = &empty_fops;
 	inode->i_nlink = 1;
@@ -301,7 +300,8 @@
 {
 	assert_spin_locked(&inode->i_lock);
 
-	if (atomic_inc_return(&inode->i_count) != 1)
+	inode->i_count++;
+	if (inode->i_count > 1)
 		return;
 
 	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
@@ -407,7 +407,7 @@
 			continue;
 		}
 		invalidate_inode_buffers(inode);
-		if (!atomic_read(&inode->i_count)) {
+		if (!inode->i_count) {
 			list_move(&inode->i_list, dispose);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
@@ -457,7 +457,7 @@
 		return 0;
 	if (inode_has_buffers(inode))
 		return 0;
-	if (atomic_read(&inode->i_count))
+	if (inode->i_count)
 		return 0;
 	if (inode->i_data.nrpages)
 		return 0;
@@ -495,7 +495,7 @@
 		inode = list_entry(inode_unused.prev, struct inode, i_list);
 
 		spin_lock(&inode->i_lock);
-		if (inode->i_state || atomic_read(&inode->i_count)) {
+		if (inode->i_state || inode->i_count) {
 			list_move(&inode->i_list, &inode_unused);
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -1310,8 +1310,6 @@
 	const struct super_operations *op = inode->i_sb->s_op;
 	int drop;
 
-	spin_lock(&sb_inode_list_lock);
-	spin_lock(&inode->i_lock);
 	if (op && op->drop_inode)
 		drop = op->drop_inode(inode);
 	else
@@ -1376,8 +1374,24 @@
 	if (inode) {
 		BUG_ON(inode->i_state & I_CLEAR);
 
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
--- linux-2.6.orig/fs/libfs.c	2010-10-19 14:17:28.000000000 +1100
+++ linux-2.6/fs/libfs.c	2010-10-19 14:19:18.000000000 +1100
@@ -255,7 +255,9 @@
 
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
--- linux-2.6.orig/fs/locks.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/locks.c	2010-10-19 14:19:16.000000000 +1100
@@ -1375,8 +1375,8 @@
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
--- linux-2.6.orig/fs/namei.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/namei.c	2010-10-19 14:19:18.000000000 +1100
@@ -2290,8 +2290,11 @@
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
--- linux-2.6.orig/fs/nfs/dir.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/nfs/dir.c	2010-10-19 14:19:18.000000000 +1100
@@ -1580,7 +1580,9 @@
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
Index: linux-2.6/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_iops.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_iops.c	2010-10-19 14:19:18.000000000 +1100
@@ -352,7 +352,9 @@
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
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/xfs/xfs_inode.h	2010-10-19 14:19:18.000000000 +1100
@@ -481,8 +481,10 @@
 
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
--- linux-2.6.orig/include/linux/fs.h	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-19 14:19:33.000000000 +1100
@@ -728,7 +728,7 @@
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
--- linux-2.6.orig/ipc/mqueue.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/ipc/mqueue.c	2010-10-19 14:19:28.000000000 +1100
@@ -768,8 +768,11 @@
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
--- linux-2.6.orig/kernel/futex.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/kernel/futex.c	2010-10-19 14:19:18.000000000 +1100
@@ -168,7 +168,9 @@
 
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
--- linux-2.6.orig/mm/shmem.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/mm/shmem.c	2010-10-19 14:19:31.000000000 +1100
@@ -1903,7 +1903,9 @@
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
--- linux-2.6.orig/fs/bfs/dir.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/bfs/dir.c	2010-10-19 14:19:18.000000000 +1100
@@ -176,7 +176,9 @@
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
--- linux-2.6.orig/fs/btrfs/inode.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/btrfs/inode.c	2010-10-19 14:19:31.000000000 +1100
@@ -1964,8 +1964,13 @@
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
@@ -2718,10 +2723,10 @@
 		return ERR_PTR(-ENOSPC);
 
 	/* check if there is someone else holds reference */
-	if (S_ISDIR(inode->i_mode) && atomic_read(&inode->i_count) > 1)
+	if (S_ISDIR(inode->i_mode) && inode->i_count > 1)
 		return ERR_PTR(-ENOSPC);
 
-	if (atomic_read(&inode->i_count) > 2)
+	if (inode->i_count > 2)
 		return ERR_PTR(-ENOSPC);
 
 	if (xchg(&root->fs_info->enospc_unlink, 1))
@@ -3939,7 +3944,7 @@
 		inode = igrab(&entry->vfs_inode);
 		if (inode) {
 			spin_unlock(&root->inode_lock);
-			if (atomic_read(&inode->i_count) > 1)
+			if (inode->i_count > 1)
 				d_prune_aliases(inode);
 			/*
 			 * btrfs_drop_inode will have it removed from
@@ -4758,7 +4763,9 @@
 	}
 
 	btrfs_set_trans_block_group(trans, dir);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	err = btrfs_add_nondir(trans, dentry, inode, 1, index);
 
Index: linux-2.6/fs/coda/dir.c
===================================================================
--- linux-2.6.orig/fs/coda/dir.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/coda/dir.c	2010-10-19 14:19:18.000000000 +1100
@@ -303,7 +303,9 @@
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
--- linux-2.6.orig/fs/exofs/inode.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/exofs/inode.c	2010-10-19 14:19:18.000000000 +1100
@@ -1107,7 +1107,9 @@
 
 	set_obj_created(oi);
 
-	atomic_dec(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count--;
+	spin_unlock(&inode->i_lock);
 	wake_up(&oi->i_wq);
 }
 
@@ -1160,14 +1162,18 @@
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
--- linux-2.6.orig/fs/exofs/namei.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/exofs/namei.c	2010-10-19 14:19:18.000000000 +1100
@@ -153,7 +153,9 @@
 
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
--- linux-2.6.orig/fs/ext4/ialloc.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/ext4/ialloc.c	2010-10-19 14:19:16.000000000 +1100
@@ -189,9 +189,9 @@
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
--- linux-2.6.orig/fs/ext4/namei.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/ext4/namei.c	2010-10-19 14:19:18.000000000 +1100
@@ -2312,7 +2312,9 @@
 
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
--- linux-2.6.orig/fs/gfs2/ops_inode.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/gfs2/ops_inode.c	2010-10-19 14:19:19.000000000 +1100
@@ -253,7 +253,9 @@
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
--- linux-2.6.orig/fs/hfsplus/dir.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/hfsplus/dir.c	2010-10-19 14:19:18.000000000 +1100
@@ -301,7 +301,9 @@
 
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
--- linux-2.6.orig/fs/hpfs/inode.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/hpfs/inode.c	2010-10-19 14:19:16.000000000 +1100
@@ -183,7 +183,7 @@
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
--- linux-2.6.orig/fs/jffs2/dir.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/jffs2/dir.c	2010-10-19 14:19:18.000000000 +1100
@@ -289,7 +289,9 @@
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
@@ -864,7 +866,9 @@
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
--- linux-2.6.orig/fs/jfs/jfs_txnmgr.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/jfs/jfs_txnmgr.c	2010-10-19 14:19:19.000000000 +1100
@@ -1279,7 +1279,9 @@
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
--- linux-2.6.orig/fs/jfs/namei.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/jfs/namei.c	2010-10-19 14:19:19.000000000 +1100
@@ -839,7 +839,9 @@
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
--- linux-2.6.orig/fs/minix/namei.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/minix/namei.c	2010-10-19 14:19:19.000000000 +1100
@@ -101,7 +101,9 @@
 
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
--- linux-2.6.orig/fs/nfs/inode.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/nfs/inode.c	2010-10-19 14:19:29.000000000 +1100
@@ -384,7 +384,7 @@
 	dprintk("NFS: nfs_fhget(%s/%Ld ct=%d)\n",
 		inode->i_sb->s_id,
 		(long long)NFS_FILEID(inode),
-		atomic_read(&inode->i_count));
+		inode->i_count);
 
 out:
 	return inode;
@@ -1190,7 +1190,7 @@
 
 	dfprintk(VFS, "NFS: %s(%s/%ld ct=%d info=0x%x)\n",
 			__func__, inode->i_sb->s_id, inode->i_ino,
-			atomic_read(&inode->i_count), fattr->valid);
+			inode->i_count, fattr->valid);
 
 	if ((fattr->valid & NFS_ATTR_FATTR_FILEID) && nfsi->fileid != fattr->fileid)
 		goto out_fileid;
Index: linux-2.6/fs/nilfs2/mdt.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/mdt.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/nilfs2/mdt.c	2010-10-19 14:19:21.000000000 +1100
@@ -480,7 +480,7 @@
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
--- linux-2.6.orig/fs/nilfs2/namei.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/nilfs2/namei.c	2010-10-19 14:19:18.000000000 +1100
@@ -219,7 +219,9 @@
 
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
--- linux-2.6.orig/fs/ocfs2/namei.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/ocfs2/namei.c	2010-10-19 14:19:19.000000000 +1100
@@ -741,7 +741,9 @@
 		goto out_commit;
 	}
 
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	dentry->d_op = &ocfs2_dentry_ops;
 	d_instantiate(dentry, inode);
 
Index: linux-2.6/fs/reiserfs/namei.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/namei.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/reiserfs/namei.c	2010-10-19 14:19:18.000000000 +1100
@@ -1156,7 +1156,9 @@
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
--- linux-2.6.orig/fs/reiserfs/stree.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/reiserfs/stree.c	2010-10-19 14:19:16.000000000 +1100
@@ -1477,7 +1477,7 @@
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
--- linux-2.6.orig/fs/sysv/namei.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/sysv/namei.c	2010-10-19 14:19:19.000000000 +1100
@@ -126,7 +126,9 @@
 
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
--- linux-2.6.orig/fs/ubifs/dir.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/ubifs/dir.c	2010-10-19 14:19:18.000000000 +1100
@@ -550,7 +550,9 @@
 
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
--- linux-2.6.orig/fs/ubifs/super.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/ubifs/super.c	2010-10-19 14:19:29.000000000 +1100
@@ -342,7 +342,7 @@
 		goto out;
 
 	dbg_gen("inode %lu, mode %#x", inode->i_ino, (int)inode->i_mode);
-	ubifs_assert(!atomic_read(&inode->i_count));
+	ubifs_assert(!inode->i_count);
 
 	truncate_inode_pages(&inode->i_data, 0);
 
Index: linux-2.6/fs/udf/namei.c
===================================================================
--- linux-2.6.orig/fs/udf/namei.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/udf/namei.c	2010-10-19 14:19:18.000000000 +1100
@@ -1101,7 +1101,9 @@
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
--- linux-2.6.orig/fs/ufs/namei.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/ufs/namei.c	2010-10-19 14:19:18.000000000 +1100
@@ -180,7 +180,9 @@
 
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
--- linux-2.6.orig/fs/notify/inode_mark.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/notify/inode_mark.c	2010-10-19 14:19:32.000000000 +1100
@@ -260,7 +260,7 @@
 		 * evict all inodes with zero i_count from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		if (!atomic_read(&inode->i_count)) {
+		if (!inode->i_count) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
@@ -278,7 +278,7 @@
 		/* In case the dropping of a reference would nuke next_i. */
 		if (&next_i->i_sb_list != list) {
 			spin_lock(&next_i->i_lock);
-			if (atomic_read(&next_i->i_count) &&
+			if (next_i->i_count &&
 			    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
 				__iget(next_i);
 				need_iput = next_i;
Index: linux-2.6/fs/ntfs/super.c
===================================================================
--- linux-2.6.orig/fs/ntfs/super.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/ntfs/super.c	2010-10-19 14:19:18.000000000 +1100
@@ -2930,7 +2930,9 @@
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
--- linux-2.6.orig/fs/cifs/inode.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/cifs/inode.c	2010-10-19 14:19:16.000000000 +1100
@@ -1641,7 +1641,7 @@
 	}
 
 	cFYI(1, "Revalidate: %s inode 0x%p count %d dentry: 0x%p d_time %ld "
-		 "jiffies %ld", full_path, inode, inode->i_count.counter,
+		 "jiffies %ld", full_path, inode, inode->i_count,
 		 dentry, dentry->d_time, jiffies);
 
 	if (CIFS_SB(sb)->tcon->unix_ext)
Index: linux-2.6/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_trace.h	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_trace.h	2010-10-19 14:19:16.000000000 +1100
@@ -599,7 +599,7 @@
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
--- linux-2.6.orig/net/socket.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/net/socket.c	2010-10-19 14:19:29.000000000 +1100
@@ -377,7 +377,9 @@
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
Index: linux-2.6/fs/nfs/nfs4state.c
===================================================================
--- linux-2.6.orig/fs/nfs/nfs4state.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/nfs/nfs4state.c	2010-10-19 14:18:58.000000000 +1100
@@ -506,8 +506,8 @@
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
--- linux-2.6.orig/fs/nfs/write.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/nfs/write.c	2010-10-19 14:19:18.000000000 +1100
@@ -390,7 +390,7 @@
 	error = radix_tree_insert(&nfsi->nfs_page_tree, req->wb_index, req);
 	BUG_ON(error);
 	if (!nfsi->npages) {
-		igrab(inode);
+		__iget(inode);
 		if (nfs_have_delegation(inode, FMODE_WRITE))
 			nfsi->change_attr++;
 	}
Index: linux-2.6/fs/nfs/getroot.c
===================================================================
--- linux-2.6.orig/fs/nfs/getroot.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/nfs/getroot.c	2010-10-19 14:19:18.000000000 +1100
@@ -55,7 +55,9 @@
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
Index: linux-2.6/drivers/staging/pohmelfs/inode.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/inode.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/drivers/staging/pohmelfs/inode.c	2010-10-19 14:19:28.000000000 +1100
@@ -1289,11 +1289,11 @@
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
 
@@ -1305,7 +1305,7 @@
 		pi = POHMELFS_I(inode);
 
 		dprintk("%s: ino: %llu, pi: %p, inode: %p, i_count: %u.\n",
-				__func__, pi->ino, pi, inode, atomic_read(&inode->i_count));
+				__func__, pi->ino, pi, inode, inode->i_count);
 
 		/*
 		 * These are special inodes, they were created during
@@ -1313,7 +1313,7 @@
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
--- linux-2.6.orig/fs/9p/vfs_inode.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/9p/vfs_inode.c	2010-10-19 14:19:28.000000000 +1100
@@ -1791,7 +1791,9 @@
 		/* Caching disabled. No need to get upto date stat info.
 		 * This dentry will be released immediately. So, just i_count++
 		 */
-		atomic_inc(&old_dentry->d_inode->i_count);
+		spin_lock(&old_dentry->d_inode->i_lock);
+		old_dentry->d_inode->i_count++;
+		spin_unlock(&old_dentry->d_inode->i_lock);
 	}
 
 	dentry->d_op = old_dentry->d_op;
Index: linux-2.6/fs/ceph/mds_client.c
===================================================================
--- linux-2.6.orig/fs/ceph/mds_client.c	2010-10-19 14:17:26.000000000 +1100
+++ linux-2.6/fs/ceph/mds_client.c	2010-10-19 14:19:16.000000000 +1100
@@ -1102,7 +1102,7 @@
 		spin_unlock(&inode->i_lock);
 		d_prune_aliases(inode);
 		dout("trim_caps_cb %p cap %p  pruned, count now %d\n",
-		     inode, cap, atomic_read(&inode->i_count));
+		     inode, cap, inode->i_count);
 		return 0;
 	}
 
Index: linux-2.6/fs/logfs/dir.c
===================================================================
--- linux-2.6.orig/fs/logfs/dir.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/logfs/dir.c	2010-10-19 14:19:18.000000000 +1100
@@ -569,7 +569,9 @@
 		return -EMLINK;
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	inode->i_nlink++;
 	mark_inode_dirty_sync(inode);
 
Index: linux-2.6/fs/logfs/readwrite.c
===================================================================
--- linux-2.6.orig/fs/logfs/readwrite.c	2010-10-19 14:17:25.000000000 +1100
+++ linux-2.6/fs/logfs/readwrite.c	2010-10-19 14:19:16.000000000 +1100
@@ -1002,7 +1002,7 @@
 {
 	struct logfs_inode *li = logfs_inode(inode);
 
-	if ((inode->i_nlink == 0) && atomic_read(&inode->i_count) == 1)
+	if ((inode->i_nlink == 0) && inode->i_count == 1)
 		return 0;
 
 	if (bix < I0_BLOCKS)


