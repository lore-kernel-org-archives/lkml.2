Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab1DFVYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:24:05 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:49927
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756775Ab1DFVYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:24:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 05/22] Staging: hv: Get rid of the forward declaration of blkvsc_init_rw()
Date: Wed,  6 Apr 2011 14:35:03 -0700
Message-Id: <1302125720-10808-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302125720-10808-1-git-send-email-kys@microsoft.com>
References: <1302125655-10741-1-git-send-email-kys@microsoft.com>
 <1302125720-10808-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of blkvsc_init_rw() by moving the
code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |  117 ++++++++++++++++++++-------------------
 1 files changed, 59 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 69048e3..5f14bb6 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -356,6 +356,65 @@ static int blkvsc_getgeo(struct block_device *bd, struct hd_geometry *hg)
 	return 0;
 }
 
+
+static void blkvsc_init_rw(struct blkvsc_request *blkvsc_req)
+{
+	/* ASSERT(blkvsc_req->req); */
+	/* ASSERT(blkvsc_req->sector_count <=
+	   (MAX_MULTIPAGE_BUFFER_COUNT*8)); */
+
+	blkvsc_req->cmd_len = 16;
+
+	if (blkvsc_req->sector_start > 0xffffffff) {
+		if (rq_data_dir(blkvsc_req->req)) {
+			blkvsc_req->write = 1;
+			blkvsc_req->cmnd[0] = WRITE_16;
+		} else {
+			blkvsc_req->write = 0;
+			blkvsc_req->cmnd[0] = READ_16;
+		}
+
+		blkvsc_req->cmnd[1] |=
+			(blkvsc_req->req->cmd_flags & REQ_FUA) ? 0x8 : 0;
+
+		*(unsigned long long *)&blkvsc_req->cmnd[2] =
+				cpu_to_be64(blkvsc_req->sector_start);
+		*(unsigned int *)&blkvsc_req->cmnd[10] =
+				cpu_to_be32(blkvsc_req->sector_count);
+	} else if ((blkvsc_req->sector_count > 0xff) ||
+		   (blkvsc_req->sector_start > 0x1fffff)) {
+		if (rq_data_dir(blkvsc_req->req)) {
+			blkvsc_req->write = 1;
+			blkvsc_req->cmnd[0] = WRITE_10;
+		} else {
+			blkvsc_req->write = 0;
+			blkvsc_req->cmnd[0] = READ_10;
+		}
+
+		blkvsc_req->cmnd[1] |=
+			(blkvsc_req->req->cmd_flags & REQ_FUA) ? 0x8 : 0;
+
+		*(unsigned int *)&blkvsc_req->cmnd[2] =
+				cpu_to_be32(blkvsc_req->sector_start);
+		*(unsigned short *)&blkvsc_req->cmnd[7] =
+				cpu_to_be16(blkvsc_req->sector_count);
+	} else {
+		if (rq_data_dir(blkvsc_req->req)) {
+			blkvsc_req->write = 1;
+			blkvsc_req->cmnd[0] = WRITE_6;
+		} else {
+			blkvsc_req->write = 0;
+			blkvsc_req->cmnd[0] = READ_6;
+		}
+
+		*(unsigned int *)&blkvsc_req->cmnd[1] =
+				cpu_to_be32(blkvsc_req->sector_start) >> 8;
+		blkvsc_req->cmnd[1] &= 0x1f;
+		blkvsc_req->cmnd[4] = (unsigned char)blkvsc_req->sector_count;
+	}
+}
+
+
 /* Static decl */
 static int blkvsc_probe(struct device *dev);
 static int blkvsc_remove(struct device *device);
@@ -369,7 +428,6 @@ static void blkvsc_request(struct request_queue *queue);
 static void blkvsc_request_completion(struct hv_storvsc_request *request);
 static int blkvsc_do_request(struct block_device_context *blkdev,
 			     struct request *req);
-static void blkvsc_init_rw(struct blkvsc_request *blkvsc_req);
 static void blkvsc_cmd_completion(struct hv_storvsc_request *request);
 static int blkvsc_do_inquiry(struct block_device_context *blkdev);
 static int blkvsc_do_read_capacity(struct block_device_context *blkdev);
@@ -1000,63 +1058,6 @@ static int blkvsc_remove(struct device *device)
 	return ret;
 }
 
-static void blkvsc_init_rw(struct blkvsc_request *blkvsc_req)
-{
-	/* ASSERT(blkvsc_req->req); */
-	/* ASSERT(blkvsc_req->sector_count <= (MAX_MULTIPAGE_BUFFER_COUNT*8)); */
-
-	blkvsc_req->cmd_len = 16;
-
-	if (blkvsc_req->sector_start > 0xffffffff) {
-		if (rq_data_dir(blkvsc_req->req)) {
-			blkvsc_req->write = 1;
-			blkvsc_req->cmnd[0] = WRITE_16;
-		} else {
-			blkvsc_req->write = 0;
-			blkvsc_req->cmnd[0] = READ_16;
-		}
-
-		blkvsc_req->cmnd[1] |=
-			(blkvsc_req->req->cmd_flags & REQ_FUA) ? 0x8 : 0;
-
-		*(unsigned long long *)&blkvsc_req->cmnd[2] =
-				cpu_to_be64(blkvsc_req->sector_start);
-		*(unsigned int *)&blkvsc_req->cmnd[10] =
-				cpu_to_be32(blkvsc_req->sector_count);
-	} else if ((blkvsc_req->sector_count > 0xff) ||
-		   (blkvsc_req->sector_start > 0x1fffff)) {
-		if (rq_data_dir(blkvsc_req->req)) {
-			blkvsc_req->write = 1;
-			blkvsc_req->cmnd[0] = WRITE_10;
-		} else {
-			blkvsc_req->write = 0;
-			blkvsc_req->cmnd[0] = READ_10;
-		}
-
-		blkvsc_req->cmnd[1] |=
-			(blkvsc_req->req->cmd_flags & REQ_FUA) ? 0x8 : 0;
-
-		*(unsigned int *)&blkvsc_req->cmnd[2] =
-				cpu_to_be32(blkvsc_req->sector_start);
-		*(unsigned short *)&blkvsc_req->cmnd[7] =
-				cpu_to_be16(blkvsc_req->sector_count);
-	} else {
-		if (rq_data_dir(blkvsc_req->req)) {
-			blkvsc_req->write = 1;
-			blkvsc_req->cmnd[0] = WRITE_6;
-		} else {
-			blkvsc_req->write = 0;
-			blkvsc_req->cmnd[0] = READ_6;
-		}
-
-		*(unsigned int *)&blkvsc_req->cmnd[1] =
-				cpu_to_be32(blkvsc_req->sector_start) >> 8;
-		blkvsc_req->cmnd[1] &= 0x1f;
-		blkvsc_req->cmnd[4] = (unsigned char)blkvsc_req->sector_count;
-	}
-}
-
-
 /*
  * We break the request into 1 or more blkvsc_requests and submit
  * them.  If we cant submit them all, we put them on the
-- 
1.7.4.1

