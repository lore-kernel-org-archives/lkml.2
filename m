Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1CVLZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:25:22 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:16735 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932Ab1CVLXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:23:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkEAK8jiE15LK5JgWdsb2JhbAClQxUBARYmJcQUhWQE
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/8] fs: factor inode disposal
Date: Tue, 22 Mar 2011 22:23:37 +1100
Message-Id: <1300793023-3775-3-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300793023-3775-1-git-send-email-david@fromorbit.com>
References: <1300793023-3775-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We have a couple of places that dispose of inodes. factor the
disposal into evict() to isolate this code and make it simpler to
peel away the inode_lock from the code.

While doing this, change the logic flow in iput_final() to separate
the different cases that need to be handled to make the transitions
the inode goes through more obvious.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |  104 +++++++++++++++++++++++------------------------------------
 1 files changed, 41 insertions(+), 63 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index bd5a237..442b55b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -422,17 +422,6 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 EXPORT_SYMBOL(__insert_inode_hash);
 
 /**
- *	__remove_inode_hash - remove an inode from the hash
- *	@inode: inode to unhash
- *
- *	Remove an inode from the superblock.
- */
-static void __remove_inode_hash(struct inode *inode)
-{
-	hlist_del_init(&inode->i_hash);
-}
-
-/**
  *	remove_inode_hash - remove an inode from the hash
  *	@inode: inode to unhash
  *
@@ -461,10 +450,31 @@ void end_writeback(struct inode *inode)
 }
 EXPORT_SYMBOL(end_writeback);
 
+/*
+ * Free the inode passed in, removing it from the lists it is still connected
+ * to. We remove any pages still attached to the inode and wait for any IO that
+ * is still in progress before finally destroying the inode.
+ *
+ * An inode must already be marked I_FREEING so that we avoid the inode being
+ * moved back onto lists if we race with other code that manipulates the lists
+ * (e.g. writeback_single_inode). The caller is responsible for setting this.
+ *
+ * An inode must already be removed from the LRU list before being evicted from
+ * the cache. This should occur atomically with setting the I_FREEING state
+ * flag, so no inodes here should ever be on the LRU when being evicted.
+ */
 static void evict(struct inode *inode)
 {
 	const struct super_operations *op = inode->i_sb->s_op;
 
+	BUG_ON(!(inode->i_state & I_FREEING));
+	BUG_ON(!list_empty(&inode->i_lru));
+
+	spin_lock(&inode_lock);
+	list_del_init(&inode->i_wb_list);
+	__inode_sb_list_del(inode);
+	spin_unlock(&inode_lock);
+
 	if (op->evict_inode) {
 		op->evict_inode(inode);
 	} else {
@@ -476,6 +486,15 @@ static void evict(struct inode *inode)
 		bd_forget(inode);
 	if (S_ISCHR(inode->i_mode) && inode->i_cdev)
 		cd_forget(inode);
+
+	remove_inode_hash(inode);
+
+	spin_lock(&inode->i_lock);
+	wake_up_bit(&inode->i_state, __I_NEW);
+	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
+	spin_unlock(&inode->i_lock);
+
+	destroy_inode(inode);
 }
 
 /*
@@ -494,16 +513,6 @@ static void dispose_list(struct list_head *head)
 		list_del_init(&inode->i_lru);
 
 		evict(inode);
-
-		spin_lock(&inode_lock);
-		__remove_inode_hash(inode);
-		__inode_sb_list_del(inode);
-		spin_unlock(&inode_lock);
-
-		spin_lock(&inode->i_lock);
-		wake_up_bit(&inode->i_state, __I_NEW);
-		spin_unlock(&inode->i_lock);
-		destroy_inode(inode);
 	}
 }
 
@@ -536,13 +545,7 @@ void evict_inodes(struct super_block *sb)
 		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
 			inodes_stat.nr_unused--;
 		spin_unlock(&inode->i_lock);
-
-		/*
-		 * Move the inode off the IO lists and LRU once I_FREEING is
-		 * set so that it won't get moved back on there if it is dirty.
-		 */
 		list_move(&inode->i_lru, &dispose);
-		list_del_init(&inode->i_wb_list);
 	}
 	spin_unlock(&inode_lock);
 
@@ -595,13 +598,7 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
 			inodes_stat.nr_unused--;
 		spin_unlock(&inode->i_lock);
-
-		/*
-		 * Move the inode off the IO lists and LRU once I_FREEING is
-		 * set so that it won't get moved back on there if it is dirty.
-		 */
 		list_move(&inode->i_lru, &dispose);
-		list_del_init(&inode->i_wb_list);
 	}
 	spin_unlock(&inode_lock);
 
@@ -698,12 +695,7 @@ static void prune_icache(int nr_to_scan)
 		inode->i_state |= I_FREEING;
 		spin_unlock(&inode->i_lock);
 
-		/*
-		 * Move the inode off the IO lists and LRU once I_FREEING is
-		 * set so that it won't get moved back on there if it is dirty.
-		 */
 		list_move(&inode->i_lru, &freeable);
-		list_del_init(&inode->i_wb_list);
 		inodes_stat.nr_unused--;
 	}
 	if (current_is_kswapd())
@@ -1433,16 +1425,16 @@ static void iput_final(struct inode *inode)
 	else
 		drop = generic_drop_inode(inode);
 
+	if (!drop && (sb->s_flags & MS_ACTIVE)) {
+		inode->i_state |= I_REFERENCED;
+		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
+			inode_lru_list_add(inode);
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&inode_lock);
+		return;
+	}
+
 	if (!drop) {
-		if (sb->s_flags & MS_ACTIVE) {
-			inode->i_state |= I_REFERENCED;
-			if (!(inode->i_state & (I_DIRTY|I_SYNC))) {
-				inode_lru_list_add(inode);
-			}
-			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lock);
-			return;
-		}
 		inode->i_state |= I_WILL_FREE;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
@@ -1451,28 +1443,14 @@ static void iput_final(struct inode *inode)
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		__remove_inode_hash(inode);
 	}
 
 	inode->i_state |= I_FREEING;
-	spin_unlock(&inode->i_lock);
-
-	/*
-	 * Move the inode off the IO lists and LRU once I_FREEING is
-	 * set so that it won't get moved back on there if it is dirty.
-	 */
 	inode_lru_list_del(inode);
-	list_del_init(&inode->i_wb_list);
-
-	__inode_sb_list_del(inode);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
+
 	evict(inode);
-	remove_inode_hash(inode);
-	spin_lock(&inode->i_lock);
-	wake_up_bit(&inode->i_state, __I_NEW);
-	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
-	spin_unlock(&inode->i_lock);
-	destroy_inode(inode);
 }
 
 /**
-- 
1.7.2.3

