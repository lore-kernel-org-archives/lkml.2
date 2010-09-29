Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0I2MTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:19:25 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:50352 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755353Ab0I2MTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:19 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/17] fs: icache lock s_inodes list
Date: Wed, 29 Sep 2010 22:18:34 +1000
Message-Id: <1285762729-17928-3-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

To allow removal of the inode_lock, we first need to protect the
superblock inode list with it's own lock instead of using the
inode_lock for this purpose. Nest the new sb_inode_list_lock inside
the inode_lock around the list operations it needs to protect.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/drop_caches.c          |    4 ++++
 fs/fs-writeback.c         |    4 ++++
 fs/inode.c                |   19 +++++++++++++++++++
 fs/notify/inode_mark.c    |    2 ++
 fs/quota/dquot.c          |    6 ++++++
 include/linux/writeback.h |    1 +
 6 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 2195c21..ab69ae7 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -17,18 +17,22 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 	struct inode *inode, *toput_inode = NULL;
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
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
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 81e086d..9adc9d9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1021,6 +1021,7 @@ static void wait_sb_inodes(struct super_block *sb)
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 
 	/*
 	 * Data integrity sync. Must wait for all pages under writeback,
@@ -1038,6 +1039,7 @@ static void wait_sb_inodes(struct super_block *sb)
 		if (mapping->nrpages == 0)
 			continue;
 		__iget(inode);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		/*
 		 * We hold a reference to 'inode' so it couldn't have
@@ -1055,7 +1057,9 @@ static void wait_sb_inodes(struct super_block *sb)
 		cond_resched();
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	iput(old_inode);
 }
diff --git a/fs/inode.c b/fs/inode.c
index 8646433..ca98254 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -26,6 +26,15 @@
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
@@ -83,6 +92,7 @@ static struct hlist_head *inode_hashtable __read_mostly;
  * the i_state of an inode while it is in use..
  */
 DEFINE_SPINLOCK(inode_lock);
+DEFINE_SPINLOCK(sb_inode_list_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -339,7 +349,9 @@ static void dispose_list(struct list_head *head)
 
 		spin_lock(&inode_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
 		wake_up_inode(inode);
@@ -371,6 +383,7 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
 		 * shrink_icache_memory() away.
 		 */
 		cond_resched_lock(&inode_lock);
+		cond_resched_lock(&sb_inode_list_lock);
 
 		next = next->next;
 		if (tmp == head)
@@ -408,8 +421,10 @@ int invalidate_inodes(struct super_block *sb)
 
 	down_write(&iprune_sem);
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	fsnotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(&sb->s_inodes, &throw_away);
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 
 	dispose_list(&throw_away);
@@ -597,7 +612,9 @@ __inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
 {
 	inodes_stat.nr_inodes++;
 	list_add(&inode->i_list, &inode_in_use);
+	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
+	spin_unlock(&sb_inode_list_lock);
 	if (head)
 		hlist_add_head(&inode->i_hash, head);
 }
@@ -1231,7 +1248,9 @@ static void iput_final(struct inode *inode)
 		hlist_del_init(&inode->i_hash);
 	}
 	list_del_init(&inode->i_list);
+	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
+	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 33297c0..34b1585 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -283,6 +283,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		 * will be added since the umount has begun.  Finally,
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
@@ -296,5 +297,6 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		iput(inode);
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
 }
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index aad1316..2e3b913 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -897,6 +897,7 @@ static void add_dquot_ref(struct super_block *sb, int type)
 #endif
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
 			continue;
@@ -910,6 +911,7 @@ static void add_dquot_ref(struct super_block *sb, int type)
 			continue;
 
 		__iget(inode);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
 		iput(old_inode);
@@ -921,7 +923,9 @@ static void add_dquot_ref(struct super_block *sb, int type)
 		 * keep the reference and iput it later. */
 		old_inode = inode;
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	iput(old_inode);
 
@@ -1004,6 +1008,7 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 	int reserved = 0;
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
@@ -1017,6 +1022,7 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 			remove_inode_dquot_ref(inode, type, tofree_head);
 		}
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 #ifdef CONFIG_QUOTA_DEBUG
 	if (reserved) {
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 72a5d64..9974edb 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -10,6 +10,7 @@
 struct backing_dev_info;
 
 extern spinlock_t inode_lock;
+extern spinlock_t sb_inode_list_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
-- 
1.7.1

