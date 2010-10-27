Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab0J0EXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 00:23:53 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:42208 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751060Ab0J0EXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 00:23:47 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] fs: factor inode disposal
Date: Wed, 27 Oct 2010 15:23:02 +1100
Message-Id: <1288153384-8878-3-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288153384-8878-1-git-send-email-david@fromorbit.com>
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We have a couple of places that dispose of inodes. factor the
disposal into a common helper dispose_one_inode() to isolate this
code and make it simpler to peel away the inode_lock from the code.

While doing this, change the logic flow in iput_final() to separate
the different cases that need to be handled to make the transitions
the inode goes through more obvious.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   75 +++++++++++++++++++++++++++++++----------------------------
 1 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index eaba6ce..f134aa4 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -464,6 +464,32 @@ static void evict(struct inode *inode)
 }
 
 /*
+ * Free the inode passed in, removing it from the lists it is still connected
+ * to but avoiding unnecessary lock round-trips for the lists it is no longer
+ * on.
+ *
+ * An inode must already be marked I_FREEING so that we avoid the inode being
+ * moved back onto lists if we race with other code that manipulates the lists
+ * (e.g. writeback_single_inode_inode). The caller is responsisble for setting this.
+ */
+static void dispose_one_inode(struct inode *inode)
+{
+	BUG_ON(!(inode->i_state & I_FREEING));
+
+	spin_lock(&inode_lock);
+	list_del_init(&inode->i_wb_list);
+	__remove_inode_hash(inode);
+	__inode_sb_list_del(inode);
+	spin_unlock(&inode_lock);
+
+	evict(inode);
+
+	wake_up_inode(inode);
+	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
+	destroy_inode(inode);
+}
+
+/*
  * dispose_list - dispose of the contents of a local list
  * @head: the head of the list to free
  *
@@ -478,15 +504,7 @@ static void dispose_list(struct list_head *head)
 		inode = list_first_entry(head, struct inode, i_lru);
 		list_del_init(&inode->i_lru);
 
-		evict(inode);
-
-		spin_lock(&inode_lock);
-		__remove_inode_hash(inode);
-		__inode_sb_list_del(inode);
-		spin_unlock(&inode_lock);
-
-		wake_up_inode(inode);
-		destroy_inode(inode);
+		dispose_one_inode(inode);
 	}
 }
 
@@ -528,7 +546,6 @@ void evict_inodes(struct super_block *sb)
 		 * set so that it won't get moved back on there if it is dirty.
 		 */
 		list_move(&inode->i_lru, &dispose);
-		list_del_init(&inode->i_wb_list);
 	}
 	spin_unlock(&inode_lock);
 
@@ -574,7 +591,6 @@ int invalidate_inodes(struct super_block *sb)
 		 * set so that it won't get moved back on there if it is dirty.
 		 */
 		list_move(&inode->i_lru, &dispose);
-		list_del_init(&inode->i_wb_list);
 	}
 	spin_unlock(&inode_lock);
 
@@ -677,7 +693,6 @@ static void prune_icache(int nr_to_scan)
 		 * set so that it won't get moved back on there if it is dirty.
 		 */
 		list_move(&inode->i_lru, &freeable);
-		list_del_init(&inode->i_wb_list);
 		percpu_counter_dec(&nr_inodes_unused);
 	}
 	if (current_is_kswapd())
@@ -1409,16 +1424,16 @@ static void iput_final(struct inode *inode)
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
@@ -1427,26 +1442,14 @@ static void iput_final(struct inode *inode)
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
-	evict(inode);
-	remove_inode_hash(inode);
-	wake_up_inode(inode);
-	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
-	destroy_inode(inode);
+
+	dispose_one_inode(inode);
 }
 
 /**
-- 
1.7.1

