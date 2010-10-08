Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0JHFYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:24:30 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:60938 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752692Ab0JHFWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:22:15 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/18] fs: add a per-superblock lock for the inode list
Date: Fri,  8 Oct 2010 16:21:26 +1100
Message-Id: <1286515292-15882-13-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286515292-15882-1-git-send-email-david@fromorbit.com>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To allow removal of the inode_lock, we first need to protect the
superblock inode list with its own lock instead of using the
inode_lock. Add a lock to the superblock to protect this list and
nest the new lock inside the inode_lock around the list operations
it needs to protect.

Based on a patch originally from Nick Piggin.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/drop_caches.c       |    4 ++++
 fs/fs-writeback.c      |    4 ++++
 fs/inode.c             |   22 +++++++++++++++++++---
 fs/notify/inode_mark.c |    3 +++
 fs/quota/dquot.c       |    6 ++++++
 fs/super.c             |    1 +
 include/linux/fs.h     |    1 +
 7 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index c4f3e06..c808ca8 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -17,18 +17,22 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 	struct inode *inode, *toput_inode = NULL;
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb->s_inodes_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
 			continue;
 		if (inode->i_mapping->nrpages == 0)
 			continue;
 		iref_locked(inode);
+		spin_unlock(&sb->s_inodes_lock);
 		spin_unlock(&inode_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
 		toput_inode = inode;
 		spin_lock(&inode_lock);
+		spin_lock(&sb->s_inodes_lock);
 	}
+	spin_unlock(&sb->s_inodes_lock);
 	spin_unlock(&inode_lock);
 	iput(toput_inode);
 }
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d63ab47..29f8032 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1026,6 +1026,7 @@ static void wait_sb_inodes(struct super_block *sb)
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb->s_inodes_lock);
 
 	/*
 	 * Data integrity sync. Must wait for all pages under writeback,
@@ -1043,6 +1044,7 @@ static void wait_sb_inodes(struct super_block *sb)
 		if (mapping->nrpages == 0)
 			continue;
 		iref_locked(inode);
+		spin_unlock(&sb->s_inodes_lock);
 		spin_unlock(&inode_lock);
 		/*
 		 * We hold a reference to 'inode' so it couldn't have
@@ -1060,7 +1062,9 @@ static void wait_sb_inodes(struct super_block *sb)
 		cond_resched();
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb->s_inodes_lock);
 	}
+	spin_unlock(&sb->s_inodes_lock);
 	spin_unlock(&inode_lock);
 	iput(old_inode);
 }
diff --git a/fs/inode.c b/fs/inode.c
index 3c07719..e6bb36d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -33,13 +33,18 @@
  *   i_ref
  * inode_hash_bucket lock protects:
  *   inode hash table, i_hash
+ * sb inode lock protects:
+ *   s_inodes, i_sb_list
  *
  * Lock orders
  * inode_lock
  *   inode hash bucket lock
  *     inode->i_lock
+ *
+ * inode_lock
+ *   sb inode lock
+ *     inode->i_lock
  */
-
 /*
  * This is needed for the following functions:
  *  - inode_has_buffers
@@ -488,7 +493,9 @@ static void dispose_list(struct list_head *head)
 
 		spin_lock(&inode_lock);
 		__remove_inode_hash(inode);
+		spin_lock(&inode->i_sb->s_inodes_lock);
 		list_del_init(&inode->i_sb_list);
+		spin_unlock(&inode->i_sb->s_inodes_lock);
 		spin_unlock(&inode_lock);
 
 		wake_up_inode(inode);
@@ -499,7 +506,8 @@ static void dispose_list(struct list_head *head)
 /*
  * Invalidate all inodes for a device.
  */
-static int invalidate_list(struct list_head *head, struct list_head *dispose)
+static int invalidate_list(struct super_block *sb, struct list_head *head,
+			struct list_head *dispose)
 {
 	struct list_head *next;
 	int busy = 0;
@@ -516,6 +524,7 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 		 * shrink_icache_memory() away.
 		 */
 		cond_resched_lock(&inode_lock);
+		cond_resched_lock(&sb->s_inodes_lock);
 
 		next = next->next;
 		if (tmp == head)
@@ -555,8 +564,10 @@ int invalidate_inodes(struct super_block *sb)
 
 	down_write(&iprune_sem);
 	spin_lock(&inode_lock);
+	spin_lock(&sb->s_inodes_lock);
 	fsnotify_unmount_inodes(&sb->s_inodes);
-	busy = invalidate_list(&sb->s_inodes, &throw_away);
+	busy = invalidate_list(sb, &sb->s_inodes, &throw_away);
+	spin_unlock(&sb->s_inodes_lock);
 	spin_unlock(&inode_lock);
 
 	dispose_list(&throw_away);
@@ -753,7 +764,9 @@ static inline void
 __inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
 			struct inode *inode)
 {
+	spin_lock(&sb->s_inodes_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
+	spin_unlock(&sb->s_inodes_lock);
 	if (b) {
 		spin_lock_bucket(b);
 		hlist_bl_add_head(&inode->i_hash, &b->head);
@@ -1397,7 +1410,10 @@ static void iput_final(struct inode *inode)
 		percpu_counter_dec(&nr_inodes_unused);
 	}
 
+	spin_lock(&sb->s_inodes_lock);
 	list_del_init(&inode->i_sb_list);
+	spin_unlock(&sb->s_inodes_lock);
+
 	spin_unlock(&inode_lock);
 	evict(inode);
 	remove_inode_hash(inode);
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 2fe319b..3389ff0 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -242,6 +242,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 
 	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
 		struct inode *need_iput_tmp;
+		struct super_block *sb = inode->i_sb;
 
 		/*
 		 * We cannot iref() an inode in state I_FREEING,
@@ -288,6 +289,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		 * will be added since the umount has begun.  Finally,
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
+		spin_unlock(&sb->s_inodes_lock);
 		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
@@ -301,5 +303,6 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		iput(inode);
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb->s_inodes_lock);
 	}
 }
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 5199418..b7cbc41 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -897,6 +897,7 @@ static void add_dquot_ref(struct super_block *sb, int type)
 #endif
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb->s_inodes_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
 			continue;
@@ -910,6 +911,7 @@ static void add_dquot_ref(struct super_block *sb, int type)
 			continue;
 
 		iref_locked(inode);
+		spin_unlock(&sb->s_inodes_lock);
 		spin_unlock(&inode_lock);
 
 		iput(old_inode);
@@ -921,7 +923,9 @@ static void add_dquot_ref(struct super_block *sb, int type)
 		 * keep the reference and iput it later. */
 		old_inode = inode;
 		spin_lock(&inode_lock);
+		spin_lock(&sb->s_inodes_lock);
 	}
+	spin_unlock(&sb->s_inodes_lock);
 	spin_unlock(&inode_lock);
 	iput(old_inode);
 
@@ -1004,6 +1008,7 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 	int reserved = 0;
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb->s_inodes_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
@@ -1017,6 +1022,7 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 			remove_inode_dquot_ref(inode, type, tofree_head);
 		}
 	}
+	spin_unlock(&sb->s_inodes_lock);
 	spin_unlock(&inode_lock);
 #ifdef CONFIG_QUOTA_DEBUG
 	if (reserved) {
diff --git a/fs/super.c b/fs/super.c
index 8819e3a..d826214 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -76,6 +76,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		INIT_LIST_HEAD(&s->s_dentry_lru);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
+		spin_lock_init(&(s->s_inodes_lock);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
 		/*
 		 * The locking rules for s_lock are up to the
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 34f983f..54c4e86 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1342,6 +1342,7 @@ struct super_block {
 #endif
 	const struct xattr_handler **s_xattr;
 
+	spinlock_t		s_inodes_lock;	/* lock for s_inodes */
 	struct list_head	s_inodes;	/* all inodes */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 #ifdef CONFIG_SMP
-- 
1.7.1

