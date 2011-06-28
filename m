Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab1F1KpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:45:12 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:49634 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab1F1Knl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:43:41 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, hong.xu@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [RFC PATCH] MTD: atmel_nand: optimize read/write buffer functions
Date: Tue, 28 Jun 2011 13:50:56 +0200
Message-Id: <1309261856-27402-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For PIO NAND access functions, we use the features of the SMC:
- no need to take into account the NAND bus width: SMC will deal with this
- a word aligned memcpy on the NAND chip-select space is able to generate
  proper SMC behavior while optimizing AHB bus usage thanks to optimized memcpy
  implementation.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mtd/nand/atmel_nand.c |   71 +++++++++++++++++-----------------------
 1 files changed, 30 insertions(+), 41 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index b300705..cb8a04b 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -160,37 +160,6 @@ static int atmel_nand_device_ready(struct mtd_info *mtd)
                 !!host->board->rdy_pin_active_low;
 }
 
-/*
- * Minimal-overhead PIO for data access.
- */
-static void atmel_read_buf8(struct mtd_info *mtd, u8 *buf, int len)
-{
-	struct nand_chip	*nand_chip = mtd->priv;
-
-	__raw_readsb(nand_chip->IO_ADDR_R, buf, len);
-}
-
-static void atmel_read_buf16(struct mtd_info *mtd, u8 *buf, int len)
-{
-	struct nand_chip	*nand_chip = mtd->priv;
-
-	__raw_readsw(nand_chip->IO_ADDR_R, buf, len / 2);
-}
-
-static void atmel_write_buf8(struct mtd_info *mtd, const u8 *buf, int len)
-{
-	struct nand_chip	*nand_chip = mtd->priv;
-
-	__raw_writesb(nand_chip->IO_ADDR_W, buf, len);
-}
-
-static void atmel_write_buf16(struct mtd_info *mtd, const u8 *buf, int len)
-{
-	struct nand_chip	*nand_chip = mtd->priv;
-
-	__raw_writesw(nand_chip->IO_ADDR_W, buf, len / 2);
-}
-
 static void dma_complete_func(void *completion)
 {
 	complete(completion);
@@ -265,33 +234,53 @@ err_buf:
 static void atmel_read_buf(struct mtd_info *mtd, u8 *buf, int len)
 {
 	struct nand_chip *chip = mtd->priv;
-	struct atmel_nand_host *host = chip->priv;
+	u32 align;
+	u8 *pbuf;
 
 	if (use_dma && len > mtd->oobsize)
 		/* only use DMA for bigger than oob size: better performances */
 		if (atmel_nand_dma_op(mtd, buf, len, 1) == 0)
 			return;
 
-	if (host->board->bus_width_16)
-		atmel_read_buf16(mtd, buf, len);
-	else
-		atmel_read_buf8(mtd, buf, len);
+	/* if no DMA operation possible, use PIO */
+	pbuf = buf;
+	align = 0x03 & ((unsigned)pbuf);
+
+	if (align) {
+		u32 align_len = 4 - align;
+
+		/* non aligned buffer: re-align to next word boundary */
+		ioread8_rep(chip->IO_ADDR_R, pbuf, align_len);
+		pbuf += align_len;
+		len -= align_len;
+	}
+	memcpy((void *)pbuf, chip->IO_ADDR_R, len);
 }
 
 static void atmel_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
 {
 	struct nand_chip *chip = mtd->priv;
-	struct atmel_nand_host *host = chip->priv;
+	u32 align;
+	const u8 *pbuf;
 
 	if (use_dma && len > mtd->oobsize)
 		/* only use DMA for bigger than oob size: better performances */
 		if (atmel_nand_dma_op(mtd, (void *)buf, len, 0) == 0)
 			return;
 
-	if (host->board->bus_width_16)
-		atmel_write_buf16(mtd, buf, len);
-	else
-		atmel_write_buf8(mtd, buf, len);
+	/* if no DMA operation possible, use PIO */
+	pbuf = buf;
+	align = 0x03 & ((unsigned)pbuf);
+
+	if (align) {
+		u32 align_len = 4 - align;
+
+		/* non aligned buffer: re-align to next word boundary */
+		iowrite8_rep(chip->IO_ADDR_W, pbuf, align_len);
+		pbuf += align_len;
+		len -= align_len;
+	}
+	memcpy(chip->IO_ADDR_W, (void *)pbuf, len);
 }
 
 /*
-- 
1.7.3

