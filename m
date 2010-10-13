Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab0JMATH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 20:19:07 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:60861 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752339Ab0JMAQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 20:16:42 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/18] fs: rework icount to be a locked variable
Date: Wed, 13 Oct 2010 11:15:50 +1100
Message-Id: <1286928961-15157-8-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286928961-15157-1-git-send-email-david@fromorbit.com>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The inode reference count is currently an atomic variable so that it can be
sampled/modified outside the inode_lock. However, the inode_lock is still
needed to synchronise the final reference count and checks against the inode
state.

To avoid needing the protection of the inode lock, protect the inode reference
count with the per-inode i_lock and convert it to a normal variable. To avoid
existing out-of-tree code accidentally compiling against the new method, rename
the i_count field to i_ref. This is relatively straight forward as there
are limited external references to the i_count field remaining.

Based on work originally from Nick Piggin.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/btrfs/inode.c             |   14 +++++--
 fs/ceph/mds_client.c         |    2 +-
 fs/cifs/inode.c              |    2 +-
 fs/drop_caches.c             |    4 ++-
 fs/ext3/ialloc.c             |    4 +-
 fs/ext4/ialloc.c             |    4 +-
 fs/fs-writeback.c            |   10 ++++--
 fs/hpfs/inode.c              |    2 +-
 fs/inode.c                   |   81 +++++++++++++++++++++++++++++++-----------
 fs/locks.c                   |    2 +-
 fs/logfs/readwrite.c         |    2 +-
 fs/nfs/inode.c               |    4 +-
 fs/nfs/nfs4state.c           |    2 +-
 fs/nilfs2/mdt.c              |    2 +-
 fs/notify/inode_mark.c       |   25 ++++++++-----
 fs/ntfs/inode.c              |    6 ++--
 fs/ntfs/super.c              |    2 +-
 fs/quota/dquot.c             |    4 ++-
 fs/reiserfs/stree.c          |    2 +-
 fs/smbfs/inode.c             |    2 +-
 fs/ubifs/super.c             |    2 +-
 fs/udf/inode.c               |    2 +-
 fs/xfs/linux-2.6/xfs_trace.h |    2 +-
 fs/xfs/xfs_inode.h           |    1 -
 include/linux/fs.h           |    2 +-
 25 files changed, 122 insertions(+), 63 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 80e28bf..7947bf0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1964,8 +1964,14 @@ void btrfs_add_delayed_iput(struct inode *inode)
 	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct delayed_iput *delayed;
 
-	if (atomic_add_unless(&inode->i_count, -1, 1))
+	/* XXX: filesystems should not play refcount games like this */
+	spin_lock(&inode->i_lock);
+	if (inode->i_ref > 1) {
+		inode->i_ref--;
+		spin_unlock(&inode->i_lock);
 		return;
+	}
+	spin_unlock(&inode->i_lock);
 
 	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
 	delayed->inode = inode;
@@ -2718,10 +2724,10 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 		return ERR_PTR(-ENOSPC);
 
 	/* check if there is someone else holds reference */
-	if (S_ISDIR(inode->i_mode) && atomic_read(&inode->i_count) > 1)
+	if (S_ISDIR(inode->i_mode) && inode->i_ref > 1)
 		return ERR_PTR(-ENOSPC);
 
-	if (atomic_read(&inode->i_count) > 2)
+	if (inode->i_ref > 2)
 		return ERR_PTR(-ENOSPC);
 
 	if (xchg(&root->fs_info->enospc_unlink, 1))
@@ -3939,7 +3945,7 @@ again:
 		inode = igrab(&entry->vfs_inode);
 		if (inode) {
 			spin_unlock(&root->inode_lock);
-			if (atomic_read(&inode->i_count) > 1)
+			if (inode->i_ref > 1)
 				d_prune_aliases(inode);
 			/*
 			 * btrfs_drop_inode will have it removed from
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index fad95f8..1217580 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1102,7 +1102,7 @@ static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
 		spin_unlock(&inode->i_lock);
 		d_prune_aliases(inode);
 		dout("trim_caps_cb %p cap %p  pruned, count now %d\n",
-		     inode, cap, atomic_read(&inode->i_count));
+		     inode, cap, inode->i_ref);
 		return 0;
 	}
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 53cce8c..f13f2d0 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1641,7 +1641,7 @@ int cifs_revalidate_dentry(struct dentry *dentry)
 	}
 
 	cFYI(1, "Revalidate: %s inode 0x%p count %d dentry: 0x%p d_time %ld "
-		 "jiffies %ld", full_path, inode, inode->i_count.counter,
+		 "jiffies %ld", full_path, inode, inode->i_ref,
 		 dentry, dentry->d_time, jiffies);
 
 	if (CIFS_SB(sb)->tcon->unix_ext)
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index c2721fa..10c8c5a 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -22,7 +22,9 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 			continue;
 		if (inode->i_mapping->nrpages == 0)
 			continue;
-		atomic_inc(&inode->i_count);
+		spin_lock(&inode->i_lock);
+		inode->i_ref++;
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 4ab72db..fb20ac7 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -100,9 +100,9 @@ void ext3_free_inode (handle_t *handle, struct inode * inode)
 	struct ext3_sb_info *sbi;
 	int fatal = 0, err;
 
-	if (atomic_read(&inode->i_count) > 1) {
+	if (inode->i_ref > 1) {
 		printk ("ext3_free_inode: inode has count=%d\n",
-					atomic_read(&inode->i_count));
+					inode->i_ref);
 		return;
 	}
 	if (inode->i_nlink) {
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 45853e0..56d0bb0 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -189,9 +189,9 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	struct ext4_sb_info *sbi;
 	int fatal = 0, err, count, cleared;
 
-	if (atomic_read(&inode->i_count) > 1) {
+	if (inode->i_ref > 1) {
 		printk(KERN_ERR "ext4_free_inode: inode has count=%d\n",
-		       atomic_read(&inode->i_count));
+		       inode->i_ref);
 		return;
 	}
 	if (inode->i_nlink) {
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8fb092a..be40b8d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -315,7 +315,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	unsigned dirty;
 	int ret;
 
-	if (!atomic_read(&inode->i_count))
+	if (!inode->i_ref)
 		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
 	else
 		WARN_ON(inode->i_state & I_WILL_FREE);
@@ -493,7 +493,9 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 			return 1;
 
 		BUG_ON(inode->i_state & I_FREEING);
-		atomic_inc(&inode->i_count);
+		spin_lock(&inode->i_lock);
+		inode->i_ref++;
+		spin_unlock(&inode->i_lock);
 		pages_skipped = wbc->pages_skipped;
 		writeback_single_inode(inode, wbc);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -1039,7 +1041,9 @@ static void wait_sb_inodes(struct super_block *sb)
 		mapping = inode->i_mapping;
 		if (mapping->nrpages == 0)
 			continue;
-		atomic_inc(&inode->i_count);
+		spin_lock(&inode->i_lock);
+		inode->i_ref++;
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		/*
 		 * We hold a reference to 'inode' so it couldn't have
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 56f0da1..67147bf 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -183,7 +183,7 @@ void hpfs_write_inode(struct inode *i)
 	struct hpfs_inode_info *hpfs_inode = hpfs_i(i);
 	struct inode *parent;
 	if (i->i_ino == hpfs_sb(i->i_sb)->sb_root) return;
-	if (hpfs_inode->i_rddir_off && !atomic_read(&i->i_count)) {
+	if (hpfs_inode->i_rddir_off && !i->i_ref) {
 		if (*hpfs_inode->i_rddir_off) printk("HPFS: write_inode: some position still there\n");
 		kfree(hpfs_inode->i_rddir_off);
 		hpfs_inode->i_rddir_off = NULL;
diff --git a/fs/inode.c b/fs/inode.c
index ee242c1..9f7d284 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -26,6 +26,13 @@
 #include <linux/posix_acl.h>
 
 /*
+ * Locking rules.
+ *
+ * inode->i_lock protects:
+ *   i_ref
+ */
+
+/*
  * This is needed for the following functions:
  *  - inode_has_buffers
  *  - invalidate_inode_buffers
@@ -64,9 +71,9 @@ static unsigned int i_hash_shift __read_mostly;
  * Each inode can be on two separate lists. One is
  * the hash list of the inode, used for lookups. The
  * other linked list is the "type" list:
- *  "in_use" - valid inode, i_count > 0, i_nlink > 0
+ *  "in_use" - valid inode, i_ref > 0, i_nlink > 0
  *  "dirty"  - as "in_use" but also dirty
- *  "unused" - valid inode, i_count = 0
+ *  "unused" - valid inode, i_ref = 0
  *
  * A "dirty" list is maintained for each super block,
  * allowing for low-overhead inode sync() operations.
@@ -164,7 +171,7 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_sb = sb;
 	inode->i_blkbits = sb->s_blocksize_bits;
 	inode->i_flags = 0;
-	atomic_set(&inode->i_count, 1);
+	inode->i_ref = 1;
 	inode->i_op = &empty_iops;
 	inode->i_fop = &empty_fops;
 	inode->i_nlink = 1;
@@ -325,9 +332,11 @@ static void init_once(void *foo)
  */
 void iref(struct inode *inode)
 {
-	WARN_ON(atomic_read(&inode->i_count < 1));
+	WARN_ON(inode->i_ref < 1);
 	spin_lock(&inode_lock);
-	atomic_inc(&inode->i_count);
+	spin_lock(&inode->i_lock);
+	inode->i_ref++;
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL_GPL(iref);
@@ -432,13 +441,16 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 		if (inode->i_state & I_NEW)
 			continue;
 		invalidate_inode_buffers(inode);
-		if (!atomic_read(&inode->i_count)) {
+		spin_lock(&inode->i_lock);
+		if (!inode->i_ref) {
+			spin_unlock(&inode->i_lock);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			list_move(&inode->i_lru, dispose);
 			percpu_counter_dec(&nr_inodes_unused);
 			continue;
 		}
+		spin_unlock(&inode->i_lock);
 		busy = 1;
 	}
 	return busy;
@@ -476,7 +488,7 @@ static int can_unuse(struct inode *inode)
 		return 0;
 	if (inode_has_buffers(inode))
 		return 0;
-	if (atomic_read(&inode->i_count))
+	if (inode->i_ref)
 		return 0;
 	if (inode->i_data.nrpages)
 		return 0;
@@ -519,8 +531,9 @@ static void prune_icache(int nr_to_scan)
 		 * Referenced or dirty inodes are still in use. Give them
 		 * another pass through the LRU as we canot reclaim them now.
 		 */
-		if (atomic_read(&inode->i_count) ||
-		    (inode->i_state & ~I_REFERENCED)) {
+		spin_lock(&inode->i_lock);
+		if (inode->i_ref || (inode->i_state & ~I_REFERENCED)) {
+			spin_unlock(&inode->i_lock);
 			list_del_init(&inode->i_lru);
 			percpu_counter_dec(&nr_inodes_unused);
 			continue;
@@ -528,12 +541,14 @@ static void prune_icache(int nr_to_scan)
 
 		/* recently referenced inodes get one more pass */
 		if (inode->i_state & I_REFERENCED) {
+			spin_unlock(&inode->i_lock);
 			list_move(&inode->i_lru, &inode_lru);
 			inode->i_state &= ~I_REFERENCED;
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
-			atomic_inc(&inode->i_count);
+			inode->i_ref++;
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
@@ -550,7 +565,8 @@ static void prune_icache(int nr_to_scan)
 				list_move(&inode->i_lru, &inode_lru);
 				continue;
 			}
-		}
+		} else
+			spin_unlock(&inode->i_lock);
 		list_move(&inode->i_lru, &freeable);
 		list_del_init(&inode->i_wb_list);
 		WARN_ON(inode->i_state & I_NEW);
@@ -803,7 +819,9 @@ static struct inode *get_new_inode(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		atomic_inc(&old->i_count);
+		spin_lock(&old->i_lock);
+		old->i_ref++;
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -850,7 +868,9 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		atomic_inc(&old->i_count);
+		spin_lock(&old->i_lock);
+		old->i_ref++;
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -902,15 +922,19 @@ EXPORT_SYMBOL(iunique);
 struct inode *igrab(struct inode *inode)
 {
 	spin_lock(&inode_lock);
-	if (!(inode->i_state & (I_FREEING|I_WILL_FREE)))
-		atomic_inc(&inode->i_count);
-	else
+	spin_lock(&inode->i_lock);
+	if (!(inode->i_state & (I_FREEING|I_WILL_FREE))) {
+		inode->i_ref++;
+		spin_unlock(&inode->i_lock);
+	} else {
+		spin_unlock(&inode->i_lock);
 		/*
 		 * Handle the case where s_op->clear_inode is not been
 		 * called yet, and somebody is calling igrab
 		 * while the inode is getting freed.
 		 */
 		inode = NULL;
+	}
 	spin_unlock(&inode_lock);
 	return inode;
 }
@@ -944,7 +968,9 @@ static struct inode *ifind(struct super_block *sb,
 	spin_lock(&inode_lock);
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
-		atomic_inc(&inode->i_count);
+		spin_lock(&inode->i_lock);
+		inode->i_ref++;
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
@@ -977,7 +1003,9 @@ static struct inode *ifind_fast(struct super_block *sb,
 	spin_lock(&inode_lock);
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
-		atomic_inc(&inode->i_count);
+		spin_lock(&inode->i_lock);
+		inode->i_ref++;
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(inode);
 		return inode;
@@ -1160,7 +1188,9 @@ int insert_inode_locked(struct inode *inode)
 			spin_unlock(&inode_lock);
 			return 0;
 		}
-		atomic_inc(&old->i_count);
+		spin_lock(&old->i_lock);
+		old->i_ref++;
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1199,7 +1229,9 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 			spin_unlock(&inode_lock);
 			return 0;
 		}
-		atomic_inc(&old->i_count);
+		spin_lock(&old->i_lock);
+		old->i_ref++;
+		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
 		if (unlikely(!hlist_unhashed(&old->i_hash))) {
@@ -1333,8 +1365,15 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state & I_CLEAR);
 
-		if (atomic_dec_and_lock(&inode->i_count, &inode_lock))
+		spin_lock(&inode_lock);
+		spin_lock(&inode->i_lock);
+		if (--inode->i_ref == 0) {
+			spin_unlock(&inode->i_lock);
 			iput_final(inode);
+			return;
+		}
+		spin_unlock(&inode->i_lock);
+		spin_lock(&inode_lock);
 	}
 }
 EXPORT_SYMBOL(iput);
diff --git a/fs/locks.c b/fs/locks.c
index ab24d49..4dec81a 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1376,7 +1376,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 			goto out;
 		if ((arg == F_WRLCK)
 		    && ((atomic_read(&dentry->d_count) > 1)
-			|| (atomic_read(&inode->i_count) > 1)))
+			|| inode->i_ref > 1))
 			goto out;
 	}
 
diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index 6127baf..1b26a8d 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -1002,7 +1002,7 @@ static int __logfs_is_valid_block(struct inode *inode, u64 bix, u64 ofs)
 {
 	struct logfs_inode *li = logfs_inode(inode);
 
-	if ((inode->i_nlink == 0) && atomic_read(&inode->i_count) == 1)
+	if ((inode->i_nlink == 0) && inode->i_ref == 1)
 		return 0;
 
 	if (bix < I0_BLOCKS)
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 7d2d6c7..32a9c69 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -384,7 +384,7 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 	dprintk("NFS: nfs_fhget(%s/%Ld ct=%d)\n",
 		inode->i_sb->s_id,
 		(long long)NFS_FILEID(inode),
-		atomic_read(&inode->i_count));
+		inode->i_ref);
 
 out:
 	return inode;
@@ -1190,7 +1190,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 
 	dfprintk(VFS, "NFS: %s(%s/%ld ct=%d info=0x%x)\n",
 			__func__, inode->i_sb->s_id, inode->i_ino,
-			atomic_read(&inode->i_count), fattr->valid);
+			inode->i_ref, fattr->valid);
 
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
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 62756b4..939459d 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -480,7 +480,7 @@ nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
 		inode->i_sb = sb; /* sb may be NULL for some meta data files */
 		inode->i_blkbits = nilfs->ns_blocksize_bits;
 		inode->i_flags = 0;
-		atomic_set(&inode->i_count, 1);
+		inode->i_ref = 1;
 		inode->i_nlink = 1;
 		inode->i_ino = ino;
 		inode->i_mode = S_IFREG;
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index fa7f3b8..1a4c117 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -252,29 +252,36 @@ void fsnotify_unmount_inodes(struct list_head *list)
 			continue;
 
 		/*
-		 * If i_count is zero, the inode cannot have any watches and
+		 * If i_ref is zero, the inode cannot have any watches and
 		 * doing an iref/iput with MS_ACTIVE clear would actually
-		 * evict all inodes with zero i_count from icache which is
+		 * evict all inodes with zero i_ref from icache which is
 		 * unnecessarily violent and may in fact be illegal to do.
 		 */
-		if (!atomic_read(&inode->i_count))
+		spin_lock(&inode->i_lock);
+		if (!inode->i_ref) {
+			spin_unlock(&inode->i_lock);
 			continue;
+		}
 
 		need_iput_tmp = need_iput;
 		need_iput = NULL;
 
 		/* In case fsnotify_inode_delete() drops a reference. */
 		if (inode != need_iput_tmp)
-			atomic_inc(&inode->i_count);
+			inode->i_ref++;
 		else
 			need_iput_tmp = NULL;
+		spin_unlock(&inode->i_lock);
 
 		/* In case the dropping of a reference would nuke next_i. */
-		if ((&next_i->i_sb_list != list) &&
-		    atomic_read(&next_i->i_count) &&
-		    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
-			atomic_inc(&next_i->i_count);
-			need_iput = next_i;
+		if (&next_i->i_sb_list != list) {
+			spin_lock(&next_i->i_lock);
+			if (inode->i_ref &&
+			    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
+				next_i->i_ref++;
+				need_iput = next_i;
+			}
+			spin_unlock(&next_i->i_lock);
 		}
 
 		/*
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 93622b1..07fdef8 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -531,7 +531,7 @@ err_corrupt_attr:
  *
  * Q: What locks are held when the function is called?
  * A: i_state has I_NEW set, hence the inode is locked, also
- *    i_count is set to 1, so it is not going to go away
+ *    i_ref is set to 1, so it is not going to go away
  *    i_flags is set to 0 and we have no business touching it.  Only an ioctl()
  *    is allowed to write to them. We should of course be honouring them but
  *    we need to do that using the IS_* macros defined in include/linux/fs.h.
@@ -1208,7 +1208,7 @@ err_out:
  *
  * Q: What locks are held when the function is called?
  * A: i_state has I_NEW set, hence the inode is locked, also
- *    i_count is set to 1, so it is not going to go away
+ *    i_ref is set to 1, so it is not going to go away
  *
  * Return 0 on success and -errno on error.  In the error case, the inode will
  * have had make_bad_inode() executed on it.
@@ -1475,7 +1475,7 @@ err_out:
  *
  * Q: What locks are held when the function is called?
  * A: i_state has I_NEW set, hence the inode is locked, also
- *    i_count is set to 1, so it is not going to go away
+ *    i_ref is set to 1, so it is not going to go away
  *
  * Return 0 on success and -errno on error.  In the error case, the inode will
  * have had make_bad_inode() executed on it.
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 52b48e3..181eddb 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2689,7 +2689,7 @@ static const struct super_operations ntfs_sops = {
 	//					   held. See fs/inode.c::
 	//					   generic_drop_inode(). */
 	//.delete_inode	= NULL,			/* VFS: Delete inode from disk.
-	//					   Called when i_count becomes
+	//					   Called when i_ref becomes
 	//					   0 and i_nlink is also 0. */
 	//.write_super	= NULL,			/* Flush dirty super block to
 	//					   disk. */
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 38d4304..326df72 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -909,7 +909,9 @@ static void add_dquot_ref(struct super_block *sb, int type)
 		if (!dqinit_needed(inode, type))
 			continue;
 
-		atomic_inc(&inode->i_count);
+		spin_lock(&inode->i_lock);
+		inode->i_ref++;
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 
 		iput(old_inode);
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 313d39d..42d3311 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -1477,7 +1477,7 @@ static int maybe_indirect_to_direct(struct reiserfs_transaction_handle *th,
 	 ** reading in the last block.  The user will hit problems trying to
 	 ** read the file, but for now we just skip the indirect2direct
 	 */
-	if (atomic_read(&inode->i_count) > 1 ||
+	if (inode->i_ref > 1 ||
 	    !tail_has_to_be_packed(inode) ||
 	    !page || (REISERFS_I(inode)->i_flags & i_nopack_mask)) {
 		/* leave tail in an unformatted node */
diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index 450c919..85ff606 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -320,7 +320,7 @@ out:
 }
 
 /*
- * This routine is called when i_nlink == 0 and i_count goes to 0.
+ * This routine is called when i_nlink == 0 and i_ref goes to 0.
  * All blocking cleanup operations need to go here to avoid races.
  */
 static void
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index cd5900b..ead1f89 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -342,7 +342,7 @@ static void ubifs_evict_inode(struct inode *inode)
 		goto out;
 
 	dbg_gen("inode %lu, mode %#x", inode->i_ino, (int)inode->i_mode);
-	ubifs_assert(!atomic_read(&inode->i_count));
+	ubifs_assert(!inode->i_ref);
 
 	truncate_inode_pages(&inode->i_data, 0);
 
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index fc48f37..05b0445 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1071,7 +1071,7 @@ static void __udf_read_inode(struct inode *inode)
 	 *      i_flags = sb->s_flags
 	 *      i_state = 0
 	 * clean_inode(): zero fills and sets
-	 *      i_count = 1
+	 *      i_ref = 1
 	 *      i_nlink = 1
 	 *      i_op = NULL;
 	 */
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index be5dffd..0428b06 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -599,7 +599,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->count = atomic_read(&VFS_I(ip)->i_count);
+		__entry->count = VFS_I(ip)->i_ref;
 		__entry->pincount = atomic_read(&ip->i_pincount);
 		__entry->caller_ip = caller_ip;
 	),
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index cbb4791..1e41fa8 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -481,7 +481,6 @@ void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 
 #define IHOLD(ip) \
 do { \
-	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
 	iref(VFS_I(ip)); \
 	trace_xfs_ihold(ip, _THIS_IP_); \
 } while (0)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6eb94b0..0b6ee34 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -730,7 +730,7 @@ struct inode {
 	struct list_head	i_sb_list;
 	struct list_head	i_dentry;
 	unsigned long		i_ino;
-	atomic_t		i_count;
+	unsigned int		i_ref;
 	unsigned int		i_nlink;
 	uid_t			i_uid;
 	gid_t			i_gid;
-- 
1.7.1

