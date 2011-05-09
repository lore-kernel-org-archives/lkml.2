Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab1EIV7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:59:32 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47524
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754950Ab1EIVos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:48 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 066/206] Staging: hv: Simplify the code for getting the drive parameters
Date: Mon,  9 May 2011 14:55:48 -0700
Message-Id: <1304978288-22999-66-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are making up the drive parameters; simplify the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   84 +++++++-------------------------------
 1 files changed, 15 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index caa1f36..5624d26 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -381,79 +381,25 @@ static int storvsc_remove(struct hv_device *dev)
 static int storvsc_get_chs(struct scsi_device *sdev, struct block_device * bdev,
 			   sector_t capacity, int *info)
 {
-	sector_t total_sectors = capacity;
-	sector_t cylinder_times_heads = 0;
-	sector_t temp = 0;
+	sector_t nsect = capacity;
+	sector_t cylinders = nsect;
+	int heads, sectors_pt;
 
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
+	/*
+	 * We are making up these values; let us keep it simple.
+	 */
+	heads = 0xff;
+	sectors_pt = 0x3f;      /* Sectors per track */
+	sector_div(cylinders, heads * sectors_pt);
+	if ((sector_t)(cylinders + 1) * heads * sectors_pt < nsect)
+		cylinders = 0xffff;
 
 	info[0] = heads;
-	info[1] = sectors_per_track;
-	info[2] = cylinders;
+	info[1] = sectors_pt;
+	info[2] = (int)cylinders;
 
-	DPRINT_INFO(STORVSC_DRV, "CHS (%d, %d, %d)", cylinders, heads,
-		    sectors_per_track);
+	DPRINT_INFO(STORVSC_DRV, "CHS (%d, %d, %d)", (int)cylinders, heads,
+			sectors_pt);
 
 	return 0;
 }
-- 
1.7.4.1

