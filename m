Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722Ab0JSD6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:58:32 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28449 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933571Ab0JSD4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaCd4JSBIpK
Message-Id: <20101019034658.532298813@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:45 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 29/35] fs: icache per-bdi writeback list locking
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode-scale-wb-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scale inode writeback lists by breaking the global writeback list lock
into per-bdi locks.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/fs-writeback.c           |  110 ++++++++++++++++++++------------------------
 fs/inode.c                  |   17 ++++--
 fs/internal.h               |   12 ++++
 include/linux/backing-dev.h |    2 
 include/linux/writeback.h   |    2 
 mm/backing-dev.c            |   28 +++++++++--
 6 files changed, 100 insertions(+), 71 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:20.000000000 +1100
@@ -69,16 +69,6 @@
 	return test_bit(BDI_writeback_running, &bdi->state);
 }
 
-static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
-{
-	struct super_block *sb = inode->i_sb;
-
-	if (strcmp(sb->s_type->name, "bdev") == 0)
-		return inode->i_mapping->backing_dev_info;
-
-	return sb->s_bdi;
-}
-
 static void bdi_queue_work(struct backing_dev_info *bdi,
 		struct wb_writeback_work *work)
 {
@@ -165,11 +155,9 @@
  * the case then the inode must have been redirtied while it was being written
  * out and we don't reset its dirtied_when.
  */
-static void redirty_tail(struct inode *inode)
+static void redirty_tail(struct bdi_writeback *wb, struct inode *inode)
 {
-	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
-
-	assert_spin_locked(&wb_inode_list_lock);
+	assert_spin_locked(&wb->b_lock);
 	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
@@ -183,11 +171,9 @@
 /*
  * requeue inode for re-scanning after bdi->b_io list is exhausted.
  */
-static void requeue_io(struct inode *inode)
+static void requeue_io(struct bdi_writeback *wb, struct inode *inode)
 {
-	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
-
-	assert_spin_locked(&wb_inode_list_lock);
+	assert_spin_locked(&wb->b_lock);
 	list_move(&inode->i_io, &wb->b_more_io);
 }
 
@@ -228,7 +214,6 @@
 	struct inode *inode;
 	int do_sb_sort = 0;
 
-	assert_spin_locked(&wb_inode_list_lock);
 	while (!list_empty(delaying_queue)) {
 		inode = list_entry(delaying_queue->prev, struct inode, i_io);
 		if (older_than_this &&
@@ -285,18 +270,19 @@
 /*
  * Wait for writeback on an inode to complete.
  */
-static void inode_wait_for_writeback(struct inode *inode)
+static void inode_wait_for_writeback(struct bdi_writeback *wb,
+					struct inode *inode)
 {
 	DEFINE_WAIT_BIT(wq, &inode->i_state, __I_SYNC);
 	wait_queue_head_t *wqh;
 
 	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
 	while (inode->i_state & I_SYNC) {
-		spin_unlock(&wb_inode_list_lock);
+		spin_unlock(&wb->b_lock);
 		spin_unlock(&inode->i_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
 		spin_lock(&inode->i_lock);
-		spin_lock(&wb_inode_list_lock);
+		spin_lock(&wb->b_lock);
 	}
 }
 
@@ -315,7 +301,8 @@
  * with them locked.
  */
 static int
-writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
+writeback_single_inode(struct bdi_writeback *wb, struct inode *inode,
+			struct writeback_control *wbc)
 {
 	struct address_space *mapping = inode->i_mapping;
 	unsigned dirty;
@@ -336,14 +323,14 @@
 		 * completed a full scan of b_io.
 		 */
 		if (wbc->sync_mode != WB_SYNC_ALL) {
-			requeue_io(inode);
+			requeue_io(wb, inode);
 			return 0;
 		}
 
 		/*
 		 * It's a data-integrity sync.  We must wait.
 		 */
-		inode_wait_for_writeback(inode);
+		inode_wait_for_writeback(wb, inode);
 	}
 
 	BUG_ON(inode->i_state & I_SYNC);
@@ -351,7 +338,7 @@
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
-	spin_unlock(&wb_inode_list_lock);
+	spin_unlock(&wb->b_lock);
 	spin_unlock(&inode->i_lock);
 
 	ret = do_writepages(mapping, wbc);
@@ -386,7 +373,7 @@
 		spin_lock(&inode->i_lock);
 	}
 
-	spin_lock(&wb_inode_list_lock);
+	spin_lock(&wb->b_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
@@ -399,7 +386,7 @@
 				/*
 				 * slice used up: queue for next turn
 				 */
-				requeue_io(inode);
+				requeue_io(wb, inode);
 			} else {
 				/*
 				 * Writeback blocked by something other than
@@ -408,7 +395,7 @@
 				 * retrying writeback of the dirty page/inode
 				 * that cannot be performed immediately.
 				 */
-				redirty_tail(inode);
+				redirty_tail(wb, inode);
 			}
 		} else if (inode->i_state & I_DIRTY) {
 			/*
@@ -417,7 +404,7 @@
 			 * submission or metadata updates after data IO
 			 * completion.
 			 */
-			redirty_tail(inode);
+			redirty_tail(wb, inode);
 		} else {
 			/*
 			 * The inode is clean
@@ -477,8 +464,9 @@
 						 struct inode, i_io);
 
 		if (!spin_trylock(&inode->i_lock)) {
-			spin_unlock(&wb_inode_list_lock);
-			spin_lock(&wb_inode_list_lock);
+			spin_unlock(&wb->b_lock);
+			cpu_relax();
+			spin_lock(&wb->b_lock);
 			goto again;
 		}
 
@@ -489,7 +477,7 @@
 				 * superblock, move all inodes not belonging
 				 * to it back onto the dirty list.
 				 */
-				redirty_tail(inode);
+				redirty_tail(wb, inode);
 				spin_unlock(&inode->i_lock);
 				continue;
 			}
@@ -505,7 +493,7 @@
 		}
 
 		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
-			requeue_io(inode);
+			requeue_io(wb, inode);
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
@@ -521,19 +509,19 @@
 		BUG_ON(inode->i_state & I_FREEING);
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
-		writeback_single_inode(inode, wbc);
+		writeback_single_inode(wb, inode, wbc);
 		if (wbc->pages_skipped != pages_skipped) {
 			/*
 			 * writeback is not making progress due to locked
 			 * buffers.  Skip this inode for now.
 			 */
-			redirty_tail(inode);
+			redirty_tail(wb, inode);
 		}
-		spin_unlock(&wb_inode_list_lock);
+		spin_unlock(&wb->b_lock);
 		spin_unlock(&inode->i_lock);
 		iput(inode);
 		cond_resched();
-		spin_lock(&wb_inode_list_lock);
+		spin_lock(&wb->b_lock);
 		if (wbc->nr_to_write <= 0) {
 			wbc->more_io = 1;
 			return 1;
@@ -553,7 +541,7 @@
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
 again:
-	spin_lock(&wb_inode_list_lock);
+	spin_lock(&wb->b_lock);
 
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
@@ -565,10 +553,11 @@
 
 		if (!pin_sb_for_writeback(sb)) {
 			if (!spin_trylock(&inode->i_lock)) {
-				spin_unlock(&wb_inode_list_lock);
+				spin_unlock(&wb->b_lock);
+				cpu_relax();
 				goto again;
 			}
-			requeue_io(inode);
+			requeue_io(wb, inode);
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
@@ -578,7 +567,7 @@
 		if (ret)
 			break;
 	}
-	spin_unlock(&wb_inode_list_lock);
+	spin_unlock(&wb->b_lock);
 	/* Leave any unwritten inodes on b_io */
 }
 
@@ -587,11 +576,11 @@
 {
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	spin_lock(&wb_inode_list_lock);
+	spin_lock(&wb->b_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 	writeback_sb_inodes(sb, wb, wbc, true);
-	spin_unlock(&wb_inode_list_lock);
+	spin_unlock(&wb->b_lock);
 }
 
 /*
@@ -702,19 +691,19 @@
 		 * we'll just busyloop.
 		 */
 retry:
-		spin_lock(&wb_inode_list_lock);
+		spin_lock(&wb->b_lock);
 		if (!list_empty(&wb->b_more_io))  {
 			inode = list_entry(wb->b_more_io.prev,
 						struct inode, i_io);
 			if (!spin_trylock(&inode->i_lock)) {
-				spin_unlock(&wb_inode_list_lock);
+				spin_unlock(&wb->b_lock);
 				goto retry;
 			}
 			trace_wbc_writeback_wait(&wbc, wb->bdi);
-			inode_wait_for_writeback(inode);
+			inode_wait_for_writeback(wb, inode);
 			spin_unlock(&inode->i_lock);
 		}
-		spin_unlock(&wb_inode_list_lock);
+		spin_unlock(&wb->b_lock);
 	}
 
 	return wrote;
@@ -1013,7 +1002,9 @@
 		 * reposition it (that would break b_dirty time-ordering).
 		 */
 		if (!was_dirty) {
-			bdi = inode_to_bdi(inode);
+			struct bdi_writeback *wb;
+ 			bdi = inode_to_bdi(inode);
+			wb = inode_to_wb(inode);
 
 			if (bdi_cap_writeback_dirty(bdi)) {
 				WARN(!test_bit(BDI_registered, &bdi->state),
@@ -1030,9 +1021,10 @@
 			}
 
 			inode->dirtied_when = jiffies;
-			spin_lock(&wb_inode_list_lock);
-			list_move(&inode->i_io, &bdi->wb.b_dirty);
-			spin_unlock(&wb_inode_list_lock);
+			spin_lock(&wb->b_lock);
+			BUG_ON(!list_empty(&inode->i_io));
+			list_add(&inode->i_io, &wb->b_dirty);
+			spin_unlock(&wb->b_lock);
 		}
 	}
 out:
@@ -1209,6 +1201,7 @@
  */
 int write_inode_now(struct inode *inode, int sync)
 {
+	struct bdi_writeback *wb = inode_to_wb(inode);
 	int ret;
 	struct writeback_control wbc = {
 		.nr_to_write = LONG_MAX,
@@ -1222,9 +1215,9 @@
 
 	might_sleep();
 	spin_lock(&inode->i_lock);
-	spin_lock(&wb_inode_list_lock);
-	ret = writeback_single_inode(inode, &wbc);
-	spin_unlock(&wb_inode_list_lock);
+	spin_lock(&wb->b_lock);
+	ret = writeback_single_inode(wb, inode, &wbc);
+	spin_unlock(&wb->b_lock);
 	spin_unlock(&inode->i_lock);
 	if (sync)
 		inode_sync_wait(inode);
@@ -1245,12 +1238,13 @@
  */
 int sync_inode(struct inode *inode, struct writeback_control *wbc)
 {
+	struct bdi_writeback *wb = inode_to_wb(inode);
 	int ret;
 
 	spin_lock(&inode->i_lock);
-	spin_lock(&wb_inode_list_lock);
-	ret = writeback_single_inode(inode, wbc);
-	spin_unlock(&wb_inode_list_lock);
+	spin_lock(&wb->b_lock);
+	ret = writeback_single_inode(wb, inode, wbc);
+	spin_unlock(&wb->b_lock);
 	spin_unlock(&inode->i_lock);
 	return ret;
 }
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:19.000000000 +1100
@@ -26,6 +26,7 @@
 #include <linux/posix_acl.h>
 #include <linux/bit_spinlock.h>
 #include <linux/lglock.h>
+#include "internal.h"
 
 /*
  * Usage:
@@ -35,7 +36,7 @@
  *   inode hash table, i_hash
  * inode_lru_lock protects:
  *   inode_lru, i_lru
- * wb_inode_list_lock protects:
+ * wb->b_lock protects:
  *   b_io, b_more_io, b_dirty, i_io, i_lru
  * inode->i_lock protects:
  *   i_state
@@ -49,7 +50,7 @@
  * inode->i_lock
  *   inode_list_lglock
  *   inode_lru_lock
- *   wb_inode_list_lock
+ *   wb->b_lock
  *   inode_hash_bucket lock
  */
 /*
@@ -126,7 +127,6 @@
 DECLARE_LGLOCK(inode_list_lglock);
 DEFINE_LGLOCK(inode_list_lglock);
 
-DEFINE_SPINLOCK(wb_inode_list_lock);
 static DEFINE_SPINLOCK(inode_lru_lock);
 
 /*
@@ -473,9 +473,11 @@
 		}
 		invalidate_inode_buffers(inode);
 		if (!inode->i_count) {
-			spin_lock(&wb_inode_list_lock);
+			struct bdi_writeback *wb = inode_to_wb(inode);
+
+			spin_lock(&wb->b_lock);
 			list_del_init(&inode->i_io);
-			spin_unlock(&wb_inode_list_lock);
+			spin_unlock(&wb->b_lock);
 
 			__inode_lru_list_del(inode);
 
@@ -1556,9 +1558,10 @@
 	if (!list_empty(&inode->i_lru))
 		__inode_lru_list_del(inode);
 	if (!list_empty(&inode->i_io)) {
-		spin_lock(&wb_inode_list_lock);
+		struct bdi_writeback *wb = inode_to_wb(inode);
+		spin_lock(&wb->b_lock);
 		list_del_init(&inode->i_io);
-		spin_unlock(&wb_inode_list_lock);
+		spin_unlock(&wb->b_lock);
 	}
 	inode_sb_list_del(inode);
 	WARN_ON(inode->i_state & I_NEW);
Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h	2010-10-19 14:17:28.000000000 +1100
+++ linux-2.6/fs/internal.h	2010-10-19 14:19:00.000000000 +1100
@@ -15,6 +15,18 @@
 struct linux_binprm;
 struct path;
 
+static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+	if (strcmp(sb->s_type->name, "bdev") == 0)
+		return inode->i_mapping->backing_dev_info;
+
+	return sb->s_bdi;
+}
+
+#define inode_to_wb(inode)   (&inode_to_bdi(inode)->wb)
+
 /*
  * block_dev.c
  */
Index: linux-2.6/include/linux/backing-dev.h
===================================================================
--- linux-2.6.orig/include/linux/backing-dev.h	2010-10-19 14:17:15.000000000 +1100
+++ linux-2.6/include/linux/backing-dev.h	2010-10-19 14:19:00.000000000 +1100
@@ -16,6 +16,7 @@
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/writeback.h>
+#include <linux/spinlock.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -54,6 +55,7 @@
 
 	struct task_struct *task;	/* writeback thread */
 	struct timer_list wakeup_timer; /* used for delayed bdi thread wakeup */
+	spinlock_t b_lock;		/* lock for inode lists */
 	struct list_head b_dirty;	/* dirty inodes */
 	struct list_head b_io;		/* parked for writeback */
 	struct list_head b_more_io;	/* parked for more writeback */
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/include/linux/writeback.h	2010-10-19 14:19:00.000000000 +1100
@@ -9,8 +9,6 @@
 
 struct backing_dev_info;
 
-extern spinlock_t wb_inode_list_lock;
-
 /*
  * fs/fs-writeback.c
  */
Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/mm/backing-dev.c	2010-10-19 14:19:00.000000000 +1100
@@ -73,14 +73,14 @@
 	struct inode *inode;
 
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
-	spin_lock(&wb_inode_list_lock);
+	spin_lock(&wb->b_lock);
 	list_for_each_entry(inode, &wb->b_dirty, i_io)
 		nr_dirty++;
 	list_for_each_entry(inode, &wb->b_io, i_io)
 		nr_io++;
 	list_for_each_entry(inode, &wb->b_more_io, i_io)
 		nr_more_io++;
-	spin_unlock(&wb_inode_list_lock);
+	spin_unlock(&wb->b_lock);
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
 	bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
@@ -631,6 +631,7 @@
 
 	wb->bdi = bdi;
 	wb->last_old_flush = jiffies;
+	spin_lock_init(&wb->b_lock);
 	INIT_LIST_HEAD(&wb->b_dirty);
 	INIT_LIST_HEAD(&wb->b_io);
 	INIT_LIST_HEAD(&wb->b_more_io);
@@ -671,6 +672,17 @@
 }
 EXPORT_SYMBOL(bdi_init);
 
+static void bdi_lock_two(struct backing_dev_info *bdi1, struct backing_dev_info *bdi2)
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
@@ -682,11 +694,19 @@
 	if (bdi_has_dirty_io(bdi)) {
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
 
-		spin_lock(&wb_inode_list_lock);
+		bdi_lock_two(bdi, &default_backing_dev_info);
+		/*
+		 * It's OK to move inodes between different wb lists without
+		 * locking the individual inodes. i_lock will still protect
+		 * whether or not it is on a writeback list or not. However it
+		 * is a little quirk, maybe better to lock all inodes in this
+		 * uncommon case just to keep locking very regular.
+		 */
 		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
 		list_splice(&bdi->wb.b_io, &dst->b_io);
 		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
-		spin_unlock(&wb_inode_list_lock);
+		spin_unlock(&bdi->wb.b_lock);
+		spin_unlock(&dst->b_lock);
 	}
 
 	bdi_unregister(bdi);


