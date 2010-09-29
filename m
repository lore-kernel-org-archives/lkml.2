Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0I2MTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:19:23 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:50421 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755366Ab0I2MTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:19 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/17] fs: Factor inode hash operations into functions
Date: Wed, 29 Sep 2010 22:18:43 +1000
Message-Id: <1285762729-17928-12-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Before we can replace the inode hash locking with a more scalable
mechanism, we need to remove external users of the inode_hash_lock.
Make it private by adding a function __remove_inode_hash that can be
called by filesystems instead of open-coding their own inode hash
removal operations.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c                |   39 ++++++++++++++++++++++++---------------
 include/linux/fs.h        |    1 +
 include/linux/writeback.h |    1 -
 3 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 153f8d2..24141cc 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -105,7 +105,7 @@ static struct hlist_head *inode_hashtable __read_mostly;
  */
 DEFINE_SPINLOCK(sb_inode_list_lock);
 DEFINE_SPINLOCK(wb_inode_list_lock);
-DEFINE_SPINLOCK(inode_hash_lock);
+static DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -371,9 +371,7 @@ static void dispose_list(struct list_head *head)
 
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
-		spin_lock(&inode_hash_lock);
-		hlist_del_init(&inode->i_hash);
-		spin_unlock(&inode_hash_lock);
+		__remove_inode_hash(inode);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
@@ -1274,6 +1272,20 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 EXPORT_SYMBOL(__insert_inode_hash);
 
 /**
+ *	__remove_inode_hash - remove an inode from the hash
+ *	@inode: inode to unhash
+ *
+ *	Remove an inode from the superblock. inode->i_lock must be
+ *	held.
+ */
+void __remove_inode_hash(struct inode *inode)
+{
+	spin_lock(&inode_hash_lock);
+	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_hash_lock);
+}
+
+/**
  *	remove_inode_hash - remove an inode from the hash
  *	@inode: inode to unhash
  *
@@ -1282,9 +1294,7 @@ EXPORT_SYMBOL(__insert_inode_hash);
 void remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode->i_lock);
-	spin_lock(&inode_hash_lock);
-	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode_hash_lock);
+	__remove_inode_hash(inode);
 	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(remove_inode_hash);
@@ -1348,9 +1358,7 @@ static void iput_final(struct inode *inode)
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
-		spin_lock(&inode_hash_lock);
-		hlist_del_init(&inode->i_hash);
-		spin_unlock(&inode_hash_lock);
+		__remove_inode_hash(inode);
 		atomic_dec(&inodes_stat.nr_unused);
 	}
 	spin_lock(&wb_inode_list_lock);
@@ -1363,11 +1371,12 @@ static void iput_final(struct inode *inode)
 	spin_unlock(&inode->i_lock);
 	atomic_dec(&inodes_stat.nr_inodes);
 	evict(inode);
-	spin_lock(&inode->i_lock);
-	spin_lock(&inode_hash_lock);
-	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode_hash_lock);
-	spin_unlock(&inode->i_lock);
+
+	/*
+	 * i_lock is required to delete from hash because find_inode_fast
+	 * might find us but go to sleep before we run wake_up_inode.
+	 */
+	remove_inode_hash(inode);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
 	destroy_inode(inode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 46a51b9..da0ebf1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2186,6 +2186,7 @@ extern int should_remove_suid(struct dentry *);
 extern int file_remove_suid(struct file *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
+extern void __remove_inode_hash(struct inode *);
 extern void remove_inode_hash(struct inode *);
 static inline void insert_inode_hash(struct inode *inode) {
 	__insert_inode_hash(inode, inode->i_ino);
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index d266f0d..0f6fe0c 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -11,7 +11,6 @@ struct backing_dev_info;
 
 extern spinlock_t sb_inode_list_lock;
 extern spinlock_t wb_inode_list_lock;
-extern spinlock_t inode_hash_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
-- 
1.7.1

