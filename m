Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab0HZSuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:50:15 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:40525 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab0HZSuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:50:12 -0400
Subject: [PATCH 10/13] cciss: factor out cciss_getluninfo
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Thu, 26 Aug 2010 13:56:20 -0500
Message-ID: <20100826185620.9067.43001.stgit@beardog.cce.hp.com>
In-Reply-To: <20100826185315.9067.25060.stgit@beardog.cce.hp.com>
References: <20100826185315.9067.25060.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6e915de..3f24450 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1384,12 +1384,27 @@ static int cciss_getdrivver(ctlr_info_t *h, void __user *argp)
 	return 0;
 }
 
+static int cciss_getluninfo(ctlr_info_t *h,
+	struct gendisk *disk, void __user *argp)
+{
+	LogvolInfo_struct luninfo;
+	drive_info_struct *drv = get_drv(disk);
+
+	if (!argp)
+		return -EINVAL;
+	memcpy(&luninfo.LunID, drv->LunID, sizeof(luninfo.LunID));
+	luninfo.num_opens = drv->usage_count;
+	luninfo.num_parts = 0;
+	if (copy_to_user(argp, &luninfo, sizeof(LogvolInfo_struct)))
+		return -EFAULT;
+	return 0;
+}
+
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	unsigned int cmd, unsigned long arg)
 {
 	struct gendisk *disk = bdev->bd_disk;
 	ctlr_info_t *h = get_host(disk);
-	drive_info_struct *drv = get_drv(disk);
 	void __user *argp = (void __user *)arg;
 
 	dev_dbg(&h->pdev->dev, "cciss_ioctl: Called with cmd=%x %lx\n",
@@ -1417,19 +1432,8 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_REGNEWD:
 	case CCISS_REVALIDVOLS:
 		return rebuild_lun_table(h, 0, 1);
-
-	case CCISS_GETLUNINFO:{
-			LogvolInfo_struct luninfo;
-
-			memcpy(&luninfo.LunID, drv->LunID,
-				sizeof(luninfo.LunID));
-			luninfo.num_opens = drv->usage_count;
-			luninfo.num_parts = 0;
-			if (copy_to_user(argp, &luninfo,
-					 sizeof(LogvolInfo_struct)))
-				return -EFAULT;
-			return 0;
-		}
+	case CCISS_GETLUNINFO:
+		return cciss_getluninfo(h, disk, argp);
 	case CCISS_PASSTHRU:
 		{
 			IOCTL_Command_struct iocommand;

