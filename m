Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab0I2MTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:19:32 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:48374 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755537Ab0I2MT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:26 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/17] fs: icache lock i_count
Date: Wed, 29 Sep 2010 22:18:37 +1000
Message-Id: <1285762729-17928-6-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

the inode reference count is currently an atomic variable so that it can be
sampled/modified outside the inode_lock. However, the inode_lock is still
needed to synchronise the final reference count and checks against the inode
state.

With the inode state now protected by a per-inode lock, we can protect the
inode reference count with the same per-inode lock and still check and modify
the count and state atomically. By using the i_lock in this manner, we no
longer need an atomic reference count field, so convert all the reference
counting to be protected by the inode->i_lock and change i_count to a
non-atomic variable.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 arch/powerpc/platforms/cell/spufs/file.c |    2 +-
 drivers/staging/pohmelfs/inode.c         |   14 +++++++----
 fs/9p/vfs_inode.c                        |    4 ++-
 fs/affs/inode.c                          |    4 ++-
 fs/afs/dir.c                             |    4 ++-
 fs/anon_inodes.c                         |    4 ++-
 fs/bfs/dir.c                             |    4 ++-
 fs/block_dev.c                           |   15 ++++++++++--
 fs/btrfs/inode.c                         |   23 +++++++++++++++----
 fs/ceph/mds_client.c                     |    2 +-
 fs/cifs/inode.c                          |    2 +-
 fs/coda/dir.c                            |    4 ++-
 fs/exofs/inode.c                         |   12 +++++++--
 fs/exofs/namei.c                         |    4 ++-
 fs/ext2/namei.c                          |    4 ++-
 fs/ext3/ialloc.c                         |    4 +-
 fs/ext3/namei.c                          |    4 ++-
 fs/ext4/ialloc.c                         |    4 +-
 fs/ext4/namei.c                          |    4 ++-
 fs/fs-writeback.c                        |    4 +-
 fs/gfs2/ops_inode.c                      |    4 ++-
 fs/hfsplus/dir.c                         |    4 ++-
 fs/hpfs/inode.c                          |    2 +-
 fs/inode.c                               |   36 ++++++++++++++++++++---------
 fs/jffs2/dir.c                           |    8 +++++-
 fs/jfs/jfs_txnmgr.c                      |    4 ++-
 fs/jfs/namei.c                           |    4 ++-
 fs/libfs.c                               |    4 ++-
 fs/locks.c                               |    2 +-
 fs/logfs/dir.c                           |    4 ++-
 fs/logfs/readwrite.c                     |    6 ++++-
 fs/minix/namei.c                         |    4 ++-
 fs/namei.c                               |    7 ++++-
 fs/nfs/dir.c                             |    4 ++-
 fs/nfs/getroot.c                         |    4 ++-
 fs/nfs/inode.c                           |    4 +-
 fs/nfs/nfs4state.c                       |    2 +-
 fs/nfs/write.c                           |    2 +-
 fs/nilfs2/mdt.c                          |    2 +-
 fs/nilfs2/namei.c                        |    4 ++-
 fs/notify/inode_mark.c                   |   21 ++++++++++------
 fs/ntfs/super.c                          |    4 ++-
 fs/ocfs2/namei.c                         |    4 ++-
 fs/reiserfs/namei.c                      |    4 ++-
 fs/reiserfs/stree.c                      |    2 +-
 fs/sysv/namei.c                          |    4 ++-
 fs/ubifs/dir.c                           |    4 ++-
 fs/ubifs/super.c                         |    2 +-
 fs/udf/namei.c                           |    4 ++-
 fs/ufs/namei.c                           |    4 ++-
 fs/xfs/linux-2.6/xfs_iops.c              |    4 ++-
 fs/xfs/linux-2.6/xfs_trace.h             |    2 +-
 fs/xfs/xfs_inode.h                       |    6 +++-
 include/linux/fs.h                       |    2 +-
 ipc/mqueue.c                             |    7 ++++-
 kernel/futex.c                           |    4 ++-
 mm/shmem.c                               |    4 ++-
 net/socket.c                             |    4 ++-
 58 files changed, 224 insertions(+), 95 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index 1a40da9..79238ba 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -1549,7 +1549,7 @@ static int spufs_mfc_open(struct inode *inode, struct file *file)
 	if (ctx->owner != current->mm)
 		return -EINVAL;
 
-	if (atomic_read(&inode->i_count) != 1)
+	if (inode->i_count != 1)
 		return -EBUSY;
 
 	mutex_lock(&ctx->mapping_lock);
diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index 97dae29..2dc95dd 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -1289,13 +1289,15 @@ static void pohmelfs_put_super(struct super_block *sb)
 		dprintk("%s: ino: %llu, pi: %p, inode: %p, count: %u.\n",
 				__func__, pi->ino, pi, inode, count);
 
-		if (atomic_read(&inode->i_count) != count) {
+		spin_lock(&inode->i_lock);
+		if (inode->i_count) != count) {
 			printk("%s: ino: %llu, pi: %p, inode: %p, count: %u, i_count: %d.\n",
 					__func__, pi->ino, pi, inode, count,
-					atomic_read(&inode->i_count));
-			count = atomic_read(&inode->i_count);
+					inode->i_count);
+			count = inode->i_count;
 			in_drop_list++;
 		}
+		spin_unlock(&inode->i_lock);
 
 		while (count--)
 			iput(&pi->vfs_inode);
@@ -1305,7 +1307,7 @@ static void pohmelfs_put_super(struct super_block *sb)
 		pi = POHMELFS_I(inode);
 
 		dprintk("%s: ino: %llu, pi: %p, inode: %p, i_count: %u.\n",
-				__func__, pi->ino, pi, inode, atomic_read(&inode->i_count));
+				__func__, pi->ino, pi, inode, inode->i_count);
 
 		/*
 		 * These are special inodes, they were created during
@@ -1313,7 +1315,9 @@ static void pohmelfs_put_super(struct super_block *sb)
 		 * so they live here with reference counter being 1 and prevent
 		 * umount from succeed since it believes that they are busy.
 		 */
-		count = atomic_read(&inode->i_count);
+		spin_lock(&inode->i_lock);
+		count = inode->i_count;
+		spin_lock(&inode->i_lock);
 		if (count) {
 			list_del_init(&inode->i_sb_list);
 			while (count--)
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 9e670d5..5e1d774 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1791,7 +1791,9 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 		/* Caching disabled. No need to get upto date stat info.
 		 * This dentry will be released immediately. So, just i_count++
 		 */
-		atomic_inc(&old_dentry->d_inode->i_count);
+		spin_lock(&old_dentry->d_inode->i_lock);
+		old_dentry->d_inode->i_count++;
+		spin_unlock(&old_dentry->d_inode->i_lock);
 	}
 
 	dentry->d_op = old_dentry->d_op;
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 3a0fdec..cb9e773 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -388,7 +388,9 @@ affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s3
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
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 0d38c09..4d8598c 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1045,7 +1045,9 @@ static int afs_link(struct dentry *from, struct inode *dir,
 	if (ret < 0)
 		goto link_error;
 
-	atomic_inc(&vnode->vfs_inode.i_count);
+	spin_lock(&vnode->vfs_inode.i_lock);
+	vnode->vfs_inode.i_count++;
+	spin_unlock(&vnode->vfs_inode.i_lock);
 	d_instantiate(dentry, &vnode->vfs_inode);
 	key_put(key);
 	_leave(" = 0");
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index e4b75d6..c50dc2a 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -114,7 +114,9 @@ struct file *anon_inode_getfile(const char *name,
 	 * so we can avoid doing an igrab() and we can use an open-coded
 	 * atomic_inc().
 	 */
-	atomic_inc(&anon_inode_inode->i_count);
+	spin_lock(&anon_inode_inode->i_lock);
+	anon_inode_inode->i_count++;
+	spin_unlock(&anon_inode_inode->i_lock);
 
 	path.dentry->d_op = &anon_inodefs_dentry_operations;
 	d_instantiate(path.dentry, anon_inode_inode);
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index d967e05..d42fc72 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -176,7 +176,9 @@ static int bfs_link(struct dentry *old, struct inode *dir,
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
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 50e8c85..140451c 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -550,7 +550,12 @@ EXPORT_SYMBOL(bdget);
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
 
@@ -580,7 +585,9 @@ static struct block_device *bd_acquire(struct inode *inode)
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
@@ -596,7 +603,9 @@ static struct block_device *bd_acquire(struct inode *inode)
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
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c038644..ffb8aec 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1964,8 +1964,13 @@ void btrfs_add_delayed_iput(struct inode *inode)
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
@@ -2718,11 +2723,17 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 		return ERR_PTR(-ENOSPC);
 
 	/* check if there is someone else holds reference */
-	if (S_ISDIR(inode->i_mode) && atomic_read(&inode->i_count) > 1)
+	spin_lock(&inode->i_lock);
+	if (S_ISDIR(inode->i_mode) && inode->i_count > 1) {
+		spin_unlock(&inode->i_lock);
 		return ERR_PTR(-ENOSPC);
+	}
 
-	if (atomic_read(&inode->i_count) > 2)
+	if (inode->i_count > 2) {
+		spin_unlock(&inode->i_lock);
 		return ERR_PTR(-ENOSPC);
+	}
+	spin_unlock(&inode->i_lock);
 
 	if (xchg(&root->fs_info->enospc_unlink, 1))
 		return ERR_PTR(-ENOSPC);
@@ -3939,7 +3950,7 @@ again:
 		inode = igrab(&entry->vfs_inode);
 		if (inode) {
 			spin_unlock(&root->inode_lock);
-			if (atomic_read(&inode->i_count) > 1)
+			if (inode->i_count > 1)
 				d_prune_aliases(inode);
 			/*
 			 * btrfs_drop_inode will have it removed from
@@ -4758,7 +4769,9 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	}
 
 	btrfs_set_trans_block_group(trans, dir);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	err = btrfs_add_nondir(trans, dentry, inode, 1, index);
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f091b13..cb4d673 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1102,7 +1102,7 @@ static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
 		spin_unlock(&inode->i_lock);
 		d_prune_aliases(inode);
 		dout("trim_caps_cb %p cap %p  pruned, count now %d\n",
-		     inode, cap, atomic_read(&inode->i_count));
+		     inode, cap, inode->i_count);
 		return 0;
 	}
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 93f77d4..af0f050 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1639,7 +1639,7 @@ int cifs_revalidate_dentry(struct dentry *dentry)
 	}
 
 	cFYI(1, "Revalidate: %s inode 0x%p count %d dentry: 0x%p d_time %ld "
-		 "jiffies %ld", full_path, inode, inode->i_count.counter,
+		 "jiffies %ld", full_path, inode, inode->i_count,
 		 dentry, dentry->d_time, jiffies);
 
 	if (CIFS_SB(sb)->tcon->unix_ext)
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index ccd98b0..2e52ad6 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -303,7 +303,9 @@ static int coda_link(struct dentry *source_de, struct inode *dir_inode,
 	}
 
 	coda_dir_update_mtime(dir_inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	d_instantiate(de, inode);
 	inc_nlink(inode);
 
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index eb7368e..3e7f967 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1101,7 +1101,9 @@ static void create_done(struct exofs_io_state *ios, void *p)
 
 	set_obj_created(oi);
 
-	atomic_dec(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count--;
+	spin_unlock(&inode->i_lock);
 	wake_up(&oi->i_wq);
 }
 
@@ -1154,14 +1156,18 @@ struct inode *exofs_new_inode(struct inode *dir, int mode)
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
diff --git a/fs/exofs/namei.c b/fs/exofs/namei.c
index b7dd0c2..506778a 100644
--- a/fs/exofs/namei.c
+++ b/fs/exofs/namei.c
@@ -153,7 +153,9 @@ static int exofs_link(struct dentry *old_dentry, struct inode *dir,
 
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	return exofs_add_nondir(dentry, inode);
 }
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 71efb0e..a5b9a54 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -206,7 +206,9 @@ static int ext2_link (struct dentry * old_dentry, struct inode * dir,
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	err = ext2_add_link(dentry, inode);
 	if (!err) {
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 4ab72db..cdb398b 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -100,9 +100,9 @@ void ext3_free_inode (handle_t *handle, struct inode * inode)
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
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 2b35ddb..4e3b5ff 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2260,7 +2260,9 @@ retry:
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	err = ext3_add_entry(handle, dentry, inode);
 	if (!err) {
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 45853e0..720b42d 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -189,9 +189,9 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
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
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 314c0d3..4dbb5e5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2312,7 +2312,9 @@ retry:
 
 	inode->i_ctime = ext4_current_time(inode);
 	ext4_inc_count(handle, inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	err = ext4_add_entry(handle, dentry, inode);
 	if (!err) {
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 7bd1aef..2edaad7 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -309,7 +309,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	unsigned dirty;
 	int ret;
 
-	if (!atomic_read(&inode->i_count))
+	if (!inode->i_count)
 		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
 	else
 		WARN_ON(inode->i_state & I_WILL_FREE);
@@ -406,7 +406,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			 * completion.
 			 */
 			redirty_tail(inode);
-		} else if (atomic_read(&inode->i_count)) {
+		} else if (inode->i_count) {
 			/*
 			 * The inode is clean, inuse
 			 */
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 1009be2..49c38dc 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
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
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 764fd1b..55fa48d 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -301,7 +301,9 @@ static int hfsplus_link(struct dentry *src_dentry, struct inode *dst_dir,
 
 	inc_nlink(inode);
 	hfsplus_instantiate(dst_dentry, inode, cnid);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 	HFSPLUS_SB(sb).file_count++;
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 56f0da1..7f6b7ef 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -183,7 +183,7 @@ void hpfs_write_inode(struct inode *i)
 	struct hpfs_inode_info *hpfs_inode = hpfs_i(i);
 	struct inode *parent;
 	if (i->i_ino == hpfs_sb(i->i_sb)->sb_root) return;
-	if (hpfs_inode->i_rddir_off && !atomic_read(&i->i_count)) {
+	if (hpfs_inode->i_rddir_off && !i->i_count) {
 		if (*hpfs_inode->i_rddir_off) printk("HPFS: write_inode: some position still there\n");
 		kfree(hpfs_inode->i_rddir_off);
 		hpfs_inode->i_rddir_off = NULL;
diff --git a/fs/inode.c b/fs/inode.c
index 906a4ad..2e8ab8e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
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
@@ -150,7 +149,7 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_sb = sb;
 	inode->i_blkbits = sb->s_blocksize_bits;
 	inode->i_flags = 0;
-	atomic_set(&inode->i_count, 1);
+	inode->i_count = 1;
 	inode->i_op = &empty_iops;
 	inode->i_fop = &empty_fops;
 	inode->i_nlink = 1;
@@ -301,7 +300,8 @@ void __iget(struct inode *inode)
 {
 	assert_spin_locked(&inode->i_lock);
 
-	if (atomic_inc_return(&inode->i_count) != 1)
+	inode->i_count++;
+	if (inode->i_count > 1)
 		return;
 
 	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
@@ -407,7 +407,7 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 			continue;
 		}
 		invalidate_inode_buffers(inode);
-		if (!atomic_read(&inode->i_count)) {
+		if (!inode->i_count) {
 			list_move(&inode->i_list, dispose);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
@@ -457,7 +457,7 @@ static int can_unuse(struct inode *inode)
 		return 0;
 	if (inode_has_buffers(inode))
 		return 0;
-	if (atomic_read(&inode->i_count))
+	if (inode->i_count)
 		return 0;
 	if (inode->i_data.nrpages)
 		return 0;
@@ -495,7 +495,7 @@ static void prune_icache(int nr_to_scan)
 		inode = list_entry(inode_unused.prev, struct inode, i_list);
 
 		spin_lock(&inode->i_lock);
-		if (inode->i_state || atomic_read(&inode->i_count)) {
+		if (inode->i_state || inode->i_count) {
 			list_move(&inode->i_list, &inode_unused);
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -1307,8 +1307,6 @@ static void iput_final(struct inode *inode)
 	else
 		drop = generic_drop_inode(inode);
 
-	spin_lock(&sb_inode_list_lock);
-	spin_lock(&inode->i_lock);
 	if (!drop) {
 		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
@@ -1368,8 +1366,24 @@ void iput(struct inode *inode)
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
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index ed78a3c..4d1bcfa 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -289,7 +289,9 @@ static int jffs2_link (struct dentry *old_dentry, struct inode *dir_i, struct de
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
@@ -864,7 +866,9 @@ static int jffs2_rename (struct inode *old_dir_i, struct dentry *old_dentry,
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
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index d945ea7..820212f 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -1279,7 +1279,9 @@ int txCommit(tid_t tid,		/* transaction identifier */
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
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index a9cf8e8..3259008 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -839,7 +839,9 @@ static int jfs_link(struct dentry *old_dentry,
 	ip->i_ctime = CURRENT_TIME;
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	mark_inode_dirty(dir);
-	atomic_inc(&ip->i_count);
+	spin_lock(&ip->i_lock);
+	ip->i_count++;
+	spin_unlock(&ip->i_lock);
 
 	iplist[0] = ip;
 	iplist[1] = dir;
diff --git a/fs/libfs.c b/fs/libfs.c
index 0a9da95..0fa4dbe 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -255,7 +255,9 @@ int simple_link(struct dentry *old_dentry, struct inode *dir, struct dentry *den
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	dget(dentry);
 	d_instantiate(dentry, inode);
 	return 0;
diff --git a/fs/locks.c b/fs/locks.c
index ab24d49..6d97e65 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1376,7 +1376,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 			goto out;
 		if ((arg == F_WRLCK)
 		    && ((atomic_read(&dentry->d_count) > 1)
-			|| (atomic_read(&inode->i_count) > 1)))
+			|| inode->i_count > 1))
 			goto out;
 	}
 
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 9777eb5..90eb51f 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -569,7 +569,9 @@ static int logfs_link(struct dentry *old_dentry, struct inode *dir,
 		return -EMLINK;
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	inode->i_nlink++;
 	mark_inode_dirty_sync(inode);
 
diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index 6127baf..0d92191 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -1002,8 +1002,12 @@ static int __logfs_is_valid_block(struct inode *inode, u64 bix, u64 ofs)
 {
 	struct logfs_inode *li = logfs_inode(inode);
 
-	if ((inode->i_nlink == 0) && atomic_read(&inode->i_count) == 1)
+	spin_lock(&inode->i_lock);
+	if ((inode->i_nlink == 0) && inode->i_count == 1) {
+		spin_unlock(&inode->i_lock);
 		return 0;
+	}
+	spin_unlock(&inode->i_lock);
 
 	if (bix < I0_BLOCKS)
 		return logfs_is_valid_direct(li, bix, ofs);
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index f3f3578..a4a160f 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -101,7 +101,9 @@ static int minix_link(struct dentry * old_dentry, struct inode * dir,
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	return add_nondir(dentry, inode);
 }
 
diff --git a/fs/namei.c b/fs/namei.c
index 24896e8..817d6bb 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2290,8 +2290,11 @@ static long do_unlinkat(int dfd, const char __user *pathname)
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
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index e257172..375b6b5 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1580,7 +1580,9 @@ nfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
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
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index a70e446..c6db37e 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -55,7 +55,9 @@ static int nfs_superblock_set_dummy_root(struct super_block *sb, struct inode *i
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
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 7d2d6c7..dfb79e5 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -384,7 +384,7 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 	dprintk("NFS: nfs_fhget(%s/%Ld ct=%d)\n",
 		inode->i_sb->s_id,
 		(long long)NFS_FILEID(inode),
-		atomic_read(&inode->i_count));
+		inode->i_count);
 
 out:
 	return inode;
@@ -1190,7 +1190,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 
 	dfprintk(VFS, "NFS: %s(%s/%ld ct=%d info=0x%x)\n",
 			__func__, inode->i_sb->s_id, inode->i_ino,
-			atomic_read(&inode->i_count), fattr->valid);
+			inode->i_count, fattr->valid);
 
 	if ((fattr->valid & NFS_ATTR_FATTR_FILEID) && nfsi->fileid != fattr->fileid)
 		goto out_fileid;
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 3e2f19b..d7fc5d0 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -506,8 +506,8 @@ nfs4_get_open_state(struct inode *inode, struct nfs4_state_owner *owner)
 		state->owner = owner;
 		atomic_inc(&owner->so_count);
 		list_add(&state->inode_states, &nfsi->open_states);
-		state->inode = igrab(inode);
 		spin_unlock(&inode->i_lock);
+		state->inode = igrab(inode);
 		/* Note: The reclaim code dictates that we add stateless
 		 * and read-only stateids to the end of the list */
 		list_add_tail(&state->open_states, &owner->so_states);
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 874972d..129ebaa 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -390,7 +390,7 @@ static int nfs_inode_add_request(struct inode *inode, struct nfs_page *req)
 	error = radix_tree_insert(&nfsi->nfs_page_tree, req->wb_index, req);
 	BUG_ON(error);
 	if (!nfsi->npages) {
-		igrab(inode);
+		__iget(inode);
 		if (nfs_have_delegation(inode, FMODE_WRITE))
 			nfsi->change_attr++;
 	}
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index d01aff4..db0b75b 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -480,7 +480,7 @@ nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
 		inode->i_sb = sb; /* sb may be NULL for some meta data files */
 		inode->i_blkbits = nilfs->ns_blocksize_bits;
 		inode->i_flags = 0;
-		atomic_set(&inode->i_count, 1);
+		inode->i_count = 1;
 		inode->i_nlink = 1;
 		inode->i_ino = ino;
 		inode->i_mode = S_IFREG;
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index ad6ed2c..9e287ea 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -219,7 +219,9 @@ static int nilfs_link(struct dentry *old_dentry, struct inode *dir,
 
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	err = nilfs_add_nondir(dentry, inode);
 	if (!err)
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 34b1585..70f7e16 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -257,24 +257,29 @@ void fsnotify_unmount_inodes(struct list_head *list)
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
-		    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
-			__iget(next_i);
-			need_iput = next_i;
+		if (&next_i->i_sb_list != list) {
+			spin_lock(&next_i->i_lock);
+			if (next_i->i_count &&
+			    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
+				__iget(next_i);
+				need_iput = next_i;
+			}
+			spin_unlock(&next_i->i_lock);
 		}
 
 		/*
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 5128061..2e380ba 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2930,7 +2930,9 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
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
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index a00dda2..9c46feb 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -741,7 +741,9 @@ static int ocfs2_link(struct dentry *old_dentry,
 		goto out_commit;
 	}
 
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	dentry->d_op = &ocfs2_dentry_ops;
 	d_instantiate(dentry, inode);
 
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index ee78d4a..1efebb2 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -1156,7 +1156,9 @@ static int reiserfs_link(struct dentry *old_dentry, struct inode *dir,
 	inode->i_ctime = CURRENT_TIME_SEC;
 	reiserfs_update_sd(&th, inode);
 
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	d_instantiate(dentry, inode);
 	retval = journal_end(&th, dir->i_sb, jbegin_count);
 	reiserfs_write_unlock(dir->i_sb);
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 313d39d..b8d4d67 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -1477,7 +1477,7 @@ static int maybe_indirect_to_direct(struct reiserfs_transaction_handle *th,
 	 ** reading in the last block.  The user will hit problems trying to
 	 ** read the file, but for now we just skip the indirect2direct
 	 */
-	if (atomic_read(&inode->i_count) > 1 ||
+	if (inode->i_count > 1 ||
 	    !tail_has_to_be_packed(inode) ||
 	    !page || (REISERFS_I(inode)->i_flags & i_nopack_mask)) {
 		/* leave tail in an unformatted node */
diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index 33e047b..d63da9b 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -126,7 +126,9 @@ static int sysv_link(struct dentry * old_dentry, struct inode * dir,
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	return add_nondir(dentry, inode);
 }
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 87ebcce..c204b5c 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -550,7 +550,9 @@ static int ubifs_link(struct dentry *old_dentry, struct inode *dir,
 
 	lock_2_inodes(dir, inode);
 	inc_nlink(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	inode->i_ctime = ubifs_current_time(inode);
 	dir->i_size += sz_change;
 	dir_ui->ui_size = dir->i_size;
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index cd5900b..c3c79b7 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -342,7 +342,7 @@ static void ubifs_evict_inode(struct inode *inode)
 		goto out;
 
 	dbg_gen("inode %lu, mode %#x", inode->i_ino, (int)inode->i_mode);
-	ubifs_assert(!atomic_read(&inode->i_count));
+	ubifs_assert(!inode->i_count);
 
 	truncate_inode_pages(&inode->i_data, 0);
 
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index bf5fc67..d8b0dc8 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1101,7 +1101,9 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
 	inc_nlink(inode);
 	inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	d_instantiate(dentry, inode);
 	unlock_kernel();
 
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index b056f02..8cbf920 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -180,7 +180,9 @@ static int ufs_link (struct dentry * old_dentry, struct inode * dir,
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 
 	error = ufs_add_nondir(dentry, inode);
 	unlock_kernel();
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index b1fc2a6..332cdf5 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -352,7 +352,9 @@ xfs_vn_link(
 	if (unlikely(error))
 		return -error;
 
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_count++;
+	spin_unlock(&inode->i_lock);
 	d_instantiate(dentry, inode);
 	return 0;
 }
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index be5dffd..065db30 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -599,7 +599,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->count = atomic_read(&VFS_I(ip)->i_count);
+		__entry->count = VFS_I(ip)->i_count;
 		__entry->pincount = atomic_read(&ip->i_pincount);
 		__entry->caller_ip = caller_ip;
 	),
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0898c54..859628b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -481,8 +481,10 @@ void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 
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
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 76041b6..415c88e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -728,7 +728,7 @@ struct inode {
 	struct list_head	i_sb_list;
 	struct list_head	i_dentry;
 	unsigned long		i_ino;
-	atomic_t		i_count;
+	unsigned int		i_count;
 	unsigned int		i_nlink;
 	uid_t			i_uid;
 	gid_t			i_gid;
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index c60e519..7fe9efb 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -768,8 +768,11 @@ SYSCALL_DEFINE1(mq_unlink, const char __user *, u_name)
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
diff --git a/kernel/futex.c b/kernel/futex.c
index 6a3a5fa..e9dfa00 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -168,7 +168,9 @@ static void get_futex_key_refs(union futex_key *key)
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		atomic_inc(&key->shared.inode->i_count);
+		spin_lock(&key->shared.inode->i_lock);
+		key->shared.inode->i_count++;
+		spin_unlock(&key->shared.inode->i_lock);
 		break;
 	case FUT_OFF_MMSHARED:
 		atomic_inc(&key->private.mm->mm_count);
diff --git a/mm/shmem.c b/mm/shmem.c
index 080b09a..56229bb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1903,7 +1903,9 @@ static int shmem_link(struct dentry *old_dentry, struct inode *dir, struct dentr
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
diff --git a/net/socket.c b/net/socket.c
index 2270b94..5431af1 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -377,7 +377,9 @@ static int sock_alloc_file(struct socket *sock, struct file **f, int flags)
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
-- 
1.7.1

