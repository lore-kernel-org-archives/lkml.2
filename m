Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935604Ab1KJErk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:47:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058Ab1KJDdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:33:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:25 2011
Message-Id: <20111109212725.037029336@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lei Wen <leiwen@marvell.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [243/262] mtd: pxa3xx_nand: fix nand detection issue
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lei Wen <leiwen@marvell.com>

commit 0fab028b77d714ad302404b23306cf7adb885223 upstream.

When keep_config is set, the detection would goes different routine.
That the driver would read out the setting which is set previously
by bootloader. While most bootloader keep the irq mask as off, and
current driver need all irq default open, keep_config behavior would
lead to no irq at all.

Signed-off-by: Lei Wen <leiwen@marvell.com>
Tested-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/nand/pxa3xx_nand.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -813,7 +813,7 @@ static int pxa3xx_nand_detect_config(str
 	info->page_size = ndcr & NDCR_PAGE_SZ ? 2048 : 512;
 	/* set info fields needed to read id */
 	info->read_id_bytes = (info->page_size == 2048) ? 4 : 2;
-	info->reg_ndcr = ndcr;
+	info->reg_ndcr = ndcr & ~NDCR_INT_MASK;
 	info->cmdset = &default_cmdset;
 
 	info->ndtr0cs0 = nand_readl(info, NDTR0CS0);
@@ -882,7 +882,7 @@ static int pxa3xx_nand_scan(struct mtd_i
 	struct pxa3xx_nand_info *info = mtd->priv;
 	struct platform_device *pdev = info->pdev;
 	struct pxa3xx_nand_platform_data *pdata = pdev->dev.platform_data;
-	struct nand_flash_dev pxa3xx_flash_ids[2] = { {NULL,}, {NULL,} };
+	struct nand_flash_dev pxa3xx_flash_ids[2], *def = NULL;
 	const struct pxa3xx_nand_flash *f = NULL;
 	struct nand_chip *chip = mtd->priv;
 	uint32_t id = -1;
@@ -942,8 +942,10 @@ static int pxa3xx_nand_scan(struct mtd_i
 	pxa3xx_flash_ids[0].erasesize = f->page_size * f->page_per_block;
 	if (f->flash_width == 16)
 		pxa3xx_flash_ids[0].options = NAND_BUSWIDTH_16;
+	pxa3xx_flash_ids[1].name = NULL;
+	def = pxa3xx_flash_ids;
 KEEP_CONFIG:
-	if (nand_scan_ident(mtd, 1, pxa3xx_flash_ids))
+	if (nand_scan_ident(mtd, 1, def))
 		return -ENODEV;
 	/* calculate addressing information */
 	info->col_addr_cycles = (mtd->writesize >= 2048) ? 2 : 1;
@@ -954,9 +956,9 @@ KEEP_CONFIG:
 		info->row_addr_cycles = 2;
 	mtd->name = mtd_names[0];
 	chip->ecc.mode = NAND_ECC_HW;
-	chip->ecc.size = f->page_size;
+	chip->ecc.size = info->page_size;
 
-	chip->options = (f->flash_width == 16) ? NAND_BUSWIDTH_16 : 0;
+	chip->options = (info->reg_ndcr & NDCR_DWIDTH_M) ? NAND_BUSWIDTH_16 : 0;
 	chip->options |= NAND_NO_AUTOINCR;
 	chip->options |= NAND_NO_READRDY;
 


