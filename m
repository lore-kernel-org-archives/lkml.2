Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0FXDQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab0FXDPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:52 -0400
Message-Id: <20100624030730.764840115@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:44 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 32/52] fs: icache protect inode state
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-6b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect i_hash, i_sb_list etc members with i_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/hugetlbfs/inode.c |    1 +
 fs/inode.c           |   29 ++++++++++++++++++++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -35,7 +35,11 @@
  * wb_inode_list_lock protects:
  *   inode_in_use, inode_unused, b_io, b_more_io, b_dirty, i_list
  * inode->i_lock protects:
- *   i_state, i_count
+ *   i_state
+ *   i_count
+ *   i_hash
+ *   i_list
+ *   i_sb_list
  *
  * Ordering:
  * inode_lock
@@ -373,12 +377,14 @@ static void dispose_list(struct list_hea
 		clear_inode(inode);
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
+		spin_lock(&inode->i_lock);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
-		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&sb_inode_list_lock);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 
 		wake_up_inode(inode);
@@ -680,7 +686,6 @@ __inode_add_to_lists(struct super_block
 			struct inode *inode)
 {
 	atomic_inc(&inodes_stat.nr_inodes);
-	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
 	spin_lock(&wb_inode_list_lock);
@@ -710,7 +715,10 @@ void inode_add_to_lists(struct super_blo
 	struct hlist_head *head = inode_hashtable + hash(sb, inode->i_ino);
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
+	spin_lock(&inode->i_lock);
 	__inode_add_to_lists(sb, head, inode);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL_GPL(inode_add_to_lists);
@@ -742,9 +750,12 @@ struct inode *new_inode(struct super_blo
 	inode = alloc_inode(sb);
 	if (inode) {
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
+		spin_lock(&inode->i_lock);
 		inode->i_ino = ++last_ino;
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
+		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 	}
 	return inode;
@@ -808,11 +819,14 @@ static struct inode *get_new_inode(struc
 		/* We released the lock, so.. */
 		old = find_inode(sb, head, test, data);
 		if (!old) {
+			spin_lock(&sb_inode_list_lock);
+			spin_lock(&inode->i_lock);
 			if (set(inode, data))
 				goto set_failed;
 
 			inode->i_state = I_NEW;
 			__inode_add_to_lists(sb, head, inode);
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -837,6 +851,7 @@ static struct inode *get_new_inode(struc
 
 set_failed:
 	spin_unlock(&inode->i_lock);
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	destroy_inode(inode);
 	return NULL;
@@ -859,9 +874,12 @@ static struct inode *get_new_inode_fast(
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
+			spin_lock(&sb_inode_list_lock);
+			spin_lock(&inode->i_lock);
 			inode->i_ino = ino;
 			inode->i_state = I_NEW;
 			__inode_add_to_lists(sb, head, inode);
+			spin_unlock(&inode->i_lock);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -1275,10 +1293,13 @@ EXPORT_SYMBOL(insert_inode_locked4);
 void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 {
 	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
+
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	spin_lock(&inode_hash_lock);
 	hlist_add_head(&inode->i_hash, head);
 	spin_unlock(&inode_hash_lock);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
@@ -1292,9 +1313,11 @@ EXPORT_SYMBOL(__insert_inode_hash);
 void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode_hash_lock);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
@@ -1338,9 +1361,11 @@ void generic_delete_inode(struct inode *
 		clear_inode(inode);
 	}
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode_hash_lock);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != I_CLEAR);
@@ -1385,10 +1410,10 @@ int generic_detach_inode(struct inode *i
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		atomic_dec(&inodes_stat.nr_unused);
 		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
 		spin_unlock(&inode_hash_lock);
+		atomic_dec(&inodes_stat.nr_unused);
 	}
 	spin_lock(&wb_inode_list_lock);
 	list_del_init(&inode->i_list);
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c
+++ linux-2.6/fs/hugetlbfs/inode.c
@@ -382,6 +382,7 @@ static void hugetlbfs_forget_inode(struc
 	if (generic_detach_inode(inode)) {
 		truncate_hugepages(inode, 0);
 		clear_inode(inode);
+		/* XXX: why no wake_up_inode? */
 		destroy_inode(inode);
 	}
 }


