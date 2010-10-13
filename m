Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0JMAQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 20:16:53 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:40717 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752335Ab0JMAQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 20:16:50 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/18] fs: add a per-superblock lock for the inode list
Date: Wed, 13 Oct 2010 11:15:53 +1100
Message-Id: <1286928961-15157-11-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286928961-15157-1-git-send-email-david@fromorbit.com>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 10c8c5a..dfe8cb1 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -17,6 +17,7 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 	struct inode *inode, *toput_inode = NULL;
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb->s_inodes_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
 			continue;
@@ -25,12 +26,15 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 		spin_lock(&inode->i_lock);
 		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
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
index 31d7f35..387385b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1025,6 +1025,7 @@ static void wait_sb_inodes(struct super_block *sb)
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb->s_inodes_lock);
 
 	/*
 	 * Data integrity sync. Must wait for all pages under writeback,
@@ -1044,6 +1045,7 @@ static void wait_sb_inodes(struct super_block *sb)
 		spin_lock(&inode->i_lock);
 		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
+		spin_unlock(&sb->s_inodes_lock);
 		spin_unlock(&inode_lock);
 		/*
 		 * We hold a reference to 'inode' so it couldn't have
@@ -1061,7 +1063,9 @@ static void wait_sb_inodes(struct super_block *sb)
 		cond_resched();
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb->s_inodes_lock);
 	}
+	spin_unlock(&sb->s_inodes_lock);
 	spin_unlock(&inode_lock);
 	iput(old_inode);
 }
diff --git a/fs/inode.c b/fs/inode.c
index dd3270a..ab65f99 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -33,13 +33,18 @@
  *   i_ref
  * inode hash lock protects:
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
@@ -474,7 +479,9 @@ static void dispose_list(struct list_head *head)
 
 		spin_lock(&inode_lock);
 		__remove_inode_hash(inode);
+		spin_lock(&inode->i_sb->s_inodes_lock);
 		list_del_init(&inode->i_sb_list);
+		spin_unlock(&inode->i_sb->s_inodes_lock);
 		spin_unlock(&inode_lock);
 
 		wake_up_inode(inode);
@@ -485,7 +492,8 @@ static void dispose_list(struct list_head *head)
 /*
  * Invalidate all inodes for a device.
  */
-static int invalidate_list(struct list_head *head, struct list_head *dispose)
+static int invalidate_list(struct super_block *sb, struct list_head *head,
+			struct list_head *dispose)
 {
 	struct list_head *next;
 	int busy = 0;
@@ -502,6 +510,7 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 		 * shrink_icache_memory() away.
 		 */
 		cond_resched_lock(&inode_lock);
+		cond_resched_lock(&sb->s_inodes_lock);
 
 		next = next->next;
 		if (tmp == head)
@@ -540,8 +549,10 @@ int invalidate_inodes(struct super_block *sb)
 
 	down_write(&iprune_sem);
 	spin_lock(&inode_lock);
+	spin_lock(&sb->s_inodes_lock);
 	fsnotify_unmount_inodes(&sb->s_inodes);
-	busy = invalidate_list(&sb->s_inodes, &throw_away);
+	busy = invalidate_list(sb, &sb->s_inodes, &throw_away);
+	spin_unlock(&sb->s_inodes_lock);
 	spin_unlock(&inode_lock);
 
 	dispose_list(&throw_away);
@@ -747,7 +758,9 @@ static inline void
 __inode_add_to_lists(struct super_block *sb, struct hlist_bl_head *b,
 			struct inode *inode)
 {
+	spin_lock(&sb->s_inodes_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
+	spin_unlock(&sb->s_inodes_lock);
 	if (b) {
 		hlist_bl_lock(b);
 		hlist_bl_add_head(&inode->i_hash, b);
@@ -1387,7 +1400,10 @@ static void iput_final(struct inode *inode)
 	 */
 	inode_lru_list_del(inode);
 
+	spin_lock(&sb->s_inodes_lock);
 	list_del_init(&inode->i_sb_list);
+	spin_unlock(&sb->s_inodes_lock);
+
 	spin_unlock(&inode_lock);
 	evict(inode);
 	remove_inode_hash(inode);
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 1a4c117..4ed0e43 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -242,6 +242,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 
 	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
 		struct inode *need_iput_tmp;
+		struct super_block *sb = inode->i_sb;
 
 		/*
 		 * We cannot iref() an inode in state I_FREEING,
@@ -290,6 +291,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		 * will be added since the umount has begun.  Finally,
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
+		spin_unlock(&sb->s_inodes_lock);
 		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
@@ -303,5 +305,6 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		iput(inode);
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb->s_inodes_lock);
 	}
 }
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 326df72..7ef5411 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -897,6 +897,7 @@ static void add_dquot_ref(struct super_block *sb, int type)
 #endif
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb->s_inodes_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
 			continue;
@@ -912,6 +913,7 @@ static void add_dquot_ref(struct super_block *sb, int type)
 		spin_lock(&inode->i_lock);
 		inode->i_ref++;
 		spin_unlock(&inode->i_lock);
+		spin_unlock(&sb->s_inodes_lock);
 		spin_unlock(&inode_lock);
 
 		iput(old_inode);
@@ -923,7 +925,9 @@ static void add_dquot_ref(struct super_block *sb, int type)
 		 * keep the reference and iput it later. */
 		old_inode = inode;
 		spin_lock(&inode_lock);
+		spin_lock(&sb->s_inodes_lock);
 	}
+	spin_unlock(&sb->s_inodes_lock);
 	spin_unlock(&inode_lock);
 	iput(old_inode);
 
@@ -1006,6 +1010,7 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 	int reserved = 0;
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb->s_inodes_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
@@ -1019,6 +1024,7 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 			remove_inode_dquot_ref(inode, type, tofree_head);
 		}
 	}
+	spin_unlock(&sb->s_inodes_lock);
 	spin_unlock(&inode_lock);
 #ifdef CONFIG_QUOTA_DEBUG
 	if (reserved) {
diff --git a/fs/super.c b/fs/super.c
index 8819e3a..c5332e5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -76,6 +76,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		INIT_LIST_HEAD(&s->s_dentry_lru);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
+		spin_lock_init(&s->s_inodes_lock);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
 		/*
 		 * The locking rules for s_lock are up to the
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 67dd926..767913a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1347,6 +1347,7 @@ struct super_block {
 #endif
 	const struct xattr_handler **s_xattr;
 
+	spinlock_t		s_inodes_lock;	/* lock for s_inodes */
 	struct list_head	s_inodes;	/* all inodes */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 #ifdef CONFIG_SMP
-- 
1.7.1

