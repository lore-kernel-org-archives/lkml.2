Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab2JTScx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 14:32:53 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:60878 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab2JTSc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 14:32:27 -0400
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: linux-kernel@vger.kernel.org
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: [PATCH 1/4] brd: change module parameters rd_size, rd_nr, max_part to unsigned
Date: Sat, 20 Oct 2012 20:32:20 +0200
Message-Id: <1350757943-24981-2-git-send-email-hannes@stressinduktion.org>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1350757943-24981-1-git-send-email-hannes@stressinduktion.org>
References: <1350757943-24981-1-git-send-email-hannes@stressinduktion.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All parameters of the module brd are now converted to unsigneds. This
saves some less-than-zero checks.

As the external user of rd_size (arch/arm/kernel/setup.c:setup_ramdisk)
seems to be gone in v3.7-rc1 this variable can later be declared static.

While at it, move the (perhaps automatically) placed brd_mutex out of
the silly constellation between function prelude comment and function.

Cc: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 drivers/block/brd.c | 44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 531ceb3..c4965f5 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -48,10 +48,11 @@ struct brd_device {
 	struct radix_tree_root	brd_pages;
 };
 
+static DEFINE_MUTEX(brd_mutex);
+
 /*
  * Look up and return a brd's page for a given sector.
  */
-static DEFINE_MUTEX(brd_mutex);
 static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
 {
 	pgoff_t idx;
@@ -429,15 +430,15 @@ static const struct block_device_operations brd_fops = {
 /*
  * And now the modules code and kernel interface.
  */
-static int rd_nr;
-int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
-static int max_part;
-static int part_shift;
-module_param(rd_nr, int, S_IRUGO);
+static unsigned int rd_nr;
+unsigned int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
+static unsigned int max_part;
+static unsigned int part_shift;
+module_param(rd_nr, uint, S_IRUGO);
 MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
-module_param(rd_size, int, S_IRUGO);
+module_param(rd_size, uint, S_IRUGO);
 MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
-module_param(max_part, int, S_IRUGO);
+module_param(max_part, uint, S_IRUGO);
 MODULE_PARM_DESC(max_part, "Maximum number of partitions per RAM disk");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
@@ -447,7 +448,7 @@ MODULE_ALIAS("rd");
 /* Legacy boot options - nonmodular */
 static int __init ramdisk_size(char *str)
 {
-	rd_size = simple_strtol(str, NULL, 0);
+	rd_size = simple_strtoul(str, NULL, 0);
 	return 1;
 }
 __setup("ramdisk_size=", ramdisk_size);
@@ -555,7 +556,7 @@ static struct kobject *brd_probe(dev_t dev, int *part, void *data)
 
 static int __init brd_init(void)
 {
-	int i, nr;
+	unsigned int i, nr;
 	unsigned long range;
 	struct brd_device *brd, *next;
 
@@ -574,20 +575,17 @@ static int __init brd_init(void)
 	 *     kernel automatically instantiate actual device on-demand.
 	 */
 
-	part_shift = 0;
-	if (max_part > 0) {
-		part_shift = fls(max_part);
+	part_shift = fls(max_part);
 
-		/*
-		 * Adjust max_part according to part_shift as it is exported
-		 * to user space so that user can decide correct minor number
-		 * if [s]he want to create more devices.
-		 *
-		 * Note that -1 is required because partition 0 is reserved
-		 * for the whole disk.
-		 */
-		max_part = (1UL << part_shift) - 1;
-	}
+	/*
+	 * Adjust max_part according to part_shift as it is exported
+	 * to user space so that user can decide correct minor number
+	 * if [s]he want to create more devices.
+	 *
+	 * Note that -1 is required because partition 0 is reserved
+	 * for the whole disk.
+	 */
+	max_part = (1UL << part_shift) - 1;
 
 	if ((1UL << part_shift) > DISK_MAX_PARTS)
 		return -EINVAL;
-- 
1.7.12.4

