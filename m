Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab1DVVnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:43:10 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42305
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756444Ab1DVVnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:43:07 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 07/21] Staging: hv: Get rid of the state media_not_present
Date: Fri, 22 Apr 2011 14:55:12 -0700
Message-Id: <1303509326-3094-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303509326-3094-1-git-send-email-kys@microsoft.com>
References: <1303509246-3053-1-git-send-email-kys@microsoft.com>
 <1303509326-3094-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block driver in Hyper-V does not handle removable media, get rid of the
media_not_present state.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index a7ae437..4c248b7 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -103,7 +103,6 @@ struct block_device_context {
 	unsigned int device_id_len;
 	int num_outstanding_reqs;
 	int shutting_down;
-	int media_not_present;
 	unsigned int sector_size;
 	sector_t capacity;
 	unsigned int port;
@@ -446,7 +445,6 @@ static int blkvsc_do_operation(struct block_device_context *blkdev,
 	case DO_CAPACITY:
 		blkdev->sector_size = 0;
 		blkdev->capacity = 0;
-		blkdev->media_not_present = 0; /* assume a disk is present */
 
 		blkvsc_req->cmnd[0] = READ_CAPACITY;
 		blkvsc_req->cmd_len = 16;
@@ -473,10 +471,6 @@ static int blkvsc_do_operation(struct block_device_context *blkdev,
 		scsi_normalize_sense(blkvsc_req->sense_buffer,
 				     SCSI_SENSE_BUFFERSIZE, &sense_hdr);
 
-		if (sense_hdr.asc == 0x3A)
-			/* Medium not present */
-			blkdev->media_not_present = 1;
-
 		return 0;
 	}
 
@@ -964,8 +958,7 @@ static void blkvsc_request(struct request_queue *queue)
 		DPRINT_DBG(BLKVSC_DRV, "- req %p\n", req);
 
 		blkdev = req->rq_disk->private_data;
-		if (blkdev->shutting_down || req->cmd_type != REQ_TYPE_FS ||
-		    blkdev->media_not_present) {
+		if (blkdev->shutting_down || req->cmd_type != REQ_TYPE_FS) {
 			__blk_end_request_cur(req, 0);
 			continue;
 		}
-- 
1.7.4.1

