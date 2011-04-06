Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab1DFVYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:24:11 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:49955
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756891Ab1DFVYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:24:02 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 15/22] Staging: hv: Get rid of the forward declaration of blkvsc_revalidate_disk()
Date: Wed,  6 Apr 2011 14:35:13 -0700
Message-Id: <1302125720-10808-15-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302125720-10808-1-git-send-email-kys@microsoft.com>
References: <1302125655-10741-1-git-send-email-kys@microsoft.com>
 <1302125720-10808-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of blkvsc_revalidate_disk() by moving
the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 49caad7..35dacf0 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -861,9 +861,23 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 	return 0;
 }
 
+static int blkvsc_revalidate_disk(struct gendisk *gd)
+{
+	struct block_device_context *blkdev = gd->private_data;
+
+	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
+
+	if (blkdev->device_type == DVD_TYPE) {
+		blkvsc_do_read_capacity(blkdev);
+		set_capacity(blkdev->gd, blkdev->capacity *
+			    (blkdev->sector_size/512));
+		blk_queue_logical_block_size(gd->queue, blkdev->sector_size);
+	}
+	return 0;
+}
+
 /* Static decl */
 static int blkvsc_probe(struct device *dev);
-static int blkvsc_revalidate_disk(struct gendisk *gd);
 static void blkvsc_request(struct request_queue *queue);
 static void blkvsc_request_completion(struct hv_storvsc_request *request);
 static int blkvsc_do_request(struct block_device_context *blkdev,
@@ -1513,21 +1527,6 @@ static void blkvsc_request(struct request_queue *queue)
 	}
 }
 
-static int blkvsc_revalidate_disk(struct gendisk *gd)
-{
-	struct block_device_context *blkdev = gd->private_data;
-
-	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
-
-	if (blkdev->device_type == DVD_TYPE) {
-		blkvsc_do_read_capacity(blkdev);
-		set_capacity(blkdev->gd, blkdev->capacity *
-			    (blkdev->sector_size/512));
-		blk_queue_logical_block_size(gd->queue, blkdev->sector_size);
-	}
-	return 0;
-}
-
 static int __init blkvsc_init(void)
 {
 	int ret;
-- 
1.7.4.1

