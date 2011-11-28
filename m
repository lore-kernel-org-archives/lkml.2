Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1K2AFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 19:05:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab1K2AE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 19:04:58 -0500
Date: Mon, 28 Nov 2011 18:32:18 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Valerie Aurora <val@vaaconsulting.com>
cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        esandeen@redhat.com
Subject: Re: [PATCH] deadlock with suspend and quotas
In-Reply-To: <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com>
Message-ID: <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
 <20111128150400.GE6366@quack.suse.cz> <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
 <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi
> 
> Where can I get that patch set?
> 
> We are experiencing other similar deadlocks on RHEL-6, caused by sync or 
> background writeback (these code paths take s_umount and wait trying to do 
> I/O), but I wasn't able to reproduce these deadlocks on upstream kernel? 
> Are there other known deadlock possibilities?
> 
> Mikulas

I found some patch named "[RFC PATCH 1/3] VFS: Fix s_umount thaw/write 
deadlock" (I couldn't find the next two parts of the patch in the 
archives). And the patch looks wrong:

- down_read_trylock(&sb->s_umount) doesn't fix anything. The lock is not 
held when the filesystem is frozen and it is taken for write when thawing. 
Consequently, any task can succeed with down_read_trylock(&sb->s_umount) 
on a frozen filesystem and if this tasks attempts to do an I/O that is 
waiting for thaw, it may still deadlock.

- skipping sync on frozen filesystem violates sync semantics. 
Applications, such as databases, assume that when sync finishes, data were 
written to stable storage. If we skip sync when the filesystem is frozen, 
we can cause data corruption in these applications (if the system crashes 
after we skipped a sync).

- I'm not sure what userspace quota subsystem will do if we start 
returning -EBUSY spuriously.

There is another thing --- I wasn't able to reproduce these sync-related 
deadlocks at all. Did anyone succeeded in reproducing them? Are there any 
reported deadlocks? When freezing the ext3 or ext4 filesystem, the kernel 
prevents creating new dirty data, syncs all data, and freezes the 
filesystem. Consequently, the sync function never finds any dirty data and 
so it doesn't block (sync doesn't writeback ATIME change, I don't know 
why).

I made this patch that fixes the quota issue and possible sync issues. It 
introduces a function down_read_s_umount(sb); --- this function takes 
s_umount lock for read, but it waits if the filesystem is suspended.

There are three more potentially unsafe users: fs/cachefiles/interface.c, 
fs/nilfs2/ioctl.c, fs/ubifs/budget.c - I didn't fix them because I can't 
test them.

Mikulas

---

Fix a s_umount deadlock

The lock s_umount is taken for write and dropped when we freeze and resume
a block device.

Consequently, if some code holds s_umount and performs an I/O, a deadlock may
happen if the device is suspended.

Unfortunatelly, it seems that developers are not aware of this restriction
that I/O must not be peformed with s_umount held.

These deadlocks were observed:
* lvcreate process: sys_ioctl -> do_vfs_ioctl -> vfs_ioctl -> dm_ctl_ioctl ->
  ctl_ioctl -> dev_suspend -> dm_resume -> unlock_fs -> thaw_bdev ->
  call_rwsem_down_write_failed (the process is trying to resume frozen device, 
  but it is waiting trying to acquire s_umount)
* quota: sys_quotactl -> do_quotactl -> vfs_get_dqblk -> dqget ->
  ext4_acquire_dquot -> ext4_journal_start_sb -> jbd2_journal_start ->
  start_this_handle (the process is holding s_umount and trying to perform
  a transaction, waiting for the device being unfrozen)

* iozone process: sys_sync -> sync_filesystems -> __sync_filesystem ->
  writeback_inodes_sb -> writeback_inodes_sb_nr -> wait_for_completion
  (the process is holding s_umount for read and trying to perform some I/O)
* flush-253:3: kthread -> bdi_start_fn -> bdi_writeback_task ->
  wb_do_writeback -> wb_writeback -> writeback_sb_inodes ->
  writeback_single_inode -> do_writepages -> ext4_da_writepages ->
  ext4_journal_start_sb -> jbd2_journal_start -> start_this_handle
  (holding s_umount for read too, acquired in writeback_inodes_wb,
  and trying to perform I/O)
* lvcreate process: sys_ioctl -> do_vfs_ioctl -> vfs_ioctl -> dm_ctl_ioctl ->
  ctl_ioctl -> dev_suspend -> dm_resume -> unlock_fs -> thaw_bdev ->
  call_rwsem_down_write_failed (just like in a previous case: trying to
  resume frozen device, waiting on s_umount)

This patch fixes these observed code paths:
* introduce a function to safely take s_unlock - down_read_s_umount. It takes
  the lock, check if a filesystem is frozen, if it is, drops the lock and
  waits for unfreeze.
* get_super function has a parameter, if the parameter is true, it waits for
  the device to unfreeze (it fixes quota deadlock and a possible deadlock in
  fsync_bdev and __invalidate_device)
* the same for iterate_supers (it fixes the sync deadlock and a possible
  deadlock in drop_caches_sysctl_handler)
* grab_super_passive fails if the device is suspended (fixes the inode writeback
  deadlock and a possible deadlock in prune_super)

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
CC: stable@kernel.org

---
 fs/block_dev.c           |    6 +++---
 fs/buffer.c              |    2 +-
 fs/drop_caches.c         |    2 +-
 fs/fs-writeback.c        |    8 ++++++++
 fs/quota/quota.c         |    4 ++--
 fs/super.c               |   29 ++++++++++++++++++++---------
 fs/sync.c                |    4 ++--
 include/linux/fs.h       |   28 +++++++++++++++++++++++++---
 security/selinux/hooks.c |    2 +-
 9 files changed, 63 insertions(+), 22 deletions(-)

Index: linux-3.2-rc3-fast/fs/quota/quota.c
===================================================================
--- linux-3.2-rc3-fast.orig/fs/quota/quota.c	2011-11-25 05:51:13.000000000 +0100
+++ linux-3.2-rc3-fast/fs/quota/quota.c	2011-11-25 05:51:36.000000000 +0100
@@ -59,7 +59,7 @@ static int quota_sync_all(int type)
 		return -EINVAL;
 	ret = security_quotactl(Q_SYNC, type, 0, NULL);
 	if (!ret)
-		iterate_supers(quota_sync_one, &type);
+		iterate_supers(quota_sync_one, &type, true);
 	return ret;
 }
 
@@ -310,7 +310,7 @@ static struct super_block *quotactl_bloc
 	putname(tmp);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
-	sb = get_super(bdev);
+	sb = get_super(bdev, true);
 	bdput(bdev);
 	if (!sb)
 		return ERR_PTR(-ENODEV);
Index: linux-3.2-rc3-fast/include/linux/fs.h
===================================================================
--- linux-3.2-rc3-fast.orig/include/linux/fs.h	2011-11-25 05:51:13.000000000 +0100
+++ linux-3.2-rc3-fast/include/linux/fs.h	2011-11-25 05:56:03.000000000 +0100
@@ -10,6 +10,7 @@
 #include <linux/ioctl.h>
 #include <linux/blk_types.h>
 #include <linux/types.h>
+#include <linux/sched.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -1502,6 +1503,26 @@ enum {
 	wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level)))
 
 /*
+ * Take s_umount and make sure that the filesystem is not frozen.
+ * This function must be used if we intend to perform any I/O while
+ * holding s_umount.
+ *
+ * s_umount is taken for write when resuming a frozen filesystem,
+ * thus if someone calls down_read(&s->s_umount) and performs any I/O,
+ * it may deadlock.
+ */
+static inline void down_read_s_umount(struct super_block *sb)
+{
+retry:
+	down_read(&sb->s_umount);
+	if (unlikely(sb->s_frozen != SB_UNFROZEN)) {
+		up_write(&sb->s_umount);
+		vfs_check_frozen(sb, SB_FREEZE_WRITE);
+		goto retry;
+	}
+}
+
+/*
  * until VFS tracks user namespaces for inodes, just make all files
  * belong to init_user_ns
  */
@@ -2528,13 +2549,14 @@ extern int generic_block_fiemap(struct i
 extern void get_filesystem(struct file_system_type *fs);
 extern void put_filesystem(struct file_system_type *fs);
 extern struct file_system_type *get_fs_type(const char *name);
-extern struct super_block *get_super(struct block_device *);
+extern struct super_block *get_super(struct block_device *, bool);
 extern struct super_block *get_active_super(struct block_device *bdev);
 extern struct super_block *user_get_super(dev_t);
 extern void drop_super(struct super_block *sb);
-extern void iterate_supers(void (*)(struct super_block *, void *), void *);
+extern void iterate_supers(void (*)(struct super_block *, void *), void *, bool);
 extern void iterate_supers_type(struct file_system_type *,
-			        void (*)(struct super_block *, void *), void *);
+			        void (*)(struct super_block *, void *), void *,
+				bool);
 
 extern int dcache_dir_open(struct inode *, struct file *);
 extern int dcache_dir_close(struct inode *, struct file *);
Index: linux-3.2-rc3-fast/fs/buffer.c
===================================================================
--- linux-3.2-rc3-fast.orig/fs/buffer.c	2011-11-25 05:51:13.000000000 +0100
+++ linux-3.2-rc3-fast/fs/buffer.c	2011-11-25 05:51:36.000000000 +0100
@@ -571,7 +571,7 @@ static void do_thaw_one(struct super_blo
 
 static void do_thaw_all(struct work_struct *work)
 {
-	iterate_supers(do_thaw_one, NULL);
+	iterate_supers(do_thaw_one, NULL, false);
 	kfree(work);
 	printk(KERN_WARNING "Emergency Thaw complete\n");
 }
Index: linux-3.2-rc3-fast/fs/super.c
===================================================================
--- linux-3.2-rc3-fast.orig/fs/super.c	2011-11-25 05:51:13.000000000 +0100
+++ linux-3.2-rc3-fast/fs/super.c	2011-11-29 00:16:01.000000000 +0100
@@ -337,7 +337,7 @@ bool grab_super_passive(struct super_blo
 	spin_unlock(&sb_lock);
 
 	if (down_read_trylock(&sb->s_umount)) {
-		if (sb->s_root)
+		if (sb->s_frozen == SB_UNFROZEN && sb->s_root)
 			return true;
 		up_read(&sb->s_umount);
 	}
@@ -503,7 +503,7 @@ void sync_supers(void)
 			sb->s_count++;
 			spin_unlock(&sb_lock);
 
-			down_read(&sb->s_umount);
+			down_read_s_umount(sb);
 			if (sb->s_root && sb->s_dirt)
 				sb->s_op->write_super(sb);
 			up_read(&sb->s_umount);
@@ -527,7 +527,8 @@ void sync_supers(void)
  *	Scans the superblock list and calls given function, passing it
  *	locked superblock and given argument.
  */
-void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
+void iterate_supers(void (*f)(struct super_block *, void *), void *arg,
+		    bool wait_for_unfreeze)
 {
 	struct super_block *sb, *p = NULL;
 
@@ -538,7 +539,10 @@ void iterate_supers(void (*f)(struct sup
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 
-		down_read(&sb->s_umount);
+		if (!wait_for_unfreeze)
+			down_read(&sb->s_umount);
+		else
+			down_read_s_umount(sb);
 		if (sb->s_root)
 			f(sb, arg);
 		up_read(&sb->s_umount);
@@ -563,7 +567,8 @@ void iterate_supers(void (*f)(struct sup
  *	locked superblock and given argument.
  */
 void iterate_supers_type(struct file_system_type *type,
-	void (*f)(struct super_block *, void *), void *arg)
+	void (*f)(struct super_block *, void *), void *arg,
+	bool wait_for_unfreeze)
 {
 	struct super_block *sb, *p = NULL;
 
@@ -572,7 +577,10 @@ void iterate_supers_type(struct file_sys
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 
-		down_read(&sb->s_umount);
+		if (!wait_for_unfreeze)
+			down_read(&sb->s_umount);
+		else
+			down_read_s_umount(sb);
 		if (sb->s_root)
 			f(sb, arg);
 		up_read(&sb->s_umount);
@@ -597,7 +605,7 @@ EXPORT_SYMBOL(iterate_supers_type);
  *	mounted on the device given. %NULL is returned if no match is found.
  */
 
-struct super_block *get_super(struct block_device *bdev)
+struct super_block *get_super(struct block_device *bdev, bool wait_for_unfreeze)
 {
 	struct super_block *sb;
 
@@ -612,7 +620,10 @@ rescan:
 		if (sb->s_bdev == bdev) {
 			sb->s_count++;
 			spin_unlock(&sb_lock);
-			down_read(&sb->s_umount);
+			if (wait_for_unfreeze)
+				down_read_s_umount(sb);
+			else
+				down_read(&sb->s_umount);
 			/* still alive? */
 			if (sb->s_root)
 				return sb;
@@ -672,7 +683,7 @@ rescan:
 		if (sb->s_dev ==  dev) {
 			sb->s_count++;
 			spin_unlock(&sb_lock);
-			down_read(&sb->s_umount);
+			down_read_s_umount(sb);
 			/* still alive? */
 			if (sb->s_root)
 				return sb;
Index: linux-3.2-rc3-fast/fs/sync.c
===================================================================
--- linux-3.2-rc3-fast.orig/fs/sync.c	2011-11-25 05:51:13.000000000 +0100
+++ linux-3.2-rc3-fast/fs/sync.c	2011-11-25 05:51:36.000000000 +0100
@@ -89,7 +89,7 @@ static void sync_one_sb(struct super_blo
  */
 static void sync_filesystems(int wait)
 {
-	iterate_supers(sync_one_sb, &wait);
+	iterate_supers(sync_one_sb, &wait, true);
 }
 
 /*
@@ -144,7 +144,7 @@ SYSCALL_DEFINE1(syncfs, int, fd)
 		return -EBADF;
 	sb = file->f_dentry->d_sb;
 
-	down_read(&sb->s_umount);
+	down_read_s_umount(sb);
 	ret = sync_filesystem(sb);
 	up_read(&sb->s_umount);
 
Index: linux-3.2-rc3-fast/fs/block_dev.c
===================================================================
--- linux-3.2-rc3-fast.orig/fs/block_dev.c	2011-11-25 05:51:13.000000000 +0100
+++ linux-3.2-rc3-fast/fs/block_dev.c	2011-11-25 05:51:36.000000000 +0100
@@ -222,7 +222,7 @@ EXPORT_SYMBOL(sync_blockdev);
  */
 int fsync_bdev(struct block_device *bdev)
 {
-	struct super_block *sb = get_super(bdev);
+	struct super_block *sb = get_super(bdev, true);
 	if (sb) {
 		int res = sync_filesystem(sb);
 		drop_super(sb);
@@ -256,7 +256,7 @@ struct super_block *freeze_bdev(struct b
 		 * to freeze_bdev grab an active reference and only the last
 		 * thaw_bdev drops it.
 		 */
-		sb = get_super(bdev);
+		sb = get_super(bdev, false);
 		drop_super(sb);
 		mutex_unlock(&bdev->bd_fsfreeze_mutex);
 		return sb;
@@ -1658,7 +1658,7 @@ EXPORT_SYMBOL(lookup_bdev);
 
 int __invalidate_device(struct block_device *bdev, bool kill_dirty)
 {
-	struct super_block *sb = get_super(bdev);
+	struct super_block *sb = get_super(bdev, true);
 	int res = 0;
 
 	if (sb) {
Index: linux-3.2-rc3-fast/fs/drop_caches.c
===================================================================
--- linux-3.2-rc3-fast.orig/fs/drop_caches.c	2011-11-25 05:51:13.000000000 +0100
+++ linux-3.2-rc3-fast/fs/drop_caches.c	2011-11-25 05:51:36.000000000 +0100
@@ -59,7 +59,7 @@ int drop_caches_sysctl_handler(ctl_table
 		return ret;
 	if (write) {
 		if (sysctl_drop_caches & 1)
-			iterate_supers(drop_pagecache_sb, NULL);
+			iterate_supers(drop_pagecache_sb, NULL, true);
 		if (sysctl_drop_caches & 2)
 			drop_slab();
 	}
Index: linux-3.2-rc3-fast/security/selinux/hooks.c
===================================================================
--- linux-3.2-rc3-fast.orig/security/selinux/hooks.c	2011-11-25 05:51:13.000000000 +0100
+++ linux-3.2-rc3-fast/security/selinux/hooks.c	2011-11-25 05:51:36.000000000 +0100
@@ -5693,7 +5693,7 @@ void selinux_complete_init(void)
 
 	/* Set up any superblocks initialized prior to the policy load. */
 	printk(KERN_DEBUG "SELinux:  Setting up existing superblocks.\n");
-	iterate_supers(delayed_superblock_init, NULL);
+	iterate_supers(delayed_superblock_init, NULL, true);
 }
 
 /* SELinux requires early initialization in order to label
Index: linux-3.2-rc3-fast/fs/fs-writeback.c
===================================================================
--- linux-3.2-rc3-fast.orig/fs/fs-writeback.c	2011-11-29 00:09:30.000000000 +0100
+++ linux-3.2-rc3-fast/fs/fs-writeback.c	2011-11-29 00:12:49.000000000 +0100
@@ -1273,6 +1273,10 @@ int writeback_inodes_sb_if_idle(struct s
 {
 	if (!writeback_in_progress(sb->s_bdi)) {
 		down_read(&sb->s_umount);
+		if (unlikely(sb->s_frozen != SB_UNFROZEN)) {
+			up_read(&sb->s_umount);
+			return 0;
+		}
 		writeback_inodes_sb(sb, reason);
 		up_read(&sb->s_umount);
 		return 1;
@@ -1295,6 +1299,10 @@ int writeback_inodes_sb_nr_if_idle(struc
 {
 	if (!writeback_in_progress(sb->s_bdi)) {
 		down_read(&sb->s_umount);
+		if (unlikely(sb->s_frozen != SB_UNFROZEN)) {
+			up_read(&sb->s_umount);
+			return 0;
+		}
 		writeback_inodes_sb_nr(sb, nr, reason);
 		up_read(&sb->s_umount);
 		return 1;
