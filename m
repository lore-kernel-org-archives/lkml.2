Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab0JUAup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:50:45 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:35955 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756356Ab0JUAuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:50:37 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/21] fs: inode split IO and LRU lists
Date: Thu, 21 Oct 2010 11:49:30 +1100
Message-Id: <1287622186-1935-6-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287622186-1935-1-git-send-email-david@fromorbit.com>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

The use of the same inode list structure (inode->i_list) for two
different list constructs with different lifecycles and purposes
makes it impossible to separate the locking of the different
operations. Therefore, to enable the separation of the locking of
the writeback and reclaim lists, split the inode->i_list into two
separate lists dedicated to their specific tracking functions.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c            |    4 ++--
 fs/fs-writeback.c         |   27 ++++++++++++++-------------
 fs/inode.c                |   38 +++++++++++++++++++++-----------------
 fs/nilfs2/mdt.c           |    3 ++-
 include/linux/fs.h        |    3 ++-
 include/linux/writeback.h |    1 -
 mm/backing-dev.c          |    6 +++---
 7 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 501eab5..63b1c4c 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -58,8 +58,8 @@ static void bdev_inode_switch_bdi(struct inode *inode,
 {
 	spin_lock(&inode_lock);
 	inode->i_data.backing_dev_info = dst;
-	if (inode->i_state & I_DIRTY)
-		list_move(&inode->i_list, &dst->wb.b_dirty);
+	if (!list_empty(&inode->i_wb_list))
+		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
 	spin_unlock(&inode_lock);
 }
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 33e9857..92d73b6 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -172,11 +172,11 @@ static void redirty_tail(struct inode *inode)
 	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
-		tail = list_entry(wb->b_dirty.next, struct inode, i_list);
+		tail = list_entry(wb->b_dirty.next, struct inode, i_wb_list);
 		if (time_before(inode->dirtied_when, tail->dirtied_when))
 			inode->dirtied_when = jiffies;
 	}
-	list_move(&inode->i_list, &wb->b_dirty);
+	list_move(&inode->i_wb_list, &wb->b_dirty);
 }
 
 /*
@@ -186,7 +186,7 @@ static void requeue_io(struct inode *inode)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
-	list_move(&inode->i_list, &wb->b_more_io);
+	list_move(&inode->i_wb_list, &wb->b_more_io);
 }
 
 static void inode_sync_complete(struct inode *inode)
@@ -227,14 +227,15 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 	int do_sb_sort = 0;
 
 	while (!list_empty(delaying_queue)) {
-		inode = list_entry(delaying_queue->prev, struct inode, i_list);
+		inode = list_entry(delaying_queue->prev,
+						struct inode, i_wb_list);
 		if (older_than_this &&
 		    inode_dirtied_after(inode, *older_than_this))
 			break;
 		if (sb && sb != inode->i_sb)
 			do_sb_sort = 1;
 		sb = inode->i_sb;
-		list_move(&inode->i_list, &tmp);
+		list_move(&inode->i_wb_list, &tmp);
 	}
 
 	/* just one sb in list, splice to dispatch_queue and we're done */
@@ -245,12 +246,12 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 
 	/* Move inodes from one superblock together */
 	while (!list_empty(&tmp)) {
-		inode = list_entry(tmp.prev, struct inode, i_list);
+		inode = list_entry(tmp.prev, struct inode, i_wb_list);
 		sb = inode->i_sb;
 		list_for_each_prev_safe(pos, node, &tmp) {
-			inode = list_entry(pos, struct inode, i_list);
+			inode = list_entry(pos, struct inode, i_wb_list);
 			if (inode->i_sb == sb)
-				list_move(&inode->i_list, dispatch_queue);
+				list_move(&inode->i_wb_list, dispatch_queue);
 		}
 	}
 }
@@ -415,7 +416,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			 * does not move dirty inodes to the LRU and dirty
 			 * inodes are removed from the LRU during scanning.
 			 */
-			list_del_init(&inode->i_list);
+			list_del_init(&inode->i_wb_list);
 			if (!atomic_read(&inode->i_count))
 				inode_lru_list_add(inode);
 		}
@@ -466,7 +467,7 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 	while (!list_empty(&wb->b_io)) {
 		long pages_skipped;
 		struct inode *inode = list_entry(wb->b_io.prev,
-						 struct inode, i_list);
+						 struct inode, i_wb_list);
 
 		if (inode->i_sb != sb) {
 			if (only_this_sb) {
@@ -537,7 +538,7 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = list_entry(wb->b_io.prev,
-						 struct inode, i_list);
+						 struct inode, i_wb_list);
 		struct super_block *sb = inode->i_sb;
 
 		if (!pin_sb_for_writeback(sb)) {
@@ -676,7 +677,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 		spin_lock(&inode_lock);
 		if (!list_empty(&wb->b_more_io))  {
 			inode = list_entry(wb->b_more_io.prev,
-						struct inode, i_list);
+						struct inode, i_wb_list);
 			trace_wbc_writeback_wait(&wbc, wb->bdi);
 			inode_wait_for_writeback(inode);
 		}
@@ -990,7 +991,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			}
 
 			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &bdi->wb.b_dirty);
+			list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
 		}
 	}
 out:
diff --git a/fs/inode.c b/fs/inode.c
index f47ec71..e88d582 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -72,7 +72,7 @@ static unsigned int i_hash_shift __read_mostly;
  * allowing for low-overhead inode sync() operations.
  */
 
-LIST_HEAD(inode_unused);
+static LIST_HEAD(inode_lru);
 static struct hlist_head *inode_hashtable __read_mostly;
 
 /*
@@ -272,6 +272,7 @@ EXPORT_SYMBOL(__destroy_inode);
 
 void destroy_inode(struct inode *inode)
 {
+	BUG_ON(!list_empty(&inode->i_lru));
 	__destroy_inode(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
@@ -290,7 +291,8 @@ void inode_init_once(struct inode *inode)
 	INIT_HLIST_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
-	INIT_LIST_HEAD(&inode->i_list);
+	INIT_LIST_HEAD(&inode->i_wb_list);
+	INIT_LIST_HEAD(&inode->i_lru);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
 	spin_lock_init(&inode->i_data.tree_lock);
 	spin_lock_init(&inode->i_data.i_mmap_lock);
@@ -322,14 +324,16 @@ void __iget(struct inode *inode)
 
 void inode_lru_list_add(struct inode *inode)
 {
-	list_add(&inode->i_list, &inode_unused);
-	percpu_counter_inc(&nr_inodes_unused);
+	if (list_empty(&inode->i_lru)) {
+		list_add(&inode->i_lru, &inode_lru);
+		percpu_counter_inc(&nr_inodes_unused);
+	}
 }
 
 void inode_lru_list_del(struct inode *inode)
 {
-	if (!list_empty(&inode->i_list)) {
-		list_del_init(&inode->i_list);
+	if (!list_empty(&inode->i_lru)) {
+		list_del_init(&inode->i_lru);
 		percpu_counter_dec(&nr_inodes_unused);
 	}
 }
@@ -375,8 +379,8 @@ static void dispose_list(struct list_head *head)
 	while (!list_empty(head)) {
 		struct inode *inode;
 
-		inode = list_first_entry(head, struct inode, i_list);
-		list_del_init(&inode->i_list);
+		inode = list_first_entry(head, struct inode, i_lru);
+		list_del_init(&inode->i_lru);
 
 		evict(inode);
 
@@ -421,7 +425,7 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 		if (!atomic_read(&inode->i_count)) {
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
-			list_move(&inode->i_list, dispose);
+			list_move(&inode->i_lru, dispose);
 			percpu_counter_dec(&nr_inodes_unused);
 			continue;
 		}
@@ -483,10 +487,10 @@ static void prune_icache(int nr_to_scan)
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
 
-		if (list_empty(&inode_unused))
+		if (list_empty(&inode_lru))
 			break;
 
-		inode = list_entry(inode_unused.prev, struct inode, i_list);
+		inode = list_entry(inode_lru.prev, struct inode, i_lru);
 
 		/*
 		 * Referenced or dirty inodes are still in use. Give them
@@ -494,14 +498,14 @@ static void prune_icache(int nr_to_scan)
 		 */
 		if (atomic_read(&inode->i_count) ||
 		    (inode->i_state & ~I_REFERENCED)) {
-			list_del_init(&inode->i_list);
+			list_del_init(&inode->i_lru);
 			percpu_counter_dec(&nr_inodes_unused);
 			continue;
 		}
 
 		/* recently referenced inodes get one more pass */
 		if (inode->i_state & I_REFERENCED) {
-			list_move(&inode->i_list, &inode_unused);
+			list_move(&inode->i_lru, &inode_lru);
 			inode->i_state &= ~I_REFERENCED;
 			continue;
 		}
@@ -526,7 +530,8 @@ static void prune_icache(int nr_to_scan)
 			spin_lock(&inode_lock);
 			continue;
 		}
-		list_move(&inode->i_list, &freeable);
+		list_move(&inode->i_lru, &freeable);
+		list_del_init(&inode->i_wb_list);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
 		percpu_counter_dec(&nr_inodes_unused);
@@ -1257,10 +1262,8 @@ static void iput_final(struct inode *inode)
 	if (!drop) {
 		if (sb->s_flags & MS_ACTIVE) {
 			inode->i_state |= I_REFERENCED;
-			if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
-				list_del_init(&inode->i_list);
+			if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 				inode_lru_list_add(inode);
-			}
 			spin_unlock(&inode_lock);
 			return;
 		}
@@ -1273,6 +1276,7 @@ static void iput_final(struct inode *inode)
 		inode->i_state &= ~I_WILL_FREE;
 		hlist_del_init(&inode->i_hash);
 	}
+	list_del_init(&inode->i_wb_list);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index d01aff4..62756b4 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -504,7 +504,8 @@ nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
 #endif
 		inode->dirtied_when = 0;
 
-		INIT_LIST_HEAD(&inode->i_list);
+		INIT_LIST_HEAD(&inode->i_wb_list);
+		INIT_LIST_HEAD(&inode->i_lru);
 		INIT_LIST_HEAD(&inode->i_sb_list);
 		inode->i_state = 0;
 #endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index af1d516..90d2b47 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -725,7 +725,8 @@ struct posix_acl;
 
 struct inode {
 	struct hlist_node	i_hash;
-	struct list_head	i_list;		/* backing dev IO list */
+	struct list_head	i_wb_list;	/* backing dev IO list */
+	struct list_head	i_lru;		/* inode LRU list */
 	struct list_head	i_sb_list;
 	struct list_head	i_dentry;
 	unsigned long		i_ino;
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index f956b66..242b6f8 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -10,7 +10,6 @@
 struct backing_dev_info;
 
 extern spinlock_t inode_lock;
-extern struct list_head inode_unused;
 
 /*
  * fs/fs-writeback.c
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 65d4204..15d5097 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -74,11 +74,11 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
 	spin_lock(&inode_lock);
-	list_for_each_entry(inode, &wb->b_dirty, i_list)
+	list_for_each_entry(inode, &wb->b_dirty, i_wb_list)
 		nr_dirty++;
-	list_for_each_entry(inode, &wb->b_io, i_list)
+	list_for_each_entry(inode, &wb->b_io, i_wb_list)
 		nr_io++;
-	list_for_each_entry(inode, &wb->b_more_io, i_list)
+	list_for_each_entry(inode, &wb->b_more_io, i_wb_list)
 		nr_more_io++;
 	spin_unlock(&inode_lock);
 
-- 
1.7.1

