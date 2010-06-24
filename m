Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab0FXDQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:48457 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab0FXDPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:50 -0400
Message-Id: <20100624030731.908711604@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:51 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 39/52] fs: icache rcu walk for i_sb_list
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-11.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables locking to be reduced and ordering simplified.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/drop_caches.c            |   10 ++++----
 fs/inode.c                  |   53 +++++++++++++++-----------------------------
 fs/notify/inode_mark.c      |   10 --------
 fs/notify/inotify/inotify.c |   10 --------
 fs/quota/dquot.c            |   16 ++++++-------
 5 files changed, 32 insertions(+), 67 deletions(-)

Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c
+++ linux-2.6/fs/drop_caches.c
@@ -16,8 +16,8 @@ static void drop_pagecache_sb(struct sup
 {
 	struct inode *inode, *toput_inode = NULL;
 
-	spin_lock(&sb_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW)
 				|| inode->i_mapping->nrpages == 0) {
@@ -26,13 +26,13 @@ static void drop_pagecache_sb(struct sup
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
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -44,10 +44,10 @@
  *
  * Ordering:
  * inode_lock
- *   sb_inode_list_lock
- *     inode->i_lock
- *       wb_inode_list_lock
- *       inode_hash_bucket lock
+ *   inode->i_lock
+ *     sb_inode_list_lock
+ *     wb_inode_list_lock
+ *     inode_hash_bucket lock
  */
 /*
  * This is needed for the following functions:
@@ -379,12 +379,12 @@ static void dispose_list(struct list_hea
 			truncate_inode_pages(&inode->i_data, 0);
 		clear_inode(inode);
 
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
@@ -406,14 +406,6 @@ static int invalidate_list(struct list_h
 		struct list_head *tmp = next;
 		struct inode *inode;
 
-		/*
-		 * We can reschedule here without worrying about the list's
-		 * consistency because the per-sb list of inodes must not
-		 * change during umount anymore, and because iprune_sem keeps
-		 * shrink_icache_memory() away.
-		 */
-		cond_resched_lock(&sb_inode_list_lock);
-
 		next = next->next;
 		if (tmp == head)
 			break;
@@ -456,12 +448,17 @@ int invalidate_inodes(struct super_block
 	int busy;
 	LIST_HEAD(throw_away);
 
+	/*
+	 * Don't need to worry about the list's consistency because the per-sb
+	 * list of inodes must not change during umount anymore, and because
+	 * iprune_sem keeps shrink_icache_memory() away.
+	 */
 	down_write(&iprune_sem);
-	spin_lock(&sb_inode_list_lock);
+//	spin_lock(&sb_inode_list_lock); XXX: is this safe?
 	inotify_unmount_inodes(&sb->s_inodes);
 	fsnotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(&sb->s_inodes, &throw_away);
-	spin_unlock(&sb_inode_list_lock);
+//	spin_unlock(&sb_inode_list_lock);
 
 	dispose_list(&throw_away);
 	up_write(&iprune_sem);
@@ -665,7 +662,8 @@ __inode_add_to_lists(struct super_block
 			struct inode *inode)
 {
 	atomic_inc(&inodes_stat.nr_inodes);
-	list_add(&inode->i_sb_list, &sb->s_inodes);
+	spin_lock(&sb_inode_list_lock);
+	list_add_rcu(&inode->i_sb_list, &sb->s_inodes);
 	spin_unlock(&sb_inode_list_lock);
 	if (b) {
 		spin_lock_bucket(b);
@@ -690,7 +688,6 @@ void inode_add_to_lists(struct super_blo
 {
 	struct inode_hash_bucket *b = inode_hashtable + hash(sb, inode->i_ino);
 
-	spin_lock(&sb_inode_list_lock);
 	spin_lock(&inode->i_lock);
 	__inode_add_to_lists(sb, b, inode);
 	spin_unlock(&inode->i_lock);
@@ -722,7 +719,6 @@ struct inode *new_inode(struct super_blo
 	inode = alloc_inode(sb);
 	if (inode) {
 		/* XXX: init as locked for speedup */
-		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
 		inode->i_ino = atomic_inc_return(&last_ino);
 		inode->i_state = 0;
@@ -789,7 +785,6 @@ static struct inode *get_new_inode(struc
 		/* We released the lock, so.. */
 		old = find_inode(sb, b, test, data);
 		if (!old) {
-			spin_lock(&sb_inode_list_lock);
 			spin_lock(&inode->i_lock);
 			if (set(inode, data))
 				goto set_failed;
@@ -819,7 +814,6 @@ static struct inode *get_new_inode(struc
 
 set_failed:
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&sb_inode_list_lock);
 	destroy_inode(inode);
 	return NULL;
 }
@@ -840,7 +834,6 @@ static struct inode *get_new_inode_fast(
 		/* We released the lock, so.. */
 		old = find_inode_fast(sb, b, ino);
 		if (!old) {
-			spin_lock(&sb_inode_list_lock);
 			spin_lock(&inode->i_lock);
 			inode->i_ino = ino;
 			inode->i_state = I_NEW;
@@ -1320,7 +1313,8 @@ void generic_delete_inode(struct inode *
 		if (!inode->i_state)
 			atomic_dec(&inodes_stat.nr_unused);
 	}
-	list_del_init(&inode->i_sb_list);
+	spin_lock(&sb_inode_list_lock);
+	list_del_rcu(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
@@ -1377,15 +1371,12 @@ int generic_detach_inode(struct inode *i
 				atomic_inc(&inodes_stat.nr_unused);
 			}
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&sb_inode_list_lock);
 			return 0;
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
@@ -1398,7 +1389,8 @@ int generic_detach_inode(struct inode *i
 		if (!inode->i_state)
 			atomic_dec(&inodes_stat.nr_unused);
 	}
-	list_del_init(&inode->i_sb_list);
+	spin_lock(&sb_inode_list_lock);
+	list_del_rcu(&inode->i_sb_list);
 	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
@@ -1468,19 +1460,12 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state == I_CLEAR);
 
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
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c
+++ linux-2.6/fs/notify/inode_mark.c
@@ -412,14 +412,6 @@ void fsnotify_unmount_inodes(struct list
 			spin_unlock(&next_i->i_lock);
 		}
 
-		/*
-		 * We can safely drop inode_lock here because we hold
-		 * references on both inode and next_i.  Also no new inodes
-		 * will be added since the umount has begun.  Finally,
-		 * iprune_mutex keeps shrink_icache_memory() away.
-		 */
-		spin_unlock(&sb_inode_list_lock);
-
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
 
@@ -429,7 +421,5 @@ void fsnotify_unmount_inodes(struct list
 		fsnotify_inode_delete(inode);
 
 		iput(inode);
-
-		spin_lock(&sb_inode_list_lock);
 	}
 }
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -434,14 +434,6 @@ void inotify_unmount_inodes(struct list_
 			spin_unlock(&next_i->i_lock);
 		}
 
-		/*
-		 * We can safely drop inode_lock here because we hold
-		 * references on both inode and next_i.  Also no new inodes
-		 * will be added since the umount has begun.  Finally,
-		 * iprune_mutex keeps shrink_icache_memory() away.
-		 */
-		spin_unlock(&sb_inode_list_lock);
-
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
 
@@ -459,8 +451,6 @@ void inotify_unmount_inodes(struct list_
 		}
 		mutex_unlock(&inode->inotify_mutex);
 		iput(inode);		
-
-		spin_lock(&sb_inode_list_lock);
 	}
 }
 EXPORT_SYMBOL_GPL(inotify_unmount_inodes);
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c
+++ linux-2.6/fs/quota/dquot.c
@@ -883,8 +883,8 @@ static void add_dquot_ref(struct super_b
 	int reserved = 0;
 #endif
 
-	spin_lock(&sb_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW)) {
 			spin_unlock(&inode->i_lock);
@@ -905,7 +905,7 @@ static void add_dquot_ref(struct super_b
 
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb_inode_list_lock);
+		rcu_read_unlock();
 
 		iput(old_inode);
 		__dquot_initialize(inode, type);
@@ -915,9 +915,9 @@ static void add_dquot_ref(struct super_b
 		 * reference and we cannot iput it under inode_lock. So we
 		 * keep the reference and iput it later. */
 		old_inode = inode;
-		spin_lock(&sb_inode_list_lock);
+		rcu_read_lock();
 	}
-	spin_unlock(&sb_inode_list_lock);
+	rcu_read_unlock();
 	iput(old_inode);
 
 #ifdef CONFIG_QUOTA_DEBUG
@@ -995,8 +995,8 @@ static void remove_dquot_ref(struct supe
 {
 	struct inode *inode;
 
-	spin_lock(&sb_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
 		 *  have quota pointer initialized. Luckily, we need to touch
@@ -1006,7 +1006,7 @@ static void remove_dquot_ref(struct supe
 		if (!IS_NOQUOTA(inode))
 			remove_inode_dquot_ref(inode, type, tofree_head);
 	}
-	spin_unlock(&sb_inode_list_lock);
+	rcu_read_unlock();
 }
 
 /* Gather all references from inodes and drop them */


