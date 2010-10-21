Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab0JUNXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:23:53 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:11481 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758027Ab0JUNWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+CeQ8IgjoEik0
Message-Id: <20101021131017.167093236@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:41 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 12/14] fs: icache lazy inode lru
References: <20101021130829.442910807@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-10.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impelemnt lazy inode lru similarly to dcache. That is, avoid moving inode
around the LRU list in iget/iput operations and defer the refcount check
to reclaim-time. Use a flag, I_REFERENCED, to tell reclaim that iget has
touched the inode in the past.

nr_unused now only accounts inodes iff they are on the unused list,
previously it would account inodes with 0 refcount (even if dirty).

The global inode_in_use list goes away, and !list_empty(&inode->i_list)
invariant goes away.

This reduces lock acquisition, improves lock ordering and corner cases
in inode_get handling.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/9p/vfs_inode.c           |    2 
 fs/affs/inode.c             |    2 
 fs/afs/dir.c                |    2 
 fs/anon_inodes.c            |    2 
 fs/bfs/dir.c                |    2 
 fs/block_dev.c              |    4 -
 fs/btrfs/inode.c            |    2 
 fs/coda/dir.c               |    2 
 fs/drop_caches.c            |    2 
 fs/exofs/inode.c            |    2 
 fs/exofs/namei.c            |    2 
 fs/ext2/namei.c             |    2 
 fs/ext3/namei.c             |    2 
 fs/ext4/namei.c             |    2 
 fs/fs-writeback.c           |   12 +--
 fs/gfs2/ops_inode.c         |    2 
 fs/hfsplus/dir.c            |    2 
 fs/inode.c                  |  141 ++++++++++++++++++--------------------------
 fs/internal.h               |    4 -
 fs/jffs2/dir.c              |    4 -
 fs/jfs/jfs_txnmgr.c         |    2 
 fs/jfs/namei.c              |    2 
 fs/libfs.c                  |    2 
 fs/logfs/dir.c              |    2 
 fs/minix/namei.c            |    2 
 fs/namei.c                  |    2 
 fs/nfs/dir.c                |    2 
 fs/nfs/getroot.c            |    2 
 fs/nilfs2/namei.c           |    2 
 fs/notify/inode_mark.c      |    4 -
 fs/ntfs/super.c             |    2 
 fs/ocfs2/namei.c            |    2 
 fs/quota/dquot.c            |    2 
 fs/reiserfs/namei.c         |    2 
 fs/sysv/namei.c             |    2 
 fs/ubifs/dir.c              |    2 
 fs/udf/namei.c              |    2 
 fs/ufs/namei.c              |    2 
 fs/xfs/linux-2.6/xfs_iops.c |    2 
 fs/xfs/xfs_inode.h          |    2 
 include/linux/fs.h          |   15 ++--
 include/linux/writeback.h   |    1 
 ipc/mqueue.c                |    2 
 kernel/futex.c              |    2 
 mm/shmem.c                  |    2 
 net/socket.c                |    2 
 46 files changed, 116 insertions(+), 145 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-21 23:50:39.000000000 +1100
@@ -40,14 +40,13 @@
  * inode_hash_lock protects:
  *   inode hash table, i_hash
  * wb_inode_list_lock protects:
- *   inode_in_use, inode_unused, b_io, b_more_io, b_dirty, i_list
+ *   inode_unused, b_io, b_more_io, b_dirty, i_list
  *
  * Ordering:
  * i_lock
  *   sb_inode_list_lock
- *     wb_inode_list_lock
+ *   wb_inode_list_lock
  *   inode_hash_lock
- *     wb_inode_list_lock
  */
 /*
  * This is needed for the following functions:
@@ -96,7 +95,6 @@ static unsigned int i_hash_shift __read_
  * allowing for low-overhead inode sync() operations.
  */
 
-LIST_HEAD(inode_in_use);
 LIST_HEAD(inode_unused);
 static struct hlist_head *inode_hashtable __read_mostly;
 
@@ -318,6 +316,7 @@ void inode_init_once(struct inode *inode
 	INIT_HLIST_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
+	INIT_LIST_HEAD(&inode->i_list);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
 	spin_lock_init(&inode->i_data.tree_lock);
 	spin_lock_init(&inode->i_data.i_mmap_lock);
@@ -339,42 +338,6 @@ static void init_once(void *foo)
 	inode_init_once(inode);
 }
 
-void __inode_get_ilock(struct inode *inode)
-{
- 	assert_spin_locked(&inode->i_lock);
-	BUG_ON(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE));
-	BUG_ON(inode->i_count == 0);
-	inode->i_count++;
-}
-EXPORT_SYMBOL(__inode_get_ilock);
-
-void __inode_get(struct inode *inode)
-{
-	spin_lock(&inode->i_lock);
-	__inode_get_ilock(inode);
-	spin_unlock(&inode->i_lock);
-}
-EXPORT_SYMBOL(__inode_get);
-
-/*
- * Don't fret, this is going away when inode_get callers and implementations
- * get much simpler with lazy inode LRU.
- */
-void inode_get_ilock_wblock(struct inode *inode)
-{
- 	assert_spin_locked(&inode->i_lock);
-	assert_spin_locked(&wb_inode_list_lock);
-	BUG_ON(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE));
-	inode->i_count++;
-	if (inode->i_count != 1)
-		return;
-
-	if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
-		list_move(&inode->i_list, &inode_in_use);
-	}
-	atomic_dec(&nr_unused);
-}
-
 /*
  * i_lock must be held
  */
@@ -382,16 +345,9 @@ void inode_get_ilock(struct inode *inode
 {
  	assert_spin_locked(&inode->i_lock);
 	BUG_ON(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE));
-	inode->i_count++;
-	if (inode->i_count != 1)
-		return;
+	BUG_ON(inode->i_count == 0);
 
-	if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
-		spin_lock(&wb_inode_list_lock);
-		list_move(&inode->i_list, &inode_in_use);
-		spin_unlock(&wb_inode_list_lock);
-	}
-	atomic_dec(&nr_unused);
+	inode->i_count++;
 }
 EXPORT_SYMBOL(inode_get_ilock);
 
@@ -450,7 +406,7 @@ static void dispose_list(struct list_hea
 
 		/* No locking here, it's a private list now */
 		inode = list_first_entry(head, struct inode, i_list);
-		list_del(&inode->i_list);
+		list_del_init(&inode->i_list);
 
 		evict(inode);
 
@@ -498,20 +454,23 @@ static int invalidate_list(struct super_
 		}
 		invalidate_inode_buffers(inode);
 		if (!inode->i_count) {
-			spin_lock(&wb_inode_list_lock);
-			list_move(&inode->i_list, dispose);
-			spin_unlock(&wb_inode_list_lock);
+			if (!list_empty(&inode->i_list)) {
+				spin_lock(&wb_inode_list_lock);
+				list_del(&inode->i_list);
+				spin_unlock(&wb_inode_list_lock);
+				if (!(inode->i_state & (I_DIRTY|I_SYNC)))
+					atomic_dec(&nr_unused);
+			}
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
-			count++;
 			spin_unlock(&inode->i_lock);
+			list_add(&inode->i_list, dispose);
+			count++;
 			continue;
 		}
 		spin_unlock(&inode->i_lock);
 		busy = 1;
 	}
-	/* only unused inodes may be cached with i_count zero */
-	atomic_sub(count, &nr_unused);
 
 	return busy;
 }
@@ -542,7 +501,7 @@ EXPORT_SYMBOL(invalidate_inodes);
 
 static int can_unuse(struct inode *inode)
 {
-	if (inode->i_state)
+	if (inode->i_state & ~I_REFERENCED)
 		return 0;
 	if (inode_has_buffers(inode))
 		return 0;
@@ -590,13 +549,28 @@ static void prune_icache(int nr_to_scan)
 			goto lock_again;
 		}
 
-		if (inode->i_state || inode->i_count) {
+		if (inode->i_count || (inode->i_state & ~I_REFERENCED)) {
+			list_del_init(&inode->i_list);
+			spin_unlock(&inode->i_lock);
+			atomic_dec(&nr_unused);
+			continue;
+		}
+		if (inode->i_state & I_REFERENCED) {
 			list_move(&inode->i_list, &inode_unused);
+			inode->i_state &= ~I_REFERENCED;
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
-			inode_get_ilock_wblock(inode);
+			/*
+			 * Move back to the head of the unused list in case the
+			 * invalidations failed. Could improve this by going to
+			 * the head of the list only if invalidation fails.
+			 *
+			 * We'll try to get it back if it becomes freeable.
+			 */
+			list_move(&inode->i_list, &inode_unused);
+			inode->i_count++;
 			spin_unlock(&wb_inode_list_lock);
 			spin_unlock(&inode->i_lock);
 			if (remove_inode_buffers(inode))
@@ -670,9 +644,9 @@ static struct shrinker icache_shrinker =
 static void __wait_on_freeing_inode(struct inode *inode);
 /*
  * Called with the inode lock held.
- * NOTE: we are not increasing the inode-refcount, you must call
- * inode_get_ilock() by hand after calling find_inode now! This simplifies
- * iunique and won't add any additional branch in the common code.
+ * NOTE: we are not increasing the inode-refcount, you must increment the
+ * refcount by hand after calling find_inode now! This simplifies iunique and
+ * won't add any additional branch in the common code.
  */
 static struct inode *find_inode(struct super_block *sb,
 				struct hlist_head *head,
@@ -748,10 +722,8 @@ static inline void
 __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
 			struct inode *inode)
 {
+	BUG_ON(!inode->i_count);
 	atomic_inc(&nr_inodes);
-	spin_lock(&wb_inode_list_lock);
-	list_add(&inode->i_list, &inode_in_use);
-	spin_unlock(&wb_inode_list_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
@@ -896,7 +868,7 @@ static struct inode *get_new_inode(struc
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		inode_get_ilock(old);
+		old->i_count++;
 		spin_unlock(&inode_hash_lock);
 		spin_unlock(&old->i_lock);
 		destroy_inode(inode);
@@ -947,7 +919,7 @@ static struct inode *get_new_inode_fast(
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		inode_get_ilock(old);
+		old->i_count++;
 		spin_unlock(&inode_hash_lock);
 		spin_unlock(&old->i_lock);
 		destroy_inode(inode);
@@ -1027,7 +999,7 @@ struct inode *igrab(struct inode *inode)
 
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_WILL_FREE)))
-		inode_get_ilock(inode);
+		inode->i_count++;
 	else
 		/*
 		 * Handle the case where s_op->clear_inode is not been
@@ -1069,7 +1041,7 @@ static struct inode *ifind(struct super_
 	spin_lock(&inode_hash_lock);
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
-		inode_get_ilock(inode);
+		inode->i_count++;
 		spin_unlock(&inode_hash_lock);
 		spin_unlock(&inode->i_lock);
 		if (likely(wait))
@@ -1103,7 +1075,7 @@ static struct inode *ifind_fast(struct s
 	spin_lock(&inode_hash_lock);
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
-		inode_get_ilock(inode);
+		inode->i_count++;
 		spin_unlock(&inode_hash_lock);
 		spin_unlock(&inode->i_lock);
 		wait_on_inode(inode);
@@ -1297,7 +1269,7 @@ int insert_inode_locked(struct inode *in
 		return 0;
 
 found_old:
-		inode_get_ilock(old);
+		old->i_count++;
 		spin_unlock(&inode_hash_lock);
 		spin_unlock(&old->i_lock);
 		wait_on_inode(old);
@@ -1347,7 +1319,7 @@ int insert_inode_locked4(struct inode *i
 		return 0;
 
 found_old:
-		inode_get_ilock(old);
+		old->i_count++;
 		spin_unlock(&inode_hash_lock);
 		spin_unlock(&old->i_lock);
 		wait_on_inode(old);
@@ -1446,13 +1418,15 @@ static void iput_final(struct inode *ino
 		drop = generic_drop_inode(inode);
 
 	if (!drop) {
-		if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
-			spin_lock(&wb_inode_list_lock);
-			list_move(&inode->i_list, &inode_unused);
-			spin_unlock(&wb_inode_list_lock);
-		}
-		atomic_inc(&nr_unused);
 		if (sb->s_flags & MS_ACTIVE) {
+			inode->i_state |= I_REFERENCED;
+			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
+					list_empty(&inode->i_list)) {
+				spin_lock(&wb_inode_list_lock);
+				list_add(&inode->i_list, &inode_unused);
+				spin_unlock(&wb_inode_list_lock);
+				atomic_inc(&nr_unused);
+			}
 			spin_unlock(&inode->i_lock);
 			return;
 		}
@@ -1463,12 +1437,15 @@ static void iput_final(struct inode *ino
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		atomic_dec(&nr_unused);
 		__remove_inode_hash(inode);
 	}
-	spin_lock(&wb_inode_list_lock);
-	list_del_init(&inode->i_list);
-	spin_unlock(&wb_inode_list_lock);
+	if (!list_empty(&inode->i_list)) {
+		spin_lock(&wb_inode_list_lock);
+		list_del_init(&inode->i_list);
+		spin_unlock(&wb_inode_list_lock);
+		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
+			atomic_dec(&nr_unused);
+	}
 	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-21 23:50:39.000000000 +1100
@@ -1632,16 +1632,17 @@ struct super_operations {
  *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  */
-#define I_DIRTY_SYNC		1
-#define I_DIRTY_DATASYNC	2
-#define I_DIRTY_PAGES		4
+#define I_DIRTY_SYNC		0x01
+#define I_DIRTY_DATASYNC	0x02
+#define I_DIRTY_PAGES		0x04
 #define __I_NEW			3
 #define I_NEW			(1 << __I_NEW)
-#define I_WILL_FREE		16
-#define I_FREEING		32
-#define I_CLEAR			64
+#define I_WILL_FREE		0x10
+#define I_FREEING		0x20
+#define I_CLEAR			0x40
 #define __I_SYNC		7
 #define I_SYNC			(1 << __I_SYNC)
+#define I_REFERENCED		0x100
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
@@ -2184,8 +2185,6 @@ extern void unlock_new_inode(struct inod
 
 extern void inode_get(struct inode *inode);
 extern void inode_get_ilock(struct inode *inode);
-extern void __inode_get(struct inode *inode);
-extern void __inode_get_ilock(struct inode *inode);
 extern void iget_failed(struct inode *);
 extern void end_writeback(struct inode *);
 extern void destroy_inode(struct inode *);
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-21 23:50:39.000000000 +1100
@@ -416,16 +416,12 @@ writeback_single_inode(struct inode *ino
 			 * completion.
 			 */
 			redirty_tail(inode);
-		} else if (inode->i_count) {
-			/*
-			 * The inode is clean, inuse
-			 */
-			list_move(&inode->i_list, &inode_in_use);
 		} else {
 			/*
-			 * The inode is clean, unused
+			 * The inode is clean
 			 */
 			list_move(&inode->i_list, &inode_unused);
+			atomic_inc(&nr_unused);
 		}
 	}
 	inode_sync_complete(inode);
@@ -521,7 +517,7 @@ static int writeback_sb_inodes(struct su
 		}
 
 		BUG_ON(inode->i_state & I_FREEING);
-		inode_get_ilock_wblock(inode);
+		inode->i_count++;
 		pages_skipped = wbc->pages_skipped;
 		writeback_single_inode(inode, wbc);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -1095,7 +1091,7 @@ static void wait_sb_inodes(struct super_
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		inode_get_ilock_wblock(inode);
+		inode->i_count++;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
 		/*
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/include/linux/writeback.h	2010-10-21 23:50:39.000000000 +1100
@@ -11,7 +11,6 @@ struct backing_dev_info;
 
 extern spinlock_t sb_inode_list_lock;
 extern spinlock_t wb_inode_list_lock;
-extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
 /*
Index: linux-2.6/fs/9p/vfs_inode.c
===================================================================
--- linux-2.6.orig/fs/9p/vfs_inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/9p/vfs_inode.c	2010-10-21 23:50:27.000000000 +1100
@@ -1791,7 +1791,7 @@ v9fs_vfs_link_dotl(struct dentry *old_de
 		/* Caching disabled. No need to get upto date stat info.
 		 * This dentry will be released immediately. So, just i_count++
 		 */
-		__inode_get(old_dentry->d_inode);
+		inode_get(old_dentry->d_inode);
 	}
 
 	dentry->d_op = old_dentry->d_op;
Index: linux-2.6/fs/affs/inode.c
===================================================================
--- linux-2.6.orig/fs/affs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/affs/inode.c	2010-10-21 23:50:27.000000000 +1100
@@ -388,7 +388,7 @@ affs_add_entry(struct inode *dir, struct
 		affs_adjust_checksum(inode_bh, block - be32_to_cpu(chain));
 		mark_buffer_dirty_inode(inode_bh, inode);
 		inode->i_nlink = 2;
-		__inode_get(inode);
+		inode_get(inode);
 	}
 	affs_fix_checksum(sb, bh);
 	mark_buffer_dirty_inode(bh, inode);
Index: linux-2.6/fs/afs/dir.c
===================================================================
--- linux-2.6.orig/fs/afs/dir.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/afs/dir.c	2010-10-21 23:50:27.000000000 +1100
@@ -1045,7 +1045,7 @@ static int afs_link(struct dentry *from,
 	if (ret < 0)
 		goto link_error;
 
-	__inode_get(&vnode->vfs_inode);
+	inode_get(&vnode->vfs_inode);
 	d_instantiate(dentry, &vnode->vfs_inode);
 	key_put(key);
 	_leave(" = 0");
Index: linux-2.6/fs/anon_inodes.c
===================================================================
--- linux-2.6.orig/fs/anon_inodes.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/anon_inodes.c	2010-10-21 23:50:27.000000000 +1100
@@ -114,7 +114,7 @@ struct file *anon_inode_getfile(const ch
 	 * so we can avoid doing an igrab() and we can use an open-coded
 	 * atomic_inc().
 	 */
-	__inode_get(anon_inode_inode);
+	inode_get(anon_inode_inode);
 
 	path.dentry->d_op = &anon_inodefs_dentry_operations;
 	d_instantiate(path.dentry, anon_inode_inode);
Index: linux-2.6/fs/bfs/dir.c
===================================================================
--- linux-2.6.orig/fs/bfs/dir.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/bfs/dir.c	2010-10-21 23:50:27.000000000 +1100
@@ -176,7 +176,7 @@ static int bfs_link(struct dentry *old,
 	inc_nlink(inode);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
-	__inode_get(inode);
+	inode_get(inode);
 	d_instantiate(new, inode);
 	mutex_unlock(&info->bfs_lock);
 	return 0;
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/block_dev.c	2010-10-21 23:50:27.000000000 +1100
@@ -550,7 +550,7 @@ EXPORT_SYMBOL(bdget);
  */
 struct block_device *bdgrab(struct block_device *bdev)
 {
-	__inode_get(bdev->bd_inode);
+	inode_get(bdev->bd_inode);
 
 	return bdev;
 }
@@ -597,7 +597,7 @@ static struct block_device *bd_acquire(s
 			 * So, we can access it via ->i_mapping always
 			 * without igrab().
 			 */
-			__inode_get(bdev->bd_inode);
+			inode_get(bdev->bd_inode);
 			inode->i_bdev = bdev;
 			inode->i_mapping = bdev->bd_inode->i_mapping;
 			list_add(&inode->i_devices, &bdev->bd_inodes);
Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/btrfs/inode.c	2010-10-21 23:50:27.000000000 +1100
@@ -4763,7 +4763,7 @@ static int btrfs_link(struct dentry *old
 	}
 
 	btrfs_set_trans_block_group(trans, dir);
-	__inode_get(inode);
+	inode_get(inode);
 
 	err = btrfs_add_nondir(trans, dentry, inode, 1, index);
 
Index: linux-2.6/fs/coda/dir.c
===================================================================
--- linux-2.6.orig/fs/coda/dir.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/coda/dir.c	2010-10-21 23:50:27.000000000 +1100
@@ -303,7 +303,7 @@ static int coda_link(struct dentry *sour
 	}
 
 	coda_dir_update_mtime(dir_inode);
-	__inode_get(inode);
+	inode_get(inode);
 	d_instantiate(de, inode);
 	inc_nlink(inode);
 
Index: linux-2.6/fs/exofs/inode.c
===================================================================
--- linux-2.6.orig/fs/exofs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/exofs/inode.c	2010-10-21 23:50:27.000000000 +1100
@@ -1162,7 +1162,7 @@ struct inode *exofs_new_inode(struct ino
 	/* increment the refcount so that the inode will still be around when we
 	 * reach the callback
 	 */
-	__inode_get(inode);
+	inode_get(inode);
 
 	ios->done = create_done;
 	ios->private = inode;
Index: linux-2.6/fs/exofs/namei.c
===================================================================
--- linux-2.6.orig/fs/exofs/namei.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/exofs/namei.c	2010-10-21 23:50:27.000000000 +1100
@@ -153,7 +153,7 @@ static int exofs_link(struct dentry *old
 
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
-	__inode_get(inode);
+	inode_get(inode);
 
 	return exofs_add_nondir(dentry, inode);
 }
Index: linux-2.6/fs/ext2/namei.c
===================================================================
--- linux-2.6.orig/fs/ext2/namei.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/ext2/namei.c	2010-10-21 23:50:27.000000000 +1100
@@ -206,7 +206,7 @@ static int ext2_link (struct dentry * ol
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	__inode_get(inode);
+	inode_get(inode);
 
 	err = ext2_add_link(dentry, inode);
 	if (!err) {
Index: linux-2.6/fs/ext3/namei.c
===================================================================
--- linux-2.6.orig/fs/ext3/namei.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/ext3/namei.c	2010-10-21 23:50:27.000000000 +1100
@@ -2260,7 +2260,7 @@ static int ext3_link (struct dentry * ol
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inc_nlink(inode);
-	__inode_get(inode);
+	inode_get(inode);
 
 	err = ext3_add_entry(handle, dentry, inode);
 	if (!err) {
Index: linux-2.6/fs/ext4/namei.c
===================================================================
--- linux-2.6.orig/fs/ext4/namei.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/ext4/namei.c	2010-10-21 23:50:27.000000000 +1100
@@ -2312,7 +2312,7 @@ static int ext4_link(struct dentry *old_
 
 	inode->i_ctime = ext4_current_time(inode);
 	ext4_inc_count(handle, inode);
-	__inode_get(inode);
+	inode_get(inode);
 
 	err = ext4_add_entry(handle, dentry, inode);
 	if (!err) {
Index: linux-2.6/fs/gfs2/ops_inode.c
===================================================================
--- linux-2.6.orig/fs/gfs2/ops_inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/gfs2/ops_inode.c	2010-10-21 23:50:27.000000000 +1100
@@ -253,7 +253,7 @@ static int gfs2_link(struct dentry *old_
 	gfs2_holder_uninit(ghs);
 	gfs2_holder_uninit(ghs + 1);
 	if (!error) {
-		__inode_get(inode);
+		inode_get(inode);
 		d_instantiate(dentry, inode);
 		mark_inode_dirty(inode);
 	}
Index: linux-2.6/fs/hfsplus/dir.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/dir.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/hfsplus/dir.c	2010-10-21 23:50:27.000000000 +1100
@@ -301,7 +301,7 @@ static int hfsplus_link(struct dentry *s
 
 	inc_nlink(inode);
 	hfsplus_instantiate(dst_dentry, inode, cnid);
-	__inode_get(inode);
+	inode_get(inode);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 	HFSPLUS_SB(sb).file_count++;
Index: linux-2.6/fs/jffs2/dir.c
===================================================================
--- linux-2.6.orig/fs/jffs2/dir.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/jffs2/dir.c	2010-10-21 23:50:27.000000000 +1100
@@ -289,7 +289,7 @@ static int jffs2_link (struct dentry *ol
 		mutex_unlock(&f->sem);
 		d_instantiate(dentry, old_dentry->d_inode);
 		dir_i->i_mtime = dir_i->i_ctime = ITIME(now);
-		__inode_get(old_dentry->d_inode);
+		inode_get(old_dentry->d_inode);
 	}
 	return ret;
 }
@@ -864,7 +864,7 @@ static int jffs2_rename (struct inode *o
 		printk(KERN_NOTICE "jffs2_rename(): Link succeeded, unlink failed (err %d). You now have a hard link\n", ret);
 		/* Might as well let the VFS know */
 		d_instantiate(new_dentry, old_dentry->d_inode);
-		__inode_get(old_dentry->d_inode);
+		inode_get(old_dentry->d_inode);
 		new_dir_i->i_mtime = new_dir_i->i_ctime = ITIME(now);
 		return ret;
 	}
Index: linux-2.6/fs/jfs/jfs_txnmgr.c
===================================================================
--- linux-2.6.orig/fs/jfs/jfs_txnmgr.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/jfs/jfs_txnmgr.c	2010-10-21 23:50:27.000000000 +1100
@@ -1279,7 +1279,7 @@ int txCommit(tid_t tid,		/* transaction
 	 * lazy commit thread finishes processing
 	 */
 	if (tblk->xflag & COMMIT_DELETE) {
-		__inode_get(tblk->u.ip);
+		inode_get(tblk->u.ip);
 		/*
 		 * Avoid a rare deadlock
 		 *
Index: linux-2.6/fs/jfs/namei.c
===================================================================
--- linux-2.6.orig/fs/jfs/namei.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/jfs/namei.c	2010-10-21 23:50:27.000000000 +1100
@@ -839,7 +839,7 @@ static int jfs_link(struct dentry *old_d
 	ip->i_ctime = CURRENT_TIME;
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	mark_inode_dirty(dir);
-	__inode_get(ip);
+	inode_get(ip);
 
 	iplist[0] = ip;
 	iplist[1] = dir;
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/libfs.c	2010-10-21 23:50:27.000000000 +1100
@@ -255,7 +255,7 @@ int simple_link(struct dentry *old_dentr
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inc_nlink(inode);
-	__inode_get(inode);
+	inode_get(inode);
 	dget(dentry);
 	d_instantiate(dentry, inode);
 	return 0;
Index: linux-2.6/fs/logfs/dir.c
===================================================================
--- linux-2.6.orig/fs/logfs/dir.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/logfs/dir.c	2010-10-21 23:50:27.000000000 +1100
@@ -569,7 +569,7 @@ static int logfs_link(struct dentry *old
 		return -EMLINK;
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-	__inode_get(inode);
+	inode_get(inode);
 	inode->i_nlink++;
 	mark_inode_dirty_sync(inode);
 
Index: linux-2.6/fs/minix/namei.c
===================================================================
--- linux-2.6.orig/fs/minix/namei.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/minix/namei.c	2010-10-21 23:50:27.000000000 +1100
@@ -101,7 +101,7 @@ static int minix_link(struct dentry * ol
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	__inode_get(inode);
+	inode_get(inode);
 	return add_nondir(dentry, inode);
 }
 
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/namei.c	2010-10-21 23:50:27.000000000 +1100
@@ -2291,7 +2291,7 @@ static long do_unlinkat(int dfd, const c
 			goto slashes;
 		inode = dentry->d_inode;
 		if (inode)
-			__inode_get(inode);
+			inode_get(inode);
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/nfs/dir.c	2010-10-21 23:50:27.000000000 +1100
@@ -1580,7 +1580,7 @@ nfs_link(struct dentry *old_dentry, stru
 	d_drop(dentry);
 	error = NFS_PROTO(dir)->link(inode, dir, &dentry->d_name);
 	if (error == 0) {
-		__inode_get(inode);
+		inode_get(inode);
 		d_add(dentry, inode);
 	}
 	return error;
Index: linux-2.6/fs/nfs/getroot.c
===================================================================
--- linux-2.6.orig/fs/nfs/getroot.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/nfs/getroot.c	2010-10-21 23:50:27.000000000 +1100
@@ -55,7 +55,7 @@ static int nfs_superblock_set_dummy_root
 			return -ENOMEM;
 		}
 		/* We know the inode is not being freed */
-		__inode_get(inode);
+		inode_get(inode);
 		/*
 		 * Ensure that this dentry is invisible to d_find_alias().
 		 * Otherwise, it may be spliced into the tree by
Index: linux-2.6/fs/nilfs2/namei.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/namei.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/nilfs2/namei.c	2010-10-21 23:50:27.000000000 +1100
@@ -219,7 +219,7 @@ static int nilfs_link(struct dentry *old
 
 	inode->i_ctime = CURRENT_TIME;
 	inode_inc_link_count(inode);
-	__inode_get(inode);
+	inode_get(inode);
 
 	err = nilfs_add_nondir(dentry, inode);
 	if (!err)
Index: linux-2.6/fs/ntfs/super.c
===================================================================
--- linux-2.6.orig/fs/ntfs/super.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/ntfs/super.c	2010-10-21 23:50:27.000000000 +1100
@@ -2930,7 +2930,7 @@ static int ntfs_fill_super(struct super_
 	}
 	if ((sb->s_root = d_alloc_root(vol->root_ino))) {
 		/* We increment i_count simulating an ntfs_iget(). */
-		__inode_get(vol->root_ino);
+		inode_get(vol->root_ino);
 		ntfs_debug("Exiting, status successful.");
 		/* Release the default upcase if it has no users. */
 		mutex_lock(&ntfs_lock);
Index: linux-2.6/fs/ocfs2/namei.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/namei.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/ocfs2/namei.c	2010-10-21 23:50:27.000000000 +1100
@@ -741,7 +741,7 @@ static int ocfs2_link(struct dentry *old
 		goto out_commit;
 	}
 
-	__inode_get(inode);
+	inode_get(inode);
 	dentry->d_op = &ocfs2_dentry_ops;
 	d_instantiate(dentry, inode);
 
Index: linux-2.6/fs/reiserfs/namei.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/namei.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/reiserfs/namei.c	2010-10-21 23:50:27.000000000 +1100
@@ -1156,7 +1156,7 @@ static int reiserfs_link(struct dentry *
 	inode->i_ctime = CURRENT_TIME_SEC;
 	reiserfs_update_sd(&th, inode);
 
-	__inode_get(inode);
+	inode_get(inode);
 	d_instantiate(dentry, inode);
 	retval = journal_end(&th, dir->i_sb, jbegin_count);
 	reiserfs_write_unlock(dir->i_sb);
Index: linux-2.6/fs/sysv/namei.c
===================================================================
--- linux-2.6.orig/fs/sysv/namei.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/sysv/namei.c	2010-10-21 23:50:27.000000000 +1100
@@ -126,7 +126,7 @@ static int sysv_link(struct dentry * old
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	__inode_get(inode);
+	inode_get(inode);
 
 	return add_nondir(dentry, inode);
 }
Index: linux-2.6/fs/ubifs/dir.c
===================================================================
--- linux-2.6.orig/fs/ubifs/dir.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/ubifs/dir.c	2010-10-21 23:50:27.000000000 +1100
@@ -550,7 +550,7 @@ static int ubifs_link(struct dentry *old
 
 	lock_2_inodes(dir, inode);
 	inc_nlink(inode);
-	__inode_get(inode);
+	inode_get(inode);
 	inode->i_ctime = ubifs_current_time(inode);
 	dir->i_size += sz_change;
 	dir_ui->ui_size = dir->i_size;
Index: linux-2.6/fs/udf/namei.c
===================================================================
--- linux-2.6.orig/fs/udf/namei.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/udf/namei.c	2010-10-21 23:50:27.000000000 +1100
@@ -1101,7 +1101,7 @@ static int udf_link(struct dentry *old_d
 	inc_nlink(inode);
 	inode->i_ctime = current_fs_time(inode->i_sb);
 	mark_inode_dirty(inode);
-	__inode_get(inode);
+	inode_get(inode);
 	d_instantiate(dentry, inode);
 	unlock_kernel();
 
Index: linux-2.6/fs/ufs/namei.c
===================================================================
--- linux-2.6.orig/fs/ufs/namei.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/ufs/namei.c	2010-10-21 23:50:27.000000000 +1100
@@ -180,7 +180,7 @@ static int ufs_link (struct dentry * old
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
-	__inode_get(inode);
+	inode_get(inode);
 
 	error = ufs_add_nondir(dentry, inode);
 	unlock_kernel();
Index: linux-2.6/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_iops.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_iops.c	2010-10-21 23:50:27.000000000 +1100
@@ -352,7 +352,7 @@ xfs_vn_link(
 	if (unlikely(error))
 		return -error;
 
-	__inode_get(inode);
+	inode_get(inode);
 	d_instantiate(dentry, inode);
 	return 0;
 }
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/xfs/xfs_inode.h	2010-10-21 23:50:27.000000000 +1100
@@ -482,7 +482,7 @@ void		xfs_mark_inode_dirty_sync(xfs_inod
 #define IHOLD(ip) \
 do { \
 	ASSERT(VFS_I(ip)->i_count > 0) ; \
-	__inode_get(VFS_I(ip)); \
+	inode_get(VFS_I(ip)); \
 	trace_xfs_ihold(ip, _THIS_IP_); \
 } while (0)
 
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/ipc/mqueue.c	2010-10-21 23:50:27.000000000 +1100
@@ -769,7 +769,7 @@ SYSCALL_DEFINE1(mq_unlink, const char __
 
 	inode = dentry->d_inode;
 	if (inode)
-		__inode_get(inode);
+		inode_get(inode);
 	err = mnt_want_write(ipc_ns->mq_mnt);
 	if (err)
 		goto out_err;
Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/kernel/futex.c	2010-10-21 23:50:27.000000000 +1100
@@ -168,7 +168,7 @@ static void get_futex_key_refs(union fut
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		__inode_get(key->shared.inode);
+		inode_get(key->shared.inode);
 		break;
 	case FUT_OFF_MMSHARED:
 		atomic_inc(&key->private.mm->mm_count);
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/mm/shmem.c	2010-10-21 23:50:27.000000000 +1100
@@ -1903,7 +1903,7 @@ static int shmem_link(struct dentry *old
 	dir->i_size += BOGO_DIRENT_SIZE;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inc_nlink(inode);
-	__inode_get(inode);
+	inode_get(inode);
 	dget(dentry);		/* Extra pinning count for the created dentry */
 	d_instantiate(dentry, inode);
 out:
Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/net/socket.c	2010-10-21 23:50:27.000000000 +1100
@@ -377,7 +377,7 @@ static int sock_alloc_file(struct socket
 		  &socket_file_ops);
 	if (unlikely(!file)) {
 		/* drop dentry, keep inode */
-		__inode_get(path.dentry->d_inode);
+		inode_get(path.dentry->d_inode);
 		path_put(&path);
 		put_unused_fd(fd);
 		return -ENFILE;
Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/internal.h	2010-10-21 23:50:39.000000000 +1100
@@ -45,6 +45,8 @@ static inline int __sync_blockdev(struct
 }
 #endif
 
+extern atomic_t nr_unused;
+
 /*
  * char_dev.c
  */
@@ -74,8 +76,6 @@ extern void __init mnt_init(void);
 
 DECLARE_BRLOCK(vfsmount_lock);
 
-extern void inode_get_ilock_wblock(struct inode *inode);
-
 /*
  * fs_struct.c
  */
Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/drop_caches.c	2010-10-21 23:50:27.000000000 +1100
@@ -32,7 +32,7 @@ static void drop_pagecache_sb(struct sup
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		inode_get_ilock(inode);
+		inode->i_count++;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/notify/inode_mark.c	2010-10-21 23:50:27.000000000 +1100
@@ -289,7 +289,7 @@ void fsnotify_unmount_inodes(struct supe
 
 		/* In case fsnotify_inode_delete() drops a reference. */
 		if (inode != need_iput_tmp)
-			inode_get_ilock(inode);
+			inode->i_count++;
 		else
 			need_iput_tmp = NULL;
 		spin_unlock(&inode->i_lock);
@@ -298,7 +298,7 @@ void fsnotify_unmount_inodes(struct supe
 		if ((&next_i->i_sb_list != list)) {
 			if (next_i->i_count &&
 			    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
-				inode_get_ilock(next_i);
+				next_i->i_count++;
 				need_iput = next_i;
 			}
 		}
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/quota/dquot.c	2010-10-21 23:50:27.000000000 +1100
@@ -922,7 +922,7 @@ static void add_dquot_ref(struct super_b
 			continue;
 		}
 
-		inode_get_ilock(inode);
+		inode->i_count++;
 		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
 


