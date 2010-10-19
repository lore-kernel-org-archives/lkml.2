Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab0JSEDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:03:01 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28439 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758039Ab0JSD4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSg
Message-Id: <20101019034656.404777390@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:25 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 09/35] fs: icache lock lru/writeback lists
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, wb_inode_list_lock, to protect i_list and various lists
which the inode can be put onto.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/fs-writeback.c         |   48 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/inode.c                |   44 ++++++++++++++++++++++++++++++++++--------
 include/linux/writeback.h |    1 
 mm/backing-dev.c          |    4 +++
 4 files changed, 87 insertions(+), 10 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:33.000000000 +1100
@@ -169,6 +169,7 @@
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&wb_inode_list_lock);
 	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
@@ -186,6 +187,7 @@
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&wb_inode_list_lock);
 	list_move(&inode->i_list, &wb->b_more_io);
 }
 
@@ -226,6 +228,7 @@
 	struct inode *inode;
 	int do_sb_sort = 0;
 
+	assert_spin_locked(&wb_inode_list_lock);
 	while (!list_empty(delaying_queue)) {
 		inode = list_entry(delaying_queue->prev, struct inode, i_list);
 		if (older_than_this &&
@@ -289,11 +292,13 @@
 
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
 
@@ -347,6 +352,7 @@
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
@@ -383,6 +389,7 @@
 
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&wb_inode_list_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
@@ -469,11 +476,18 @@
 static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 		struct writeback_control *wbc, bool only_this_sb)
 {
+again:
 	while (!list_empty(&wb->b_io)) {
 		long pages_skipped;
 		struct inode *inode = list_entry(wb->b_io.prev,
 						 struct inode, i_list);
 
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&wb_inode_list_lock);
+			spin_lock(&wb_inode_list_lock);
+			goto again;
+		}
+
 		if (inode->i_sb != sb) {
 			if (only_this_sb) {
 				/*
@@ -482,9 +496,12 @@
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
@@ -493,10 +510,9 @@
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
@@ -519,11 +535,13 @@
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
@@ -543,6 +561,9 @@
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_lock);
+again:
+	spin_lock(&wb_inode_list_lock);
+
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 
@@ -552,7 +573,12 @@
 		struct super_block *sb = inode->i_sb;
 
 		if (!pin_sb_for_writeback(sb)) {
+			if (!spin_trylock(&inode->i_lock)) {
+				spin_unlock(&wb_inode_list_lock);
+				goto again;
+			}
 			requeue_io(inode);
+			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		ret = writeback_sb_inodes(sb, wb, wbc, false);
@@ -561,6 +587,7 @@
 		if (ret)
 			break;
 	}
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
 }
@@ -571,9 +598,11 @@
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_lock);
+	spin_lock(&wb_inode_list_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 	writeback_sb_inodes(sb, wb, wbc, true);
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode_lock);
 }
 
@@ -684,13 +713,22 @@
 		 * become available for writeback. Otherwise
 		 * we'll just busyloop.
 		 */
+retry:
 		spin_lock(&inode_lock);
+		spin_lock(&wb_inode_list_lock);
 		if (!list_empty(&wb->b_more_io))  {
 			inode = list_entry(wb->b_more_io.prev,
 						struct inode, i_list);
+			if (!spin_trylock(&inode->i_lock)) {
+				spin_unlock(&wb_inode_list_lock);
+				spin_unlock(&inode_lock);
+				goto retry;
+			}
 			trace_wbc_writeback_wait(&wbc, wb->bdi);
 			inode_wait_for_writeback(inode);
+			spin_unlock(&inode->i_lock);
 		}
+		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode_lock);
 	}
 
@@ -1002,7 +1040,9 @@
 			}
 
 			inode->dirtied_when = jiffies;
+			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, &bdi->wb.b_dirty);
+			spin_unlock(&wb_inode_list_lock);
 		}
 	}
 out:
@@ -1195,7 +1235,9 @@
 	might_sleep();
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&wb_inode_list_lock);
 	ret = writeback_single_inode(inode, &wbc);
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	if (sync)
@@ -1221,7 +1263,9 @@
 
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
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:33.000000000 +1100
@@ -31,6 +31,8 @@
  *   s_inodes, i_sb_list
  * inode_hash_lock protects:
  *   inode hash table, i_hash
+ * wb_inode_list_lock protects:
+ *   inode_in_use, inode_unused, b_io, b_more_io, b_dirty, i_list
  * inode->i_lock protects:
  *   i_state, i_count
  *
@@ -38,6 +40,7 @@
  * inode_lock
  *   sb_inode_list_lock
  *     inode->i_lock
+ *       wb_inode_list_lock
  *       inode_hash_lock
  */
 /*
@@ -99,6 +102,7 @@
  */
 DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
+DEFINE_SPINLOCK(wb_inode_list_lock);
 static DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
@@ -304,8 +308,11 @@
 	if (inode->i_count > 1)
 		return;
 
-	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
+	if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
+		spin_lock(&wb_inode_list_lock);
 		list_move(&inode->i_list, &inode_in_use);
+		spin_unlock(&wb_inode_list_lock);
+	}
 	inodes_stat.nr_unused--;
 }
 
@@ -408,7 +415,9 @@
 		}
 		invalidate_inode_buffers(inode);
 		if (!inode->i_count) {
+			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, dispose);
+			spin_unlock(&wb_inode_list_lock);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			spin_unlock(&inode->i_lock);
@@ -486,6 +495,8 @@
 
 	down_read(&iprune_sem);
 	spin_lock(&inode_lock);
+again:
+	spin_lock(&wb_inode_list_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
 
@@ -494,13 +505,17 @@
 
 		inode = list_entry(inode_unused.prev, struct inode, i_list);
 
-		spin_lock(&inode->i_lock);
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&wb_inode_list_lock);
+			goto again;
+		}
 		if (inode->i_state || inode->i_count) {
 			list_move(&inode->i_list, &inode_unused);
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
+			spin_unlock(&wb_inode_list_lock);
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
@@ -509,11 +524,16 @@
 								0, -1);
 			iput(inode);
 			spin_lock(&inode_lock);
+again2:
+			spin_lock(&wb_inode_list_lock);
 
 			if (inode != list_entry(inode_unused.next,
 						struct inode, i_list))
 				continue;	/* wrong inode or list_empty */
-			spin_lock(&inode->i_lock);
+			if (!spin_trylock(&inode->i_lock)) {
+				spin_unlock(&wb_inode_list_lock);
+				goto again2;
+			}
 			if (!can_unuse(inode)) {
 				spin_unlock(&inode->i_lock);
 				continue;
@@ -531,6 +551,7 @@
 	else
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&inode_lock);
+	spin_unlock(&wb_inode_list_lock);
 
 	dispose_list(&freeable);
 	up_read(&iprune_sem);
@@ -663,7 +684,9 @@
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
+	spin_lock(&wb_inode_list_lock);
 	list_add(&inode->i_list, &inode_in_use);
+	spin_unlock(&wb_inode_list_lock);
 	if (head) {
 		spin_lock(&inode_hash_lock);
 		hlist_add_head(&inode->i_hash, head);
@@ -1316,8 +1339,11 @@
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
@@ -1341,7 +1367,9 @@
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
 	}
+	spin_lock(&wb_inode_list_lock);
 	list_del_init(&inode->i_list);
+	spin_unlock(&wb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
@@ -1374,17 +1402,17 @@
 	if (inode) {
 		BUG_ON(inode->i_state & I_CLEAR);
 
-retry:
+retry1:
 		spin_lock(&inode->i_lock);
 		if (inode->i_count == 1) {
 			if (!spin_trylock(&inode_lock)) {
+retry2:
 				spin_unlock(&inode->i_lock);
-				goto retry;
+				goto retry1;
 			}
 			if (!spin_trylock(&sb_inode_list_lock)) {
 				spin_unlock(&inode_lock);
-				spin_unlock(&inode->i_lock);
-				goto retry;
+				goto retry2;
 			}
 			inode->i_count--;
 			iput_final(inode);
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/include/linux/writeback.h	2010-10-19 14:19:32.000000000 +1100
@@ -11,6 +11,7 @@
 
 extern spinlock_t inode_lock;
 extern spinlock_t sb_inode_list_lock;
+extern spinlock_t wb_inode_list_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c	2010-10-19 14:17:24.000000000 +1100
+++ linux-2.6/mm/backing-dev.c	2010-10-19 14:19:32.000000000 +1100
@@ -74,12 +74,14 @@
 
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
@@ -683,9 +685,11 @@
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
 
 		spin_lock(&inode_lock);
+		spin_lock(&wb_inode_list_lock);
 		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
 		list_splice(&bdi->wb.b_io, &dst->b_io);
 		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
+		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode_lock);
 	}
 


