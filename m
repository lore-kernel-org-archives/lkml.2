Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab0JSEAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:00:37 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28439 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933503Ab0JSD4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaCeIJRBIUMhT6FAA
Message-Id: <20101019034657.590452043@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:36 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 20/35] fs: icache rcu walk for i_sb_list
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-11.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables locking to be reduced and ordering simplified.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 Documentation/filesystems/Locking |    2 -
 Documentation/filesystems/vfs.txt |    2 -
 fs/drop_caches.c                  |   10 ++++-----
 fs/fs-writeback.c                 |   19 ++++++++---------
 fs/inode.c                        |   41 ++++++++++++--------------------------
 fs/quota/dquot.c                  |   18 ++++++++--------
 6 files changed, 39 insertions(+), 53 deletions(-)

Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/drop_caches.c	2010-10-19 14:19:24.000000000 +1100
@@ -16,8 +16,8 @@
 {
 	struct inode *inode, *toput_inode = NULL;
 
-	spin_lock(&sb_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)
 				|| inode->i_mapping->nrpages == 0) {
@@ -26,13 +26,13 @@
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb_inode_list_lock);
+		rcu_read_unlock();
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
 		toput_inode = inode;
-		spin_lock(&sb_inode_list_lock);
+		rcu_read_lock();
 	}
-	spin_unlock(&sb_inode_list_lock);
+	rcu_read_unlock();
 	iput(toput_inode);
 }
 
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:24.000000000 +1100
@@ -42,10 +42,10 @@
  *   i_sb_list
  *
  * Ordering:
- * sb_inode_list_lock
- *   inode->i_lock
- *     wb_inode_list_lock
- *     inode_hash_bucket lock
+ * inode->i_lock
+ *   sb_inode_list_lock
+ *   wb_inode_list_lock
+ *   inode_hash_bucket lock
  */
 /*
  * This is needed for the following functions:
@@ -382,12 +382,12 @@
 
 		evict(inode);
 
-		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		__remove_inode_hash(inode);
-		list_del_init(&inode->i_sb_list);
-		spin_unlock(&inode->i_lock);
+		spin_lock(&sb_inode_list_lock);
+		list_del_rcu(&inode->i_sb_list);
 		spin_unlock(&sb_inode_list_lock);
+		spin_unlock(&inode->i_lock);
 
 		wake_up_inode(inode);
 		destroy_inode(inode);
@@ -696,7 +696,8 @@
 __inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
 			struct inode *inode)
 {
-	list_add(&inode->i_sb_list, &sb->s_inodes);
+	spin_lock(&sb_inode_list_lock);
+	list_add_rcu(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
 	if (b) {
 		spin_lock_bucket(b);
@@ -721,7 +722,6 @@
 {
 	struct inode_hash_bucket *b = inode_hashtable + hash(sb, inode->i_ino);
 
-	spin_lock(&sb_inode_list_lock);
 	spin_lock(&inode->i_lock);
 	__inode_add_to_lists(sb, b, inode);
 	spin_unlock(&inode->i_lock);
@@ -752,7 +752,6 @@
 
 	inode = alloc_inode(sb);
 	if (inode) {
-		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		inode->i_ino = (unsigned int)atomic_inc_return(&last_ino);
 		inode->i_state = 0;
@@ -819,7 +818,6 @@
 		/* We released the lock, so.. */
 		old = find_inode(sb, b, test, data);
 		if (!old) {
-			spin_lock(&sb_inode_list_lock);
 			spin_lock(&inode->i_lock);
 			if (set(inode, data))
 				goto set_failed;
@@ -849,7 +847,6 @@
 
 set_failed:
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&sb_inode_list_lock);
 	destroy_inode(inode);
 	return NULL;
 }
@@ -870,7 +867,6 @@
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, b, ino);
 		if (!old) {
-			spin_lock(&sb_inode_list_lock);
 			spin_lock(&inode->i_lock);
 			inode->i_ino = ino;
 			inode->i_state = I_NEW;
@@ -1380,15 +1376,12 @@
 				atomic_inc(&inodes_stat.nr_unused);
 			}
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&sb_inode_list_lock);
 			return;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb_inode_list_lock);
 		write_inode_now(inode, 1);
-		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
@@ -1401,7 +1394,8 @@
 		if (!inode->i_state)
 			atomic_dec(&inodes_stat.nr_unused);
 	}
-	list_del_init(&inode->i_sb_list);
+	spin_lock(&sb_inode_list_lock);
+	list_del_rcu(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
@@ -1431,19 +1425,12 @@
 	if (inode) {
 		BUG_ON(inode->i_state & I_CLEAR);
 
-retry:
 		spin_lock(&inode->i_lock);
-		if (inode->i_count == 1) {
-			if (!spin_trylock(&sb_inode_list_lock)) {
-				spin_unlock(&inode->i_lock);
-				goto retry;
-			}
-			inode->i_count--;
+		inode->i_count--;
+		if (inode->i_count == 0)
 			iput_final(inode);
-		} else {
-			inode->i_count--;
+		else
 			spin_unlock(&inode->i_lock);
-		}
 	}
 }
 EXPORT_SYMBOL(iput);
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/quota/dquot.c	2010-10-19 14:19:23.000000000 +1100
@@ -897,8 +897,8 @@
 	int reserved = 0;
 #endif
 
-	spin_lock(&sb_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
 			spin_unlock(&inode->i_lock);
@@ -919,19 +919,19 @@
 
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb_inode_list_lock);
+		rcu_read_unlock();
 
 		iput(old_inode);
 		__dquot_initialize(inode, type);
 		/* We hold a reference to 'inode' so it couldn't have been
 		 * removed from s_inodes list while we dropped the
-		 * sb_inode_list_lock.  We cannot iput the inode now as we can
+		 * i_lock.  We cannot iput the inode now as we can
 		 * be holding the last reference and we cannot iput it under
 		 * lock. So we keep the reference and iput it later. */
 		old_inode = inode;
-		spin_lock(&sb_inode_list_lock);
+		rcu_read_lock();
 	}
-	spin_unlock(&sb_inode_list_lock);
+	rcu_read_unlock();
 	iput(old_inode);
 
 #ifdef CONFIG_QUOTA_DEBUG
@@ -1012,8 +1012,8 @@
 	struct inode *inode;
 	int reserved = 0;
 
-	spin_lock(&sb_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
 		 *  have quota pointer initialized. Luckily, we need to touch
@@ -1026,7 +1026,7 @@
 			remove_inode_dquot_ref(inode, type, tofree_head);
 		}
 	}
-	spin_unlock(&sb_inode_list_lock);
+	rcu_read_unlock();
 #ifdef CONFIG_QUOTA_DEBUG
 	if (reserved) {
 		printk(KERN_WARNING "VFS (%s): Writes happened after quota"
Index: linux-2.6/Documentation/filesystems/Locking
===================================================================
--- linux-2.6.orig/Documentation/filesystems/Locking	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/Documentation/filesystems/Locking	2010-10-19 14:18:59.000000000 +1100
@@ -114,7 +114,7 @@
 destroy_inode:
 dirty_inode:				(must not sleep)
 write_inode:
-drop_inode:				!!!i_lock, sb_inode_list_lock!!!
+drop_inode:				!!!i_lock!!!
 evict_inode:
 put_super:		write
 write_super:		read
Index: linux-2.6/Documentation/filesystems/vfs.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/vfs.txt	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/Documentation/filesystems/vfs.txt	2010-10-19 14:19:16.000000000 +1100
@@ -246,7 +246,7 @@
 	should be synchronous or not, not all filesystems check this flag.
 
   drop_inode: called when the last access to the inode is dropped,
-	with the i_lock and sb_inode_list_lock spinlock held.
+	with the i_lock spinlock held.
 
 	This method should be either NULL (normal UNIX filesystem
 	semantics) or "generic_delete_inode" (for filesystems that do not
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:24.000000000 +1100
@@ -1061,8 +1061,6 @@
 	 */
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	spin_lock(&sb_inode_list_lock);
-
 	/*
 	 * Data integrity sync. Must wait for all pages under writeback,
 	 * because there may have been pages dirtied before our sync
@@ -1070,7 +1068,8 @@
 	 * In which case, the inode may not be on the dirty list, but
 	 * we still have to wait for that writeout.
 	 */
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
 		struct address_space *mapping;
 
 		spin_lock(&inode->i_lock);
@@ -1087,13 +1086,13 @@
 
  		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb_inode_list_lock);
+		rcu_read_unlock();
 		/*
 		 * We hold a reference to 'inode' so it couldn't have been
-		 * removed from s_inodes list while we dropped the
-		 * sb_inode_list_lock.  We cannot iput the inode now as we can
-		 * be holding the last reference and we cannot iput it under
-		 * spinlock. So we keep the reference and iput it later.
+		 * removed from s_inodes list while we dropped the i_lock.  We
+		 * cannot iput the inode now as we can be holding the last
+		 * reference and we cannot iput it under spinlock. So we keep
+		 * the reference and iput it later.
 		 */
 		iput(old_inode);
 		old_inode = inode;
@@ -1102,9 +1101,9 @@
 
 		cond_resched();
 
-		spin_lock(&sb_inode_list_lock);
+		rcu_read_lock();
 	}
-	spin_unlock(&sb_inode_list_lock);
+	rcu_read_unlock();
 	iput(old_inode);
 }
 


