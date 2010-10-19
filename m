Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab0JSD4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:56:13 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28439 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758037Ab0JSD4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSg
Message-Id: <20101019034656.095617797@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:22 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 06/35] fs: icache lock inode hash
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, inode_hash_lock, to protect the inode hash table lists.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/inode.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:38.000000000 +1100
@@ -29,10 +29,14 @@
  * Usage:
  * sb_inode_list_lock protects:
  *   s_inodes, i_sb_list
+ * inode_hash_lock protects:
+ *   inode hash table, i_hash
  *
  * Ordering:
  * inode_lock
  *   sb_inode_list_lock
+ * inode_lock
+ *   inode_hash_lock
  */
 /*
  * This is needed for the following functions:
@@ -93,6 +97,7 @@
  */
 DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
+DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -348,7 +353,9 @@
 		evict(inode);
 
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_unlock(&inode_hash_lock);
 		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&sb_inode_list_lock);
@@ -566,17 +573,20 @@
 	struct inode *inode = NULL;
 
 repeat:
+	spin_lock(&inode_hash_lock);
 	hlist_for_each_entry(inode, node, head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
 		if (!test(inode, data))
 			continue;
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
+			spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		break;
 	}
+	spin_unlock(&inode_hash_lock);
 	return node ? inode : NULL;
 }
 
@@ -591,17 +601,20 @@
 	struct inode *inode = NULL;
 
 repeat:
+	spin_lock(&inode_hash_lock);
 	hlist_for_each_entry(inode, node, head, i_hash) {
 		if (inode->i_ino != ino)
 			continue;
 		if (inode->i_sb != sb)
 			continue;
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
+			spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		break;
 	}
+	spin_unlock(&inode_hash_lock);
 	return node ? inode : NULL;
 }
 
@@ -624,8 +637,11 @@
 	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
-	if (head)
+	if (head) {
+		spin_lock(&inode_hash_lock);
 		hlist_add_head(&inode->i_hash, head);
+		spin_unlock(&inode_hash_lock);
+	}
 }
 
 /**
@@ -1103,7 +1119,9 @@
 	while (1) {
 		struct hlist_node *node;
 		struct inode *old = NULL;
+
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
@@ -1115,9 +1133,11 @@
 		}
 		if (likely(!node)) {
 			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode_hash_lock);
 			spin_unlock(&inode_lock);
 			return 0;
 		}
+		spin_unlock(&inode_hash_lock);
 		__iget(old);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
@@ -1143,6 +1163,7 @@
 		struct inode *old = NULL;
 
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
@@ -1154,9 +1175,11 @@
 		}
 		if (likely(!node)) {
 			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode_hash_lock);
 			spin_unlock(&inode_lock);
 			return 0;
 		}
+		spin_unlock(&inode_hash_lock);
 		__iget(old);
 		spin_unlock(&inode_lock);
 		wait_on_inode(old);
@@ -1181,7 +1204,9 @@
 {
 	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_add_head(&inode->i_hash, head);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
@@ -1195,7 +1220,9 @@
 void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
@@ -1254,7 +1281,9 @@
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		inodes_stat.nr_unused--;
+		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_unlock(&inode_hash_lock);
 	}
 	list_del_init(&inode->i_list);
 	spin_lock(&sb_inode_list_lock);
@@ -1266,7 +1295,9 @@
 	spin_unlock(&inode_lock);
 	evict(inode);
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));


