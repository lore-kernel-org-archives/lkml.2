Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761068Ab2BJXTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:19:53 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2BJWlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:41:14 -0500
MIME-Version: 1.0
Message-Id: <20120210222947.277802164@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nikolaus Voss <n.voss@weinmann.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [patch 25/86] Revert "mtd: atmel_nand: optimize read/write buffer functions"
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 500823195d0c9eec2a4637484f30cc93ec633d4a upstream.

This reverts commit fb5427508abbd635e877fabdf55795488119c2d6.

The reason is that it breaks 16 bits NAND flash as it was reported by
Nikolaus Voss and confirmed by Eric Bénard.

Nicolas Ferre <nicolas.ferre@atmel.com> alco confirmed:
"After double checking with designers, I must admit that I misunderstood
the way of optimizing accesses to SMC. 16 bit nand is not so common
those days..."

Reported-by: Nikolaus Voss <n.voss@weinmann.de>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/atmel_nand.c |   45 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -161,6 +161,37 @@ static int atmel_nand_device_ready(struc
                 !!host->board->rdy_pin_active_low;
 }
 
+/*
+ * Minimal-overhead PIO for data access.
+ */
+static void atmel_read_buf8(struct mtd_info *mtd, u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip = mtd->priv;
+
+	__raw_readsb(nand_chip->IO_ADDR_R, buf, len);
+}
+
+static void atmel_read_buf16(struct mtd_info *mtd, u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip = mtd->priv;
+
+	__raw_readsw(nand_chip->IO_ADDR_R, buf, len / 2);
+}
+
+static void atmel_write_buf8(struct mtd_info *mtd, const u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip = mtd->priv;
+
+	__raw_writesb(nand_chip->IO_ADDR_W, buf, len);
+}
+
+static void atmel_write_buf16(struct mtd_info *mtd, const u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip = mtd->priv;
+
+	__raw_writesw(nand_chip->IO_ADDR_W, buf, len / 2);
+}
+
 static void dma_complete_func(void *completion)
 {
 	complete(completion);
@@ -235,27 +266,33 @@ err_buf:
 static void atmel_read_buf(struct mtd_info *mtd, u8 *buf, int len)
 {
 	struct nand_chip *chip = mtd->priv;
+	struct atmel_nand_host *host = chip->priv;
 
 	if (use_dma && len > mtd->oobsize)
 		/* only use DMA for bigger than oob size: better performances */
 		if (atmel_nand_dma_op(mtd, buf, len, 1) == 0)
 			return;
 
-	/* if no DMA operation possible, use PIO */
-	memcpy_fromio(buf, chip->IO_ADDR_R, len);
+	if (host->board->bus_width_16)
+		atmel_read_buf16(mtd, buf, len);
+	else
+		atmel_read_buf8(mtd, buf, len);
 }
 
 static void atmel_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
 {
 	struct nand_chip *chip = mtd->priv;
+	struct atmel_nand_host *host = chip->priv;
 
 	if (use_dma && len > mtd->oobsize)
 		/* only use DMA for bigger than oob size: better performances */
 		if (atmel_nand_dma_op(mtd, (void *)buf, len, 0) == 0)
 			return;
 
-	/* if no DMA operation possible, use PIO */
-	memcpy_toio(chip->IO_ADDR_W, buf, len);
+	if (host->board->bus_width_16)
+		atmel_write_buf16(mtd, buf, len);
+	else
+		atmel_write_buf8(mtd, buf, len);
 }
 
 /*


