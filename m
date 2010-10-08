Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0JHFX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:23:57 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:60946 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752755Ab0JHFWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:22:15 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/18] fs: add inode reference coutn read accessor
Date: Fri,  8 Oct 2010 16:21:22 +1100
Message-Id: <1286515292-15882-9-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286515292-15882-1-git-send-email-david@fromorbit.com>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To remove most of the remaining direct references to the inode
reference count, add an iref_read() accessor function to read the
current reference count.  New users of this function should be
frowned upon, as there is rarely a good reason for looking at the
current reference count.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 arch/powerpc/platforms/cell/spufs/file.c |    2 +-
 drivers/staging/pohmelfs/inode.c         |   10 +++++-----
 fs/btrfs/inode.c                         |    6 +++---
 fs/ceph/mds_client.c                     |    2 +-
 fs/cifs/inode.c                          |    2 +-
 fs/ext3/ialloc.c                         |    4 ++--
 fs/ext4/ialloc.c                         |    4 ++--
 fs/fs-writeback.c                        |    2 +-
 fs/hpfs/inode.c                          |    2 +-
 fs/inode.c                               |   10 ++++++++++
 fs/locks.c                               |    2 +-
 fs/logfs/readwrite.c                     |    2 +-
 fs/nfs/inode.c                           |    4 ++--
 fs/notify/inode_mark.c                   |   11 +++++------
 fs/reiserfs/stree.c                      |    2 +-
 fs/smbfs/inode.c                         |    2 +-
 fs/ubifs/super.c                         |    2 +-
 fs/xfs/linux-2.6/xfs_trace.h             |    2 +-
 fs/xfs/xfs_inode.h                       |    2 +-
 include/linux/fs.h                       |    1 +
 20 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index 1a40da9..2e4263c 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -1549,7 +1549,7 @@ static int spufs_mfc_open(struct inode *inode, struct file *file)
 	if (ctx->owner != current->mm)
 		return -EINVAL;
 
-	if (atomic_read(&inode->i_count) != 1)
+	if (iref_read(inode) != 1)
 		return -EBUSY;
 
 	mutex_lock(&ctx->mapping_lock);
diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index 97dae29..d8a308d 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -1289,11 +1289,11 @@ static void pohmelfs_put_super(struct super_block *sb)
 		dprintk("%s: ino: %llu, pi: %p, inode: %p, count: %u.\n",
 				__func__, pi->ino, pi, inode, count);
 
-		if (atomic_read(&inode->i_count) != count) {
+		if (iref_read(inode) != count) {
 			printk("%s: ino: %llu, pi: %p, inode: %p, count: %u, i_count: %d.\n",
 					__func__, pi->ino, pi, inode, count,
-					atomic_read(&inode->i_count));
-			count = atomic_read(&inode->i_count);
+					iref_read(inode));
+			count = iref_read(inode);
 			in_drop_list++;
 		}
 
@@ -1305,7 +1305,7 @@ static void pohmelfs_put_super(struct super_block *sb)
 		pi = POHMELFS_I(inode);
 
 		dprintk("%s: ino: %llu, pi: %p, inode: %p, i_count: %u.\n",
-				__func__, pi->ino, pi, inode, atomic_read(&inode->i_count));
+				__func__, pi->ino, pi, inode, iref_read(inode));
 
 		/*
 		 * These are special inodes, they were created during
@@ -1313,7 +1313,7 @@ static void pohmelfs_put_super(struct super_block *sb)
 		 * so they live here with reference counter being 1 and prevent
 		 * umount from succeed since it believes that they are busy.
 		 */
-		count = atomic_read(&inode->i_count);
+		count = iref_read(inode);
 		if (count) {
 			list_del_init(&inode->i_sb_list);
 			while (count--)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0c3a35b..2953e9f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2718,10 +2718,10 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 		return ERR_PTR(-ENOSPC);
 
 	/* check if there is someone else holds reference */
-	if (S_ISDIR(inode->i_mode) && atomic_read(&inode->i_count) > 1)
+	if (S_ISDIR(inode->i_mode) && iref_read(inode) > 1)
 		return ERR_PTR(-ENOSPC);
 
-	if (atomic_read(&inode->i_count) > 2)
+	if (iref_read(inode) > 2)
 		return ERR_PTR(-ENOSPC);
 
 	if (xchg(&root->fs_info->enospc_unlink, 1))
@@ -3939,7 +3939,7 @@ again:
 		inode = igrab(&entry->vfs_inode);
 		if (inode) {
 			spin_unlock(&root->inode_lock);
-			if (atomic_read(&inode->i_count) > 1)
+			if (iref_read(inode) > 1)
 				d_prune_aliases(inode);
 			/*
 			 * btrfs_drop_inode will have it removed from
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index fad95f8..b6d0ef1 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1102,7 +1102,7 @@ static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
 		spin_unlock(&inode->i_lock);
 		d_prune_aliases(inode);
 		dout("trim_caps_cb %p cap %p  pruned, count now %d\n",
-		     inode, cap, atomic_read(&inode->i_count));
+		     inode, cap, iref_read(inode));
 		return 0;
 	}
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 63a0bdb..74cb762 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1641,7 +1641,7 @@ int cifs_revalidate_dentry(struct dentry *dentry)
 	}
 
 	cFYI(1, "Revalidate: %s inode 0x%p count %d dentry: 0x%p d_time %ld "
-		 "jiffies %ld", full_path, inode, inode->i_count.counter,
+		 "jiffies %ld", full_path, inode, iref_read(inode),
 		 dentry, dentry->d_time, jiffies);
 
 	if (CIFS_SB(sb)->tcon->unix_ext)
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 4ab72db..64669aa 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -100,9 +100,9 @@ void ext3_free_inode (handle_t *handle, struct inode * inode)
 	struct ext3_sb_info *sbi;
 	int fatal = 0, err;
 
-	if (atomic_read(&inode->i_count) > 1) {
+	if (iref_read(inode) > 1) {
 		printk ("ext3_free_inode: inode has count=%d\n",
-					atomic_read(&inode->i_count));
+					iref_read(inode));
 		return;
 	}
 	if (inode->i_nlink) {
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 45853e0..38ac6e5 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -189,9 +189,9 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	struct ext4_sb_info *sbi;
 	int fatal = 0, err, count, cleared;
 
-	if (atomic_read(&inode->i_count) > 1) {
+	if (iref_read(inode) > 1) {
 		printk(KERN_ERR "ext4_free_inode: inode has count=%d\n",
-		       atomic_read(&inode->i_count));
+		       iref_read(inode));
 		return;
 	}
 	if (inode->i_nlink) {
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1bf8a28..ec7a689 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -315,7 +315,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	unsigned dirty;
 	int ret;
 
-	if (!atomic_read(&inode->i_count))
+	if (!iref_read(inode))
 		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
 	else
 		WARN_ON(inode->i_state & I_WILL_FREE);
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 56f0da1..05b5d79 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -183,7 +183,7 @@ void hpfs_write_inode(struct inode *i)
 	struct hpfs_inode_info *hpfs_inode = hpfs_i(i);
 	struct inode *parent;
 	if (i->i_ino == hpfs_sb(i->i_sb)->sb_root) return;
-	if (hpfs_inode->i_rddir_off && !atomic_read(&i->i_count)) {
+	if (hpfs_inode->i_rddir_off && !iref_read(i)) {
 		if (*hpfs_inode->i_rddir_off) printk("HPFS: write_inode: some position still there\n");
 		kfree(hpfs_inode->i_rddir_off);
 		hpfs_inode->i_rddir_off = NULL;
diff --git a/fs/inode.c b/fs/inode.c
index aa66e07..b1dc6dc 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -331,6 +331,16 @@ void iref_locked(struct inode *inode)
 	atomic_inc(&inode->i_count);
 }
 
+/*
+ * Nobody outside of core code should really be looking at the inode reference
+ * count. Please don't add new users of this function.
+ */
+int iref_read(struct inode *inode)
+{
+	return atomic_read(&inode->i_count);
+}
+EXPORT_SYMBOL_GPL(iref_read);
+
 void end_writeback(struct inode *inode)
 {
 	might_sleep();
diff --git a/fs/locks.c b/fs/locks.c
index ab24d49..cbf3114 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1376,7 +1376,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 			goto out;
 		if ((arg == F_WRLCK)
 		    && ((atomic_read(&dentry->d_count) > 1)
-			|| (atomic_read(&inode->i_count) > 1)))
+			|| (iref_read(inode) > 1)))
 			goto out;
 	}
 
diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index 6127baf..8beb842 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -1002,7 +1002,7 @@ static int __logfs_is_valid_block(struct inode *inode, u64 bix, u64 ofs)
 {
 	struct logfs_inode *li = logfs_inode(inode);
 
-	if ((inode->i_nlink == 0) && atomic_read(&inode->i_count) == 1)
+	if ((inode->i_nlink == 0) && iref_read(inode) == 1)
 		return 0;
 
 	if (bix < I0_BLOCKS)
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 886be68..387f4dc 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -385,7 +385,7 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 	dprintk("NFS: nfs_fhget(%s/%Ld ct=%d)\n",
 		inode->i_sb->s_id,
 		(long long)NFS_FILEID(inode),
-		atomic_read(&inode->i_count));
+		iref_read(inode));
 
 out:
 	return inode;
@@ -1191,7 +1191,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 
 	dfprintk(VFS, "NFS: %s(%s/%ld ct=%d info=0x%x)\n",
 			__func__, inode->i_sb->s_id, inode->i_ino,
-			atomic_read(&inode->i_count), fattr->valid);
+			iref_read(inode), fattr->valid);
 
 	if ((fattr->valid & NFS_ATTR_FATTR_FILEID) && nfsi->fileid != fattr->fileid)
 		goto out_fileid;
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 8096a9e..6c54e02 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -252,12 +252,12 @@ void fsnotify_unmount_inodes(struct list_head *list)
 			continue;
 
 		/*
-		 * If i_count is zero, the inode cannot have any watches and
-		 * doing an iref/iput with MS_ACTIVE clear would actually
-		 * evict all inodes with zero i_count from icache which is
+		 * If the inode is not referenced, the inode cannot have any
+		 * watches and doing an iref/iput with MS_ACTIVE clear would
+		 * actually evict all unreferenced inodes from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		if (!atomic_read(&inode->i_count))
+		if (!iref_read(inode))
 			continue;
 
 		need_iput_tmp = need_iput;
@@ -270,8 +270,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 			need_iput_tmp = NULL;
 
 		/* In case the dropping of a reference would nuke next_i. */
-		if ((&next_i->i_sb_list != list) &&
-		    atomic_read(&next_i->i_count) &&
+		if ((&next_i->i_sb_list != list) && iref_read(inode) &&
 		    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
 			iref_locked(next_i);
 			need_iput = next_i;
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 313d39d..55c3ad3 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -1477,7 +1477,7 @@ static int maybe_indirect_to_direct(struct reiserfs_transaction_handle *th,
 	 ** reading in the last block.  The user will hit problems trying to
 	 ** read the file, but for now we just skip the indirect2direct
 	 */
-	if (atomic_read(&inode->i_count) > 1 ||
+	if (iref_read(inode) > 1 ||
 	    !tail_has_to_be_packed(inode) ||
 	    !page || (REISERFS_I(inode)->i_flags & i_nopack_mask)) {
 		/* leave tail in an unformatted node */
diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index 450c919..792593b 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -320,7 +320,7 @@ out:
 }
 
 /*
- * This routine is called when i_nlink == 0 and i_count goes to 0.
+ * This routine is called when i_nlink == 0 and the reference count goes to 0.
  * All blocking cleanup operations need to go here to avoid races.
  */
 static void
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 45888fb..a1b109c 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -342,7 +342,7 @@ static void ubifs_evict_inode(struct inode *inode)
 		goto out;
 
 	dbg_gen("inode %lu, mode %#x", inode->i_ino, (int)inode->i_mode);
-	ubifs_assert(!atomic_read(&inode->i_count));
+	ubifs_assert(!iref_read(inode));
 
 	truncate_inode_pages(&inode->i_data, 0);
 
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index be5dffd..c3940ab 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -599,7 +599,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->count = atomic_read(&VFS_I(ip)->i_count);
+		__entry->count = iref_read(VFS_I(ip));
 		__entry->pincount = atomic_read(&ip->i_pincount);
 		__entry->caller_ip = caller_ip;
 	),
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index cbb4791..5000660 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -481,7 +481,7 @@ void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 
 #define IHOLD(ip) \
 do { \
-	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
+	ASSERT(iref_read(VFS_I(ip)) > 0) ; \
 	iref(VFS_I(ip)); \
 	trace_xfs_ihold(ip, _THIS_IP_); \
 } while (0)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2e971f2..6f0df2a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2186,6 +2186,7 @@ extern void unlock_new_inode(struct inode *);
 
 extern void iref(struct inode *inode);
 extern void iref_locked(struct inode *inode);
+extern int iref_read(struct inode *inode);
 extern void iget_failed(struct inode *);
 extern void end_writeback(struct inode *);
 extern void destroy_inode(struct inode *);
-- 
1.7.1

