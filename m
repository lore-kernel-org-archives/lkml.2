Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab1CVLXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:23:36 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:16735 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753997Ab1CVLXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:23:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkEAK8jiE15LK5JgWdsb2JhbAClQxUBARYmJcQUgn4BgmUEkmc
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/8] fs: move i_sb_list out from under inode_lock
Date: Tue, 22 Mar 2011 22:23:40 +1100
Message-Id: <1300793023-3775-6-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300793023-3775-1-git-send-email-david@fromorbit.com>
References: <1300793023-3775-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Protect the per-sb inode list with a new global lock
inode_sb_list_lock and use it to protect the list manipulations and
traversals. This lock replaces the inode_lock as the inodes on the
list can be validity checked while holding the inode->i_lock and
hence the inode_lock is no longer needed to protect the list.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/drop_caches.c       |    9 +++++----
 fs/fs-writeback.c      |   21 +++++++++++----------
 fs/inode.c             |   43 +++++++++++++++++++++++--------------------
 fs/internal.h          |    2 ++
 fs/notify/inode_mark.c |   20 ++++++++++----------
 fs/quota/dquot.c       |   28 ++++++++++++++++------------
 6 files changed, 67 insertions(+), 56 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 62dd8ee..86cd2f1 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -8,6 +8,7 @@
 #include <linux/writeback.h>
 #include <linux/sysctl.h>
 #include <linux/gfp.h>
+#include "internal.h"
 
 /* A global variable is a bit ugly, but it keeps the code simple */
 int sysctl_drop_caches;
@@ -16,7 +17,7 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 {
 	struct inode *inode, *toput_inode = NULL;
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_sb_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
 		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
@@ -26,13 +27,13 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_sb_list_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
 		toput_inode = inode;
-		spin_lock(&inode_lock);
+		spin_lock(&inode_sb_list_lock);
 	}
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_sb_list_lock);
 	iput(toput_inode);
 }
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index efd1ebe..5de56a2 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1123,7 +1123,7 @@ static void wait_sb_inodes(struct super_block *sb)
 	 */
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_sb_list_lock);
 
 	/*
 	 * Data integrity sync. Must wait for all pages under writeback,
@@ -1143,14 +1143,15 @@ static void wait_sb_inodes(struct super_block *sb)
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_sb_list_lock);
+
 		/*
-		 * We hold a reference to 'inode' so it couldn't have
-		 * been removed from s_inodes list while we dropped the
-		 * inode_lock.  We cannot iput the inode now as we can
-		 * be holding the last reference and we cannot iput it
-		 * under inode_lock. So we keep the reference and iput
-		 * it later.
+		 * We hold a reference to 'inode' so it couldn't have been
+		 * removed from s_inodes list while we dropped the
+		 * inode_sb_list_lock.  We cannot iput the inode now as we can
+		 * be holding the last reference and we cannot iput it under
+		 * inode_sb_list_lock. So we keep the reference and iput it
+		 * later.
 		 */
 		iput(old_inode);
 		old_inode = inode;
@@ -1159,9 +1160,9 @@ static void wait_sb_inodes(struct super_block *sb)
 
 		cond_resched();
 
-		spin_lock(&inode_lock);
+		spin_lock(&inode_sb_list_lock);
 	}
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_sb_list_lock);
 	iput(old_inode);
 }
 
diff --git a/fs/inode.c b/fs/inode.c
index 5ecd880..5483d38 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -33,10 +33,15 @@
  *   inode->i_state, inode->i_hash, __iget()
  * inode_lru_lock protects:
  *   inode_lru, inode->i_lru
+ * inode_sb_list_lock protects:
+ *   sb->s_inodes, inode->i_sb_list
  *
  * Lock ordering:
  * inode_lock
  *   inode->i_lock
+ *
+ * inode_sb_list_lock
+ *   inode->i_lock
  *     inode_lru_lock
  */
 
@@ -98,6 +103,8 @@ static struct hlist_head *inode_hashtable __read_mostly;
  */
 DEFINE_SPINLOCK(inode_lock);
 
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_sb_list_lock);
+
 /*
  * iprune_sem provides exclusion between the icache shrinking and the
  * umount path.
@@ -377,26 +384,23 @@ static void inode_lru_list_del(struct inode *inode)
 	spin_unlock(&inode_lru_lock);
 }
 
-static inline void __inode_sb_list_add(struct inode *inode)
-{
-	list_add(&inode->i_sb_list, &inode->i_sb->s_inodes);
-}
-
 /**
  * inode_sb_list_add - add inode to the superblock list of inodes
  * @inode: inode to add
  */
 void inode_sb_list_add(struct inode *inode)
 {
-	spin_lock(&inode_lock);
-	__inode_sb_list_add(inode);
-	spin_unlock(&inode_lock);
+	spin_lock(&inode_sb_list_lock);
+	list_add(&inode->i_sb_list, &inode->i_sb->s_inodes);
+	spin_unlock(&inode_sb_list_lock);
 }
 EXPORT_SYMBOL_GPL(inode_sb_list_add);
 
-static inline void __inode_sb_list_del(struct inode *inode)
+static inline void inode_sb_list_del(struct inode *inode)
 {
+	spin_lock(&inode_sb_list_lock);
 	list_del_init(&inode->i_sb_list);
+	spin_unlock(&inode_sb_list_lock);
 }
 
 static unsigned long hash(struct super_block *sb, unsigned long hashval)
@@ -480,9 +484,10 @@ static void evict(struct inode *inode)
 
 	spin_lock(&inode_lock);
 	list_del_init(&inode->i_wb_list);
-	__inode_sb_list_del(inode);
 	spin_unlock(&inode_lock);
 
+	inode_sb_list_del(inode);
+
 	if (op->evict_inode) {
 		op->evict_inode(inode);
 	} else {
@@ -538,7 +543,7 @@ void evict_inodes(struct super_block *sb)
 	struct inode *inode, *next;
 	LIST_HEAD(dispose);
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_sb_list_lock);
 	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
 		if (atomic_read(&inode->i_count))
 			continue;
@@ -554,7 +559,7 @@ void evict_inodes(struct super_block *sb)
 		spin_unlock(&inode->i_lock);
 		list_add(&inode->i_lru, &dispose);
 	}
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_sb_list_lock);
 
 	dispose_list(&dispose);
 
@@ -583,7 +588,7 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 	struct inode *inode, *next;
 	LIST_HEAD(dispose);
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_sb_list_lock);
 	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
@@ -606,7 +611,7 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 		spin_unlock(&inode->i_lock);
 		list_add(&inode->i_lru, &dispose);
 	}
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_sb_list_lock);
 
 	dispose_list(&dispose);
 
@@ -866,16 +871,14 @@ struct inode *new_inode(struct super_block *sb)
 {
 	struct inode *inode;
 
-	spin_lock_prefetch(&inode_lock);
+	spin_lock_prefetch(&inode_sb_list_lock);
 
 	inode = alloc_inode(sb);
 	if (inode) {
-		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
 		inode->i_state = 0;
 		spin_unlock(&inode->i_lock);
-		__inode_sb_list_add(inode);
-		spin_unlock(&inode_lock);
+		inode_sb_list_add(inode);
 	}
 	return inode;
 }
@@ -944,7 +947,7 @@ static struct inode *get_new_inode(struct super_block *sb,
 			inode->i_state = I_NEW;
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
-			__inode_sb_list_add(inode);
+			inode_sb_list_add(inode);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
@@ -993,7 +996,7 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 			inode->i_state = I_NEW;
 			hlist_add_head(&inode->i_hash, head);
 			spin_unlock(&inode->i_lock);
-			__inode_sb_list_add(inode);
+			inode_sb_list_add(inode);
 			spin_unlock(&inode_lock);
 
 			/* Return the locked inode with I_NEW set, the
diff --git a/fs/internal.h b/fs/internal.h
index 8318059..7013ae0 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -125,6 +125,8 @@ extern long do_handle_open(int mountdirfd,
 /*
  * inode.c
  */
+extern spinlock_t inode_sb_list_lock;
+
 extern int get_nr_dirty_inodes(void);
 extern void evict_inodes(struct super_block *);
 extern int invalidate_inodes(struct super_block *, bool);
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 4dd53fb..fb3b3c5 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -29,6 +29,8 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
+#include "../internal.h"
+
 /*
  * Recalculate the mask of events relevant to a given inode locked.
  */
@@ -237,15 +239,14 @@ out:
  * fsnotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
  * @list: list of inodes being unmounted (sb->s_inodes)
  *
- * Called with inode_lock held, protecting the unmounting super block's list
- * of inodes, and with iprune_mutex held, keeping shrink_icache_memory() at bay.
- * We temporarily drop inode_lock, however, and CAN block.
+ * Called during unmount with no locks held, so needs to be safe against
+ * concurrent modifiers. We temporarily drop inode_sb_list_lock and CAN block.
  */
 void fsnotify_unmount_inodes(struct list_head *list)
 {
 	struct inode *inode, *next_i, *need_iput = NULL;
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_sb_list_lock);
 	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
 		struct inode *need_iput_tmp;
 
@@ -293,12 +294,11 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		}
 
 		/*
-		 * We can safely drop inode_lock here because we hold
+		 * We can safely drop inode_sb_list_lock here because we hold
 		 * references on both inode and next_i.  Also no new inodes
-		 * will be added since the umount has begun.  Finally,
-		 * iprune_mutex keeps shrink_icache_memory() away.
+		 * will be added since the umount has begun.
 		 */
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_sb_list_lock);
 
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
@@ -310,7 +310,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 
 		iput(inode);
 
-		spin_lock(&inode_lock);
+		spin_lock(&inode_sb_list_lock);
 	}
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_sb_list_lock);
 }
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index a1470fd..fcc8ae7 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -76,7 +76,7 @@
 #include <linux/buffer_head.h>
 #include <linux/capability.h>
 #include <linux/quotaops.h>
-#include <linux/writeback.h> /* for inode_lock, oddly enough.. */
+#include "../internal.h" /* ugh */
 
 #include <asm/uaccess.h>
 
@@ -900,7 +900,7 @@ static void add_dquot_ref(struct super_block *sb, int type)
 	int reserved = 0;
 #endif
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_sb_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
 		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
@@ -915,19 +915,23 @@ static void add_dquot_ref(struct super_block *sb, int type)
 #endif
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_lock);
+		spin_unlock(&inode_sb_list_lock);
 
 		iput(old_inode);
 		__dquot_initialize(inode, type);
-		/* We hold a reference to 'inode' so it couldn't have been
-		 * removed from s_inodes list while we dropped the inode_lock.
-		 * We cannot iput the inode now as we can be holding the last
-		 * reference and we cannot iput it under inode_lock. So we
-		 * keep the reference and iput it later. */
+
+		/*
+		 * We hold a reference to 'inode' so it couldn't have been
+		 * removed from s_inodes list while we dropped the
+		 * inode_sb_list_lock We cannot iput the inode now as we can be
+		 * holding the last reference and we cannot iput it under
+		 * inode_sb_list_lock. So we keep the reference and iput it
+		 * later.
+		 */
 		old_inode = inode;
-		spin_lock(&inode_lock);
+		spin_lock(&inode_sb_list_lock);
 	}
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_sb_list_lock);
 	iput(old_inode);
 
 #ifdef CONFIG_QUOTA_DEBUG
@@ -1008,7 +1012,7 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 	struct inode *inode;
 	int reserved = 0;
 
-	spin_lock(&inode_lock);
+	spin_lock(&inode_sb_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
@@ -1022,7 +1026,7 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 			remove_inode_dquot_ref(inode, type, tofree_head);
 		}
 	}
-	spin_unlock(&inode_lock);
+	spin_unlock(&inode_sb_list_lock);
 #ifdef CONFIG_QUOTA_DEBUG
 	if (reserved) {
 		printk(KERN_WARNING "VFS (%s): Writes happened after quota"
-- 
1.7.2.3

