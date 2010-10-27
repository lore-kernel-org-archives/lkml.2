Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab0J0XDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 19:03:20 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:60476 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757302Ab0J0XDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 19:03:15 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] fs: Lock the inode LRU list separately
Date: Thu, 28 Oct 2010 10:02:17 +1100
Message-Id: <1288220538-21476-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288220538-21476-1-git-send-email-david@fromorbit.com>
References: <1288220538-21476-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Introduce the inode_lru_lock to protect the inode_lru list. This
lock is nested inside the inode->i_lock to allow the inode to be
added to the LRU list in iput_final without needing to deal with
lock inversions. This keeps iput_final() clean and neat.

Further, where marking the inode I_FREEING and removing it from the
LRU, move the LRU list manipulation within the inode->i_lock to keep
the list manipulation consistent with iput_final. This also means
that most of the open coded LRU list removal + unused inode
accounting can now use the inode_lru_list_del() wrappers which
cleans the code up further.

However, this locking change means what the LRU traversal in
prune_icache() inverts this lock ordering and needs to use trylock
semantics on the inode->i_lock to avoid deadlocking. In these cases,
if we fail to lock the inode we move it to the back of the LRU to
prevent spinning on it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   45 +++++++++++++++++++++++++++++----------------
 1 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index bd1688b..da741e7 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -30,10 +30,13 @@
  *
  * inode->i_lock protects:
  *   inode->i_state, __iget()
+ * inode_lru_lock protects:
+ *   inode_lru, inode->i_lru
  *
  * Lock ordering:
  * inode_lock
  *   inode->i_lock
+ *     inode_lru_lock
  */
 
 /*
@@ -83,6 +86,7 @@ static unsigned int i_hash_shift __read_mostly;
  */
 
 static LIST_HEAD(inode_lru);
+static DEFINE_SPINLOCK(inode_lru_lock);
 static struct hlist_head *inode_hashtable __read_mostly;
 
 /*
@@ -343,18 +347,22 @@ EXPORT_SYMBOL(ihold);
 
 static void inode_lru_list_add(struct inode *inode)
 {
+	spin_lock(&inode_lru_lock);
 	if (list_empty(&inode->i_lru)) {
 		list_add(&inode->i_lru, &inode_lru);
 		percpu_counter_inc(&nr_inodes_unused);
 	}
+	spin_unlock(&inode_lru_lock);
 }
 
 static void inode_lru_list_del(struct inode *inode)
 {
+	spin_lock(&inode_lru_lock);
 	if (!list_empty(&inode->i_lru)) {
 		list_del_init(&inode->i_lru);
 		percpu_counter_dec(&nr_inodes_unused);
 	}
+	spin_unlock(&inode_lru_lock);
 }
 
 static inline void __inode_sb_list_add(struct inode *inode)
@@ -521,15 +529,10 @@ void evict_inodes(struct super_block *sb)
 		}
 
 		inode->i_state |= I_FREEING;
-		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
-			percpu_counter_dec(&nr_inodes_unused);
+		inode_lru_list_del(inode);
 		spin_unlock(&inode->i_lock);
 
-		/*
-		 * Move the inode off the LRU once I_FREEING is set so that it
-		 * won't get moved back on.
-		 */
-		list_move(&inode->i_lru, &dispose);
+		list_add(&inode->i_lru, &dispose);
 	}
 	spin_unlock(&inode_lock);
 
@@ -566,15 +569,10 @@ int invalidate_inodes(struct super_block *sb)
 		}
 
 		inode->i_state |= I_FREEING;
-		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
-			percpu_counter_dec(&nr_inodes_unused);
+		inode_lru_list_del(inode);
 		spin_unlock(&inode->i_lock);
 
-		/*
-		 * Move the inode off the LRU once I_FREEING is
-		 * set so that it won't get moved back on.
-		 */
-		list_move(&inode->i_lru, &dispose);
+		list_add(&inode->i_lru, &dispose);
 	}
 	spin_unlock(&inode_lock);
 
@@ -621,6 +619,7 @@ static void prune_icache(int nr_to_scan)
 
 	down_read(&iprune_sem);
 	spin_lock(&inode_lock);
+	spin_lock(&inode_lru_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
 
@@ -630,10 +629,19 @@ static void prune_icache(int nr_to_scan)
 		inode = list_entry(inode_lru.prev, struct inode, i_lru);
 
 		/*
+		 * we are inverting the inode_lru_lock/inode->i_lock here,
+		 * so use a trylock. If we fail to get the lock, just move the
+		 * inode to the back of the list so we don't spin on it.
+		 */
+		if (!spin_trylock(&inode->i_lock)) {
+			list_move(&inode->i_lru, &inode_lru);
+			continue;
+		}
+
+		/*
 		 * Referenced or dirty inodes are still in use. Give them
 		 * another pass through the LRU as we canot reclaim them now.
 		 */
-		spin_lock(&inode->i_lock);
 		if (atomic_read(&inode->i_count) ||
 		    (inode->i_state & ~I_REFERENCED)) {
 			spin_unlock(&inode->i_lock);
@@ -652,17 +660,21 @@ static void prune_icache(int nr_to_scan)
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
+			spin_unlock(&inode_lru_lock);
 			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
 			spin_lock(&inode_lock);
+			spin_lock(&inode_lru_lock);
 
 			if (inode != list_entry(inode_lru.next,
 						struct inode, i_lru))
 				continue;	/* wrong inode or list_empty */
-			spin_lock(&inode->i_lock);
+			/* avoid lock inversions with trylock */
+			if (!spin_trylock(&inode->i_lock))
+				continue;
 			if (!can_unuse(inode)) {
 				spin_unlock(&inode->i_lock);
 				continue;
@@ -683,6 +695,7 @@ static void prune_icache(int nr_to_scan)
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
 		__count_vm_events(PGINODESTEAL, reap);
+	spin_unlock(&inode_lru_lock);
 	spin_unlock(&inode_lock);
 
 	dispose_list(&freeable);
-- 
1.7.1

