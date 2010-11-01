Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab0KAQRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:17:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:46864 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758538Ab0KAQRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:17:03 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org,
        petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
        aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com,
        chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com,
        joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp,
        reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] block: make blkdev_get/put() handle exclusive access
Date: Mon,  1 Nov 2010 17:15:28 +0100
Message-Id: <1288628129-12811-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288628129-12811-1-git-send-email-tj@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Nov 2010 16:15:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Over time, block layer has accumulated a set of APIs dealing with bdev
open, close, claim and release.

* blkdev_get/put() are the primary open and close functions.

* bd_claim/release() deal with exclusive open.

* open/close_bdev_exclusive() are combination of open and claim and
  the other way around, respectively.

* bd_link/unlink_disk_holder() to create and remove holder/slave
  symlinks.

* open_by_devnum() wraps bdget() + blkdev_get().

The interface is a bit confusing and the decoupling of open and claim
makes it impossible to properly guarantee exclusive access as
in-kernel open + claim sequence can disturb the existing exclusive
open even before the block layer knows the current open if for another
exclusive access.  Reorganize the interface such that,

* blkdev_get() is extended to include exclusive access management.
  @holder argument is added and, if is @FMODE_EXCL specified, it will
  gain exclusive access atomically w.r.t. other exclusive accesses.

* blkdev_put() is similarly extended.  It now takes @mode argument and
  if @FMODE_EXCL is set, it releases an exclusive access.  Also, when
  the last exclusive claim is released, the holder/slave symlinks are
  removed automatically.

* bd_claim/release() and close_bdev_exclusive() are no longer
  necessary and either made static or removed.

* bd_link_disk_holder() remains the same but bd_unlink_disk_holder()
  is no longer necessary and removed.

* open_bdev_exclusive() becomes a simple wrapper around lookup_bdev()
  and blkdev_get().  It also has an unexpected extra bdev_read_only()
  test which probably should be moved into blkdev_get().

* open_by_devnum() is modified to take @holder argument and pass it to
  blkdev_get().

Most of bdev open/close operations are unified into blkdev_get/put()
and most exclusive accesses are tested atomically at the open time (as
it should).  This cleans up code and removes some, both valid and
invalid, but unnecessary all the same, corner cases.

open_bdev_exclusive() and open_by_devnum() can use further cleanup -
rename to blkdev_get_by_path() and blkdev_get_by_devt() and drop
special features.  Well, let's leave them for another day.

Most conversions are straight-forward.  drbd conversion is a bit more
involved as there was some reordering, but the logic should stay the
same.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Osterlund <petero2@telia.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com
Cc: drbd-dev@lists.linbit.com
Cc: Neil Brown <neilb@suse.de>
Cc: Leo Chen <leochen@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Joern Engel <joern@logfs.org>
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Cc: reiserfs-devel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 block/ioctl.c                   |    5 +-
 drivers/block/drbd/drbd_int.h   |    2 -
 drivers/block/drbd/drbd_main.c  |    7 +--
 drivers/block/drbd/drbd_nl.c    |  105 ++++++++++------------------
 drivers/block/pktcdvd.c         |   22 ++----
 drivers/char/raw.c              |   14 +---
 drivers/md/dm-table.c           |   15 +---
 drivers/md/md.c                 |   14 +---
 drivers/mtd/devices/block2mtd.c |   17 +----
 drivers/s390/block/dasd_genhd.c |    2 +-
 fs/block_dev.c                  |  149 +++++++++++++--------------------------
 fs/btrfs/volumes.c              |   14 ++--
 fs/ext3/super.c                 |   12 +---
 fs/ext4/super.c                 |   12 +---
 fs/gfs2/ops_fstype.c            |    4 +-
 fs/jfs/jfs_logmgr.c             |   17 ++---
 fs/logfs/dev_bdev.c             |    4 +-
 fs/nilfs2/super.c               |    4 +-
 fs/ocfs2/cluster/heartbeat.c    |    2 +-
 fs/partitions/check.c           |    2 +-
 fs/reiserfs/journal.c           |   17 ++---
 fs/super.c                      |   14 ++--
 fs/xfs/linux-2.6/xfs_super.c    |    2 +-
 include/linux/fs.h              |   14 +---
 kernel/power/swap.c             |    5 +-
 mm/swapfile.c                   |    7 +-
 26 files changed, 163 insertions(+), 319 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index d724ceb..cc46d49 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -294,11 +294,12 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			return -EINVAL;
 		if (get_user(n, (int __user *) arg))
 			return -EFAULT;
-		if (!(mode & FMODE_EXCL) && bd_claim(bdev, &bdev) < 0)
+		if (!(mode & FMODE_EXCL) &&
+		    blkdev_get(bdev, mode | FMODE_EXCL, &bdev) < 0)
 			return -EBUSY;
 		ret = set_blocksize(bdev, n);
 		if (!(mode & FMODE_EXCL))
-			bd_release(bdev);
+			blkdev_put(bdev, mode | FMODE_EXCL);
 		return ret;
 	case BLKPG:
 		ret = blkpg_ioctl(bdev, (struct blkpg_ioctl_arg __user *) arg);
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 9bdcf43..0590b9f 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -923,8 +923,6 @@ struct drbd_md {
 struct drbd_backing_dev {
 	struct block_device *backing_bdev;
 	struct block_device *md_bdev;
-	struct file *lo_file;
-	struct file *md_file;
 	struct drbd_md md;
 	struct disk_conf dc; /* The user provided config... */
 	sector_t known_size; /* last known size of that backing device */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 25c7a73..7ec1a82 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3361,11 +3361,8 @@ void drbd_free_bc(struct drbd_backing_dev *ldev)
 	if (ldev == NULL)
 		return;
 
-	bd_release(ldev->backing_bdev);
-	bd_release(ldev->md_bdev);
-
-	fput(ldev->lo_file);
-	fput(ldev->md_file);
+	blkdev_put(ldev->backing_bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
+	blkdev_put(ldev->md_bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 
 	kfree(ldev);
 }
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 87925e9..fd03460 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -855,7 +855,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	sector_t max_possible_sectors;
 	sector_t min_md_device_sectors;
 	struct drbd_backing_dev *nbc = NULL; /* new_backing_conf */
-	struct inode *inode, *inode2;
+	struct block_device *bdev;
 	struct lru_cache *resync_lru = NULL;
 	union drbd_state ns, os;
 	unsigned int max_seg_s;
@@ -902,46 +902,40 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 		}
 	}
 
-	nbc->lo_file = filp_open(nbc->dc.backing_dev, O_RDWR, 0);
-	if (IS_ERR(nbc->lo_file)) {
+	bdev = open_bdev_exclusive(nbc->dc.backing_dev,
+				   FMODE_READ | FMODE_WRITE, mdev);
+	if (IS_ERR(bdev)) {
 		dev_err(DEV, "open(\"%s\") failed with %ld\n", nbc->dc.backing_dev,
-		    PTR_ERR(nbc->lo_file));
-		nbc->lo_file = NULL;
+			PTR_ERR(bdev));
 		retcode = ERR_OPEN_DISK;
 		goto fail;
 	}
+	nbc->backing_bdev = bdev;
 
-	inode = nbc->lo_file->f_dentry->d_inode;
-
-	if (!S_ISBLK(inode->i_mode)) {
-		retcode = ERR_DISK_NOT_BDEV;
-		goto fail;
-	}
-
-	nbc->md_file = filp_open(nbc->dc.meta_dev, O_RDWR, 0);
-	if (IS_ERR(nbc->md_file)) {
+	/*
+	 * meta_dev_idx >= 0: external fixed size, possibly multiple
+	 * drbd sharing one meta device.  TODO in that case, paranoia
+	 * check that [md_bdev, meta_dev_idx] is not yet used by some
+	 * other drbd minor!  (if you use drbd.conf + drbdadm, that
+	 * should check it for you already; but if you don't, or
+	 * someone fooled it, we need to double check here)
+	 */
+	bdev = open_bdev_exclusive(nbc->dc.meta_dev,
+				   FMODE_READ | FMODE_WRITE,
+				   (nbc->dc.meta_dev_idx < 0) ?
+				   (void *)mdev : (void *)drbd_m_holder);
+	if (IS_ERR(bdev)) {
 		dev_err(DEV, "open(\"%s\") failed with %ld\n", nbc->dc.meta_dev,
-		    PTR_ERR(nbc->md_file));
-		nbc->md_file = NULL;
+			PTR_ERR(bdev));
 		retcode = ERR_OPEN_MD_DISK;
 		goto fail;
 	}
+	nbc->md_bdev = bdev;
 
-	inode2 = nbc->md_file->f_dentry->d_inode;
-
-	if (!S_ISBLK(inode2->i_mode)) {
-		retcode = ERR_MD_NOT_BDEV;
-		goto fail;
-	}
-
-	nbc->backing_bdev = inode->i_bdev;
-	if (bd_claim(nbc->backing_bdev, mdev)) {
-		printk(KERN_ERR "drbd: bd_claim(%p,%p); failed [%p;%p;%u]\n",
-		       nbc->backing_bdev, mdev,
-		       nbc->backing_bdev->bd_holder,
-		       nbc->backing_bdev->bd_contains->bd_holder,
-		       nbc->backing_bdev->bd_holders);
-		retcode = ERR_BDCLAIM_DISK;
+	if ((nbc->backing_bdev == nbc->md_bdev) !=
+	    (nbc->dc.meta_dev_idx == DRBD_MD_INDEX_INTERNAL ||
+	     nbc->dc.meta_dev_idx == DRBD_MD_INDEX_FLEX_INT)) {
+		retcode = ERR_MD_IDX_INVALID;
 		goto fail;
 	}
 
@@ -950,28 +944,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 			offsetof(struct bm_extent, lce));
 	if (!resync_lru) {
 		retcode = ERR_NOMEM;
-		goto release_bdev_fail;
-	}
-
-	/* meta_dev_idx >= 0: external fixed size,
-	 * possibly multiple drbd sharing one meta device.
-	 * TODO in that case, paranoia check that [md_bdev, meta_dev_idx] is
-	 * not yet used by some other drbd minor!
-	 * (if you use drbd.conf + drbdadm,
-	 * that should check it for you already; but if you don't, or someone
-	 * fooled it, we need to double check here) */
-	nbc->md_bdev = inode2->i_bdev;
-	if (bd_claim(nbc->md_bdev, (nbc->dc.meta_dev_idx < 0) ? (void *)mdev
-				: (void *) drbd_m_holder)) {
-		retcode = ERR_BDCLAIM_MD_DISK;
-		goto release_bdev_fail;
-	}
-
-	if ((nbc->backing_bdev == nbc->md_bdev) !=
-	    (nbc->dc.meta_dev_idx == DRBD_MD_INDEX_INTERNAL ||
-	     nbc->dc.meta_dev_idx == DRBD_MD_INDEX_FLEX_INT)) {
-		retcode = ERR_MD_IDX_INVALID;
-		goto release_bdev2_fail;
+		goto fail;
 	}
 
 	/* RT - for drbd_get_max_capacity() DRBD_MD_INDEX_FLEX_INT */
@@ -982,7 +955,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 			(unsigned long long) drbd_get_max_capacity(nbc),
 			(unsigned long long) nbc->dc.disk_size);
 		retcode = ERR_DISK_TO_SMALL;
-		goto release_bdev2_fail;
+		goto fail;
 	}
 
 	if (nbc->dc.meta_dev_idx < 0) {
@@ -999,7 +972,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 		dev_warn(DEV, "refusing attach: md-device too small, "
 		     "at least %llu sectors needed for this meta-disk type\n",
 		     (unsigned long long) min_md_device_sectors);
-		goto release_bdev2_fail;
+		goto fail;
 	}
 
 	/* Make sure the new disk is big enough
@@ -1007,7 +980,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	if (drbd_get_max_capacity(nbc) <
 	    drbd_get_capacity(mdev->this_bdev)) {
 		retcode = ERR_DISK_TO_SMALL;
-		goto release_bdev2_fail;
+		goto fail;
 	}
 
 	nbc->known_size = drbd_get_capacity(nbc->backing_bdev);
@@ -1030,7 +1003,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	retcode = _drbd_request_state(mdev, NS(disk, D_ATTACHING), CS_VERBOSE);
 	drbd_resume_io(mdev);
 	if (retcode < SS_SUCCESS)
-		goto release_bdev2_fail;
+		goto fail;
 
 	if (!get_ldev_if_state(mdev, D_ATTACHING))
 		goto force_diskless;
@@ -1264,18 +1237,14 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
  force_diskless:
 	drbd_force_state(mdev, NS(disk, D_DISKLESS));
 	drbd_md_sync(mdev);
- release_bdev2_fail:
-	if (nbc)
-		bd_release(nbc->md_bdev);
- release_bdev_fail:
-	if (nbc)
-		bd_release(nbc->backing_bdev);
  fail:
 	if (nbc) {
-		if (nbc->lo_file)
-			fput(nbc->lo_file);
-		if (nbc->md_file)
-			fput(nbc->md_file);
+		if (nbc->backing_bdev)
+			blkdev_put(nbc->backing_bdev,
+				   FMODE_READ | FMODE_WRITE | FMODE_EXCL);
+		if (nbc->md_bdev)
+			blkdev_put(nbc->md_bdev,
+				   FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 		kfree(nbc);
 	}
 	lc_destroy(resync_lru);
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 19b3568..77d70ee 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2296,15 +2296,12 @@ static int pkt_open_dev(struct pktcdvd_device *pd, fmode_t write)
 	 * so bdget() can't fail.
 	 */
 	bdget(pd->bdev->bd_dev);
-	if ((ret = blkdev_get(pd->bdev, FMODE_READ)))
+	if ((ret = blkdev_get(pd->bdev, FMODE_READ | FMODE_EXCL, pd)))
 		goto out;
 
-	if ((ret = bd_claim(pd->bdev, pd)))
-		goto out_putdev;
-
 	if ((ret = pkt_get_last_written(pd, &lba))) {
 		printk(DRIVER_NAME": pkt_get_last_written failed\n");
-		goto out_unclaim;
+		goto out_putdev;
 	}
 
 	set_capacity(pd->disk, lba << 2);
@@ -2314,7 +2311,7 @@ static int pkt_open_dev(struct pktcdvd_device *pd, fmode_t write)
 	q = bdev_get_queue(pd->bdev);
 	if (write) {
 		if ((ret = pkt_open_write(pd)))
-			goto out_unclaim;
+			goto out_putdev;
 		/*
 		 * Some CDRW drives can not handle writes larger than one packet,
 		 * even if the size is a multiple of the packet size.
@@ -2329,23 +2326,21 @@ static int pkt_open_dev(struct pktcdvd_device *pd, fmode_t write)
 	}
 
 	if ((ret = pkt_set_segment_merging(pd, q)))
-		goto out_unclaim;
+		goto out_putdev;
 
 	if (write) {
 		if (!pkt_grow_pktlist(pd, CONFIG_CDROM_PKTCDVD_BUFFERS)) {
 			printk(DRIVER_NAME": not enough memory for buffers\n");
 			ret = -ENOMEM;
-			goto out_unclaim;
+			goto out_putdev;
 		}
 		printk(DRIVER_NAME": %lukB available on disc\n", lba << 1);
 	}
 
 	return 0;
 
-out_unclaim:
-	bd_release(pd->bdev);
 out_putdev:
-	blkdev_put(pd->bdev, FMODE_READ);
+	blkdev_put(pd->bdev, FMODE_READ | FMODE_EXCL);
 out:
 	return ret;
 }
@@ -2362,8 +2357,7 @@ static void pkt_release_dev(struct pktcdvd_device *pd, int flush)
 	pkt_lock_door(pd, 0);
 
 	pkt_set_speed(pd, MAX_SPEED, MAX_SPEED);
-	bd_release(pd->bdev);
-	blkdev_put(pd->bdev, FMODE_READ);
+	blkdev_put(pd->bdev, FMODE_READ | FMODE_EXCL);
 
 	pkt_shrink_pktlist(pd);
 }
@@ -2733,7 +2727,7 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 	bdev = bdget(dev);
 	if (!bdev)
 		return -ENOMEM;
-	ret = blkdev_get(bdev, FMODE_READ | FMODE_NDELAY);
+	ret = blkdev_get(bdev, FMODE_READ | FMODE_NDELAY, NULL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index bfe25ea..b4b9d5a 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -65,15 +65,12 @@ static int raw_open(struct inode *inode, struct file *filp)
 	if (!bdev)
 		goto out;
 	igrab(bdev->bd_inode);
-	err = blkdev_get(bdev, filp->f_mode);
+	err = blkdev_get(bdev, filp->f_mode | FMODE_EXCL, raw_open);
 	if (err)
 		goto out;
-	err = bd_claim(bdev, raw_open);
-	if (err)
-		goto out1;
 	err = set_blocksize(bdev, bdev_logical_block_size(bdev));
 	if (err)
-		goto out2;
+		goto out1;
 	filp->f_flags |= O_DIRECT;
 	filp->f_mapping = bdev->bd_inode->i_mapping;
 	if (++raw_devices[minor].inuse == 1)
@@ -83,10 +80,8 @@ static int raw_open(struct inode *inode, struct file *filp)
 	mutex_unlock(&raw_mutex);
 	return 0;
 
-out2:
-	bd_release(bdev);
 out1:
-	blkdev_put(bdev, filp->f_mode);
+	blkdev_put(bdev, filp->f_mode | FMODE_EXCL);
 out:
 	mutex_unlock(&raw_mutex);
 	return err;
@@ -110,8 +105,7 @@ static int raw_release(struct inode *inode, struct file *filp)
 	}
 	mutex_unlock(&raw_mutex);
 
-	bd_release(bdev);
-	blkdev_put(bdev, filp->f_mode);
+	blkdev_put(bdev, filp->f_mode | FMODE_EXCL);
 	return 0;
 }
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2c876ff..9e88ca0 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -325,20 +325,13 @@ static int open_dev(struct dm_dev_internal *d, dev_t dev,
 
 	BUG_ON(d->dm_dev.bdev);
 
-	bdev = open_by_devnum(dev, d->dm_dev.mode);
+	bdev = open_by_devnum(dev, d->dm_dev.mode | FMODE_EXCL, _claim_ptr);
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
-	r = bd_claim(bdev, _claim_ptr);
-	if (r) {
-		blkdev_put(bdev, d->dm_dev.mode);
-		return r;
-	}
-
 	r = bd_link_disk_holder(bdev, dm_disk(md));
 	if (r) {
-		bd_release(bdev);
-		blkdev_put(bdev, d->dm_dev.mode);
+		blkdev_put(bdev, d->dm_dev.mode | FMODE_EXCL);
 		return r;
 	}
 
@@ -354,9 +347,7 @@ static void close_dev(struct dm_dev_internal *d, struct mapped_device *md)
 	if (!d->dm_dev.bdev)
 		return;
 
-	bd_unlink_disk_holder(d->dm_dev.bdev);
-	bd_release(d->dm_dev.bdev);
-	blkdev_put(d->dm_dev.bdev, d->dm_dev.mode);
+	blkdev_put(d->dm_dev.bdev, d->dm_dev.mode | FMODE_EXCL);
 	d->dm_dev.bdev = NULL;
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c47644f..6af951f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1907,7 +1907,6 @@ static void unbind_rdev_from_array(mdk_rdev_t * rdev)
 		MD_BUG();
 		return;
 	}
-	bd_unlink_disk_holder(rdev->bdev);
 	list_del_rcu(&rdev->same_set);
 	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
 	rdev->mddev = NULL;
@@ -1935,19 +1934,13 @@ static int lock_rdev(mdk_rdev_t *rdev, dev_t dev, int shared)
 	struct block_device *bdev;
 	char b[BDEVNAME_SIZE];
 
-	bdev = open_by_devnum(dev, FMODE_READ|FMODE_WRITE);
+	bdev = open_by_devnum(dev, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
+			      shared ? (mdk_rdev_t *)lock_rdev : rdev);
 	if (IS_ERR(bdev)) {
 		printk(KERN_ERR "md: could not open %s.\n",
 			__bdevname(dev, b));
 		return PTR_ERR(bdev);
 	}
-	err = bd_claim(bdev, shared ? (mdk_rdev_t *)lock_rdev : rdev);
-	if (err) {
-		printk(KERN_ERR "md: could not bd_claim %s.\n",
-			bdevname(bdev, b));
-		blkdev_put(bdev, FMODE_READ|FMODE_WRITE);
-		return err;
-	}
 	if (!shared)
 		set_bit(AllReserved, &rdev->flags);
 	rdev->bdev = bdev;
@@ -1960,8 +1953,7 @@ static void unlock_rdev(mdk_rdev_t *rdev)
 	rdev->bdev = NULL;
 	if (!bdev)
 		MD_BUG();
-	bd_release(bdev);
-	blkdev_put(bdev, FMODE_READ|FMODE_WRITE);
+	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 }
 
 void md_autodetect_dev(dev_t dev);
diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index 806a9ed..84a4045 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -224,7 +224,7 @@ static void block2mtd_free_device(struct block2mtd_dev *dev)
 	if (dev->blkdev) {
 		invalidate_mapping_pages(dev->blkdev->bd_inode->i_mapping,
 					0, -1);
-		close_bdev_exclusive(dev->blkdev, FMODE_READ|FMODE_WRITE);
+		blkdev_put(dev->blkdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 	}
 
 	kfree(dev);
@@ -254,18 +254,9 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 		   to resolve the device name by other means. */
 
 		dev_t devt = name_to_dev_t(devname);
-		if (devt) {
-			bdev = open_by_devnum(devt, FMODE_WRITE | FMODE_READ);
-			if (!IS_ERR(bdev)) {
-				int ret;
-				ret = bd_claim(bdev, dev);
-				if (ret) {
-					blkdev_put(bdev,
-						   FMODE_READ | FMODE_WRITE);
-					bdev = ERR_PTR(ret);
-				}
-			}
-		}
+		if (devt)
+			bdev = open_by_devnum(devt,
+					FMODE_READ|FMODE_WRITE|FMODE_EXCL, dev);
 	}
 #endif
 
diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index 30a1ca3..5505bc0 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -103,7 +103,7 @@ int dasd_scan_partitions(struct dasd_block *block)
 	struct block_device *bdev;
 
 	bdev = bdget_disk(block->gdp, 0);
-	if (!bdev || blkdev_get(bdev, FMODE_READ) < 0)
+	if (!bdev || blkdev_get(bdev, FMODE_READ, NULL) < 0)
 		return -ENODEV;
 	/*
 	 * See fs/partition/check.c:register_disk,rescan_partitions
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9329068..fc48912 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -660,7 +660,7 @@ static bool bd_may_claim(struct block_device *bdev, struct block_device *whole,
 	else if (bdev->bd_contains == bdev)
 		return true;  	 /* is a whole device which isn't held */
 
-	else if (whole->bd_holder == bd_claim)
+	else if (whole->bd_holder == bd_may_claim)
 		return true; 	 /* is a partition of a device that is being partitioned */
 	else if (whole->bd_holder != NULL)
 		return false;	 /* is a partition of a held device */
@@ -807,10 +807,10 @@ static void __bd_claim(struct block_device *bdev, struct block_device *whole,
 {
 	/* note that for a whole device bd_holders
 	 * will be incremented twice, and bd_holder will
-	 * be set to bd_claim before being set to holder
+	 * be set to bd_may_claim before being set to holder
 	 */
 	whole->bd_holders++;
-	whole->bd_holder = bd_claim;
+	whole->bd_holder = bd_may_claim;
 	bdev->bd_holders++;
 	bdev->bd_holder = holder;
 }
@@ -835,37 +835,7 @@ static void bd_finish_claiming(struct block_device *bdev,
 	__bd_abort_claiming(whole, holder); /* not actually an abort */
 }
 
-/**
- * bd_claim - claim a block device
- * @bdev: block device to claim
- * @holder: holder trying to claim @bdev
- *
- * Try to claim @bdev which must have been opened successfully.
- *
- * CONTEXT:
- * Might sleep.
- *
- * RETURNS:
- * 0 if successful, -EBUSY if @bdev is already claimed.
- */
-int bd_claim(struct block_device *bdev, void *holder)
-{
-	struct block_device *whole = bdev->bd_contains;
-	int res;
-
-	might_sleep();
-
-	spin_lock(&bdev_lock);
-	res = bd_prepare_to_claim(bdev, whole, holder);
-	if (res == 0)
-		__bd_claim(bdev, whole, holder);
-	spin_unlock(&bdev_lock);
-
-	return res;
-}
-EXPORT_SYMBOL(bd_claim);
-
-void bd_release(struct block_device *bdev)
+static void bd_release(struct block_device *bdev)
 {
 	spin_lock(&bdev_lock);
 	if (!--bdev->bd_contains->bd_holders)
@@ -875,8 +845,6 @@ void bd_release(struct block_device *bdev)
 	spin_unlock(&bdev_lock);
 }
 
-EXPORT_SYMBOL(bd_release);
-
 #ifdef CONFIG_SYSFS
 static int add_symlink(struct kobject *from, struct kobject *to)
 {
@@ -943,7 +911,7 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(bd_link_disk_holder);
 
-void bd_unlink_disk_holder(struct block_device *bdev)
+static void bd_unlink_disk_holder(struct block_device *bdev)
 {
 	struct gendisk *disk = bdev->bd_holder_disk;
 
@@ -954,7 +922,9 @@ void bd_unlink_disk_holder(struct block_device *bdev)
 	del_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
 	del_symlink(bdev->bd_part->holder_dir, &disk_to_dev(disk)->kobj);
 }
-EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
+#else
+static inline void bd_unlink_disk_holder(struct block_device *bdev)
+{ }
 #endif
 
 /*
@@ -964,12 +934,12 @@ EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
  * to be used for internal purposes.  If you ever need it - reconsider
  * your API.
  */
-struct block_device *open_by_devnum(dev_t dev, fmode_t mode)
+struct block_device *open_by_devnum(dev_t dev, fmode_t mode, void *holder)
 {
 	struct block_device *bdev = bdget(dev);
 	int err = -ENOMEM;
 	if (bdev)
-		err = blkdev_get(bdev, mode);
+		err = blkdev_get(bdev, mode, holder);
 	return err ? ERR_PTR(err) : bdev;
 }
 
@@ -1235,17 +1205,37 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	return ret;
 }
 
-int blkdev_get(struct block_device *bdev, fmode_t mode)
+int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
 {
-	return __blkdev_get(bdev, mode, 0);
+	struct block_device *whole = NULL;
+	int res;
+
+	WARN_ON_ONCE((mode & FMODE_EXCL) && !holder);
+
+	if ((mode & FMODE_EXCL) && holder) {
+		whole = bd_start_claiming(bdev, holder);
+		if (IS_ERR(whole)) {
+			bdput(bdev);
+			return PTR_ERR(whole);
+		}
+	}
+
+	res = __blkdev_get(bdev, mode, 0);
+
+	if (whole) {
+		if (res == 0)
+			bd_finish_claiming(bdev, whole, holder);
+		else
+			bd_abort_claiming(whole, holder);
+	}
+
+	return res;
 }
 EXPORT_SYMBOL(blkdev_get);
 
 static int blkdev_open(struct inode * inode, struct file * filp)
 {
-	struct block_device *whole = NULL;
 	struct block_device *bdev;
-	int res;
 
 	/*
 	 * Preserve backwards compatibility and allow large file access
@@ -1266,26 +1256,9 @@ static int blkdev_open(struct inode * inode, struct file * filp)
 	if (bdev == NULL)
 		return -ENOMEM;
 
-	if (filp->f_mode & FMODE_EXCL) {
-		whole = bd_start_claiming(bdev, filp);
-		if (IS_ERR(whole)) {
-			bdput(bdev);
-			return PTR_ERR(whole);
-		}
-	}
-
 	filp->f_mapping = bdev->bd_inode->i_mapping;
 
-	res = blkdev_get(bdev, filp->f_mode);
-
-	if (whole) {
-		if (res == 0)
-			bd_finish_claiming(bdev, whole, filp);
-		else
-			bd_abort_claiming(whole, filp);
-	}
-
-	return res;
+	return blkdev_get(bdev, filp->f_mode, filp);
 }
 
 static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
@@ -1329,6 +1302,13 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 
 int blkdev_put(struct block_device *bdev, fmode_t mode)
 {
+	if (mode & FMODE_EXCL) {
+		mutex_lock(&bdev->bd_mutex);
+		bd_release(bdev);
+		if (!bdev->bd_holders)
+			bd_unlink_disk_holder(bdev);
+		mutex_unlock(&bdev->bd_mutex);
+	}
 	return __blkdev_put(bdev, mode, 0);
 }
 EXPORT_SYMBOL(blkdev_put);
@@ -1336,8 +1316,7 @@ EXPORT_SYMBOL(blkdev_put);
 static int blkdev_close(struct inode * inode, struct file * filp)
 {
 	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
-	if (bdev->bd_holder == filp)
-		bd_release(bdev);
+
 	return blkdev_put(bdev, filp->f_mode);
 }
 
@@ -1494,55 +1473,27 @@ EXPORT_SYMBOL(lookup_bdev);
  */
 struct block_device *open_bdev_exclusive(const char *path, fmode_t mode, void *holder)
 {
-	struct block_device *bdev, *whole;
+	struct block_device *bdev;
 	int error;
 
 	bdev = lookup_bdev(path);
 	if (IS_ERR(bdev))
 		return bdev;
 
-	whole = bd_start_claiming(bdev, holder);
-	if (IS_ERR(whole)) {
-		bdput(bdev);
-		return whole;
-	}
-
-	error = blkdev_get(bdev, mode);
+	error = blkdev_get(bdev, mode | FMODE_EXCL, holder);
 	if (error)
-		goto out_abort_claiming;
+		return ERR_PTR(error);
 
-	error = -EACCES;
-	if ((mode & FMODE_WRITE) && bdev_read_only(bdev))
-		goto out_blkdev_put;
+	if ((mode & FMODE_WRITE) && bdev_read_only(bdev)) {
+		blkdev_put(bdev, mode);
+		return ERR_PTR(-EACCES);
+	}
 
-	bd_finish_claiming(bdev, whole, holder);
 	return bdev;
-
-out_blkdev_put:
-	blkdev_put(bdev, mode);
-out_abort_claiming:
-	bd_abort_claiming(whole, holder);
-	return ERR_PTR(error);
 }
 
 EXPORT_SYMBOL(open_bdev_exclusive);
 
-/**
- * close_bdev_exclusive  -  close a blockdevice opened by open_bdev_exclusive()
- *
- * @bdev:	blockdevice to close
- * @mode:	mode, must match that used to open.
- *
- * This is the counterpart to open_bdev_exclusive().
- */
-void close_bdev_exclusive(struct block_device *bdev, fmode_t mode)
-{
-	bd_release(bdev);
-	blkdev_put(bdev, mode);
-}
-
-EXPORT_SYMBOL(close_bdev_exclusive);
-
 int __invalidate_device(struct block_device *bdev)
 {
 	struct super_block *sb = get_super(bdev);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d395962..f1b729d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -489,7 +489,7 @@ again:
 			continue;
 
 		if (device->bdev) {
-			close_bdev_exclusive(device->bdev, device->mode);
+			blkdev_put(device->bdev, device->mode | FMODE_EXCL);
 			device->bdev = NULL;
 			fs_devices->open_devices--;
 		}
@@ -523,7 +523,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		if (device->bdev) {
-			close_bdev_exclusive(device->bdev, device->mode);
+			blkdev_put(device->bdev, device->mode | FMODE_EXCL);
 			fs_devices->open_devices--;
 		}
 		if (device->writeable) {
@@ -638,7 +638,7 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 error_brelse:
 		brelse(bh);
 error_close:
-		close_bdev_exclusive(bdev, flags);
+		blkdev_put(bdev, flags | FMODE_EXCL);
 error:
 		continue;
 	}
@@ -716,7 +716,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 
 	brelse(bh);
 error_close:
-	close_bdev_exclusive(bdev, flags);
+	blkdev_put(bdev, flags | FMODE_EXCL);
 error:
 	mutex_unlock(&uuid_mutex);
 	return ret;
@@ -1244,7 +1244,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		root->fs_info->fs_devices->latest_bdev = next_device->bdev;
 
 	if (device->bdev) {
-		close_bdev_exclusive(device->bdev, device->mode);
+		blkdev_put(device->bdev, device->mode | FMODE_EXCL);
 		device->bdev = NULL;
 		device->fs_devices->open_devices--;
 	}
@@ -1287,7 +1287,7 @@ error_brelse:
 	brelse(bh);
 error_close:
 	if (bdev)
-		close_bdev_exclusive(bdev, FMODE_READ);
+		blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
 out:
 	mutex_unlock(&root->fs_info->volume_mutex);
 	mutex_unlock(&uuid_mutex);
@@ -1565,7 +1565,7 @@ out:
 	mutex_unlock(&root->fs_info->volume_mutex);
 	return ret;
 error:
-	close_bdev_exclusive(bdev, 0);
+	blkdev_put(bdev, FMODE_EXCL);
 	if (seeding_dev) {
 		mutex_unlock(&uuid_mutex);
 		up_write(&sb->s_umount);
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 2fedaf8..23e7513 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -347,7 +347,7 @@ static struct block_device *ext3_blkdev_get(dev_t dev, struct super_block *sb)
 	struct block_device *bdev;
 	char b[BDEVNAME_SIZE];
 
-	bdev = open_by_devnum(dev, FMODE_READ|FMODE_WRITE);
+	bdev = open_by_devnum(dev, FMODE_READ|FMODE_WRITE|FMODE_EXCL, sb);
 	if (IS_ERR(bdev))
 		goto fail;
 	return bdev;
@@ -364,8 +364,7 @@ fail:
  */
 static int ext3_blkdev_put(struct block_device *bdev)
 {
-	bd_release(bdev);
-	return blkdev_put(bdev, FMODE_READ|FMODE_WRITE);
+	return blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 }
 
 static int ext3_blkdev_remove(struct ext3_sb_info *sbi)
@@ -2136,13 +2135,6 @@ static journal_t *ext3_get_dev_journal(struct super_block *sb,
 	if (bdev == NULL)
 		return NULL;
 
-	if (bd_claim(bdev, sb)) {
-		ext3_msg(sb, KERN_ERR,
-			"error: failed to claim external journal device");
-		blkdev_put(bdev, FMODE_READ|FMODE_WRITE);
-		return NULL;
-	}
-
 	blocksize = sb->s_blocksize;
 	hblock = bdev_logical_block_size(bdev);
 	if (blocksize < hblock) {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 40131b7..612ff3d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -647,7 +647,7 @@ static struct block_device *ext4_blkdev_get(dev_t dev, struct super_block *sb)
 	struct block_device *bdev;
 	char b[BDEVNAME_SIZE];
 
-	bdev = open_by_devnum(dev, FMODE_READ|FMODE_WRITE);
+	bdev = open_by_devnum(dev, FMODE_READ|FMODE_WRITE|FMODE_EXCL, sb);
 	if (IS_ERR(bdev))
 		goto fail;
 	return bdev;
@@ -663,8 +663,7 @@ fail:
  */
 static int ext4_blkdev_put(struct block_device *bdev)
 {
-	bd_release(bdev);
-	return blkdev_put(bdev, FMODE_READ|FMODE_WRITE);
+	return blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 }
 
 static int ext4_blkdev_remove(struct ext4_sb_info *sbi)
@@ -3732,13 +3731,6 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 	if (bdev == NULL)
 		return NULL;
 
-	if (bd_claim(bdev, sb)) {
-		ext4_msg(sb, KERN_ERR,
-			"failed to claim external journal device");
-		blkdev_put(bdev, FMODE_READ|FMODE_WRITE);
-		return NULL;
-	}
-
 	blocksize = sb->s_blocksize;
 	hblock = bdev_logical_block_size(bdev);
 	if (blocksize < hblock) {
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 3eb1393..c1f0763 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1298,7 +1298,7 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 		goto error_bdev;
 
 	if (s->s_root)
-		close_bdev_exclusive(bdev, mode);
+		blkdev_put(bdev, mode | FMODE_EXCL);
 
 	memset(&args, 0, sizeof(args));
 	args.ar_quota = GFS2_QUOTA_DEFAULT;
@@ -1342,7 +1342,7 @@ error_super:
 	deactivate_locked_super(s);
 	return ERR_PTR(error);
 error_bdev:
-	close_bdev_exclusive(bdev, mode);
+	blkdev_put(bdev, mode | FMODE_EXCL);
 	return ERR_PTR(error);
 }
 
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index e1b8493..5a290f2 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1120,16 +1120,13 @@ int lmLogOpen(struct super_block *sb)
 	 * file systems to log may have n-to-1 relationship;
 	 */
 
-	bdev = open_by_devnum(sbi->logdev, FMODE_READ|FMODE_WRITE);
+	bdev = open_by_devnum(sbi->logdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
+			      log);
 	if (IS_ERR(bdev)) {
 		rc = -PTR_ERR(bdev);
 		goto free;
 	}
 
-	if ((rc = bd_claim(bdev, log))) {
-		goto close;
-	}
-
 	log->bdev = bdev;
 	memcpy(log->uuid, sbi->loguuid, sizeof(log->uuid));
 
@@ -1137,7 +1134,7 @@ int lmLogOpen(struct super_block *sb)
 	 * initialize log:
 	 */
 	if ((rc = lmLogInit(log)))
-		goto unclaim;
+		goto close;
 
 	list_add(&log->journal_list, &jfs_external_logs);
 
@@ -1163,11 +1160,8 @@ journal_found:
 	list_del(&log->journal_list);
 	lbmLogShutdown(log);
 
-      unclaim:
-	bd_release(bdev);
-
       close:		/* close external log device */
-	blkdev_put(bdev, FMODE_READ|FMODE_WRITE);
+	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 
       free:		/* free log descriptor */
 	mutex_unlock(&jfs_log_mutex);
@@ -1512,8 +1506,7 @@ int lmLogClose(struct super_block *sb)
 	bdev = log->bdev;
 	rc = lmLogShutdown(log);
 
-	bd_release(bdev);
-	blkdev_put(bdev, FMODE_READ|FMODE_WRITE);
+	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 
 	kfree(log);
 
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 92ca6fb..734b902 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -300,7 +300,7 @@ static int bdev_write_sb(struct super_block *sb, struct page *page)
 
 static void bdev_put_device(struct logfs_super *s)
 {
-	close_bdev_exclusive(s->s_bdev, FMODE_READ|FMODE_WRITE);
+	blkdev_put(s->s_bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 }
 
 static int bdev_can_write_buf(struct super_block *sb, u64 ofs)
@@ -331,7 +331,7 @@ int logfs_get_sb_bdev(struct logfs_super *p, struct file_system_type *type,
 
 	if (MAJOR(bdev->bd_dev) == MTD_BLOCK_MAJOR) {
 		int mtdnr = MINOR(bdev->bd_dev);
-		close_bdev_exclusive(bdev, FMODE_READ|FMODE_WRITE);
+		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 		return logfs_get_sb_mtd(p, mtdnr);
 	}
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f804d41..756a679 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1233,7 +1233,7 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 	}
 
 	if (!s_new)
-		close_bdev_exclusive(sd.bdev, mode);
+		blkdev_put(sd.bdev, mode | FMODE_EXCL);
 
 	return root_dentry;
 
@@ -1242,7 +1242,7 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 
  failed:
 	if (!s_new)
-		close_bdev_exclusive(sd.bdev, mode);
+		blkdev_put(sd.bdev, mode | FMODE_EXCL);
 	return ERR_PTR(err);
 }
 
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 52c7557..d0a2721 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1674,7 +1674,7 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 		goto out;
 
 	reg->hr_bdev = I_BDEV(filp->f_mapping->host);
-	ret = blkdev_get(reg->hr_bdev, FMODE_WRITE | FMODE_READ);
+	ret = blkdev_get(reg->hr_bdev, FMODE_WRITE | FMODE_READ, NULL);
 	if (ret) {
 		reg->hr_bdev = NULL;
 		goto out;
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 0a8b0ad..2e6501d 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -549,7 +549,7 @@ void register_disk(struct gendisk *disk)
 		goto exit;
 
 	bdev->bd_invalidated = 1;
-	err = blkdev_get(bdev, FMODE_READ);
+	err = blkdev_get(bdev, FMODE_READ, NULL);
 	if (err < 0)
 		goto exit;
 	blkdev_put(bdev, FMODE_READ);
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 076c8b1..b488136 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2552,8 +2552,6 @@ static int release_journal_dev(struct super_block *super,
 	result = 0;
 
 	if (journal->j_dev_bd != NULL) {
-		if (journal->j_dev_bd->bd_dev != super->s_dev)
-			bd_release(journal->j_dev_bd);
 		result = blkdev_put(journal->j_dev_bd, journal->j_dev_mode);
 		journal->j_dev_bd = NULL;
 	}
@@ -2571,7 +2569,7 @@ static int journal_init_dev(struct super_block *super,
 {
 	int result;
 	dev_t jdev;
-	fmode_t blkdev_mode = FMODE_READ | FMODE_WRITE;
+	fmode_t blkdev_mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
 	char b[BDEVNAME_SIZE];
 
 	result = 0;
@@ -2585,7 +2583,9 @@ static int journal_init_dev(struct super_block *super,
 
 	/* there is no "jdev" option and journal is on separate device */
 	if ((!jdev_name || !jdev_name[0])) {
-		journal->j_dev_bd = open_by_devnum(jdev, blkdev_mode);
+		if (jdev == super->s_dev)
+			blkdev_mode &= ~FMODE_EXCL;
+		journal->j_dev_bd = open_by_devnum(jdev, blkdev_mode, journal);
 		journal->j_dev_mode = blkdev_mode;
 		if (IS_ERR(journal->j_dev_bd)) {
 			result = PTR_ERR(journal->j_dev_bd);
@@ -2594,15 +2594,8 @@ static int journal_init_dev(struct super_block *super,
 					 "cannot init journal device '%s': %i",
 					 __bdevname(jdev, b), result);
 			return result;
-		} else if (jdev != super->s_dev) {
-			result = bd_claim(journal->j_dev_bd, journal);
-			if (result) {
-				blkdev_put(journal->j_dev_bd, blkdev_mode);
-				return result;
-			}
-
+		} else if (jdev != super->s_dev)
 			set_blocksize(journal->j_dev_bd, super->s_blocksize);
-		}
 
 		return 0;
 	}
diff --git a/fs/super.c b/fs/super.c
index ca69615..22374bf 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -801,13 +801,13 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 
 		/*
 		 * s_umount nests inside bd_mutex during
-		 * __invalidate_device().  close_bdev_exclusive()
-		 * acquires bd_mutex and can't be called under
-		 * s_umount.  Drop s_umount temporarily.  This is safe
-		 * as we're holding an active reference.
+		 * __invalidate_device().  blkdev_put() acquires
+		 * bd_mutex and can't be called under s_umount.  Drop
+		 * s_umount temporarily.  This is safe as we're
+		 * holding an active reference.
 		 */
 		up_write(&s->s_umount);
-		close_bdev_exclusive(bdev, mode);
+		blkdev_put(bdev, mode | FMODE_EXCL);
 		down_write(&s->s_umount);
 	} else {
 		char b[BDEVNAME_SIZE];
@@ -831,7 +831,7 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 error_s:
 	error = PTR_ERR(s);
 error_bdev:
-	close_bdev_exclusive(bdev, mode);
+	blkdev_put(bdev, mode | FMODE_EXCL);
 error:
 	return ERR_PTR(error);
 }
@@ -862,7 +862,7 @@ void kill_block_super(struct super_block *sb)
 	bdev->bd_super = NULL;
 	generic_shutdown_super(sb);
 	sync_blockdev(bdev);
-	close_bdev_exclusive(bdev, mode);
+	blkdev_put(bdev, mode | FMODE_EXCL);
 }
 
 EXPORT_SYMBOL(kill_block_super);
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 9f3a78f..a1a6e5c 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -623,7 +623,7 @@ xfs_blkdev_put(
 	struct block_device	*bdev)
 {
 	if (bdev)
-		close_bdev_exclusive(bdev, FMODE_READ|FMODE_WRITE);
+		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 }
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b361848..64bd2f4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2007,7 +2007,8 @@ extern struct block_device *bdgrab(struct block_device *bdev);
 extern void bd_set_size(struct block_device *, loff_t size);
 extern void bd_forget(struct inode *inode);
 extern void bdput(struct block_device *);
-extern struct block_device *open_by_devnum(dev_t, fmode_t);
+extern struct block_device *open_by_devnum(dev_t dev, fmode_t mode,
+					   void *holder);
 extern void invalidate_bdev(struct block_device *);
 extern int sync_blockdev(struct block_device *bdev);
 extern struct super_block *freeze_bdev(struct block_device *);
@@ -2038,22 +2039,16 @@ extern const struct file_operations def_fifo_fops;
 extern int ioctl_by_bdev(struct block_device *, unsigned, unsigned long);
 extern int blkdev_ioctl(struct block_device *, fmode_t, unsigned, unsigned long);
 extern long compat_blkdev_ioctl(struct file *, unsigned, unsigned long);
-extern int blkdev_get(struct block_device *, fmode_t);
-extern int blkdev_put(struct block_device *, fmode_t);
-extern int bd_claim(struct block_device *, void *);
-extern void bd_release(struct block_device *);
+extern int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder);
+extern int blkdev_put(struct block_device *bdev, fmode_t mode);
 #ifdef CONFIG_SYSFS
 extern int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
-extern void bd_unlink_disk_holder(struct block_device *bdev);
 #else
 static inline int bd_link_disk_holder(struct block_device *bdev,
 				      struct gendisk *disk)
 {
 	return 0;
 }
-static inline void bd_unlink_disk_holder(struct block_device *bdev)
-{
-}
 #endif
 #endif
 
@@ -2090,7 +2085,6 @@ extern const char *__bdevname(dev_t, char *buffer);
 extern const char *bdevname(struct block_device *bdev, char *buffer);
 extern struct block_device *lookup_bdev(const char *);
 extern struct block_device *open_bdev_exclusive(const char *, fmode_t, void *);
-extern void close_bdev_exclusive(struct block_device *, fmode_t);
 extern void blkdev_show(struct seq_file *,off_t);
 
 #else
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index a0e4a86..513a77f 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -223,7 +223,7 @@ static int swsusp_swap_check(void)
 		return res;
 
 	root_swap = res;
-	res = blkdev_get(hib_resume_bdev, FMODE_WRITE);
+	res = blkdev_get(hib_resume_bdev, FMODE_WRITE, NULL);
 	if (res)
 		return res;
 
@@ -907,7 +907,8 @@ int swsusp_check(void)
 {
 	int error;
 
-	hib_resume_bdev = open_by_devnum(swsusp_resume_device, FMODE_READ);
+	hib_resume_bdev = open_by_devnum(swsusp_resume_device,
+					 FMODE_READ, NULL);
 	if (!IS_ERR(hib_resume_bdev)) {
 		set_blocksize(hib_resume_bdev, PAGE_SIZE);
 		clear_page(swsusp_header);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 67ddaaf..b6adcfb 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1677,7 +1677,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (S_ISBLK(inode->i_mode)) {
 		struct block_device *bdev = I_BDEV(inode);
 		set_blocksize(bdev, p->old_block_size);
-		bd_release(bdev);
+		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 	} else {
 		mutex_lock(&inode->i_mutex);
 		inode->i_flags &= ~S_SWAPFILE;
@@ -1939,7 +1939,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	error = -EINVAL;
 	if (S_ISBLK(inode->i_mode)) {
 		bdev = I_BDEV(inode);
-		error = bd_claim(bdev, sys_swapon);
+		error = blkdev_get(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL,
+				   sys_swapon);
 		if (error < 0) {
 			bdev = NULL;
 			error = -EINVAL;
@@ -2136,7 +2137,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 bad_swap:
 	if (bdev) {
 		set_blocksize(bdev, p->old_block_size);
-		bd_release(bdev);
+		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 	}
 	destroy_swap_extents(p);
 	swap_cgroup_swapoff(type);
-- 
1.7.1

