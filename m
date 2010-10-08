Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0JHFWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:22:33 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:46855 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752703Ab0JHFW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:22:29 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/18] fs: Reduce inode I_FREEING and factor inode disposal
Date: Fri,  8 Oct 2010 16:21:32 +1100
Message-Id: <1286515292-15882-19-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286515292-15882-1-git-send-email-david@fromorbit.com>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Inode reclaim can push many inodes into the I_FREEING state before
it actually frees them. During the time it gathers these inodes, it
can call iput(), invalidate_mapping_pages, be preempted, etc. As a
result, holding inodes in I_FREEING can cause pauses.

After the inode scalability work, there is not a big reason to batch
up inodes to reclaim them, so we can dispose them as they are found
from the LRU. With similar reasoning, we can do the same during
unmount, completely removing the need for the dispose_list()
function.

Further, iput_final() does the same inode cleanup as reclaim and
unmount, so convert them all to use a single function for destroying
inodes. This is written such that the callers can optimise list
removals to avoid unneccessary lock round trips when removing inodes
from lists.

Based on a patch originally from Nick Piggin.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |  150 +++++++++++++++++++++++++-----------------------------------
 1 files changed, 63 insertions(+), 87 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index c778ec4..03ddd19 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -29,6 +29,8 @@
 /*
  * Locking rules.
  *
+ * inode->i_lock is *always* the innermost lock.
+ *
  * inode->i_lock protects:
  *   i_ref i_state
  * inode_hash_bucket lock protects:
@@ -46,8 +48,15 @@
  *
  *   sb inode lock
  *     inode_lru_lock
- *       wb->b_lock
- *         inode->i_lock
+ *     wb->b_lock
+ *     inode->i_lock
+ *
+ *   wb->b_lock
+ *     sb_lock (pin sb for writeback)
+ *     inode->i_lock
+ *
+ *   inode_lru
+ *     inode->i_lock
  */
 /*
  * This is needed for the following functions:
@@ -434,13 +443,12 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 EXPORT_SYMBOL(__insert_inode_hash);
 
 /**
- *	__remove_inode_hash - remove an inode from the hash
+ *	remove_inode_hash - remove an inode from the hash
  *	@inode: inode to unhash
  *
- *	Remove an inode from the superblock. inode->i_lock must be
- *	held.
+ *	Remove an inode from the superblock.
  */
-static void __remove_inode_hash(struct inode *inode)
+void remove_inode_hash(struct inode *inode)
 {
 	struct inode_hash_bucket *b;
 
@@ -449,17 +457,6 @@ static void __remove_inode_hash(struct inode *inode)
 	hlist_bl_del_init(&inode->i_hash);
 	spin_unlock_bucket(b);
 }
-
-/**
- *	remove_inode_hash - remove an inode from the hash
- *	@inode: inode to unhash
- *
- *	Remove an inode from the superblock.
- */
-void remove_inode_hash(struct inode *inode)
-{
-	__remove_inode_hash(inode);
-}
 EXPORT_SYMBOL(remove_inode_hash);
 
 void end_writeback(struct inode *inode)
@@ -494,37 +491,53 @@ static void evict(struct inode *inode)
 }
 
 /*
- * dispose_list - dispose of the contents of a local list
- * @head: the head of the list to free
+ * Free the inode passed in, removing it from the lists it is still connected
+ * to but avoiding unnecessary lock round-trips for the lists it is no longer
+ * on.
  *
- * Dispose-list gets a local list with local inodes in it, so it doesn't
- * need to worry about list corruption and SMP locks.
+ * An inode must already be marked I_FREEING so that we avoid the inode being
+ * moved back onto lists if we race with other code that manipulates the lists
+ * (e.g. writeback_single_inode).
  */
-static void dispose_list(struct list_head *head)
+static void dispose_one_inode(struct inode *inode)
 {
-	while (!list_empty(head)) {
-		struct inode *inode;
+	BUG_ON(!(inode->i_state & I_FREEING));
 
-		inode = list_first_entry(head, struct inode, i_lru);
-		list_del_init(&inode->i_lru);
+	/*
+	 * move the inode off the IO lists and LRU once
+	 * I_FREEING is set so that it won't get moved back on
+	 * there if it is dirty.
+	 */
+	if (!list_empty(&inode->i_io)) {
+		struct backing_dev_info *bdi = inode_to_bdi(inode);
 
-		evict(inode);
+		spin_lock(&bdi->wb.b_lock);
+		list_del_init(&inode->i_io);
+		spin_unlock(&bdi->wb.b_lock);
+	}
+
+	if (!list_empty(&inode->i_lru))
+		inode_lru_list_del(inode);
 
-		__remove_inode_hash(inode);
+	if (!list_empty(&inode->i_sb_list)) {
 		spin_lock(&inode->i_sb->s_inodes_lock);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&inode->i_sb->s_inodes_lock);
-
-		wake_up_inode(inode);
-		destroy_inode(inode);
 	}
+
+	evict(inode);
+
+	remove_inode_hash(inode);
+	wake_up_inode(inode);
+	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
+	destroy_inode(inode);
 }
 
+
 /*
  * Invalidate all inodes for a device.
  */
-static int invalidate_list(struct super_block *sb, struct list_head *head,
-			struct list_head *dispose)
+static int invalidate_list(struct super_block *sb, struct list_head *head)
 {
 	struct list_head *next;
 	int busy = 0;
@@ -553,30 +566,22 @@ static int invalidate_list(struct super_block *sb, struct list_head *head,
 		}
 		invalidate_inode_buffers(inode);
 		if (!inode->i_ref) {
-			struct backing_dev_info *bdi = inode_to_bdi(inode);
-
 			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			spin_unlock(&inode->i_lock);
 
-			/*
-			 * move the inode off the IO lists and LRU once
-			 * I_FREEING is set so that it won't get moved back on
-			 * there if it is dirty.
-			 */
-			spin_lock(&bdi->wb.b_lock);
-			list_del_init(&inode->i_io);
-			spin_unlock(&bdi->wb.b_lock);
+			/* save a lock round trip by removing the inode here. */
+			list_del_init(&inode->i_sb_list);
+			spin_unlock(&sb->s_inodes_lock);
 
-			spin_lock(&inode_lru_lock);
-			list_move(&inode->i_lru, dispose);
-			spin_unlock(&inode_lru_lock);
+			dispose_one_inode(inode);
 
-			percpu_counter_dec(&nr_inodes_unused);
+			spin_lock(&sb->s_inodes_lock);
 			continue;
 		}
 		spin_unlock(&inode->i_lock);
 		busy = 1;
+
 	}
 	return busy;
 }
@@ -592,15 +597,12 @@ static int invalidate_list(struct super_block *sb, struct list_head *head,
 int invalidate_inodes(struct super_block *sb)
 {
 	int busy;
-	LIST_HEAD(throw_away);
 
 	down_write(&iprune_sem);
 	spin_lock(&sb->s_inodes_lock);
 	fsnotify_unmount_inodes(&sb->s_inodes);
-	busy = invalidate_list(sb, &sb->s_inodes, &throw_away);
+	busy = invalidate_list(sb, &sb->s_inodes);
 	spin_unlock(&sb->s_inodes_lock);
-
-	dispose_list(&throw_away);
 	up_write(&iprune_sem);
 
 	return busy;
@@ -636,7 +638,6 @@ static int can_unuse(struct inode *inode)
  */
 static void prune_icache(int nr_to_scan)
 {
-	LIST_HEAD(freeable);
 	int nr_scanned;
 	unsigned long reap = 0;
 
@@ -644,7 +645,6 @@ static void prune_icache(int nr_to_scan)
 	spin_lock(&inode_lru_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
-		struct backing_dev_info *bdi;
 
 		if (list_empty(&inode_lru))
 			break;
@@ -691,18 +691,15 @@ static void prune_icache(int nr_to_scan)
 		inode->i_state |= I_FREEING;
 		spin_unlock(&inode->i_lock);
 
-		/*
-		 * move the inode off the IO lists and LRU once
-		 * I_FREEING is set so that it won't get moved back on
-		 * there if it is dirty.
-		 */
-		bdi = inode_to_bdi(inode);
-		spin_lock(&bdi->wb.b_lock);
-		list_del_init(&inode->i_io);
-		spin_unlock(&bdi->wb.b_lock);
-
-		list_move(&inode->i_lru, &freeable);
+		/* save a lock round trip by removing the inode here. */
+		list_del_init(&inode->i_lru);
 		percpu_counter_dec(&nr_inodes_unused);
+		spin_unlock(&inode_lru_lock);
+
+		dispose_one_inode(inode);
+		cond_resched();
+
+		spin_lock(&inode_lru_lock);
 	}
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
@@ -710,7 +707,6 @@ static void prune_icache(int nr_to_scan)
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&inode_lru_lock);
 
-	dispose_list(&freeable);
 	up_read(&iprune_sem);
 }
 
@@ -1449,7 +1445,6 @@ static void iput_final(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	const struct super_operations *op = inode->i_sb->s_op;
-	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	int drop;
 
 	assert_spin_locked(&inode->i_lock);
@@ -1475,35 +1470,16 @@ static void iput_final(struct inode *inode)
 		inode->i_state |= I_WILL_FREE;
 		spin_unlock(&inode->i_lock);
 		write_inode_now(inode, 1);
+		remove_inode_hash(inode);
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		__remove_inode_hash(inode);
 	}
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
 
-	/*
-	 * move the inode off the IO lists and LRU once I_FREEING is set so
-	 * that it won't get moved back on there if it is dirty.
-	 * around.
-	 */
-	spin_lock(&bdi->wb.b_lock);
-	list_del_init(&inode->i_io);
-	spin_unlock(&bdi->wb.b_lock);
-
-	inode_lru_list_del(inode);
-
-	spin_lock(&sb->s_inodes_lock);
-	list_del_init(&inode->i_sb_list);
-	spin_unlock(&sb->s_inodes_lock);
-
-	evict(inode);
-	remove_inode_hash(inode);
-	wake_up_inode(inode);
-	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
-	destroy_inode(inode);
+	dispose_one_inode(inode);
 }
 
 /**
-- 
1.7.1

