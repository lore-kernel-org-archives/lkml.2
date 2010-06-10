Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab0FJHVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 03:21:45 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:54573 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752670Ab0FJHUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 03:20:39 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, josef@redhat.com,
       jeffmerkey@gmail.com
Subject: [PATCH 4/5] fsfreeze: switch to using super methods everywhere
Date: Thu, 10 Jun 2010 17:19:53 +1000
Message-Id: <1276154395-24766-5-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276154395-24766-1-git-send-email-david@fromorbit.com>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

freeze/thaw_bdev are now just trivial wrappers around
freeze/thaw_super(). Convert all users of the bdev interfaces to use
the superblock interfaces instead, and remove the bdev interfaces.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 drivers/md/dm.c    |   13 +++++++----
 fs/block_dev.c     |   54 ----------------------------------------------------
 fs/buffer.c        |    2 +-
 fs/super.c         |    1 +
 fs/xfs/xfs_fsops.c |   10 ++------
 include/linux/fs.h |   19 ------------------
 6 files changed, 13 insertions(+), 86 deletions(-)

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
index 84899b3..3c3d1fe 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -213,60 +213,6 @@ int fsync_bdev(struct block_device *bdev)
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
-	sb = get_active_super(bdev);
-	if (!sb)
-		goto out;
-	error = freeze_super(sb);
-	if (error) {
-		deactivate_super(sb);
-		return ERR_PTR(error);
-	}
-	deactivate_super(sb);
- out:
-	sync_blockdev(bdev);
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
-	if (!sb)
-		return -EINVAL;
-	return thaw_super(sb);
-}
-EXPORT_SYMBOL(thaw_bdev);
-
-int thaw_bdev_emergency(struct block_device *bdev, struct super_block *sb)
-{
-	if (!sb)
-		return -EINVAL;
-	return thaw_super_emergency(sb);
-}
-
 static int blkdev_writepage(struct page *page, struct writeback_control *wbc)
 {
 	return block_write_full_page(page, blkdev_get_block, wbc);
diff --git a/fs/buffer.c b/fs/buffer.c
index f0c55d9..b095fc1 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -564,7 +564,7 @@ repeat:
 static void do_thaw_one(struct super_block *sb, void *unused)
 {
 	char b[BDEVNAME_SIZE];
-	while (sb->s_bdev && !thaw_bdev_emergency(sb->s_bdev, sb))
+	while (sb->s_bdev && !thaw_super_emergency(sb))
 		printk(KERN_WARNING "Emergency Thaw on %s\n",
 		       bdevname(sb->s_bdev, b));
 }
diff --git a/fs/super.c b/fs/super.c
index 5f13431..81a4034 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -976,6 +976,7 @@ int freeze_super(struct super_block *sb)
 		}
 	}
 out_active:
+	sync_blockdev(sb->s_bdev);
 	up_write(&sb->s_umount);
 out_unlock:
 	mutex_unlock(&sb->s_freeze_mutex);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 37a6f62..cc993a5 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -642,16 +642,12 @@ xfs_fs_goingdown(
 	__uint32_t	inflags)
 {
 	switch (inflags) {
-	case XFS_FSOP_GOING_FLAGS_DEFAULT: {
-		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
-
-		if (sb && !IS_ERR(sb)) {
+	case XFS_FSOP_GOING_FLAGS_DEFAULT:
+		if (!freeze_super(mp->m_super)) {
 			xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
-			thaw_bdev(sb->s_bdev, sb);
+			thaw_super(mp->m_super);
 		}
-
 		break;
-	}
 	case XFS_FSOP_GOING_FLAGS_LOGFLUSH:
 		xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
 		break;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f92b077..39bf4ac 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1951,30 +1951,11 @@ extern void invalidate_bdev(struct block_device *);
 extern int sync_blockdev(struct block_device *bdev);
 extern struct super_block *freeze_bdev(struct block_device *);
 extern void emergency_thaw_all(void);
-extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
-extern int thaw_bdev_emergency(struct block_device *bdev,
-				struct super_block *sb);
 extern int fsync_bdev(struct block_device *);
 #else
 static inline void bd_forget(struct inode *inode) {}
 static inline int sync_blockdev(struct block_device *bdev) { return 0; }
 static inline void invalidate_bdev(struct block_device *bdev) {}
-
-static inline struct super_block *freeze_bdev(struct block_device *sb)
-{
-	return NULL;
-}
-
-static inline int thaw_bdev(struct block_device *bdev, struct super_block *sb)
-{
-	return 0;
-}
-
-static inline int thaw_bdev_emergency(struct block_device *bdev,
-					struct super_block *sb)
-{
-	return 0;
-}
 #endif
 extern int sync_filesystem(struct super_block *);
 extern const struct file_operations def_blk_fops;
-- 
1.7.1

