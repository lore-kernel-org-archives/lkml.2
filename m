Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab1DVWNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 18:13:37 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:46472
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756740Ab1DVWNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 18:13:36 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 21/21] Staging: hv: Get rid of IDE details from blkvsc_drv.c
Date: Fri, 22 Apr 2011 14:55:26 -0700
Message-Id: <1303509326-3094-21-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303509326-3094-1-git-send-email-kys@microsoft.com>
References: <1303509246-3053-1-git-send-email-kys@microsoft.com>
 <1303509326-3094-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now get rid of IDE details from blkvsc_drv.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   55 +++++++++++---------------------------
 drivers/staging/hv/storvsc.c    |   18 ++++++------
 2 files changed, 25 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 3229ebc..acc5435 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -953,11 +953,8 @@ static int blkvsc_probe(struct device *device)
 
 	struct block_device_context *blkdev = NULL;
 	struct storvsc_device_info device_info;
-	int major = 0;
-	int devnum = 0;
+	struct storvsc_major_info major_info;
 	int ret = 0;
-	static int ide0_registered;
-	static int ide1_registered;
 
 
 	blkdev = kzalloc(sizeof(struct block_device_context), GFP_KERNEL);
@@ -994,43 +991,23 @@ static int blkvsc_probe(struct device *device)
 
 	dev_set_drvdata(device, blkdev);
 
-	/* Calculate the major and device num */
-	if (blkdev->path == 0) {
-		major = IDE0_MAJOR;
-		devnum = blkdev->path + blkdev->target;		/* 0 or 1 */
-
-		if (!ide0_registered) {
-			ret = register_blkdev(major, "ide");
-			if (ret != 0) {
-				DPRINT_ERR(BLKVSC_DRV,
-					   "register_blkdev() failed! ret %d",
-					   ret);
-				goto remove;
-			}
+	ret = stor_vsc_get_major_info(&device_info, &major_info);
 
-			ide0_registered = 1;
-		}
-	} else if (blkdev->path == 1) {
-		major = IDE1_MAJOR;
-		devnum = blkdev->path + blkdev->target + 1; /* 2 or 3 */
-
-		if (!ide1_registered) {
-			ret = register_blkdev(major, "ide");
-			if (ret != 0) {
-				DPRINT_ERR(BLKVSC_DRV,
-					   "register_blkdev() failed! ret %d",
-					   ret);
-				goto remove;
-			}
+	if (ret)
+		goto cleanup;
+
+	if (major_info.do_register) {
+		ret = register_blkdev(major_info.major, major_info.devname);
 
-			ide1_registered = 1;
+		if (ret != 0) {
+			DPRINT_ERR(BLKVSC_DRV,
+				   "register_blkdev() failed! ret %d", ret);
+			goto remove;
 		}
-	} else {
-		ret = -1;
-		goto cleanup;
 	}
 
-	DPRINT_INFO(BLKVSC_DRV, "blkvsc registered for major %d!!", major);
+	DPRINT_INFO(BLKVSC_DRV, "blkvsc registered for major %d!!",
+			major_info.major);
 
 	blkdev->gd = alloc_disk(BLKVSC_MINORS);
 	if (!blkdev->gd) {
@@ -1046,8 +1023,8 @@ static int blkvsc_probe(struct device *device)
 	blk_queue_bounce_limit(blkdev->gd->queue, BLK_BOUNCE_ANY);
 	blk_queue_dma_alignment(blkdev->gd->queue, 511);
 
-	blkdev->gd->major = major;
-	if (devnum == 1 || devnum == 3)
+	blkdev->gd->major = major_info.major;
+	if (major_info.index == 1 || major_info.index == 3)
 		blkdev->gd->first_minor = BLKVSC_MINORS;
 	else
 		blkdev->gd->first_minor = 0;
@@ -1055,7 +1032,7 @@ static int blkvsc_probe(struct device *device)
 	blkdev->gd->events = DISK_EVENT_MEDIA_CHANGE;
 	blkdev->gd->private_data = blkdev;
 	blkdev->gd->driverfs_dev = &(blkdev->device_ctx->device);
-	sprintf(blkdev->gd->disk_name, "hd%c", 'a' + devnum);
+	sprintf(blkdev->gd->disk_name, "hd%c", 'a' + major_info.index);
 
 	blkvsc_do_operation(blkdev, DO_INQUIRY);
 	blkvsc_do_operation(blkdev, DO_CAPACITY);
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index e2b3410..85bae5a 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -629,26 +629,26 @@ int stor_vsc_get_major_info(struct storvsc_device_info *device_info,
 
 	if (device_info->path_id) {
 		major_info->major = 22;
-		if (!ide1_registered)
+		if (!ide1_registered) {
 			major_info->do_register = true;
-		else {
-			major_info->do_register = false;
 			ide1_registered = true;
-		}
+		} else
+			major_info->do_register = false;
+
 		if (device_info->target_id)
 			major_info->index = 3;
-		 else
+		else
 			major_info->index = 2;
 
 		return 0;
 	} else {
 		major_info->major = 3;
-		if (!ide0_registered)
+		if (!ide0_registered) {
 			major_info->do_register = true;
-		else {
-			major_info->do_register = false;
 			ide0_registered = true;
-		}
+		} else
+			major_info->do_register = false;
+
 		if (device_info->target_id)
 			major_info->index = 1;
 		else
-- 
1.7.4.1

