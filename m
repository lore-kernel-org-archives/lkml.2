Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab1DVVna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:43:30 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:47501
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756782Ab1DVVnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:43:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 02/21] Staging: hv: Simplify the code for blkvsc_getgeo()
Date: Fri, 22 Apr 2011 14:55:07 -0700
Message-Id: <1303509326-3094-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303509326-3094-1-git-send-email-kys@microsoft.com>
References: <1303509246-3053-1-git-send-email-kys@microsoft.com>
 <1303509326-3094-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are making up the geometry anyway, keep it simple.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   84 +++++---------------------------------
 1 files changed, 11 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 3b47495..f5cc522 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -278,82 +278,20 @@ static int blkvsc_open(struct block_device *bdev, fmode_t mode)
 
 static int blkvsc_getgeo(struct block_device *bd, struct hd_geometry *hg)
 {
-	sector_t total_sectors = get_capacity(bd->bd_disk);
-	sector_t cylinder_times_heads = 0;
-	sector_t temp = 0;
+	sector_t nsect = get_capacity(bd->bd_disk);
+	sector_t cylinders = nsect;
 
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
+	/*
+	 * We are making up these values; let us keep it simple.
+	 */
+	hg->heads = 0xff;
+	hg->sectors = 0x3f;
+	sector_div(cylinders, hg->heads * hg->sectors);
 	hg->cylinders = cylinders;
-
-	DPRINT_INFO(BLKVSC_DRV, "CHS (%d, %d, %d)", cylinders, heads,
-		    sectors_per_track);
-
+	if ((sector_t)(hg->cylinders + 1) * hg->heads * hg->sectors < nsect)
+		hg->cylinders = 0xffff;
 	return 0;
+
 }
 
 
-- 
1.7.4.1

