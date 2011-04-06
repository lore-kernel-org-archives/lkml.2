Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab1DFWyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:54:09 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:47367
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756442Ab1DFWyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:54:03 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 04/22] Staging: hv: Introduce a common function for issuing commands to the device
Date: Wed,  6 Apr 2011 16:05:04 -0700
Message-Id: <1302131122-15530-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302131122-15530-1-git-send-email-kys@microsoft.com>
References: <1302131006-15411-1-git-send-email-kys@microsoft.com>
 <1302131122-15530-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are multiple functions to either get info about the device
(INQUIRY, CAPACITY etc) or to FLUSH the device cache. The majority of the
code for these functions is identical. Introduce a common function for
doing all these operations.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |  163 ++++++++++++++++++++------------------
 1 files changed, 86 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index f5cc522..9dbba3c 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -46,6 +46,10 @@ enum blkvsc_device_type {
 	DVD_TYPE,
 };
 
+enum blkvsc_op_type {
+	DO_INQUIRY,
+};
+
 /*
  * This request ties the struct request and struct
  * blkvsc_request/hv_storvsc_request together A struct request may be
@@ -394,6 +398,86 @@ static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
 	complete(&blkvsc_req->request.wait_event);
 }
 
+
+static int blkvsc_do_operation(struct block_device_context *blkdev,
+				enum blkvsc_op_type op)
+{
+	struct blkvsc_request *blkvsc_req;
+	struct page *page_buf;
+	unsigned char *buf;
+	unsigned char device_type;
+	int ret = 0;
+
+	blkvsc_req = kmem_cache_zalloc(blkdev->request_pool, GFP_KERNEL);
+	if (!blkvsc_req)
+		return -ENOMEM;
+
+	page_buf = alloc_page(GFP_KERNEL);
+	if (!page_buf) {
+		kmem_cache_free(blkvsc_req->dev->request_pool, blkvsc_req);
+		return -ENOMEM;
+	}
+
+	init_completion(&blkvsc_req->request.wait_event);
+	blkvsc_req->dev = blkdev;
+	blkvsc_req->req = NULL;
+	blkvsc_req->write = 0;
+
+	blkvsc_req->request.data_buffer.pfn_array[0] =
+	page_to_pfn(page_buf);
+	blkvsc_req->request.data_buffer.offset = 0;
+
+	switch (op) {
+	case DO_INQUIRY:
+		blkvsc_req->cmnd[0] = INQUIRY;
+		blkvsc_req->cmnd[1] = 0x1;		/* Get product data */
+		blkvsc_req->cmnd[2] = 0x83;		/* mode page 83 */
+		blkvsc_req->cmnd[4] = 64;
+		blkvsc_req->cmd_len = 6;
+		blkvsc_req->request.data_buffer.len = 64;
+		break;
+
+	default:
+		ret = -EINVAL;
+		goto cleanup;
+	}
+
+	blkvsc_submit_request(blkvsc_req, blkvsc_cmd_completion);
+
+	wait_for_completion_interruptible(&blkvsc_req->request.wait_event);
+
+	buf = kmap(page_buf);
+
+	switch (op) {
+	case DO_INQUIRY:
+		device_type = buf[0] & 0x1F;
+
+		if (device_type == 0x0)
+			blkdev->device_type = HARDDISK_TYPE;
+		 else if (device_type == 0x5)
+			blkdev->device_type = DVD_TYPE;
+		 else
+			blkdev->device_type = UNKNOWN_DEV_TYPE;
+
+		blkdev->device_id_len = buf[7];
+		if (blkdev->device_id_len > 64)
+			blkdev->device_id_len = 64;
+
+		memcpy(blkdev->device_id, &buf[8], blkdev->device_id_len);
+		break;
+	}
+
+cleanup:
+
+	kunmap(page_buf);
+
+	__free_page(page_buf);
+
+	kmem_cache_free(blkvsc_req->dev->request_pool, blkvsc_req);
+
+	return ret;
+}
+
 static int blkvsc_do_flush(struct block_device_context *blkdev)
 {
 	struct blkvsc_request *blkvsc_req;
@@ -799,82 +883,6 @@ static int blkvsc_revalidate_disk(struct gendisk *gd)
 }
 
 
-/* Do a scsi INQUIRY cmd here to get the device type (ie disk or dvd) */
-static int blkvsc_do_inquiry(struct block_device_context *blkdev)
-{
-	struct blkvsc_request *blkvsc_req;
-	struct page *page_buf;
-	unsigned char *buf;
-	unsigned char device_type;
-
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_inquiry()\n");
-
-	blkvsc_req = kmem_cache_zalloc(blkdev->request_pool, GFP_KERNEL);
-	if (!blkvsc_req)
-		return -ENOMEM;
-
-	memset(blkvsc_req, 0, sizeof(struct blkvsc_request));
-	page_buf = alloc_page(GFP_KERNEL);
-	if (!page_buf) {
-		kmem_cache_free(blkvsc_req->dev->request_pool, blkvsc_req);
-		return -ENOMEM;
-	}
-
-	init_completion(&blkvsc_req->request.wait_event);
-	blkvsc_req->dev = blkdev;
-	blkvsc_req->req = NULL;
-	blkvsc_req->write = 0;
-
-	blkvsc_req->request.data_buffer.pfn_array[0] =
-	page_to_pfn(page_buf);
-	blkvsc_req->request.data_buffer.offset = 0;
-	blkvsc_req->request.data_buffer.len = 64;
-
-	blkvsc_req->cmnd[0] = INQUIRY;
-	blkvsc_req->cmnd[1] = 0x1;		/* Get product data */
-	blkvsc_req->cmnd[2] = 0x83;		/* mode page 83 */
-	blkvsc_req->cmnd[4] = 64;
-	blkvsc_req->cmd_len = 6;
-
-	blkvsc_submit_request(blkvsc_req, blkvsc_cmd_completion);
-
-	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete\n",
-		   blkvsc_req);
-
-	wait_for_completion_interruptible(&blkvsc_req->request.wait_event);
-
-	buf = kmap(page_buf);
-
-	/* be to le */
-	device_type = buf[0] & 0x1F;
-
-	if (device_type == 0x0) {
-		blkdev->device_type = HARDDISK_TYPE;
-	} else if (device_type == 0x5) {
-		blkdev->device_type = DVD_TYPE;
-	} else {
-		/* TODO: this is currently unsupported device type */
-		blkdev->device_type = UNKNOWN_DEV_TYPE;
-	}
-
-	DPRINT_DBG(BLKVSC_DRV, "device type %d\n", device_type);
-
-	blkdev->device_id_len = buf[7];
-	if (blkdev->device_id_len > 64)
-		blkdev->device_id_len = 64;
-
-	memcpy(blkdev->device_id, &buf[8], blkdev->device_id_len);
-
-	kunmap(page_buf);
-
-	__free_page(page_buf);
-
-	kmem_cache_free(blkvsc_req->dev->request_pool, blkvsc_req);
-
-	return 0;
-}
-
-
 /*
  * We break the request into 1 or more blkvsc_requests and submit
  * them.  If we cant submit them all, we put them on the
@@ -1127,6 +1135,7 @@ static void blkvsc_request(struct request_queue *queue)
 }
 
 
+
 /* The one and only one */
 static  struct storvsc_driver_object g_blkvsc_drv;
 
@@ -1337,7 +1346,7 @@ static int blkvsc_probe(struct device *device)
 	blkdev->gd->driverfs_dev = &(blkdev->device_ctx->device);
 	sprintf(blkdev->gd->disk_name, "hd%c", 'a' + devnum);
 
-	blkvsc_do_inquiry(blkdev);
+	blkvsc_do_operation(blkdev, DO_INQUIRY);
 	if (blkdev->device_type == DVD_TYPE) {
 		set_disk_ro(blkdev->gd, 1);
 		blkdev->gd->flags |= GENHD_FL_REMOVABLE;
-- 
1.7.4.1

