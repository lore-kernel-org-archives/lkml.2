Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab0EMUD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:03:29 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42027 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932676Ab0EMUDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:03:20 -0400
Date: Thu, 13 May 2010 22:03:15 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 12/20] drivers/mtd: Use kzalloc
Message-ID: <Pine.LNX.4.64.1005132202570.6282@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,size,flags;
statement S;
@@

-x = kmalloc(size,flags);
+x = kzalloc(size,flags);
 if (x == NULL) S
-memset(x, 0, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/lpddr/qinfo_probe.c     |    7 ++-----
 drivers/mtd/maps/ixp2000.c          |    3 +--
 drivers/mtd/maps/ixp4xx.c           |    3 +--
 drivers/mtd/maps/pxa2xx-flash.c     |    3 +--
 drivers/mtd/tests/mtd_pagetest.c    |    3 +--
 drivers/mtd/tests/mtd_readtest.c    |    3 +--
 drivers/mtd/tests/mtd_speedtest.c   |    3 +--
 drivers/mtd/tests/mtd_stresstest.c  |    3 +--
 drivers/mtd/tests/mtd_subpagetest.c |    3 +--
 9 files changed, 10 insertions(+), 21 deletions(-)

diff -u -p a/drivers/mtd/lpddr/qinfo_probe.c b/drivers/mtd/lpddr/qinfo_probe.c
--- a/drivers/mtd/lpddr/qinfo_probe.c
+++ b/drivers/mtd/lpddr/qinfo_probe.c
@@ -134,13 +134,12 @@ out:
 static int lpddr_chip_setup(struct map_info *map, struct lpddr_private *lpddr)
 {
 
-	lpddr->qinfo = kmalloc(sizeof(struct qinfo_chip), GFP_KERNEL);
+	lpddr->qinfo = kzalloc(sizeof(struct qinfo_chip), GFP_KERNEL);
 	if (!lpddr->qinfo) {
 		printk(KERN_WARNING "%s: no memory for LPDDR qinfo structure\n",
 				map->name);
 		return 0;
 	}
-	memset(lpddr->qinfo, 0, sizeof(struct qinfo_chip));
 
 	/* Get the ManuID */
 	lpddr->ManufactId = CMDVAL(map_read(map, map->pfow_base + PFOW_MANUFACTURER_ID));
@@ -185,13 +184,11 @@ static struct lpddr_private *lpddr_probe
 	lpddr.numchips = 1;
 
 	numvirtchips = lpddr.numchips * lpddr.qinfo->HWPartsNum;
-	retlpddr = kmalloc(sizeof(struct lpddr_private) +
+	retlpddr = kzalloc(sizeof(struct lpddr_private) +
 			numvirtchips * sizeof(struct flchip), GFP_KERNEL);
 	if (!retlpddr)
 		return NULL;
 
-	memset(retlpddr, 0, sizeof(struct lpddr_private) +
-				numvirtchips * sizeof(struct flchip));
 	memcpy(retlpddr, &lpddr, sizeof(struct lpddr_private));
 
 	retlpddr->numchips = numvirtchips;
diff -u -p a/drivers/mtd/maps/ixp2000.c b/drivers/mtd/maps/ixp2000.c
--- a/drivers/mtd/maps/ixp2000.c
+++ b/drivers/mtd/maps/ixp2000.c
@@ -165,12 +165,11 @@ static int ixp2000_flash_probe(struct pl
 		return -EIO;
 	}
 
-	info = kmalloc(sizeof(struct ixp2000_flash_info), GFP_KERNEL);
+	info = kzalloc(sizeof(struct ixp2000_flash_info), GFP_KERNEL);
 	if(!info) {
 		err = -ENOMEM;
 		goto Error;
 	}
-	memset(info, 0, sizeof(struct ixp2000_flash_info));
 
 	platform_set_drvdata(dev, info);
 
diff -u -p a/drivers/mtd/maps/ixp4xx.c b/drivers/mtd/maps/ixp4xx.c
--- a/drivers/mtd/maps/ixp4xx.c
+++ b/drivers/mtd/maps/ixp4xx.c
@@ -196,12 +196,11 @@ static int ixp4xx_flash_probe(struct pla
 			return err;
 	}
 
-	info = kmalloc(sizeof(struct ixp4xx_flash_info), GFP_KERNEL);
+	info = kzalloc(sizeof(struct ixp4xx_flash_info), GFP_KERNEL);
 	if(!info) {
 		err = -ENOMEM;
 		goto Error;
 	}
-	memset(info, 0, sizeof(struct ixp4xx_flash_info));
 
 	platform_set_drvdata(dev, info);
 
diff -u -p a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -63,11 +63,10 @@ static int __init pxa2xx_flash_probe(str
 	if (!res)
 		return -ENODEV;
 
-	info = kmalloc(sizeof(struct pxa2xx_flash_info), GFP_KERNEL);
+	info = kzalloc(sizeof(struct pxa2xx_flash_info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
-	memset(info, 0, sizeof(struct pxa2xx_flash_info));
 	info->map.name = (char *) flash->name;
 	info->map.bankwidth = flash->width;
 	info->map.phys = res->start;
diff -u -p a/drivers/mtd/tests/mtd_pagetest.c b/drivers/mtd/tests/mtd_pagetest.c
--- a/drivers/mtd/tests/mtd_pagetest.c
+++ b/drivers/mtd/tests/mtd_pagetest.c
@@ -480,12 +480,11 @@ static int scan_for_bad_eraseblocks(void
 {
 	int i, bad = 0;
 
-	bbt = kmalloc(ebcnt, GFP_KERNEL);
+	bbt = kzalloc(ebcnt, GFP_KERNEL);
 	if (!bbt) {
 		printk(PRINT_PREF "error: cannot allocate memory\n");
 		return -ENOMEM;
 	}
-	memset(bbt, 0 , ebcnt);
 
 	printk(PRINT_PREF "scanning for bad eraseblocks\n");
 	for (i = 0; i < ebcnt; ++i) {
diff -u -p a/drivers/mtd/tests/mtd_readtest.c b/drivers/mtd/tests/mtd_readtest.c
--- a/drivers/mtd/tests/mtd_readtest.c
+++ b/drivers/mtd/tests/mtd_readtest.c
@@ -141,12 +141,11 @@ static int scan_for_bad_eraseblocks(void
 {
 	int i, bad = 0;
 
-	bbt = kmalloc(ebcnt, GFP_KERNEL);
+	bbt = kzalloc(ebcnt, GFP_KERNEL);
 	if (!bbt) {
 		printk(PRINT_PREF "error: cannot allocate memory\n");
 		return -ENOMEM;
 	}
-	memset(bbt, 0 , ebcnt);
 
 	/* NOR flash does not implement block_isbad */
 	if (mtd->block_isbad == NULL)
diff -u -p a/drivers/mtd/tests/mtd_speedtest.c b/drivers/mtd/tests/mtd_speedtest.c
--- a/drivers/mtd/tests/mtd_speedtest.c
+++ b/drivers/mtd/tests/mtd_speedtest.c
@@ -295,12 +295,11 @@ static int scan_for_bad_eraseblocks(void
 {
 	int i, bad = 0;
 
-	bbt = kmalloc(ebcnt, GFP_KERNEL);
+	bbt = kzalloc(ebcnt, GFP_KERNEL);
 	if (!bbt) {
 		printk(PRINT_PREF "error: cannot allocate memory\n");
 		return -ENOMEM;
 	}
-	memset(bbt, 0 , ebcnt);
 
 	/* NOR flash does not implement block_isbad */
 	if (mtd->block_isbad == NULL)
diff -u -p a/drivers/mtd/tests/mtd_stresstest.c b/drivers/mtd/tests/mtd_stresstest.c
--- a/drivers/mtd/tests/mtd_stresstest.c
+++ b/drivers/mtd/tests/mtd_stresstest.c
@@ -221,12 +221,11 @@ static int scan_for_bad_eraseblocks(void
 {
 	int i, bad = 0;
 
-	bbt = kmalloc(ebcnt, GFP_KERNEL);
+	bbt = kzalloc(ebcnt, GFP_KERNEL);
 	if (!bbt) {
 		printk(PRINT_PREF "error: cannot allocate memory\n");
 		return -ENOMEM;
 	}
-	memset(bbt, 0 , ebcnt);
 
 	/* NOR flash does not implement block_isbad */
 	if (mtd->block_isbad == NULL)
diff -u -p a/drivers/mtd/tests/mtd_subpagetest.c b/drivers/mtd/tests/mtd_subpagetest.c
--- a/drivers/mtd/tests/mtd_subpagetest.c
+++ b/drivers/mtd/tests/mtd_subpagetest.c
@@ -354,12 +354,11 @@ static int scan_for_bad_eraseblocks(void
 {
 	int i, bad = 0;
 
-	bbt = kmalloc(ebcnt, GFP_KERNEL);
+	bbt = kzalloc(ebcnt, GFP_KERNEL);
 	if (!bbt) {
 		printk(PRINT_PREF "error: cannot allocate memory\n");
 		return -ENOMEM;
 	}
-	memset(bbt, 0 , ebcnt);
 
 	printk(PRINT_PREF "scanning for bad eraseblocks\n");
 	for (i = 0; i < ebcnt; ++i) {
