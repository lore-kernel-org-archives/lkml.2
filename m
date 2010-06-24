Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0FXDWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:22:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:48501 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab0FXDQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:16:08 -0400
Message-Id: <20100624030730.419497214@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:42 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 30/52] fs: icache lock lru/writeback lists
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, wb_inode_list_lock, to protect i_list and various lists
which the inode can be put onto.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/fs-writeback.c         |   40 ++++++++++++++++++++++++++++++++++++++--
 fs/inode.c                |   43 +++++++++++++++++++++++++++++++++++--------
 include/linux/writeback.h |    1 +
 mm/backing-dev.c          |    4 ++++
 4 files changed, 78 insertions(+), 10 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -287,6 +287,7 @@ static void redirty_tail(struct inode *i
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&wb_inode_list_lock);
 	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
@@ -304,6 +305,7 @@ static void requeue_io(struct inode *ino
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
+	assert_spin_locked(&wb_inode_list_lock);
 	list_move(&inode->i_list, &wb->b_more_io);
 }
 
@@ -344,6 +346,7 @@ static void move_expired_inodes(struct l
 	struct inode *inode;
 	int do_sb_sort = 0;
 
+	assert_spin_locked(&wb_inode_list_lock);
 	while (!list_empty(delaying_queue)) {
 		inode = list_entry(delaying_queue->prev, struct inode, i_list);
 		if (older_than_this &&
@@ -399,11 +402,13 @@ static void inode_wait_for_writeback(str
 
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
 
@@ -457,6 +462,7 @@ writeback_single_inode(struct inode *ino
 	/* Set I_SYNC, reset I_DIRTY_PAGES */
 	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY_PAGES;
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 
@@ -493,6 +499,7 @@ writeback_single_inode(struct inode *ino
 
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&wb_inode_list_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
 		if ((inode->i_state & I_DIRTY_PAGES) && wbc->for_kupdate) {
@@ -623,23 +630,31 @@ static int writeback_sb_inodes(struct su
 			       struct bdi_writeback *wb,
 			       struct writeback_control *wbc)
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
 		if (wbc->sb && sb != inode->i_sb) {
 			/* super block given and doesn't
 			   match, skip this inode */
 			redirty_tail(inode);
+			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		if (sb != inode->i_sb)
+		if (sb != inode->i_sb) {
 			/* finish with this superblock */
+			spin_unlock(&inode->i_lock);
 			return 0;
-		spin_lock(&inode->i_lock);
+		}
 		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
-			spin_unlock(&inode->i_lock);
 			requeue_io(inode);
+			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		/*
@@ -662,11 +677,13 @@ static int writeback_sb_inodes(struct su
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
@@ -685,6 +702,9 @@ static void writeback_inodes_wb(struct b
 
 	wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_lock);
+again:
+	spin_lock(&wb_inode_list_lock);
+
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
 
@@ -697,13 +717,23 @@ static void writeback_inodes_wb(struct b
 		if (wbc->sb && sb != wbc->sb) {
 			/* super block given and doesn't
 			   match, skip this inode */
+			if (!spin_trylock(&inode->i_lock)) {
+				spin_unlock(&wb_inode_list_lock);
+				goto again;
+			}
 			redirty_tail(inode);
+			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		state = pin_sb_for_writeback(wbc, sb);
 
 		if (state == SB_PIN_FAILED) {
+			if (!spin_trylock(&inode->i_lock)) {
+				spin_unlock(&wb_inode_list_lock);
+				goto again;
+			}
 			requeue_io(inode);
+			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		ret = writeback_sb_inodes(sb, wb, wbc);
@@ -713,6 +743,7 @@ static void writeback_inodes_wb(struct b
 		if (ret)
 			break;
 	}
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
 }
@@ -825,12 +856,21 @@ static long wb_writeback(struct bdi_writ
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
 			inode_wait_for_writeback(inode);
+			spin_unlock(&inode->i_lock);
 		}
+		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode_lock);
 	}
 
@@ -1142,7 +1182,9 @@ void __mark_inode_dirty(struct inode *in
 			}
 
 			inode->dirtied_when = jiffies;
+			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, &wb->b_dirty);
+			spin_unlock(&wb_inode_list_lock);
 		}
 	}
 out:
@@ -1306,7 +1348,9 @@ int write_inode_now(struct inode *inode,
 	might_sleep();
 	spin_lock(&inode_lock);
 	spin_lock(&inode->i_lock);
+	spin_lock(&wb_inode_list_lock);
 	ret = writeback_single_inode(inode, &wbc);
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	if (sync)
@@ -1332,7 +1376,9 @@ int sync_inode(struct inode *inode, stru
 
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
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -32,6 +32,8 @@
  *   s_inodes, i_sb_list
  * inode_hash_lock protects:
  *   inode hash table, i_hash
+ * wb_inode_list_lock protects:
+ *   inode_in_use, inode_unused, b_io, b_more_io, b_dirty, i_list
  * inode->i_lock protects:
  *   i_state, i_count
  *
@@ -39,6 +41,7 @@
  * inode_lock
  *   sb_inode_list_lock
  *     inode->i_lock
+ *       wb_inode_list_lock
  *       inode_hash_lock
  */
 /*
@@ -100,6 +103,7 @@ static struct hlist_head *inode_hashtabl
  */
 DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
+DEFINE_SPINLOCK(wb_inode_list_lock);
 DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
@@ -309,8 +313,11 @@ void __iget(struct inode *inode)
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
 
@@ -413,7 +420,9 @@ static int invalidate_list(struct list_h
 		}
 		invalidate_inode_buffers(inode);
 		if (!inode->i_count) {
+			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, dispose);
+			spin_unlock(&wb_inode_list_lock);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			spin_unlock(&inode->i_lock);
@@ -492,6 +501,8 @@ static void prune_icache(int nr_to_scan)
 
 	down_read(&iprune_sem);
 	spin_lock(&inode_lock);
+again:
+	spin_lock(&wb_inode_list_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
 
@@ -500,13 +511,17 @@ static void prune_icache(int nr_to_scan)
 
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
@@ -515,11 +530,16 @@ static void prune_icache(int nr_to_scan)
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
@@ -537,6 +557,7 @@ static void prune_icache(int nr_to_scan)
 	else
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&inode_lock);
+	spin_unlock(&wb_inode_list_lock);
 
 	dispose_list(&freeable);
 	up_read(&iprune_sem);
@@ -660,7 +681,9 @@ __inode_add_to_lists(struct super_block
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
+	spin_lock(&wb_inode_list_lock);
 	list_add(&inode->i_list, &inode_in_use);
+	spin_unlock(&wb_inode_list_lock);
 	if (head) {
 		spin_lock(&inode_hash_lock);
 		hlist_add_head(&inode->i_hash, head);
@@ -1290,7 +1313,9 @@ void generic_delete_inode(struct inode *
 {
 	const struct super_operations *op = inode->i_sb->s_op;
 
+	spin_lock(&wb_inode_list_lock);
 	list_del_init(&inode->i_list);
+	spin_unlock(&wb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
@@ -1335,8 +1360,11 @@ int generic_detach_inode(struct inode *i
 	struct super_block *sb = inode->i_sb;
 
 	if (!hlist_unhashed(&inode->i_hash)) {
-		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
+		if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
+			spin_lock(&wb_inode_list_lock);
 			list_move(&inode->i_list, &inode_unused);
+			spin_unlock(&wb_inode_list_lock);
+		}
 		inodes_stat.nr_unused++;
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode->i_lock);
@@ -1360,7 +1388,9 @@ int generic_detach_inode(struct inode *i
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
 	}
+	spin_lock(&wb_inode_list_lock);
 	list_del_init(&inode->i_list);
+	spin_unlock(&wb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
@@ -1432,17 +1462,17 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state == I_CLEAR);
 
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
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -11,6 +11,7 @@ struct backing_dev_info;
 
 extern spinlock_t inode_lock;
 extern spinlock_t sb_inode_list_lock;
+extern spinlock_t wb_inode_list_lock;
 extern spinlock_t inode_hash_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c
+++ linux-2.6/mm/backing-dev.c
@@ -78,6 +78,7 @@ static int bdi_debug_stats_show(struct s
 	 */
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
 	spin_lock(&inode_lock);
+	spin_lock(&wb_inode_list_lock);
 	list_for_each_entry(wb, &bdi->wb_list, list) {
 		nr_wb++;
 		list_for_each_entry(inode, &wb->b_dirty, i_list)
@@ -87,6 +88,7 @@ static int bdi_debug_stats_show(struct s
 		list_for_each_entry(inode, &wb->b_more_io, i_list)
 			nr_more_io++;
 	}
+	spin_unlock(&wb_inode_list_lock);
 	spin_unlock(&inode_lock);
 
 	get_dirty_limits(&background_thresh, &dirty_thresh, &bdi_thresh, bdi);
@@ -712,9 +714,11 @@ void bdi_destroy(struct backing_dev_info
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
 
 		spin_lock(&inode_lock);
+		spin_lock(&wb_inode_list_lock);
 		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
 		list_splice(&bdi->wb.b_io, &dst->b_io);
 		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
+		spin_unlock(&wb_inode_list_lock);
 		spin_unlock(&inode_lock);
 	}
 


