Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab0FXDRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:17:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:48488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229Ab0FXDP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:58 -0400
Message-Id: <20100624030733.354313412@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:03:00 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 48/52] fs: icache split IO and LRU lists
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode-split-lists.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split inode reclaim and writeback lists in preparation to scale them up
(per-bdi locking for i_io and per-zone locking for i_lru)

Signed-off-by: Nick Piggin <npiggin@suse.de>
--
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -291,11 +291,11 @@ static void redirty_tail(struct inode *i
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
@@ -306,7 +306,7 @@ static void requeue_io(struct inode *ino
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
 	assert_spin_locked(&wb_inode_list_lock);
-	list_move(&inode->i_list, &wb->b_more_io);
+	list_move(&inode->i_io, &wb->b_more_io);
 }
 
 static void inode_sync_complete(struct inode *inode)
@@ -348,14 +348,14 @@ static void move_expired_inodes(struct l
 
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
@@ -366,12 +366,12 @@ static void move_expired_inodes(struct l
 
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
@@ -556,7 +556,11 @@ select_queue:
 			}
 		} else {
 			/* The inode is clean */
-			list_move(&inode->i_list, &inode_unused);
+			list_del_init(&inode->i_io);
+			if (list_empty(&inode->i_lru)) {
+				list_add(&inode->i_lru, &inode_unused);
+				inodes_stat.nr_unused++;
+			}
 		}
 	}
 	inode_sync_complete(inode);
@@ -623,7 +627,7 @@ again:
 	while (!list_empty(&wb->b_io)) {
 		long pages_skipped;
 		struct inode *inode = list_entry(wb->b_io.prev,
-						 struct inode, i_list);
+						 struct inode, i_io);
 		if (!spin_trylock(&inode->i_lock)) {
 			spin_unlock(&wb_inode_list_lock);
 			spin_lock(&wb_inode_list_lock);
@@ -696,7 +700,7 @@ again:
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = list_entry(wb->b_io.prev,
-						 struct inode, i_list);
+						 struct inode, i_io);
 		struct super_block *sb = inode->i_sb;
 		enum sb_pin_state state;
 
@@ -845,7 +849,7 @@ retry:
 		spin_lock(&wb_inode_list_lock);
 		if (!list_empty(&wb->b_more_io))  {
 			inode = list_entry(wb->b_more_io.prev,
-						struct inode, i_list);
+						struct inode, i_io);
 			if (!spin_trylock(&inode->i_lock)) {
 				spin_unlock(&wb_inode_list_lock);
 				goto retry;
@@ -1164,7 +1168,7 @@ void __mark_inode_dirty(struct inode *in
 
 			inode->dirtied_when = jiffies;
 			spin_lock(&wb_inode_list_lock);
-			list_move(&inode->i_list, &wb->b_dirty);
+			list_move(&inode->i_io, &wb->b_dirty);
 			spin_unlock(&wb_inode_list_lock);
 		}
 	}
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -726,7 +726,8 @@ struct posix_acl;
 
 struct inode {
 	struct hlist_bl_node	i_hash;
-	struct list_head	i_list;		/* backing dev IO list */
+	struct list_head	i_io;		/* backing dev IO list */
+	struct list_head	i_lru;
 	struct list_head	i_sb_list;
 	union {
 		struct list_head	i_dentry;
Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c
+++ linux-2.6/mm/backing-dev.c
@@ -80,11 +80,11 @@ static int bdi_debug_stats_show(struct s
 	spin_lock(&wb_inode_list_lock);
 	list_for_each_entry(wb, &bdi->wb_list, list) {
 		nr_wb++;
-		list_for_each_entry(inode, &wb->b_dirty, i_list)
+		list_for_each_entry(inode, &wb->b_dirty, i_io)
 			nr_dirty++;
-		list_for_each_entry(inode, &wb->b_io, i_list)
+		list_for_each_entry(inode, &wb->b_io, i_io)
 			nr_io++;
-		list_for_each_entry(inode, &wb->b_more_io, i_list)
+		list_for_each_entry(inode, &wb->b_more_io, i_io)
 			nr_more_io++;
 	}
 	spin_unlock(&wb_inode_list_lock);
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -35,12 +35,13 @@
  * inode_hash_bucket lock protects:
  *   inode hash table, i_hash
  * wb_inode_list_lock protects:
- *   inode_in_use, inode_unused, b_io, b_more_io, b_dirty, i_list
+ *   inode_in_use, inode_unused, b_io, b_more_io, b_dirty, i_io, i_lru
  * inode->i_lock protects:
  *   i_state
  *   i_count
  *   i_hash
- *   i_list
+ *   i_io
+ *   i_lru
  *   i_sb_list
  *
  * Ordering:
@@ -313,6 +314,7 @@ static void i_callback(struct rcu_head *
 
 void destroy_inode(struct inode *inode)
 {
+	BUG_ON(!list_empty(&inode->i_io));
 	__destroy_inode(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
@@ -331,7 +333,8 @@ void inode_init_once(struct inode *inode
 	INIT_HLIST_BL_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
-	INIT_LIST_HEAD(&inode->i_list);
+	INIT_LIST_HEAD(&inode->i_io);
+	INIT_LIST_HEAD(&inode->i_lru);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
 	spin_lock_init(&inode->i_data.tree_lock);
 	spin_lock_init(&inode->i_data.i_mmap_lock);
@@ -401,8 +404,8 @@ static void dispose_list(struct list_hea
 	while (!list_empty(head)) {
 		struct inode *inode;
 
-		inode = list_first_entry(head, struct inode, i_list);
-		list_del_init(&inode->i_list);
+		inode = list_first_entry(head, struct inode, i_lru);
+		list_del_init(&inode->i_lru);
 
 		if (inode->i_data.nrpages)
 			truncate_inode_pages(&inode->i_data, 0);
@@ -436,13 +439,14 @@ static int invalidate_sb_inodes(struct s
 		invalidate_inode_buffers(inode);
 		if (!inode->i_count) {
 			spin_lock(&wb_inode_list_lock);
-			list_del(&inode->i_list);
+			list_del_init(&inode->i_io);
+			list_del(&inode->i_lru);
 			inodes_stat.nr_unused--;
 			spin_unlock(&wb_inode_list_lock);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			spin_unlock(&inode->i_lock);
-			list_add(&inode->i_list, dispose);
+			list_add(&inode->i_lru, dispose);
 			continue;
 		}
 		spin_unlock(&inode->i_lock);
@@ -511,26 +515,26 @@ again:
 		if (list_empty(&inode_unused))
 			break;
 
-		inode = list_entry(inode_unused.prev, struct inode, i_list);
+		inode = list_entry(inode_unused.prev, struct inode, i_lru);
 
 		if (!spin_trylock(&inode->i_lock)) {
 			spin_unlock(&wb_inode_list_lock);
 			goto again;
 		}
 		if (inode->i_count || (inode->i_state & ~I_REFERENCED)) {
-			list_del_init(&inode->i_list);
+			list_del_init(&inode->i_lru);
 			spin_unlock(&inode->i_lock);
 			inodes_stat.nr_unused--;
 			continue;
 		}
 		if (inode->i_state) {
-			list_move(&inode->i_list, &inode_unused);
+			list_move(&inode->i_lru, &inode_unused);
 			inode->i_state &= ~I_REFERENCED;
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
-			list_move(&inode->i_list, &inode_unused);
+			list_move(&inode->i_lru, &inode_unused);
 			spin_unlock(&wb_inode_list_lock);
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
@@ -542,7 +546,7 @@ again:
 			spin_lock(&wb_inode_list_lock);
 			continue;
 		}
-		list_move(&inode->i_list, &freeable);
+		list_move(&inode->i_lru, &freeable);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
 		spin_unlock(&inode->i_lock);
@@ -1395,11 +1399,15 @@ void generic_delete_inode(struct inode *
 {
 	const struct super_operations *op = inode->i_sb->s_op;
 
-	if (!list_empty(&inode->i_list)) {
+	if (!list_empty(&inode->i_lru)) {
 		spin_lock(&wb_inode_list_lock);
-		list_del_init(&inode->i_list);
-		if (!inode->i_state)
-			inodes_stat.nr_unused--;
+		list_del_init(&inode->i_lru);
+		inodes_stat.nr_unused--;
+		spin_unlock(&wb_inode_list_lock);
+	}
+	if (!list_empty(&inode->i_io)) {
+		spin_lock(&wb_inode_list_lock);
+		list_del_init(&inode->i_io);
 		spin_unlock(&wb_inode_list_lock);
 	}
 	inode_sb_list_del(inode);
@@ -1451,9 +1459,9 @@ int generic_detach_inode(struct inode *i
 		if (sb->s_flags & MS_ACTIVE) {
 			inode->i_state |= I_REFERENCED;
 			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
-					list_empty(&inode->i_list)) {
+					list_empty(&inode->i_lru)) {
 				spin_lock(&wb_inode_list_lock);
-				list_add(&inode->i_list, &inode_unused);
+				list_add(&inode->i_lru, &inode_unused);
 				inodes_stat.nr_unused++;
 				spin_unlock(&wb_inode_list_lock);
 			}
@@ -1469,11 +1477,15 @@ int generic_detach_inode(struct inode *i
 		inode->i_state &= ~I_WILL_FREE;
 		__remove_inode_hash(inode);
 	}
-	if (!list_empty(&inode->i_list)) {
+	if (!list_empty(&inode->i_lru)) {
 		spin_lock(&wb_inode_list_lock);
-		list_del_init(&inode->i_list);
-		if (!inode->i_state)
-			inodes_stat.nr_unused--;
+		list_del_init(&inode->i_lru);
+		inodes_stat.nr_unused--;
+		spin_unlock(&wb_inode_list_lock);
+	}
+	if (!list_empty(&inode->i_io)) {
+		spin_lock(&wb_inode_list_lock);
+		list_del_init(&inode->i_io);
 		spin_unlock(&wb_inode_list_lock);
 	}
 	inode_sb_list_del(inode);


