Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab0JUAuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:50:51 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:57598 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756403Ab0JUAup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:50:45 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/21] fs: split locking of inode writeback and LRU lists
Date: Thu, 21 Oct 2010 11:49:40 +1100
Message-Id: <1287622186-1935-16-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287622186-1935-1-git-send-email-david@fromorbit.com>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Given that the inode LRU and IO lists are split apart, they do not
need to be protected by the same lock. So in preparation for removal
of the inode_lock, add new locks for them. The writeback lists are
only ever accessed in the context of a bdi, so add a per-BDI lock to
protect manipulations of these lists.

For the inode LRU, introduce a simple global lock to protect it.
While this could be made per-sb, it is unclear yet as to what is the
next step for optimising/parallelising reclaim of inodes. Rather
than optimise now, leave it as a global list and lock until further
analysis can be done.

Because there will now be a situation where the inode is on
different lists protected by different locks during the freeing of
the inode (i.e. not an atomic state transition), we need to ensure
that we set the I_FREEING state flag before we start removing inodes
from the IO and LRU lists. This ensures that if we race with other
threads during freeing, they will notice the I_FREEING flag is set
and be able to take appropriate action to avoid problems.

Based on a patch originally from Nick Piggin.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c              |    5 +++
 fs/fs-writeback.c           |   51 +++++++++++++++++++++++++++++++++---
 fs/inode.c                  |   61 ++++++++++++++++++++++++++++++++++++++-----
 fs/internal.h               |    5 +++
 include/linux/backing-dev.h |    3 ++
 mm/backing-dev.c            |   18 ++++++++++++
 6 files changed, 132 insertions(+), 11 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 11ad53d..7909775 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -56,10 +56,15 @@ EXPORT_SYMBOL(I_BDEV);
 static void bdev_inode_switch_bdi(struct inode *inode,
 			struct backing_dev_info *dst)
 {
+	struct backing_dev_info *old = inode->i_data.backing_dev_info;
+
 	spin_lock(&inode_lock);
+	bdi_lock_two(old, dst);
 	inode->i_data.backing_dev_info = dst;
 	if (!list_empty(&inode->i_wb_list))
 		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
+	spin_unlock(&old->wb.b_lock);
+	spin_unlock(&dst->wb.b_lock);
 	spin_unlock(&inode_lock);
 }
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 676e048..36106e6 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -157,6 +157,18 @@ void bdi_start_background_writeback(struct backing_dev_info *bdi)
 }
 
 /*
+ * Remove the inode from the writeback list it is on.
+ */
+void inode_wb_list_del(struct inode *inode)
+{
+	struct backing_dev_info *bdi = inode_to_bdi(inode);
+
+	spin_lock(&bdi->wb.b_lock);
+	list_del_init(&inode->i_wb_list);
+	spin_unlock(&bdi->wb.b_lock);
+}
+
+/*
  * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
  * furthest end of its superblock's dirty-inode list.
  *
@@ -169,6 +181,7 @@ static void redirty_tail(struct inode *inode)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&wb->b_lock);
 	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
@@ -186,6 +199,7 @@ static void requeue_io(struct inode *inode)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&wb->b_lock);
 	list_move(&inode->i_wb_list, &wb->b_more_io);
 }
 
@@ -269,6 +283,7 @@ static void move_expired_inodes(struct list_head *delaying_queue,
  */
 static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
 {
+	assert_spin_locked(&wb->b_lock);
 	list_splice_init(&wb->b_more_io, &wb->b_io);
 	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
 }
@@ -311,6 +326,7 @@ static void inode_wait_for_writeback(struct inode *inode)
 static int
 writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 {
+	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct address_space *mapping = inode->i_mapping;
 	unsigned dirty;
 	int ret;
@@ -330,7 +346,9 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 		 * completed a full scan of b_io.
 		 */
 		if (wbc->sync_mode != WB_SYNC_ALL) {
+			spin_lock(&bdi->wb.b_lock);
 			requeue_io(inode);
+			spin_unlock(&bdi->wb.b_lock);
 			return 0;
 		}
 
@@ -385,6 +403,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			 * sometimes bales out without doing anything.
 			 */
 			inode->i_state |= I_DIRTY_PAGES;
+			spin_lock(&bdi->wb.b_lock);
 			if (wbc->nr_to_write <= 0) {
 				/*
 				 * slice used up: queue for next turn
@@ -400,6 +419,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 				 */
 				redirty_tail(inode);
 			}
+			spin_unlock(&bdi->wb.b_lock);
 		} else if (inode->i_state & I_DIRTY) {
 			/*
 			 * Filesystems can dirty the inode during writeback
@@ -407,7 +427,9 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			 * submission or metadata updates after data IO
 			 * completion.
 			 */
+			spin_lock(&bdi->wb.b_lock);
 			redirty_tail(inode);
+			spin_unlock(&bdi->wb.b_lock);
 		} else {
 			/*
 			 * The inode is clean. If it is unused, then make sure
@@ -415,7 +437,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			 * does not move dirty inodes to the LRU and dirty
 			 * inodes are removed from the LRU during scanning.
 			 */
-			list_del_init(&inode->i_wb_list);
+			inode_wb_list_del(inode);
 			if (!inode->i_ref)
 				inode_lru_list_add(inode);
 		}
@@ -463,6 +485,7 @@ static bool pin_sb_for_writeback(struct super_block *sb)
 static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		struct writeback_control *wbc, bool only_this_sb)
 {
+	assert_spin_locked(&wb->b_lock);
 	while (!list_empty(&wb->b_io)) {
 		long pages_skipped;
 		struct inode *inode = list_entry(wb->b_io.prev,
@@ -478,7 +501,6 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 				redirty_tail(inode);
 				continue;
 			}
-
 			/*
 			 * The inode belongs to a different superblock.
 			 * Bounce back to the caller to unpin this and
@@ -487,7 +509,15 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 			return 0;
 		}
 
-		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
+		/*
+		 * We can see I_FREEING here when the inode is in the process of
+		 * being reclaimed. In that case the freer is waiting on the
+		 * wb->b_lock that we currently hold to remove the inode from
+		 * the writeback list. So we don't spin on it here, requeue it
+		 * and move on to the next inode, which will allow the other
+		 * thread to free the inode when we drop the lock.
+		 */
+		if (inode->i_state & (I_NEW | I_WILL_FREE | I_FREEING)) {
 			requeue_io(inode);
 			continue;
 		}
@@ -498,10 +528,11 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		if (inode_dirtied_after(inode, wbc->wb_start))
 			return 1;
 
-		BUG_ON(inode->i_state & I_FREEING);
 		spin_lock(&inode->i_lock);
 		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
+		spin_unlock(&wb->b_lock);
+
 		pages_skipped = wbc->pages_skipped;
 		writeback_single_inode(inode, wbc);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -509,12 +540,15 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 			 * writeback is not making progress due to locked
 			 * buffers.  Skip this inode for now.
 			 */
+			spin_lock(&wb->b_lock);
 			redirty_tail(inode);
+			spin_unlock(&wb->b_lock);
 		}
 		spin_unlock(&inode_lock);
 		iput(inode);
 		cond_resched();
 		spin_lock(&inode_lock);
+		spin_lock(&wb->b_lock);
 		if (wbc->nr_to_write <= 0) {
 			wbc->more_io = 1;
 			return 1;
@@ -534,6 +568,8 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_lock);
+	spin_lock(&wb->b_lock);
+
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 
@@ -552,6 +588,7 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 		if (ret)
 			break;
 	}
+	spin_unlock(&wb->b_lock);
 	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
 }
@@ -562,9 +599,11 @@ static void __writeback_inodes_sb(struct super_block *sb,
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_lock);
+	spin_lock(&wb->b_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 	writeback_sb_inodes(sb, wb, wbc, true);
+	spin_unlock(&wb->b_lock);
 	spin_unlock(&inode_lock);
 }
 
@@ -677,8 +716,10 @@ static long wb_writeback(struct bdi_writeback *wb,
 		 */
 		spin_lock(&inode_lock);
 		if (!list_empty(&wb->b_more_io))  {
+			spin_lock(&wb->b_lock);
 			inode = list_entry(wb->b_more_io.prev,
 						struct inode, i_wb_list);
+			spin_unlock(&wb->b_lock);
 			trace_wbc_writeback_wait(&wbc, wb->bdi);
 			inode_wait_for_writeback(inode);
 		}
@@ -991,8 +1032,10 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 					wakeup_bdi = true;
 			}
 
+			spin_lock(&bdi->wb.b_lock);
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
+			spin_unlock(&bdi->wb.b_lock);
 		}
 	}
 out:
diff --git a/fs/inode.c b/fs/inode.c
index 734aadf..959c8b5 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -25,6 +25,8 @@
 #include <linux/async.h>
 #include <linux/posix_acl.h>
 
+#include "internal.h"
+
 /*
  * Locking rules.
  *
@@ -36,6 +38,10 @@
  *   inode hash table, i_hash
  * sb inode lock protects:
  *   s_inodes, i_sb_list
+ * bdi writeback lock protects:
+ *   b_io, b_more_io, b_dirty, i_wb_list
+ * inode_lru_lock protects:
+ *   inode_lru, i_lru
  *
  * Lock orders
  * inode_lock
@@ -44,6 +50,17 @@
  *
  * inode_lock
  *   sb inode lock
+ *     inode_lru_lock
+ *       wb->b_lock
+ *         inode->i_lock
+ *
+ * inode_lock
+ *   wb->b_lock
+ *     sb_lock (pin sb for writeback)
+ *     inode->i_lock
+ *
+ * inode_lock
+ *   inode_lru
  *     inode->i_lock
  */
 /*
@@ -94,6 +111,7 @@ static struct hlist_bl_head *inode_hashtable __read_mostly;
  * allowing for low-overhead inode sync() operations.
  */
 static LIST_HEAD(inode_lru);
+static DEFINE_SPINLOCK(inode_lru_lock);
 
 /*
  * A simple spinlock to protect the list manipulations.
@@ -354,20 +372,28 @@ void iref(struct inode *inode)
 }
 EXPORT_SYMBOL_GPL(iref);
 
+/*
+ * check against I_FREEING as inode writeback completion could race with
+ * setting the I_FREEING and removing the inode from the LRU.
+ */
 void inode_lru_list_add(struct inode *inode)
 {
-	if (list_empty(&inode->i_lru)) {
+	spin_lock(&inode_lru_lock);
+	if (list_empty(&inode->i_lru) && !(inode->i_state & I_FREEING)) {
 		list_add(&inode->i_lru, &inode_lru);
 		percpu_counter_inc(&nr_inodes_unused);
 	}
+	spin_unlock(&inode_lru_lock);
 }
 
 void inode_lru_list_del(struct inode *inode)
 {
+	spin_lock(&inode_lru_lock);
 	if (!list_empty(&inode->i_lru)) {
 		list_del_init(&inode->i_lru);
 		percpu_counter_dec(&nr_inodes_unused);
 	}
+	spin_unlock(&inode_lru_lock);
 }
 
 static void __inode_sb_list_add(struct inode *inode)
@@ -552,8 +578,18 @@ static int invalidate_list(struct super_block *sb, struct list_head *head,
 			spin_unlock(&inode->i_lock);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
+
+			/*
+			 * move the inode off the IO lists and LRU once
+			 * I_FREEING is set so that it won't get moved back on
+			 * there if it is dirty.
+			 */
+			inode_wb_list_del(inode);
+
+			spin_lock(&inode_lru_lock);
 			list_move(&inode->i_lru, dispose);
 			percpu_counter_dec(&nr_inodes_unused);
+			spin_unlock(&inode_lru_lock);
 			continue;
 		}
 		spin_unlock(&inode->i_lock);
@@ -614,6 +650,7 @@ static void prune_icache(int nr_to_scan)
 
 	down_read(&iprune_sem);
 	spin_lock(&inode_lock);
+	spin_lock(&inode_lru_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
 
@@ -644,6 +681,7 @@ static void prune_icache(int nr_to_scan)
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
 			inode->i_ref++;
 			spin_unlock(&inode->i_lock);
+			spin_unlock(&inode_lru_lock);
 			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
@@ -661,19 +699,28 @@ static void prune_icache(int nr_to_scan)
 			 * same. Either way, we won't spin on it in this loop.
 			 */
 			spin_lock(&inode_lock);
+			spin_lock(&inode_lru_lock);
 			continue;
 		}
 		spin_unlock(&inode->i_lock);
-		list_move(&inode->i_lru, &freeable);
-		list_del_init(&inode->i_wb_list);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
+
+		/*
+		 * move the inode off the io lists and lru once
+		 * i_freeing is set so that it won't get moved back on
+		 * there if it is dirty.
+		 */
+		inode_wb_list_del(inode);
+
+		list_move(&inode->i_lru, &freeable);
 		percpu_counter_dec(&nr_inodes_unused);
 	}
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
 		__count_vm_events(PGINODESTEAL, reap);
+	spin_unlock(&inode_lru_lock);
 	spin_unlock(&inode_lock);
 
 	dispose_list(&freeable);
@@ -1391,15 +1438,15 @@ static void iput_final(struct inode *inode)
 		inode->i_state &= ~I_WILL_FREE;
 		__remove_inode_hash(inode);
 	}
-	list_del_init(&inode->i_wb_list);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 
 	/*
-	 * After we delete the inode from the LRU here, we avoid moving dirty
-	 * inodes back onto the LRU now because I_FREEING is set and hence
-	 * writeback_single_inode() won't move the inode around.
+	 * After we delete the inode from the LRU and IO lists here, we avoid
+	 * moving dirty inodes back onto the LRU now because I_FREEING is set
+	 * and hence writeback_single_inode() won't move the inode around.
 	 */
+	inode_wb_list_del(inode);
 	inode_lru_list_del(inode);
 
 	__inode_sb_list_del(inode);
diff --git a/fs/internal.h b/fs/internal.h
index ece3565..f8825ae 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -107,3 +107,8 @@ extern void release_open_intent(struct nameidata *);
  */
 extern void inode_lru_list_add(struct inode *inode);
 extern void inode_lru_list_del(struct inode *inode);
+
+/*
+ * fs-writeback.c
+ */
+extern void inode_wb_list_del(struct inode *inode);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 35b0074..995a3ad 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -57,6 +57,7 @@ struct bdi_writeback {
 	struct list_head b_dirty;	/* dirty inodes */
 	struct list_head b_io;		/* parked for writeback */
 	struct list_head b_more_io;	/* parked for more writeback */
+	spinlock_t b_lock;		/* writeback lists lock */
 };
 
 struct backing_dev_info {
@@ -108,6 +109,8 @@ int bdi_writeback_thread(void *data);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 void bdi_arm_supers_timer(void);
 void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi);
+void bdi_lock_two(struct backing_dev_info *bdi1,
+				struct backing_dev_info *bdi2);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 15d5097..52442bd 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -74,12 +74,14 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
 	spin_lock(&inode_lock);
+	spin_lock(&wb->b_lock);
 	list_for_each_entry(inode, &wb->b_dirty, i_wb_list)
 		nr_dirty++;
 	list_for_each_entry(inode, &wb->b_io, i_wb_list)
 		nr_io++;
 	list_for_each_entry(inode, &wb->b_more_io, i_wb_list)
 		nr_more_io++;
+	spin_unlock(&wb->b_lock);
 	spin_unlock(&inode_lock);
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
@@ -634,6 +636,7 @@ static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
 	INIT_LIST_HEAD(&wb->b_dirty);
 	INIT_LIST_HEAD(&wb->b_io);
 	INIT_LIST_HEAD(&wb->b_more_io);
+	spin_lock_init(&wb->b_lock);
 	setup_timer(&wb->wakeup_timer, wakeup_timer_fn, (unsigned long)bdi);
 }
 
@@ -671,6 +674,18 @@ err:
 }
 EXPORT_SYMBOL(bdi_init);
 
+void bdi_lock_two(struct backing_dev_info *bdi1,
+				struct backing_dev_info *bdi2)
+{
+	if (bdi1 < bdi2) {
+		spin_lock(&bdi1->wb.b_lock);
+		spin_lock_nested(&bdi2->wb.b_lock, 1);
+	} else {
+		spin_lock(&bdi2->wb.b_lock);
+		spin_lock_nested(&bdi1->wb.b_lock, 1);
+	}
+}
+
 void bdi_destroy(struct backing_dev_info *bdi)
 {
 	int i;
@@ -683,9 +698,12 @@ void bdi_destroy(struct backing_dev_info *bdi)
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
 
 		spin_lock(&inode_lock);
+		bdi_lock_two(bdi, &default_backing_dev_info);
 		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
 		list_splice(&bdi->wb.b_io, &dst->b_io);
 		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
+		spin_unlock(&bdi->wb.b_lock);
+		spin_unlock(&dst->b_lock);
 		spin_unlock(&inode_lock);
 	}
 
-- 
1.7.1

