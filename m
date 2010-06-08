Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab0FHM7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 08:59:15 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:49391 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754536Ab0FHM7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 08:59:13 -0400
Date: Tue, 8 Jun 2010 22:58:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <josef@redhat.com>
Cc: Jeffrey Merkey <jeffmerkey@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: 2.6.34 echo j > /proc/sysrq-trigger causes inifnite
 unfreeze/Thaw event
Message-ID: <20100608125852.GD7869@dastard>
References: <AANLkTim74SREZDq7VQhq6Z1hKXZLINoq0t8rkyQecmM1@mail.gmail.com>
 <20100607010542.GB27325@dastard>
 <20100607213631.GE2336@localhost.localdomain>
 <20100607215925.GF2336@localhost.localdomain>
 <20100607232350.GA6965@dastard>
 <20100608020741.GG2336@localhost.localdomain>
 <20100608022652.GC6965@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100608022652.GC6965@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 12:26:52PM +1000, Dave Chinner wrote:
> On Mon, Jun 07, 2010 at 10:07:41PM -0400, Josef Bacik wrote:
> > Well damnit.  I guess what we need to do is get rid of the freeze_bdev/thaw_bdev
> > interface altogether, and move the count stuff down to the super.  Anybody who
> > calls freeze_bdev/thaw_bdev knows the sb anyway, so if we get rid of
> > bd_fsfreeze_count and move it to sb->s_fsfreeze_count and do the same with
> > bd_fsfreeze_mutex then we could solve this altogether and simplify the
> > interface.  It grows the sb struct, but hey it shrinks the bdev struct :).  How
> > horrible of an idea is that?  Thanks,
> 
> Kind of what I was thinking of. I wasn't sure about what btrfs
> required, but you've cleared that up. I'll put a patch together and
> see how it looks.

Not too bad:

 8 files changed, 137 insertions(+), 190 deletions(-)

It really needs to be split up into multiple commits and the test
case needs to exercise dmsetup suspend/resume as well, but I think
this works well enough for comments at this point. I've only tested
it on XFS so far.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


RFC: fsfreeze: kill freeze_bdev/thaw_bdev

From: Dave Chinner <dchinner@redhat.com>

The thawing of a filesystem through sysrq-j loops infinitely as it
incorrectly detects a thawed filesytsem as frozen and tries to
unfreeze repeatedly. This is a regression caused by
4504230a71566785a05d3e6b53fa1ee071b864eb ("freeze_bdev: grab active
reference to frozen superblocks") in that it no longer returned
-EINVAL for superblocks that were not frozen.

Deeper problems arose on further inspection - filesystems frozen with
freeze_super() could not be unfrozen by thaw_bdev() so emergency thawing didn't
work on anything manually frozen, and deadlocks on sb->s_umount occur as
superblocks are iterated in the emergency thaw with it already held for read.

Everywhere we freeze or thaw, we already have a superblock or can get one
easily so could call freeze_super() directly. Hence we can kill the bdev level
operations and move all the nesting infrastructure up into the superblock
level so we have a single consistent interface.

While there, we can move all the emergency thaw infrastructure to fs/super.c
so that all the freeze/thaw code is in one place and only freeze/thaw_super()
are exported.

This is just an RFC at this point. It passes simple testing (script below that
can be turned into an xfstest script easily) without triggering lockdep errors,
hanging or crashing....

Signed-off-by: Dave Chinner <dchinner@redhat.com>

#!/bin/bash
MNT=$1

mount $MNT
xfs_freeze -f $MNT ; touch $MNT/foo &
xfs_freeze -u $MNT
wait

xfs_freeze -f $MNT ; touch $MNT/foo &
xfs_freeze -f $MNT ; touch $MNT/foo &
xfs_freeze -f $MNT ; touch $MNT/foo &
xfs_freeze -f $MNT ; touch $MNT/foo &
xfs_freeze -u $MNT
xfs_freeze -u $MNT
xfs_freeze -u $MNT
xfs_freeze -u $MNT
wait

xfs_freeze -f $MNT ; touch $MNT/foo &
xfs_freeze -f $MNT ; touch $MNT/foo &
xfs_freeze -f $MNT ; touch $MNT/foo &
xfs_freeze -f $MNT ; touch $MNT/foo &
echo j > /proc/sysrq-trigger
wait

xfs_freeze -u $MNT
xfs_freeze -u $MNT
xfs_freeze -u $MNT
xfs_freeze -u $MNT
xfs_freeze -u $MNT

xfs_freeze -f $MNT ; touch $MNT/foo &
xfs_freeze -f $MNT ; touch $MNT/foo &
xfs_freeze -u $MNT
xfs_freeze -u $MNT
wait
umount $MNT

---
 drivers/md/dm.c      |   13 +++--
 fs/block_dev.c       |   84 --------------------------
 fs/buffer.c          |   31 ----------
 fs/gfs2/ops_fstype.c |   12 ----
 fs/ioctl.c           |    2 -
 fs/super.c           |  160 ++++++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_fsops.c   |    6 +-
 include/linux/fs.h   |   19 +-----
 8 files changed, 137 insertions(+), 190 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d21e128..70d5fd6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2427,15 +2427,18 @@ static int lock_fs(struct mapped_device *md)
 
 	WARN_ON(md->frozen_sb);
 
-	md->frozen_sb = freeze_bdev(md->bdev);
-	if (IS_ERR(md->frozen_sb)) {
-		r = PTR_ERR(md->frozen_sb);
+	md->frozen_sb = get_active_super(md->bdev);
+	if (!md->frozen_sb)
+		return -EIO;
+	r = freeze_super(md->frozen_sb);
+	if (r) {
+		deactivate_super(md->frozen_sb);
 		md->frozen_sb = NULL;
 		return r;
 	}
+	deactivate_super(md->frozen_sb);
 
 	set_bit(DMF_FROZEN, &md->flags);
-
 	return 0;
 }
 
@@ -2444,7 +2447,7 @@ static void unlock_fs(struct mapped_device *md)
 	if (!test_bit(DMF_FROZEN, &md->flags))
 		return;
 
-	thaw_bdev(md->bdev, md->frozen_sb);
+	thaw_super(md->frozen_sb);
 	md->frozen_sb = NULL;
 	clear_bit(DMF_FROZEN, &md->flags);
 }
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7346c96..3c3d1fe 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -213,88 +213,6 @@ int fsync_bdev(struct block_device *bdev)
 }
 EXPORT_SYMBOL(fsync_bdev);
 
-/**
- * freeze_bdev  --  lock a filesystem and force it into a consistent state
- * @bdev:	blockdevice to lock
- *
- * If a superblock is found on this device, we take the s_umount semaphore
- * on it to make sure nobody unmounts until the snapshot creation is done.
- * The reference counter (bd_fsfreeze_count) guarantees that only the last
- * unfreeze process can unfreeze the frozen filesystem actually when multiple
- * freeze requests arrive simultaneously. It counts up in freeze_bdev() and
- * count down in thaw_bdev(). When it becomes 0, thaw_bdev() will unfreeze
- * actually.
- */
-struct super_block *freeze_bdev(struct block_device *bdev)
-{
-	struct super_block *sb;
-	int error = 0;
-
-	mutex_lock(&bdev->bd_fsfreeze_mutex);
-	if (++bdev->bd_fsfreeze_count > 1) {
-		/*
-		 * We don't even need to grab a reference - the first call
-		 * to freeze_bdev grab an active reference and only the last
-		 * thaw_bdev drops it.
-		 */
-		sb = get_super(bdev);
-		drop_super(sb);
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
-		return sb;
-	}
-
-	sb = get_active_super(bdev);
-	if (!sb)
-		goto out;
-	error = freeze_super(sb);
-	if (error) {
-		deactivate_super(sb);
-		bdev->bd_fsfreeze_count--;
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
-		return ERR_PTR(error);
-	}
-	deactivate_super(sb);
- out:
-	sync_blockdev(bdev);
-	mutex_unlock(&bdev->bd_fsfreeze_mutex);
-	return sb;	/* thaw_bdev releases s->s_umount */
-}
-EXPORT_SYMBOL(freeze_bdev);
-
-/**
- * thaw_bdev  -- unlock filesystem
- * @bdev:	blockdevice to unlock
- * @sb:		associated superblock
- *
- * Unlocks the filesystem and marks it writeable again after freeze_bdev().
- */
-int thaw_bdev(struct block_device *bdev, struct super_block *sb)
-{
-	int error = -EINVAL;
-
-	mutex_lock(&bdev->bd_fsfreeze_mutex);
-	if (!bdev->bd_fsfreeze_count)
-		goto out;
-
-	error = 0;
-	if (--bdev->bd_fsfreeze_count > 0)
-		goto out;
-
-	if (!sb)
-		goto out;
-
-	error = thaw_super(sb);
-	if (error) {
-		bdev->bd_fsfreeze_count++;
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
-		return error;
-	}
-out:
-	mutex_unlock(&bdev->bd_fsfreeze_mutex);
-	return 0;
-}
-EXPORT_SYMBOL(thaw_bdev);
-
 static int blkdev_writepage(struct page *page, struct writeback_control *wbc)
 {
 	return block_write_full_page(page, blkdev_get_block, wbc);
@@ -417,8 +335,6 @@ static void init_once(void *foo)
 	INIT_LIST_HEAD(&bdev->bd_holder_list);
 #endif
 	inode_init_once(&ei->vfs_inode);
-	/* Initialize mutex for freeze. */
-	mutex_init(&bdev->bd_fsfreeze_mutex);
 }
 
 static inline void __bd_forget(struct inode *inode)
diff --git a/fs/buffer.c b/fs/buffer.c
index d54812b..61bd994 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -561,37 +561,6 @@ repeat:
 	return err;
 }
 
-static void do_thaw_one(struct super_block *sb, void *unused)
-{
-	char b[BDEVNAME_SIZE];
-	while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
-		printk(KERN_WARNING "Emergency Thaw on %s\n",
-		       bdevname(sb->s_bdev, b));
-}
-
-static void do_thaw_all(struct work_struct *work)
-{
-	iterate_supers(do_thaw_one, NULL);
-	kfree(work);
-	printk(KERN_WARNING "Emergency Thaw complete\n");
-}
-
-/**
- * emergency_thaw_all -- forcibly thaw every frozen filesystem
- *
- * Used for emergency unfreeze of all filesystems via SysRq
- */
-void emergency_thaw_all(void)
-{
-	struct work_struct *work;
-
-	work = kmalloc(sizeof(*work), GFP_ATOMIC);
-	if (work) {
-		INIT_WORK(work, do_thaw_all);
-		schedule_work(work);
-	}
-}
-
 /**
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
  * @mapping: the mapping which wants those buffers written
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 3593b3a..5acc907 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1304,19 +1304,7 @@ static int gfs2_get_sb(struct file_system_type *fs_type, int flags,
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
-	/*
-	 * once the super is inserted into the list by sget, s_umount
-	 * will protect the lockfs code from trying to start a snapshot
-	 * while we are mounting
-	 */
-	mutex_lock(&bdev->bd_fsfreeze_mutex);
-	if (bdev->bd_fsfreeze_count > 0) {
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
-		error = -EBUSY;
-		goto error_bdev;
-	}
 	s = sget(fs_type, test_gfs2_super, set_gfs2_super, bdev);
-	mutex_unlock(&bdev->bd_fsfreeze_mutex);
 	error = PTR_ERR(s);
 	if (IS_ERR(s))
 		goto error_bdev;
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 2d140a7..31ff1d7 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -525,7 +525,6 @@ static int ioctl_fsfreeze(struct file *filp)
 	if (sb->s_op->freeze_fs == NULL)
 		return -EOPNOTSUPP;
 
-	/* Freeze */
 	return freeze_super(sb);
 }
 
@@ -536,7 +535,6 @@ static int ioctl_fsthaw(struct file *filp)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	/* Thaw */
 	return thaw_super(sb);
 }
 
diff --git a/fs/super.c b/fs/super.c
index 5c35bc7..69ac4fb 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -95,6 +95,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		s->s_maxbytes = MAX_NON_LFS;
 		s->s_op = &default_op;
 		s->s_time_gran = 1000000000;
+		mutex_init(&s->s_freeze_mutex);
 	}
 out:
 	return s;
@@ -744,19 +745,7 @@ int get_sb_bdev(struct file_system_type *fs_type,
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
-	/*
-	 * once the super is inserted into the list by sget, s_umount
-	 * will protect the lockfs code from trying to start a snapshot
-	 * while we are mounting
-	 */
-	mutex_lock(&bdev->bd_fsfreeze_mutex);
-	if (bdev->bd_fsfreeze_count > 0) {
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
-		error = -EBUSY;
-		goto error_bdev;
-	}
 	s = sget(fs_type, test_bdev_super, set_bdev_super, bdev);
-	mutex_unlock(&bdev->bd_fsfreeze_mutex);
 	if (IS_ERR(s))
 		goto error_s;
 
@@ -940,26 +929,33 @@ EXPORT_SYMBOL_GPL(vfs_kern_mount);
  * freeze_super - lock the filesystem and force it into a consistent state
  * @sb: the super to lock
  *
+
  * Syncs the super to make sure the filesystem is consistent and calls the fs's
- * freeze_fs.  Subsequent calls to this without first thawing the fs will return
- * -EBUSY.
+ * freeze_fs.  The reference counter (s_freeze_count) guarantees that only the
+ * last unfreeze process can unfreeze the frozen filesystem actually when
+ * multiple freeze requests arrive simultaneously. It counts up in
+ * freeze_super() and count down in thaw_super(). When it becomes 0,
+ * thaw_super() will execute the unfreeze.
  */
 int freeze_super(struct super_block *sb)
 {
-	int ret;
+	int error = 0;
 
 	atomic_inc(&sb->s_active);
 	down_write(&sb->s_umount);
+	mutex_lock(&sb->s_freeze_mutex);
+	if (++sb->s_freeze_count > 1)
+		goto out_deactivate;
+
 	if (sb->s_frozen) {
-		deactivate_locked_super(sb);
-		return -EBUSY;
+		error = -EBUSY;
+		goto out_deactivate;
 	}
 
 	if (sb->s_flags & MS_RDONLY) {
 		sb->s_frozen = SB_FREEZE_TRANS;
 		smp_wmb();
-		up_write(&sb->s_umount);
-		return 0;
+		goto out_active;
 	}
 
 	sb->s_frozen = SB_FREEZE_WRITE;
@@ -972,60 +968,150 @@ int freeze_super(struct super_block *sb)
 
 	sync_blockdev(sb->s_bdev);
 	if (sb->s_op->freeze_fs) {
-		ret = sb->s_op->freeze_fs(sb);
-		if (ret) {
+		error = sb->s_op->freeze_fs(sb);
+		if (error) {
 			printk(KERN_ERR
 				"VFS:Filesystem freeze failed\n");
 			sb->s_frozen = SB_UNFROZEN;
-			deactivate_locked_super(sb);
-			return ret;
+			goto out_deactivate;
 		}
 	}
+out_active:
 	up_write(&sb->s_umount);
-	return 0;
+	sync_blockdev(sb->s_bdev);
+out_unlock:
+	mutex_unlock(&sb->s_freeze_mutex);
+	return error;
+
+out_deactivate:
+	deactivate_locked_super(sb);
+	goto out_unlock;
+
 }
 EXPORT_SYMBOL(freeze_super);
 
 /**
- * thaw_super -- unlock filesystem
+ * __thaw_super -- unlock filesystem
  * @sb: the super to thaw
+ * @emergency: override the nesting count and unfreeze immediately if set
  *
  * Unlocks the filesystem and marks it writeable again after freeze_super().
+ * Caller must already hold sb->s_umount. Return -EINVAL if @sb is not frozen,
+ * 0 if the unfreeze was executed and succeeded or the error if it failed. If
+ * the unfreeze fails, then leave @sb in the frozen state.
  */
-int thaw_super(struct super_block *sb)
+static int __thaw_super(struct super_block *sb, int emergency)
 {
-	int error;
+	int error = -EINVAL;
 
-	down_write(&sb->s_umount);
-	if (sb->s_frozen == SB_UNFROZEN) {
-		up_write(&sb->s_umount);
-		return -EINVAL;
+	if (!emergency) {
+		down_write(&sb->s_umount);
+		mutex_lock(&sb->s_freeze_mutex);
+		if (!sb->s_freeze_count)
+			goto out;
+
+		if (--sb->s_freeze_count > 0) {
+			error = 0;
+			goto out;
+		}
+	} else {
+		/* already under down_read(&sb->s_umount) */
+		mutex_lock(&sb->s_freeze_mutex);
 	}
 
-	if (sb->s_flags & MS_RDONLY)
+	if (sb->s_frozen == SB_UNFROZEN)
 		goto out;
 
+	if (sb->s_flags & MS_RDONLY)
+		goto out_unfreeze;
+
 	if (sb->s_op->unfreeze_fs) {
 		error = sb->s_op->unfreeze_fs(sb);
 		if (error) {
 			printk(KERN_ERR
 				"VFS:Filesystem thaw failed\n");
 			sb->s_frozen = SB_FREEZE_TRANS;
-			up_write(&sb->s_umount);
-			return error;
+			goto out;
 		}
 	}
 
-out:
+out_unfreeze:
 	sb->s_frozen = SB_UNFROZEN;
 	smp_wmb();
 	wake_up(&sb->s_wait_unfrozen);
-	deactivate_locked_super(sb);
-
+	mutex_unlock(&sb->s_freeze_mutex);
+	/*
+	 * When called from emergency scope, we cannot grab the s_umount lock
+	 * so we cannot deactivate the superblock. This would leave unbalanced
+	 * superblock references which could prevent unmount, so we leave the
+	 * s_freeze_count alone on an emergency thaw so that the references can
+	 * be dropped by subsequent thaw_super() calls..
+	 */
+	if (!emergency)
+		deactivate_locked_super(sb);
 	return 0;
+
+out:
+	if (error && error != -EINVAL)
+		sb->s_freeze_count++;
+	mutex_unlock(&sb->s_freeze_mutex);
+	if (!emergency)
+		up_write(&sb->s_umount);
+	return error;
+}
+
+/**
+ * thaw_super -- unlock filesystem
+ * @sb: the super to thaw
+ *
+ * Unlocks the filesystem and marks it writeable again after freeze_super().
+ */
+int thaw_super(struct super_block *sb)
+{
+	return __thaw_super(sb, 0);
 }
 EXPORT_SYMBOL(thaw_super);
 
+/**
+ * thaw_super_emergency  -- unlock filesystem
+ * @bdev:	blockdevice to unlock
+ * @sb:		associated superblock
+ *
+ * Unlocks the filesystem and marks it writeable again after freeze_super().
+ * This overrides any nested freezes and unconditionally thaws the superblock.
+ */
+static void thaw_super_emergency(struct super_block *sb, void *unused)
+{
+	char b[BDEVNAME_SIZE] = { 0 };
+
+	printk(KERN_WARNING "Emergency Thaw on %s.\n",
+				sb->s_bdev ? bdevname(sb->s_bdev, b) : b);
+	while (!__thaw_super(sb, 1));
+}
+
+static void do_thaw_all(struct work_struct *work)
+{
+	iterate_supers(thaw_super_emergency, NULL);
+	kfree(work);
+	printk(KERN_WARNING "Emergency Thaw complete\n");
+}
+
+/**
+ * emergency_thaw_all -- forcibly thaw every frozen filesystem
+ *
+ * Used for emergency unfreeze of all filesystems via SysRq
+ */
+void emergency_thaw_all(void)
+{
+	struct work_struct *work;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (work) {
+		INIT_WORK(work, do_thaw_all);
+		schedule_work(work);
+	}
+}
+
 static struct vfsmount *fs_set_subtype(struct vfsmount *mnt, const char *fstype)
 {
 	int err;
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 37a6f62..8862e41 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -643,11 +643,11 @@ xfs_fs_goingdown(
 {
 	switch (inflags) {
 	case XFS_FSOP_GOING_FLAGS_DEFAULT: {
-		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
+		int error = freeze_super(mp->m_super);
 
-		if (sb && !IS_ERR(sb)) {
+		if (error) {
 			xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
-			thaw_bdev(sb->s_bdev, sb);
+			thaw_super(mp->m_super);
 		}
 
 		break;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 471e1ff..7972afe 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -672,11 +672,6 @@ struct block_device {
 	 * care to not mess up bd_private for that case.
 	 */
 	unsigned long		bd_private;
-
-	/* The counter of freeze processes */
-	int			bd_fsfreeze_count;
-	/* Mutex for freeze */
-	struct mutex		bd_fsfreeze_mutex;
 };
 
 /*
@@ -1382,6 +1377,9 @@ struct super_block {
 	 * generic_show_options()
 	 */
 	char *s_options;
+
+	int			s_freeze_count;	/* nr of nested freezes */
+	struct mutex		s_freeze_mutex; /* nested freeze lock */
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
@@ -1950,24 +1948,13 @@ extern void bdput(struct block_device *);
 extern struct block_device *open_by_devnum(dev_t, fmode_t);
 extern void invalidate_bdev(struct block_device *);
 extern int sync_blockdev(struct block_device *bdev);
-extern struct super_block *freeze_bdev(struct block_device *);
 extern void emergency_thaw_all(void);
-extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
 extern int fsync_bdev(struct block_device *);
 #else
 static inline void bd_forget(struct inode *inode) {}
 static inline int sync_blockdev(struct block_device *bdev) { return 0; }
 static inline void invalidate_bdev(struct block_device *bdev) {}
 
-static inline struct super_block *freeze_bdev(struct block_device *sb)
-{
-	return NULL;
-}
-
-static inline int thaw_bdev(struct block_device *bdev, struct super_block *sb)
-{
-	return 0;
-}
 #endif
 extern int sync_filesystem(struct super_block *);
 extern const struct file_operations def_blk_fops;
