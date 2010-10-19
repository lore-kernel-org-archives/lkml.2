Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933797Ab0JSD7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:59:22 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:35868 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933785Ab0JSD7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:59:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaCeIJRBIpK
Message-Id: <20101019034657.896022051@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:39 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 23/35] fs: icache use per-CPU lists and locks for sb inode lists
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-sb-inodes-percpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/drop_caches.c                 |    4 -
 fs/fs-writeback.c                |   15 +++--
 fs/inode.c                       |   99 ++++++++++++++++++++++++++++-----------
 fs/notify/inode_mark.c           |    6 +-
 fs/quota/dquot.c                 |    8 +--
 fs/super.c                       |   16 +++++-
 include/linux/fs.h               |   58 ++++++++++++++++++++++
 include/linux/fsnotify_backend.h |    4 -
 include/linux/writeback.h        |    1 
 9 files changed, 164 insertions(+), 47 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:23.000000000 +1100
@@ -25,10 +25,11 @@
 #include <linux/async.h>
 #include <linux/posix_acl.h>
 #include <linux/bit_spinlock.h>
+#include <linux/lglock.h>
 
 /*
  * Usage:
- * sb_inode_list_lock protects:
+ * inode_list_lglock protects:
  *   s_inodes, i_sb_list
  * inode_hash_bucket lock protects:
  *   inode hash table, i_hash
@@ -43,7 +44,7 @@
  *
  * Ordering:
  * inode->i_lock
- *   sb_inode_list_lock
+ *   inode_list_lglock
  *   wb_inode_list_lock
  *   inode_hash_bucket lock
  */
@@ -118,7 +119,9 @@
  * NOTE! You also have to own the lock if you change
  * the i_state of an inode while it is in use..
  */
-DEFINE_SPINLOCK(sb_inode_list_lock);
+DECLARE_LGLOCK(inode_list_lglock);
+DEFINE_LGLOCK(inode_list_lglock);
+
 DEFINE_SPINLOCK(wb_inode_list_lock);
 
 /*
@@ -395,6 +398,8 @@
 
 static void __remove_inode_hash(struct inode *inode);
 
+static void inode_sb_list_del(struct inode *inode);
+
 /*
  * dispose_list - dispose of the contents of a local list
  * @head: the head of the list to free
@@ -414,9 +419,7 @@
 
 		spin_lock(&inode->i_lock);
 		__remove_inode_hash(inode);
-		spin_lock(&sb_inode_list_lock);
-		list_del_rcu(&inode->i_sb_list);
-		spin_unlock(&sb_inode_list_lock);
+		inode_sb_list_del(inode);
 		spin_unlock(&inode->i_lock);
 
 		wake_up_inode(inode);
@@ -427,20 +430,12 @@
 /*
  * Invalidate all inodes for a device.
  */
-static int invalidate_list(struct list_head *head, struct list_head *dispose)
+static int invalidate_sb_inodes(struct super_block *sb, struct list_head *dispose)
 {
-	struct list_head *next;
+	struct inode *inode;
 	int busy = 0;
 
-	next = head->next;
-	for (;;) {
-		struct list_head *tmp = next;
-		struct inode *inode;
-
-		next = next->next;
-		if (tmp == head)
-			break;
-		inode = list_entry(tmp, struct inode, i_sb_list);
+	do_inode_list_for_each_entry_rcu(sb, inode) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & I_NEW) {
 			spin_unlock(&inode->i_lock);
@@ -460,7 +455,8 @@
 		}
 		spin_unlock(&inode->i_lock);
 		busy = 1;
-	}
+	} while_inode_list_for_each_entry_rcu
+
 	return busy;
 }
 
@@ -483,8 +479,8 @@
 	 * its consistency, because the list must not change during umount
 	 * anymore, and because iprune_sem keeps shrink_icache_memory() away.
 	 */
-	fsnotify_unmount_inodes(&sb->s_inodes);
-	busy = invalidate_list(&sb->s_inodes, &throw_away);
+	fsnotify_unmount_inodes(sb);
+	busy = invalidate_sb_inodes(sb, &throw_away);
 
 	dispose_list(&throw_away);
 	up_write(&iprune_sem);
@@ -718,13 +714,63 @@
 	return tmp & I_HASHMASK;
 }
 
+static inline int inode_list_cpu(struct inode *inode)
+{
+#ifdef CONFIG_SMP
+	return inode->i_sb_list_cpu;
+#else
+	return smp_processor_id();
+#endif
+}
+
+/* helper for file_sb_list_add to reduce ifdefs */
+static inline void __inode_sb_list_add(struct inode *inode, struct super_block *sb)
+{
+	struct list_head *list;
+#ifdef CONFIG_SMP
+	int cpu;
+	cpu = smp_processor_id();
+	inode->i_sb_list_cpu = cpu;
+	list = per_cpu_ptr(sb->s_inodes, cpu);
+#else
+	list = &sb->s_inodes;
+#endif
+	list_add_rcu(&inode->i_sb_list, list);
+}
+
+/**
+ * inode_sb_list_add - add an inode to the sb's file list
+ * @inode: inode to add
+ * @sb: sb to add it to
+ *
+ * Use this function to associate an with the superblock it belongs to.
+ */
+static void inode_sb_list_add(struct inode *inode, struct super_block *sb)
+{
+	lg_local_lock(inode_list_lglock);
+	__inode_sb_list_add(inode, sb);
+	lg_local_unlock(inode_list_lglock);
+}
+
+/**
+ * inode_sb_list_del - remove an inode from the sb's inode list
+ * @inode: inode to remove
+ * @sb: sb to remove it from
+ *
+ * Use this function to remove an inode from its superblock.
+ */
+static void inode_sb_list_del(struct inode *inode)
+{
+	lg_local_lock_cpu(inode_list_lglock, inode_list_cpu(inode));
+	list_del_rcu(&inode->i_sb_list);
+	lg_local_unlock_cpu(inode_list_lglock, inode_list_cpu(inode));
+}
+
 static inline void
 __inode_add_to_lists(struct super_block *sb, struct inode_hash_bucket *b,
 			struct inode *inode)
 {
-	spin_lock(&sb_inode_list_lock);
-	list_add_rcu(&inode->i_sb_list, &sb->s_inodes);
-	spin_unlock(&sb_inode_list_lock);
+	inode_sb_list_add(inode, sb);
 	if (b) {
 		spin_lock_bucket(b);
 		hlist_bl_add_head_rcu(&inode->i_hash, &b->head);
@@ -1270,6 +1316,7 @@
 			continue;
 		if (!spin_trylock(&old->i_lock)) {
 			spin_unlock_bucket(b);
+			cpu_relax();
 			goto repeat;
 		}
 		goto found_old;
@@ -1453,9 +1500,7 @@
 			inodes_stat.nr_unused--;
 		spin_unlock(&wb_inode_list_lock);
 	}
-	spin_lock(&sb_inode_list_lock);
-	list_del_rcu(&inode->i_sb_list);
-	spin_unlock(&sb_inode_list_lock);
+	inode_sb_list_del(inode);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	spin_unlock(&inode->i_lock);
@@ -1732,6 +1777,8 @@
 					 init_once);
 	register_shrinker(&icache_shrinker);
 
+	lg_lock_init(inode_list_lglock);
+
 	/* Hash may have been set up in inode_init_early */
 	if (!hashdist)
 		return;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-19 14:19:22.000000000 +1100
@@ -374,6 +374,7 @@
 #include <linux/cache.h>
 #include <linux/kobject.h>
 #include <linux/list.h>
+#include <linux/rculist.h>
 #include <linux/rculist_bl.h>
 #include <linux/radix-tree.h>
 #include <linux/prio_tree.h>
@@ -733,6 +734,9 @@
 		struct rcu_head		i_rcu;
 	};
 	unsigned long		i_ino;
+#ifdef CONFIG_SMP
+	int			i_sb_list_cpu;
+#endif
 	unsigned int		i_count;
 	unsigned int		i_nlink;
 	uid_t			i_uid;
@@ -1344,11 +1348,12 @@
 #endif
 	const struct xattr_handler **s_xattr;
 
-	struct list_head	s_inodes;	/* all inodes */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 #ifdef CONFIG_SMP
+	struct list_head __percpu *s_inodes;
 	struct list_head __percpu *s_files;
 #else
+	struct list_head	s_inodes;	/* all inodes */
 	struct list_head	s_files;
 #endif
 	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
@@ -2202,6 +2207,57 @@
 	__insert_inode_hash(inode, inode->i_ino);
 }
 
+#ifdef CONFIG_SMP
+/*
+ * These macros iterate all inodes on all CPUs for a given superblock.
+ * rcu_read_lock must be held.
+ */
+#define do_inode_list_for_each_entry_rcu(__sb, __inode)		\
+{								\
+	int i;							\
+	for_each_possible_cpu(i) {				\
+		struct list_head *list;				\
+		list = per_cpu_ptr((__sb)->s_inodes, i);	\
+		list_for_each_entry_rcu((__inode), list, i_sb_list)
+
+#define while_inode_list_for_each_entry_rcu			\
+	}							\
+}
+
+#define do_inode_list_for_each_entry_safe(__sb, __inode, __tmp)	\
+{								\
+	int i;							\
+	for_each_possible_cpu(i) {				\
+		struct list_head *list;				\
+		list = per_cpu_ptr((__sb)->s_inodes, i);	\
+		list_for_each_entry_safe((__inode), (__tmp), list, i_sb_list)
+
+#define while_inode_list_for_each_entry_safe			\
+	}							\
+}
+
+#else
+
+#define do_inode_list_for_each_entry_rcu(__sb, __inode)		\
+{								\
+	struct list_head *list;					\
+	list = &(sb)->s_inodes;					\
+	list_for_each_entry_rcu((__inode), list, i_sb_list)
+
+#define while_inode_list_for_each_entry_rcu			\
+}
+
+#define do_inode_list_for_each_entry_safe(__sb, __inode, __tmp)	\
+{								\
+	struct list_head *list;					\
+	list = &(sb)->s_inodes;					\
+	list_for_each_entry_safe((__inode), (__tmp), list, i_sb_list)
+
+#define while_inode_list_for_each_entry_safe			\
+}
+
+#endif
+
 #ifdef CONFIG_BLOCK
 extern void submit_bio(int, struct bio *);
 extern int bdev_read_only(struct block_device *);
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c	2010-10-19 14:17:17.000000000 +1100
+++ linux-2.6/fs/super.c	2010-10-19 14:18:59.000000000 +1100
@@ -67,12 +67,25 @@
 			for_each_possible_cpu(i)
 				INIT_LIST_HEAD(per_cpu_ptr(s->s_files, i));
 		}
+		s->s_inodes = alloc_percpu(struct list_head);
+		if (!s->s_inodes) {
+			free_percpu(s->s_files);
+			security_sb_free(s);
+			kfree(s);
+			s = NULL;
+			goto out;
+		} else {
+			int i;
+
+			for_each_possible_cpu(i)
+				INIT_LIST_HEAD(per_cpu_ptr(s->s_inodes, i));
+		}
 #else
 		INIT_LIST_HEAD(&s->s_files);
+		INIT_LIST_HEAD(&s->s_inodes);
 #endif
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
-		INIT_LIST_HEAD(&s->s_inodes);
 		INIT_LIST_HEAD(&s->s_dentry_lru);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
@@ -124,6 +137,7 @@
 static inline void destroy_super(struct super_block *s)
 {
 #ifdef CONFIG_SMP
+	free_percpu(s->s_inodes);
 	free_percpu(s->s_files);
 #endif
 	security_sb_free(s);
Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/drop_caches.c	2010-10-19 14:19:18.000000000 +1100
@@ -17,7 +17,7 @@
 	struct inode *inode, *toput_inode = NULL;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
+	do_inode_list_for_each_entry_rcu(sb, inode) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)
 				|| inode->i_mapping->nrpages == 0) {
@@ -31,7 +31,7 @@
 		iput(toput_inode);
 		toput_inode = inode;
 		rcu_read_lock();
-	}
+	} while_inode_list_for_each_entry_rcu
 	rcu_read_unlock();
 	iput(toput_inode);
 }
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:22.000000000 +1100
@@ -1074,7 +1074,7 @@
 	 * we still have to wait for that writeout.
 	 */
 	rcu_read_lock();
-	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
+	do_inode_list_for_each_entry_rcu(sb, inode) {
 		struct address_space *mapping;
 
 		spin_lock(&inode->i_lock);
@@ -1093,11 +1093,12 @@
 		spin_unlock(&inode->i_lock);
 		rcu_read_unlock();
 		/*
-		 * We hold a reference to 'inode' so it couldn't have been
-		 * removed from s_inodes list while we dropped the i_lock.  We
-		 * cannot iput the inode now as we can be holding the last
-		 * reference and we cannot iput it under spinlock. So we keep
-		 * the reference and iput it later.
+		 * We hold a reference to 'inode' so it couldn't have
+		 * been removed from s_inodes list while we dropped the
+		 * i_lock.  We cannot iput the inode now as we can be
+		 * holding the last reference and we cannot iput it
+		 * under spinlock. So we keep the reference and iput it
+		 * later.
 		 */
 		iput(old_inode);
 		old_inode = inode;
@@ -1107,7 +1108,7 @@
 		cond_resched();
 
 		rcu_read_lock();
-	}
+	} while_inode_list_for_each_entry_rcu
 	rcu_read_unlock();
 	iput(old_inode);
 }
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/notify/inode_mark.c	2010-10-19 14:19:18.000000000 +1100
@@ -236,11 +236,11 @@
  * and with the sb going away, no new inodes will appear or be referenced
  * from other paths.
  */
-void fsnotify_unmount_inodes(struct list_head *list)
+void fsnotify_unmount_inodes(struct super_block *sb)
 {
 	struct inode *inode, *next_i, *need_iput = NULL;
 
-	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
+	do_inode_list_for_each_entry_safe(sb, inode, next_i) {
 		struct inode *need_iput_tmp;
 
 		spin_lock(&inode->i_lock);
@@ -295,5 +295,5 @@
 		fsnotify_inode_delete(inode);
 
 		iput(inode);
-	}
+	} while_inode_list_for_each_entry_safe
 }
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/quota/dquot.c	2010-10-19 14:19:18.000000000 +1100
@@ -898,7 +898,7 @@
 #endif
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
+	do_inode_list_for_each_entry_rcu(sb, inode) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
 			spin_unlock(&inode->i_lock);
@@ -930,7 +930,7 @@
 		 * lock. So we keep the reference and iput it later. */
 		old_inode = inode;
 		rcu_read_lock();
-	}
+	} while_inode_list_for_each_entry_rcu
 	rcu_read_unlock();
 	iput(old_inode);
 
@@ -1013,7 +1013,7 @@
 	int reserved = 0;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
+	do_inode_list_for_each_entry_rcu(sb, inode) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
 		 *  have quota pointer initialized. Luckily, we need to touch
@@ -1025,7 +1025,7 @@
 				reserved = 1;
 			remove_inode_dquot_ref(inode, type, tofree_head);
 		}
-	}
+	} while_inode_list_for_each_entry_rcu
 	rcu_read_unlock();
 #ifdef CONFIG_QUOTA_DEBUG
 	if (reserved) {
Index: linux-2.6/include/linux/fsnotify_backend.h
===================================================================
--- linux-2.6.orig/include/linux/fsnotify_backend.h	2010-10-19 14:17:17.000000000 +1100
+++ linux-2.6/include/linux/fsnotify_backend.h	2010-10-19 14:18:59.000000000 +1100
@@ -402,7 +402,7 @@
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_get_mark(struct fsnotify_mark *mark);
 extern void fsnotify_put_mark(struct fsnotify_mark *mark);
-extern void fsnotify_unmount_inodes(struct list_head *list);
+extern void fsnotify_unmount_inodes(struct super_block *sb);
 
 /* put here because inotify does some weird stuff when destroying watches */
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
@@ -443,7 +443,7 @@
 	return 0;
 }
 
-static inline void fsnotify_unmount_inodes(struct list_head *list)
+static inline void fsnotify_unmount_inodes(struct super_block *sb)
 {}
 
 #endif	/* CONFIG_FSNOTIFY */
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/include/linux/writeback.h	2010-10-19 14:19:21.000000000 +1100
@@ -9,7 +9,6 @@
 
 struct backing_dev_info;
 
-extern spinlock_t sb_inode_list_lock;
 extern spinlock_t wb_inode_list_lock;
 extern struct list_head inode_unused;
 


