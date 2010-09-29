Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab0I2MTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:19:34 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:48401 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755673Ab0I2MTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:32 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/17] fs: Implement lazy LRU updates for inodes.
Date: Wed, 29 Sep 2010 22:18:45 +1000
Message-Id: <1285762729-17928-14-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Convert the inode LRU to use lazy updates to reduce lock and
cacheline traffic.  We avoid moving inodes around in the LRU list
during iget/iput operations so these frequent operations don't need
to access the LRUs. Instead, we defer the refcount checks to
reclaim-time and use a per-inode state flag, I_REFERENCED, to tell
reclaim that iget has touched the inode in the past. This means that
only reclaim should be touching the LRU with any frequency, hence
significantly reducing lock acquisitions and the amount contention
on LRU updates.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c         |   20 +++--------
 fs/inode.c                |   81 +++++++++++++--------------------------------
 include/linux/fs.h        |   20 +++++++----
 include/linux/writeback.h |    1 -
 4 files changed, 42 insertions(+), 80 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 9b63fc7..432a4df 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -408,15 +408,8 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			 * completion.
 			 */
 			redirty_tail(inode);
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
@@ -1058,8 +1051,6 @@ static void wait_sb_inodes(struct super_block *sb)
 	 */
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	spin_lock(&sb_inode_list_lock);
-
 	/*
 	 * Data integrity sync. Must wait for all pages under writeback,
 	 * because there may have been pages dirtied before our sync
@@ -1067,6 +1058,7 @@ static void wait_sb_inodes(struct super_block *sb)
 	 * In which case, the inode may not be on the dirty list, but
 	 * we still have to wait for that writeout.
 	 */
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		struct address_space *mapping;
 
@@ -1083,10 +1075,10 @@ static void wait_sb_inodes(struct super_block *sb)
 		spin_unlock(&sb_inode_list_lock);
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
diff --git a/fs/inode.c b/fs/inode.c
index 9d1a0fc..50599d7 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -94,7 +94,6 @@ static unsigned int i_hash_shift __read_mostly;
  * allowing for low-overhead inode sync() operations.
  */
 
-LIST_HEAD(inode_in_use);
 LIST_HEAD(inode_unused);
 
 struct inode_hash_bucket {
@@ -296,6 +295,7 @@ void inode_init_once(struct inode *inode)
 	INIT_HLIST_BL_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
+	INIT_LIST_HEAD(&inode->i_list);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
 	spin_lock_init(&inode->i_data.tree_lock);
 	spin_lock_init(&inode->i_data.i_mmap_lock);
@@ -317,25 +317,6 @@ static void init_once(void *foo)
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
@@ -380,7 +361,7 @@ static void dispose_list(struct list_head *head)
 		struct inode *inode;
 
 		inode = list_first_entry(head, struct inode, i_list);
-		list_del(&inode->i_list);
+		list_del_init(&inode->i_list);
 
 		evict(inode);
 
@@ -431,11 +412,12 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
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
@@ -473,19 +455,6 @@ int invalidate_inodes(struct super_block *sb)
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
  * a temporary list and then are freed outside LRU lock by dispose_list().
@@ -503,13 +472,12 @@ static void prune_icache(int nr_to_scan)
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
@@ -521,33 +489,30 @@ again:
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
@@ -687,9 +652,6 @@ __inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
 	atomic_inc(&inodes_stat.nr_inodes);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
-	spin_lock(&wb_inode_list_lock);
-	list_add(&inode->i_list, &inode_in_use);
-	spin_unlock(&wb_inode_list_lock);
 	if (b) {
 		spin_lock_bucket(b);
 		hlist_bl_add_head(&inode->i_hash, &b->head);
@@ -1381,11 +1343,14 @@ static void iput_final(struct inode *inode)
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f06be07..096a5eb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1627,16 +1627,17 @@ struct super_operations {
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
 
@@ -2177,7 +2178,6 @@ extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struc
 extern int insert_inode_locked(struct inode *);
 extern void unlock_new_inode(struct inode *);
 
-extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
 extern void end_writeback(struct inode *);
 extern void destroy_inode(struct inode *);
@@ -2392,6 +2392,12 @@ extern int generic_show_options(struct seq_file *m, struct vfsmount *mnt);
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
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 0f6fe0c..cde6993 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -11,7 +11,6 @@ struct backing_dev_info;
 
 extern spinlock_t sb_inode_list_lock;
 extern spinlock_t wb_inode_list_lock;
-extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
 /*
-- 
1.7.1

