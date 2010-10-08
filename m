Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab0JHFZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:25:55 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:44311 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752337Ab0JHFWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:22:02 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/18] fs: inode split IO and LRU lists
Date: Fri,  8 Oct 2010 16:21:19 +1100
Message-Id: <1286515292-15882-6-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286515292-15882-1-git-send-email-david@fromorbit.com>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
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
---
 fs/fs-writeback.c         |   30 +++++++++++++++++-------------
 fs/inode.c                |   36 +++++++++++++++++++++---------------
 fs/nilfs2/mdt.c           |    3 ++-
 include/linux/fs.h        |    3 ++-
 include/linux/writeback.h |    3 +++
 mm/backing-dev.c          |   44 ++++++++++++++++++++++----------------------
 6 files changed, 67 insertions(+), 52 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2a61300..78aaaa8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -172,11 +172,11 @@ static void redirty_tail(struct inode *inode)
 	if (!list_empty(&wb->b_dirty)) {
 		struct inode *tail;
 
-		tail = list_entry(wb->b_dirty.next, struct inode, i_list);
+		tail = list_entry(wb->b_dirty.next, struct inode, i_io);
 		if (time_before(inode->dirtied_when, tail->dirtied_when))
 			inode->dirtied_when = jiffies;
 	}
-	list_move(&inode->i_list, &wb->b_dirty);
+	list_move(&inode->i_io, &wb->b_dirty);
 }
 
 /*
@@ -186,7 +186,7 @@ static void requeue_io(struct inode *inode)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
-	list_move(&inode->i_list, &wb->b_more_io);
+	list_move(&inode->i_io, &wb->b_more_io);
 }
 
 static void inode_sync_complete(struct inode *inode)
@@ -227,14 +227,14 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 	int do_sb_sort = 0;
 
 	while (!list_empty(delaying_queue)) {
-		inode = list_entry(delaying_queue->prev, struct inode, i_list);
+		inode = list_entry(delaying_queue->prev, struct inode, i_io);
 		if (older_than_this &&
 		    inode_dirtied_after(inode, *older_than_this))
 			break;
 		if (sb && sb != inode->i_sb)
 			do_sb_sort = 1;
 		sb = inode->i_sb;
-		list_move(&inode->i_list, &tmp);
+		list_move(&inode->i_io, &tmp);
 	}
 
 	/* just one sb in list, splice to dispatch_queue and we're done */
@@ -245,12 +245,12 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 
 	/* Move inodes from one superblock together */
 	while (!list_empty(&tmp)) {
-		inode = list_entry(tmp.prev, struct inode, i_list);
+		inode = list_entry(tmp.prev, struct inode, i_io);
 		sb = inode->i_sb;
 		list_for_each_prev_safe(pos, node, &tmp) {
-			inode = list_entry(pos, struct inode, i_list);
+			inode = list_entry(pos, struct inode, i_io);
 			if (inode->i_sb == sb)
-				list_move(&inode->i_list, dispatch_queue);
+				list_move(&inode->i_io, dispatch_queue);
 		}
 	}
 }
@@ -410,7 +410,11 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			redirty_tail(inode);
 		} else {
 			/* The inode is clean */
-			list_move(&inode->i_list, &inode_unused);
+			list_del_init(&inode->i_io);
+			if (list_empty(&inode->i_lru)) {
+				list_add(&inode->i_lru, &inode_unused);
+				percpu_counter_inc(&nr_inodes_unused);
+			}
 		}
 	}
 	inode_sync_complete(inode);
@@ -459,7 +463,7 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
 	while (!list_empty(&wb->b_io)) {
 		long pages_skipped;
 		struct inode *inode = list_entry(wb->b_io.prev,
-						 struct inode, i_list);
+						 struct inode, i_io);
 
 		if (inode->i_sb != sb) {
 			if (only_this_sb) {
@@ -530,7 +534,7 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = list_entry(wb->b_io.prev,
-						 struct inode, i_list);
+						 struct inode, i_io);
 		struct super_block *sb = inode->i_sb;
 
 		if (!pin_sb_for_writeback(sb)) {
@@ -669,7 +673,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 		spin_lock(&inode_lock);
 		if (!list_empty(&wb->b_more_io))  {
 			inode = list_entry(wb->b_more_io.prev,
-						struct inode, i_list);
+						struct inode, i_io);
 			trace_wbc_writeback_wait(&wbc, wb->bdi);
 			inode_wait_for_writeback(inode);
 		}
@@ -983,7 +987,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			}
 
 			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &bdi->wb.b_dirty);
+			list_move(&inode->i_io, &bdi->wb.b_dirty);
 		}
 	}
 out:
diff --git a/fs/inode.c b/fs/inode.c
index e76d398..98f8963 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -102,8 +102,8 @@ static DECLARE_RWSEM(iprune_sem);
  */
 struct inodes_stat_t inodes_stat;
 
-static struct percpu_counter nr_inodes __cacheline_aligned_in_smp;
-static struct percpu_counter nr_inodes_unused __cacheline_aligned_in_smp;
+struct percpu_counter nr_inodes __cacheline_aligned_in_smp;
+struct percpu_counter nr_inodes_unused __cacheline_aligned_in_smp;
 
 static struct kmem_cache *inode_cachep __read_mostly;
 
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
+	INIT_LIST_HEAD(&inode->i_io);
+	INIT_LIST_HEAD(&inode->i_lru);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
 	spin_lock_init(&inode->i_data.tree_lock);
 	spin_lock_init(&inode->i_data.i_mmap_lock);
@@ -361,8 +363,8 @@ static void dispose_list(struct list_head *head)
 	while (!list_empty(head)) {
 		struct inode *inode;
 
-		inode = list_first_entry(head, struct inode, i_list);
-		list_del_init(&inode->i_list);
+		inode = list_first_entry(head, struct inode, i_lru);
+		list_del_init(&inode->i_lru);
 
 		evict(inode);
 
@@ -405,7 +407,8 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 			continue;
 		invalidate_inode_buffers(inode);
 		if (!atomic_read(&inode->i_count)) {
-			list_move(&inode->i_list, dispose);
+			list_move(&inode->i_lru, dispose);
+			list_del_init(&inode->i_io);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			percpu_counter_dec(&nr_inodes_unused);
@@ -482,16 +485,16 @@ static void prune_icache(int nr_to_scan)
 		if (list_empty(&inode_unused))
 			break;
 
-		inode = list_entry(inode_unused.prev, struct inode, i_list);
+		inode = list_entry(inode_unused.prev, struct inode, i_lru);
 
 		if (atomic_read(&inode->i_count) ||
 		    (inode->i_state & ~I_REFERENCED)) {
-			list_del_init(&inode->i_list);
+			list_del_init(&inode->i_lru);
 			percpu_counter_dec(&nr_inodes_unused);
 			continue;
 		}
 		if (inode->i_state & I_REFERENCED) {
-			list_move(&inode->i_list, &inode_unused);
+			list_move(&inode->i_lru, &inode_unused);
 			inode->i_state &= ~I_REFERENCED;
 			continue;
 		}
@@ -510,11 +513,12 @@ static void prune_icache(int nr_to_scan)
 			 * on it.
 			 */
 			if (!can_unuse(inode)) {
-				list_move(&inode->i_list, &inode_unused);
+				list_move(&inode->i_lru, &inode_unused);
 				continue;
 			}
 		}
-		list_move(&inode->i_list, &freeable);
+		list_move(&inode->i_lru, &freeable);
+		list_del_init(&inode->i_io);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
 		percpu_counter_dec(&nr_inodes_unused);
@@ -1245,8 +1249,9 @@ static void iput_final(struct inode *inode)
 	if (!drop) {
 		if (sb->s_flags & MS_ACTIVE) {
 			inode->i_state |= I_REFERENCED;
-			if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
-				list_move(inode->i_list, &inode_unused);
+			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
+			    list_empty(&inode->i_lru)) {
+				list_add(&inode->i_lru, &inode_unused);
 				percpu_counter_inc(&nr_inodes_unused);
 			}
 			spin_unlock(&inode_lock);
@@ -1261,6 +1266,7 @@ static void iput_final(struct inode *inode)
 		inode->i_state &= ~I_WILL_FREE;
 		hlist_del_init(&inode->i_hash);
 	}
+	list_del_init(&inode->i_io);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 
@@ -1269,8 +1275,8 @@ static void iput_final(struct inode *inode)
 	 * is set and hence writeback_single_inode() won't move the inode
 	 * around.
 	 */
-	if (!list_empty(&inode->i_list)) {
-		list_del_init(&inode->i_list);
+	if (!list_empty(&inode->i_lru)) {
+		list_del_init(&inode->i_lru);
 		percpu_counter_dec(&nr_inodes_unused);
 	}
 
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 7713861..2ee524f 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -504,7 +504,8 @@ nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
 #endif
 		inode->dirtied_when = 0;
 
-		INIT_LIST_HEAD(&inode->i_list);
+		INIT_LIST_HEAD(&inode->i_io);
+		INIT_LIST_HEAD(&inode->i_lru);
 		INIT_LIST_HEAD(&inode->i_sb_list);
 		inode->i_state = 0;
 #endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8ff7b6b..11c7ad4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -725,7 +725,8 @@ struct posix_acl;
 
 struct inode {
 	struct hlist_node	i_hash;
-	struct list_head	i_list;		/* backing dev IO list */
+	struct list_head	i_io;		/* backing dev IO list */
+	struct list_head	i_lru;		/* backing dev IO list */
 	struct list_head	i_sb_list;
 	struct list_head	i_dentry;
 	unsigned long		i_ino;
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index f956b66..f7ed2a0 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -12,6 +12,9 @@ struct backing_dev_info;
 extern spinlock_t inode_lock;
 extern struct list_head inode_unused;
 
+extern struct percpu_counter nr_inodes;
+extern struct percpu_counter nr_inodes_unused;
+
 /*
  * fs/fs-writeback.c
  */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0188d99..a124991 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -74,11 +74,11 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
 	spin_lock(&inode_lock);
-	list_for_each_entry(inode, &wb->b_dirty, i_list)
+	list_for_each_entry(inode, &wb->b_dirty, i_io)
 		nr_dirty++;
-	list_for_each_entry(inode, &wb->b_io, i_list)
+	list_for_each_entry(inode, &wb->b_io, i_io)
 		nr_io++;
-	list_for_each_entry(inode, &wb->b_more_io, i_list)
+	list_for_each_entry(inode, &wb->b_more_io, i_io)
 		nr_more_io++;
 	spin_unlock(&inode_lock);
 
@@ -681,27 +681,27 @@ void mapping_set_bdi(struct address_space *mapping,
 		return;
 
 	spin_lock(&inode_lock);
-	if (!list_empty(&inode->i_list)) {
+	if (!list_empty(&inode->i_io)) {
 		struct inode *i;
 
-		list_for_each_entry(i, &old->wb.b_dirty, i_list) {
+		list_for_each_entry(i, &old->wb.b_dirty, i_io) {
 			if (inode == i) {
-				list_del(&inode->i_list);
-				list_add(&inode->i_list, &bdi->wb.b_dirty);
+				list_del(&inode->i_io);
+				list_add(&inode->i_io, &bdi->wb.b_dirty);
 				goto found;
 			}
 		}
-		list_for_each_entry(i, &old->wb.b_io, i_list) {
+		list_for_each_entry(i, &old->wb.b_io, i_io) {
 			if (inode == i) {
-				list_del(&inode->i_list);
-				list_add(&inode->i_list, &bdi->wb.b_io);
+				list_del(&inode->i_io);
+				list_add(&inode->i_io, &bdi->wb.b_io);
 				goto found;
 			}
 		}
-		list_for_each_entry(i, &old->wb.b_more_io, i_list) {
+		list_for_each_entry(i, &old->wb.b_more_io, i_io) {
 			if (inode == i) {
-				list_del(&inode->i_list);
-				list_add(&inode->i_list, &bdi->wb.b_more_io);
+				list_del(&inode->i_io);
+				list_add(&inode->i_io, &bdi->wb.b_more_io);
 				goto found;
 			}
 		}
@@ -726,19 +726,19 @@ void bdi_destroy(struct backing_dev_info *bdi)
 		struct inode *i, *tmp;
 
 		spin_lock(&inode_lock);
-		list_for_each_entry_safe(i, tmp, &bdi->wb.b_dirty, i_list) {
-			list_del(&i->i_list);
-			list_add_tail(&i->i_list, &dst->b_dirty);
+		list_for_each_entry_safe(i, tmp, &bdi->wb.b_dirty, i_io) {
+			list_del(&i->i_io);
+			list_add_tail(&i->i_io, &dst->b_dirty);
 			i->i_mapping->a_bdi = bdi;
 		}
-		list_for_each_entry_safe(i, tmp, &bdi->wb.b_io, i_list) {
-			list_del(&i->i_list);
-			list_add_tail(&i->i_list, &dst->b_io);
+		list_for_each_entry_safe(i, tmp, &bdi->wb.b_io, i_io) {
+			list_del(&i->i_io);
+			list_add_tail(&i->i_io, &dst->b_io);
 			i->i_mapping->a_bdi = bdi;
 		}
-		list_for_each_entry_safe(i, tmp, &bdi->wb.b_more_io, i_list) {
-			list_del(&i->i_list);
-			list_add_tail(&i->i_list, &dst->b_more_io);
+		list_for_each_entry_safe(i, tmp, &bdi->wb.b_more_io, i_io) {
+			list_del(&i->i_io);
+			list_add_tail(&i->i_io, &dst->b_more_io);
 			i->i_mapping->a_bdi = bdi;
 		}
 		spin_unlock(&inode_lock);
-- 
1.7.1

