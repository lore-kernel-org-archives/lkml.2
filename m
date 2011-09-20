Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab1ITSHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:07:01 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:28123 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab1ITSG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:06:59 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1316541997!30095141!52
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] spi: spi-dw: fix all sparse warnings
Date: Tue, 20 Sep 2011 11:06:17 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, <grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109201106.19123.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dw_{read,write}[lw] macros produce sparse warnings everytime they
are used.  The "read" ones cause:

warning: cast removes address space of expression
warning: incorrect type in argument 1 (different address spaces)
   expected void const volatile [noderef] <asn:2>*addr
   got unsigned int *<noident>

And the "write" ones:

warning: cast removes address space of expression
warning: incorrect type in argument 2 (different address spaces)
   expected void volatile [noderef] <asn:2>*addr
   got unsigned int *<noident>

Fix this by removing struct dw_spi_reg and converting all the register
offsets to #defines. Then convert the macros into inlined functions so
that proper type checking can occur.

While here, also fix the three sparse warnings in spi-dw-mid.c due to
the return value of ioremap_nocache being stored in a u32 * not a
void __iomem *.

With these changes the spi-dw* files all build with no sparse warnings.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Grant Likely <grant.likely@secretlab.ca>

---

diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index 130e555..e743a45 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -116,13 +116,13 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 	/* 1. setup DMA related registers */
 	if (cs_change) {
 		spi_enable_chip(dws, 0);
-		dw_writew(dws, dmardlr, 0xf);
-		dw_writew(dws, dmatdlr, 0x10);
+		dw_writew(dws, DW_SPI_DMARDLR, 0xf);
+		dw_writew(dws, DW_SPI_DMATDLR, 0x10);
 		if (dws->tx_dma)
 			dma_ctrl |= 0x2;
 		if (dws->rx_dma)
 			dma_ctrl |= 0x1;
-		dw_writew(dws, dmacr, dma_ctrl);
+		dw_writew(dws, DW_SPI_DMACR, dma_ctrl);
 		spi_enable_chip(dws, 1);
 	}
 
@@ -200,7 +200,8 @@ static struct dw_spi_dma_ops mid_dma_ops = {
 
 int dw_spi_mid_init(struct dw_spi *dws)
 {
-	u32 *clk_reg, clk_cdiv;
+	void __iomem *clk_reg;
+	u32 clk_cdiv;
 
 	clk_reg = ioremap_nocache(MRST_CLK_SPI0_REG, 16);
 	if (!clk_reg)
diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 0b99320..082458d 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -89,35 +89,35 @@ static ssize_t  spi_show_regs(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
 			"=================================\n");
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"CTRL0: \t\t0x%08x\n", dw_readl(dws, ctrl0));
+			"CTRL0: \t\t0x%08x\n", dw_readl(dws, DW_SPI_CTRL0));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"CTRL1: \t\t0x%08x\n", dw_readl(dws, ctrl1));
+			"CTRL1: \t\t0x%08x\n", dw_readl(dws, DW_SPI_CTRL1));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"SSIENR: \t0x%08x\n", dw_readl(dws, ssienr));
+			"SSIENR: \t0x%08x\n", dw_readl(dws, DW_SPI_SSIENR));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"SER: \t\t0x%08x\n", dw_readl(dws, ser));
+			"SER: \t\t0x%08x\n", dw_readl(dws, DW_SPI_SER));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"BAUDR: \t\t0x%08x\n", dw_readl(dws, baudr));
+			"BAUDR: \t\t0x%08x\n", dw_readl(dws, DW_SPI_BAUDR));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"TXFTLR: \t0x%08x\n", dw_readl(dws, txfltr));
+			"TXFTLR: \t0x%08x\n", dw_readl(dws, DW_SPI_TXFLTR));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"RXFTLR: \t0x%08x\n", dw_readl(dws, rxfltr));
+			"RXFTLR: \t0x%08x\n", dw_readl(dws, DW_SPI_RXFLTR));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"TXFLR: \t\t0x%08x\n", dw_readl(dws, txflr));
+			"TXFLR: \t\t0x%08x\n", dw_readl(dws, DW_SPI_TXFLR));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"RXFLR: \t\t0x%08x\n", dw_readl(dws, rxflr));
+			"RXFLR: \t\t0x%08x\n", dw_readl(dws, DW_SPI_RXFLR));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"SR: \t\t0x%08x\n", dw_readl(dws, sr));
+			"SR: \t\t0x%08x\n", dw_readl(dws, DW_SPI_SR));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"IMR: \t\t0x%08x\n", dw_readl(dws, imr));
+			"IMR: \t\t0x%08x\n", dw_readl(dws, DW_SPI_IMR));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"ISR: \t\t0x%08x\n", dw_readl(dws, isr));
+			"ISR: \t\t0x%08x\n", dw_readl(dws, DW_SPI_ISR));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"DMACR: \t\t0x%08x\n", dw_readl(dws, dmacr));
+			"DMACR: \t\t0x%08x\n", dw_readl(dws, DW_SPI_DMACR));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"DMATDLR: \t0x%08x\n", dw_readl(dws, dmatdlr));
+			"DMATDLR: \t0x%08x\n", dw_readl(dws, DW_SPI_DMATDLR));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
-			"DMARDLR: \t0x%08x\n", dw_readl(dws, dmardlr));
+			"DMARDLR: \t0x%08x\n", dw_readl(dws, DW_SPI_DMARDLR));
 	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
 			"=================================\n");
 
@@ -167,7 +167,7 @@ static inline u32 tx_max(struct dw_spi *dws)
 	u32 tx_left, tx_room, rxtx_gap;
 
 	tx_left = (dws->tx_end - dws->tx) / dws->n_bytes;
-	tx_room = dws->fifo_len - dw_readw(dws, txflr);
+	tx_room = dws->fifo_len - dw_readw(dws, DW_SPI_TXFLR);
 
 	/*
 	 * Another concern is about the tx/rx mismatch, we
@@ -188,7 +188,7 @@ static inline u32 rx_max(struct dw_spi *dws)
 {
 	u32 rx_left = (dws->rx_end - dws->rx) / dws->n_bytes;
 
-	return min(rx_left, (u32)dw_readw(dws, rxflr));
+	return min(rx_left, (u32)dw_readw(dws, DW_SPI_RXFLR));
 }
 
 static void dw_writer(struct dw_spi *dws)
@@ -204,7 +204,7 @@ static void dw_writer(struct dw_spi *dws)
 			else
 				txw = *(u16 *)(dws->tx);
 		}
-		dw_writew(dws, dr, txw);
+		dw_writew(dws, DW_SPI_DR, txw);
 		dws->tx += dws->n_bytes;
 	}
 }
@@ -215,7 +215,7 @@ static void dw_reader(struct dw_spi *dws)
 	u16 rxw;
 
 	while (max--) {
-		rxw = dw_readw(dws, dr);
+		rxw = dw_readw(dws, DW_SPI_DR);
 		/* Care rx only if the transfer's original "rx" is not null */
 		if (dws->rx_end - dws->len) {
 			if (dws->n_bytes == 1)
@@ -323,13 +323,13 @@ EXPORT_SYMBOL_GPL(dw_spi_xfer_done);
 
 static irqreturn_t interrupt_transfer(struct dw_spi *dws)
 {
-	u16 irq_status = dw_readw(dws, isr);
+	u16 irq_status = dw_readw(dws, DW_SPI_ISR);
 
 	/* Error handling */
 	if (irq_status & (SPI_INT_TXOI | SPI_INT_RXOI | SPI_INT_RXUI)) {
-		dw_readw(dws, txoicr);
-		dw_readw(dws, rxoicr);
-		dw_readw(dws, rxuicr);
+		dw_readw(dws, DW_SPI_TXOICR);
+		dw_readw(dws, DW_SPI_RXOICR);
+		dw_readw(dws, DW_SPI_RXUICR);
 		int_error_stop(dws, "interrupt_transfer: fifo overrun/underrun");
 		return IRQ_HANDLED;
 	}
@@ -353,7 +353,7 @@ static irqreturn_t interrupt_transfer(struct dw_spi *dws)
 static irqreturn_t dw_spi_irq(int irq, void *dev_id)
 {
 	struct dw_spi *dws = dev_id;
-	u16 irq_status = dw_readw(dws, isr) & 0x3f;
+	u16 irq_status = dw_readw(dws, DW_SPI_ISR) & 0x3f;
 
 	if (!irq_status)
 		return IRQ_NONE;
@@ -521,11 +521,11 @@ static void pump_transfers(unsigned long data)
 	 *	2. clk_div is changed
 	 *	3. control value changes
 	 */
-	if (dw_readw(dws, ctrl0) != cr0 || cs_change || clk_div || imask) {
+	if (dw_readw(dws, DW_SPI_CTRL0) != cr0 || cs_change || clk_div || imask) {
 		spi_enable_chip(dws, 0);
 
-		if (dw_readw(dws, ctrl0) != cr0)
-			dw_writew(dws, ctrl0, cr0);
+		if (dw_readw(dws, DW_SPI_CTRL0) != cr0)
+			dw_writew(dws, DW_SPI_CTRL0, cr0);
 
 		spi_set_clk(dws, clk_div ? clk_div : chip->clk_div);
 		spi_chip_sel(dws, spi->chip_select);
@@ -535,7 +535,7 @@ static void pump_transfers(unsigned long data)
 		if (imask)
 			spi_umask_intr(dws, imask);
 		if (txint_level)
-			dw_writew(dws, txfltr, txint_level);
+			dw_writew(dws, DW_SPI_TXFLTR, txint_level);
 
 		spi_enable_chip(dws, 1);
 		if (cs_change)
@@ -791,13 +791,13 @@ static void spi_hw_init(struct dw_spi *dws)
 	if (!dws->fifo_len) {
 		u32 fifo;
 		for (fifo = 2; fifo <= 257; fifo++) {
-			dw_writew(dws, txfltr, fifo);
-			if (fifo != dw_readw(dws, txfltr))
+			dw_writew(dws, DW_SPI_TXFLTR, fifo);
+			if (fifo != dw_readw(dws, DW_SPI_TXFLTR))
 				break;
 		}
 
 		dws->fifo_len = (fifo == 257) ? 0 : fifo;
-		dw_writew(dws, txfltr, 0);
+		dw_writew(dws, DW_SPI_TXFLTR, 0);
 	}
 }
 
diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index 8b7b07b..9c57c07 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -4,6 +4,33 @@
 #include <linux/io.h>
 #include <linux/scatterlist.h>
 
+/* Register offsets */
+#define DW_SPI_CTRL0			0x00
+#define DW_SPI_CTRL1			0x04
+#define DW_SPI_SSIENR			0x08
+#define DW_SPI_MWCR			0x0c
+#define DW_SPI_SER			0x10
+#define DW_SPI_BAUDR			0x14
+#define DW_SPI_TXFLTR			0x18
+#define DW_SPI_RXFLTR			0x1c
+#define DW_SPI_TXFLR			0x20
+#define DW_SPI_RXFLR			0x24
+#define DW_SPI_SR			0x28
+#define DW_SPI_IMR			0x2c
+#define DW_SPI_ISR			0x30
+#define DW_SPI_RISR			0x34
+#define DW_SPI_TXOICR			0x38
+#define DW_SPI_RXOICR			0x3c
+#define DW_SPI_RXUICR			0x40
+#define DW_SPI_MSTICR			0x44
+#define DW_SPI_ICR			0x48
+#define DW_SPI_DMACR			0x4c
+#define DW_SPI_DMATDLR			0x50
+#define DW_SPI_DMARDLR			0x54
+#define DW_SPI_IDR			0x58
+#define DW_SPI_VERSION			0x5c
+#define DW_SPI_DR			0x60
+
 /* Bit fields in CTRLR0 */
 #define SPI_DFS_OFFSET			0
 
@@ -55,35 +82,6 @@ enum dw_ssi_type {
 	SSI_NS_MICROWIRE,
 };
 
-struct dw_spi_reg {
-	u32	ctrl0;
-	u32	ctrl1;
-	u32	ssienr;
-	u32	mwcr;
-	u32	ser;
-	u32	baudr;
-	u32	txfltr;
-	u32	rxfltr;
-	u32	txflr;
-	u32	rxflr;
-	u32	sr;
-	u32	imr;
-	u32	isr;
-	u32	risr;
-	u32	txoicr;
-	u32	rxoicr;
-	u32	rxuicr;
-	u32	msticr;
-	u32	icr;
-	u32	dmacr;
-	u32	dmatdlr;
-	u32	dmardlr;
-	u32	idr;
-	u32	version;
-	u32	dr;		/* Currently oper as 32 bits,
-				though only low 16 bits matters */
-} __packed;
-
 struct dw_spi;
 struct dw_spi_dma_ops {
 	int (*dma_init)(struct dw_spi *dws);
@@ -161,23 +159,34 @@ struct dw_spi {
 #endif
 };
 
-#define dw_readl(dw, name) \
-	__raw_readl(&(((struct dw_spi_reg *)dw->regs)->name))
-#define dw_writel(dw, name, val) \
-	__raw_writel((val), &(((struct dw_spi_reg *)dw->regs)->name))
-#define dw_readw(dw, name) \
-	__raw_readw(&(((struct dw_spi_reg *)dw->regs)->name))
-#define dw_writew(dw, name, val) \
-	__raw_writew((val), &(((struct dw_spi_reg *)dw->regs)->name))
+static inline u32 dw_readl(struct dw_spi *dws, u32 offset)
+{
+	return __raw_readl(dws->regs + offset);
+}
+
+static inline void dw_writel(struct dw_spi *dws, u32 offset, u32 val)
+{
+	__raw_writel(val, dws->regs + offset);
+}
+
+static inline u16 dw_readw(struct dw_spi *dws, u32 offset)
+{
+	return __raw_readw(dws->regs + offset);
+}
+
+static inline void dw_writew(struct dw_spi *dws, u32 offset, u16 val)
+{
+	__raw_writew(val, dws->regs + offset);
+}
 
 static inline void spi_enable_chip(struct dw_spi *dws, int enable)
 {
-	dw_writel(dws, ssienr, (enable ? 1 : 0));
+	dw_writel(dws, DW_SPI_SSIENR, (enable ? 1 : 0));
 }
 
 static inline void spi_set_clk(struct dw_spi *dws, u16 div)
 {
-	dw_writel(dws, baudr, div);
+	dw_writel(dws, DW_SPI_BAUDR, div);
 }
 
 static inline void spi_chip_sel(struct dw_spi *dws, u16 cs)
@@ -188,7 +197,7 @@ static inline void spi_chip_sel(struct dw_spi *dws, u16 cs)
 	if (dws->cs_control)
 		dws->cs_control(1);
 
-	dw_writel(dws, ser, 1 << cs);
+	dw_writel(dws, DW_SPI_SER, 1 << cs);
 }
 
 /* Disable IRQ bits */
@@ -196,8 +205,8 @@ static inline void spi_mask_intr(struct dw_spi *dws, u32 mask)
 {
 	u32 new_mask;
 
-	new_mask = dw_readl(dws, imr) & ~mask;
-	dw_writel(dws, imr, new_mask);
+	new_mask = dw_readl(dws, DW_SPI_IMR) & ~mask;
+	dw_writel(dws, DW_SPI_IMR, new_mask);
 }
 
 /* Enable IRQ bits */
@@ -205,8 +214,8 @@ static inline void spi_umask_intr(struct dw_spi *dws, u32 mask)
 {
 	u32 new_mask;
 
-	new_mask = dw_readl(dws, imr) | mask;
-	dw_writel(dws, imr, new_mask);
+	new_mask = dw_readl(dws, DW_SPI_IMR) | mask;
+	dw_writel(dws, DW_SPI_IMR, new_mask);
 }
 
 /*
