Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab0I2MVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:21:10 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:41834 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755625Ab0I2MTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:30 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/17] fs: icache lock inode hash
Date: Wed, 29 Sep 2010 22:18:35 +1000
Message-Id: <1285762729-17928-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Currently the inode hash lists are protected by the inode_lock. To
allow removal of the inode_lock, we need to protect the inode hash
table lists with a new lock. Nest the new inode_hash_lock inside the
inode_lock to protect the hash lists.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c                |   33 ++++++++++++++++++++++++++++++++-
 include/linux/writeback.h |    1 +
 2 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index ca98254..9d7ffb1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
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
@@ -93,6 +97,7 @@ static struct hlist_head *inode_hashtable __read_mostly;
  */
 DEFINE_SPINLOCK(inode_lock);
 DEFINE_SPINLOCK(sb_inode_list_lock);
+DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -348,7 +353,9 @@ static void dispose_list(struct list_head *head)
 		evict(inode);
 
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_unlock(&inode_hash_lock);
 		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&sb_inode_list_lock);
@@ -557,17 +564,20 @@ static struct inode *find_inode(struct super_block *sb,
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
 
@@ -582,17 +592,20 @@ static struct inode *find_inode_fast(struct super_block *sb,
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
 
@@ -615,8 +628,11 @@ __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
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
@@ -1094,7 +1110,9 @@ int insert_inode_locked(struct inode *inode)
 	while (1) {
 		struct hlist_node *node;
 		struct inode *old = NULL;
+
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
@@ -1106,9 +1124,11 @@ int insert_inode_locked(struct inode *inode)
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
@@ -1134,6 +1154,7 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		struct inode *old = NULL;
 
 		spin_lock(&inode_lock);
+		spin_lock(&inode_hash_lock);
 		hlist_for_each_entry(old, node, head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
@@ -1145,9 +1166,11 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
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
@@ -1172,7 +1195,9 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 {
 	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_add_head(&inode->i_hash, head);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
@@ -1186,7 +1211,9 @@ EXPORT_SYMBOL(__insert_inode_hash);
 void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
@@ -1245,7 +1272,9 @@ static void iput_final(struct inode *inode)
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		inodes_stat.nr_unused--;
+		spin_lock(&inode_hash_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_unlock(&inode_hash_lock);
 	}
 	list_del_init(&inode->i_list);
 	spin_lock(&sb_inode_list_lock);
@@ -1257,7 +1286,9 @@ static void iput_final(struct inode *inode)
 	spin_unlock(&inode_lock);
 	evict(inode);
 	spin_lock(&inode_lock);
+	spin_lock(&inode_hash_lock);
 	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
 	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 9974edb..35d6e81 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -11,6 +11,7 @@ struct backing_dev_info;
 
 extern spinlock_t inode_lock;
 extern spinlock_t sb_inode_list_lock;
+extern spinlock_t inode_hash_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
-- 
1.7.1

