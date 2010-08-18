Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab0HRENi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 00:13:38 -0400
Received: from mail.lixom.net ([70.86.134.90]:53892 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab0HRENd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 00:13:33 -0400
Date: Tue, 17 Aug 2010 23:13:33 -0500
From: Olof Johansson <olof@lixom.net>
To: linux-mmc@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: make number of mmcblk minors configurable
Message-ID: <20100818041333.GA14149@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old limit of number of minor numbers per mmcblk device was hardcoded
at 8. This isn't enough for some of the more elaborate partitioning
schemes, for example those used by Chrome OS.

Since there might be a bunch of systems out there with static /dev
contents that relies on the old numbering scheme, let's make it a
build-time option with the default set to the previous 8.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/mmc/card/Kconfig |   10 ++++++++++
 drivers/mmc/card/block.c |   20 ++++++++------------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/card/Kconfig b/drivers/mmc/card/Kconfig
index 3f2a912..e939dcf 100644
--- a/drivers/mmc/card/Kconfig
+++ b/drivers/mmc/card/Kconfig
@@ -14,6 +14,16 @@ config MMC_BLOCK
 	  mount the filesystem. Almost everyone wishing MMC support
 	  should say Y or M here.
 
+config MMC_BLOCK_MINORS
+	int "Number of minors per block device"
+	range 4 32
+	default 8
+	help
+	  Number of minors per block device. One is needed for every
+	  partition (plus one for the whole device).
+	  Default is 8 to be backwards compatible with previous
+	  hardcoded device numbering.
+
 config MMC_BLOCK_BOUNCE
 	bool "Use bounce buffer for simple hosts"
 	depends on MMC_BLOCK
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index d545f79..524e232 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -45,13 +45,9 @@
 
 MODULE_ALIAS("mmc:block");
 
-/*
- * max 8 partitions per card
- */
-#define MMC_SHIFT	3
-#define MMC_NUM_MINORS	(256 >> MMC_SHIFT)
+#define MMC_MAX_DEVICES	((255 + CONFIG_MMC_BLOCK_MINORS) / CONFIG_MMC_BLOCK_MINORS)
 
-static DECLARE_BITMAP(dev_use, MMC_NUM_MINORS);
+static DECLARE_BITMAP(dev_use, MMC_MAX_DEVICES);
 
 /*
  * There is one mmc_blk_data per slot.
@@ -88,10 +84,10 @@ static void mmc_blk_put(struct mmc_blk_data *md)
 	md->usage--;
 	if (md->usage == 0) {
 		int devmaj = MAJOR(disk_devt(md->disk));
-		int devidx = MINOR(disk_devt(md->disk)) >> MMC_SHIFT;
+		int devidx = MINOR(disk_devt(md->disk)) / CONFIG_MMC_BLOCK_MINORS;
 
 		if (!devmaj)
-			devidx = md->disk->first_minor >> MMC_SHIFT;
+			devidx = md->disk->first_minor / CONFIG_MMC_BLOCK_MINORS;
 
 		blk_cleanup_queue(md->queue.queue);
 
@@ -567,8 +563,8 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
 	struct mmc_blk_data *md;
 	int devidx, ret;
 
-	devidx = find_first_zero_bit(dev_use, MMC_NUM_MINORS);
-	if (devidx >= MMC_NUM_MINORS)
+	devidx = find_first_zero_bit(dev_use, MMC_MAX_DEVICES);
+	if (devidx >= MMC_MAX_DEVICES)
 		return ERR_PTR(-ENOSPC);
 	__set_bit(devidx, dev_use);
 
@@ -585,7 +581,7 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
 	 */
 	md->read_only = mmc_blk_readonly(card);
 
-	md->disk = alloc_disk(1 << MMC_SHIFT);
+	md->disk = alloc_disk(CONFIG_MMC_BLOCK_MINORS);
 	if (md->disk == NULL) {
 		ret = -ENOMEM;
 		goto err_kfree;
@@ -602,7 +598,7 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
 	md->queue.data = md;
 
 	md->disk->major	= MMC_BLOCK_MAJOR;
-	md->disk->first_minor = devidx << MMC_SHIFT;
+	md->disk->first_minor = devidx * CONFIG_MMC_BLOCK_MINORS;
 	md->disk->fops = &mmc_bdops;
 	md->disk->private_data = md;
 	md->disk->queue = md->queue.queue;
-- 
1.5.6.5

