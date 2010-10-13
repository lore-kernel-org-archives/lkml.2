Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab0JMAQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 20:16:32 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:55071 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750818Ab0JMAQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 20:16:30 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/18] fs: Implement lazy LRU updates for inodes.
Date: Wed, 13 Oct 2010 11:15:46 +1100
Message-Id: <1286928961-15157-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286928961-15157-1-git-send-email-david@fromorbit.com>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
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

This also removes the inode_in_use list, which means we now only
have one list for tracking the inode LRU status. This makes it much
simpler to split out the LRU list operations under it's own lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/fs-writeback.c         |   12 +----
 fs/inode.c                |   92 +++++++++++++++++++++++++++++++--------------
 fs/internal.h             |    6 +++
 include/linux/fs.h        |   13 +++---
 include/linux/writeback.h |    1 -
 5 files changed, 80 insertions(+), 44 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 58a95b7..61c11d5 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -408,16 +408,10 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			 * completion.
 			 */
 			redirty_tail(inode);
-		} else if (atomic_read(&inode->i_count)) {
-			/*
-			 * The inode is clean, inuse
-			 */
-			list_move(&inode->i_list, &inode_in_use);
 		} else {
-			/*
-			 * The inode is clean, unused
-			 */
-			list_move(&inode->i_list, &inode_unused);
+			/* The inode is clean */
+			list_del_init(&inode->i_list);
+			inode_lru_list_add(inode);
 		}
 	}
 	inode_sync_complete(inode);
diff --git a/fs/inode.c b/fs/inode.c
index b3b6a4b..5dd74b4 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -72,7 +72,6 @@ static unsigned int i_hash_shift __read_mostly;
  * allowing for low-overhead inode sync() operations.
  */
 
-LIST_HEAD(inode_in_use);
 LIST_HEAD(inode_unused);
 static struct hlist_head *inode_hashtable __read_mostly;
 
@@ -291,6 +290,7 @@ void inode_init_once(struct inode *inode)
 	INIT_HLIST_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
+	INIT_LIST_HEAD(&inode->i_list);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
 	spin_lock_init(&inode->i_data.tree_lock);
 	spin_lock_init(&inode->i_data.i_mmap_lock);
@@ -317,12 +317,21 @@ static void init_once(void *foo)
  */
 void __iget(struct inode *inode)
 {
-	if (atomic_inc_return(&inode->i_count) != 1)
-		return;
+	atomic_inc(&inode->i_count);
+}
 
-	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
-		list_move(&inode->i_list, &inode_in_use);
-	percpu_counter_dec(&nr_inodes_unused);
+void inode_lru_list_add(struct inode *inode)
+{
+	list_add(&inode->i_list, &inode_unused);
+	percpu_counter_inc(&nr_inodes_unused);
+}
+
+void inode_lru_list_del(struct inode *inode)
+{
+	if (!list_empty(&inode->i_list)) {
+		list_del_init(&inode->i_list);
+		percpu_counter_dec(&nr_inodes_unused);
+	}
 }
 
 void end_writeback(struct inode *inode)
@@ -367,7 +376,7 @@ static void dispose_list(struct list_head *head)
 		struct inode *inode;
 
 		inode = list_first_entry(head, struct inode, i_list);
-		list_del(&inode->i_list);
+		list_del_init(&inode->i_list);
 
 		evict(inode);
 
@@ -410,9 +419,9 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 			continue;
 		invalidate_inode_buffers(inode);
 		if (!atomic_read(&inode->i_count)) {
-			list_move(&inode->i_list, dispose);
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
+			list_move(&inode->i_list, dispose);
 			percpu_counter_dec(&nr_inodes_unused);
 			continue;
 		}
@@ -461,17 +470,20 @@ static int can_unuse(struct inode *inode)
 }
 
 /*
- * Scan `goal' inodes on the unused list for freeable ones. They are moved to
- * a temporary list and then are freed outside inode_lock by dispose_list().
+ * Scan `goal' inodes on the unused list for freeable ones. They are moved to a
+ * temporary list and then are freed outside inode_lock by dispose_list().
  *
  * Any inodes which are pinned purely because of attached pagecache have their
- * pagecache removed.  We expect the final iput() on that inode to add it to
- * the front of the inode_unused list.  So look for it there and if the
- * inode is still freeable, proceed.  The right inode is found 99.9% of the
- * time in testing on a 4-way.
+ * pagecache removed.  If the inode has metadata buffers attached to
+ * mapping->private_list then try to remove them.
  *
- * If the inode has metadata buffers attached to mapping->private_list then
- * try to remove them.
+ * If the inode has the I_REFERENCED flag set, it means that it has been used
+ * recently - the flag is set in iput_final(). When we encounter such an inode,
+ * clear the flag and move it to the back of the LRU so it gets another pass
+ * through the LRU before it gets reclaimed. This is necessary because of the
+ * fact we are doing lazy LRU updates to minimise lock contention so the LRU
+ * does not have strict ordering. Hence we don't want to reclaim inodes with
+ * this flag set because they are the inodes that are out of order...
  */
 static void prune_icache(int nr_to_scan)
 {
@@ -489,8 +501,21 @@ static void prune_icache(int nr_to_scan)
 
 		inode = list_entry(inode_unused.prev, struct inode, i_list);
 
-		if (inode->i_state || atomic_read(&inode->i_count)) {
+		/*
+		 * Referenced or dirty inodes are still in use. Give them
+		 * another pass through the LRU as we canot reclaim them now.
+		 */
+		if (atomic_read(&inode->i_count) ||
+		    (inode->i_state & ~I_REFERENCED)) {
+			list_del_init(&inode->i_list);
+			percpu_counter_dec(&nr_inodes_unused);
+			continue;
+		}
+
+		/* recently referenced inodes get one more pass */
+		if (inode->i_state & I_REFERENCED) {
 			list_move(&inode->i_list, &inode_unused);
+			inode->i_state &= ~I_REFERENCED;
 			continue;
 		}
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
@@ -502,11 +527,15 @@ static void prune_icache(int nr_to_scan)
 			iput(inode);
 			spin_lock(&inode_lock);
 
-			if (inode != list_entry(inode_unused.next,
-						struct inode, i_list))
-				continue;	/* wrong inode or list_empty */
-			if (!can_unuse(inode))
+			/*
+			 * if we can't reclaim this inode immediately, give it
+			 * another pass through the free list so we don't spin
+			 * on it.
+			 */
+			if (!can_unuse(inode)) {
+				list_move(&inode->i_list, &inode_unused);
 				continue;
+			}
 		}
 		list_move(&inode->i_list, &freeable);
 		WARN_ON(inode->i_state & I_NEW);
@@ -621,7 +650,6 @@ static inline void
 __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
 			struct inode *inode)
 {
-	list_add(&inode->i_list, &inode_in_use);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	if (head)
 		hlist_add_head(&inode->i_hash, head);
@@ -1238,10 +1266,12 @@ static void iput_final(struct inode *inode)
 		drop = generic_drop_inode(inode);
 
 	if (!drop) {
-		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
-			list_move(&inode->i_list, &inode_unused);
-		percpu_counter_inc(&nr_inodes_unused);
 		if (sb->s_flags & MS_ACTIVE) {
+			inode->i_state |= I_REFERENCED;
+			if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
+				list_del_init(&inode->i_list);
+				inode_lru_list_add(inode);
+			}
 			spin_unlock(&inode_lock);
 			return;
 		}
@@ -1252,13 +1282,19 @@ static void iput_final(struct inode *inode)
 		spin_lock(&inode_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		percpu_counter_dec(&nr_inodes_unused);
 		hlist_del_init(&inode->i_hash);
 	}
-	list_del_init(&inode->i_list);
-	list_del_init(&inode->i_sb_list);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
+
+	/*
+	 * After we delete the inode from the LRU here, we avoid moving dirty
+	 * inodes back onto the LRU now because I_FREEING is set and hence
+	 * writeback_single_inode() won't move the inode around.
+	 */
+	inode_lru_list_del(inode);
+
+	list_del_init(&inode->i_sb_list);
 	spin_unlock(&inode_lock);
 	evict(inode);
 	spin_lock(&inode_lock);
diff --git a/fs/internal.h b/fs/internal.h
index a6910e9..ece3565 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -101,3 +101,9 @@ extern void put_super(struct super_block *sb);
 struct nameidata;
 extern struct file *nameidata_to_filp(struct nameidata *);
 extern void release_open_intent(struct nameidata *);
+
+/*
+ * inode.c
+ */
+extern void inode_lru_list_add(struct inode *inode);
+extern void inode_lru_list_del(struct inode *inode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1fb92f9..af1d516 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1632,16 +1632,17 @@ struct super_operations {
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
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 72a5d64..f956b66 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -10,7 +10,6 @@
 struct backing_dev_info;
 
 extern spinlock_t inode_lock;
-extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
 /*
-- 
1.7.1

