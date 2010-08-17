Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab0HQStq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:49:46 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:56286 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759306Ab0HQSt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:49:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0GAE51akx5Ld90/2dsb2JhbACUI4wbcsEqhTcEiWc
Message-Id: <20100817184122.092675087@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 18 Aug 2010 04:37:38 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: [patch 09/10] fs: scale files_lock
References: <20100817183729.613117146@kernel.dk>
Content-Disposition: inline; filename=fs-files_lock-scale.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs: scale files_lock

Improve scalability of files_lock by adding per-cpu, per-sb files lists,
protected with an lglock. The lglock provides fast access to the per-cpu lists
to add and remove files. It also provides a snapshot of all the per-cpu lists
(although this is very slow).

One difficulty with this approach is that a file can be removed from the list
by another CPU. We must track which per-cpu list the file is on with a new
variale in the file struct (packed into a hole on 64-bit archs). Scalability
could suffer if files are frequently removed from different cpu's list.

However loads with frequent removal of files imply short interval between
adding and removing the files, and the scheduler attempts to avoid moving
processes too far away. Also, even in the case of cross-CPU removal, the
hardware has much more opportunity to parallelise cacheline transfers with N
cachelines than with 1.

A worst-case test of 1 CPU allocating files subsequently being freed by N CPUs
degenerates to contending on a single lock, which is no worse than before. When
more than one CPU are allocating files, even if they are always freed by
different CPUs, there will be more parallelism than the single-lock case.


Testing results:

On a 2 socket, 8 core opteron, I measure the number of times the lock is taken
to remove the file, the number of times it is removed by the same CPU that
added it, and the number of times it is removed by the same node that added it.

Booting:    locks=  25049 cpu-hits=  23174 (92.5%) node-hits=  23945 (95.6%)
kbuild -j16 locks=2281913 cpu-hits=2208126 (96.8%) node-hits=2252674 (98.7%)
dbench 64   locks=4306582 cpu-hits=4287247 (99.6%) node-hits=4299527 (99.8%)

So a file is removed from the same CPU it was added by over 90% of the time.
It remains within the same node 95% of the time.


Tim Chen ran some numbers for a 64 thread Nehalem system performing a compile.

                throughput
2.6.34-rc2      24.5
+patch          24.9

                us      sys     idle    IO wait (in %)
2.6.34-rc2      51.25   28.25   17.25   3.25
+patch          53.75   18.5    19      8.75

So significantly less CPU time spent in kernel code, higher idle time and
slightly higher throughput.


Single threaded performance difference was within the noise of microbenchmarks.
That is not to say penalty does not exist, the code is larger and more memory
accesses required so it will be slightly slower.

Cc: linux-kernel@vger.kernel.org
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/file_table.c    |  108 ++++++++++++++++++++++++++++++++++++++++++++---------
 fs/super.c         |   18 ++++++++
 include/linux/fs.h |    7 +++
 3 files changed, 115 insertions(+), 18 deletions(-)

Index: linux-2.6/fs/file_table.c
===================================================================
--- linux-2.6.orig/fs/file_table.c	2010-08-18 04:04:29.000000000 +1000
+++ linux-2.6/fs/file_table.c	2010-08-18 04:04:29.000000000 +1000
@@ -20,7 +20,9 @@
 #include <linux/cdev.h>
 #include <linux/fsnotify.h>
 #include <linux/sysctl.h>
+#include <linux/lglock.h>
 #include <linux/percpu_counter.h>
+#include <linux/percpu.h>
 #include <linux/ima.h>
 
 #include <asm/atomic.h>
@@ -32,7 +34,8 @@ struct files_stat_struct files_stat = {
 	.max_files = NR_FILE
 };
 
-static __cacheline_aligned_in_smp DEFINE_SPINLOCK(files_lock);
+DECLARE_LGLOCK(files_lglock);
+DEFINE_LGLOCK(files_lglock);
 
 /* SLAB cache for file structures */
 static struct kmem_cache *filp_cachep __read_mostly;
@@ -336,30 +339,98 @@ void put_filp(struct file *file)
 	}
 }
 
+static inline int file_list_cpu(struct file *file)
+{
+#ifdef CONFIG_SMP
+	return file->f_sb_list_cpu;
+#else
+	return smp_processor_id();
+#endif
+}
+
+/* helper for file_sb_list_add to reduce ifdefs */
+static inline void __file_sb_list_add(struct file *file, struct super_block *sb)
+{
+	struct list_head *list;
+#ifdef CONFIG_SMP
+	int cpu;
+	cpu = smp_processor_id();
+	file->f_sb_list_cpu = cpu;
+	list = per_cpu_ptr(sb->s_files, cpu);
+#else
+	list = &sb->s_files;
+#endif
+	list_add(&file->f_u.fu_list, list);
+}
+
+/**
+ * file_sb_list_add - add a file to the sb's file list
+ * @file: file to add
+ * @sb: sb to add it to
+ *
+ * Use this function to associate a file with the superblock of the inode it
+ * refers to.
+ */
 void file_sb_list_add(struct file *file, struct super_block *sb)
 {
-	spin_lock(&files_lock);
-	BUG_ON(!list_empty(&file->f_u.fu_list));
-	list_add(&file->f_u.fu_list, &sb->s_files);
-	spin_unlock(&files_lock);
+	lg_local_lock(files_lglock);
+	__file_sb_list_add(file, sb);
+	lg_local_unlock(files_lglock);
 }
 
+/**
+ * file_sb_list_del - remove a file from the sb's file list
+ * @file: file to remove
+ * @sb: sb to remove it from
+ *
+ * Use this function to remove a file from its superblock.
+ */
 void file_sb_list_del(struct file *file)
 {
 	if (!list_empty(&file->f_u.fu_list)) {
-		spin_lock(&files_lock);
+		lg_local_lock_cpu(files_lglock, file_list_cpu(file));
 		list_del_init(&file->f_u.fu_list);
-		spin_unlock(&files_lock);
+		lg_local_unlock_cpu(files_lglock, file_list_cpu(file));
 	}
 }
 
+#ifdef CONFIG_SMP
+
+/*
+ * These macros iterate all files on all CPUs for a given superblock.
+ * files_lglock must be held globally.
+ */
+#define do_file_list_for_each_entry(__sb, __file)		\
+{								\
+	int i;							\
+	for_each_possible_cpu(i) {				\
+		struct list_head *list;				\
+		list = per_cpu_ptr((__sb)->s_files, i);		\
+		list_for_each_entry((__file), list, f_u.fu_list)
+
+#define while_file_list_for_each_entry				\
+	}							\
+}
+
+#else
+
+#define do_file_list_for_each_entry(__sb, __file)		\
+{								\
+	struct list_head *list;					\
+	list = &(sb)->s_files;					\
+	list_for_each_entry((__file), list, f_u.fu_list)
+
+#define while_file_list_for_each_entry				\
+}
+
+#endif
+
 int fs_may_remount_ro(struct super_block *sb)
 {
 	struct file *file;
-
 	/* Check that no files are currently opened for writing. */
-	spin_lock(&files_lock);
-	list_for_each_entry(file, &sb->s_files, f_u.fu_list) {
+	lg_global_lock(files_lglock);
+	do_file_list_for_each_entry(sb, file) {
 		struct inode *inode = file->f_path.dentry->d_inode;
 
 		/* File with pending delete? */
@@ -369,11 +440,11 @@ int fs_may_remount_ro(struct super_block
 		/* Writeable file? */
 		if (S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE))
 			goto too_bad;
-	}
-	spin_unlock(&files_lock);
+	} while_file_list_for_each_entry;
+	lg_global_unlock(files_lglock);
 	return 1; /* Tis' cool bro. */
 too_bad:
-	spin_unlock(&files_lock);
+	lg_global_unlock(files_lglock);
 	return 0;
 }
 
@@ -389,8 +460,8 @@ void mark_files_ro(struct super_block *s
 	struct file *f;
 
 retry:
-	spin_lock(&files_lock);
-	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
+	lg_global_lock(files_lglock);
+	do_file_list_for_each_entry(sb, f) {
 		struct vfsmount *mnt;
 		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
 		       continue;
@@ -406,12 +477,12 @@ retry:
 		file_release_write(f);
 		mnt = mntget(f->f_path.mnt);
 		/* This can sleep, so we can't hold the spinlock. */
-		spin_unlock(&files_lock);
+		lg_global_unlock(files_lglock);
 		mnt_drop_write(mnt);
 		mntput(mnt);
 		goto retry;
-	}
-	spin_unlock(&files_lock);
+	} while_file_list_for_each_entry;
+	lg_global_unlock(files_lglock);
 }
 
 void __init files_init(unsigned long mempages)
@@ -431,5 +502,6 @@ void __init files_init(unsigned long mem
 	if (files_stat.max_files < NR_FILE)
 		files_stat.max_files = NR_FILE;
 	files_defer_init();
+	lg_lock_init(files_lglock);
 	percpu_counter_init(&nr_files, 0);
 } 
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c	2010-08-18 04:04:00.000000000 +1000
+++ linux-2.6/fs/super.c	2010-08-18 04:04:29.000000000 +1000
@@ -54,7 +54,22 @@ static struct super_block *alloc_super(s
 			s = NULL;
 			goto out;
 		}
+#ifdef CONFIG_SMP
+		s->s_files = alloc_percpu(struct list_head);
+		if (!s->s_files) {
+			security_sb_free(s);
+			kfree(s);
+			s = NULL;
+			goto out;
+		} else {
+			int i;
+
+			for_each_possible_cpu(i)
+				INIT_LIST_HEAD(per_cpu_ptr(s->s_files, i));
+		}
+#else
 		INIT_LIST_HEAD(&s->s_files);
+#endif
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
@@ -108,6 +123,9 @@ out:
  */
 static inline void destroy_super(struct super_block *s)
 {
+#ifdef CONFIG_SMP
+	free_percpu(s->s_files);
+#endif
 	security_sb_free(s);
 	kfree(s->s_subtype);
 	kfree(s->s_options);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-08-18 04:04:29.000000000 +1000
+++ linux-2.6/include/linux/fs.h	2010-08-18 04:04:29.000000000 +1000
@@ -929,6 +929,9 @@ struct file {
 #define f_vfsmnt	f_path.mnt
 	const struct file_operations	*f_op;
 	spinlock_t		f_lock;  /* f_ep_links, f_flags, no IRQ */
+#ifdef CONFIG_SMP
+	int			f_sb_list_cpu;
+#endif
 	atomic_long_t		f_count;
 	unsigned int 		f_flags;
 	fmode_t			f_mode;
@@ -1343,7 +1346,11 @@ struct super_block {
 
 	struct list_head	s_inodes;	/* all inodes */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
+#ifdef CONFIG_SMP
+	struct list_head __percpu *s_files;
+#else
 	struct list_head	s_files;
+#endif
 	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */


