Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0JSEBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:01:47 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28449 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933135Ab0JSD4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSg
Message-Id: <20101019034657.147371115@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:32 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 16/35] fs: icache lazy inode lru
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-10.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impelemnt lazy inode lru similarly to dcache. That is, avoid moving inode
around the LRU list in iget/iput operations and defer the refcount check
to reclaim-time. Use a flag, I_REFERENCED, to tell reclaim that iget has
touched the inode in the past.

This will reduce lock acquisition, and will also improve lock ordering
with subsequent patches.

The global inode_in_use list goes away, and !list_empty(&inode->i_list)
invariant goes away. 

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/fs-writeback.c         |    7 ---
 fs/inode.c                |   98 ++++++++++++++++++++++------------------------
 include/linux/fs.h        |   20 ++++++---
 include/linux/writeback.h |    1 
 4 files changed, 61 insertions(+), 65 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:29.000000000 +1100
@@ -94,7 +94,6 @@
  * allowing for low-overhead inode sync() operations.
  */
 
-LIST_HEAD(inode_in_use);
 LIST_HEAD(inode_unused);
 
 struct inode_hash_bucket {
@@ -299,6 +298,7 @@
 	INIT_HLIST_BL_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
+	INIT_LIST_HEAD(&inode->i_list);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
 	spin_lock_init(&inode->i_data.tree_lock);
 	spin_lock_init(&inode->i_data.i_mmap_lock);
@@ -320,25 +320,6 @@
 	inode_init_once(inode);
 }
 
-/*
- * i_lock must be held
- */
-void __iget(struct inode *inode)
-{
-	assert_spin_locked(&inode->i_lock);
-
-	inode->i_count++;
-	if (inode->i_count > 1)
-		return;
-
-	if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
-		spin_lock(&wb_inode_list_lock);
-		list_move(&inode->i_list, &inode_in_use);
-		spin_unlock(&wb_inode_list_lock);
-	}
-	atomic_dec(&inodes_stat.nr_unused);
-}
-
 void end_writeback(struct inode *inode)
 {
 	might_sleep();
@@ -383,7 +364,7 @@
 		struct inode *inode;
 
 		inode = list_first_entry(head, struct inode, i_list);
-		list_del(&inode->i_list);
+		list_del_init(&inode->i_list);
 
 		evict(inode);
 
@@ -432,11 +413,12 @@
 		invalidate_inode_buffers(inode);
 		if (!inode->i_count) {
 			spin_lock(&wb_inode_list_lock);
-			list_move(&inode->i_list, dispose);
+			list_del(&inode->i_list);
 			spin_unlock(&wb_inode_list_lock);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			spin_unlock(&inode->i_lock);
+			list_add(&inode->i_list, dispose);
 			count++;
 			continue;
 		}
@@ -476,7 +458,7 @@
 
 static int can_unuse(struct inode *inode)
 {
-	if (inode->i_state)
+	if (inode->i_state & ~I_REFERENCED)
 		return 0;
 	if (inode_has_buffers(inode))
 		return 0;
@@ -504,13 +486,12 @@
 {
 	LIST_HEAD(freeable);
 	int nr_pruned = 0;
-	int nr_scanned;
 	unsigned long reap = 0;
 
 	down_read(&iprune_sem);
 again:
 	spin_lock(&wb_inode_list_lock);
-	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
+	for (; nr_to_scan; nr_to_scan--) {
 		struct inode *inode;
 
 		if (list_empty(&inode_unused))
@@ -522,34 +503,47 @@
 			spin_unlock(&wb_inode_list_lock);
 			goto again;
 		}
-		if (inode->i_state || inode->i_count) {
+		if (inode->i_count || (inode->i_state & ~I_REFERENCED)) {
+			list_del_init(&inode->i_list);
+			spin_unlock(&inode->i_lock);
+			atomic_dec(&inodes_stat.nr_unused);
+			continue;
+		}
+		if (inode->i_state & I_REFERENCED) {
 			list_move(&inode->i_list, &inode_unused);
+			inode->i_state &= ~I_REFERENCED;
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
+			/*
+			 * Move back to the head of the unused list in case the
+			 * invalidations failed. Could improve this by going to
+			 * the head of the list only if invalidation fails.
+			 *
+			 * We'll try to get it back if it becomes freeable.
+			 */
+			list_move(&inode->i_list, &inode_unused);
 			spin_unlock(&wb_inode_list_lock);
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
+
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
-again2:
 			spin_lock(&wb_inode_list_lock);
-
-			if (inode != list_entry(inode_unused.next,
-						struct inode, i_list))
-				continue;	/* wrong inode or list_empty */
-			if (!spin_trylock(&inode->i_lock)) {
-				spin_unlock(&wb_inode_list_lock);
-				goto again2;
-			}
-			if (!can_unuse(inode)) {
-				spin_unlock(&inode->i_lock);
-				continue;
+			if (inode == list_entry(inode_unused.next,
+						struct inode, i_list)) {
+				if (spin_trylock(&inode->i_lock)) {
+					if (can_unuse(inode))
+						goto freeable;
+					spin_unlock(&inode->i_lock);
+				}
 			}
+			continue;
 		}
+freeable:
 		list_move(&inode->i_list, &freeable);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
@@ -695,9 +689,6 @@
 {
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
-	spin_lock(&wb_inode_list_lock);
-	list_add(&inode->i_list, &inode_in_use);
-	spin_unlock(&wb_inode_list_lock);
 	if (b) {
 		spin_lock_bucket(b);
 		hlist_bl_add_head(&inode->i_hash, &b->head);
@@ -1371,13 +1362,15 @@
 		drop = generic_drop_inode(inode);
 
 	if (!drop) {
-		if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
-			spin_lock(&wb_inode_list_lock);
-			list_move(&inode->i_list, &inode_unused);
-			spin_unlock(&wb_inode_list_lock);
-		}
-		atomic_inc(&inodes_stat.nr_unused);
 		if (sb->s_flags & MS_ACTIVE) {
+			inode->i_state |= I_REFERENCED;
+			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
+					list_empty(&inode->i_list)) {
+				spin_lock(&wb_inode_list_lock);
+				list_add(&inode->i_list, &inode_unused);
+				spin_unlock(&wb_inode_list_lock);
+				atomic_inc(&inodes_stat.nr_unused);
+			}
 			spin_unlock(&inode->i_lock);
 			spin_unlock(&sb_inode_list_lock);
 			return;
@@ -1392,11 +1385,14 @@
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		__remove_inode_hash(inode);
-		atomic_dec(&inodes_stat.nr_unused);
 	}
-	spin_lock(&wb_inode_list_lock);
-	list_del_init(&inode->i_list);
-	spin_unlock(&wb_inode_list_lock);
+	if (!list_empty(&inode->i_list)) {
+		spin_lock(&wb_inode_list_lock);
+		list_del_init(&inode->i_list);
+		spin_unlock(&wb_inode_list_lock);
+		if (!inode->i_state)
+			atomic_dec(&inodes_stat.nr_unused);
+	}
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-19 14:19:28.000000000 +1100
@@ -1637,16 +1637,17 @@
  *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  */
-#define I_DIRTY_SYNC		1
-#define I_DIRTY_DATASYNC	2
-#define I_DIRTY_PAGES		4
+#define I_DIRTY_SYNC		0x01
+#define I_DIRTY_DATASYNC	0x02
+#define I_DIRTY_PAGES		0x04
 #define __I_NEW			3
 #define I_NEW			(1 << __I_NEW)
-#define I_WILL_FREE		16
-#define I_FREEING		32
-#define I_CLEAR			64
+#define I_WILL_FREE		0x10
+#define I_FREEING		0x20
+#define I_CLEAR			0x40
 #define __I_SYNC		7
 #define I_SYNC			(1 << __I_SYNC)
+#define I_REFERENCED		0x100
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
@@ -2187,7 +2188,6 @@
 extern int insert_inode_locked(struct inode *);
 extern void unlock_new_inode(struct inode *);
 
-extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
 extern void end_writeback(struct inode *);
 extern void destroy_inode(struct inode *);
@@ -2401,6 +2401,12 @@
 extern void save_mount_options(struct super_block *sb, char *options);
 extern void replace_mount_options(struct super_block *sb, char *options);
 
+static inline void __iget(struct inode *inode)
+{
+	assert_spin_locked(&inode->i_lock);
+	inode->i_count++;
+}
+
 static inline ino_t parent_ino(struct dentry *dentry)
 {
 	ino_t res;
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:25.000000000 +1100
@@ -416,14 +416,9 @@
 			 * completion.
 			 */
 			redirty_tail(inode);
-		} else if (inode->i_count) {
-			/*
-			 * The inode is clean, inuse
-			 */
-			list_move(&inode->i_list, &inode_in_use);
 		} else {
 			/*
-			 * The inode is clean, unused
+			 * The inode is clean
 			 */
 			list_move(&inode->i_list, &inode_unused);
 		}
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/include/linux/writeback.h	2010-10-19 14:19:23.000000000 +1100
@@ -11,7 +11,6 @@
 
 extern spinlock_t sb_inode_list_lock;
 extern spinlock_t wb_inode_list_lock;
-extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
 /*


