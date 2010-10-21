Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab0JUNYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:24:42 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:7306 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758012Ab0JUNWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+FSgSKTQ
Message-Id: <20101021131017.274548424@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:42 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 13/14] fs: icache split IO and LRU lists
References: <20101021130829.442910807@kernel.dk>
Content-Disposition: inline; filename=fs-inode-split-lists.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split inode reclaim and writeback lists in preparation to scale them up
(per-bdi locking for i_io and per-zone locking for i_lru)

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/fs-writeback.c         |   27 ++++++-------
 fs/inode.c                |   91 +++++++++++++++++++++++++++-------------------
 fs/internal.h             |    2 -
 fs/nilfs2/mdt.c           |    3 +
 include/linux/fs.h        |    3 +
 include/linux/writeback.h |    1 
 mm/backing-dev.c          |    6 +--
 7 files changed, 74 insertions(+), 59 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-21 23:50:27.000000000 +1100
@@ -173,11 +173,11 @@ static void redirty_tail(struct inode *i
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
@@ -188,7 +188,7 @@ static void requeue_io(struct inode *ino
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
 	assert_spin_locked(&wb_inode_list_lock);
-	list_move(&inode->i_list, &wb->b_more_io);
+	list_move(&inode->i_io, &wb->b_more_io);
 }
 
 static void inode_sync_complete(struct inode *inode)
@@ -230,14 +230,14 @@ static void move_expired_inodes(struct l
 
 	assert_spin_locked(&wb_inode_list_lock);
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
@@ -248,12 +248,12 @@ static void move_expired_inodes(struct l
 
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
@@ -420,8 +420,7 @@ writeback_single_inode(struct inode *ino
 			/*
 			 * The inode is clean
 			 */
-			list_move(&inode->i_list, &inode_unused);
-			atomic_inc(&nr_unused);
+			list_del_init(&inode->i_io);
 		}
 	}
 	inode_sync_complete(inode);
@@ -471,7 +470,7 @@ static int writeback_sb_inodes(struct su
 	while (!list_empty(&wb->b_io)) {
 		long pages_skipped;
 		struct inode *inode = list_entry(wb->b_io.prev,
-						 struct inode, i_list);
+						 struct inode, i_io);
 
 		if (!spin_trylock(&inode->i_lock)) {
 			spin_unlock(&wb_inode_list_lock);
@@ -558,7 +557,7 @@ void writeback_inodes_wb(struct bdi_writ
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = list_entry(wb->b_io.prev,
-						 struct inode, i_list);
+						 struct inode, i_io);
 		struct super_block *sb = inode->i_sb;
 
 		if (!pin_sb_for_writeback(sb)) {
@@ -704,7 +703,7 @@ static long wb_writeback(struct bdi_writ
 		spin_lock(&wb_inode_list_lock);
 		if (!list_empty(&wb->b_more_io))  {
 			inode = list_entry(wb->b_more_io.prev,
-						struct inode, i_list);
+						struct inode, i_io);
 			if (!spin_trylock(&inode->i_lock)) {
 				spin_unlock(&wb_inode_list_lock);
 				cpu_relax();
@@ -1025,7 +1024,7 @@ void __mark_inode_dirty(struct inode *in
 
 			inode->dirtied_when = jiffies;
 			spin_lock(&wb_inode_list_lock);
-			list_move(&inode->i_list, &bdi->wb.b_dirty);
+			list_move(&inode->i_io, &bdi->wb.b_dirty);
 			spin_unlock(&wb_inode_list_lock);
 		}
 	}
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-21 23:50:27.000000000 +1100
@@ -725,7 +725,8 @@ struct posix_acl;
 
 struct inode {
 	struct hlist_node	i_hash;
-	struct list_head	i_list;		/* backing dev IO list */
+	struct list_head	i_io;		/* backing dev IO list */
+	struct list_head	i_lru;		/* inode LRU list */
 	struct list_head	i_sb_list;
 	struct list_head	i_dentry;
 	unsigned long		i_ino;
Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/mm/backing-dev.c	2010-10-21 23:50:27.000000000 +1100
@@ -74,11 +74,11 @@ static int bdi_debug_stats_show(struct s
 
 	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
 	spin_lock(&wb_inode_list_lock);
-	list_for_each_entry(inode, &wb->b_dirty, i_list)
+	list_for_each_entry(inode, &wb->b_dirty, i_io)
 		nr_dirty++;
-	list_for_each_entry(inode, &wb->b_io, i_list)
+	list_for_each_entry(inode, &wb->b_io, i_io)
 		nr_io++;
-	list_for_each_entry(inode, &wb->b_more_io, i_list)
+	list_for_each_entry(inode, &wb->b_more_io, i_io)
 		nr_more_io++;
 	spin_unlock(&wb_inode_list_lock);
 
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-21 23:50:38.000000000 +1100
@@ -33,14 +33,15 @@
  *   i_count
  *   i_state
  *   i_hash
- *   i_list
+ *   i_lru
+ *   i_io
  *   i_sb_list
  * sb_inode_list_lock protects:
  *   s_inodes, i_sb_list
  * inode_hash_lock protects:
  *   inode hash table, i_hash
  * wb_inode_list_lock protects:
- *   inode_unused, b_io, b_more_io, b_dirty, i_list
+ *   inode_lru, b_io, b_more_io, b_dirty, i_lru, i_io
  *
  * Ordering:
  * i_lock
@@ -95,7 +96,7 @@ static unsigned int i_hash_shift __read_
  * allowing for low-overhead inode sync() operations.
  */
 
-LIST_HEAD(inode_unused);
+static LIST_HEAD(inode_lru);
 static struct hlist_head *inode_hashtable __read_mostly;
 
 /*
@@ -298,6 +299,7 @@ EXPORT_SYMBOL(__destroy_inode);
 
 void destroy_inode(struct inode *inode)
 {
+	BUG_ON(!list_empty(&inode->i_io));
 	__destroy_inode(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
@@ -316,7 +318,8 @@ void inode_init_once(struct inode *inode
 	INIT_HLIST_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
-	INIT_LIST_HEAD(&inode->i_list);
+	INIT_LIST_HEAD(&inode->i_io);
+	INIT_LIST_HEAD(&inode->i_lru);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
 	spin_lock_init(&inode->i_data.tree_lock);
 	spin_lock_init(&inode->i_data.i_mmap_lock);
@@ -388,6 +391,35 @@ static void evict(struct inode *inode)
 		cd_forget(inode);
 }
 
+static void insert_inode_lru(struct inode *inode)
+{
+	if (list_empty(&inode->i_lru)) {
+		spin_lock(&wb_inode_list_lock);
+		list_add(&inode->i_lru, &inode_lru);
+		spin_unlock(&wb_inode_list_lock);
+		atomic_inc(&nr_unused);
+	}
+}
+
+static void remove_inode_lru(struct inode *inode)
+{
+	if (!list_empty(&inode->i_lru)) {
+		spin_lock(&wb_inode_list_lock);
+		list_del_init(&inode->i_lru);
+		spin_unlock(&wb_inode_list_lock);
+		atomic_dec(&nr_unused);
+	}
+}
+
+static void remove_inode_io(struct inode *inode)
+{
+	if (!list_empty(&inode->i_io)) {
+		spin_lock(&wb_inode_list_lock);
+		list_del_init(&inode->i_io);
+		spin_unlock(&wb_inode_list_lock);
+	}
+}
+
 static void __remove_inode_hash(struct inode *inode);
 
 /*
@@ -405,8 +437,8 @@ static void dispose_list(struct list_hea
 		struct inode *inode;
 
 		/* No locking here, it's a private list now */
-		inode = list_first_entry(head, struct inode, i_list);
-		list_del_init(&inode->i_list);
+		inode = list_first_entry(head, struct inode, i_lru);
+		list_del_init(&inode->i_lru);
 
 		evict(inode);
 
@@ -454,17 +486,12 @@ static int invalidate_list(struct super_
 		}
 		invalidate_inode_buffers(inode);
 		if (!inode->i_count) {
-			if (!list_empty(&inode->i_list)) {
-				spin_lock(&wb_inode_list_lock);
-				list_del(&inode->i_list);
-				spin_unlock(&wb_inode_list_lock);
-				if (!(inode->i_state & (I_DIRTY|I_SYNC)))
-					atomic_dec(&nr_unused);
-			}
+			remove_inode_lru(inode);
+			remove_inode_io(inode);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			spin_unlock(&inode->i_lock);
-			list_add(&inode->i_list, dispose);
+			list_add(&inode->i_lru, dispose);
 			count++;
 			continue;
 		}
@@ -518,7 +545,7 @@ static int can_unuse(struct inode *inode
  *
  * Any inodes which are pinned purely because of attached pagecache have their
  * pagecache removed.  We expect the final iput() on that inode to add it to
- * the front of the inode_unused list.  So look for it there and if the
+ * the front of the inode_lru list.  So look for it there and if the
  * inode is still freeable, proceed.  The right inode is found 99.9% of the
  * time in testing on a 4-way.
  *
@@ -538,10 +565,10 @@ static void prune_icache(int nr_to_scan)
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
 
-		if (list_empty(&inode_unused))
+		if (list_empty(&inode_lru))
 			break;
 
-		inode = list_entry(inode_unused.prev, struct inode, i_list);
+		inode = list_entry(inode_lru.prev, struct inode, i_lru);
 
 		if (!spin_trylock(&inode->i_lock)) {
 			spin_unlock(&wb_inode_list_lock);
@@ -550,13 +577,13 @@ static void prune_icache(int nr_to_scan)
 		}
 
 		if (inode->i_count || (inode->i_state & ~I_REFERENCED)) {
-			list_del_init(&inode->i_list);
+			list_del_init(&inode->i_lru);
 			spin_unlock(&inode->i_lock);
 			atomic_dec(&nr_unused);
 			continue;
 		}
 		if (inode->i_state & I_REFERENCED) {
-			list_move(&inode->i_list, &inode_unused);
+			list_move(&inode->i_lru, &inode_lru);
 			inode->i_state &= ~I_REFERENCED;
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -569,7 +596,7 @@ static void prune_icache(int nr_to_scan)
 			 *
 			 * We'll try to get it back if it becomes freeable.
 			 */
-			list_move(&inode->i_list, &inode_unused);
+			list_move(&inode->i_lru, &inode_lru);
 			inode->i_count++;
 			spin_unlock(&wb_inode_list_lock);
 			spin_unlock(&inode->i_lock);
@@ -585,8 +612,8 @@ static void prune_icache(int nr_to_scan)
 				goto lock_again_2;
 			}
 
-			if (inode != list_entry(inode_unused.next,
-						struct inode, i_list)) {
+			if (inode != list_entry(inode_lru.next,
+						struct inode, i_lru)) {
 				spin_unlock(&inode->i_lock);
 				continue;	/* wrong inode or list_empty */
 			}
@@ -595,7 +622,7 @@ static void prune_icache(int nr_to_scan)
 				continue;
 			}
 		}
-		list_move(&inode->i_list, &freeable);
+		list_move(&inode->i_lru, &freeable);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
 		spin_unlock(&inode->i_lock);
@@ -1420,13 +1447,8 @@ static void iput_final(struct inode *ino
 	if (!drop) {
 		if (sb->s_flags & MS_ACTIVE) {
 			inode->i_state |= I_REFERENCED;
-			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
-					list_empty(&inode->i_list)) {
-				spin_lock(&wb_inode_list_lock);
-				list_add(&inode->i_list, &inode_unused);
-				spin_unlock(&wb_inode_list_lock);
-				atomic_inc(&nr_unused);
-			}
+			if (!(inode->i_state & (I_DIRTY|I_SYNC)))
+				insert_inode_lru(inode);
 			spin_unlock(&inode->i_lock);
 			return;
 		}
@@ -1439,13 +1461,8 @@ static void iput_final(struct inode *ino
 		inode->i_state &= ~I_WILL_FREE;
 		__remove_inode_hash(inode);
 	}
-	if (!list_empty(&inode->i_list)) {
-		spin_lock(&wb_inode_list_lock);
-		list_del_init(&inode->i_list);
-		spin_unlock(&wb_inode_list_lock);
-		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
-			atomic_dec(&nr_unused);
-	}
+	remove_inode_lru(inode);
+	remove_inode_io(inode);
 	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
Index: linux-2.6/fs/nilfs2/mdt.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/mdt.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/nilfs2/mdt.c	2010-10-21 23:50:27.000000000 +1100
@@ -504,7 +504,8 @@ nilfs_mdt_new_common(struct the_nilfs *n
 #endif
 		inode->dirtied_when = 0;
 
-		INIT_LIST_HEAD(&inode->i_list);
+		INIT_LIST_HEAD(&inode->i_io);
+		INIT_LIST_HEAD(&inode->i_lru);
 		INIT_LIST_HEAD(&inode->i_sb_list);
 		inode->i_state = 0;
 #endif
Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/internal.h	2010-10-21 23:50:27.000000000 +1100
@@ -45,8 +45,6 @@ static inline int __sync_blockdev(struct
 }
 #endif
 
-extern atomic_t nr_unused;
-
 /*
  * char_dev.c
  */
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/include/linux/writeback.h	2010-10-21 23:50:27.000000000 +1100
@@ -11,7 +11,6 @@ struct backing_dev_info;
 
 extern spinlock_t sb_inode_list_lock;
 extern spinlock_t wb_inode_list_lock;
-extern struct list_head inode_unused;
 
 /*
  * fs/fs-writeback.c


