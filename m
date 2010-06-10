Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab0FJHUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 03:20:49 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:45734 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758106Ab0FJHUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 03:20:44 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, josef@redhat.com,
       jeffmerkey@gmail.com
Subject: [PATCH 3/5] fsfreeze: freeze_super and thaw_bdev don't play well together
Date: Thu, 10 Jun 2010 17:19:52 +1000
Message-Id: <1276154395-24766-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276154395-24766-1-git-send-email-david@fromorbit.com>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

thaw_bdev() has re-enterency guards to allow freezes to nest
together. That is, it ensures that the filesystem is not thawed
until the last thaw command is issued. This is needed to prevent the
filesystem from being unfrozen while an existing freezer is still
operating on the filesystem in a frozen state (e.g. dm-snapshot).

Currently, freeze_super() and thaw_super() bypasses these guards,
and as a result manual freezing and unfreezing via the ioctl methods
do not nest correctly. hence mixing userspace directed freezes with
block device level freezes result in inconsistency due to premature
thawing of the filesystem.

Move the re-enterency guards to the superblock and into freeze_super
and thaw_super() so that userspace directed freezes nest correctly
again.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/block_dev.c       |   59 ++++----------------------------------
 fs/gfs2/ops_fstype.c |   12 --------
 fs/super.c           |   77 ++++++++++++++++++++++++++++++-------------------
 include/linux/fs.h   |    8 ++---
 4 files changed, 56 insertions(+), 100 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index a8c8224..84899b3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -230,71 +230,22 @@ struct super_block *freeze_bdev(struct block_device *bdev)
 	struct super_block *sb;
 	int error = 0;
 
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
 	sb = get_active_super(bdev);
 	if (!sb)
 		goto out;
 	error = freeze_super(sb);
 	if (error) {
 		deactivate_super(sb);
-		bdev->bd_fsfreeze_count--;
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
 		return ERR_PTR(error);
 	}
 	deactivate_super(sb);
  out:
 	sync_blockdev(bdev);
-	mutex_unlock(&bdev->bd_fsfreeze_mutex);
 	return sb;	/* thaw_bdev releases s->s_umount */
 }
 EXPORT_SYMBOL(freeze_bdev);
 
 /**
- * __thaw_bdev  -- unlock filesystem
- * @bdev:	blockdevice to unlock
- * @sb:		associated superblock
- * @emergency:	emergency thaw
- *
- * Unlocks the filesystem and marks it writeable again after freeze_bdev().
- */
-static int __thaw_bdev(struct block_device *bdev, struct super_block *sb, int emergency)
-{
-	int error = -EINVAL;
-
-	mutex_lock(&bdev->bd_fsfreeze_mutex);
-	if (!bdev->bd_fsfreeze_count)
-		goto out;
-
-	if (!sb)
-		goto out;
-
-	error = 0;
-	if (--bdev->bd_fsfreeze_count > 0)
-		goto out;
-
-	if (emergency)
-		error = thaw_super_emergency(sb);
-	else
-		error = thaw_super(sb);
-	if (error)
-		bdev->bd_fsfreeze_count++;
-out:
-	mutex_unlock(&bdev->bd_fsfreeze_mutex);
-	return error;
-}
-/**
  * thaw_bdev  -- unlock filesystem
  * @bdev:	blockdevice to unlock
  * @sb:		associated superblock
@@ -303,13 +254,17 @@ out:
  */
 int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
-	return __thaw_bdev(bdev, sb, 0);
+	if (!sb)
+		return -EINVAL;
+	return thaw_super(sb);
 }
 EXPORT_SYMBOL(thaw_bdev);
 
 int thaw_bdev_emergency(struct block_device *bdev, struct super_block *sb)
 {
-	return __thaw_bdev(bdev, sb, 1);
+	if (!sb)
+		return -EINVAL;
+	return thaw_super_emergency(sb);
 }
 
 static int blkdev_writepage(struct page *page, struct writeback_control *wbc)
@@ -434,8 +389,6 @@ static void init_once(void *foo)
 	INIT_LIST_HEAD(&bdev->bd_holder_list);
 #endif
 	inode_init_once(&ei->vfs_inode);
-	/* Initialize mutex for freeze. */
-	mutex_init(&bdev->bd_fsfreeze_mutex);
 }
 
 static inline void __bd_forget(struct inode *inode)
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
diff --git a/fs/super.c b/fs/super.c
index 76ed922..5f13431 100644
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
 
@@ -941,25 +930,31 @@ EXPORT_SYMBOL_GPL(vfs_kern_mount);
  * @sb: the super to lock
  *
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
+	int ret = 0;
 
 	atomic_inc(&sb->s_active);
 	down_write(&sb->s_umount);
+	mutex_lock(&sb->s_freeze_mutex);
+	if (++sb->s_freeze_count > 1)
+		goto out_deactivate;
+
 	if (sb->s_frozen) {
-		deactivate_locked_super(sb);
-		return -EBUSY;
+		ret = -EBUSY;
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
@@ -977,12 +972,18 @@ int freeze_super(struct super_block *sb)
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
+out_unlock:
+	mutex_unlock(&sb->s_freeze_mutex);
+	return ret;
+
+out_deactivate:
+	deactivate_locked_super(sb);
+	goto out_unlock;
 }
 EXPORT_SYMBOL(freeze_super);
 
@@ -993,22 +994,34 @@ EXPORT_SYMBOL(freeze_super);
  *
  * Unlocks the filesystem and marks it writeable again after freeze_super().
  * If we are doing an emergency thaw, we don't need to grab the sb->s_umount
- * lock as it is already held.
+ * lock as it is already held.  Return -EINVAL if @sb is not frozen, 0 if the
+ * unfreeze was executed and succeeded or the error if it failed. If the
+ * unfreeze fails, then leave @sb in the frozen state.
  */
 static int __thaw_super(struct super_block *sb, int emergency)
 {
-	int error = 0;
+	int error = -EINVAL;
 
-	if (!emergency)
+	if (!emergency) {
 		down_write(&sb->s_umount);
+		mutex_lock(&sb->s_freeze_mutex);
+		if (!sb->s_freeze_count)
+			goto out_unlock;
 
-	if (sb->s_frozen == SB_UNFROZEN) {
-		error = -EINVAL;
-		goto out_unlock;
+		if (--sb->s_freeze_count > 0) {
+			error = 0;
+			goto out_unlock;
+		}
+	} else {
+		/* already under down_read(&sb->s_umount) */
+		mutex_lock(&sb->s_freeze_mutex);
 	}
 
+	if (sb->s_frozen == SB_UNFROZEN)
+		goto out_unlock;
+
 	if (sb->s_flags & MS_RDONLY)
-		goto out;
+		goto out_unfreeze;
 
 	if (sb->s_op->unfreeze_fs) {
 		error = sb->s_op->unfreeze_fs(sb);
@@ -1020,10 +1033,11 @@ static int __thaw_super(struct super_block *sb, int emergency)
 		}
 	}
 
-out:
+out_unfreeze:
 	sb->s_frozen = SB_UNFROZEN;
 	smp_wmb();
 	wake_up(&sb->s_wait_unfrozen);
+	mutex_unlock(&sb->s_freeze_mutex);
 	/*
 	 * When called from emergency scope, we cannot grab the s_umount lock
 	 * so we cannot deactivate the superblock. This may leave unbalanced
@@ -1035,6 +1049,9 @@ out:
 	return 0;
 
 out_unlock:
+	if (error && error != -EINVAL)
+		sb->s_freeze_count++;
+	mutex_unlock(&sb->s_freeze_mutex);
 	if (!emergency)
 		up_write(&sb->s_umount);
 	return error;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e246389..f92b077 100644
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
+	struct mutex		s_freeze_mutex;	/* nesting lock */
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
-- 
1.7.1

