Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756Ab0JSD5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:57:03 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28444 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933525Ab0JSD4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSg
Message-Id: <20101019034658.426106232@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:44 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 28/35] fs: icache split writeback and lru locks
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode-split-wb-lru-locks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split wb_inode_list_lock lock into two locks, inode_lru_lock to protect
inode LRU list, and a per-bdi lock to protect the inode writeback lists.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/fs-writeback.c         |    6 +--
 fs/inode.c                |   73 ++++++++++++++++++++++++++++------------------
 include/linux/fs.h        |    2 +
 include/linux/writeback.h |    1 
 4 files changed, 50 insertions(+), 32 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:20.000000000 +1100
@@ -423,10 +423,8 @@
 			 * The inode is clean
 			 */
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
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:20.000000000 +1100
@@ -33,8 +33,10 @@
  *   s_inodes, i_sb_list
  * inode_hash_bucket lock protects:
  *   inode hash table, i_hash
+ * inode_lru_lock protects:
+ *   inode_lru, i_lru
  * wb_inode_list_lock protects:
- *   inode_in_use, inode_unused, b_io, b_more_io, b_dirty, i_io, i_lru
+ *   b_io, b_more_io, b_dirty, i_io, i_lru
  * inode->i_lock protects:
  *   i_state
  *   i_count
@@ -46,6 +48,7 @@
  * Ordering:
  * inode->i_lock
  *   inode_list_lglock
+ *   inode_lru_lock
  *   wb_inode_list_lock
  *   inode_hash_bucket lock
  */
@@ -96,7 +99,7 @@
  * allowing for low-overhead inode sync() operations.
  */
 
-LIST_HEAD(inode_unused);
+static LIST_HEAD(inode_lru);
 
 struct inode_hash_bucket {
 	struct hlist_bl_head head;
@@ -124,6 +127,7 @@
 DEFINE_LGLOCK(inode_list_lglock);
 
 DEFINE_SPINLOCK(wb_inode_list_lock);
+static DEFINE_SPINLOCK(inode_lru_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -432,6 +436,28 @@
 }
 
 /*
+ * Add an inode to the LRU list. i_lock must be held.
+ */
+void __inode_lru_list_add(struct inode *inode)
+{
+	spin_lock(&inode_lru_lock);
+	list_add(&inode->i_lru, &inode_lru);
+	inodes_stat.nr_unused++;
+	spin_unlock(&inode_lru_lock);
+}
+
+/*
+ * Remove an inode from the LRU list. i_lock must be held.
+ */
+void __inode_lru_list_del(struct inode *inode)
+{
+	spin_lock(&inode_lru_lock);
+	list_del_init(&inode->i_lru);
+	inodes_stat.nr_unused--;
+	spin_unlock(&inode_lru_lock);
+}
+
+/*
  * Invalidate all inodes for a device.
  */
 static int invalidate_sb_inodes(struct super_block *sb, struct list_head *dispose)
@@ -449,9 +475,10 @@
 		if (!inode->i_count) {
 			spin_lock(&wb_inode_list_lock);
 			list_del_init(&inode->i_io);
-			list_del(&inode->i_lru);
-			inodes_stat.nr_unused--;
 			spin_unlock(&wb_inode_list_lock);
+
+			__inode_lru_list_del(inode);
+
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			spin_unlock(&inode->i_lock);
@@ -513,7 +540,7 @@
  *
  * Any inodes which are pinned purely because of attached pagecache have their
  * pagecache removed.  We expect the final iput() on that inode to add it to
- * the front of the inode_unused list.  So look for it there and if the
+ * the front of the inode_lru list.  So look for it there and if the
  * inode is still freeable, proceed.  The right inode is found 99.9% of the
  * time in testing on a 4-way.
  *
@@ -527,17 +554,17 @@
 
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
@@ -547,7 +574,7 @@
 			continue;
 		}
 		if (inode->i_state & I_REFERENCED) {
-			list_move(&inode->i_lru, &inode_unused);
+			list_move(&inode->i_lru, &inode_lru);
 			inode->i_state &= ~I_REFERENCED;
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -560,8 +587,8 @@
 			 *
 			 * We'll try to get it back if it becomes freeable.
 			 */
-			list_move(&inode->i_lru, &inode_unused);
-			spin_unlock(&wb_inode_list_lock);
+			list_move(&inode->i_lru, &inode_lru);
+			spin_unlock(&inode_lru_lock);
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
 
@@ -569,8 +596,8 @@
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
-			spin_lock(&wb_inode_list_lock);
-			if (inode == list_entry(inode_unused.next,
+			spin_lock(&inode_lru_lock);
+			if (inode == list_entry(inode_lru.next,
 						struct inode, i_lru)) {
 				if (spin_trylock(&inode->i_lock)) {
 					if (can_unuse(inode))
@@ -591,7 +618,7 @@
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
 		__count_vm_events(PGINODESTEAL, reap);
-	spin_unlock(&wb_inode_list_lock);
+	spin_unlock(&inode_lru_lock);
 
 	dispose_list(&freeable);
 	up_read(&iprune_sem);
@@ -1512,12 +1539,8 @@
 		if (sb->s_flags & MS_ACTIVE) {
 			inode->i_state |= I_REFERENCED;
 			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
-					list_empty(&inode->i_lru)) {
-				spin_lock(&wb_inode_list_lock);
-				list_add(&inode->i_lru, &inode_unused);
-				inodes_stat.nr_unused++;
-				spin_unlock(&wb_inode_list_lock);
-			}
+					list_empty(&inode->i_lru))
+				__inode_lru_list_add(inode);
 			spin_unlock(&inode->i_lock);
 			return;
 		}
@@ -1530,12 +1553,8 @@
 		inode->i_state &= ~I_WILL_FREE;
 		__remove_inode_hash(inode);
 	}
-	if (!list_empty(&inode->i_lru)) {
-		spin_lock(&wb_inode_list_lock);
-		list_del_init(&inode->i_lru);
-		inodes_stat.nr_unused--;
-		spin_unlock(&wb_inode_list_lock);
-	}
+	if (!list_empty(&inode->i_lru))
+		__inode_lru_list_del(inode);
 	if (!list_empty(&inode->i_io)) {
 		spin_lock(&wb_inode_list_lock);
 		list_del_init(&inode->i_io);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-19 14:19:18.000000000 +1100
@@ -2088,6 +2088,8 @@
 extern int __invalidate_device(struct block_device *);
 extern int invalidate_partition(struct gendisk *, int);
 #endif
+extern void __inode_lru_list_add(struct inode *inode);
+extern void __inode_lru_list_del(struct inode *inode);
 extern int invalidate_inodes(struct super_block *);
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/include/linux/writeback.h	2010-10-19 14:19:20.000000000 +1100
@@ -10,7 +10,6 @@
 struct backing_dev_info;
 
 extern spinlock_t wb_inode_list_lock;
-extern struct list_head inode_unused;
 
 /*
  * fs/fs-writeback.c


