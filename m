Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab0FXDYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:24:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab0FXDP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:59 -0400
Message-Id: <20100624030731.563540438@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:49 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 37/52] fs: icache lazy lru
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-10.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impelemnt lazy inode lru similarly to dcache. This will reduce lock
acquisition and will help to improve lock ordering subsequently.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/fs-writeback.c         |   21 +++++++--------
 fs/inode.c                |   61 +++++++++++++++++++---------------------------
 include/linux/fs.h        |    7 ++++-
 include/linux/writeback.h |    1 
 4 files changed, 42 insertions(+), 48 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -96,7 +96,6 @@ static unsigned int i_hash_shift __read_
  * allowing for low-overhead inode sync() operations.
  */
 
-LIST_HEAD(inode_in_use);
 LIST_HEAD(inode_unused);
 
 struct inode_hash_bucket {
@@ -298,6 +297,7 @@ void inode_init_once(struct inode *inode
 	INIT_HLIST_BL_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
+	INIT_LIST_HEAD(&inode->i_list);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
 	spin_lock_init(&inode->i_data.tree_lock);
 	spin_lock_init(&inode->i_data.i_mmap_lock);
@@ -323,25 +323,6 @@ static void init_once(void *foo)
 	inode_init_once(inode);
 }
 
-/*
- * inode_lock must be held
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
 /**
  * clear_inode - clear an inode
  * @inode: inode to clear
@@ -384,7 +365,7 @@ static void dispose_list(struct list_hea
 		struct inode *inode;
 
 		inode = list_first_entry(head, struct inode, i_list);
-		list_del(&inode->i_list);
+		list_del_init(&inode->i_list);
 
 		if (inode->i_data.nrpages)
 			truncate_inode_pages(&inode->i_data, 0);
@@ -437,11 +418,12 @@ static int invalidate_list(struct list_h
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
@@ -480,19 +462,6 @@ int invalidate_inodes(struct super_block
 }
 EXPORT_SYMBOL(invalidate_inodes);
 
-static int can_unuse(struct inode *inode)
-{
-	if (inode->i_state)
-		return 0;
-	if (inode_has_buffers(inode))
-		return 0;
-	if (inode->i_count)
-		return 0;
-	if (inode->i_data.nrpages)
-		return 0;
-	return 1;
-}
-
 /*
  * Scan `goal' inodes on the unused list for freeable ones. They are moved to
  * a temporary list and then are freed outside inode_lock by dispose_list().
@@ -510,13 +479,12 @@ static void prune_icache(int nr_to_scan)
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
@@ -528,33 +496,30 @@ again:
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
+		if (inode->i_state) {
 			list_move(&inode->i_list, &inode_unused);
+			inode->i_state &= ~I_REFERENCED;
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
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
-			}
+			continue;
 		}
 		list_move(&inode->i_list, &freeable);
 		WARN_ON(inode->i_state & I_NEW);
@@ -694,9 +659,6 @@ __inode_add_to_lists(struct super_block
 	atomic_inc(&inodes_stat.nr_inodes);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
-	spin_lock(&wb_inode_list_lock);
-	list_add(&inode->i_list, &inode_in_use);
-	spin_unlock(&wb_inode_list_lock);
 	if (b) {
 		spin_lock_bucket(b);
 		hlist_bl_add_head(&inode->i_hash, &b->head);
@@ -1343,9 +1305,13 @@ void generic_delete_inode(struct inode *
 {
 	const struct super_operations *op = inode->i_sb->s_op;
 
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
@@ -1393,13 +1359,15 @@ int generic_detach_inode(struct inode *i
 	struct super_block *sb = inode->i_sb;
 
 	if (!hlist_bl_unhashed(&inode->i_hash)) {
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
 			return 0;
@@ -1414,11 +1382,14 @@ int generic_detach_inode(struct inode *i
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
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -1634,16 +1634,17 @@ struct super_operations {
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
 
@@ -2171,7 +2172,6 @@ extern int insert_inode_locked4(struct i
 extern int insert_inode_locked(struct inode *);
 extern void unlock_new_inode(struct inode *);
 
-extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
 extern void destroy_inode(struct inode *);
@@ -2422,6 +2422,12 @@ extern int generic_show_options(struct s
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
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -552,15 +552,8 @@ select_queue:
 				inode->i_state |= I_DIRTY_PAGES;
 				redirty_tail(inode);
 			}
-		} else if (inode->i_count) {
-			/*
-			 * The inode is clean, inuse
-			 */
-			list_move(&inode->i_list, &inode_in_use);
 		} else {
-			/*
-			 * The inode is clean, unused
-			 */
+			/* The inode is clean */
 			list_move(&inode->i_list, &inode_unused);
 		}
 	}
@@ -1206,8 +1199,6 @@ static void wait_sb_inodes(struct super_
 	 */
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	spin_lock(&sb_inode_list_lock);
-
 	/*
 	 * Data integrity sync. Must wait for all pages under writeback,
 	 * because there may have been pages dirtied before our sync
@@ -1215,7 +1206,8 @@ static void wait_sb_inodes(struct super_
 	 * In which case, the inode may not be on the dirty list, but
 	 * we still have to wait for that writeout.
 	 */
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
 		struct address_space *mapping;
 
 		mapping = inode->i_mapping;
@@ -1229,13 +1221,13 @@ static void wait_sb_inodes(struct super_
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb_inode_list_lock);
+		rcu_read_unlock();
 		/*
 		 * We hold a reference to 'inode' so it couldn't have been
-		 * removed from s_inodes list while we dropped the
-		 * sb_inode_list_lock.  We cannot iput the inode now as we can
-		 * be holding the last reference and we cannot iput it under
-		 * spinlock. So we keep the reference and iput it later.
+		 * removed from s_inodes list while we dropped the i_lock.  We
+		 * cannot iput the inode now as we can be holding the last
+		 * reference and we cannot iput it under spinlock. So we keep
+		 * the reference and iput it later.
 		 */
 		iput(old_inode);
 		old_inode = inode;
@@ -1244,9 +1236,9 @@ static void wait_sb_inodes(struct super_
 
 		cond_resched();
 
-		spin_lock(&sb_inode_list_lock);
+		rcu_read_lock();
 	}
-	spin_unlock(&sb_inode_list_lock);
+	rcu_read_unlock();
 	iput(old_inode);
 }
 
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -11,7 +11,6 @@ struct backing_dev_info;
 
 extern spinlock_t sb_inode_list_lock;
 extern spinlock_t wb_inode_list_lock;
-extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
 /*


