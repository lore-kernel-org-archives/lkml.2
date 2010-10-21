Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab0JUNZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:25:39 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:7306 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757970Ab0JUNWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+CeYJRBIpNhQE
Message-Id: <20101021131016.418539210@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:34 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 05/14] fs: icache lock s_inodes list
References: <20101021130829.442910807@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect sb->s_inodes with a new lock, sb_inode_list_lock.

[note: we could actually start lifting inode_lock away from
s_inodes lookups now, because they don't tend to be particularly
coupled with other inode_lock "sub-classes"]

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/drop_caches.c          |   11 ++++++++++-
 fs/fs-writeback.c         |   11 ++++++++++-
 fs/inode.c                |   10 ++++++++++
 fs/notify/inode_mark.c    |   27 ++++++++++++++++++++++++---
 fs/quota/dquot.c          |   22 ++++++++++++++++++++--
 include/linux/writeback.h |    1 +
 6 files changed, 75 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/drop_caches.c	2010-10-21 23:50:43.000000000 +1100
@@ -17,8 +17,14 @@ static void drop_pagecache_sb(struct sup
 	struct inode *inode, *toput_inode = NULL;
 
 	spin_lock(&inode_lock);
+lock_again:
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		spin_lock(&inode->i_lock);
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&sb_inode_list_lock);
+			cpu_relax();
+			goto lock_again;
+		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -29,12 +35,15 @@ static void drop_pagecache_sb(struct sup
 		}
 		inode_get_ilock(inode);
 		spin_unlock(&inode->i_lock);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
 		toput_inode = inode;
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	iput(toput_inode);
 }
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-21 23:50:44.000000000 +1100
@@ -1042,6 +1042,8 @@ static void wait_sb_inodes(struct super_
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_lock);
+lock_again:
+	spin_lock(&sb_inode_list_lock);
 
 	/*
 	 * Data integrity sync. Must wait for all pages under writeback,
@@ -1053,7 +1055,11 @@ static void wait_sb_inodes(struct super_
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		struct address_space *mapping;
 
-		spin_lock(&inode->i_lock);
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&sb_inode_list_lock);
+			cpu_relax();
+			goto lock_again;
+		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -1065,6 +1071,7 @@ static void wait_sb_inodes(struct super_
 		}
 		inode_get_ilock(inode);
 		spin_unlock(&inode->i_lock);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		/*
 		 * We hold a reference to 'inode' so it couldn't have
@@ -1082,7 +1089,9 @@ static void wait_sb_inodes(struct super_
 		cond_resched();
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	iput(old_inode);
 }
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-21 23:50:45.000000000 +1100
@@ -37,10 +37,13 @@
  *   i_hash
  *   i_list
  *   i_sb_list
+ * sb_inode_list_lock protects:
+ *   s_inodes, i_sb_list
  *
  * Ordering:
  * inode_lock
  *   i_lock
+ *     sb_inode_list_lock
  */
 /*
  * This is needed for the following functions:
@@ -100,6 +103,7 @@ static struct hlist_head *inode_hashtabl
  * the i_state of an inode while it is in use..
  */
 DEFINE_SPINLOCK(inode_lock);
+DEFINE_SPINLOCK(sb_inode_list_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -387,7 +391,9 @@ static void dispose_list(struct list_hea
 		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 
@@ -661,7 +667,9 @@ __inode_add_to_lists(struct super_block
 {
 	inodes_stat.nr_inodes++;
 	list_add(&inode->i_list, &inode_in_use);
+	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
+	spin_unlock(&sb_inode_list_lock);
 	if (head)
 		hlist_add_head(&inode->i_hash, head);
 }
@@ -1333,7 +1341,9 @@ static void iput_final(struct inode *ino
 		hlist_del_init(&inode->i_hash);
 	}
 	list_del_init(&inode->i_list);
+	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
+	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/quota/dquot.c	2010-10-21 23:50:43.000000000 +1100
@@ -898,8 +898,14 @@ static void add_dquot_ref(struct super_b
 #endif
 
 	spin_lock(&inode_lock);
+lock_again:
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		spin_lock(&inode->i_lock);
+		if (!spin_trylock(&inode->i_lock)) {
+			spin_unlock(&sb_inode_list_lock);
+			cpu_relax();
+			goto lock_again;
+		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -918,6 +924,7 @@ static void add_dquot_ref(struct super_b
 		}
 
 		inode_get_ilock(inode);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 
@@ -930,7 +937,9 @@ static void add_dquot_ref(struct super_b
 		 * keep the reference and iput it later. */
 		old_inode = inode;
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	iput(old_inode);
 
@@ -1013,6 +1022,8 @@ static void remove_dquot_ref(struct supe
 	int reserved = 0;
 
 	spin_lock(&inode_lock);
+lock_again:
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
@@ -1021,11 +1032,18 @@ static void remove_dquot_ref(struct supe
 		 *  (dqptr_sem).
 		 */
 		if (!IS_NOQUOTA(inode)) {
-			if (unlikely(inode_get_rsv_space(inode) > 0))
+			if (!spin_trylock(&inode->i_lock)) {
+				spin_unlock(&sb_inode_list_lock);
+				cpu_relax();
+				goto lock_again;
+			}
+			if (unlikely(__inode_get_rsv_space(inode) > 0))
 				reserved = 1;
 			remove_inode_dquot_ref(inode, type, tofree_head);
+			spin_unlock(&inode->i_lock);
 		}
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 #ifdef CONFIG_QUOTA_DEBUG
 	if (reserved) {
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h	2010-10-21 23:49:53.000000000 +1100
+++ linux-2.6/include/linux/writeback.h	2010-10-21 23:50:44.000000000 +1100
@@ -10,6 +10,7 @@
 struct backing_dev_info;
 
 extern spinlock_t inode_lock;
+extern spinlock_t sb_inode_list_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/notify/inode_mark.c	2010-10-21 23:50:43.000000000 +1100
@@ -242,17 +242,35 @@ void fsnotify_unmount_inodes(struct supe
 	struct inode *inode, *next_i, *need_iput = NULL;
 
 	spin_lock(&inode_lock);
+lock_again:
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
 		struct inode *need_iput_tmp;
 
+		if (!spin_trylock(&inode->i_lock)) {
+lock_again_2:
+			spin_unlock(&sb_inode_list_lock);
+			cpu_relax();
+			goto lock_again;
+		}
+		/*
+		 * Nasty hack, we have to lock this inode in case
+		 * we need to increment its refcount. Will be able
+		 * to go away when we RCU walk the s_inodes list.
+		 */
+		if (!spin_trylock(&next_i->i_lock)) {
+			spin_unlock(&inode->i_lock);
+			goto lock_again_2;
+		}
+
 		/*
 		 * We cannot inode_get() an inode in state I_FREEING,
 		 * I_WILL_FREE, or I_NEW which is fine because by that point
 		 * the inode cannot have any associated watches.
 		 */
-		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
 			spin_unlock(&inode->i_lock);
+			spin_unlock(&next_i->i_lock);
 			continue;
 		}
 
@@ -264,6 +282,7 @@ void fsnotify_unmount_inodes(struct supe
 		 */
 		if (!inode->i_count) {
 			spin_unlock(&inode->i_lock);
+			spin_unlock(&next_i->i_lock);
 			continue;
 		}
 
@@ -279,14 +298,13 @@ void fsnotify_unmount_inodes(struct supe
 
 		/* In case the dropping of a reference would nuke next_i. */
 		if ((&next_i->i_sb_list != list)) {
-			spin_lock(&next_i->i_lock);
 			if (next_i->i_count &&
 			    !(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
 				inode_get_ilock(next_i);
 				need_iput = next_i;
 			}
-			spin_unlock(&next_i->i_lock);
 		}
+		spin_unlock(&next_i->i_lock);
 
 		/*
 		 * We can safely drop inode_lock here because we hold
@@ -294,6 +312,7 @@ void fsnotify_unmount_inodes(struct supe
 		 * will be added since the umount has begun.  Finally,
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
@@ -307,6 +326,8 @@ void fsnotify_unmount_inodes(struct supe
 		iput(inode);
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 }


