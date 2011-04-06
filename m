Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab1DFX16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 19:27:58 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:39457
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754476Ab1DFX15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 19:27:57 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 05/22] Staging: hv: Get rid of blkvsc_do_read_capacity()
Date: Wed,  6 Apr 2011 16:05:05 -0700
Message-Id: <1302131122-15530-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302131122-15530-1-git-send-email-kys@microsoft.com>
References: <1302131006-15411-1-git-send-email-kys@microsoft.com>
 <1302131122-15530-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a common function for some of the operations on the device,
use that and get rid of the function blkvsc_do_read_capacity().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |  117 +++++++++++++--------------------------
 1 files changed, 39 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 9dbba3c..b2d149d 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -48,6 +48,7 @@ enum blkvsc_device_type {
 
 enum blkvsc_op_type {
 	DO_INQUIRY,
+	DO_CAPACITY,
 };
 
 /*
@@ -406,6 +407,9 @@ static int blkvsc_do_operation(struct block_device_context *blkdev,
 	struct page *page_buf;
 	unsigned char *buf;
 	unsigned char device_type;
+	struct scsi_sense_hdr sense_hdr;
+	struct vmscsi_request *vm_srb;
+
 	int ret = 0;
 
 	blkvsc_req = kmem_cache_zalloc(blkdev->request_pool, GFP_KERNEL);
@@ -418,6 +422,7 @@ static int blkvsc_do_operation(struct block_device_context *blkdev,
 		return -ENOMEM;
 	}
 
+	vm_srb = &blkvsc_req->request.vstor_packet.vm_srb;
 	init_completion(&blkvsc_req->request.wait_event);
 	blkvsc_req->dev = blkdev;
 	blkvsc_req->req = NULL;
@@ -437,6 +442,15 @@ static int blkvsc_do_operation(struct block_device_context *blkdev,
 		blkvsc_req->request.data_buffer.len = 64;
 		break;
 
+	case DO_CAPACITY:
+		blkdev->sector_size = 0;
+		blkdev->capacity = 0;
+		blkdev->media_not_present = 0; /* assume a disk is present */
+
+		blkvsc_req->cmnd[0] = READ_CAPACITY;
+		blkvsc_req->cmd_len = 16;
+		blkvsc_req->request.data_buffer.len = 8;
+		break;
 	default:
 		ret = -EINVAL;
 		goto cleanup;
@@ -446,6 +460,18 @@ static int blkvsc_do_operation(struct block_device_context *blkdev,
 
 	wait_for_completion_interruptible(&blkvsc_req->request.wait_event);
 
+	/* check error */
+	if (vm_srb->scsi_status) {
+		scsi_normalize_sense(blkvsc_req->sense_buffer,
+				     SCSI_SENSE_BUFFERSIZE, &sense_hdr);
+
+		if (sense_hdr.asc == 0x3A)
+			/* Medium not present */
+			blkdev->media_not_present = 1;
+
+		return 0;
+	}
+
 	buf = kmap(page_buf);
 
 	switch (op) {
@@ -465,6 +491,17 @@ static int blkvsc_do_operation(struct block_device_context *blkdev,
 
 		memcpy(blkdev->device_id, &buf[8], blkdev->device_id_len);
 		break;
+
+	case DO_CAPACITY:
+		/* be to le */
+		blkdev->capacity =
+		((buf[0] << 24) | (buf[1] << 16) |
+		(buf[2] << 8) | buf[3]) + 1;
+
+		blkdev->sector_size =
+		(buf[4] << 24) | (buf[5] << 16) |
+		(buf[6] << 8) | buf[7];
+		break;
 	}
 
 cleanup:
@@ -715,82 +752,6 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 }
 
 
-/* Do a scsi READ_CAPACITY cmd here to get the size of the disk */
-static int blkvsc_do_read_capacity(struct block_device_context *blkdev)
-{
-	struct blkvsc_request *blkvsc_req;
-	struct page *page_buf;
-	unsigned char *buf;
-	struct scsi_sense_hdr sense_hdr;
-	struct vmscsi_request *vm_srb;
-
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_read_capacity()\n");
-
-	blkdev->sector_size = 0;
-	blkdev->capacity = 0;
-	blkdev->media_not_present = 0; /* assume a disk is present */
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
-	vm_srb = &blkvsc_req->request.vstor_packet.vm_srb;
-	init_completion(&blkvsc_req->request.wait_event);
-	blkvsc_req->dev = blkdev;
-	blkvsc_req->req = NULL;
-	blkvsc_req->write = 0;
-
-	blkvsc_req->request.data_buffer.pfn_array[0] =
-	page_to_pfn(page_buf);
-	blkvsc_req->request.data_buffer.offset = 0;
-	blkvsc_req->request.data_buffer.len = 8;
-
-	blkvsc_req->cmnd[0] = READ_CAPACITY;
-	blkvsc_req->cmd_len = 16;
-
-	blkvsc_submit_request(blkvsc_req, blkvsc_cmd_completion);
-
-	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete\n",
-		   blkvsc_req);
-
-	wait_for_completion_interruptible(&blkvsc_req->request.wait_event);
-
-	/* check error */
-	if (vm_srb->scsi_status) {
-		scsi_normalize_sense(blkvsc_req->sense_buffer,
-				     SCSI_SENSE_BUFFERSIZE, &sense_hdr);
-
-		if (sense_hdr.asc == 0x3A) {
-			/* Medium not present */
-			blkdev->media_not_present = 1;
-		}
-		return 0;
-	}
-	buf = kmap(page_buf);
-
-	/* be to le */
-	blkdev->capacity = ((buf[0] << 24) | (buf[1] << 16) |
-			    (buf[2] << 8) | buf[3]) + 1;
-	blkdev->sector_size = (buf[4] << 24) | (buf[5] << 16) |
-			      (buf[6] << 8) | buf[7];
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
 static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 {
 	struct blkvsc_request *blkvsc_req;
@@ -874,7 +835,7 @@ static int blkvsc_revalidate_disk(struct gendisk *gd)
 	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
 
 	if (blkdev->device_type == DVD_TYPE) {
-		blkvsc_do_read_capacity(blkdev);
+		blkvsc_do_operation(blkdev, DO_CAPACITY);
 		set_capacity(blkdev->gd, blkdev->capacity *
 			    (blkdev->sector_size/512));
 		blk_queue_logical_block_size(gd->queue, blkdev->sector_size);
@@ -1350,7 +1311,7 @@ static int blkvsc_probe(struct device *device)
 	if (blkdev->device_type == DVD_TYPE) {
 		set_disk_ro(blkdev->gd, 1);
 		blkdev->gd->flags |= GENHD_FL_REMOVABLE;
-		blkvsc_do_read_capacity(blkdev);
+		blkvsc_do_operation(blkdev, DO_CAPACITY);
 	} else {
 		blkvsc_do_read_capacity16(blkdev);
 	}
-- 
1.7.4.1

