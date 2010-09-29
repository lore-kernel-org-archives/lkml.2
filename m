Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab0I2MT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:19:26 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:41781 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755338Ab0I2MTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:19 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/17] fs: icache protect inode state
Date: Wed, 29 Sep 2010 22:18:40 +1000
Message-Id: <1285762729-17928-9-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Before removing the inode_lock, we need to protect the inode list
operations with the inode->i_lock. This ensures that all inode state
changes are serialised regardless of the fact that the lists they
are moving around might be protected by different locks. Hence we
can safely protect an inode in transit from one list to another
without needing to hold all the list locks at the same time.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 6d982e6..8fbc4d4 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -34,7 +34,11 @@
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
@@ -368,12 +372,14 @@ static void dispose_list(struct list_head *head)
 		evict(inode);
 
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
@@ -674,7 +680,6 @@ __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
 			struct inode *inode)
 {
 	atomic_inc(&inodes_stat.nr_inodes);
-	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
 	spin_lock(&wb_inode_list_lock);
@@ -704,7 +709,10 @@ void inode_add_to_lists(struct super_block *sb, struct inode *inode)
 	struct hlist_head *head = inode_hashtable + hash(sb, inode->i_ino);
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
+	spin_lock(&inode->i_lock);
 	__inode_add_to_lists(sb, head, inode);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL_GPL(inode_add_to_lists);
@@ -736,9 +744,12 @@ struct inode *new_inode(struct super_block *sb)
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
@@ -802,11 +813,14 @@ static struct inode *get_new_inode(struct super_block *sb,
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
@@ -831,6 +845,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 
 set_failed:
 	spin_unlock(&inode->i_lock);
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	destroy_inode(inode);
 	return NULL;
@@ -853,9 +868,12 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
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
@@ -1270,10 +1288,13 @@ EXPORT_SYMBOL(insert_inode_locked4);
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
@@ -1287,9 +1308,11 @@ EXPORT_SYMBOL(__insert_inode_hash);
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
@@ -1356,10 +1379,10 @@ static void iput_final(struct inode *inode)
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
@@ -1373,9 +1396,11 @@ static void iput_final(struct inode *inode)
 	atomic_dec(&inodes_stat.nr_inodes);
 	evict(inode);
 	spin_lock(&inode_lock);
+	spin_lock(&inode->i_lock);
 	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode_hash_lock);
+	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
-- 
1.7.1

