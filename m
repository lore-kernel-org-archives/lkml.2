Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab2DPQRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:17:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab2DPQOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:14:25 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dchinner@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 13/27] fs: Improve filesystem freezing handling
Date: Mon, 16 Apr 2012 18:13:51 +0200
Message-Id: <1334592845-22862-14-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1334592845-22862-1-git-send-email-jack@suse.cz>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfs_check_frozen() tests are racy since the filesystem can be frozen just after
the test is performed. Thus in write paths we can end up marking some pages or
inodes dirty even though the file system is already frozen. This creates
problems with flusher thread hanging on frozen filesystem.

Another problem is that exclusion between ->page_mkwrite() and filesystem
freezing has been handled by setting page dirty and then verifying s_frozen.
This guaranteed that either the freezing code sees the faulted page, writes it,
and writeprotects it again or we see s_frozen set and bail out of page fault.
This works to protect from page being marked writeable while filesystem
freezing is running but has an unpleasant artefact of leaving dirty (although
unmodified and writeprotected) pages on frozen filesystem resulting in similar
problems with flusher thread as the first problem.

This patch aims at providing exclusion between write paths and filesystem
freezing. We implement a writer-freeze read-write semaphore in the superblock.
Actually, there are three such semaphores because of lock ranking reasons - one
for page fault handlers (->page_mkwrite), one for all other writers, and one of
internal filesystem purposes (used e.g. to track running transactions).  Write
paths which should block freezing (e.g. directory operations, ->aio_write(),
->page_mkwrite) hold reader side of the semaphore. Code freezing the filesystem
takes the writer side.

Only that we don't really want to bounce cachelines of the semaphores between
CPUs for each write happening. So we implement the reader side of the semaphore
as a per-cpu counter and the writer side is implemented using s_writers.frozen
superblock field.

BugLink: https://bugs.launchpad.net/bugs/897421
Tested-by: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Tested-by: Dann Frazier <dann.frazier@canonical.com>
Tested-by: Massimo Morana <massimo.morana@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/super.c         |  329 ++++++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/fs.h |   48 +++++++--
 2 files changed, 348 insertions(+), 29 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index cf00177..6ed27cd 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -33,12 +33,20 @@
 #include <linux/rculist_bl.h>
 #include <linux/cleancache.h>
 #include <linux/fsnotify.h>
+#include <linux/lockdep.h>
 #include "internal.h"
 
 
 LIST_HEAD(super_blocks);
 DEFINE_SPINLOCK(sb_lock);
 
+static struct lock_class_key sb_writers_key[SB_FREEZE_LEVELS];
+static char *sb_writers_name[SB_FREEZE_LEVELS] = {
+	"sb_writers",
+	"sb_pagefaults",
+	"sb_internal",
+};
+
 /*
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
@@ -102,6 +110,35 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
 	return total_objects;
 }
 
+static int init_sb_writers(struct super_block *s)
+{
+	int err;
+	int i;
+
+	for (i = 0; i < SB_FREEZE_LEVELS; i++) {
+		err = percpu_counter_init(&s->s_writers.counter[i], 0);
+		if (err < 0)
+			goto err_out;
+		lockdep_init_map(&s->s_writers.lock_map[i], sb_writers_name[i],
+				 &sb_writers_key[i], 0);
+	}
+	init_waitqueue_head(&s->s_writers.wait);
+	init_waitqueue_head(&s->s_writers.wait_unfrozen);
+	return 0;
+err_out:
+	while (--i >= 0)
+		percpu_counter_destroy(&s->s_writers.counter[i]);
+	return err;
+}
+
+static void destroy_sb_writers(struct super_block *s)
+{
+	int i;
+
+	for (i = 0; i < SB_FREEZE_LEVELS; i++)
+		percpu_counter_destroy(&s->s_writers.counter[i]);
+}
+
 /**
  *	alloc_super	-	create new superblock
  *	@type:	filesystem type superblock should belong to
@@ -116,18 +153,19 @@ static struct super_block *alloc_super(struct file_system_type *type)
 
 	if (s) {
 		if (security_sb_alloc(s)) {
+			/*
+			 * We cannot call security_sb_free() without
+			 * security_sb_alloc() succeeding. So bail out manually
+			 */
 			kfree(s);
 			s = NULL;
 			goto out;
 		}
 #ifdef CONFIG_SMP
 		s->s_files = alloc_percpu(struct list_head);
-		if (!s->s_files) {
-			security_sb_free(s);
-			kfree(s);
-			s = NULL;
-			goto out;
-		} else {
+		if (!s->s_files)
+			goto err_out;
+		else {
 			int i;
 
 			for_each_possible_cpu(i)
@@ -136,6 +174,9 @@ static struct super_block *alloc_super(struct file_system_type *type)
 #else
 		INIT_LIST_HEAD(&s->s_files);
 #endif
+		if (init_sb_writers(s))
+			goto err_out;
+
 		s->s_bdi = &default_backing_dev_info;
 		INIT_HLIST_NODE(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
@@ -188,6 +229,16 @@ static struct super_block *alloc_super(struct file_system_type *type)
 	}
 out:
 	return s;
+err_out:
+	security_sb_free(s);
+#ifdef CONFIG_SMP
+	if (s->s_files)
+		free_percpu(s->s_files);
+#endif
+	destroy_sb_writers(s);
+	kfree(s);
+	s = NULL;
+	goto out;
 }
 
 /**
@@ -201,6 +252,7 @@ static inline void destroy_super(struct super_block *s)
 #ifdef CONFIG_SMP
 	free_percpu(s->s_files);
 #endif
+	destroy_sb_writers(s);
 	security_sb_free(s);
 	WARN_ON(!list_empty(&s->s_mounts));
 	kfree(s->s_subtype);
@@ -647,10 +699,11 @@ struct super_block *get_super_thawed(struct block_device *bdev)
 {
 	while (1) {
 		struct super_block *s = get_super(bdev);
-		if (!s || s->s_frozen == SB_UNFROZEN)
+		if (!s || s->s_writers.frozen == SB_UNFROZEN)
 			return s;
 		up_read(&s->s_umount);
-		vfs_check_frozen(s, SB_FREEZE_WRITE);
+		wait_event(s->s_writers.wait_unfrozen,
+			   s->s_writers.frozen == SB_UNFROZEN);
 		put_super(s);
 	}
 }
@@ -728,7 +781,7 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	int retval;
 	int remount_ro;
 
-	if (sb->s_frozen != SB_UNFROZEN)
+	if (sb->s_writers.frozen != SB_UNFROZEN)
 		return -EBUSY;
 
 #ifdef CONFIG_BLOCK
@@ -1163,6 +1216,196 @@ out:
 	return ERR_PTR(error);
 }
 
+static void __sb_end_write(struct super_block *sb, int level)
+{
+	percpu_counter_dec(&sb->s_writers.counter[level-1]);
+	/*
+	 * Make sure s_writers are updated before we wake up waiters in
+	 * freeze_super().
+	 */
+	smp_mb();
+	if (waitqueue_active(&sb->s_writers.wait))
+		wake_up(&sb->s_writers.wait);
+	rwsem_release(&sb->s_writers.lock_map[level-1], 1, _RET_IP_);
+}
+
+/**
+ * sb_end_write - drop write access to a superblock
+ * @sb: the super we wrote to
+ *
+ * Decrement number of writers to the filesystem. Wake up possible waiters
+ * wanting to freeze the filesystem.
+ */
+void sb_end_write(struct super_block *sb)
+{
+	__sb_end_write(sb, SB_FREEZE_WRITE);
+}
+EXPORT_SYMBOL(sb_end_write);
+
+/**
+ * sb_end_pagefault - drop write access to a superblock from a page fault
+ * @sb: the super we wrote to
+ *
+ * Decrement number of processes handling write page fault to the filesystem.
+ * Wake up possible waiters wanting to freeze the filesystem.
+ */
+void sb_end_pagefault(struct super_block *sb)
+{
+	__sb_end_write(sb, SB_FREEZE_PAGEFAULT);
+}
+EXPORT_SYMBOL(sb_end_pagefault);
+
+/**
+ * sb_end_intwrite - drop write access to a superblock for internal fs purposes
+ * @sb: the super we wrote to
+ *
+ * Decrement fs-internal number of writers to the filesystem.  Wake up possible
+ * waiters wanting to freeze the filesystem.
+ */
+void sb_end_intwrite(struct super_block *sb)
+{
+	__sb_end_write(sb, SB_FREEZE_FS);
+}
+EXPORT_SYMBOL(sb_end_intwrite);
+
+static int __sb_start_write(struct super_block *sb, int level, bool wait)
+{
+retry:
+	if (wait) {
+		wait_event(sb->s_writers.wait_unfrozen,
+			   sb->s_writers.frozen < level);
+	} else if (sb->s_writers.frozen >= level)
+		return 0;
+
+	rwsem_acquire_read(&sb->s_writers.lock_map[level-1], 0, !wait,
+			   _RET_IP_);
+	percpu_counter_inc(&sb->s_writers.counter[level-1]);
+	/*
+	 * Make sure counter is updated before we check for frozen.
+	 * freeze_super() first sets frozen and then checks the counter.
+	 */
+	smp_mb();
+	if (sb->s_writers.frozen >= level) {
+		__sb_end_write(sb, level);
+		goto retry;
+	}
+	return 1;
+}
+
+/**
+ * sb_start_write - get write access to a superblock
+ * @sb: the super we write to
+ *
+ * When a process wants to write data or metadata to a file system (i.e. dirty
+ * a page or an inode), it should embed the operation in a sb_start_write() -
+ * sb_end_write() pair to get exclusion against file system freezing. This
+ * function increments number of writers preventing freezing. If the file
+ * system is already frozen, the function waits until the file system is
+ * thawed.
+ *
+ * Since freeze protection behaves as a lock, users have to preserve
+ * ordering of freeze protection and other filesystem locks. Generally,
+ * freeze protection should be the outermost lock. In particular, we have:
+ *
+ * sb_start_write
+ *   -> i_mutex			(write path, truncate, directory ops, ...)
+ *   -> s_umount		(freeze_super, thaw_super)
+ */
+void sb_start_write(struct super_block *sb)
+{
+	__sb_start_write(sb, SB_FREEZE_WRITE, true);
+}
+EXPORT_SYMBOL(sb_start_write);
+
+int sb_start_write_trylock(struct super_block *sb)
+{
+	return __sb_start_write(sb, SB_FREEZE_WRITE, false);
+}
+EXPORT_SYMBOL(sb_start_write_trylock);
+
+/**
+ * sb_start_pagefault - get write access to a superblock from a page fault
+ * @sb: the super we write to
+ *
+ * When a process starts handling write page fault, it should embed the
+ * operation into sb_start_pagefault() - sb_end_pagefault() pair to get
+ * exclusion against file system freezing. This is needed since the page fault
+ * is going to dirty a page. This function increments number of running page
+ * faults preventing freezing. If the file system is already frozen, the
+ * function waits until the file system is thawed.
+ *
+ * Since page fault freeze protection behaves as a lock, users have to preserve
+ * ordering of freeze protection and other filesystem locks. It is advised to
+ * put sb_start_pagefault() close to mmap_sem in lock ordering. Page fault
+ * handling code implies lock dependency:
+ *
+ * mmap_sem
+ *   -> sb_start_pagefault
+ */
+void sb_start_pagefault(struct super_block *sb)
+{
+	__sb_start_write(sb, SB_FREEZE_PAGEFAULT, true);
+}
+EXPORT_SYMBOL(sb_start_pagefault);
+
+/*
+ * sb_start_intwrite - get write access to a superblock for internal fs purposes
+ * @sb: the super we write to
+ *
+ * This is the third level of protection against filesystem freezing. It is
+ * free for use by a filesystem. The only requirement is that it must rank
+ * below sb_start_pagefault.
+ *
+ * For example filesystem can call sb_start_intwrite() when starting a
+ * transaction which somewhat eases handling of freezing for internal sources
+ * of filesystem changes (internal fs threads, discarding preallocation on file
+ * close, etc.).
+ */
+void sb_start_intwrite(struct super_block *sb)
+{
+	__sb_start_write(sb, SB_FREEZE_FS, true);
+}
+EXPORT_SYMBOL(sb_start_intwrite);
+
+/**
+ * sb_wait_write - wait until all writers to given file system finish
+ * @sb: the super for which we wait
+ * @level: type of writers we wait for (normal vs page fault)
+ *
+ * This function waits until there are no writers of given type to given file
+ * system. Caller of this function should make sure there can be no new writers
+ * of type @level before calling this function. Otherwise this function can
+ * livelock.
+ */
+static void sb_wait_write(struct super_block *sb, int level)
+{
+	s64 writers;
+
+	/*
+	 * We just cycle-through lockdep here so that it does not complain
+	 * about returning with lock to userspace
+	 */
+	rwsem_acquire(&sb->s_writers.lock_map[level-1], 0, 0, _THIS_IP_);
+	rwsem_release(&sb->s_writers.lock_map[level-1], 1, _THIS_IP_);
+
+	do {
+		DEFINE_WAIT(wait);
+
+		/*
+		 * We use a barrier in prepare_to_wait() to separate setting
+		 * of frozen and checking of the counter
+		 */
+		prepare_to_wait(&sb->s_writers.wait, &wait,
+				TASK_UNINTERRUPTIBLE);
+
+		writers = percpu_counter_sum(&sb->s_writers.counter[level-1]);
+		if (writers)
+			schedule();
+
+		finish_wait(&sb->s_writers.wait, &wait);
+	} while (writers);
+}
+
 /**
  * freeze_super - lock the filesystem and force it into a consistent state
  * @sb: the super to lock
@@ -1170,6 +1413,31 @@ out:
  * Syncs the super to make sure the filesystem is consistent and calls the fs's
  * freeze_fs.  Subsequent calls to this without first thawing the fs will return
  * -EBUSY.
+ *
+ * During this function, sb->s_writers.frozen goes through these values:
+ *
+ * SB_UNFROZEN: File system is normal, all writes progress as usual.
+ *
+ * SB_FREEZE_WRITE: The file system is in the process of being frozen.  New
+ * writes should be blocked, though page faults are still allowed. We wait for
+ * all writes to complete and then proceed to the next stage.
+ *
+ * SB_FREEZE_PAGEFAULT: Freezing continues. Now also page faults are blocked
+ * but internal fs threads can still modify the filesystem (although they
+ * should not dirty new pages or inodes), writeback can run etc. After waiting
+ * for all running page faults we sync the filesystem which will clean all
+ * dirty pages and inodes (no new dirty pages or inodes can be created when
+ * sync is running).
+ *
+ * SB_FREEZE_FS: The file system is frozen. Now all internal sources of fs
+ * modification are blocked (e.g. XFS preallocation truncation on inode
+ * reclaim). This is usually implemented by blocking new transactions for
+ * filesystems that have them and need this additional guard. After all
+ * internal writers are finished we call ->freeze_fs() to finish filesystem
+ * freezing. Then we transition to SB_FREEZE_COMPLETE state. This state is
+ * mostly auxiliary for filesystems to verify they do not modify frozen fs.
+ *
+ * sb->s_writers.frozen is protected by sb->s_umount.
  */
 int freeze_super(struct super_block *sb)
 {
@@ -1177,7 +1445,7 @@ int freeze_super(struct super_block *sb)
 
 	atomic_inc(&sb->s_active);
 	down_write(&sb->s_umount);
-	if (sb->s_frozen) {
+	if (sb->s_writers.frozen != SB_UNFROZEN) {
 		deactivate_locked_super(sb);
 		return -EBUSY;
 	}
@@ -1188,33 +1456,53 @@ int freeze_super(struct super_block *sb)
 	}
 
 	if (sb->s_flags & MS_RDONLY) {
-		sb->s_frozen = SB_FREEZE_TRANS;
-		smp_wmb();
+		/* Nothing to do really... */
+		sb->s_writers.frozen = SB_FREEZE_COMPLETE;
 		up_write(&sb->s_umount);
 		return 0;
 	}
 
-	sb->s_frozen = SB_FREEZE_WRITE;
+	/* From now on, no new normal writers can start */
+	sb->s_writers.frozen = SB_FREEZE_WRITE;
+	smp_wmb();
+
+	/* Release s_umount to preserve sb_start_write -> s_umount ordering */
+	up_write(&sb->s_umount);
+
+	sb_wait_write(sb, SB_FREEZE_WRITE);
+
+	/* Now we go and block page faults... */
+	down_write(&sb->s_umount);
+	sb->s_writers.frozen = SB_FREEZE_PAGEFAULT;
 	smp_wmb();
 
+	sb_wait_write(sb, SB_FREEZE_PAGEFAULT);
+
+	/* All writers are done so after syncing there won't be dirty data */
 	sync_filesystem(sb);
 
-	sb->s_frozen = SB_FREEZE_TRANS;
+	/* Now wait for internal filesystem counter */
+	sb->s_writers.frozen = SB_FREEZE_FS;
 	smp_wmb();
+	sb_wait_write(sb, SB_FREEZE_FS);
 
-	sync_blockdev(sb->s_bdev);
 	if (sb->s_op->freeze_fs) {
 		ret = sb->s_op->freeze_fs(sb);
 		if (ret) {
 			printk(KERN_ERR
 				"VFS:Filesystem freeze failed\n");
-			sb->s_frozen = SB_UNFROZEN;
+			sb->s_writers.frozen = SB_UNFROZEN;
 			smp_wmb();
-			wake_up(&sb->s_wait_unfrozen);
+			wake_up(&sb->s_writers.wait_unfrozen);
 			deactivate_locked_super(sb);
 			return ret;
 		}
 	}
+	/*
+	 * This is just for debugging purposes so that fs can warn if it
+	 * sees write activity when frozen is set to SB_FREEZE_COMPLETE.
+	 */
+	sb->s_writers.frozen = SB_FREEZE_COMPLETE;
 	up_write(&sb->s_umount);
 	return 0;
 }
@@ -1231,7 +1519,7 @@ int thaw_super(struct super_block *sb)
 	int error;
 
 	down_write(&sb->s_umount);
-	if (sb->s_frozen == SB_UNFROZEN) {
+	if (sb->s_writers.frozen == SB_UNFROZEN) {
 		up_write(&sb->s_umount);
 		return -EINVAL;
 	}
@@ -1244,16 +1532,15 @@ int thaw_super(struct super_block *sb)
 		if (error) {
 			printk(KERN_ERR
 				"VFS:Filesystem thaw failed\n");
-			sb->s_frozen = SB_FREEZE_TRANS;
 			up_write(&sb->s_umount);
 			return error;
 		}
 	}
 
 out:
-	sb->s_frozen = SB_UNFROZEN;
+	sb->s_writers.frozen = SB_UNFROZEN;
 	smp_wmb();
-	wake_up(&sb->s_wait_unfrozen);
+	wake_up(&sb->s_writers.wait_unfrozen);
 	deactivate_locked_super(sb);
 
 	return 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8de6755..d3c5126 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -402,6 +402,7 @@ struct inodes_stat_t {
 #include <linux/atomic.h>
 #include <linux/shrinker.h>
 #include <linux/migrate_mode.h>
+#include <linux/lockdep.h>
 
 #include <asm/byteorder.h>
 
@@ -1402,6 +1403,16 @@ extern void f_delown(struct file *filp);
 extern pid_t f_getown(struct file *filp);
 extern int send_sigurg(struct fown_struct *fown);
 
+struct mm_struct;
+
+void sb_start_write(struct super_block *sb);
+int sb_start_write_trylock(struct super_block *sb);
+void sb_end_write(struct super_block *sb);
+void sb_start_pagefault(struct super_block *sb);
+void sb_end_pagefault(struct super_block *sb);
+void sb_start_intwrite(struct super_block *sb);
+void sb_end_intwrite(struct super_block *sb);
+
 /*
  *	Umount options
  */
@@ -1415,6 +1426,32 @@ extern int send_sigurg(struct fown_struct *fown);
 extern struct list_head super_blocks;
 extern spinlock_t sb_lock;
 
+/* Possible states of 'frozen' field */
+enum {
+	SB_UNFROZEN = 0,		/* FS is unfrozen */
+	SB_FREEZE_WRITE	= 1,		/* Writes, dir ops, ioctls frozen */
+	SB_FREEZE_TRANS = 2,
+	SB_FREEZE_PAGEFAULT = 2,	/* Page faults stopped as well */
+	SB_FREEZE_FS = 3,		/* For internal FS use (e.g. to stop
+					 * internal threads if needed) */
+	SB_FREEZE_COMPLETE = 4,		/* ->freeze_fs finished successfully */
+};
+
+#define SB_FREEZE_LEVELS (SB_FREEZE_COMPLETE - 1)
+
+struct sb_writers {
+	/* Counters for counting writers at each level */
+	struct percpu_counter	counter[SB_FREEZE_LEVELS];
+	wait_queue_head_t	wait;		/* queue for waiting for
+						   writers / faults to finish */
+	int			frozen;		/* Is sb frozen? */
+	wait_queue_head_t	wait_unfrozen;	/* queue for waiting for
+						   sb to be thawed */
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	lock_map[SB_FREEZE_LEVELS];
+#endif
+};
+
 struct super_block {
 	struct list_head	s_list;		/* Keep this first */
 	dev_t			s_dev;		/* search index; _not_ kdev_t */
@@ -1464,6 +1501,7 @@ struct super_block {
 
 	int			s_frozen;
 	wait_queue_head_t	s_wait_unfrozen;
+	struct sb_writers	s_writers;
 
 	char s_id[32];				/* Informational name */
 	u8 s_uuid[16];				/* UUID */
@@ -1518,14 +1556,8 @@ extern struct timespec current_fs_time(struct super_block *sb);
 /*
  * Snapshotting support.
  */
-enum {
-	SB_UNFROZEN = 0,
-	SB_FREEZE_WRITE	= 1,
-	SB_FREEZE_TRANS = 2,
-};
-
-#define vfs_check_frozen(sb, level) \
-	wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level)))
+/* Will go away when all users are converted */
+#define vfs_check_frozen(sb, level) do { } while (0)
 
 /*
  * until VFS tracks user namespaces for inodes, just make all files
-- 
1.7.1

