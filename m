Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716Ab0GTUnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:43:24 -0400
Received: from claw.goop.org ([74.207.240.146]:50943 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761599Ab0GTUmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:50 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 13/16] blkfront: Fix blkfront backend switch race (bdev release)
Date: Tue, 20 Jul 2010 13:42:21 -0700
Message-Id: <1e649866f28507620da7cbaf24f46c208f804ada.1279658433.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
References: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Stodden <daniel.stodden@citrix.com>

We cannot read backend state within bdev operations, because it risks
grabbing the state change before xenbus gets to do it.

Fixed by tracking deferral with a frontend switch to Closing. State
exposure isn't strictly necessary, but the backends won't mind.

For a 'clean' deferral this seems actually a more decent protocol than
raising errors.

Signed-off-by: Daniel Stodden <daniel.stodden@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |   46 ++++++++++++++++++++++++++++-------------
 1 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 974d59a..214c92e 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1144,22 +1144,38 @@ static int blkif_open(struct block_device *bdev, fmode_t mode)
 static int blkif_release(struct gendisk *disk, fmode_t mode)
 {
 	struct blkfront_info *info = disk->private_data;
-	info->users--;
-	if (info->users == 0) {
-		/* Check whether we have been instructed to close.  We will
-		   have ignored this request initially, as the device was
-		   still mounted. */
-		struct xenbus_device *dev = info->xbdev;
-
-		if (!dev) {
-			xlvbd_release_gendisk(info);
-			kfree(info);
-		} else if (xenbus_read_driver_state(dev->otherend)
-			   == XenbusStateClosing && info->is_ready) {
-			xlvbd_release_gendisk(info);
-			xenbus_frontend_closed(dev);
-		}
+	struct block_device *bdev;
+	struct xenbus_device *xbdev;
+
+	if (--info->users)
+		return 0;
+
+	bdev = bdget_disk(disk, 0);
+	bdput(bdev);
+
+	/*
+	 * Check if we have been instructed to close. We will have
+	 * deferred this request, because the bdev was still open.
+	 */
+
+	mutex_lock(&info->mutex);
+	xbdev = info->xbdev;
+
+	if (xbdev && xbdev->state == XenbusStateClosing) {
+		/* pending switch to state closed */
+		xlvbd_release_gendisk(info);
+		xenbus_frontend_closed(info->xbdev);
 	}
+
+	mutex_unlock(&info->mutex);
+
+	if (!xbdev) {
+		/* sudden device removal */
+		xlvbd_release_gendisk(info);
+		disk->private_data = NULL;
+		kfree(info);
+	}
+
 	return 0;
 }
 
-- 
1.7.1.1

