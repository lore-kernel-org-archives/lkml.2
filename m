Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab1DFVsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:48:00 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:34718
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756922Ab1DFVr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:47:57 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 04/22] Staging: hv: Get rid of the forward declaration of blkvsc_getgeo()
Date: Wed,  6 Apr 2011 14:35:02 -0700
Message-Id: <1302125720-10808-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302125720-10808-1-git-send-email-kys@microsoft.com>
References: <1302125655-10741-1-git-send-email-kys@microsoft.com>
 <1302125720-10808-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of blkvsc_getgeo() by moving the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |  162 +++++++++++++++++++-------------------
 1 files changed, 81 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 173abe3..69048e3 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -275,6 +275,87 @@ static int blkvsc_open(struct block_device *bdev, fmode_t mode)
 	return 0;
 }
 
+
+static int blkvsc_getgeo(struct block_device *bd, struct hd_geometry *hg)
+{
+	sector_t total_sectors = get_capacity(bd->bd_disk);
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
+	hg->heads = heads;
+	hg->sectors = sectors_per_track;
+	hg->cylinders = cylinders;
+
+	DPRINT_INFO(BLKVSC_DRV, "CHS (%d, %d, %d)", cylinders, heads,
+		    sectors_per_track);
+
+	return 0;
+}
+
 /* Static decl */
 static int blkvsc_probe(struct device *dev);
 static int blkvsc_remove(struct device *device);
@@ -282,7 +363,6 @@ static void blkvsc_shutdown(struct device *device);
 
 static int blkvsc_release(struct gendisk *disk, fmode_t mode);
 static int blkvsc_revalidate_disk(struct gendisk *gd);
-static int blkvsc_getgeo(struct block_device *bd, struct hd_geometry *hg);
 static int blkvsc_ioctl(struct block_device *bd, fmode_t mode,
 			unsigned cmd, unsigned long argument);
 static void blkvsc_request(struct request_queue *queue);
@@ -1427,86 +1507,6 @@ static int blkvsc_revalidate_disk(struct gendisk *gd)
 	return 0;
 }
 
-static int blkvsc_getgeo(struct block_device *bd, struct hd_geometry *hg)
-{
-	sector_t total_sectors = get_capacity(bd->bd_disk);
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
-	hg->heads = heads;
-	hg->sectors = sectors_per_track;
-	hg->cylinders = cylinders;
-
-	DPRINT_INFO(BLKVSC_DRV, "CHS (%d, %d, %d)", cylinders, heads,
-		    sectors_per_track);
-
-    return 0;
-}
-
 static int blkvsc_ioctl(struct block_device *bd, fmode_t mode,
 			unsigned cmd, unsigned long argument)
 {
-- 
1.7.4.1

