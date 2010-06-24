Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0FXDWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:22:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:48504 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab0FXDQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:16:08 -0400
Message-Id: <20100624030731.264836909@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:47 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 35/52] fs: icache factor hash lock into functions
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-8.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make inode_hash_lock private by adding a function __remove_inode_hash
that can be used by filesystems defining their own drop_inode functions.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/inode.c                |   42 +++++++++++++++++++++++++++---------------
 include/linux/fs.h        |    1 +
 include/linux/writeback.h |    1 -
 3 files changed, 28 insertions(+), 16 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -107,7 +107,7 @@ static struct hlist_head *inode_hashtabl
  */
 DEFINE_SPINLOCK(sb_inode_list_lock);
 DEFINE_SPINLOCK(wb_inode_list_lock);
-DEFINE_SPINLOCK(inode_hash_lock);
+static DEFINE_SPINLOCK(inode_hash_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -377,9 +377,7 @@ static void dispose_list(struct list_hea
 
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
-		spin_lock(&inode_hash_lock);
-		hlist_del_init(&inode->i_hash);
-		spin_unlock(&inode_hash_lock);
+		__remove_inode_hash(inode);
 		list_del_init(&inode->i_sb_list);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb_inode_list_lock);
@@ -1280,6 +1278,20 @@ void __insert_inode_hash(struct inode *i
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
@@ -1288,9 +1300,7 @@ EXPORT_SYMBOL(__insert_inode_hash);
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
@@ -1332,11 +1342,15 @@ void generic_delete_inode(struct inode *
 		truncate_inode_pages(&inode->i_data, 0);
 		clear_inode(inode);
 	}
-	spin_lock(&inode->i_lock);
-	spin_lock(&inode_hash_lock);
-	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode_hash_lock);
-	spin_unlock(&inode->i_lock);
+	/*
+	 * i_lock not required to delete from hash. If there was a
+	 * concurrency window, then it would be possible for the other
+	 * thread to touch the inode after it has been freed, with
+	 * destroy_inode.
+	 * XXX: yes it is because find_inode_fast checks it. Maybe we
+	 * can avoid it though...
+	 */
+	remove_inode_hash(inode);
 	wake_up_inode(inode);
 	BUG_ON(inode->i_state != I_CLEAR);
 	destroy_inode(inode);
@@ -1377,9 +1391,7 @@ int generic_detach_inode(struct inode *i
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
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -2181,6 +2181,7 @@ extern int should_remove_suid(struct den
 extern int file_remove_suid(struct file *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
+extern void __remove_inode_hash(struct inode *);
 extern void remove_inode_hash(struct inode *);
 static inline void insert_inode_hash(struct inode *inode) {
 	__insert_inode_hash(inode, inode->i_ino);
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -11,7 +11,6 @@ struct backing_dev_info;
 
 extern spinlock_t sb_inode_list_lock;
 extern spinlock_t wb_inode_list_lock;
-extern spinlock_t inode_hash_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 


