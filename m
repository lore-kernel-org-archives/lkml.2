Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0JPIQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 04:16:00 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:41181 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753804Ab0JPIPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 04:15:15 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/19] fs: Reduce inode I_FREEING and factor inode disposal
Date: Sat, 16 Oct 2010 19:14:11 +1100
Message-Id: <1287216853-17634-18-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287216853-17634-1-git-send-email-david@fromorbit.com>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
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
from the LRU.

Unmount does a very similar reclaim process via invalidate_list(),
but currently uses the i_lru list to aggregate inodes for a batched
disposal. This requires taking the inode_lru_lock for every inode we
want to dispose. Instead, take the inodes off the superblock inode
list (as we already hold the lock) and use i_sb_list as the
aggregator for inodes to dispose to reduce lock traffic.

Further, iput_final() does the same inode cleanup as reclaim and
unmount, so convert them all to use a single function for destroying
inodes. This is written such that the callers can optimise list
removals to avoid unneccessary lock round trips when removing inodes
from lists.

Based on a patch originally from Nick Piggin.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |  109 +++++++++++++++++++++++++++++++----------------------------
 1 files changed, 57 insertions(+), 52 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 5cddf45..bea1657 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -32,6 +32,8 @@
  *
  * inode->i_lock is *always* the innermost lock.
  *
+ * inode->i_lock is *always* the innermost lock.
+ *
  * inode->i_lock protects:
  *   i_ref i_state
  * inode hash lock protects:
@@ -49,8 +51,8 @@
  *
  * sb inode lock
  *   inode_lru_lock
- *     wb->b_lock
- *       inode->i_lock
+ *   wb->b_lock
+ *     inode->i_lock
  *
  * wb->b_lock
  *   sb_lock (pin sb for writeback)
@@ -460,6 +462,44 @@ static void evict(struct inode *inode)
 }
 
 /*
+ * Free the inode passed in, removing it from the lists it is still connected
+ * to but avoiding unnecessary lock round-trips for the lists it is no longer
+ * on.
+ *
+ * An inode must already be marked I_FREEING so that we avoid the inode being
+ * moved back onto lists if we race with other code that manipulates the lists
+ * (e.g. writeback_single_inode). The caller
+ */
+static void dispose_one_inode(struct inode *inode)
+{
+	BUG_ON(!(inode->i_state & I_FREEING));
+
+	/*
+	 * move the inode off the IO lists and LRU once
+	 * I_FREEING is set so that it won't get moved back on
+	 * there if it is dirty.
+	 */
+	if (!list_empty(&inode->i_wb_list))
+		inode_wb_list_del(inode);
+
+	if (!list_empty(&inode->i_lru))
+		inode_lru_list_del(inode);
+
+	if (!list_empty(&inode->i_sb_list)) {
+		spin_lock(&inode->i_sb->s_inodes_lock);
+		list_del_init(&inode->i_sb_list);
+		spin_unlock(&inode->i_sb->s_inodes_lock);
+	}
+
+	evict(inode);
+
+	remove_inode_hash(inode);
+	wake_up_inode(inode);
+	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
+	destroy_inode(inode);
+}
+
+/*
  * dispose_list - dispose of the contents of a local list
  * @head: the head of the list to free
  *
@@ -471,18 +511,10 @@ static void dispose_list(struct list_head *head)
 	while (!list_empty(head)) {
 		struct inode *inode;
 
-		inode = list_first_entry(head, struct inode, i_lru);
-		list_del_init(&inode->i_lru);
-
-		evict(inode);
-
-		remove_inode_hash(inode);
-		spin_lock(&inode->i_sb->s_inodes_lock);
+		inode = list_first_entry(head, struct inode, i_sb_list);
 		list_del_init(&inode->i_sb_list);
-		spin_unlock(&inode->i_sb->s_inodes_lock);
 
-		wake_up_inode(inode);
-		destroy_inode(inode);
+		dispose_one_inode(inode);
 	}
 }
 
@@ -523,17 +555,8 @@ static int invalidate_list(struct super_block *sb, struct list_head *head,
 			inode->i_state |= I_FREEING;
 			spin_unlock(&inode->i_lock);
 
-			/*
-			 * move the inode off the IO lists and LRU once
-			 * I_FREEING is set so that it won't get moved back on
-			 * there if it is dirty.
-			 */
-			inode_wb_list_del(inode);
-
-			spin_lock(&inode_lru_lock);
-			list_move(&inode->i_lru, dispose);
-			percpu_counter_dec(&nr_inodes_unused);
-			spin_unlock(&inode_lru_lock);
+			/* save a lock round trip by removing the inode here. */
+			list_move(&inode->i_sb_list, dispose);
 			continue;
 		}
 		spin_unlock(&inode->i_lock);
@@ -552,17 +575,17 @@ static int invalidate_list(struct super_block *sb, struct list_head *head,
  */
 int invalidate_inodes(struct super_block *sb)
 {
-	int busy;
 	LIST_HEAD(throw_away);
+	int busy;
 
 	down_write(&iprune_sem);
 	spin_lock(&sb->s_inodes_lock);
 	fsnotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(sb, &sb->s_inodes, &throw_away);
 	spin_unlock(&sb->s_inodes_lock);
+	up_write(&iprune_sem);
 
 	dispose_list(&throw_away);
-	up_write(&iprune_sem);
 
 	return busy;
 }
@@ -600,7 +623,6 @@ static int can_unuse(struct inode *inode)
  */
 static void prune_icache(int nr_to_scan)
 {
-	LIST_HEAD(freeable);
 	int nr_scanned;
 	unsigned long reap = 0;
 
@@ -660,15 +682,15 @@ static void prune_icache(int nr_to_scan)
 		inode->i_state |= I_FREEING;
 		spin_unlock(&inode->i_lock);
 
-		/*
-		 * move the inode off the io lists and lru once
-		 * i_freeing is set so that it won't get moved back on
-		 * there if it is dirty.
-		 */
-		inode_wb_list_del(inode);
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
@@ -676,7 +698,6 @@ static void prune_icache(int nr_to_scan)
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&inode_lru_lock);
 
-	dispose_list(&freeable);
 	up_read(&iprune_sem);
 }
 
@@ -1461,23 +1482,7 @@ static void iput_final(struct inode *inode)
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
 
-	/*
-	 * After we delete the inode from the LRU and IO lists here, we avoid
-	 * moving dirty inodes back onto the LRU now because I_FREEING is set
-	 * and hence writeback_single_inode() won't move the inode around.
-	 */
-	inode_wb_list_del(inode);
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

