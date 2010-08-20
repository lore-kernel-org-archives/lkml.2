Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab0HTBCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:02:45 -0400
Received: from mail.lixom.net ([70.86.134.90]:50673 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab0HTBCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:02:43 -0400
Date: Thu, 19 Aug 2010 20:02:42 -0500
From: Olof Johansson <olof@lixom.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] mmc: add config and runtime option for number of mmcblk
	minors
Message-ID: <20100820010242.GA29588@lixom.net>
References: <20100818041333.GA14149@lixom.net> <20100818171636.0625b668.akpm@linux-foundation.org> <20100819032230.GA21980@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819032230.GA21980@lixom.net>
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

Also provide a boot/modprobe-time parameter to override the config
default: mmcblk.perdev_minors.

Signed-off-by: Olof Johansson <olof@lixom.net>

---

Changes since v1:
	* Runtime override of config default
	* Better help text
	* DIV_ROUND_UP for max_devices calculation
	* Clarify mmcblk device count limitations

 drivers/mmc/card/Kconfig |   17 +++++++++++++++++
 drivers/mmc/card/block.c |   43 +++++++++++++++++++++++++++++++------------
 2 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/card/Kconfig b/drivers/mmc/card/Kconfig
index 3f2a912..57e4416 100644
--- a/drivers/mmc/card/Kconfig
+++ b/drivers/mmc/card/Kconfig
@@ -14,6 +14,23 @@ config MMC_BLOCK
 	  mount the filesystem. Almost everyone wishing MMC support
 	  should say Y or M here.
 
+config MMC_BLOCK_MINORS
+	int "Number of minors per block device"
+	range 4 256
+	default 8
+	help
+	  Number of minors per block device. One is needed for every
+	  partition on the disk (plus one for the whole disk).
+
+	  Number of total MMC minors available is 256, so your number
+	  of supported block devices will be limited to 256 divided
+	  by this number.
+
+	  Default is 8 to be backwards compatible with previous
+	  hardwired device numbering.
+
+	  If unsure, say 8 here.
+
 config MMC_BLOCK_BOUNCE
 	bool "Use bounce buffer for simple hosts"
 	depends on MMC_BLOCK
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index cb9fbc8..143b23e 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -43,14 +43,26 @@
 #include "queue.h"
 
 MODULE_ALIAS("mmc:block");
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "mmcblk."
 
-/*
- * max 8 partitions per card
+
+/* 
+ * The defaults come from config options but can be overriden by module
+ * or bootarg options.
+ */
+static int perdev_minors = CONFIG_MMC_BLOCK_MINORS;
+
+/* 
+ * We've only got one major, so number of mmcblk devices is
+ * limited to 256 / number of minors per device.
  */
-#define MMC_SHIFT	3
-#define MMC_NUM_MINORS	(256 >> MMC_SHIFT)
+static int max_devices = DIV_ROUND_UP(256, CONFIG_MMC_BLOCK_MINORS);
 
-static DECLARE_BITMAP(dev_use, MMC_NUM_MINORS);
+/* 256 minors, so at most 256 separate devices */
+static DECLARE_BITMAP(dev_use, 256);
 
 /*
  * There is one mmc_blk_data per slot.
@@ -66,6 +78,9 @@ struct mmc_blk_data {
 
 static DEFINE_MUTEX(open_lock);
 
+module_param(perdev_minors, int, 0644);
+MODULE_PARM_DESC(perdev_minors, "Minors numbers to allocate per device");
+
 static struct mmc_blk_data *mmc_blk_get(struct gendisk *disk)
 {
 	struct mmc_blk_data *md;
@@ -87,10 +102,10 @@ static void mmc_blk_put(struct mmc_blk_data *md)
 	md->usage--;
 	if (md->usage == 0) {
 		int devmaj = MAJOR(disk_devt(md->disk));
-		int devidx = MINOR(disk_devt(md->disk)) >> MMC_SHIFT;
+		int devidx = MINOR(disk_devt(md->disk)) / perdev_minors;
 
 		if (!devmaj)
-			devidx = md->disk->first_minor >> MMC_SHIFT;
+			devidx = md->disk->first_minor / perdev_minors;
 
 		blk_cleanup_queue(md->queue.queue);
 
@@ -482,8 +497,8 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
 	struct mmc_blk_data *md;
 	int devidx, ret;
 
-	devidx = find_first_zero_bit(dev_use, MMC_NUM_MINORS);
-	if (devidx >= MMC_NUM_MINORS)
+	devidx = find_first_zero_bit(dev_use, max_devices);
+	if (devidx >= max_devices)
 		return ERR_PTR(-ENOSPC);
 	__set_bit(devidx, dev_use);
 
@@ -500,7 +515,7 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
 	 */
 	md->read_only = mmc_blk_readonly(card);
 
-	md->disk = alloc_disk(1 << MMC_SHIFT);
+	md->disk = alloc_disk(perdev_minors);
 	if (md->disk == NULL) {
 		ret = -ENOMEM;
 		goto err_kfree;
@@ -517,7 +532,7 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
 	md->queue.data = md;
 
 	md->disk->major	= MMC_BLOCK_MAJOR;
-	md->disk->first_minor = devidx << MMC_SHIFT;
+	md->disk->first_minor = devidx * perdev_minors;
 	md->disk->fops = &mmc_bdops;
 	md->disk->private_data = md;
 	md->disk->queue = md->queue.queue;
@@ -593,7 +608,6 @@ static int mmc_blk_probe(struct mmc_card *card)
 {
 	struct mmc_blk_data *md;
 	int err;
-
 	char cap_str[10];
 
 	/*
@@ -683,6 +697,11 @@ static int __init mmc_blk_init(void)
 {
 	int res;
 
+	if (perdev_minors != CONFIG_MMC_BLOCK_MINORS) {
+		pr_info("mmcblk: using %d minors per device\n", perdev_minors);
+		max_devices = DIV_ROUND_UP(256, perdev_minors);
+	}
+
 	res = register_blkdev(MMC_BLOCK_MAJOR, "mmc");
 	if (res)
 		goto out;
-- 
1.5.6.5

