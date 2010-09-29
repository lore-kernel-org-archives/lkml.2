Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab0I2MXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:23:23 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:49430 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755380Ab0I2MTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:20 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/17] fs: icache lock lru/writeback lists
Date: Wed, 29 Sep 2010 22:18:38 +1000
Message-Id: <1285762729-17928-7-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

The inode moves between different lists protected by the inode_lock. Introduce
a new lock that protects all of the lists (dirty, unused, in use, etc) that the
inode will move around as it changes state. As this is mostly a list for
protecting the writeback lists, name it wb_inode_list_lock and nest all the
list manipulations in this lock inside the current inode_lock scope.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c         |   48 +++++++++++++++++++++++++++++++++++++++++++-
 fs/inode.c                |   44 +++++++++++++++++++++++++++++++++-------
 include/linux/writeback.h |    1 +
 mm/backing-dev.c          |    4 +++
 4 files changed, 87 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2edaad7..fb7b723 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -161,6 +161,7 @@ static void redirty_tail(struct inode *inode)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&wb_inode_list_lock);
 	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
@@ -178,6 +179,7 @@ static void requeue_io(struct inode *inode)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&wb_inode_list_lock);
 	list_move(&inode->i_list, &wb->b_more_io);
 }
 
@@ -218,6 +220,7 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 	struct inode *inode;
 	int do_sb_sort = 0;
 
+	assert_spin_locked(&wb_inode_list_lock);
 	while (!list_empty(delaying_queue)) {
 		inode = list_entry(delaying_queue->prev, struct inode, i_list);
 		if (older_than_this &&
@@ -281,11 +284,13 @@ static void inode_wait_for_writeback(struct inode *inode)
 
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
 
@@ -339,6 +344,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
@@ -375,6 +381,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&wb_inode_list_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
@@ -461,11 +468,18 @@ static bool pin_sb_for_writeback(struct super_block *sb)
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
@@ -474,9 +488,12 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
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
@@ -485,10 +502,9 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
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
@@ -511,11 +527,13 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
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
@@ -535,6 +553,9 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_lock);
+again:
+	spin_lock(&wb_inode_list_lock);
+
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 
@@ -544,7 +565,12 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
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
@@ -553,6 +579,7 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 		if (ret)
 			break;
 	}
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
 }
@@ -563,9 +590,11 @@ static void __writeback_inodes_sb(struct super_block *sb,
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_lock);
+	spin_lock(&wb_inode_list_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 	writeback_sb_inodes(sb, wb, wbc, true);
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode_lock);
 }
 
@@ -676,13 +705,22 @@ static long wb_writeback(struct bdi_writeback *wb,
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
 
@@ -993,8 +1031,10 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 					wakeup_bdi = true;
 			}
 
+			spin_lock(&wb_inode_list_lock);
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &bdi->wb.b_dirty);
+			spin_unlock(&wb_inode_list_lock);
 		}
 	}
 out:
@@ -1183,7 +1223,9 @@ int write_inode_now(struct inode *inode, int sync)
 	might_sleep();
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&wb_inode_list_lock);
 	ret = writeback_single_inode(inode, &wbc);
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	if (sync)
@@ -1209,7 +1251,9 @@ int sync_inode(struct inode *inode, struct writeback_control *wbc)
 
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&wb_inode_list_lock);
 	ret = writeback_single_inode(inode, wbc);
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	return ret;
diff --git a/fs/inode.c b/fs/inode.c
index 2e8ab8e..e15620f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
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
@@ -99,6 +102,7 @@ static struct hlist_head *inode_hashtable __read_mostly;
  */
 DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
+DEFINE_SPINLOCK(wb_inode_list_lock);
 DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
@@ -304,8 +308,11 @@ void __iget(struct inode *inode)
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
 
@@ -408,7 +415,9 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 		}
 		invalidate_inode_buffers(inode);
 		if (!inode->i_count) {
+			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, dispose);
+			spin_unlock(&wb_inode_list_lock);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			spin_unlock(&inode->i_lock);
@@ -486,6 +495,8 @@ static void prune_icache(int nr_to_scan)
 
 	down_read(&iprune_sem);
 	spin_lock(&inode_lock);
+again:
+	spin_lock(&wb_inode_list_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
 
@@ -494,13 +505,17 @@ static void prune_icache(int nr_to_scan)
 
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
@@ -509,11 +524,16 @@ static void prune_icache(int nr_to_scan)
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
@@ -531,6 +551,7 @@ static void prune_icache(int nr_to_scan)
 	else
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&inode_lock);
+	spin_unlock(&wb_inode_list_lock);
 
 	dispose_list(&freeable);
 	up_read(&iprune_sem);
@@ -654,7 +675,9 @@ __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
+	spin_lock(&wb_inode_list_lock);
 	list_add(&inode->i_list, &inode_in_use);
+	spin_unlock(&wb_inode_list_lock);
 	if (head) {
 		spin_lock(&inode_hash_lock);
 		hlist_add_head(&inode->i_hash, head);
@@ -1308,8 +1331,11 @@ static void iput_final(struct inode *inode)
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
@@ -1333,7 +1359,9 @@ static void iput_final(struct inode *inode)
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
 	}
+	spin_lock(&wb_inode_list_lock);
 	list_del_init(&inode->i_list);
+	spin_unlock(&wb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
@@ -1366,17 +1394,17 @@ void iput(struct inode *inode)
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
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 35d6e81..8b9c24f 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -11,6 +11,7 @@ struct backing_dev_info;
 
 extern spinlock_t inode_lock;
 extern spinlock_t sb_inode_list_lock;
+extern spinlock_t wb_inode_list_lock;
 extern spinlock_t inode_hash_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index c2bf86f..b1e2987 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -73,12 +73,14 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 
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
@@ -681,9 +683,11 @@ void bdi_destroy(struct backing_dev_info *bdi)
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
 
 		spin_lock(&inode_lock);
+		spin_lock(&wb_inode_list_lock);
 		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
 		list_splice(&bdi->wb.b_io, &dst->b_io);
 		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
+		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode_lock);
 	}
 
-- 
1.7.1

