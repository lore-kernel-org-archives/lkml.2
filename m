Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab1DFVYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:24:15 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:49979
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756900Ab1DFVYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:24:03 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 16/22] Staging: hv: Get rid of the forward declaration for blkvsc_do_inquiry()
Date: Wed,  6 Apr 2011 14:35:14 -0700
Message-Id: <1302125720-10808-16-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302125720-10808-1-git-send-email-kys@microsoft.com>
References: <1302125655-10741-1-git-send-email-kys@microsoft.com>
 <1302125720-10808-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration for blkvsc_do_inquiry() by moving the code
around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |  158 +++++++++++++++++++-------------------
 1 files changed, 79 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 35dacf0..f7bf42f 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -876,13 +876,91 @@ static int blkvsc_revalidate_disk(struct gendisk *gd)
 	return 0;
 }
 
+
+/* Do a scsi INQUIRY cmd here to get the device type (ie disk or dvd) */
+static int blkvsc_do_inquiry(struct block_device_context *blkdev)
+{
+	struct blkvsc_request *blkvsc_req;
+	struct page *page_buf;
+	unsigned char *buf;
+	unsigned char device_type;
+
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_inquiry()\n");
+
+	blkvsc_req = kmem_cache_zalloc(blkdev->request_pool, GFP_KERNEL);
+	if (!blkvsc_req)
+		return -ENOMEM;
+
+	memset(blkvsc_req, 0, sizeof(struct blkvsc_request));
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
+	blkvsc_req->request.data_buffer.len = 64;
+
+	blkvsc_req->cmnd[0] = INQUIRY;
+	blkvsc_req->cmnd[1] = 0x1;		/* Get product data */
+	blkvsc_req->cmnd[2] = 0x83;		/* mode page 83 */
+	blkvsc_req->cmnd[4] = 64;
+	blkvsc_req->cmd_len = 6;
+
+	blkvsc_submit_request(blkvsc_req, blkvsc_cmd_completion);
+
+	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete\n",
+		   blkvsc_req);
+
+	wait_for_completion_interruptible(&blkvsc_req->request.wait_event);
+
+	buf = kmap(page_buf);
+
+	/* print_hex_dump_bytes("", DUMP_PREFIX_NONE, buf, 64); */
+	/* be to le */
+	device_type = buf[0] & 0x1F;
+
+	if (device_type == 0x0) {
+		blkdev->device_type = HARDDISK_TYPE;
+	} else if (device_type == 0x5) {
+		blkdev->device_type = DVD_TYPE;
+	} else {
+		/* TODO: this is currently unsupported device type */
+		blkdev->device_type = UNKNOWN_DEV_TYPE;
+	}
+
+	DPRINT_DBG(BLKVSC_DRV, "device type %d\n", device_type);
+
+	blkdev->device_id_len = buf[7];
+	if (blkdev->device_id_len > 64)
+		blkdev->device_id_len = 64;
+
+	memcpy(blkdev->device_id, &buf[8], blkdev->device_id_len);
+	/* printk_hex_dump_bytes("", DUMP_PREFIX_NONE, blkdev->device_id,
+	 * blkdev->device_id_len); */
+
+	kunmap(page_buf);
+
+	__free_page(page_buf);
+
+	kmem_cache_free(blkvsc_req->dev->request_pool, blkvsc_req);
+
+	return 0;
+}
+
 /* Static decl */
 static int blkvsc_probe(struct device *dev);
 static void blkvsc_request(struct request_queue *queue);
 static void blkvsc_request_completion(struct hv_storvsc_request *request);
 static int blkvsc_do_request(struct block_device_context *blkdev,
 			     struct request *req);
-static int blkvsc_do_inquiry(struct block_device_context *blkdev);
 static int blkvsc_do_pending_reqs(struct block_device_context *blkdev);
 
 static int blkvsc_ringbuffer_size = BLKVSC_RING_BUFFER_SIZE;
@@ -1138,84 +1216,6 @@ Cleanup:
 	return ret;
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
-	/* print_hex_dump_bytes("", DUMP_PREFIX_NONE, buf, 64); */
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
-	/* printk_hex_dump_bytes("", DUMP_PREFIX_NONE, blkdev->device_id,
-	 * blkdev->device_id_len); */
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
 /*
  * We break the request into 1 or more blkvsc_requests and submit
  * them.  If we cant submit them all, we put them on the
-- 
1.7.4.1

