Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab0GTUot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:44:49 -0400
Received: from claw.goop.org ([74.207.240.146]:50977 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761640Ab0GTUmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:54 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/16] blkfront: Clean up vbd release
Date: Tue, 20 Jul 2010 13:42:18 -0700
Message-Id: <7919f86fb56f5579d79e189ed399cc3a1418b79b.1279658433.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
References: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Stodden <daniel.stodden@citrix.com>

 * Current blkfront_closing is rather a xlvbd_release_gendisk.
   Renamed in preparation of later patches (need the name again).

 * Removed the misleading comment -- this only applied to the backend
   switch handler, and the queue is already flushed btw.

 * Break out the xenbus call, callers know better when to switch
   frontend state.

Signed-off-by: Daniel Stodden <daniel.stodden@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |   91 ++++++++++++++++++++----------------------
 1 files changed, 43 insertions(+), 48 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index c004ff0..7b03b48 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -534,6 +534,39 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 	return err;
 }
 
+static void xlvbd_release_gendisk(struct blkfront_info *info)
+{
+	unsigned int minor, nr_minors;
+	unsigned long flags;
+
+	if (info->rq == NULL)
+		return;
+
+	spin_lock_irqsave(&blkif_io_lock, flags);
+
+	/* No more blkif_request(). */
+	blk_stop_queue(info->rq);
+
+	/* No more gnttab callback work. */
+	gnttab_cancel_free_callback(&info->callback);
+	spin_unlock_irqrestore(&blkif_io_lock, flags);
+
+	/* Flush gnttab callback work. Must be done with no locks held. */
+	flush_scheduled_work();
+
+	del_gendisk(info->gd);
+
+	minor = info->gd->first_minor;
+	nr_minors = info->gd->minors;
+	xlbd_release_minors(minor, nr_minors);
+
+	blk_cleanup_queue(info->rq);
+	info->rq = NULL;
+
+	put_disk(info->gd);
+	info->gd = NULL;
+}
+
 static void kick_pending_request_queues(struct blkfront_info *info)
 {
 	if (!RING_FULL(&info->ring)) {
@@ -995,49 +1028,6 @@ static void blkfront_connect(struct blkfront_info *info)
 }
 
 /**
- * Handle the change of state of the backend to Closing.  We must delete our
- * device-layer structures now, to ensure that writes are flushed through to
- * the backend.  Once is this done, we can switch to Closed in
- * acknowledgement.
- */
-static void blkfront_closing(struct blkfront_info *info)
-{
-	unsigned int minor, nr_minors;
-	unsigned long flags;
-
-
-	if (info->rq == NULL)
-		goto out;
-
-	spin_lock_irqsave(&blkif_io_lock, flags);
-
-	/* No more blkif_request(). */
-	blk_stop_queue(info->rq);
-
-	/* No more gnttab callback work. */
-	gnttab_cancel_free_callback(&info->callback);
-	spin_unlock_irqrestore(&blkif_io_lock, flags);
-
-	/* Flush gnttab callback work. Must be done with no locks held. */
-	flush_scheduled_work();
-
-	minor = info->gd->first_minor;
-	nr_minors = info->gd->minors;
-	del_gendisk(info->gd);
-	xlbd_release_minors(minor, nr_minors);
-
-	blk_cleanup_queue(info->rq);
-	info->rq = NULL;
-
-	put_disk(info->gd);
-	info->gd = NULL;
-
- out:
-	if (info->xbdev)
-		xenbus_frontend_closed(info->xbdev);
-}
-
-/**
  * Callback received when the backend's state changes.
  */
 static void blkback_changed(struct xenbus_device *dev,
@@ -1073,8 +1063,11 @@ static void blkback_changed(struct xenbus_device *dev,
 		if (info->users > 0)
 			xenbus_dev_error(dev, -EBUSY,
 					 "Device in use; refusing to close");
-		else
-			blkfront_closing(info);
+		else {
+			xlvbd_release_gendisk(info);
+			xenbus_frontend_closed(info->xbdev);
+		}
+
 		mutex_unlock(&bd->bd_mutex);
 		bdput(bd);
 		break;
@@ -1125,11 +1118,13 @@ static int blkif_release(struct gendisk *disk, fmode_t mode)
 		struct xenbus_device *dev = info->xbdev;
 
 		if (!dev) {
-			blkfront_closing(info);
+			xlvbd_release_gendisk(info);
 			kfree(info);
 		} else if (xenbus_read_driver_state(dev->otherend)
-			   == XenbusStateClosing && info->is_ready)
-			blkfront_closing(info);
+			   == XenbusStateClosing && info->is_ready) {
+			xlvbd_release_gendisk(info);
+			xenbus_frontend_closed(dev);
+		}
 	}
 	return 0;
 }
-- 
1.7.1.1

