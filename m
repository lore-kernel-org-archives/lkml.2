Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab0FJHVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 03:21:14 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:47440 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758606Ab0FJHU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 03:20:56 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, josef@redhat.com,
       jeffmerkey@gmail.com
Subject: [PATCH 2/5] fsfreeze: emergency thaw will deadlock on s_umount
Date: Thu, 10 Jun 2010 17:19:51 +1000
Message-Id: <1276154395-24766-3-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276154395-24766-1-git-send-email-david@fromorbit.com>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The emergency thaw process uses iterate_super() which holds the
sb->s_umount lock in read mode. The current thaw_super() code takes
the sb->s_umount lock in write mode, hence leading to an instant
deadlock.

Pass the emergency state into the thaw_bdev/thaw_super code to avoid
taking the s_umount lock in this case. We are running under the bdev
freeze mutex, so this is still serialised against freeze despite
only having a read lock on the sb->s_umount. Hence it should be safe
to execute in this manner, especially given that emergency thaw is a
rarely executed "get-out-of-jail" feature.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/block_dev.c     |   26 ++++++++++++++++++++--
 fs/buffer.c        |    2 +-
 fs/super.c         |   58 +++++++++++++++++++++++++++++++++++++++++++---------
 include/linux/fs.h |    9 ++++++++
 4 files changed, 81 insertions(+), 14 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 366ac38..a8c8224 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -262,13 +262,14 @@ struct super_block *freeze_bdev(struct block_device *bdev)
 EXPORT_SYMBOL(freeze_bdev);
 
 /**
- * thaw_bdev  -- unlock filesystem
+ * __thaw_bdev  -- unlock filesystem
  * @bdev:	blockdevice to unlock
  * @sb:		associated superblock
+ * @emergency:	emergency thaw
  *
  * Unlocks the filesystem and marks it writeable again after freeze_bdev().
  */
-int thaw_bdev(struct block_device *bdev, struct super_block *sb)
+static int __thaw_bdev(struct block_device *bdev, struct super_block *sb, int emergency)
 {
 	int error = -EINVAL;
 
@@ -283,15 +284,34 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 	if (--bdev->bd_fsfreeze_count > 0)
 		goto out;
 
-	error = thaw_super(sb);
+	if (emergency)
+		error = thaw_super_emergency(sb);
+	else
+		error = thaw_super(sb);
 	if (error)
 		bdev->bd_fsfreeze_count++;
 out:
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
 	return error;
 }
+/**
+ * thaw_bdev  -- unlock filesystem
+ * @bdev:	blockdevice to unlock
+ * @sb:		associated superblock
+ *
+ * Unlocks the filesystem and marks it writeable again after freeze_bdev().
+ */
+int thaw_bdev(struct block_device *bdev, struct super_block *sb)
+{
+	return __thaw_bdev(bdev, sb, 0);
+}
 EXPORT_SYMBOL(thaw_bdev);
 
+int thaw_bdev_emergency(struct block_device *bdev, struct super_block *sb)
+{
+	return __thaw_bdev(bdev, sb, 1);
+}
+
 static int blkdev_writepage(struct page *page, struct writeback_control *wbc)
 {
 	return block_write_full_page(page, blkdev_get_block, wbc);
diff --git a/fs/buffer.c b/fs/buffer.c
index d54812b..f0c55d9 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -564,7 +564,7 @@ repeat:
 static void do_thaw_one(struct super_block *sb, void *unused)
 {
 	char b[BDEVNAME_SIZE];
-	while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
+	while (sb->s_bdev && !thaw_bdev_emergency(sb->s_bdev, sb))
 		printk(KERN_WARNING "Emergency Thaw on %s\n",
 		       bdevname(sb->s_bdev, b));
 }
diff --git a/fs/super.c b/fs/super.c
index 5c35bc7..76ed922 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -987,19 +987,24 @@ int freeze_super(struct super_block *sb)
 EXPORT_SYMBOL(freeze_super);
 
 /**
- * thaw_super -- unlock filesystem
+ * __thaw_super -- unlock filesystem
  * @sb: the super to thaw
+ * @emergency:	emergency thaw
  *
  * Unlocks the filesystem and marks it writeable again after freeze_super().
+ * If we are doing an emergency thaw, we don't need to grab the sb->s_umount
+ * lock as it is already held.
  */
-int thaw_super(struct super_block *sb)
+static int __thaw_super(struct super_block *sb, int emergency)
 {
-	int error;
+	int error = 0;
+
+	if (!emergency)
+		down_write(&sb->s_umount);
 
-	down_write(&sb->s_umount);
 	if (sb->s_frozen == SB_UNFROZEN) {
-		up_write(&sb->s_umount);
-		return -EINVAL;
+		error = -EINVAL;
+		goto out_unlock;
 	}
 
 	if (sb->s_flags & MS_RDONLY)
@@ -1011,8 +1016,7 @@ int thaw_super(struct super_block *sb)
 			printk(KERN_ERR
 				"VFS:Filesystem thaw failed\n");
 			sb->s_frozen = SB_FREEZE_TRANS;
-			up_write(&sb->s_umount);
-			return error;
+			goto out_unlock;
 		}
 	}
 
@@ -1020,12 +1024,46 @@ out:
 	sb->s_frozen = SB_UNFROZEN;
 	smp_wmb();
 	wake_up(&sb->s_wait_unfrozen);
-	deactivate_locked_super(sb);
-
+	/*
+	 * When called from emergency scope, we cannot grab the s_umount lock
+	 * so we cannot deactivate the superblock. This may leave unbalanced
+	 * superblock references which could prevent unmount, but given this is
+	 * an emergency operation....
+	 */
+	if (!emergency)
+		deactivate_locked_super(sb);
 	return 0;
+
+out_unlock:
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
+ * @sb: the super to thaw
+ *
+ * Unlocks the filesystem and marks it writeable again after freeze_super().
+ * This avoids taking the s_umount lock if it is already held.
+ */
+int thaw_super_emergency(struct super_block *sb)
+{
+	return __thaw_super(sb, 1);
+}
+
 static struct vfsmount *fs_set_subtype(struct vfsmount *mnt, const char *fstype)
 {
 	int err;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 471e1ff..e246389 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1803,6 +1803,7 @@ extern int iterate_mounts(int (*)(struct vfsmount *, void *), void *,
 extern int vfs_statfs(struct dentry *, struct kstatfs *);
 extern int freeze_super(struct super_block *super);
 extern int thaw_super(struct super_block *super);
+extern int thaw_super_emergency(struct super_block *super);
 
 extern int current_umask(void);
 
@@ -1953,6 +1954,8 @@ extern int sync_blockdev(struct block_device *bdev);
 extern struct super_block *freeze_bdev(struct block_device *);
 extern void emergency_thaw_all(void);
 extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
+extern int thaw_bdev_emergency(struct block_device *bdev,
+				struct super_block *sb);
 extern int fsync_bdev(struct block_device *);
 #else
 static inline void bd_forget(struct inode *inode) {}
@@ -1968,6 +1971,12 @@ static inline int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
 	return 0;
 }
+
+static inline int thaw_bdev_emergency(struct block_device *bdev,
+					struct super_block *sb)
+{
+	return 0;
+}
 #endif
 extern int sync_filesystem(struct super_block *);
 extern const struct file_operations def_blk_fops;
-- 
1.7.1

