Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab0FGV7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:59:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab0FGV7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:59:31 -0400
Date: Mon, 7 Jun 2010 17:59:25 -0400
From: Josef Bacik <josef@redhat.com>
To: Josef Bacik <josef@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Jeffrey Merkey <jeffmerkey@gmail.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: 2.6.34 echo j > /proc/sysrq-trigger causes inifnite
	unfreeze/Thaw event
Message-ID: <20100607215925.GF2336@localhost.localdomain>
References: <AANLkTim74SREZDq7VQhq6Z1hKXZLINoq0t8rkyQecmM1@mail.gmail.com> <20100607010542.GB27325@dastard> <20100607213631.GE2336@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100607213631.GE2336@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 05:36:31PM -0400, Josef Bacik wrote:
> On Mon, Jun 07, 2010 at 11:05:42AM +1000, Dave Chinner wrote:
> > On Thu, Jun 03, 2010 at 11:30:30PM -0600, Jeffrey Merkey wrote:
> > > causes the FS Thaw stuff in fs/buffer.c to enter an infinite loop
> > > filling the /var/log/messages with junk and causing the hard drive to
> > > crank away endlessly.
> > 
> > Hmmm, looks pretty obvious what the 2.6.34 bug is:
> > 
> >         while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
> >                 printk(KERN_WARNING "Emergency Thaw on %s\n",
> >                        bdevname(sb->s_bdev, b));
> > 
> > thaw_bdev() returns 0 on success or not frozen, and returns non-zero
> > only if the unfreeze failed. Looks like it was broken from the start
> > to me.
> > 
> > Fixing that endless loop shows some other problems on 2.6.35,
> > though: the emergency unfreeze is not unfreezing frozen XFS
> > filesystems.  This appears to be caused by
> > 18e9e5104fcd9a973ffe3eed3816c87f2a1b6cd2 ("Introduce freeze_super
> > and thaw_super for the fsfreeze ioctl").
> > 
> > It appears that this introduces a significant mismatch between the
> > bdev freeze/thaw and the super freze/thaw. That is, if you freeze
> > with the sb method, you can only unfreeze via the sb method.
> > however, if you freeze via the bdev method, you can unfreeze by
> > either the bdev or sb method.  This breaks the nesting of the
> > freeze/thaw operations between dm and userspace, which can lead to
> > premature thawing of the filesystem.
> > 
> > Then there is this deadlock:
> > 
> > iterate_supers(do_thaw_one) does:
> > 
> > 	down_read(&sb->s_umount);
> > 	do_thaw_one(sb)
> > 	  thaw_bdev(sb->s_bdev, sb))
> > 	    thaw_super(sb)
> > 	      down_write(&sb->s_umount);
> > 
> > Which is an instant deadlock.
> > 
> > These problems were hidden by the fact that the emergency thaw code
> > was not getting past the thaw_bdev guards and so not triggering
> > this deadlock.
> > 
> > Al, Josef, what's the best way to fix this mess?
> > 
> 
> Well we can do something like the following
> 
> 1) Make a __thaw_super() that just does all the work currently in thaw_super(),
> just without taking the s_umount semaphore.
> 2) Make an thaw_bdev_force or something like that that just sets
> bd_fsfreeze_count to 0 and calls __thaw_super().  The original intent was to
> make us call thaw until the thaw actually occured, so might as well just make it
> quick and painless.
> 3) Make do_thaw_one() call __thaw_super if sb->s_bdev doesn't exist.  I'm not
> sure if this happens currently, but it's nice just in case.
> 
> This takes care of the s_umount problem and makes sure that do_thaw_one does
> actually thaw the device.  Does this sound kosher to everybody?  Thanks,
> 

Ok here is my half-assed 15 minute fix.  I've not even compile tested it, but it
should get the general idea of what I'm talking about across.  Comments?
Complaints?  Flames?  Thanks,

Josef

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7346c96..086361c 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -272,6 +272,10 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
 	int error = -EINVAL;
 
+	if (!sb)
+		return error;
+
+	down_write(&sb->s_umount);
 	mutex_lock(&bdev->bd_fsfreeze_mutex);
 	if (!bdev->bd_fsfreeze_count)
 		goto out;
@@ -280,21 +284,47 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 	if (--bdev->bd_fsfreeze_count > 0)
 		goto out;
 
-	if (!sb)
-		goto out;
-
-	error = thaw_super(sb);
-	if (error) {
+	error = __thaw_super(sb);
+	if (error && error != -EINVAL)
 		bdev->bd_fsfreeze_count++;
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
-		return error;
-	}
+	else if (error == -EINVAL)
+		error = 0;
 out:
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
-	return 0;
+	up_write(&sb->s_umount);
+
+	return error;
 }
 EXPORT_SYMBOL(thaw_bdev);
 
+/**
+ * thaw_bdev_emergency	-- unlock a filesystem regardless of its freeze count
+ * @bdev:		blockdevice to unlock
+ * @sb:			associated superblock
+ *
+ * Unlocks the filesystem and marks it writeable again regardless of the freeze
+ * count.  Caller must down_write(&sb->s_umount).
+ */
+int thaw_bdev_emergency(struct block_device *bdev, struct super_block *sb)
+{
+	int error = -EINVAL;
+
+	if (!sb)
+		return error;
+
+	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	bdev->bd_fsfreeze_count = 0;
+	error = __thaw_super(sb);
+	if (error && error != -EINVAL)
+		bdev->bd_fsfreeze_count = 1;
+	else if (error == -EINVAL)
+		error = 0;
+	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+
+	return error;
+}
+EXPORT_SYMBOL(thaw_bdev_emergency);
+
 static int blkdev_writepage(struct page *page, struct writeback_control *wbc)
 {
 	return block_write_full_page(page, blkdev_get_block, wbc);
diff --git a/fs/buffer.c b/fs/buffer.c
index d54812b..62d97c6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -564,9 +564,19 @@ repeat:
 static void do_thaw_one(struct super_block *sb, void *unused)
 {
 	char b[BDEVNAME_SIZE];
-	while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
+
+	while (sb->s_bdev && !thaw_bdev_emergency(sb->s_bdev, sb))
 		printk(KERN_WARNING "Emergency Thaw on %s\n",
 		       bdevname(sb->s_bdev, b));
+	if (!sb->s_bdev) {
+		while (1) {
+			int ret;
+
+			ret = __thaw_super(sb);
+			if (!ret || ret == -EINVAL)
+				break;
+		}
+	}
 }
 
 static void do_thaw_all(struct work_struct *work)
diff --git a/fs/super.c b/fs/super.c
index 5c35bc7..5dee40b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -987,20 +987,18 @@ int freeze_super(struct super_block *sb)
 EXPORT_SYMBOL(freeze_super);
 
 /**
- * thaw_super -- unlock filesystem
+ * __thaw_super -- unlock filesystem
  * @sb: the super to thaw
  *
  * Unlocks the filesystem and marks it writeable again after freeze_super().
+ * Caller must down_write(&sb->s_umount).
  */
-int thaw_super(struct super_block *sb)
+int __thaw_super(struct super_block *sb)
 {
 	int error;
 
-	down_write(&sb->s_umount);
-	if (sb->s_frozen == SB_UNFROZEN) {
-		up_write(&sb->s_umount);
+	if (sb->s_frozen == SB_UNFROZEN)
 		return -EINVAL;
-	}
 
 	if (sb->s_flags & MS_RDONLY)
 		goto out;
@@ -1011,7 +1009,6 @@ int thaw_super(struct super_block *sb)
 			printk(KERN_ERR
 				"VFS:Filesystem thaw failed\n");
 			sb->s_frozen = SB_FREEZE_TRANS;
-			up_write(&sb->s_umount);
 			return error;
 		}
 	}
@@ -1020,10 +1017,28 @@ out:
 	sb->s_frozen = SB_UNFROZEN;
 	smp_wmb();
 	wake_up(&sb->s_wait_unfrozen);
-	deactivate_locked_super(sb);
+	deactivate_super(sb);
 
 	return 0;
 }
+EXPORT_SYMBOL(__thaw_super);
+
+/**
+ * thaw_super -- unlock filesystem
+ * @sb: the super to thaw
+ *
+ * Unlocks the filesystem and marks it writeable again after freeze_super().
+ */
+int thaw_super(struct super_block *sb)
+{
+	int error;
+
+	down_write(&sb->s_umount);
+	error = __thaw_super(sb);
+	up_write(&sb->s_umount);
+
+	return error;
+}
 EXPORT_SYMBOL(thaw_super);
 
 static struct vfsmount *fs_set_subtype(struct vfsmount *mnt, const char *fstype)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 471e1ff..6dd6d4f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1803,6 +1803,7 @@ extern int iterate_mounts(int (*)(struct vfsmount *, void *), void *,
 extern int vfs_statfs(struct dentry *, struct kstatfs *);
 extern int freeze_super(struct super_block *super);
 extern int thaw_super(struct super_block *super);
+extern int __thaw_super(struct super_block *super);
 
 extern int current_umask(void);
 
@@ -1953,6 +1954,7 @@ extern int sync_blockdev(struct block_device *bdev);
 extern struct super_block *freeze_bdev(struct block_device *);
 extern void emergency_thaw_all(void);
 extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
+int thaw_bdev_emergency(struct block_device *bdev, struct super_block *sb);
 extern int fsync_bdev(struct block_device *);
 #else
 static inline void bd_forget(struct inode *inode) {}
@@ -1968,6 +1970,12 @@ static inline int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
 	return 0;
 }
+
+static inline int thaw_bdev_emergency(struct block_device *bdev,
+				      struct super_block *sb)
+{
+	return 0;
+}
 #endif
 extern int sync_filesystem(struct super_block *);
 extern const struct file_operations def_blk_fops;
