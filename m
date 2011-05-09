Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab1EIWDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:03:12 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54173
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754870Ab1EIVoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:46 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 048/206] Staging: hv: Get rid of the forward declaration of storvsc_get_chs()
Date: Mon,  9 May 2011 14:55:30 -0700
Message-Id: <1304978288-22999-48-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration by moving the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |  164 ++++++++++++++++++-------------------
 1 files changed, 80 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 6f23f52..4c08328 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -381,15 +381,91 @@ static int storvsc_remove(struct hv_device *dev)
 	return 0;
 }
 
+
+static int storvsc_get_chs(struct scsi_device *sdev, struct block_device * bdev,
+			   sector_t capacity, int *info)
+{
+	sector_t total_sectors = capacity;
+	sector_t cylinder_times_heads = 0;
+	sector_t temp = 0;
+
+	int sectors_per_track = 0;
+	int heads = 0;
+	int cylinders = 0;
+	int rem = 0;
+
+	if (total_sectors > (65535 * 16 * 255))
+		total_sectors = (65535 * 16 * 255);
+
+	if (total_sectors >= (65535 * 16 * 63)) {
+		sectors_per_track = 255;
+		heads = 16;
+
+		cylinder_times_heads = total_sectors;
+		/* sector_div stores the quotient in cylinder_times_heads */
+		rem = sector_div(cylinder_times_heads, sectors_per_track);
+	} else {
+		sectors_per_track = 17;
+
+		cylinder_times_heads = total_sectors;
+		/* sector_div stores the quotient in cylinder_times_heads */
+		rem = sector_div(cylinder_times_heads, sectors_per_track);
+
+		temp = cylinder_times_heads + 1023;
+		/* sector_div stores the quotient in temp */
+		rem = sector_div(temp, 1024);
+
+		heads = temp;
+
+		if (heads < 4)
+			heads = 4;
+
+		if (cylinder_times_heads >= (heads * 1024) || (heads > 16)) {
+			sectors_per_track = 31;
+			heads = 16;
+
+			cylinder_times_heads = total_sectors;
+			/*
+			 * sector_div stores the quotient in
+			 * cylinder_times_heads
+			 */
+			rem = sector_div(cylinder_times_heads,
+					 sectors_per_track);
+		}
+
+		if (cylinder_times_heads >= (heads * 1024)) {
+			sectors_per_track = 63;
+			heads = 16;
+
+			cylinder_times_heads = total_sectors;
+			/*
+			 * sector_div stores the quotient in
+			 * cylinder_times_heads
+			 */
+			rem = sector_div(cylinder_times_heads,
+					 sectors_per_track);
+		}
+	}
+
+	temp = cylinder_times_heads;
+	/* sector_div stores the quotient in temp */
+	rem = sector_div(temp, heads);
+	cylinders = temp;
+
+	info[0] = heads;
+	info[1] = sectors_per_track;
+	info[2] = cylinders;
+
+	DPRINT_INFO(STORVSC_DRV, "CHS (%d, %d, %d)", cylinders, heads,
+		    sectors_per_track);
+
+	return 0;
+}
 /* Static decl */
 static int storvsc_probe(struct hv_device *dev);
 static int storvsc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd);
 static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd);
 
-static int storvsc_get_chs(struct scsi_device *sdev, struct block_device *bdev,
-			   sector_t capacity, int *info);
-
-
 static int storvsc_ringbuffer_size = STORVSC_RING_BUFFER_SIZE;
 module_param(storvsc_ringbuffer_size, int, S_IRUGO);
 MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
@@ -867,86 +943,6 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 	return ret;
 }
 
-static int storvsc_get_chs(struct scsi_device *sdev, struct block_device * bdev,
-			   sector_t capacity, int *info)
-{
-	sector_t total_sectors = capacity;
-	sector_t cylinder_times_heads = 0;
-	sector_t temp = 0;
-
-	int sectors_per_track = 0;
-	int heads = 0;
-	int cylinders = 0;
-	int rem = 0;
-
-	if (total_sectors > (65535 * 16 * 255))
-		total_sectors = (65535 * 16 * 255);
-
-	if (total_sectors >= (65535 * 16 * 63)) {
-		sectors_per_track = 255;
-		heads = 16;
-
-		cylinder_times_heads = total_sectors;
-		/* sector_div stores the quotient in cylinder_times_heads */
-		rem = sector_div(cylinder_times_heads, sectors_per_track);
-	} else {
-		sectors_per_track = 17;
-
-		cylinder_times_heads = total_sectors;
-		/* sector_div stores the quotient in cylinder_times_heads */
-		rem = sector_div(cylinder_times_heads, sectors_per_track);
-
-		temp = cylinder_times_heads + 1023;
-		/* sector_div stores the quotient in temp */
-		rem = sector_div(temp, 1024);
-
-		heads = temp;
-
-		if (heads < 4)
-			heads = 4;
-
-		if (cylinder_times_heads >= (heads * 1024) || (heads > 16)) {
-			sectors_per_track = 31;
-			heads = 16;
-
-			cylinder_times_heads = total_sectors;
-			/*
-			 * sector_div stores the quotient in
-			 * cylinder_times_heads
-			 */
-			rem = sector_div(cylinder_times_heads,
-					 sectors_per_track);
-		}
-
-		if (cylinder_times_heads >= (heads * 1024)) {
-			sectors_per_track = 63;
-			heads = 16;
-
-			cylinder_times_heads = total_sectors;
-			/*
-			 * sector_div stores the quotient in
-			 * cylinder_times_heads
-			 */
-			rem = sector_div(cylinder_times_heads,
-					 sectors_per_track);
-		}
-	}
-
-	temp = cylinder_times_heads;
-	/* sector_div stores the quotient in temp */
-	rem = sector_div(temp, heads);
-	cylinders = temp;
-
-	info[0] = heads;
-	info[1] = sectors_per_track;
-	info[2] = cylinders;
-
-	DPRINT_INFO(STORVSC_DRV, "CHS (%d, %d, %d)", cylinders, heads,
-		    sectors_per_track);
-
-    return 0;
-}
-
 static int __init storvsc_init(void)
 {
 	int ret;
-- 
1.7.4.1

