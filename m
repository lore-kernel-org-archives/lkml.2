Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab2APQNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:13:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51595 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab2APQNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:13:21 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: stable@kernel.org, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
        linux-scsi@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH stable 3/3] dm: do not forward ioctls from logical volumes to the underlying device
Date: Mon, 16 Jan 2012 17:13:00 +0100
Message-Id: <1326730380-7674-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1326730380-7674-1-git-send-email-pbonzini@redhat.com>
References: <1326730380-7674-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A logical volume can map to just part of underlying physical volume.
In this case, it must be treated like a partition.

Based on a patch from Alasdair G Kergon.

[ Cherry picked from 95113a17a2a1eb06151dc698dca9bcc4a29e4fbb ]

Cc: stable@kernel.org
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 drivers/md/dm-flakey.c |   11 ++++++++++-
 drivers/md/dm-linear.c |   12 +++++++++++-
 drivers/md/dm-mpath.c  |    6 ++++++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index f84c080..9fb18c1 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -368,8 +368,17 @@ static int flakey_status(struct dm_target *ti, status_type_t type,
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
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 3921e3b..9728839 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -116,7 +116,17 @@ static int linear_ioctl(struct dm_target *ti, unsigned int cmd,
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
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5e0090e..801d92d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1520,6 +1520,12 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 
 	spin_unlock_irqrestore(&m->lock, flags);
 
+	/*
+	 * Only pass ioctls through if the device sizes match exactly.
+	 */
+	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
+		r = scsi_verify_blk_ioctl(NULL, cmd);
+
 	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 }
 
-- 
1.7.7.1

