Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab0KKRMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:12:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:49439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab0KKRMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:12:18 -0500
Message-ID: <4CDC23BB.10505@kernel.org>
Date: Thu, 11 Nov 2010 18:11:23 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org,
        petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
        aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com,
        chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com,
        joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp,
        reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk,
        philipp.reisner@linbit.com, snitzer@redhat.com
Subject: [PATCH 7/5] block: clean up blkdev_get() wrappers and their users
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
In-Reply-To: <1288628129-12811-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Nov 2010 17:11:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After recent blkdev_get() modifications, open_by_devnum() and
open_bdev_exclusive() are simple wrappers around blkdev_get().
Replace them with blkdev_get_by_dev() and blkdev_get_by_path().

blkdev_get_by_dev() is identical to open_by_devnum().
blkdev_get_by_path() is slightly different in that it doesn't
automatically add %FMODE_EXCL to @mode.

All users are converted.  Most conversions are mechanical and don't
introduce any behavior difference.  There are several exceptions.

* btrfs now sets FMODE_EXCL in btrfs_device->mode, so there's no
  reason to OR it explicitly on blkdev_put().

* gfs2, nilfs2 and the generic mount_bdev() now set FMODE_EXCL in
  sb->s_mode.

* With the above changes, sb->s_mode now always should contain
  FMODE_EXCL.  WARN_ON_ONCE() added to kill_block_super() to detect
  errors.

The new blkdev_get_*() functions are with proper docbook comments.
While at it, add function description to blkdev_get() too.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Joern Engel <joern@lazybastard.org>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Cc: reiserfs-devel@vger.kernel.org
Cc: xfs-masters@oss.sgi.com
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 drivers/block/drbd/drbd_nl.c    |   12 ++--
 drivers/md/dm-table.c           |    2 +-
 drivers/md/md.c                 |    4 +-
 drivers/mtd/devices/block2mtd.c |    5 +-
 fs/block_dev.c                  |  139 ++++++++++++++++++++++++++-------------
 fs/btrfs/volumes.c              |   24 ++++---
 fs/btrfs/volumes.h              |    2 +-
 fs/ext3/super.c                 |    2 +-
 fs/ext4/super.c                 |    2 +-
 fs/gfs2/ops_fstype.c            |    8 +-
 fs/jfs/jfs_logmgr.c             |    4 +-
 fs/logfs/dev_bdev.c             |    3 +-
 fs/nilfs2/super.c               |    8 +-
 fs/reiserfs/journal.c           |    6 +-
 fs/super.c                      |    9 ++-
 fs/xfs/linux-2.6/xfs_super.c    |    3 +-
 include/linux/fs.h              |    7 +-
 kernel/power/swap.c             |    4 +-
 18 files changed, 150 insertions(+), 94 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index fd03460..650e43b 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -902,8 +902,8 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 		}
 	}

-	bdev = open_bdev_exclusive(nbc->dc.backing_dev,
-				   FMODE_READ | FMODE_WRITE, mdev);
+	bdev = blkdev_get_by_path(nbc->dc.backing_dev,
+				  FMODE_READ | FMODE_WRITE | FMODE_EXCL, mdev);
 	if (IS_ERR(bdev)) {
 		dev_err(DEV, "open(\"%s\") failed with %ld\n", nbc->dc.backing_dev,
 			PTR_ERR(bdev));
@@ -920,10 +920,10 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	 * should check it for you already; but if you don't, or
 	 * someone fooled it, we need to double check here)
 	 */
-	bdev = open_bdev_exclusive(nbc->dc.meta_dev,
-				   FMODE_READ | FMODE_WRITE,
-				   (nbc->dc.meta_dev_idx < 0) ?
-				   (void *)mdev : (void *)drbd_m_holder);
+	bdev = blkdev_get_by_path(nbc->dc.meta_dev,
+				  FMODE_READ | FMODE_WRITE | FMODE_EXCL,
+				  (nbc->dc.meta_dev_idx < 0) ?
+				  (void *)mdev : (void *)drbd_m_holder);
 	if (IS_ERR(bdev)) {
 		dev_err(DEV, "open(\"%s\") failed with %ld\n", nbc->dc.meta_dev,
 			PTR_ERR(bdev));
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9e88ca0..67150c3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -325,7 +325,7 @@ static int open_dev(struct dm_dev_internal *d, dev_t dev,

 	BUG_ON(d->dm_dev.bdev);

-	bdev = open_by_devnum(dev, d->dm_dev.mode | FMODE_EXCL, _claim_ptr);
+	bdev = blkdev_get_by_dev(dev, d->dm_dev.mode | FMODE_EXCL, _claim_ptr);
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6af951f..5aaa6bf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1934,8 +1934,8 @@ static int lock_rdev(mdk_rdev_t *rdev, dev_t dev, int shared)
 	struct block_device *bdev;
 	char b[BDEVNAME_SIZE];

-	bdev = open_by_devnum(dev, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
-			      shared ? (mdk_rdev_t *)lock_rdev : rdev);
+	bdev = blkdev_get_by_dev(dev, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
+				 shared ? (mdk_rdev_t *)lock_rdev : rdev);
 	if (IS_ERR(bdev)) {
 		printk(KERN_ERR "md: could not open %s.\n",
 			__bdevname(dev, b));
diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index 84a4045..029cede 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -246,7 +246,8 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 		return NULL;

 	/* Get a handle on the device */
-	bdev = open_bdev_exclusive(devname, FMODE_READ|FMODE_WRITE, dev);
+	bdev = blkdev_get_by_path(devname,
+				  FMODE_READ|FMODE_WRITE|FMODE_EXCL, dev);
 #ifndef MODULE
 	if (IS_ERR(bdev)) {

@@ -255,7 +256,7 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)

 		dev_t devt = name_to_dev_t(devname);
 		if (devt)
-			bdev = open_by_devnum(devt,
+			bdev = blkdev_get_by_dev(devt,
 					FMODE_READ|FMODE_WRITE|FMODE_EXCL, dev);
 	}
 #endif
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 606a525..c1c1b8c 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -854,24 +854,6 @@ static inline void bd_unlink_disk_holder(struct block_device *bdev)
 { }
 #endif

-/*
- * Tries to open block device by device number.  Use it ONLY if you
- * really do not have anything better - i.e. when you are behind a
- * truly sucky interface and all you are given is a device number.  _Never_
- * to be used for internal purposes.  If you ever need it - reconsider
- * your API.
- */
-struct block_device *open_by_devnum(dev_t dev, fmode_t mode, void *holder)
-{
-	struct block_device *bdev = bdget(dev);
-	int err = -ENOMEM;
-	if (bdev)
-		err = blkdev_get(bdev, mode, holder);
-	return err ? ERR_PTR(err) : bdev;
-}
-
-EXPORT_SYMBOL(open_by_devnum);
-
 /**
  * flush_disk - invalidates all buffer-cache entries on a disk
  *
@@ -1132,6 +1114,25 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	return ret;
 }

+/**
+ * blkdev_get - open a block device
+ * @bdev: block_device to open
+ * @mode: FMODE_* mask
+ * @holder: exclusive holder identifier
+ *
+ * Open @bdev with @mode.  If @mode includes %FMODE_EXCL, @bdev is
+ * open with exclusive access.  Specifying %FMODE_EXCL with %NULL
+ * @holder is invalid.  Exclusive opens may nest for the same @holder.
+ *
+ * On success, the reference count of @bdev is unchanged.  On failure,
+ * @bdev is put.
+ *
+ * CONTEXT:
+ * Might sleep.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
 int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
 {
 	struct block_device *whole = NULL;
@@ -1186,6 +1187,80 @@ int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
 }
 EXPORT_SYMBOL(blkdev_get);

+/**
+ * blkdev_get_by_path - open a block device by name
+ * @path: path to the block device to open
+ * @mode: FMODE_* mask
+ * @holder: exclusive holder identifier
+ *
+ * Open the blockdevice described by the device file at @path.  @mode
+ * and @holder are identical to blkdev_get().
+ *
+ * On success, the returned block_device has reference count of one.
+ *
+ * CONTEXT:
+ * Might sleep.
+ *
+ * RETURNS:
+ * Pointer to block_device on success, ERR_PTR(-errno) on failure.
+ */
+struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
+					void *holder)
+{
+	struct block_device *bdev;
+	int err;
+
+	bdev = lookup_bdev(path);
+	if (IS_ERR(bdev))
+		return bdev;
+
+	err = blkdev_get(bdev, mode, holder);
+	if (err)
+		return ERR_PTR(err);
+
+	return bdev;
+}
+EXPORT_SYMBOL(blkdev_get_by_path);
+
+/**
+ * blkdev_get_by_dev - open a block device by device number
+ * @dev: device number of block device to open
+ * @mode: FMODE_* mask
+ * @holder: exclusive holder identifier
+ *
+ * Open the blockdevice described by device number @dev.  @mode and
+ * @holder are identical to blkdev_get().
+ *
+ * Use it ONLY if you really do not have anything better - i.e. when
+ * you are behind a truly sucky interface and all you are given is a
+ * device number.  _Never_ to be used for internal purposes.  If you
+ * ever need it - reconsider your API.
+ *
+ * On success, the returned block_device has reference count of one.
+ *
+ * CONTEXT:
+ * Might sleep.
+ *
+ * RETURNS:
+ * Pointer to block_device on success, ERR_PTR(-errno) on failure.
+ */
+struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder)
+{
+	struct block_device *bdev;
+	int err;
+
+	bdev = bdget(dev);
+	if (!bdev)
+		return ERR_PTR(-ENOMEM);
+
+	err = blkdev_get(bdev, mode, holder);
+	if (err)
+		return ERR_PTR(err);
+
+	return bdev;
+}
+EXPORT_SYMBOL(blkdev_get_by_dev);
+
 static int blkdev_open(struct inode * inode, struct file * filp)
 {
 	struct block_device *bdev;
@@ -1436,34 +1511,6 @@ fail:
 }
 EXPORT_SYMBOL(lookup_bdev);

-/**
- * open_bdev_exclusive  -  open a block device by name and set it up for use
- *
- * @path:	special file representing the block device
- * @mode:	FMODE_... combination to pass be used
- * @holder:	owner for exclusion
- *
- * Open the blockdevice described by the special file at @path, claim it
- * for the @holder.
- */
-struct block_device *open_bdev_exclusive(const char *path, fmode_t mode, void *holder)
-{
-	struct block_device *bdev;
-	int error;
-
-	bdev = lookup_bdev(path);
-	if (IS_ERR(bdev))
-		return bdev;
-
-	error = blkdev_get(bdev, mode | FMODE_EXCL, holder);
-	if (error)
-		return ERR_PTR(error);
-
-	return bdev;
-}
-
-EXPORT_SYMBOL(open_bdev_exclusive);
-
 int __invalidate_device(struct block_device *bdev)
 {
 	struct super_block *sb = get_super(bdev);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f1b729d..95324e9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -489,7 +489,7 @@ again:
 			continue;

 		if (device->bdev) {
-			blkdev_put(device->bdev, device->mode | FMODE_EXCL);
+			blkdev_put(device->bdev, device->mode);
 			device->bdev = NULL;
 			fs_devices->open_devices--;
 		}
@@ -523,7 +523,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)

 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		if (device->bdev) {
-			blkdev_put(device->bdev, device->mode | FMODE_EXCL);
+			blkdev_put(device->bdev, device->mode);
 			fs_devices->open_devices--;
 		}
 		if (device->writeable) {
@@ -580,13 +580,15 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	int seeding = 1;
 	int ret = 0;

+	flags |= FMODE_EXCL;
+
 	list_for_each_entry(device, head, dev_list) {
 		if (device->bdev)
 			continue;
 		if (!device->name)
 			continue;

-		bdev = open_bdev_exclusive(device->name, flags, holder);
+		bdev = blkdev_get_by_path(device->name, flags, holder);
 		if (IS_ERR(bdev)) {
 			printk(KERN_INFO "open %s failed\n", device->name);
 			goto error;
@@ -638,7 +640,7 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 error_brelse:
 		brelse(bh);
 error_close:
-		blkdev_put(bdev, flags | FMODE_EXCL);
+		blkdev_put(bdev, flags);
 error:
 		continue;
 	}
@@ -684,7 +686,8 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,

 	mutex_lock(&uuid_mutex);

-	bdev = open_bdev_exclusive(path, flags, holder);
+	flags |= FMODE_EXCL;
+	bdev = blkdev_get_by_path(path, flags, holder);

 	if (IS_ERR(bdev)) {
 		ret = PTR_ERR(bdev);
@@ -716,7 +719,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,

 	brelse(bh);
 error_close:
-	blkdev_put(bdev, flags | FMODE_EXCL);
+	blkdev_put(bdev, flags);
 error:
 	mutex_unlock(&uuid_mutex);
 	return ret;
@@ -1179,8 +1182,8 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 			goto out;
 		}
 	} else {
-		bdev = open_bdev_exclusive(device_path, FMODE_READ,
-				      root->fs_info->bdev_holder);
+		bdev = blkdev_get_by_path(device_path, FMODE_READ | FMODE_EXCL,
+					  root->fs_info->bdev_holder);
 		if (IS_ERR(bdev)) {
 			ret = PTR_ERR(bdev);
 			goto out;
@@ -1244,7 +1247,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		root->fs_info->fs_devices->latest_bdev = next_device->bdev;

 	if (device->bdev) {
-		blkdev_put(device->bdev, device->mode | FMODE_EXCL);
+		blkdev_put(device->bdev, device->mode);
 		device->bdev = NULL;
 		device->fs_devices->open_devices--;
 	}
@@ -1439,7 +1442,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	if ((sb->s_flags & MS_RDONLY) && !root->fs_info->fs_devices->seeding)
 		return -EINVAL;

-	bdev = open_bdev_exclusive(device_path, 0, root->fs_info->bdev_holder);
+	bdev = blkdev_get_by_path(device_path, FMODE_EXCL,
+				  root->fs_info->bdev_holder);
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2b638b6..856e757 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -49,7 +49,7 @@ struct btrfs_device {

 	struct block_device *bdev;

-	/* the mode sent to open_bdev_exclusive */
+	/* the mode sent to blkdev_get */
 	fmode_t mode;

 	char *name;
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 23e7513..123720b 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -347,7 +347,7 @@ static struct block_device *ext3_blkdev_get(dev_t dev, struct super_block *sb)
 	struct block_device *bdev;
 	char b[BDEVNAME_SIZE];

-	bdev = open_by_devnum(dev, FMODE_READ|FMODE_WRITE|FMODE_EXCL, sb);
+	bdev = blkdev_get_by_dev(dev, FMODE_READ|FMODE_WRITE|FMODE_EXCL, sb);
 	if (IS_ERR(bdev))
 		goto fail;
 	return bdev;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5dd0b3e..bd63e69 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -647,7 +647,7 @@ static struct block_device *ext4_blkdev_get(dev_t dev, struct super_block *sb)
 	struct block_device *bdev;
 	char b[BDEVNAME_SIZE];

-	bdev = open_by_devnum(dev, FMODE_READ|FMODE_WRITE|FMODE_EXCL, sb);
+	bdev = blkdev_get_by_dev(dev, FMODE_READ|FMODE_WRITE|FMODE_EXCL, sb);
 	if (IS_ERR(bdev))
 		goto fail;
 	return bdev;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index c1f0763..bc56ccf 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1268,7 +1268,7 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 {
 	struct block_device *bdev;
 	struct super_block *s;
-	fmode_t mode = FMODE_READ;
+	fmode_t mode = FMODE_READ | FMODE_EXCL;
 	int error;
 	struct gfs2_args args;
 	struct gfs2_sbd *sdp;
@@ -1276,7 +1276,7 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 	if (!(flags & MS_RDONLY))
 		mode |= FMODE_WRITE;

-	bdev = open_bdev_exclusive(dev_name, mode, fs_type);
+	bdev = blkdev_get_by_path(dev_name, mode, fs_type);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);

@@ -1298,7 +1298,7 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 		goto error_bdev;

 	if (s->s_root)
-		blkdev_put(bdev, mode | FMODE_EXCL);
+		blkdev_put(bdev, mode);

 	memset(&args, 0, sizeof(args));
 	args.ar_quota = GFS2_QUOTA_DEFAULT;
@@ -1342,7 +1342,7 @@ error_super:
 	deactivate_locked_super(s);
 	return ERR_PTR(error);
 error_bdev:
-	blkdev_put(bdev, mode | FMODE_EXCL);
+	blkdev_put(bdev, mode);
 	return ERR_PTR(error);
 }

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 5a290f2..278e3fb 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1120,8 +1120,8 @@ int lmLogOpen(struct super_block *sb)
 	 * file systems to log may have n-to-1 relationship;
 	 */

-	bdev = open_by_devnum(sbi->logdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
-			      log);
+	bdev = blkdev_get_by_dev(sbi->logdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
+				 log);
 	if (IS_ERR(bdev)) {
 		rc = -PTR_ERR(bdev);
 		goto free;
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 734b902..723bc5b 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -325,7 +325,8 @@ int logfs_get_sb_bdev(struct logfs_super *p, struct file_system_type *type,
 {
 	struct block_device *bdev;

-	bdev = open_bdev_exclusive(devname, FMODE_READ|FMODE_WRITE, type);
+	bdev = blkdev_get_by_path(devname, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
+				  type);
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 756a679..0030640 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1147,14 +1147,14 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 {
 	struct nilfs_super_data sd;
 	struct super_block *s;
-	fmode_t mode = FMODE_READ;
+	fmode_t mode = FMODE_READ | FMODE_EXCL;
 	struct dentry *root_dentry;
 	int err, s_new = false;

 	if (!(flags & MS_RDONLY))
 		mode |= FMODE_WRITE;

-	sd.bdev = open_bdev_exclusive(dev_name, mode, fs_type);
+	sd.bdev = blkdev_get_by_path(dev_name, mode, fs_type);
 	if (IS_ERR(sd.bdev))
 		return ERR_CAST(sd.bdev);

@@ -1233,7 +1233,7 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 	}

 	if (!s_new)
-		blkdev_put(sd.bdev, mode | FMODE_EXCL);
+		blkdev_put(sd.bdev, mode);

 	return root_dentry;

@@ -1242,7 +1242,7 @@ nilfs_mount(struct file_system_type *fs_type, int flags,

  failed:
 	if (!s_new)
-		blkdev_put(sd.bdev, mode | FMODE_EXCL);
+		blkdev_put(sd.bdev, mode);
 	return ERR_PTR(err);
 }

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index b488136..e2fce51 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2585,7 +2585,8 @@ static int journal_init_dev(struct super_block *super,
 	if ((!jdev_name || !jdev_name[0])) {
 		if (jdev == super->s_dev)
 			blkdev_mode &= ~FMODE_EXCL;
-		journal->j_dev_bd = open_by_devnum(jdev, blkdev_mode, journal);
+		journal->j_dev_bd = blkdev_get_by_dev(jdev, blkdev_mode,
+						      journal);
 		journal->j_dev_mode = blkdev_mode;
 		if (IS_ERR(journal->j_dev_bd)) {
 			result = PTR_ERR(journal->j_dev_bd);
@@ -2601,8 +2602,7 @@ static int journal_init_dev(struct super_block *super,
 	}

 	journal->j_dev_mode = blkdev_mode;
-	journal->j_dev_bd = open_bdev_exclusive(jdev_name,
-						blkdev_mode, journal);
+	journal->j_dev_bd = blkdev_get_by_path(jdev_name, blkdev_mode, journal);
 	if (IS_ERR(journal->j_dev_bd)) {
 		result = PTR_ERR(journal->j_dev_bd);
 		journal->j_dev_bd = NULL;
diff --git a/fs/super.c b/fs/super.c
index 22374bf..5d9a449 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -766,13 +766,13 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 {
 	struct block_device *bdev;
 	struct super_block *s;
-	fmode_t mode = FMODE_READ;
+	fmode_t mode = FMODE_READ | FMODE_EXCL;
 	int error = 0;

 	if (!(flags & MS_RDONLY))
 		mode |= FMODE_WRITE;

-	bdev = open_bdev_exclusive(dev_name, mode, fs_type);
+	bdev = blkdev_get_by_path(dev_name, mode, fs_type);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);

@@ -807,7 +807,7 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 		 * holding an active reference.
 		 */
 		up_write(&s->s_umount);
-		blkdev_put(bdev, mode | FMODE_EXCL);
+		blkdev_put(bdev, mode);
 		down_write(&s->s_umount);
 	} else {
 		char b[BDEVNAME_SIZE];
@@ -831,7 +831,7 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 error_s:
 	error = PTR_ERR(s);
 error_bdev:
-	blkdev_put(bdev, mode | FMODE_EXCL);
+	blkdev_put(bdev, mode);
 error:
 	return ERR_PTR(error);
 }
@@ -862,6 +862,7 @@ void kill_block_super(struct super_block *sb)
 	bdev->bd_super = NULL;
 	generic_shutdown_super(sb);
 	sync_blockdev(bdev);
+	WARN_ON_ONCE(!(mode & FMODE_EXCL));
 	blkdev_put(bdev, mode | FMODE_EXCL);
 }

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index a1a6e5c..9209cd1 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -609,7 +609,8 @@ xfs_blkdev_get(
 {
 	int			error = 0;

-	*bdevp = open_bdev_exclusive(name, FMODE_READ|FMODE_WRITE, mp);
+	*bdevp = blkdev_get_by_path(name, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
+				    mp);
 	if (IS_ERR(*bdevp)) {
 		error = PTR_ERR(*bdevp);
 		printk("XFS: Invalid device [%s], error=%d\n", name, error);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1a033e8..f485015 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2006,8 +2006,6 @@ extern struct block_device *bdgrab(struct block_device *bdev);
 extern void bd_set_size(struct block_device *, loff_t size);
 extern void bd_forget(struct inode *inode);
 extern void bdput(struct block_device *);
-extern struct block_device *open_by_devnum(dev_t dev, fmode_t mode,
-					   void *holder);
 extern void invalidate_bdev(struct block_device *);
 extern int sync_blockdev(struct block_device *bdev);
 extern struct super_block *freeze_bdev(struct block_device *);
@@ -2039,6 +2037,10 @@ extern int ioctl_by_bdev(struct block_device *, unsigned, unsigned long);
 extern int blkdev_ioctl(struct block_device *, fmode_t, unsigned, unsigned long);
 extern long compat_blkdev_ioctl(struct file *, unsigned, unsigned long);
 extern int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder);
+extern struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
+					       void *holder);
+extern struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode,
+					      void *holder);
 extern int blkdev_put(struct block_device *bdev, fmode_t mode);
 #ifdef CONFIG_SYSFS
 extern int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
@@ -2083,7 +2085,6 @@ static inline void unregister_chrdev(unsigned int major, const char *name)
 extern const char *__bdevname(dev_t, char *buffer);
 extern const char *bdevname(struct block_device *bdev, char *buffer);
 extern struct block_device *lookup_bdev(const char *);
-extern struct block_device *open_bdev_exclusive(const char *, fmode_t, void *);
 extern void blkdev_show(struct seq_file *,off_t);

 #else
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 513a77f..b019609 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -907,8 +907,8 @@ int swsusp_check(void)
 {
 	int error;

-	hib_resume_bdev = open_by_devnum(swsusp_resume_device,
-					 FMODE_READ, NULL);
+	hib_resume_bdev = blkdev_get_by_dev(swsusp_resume_device,
+					    FMODE_READ, NULL);
 	if (!IS_ERR(hib_resume_bdev)) {
 		set_blocksize(hib_resume_bdev, PAGE_SIZE);
 		clear_page(swsusp_header);
-- 
1.7.1

