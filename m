Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab0JUNWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:22:54 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:50996 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757989Ab0JUNWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+FSgSKTQ
Message-Id: <20101021131016.640688024@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:36 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 07/14] fs: icache lock lru/writeback lists
References: <20101021130829.442910807@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, wb_inode_list_lock, to protect i_list and various lists
which the inode can be put onto.

[note: inode_lock should be able to be lifted a bit further off most
io list walks, but perhaps not lru walks yet]

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/fs-writeback.c         |   54 ++++++++++++++++++++++++++++++++++++---
 fs/inode.c                |   63 ++++++++++++++++++++++++++++++++++++++++++----
 fs/internal.h             |    1 
 include/linux/writeback.h |    1 
 mm/backing-dev.c          |    4 ++
 5 files changed, 114 insertions(+), 9 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-21 23:50:44.000000000 +1100
@@ -169,6 +169,7 @@ static void redirty_tail(struct inode *i
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&wb_inode_list_lock);
 	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
@@ -186,6 +187,7 @@ static void requeue_io(struct inode *ino
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&wb_inode_list_lock);
 	list_move(&inode->i_list, &wb->b_more_io);
 }
 
@@ -226,6 +228,7 @@ static void move_expired_inodes(struct l
 	struct inode *inode;
 	int do_sb_sort = 0;
 
+	assert_spin_locked(&wb_inode_list_lock);
 	while (!list_empty(delaying_queue)) {
 		inode = list_entry(delaying_queue->prev, struct inode, i_list);
 		if (older_than_this &&
@@ -289,11 +292,13 @@ static void inode_wait_for_writeback(str
 
 	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
 	while (inode->i_state & I_SYNC) {
+		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
 		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
+		spin_lock(&wb_inode_list_lock);
 	}
 }
 
@@ -347,6 +352,7 @@ writeback_single_inode(struct inode *ino
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
@@ -383,6 +389,7 @@ writeback_single_inode(struct inode *ino
 
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&wb_inode_list_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
@@ -469,11 +476,19 @@ static bool pin_sb_for_writeback(struct
 static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		struct writeback_control *wbc, bool only_this_sb)
 {
+lock_again:
 	while (!list_empty(&wb->b_io)) {
 		long pages_skipped;
 		struct inode *inode = list_entry(wb->b_io.prev,
 						 struct inode, i_list);
 
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&wb_inode_list_lock);
+			cpu_relax();
+			spin_lock(&wb_inode_list_lock);
+			goto lock_again;
+		}
+
 		if (inode->i_sb != sb) {
 			if (only_this_sb) {
 				/*
@@ -482,9 +497,12 @@ static int writeback_sb_inodes(struct su
 				 * to it back onto the dirty list.
 				 */
 				redirty_tail(inode);
+				spin_unlock(&inode->i_lock);
 				continue;
 			}
 
+			spin_unlock(&inode->i_lock);
+
 			/*
 			 * The inode belongs to a different superblock.
 			 * Bounce back to the caller to unpin this and
@@ -493,10 +511,9 @@ static int writeback_sb_inodes(struct su
 			return 0;
 		}
 
-		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
-			spin_unlock(&inode->i_lock);
 			requeue_io(inode);
+			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		/*
@@ -509,7 +526,7 @@ static int writeback_sb_inodes(struct su
 		}
 
 		BUG_ON(inode->i_state & I_FREEING);
-		inode_get_ilock(inode);
+		inode_get_ilock_wblock(inode);
 		pages_skipped = wbc->pages_skipped;
 		writeback_single_inode(inode, wbc);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -519,11 +536,13 @@ static int writeback_sb_inodes(struct su
 			 */
 			redirty_tail(inode);
 		}
+		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		iput(inode);
 		cond_resched();
 		spin_lock(&inode_lock);
+		spin_lock(&wb_inode_list_lock);
 		if (wbc->nr_to_write <= 0) {
 			wbc->more_io = 1;
 			return 1;
@@ -543,6 +562,9 @@ void writeback_inodes_wb(struct bdi_writ
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_lock);
+lock_again:
+	spin_lock(&wb_inode_list_lock);
+
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 
@@ -552,7 +574,13 @@ void writeback_inodes_wb(struct bdi_writ
 		struct super_block *sb = inode->i_sb;
 
 		if (!pin_sb_for_writeback(sb)) {
+			if (!spin_trylock(&inode->i_lock)) {
+				spin_unlock(&wb_inode_list_lock);
+				cpu_relax();
+				goto lock_again;
+			}
 			requeue_io(inode);
+			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		ret = writeback_sb_inodes(sb, wb, wbc, false);
@@ -561,6 +589,7 @@ void writeback_inodes_wb(struct bdi_writ
 		if (ret)
 			break;
 	}
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
 }
@@ -571,9 +600,11 @@ static void __writeback_inodes_sb(struct
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_lock);
+	spin_lock(&wb_inode_list_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 	writeback_sb_inodes(sb, wb, wbc, true);
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode_lock);
 }
 
@@ -685,12 +716,21 @@ static long wb_writeback(struct bdi_writ
 		 * we'll just busyloop.
 		 */
 		spin_lock(&inode_lock);
+lock_again:
+		spin_lock(&wb_inode_list_lock);
 		if (!list_empty(&wb->b_more_io))  {
 			inode = list_entry(wb->b_more_io.prev,
 						struct inode, i_list);
+			if (!spin_trylock(&inode->i_lock)) {
+				spin_unlock(&wb_inode_list_lock);
+				cpu_relax();
+				goto lock_again;
+			}
 			trace_wbc_writeback_wait(&wbc, wb->bdi);
 			inode_wait_for_writeback(inode);
+			spin_unlock(&inode->i_lock);
 		}
+		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode_lock);
 	}
 
@@ -1002,7 +1042,9 @@ void __mark_inode_dirty(struct inode *in
 			}
 
 			inode->dirtied_when = jiffies;
+			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, &bdi->wb.b_dirty);
+			spin_unlock(&wb_inode_list_lock);
 		}
 	}
 out:
@@ -1069,7 +1111,7 @@ static void wait_sb_inodes(struct super_
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		inode_get_ilock(inode);
+		inode_get_ilock_wblock(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
@@ -1198,7 +1240,9 @@ int write_inode_now(struct inode *inode,
 	might_sleep();
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&wb_inode_list_lock);
 	ret = writeback_single_inode(inode, &wbc);
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	if (sync)
@@ -1224,7 +1268,9 @@ int sync_inode(struct inode *inode, stru
 
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&wb_inode_list_lock);
 	ret = writeback_single_inode(inode, wbc);
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	return ret;
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-21 23:50:44.000000000 +1100
@@ -41,12 +41,16 @@
  *   s_inodes, i_sb_list
  * inode_hash_lock protects:
  *   inode hash table, i_hash
+ * wb_inode_list_lock protects:
+ *   inode_in_use, inode_unused, b_io, b_more_io, b_dirty, i_list
  *
  * Ordering:
  * inode_lock
  *   i_lock
  *     sb_inode_list_lock
+ *       wb_inode_list_lock
  *     inode_hash_lock
+ *       wb_inode_list_lock
  */
 /*
  * This is needed for the following functions:
@@ -107,6 +111,7 @@ static struct hlist_head *inode_hashtabl
  */
 DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
+DEFINE_SPINLOCK(wb_inode_list_lock);
 static DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
@@ -319,6 +324,26 @@ void __inode_get(struct inode *inode)
 EXPORT_SYMBOL(__inode_get);
 
 /*
+ * Don't fret, this is going away when inode_get callers and implementations
+ * get much simpler with lazy inode LRU.
+ */
+void inode_get_ilock_wblock(struct inode *inode)
+{
+ 	assert_spin_locked(&inode_lock);
+ 	assert_spin_locked(&inode->i_lock);
+	assert_spin_locked(&wb_inode_list_lock);
+	BUG_ON(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE));
+	inode->i_count++;
+	if (inode->i_count != 1)
+		return;
+
+	if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
+		list_move(&inode->i_list, &inode_in_use);
+	}
+	inodes_stat.nr_unused--;
+}
+
+/*
  * inode_lock must be held
  */
 void inode_get_ilock(struct inode *inode)
@@ -330,8 +355,11 @@ void inode_get_ilock(struct inode *inode
 	if (inode->i_count != 1)
 		return;
 
-	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
+	if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
+		spin_lock(&wb_inode_list_lock);
 		list_move(&inode->i_list, &inode_in_use);
+		spin_unlock(&wb_inode_list_lock);
+	}
 	inodes_stat.nr_unused--;
 }
 EXPORT_SYMBOL(inode_get_ilock);
@@ -387,6 +415,7 @@ static void dispose_list(struct list_hea
 	while (!list_empty(head)) {
 		struct inode *inode;
 
+		/* No locking here, it's a private list now */
 		inode = list_first_entry(head, struct inode, i_list);
 		list_del(&inode->i_list);
 
@@ -442,7 +471,9 @@ static int invalidate_list(struct super_
 		}
 		invalidate_inode_buffers(inode);
 		if (!inode->i_count) {
+			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, dispose);
+			spin_unlock(&wb_inode_list_lock);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			count++;
@@ -519,6 +550,8 @@ static void prune_icache(int nr_to_scan)
 
 	down_read(&iprune_sem);
 	spin_lock(&inode_lock);
+lock_again:
+	spin_lock(&wb_inode_list_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
 
@@ -527,14 +560,20 @@ static void prune_icache(int nr_to_scan)
 
 		inode = list_entry(inode_unused.prev, struct inode, i_list);
 
-		spin_lock(&inode->i_lock);
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&wb_inode_list_lock);
+			cpu_relax();
+			goto lock_again;
+		}
+
 		if (inode->i_state || inode->i_count) {
 			list_move(&inode->i_list, &inode_unused);
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
-			inode_get_ilock(inode);
+			inode_get_ilock_wblock(inode);
+			spin_unlock(&wb_inode_list_lock);
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
@@ -542,7 +581,13 @@ static void prune_icache(int nr_to_scan)
 								0, -1);
 			iput(inode);
 			spin_lock(&inode_lock);
-			spin_lock(&inode->i_lock);
+lock_again_2:
+			spin_lock(&wb_inode_list_lock);
+			if (!spin_trylock(&inode->i_lock)) {
+				spin_unlock(&wb_inode_list_lock);
+				cpu_relax();
+				goto lock_again_2;
+			}
 
 			if (inode != list_entry(inode_unused.next,
 						struct inode, i_list)) {
@@ -565,6 +610,7 @@ static void prune_icache(int nr_to_scan)
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
 		__count_vm_events(PGINODESTEAL, reap);
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode_lock);
 
 	dispose_list(&freeable);
@@ -682,7 +728,9 @@ __inode_add_to_lists(struct super_block
 			struct inode *inode)
 {
 	inodes_stat.nr_inodes++;
+	spin_lock(&wb_inode_list_lock);
 	list_add(&inode->i_list, &inode_in_use);
+	spin_unlock(&wb_inode_list_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
@@ -1376,8 +1424,11 @@ static void iput_final(struct inode *ino
 		drop = generic_drop_inode(inode);
 
 	if (!drop) {
-		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
+		if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
+			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, &inode_unused);
+			spin_unlock(&wb_inode_list_lock);
+		}
 		inodes_stat.nr_unused++;
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
@@ -1398,7 +1449,9 @@ static void iput_final(struct inode *ino
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
 	}
+	spin_lock(&wb_inode_list_lock);
 	list_del_init(&inode->i_list);
+	spin_unlock(&wb_inode_list_lock);
 	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/include/linux/writeback.h	2010-10-21 23:50:42.000000000 +1100
@@ -11,6 +11,7 @@ struct backing_dev_info;
 
 extern spinlock_t inode_lock;
 extern spinlock_t sb_inode_list_lock;
+extern spinlock_t wb_inode_list_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c	2010-10-21 23:49:53.000000000 +1100
+++ linux-2.6/mm/backing-dev.c	2010-10-21 23:50:43.000000000 +1100
@@ -74,12 +74,14 @@ static int bdi_debug_stats_show(struct s
 
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
 	spin_lock(&inode_lock);
+	spin_lock(&wb_inode_list_lock);
 	list_for_each_entry(inode, &wb->b_dirty, i_list)
 		nr_dirty++;
 	list_for_each_entry(inode, &wb->b_io, i_list)
 		nr_io++;
 	list_for_each_entry(inode, &wb->b_more_io, i_list)
 		nr_more_io++;
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode_lock);
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
@@ -683,9 +685,11 @@ void bdi_destroy(struct backing_dev_info
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
 
 		spin_lock(&inode_lock);
+		spin_lock(&wb_inode_list_lock);
 		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
 		list_splice(&bdi->wb.b_io, &dst->b_io);
 		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
+		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode_lock);
 	}
 
Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h	2010-10-21 23:49:57.000000000 +1100
+++ linux-2.6/fs/internal.h	2010-10-21 23:50:41.000000000 +1100
@@ -74,6 +74,7 @@ extern void __init mnt_init(void);
 
 DECLARE_BRLOCK(vfsmount_lock);
 
+extern void inode_get_ilock_wblock(struct inode *inode);
 
 /*
  * fs_struct.c


