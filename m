Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761695Ab0GTUnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:43:14 -0400
Received: from claw.goop.org ([74.207.240.146]:50924 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761582Ab0GTUmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:49 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        Jan Beulich <jbeulich@novell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 02/16] blkfront: fixes for 'xm block-detach ... --force'
Date: Tue, 20 Jul 2010 13:42:10 -0700
Message-Id: <04fa38b8296796fdb64c21754f3d4b42199d4ede.1279658433.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
References: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <jbeulich@novell.com>

Prevent prematurely freeing 'struct blkfront_info' instances (when the
xenbus data structures are gone, but the Linux ones are still needed).

Prevent adding a disk with the same (major, minor) [and hence the same
name and sysfs entries, which leads to oopses] when the previous
instance wasn't fully de-allocated yet.

This still doesn't address all issues resulting from forced detach:
I/O submitted after the detach still blocks forever, likely preventing
subsequent un-mounting from completing. It's not clear to me (not
knowing much about the block layer) how this can be avoided.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |   83 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 6839947..b1b16e5 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -104,6 +104,10 @@ struct blkfront_info
 
 static DEFINE_SPINLOCK(blkif_io_lock);
 
+static unsigned int nr_minors;
+static unsigned long *minors;
+static DEFINE_SPINLOCK(minor_lock);
+
 #define MAXIMUM_OUTSTANDING_BLOCK_REQS \
 	(BLKIF_MAX_SEGMENTS_PER_REQUEST * BLK_RING_SIZE)
 #define GRANT_INVALID_REF	0
@@ -138,6 +142,55 @@ static void add_id_to_freelist(struct blkfront_info *info,
 	info->shadow_free = id;
 }
 
+static int xlbd_reserve_minors(unsigned int minor, unsigned int nr)
+{
+	unsigned int end = minor + nr;
+	int rc;
+
+	if (end > nr_minors) {
+		unsigned long *bitmap, *old;
+
+		bitmap = kzalloc(BITS_TO_LONGS(end) * sizeof(*bitmap),
+				 GFP_KERNEL);
+		if (bitmap == NULL)
+			return -ENOMEM;
+
+		spin_lock(&minor_lock);
+		if (end > nr_minors) {
+			old = minors;
+			memcpy(bitmap, minors,
+			       BITS_TO_LONGS(nr_minors) * sizeof(*bitmap));
+			minors = bitmap;
+			nr_minors = BITS_TO_LONGS(end) * BITS_PER_LONG;
+		} else
+			old = bitmap;
+		spin_unlock(&minor_lock);
+		kfree(old);
+	}
+
+	spin_lock(&minor_lock);
+	if (find_next_bit(minors, end, minor) >= end) {
+		for (; minor < end; ++minor)
+			__set_bit(minor, minors);
+		rc = 0;
+	} else
+		rc = -EBUSY;
+	spin_unlock(&minor_lock);
+
+	return rc;
+}
+
+static void xlbd_release_minors(unsigned int minor, unsigned int nr)
+{
+	unsigned int end = minor + nr;
+
+	BUG_ON(end > nr_minors);
+	spin_lock(&minor_lock);
+	for (; minor < end; ++minor)
+		__clear_bit(minor, minors);
+	spin_unlock(&minor_lock);
+}
+
 static void blkif_restart_queue_callback(void *arg)
 {
 	struct blkfront_info *info = (struct blkfront_info *)arg;
@@ -417,9 +470,14 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 	if ((minor % nr_parts) == 0)
 		nr_minors = nr_parts;
 
+	err = xlbd_reserve_minors(minor, nr_minors);
+	if (err)
+		goto out;
+	err = -ENODEV;
+
 	gd = alloc_disk(nr_minors);
 	if (gd == NULL)
-		goto out;
+		goto release;
 
 	offset = minor / nr_parts;
 
@@ -450,7 +508,7 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 
 	if (xlvbd_init_blk_queue(gd, sector_size)) {
 		del_gendisk(gd);
-		goto out;
+		goto release;
 	}
 
 	info->rq = gd->queue;
@@ -470,6 +528,8 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 
 	return 0;
 
+ release:
+	xlbd_release_minors(minor, nr_minors);
  out:
 	return err;
 }
@@ -924,6 +984,7 @@ static void blkfront_connect(struct blkfront_info *info)
 static void blkfront_closing(struct xenbus_device *dev)
 {
 	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
+	unsigned int minor, nr_minors;
 	unsigned long flags;
 
 	dev_dbg(&dev->dev, "blkfront_closing: %s removed\n", dev->nodename);
@@ -946,7 +1007,10 @@ static void blkfront_closing(struct xenbus_device *dev)
 	blk_cleanup_queue(info->rq);
 	info->rq = NULL;
 
+	minor = info->gd->first_minor;
+	nr_minors = info->gd->minors;
 	del_gendisk(info->gd);
+	xlbd_release_minors(minor, nr_minors);
 
  out:
 	xenbus_frontend_closed(dev);
@@ -1004,7 +1068,10 @@ static int blkfront_remove(struct xenbus_device *dev)
 
 	blkif_free(info, 0);
 
-	kfree(info);
+	if(info->users == 0)
+		kfree(info);
+	else
+		info->is_ready = -1;
 
 	return 0;
 }
@@ -1013,12 +1080,15 @@ static int blkfront_is_ready(struct xenbus_device *dev)
 {
 	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 
-	return info->is_ready;
+	return info->is_ready > 0;
 }
 
 static int blkif_open(struct block_device *bdev, fmode_t mode)
 {
 	struct blkfront_info *info = bdev->bd_disk->private_data;
+
+	if(info->is_ready < 0)
+		return -ENODEV;
 	info->users++;
 	return 0;
 }
@@ -1034,7 +1104,10 @@ static int blkif_release(struct gendisk *disk, fmode_t mode)
 		struct xenbus_device *dev = info->xbdev;
 		enum xenbus_state state = xenbus_read_driver_state(dev->otherend);
 
-		if (state == XenbusStateClosing && info->is_ready)
+		if(info->is_ready < 0) {
+			blkfront_closing(dev);
+			kfree(info);
+		} else if (state == XenbusStateClosing && info->is_ready)
 			blkfront_closing(dev);
 	}
 	return 0;
-- 
1.7.1.1

