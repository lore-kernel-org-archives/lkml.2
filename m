Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab2EOOYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:24:23 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:44895 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757166Ab2EOOYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:24:21 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] MTD: LPC32xx MLC NAND driver
Date: Tue, 15 May 2012 16:23:52 +0200
Message-Id: <1337091832-10138-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a driver for the MLC NAND controller of the LPC32xx SoC.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Applies to v3.4-rc7 + LPC32xx SLC NAND driver (Kconfig + Makefile)

 Documentation/devicetree/bindings/mtd/lpc32xx-mlc.txt |   50 
 drivers/mtd/nand/Kconfig                              |   13 
 drivers/mtd/nand/Makefile                             |    1 
 drivers/mtd/nand/lpc32xx_nand_mlc.c                   |  960 ++++++++++++++++++
 4 files changed, 1023 insertions(+), 1 deletion(-)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/mtd/lpc32xx-mlc.txt
@@ -0,0 +1,50 @@
+NXP LPC32xx SoC NAND MLC controller
+
+Required properties:
+- compatible: "nxp,lpc3220-mlc"
+- reg: Address and size of the controller
+- interrupts: The NAND interrupt specification
+- gpios: GPIO specification for NAND write protect
+
+The following required properties are very controller specific. See the LPC32xx
+User Manual 7.5.14 MLC NAND Timing Register (the values here are specified in
+Hz, to make them independent of actual clock speed and to provide for good
+accuracy:)
+- nxp,tcea_delay: TCEA_DELAY
+- nxp,busy_delay: BUSY_DELAY
+- nxp,nand_ta: NAND_TA
+- nxp,rd_high: RD_HIGH
+- nxp,rd_low: RD_LOW
+- nxp,wr_high: WR_HIGH
+- nxp,wr_low: WR_LOW
+
+Optional subnodes:
+- Partitions, see Documentation/devicetree/bindings/mtd/partition.txt
+
+Example:
+
+	mlc: flash@200A8000 {
+		compatible = "nxp,lpc3220-mlc";
+		reg = <0x200A8000 0x11000>;
+		interrupts = <11 0>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		nxp,tcea-delay = <333333333>;
+		nxp,busy-delay = <10000000>;
+		nxp,nand-ta = <18181818>;
+		nxp,rd-high = <31250000>;
+		nxp,rd-low = <45454545>;
+		nxp,wr-high = <40000000>;
+		nxp,wr-low = <83333333>;
+		gpios = <&gpio 5 19 1>; /* GPO_P3 19, active low */
+
+		mtd0@00000000 {
+			label = "boot";
+			reg = <0x00000000 0x00064000>;
+			read-only;
+		};
+
+		...
+
+	};
--- linux-2.6.orig/drivers/mtd/nand/Kconfig
+++ linux-2.6/drivers/mtd/nand/Kconfig
@@ -415,7 +415,7 @@ config MTD_NAND_PXA3xx
 	  PXA3xx processors
 
 config MTD_NAND_SLC_LPC32XX
-	bool "NXP LPC32xx SLC Controller"
+	tristate "NXP LPC32xx SLC Controller"
 	depends on ARCH_LPC32XX
 	help
 	  Enables support for NXP's LPC32XX SLC (i.e. for Single Level Cell
@@ -425,6 +425,17 @@ config MTD_NAND_SLC_LPC32XX
 	  Please check the actual NAND chip connected and its support
 	  by the SLC NAND controller.
 
+config MTD_NAND_MLC_LPC32XX
+       tristate "NXP LPC32xx MLC Controller"
+       depends on ARCH_LPC32XX
+       help
+         Uses the LPC32XX MLC (i.e. for Multi Level Cell chips) NAND
+         controller. This is the default for the WORK92105 controller
+         board.
+
+         Please check the actual NAND chip connected and its support
+         by the MLC NAND controller.
+
 config MTD_NAND_CM_X270
 	tristate "Support for NAND Flash on CM-X270 modules"
 	depends on MACH_ARMCORE
--- linux-2.6.orig/drivers/mtd/nand/Makefile
+++ linux-2.6/drivers/mtd/nand/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_MTD_NAND_FSL_ELBC)		+= fsl_
 obj-$(CONFIG_MTD_NAND_FSL_IFC)		+= fsl_ifc_nand.o
 obj-$(CONFIG_MTD_NAND_FSL_UPM)		+= fsl_upm.o
 obj-$(CONFIG_MTD_NAND_SLC_LPC32XX)      += lpc32xx_nand_slc.o
+obj-$(CONFIG_MTD_NAND_MLC_LPC32XX)      += lpc32xx_nand_mlc.o
 obj-$(CONFIG_MTD_NAND_SH_FLCTL)		+= sh_flctl.o
 obj-$(CONFIG_MTD_NAND_MXC)		+= mxc_nand.o
 obj-$(CONFIG_MTD_NAND_SOCRATES)		+= socrates_nand.o
--- /dev/null
+++ linux-2.6/drivers/mtd/nand/lpc32xx_nand_mlc.c
@@ -0,0 +1,960 @@
+/*
+ * Driver for NAND MLC Controller in LPC32xx
+ *
+ * Author: Roland Stigge <stigge@antcom.de>
+ *
+ * Copyright (C) 2011 WORK Microwave GmbH
+ * Copyright (C) 2011, 2012 Roland Stigge
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ *
+ * NAND Flash Controller Operation:
+ * - Read: Auto Decode
+ * - Write: Auto Encode
+ * - Page Size: Large Page (2112 Bytes) only for now
+ */
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/partitions.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/completion.h>
+#include <linux/interrupt.h>
+#include <linux/of.h>
+#include <linux/of_mtd.h>
+#include <linux/of_gpio.h>
+#include <linux/amba/pl08x.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/mtd/nand_ecc.h>
+
+#define DRV_NAME "lpc32xx_nand_mlc"
+
+#define NAND_LARGE_BLOCK_PAGE_SIZE      2048
+#define NAND_SMALL_BLOCK_PAGE_SIZE      512
+
+#define NAND_ERASED_BLOCK_ECC_VALUE	0xFFFFFFFF
+
+/**********************************************************************
+* MLC NAND controller register offsets
+**********************************************************************/
+
+#define MLC_BUFF(x)			(x + 0x00000)
+#define MLC_DATA(x)			(x + 0x08000)
+#define MLC_CMD(x)			(x + 0x10000)
+#define MLC_ADDR(x)			(x + 0x10004)
+#define MLC_ECC_ENC_REG(x)		(x + 0x10008)
+#define MLC_ECC_DEC_REG(x)		(x + 0x1000C)
+#define MLC_ECC_AUTO_ENC_REG(x)		(x + 0x10010)
+#define MLC_ECC_AUTO_DEC_REG(x)		(x + 0x10014)
+#define MLC_RPR(x)			(x + 0x10018)
+#define MLC_WPR(x)			(x + 0x1001C)
+#define MLC_RUBP(x)			(x + 0x10020)
+#define MLC_ROBP(x)			(x + 0x10024)
+#define MLC_SW_WP_ADD_LOW(x)		(x + 0x10028)
+#define MLC_SW_WP_ADD_HIG(x)		(x + 0x1002C)
+#define MLC_ICR(x)			(x + 0x10030)
+#define MLC_TIME_REG(x)			(x + 0x10034)
+#define MLC_IRQ_MR(x)			(x + 0x10038)
+#define MLC_IRQ_SR(x)			(x + 0x1003C)
+#define MLC_LOCK_PR(x)			(x + 0x10044)
+#define MLC_ISR(x)			(x + 0x10048)
+#define MLC_CEH(x)			(x + 0x1004C)
+
+/**********************************************************************
+* MLC_CMD bit definitions
+**********************************************************************/
+#define MLCCMD_RESET			0xFF
+
+/**********************************************************************
+* MLC_ICR bit definitions
+**********************************************************************/
+#define MLCICR_WPROT			(1 << 3)
+#define MLCICR_LARGEBLOCK		(1 << 2)
+#define MLCICR_LONGADDR			(1 << 1)
+#define MLCICR_16BIT			(1 << 0)  /* unsupported by LPC32x0! */
+
+/**********************************************************************
+* MLC_TIME_REG bit definitions
+**********************************************************************/
+#define MLCTIMEREG_TCEA_DELAY(n)	(((n) & 0x03) << 24)
+#define MLCTIMEREG_BUSY_DELAY(n)	(((n) & 0x1F) << 19)
+#define MLCTIMEREG_NAND_TA(n)		(((n) & 0x07) << 16)
+#define MLCTIMEREG_RD_HIGH(n)		(((n) & 0x0F) << 12)
+#define MLCTIMEREG_RD_LOW(n)		(((n) & 0x0F) << 8)
+#define MLCTIMEREG_WR_HIGH(n)		(((n) & 0x0F) << 4)
+#define MLCTIMEREG_WR_LOW(n)		(((n) & 0x0F) << 0)
+
+/**********************************************************************
+* MLC_IRQ_MR and MLC_IRQ_SR bit definitions
+**********************************************************************/
+#define MLCIRQ_NAND_READY		(1 << 5)
+#define MLCIRQ_CONTROLLER_READY		(1 << 4)
+#define MLCIRQ_DECODE_FAILURE		(1 << 3)
+#define MLCIRQ_DECODE_ERROR		(1 << 2)
+#define MLCIRQ_ECC_READY		(1 << 1)
+#define MLCIRQ_WRPROT_FAULT		(1 << 0)
+
+/**********************************************************************
+* MLC_LOCK_PR bit definitions
+**********************************************************************/
+#define MLCLOCKPR_MAGIC			0xA25E
+
+/**********************************************************************
+* MLC_ISR bit definitions
+**********************************************************************/
+#define MLCISR_DECODER_FAILURE		(1 << 6)
+#define MLCISR_ERRORS			((1 << 4) | (1 << 5))
+#define MLCISR_ERRORS_DETECTED		(1 << 3)
+#define MLCISR_ECC_READY		(1 << 2)
+#define MLCISR_CONTROLLER_READY		(1 << 1)
+#define MLCISR_NAND_READY		(1 << 0)
+
+/**********************************************************************
+* MLC_CEH bit definitions
+**********************************************************************/
+#define MLCCEH_NORMAL			(1 << 0)
+
+struct lpc32xx_nand_cfg_mlc {
+	u32 tcea_delay;
+	u32 busy_delay;
+	u32 nand_ta;
+	u32 rd_high;
+	u32 rd_low;
+	u32 wr_high;
+	u32 wr_low;
+	unsigned wp_gpio;
+	struct mtd_partition *parts;
+	unsigned num_parts;
+};
+
+static struct nand_ecclayout lpc32xx_nand_oob = {
+	.eccbytes = 40,
+	.eccpos = { 6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
+		   22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
+		   38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
+		   54, 55, 56, 57, 58, 59, 60, 61, 62, 63 },
+	.oobfree = {
+		{ .offset = 0,
+		  .length = 6, },
+		{ .offset = 16,
+		  .length = 6, },
+		{ .offset = 32,
+		  .length = 6, },
+		{ .offset = 48,
+		  .length = 6, },
+		},
+};
+
+static struct nand_bbt_descr lpc32xx_nand_bbt = {
+	.options = NAND_BBT_ABSPAGE | NAND_BBT_2BIT | NAND_BBT_NO_OOB |
+		   NAND_BBT_WRITE,
+	.pages = { 524224, 0, 0, 0, 0, 0, 0, 0 },
+};
+
+static struct nand_bbt_descr lpc32xx_nand_bbt_mirror = {
+	.options = NAND_BBT_ABSPAGE | NAND_BBT_2BIT | NAND_BBT_NO_OOB |
+		   NAND_BBT_WRITE,
+	.pages = { 524160, 0, 0, 0, 0, 0, 0, 0 },
+};
+
+struct lpc32xx_nand_host {
+	struct nand_chip	nand_chip;
+	struct clk		*clk;
+	struct mtd_info		mtd;
+	void __iomem		*io_base;
+	int			irq;
+	struct lpc32xx_nand_cfg_mlc	*ncfg;
+	struct completion       comp_nand;
+	struct completion       comp_controller;
+	uint32_t llptr;
+	/*
+	 * Physical addresses of ECC buffer, DMA data buffers, OOB data buffer
+	 */
+	dma_addr_t		oob_buf_phy;
+	/*
+	 * Virtual addresses of ECC buffer, DMA data buffers, OOB data buffer
+	 */
+	uint8_t			*oob_buf;
+	/* Physical address of DMA base address */
+	dma_addr_t		io_base_phy;
+
+	struct completion	comp_dma;
+	struct dma_chan		*dma_chan;
+	struct dma_slave_config	dma_slave_config;
+	struct scatterlist	sgl;
+	u8			*dma_buf;
+};
+
+/*
+ * Activate/Deactivate DMA Operation:
+ *
+ * Using the PL080 DMA Controller for transferring the 512 byte subpages
+ * instead of doing readl() / writel() in a loop slows it down significantly.
+ * Measurements via getnstimeofday() upon 512 byte subpage reads reveal:
+ *
+ * - readl() of 128 x 32 bits in a loop: ~20us
+ * - DMA read of 512 bytes (32 bit, 4...128 words bursts): ~60us
+ * - DMA read of 512 bytes (32 bit, no bursts): ~100us
+ *
+ * This applies to the transfer itself. In the DMA case: only the
+ * wait_for_completion() (DMA setup _not_ included).
+ *
+ * Note that the 512 bytes subpage transfer is done directly from/to a
+ * FIFO/buffer inside the NAND controller. Most of the time (~400-800us for a
+ * 2048 bytes page) is spent waiting for the NAND IRQ, anyway. (The NAND
+ * controller transferring data between its internal buffer to/from the NAND
+ * chip.)
+ *
+ * Therefore, using the PL080 DMA is disabled by default, for now.
+ *
+ */
+static int use_dma = 0;
+
+static void lpc32xx_nand_setup(struct lpc32xx_nand_host *host)
+{
+	u32 clkrate, tmp;
+
+	/* Reset MLC controller */
+	writel(MLCCMD_RESET, MLC_CMD(host->io_base));
+	udelay(1000);
+
+	/* Get base clock for MLC block */
+	clkrate = clk_get_rate(host->clk);
+	if (clkrate == 0)
+		clkrate = 104000000;
+
+	/* Unlock MLC_ICR
+	 * (among others, will be locked again automatically) */
+	writew(MLCLOCKPR_MAGIC, MLC_LOCK_PR(host->io_base));
+
+	/* Configure MLC Controller: Large Block, 5 Byte Address */
+	tmp = MLCICR_LARGEBLOCK | MLCICR_LONGADDR;
+	writel(tmp, MLC_ICR(host->io_base));
+
+	/* Unlock MLC_TIME_REG
+	 * (among others, will be locked again automatically) */
+	writew(MLCLOCKPR_MAGIC, MLC_LOCK_PR(host->io_base));
+
+	/* Compute clock setup values, see LPC and NAND manual */
+	tmp = 0;
+	tmp |= MLCTIMEREG_TCEA_DELAY(clkrate / host->ncfg->tcea_delay + 1);
+	tmp |= MLCTIMEREG_BUSY_DELAY(clkrate / host->ncfg->busy_delay + 1);
+	tmp |= MLCTIMEREG_NAND_TA(clkrate / host->ncfg->nand_ta + 1);
+	tmp |= MLCTIMEREG_RD_HIGH(clkrate / host->ncfg->rd_high + 1);
+	tmp |= MLCTIMEREG_RD_LOW(clkrate / host->ncfg->rd_low);
+	tmp |= MLCTIMEREG_WR_HIGH(clkrate / host->ncfg->wr_high + 1);
+	tmp |= MLCTIMEREG_WR_LOW(clkrate / host->ncfg->wr_low);
+	writel(tmp, MLC_TIME_REG(host->io_base));
+
+	/* Enable IRQ for CONTROLLER_READY and NAND_READY */
+	writeb(MLCIRQ_CONTROLLER_READY | MLCIRQ_NAND_READY,
+			MLC_IRQ_MR(host->io_base));
+
+	/* Normal nCE operation: nCE controlled by controller */
+	writel(MLCCEH_NORMAL, MLC_CEH(host->io_base));
+}
+
+/*
+ * Hardware specific access to control lines
+ */
+static void lpc32xx_nand_cmd_ctrl(struct mtd_info *mtd, int cmd,
+				  unsigned int ctrl)
+{
+	struct nand_chip *nand_chip = mtd->priv;
+	struct lpc32xx_nand_host *host = nand_chip->priv;
+
+	if (cmd != NAND_CMD_NONE) {
+		if (ctrl & NAND_CLE)
+			writel(cmd, MLC_CMD(host->io_base));
+		else
+			writel(cmd, MLC_ADDR(host->io_base));
+	}
+}
+
+/*
+ * Read Device Ready (NAND device _and_ controller ready)
+ */
+static int lpc32xx_nand_device_ready(struct mtd_info *mtd)
+{
+	struct nand_chip *nand_chip = mtd->priv;
+	struct lpc32xx_nand_host *host = nand_chip->priv;
+
+	if ((readb(MLC_ISR(host->io_base)) &
+	     (MLCISR_CONTROLLER_READY | MLCISR_NAND_READY)) ==
+	    (MLCISR_CONTROLLER_READY | MLCISR_NAND_READY))
+		return  1;
+
+	return 0;
+}
+
+static irqreturn_t lpc3xxx_nand_irq(int irq, struct lpc32xx_nand_host *host)
+{
+	uint8_t sr;
+
+	/* Clear interrupt flag by reading status */
+	sr = readb(MLC_IRQ_SR(host->io_base));
+	if (sr & MLCIRQ_NAND_READY)
+		complete(&host->comp_nand);
+	if (sr & MLCIRQ_CONTROLLER_READY)
+		complete(&host->comp_controller);
+
+	return IRQ_HANDLED;
+}
+
+static int lpc32xx_waitfunc_nand(struct mtd_info *mtd, struct nand_chip *chip)
+{
+	struct lpc32xx_nand_host *host = chip->priv;
+
+	if (readb(MLC_ISR(host->io_base)) & MLCISR_NAND_READY)
+		goto exit;
+
+	wait_for_completion(&host->comp_nand);
+
+	while (!(readb(MLC_ISR(host->io_base)) & MLCISR_NAND_READY)) {
+		/* Seems to be delayed sometimes by controller */
+		dev_dbg(&mtd->dev, "Warning: NAND not ready.\n");
+		cpu_relax();
+	}
+
+exit:
+	return NAND_STATUS_READY;
+}
+
+static int lpc32xx_waitfunc_controller(struct mtd_info *mtd,
+				       struct nand_chip *chip)
+{
+	struct lpc32xx_nand_host *host = chip->priv;
+
+	if (readb(MLC_ISR(host->io_base)) & MLCISR_CONTROLLER_READY)
+		goto exit;
+
+	wait_for_completion(&host->comp_controller);
+
+	while (!(readb(MLC_ISR(host->io_base)) &
+		 MLCISR_CONTROLLER_READY)) {
+		dev_dbg(&mtd->dev, "Warning: Controller not ready.\n");
+		cpu_relax();
+	}
+
+exit:
+	return NAND_STATUS_READY;
+}
+
+static int lpc32xx_waitfunc(struct mtd_info *mtd, struct nand_chip *chip)
+{
+	lpc32xx_waitfunc_nand(mtd, chip);
+	lpc32xx_waitfunc_controller(mtd, chip);
+
+	return NAND_STATUS_READY;
+}
+
+/*
+ * Enable NAND write protect
+ */
+static void lpc32xx_wp_enable(struct lpc32xx_nand_host *host)
+{
+	gpio_set_value(host->ncfg->wp_gpio, 0);
+}
+
+/*
+ * Disable NAND write protect
+ */
+static void lpc32xx_wp_disable(struct lpc32xx_nand_host *host)
+{
+	gpio_set_value(host->ncfg->wp_gpio, 1);
+}
+
+static uint8_t lpc32xx_read_byte(struct mtd_info *mtd)
+{
+	struct nand_chip *nand_chip = mtd->priv;
+	struct lpc32xx_nand_host *host = nand_chip->priv;
+
+	return readb(MLC_DATA(host->io_base));
+}
+
+static void lpc32xx_write_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
+{
+	int i;
+	struct nand_chip *nand_chip = mtd->priv;
+	struct lpc32xx_nand_host *host = nand_chip->priv;
+
+	/* We are supposed to write only via the buffered auto encode */
+	dev_warn(&mtd->dev,
+		 "Warning: %s(): Writing %d bytes. This shouldn't happen!\n",
+		 __func__, len);
+
+	for (i = 0; i < len; i++)
+		writeb(buf[i], MLC_DATA(host->io_base));
+}
+
+static void lpc32xx_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
+{
+	int i;
+	struct nand_chip *nand_chip = mtd->priv;
+	struct lpc32xx_nand_host *host = nand_chip->priv;
+
+	dev_warn(&mtd->dev,
+		 "Warning: %s(): Reading %d bytes. This shouldn't happen!\n",
+		 __func__, len);
+
+	for (i = 0; i < len; i++)
+		buf[i] = readb(MLC_DATA(host->io_base));
+}
+
+static void lpc32xx_dma_complete_func(void *completion)
+{
+	complete(completion);
+}
+
+static int lpc32xx_xmit_dma(struct mtd_info *mtd, dma_addr_t dma,
+			    void *mem, int len, enum dma_transfer_direction dir)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct lpc32xx_nand_host *host = chip->priv;
+	struct dma_async_tx_descriptor *desc;
+	int flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
+	int res;
+	dma_cookie_t cookie;
+
+	host->dma_slave_config.direction = dir;
+	host->dma_slave_config.src_addr = dma;
+	host->dma_slave_config.dst_addr = dma;
+	if (dmaengine_slave_config(host->dma_chan, &host->dma_slave_config)) {
+		dev_err(mtd->dev.parent, "Failed to setup DMA slave\n");
+		return -ENXIO;
+	}
+
+	sg_init_one(&host->sgl, mem, len);
+
+	res = dma_map_sg(host->dma_chan->device->dev, &host->sgl, 1, dir);
+	if (res != 1) {
+		dev_err(mtd->dev.parent, "Failed to map sg list\n");
+		return -ENXIO;
+	}
+	desc = dmaengine_prep_slave_sg(host->dma_chan, &host->sgl, 1, dir,
+				       flags);
+	if (!desc) {
+		dev_err(mtd->dev.parent, "Failed to prepare slave sg\n");
+		goto out1;
+	}
+
+	init_completion(&host->comp_dma);
+	desc->callback = lpc32xx_dma_complete_func;
+	desc->callback_param = &host->comp_dma;
+
+	cookie = dmaengine_submit(desc);
+	if (dma_submit_error(cookie)) {
+		dev_err(mtd->dev.parent, "Failed to dmaengine_submit()\n");
+		goto out1;
+	}
+	dma_async_issue_pending(host->dma_chan);
+
+	wait_for_completion_timeout(&host->comp_dma, msecs_to_jiffies(1000));
+
+	dma_sync_sg_for_cpu(host->dma_chan->device->dev, &host->sgl, 1, dir);
+
+	return 0;
+out1:
+	dma_unmap_sg(host->dma_chan->device->dev, &host->sgl, 1, dir);
+	return -ENXIO;
+}
+
+static int lpc32xx_read_page(struct mtd_info *mtd, struct nand_chip *chip,
+			     uint8_t *buf, int page)
+{
+	struct lpc32xx_nand_host *host = chip->priv;
+	int i, j;
+	uint8_t *oobbuf = chip->oob_poi;
+	u32 mlc_isr;
+	int res;
+	u8 *dma_buf;
+	bool dma_mapped;
+
+	if ((void *)buf <= high_memory) {
+		dma_buf = buf;
+		dma_mapped = true;
+	} else {
+		dma_buf = host->dma_buf;
+		dma_mapped = false;
+	}
+
+	/* Writing Command and Address */
+	chip->cmdfunc(mtd, NAND_CMD_READ0, 0, page);
+
+	/* For all sub-pages */
+	for (i = 0; i < 4; i++) {
+		/* Start Auto Decode Command */
+		writeb(0x00, MLC_ECC_AUTO_DEC_REG(host->io_base));
+
+		/* Wait for Controller Ready */
+		lpc32xx_waitfunc_controller(mtd, chip);
+
+		/* Check ECC Error status */
+		mlc_isr = readl(MLC_ISR(host->io_base));
+		if (mlc_isr & MLCISR_DECODER_FAILURE) {
+			mtd->ecc_stats.failed++;
+			dev_warn(&mtd->dev, "%s: DECODER_FAILURE\n", __func__);
+		} else if (mlc_isr & MLCISR_ERRORS_DETECTED) {
+			mtd->ecc_stats.corrected += ((mlc_isr >> 4) & 0x3) + 1;
+		}
+
+		/* Read 512 + 16 Bytes */
+		if (use_dma) {
+			res = lpc32xx_xmit_dma(mtd, MLC_BUFF(host->io_base_phy),
+					       dma_buf + i * 512, 512,
+					       DMA_DEV_TO_MEM);
+			if (res)
+				return res;
+		} else {
+			for (j = 0; j < (512 >> 2); j++) {
+				*((uint32_t *)(buf)) =
+					readl(MLC_BUFF(host->io_base));
+				buf += 4;
+			}
+		}
+		for (j = 0; j < (16 >> 2); j++) {
+			*((uint32_t *)(oobbuf)) =
+				readl(MLC_BUFF(host->io_base));
+			oobbuf += 4;
+		}
+	}
+
+	if (use_dma && !dma_mapped)
+		memcpy(buf, dma_buf, NAND_LARGE_BLOCK_PAGE_SIZE);
+
+	return 0;
+}
+
+static void lpc32xx_write_page_lowlevel(struct mtd_info *mtd,
+					struct nand_chip *chip,
+					const uint8_t *buf)
+{
+	struct lpc32xx_nand_host *host = chip->priv;
+	const uint8_t *oobbuf = chip->oob_poi;
+	u8 *dma_buf;
+	int res;
+	int i, j;
+
+	if (use_dma) {
+		if ((void *)buf <= high_memory) {
+			dma_buf = (u8 *)buf;
+		} else {
+			dma_buf = host->dma_buf;
+			memcpy(dma_buf, buf, NAND_LARGE_BLOCK_PAGE_SIZE);
+		}
+	}
+
+	for (i = 0; i < 4; i++) {
+		/* Start Encode */
+		writeb(0x00, MLC_ECC_ENC_REG(host->io_base));
+
+		/* Write 512 + 6 Bytes to Buffer */
+		if (use_dma) {
+			res = lpc32xx_xmit_dma(mtd, MLC_BUFF(host->io_base_phy),
+					       dma_buf + i * 512, 512,
+					       DMA_MEM_TO_DEV);
+			if (res)
+				return;
+		} else {
+			for (j = 0; j < (512 >> 2); j++) {
+				writel(*((uint32_t *)(buf)),
+				       MLC_BUFF(host->io_base));
+				buf += 4;
+			}
+		}
+		writel(*((uint32_t *)(oobbuf)), MLC_BUFF(host->io_base));
+		oobbuf += 4;
+		writew(*((uint16_t *)(oobbuf)), MLC_BUFF(host->io_base));
+		oobbuf += 12;
+
+		/* Auto Encode w/ Bit 8 = 0 (see LPC MLC Controller manual) */
+		writeb(0x00, MLC_ECC_AUTO_ENC_REG(host->io_base));
+
+		/* Wait for Controller Ready */
+		lpc32xx_waitfunc_controller(mtd, chip);
+	}
+}
+
+static int lpc32xx_write_page(struct mtd_info *mtd, struct nand_chip *chip,
+			      const uint8_t *buf, int page, int cached, int raw)
+{
+	chip->cmdfunc(mtd, NAND_CMD_SEQIN, 0x00, page);
+	lpc32xx_write_page_lowlevel(mtd, chip, buf);
+	chip->cmdfunc(mtd, NAND_CMD_PAGEPROG, -1, -1);
+	lpc32xx_waitfunc(mtd, chip);
+
+	return 0;
+}
+
+static int lpc32xx_read_oob(struct mtd_info *mtd, struct nand_chip *chip,
+			    int page, int sndcmd)
+{
+	uint8_t buf[NAND_LARGE_BLOCK_PAGE_SIZE];
+
+	/* Read whole page - necessary with MLC controller! */
+	lpc32xx_read_page(mtd, chip, buf, page);
+
+	return 0;
+}
+
+static int lpc32xx_write_oob(struct mtd_info *mtd, struct nand_chip *chip,
+			      int page)
+{
+	/* None, write_oob conflicts with the automatic LPC MLC ECC decoder! */
+	return 0;
+}
+
+/* Prepares MLC for transfers with H/W ECC enabled: always enabled anyway */
+static void lpc32xx_ecc_enable(struct mtd_info *mtd, int mode)
+{
+	/* Always enabled! */
+}
+
+static bool lpc32xx_dma_filter(struct dma_chan *chan, void *param)
+{
+	struct pl08x_dma_chan *ch =
+		container_of(chan, struct pl08x_dma_chan, chan);
+
+	/* In LPC32xx's PL080 DMA wiring, the MLC NAND DMA signal is #12 */
+	if (ch->cd->min_signal == 12)
+		return true;
+	return false;
+}
+
+static int lpc32xx_dma_setup(struct lpc32xx_nand_host *host)
+{
+	struct mtd_info *mtd = &host->mtd;
+	dma_cap_mask_t mask;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	host->dma_chan = dma_request_channel(mask, lpc32xx_dma_filter, NULL);
+	if (!host->dma_chan) {
+		dev_err(mtd->dev.parent, "Failed to request DMA channel\n");
+		return -EBUSY;
+	}
+	if (dma_set_mask(host->dma_chan->device->dev, 0xFFFFFFFF)) {
+		dev_err(mtd->dev.parent, "Failed to set dma mask\n");
+		goto out1;
+	}
+
+	host->dma_slave_config.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	host->dma_slave_config.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	host->dma_slave_config.src_maxburst = 128;
+	host->dma_slave_config.dst_maxburst = 128;
+	/* DMA controller does flow control: */
+	host->dma_slave_config.device_fc = false;
+
+	return 0;
+out1:
+	dma_release_channel(host->dma_chan);
+	return -ENXIO;
+}
+
+#ifdef CONFIG_OF
+static struct lpc32xx_nand_cfg_mlc *lpc32xx_parse_dt(struct device *dev)
+{
+	struct lpc32xx_nand_cfg_mlc *pdata;
+	struct device_node *np = dev->of_node;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(dev, "could not allocate memory for platform data\n");
+		return NULL;
+	}
+
+	of_property_read_u32(np, "nxp,tcea-delay", &pdata->tcea_delay);
+	of_property_read_u32(np, "nxp,busy-delay", &pdata->busy_delay);
+	of_property_read_u32(np, "nxp,nand-ta", &pdata->nand_ta);
+	of_property_read_u32(np, "nxp,rd-high", &pdata->rd_high);
+	of_property_read_u32(np, "nxp,rd-low", &pdata->rd_low);
+	of_property_read_u32(np, "nxp,wr-high", &pdata->wr_high);
+	of_property_read_u32(np, "nxp,wr-low", &pdata->wr_low);
+
+	if (!pdata->tcea_delay || !pdata->busy_delay || !pdata->nand_ta ||
+	    !pdata->rd_high || !pdata->rd_low || !pdata->wr_high ||
+	    !pdata->wr_low) {
+		dev_err(dev, "chip parameters not specified correctly\n");
+		return NULL;
+	}
+
+	pdata->wp_gpio = of_get_named_gpio_flags(np, "gpios", 0, NULL);
+
+	return pdata;
+}
+#else
+static struct lpc32xx_nand_cfg_mlc *lpc32xx_parse_dt(struct device *dev)
+{
+	return NULL;
+}
+#endif
+
+/*
+ * Probe for NAND controller
+ */
+static int __devinit lpc32xx_nand_probe(struct platform_device *pdev)
+{
+	struct lpc32xx_nand_host *host;
+	struct mtd_info *mtd;
+	struct nand_chip *nand_chip;
+	struct resource *rc;
+	int res;
+	uint8_t sr;
+	struct mtd_part_parser_data ppdata = {};
+
+	/* Allocate memory for the device structure (and zero it) */
+	host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
+	if (!host) {
+		dev_err(&pdev->dev, "failed to allocate device structure.\n");
+		return -ENOMEM;
+	}
+
+	rc = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (rc == NULL) {
+		dev_err(&pdev->dev, "No memory resource found for device!\r\n");
+		return -ENXIO;
+	}
+
+	host->io_base = devm_request_and_ioremap(&pdev->dev, rc);
+	if (host->io_base == NULL) {
+		dev_err(&pdev->dev, "ioremap failed\n");
+		return -EIO;
+	}
+	host->io_base_phy = rc->start;
+
+	mtd = &host->mtd;
+	nand_chip = &host->nand_chip;
+	if (pdev->dev.of_node)
+		host->ncfg = lpc32xx_parse_dt(&pdev->dev);
+	else
+		host->ncfg = pdev->dev.platform_data;
+	if (!host->ncfg) {
+		dev_err(&pdev->dev, "Missing platform data\n");
+		return -ENOENT;
+	}
+	if (gpio_request(host->ncfg->wp_gpio, "NAND WP")) {
+		dev_err(&pdev->dev, "GPIO not available\n");
+		return -EBUSY;
+	}
+	lpc32xx_wp_disable(host);
+
+	nand_chip->priv = host;		/* link the private data structures */
+	mtd->priv = nand_chip;
+	mtd->owner = THIS_MODULE;
+	mtd->dev.parent = &pdev->dev;
+
+	/* Get NAND clock */
+	host->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(host->clk)) {
+		dev_err(&pdev->dev, "Clock initialization failure\n");
+		res = -ENOENT;
+		goto err_exit1;
+	}
+	clk_enable(host->clk);
+
+	nand_chip->cmd_ctrl = lpc32xx_nand_cmd_ctrl;
+	nand_chip->dev_ready = lpc32xx_nand_device_ready;
+	nand_chip->chip_delay = 25; /* us */
+
+	/* Init NAND controller */
+	lpc32xx_nand_setup(host);
+
+	platform_set_drvdata(pdev, host);
+
+	/* Initialize function pointers */
+	nand_chip->read_byte = lpc32xx_read_byte;
+	nand_chip->read_buf = lpc32xx_read_buf;
+	nand_chip->write_buf = lpc32xx_write_buf;
+	nand_chip->ecc.hwctl = lpc32xx_ecc_enable;
+	nand_chip->ecc.read_page_raw = lpc32xx_read_page;
+	nand_chip->ecc.read_page = lpc32xx_read_page;
+	nand_chip->ecc.write_page_raw = lpc32xx_write_page_lowlevel;
+	nand_chip->ecc.write_page = lpc32xx_write_page_lowlevel;
+	nand_chip->ecc.write_oob = lpc32xx_write_oob;
+	nand_chip->ecc.read_oob = lpc32xx_read_oob;
+	nand_chip->write_page = lpc32xx_write_page;
+	nand_chip->waitfunc = lpc32xx_waitfunc;
+
+	nand_chip->bbt_options = NAND_BBT_USE_FLASH | NAND_BBT_NO_OOB;
+	nand_chip->bbt_td = &lpc32xx_nand_bbt;
+	nand_chip->bbt_md = &lpc32xx_nand_bbt_mirror;
+
+	host->dma_buf = devm_kzalloc(&pdev->dev, NAND_LARGE_BLOCK_PAGE_SIZE,
+				     GFP_KERNEL);
+	if (!host->dma_buf) {
+		dev_err(&pdev->dev, "Error allocating memory\n");
+		res = -ENOMEM;
+		goto err_exit2;
+	}
+
+	res = lpc32xx_dma_setup(host);
+	if (res) {
+		res = -EIO;
+		goto err_exit2;
+	}
+
+	/*
+	 * Scan to find existance of the device and
+	 * Get the type of NAND device SMALL block or LARGE block
+	 */
+	if (nand_scan_ident(mtd, 1, NULL)) {
+		res = -ENXIO;
+		goto err_exit3;
+	}
+
+	nand_chip->ecc.mode = NAND_ECC_HW;
+	nand_chip->ecc.size = mtd->writesize;
+	nand_chip->ecc.layout = &lpc32xx_nand_oob;
+
+	/* initially clear interrupt status */
+	sr = readb(MLC_IRQ_SR(host->io_base));
+
+	init_completion(&host->comp_nand);
+	init_completion(&host->comp_controller);
+
+	host->irq = platform_get_irq(pdev, 0);
+	if ((host->irq < 0) || (host->irq >= NR_IRQS)) {
+		dev_err(&pdev->dev, "failed to get platform irq\n");
+		res = -EINVAL;
+		goto err_exit3;
+	}
+
+	if (request_irq(host->irq, (irq_handler_t)&lpc3xxx_nand_irq,
+			IRQF_TRIGGER_HIGH, DRV_NAME, host)) {
+		dev_err(&pdev->dev, "Error requesting NAND IRQ\n");
+		res = -ENXIO;
+		goto err_exit3;
+	}
+
+	/*
+	 * Fills out all the uninitialized function pointers with the defaults
+	 * And scans for a bad block table if appropriate.
+	 */
+	if (nand_scan_tail(mtd)) {
+		res = -ENXIO;
+		goto err_exit4;
+	}
+
+	mtd->name = DRV_NAME;
+
+	ppdata.of_node = pdev->dev.of_node;
+	res = mtd_device_parse_register(mtd, NULL, &ppdata, host->ncfg->parts,
+					host->ncfg->num_parts);
+	if (!res)
+		return res;
+
+	nand_release(mtd);
+
+err_exit4:
+	free_irq(host->irq, host);
+err_exit3:
+	dma_release_channel(host->dma_chan);
+err_exit2:
+	clk_disable(host->clk);
+	clk_put(host->clk);
+	platform_set_drvdata(pdev, NULL);
+err_exit1:
+	lpc32xx_wp_enable(host);
+	gpio_free(host->ncfg->wp_gpio);
+
+	return res;
+}
+
+/*
+ * Remove NAND device
+ */
+static int __devexit lpc32xx_nand_remove(struct platform_device *pdev)
+{
+	struct lpc32xx_nand_host *host = platform_get_drvdata(pdev);
+	struct mtd_info *mtd = &host->mtd;
+
+	nand_release(mtd);
+	free_irq(host->irq, host);
+	dma_release_channel(host->dma_chan);
+
+	clk_disable(host->clk);
+	clk_put(host->clk);
+	platform_set_drvdata(pdev, NULL);
+
+	lpc32xx_wp_enable(host);
+	gpio_free(host->ncfg->wp_gpio);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int lpc32xx_nand_resume(struct platform_device *pdev)
+{
+	struct lpc32xx_nand_host *host = platform_get_drvdata(pdev);
+
+	/* Re-enable NAND clock */
+	clk_enable(host->clk);
+
+	/* Fresh init of NAND controller */
+	lpc32xx_nand_setup(host);
+
+	/* Disable write protect */
+	lpc32xx_wp_disable(host);
+
+	return 0;
+}
+
+static int lpc32xx_nand_suspend(struct platform_device *pdev, pm_message_t pm)
+{
+	struct lpc32xx_nand_host *host = platform_get_drvdata(pdev);
+
+	/* Enable write protect for safety */
+	lpc32xx_wp_enable(host);
+
+	/* Disable clock */
+	clk_disable(host->clk);
+	return 0;
+}
+
+#else
+#define lpc32xx_nand_resume NULL
+#define lpc32xx_nand_suspend NULL
+#endif
+
+#if defined(CONFIG_OF)
+static const struct of_device_id lpc32xx_nand_match[] = {
+	{ .compatible = "nxp,lpc3220-mlc" },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, lpc32xx_nand_match);
+#endif
+
+static struct platform_driver lpc32xx_nand_driver = {
+	.probe		= lpc32xx_nand_probe,
+	.remove		= __devexit_p(lpc32xx_nand_remove),
+	.resume		= lpc32xx_nand_resume,
+	.suspend	= lpc32xx_nand_suspend,
+	.driver		= {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(lpc32xx_nand_match),
+	},
+};
+
+module_platform_driver(lpc32xx_nand_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Roland Stigge <stigge@antcom.de>");
+MODULE_DESCRIPTION("NAND driver for the NXP LPC32XX MLC controller");
