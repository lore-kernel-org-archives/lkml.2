Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0FXDRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:17:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:48451 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab0FXDPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:48 -0400
Message-Id: <20100624030729.921038406@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:39 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 27/52] fs: icache lock inode hash
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, inode_hash_lock, to protect the inode hash table lists.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/inode.c                |   29 ++++++++++++++++++++++++++++-
 include/linux/writeback.h |    1 +
 2 files changed, 29 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -30,10 +30,14 @@
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
@@ -94,6 +98,7 @@ static struct hlist_head *inode_hashtabl
  */
 DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
+DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -353,7 +358,9 @@ static void dispose_list(struct list_hea
 		clear_inode(inode);
 
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_unlock(&inode_hash_lock);
 		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&sb_inode_list_lock);
@@ -563,17 +570,20 @@ static struct inode *find_inode(struct s
 	struct inode *inode = NULL;
 
 repeat:
+	spin_lock(&inode_hash_lock);
 	hlist_for_each_entry(inode, node, head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
 		if (!test(inode, data))
 			continue;
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
+			spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		break;
 	}
+	spin_unlock(&inode_hash_lock);
 	return node ? inode : NULL;
 }
 
@@ -588,17 +598,20 @@ static struct inode *find_inode_fast(str
 	struct inode *inode = NULL;
 
 repeat:
+	spin_lock(&inode_hash_lock);
 	hlist_for_each_entry(inode, node, head, i_hash) {
 		if (inode->i_ino != ino)
 			continue;
 		if (inode->i_sb != sb)
 			continue;
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)) {
+			spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
 		break;
 	}
+	spin_unlock(&inode_hash_lock);
 	return node ? inode : NULL;
 }
 
@@ -621,8 +634,11 @@ __inode_add_to_lists(struct super_block
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
@@ -1100,7 +1116,9 @@ int insert_inode_locked(struct inode *in
 	while (1) {
 		struct hlist_node *node;
 		struct inode *old = NULL;
+
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
@@ -1112,9 +1130,11 @@ int insert_inode_locked(struct inode *in
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
@@ -1140,6 +1160,7 @@ int insert_inode_locked4(struct inode *i
 		struct inode *old = NULL;
 
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
@@ -1151,9 +1172,11 @@ int insert_inode_locked4(struct inode *i
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
@@ -1178,7 +1201,9 @@ void __insert_inode_hash(struct inode *i
 {
 	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_add_head(&inode->i_hash, head);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
@@ -1192,7 +1217,9 @@ EXPORT_SYMBOL(__insert_inode_hash);
 void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
@@ -1234,7 +1261,9 @@ void generic_delete_inode(struct inode *
 		clear_inode(inode);
 	}
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != I_CLEAR);
@@ -1271,7 +1300,9 @@ int generic_detach_inode(struct inode *i
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		inodes_stat.nr_unused--;
+		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_unlock(&inode_hash_lock);
 	}
 	list_del_init(&inode->i_list);
 	spin_lock(&sb_inode_list_lock);
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -11,6 +11,7 @@ struct backing_dev_info;
 
 extern spinlock_t inode_lock;
 extern spinlock_t sb_inode_list_lock;
+extern spinlock_t inode_hash_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 


