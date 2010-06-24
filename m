Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab0FXDQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab0FXDPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:47 -0400
Message-Id: <20100624030729.765849671@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:38 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 26/52] fs: icache lock s_inodes list
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect sb->s_inodes with a new lock, sb_inode_list_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/drop_caches.c            |    4 ++++
 fs/fs-writeback.c           |    4 ++++
 fs/inode.c                  |   12 ++++++++++++
 fs/notify/inode_mark.c      |    2 ++
 fs/notify/inotify/inotify.c |    2 ++
 fs/quota/dquot.c            |    6 ++++++
 include/linux/writeback.h   |    1 +
 7 files changed, 31 insertions(+)

Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c
+++ linux-2.6/fs/drop_caches.c
@@ -17,18 +17,22 @@ static void drop_pagecache_sb(struct sup
 	struct inode *inode, *toput_inode = NULL;
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
 			continue;
 		if (inode->i_mapping->nrpages == 0)
 			continue;
 		__iget(inode);
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
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -1166,6 +1166,7 @@ static void wait_sb_inodes(struct super_
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 
 	/*
 	 * Data integrity sync. Must wait for all pages under writeback,
@@ -1183,6 +1184,7 @@ static void wait_sb_inodes(struct super_
 		if (mapping->nrpages == 0)
 			continue;
 		__iget(inode);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		/*
 		 * We hold a reference to 'inode' so it couldn't have
@@ -1200,7 +1202,9 @@ static void wait_sb_inodes(struct super_
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
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -27,6 +27,15 @@
 #include <linux/posix_acl.h>
 
 /*
+ * Usage:
+ * sb_inode_list_lock protects:
+ *   s_inodes, i_sb_list
+ *
+ * Ordering:
+ * inode_lock
+ *   sb_inode_list_lock
+ */
+/*
  * This is needed for the following functions:
  *  - inode_has_buffers
  *  - invalidate_inode_buffers
@@ -84,6 +93,7 @@ static struct hlist_head *inode_hashtabl
  * the i_state of an inode while it is in use..
  */
 DEFINE_SPINLOCK(inode_lock);
+DEFINE_SPINLOCK(sb_inode_list_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -344,7 +354,9 @@ static void dispose_list(struct list_hea
 
 		spin_lock(&inode_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
 		wake_up_inode(inode);
@@ -376,6 +388,7 @@ static int invalidate_list(struct list_h
 		 * shrink_icache_memory() away.
 		 */
 		cond_resched_lock(&inode_lock);
+		cond_resched_lock(&sb_inode_list_lock);
 
 		next = next->next;
 		if (tmp == head)
@@ -413,9 +426,11 @@ int invalidate_inodes(struct super_block
 
 	down_write(&iprune_sem);
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	inotify_unmount_inodes(&sb->s_inodes);
 	fsnotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(&sb->s_inodes, &throw_away);
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 
 	dispose_list(&throw_away);
@@ -603,7 +618,9 @@ __inode_add_to_lists(struct super_block
 {
 	inodes_stat.nr_inodes++;
 	list_add(&inode->i_list, &inode_in_use);
+	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
+	spin_unlock(&sb_inode_list_lock);
 	if (head)
 		hlist_add_head(&inode->i_hash, head);
 }
@@ -1197,7 +1214,9 @@ void generic_delete_inode(struct inode *
 	const struct super_operations *op = inode->i_sb->s_op;
 
 	list_del_init(&inode->i_list);
+	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
+	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
@@ -1255,7 +1274,9 @@ int generic_detach_inode(struct inode *i
 		hlist_del_init(&inode->i_hash);
 	}
 	list_del_init(&inode->i_list);
+	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
+	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -429,6 +429,7 @@ void inotify_unmount_inodes(struct list_
 		 * will be added since the umount has begun.  Finally,
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
@@ -451,6 +452,7 @@ void inotify_unmount_inodes(struct list_
 		iput(inode);		
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
 }
 EXPORT_SYMBOL_GPL(inotify_unmount_inodes);
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c
+++ linux-2.6/fs/quota/dquot.c
@@ -884,6 +884,7 @@ static void add_dquot_ref(struct super_b
 #endif
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
 			continue;
@@ -897,6 +898,7 @@ static void add_dquot_ref(struct super_b
 			continue;
 
 		__iget(inode);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
 		iput(old_inode);
@@ -908,7 +910,9 @@ static void add_dquot_ref(struct super_b
 		 * keep the reference and iput it later. */
 		old_inode = inode;
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	iput(old_inode);
 
@@ -988,6 +992,7 @@ static void remove_dquot_ref(struct supe
 	struct inode *inode;
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
@@ -998,6 +1003,7 @@ static void remove_dquot_ref(struct supe
 		if (!IS_NOQUOTA(inode))
 			remove_inode_dquot_ref(inode, type, tofree_head);
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 }
 
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -10,6 +10,7 @@
 struct backing_dev_info;
 
 extern spinlock_t inode_lock;
+extern spinlock_t sb_inode_list_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c
+++ linux-2.6/fs/notify/inode_mark.c
@@ -408,6 +408,7 @@ void fsnotify_unmount_inodes(struct list
 		 * will be added since the umount has begun.  Finally,
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
@@ -421,5 +422,6 @@ void fsnotify_unmount_inodes(struct list
 		iput(inode);
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
 }


