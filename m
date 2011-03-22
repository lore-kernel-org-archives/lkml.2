Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab1CVLYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:24:50 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23860 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755153Ab1CVLXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:23:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkEAK8jiE15LK5JgWdsb2JhbAClQxUBARYmJcQUhWQEkmc
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 6/8] fs: move i_wb_list out from under inode_lock
Date: Tue, 22 Mar 2011 22:23:41 +1100
Message-Id: <1300793023-3775-7-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300793023-3775-1-git-send-email-david@fromorbit.com>
References: <1300793023-3775-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Protect the inode writeback list with a new global lock
inode_wb_list_lock and use it to protect the list manipulations and
traversals. This lock replaces the inode_lock as the inodes on the
list can be validity checked while holding the inode->i_lock and
hence the inode_lock is no longer needed to protect the list.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/block_dev.c            |    4 +-
 fs/fs-writeback.c         |   76 ++++++++++++++++++++++++++-------------------
 fs/inode.c                |   12 +++++--
 fs/internal.h             |    5 +++
 include/linux/writeback.h |    1 +
 mm/backing-dev.c          |    8 ++--
 mm/filemap.c              |    8 ++--
 mm/rmap.c                 |    4 +-
 8 files changed, 70 insertions(+), 48 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index bc39b18..2bbc0e6 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -55,13 +55,13 @@ EXPORT_SYMBOL(I_BDEV);
 static void bdev_inode_switch_bdi(struct inode *inode,
 			struct backing_dev_info *dst)
 {
-	spin_lock(&inode_lock);
+	spin_lock(&inode_wb_list_lock);
 	spin_lock(&inode->i_lock);
 	inode->i_data.backing_dev_info = dst;
 	if (inode->i_state & I_DIRTY)
 		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_wb_list_lock);
 }
 
 static sector_t max_block(struct block_device *bdev)
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5de56a2..ed80065 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -176,6 +176,17 @@ void bdi_start_background_writeback(struct backing_dev_info *bdi)
 }
 
 /*
+ * Remove the inode from the writeback list it is on.
+ */
+void inode_wb_list_del(struct inode *inode)
+{
+	spin_lock(&inode_wb_list_lock);
+	list_del_init(&inode->i_wb_list);
+	spin_unlock(&inode_wb_list_lock);
+}
+
+
+/*
  * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
  * furthest end of its superblock's dirty-inode list.
  *
@@ -188,6 +199,7 @@ static void redirty_tail(struct inode *inode)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&inode_wb_list_lock);
 	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
@@ -205,14 +217,17 @@ static void requeue_io(struct inode *inode)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&inode_wb_list_lock);
 	list_move(&inode->i_wb_list, &wb->b_more_io);
 }
 
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 * Prevent speculative execution through
+	 * spin_unlock(&inode_wb_list_lock);
 	 */
+
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_SYNC);
 }
@@ -286,6 +301,7 @@ static void move_expired_inodes(struct list_head *delaying_queue,
  */
 static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
 {
+	assert_spin_locked(&inode_wb_list_lock);
 	list_splice_init(&wb->b_more_io, &wb->b_io);
 	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
 }
@@ -308,25 +324,23 @@ static void inode_wait_for_writeback(struct inode *inode)
 	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
 	while (inode->i_state & I_SYNC) {
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_wb_list_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
-		spin_lock(&inode_lock);
+		spin_lock(&inode_wb_list_lock);
 		spin_lock(&inode->i_lock);
 	}
 }
 
 /*
- * Write out an inode's dirty pages.  Called under inode_lock.  Either the
- * caller has ref on the inode (either via __iget or via syscall against an fd)
- * or the inode has I_WILL_FREE set (via generic_forget_inode)
+ * Write out an inode's dirty pages.  Called under inode_wb_list_lock.  Either
+ * the caller has an active reference on the inode or the inode has I_WILL_FREE
+ * set.
  *
  * If `wait' is set, wait on the writeout.
  *
  * The whole writeout design is quite complex and fragile.  We want to avoid
  * starvation of particular inodes when others are being redirtied, prevent
  * livelocks, etc.
- *
- * Called under inode_lock.
  */
 static int
 writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
@@ -368,7 +382,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_wb_list_lock);
 
 	ret = do_writepages(mapping, wbc);
 
@@ -388,12 +402,10 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	 * due to delalloc, clear dirty metadata flags right before
 	 * write_inode()
 	 */
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	dirty = inode->i_state & I_DIRTY;
 	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_lock);
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
 		int err = write_inode(inode, wbc);
@@ -401,7 +413,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			ret = err;
 	}
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_wb_list_lock);
 	spin_lock(&inode->i_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
@@ -543,10 +555,10 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 			 */
 			redirty_tail(inode);
 		}
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_wb_list_lock);
 		iput(inode);
 		cond_resched();
-		spin_lock(&inode_lock);
+		spin_lock(&inode_wb_list_lock);
 		if (wbc->nr_to_write <= 0) {
 			wbc->more_io = 1;
 			return 1;
@@ -565,7 +577,7 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
-	spin_lock(&inode_lock);
+	spin_lock(&inode_wb_list_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 
@@ -583,7 +595,7 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 		if (ret)
 			break;
 	}
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_wb_list_lock);
 	/* Leave any unwritten inodes on b_io */
 }
 
@@ -592,11 +604,11 @@ static void __writeback_inodes_sb(struct super_block *sb,
 {
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_wb_list_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 	writeback_sb_inodes(sb, wb, wbc, true);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_wb_list_lock);
 }
 
 /*
@@ -735,7 +747,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 		 * become available for writeback. Otherwise
 		 * we'll just busyloop.
 		 */
-		spin_lock(&inode_lock);
+		spin_lock(&inode_wb_list_lock);
 		if (!list_empty(&wb->b_more_io))  {
 			inode = wb_inode(wb->b_more_io.prev);
 			trace_wbc_writeback_wait(&wbc, wb->bdi);
@@ -743,7 +755,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 			inode_wait_for_writeback(inode);
 			spin_unlock(&inode->i_lock);
 		}
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_wb_list_lock);
 	}
 
 	return wrote;
@@ -1009,7 +1021,6 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 {
 	struct super_block *sb = inode->i_sb;
 	struct backing_dev_info *bdi = NULL;
-	bool wakeup_bdi = false;
 
 	/*
 	 * Don't do this for I_DIRTY_PAGES - that doesn't actually
@@ -1033,7 +1044,6 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	if (unlikely(block_dump))
 		block_dump___mark_inode_dirty(inode);
 
-	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
@@ -1059,12 +1069,12 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		if (inode->i_state & I_FREEING)
 			goto out_unlock_inode;
 
-		spin_unlock(&inode->i_lock);
 		/*
 		 * If the inode was already on b_dirty/b_io/b_more_io, don't
 		 * reposition it (that would break b_dirty time-ordering).
 		 */
 		if (!was_dirty) {
+			bool wakeup_bdi = false;
 			bdi = inode_to_bdi(inode);
 
 			if (bdi_cap_writeback_dirty(bdi)) {
@@ -1081,18 +1091,20 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 					wakeup_bdi = true;
 			}
 
+			spin_unlock(&inode->i_lock);
+			spin_lock(&inode_wb_list_lock);
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
+			spin_unlock(&inode_wb_list_lock);
+
+			if (wakeup_bdi)
+				bdi_wakeup_thread_delayed(bdi);
+			return;
 		}
-		goto out;
 	}
 out_unlock_inode:
 	spin_unlock(&inode->i_lock);
-out:
-	spin_unlock(&inode_lock);
 
-	if (wakeup_bdi)
-		bdi_wakeup_thread_delayed(bdi);
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
 
@@ -1296,9 +1308,9 @@ int write_inode_now(struct inode *inode, int sync)
 		wbc.nr_to_write = 0;
 
 	might_sleep();
-	spin_lock(&inode_lock);
+	spin_lock(&inode_wb_list_lock);
 	ret = writeback_single_inode(inode, &wbc);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_wb_list_lock);
 	if (sync)
 		inode_sync_wait(inode);
 	return ret;
@@ -1320,9 +1332,9 @@ int sync_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int ret;
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_wb_list_lock);
 	ret = writeback_single_inode(inode, wbc);
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_wb_list_lock);
 	return ret;
 }
 EXPORT_SYMBOL(sync_inode);
diff --git a/fs/inode.c b/fs/inode.c
index 5483d38..5a7f8ef 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -25,6 +25,7 @@
 #include <linux/async.h>
 #include <linux/posix_acl.h>
 #include <linux/ima.h>
+#include "internal.h"
 
 /*
  * inode locking rules.
@@ -35,6 +36,8 @@
  *   inode_lru, inode->i_lru
  * inode_sb_list_lock protects:
  *   sb->s_inodes, inode->i_sb_list
+ * inode_wb_list_lock protects:
+ *   bdi->wb.b_{dirty,io,more_io}, inode->i_wb_list
  *
  * Lock ordering:
  * inode_lock
@@ -43,6 +46,9 @@
  * inode_sb_list_lock
  *   inode->i_lock
  *     inode_lru_lock
+ *
+ * inode_wb_list_lock
+ *   inode->i_lock
  */
 
 /*
@@ -104,6 +110,7 @@ static struct hlist_head *inode_hashtable __read_mostly;
 DEFINE_SPINLOCK(inode_lock);
 
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_sb_list_lock);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_wb_list_lock);
 
 /*
  * iprune_sem provides exclusion between the icache shrinking and the
@@ -482,10 +489,7 @@ static void evict(struct inode *inode)
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(!list_empty(&inode->i_lru));
 
-	spin_lock(&inode_lock);
-	list_del_init(&inode->i_wb_list);
-	spin_unlock(&inode_lock);
-
+	inode_wb_list_del(inode);
 	inode_sb_list_del(inode);
 
 	if (op->evict_inode) {
diff --git a/fs/internal.h b/fs/internal.h
index 7013ae0..b29c46e 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -127,6 +127,11 @@ extern long do_handle_open(int mountdirfd,
  */
 extern spinlock_t inode_sb_list_lock;
 
+/*
+ * fs-writeback.c
+ */
+extern void inode_wb_list_del(struct inode *inode);
+
 extern int get_nr_dirty_inodes(void);
 extern void evict_inodes(struct super_block *);
 extern int invalidate_inodes(struct super_block *, bool);
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 0ead399..3f5fee7 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -10,6 +10,7 @@
 struct backing_dev_info;
 
 extern spinlock_t inode_lock;
+extern spinlock_t inode_wb_list_lock;
 
 /*
  * fs/fs-writeback.c
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 027100d..4b3e9f1 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -73,14 +73,14 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 	struct inode *inode;
 
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
-	spin_lock(&inode_lock);
+	spin_lock(&inode_wb_list_lock);
 	list_for_each_entry(inode, &wb->b_dirty, i_wb_list)
 		nr_dirty++;
 	list_for_each_entry(inode, &wb->b_io, i_wb_list)
 		nr_io++;
 	list_for_each_entry(inode, &wb->b_more_io, i_wb_list)
 		nr_more_io++;
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_wb_list_lock);
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
 	bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
@@ -682,11 +682,11 @@ void bdi_destroy(struct backing_dev_info *bdi)
 	if (bdi_has_dirty_io(bdi)) {
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
 
-		spin_lock(&inode_lock);
+		spin_lock(&inode_wb_list_lock);
 		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
 		list_splice(&bdi->wb.b_io, &dst->b_io);
 		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_wb_list_lock);
 	}
 
 	bdi_unregister(bdi);
diff --git a/mm/filemap.c b/mm/filemap.c
index 79b021d..c88d17f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -80,8 +80,8 @@
  *  ->i_mutex
  *    ->i_alloc_sem             (various)
  *
- *  ->inode_lock
- *    ->sb_lock			(fs/fs-writeback.c)
+ *  inode_wb_list_lock
+ *    sb_lock			(fs/fs-writeback.c)
  *    ->mapping->tree_lock	(__sync_single_inode)
  *
  *  ->i_mmap_lock
@@ -98,9 +98,9 @@
  *    ->zone.lru_lock		(check_pte_range->isolate_lru_page)
  *    ->private_lock		(page_remove_rmap->set_page_dirty)
  *    ->tree_lock		(page_remove_rmap->set_page_dirty)
- *    ->inode_lock		(page_remove_rmap->set_page_dirty)
+ *    inode_wb_list_lock	(page_remove_rmap->set_page_dirty)
  *    ->inode->i_lock		(page_remove_rmap->set_page_dirty)
- *    ->inode_lock		(zap_pte_range->set_page_dirty)
+ *    inode_wb_list_lock	(zap_pte_range->set_page_dirty)
  *    ->inode->i_lock		(zap_pte_range->set_page_dirty)
  *    ->private_lock		(zap_pte_range->__set_page_dirty_buffers)
  *
diff --git a/mm/rmap.c b/mm/rmap.c
index 81a95c3..af9e0d7 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -31,12 +31,12 @@
  *             swap_lock (in swap_duplicate, swap_info_get)
  *               mmlist_lock (in mmput, drain_mmlist and others)
  *               mapping->private_lock (in __set_page_dirty_buffers)
- *               inode_lock (in set_page_dirty's __mark_inode_dirty)
  *               inode->i_lock (in set_page_dirty's __mark_inode_dirty)
+ *               inode_wb_list_lock (in set_page_dirty's __mark_inode_dirty)
  *                 sb_lock (within inode_lock in fs/fs-writeback.c)
  *                 mapping->tree_lock (widely used, in set_page_dirty,
  *                           in arch-dependent flush_dcache_mmap_lock,
- *                           within inode_lock in __sync_single_inode)
+ *                           within inode_wb_list_lock in __sync_single_inode)
  *
  * (code doesn't rely on that order so it could be switched around)
  * ->tasklist_lock
-- 
1.7.2.3

