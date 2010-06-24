Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab0FXDZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:25:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab0FXDP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:56 -0400
Message-Id: <20100624030732.702284052@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:56 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 44/52] fs: icache per-CPU sb inode lists and locks
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-sb-inodes-percpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/drop_caches.c                 |   37 ++++++----
 fs/fs-writeback.c                |   82 +++++++++++++-----------
 fs/inode.c                       |  128 +++++++++++++++++++++++++------------
 fs/notify/inode_mark.c           |  108 +++++++++++++++++--------------
 fs/notify/inotify/inotify.c      |  132 ++++++++++++++++++++-------------------
 fs/quota/dquot.c                 |   98 +++++++++++++++++-----------
 fs/super.c                       |   19 +++++
 include/linux/fs.h               |   10 ++
 include/linux/fsnotify_backend.h |    4 -
 include/linux/inotify.h          |    4 -
 10 files changed, 373 insertions(+), 249 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -26,10 +26,11 @@
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
@@ -45,7 +46,7 @@
  * Ordering:
  * inode_lock
  *   inode->i_lock
- *     sb_inode_list_lock
+ *     inode_list_lglock
  *     wb_inode_list_lock
  *     inode_hash_bucket lock
  */
@@ -120,7 +121,9 @@ static struct inode_hash_bucket *inode_h
  * NOTE! You also have to own the lock if you change
  * the i_state of an inode while it is in use..
  */
-DEFINE_SPINLOCK(sb_inode_list_lock);
+DECLARE_LGLOCK(inode_list_lglock);
+DEFINE_LGLOCK(inode_list_lglock);
+
 DEFINE_SPINLOCK(wb_inode_list_lock);
 
 /*
@@ -382,6 +385,8 @@ void clear_inode(struct inode *inode)
 }
 EXPORT_SYMBOL(clear_inode);
 
+static void inode_sb_list_del(struct inode *inode);
+
 /*
  * dispose_list - dispose of the contents of a local list
  * @head: the head of the list to free
@@ -405,9 +410,7 @@ static void dispose_list(struct list_hea
 
 		spin_lock(&inode->i_lock);
 		__remove_inode_hash(inode);
-		spin_lock(&sb_inode_list_lock);
-		list_del_rcu(&inode->i_sb_list);
-		spin_unlock(&sb_inode_list_lock);
+		inode_sb_list_del(inode);
 		spin_unlock(&inode->i_lock);
 
 		wake_up_inode(inode);
@@ -419,20 +422,12 @@ static void dispose_list(struct list_hea
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
@@ -452,7 +447,8 @@ static int invalidate_list(struct list_h
 		}
 		spin_unlock(&inode->i_lock);
 		busy = 1;
-	}
+	} while_inode_list_for_each_entry_rcu
+
 	return busy;
 }
 
@@ -476,9 +472,9 @@ int invalidate_inodes(struct super_block
 	 */
 	down_write(&iprune_sem);
 //	spin_lock(&sb_inode_list_lock); XXX: is this safe?
-	inotify_unmount_inodes(&sb->s_inodes);
-	fsnotify_unmount_inodes(&sb->s_inodes);
-	busy = invalidate_list(&sb->s_inodes, &throw_away);
+	inotify_unmount_inodes(sb);
+	fsnotify_unmount_inodes(sb);
+	busy = invalidate_sb_inodes(sb, &throw_away);
 //	spin_unlock(&sb_inode_list_lock);
 
 	dispose_list(&throw_away);
@@ -675,13 +671,63 @@ static unsigned long hash(struct super_b
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
 	percpu_counter_inc(&nr_inodes);
 	if (b) {
 		spin_lock_bucket(b);
@@ -1221,6 +1267,7 @@ repeat:
 			continue;
 		if (!spin_trylock(&old->i_lock)) {
 			spin_unlock_bucket(b);
+			cpu_relax();
 			goto repeat;
 		}
 		goto found_old;
@@ -1266,7 +1313,6 @@ repeat:
 		if (!spin_trylock(&old->i_lock)) {
 			spin_unlock_bucket(b);
 			cpu_relax();
-			cpu_relax();
 			goto repeat;
 		}
 		goto found_old;
@@ -1361,9 +1407,7 @@ void generic_delete_inode(struct inode *
 			inodes_stat.nr_unused--;
 		spin_unlock(&wb_inode_list_lock);
 	}
-	spin_lock(&sb_inode_list_lock);
-	list_del_rcu(&inode->i_sb_list);
-	spin_unlock(&sb_inode_list_lock);
+	inode_sb_list_del(inode);
 	percpu_counter_dec(&nr_inodes);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
@@ -1437,9 +1481,7 @@ int generic_detach_inode(struct inode *i
 			inodes_stat.nr_unused--;
 		spin_unlock(&wb_inode_list_lock);
 	}
-	spin_lock(&sb_inode_list_lock);
-	list_del_rcu(&inode->i_sb_list);
-	spin_unlock(&sb_inode_list_lock);
+	inode_sb_list_del(inode);
 	percpu_counter_dec(&nr_inodes);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
@@ -1759,6 +1801,8 @@ void __init inode_init(void)
 					 init_once);
 	register_shrinker(&icache_shrinker);
 
+	lg_lock_init(inode_list_lglock);
+
 	/* Hash may have been set up in inode_init_early */
 	if (!hashdist)
 		return;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -733,6 +733,9 @@ struct inode {
 		struct rcu_head		i_rcu;
 	};
 	unsigned long		i_ino;
+#ifdef CONFIG_SMP
+	int			i_sb_list_cpu;
+#endif
 	unsigned int		i_count;
 	unsigned int		i_nlink;
 	uid_t			i_uid;
@@ -1345,11 +1348,12 @@ struct super_block {
 #endif
 	const struct xattr_handler **s_xattr;
 
-	struct list_head	s_inodes;	/* all inodes */
 	struct hlist_bl_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 #ifdef CONFIG_SMP
+	struct list_head __percpu *s_inodes;
 	struct list_head __percpu *s_files;
 #else
+	struct list_head	s_inodes;	/* all inodes */
 	struct list_head	s_files;
 #endif
 	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
@@ -2194,6 +2198,58 @@ static inline void insert_inode_hash(str
 
 extern void file_sb_list_add(struct file *f, struct super_block *sb);
 extern void file_sb_list_del(struct file *f);
+#ifdef CONFIG_SMP
+
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
+	list_for_each_entry_rcu((__inode), (__tmp), list, i_sb_list)
+
+#define while_inode_list_for_each_entry_safe			\
+}
+
+#endif
+
 #ifdef CONFIG_BLOCK
 struct bio;
 extern void submit_bio(int, struct bio *);
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c
+++ linux-2.6/fs/super.c
@@ -68,12 +68,26 @@ static struct super_block *alloc_super(s
 			for_each_possible_cpu(i)
 				INIT_LIST_HEAD(per_cpu_ptr(s->s_files, i));
 		}
+
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
 		INIT_HLIST_BL_HEAD(&s->s_anon);
-		INIT_LIST_HEAD(&s->s_inodes);
 		INIT_LIST_HEAD(&s->s_dentry_lru);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
@@ -125,6 +139,7 @@ out:
 static inline void destroy_super(struct super_block *s)
 {
 #ifdef CONFIG_SMP
+	free_percpu(s->s_inodes);
 	free_percpu(s->s_files);
 #endif
 	security_sb_free(s);
Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c
+++ linux-2.6/fs/drop_caches.c
@@ -17,7 +17,7 @@ static void drop_pagecache_sb(struct sup
 	struct inode *inode, *toput_inode = NULL;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
+	do_inode_list_for_each_entry_rcu(sb, inode) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW)
 				|| inode->i_mapping->nrpages == 0) {
@@ -31,7 +31,7 @@ static void drop_pagecache_sb(struct sup
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
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -1198,17 +1198,17 @@ static void wait_sb_inodes(struct super_
 	 */
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	/*
-	 * Data integrity sync. Must wait for all pages under writeback,
-	 * because there may have been pages dirtied before our sync
-	 * call, but which had writeout started before we write it out.
-	 * In which case, the inode may not be on the dirty list, but
-	 * we still have to wait for that writeout.
-	 */
 	rcu_read_lock();
-	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
+	do_inode_list_for_each_entry_rcu(sb, inode) {
 		struct address_space *mapping;
 
+		/*
+		 * Data integrity sync. Must wait for all pages under writeback,
+		 * because there may have been pages dirtied before our sync
+		 * call, but which had writeout started before we write it out.
+		 * In which case, the inode may not be on the dirty list, but
+		 * we still have to wait for that writeout.
+		 */
 		mapping = inode->i_mapping;
 		if (mapping->nrpages == 0)
 			continue;
@@ -1222,11 +1222,12 @@ static void wait_sb_inodes(struct super_
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
@@ -1236,7 +1237,7 @@ static void wait_sb_inodes(struct super_
 		cond_resched();
 
 		rcu_read_lock();
-	}
+	} while_inode_list_for_each_entry_rcu
 	rcu_read_unlock();
 	iput(old_inode);
 }
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c
+++ linux-2.6/fs/notify/inode_mark.c
@@ -361,11 +361,11 @@ int fsnotify_add_mark(struct fsnotify_ma
  * of inodes, and with iprune_mutex held, keeping shrink_icache_memory() at bay.
  * We temporarily drop inode_lock, however, and CAN block.
  */
-void fsnotify_unmount_inodes(struct list_head *list)
+void fsnotify_unmount_inodes(struct super_block *sb)
 {
 	struct inode *inode, *next_i, *need_iput = NULL;
 
-	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
+	do_inode_list_for_each_entry_safe(sb, inode, next_i) {
 		struct inode *need_iput_tmp;
 
 		spin_lock(&inode->i_lock);
@@ -421,5 +421,5 @@ void fsnotify_unmount_inodes(struct list
 		fsnotify_inode_delete(inode);
 
 		iput(inode);
-	}
+	} while_inode_list_for_each_entry_safe
 }
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -381,11 +381,11 @@ EXPORT_SYMBOL_GPL(inotify_get_cookie);
  * of inodes, and with iprune_mutex held, keeping shrink_icache_memory() at bay.
  * We temporarily drop inode_lock, however, and CAN block.
  */
-void inotify_unmount_inodes(struct list_head *list)
+void inotify_unmount_inodes(struct super_block *sb)
 {
 	struct inode *inode, *next_i, *need_iput = NULL;
 
-	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
+	do_inode_list_for_each_entry_safe(sb, inode, next_i) {
 		struct inotify_watch *watch, *next_w;
 		struct inode *need_iput_tmp;
 		struct list_head *watches;
@@ -450,8 +450,8 @@ void inotify_unmount_inodes(struct list_
 			put_inotify_watch(watch);
 		}
 		mutex_unlock(&inode->inotify_mutex);
-		iput(inode);		
-	}
+		iput(inode);
+	} while_inode_list_for_each_entry_safe
 }
 EXPORT_SYMBOL_GPL(inotify_unmount_inodes);
 
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c
+++ linux-2.6/fs/quota/dquot.c
@@ -884,16 +884,12 @@ static void add_dquot_ref(struct super_b
 #endif
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
+	do_inode_list_for_each_entry_rcu(sb, inode) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW)) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-#ifdef CONFIG_QUOTA_DEBUG
-		if (unlikely(inode_get_rsv_space(inode) > 0))
-			reserved = 1;
-#endif
 		if (!atomic_read(&inode->i_writecount)) {
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -916,7 +912,7 @@ static void add_dquot_ref(struct super_b
 		 * keep the reference and iput it later. */
 		old_inode = inode;
 		rcu_read_lock();
-	}
+	} while_inode_list_for_each_entry_rcu
 	rcu_read_unlock();
 	iput(old_inode);
 
@@ -996,7 +992,7 @@ static void remove_dquot_ref(struct supe
 	struct inode *inode;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(inode, &sb->s_inodes, i_sb_list) {
+	do_inode_list_for_each_entry_rcu(sb, inode) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
 		 *  have quota pointer initialized. Luckily, we need to touch
@@ -1005,7 +1001,7 @@ static void remove_dquot_ref(struct supe
 		 */
 		if (!IS_NOQUOTA(inode))
 			remove_inode_dquot_ref(inode, type, tofree_head);
-	}
+	} while_inode_list_for_each_entry_rcu
 	rcu_read_unlock();
 }
 
Index: linux-2.6/include/linux/fsnotify_backend.h
===================================================================
--- linux-2.6.orig/include/linux/fsnotify_backend.h
+++ linux-2.6/include/linux/fsnotify_backend.h
@@ -344,7 +344,7 @@ extern void fsnotify_destroy_mark_by_ent
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
 extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
-extern void fsnotify_unmount_inodes(struct list_head *list);
+extern void fsnotify_unmount_inodes(struct super_block *sb);
 
 /* put here because inotify does some weird stuff when destroying watches */
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
@@ -374,7 +374,7 @@ static inline u32 fsnotify_get_cookie(vo
 	return 0;
 }
 
-static inline void fsnotify_unmount_inodes(struct list_head *list)
+static inline void fsnotify_unmount_inodes(struct super_block *sb)
 {}
 
 #endif	/* CONFIG_FSNOTIFY */
Index: linux-2.6/include/linux/inotify.h
===================================================================
--- linux-2.6.orig/include/linux/inotify.h
+++ linux-2.6/include/linux/inotify.h
@@ -111,7 +111,7 @@ extern void inotify_inode_queue_event(st
 				      const char *, struct inode *);
 extern void inotify_dentry_parent_queue_event(struct dentry *, __u32, __u32,
 					      const char *);
-extern void inotify_unmount_inodes(struct list_head *);
+extern void inotify_unmount_inodes(struct super_block *);
 extern void inotify_inode_is_dead(struct inode *);
 extern u32 inotify_get_cookie(void);
 
@@ -161,7 +161,7 @@ static inline void inotify_dentry_parent
 {
 }
 
-static inline void inotify_unmount_inodes(struct list_head *list)
+static inline void inotify_unmount_inodes(struct super_block *sb)
 {
 }
 
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -9,7 +9,6 @@
 
 struct backing_dev_info;
 
-extern spinlock_t sb_inode_list_lock;
 extern spinlock_t wb_inode_list_lock;
 extern struct list_head inode_unused;
 


