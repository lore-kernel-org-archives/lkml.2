Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0FXDYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:24:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:48493 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab0FXDP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:59 -0400
Message-Id: <20100624030733.504490635@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:03:01 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 49/52] fs: icache scale writeback list locking
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode-scale-wb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split wb_inode_list_lock lock into two locks, inode_lru_lock to protect
inode LRU list, and a per-bdi lock to protect the inode writeback lists.
Inode is given another list anchor so it can be present on both the LRU
and the writeback lists, for simplicity.

Signed-off-by: Nick Piggin <npiggin@suse.de>
--
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -283,11 +283,9 @@ void bdi_start_writeback(struct backing_
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
 
@@ -301,11 +299,9 @@ static void redirty_tail(struct inode *i
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
 
@@ -346,7 +342,6 @@ static void move_expired_inodes(struct l
 	struct inode *inode;
 	int do_sb_sort = 0;
 
-	assert_spin_locked(&wb_inode_list_lock);
 	while (!list_empty(delaying_queue)) {
 		inode = list_entry(delaying_queue->prev, struct inode, i_io);
 		if (older_than_this &&
@@ -395,18 +390,19 @@ static int write_inode(struct inode *ino
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
 
@@ -424,7 +420,8 @@ static void inode_wait_for_writeback(str
  * Called under inode_lock.
  */
 static int
-writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
+writeback_single_inode(struct bdi_writeback *wb, struct inode *inode,
+			struct writeback_control *wbc)
 {
 	struct address_space *mapping = inode->i_mapping;
 	unsigned dirty;
@@ -445,14 +442,14 @@ writeback_single_inode(struct inode *ino
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
@@ -460,7 +457,7 @@ writeback_single_inode(struct inode *ino
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
-	spin_unlock(&wb_inode_list_lock);
+	spin_unlock(&wb->b_lock);
 	spin_unlock(&inode->i_lock);
 
 	ret = do_writepages(mapping, wbc);
@@ -495,7 +492,7 @@ writeback_single_inode(struct inode *ino
 		spin_lock(&inode->i_lock);
 	}
 
-	spin_lock(&wb_inode_list_lock);
+	spin_lock(&wb->b_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
 		if ((inode->i_state & I_DIRTY_PAGES) && wbc->for_kupdate) {
@@ -508,7 +505,7 @@ writeback_single_inode(struct inode *ino
 			 * At least XFS will redirty the inode during the
 			 * writeback (delalloc) and on io completion (isize).
 			 */
-			redirty_tail(inode);
+			redirty_tail(wb, inode);
 		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
@@ -536,12 +533,12 @@ select_queue:
 					/*
 					 * slice used up: queue for next turn
 					 */
-					requeue_io(inode);
+					requeue_io(wb, inode);
 				} else {
 					/*
 					 * somehow blocked: retry later
 					 */
-					redirty_tail(inode);
+					redirty_tail(wb, inode);
 				}
 			} else {
 				/*
@@ -552,15 +549,13 @@ select_queue:
 				 * all the other files.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
-				redirty_tail(inode);
+				redirty_tail(wb, inode);
 			}
 		} else {
 			/* The inode is clean */
 			list_del_init(&inode->i_io);
-			if (list_empty(&inode->i_lru)) {
-				list_add(&inode->i_lru, &inode_unused);
-				inodes_stat.nr_unused++;
-			}
+			if (list_empty(&inode->i_lru))
+				__inode_lru_list_add(inode);
 		}
 	}
 	inode_sync_complete(inode);
@@ -629,14 +624,15 @@ again:
 		struct inode *inode = list_entry(wb->b_io.prev,
 						 struct inode, i_io);
 		if (!spin_trylock(&inode->i_lock)) {
-			spin_unlock(&wb_inode_list_lock);
-			spin_lock(&wb_inode_list_lock);
+			spin_unlock(&wb->b_lock);
+			cpu_relax();
+			spin_lock(&wb->b_lock);
 			goto again;
 		}
 		if (wbc->sb && sb != inode->i_sb) {
 			/* super block given and doesn't
 			   match, skip this inode */
-			redirty_tail(inode);
+			redirty_tail(wb, inode);
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
@@ -646,7 +642,7 @@ again:
 			return 0;
 		}
 		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
-			requeue_io(inode);
+			requeue_io(wb, inode);
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
@@ -662,19 +658,19 @@ again:
 		BUG_ON(inode->i_state & (I_FREEING | I_CLEAR));
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
@@ -693,7 +689,7 @@ static void writeback_inodes_wb(struct b
 
 	wbc->wb_start = jiffies; /* livelock avoidance */
 again:
-	spin_lock(&wb_inode_list_lock);
+	spin_lock(&wb->b_lock);
 
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
@@ -708,10 +704,11 @@ again:
 			/* super block given and doesn't
 			   match, skip this inode */
 			if (!spin_trylock(&inode->i_lock)) {
-				spin_unlock(&wb_inode_list_lock);
+				spin_unlock(&wb->b_lock);
+				cpu_relax();
 				goto again;
 			}
-			redirty_tail(inode);
+			redirty_tail(wb, inode);
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
@@ -719,10 +716,11 @@ again:
 
 		if (state == SB_PIN_FAILED) {
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
@@ -733,7 +731,7 @@ again:
 		if (ret)
 			break;
 	}
-	spin_unlock(&wb_inode_list_lock);
+	spin_unlock(&wb->b_lock);
 	/* Leave any unwritten inodes on b_io */
 }
 
@@ -846,18 +844,19 @@ static long wb_writeback(struct bdi_writ
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
+				cpu_relax();
 				goto retry;
 			}
-			inode_wait_for_writeback(inode);
+			inode_wait_for_writeback(wb, inode);
 			spin_unlock(&inode->i_lock);
 		}
-		spin_unlock(&wb_inode_list_lock);
+		spin_unlock(&wb->b_lock);
 	}
 
 	return wrote;
@@ -1156,7 +1155,7 @@ void __mark_inode_dirty(struct inode *in
 		 * reposition it (that would break b_dirty time-ordering).
 		 */
 		if (!was_dirty) {
-			struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
+			struct bdi_writeback *wb = inode_to_wb(inode);
 			struct backing_dev_info *bdi = wb->bdi;
 
 			if (bdi_cap_writeback_dirty(bdi) &&
@@ -1167,9 +1166,10 @@ void __mark_inode_dirty(struct inode *in
 			}
 
 			inode->dirtied_when = jiffies;
-			spin_lock(&wb_inode_list_lock);
-			list_move(&inode->i_io, &wb->b_dirty);
-			spin_unlock(&wb_inode_list_lock);
+			spin_lock(&wb->b_lock);
+			BUG_ON(!list_empty(&inode->i_io));
+			list_add(&inode->i_io, &wb->b_dirty);
+			spin_unlock(&wb->b_lock);
 		}
 	}
 out:
@@ -1313,6 +1313,7 @@ EXPORT_SYMBOL(sync_inodes_sb);
  */
 int write_inode_now(struct inode *inode, int sync)
 {
+	struct bdi_writeback *wb = inode_to_wb(inode);
 	int ret;
 	struct writeback_control wbc = {
 		.nr_to_write = LONG_MAX,
@@ -1326,9 +1327,9 @@ int write_inode_now(struct inode *inode,
 
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
@@ -1349,12 +1350,13 @@ EXPORT_SYMBOL(write_inode_now);
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
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -27,6 +27,7 @@
 #include <linux/posix_acl.h>
 #include <linux/bit_spinlock.h>
 #include <linux/lglock.h>
+#include "internal.h"
 
 /*
  * Usage:
@@ -34,8 +35,10 @@
  *   s_inodes, i_sb_list
  * inode_hash_bucket lock protects:
  *   inode hash table, i_hash
- * wb_inode_list_lock protects:
- *   inode_in_use, inode_unused, b_io, b_more_io, b_dirty, i_io, i_lru
+ * inode_lru_lock protects:
+ *   inode_lru, i_lru
+ * wb->b_lock protects:
+ *   b_io, b_more_io, b_dirty, i_io, i_lru
  * inode->i_lock protects:
  *   i_state
  *   i_count
@@ -48,7 +51,8 @@
  * inode_lock
  *   inode->i_lock
  *     inode_list_lglock
- *     wb_inode_list_lock
+ *     inode_lru_lock
+ *     wb->b_lock
  *     inode_hash_bucket lock
  */
 /*
@@ -98,7 +102,7 @@ static unsigned int i_hash_shift __read_
  * allowing for low-overhead inode sync() operations.
  */
 
-LIST_HEAD(inode_unused);
+static LIST_HEAD(inode_lru);
 
 struct inode_hash_bucket {
 	struct hlist_bl_head head;
@@ -125,7 +129,7 @@ static struct inode_hash_bucket *inode_h
 DECLARE_LGLOCK(inode_list_lglock);
 DEFINE_LGLOCK(inode_list_lglock);
 
-DEFINE_SPINLOCK(wb_inode_list_lock);
+static DEFINE_SPINLOCK(inode_lru_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -422,6 +426,22 @@ static void dispose_list(struct list_hea
 	}
 }
 
+void __inode_lru_list_add(struct inode *inode)
+{
+	spin_lock(&inode_lru_lock);
+	list_add(&inode->i_lru, &inode_lru);
+	inodes_stat.nr_unused++;
+	spin_unlock(&inode_lru_lock);
+}
+
+void __inode_lru_list_del(struct inode *inode)
+{
+	spin_lock(&inode_lru_lock);
+	list_del_init(&inode->i_lru);
+	inodes_stat.nr_unused--;
+	spin_unlock(&inode_lru_lock);
+}
+
 /*
  * Invalidate all inodes for a device.
  */
@@ -438,11 +458,17 @@ static int invalidate_sb_inodes(struct s
 		}
 		invalidate_inode_buffers(inode);
 		if (!inode->i_count) {
-			spin_lock(&wb_inode_list_lock);
+			struct bdi_writeback *wb = inode_to_wb(inode);
+
+			spin_lock(&wb->b_lock);
 			list_del_init(&inode->i_io);
+			spin_unlock(&wb->b_lock);
+
+			spin_lock(&inode_lru_lock);
 			list_del(&inode->i_lru);
 			inodes_stat.nr_unused--;
-			spin_unlock(&wb_inode_list_lock);
+			spin_unlock(&inode_lru_lock);
+
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			spin_unlock(&inode->i_lock);
@@ -494,7 +520,7 @@ EXPORT_SYMBOL(invalidate_inodes);
  *
  * Any inodes which are pinned purely because of attached pagecache have their
  * pagecache removed.  We expect the final iput() on that inode to add it to
- * the front of the inode_unused list.  So look for it there and if the
+ * the front of the inode_lru list.  So look for it there and if the
  * inode is still freeable, proceed.  The right inode is found 99.9% of the
  * time in testing on a 4-way.
  *
@@ -508,17 +534,17 @@ static void prune_icache(int nr_to_scan)
 
 	down_read(&iprune_sem);
 again:
-	spin_lock(&wb_inode_list_lock);
+	spin_lock(&inode_lru_lock);
 	for (; nr_to_scan; nr_to_scan--) {
 		struct inode *inode;
 
-		if (list_empty(&inode_unused))
+		if (list_empty(&inode_lru))
 			break;
 
-		inode = list_entry(inode_unused.prev, struct inode, i_lru);
+		inode = list_entry(inode_lru.prev, struct inode, i_lru);
 
 		if (!spin_trylock(&inode->i_lock)) {
-			spin_unlock(&wb_inode_list_lock);
+			spin_unlock(&inode_lru_lock);
 			goto again;
 		}
 		if (inode->i_count || (inode->i_state & ~I_REFERENCED)) {
@@ -528,14 +554,14 @@ again:
 			continue;
 		}
 		if (inode->i_state) {
-			list_move(&inode->i_lru, &inode_unused);
+			list_move(&inode->i_lru, &inode_lru);
 			inode->i_state &= ~I_REFERENCED;
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
-			list_move(&inode->i_lru, &inode_unused);
-			spin_unlock(&wb_inode_list_lock);
+			list_move(&inode->i_lru, &inode_lru);
+			spin_unlock(&inode_lru_lock);
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
 
@@ -543,7 +569,7 @@ again:
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
-			spin_lock(&wb_inode_list_lock);
+			spin_lock(&inode_lru_lock);
 			continue;
 		}
 		list_move(&inode->i_lru, &freeable);
@@ -556,7 +582,7 @@ again:
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
 		__count_vm_events(PGINODESTEAL, reap);
-	spin_unlock(&wb_inode_list_lock);
+	spin_unlock(&inode_lru_lock);
 
 	dispose_list(&freeable);
 	up_read(&iprune_sem);
@@ -1400,15 +1426,16 @@ void generic_delete_inode(struct inode *
 	const struct super_operations *op = inode->i_sb->s_op;
 
 	if (!list_empty(&inode->i_lru)) {
-		spin_lock(&wb_inode_list_lock);
+		spin_lock(&inode_lru_lock);
 		list_del_init(&inode->i_lru);
 		inodes_stat.nr_unused--;
-		spin_unlock(&wb_inode_list_lock);
+		spin_unlock(&inode_lru_lock);
 	}
 	if (!list_empty(&inode->i_io)) {
-		spin_lock(&wb_inode_list_lock);
+		struct bdi_writeback *wb = inode_to_wb(inode);
+		spin_lock(&wb->b_lock);
 		list_del_init(&inode->i_io);
-		spin_unlock(&wb_inode_list_lock);
+		spin_unlock(&wb->b_lock);
 	}
 	inode_sb_list_del(inode);
 	percpu_counter_dec(&nr_inodes);
@@ -1460,10 +1487,10 @@ int generic_detach_inode(struct inode *i
 			inode->i_state |= I_REFERENCED;
 			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
 					list_empty(&inode->i_lru)) {
-				spin_lock(&wb_inode_list_lock);
-				list_add(&inode->i_lru, &inode_unused);
+				spin_lock(&inode_lru_lock);
+				list_add(&inode->i_lru, &inode_lru);
 				inodes_stat.nr_unused++;
-				spin_unlock(&wb_inode_list_lock);
+				spin_unlock(&inode_lru_lock);
 			}
 			spin_unlock(&inode->i_lock);
 			return 0;
@@ -1478,15 +1505,16 @@ int generic_detach_inode(struct inode *i
 		__remove_inode_hash(inode);
 	}
 	if (!list_empty(&inode->i_lru)) {
-		spin_lock(&wb_inode_list_lock);
+		spin_lock(&inode_lru_lock);
 		list_del_init(&inode->i_lru);
 		inodes_stat.nr_unused--;
-		spin_unlock(&wb_inode_list_lock);
+		spin_unlock(&inode_lru_lock);
 	}
 	if (!list_empty(&inode->i_io)) {
-		spin_lock(&wb_inode_list_lock);
+		struct bdi_writeback *wb = inode_to_wb(inode);
+		spin_lock(&wb->b_lock);
 		list_del_init(&inode->i_io);
-		spin_unlock(&wb_inode_list_lock);
+		spin_unlock(&wb->b_lock);
 	}
 	inode_sb_list_del(inode);
 	percpu_counter_dec(&nr_inodes);
Index: linux-2.6/include/linux/backing-dev.h
===================================================================
--- linux-2.6.orig/include/linux/backing-dev.h
+++ linux-2.6/include/linux/backing-dev.h
@@ -16,6 +16,7 @@
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/writeback.h>
+#include <linux/spinlock.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -53,6 +54,7 @@ struct bdi_writeback {
 	unsigned long last_old_flush;		/* last old data flush */
 
 	struct task_struct	*task;		/* writeback task */
+	spinlock_t		b_lock;		/* lock for inode lists */
 	struct list_head	b_dirty;	/* dirty inodes */
 	struct list_head	b_io;		/* parked for writeback */
 	struct list_head	b_more_io;	/* parked for more writeback */
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -9,9 +9,6 @@
 
 struct backing_dev_info;
 
-extern spinlock_t wb_inode_list_lock;
-extern struct list_head inode_unused;
-
 /*
  * fs/fs-writeback.c
  */
Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c
+++ linux-2.6/mm/backing-dev.c
@@ -75,19 +75,22 @@ static int bdi_debug_stats_show(struct s
 	/*
 	 * inode lock is enough here, the bdi->wb_list is protected by
 	 * RCU on the reader side
+	 * (so why not for_each_entry_rcu, and why no explicit rcu disable??)
 	 */
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
-	spin_lock(&wb_inode_list_lock);
-	list_for_each_entry(wb, &bdi->wb_list, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(wb, &bdi->wb_list, list) {
 		nr_wb++;
+		spin_lock(&wb->b_lock);
 		list_for_each_entry(inode, &wb->b_dirty, i_io)
 			nr_dirty++;
 		list_for_each_entry(inode, &wb->b_io, i_io)
 			nr_io++;
 		list_for_each_entry(inode, &wb->b_more_io, i_io)
 			nr_more_io++;
+		spin_unlock(&wb->b_lock);
 	}
-	spin_unlock(&wb_inode_list_lock);
+	rcu_read_unlock();
 
 	get_dirty_limits(&background_thresh, &dirty_thresh, &bdi_thresh, bdi);
 
@@ -267,6 +270,7 @@ static void bdi_wb_init(struct bdi_write
 
 	wb->bdi = bdi;
 	wb->last_old_flush = jiffies;
+	spin_lock_init(&wb->b_lock);
 	INIT_LIST_HEAD(&wb->b_dirty);
 	INIT_LIST_HEAD(&wb->b_io);
 	INIT_LIST_HEAD(&wb->b_more_io);
@@ -700,6 +704,17 @@ err:
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
 void mapping_set_bdi(struct address_space *mapping, struct backing_dev_info *bdi)
 {
 	struct inode *inode = mapping->host;
@@ -708,7 +723,7 @@ void mapping_set_bdi(struct address_spac
 	if (unlikely(old == bdi))
 		return;
 
-	spin_lock(&wb_inode_list_lock);
+	bdi_lock_two(bdi, old);
 	if (!list_empty(&inode->i_io)) {
 		struct inode *i;
 
@@ -737,7 +752,8 @@ void mapping_set_bdi(struct address_spac
 	}
 found:
 	mapping->a_bdi = bdi;
-	spin_unlock(&wb_inode_list_lock);
+	spin_unlock(&bdi->wb.b_lock);
+	spin_unlock(&old->wb.b_lock);
 }
 EXPORT_SYMBOL(mapping_set_bdi);
 
@@ -753,7 +769,7 @@ void bdi_destroy(struct backing_dev_info
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
 		struct inode *i;
 
-		spin_lock(&wb_inode_list_lock);
+		bdi_lock_two(bdi, &default_backing_dev_info);
 		list_for_each_entry(i, &bdi->wb.b_dirty, i_io) {
 			list_del(&i->i_io);
 			list_add(&i->i_io, &dst->b_dirty);
@@ -769,7 +785,8 @@ void bdi_destroy(struct backing_dev_info
 			list_add(&i->i_io, &dst->b_more_io);
 			i->i_mapping->a_bdi = bdi;
 		}
-		spin_unlock(&wb_inode_list_lock);
+		spin_unlock(&bdi->wb.b_lock);
+		spin_unlock(&dst->b_lock);
 	}
 
 	bdi_unregister(bdi);
Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h
+++ linux-2.6/fs/internal.h
@@ -15,6 +15,8 @@ struct super_block;
 struct linux_binprm;
 struct path;
 
+#define inode_to_wb(inode)   (&(inode)->i_mapping->a_bdi->wb)
+
 /*
  * block_dev.c
  */
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -2076,6 +2076,8 @@ extern int check_disk_change(struct bloc
 extern int __invalidate_device(struct block_device *);
 extern int invalidate_partition(struct gendisk *, int);
 #endif
+extern void __inode_lru_list_add(struct inode *inode);
+extern void __inode_lru_list_del(struct inode *inode);
 extern int invalidate_inodes(struct super_block *);
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);


