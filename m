Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1ARDCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 22:02:31 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:62582 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab1ARDCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 22:02:30 -0500
From: Hong Xu <hong.xu@atmel.com>
To: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jamie@jamieiles.com, jacmet@sunsite.dk,
        ryan@bluewatersys.com
Cc: nicolas.ferre@atmel.com, hong.xu@atmel.com
Subject: [PATCH] MTD: atmel_nand: Add DMA support to access Nandflash
Date: Tue, 18 Jan 2011 11:02:42 +0800
Message-Id: <1295319762-5351-2-git-send-email-hong.xu@atmel.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <hong.xu@atmel.com>
References: <hong.xu@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SAM9 chips have the ability to perform DMA between CPU and SMC controller.
This patch adds DMA support for SAM9RL, SAM9G45, SSAM9G46,AM9M10, SAM9M11.

Signed-off-by: Hong Xu <hong.xu@atmel.com>
---
 drivers/mtd/nand/atmel_nand.c |  166 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 157 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index ccce0f0..248e0db 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -48,6 +48,9 @@
 #define no_ecc		0
 #endif
 
+static int use_dma = 1;
+module_param(use_dma, int, 0);
+
 static int on_flash_bbt = 0;
 module_param(on_flash_bbt, int, 0);
 
@@ -89,11 +92,20 @@ struct atmel_nand_host {
 	struct nand_chip	nand_chip;
 	struct mtd_info		mtd;
 	void __iomem		*io_base;
+	dma_addr_t		io_phys;
 	struct atmel_nand_data	*board;
 	struct device		*dev;
 	void __iomem		*ecc;
+
+	struct completion comp;
+	struct dma_chan *dma_chan;
 };
 
+static int cpu_has_dma(void)
+{
+	return cpu_is_at91sam9rl() || cpu_is_at91sam9g45();
+}
+
 /*
  * Enable NAND.
  */
@@ -150,7 +162,7 @@ static int atmel_nand_device_ready(struct mtd_info *mtd)
 /*
  * Minimal-overhead PIO for data access.
  */
-static void atmel_read_buf(struct mtd_info *mtd, u8 *buf, int len)
+static void atmel_read_buf8(struct mtd_info *mtd, u8 *buf, int len)
 {
 	struct nand_chip	*nand_chip = mtd->priv;
 
@@ -164,7 +176,7 @@ static void atmel_read_buf16(struct mtd_info *mtd, u8 *buf, int len)
 	__raw_readsw(nand_chip->IO_ADDR_R, buf, len / 2);
 }
 
-static void atmel_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
+static void atmel_write_buf8(struct mtd_info *mtd, const u8 *buf, int len)
 {
 	struct nand_chip	*nand_chip = mtd->priv;
 
@@ -178,6 +190,121 @@ static void atmel_write_buf16(struct mtd_info *mtd, const u8 *buf, int len)
 	__raw_writesw(nand_chip->IO_ADDR_W, buf, len / 2);
 }
 
+static void dma_complete_func(void *completion)
+{
+	complete(completion);
+}
+
+static int atmel_nand_dma_op(struct mtd_info *mtd, void *buf, int len,
+			       int is_read)
+{
+	struct dma_device *dma_dev;
+	enum dma_ctrl_flags flags;
+	dma_addr_t dma_src_addr, dma_dst_addr, phys_addr;
+	struct dma_async_tx_descriptor *tx = NULL;
+	dma_cookie_t cookie;
+	struct nand_chip *chip = mtd->priv;
+	struct atmel_nand_host *host = chip->priv;
+	void *p = buf;
+	enum dma_data_direction dir = is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+
+	if (buf >= high_memory) {
+		struct page *pg;
+
+		if (((size_t)buf & PAGE_MASK) !=
+		    ((size_t)(buf + len - 1) & PAGE_MASK)) {
+			dev_warn(host->dev, "Buffer doesn't fit in one page:");
+			goto err_dma;
+		}
+
+		pg = vmalloc_to_page(buf);
+		if (pg == 0) {
+			dev_err(host->dev, "Failed to vmalloc_to_page:");
+			goto err_dma;
+		}
+		p = page_address(pg) + ((size_t)buf & ~PAGE_MASK);
+	}
+
+	dma_dev = host->dma_chan->device;
+
+	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_DEST_UNMAP | DMA_PREP_INTERRUPT |
+			DMA_COMPL_SKIP_SRC_UNMAP;
+
+	phys_addr = dma_map_single(dma_dev->dev, p, len, dir);
+
+	if (dma_mapping_error(dma_dev->dev, phys_addr)) {
+		dev_err(host->dev, "Failed to dma_map_single:");
+		goto err_dma;
+	}
+
+	if (is_read) {
+		dma_src_addr = host->io_phys;
+		dma_dst_addr = phys_addr;
+	} else {
+		dma_src_addr = phys_addr;
+		dma_dst_addr = host->io_phys;
+	}
+
+	tx = dma_dev->device_prep_dma_memcpy(host->dma_chan, dma_dst_addr,
+					     dma_src_addr, len, flags);
+	if (!tx) {
+		dev_err(host->dev, "Failed to prepare DMA memcpy\n");
+		goto err;
+	}
+
+	init_completion(&host->comp);
+	tx->callback = dma_complete_func;
+	tx->callback_param = &host->comp;
+
+	cookie = tx->tx_submit(tx);
+	if (dma_submit_error(cookie)) {
+		dev_err(host->dev, "Failed to do DMA tx_submit\n");
+		goto err;
+	}
+
+	dma_async_issue_pending(host->dma_chan);
+
+	wait_for_completion(&host->comp);
+
+	return 0;
+
+err:
+	dma_unmap_single(dma_dev->dev, phys_addr, len, dir);
+err_dma:
+	dev_warn(host->dev, " Fall back to CPU I/O\n");
+	return -EIO;
+}
+
+static void atmel_read_buf(struct mtd_info *mtd, u8 *buf, int len)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct atmel_nand_host *host = chip->priv;
+
+	if (use_dma && len >= mtd->oobsize)
+		if (atmel_nand_dma_op(mtd, buf, len, 1) == 0)
+			return;
+
+	if (host->board->bus_width_16)
+		atmel_read_buf16(mtd, buf, len);
+	else
+		atmel_read_buf8(mtd, buf, len);
+}
+
+static void atmel_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct atmel_nand_host *host = chip->priv;
+
+	if (use_dma && len >= mtd->oobsize)
+		if (atmel_nand_dma_op(mtd, (void *)buf, len, 0) == 0)
+			return;
+
+	if (host->board->bus_width_16)
+		atmel_write_buf16(mtd, buf, len);
+	else
+		atmel_write_buf8(mtd, buf, len);
+}
+
 /*
  * Calculate HW ECC
  *
@@ -398,6 +525,8 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	host->io_phys = (dma_addr_t)mem->start;
+
 	host->io_base = ioremap(mem->start, mem->end - mem->start + 1);
 	if (host->io_base == NULL) {
 		printk(KERN_ERR "atmel_nand: ioremap failed\n");
@@ -448,14 +577,11 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 
 	nand_chip->chip_delay = 20;		/* 20us command delay time */
 
-	if (host->board->bus_width_16) {	/* 16-bit bus width */
+	if (host->board->bus_width_16)	/* 16-bit bus width */
 		nand_chip->options |= NAND_BUSWIDTH_16;
-		nand_chip->read_buf = atmel_read_buf16;
-		nand_chip->write_buf = atmel_write_buf16;
-	} else {
-		nand_chip->read_buf = atmel_read_buf;
-		nand_chip->write_buf = atmel_write_buf;
-	}
+
+	nand_chip->read_buf = atmel_read_buf;
+	nand_chip->write_buf = atmel_write_buf;
 
 	platform_set_drvdata(pdev, host);
 	atmel_nand_enable(host);
@@ -473,6 +599,22 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 		nand_chip->options |= NAND_USE_FLASH_BBT;
 	}
 
+	if (cpu_has_dma() && use_dma) {
+		dma_cap_mask_t mask;
+
+		dma_cap_zero(mask);
+		dma_cap_set(DMA_MEMCPY, mask);
+		host->dma_chan = dma_request_channel(mask, 0, NULL);
+		if (!host->dma_chan) {
+			dev_err(host->dev, "Failed to request DMA channel\n");
+			use_dma = 0;
+		}
+	}
+	if (use_dma)
+		dev_info(host->dev, "Using DMA for NAND access.\n");
+	else
+		dev_info(host->dev, "No DMA support for NAND access.\n");
+
 	/* first scan to find the device and get the page size */
 	if (nand_scan_ident(mtd, 1, NULL)) {
 		res = -ENXIO;
@@ -555,6 +697,8 @@ err_scan_ident:
 err_no_card:
 	atmel_nand_disable(host);
 	platform_set_drvdata(pdev, NULL);
+	if (host->dma_chan)
+		dma_release_channel(host->dma_chan);
 	if (host->ecc)
 		iounmap(host->ecc);
 err_ecc_ioremap:
@@ -578,6 +722,10 @@ static int __exit atmel_nand_remove(struct platform_device *pdev)
 
 	if (host->ecc)
 		iounmap(host->ecc);
+
+	if (host->dma_chan)
+		dma_release_channel(host->dma_chan);
+
 	iounmap(host->io_base);
 	kfree(host);
 
-- 
1.7.3.3

