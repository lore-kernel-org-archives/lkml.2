Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0J0XDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 19:03:07 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:57904 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755040Ab0J0XDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 19:03:05 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] fs: factor inode disposal
Date: Thu, 28 Oct 2010 10:02:16 +1100
Message-Id: <1288220538-21476-3-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288220538-21476-1-git-send-email-david@fromorbit.com>
References: <1288220538-21476-1-git-send-email-david@fromorbit.com>
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
 fs/inode.c |   89 +++++++++++++++++++++++++----------------------------------
 1 files changed, 38 insertions(+), 51 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index e1959f3..bd1688b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -408,17 +408,6 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
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
@@ -446,10 +435,26 @@ void end_writeback(struct inode *inode)
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
+ */
 static void evict(struct inode *inode)
 {
 	const struct super_operations *op = inode->i_sb->s_op;
 
+	BUG_ON(!(inode->i_state & I_FREEING));
+
+	spin_lock(&inode_lock);
+	list_del_init(&inode->i_wb_list);
+	__inode_sb_list_del(inode);
+	spin_unlock(&inode_lock);
+
 	if (op->evict_inode) {
 		op->evict_inode(inode);
 	} else {
@@ -461,6 +466,11 @@ static void evict(struct inode *inode)
 		bd_forget(inode);
 	if (S_ISCHR(inode->i_mode) && inode->i_cdev)
 		cd_forget(inode);
+
+	remove_inode_hash(inode);
+	wake_up_inode(inode);
+	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
+	destroy_inode(inode);
 }
 
 /*
@@ -479,14 +489,6 @@ static void dispose_list(struct list_head *head)
 		list_del_init(&inode->i_lru);
 
 		evict(inode);
-
-		spin_lock(&inode_lock);
-		__remove_inode_hash(inode);
-		__inode_sb_list_del(inode);
-		spin_unlock(&inode_lock);
-
-		wake_up_inode(inode);
-		destroy_inode(inode);
 	}
 }
 
@@ -524,11 +526,10 @@ void evict_inodes(struct super_block *sb)
 		spin_unlock(&inode->i_lock);
 
 		/*
-		 * Move the inode off the IO lists and LRU once I_FREEING is
-		 * set so that it won't get moved back on there if it is dirty.
+		 * Move the inode off the LRU once I_FREEING is set so that it
+		 * won't get moved back on.
 		 */
 		list_move(&inode->i_lru, &dispose);
-		list_del_init(&inode->i_wb_list);
 	}
 	spin_unlock(&inode_lock);
 
@@ -570,11 +571,10 @@ int invalidate_inodes(struct super_block *sb)
 		spin_unlock(&inode->i_lock);
 
 		/*
-		 * Move the inode off the IO lists and LRU once I_FREEING is
-		 * set so that it won't get moved back on there if it is dirty.
+		 * Move the inode off the LRU once I_FREEING is
+		 * set so that it won't get moved back on.
 		 */
 		list_move(&inode->i_lru, &dispose);
-		list_del_init(&inode->i_wb_list);
 	}
 	spin_unlock(&inode_lock);
 
@@ -673,11 +673,10 @@ static void prune_icache(int nr_to_scan)
 		spin_unlock(&inode->i_lock);
 
 		/*
-		 * Move the inode off the IO lists and LRU once I_FREEING is
-		 * set so that it won't get moved back on there if it is dirty.
+		 * Move the inode off the LRU once I_FREEING is
+		 * set so that it won't get moved back on.
 		 */
 		list_move(&inode->i_lru, &freeable);
-		list_del_init(&inode->i_wb_list);
 		percpu_counter_dec(&nr_inodes_unused);
 	}
 	if (current_is_kswapd())
@@ -1409,16 +1408,16 @@ static void iput_final(struct inode *inode)
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
@@ -1427,26 +1426,14 @@ static void iput_final(struct inode *inode)
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
-	wake_up_inode(inode);
-	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
-	destroy_inode(inode);
 }
 
 /**
-- 
1.7.1

