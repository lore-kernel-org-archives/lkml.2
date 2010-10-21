Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0JUAu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:50:28 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:35893 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752447Ab0JUAu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:50:26 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/21] fs: Factor inode hash operations into functions
Date: Thu, 21 Oct 2010 11:49:34 +1100
Message-Id: <1287622186-1935-10-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287622186-1935-1-git-send-email-david@fromorbit.com>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Before replacing the inode hash locking with a more scalable
mechanism, factor the removal of the inode from the hashes rather
than open coding it in several places.

Based on a patch originally from Nick Piggin.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/inode.c |  100 +++++++++++++++++++++++++++++++++--------------------------
 1 files changed, 56 insertions(+), 44 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 77b71ce..cfcafee 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -359,6 +359,59 @@ void inode_lru_list_del(struct inode *inode)
 	}
 }
 
+static unsigned long hash(struct super_block *sb, unsigned long hashval)
+{
+	unsigned long tmp;
+
+	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) /
+			L1_CACHE_BYTES;
+	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> I_HASHBITS);
+	return tmp & I_HASHMASK;
+}
+
+/**
+ *	__insert_inode_hash - hash an inode
+ *	@inode: unhashed inode
+ *	@hashval: unsigned long value used to locate this object in the
+ *		inode_hashtable.
+ *
+ *	Add an inode to the inode hash for this superblock.
+ */
+void __insert_inode_hash(struct inode *inode, unsigned long hashval)
+{
+	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
+	spin_lock(&inode_lock);
+	hlist_add_head(&inode->i_hash, head);
+	spin_unlock(&inode_lock);
+}
+EXPORT_SYMBOL(__insert_inode_hash);
+
+/**
+ *	__remove_inode_hash - remove an inode from the hash
+ *	@inode: inode to unhash
+ *
+ *	Remove an inode from the superblock. inode->i_lock must be
+ *	held.
+ */
+static void __remove_inode_hash(struct inode *inode)
+{
+	hlist_del_init(&inode->i_hash);
+}
+
+/**
+ *	remove_inode_hash - remove an inode from the hash
+ *	@inode: inode to unhash
+ *
+ *	Remove an inode from the superblock.
+ */
+void remove_inode_hash(struct inode *inode)
+{
+	spin_lock(&inode_lock);
+	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_lock);
+}
+EXPORT_SYMBOL(remove_inode_hash);
+
 void end_writeback(struct inode *inode)
 {
 	might_sleep();
@@ -406,7 +459,7 @@ static void dispose_list(struct list_head *head)
 		evict(inode);
 
 		spin_lock(&inode_lock);
-		hlist_del_init(&inode->i_hash);
+		__remove_inode_hash(inode);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&inode_lock);
 
@@ -658,16 +711,6 @@ repeat:
 	return node ? inode : NULL;
 }
 
-static unsigned long hash(struct super_block *sb, unsigned long hashval)
-{
-	unsigned long tmp;
-
-	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) /
-			L1_CACHE_BYTES;
-	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> I_HASHBITS);
-	return tmp & I_HASHMASK;
-}
-
 static inline void
 __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
 			struct inode *inode)
@@ -1234,36 +1277,6 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 }
 EXPORT_SYMBOL(insert_inode_locked4);
 
-/**
- *	__insert_inode_hash - hash an inode
- *	@inode: unhashed inode
- *	@hashval: unsigned long value used to locate this object in the
- *		inode_hashtable.
- *
- *	Add an inode to the inode hash for this superblock.
- */
-void __insert_inode_hash(struct inode *inode, unsigned long hashval)
-{
-	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
-	spin_lock(&inode_lock);
-	hlist_add_head(&inode->i_hash, head);
-	spin_unlock(&inode_lock);
-}
-EXPORT_SYMBOL(__insert_inode_hash);
-
-/**
- *	remove_inode_hash - remove an inode from the hash
- *	@inode: inode to unhash
- *
- *	Remove an inode from the superblock.
- */
-void remove_inode_hash(struct inode *inode)
-{
-	spin_lock(&inode_lock);
-	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode_lock);
-}
-EXPORT_SYMBOL(remove_inode_hash);
 
 int generic_delete_inode(struct inode *inode)
 {
@@ -1319,6 +1332,7 @@ static void iput_final(struct inode *inode)
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		hlist_del_init(&inode->i_hash);
+		__remove_inode_hash(inode);
 	}
 	list_del_init(&inode->i_wb_list);
 	WARN_ON(inode->i_state & I_NEW);
@@ -1334,9 +1348,7 @@ static void iput_final(struct inode *inode)
 	list_del_init(&inode->i_sb_list);
 	spin_unlock(&inode_lock);
 	evict(inode);
-	spin_lock(&inode_lock);
-	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode_lock);
+	remove_inode_hash(inode);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
 	destroy_inode(inode);
-- 
1.7.1

