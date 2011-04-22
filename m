Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab1DVVY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:24:27 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:52007
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755580Ab1DVVXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:23:36 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 09/18] Staging: hv: Get rid of the forward declaration for blkvsc_do_read_capacity()
Date: Fri, 22 Apr 2011 14:13:30 -0700
Message-Id: <1303506819-1913-9-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303506819-1913-1-git-send-email-kys@microsoft.com>
References: <1303506780-1872-1-git-send-email-kys@microsoft.com>
 <1303506819-1913-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration for blkvsc_do_read_capacity() by moving
the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |  152 +++++++++++++++++++-------------------
 1 files changed, 76 insertions(+), 76 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index d863dbd..21be2ab 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -693,6 +693,82 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 	return 0;
 }
 
+
+/* Do a scsi READ_CAPACITY cmd here to get the size of the disk */
+static int blkvsc_do_read_capacity(struct block_device_context *blkdev)
+{
+	struct blkvsc_request *blkvsc_req;
+	struct page *page_buf;
+	unsigned char *buf;
+	struct scsi_sense_hdr sense_hdr;
+	struct vmscsi_request *vm_srb;
+
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_read_capacity()\n");
+
+	blkdev->sector_size = 0;
+	blkdev->capacity = 0;
+	blkdev->media_not_present = 0; /* assume a disk is present */
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
+	vm_srb = &blkvsc_req->request.vstor_packet.vm_srb;
+	init_completion(&blkvsc_req->request.wait_event);
+	blkvsc_req->dev = blkdev;
+	blkvsc_req->req = NULL;
+	blkvsc_req->write = 0;
+
+	blkvsc_req->request.data_buffer.pfn_array[0] =
+	page_to_pfn(page_buf);
+	blkvsc_req->request.data_buffer.offset = 0;
+	blkvsc_req->request.data_buffer.len = 8;
+
+	blkvsc_req->cmnd[0] = READ_CAPACITY;
+	blkvsc_req->cmd_len = 16;
+
+	blkvsc_submit_request(blkvsc_req, blkvsc_cmd_completion);
+
+	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete\n",
+		   blkvsc_req);
+
+	wait_for_completion_interruptible(&blkvsc_req->request.wait_event);
+
+	/* check error */
+	if (vm_srb->scsi_status) {
+		scsi_normalize_sense(blkvsc_req->sense_buffer,
+				     SCSI_SENSE_BUFFERSIZE, &sense_hdr);
+
+		if (sense_hdr.asc == 0x3A) {
+			/* Medium not present */
+			blkdev->media_not_present = 1;
+		}
+		return 0;
+	}
+	buf = kmap(page_buf);
+
+	/* be to le */
+	blkdev->capacity = ((buf[0] << 24) | (buf[1] << 16) |
+			    (buf[2] << 8) | buf[3]) + 1;
+	blkdev->sector_size = (buf[4] << 24) | (buf[5] << 16) |
+			      (buf[6] << 8) | buf[7];
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
 static int blkvsc_revalidate_disk(struct gendisk *gd);
@@ -701,7 +777,6 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request);
 static int blkvsc_do_request(struct block_device_context *blkdev,
 			     struct request *req);
 static int blkvsc_do_inquiry(struct block_device_context *blkdev);
-static int blkvsc_do_read_capacity(struct block_device_context *blkdev);
 static int blkvsc_do_read_capacity16(struct block_device_context *blkdev);
 static int blkvsc_do_pending_reqs(struct block_device_context *blkdev);
 
@@ -1035,81 +1110,6 @@ static int blkvsc_do_inquiry(struct block_device_context *blkdev)
 	return 0;
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
 static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 {
 	struct blkvsc_request *blkvsc_req;
-- 
1.7.4.1

