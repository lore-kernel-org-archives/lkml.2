Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770Ab0JSD5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:57:44 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28444 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933661Ab0JSD4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaCd4JSBIUMhT6FAA
Message-Id: <20101019034659.071935789@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:50 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 34/35] fs: inode rename i_count to i_refs
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-rename.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 Documentation/filesystems/vfs.txt        |    4 ++--
 arch/powerpc/platforms/cell/spufs/file.c |    2 +-
 drivers/staging/pohmelfs/inode.c         |   14 +++++++-------
 fs/9p/vfs_inode.c                        |    2 +-
 fs/block_dev.c                           |    2 +-
 fs/btrfs/inode.c                         |   10 +++++-----
 fs/ceph/mds_client.c                     |    2 +-
 fs/cifs/inode.c                          |    2 +-
 fs/exofs/inode.c                         |    4 ++--
 fs/ext3/ialloc.c                         |    4 ++--
 fs/ext4/ialloc.c                         |    4 ++--
 fs/fs-writeback.c                        |    4 ++--
 fs/hpfs/inode.c                          |    2 +-
 fs/inode.c                               |   18 +++++++++---------
 fs/locks.c                               |    2 +-
 fs/logfs/readwrite.c                     |    2 +-
 fs/nfs/inode.c                           |    4 ++--
 fs/nilfs2/mdt.c                          |    2 +-
 fs/notify/inode_mark.c                   |    8 ++++----
 fs/ntfs/inode.c                          |    6 +++---
 fs/ntfs/super.c                          |    4 ++--
 fs/reiserfs/stree.c                      |    2 +-
 fs/smbfs/inode.c                         |    2 +-
 fs/squashfs/dir.c                        |    8 ++++----
 fs/squashfs/inode.c                      |    2 +-
 fs/ubifs/super.c                         |    2 +-
 fs/udf/inode.c                           |    2 +-
 fs/xfs/linux-2.6/xfs_trace.h             |    2 +-
 fs/xfs/xfs_inode.h                       |    2 +-
 include/linux/fs.h                       |    6 +++---
 30 files changed, 65 insertions(+), 65 deletions(-)

Index: linux-2.6/Documentation/filesystems/vfs.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/vfs.txt	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/Documentation/filesystems/vfs.txt	2010-10-19 14:19:00.000000000 +1100
@@ -347,7 +347,7 @@
   lookup: called when the VFS needs to look up an inode in a parent
 	directory. The name to look for is found in the dentry. This
 	method must call d_add() to insert the found inode into the
-	dentry. The "i_count" field in the inode structure should be
+	dentry. The "i_refs" field in the inode structure should be
 	incremented. If the named inode does not exist a NULL inode
 	should be inserted into the dentry (this is called a negative
 	dentry). Returning an error code from this routine must only
@@ -926,7 +926,7 @@
 	d_instantiate()
 
   d_instantiate: add a dentry to the alias hash list for the inode and
-	updates the "d_inode" member. The "i_count" member in the
+	updates the "d_inode" member. The "i_refs" member in the
 	inode structure should be set/incremented. If the inode
 	pointer is NULL, the dentry is called a "negative
 	dentry". This function is commonly called when an inode is
Index: linux-2.6/fs/9p/vfs_inode.c
===================================================================
--- linux-2.6.orig/fs/9p/vfs_inode.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/9p/vfs_inode.c	2010-10-19 14:19:00.000000000 +1100
@@ -1796,7 +1796,7 @@
 		kfree(st);
 	} else {
 		/* Caching disabled. No need to get upto date stat info.
-		 * This dentry will be released immediately. So, just i_count++
+		 * This dentry will be released immediately. So, just i_refs++
 		 */
 		inode_get(old_dentry->d_inode);
 	}
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/block_dev.c	2010-10-19 14:19:00.000000000 +1100
@@ -599,7 +599,7 @@
 		spin_lock(&bdev_lock);
 		if (!inode->i_bdev) {
 			/*
-			 * We take an additional bd_inode->i_count for inode,
+			 * We take an additional bd_inode->i_refs for inode,
 			 * and it's released in clear_inode() of inode.
 			 * So, we can access it via ->i_mapping always
 			 * without igrab().
Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/btrfs/inode.c	2010-10-19 14:19:00.000000000 +1100
@@ -1965,8 +1965,8 @@
 	struct delayed_iput *delayed;
 
 	spin_lock(&inode->i_lock);
-	if (inode->i_count > 1) {
-		inode->i_count--;
+	if (inode->i_refs > 1) {
+		inode->i_refs--;
 		spin_unlock(&inode->i_lock);
 		return;
 	}
@@ -2723,10 +2723,10 @@
 		return ERR_PTR(-ENOSPC);
 
 	/* check if there is someone else holds reference */
-	if (S_ISDIR(inode->i_mode) && inode->i_count > 1)
+	if (S_ISDIR(inode->i_mode) && inode->i_refs > 1)
 		return ERR_PTR(-ENOSPC);
 
-	if (inode->i_count > 2)
+	if (inode->i_refs > 2)
 		return ERR_PTR(-ENOSPC);
 
 	if (xchg(&root->fs_info->enospc_unlink, 1))
@@ -3944,7 +3944,7 @@
 		inode = igrab(&entry->vfs_inode);
 		if (inode) {
 			spin_unlock(&root->inode_lock);
-			if (inode->i_count > 1)
+			if (inode->i_refs > 1)
 				d_prune_aliases(inode);
 			/*
 			 * btrfs_drop_inode will have it removed from
Index: linux-2.6/fs/ceph/mds_client.c
===================================================================
--- linux-2.6.orig/fs/ceph/mds_client.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/ceph/mds_client.c	2010-10-19 14:19:00.000000000 +1100
@@ -1102,7 +1102,7 @@
 		spin_unlock(&inode->i_lock);
 		d_prune_aliases(inode);
 		dout("trim_caps_cb %p cap %p  pruned, count now %d\n",
-		     inode, cap, inode->i_count);
+		     inode, cap, inode->i_refs);
 		return 0;
 	}
 
Index: linux-2.6/fs/cifs/inode.c
===================================================================
--- linux-2.6.orig/fs/cifs/inode.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/cifs/inode.c	2010-10-19 14:19:00.000000000 +1100
@@ -1641,7 +1641,7 @@
 	}
 
 	cFYI(1, "Revalidate: %s inode 0x%p count %d dentry: 0x%p d_time %ld "
-		 "jiffies %ld", full_path, inode, inode->i_count,
+		 "jiffies %ld", full_path, inode, inode->i_refs,
 		 dentry, dentry->d_time, jiffies);
 
 	if (CIFS_SB(sb)->tcon->unix_ext)
Index: linux-2.6/fs/exofs/inode.c
===================================================================
--- linux-2.6.orig/fs/exofs/inode.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/exofs/inode.c	2010-10-19 14:19:00.000000000 +1100
@@ -1108,7 +1108,7 @@
 	set_obj_created(oi);
 
 	spin_lock(&inode->i_lock);
-	inode->i_count--;
+	inode->i_refs--;
 	spin_unlock(&inode->i_lock);
 	wake_up(&oi->i_wq);
 }
@@ -1170,7 +1170,7 @@
 	ret = exofs_sbi_create(ios);
 	if (ret) {
 		spin_lock(&inode->i_lock);
-		inode->i_count--;
+		inode->i_refs--;
 		spin_unlock(&inode->i_lock);
 		exofs_put_io_state(ios);
 		return ERR_PTR(ret);
Index: linux-2.6/fs/ext3/ialloc.c
===================================================================
--- linux-2.6.orig/fs/ext3/ialloc.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/ext3/ialloc.c	2010-10-19 14:19:00.000000000 +1100
@@ -100,9 +100,9 @@
 	struct ext3_sb_info *sbi;
 	int fatal = 0, err;
 
-	if (inode->i_count > 1) {
+	if (inode->i_refs > 1) {
 		printk ("ext3_free_inode: inode has count=%d\n",
-					inode->i_count);
+					inode->i_refs);
 		return;
 	}
 	if (inode->i_nlink) {
Index: linux-2.6/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.orig/fs/ext4/ialloc.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/ext4/ialloc.c	2010-10-19 14:19:00.000000000 +1100
@@ -189,9 +189,9 @@
 	struct ext4_sb_info *sbi;
 	int fatal = 0, err, count, cleared;
 
-	if (inode->i_count > 1) {
+	if (inode->i_refs > 1) {
 		printk(KERN_ERR "ext4_free_inode: inode has count=%d\n",
-		       inode->i_count);
+		       inode->i_refs);
 		return;
 	}
 	if (inode->i_nlink) {
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:00.000000000 +1100
@@ -308,7 +308,7 @@
 	unsigned dirty;
 	int ret;
 
-	if (!inode->i_count)
+	if (!inode->i_refs)
 		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
 	else
 		WARN_ON(inode->i_state & I_WILL_FREE);
@@ -414,7 +414,7 @@
 			/*
 			 * Put it on the LRU if it is unused, otherwise lazy.
 			 */
-			if (!inode->i_count && list_empty(&inode->i_lru))
+			if (!inode->i_refs && list_empty(&inode->i_lru))
 				__inode_lru_list_add(inode);
 		}
 	}
Index: linux-2.6/fs/hpfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hpfs/inode.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/hpfs/inode.c	2010-10-19 14:19:00.000000000 +1100
@@ -183,7 +183,7 @@
 	struct hpfs_inode_info *hpfs_inode = hpfs_i(i);
 	struct inode *parent;
 	if (i->i_ino == hpfs_sb(i->i_sb)->sb_root) return;
-	if (hpfs_inode->i_rddir_off && !i->i_count) {
+	if (hpfs_inode->i_rddir_off && !i->i_refs) {
 		if (*hpfs_inode->i_rddir_off) printk("HPFS: write_inode: some position still there\n");
 		kfree(hpfs_inode->i_rddir_off);
 		hpfs_inode->i_rddir_off = NULL;
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:14.000000000 +1100
@@ -40,7 +40,7 @@
  *   b_io, b_more_io, b_dirty, i_io, i_lru
  * inode->i_lock protects:
  *   i_state
- *   i_count
+ *   i_refs
  *   i_hash
  *   i_io
  *   i_lru
@@ -92,9 +92,9 @@
  * Each inode can be on two separate lists. One is
  * the hash list of the inode, used for lookups. The
  * other linked list is the "type" list:
- *  "in_use" - valid inode, i_count > 0, i_nlink > 0
+ *  "in_use" - valid inode, i_refs > 0, i_nlink > 0
  *  "dirty"  - as "in_use" but also dirty
- *  "unused" - valid inode, i_count = 0
+ *  "unused" - valid inode, i_refs = 0
  *
  * A "dirty" list is maintained for each super block,
  * allowing for low-overhead inode sync() operations.
@@ -212,7 +212,7 @@
 	inode->i_sb = sb;
 	inode->i_blkbits = sb->s_blocksize_bits;
 	inode->i_flags = 0;
-	inode->i_count = 1;
+	inode->i_refs = 1;
 	inode->i_op = &empty_iops;
 	inode->i_fop = &empty_fops;
 	inode->i_nlink = 1;
@@ -484,7 +484,7 @@
 			continue;
 		}
 		invalidate_inode_buffers(inode);
-		if (!inode->i_count) {
+		if (!inode->i_refs) {
 			struct bdi_writeback *wb = inode_to_wb(inode);
 
 			spin_lock(&wb->b_lock);
@@ -541,7 +541,7 @@
 		return 0;
 	if (inode_has_buffers(inode))
 		return 0;
-	if (inode->i_count)
+	if (inode->i_refs)
 		return 0;
 	if (inode->i_data.nrpages)
 		return 0;
@@ -581,7 +581,7 @@
 			cpu_relax();
 			goto again;
 		}
-		if (inode->i_count || (inode->i_state & ~I_REFERENCED)) {
+		if (inode->i_refs || (inode->i_state & ~I_REFERENCED)) {
 			list_del_init(&inode->i_lru);
 			spin_unlock(&inode->i_lock);
 			zone->inode_nr_lru--;
@@ -1608,8 +1608,8 @@
 		BUG_ON(inode->i_state & I_CLEAR);
 
 		spin_lock(&inode->i_lock);
-		inode->i_count--;
-		if (inode->i_count == 0)
+		inode->i_refs--;
+		if (inode->i_refs == 0)
 			iput_final(inode);
 		else
 			spin_unlock(&inode->i_lock);
Index: linux-2.6/fs/locks.c
===================================================================
--- linux-2.6.orig/fs/locks.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/locks.c	2010-10-19 14:19:00.000000000 +1100
@@ -1376,7 +1376,7 @@
 			goto out;
 		if ((arg == F_WRLCK)
 		    && (atomic_read(&dentry->d_count) > 1
-			|| inode->i_count > 1))
+			|| inode->i_refs > 1))
 			goto out;
 	}
 
Index: linux-2.6/fs/logfs/readwrite.c
===================================================================
--- linux-2.6.orig/fs/logfs/readwrite.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/logfs/readwrite.c	2010-10-19 14:19:00.000000000 +1100
@@ -1002,7 +1002,7 @@
 {
 	struct logfs_inode *li = logfs_inode(inode);
 
-	if ((inode->i_nlink == 0) && inode->i_count == 1)
+	if ((inode->i_nlink == 0) && inode->i_refs == 1)
 		return 0;
 
 	if (bix < I0_BLOCKS)
Index: linux-2.6/fs/nfs/inode.c
===================================================================
--- linux-2.6.orig/fs/nfs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/nfs/inode.c	2010-10-19 14:19:00.000000000 +1100
@@ -384,7 +384,7 @@
 	dprintk("NFS: nfs_fhget(%s/%Ld ct=%d)\n",
 		inode->i_sb->s_id,
 		(long long)NFS_FILEID(inode),
-		inode->i_count);
+		inode->i_refs);
 
 out:
 	return inode;
@@ -1190,7 +1190,7 @@
 
 	dfprintk(VFS, "NFS: %s(%s/%ld ct=%d info=0x%x)\n",
 			__func__, inode->i_sb->s_id, inode->i_ino,
-			inode->i_count, fattr->valid);
+			inode->i_refs, fattr->valid);
 
 	if ((fattr->valid & NFS_ATTR_FATTR_FILEID) && nfsi->fileid != fattr->fileid)
 		goto out_fileid;
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/notify/inode_mark.c	2010-10-19 14:19:00.000000000 +1100
@@ -255,12 +255,12 @@
 		}
 
 		/*
-		 * If i_count is zero, the inode cannot have any watches and
+		 * If i_refs is zero, the inode cannot have any watches and
 		 * doing an inode_get/iput with MS_ACTIVE clear would actually
-		 * evict all inodes with zero i_count from icache which is
+		 * evict all inodes with zero i_refs from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		if (!inode->i_count) {
+		if (!inode->i_refs) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
@@ -278,7 +278,7 @@
 		/* In case the dropping of a reference would nuke next_i. */
 		if (&next_i->i_sb_list != list) {
 			spin_lock(&next_i->i_lock);
-			if (next_i->i_count &&
+			if (next_i->i_refs &&
 			    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
 				inode_get_ilock(next_i);
 				need_iput = next_i;
Index: linux-2.6/fs/ntfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ntfs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/ntfs/inode.c	2010-10-19 14:19:00.000000000 +1100
@@ -538,7 +538,7 @@
  *
  * Q: What locks are held when the function is called?
  * A: i_state has I_NEW set, hence the inode is locked, also
- *    i_count is set to 1, so it is not going to go away
+ *    i_refs is set to 1, so it is not going to go away
  *    i_flags is set to 0 and we have no business touching it.  Only an ioctl()
  *    is allowed to write to them. We should of course be honouring them but
  *    we need to do that using the IS_* macros defined in include/linux/fs.h.
@@ -1215,7 +1215,7 @@
  *
  * Q: What locks are held when the function is called?
  * A: i_state has I_NEW set, hence the inode is locked, also
- *    i_count is set to 1, so it is not going to go away
+ *    i_refs is set to 1, so it is not going to go away
  *
  * Return 0 on success and -errno on error.  In the error case, the inode will
  * have had make_bad_inode() executed on it.
@@ -1482,7 +1482,7 @@
  *
  * Q: What locks are held when the function is called?
  * A: i_state has I_NEW set, hence the inode is locked, also
- *    i_count is set to 1, so it is not going to go away
+ *    i_refs is set to 1, so it is not going to go away
  *
  * Return 0 on success and -errno on error.  In the error case, the inode will
  * have had make_bad_inode() executed on it.
Index: linux-2.6/fs/ntfs/super.c
===================================================================
--- linux-2.6.orig/fs/ntfs/super.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/ntfs/super.c	2010-10-19 14:19:00.000000000 +1100
@@ -2689,7 +2689,7 @@
 	//					   held. See fs/inode.c::
 	//					   generic_drop_inode(). */
 	//.delete_inode	= NULL,			/* VFS: Delete inode from disk.
-	//					   Called when i_count becomes
+	//					   Called when i_refs becomes
 	//					   0 and i_nlink is also 0. */
 	//.write_super	= NULL,			/* Flush dirty super block to
 	//					   disk. */
@@ -2929,7 +2929,7 @@
 		goto unl_upcase_iput_tmp_ino_err_out_now;
 	}
 	if ((sb->s_root = d_alloc_root(vol->root_ino))) {
-		/* We increment i_count simulating an ntfs_iget(). */
+		/* We increment i_refs simulating an ntfs_iget(). */
 		inode_get(vol->root_ino);
 		ntfs_debug("Exiting, status successful.");
 		/* Release the default upcase if it has no users. */
Index: linux-2.6/fs/reiserfs/stree.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/stree.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/reiserfs/stree.c	2010-10-19 14:19:00.000000000 +1100
@@ -1477,7 +1477,7 @@
 	 ** reading in the last block.  The user will hit problems trying to
 	 ** read the file, but for now we just skip the indirect2direct
 	 */
-	if (inode->i_count > 1 ||
+	if (inode->i_refs > 1 ||
 	    !tail_has_to_be_packed(inode) ||
 	    !page || (REISERFS_I(inode)->i_flags & i_nopack_mask)) {
 		/* leave tail in an unformatted node */
Index: linux-2.6/fs/smbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/smbfs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/smbfs/inode.c	2010-10-19 14:19:00.000000000 +1100
@@ -327,7 +327,7 @@
 }
 
 /*
- * This routine is called when i_nlink == 0 and i_count goes to 0.
+ * This routine is called when i_nlink == 0 and i_refs goes to 0.
  * All blocking cleanup operations need to go here to avoid races.
  */
 static void
Index: linux-2.6/fs/squashfs/dir.c
===================================================================
--- linux-2.6.orig/fs/squashfs/dir.c	2010-10-19 14:17:11.000000000 +1100
+++ linux-2.6/fs/squashfs/dir.c	2010-10-19 14:19:00.000000000 +1100
@@ -50,14 +50,14 @@
  */
 static int get_dir_index_using_offset(struct super_block *sb,
 	u64 *next_block, int *next_offset, u64 index_start, int index_offset,
-	int i_count, u64 f_pos)
+	int i_refs, u64 f_pos)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	int err, i, index, length = 0;
 	struct squashfs_dir_index dir_index;
 
-	TRACE("Entered get_dir_index_using_offset, i_count %d, f_pos %lld\n",
-					i_count, f_pos);
+	TRACE("Entered get_dir_index_using_offset, i_refs %d, f_pos %lld\n",
+					i_refs, f_pos);
 
 	/*
 	 * Translate from external f_pos to the internal f_pos.  This
@@ -68,7 +68,7 @@
 		return f_pos;
 	f_pos -= 3;
 
-	for (i = 0; i < i_count; i++) {
+	for (i = 0; i < i_refs; i++) {
 		err = squashfs_read_metadata(sb, &dir_index, &index_start,
 				&index_offset, sizeof(dir_index));
 		if (err < 0)
Index: linux-2.6/fs/squashfs/inode.c
===================================================================
--- linux-2.6.orig/fs/squashfs/inode.c	2010-10-19 14:17:11.000000000 +1100
+++ linux-2.6/fs/squashfs/inode.c	2010-10-19 14:19:00.000000000 +1100
@@ -266,7 +266,7 @@
 		squashfs_i(inode)->offset = le16_to_cpu(sqsh_ino->offset);
 		squashfs_i(inode)->dir_idx_start = block;
 		squashfs_i(inode)->dir_idx_offset = offset;
-		squashfs_i(inode)->dir_idx_cnt = le16_to_cpu(sqsh_ino->i_count);
+		squashfs_i(inode)->dir_idx_cnt = le16_to_cpu(sqsh_ino->i_refs);
 		squashfs_i(inode)->parent = le32_to_cpu(sqsh_ino->parent_inode);
 
 		TRACE("Long directory inode %x:%x, start_block %llx, offset "
Index: linux-2.6/fs/ubifs/super.c
===================================================================
--- linux-2.6.orig/fs/ubifs/super.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/ubifs/super.c	2010-10-19 14:19:00.000000000 +1100
@@ -350,7 +350,7 @@
 		goto out;
 
 	dbg_gen("inode %lu, mode %#x", inode->i_ino, (int)inode->i_mode);
-	ubifs_assert(!inode->i_count);
+	ubifs_assert(!inode->i_refs);
 
 	truncate_inode_pages(&inode->i_data, 0);
 
Index: linux-2.6/fs/udf/inode.c
===================================================================
--- linux-2.6.orig/fs/udf/inode.c	2010-10-19 14:17:11.000000000 +1100
+++ linux-2.6/fs/udf/inode.c	2010-10-19 14:19:00.000000000 +1100
@@ -1071,7 +1071,7 @@
 	 *      i_flags = sb->s_flags
 	 *      i_state = 0
 	 * clean_inode(): zero fills and sets
-	 *      i_count = 1
+	 *      i_refs = 1
 	 *      i_nlink = 1
 	 *      i_op = NULL;
 	 */
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-19 14:19:00.000000000 +1100
@@ -738,7 +738,7 @@
 #ifdef CONFIG_SMP
 	int			i_sb_list_cpu;
 #endif
-	unsigned int		i_count;
+	unsigned int		i_refs;
 	unsigned int		i_nlink;
 	uid_t			i_uid;
 	gid_t			i_gid;
@@ -1621,7 +1621,7 @@
  *			also cause waiting on I_NEW, without I_NEW actually
  *			being set.  find_inode() uses this to prevent returning
  *			nearly-dead inodes.
- * I_WILL_FREE		Must be set when calling write_inode_now() if i_count
+ * I_WILL_FREE		Must be set when calling write_inode_now() if i_refs
  *			is zero.  I_FREEING must be set when I_WILL_FREE is
  *			cleared.
  * I_FREEING		Set when inode is about to be freed but still has dirty
@@ -2466,7 +2466,7 @@
 {
 	assert_spin_locked(&inode->i_lock);
 	BUG_ON(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE));
-	inode->i_count++;
+	inode->i_refs++;
 }
 
 static inline void inode_get(struct inode *inode)
Index: linux-2.6/fs/nilfs2/mdt.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/mdt.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/nilfs2/mdt.c	2010-10-19 14:19:00.000000000 +1100
@@ -480,7 +480,7 @@
 		inode->i_sb = sb; /* sb may be NULL for some meta data files */
 		inode->i_blkbits = nilfs->ns_blocksize_bits;
 		inode->i_flags = 0;
-		inode->i_count = 1;
+		inode->i_refs = 1;
 		inode->i_nlink = 1;
 		inode->i_ino = ino;
 		inode->i_mode = S_IFREG;
Index: linux-2.6/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_trace.h	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_trace.h	2010-10-19 14:19:00.000000000 +1100
@@ -599,7 +599,7 @@
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->count = VFS_I(ip)->i_count;
+		__entry->count = VFS_I(ip)->i_refs;
 		__entry->pincount = atomic_read(&ip->i_pincount);
 		__entry->caller_ip = caller_ip;
 	),
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/xfs/xfs_inode.h	2010-10-19 14:19:00.000000000 +1100
@@ -481,7 +481,7 @@
 
 #define IHOLD(ip) \
 do { \
-	ASSERT(VFS_I(ip)->i_count > 0) ; \
+	ASSERT(VFS_I(ip)->i_refs > 0) ; \
 	inode_get(VFS_I(ip)); \
 	trace_xfs_ihold(ip, _THIS_IP_); \
 } while (0)
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/file.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/file.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/file.c	2010-10-19 14:19:00.000000000 +1100
@@ -1549,7 +1549,7 @@
 	if (ctx->owner != current->mm)
 		return -EINVAL;
 
-	if (inode->i_count != 1)
+	if (inode->i_refs != 1)
 		return -EBUSY;
 
 	mutex_lock(&ctx->mapping_lock);
Index: linux-2.6/drivers/staging/pohmelfs/inode.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/drivers/staging/pohmelfs/inode.c	2010-10-19 14:19:00.000000000 +1100
@@ -1296,11 +1296,11 @@
 		dprintk("%s: ino: %llu, pi: %p, inode: %p, count: %u.\n",
 				__func__, pi->ino, pi, inode, count);
 
-		if (inode->i_count != count) {
-			printk("%s: ino: %llu, pi: %p, inode: %p, count: %u, i_count: %d.\n",
+		if (inode->i_refs != count) {
+			printk("%s: ino: %llu, pi: %p, inode: %p, count: %u, i_refs: %d.\n",
 					__func__, pi->ino, pi, inode, count,
-					inode->i_count);
-			count = inode->i_count;
+					inode->i_refs);
+			count = inode->i_refs;
 			in_drop_list++;
 		}
 
@@ -1311,8 +1311,8 @@
 	list_for_each_entry_safe(inode, tmp, &sb->s_inodes, i_sb_list) {
 		pi = POHMELFS_I(inode);
 
-		dprintk("%s: ino: %llu, pi: %p, inode: %p, i_count: %u.\n",
-				__func__, pi->ino, pi, inode, inode->i_count);
+		dprintk("%s: ino: %llu, pi: %p, inode: %p, i_refs: %u.\n",
+				__func__, pi->ino, pi, inode, inode->i_refs);
 
 		/*
 		 * These are special inodes, they were created during
@@ -1320,7 +1320,7 @@
 		 * so they live here with reference counter being 1 and prevent
 		 * umount from succeed since it believes that they are busy.
 		 */
-		count = inode->i_count;
+		count = inode->i_refs;
 		if (count) {
 			list_del_init(&inode->i_sb_list);
 			while (count--)


