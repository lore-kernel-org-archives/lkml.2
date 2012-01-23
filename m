Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab2AWXto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:49:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab2AWXtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:49:41 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:28 2012
Message-Id: <20120123234028.299579430@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alasdair G Kergon <agk@redhat.com>,
        dm-devel@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: [63/90] dm: do not forward ioctls from logical volumes to the
 underlying device
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit ec8013beddd717d1740cfefb1a9b900deef85462 upstream.

A logical volume can map to just part of underlying physical volume.
In this case, it must be treated like a partition.

Based on a patch from Alasdair G Kergon.

Cc: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-flakey.c |   11 ++++++++++-
 drivers/md/dm-linear.c |   12 +++++++++++-
 drivers/md/dm-mpath.c  |    6 ++++++
 3 files changed, 27 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -149,8 +149,17 @@ static int flakey_status(struct dm_targe
 static int flakey_ioctl(struct dm_target *ti, unsigned int cmd, unsigned long arg)
 {
 	struct flakey_c *fc = ti->private;
+	struct dm_dev *dev = fc->dev;
+	int r = 0;
 
-	return __blkdev_driver_ioctl(fc->dev->bdev, fc->dev->mode, cmd, arg);
+	/*
+	 * Only pass ioctls through if the device sizes match exactly.
+	 */
+	if (fc->start ||
+	    ti->len != i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT)
+		r = scsi_verify_blk_ioctl(NULL, cmd);
+
+	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
 }
 
 static int flakey_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -116,7 +116,17 @@ static int linear_ioctl(struct dm_target
 			unsigned long arg)
 {
 	struct linear_c *lc = (struct linear_c *) ti->private;
-	return __blkdev_driver_ioctl(lc->dev->bdev, lc->dev->mode, cmd, arg);
+	struct dm_dev *dev = lc->dev;
+	int r = 0;
+
+	/*
+	 * Only pass ioctls through if the device sizes match exactly.
+	 */
+	if (lc->start ||
+	    ti->len != i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT)
+		r = scsi_verify_blk_ioctl(NULL, cmd);
+
+	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
 }
 
 static int linear_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1584,6 +1584,12 @@ static int multipath_ioctl(struct dm_tar
 
 	spin_unlock_irqrestore(&m->lock, flags);
 
+	/*
+	 * Only pass ioctls through if the device sizes match exactly.
+	 */
+	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
+		r = scsi_verify_blk_ioctl(NULL, cmd);
+
 	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 }
 


