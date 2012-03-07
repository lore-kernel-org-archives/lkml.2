Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab2CGOeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 09:34:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63488 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab2CGOeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 09:34:00 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 01/13] dmaengine: imx-dma: merge old dma-v1.c with imx-dma.c
Date: Wed,  7 Mar 2012 15:33:33 +0100
Message-Id: <1331130825-14947-2-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
References: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is mainly a simple merge changing the prefix of some
functions to fit the imx-dma namings.

As there are no users of the old dma-v1.c api we can safely
remove this file.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 arch/arm/mach-imx/Kconfig               |    6 -
 arch/arm/mach-imx/Makefile              |    2 -
 arch/arm/mach-imx/dma-v1.c              |  846 -------------------------------
 arch/arm/mach-imx/include/mach/dma-v1.h |  103 ----
 drivers/dma/Kconfig                     |    1 -
 drivers/dma/imx-dma.c                   |  591 ++++++++++++++++++++--
 6 files changed, 541 insertions(+), 1008 deletions(-)
 delete mode 100644 arch/arm/mach-imx/dma-v1.c
 delete mode 100644 arch/arm/mach-imx/include/mach/dma-v1.h

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 0e6de36..3da1421 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -1,6 +1,3 @@
-config IMX_HAVE_DMA_V1
-	bool
-
 config HAVE_IMX_GPC
 	bool
 
@@ -26,7 +23,6 @@ config SOC_IMX1
 	bool
 	select ARCH_MX1
 	select CPU_ARM920T
-	select IMX_HAVE_DMA_V1
 	select IMX_HAVE_IOMUX_V1
 	select MXC_AVIC
 
@@ -35,7 +31,6 @@ config SOC_IMX21
 	select MACH_MX21
 	select CPU_ARM926T
 	select ARCH_MXC_AUDMUX_V1
-	select IMX_HAVE_DMA_V1
 	select IMX_HAVE_IOMUX_V1
 	select MXC_AVIC
 
@@ -52,7 +47,6 @@ config SOC_IMX27
 	select MACH_MX27
 	select CPU_ARM926T
 	select ARCH_MXC_AUDMUX_V1
-	select IMX_HAVE_DMA_V1
 	select IMX_HAVE_IOMUX_V1
 	select MXC_AVIC
 
diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index f5920c2..a62dc3a 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -1,5 +1,3 @@
-obj-$(CONFIG_IMX_HAVE_DMA_V1) += dma-v1.o
-
 obj-$(CONFIG_SOC_IMX1) += clock-imx1.o mm-imx1.o
 obj-$(CONFIG_SOC_IMX21) += clock-imx21.o mm-imx21.o
 
diff --git a/arch/arm/mach-imx/dma-v1.c b/arch/arm/mach-imx/dma-v1.c
deleted file mode 100644
index 42afc29..0000000
--- a/arch/arm/mach-imx/dma-v1.c
+++ /dev/null
@@ -1,846 +0,0 @@
-/*
- *  linux/arch/arm/plat-mxc/dma-v1.c
- *
- *  i.MX DMA registration and IRQ dispatching
- *
- * Copyright 2006 Pavel Pisa <pisa@cmp.felk.cvut.cz>
- * Copyright 2008 Juergen Beisert, <kernel@pengutronix.de>
- * Copyright 2008 Sascha Hauer, <s.hauer@pengutronix.de>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
- * MA 02110-1301, USA.
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/interrupt.h>
-#include <linux/err.h>
-#include <linux/errno.h>
-#include <linux/clk.h>
-#include <linux/scatterlist.h>
-#include <linux/io.h>
-
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <mach/hardware.h>
-#include <mach/dma-v1.h>
-
-#define DMA_DCR     0x00		/* Control Register */
-#define DMA_DISR    0x04		/* Interrupt status Register */
-#define DMA_DIMR    0x08		/* Interrupt mask Register */
-#define DMA_DBTOSR  0x0c		/* Burst timeout status Register */
-#define DMA_DRTOSR  0x10		/* Request timeout Register */
-#define DMA_DSESR   0x14		/* Transfer Error Status Register */
-#define DMA_DBOSR   0x18		/* Buffer overflow status Register */
-#define DMA_DBTOCR  0x1c		/* Burst timeout control Register */
-#define DMA_WSRA    0x40		/* W-Size Register A */
-#define DMA_XSRA    0x44		/* X-Size Register A */
-#define DMA_YSRA    0x48		/* Y-Size Register A */
-#define DMA_WSRB    0x4c		/* W-Size Register B */
-#define DMA_XSRB    0x50		/* X-Size Register B */
-#define DMA_YSRB    0x54		/* Y-Size Register B */
-#define DMA_SAR(x)  (0x80 + ((x) << 6))	/* Source Address Registers */
-#define DMA_DAR(x)  (0x84 + ((x) << 6))	/* Destination Address Registers */
-#define DMA_CNTR(x) (0x88 + ((x) << 6))	/* Count Registers */
-#define DMA_CCR(x)  (0x8c + ((x) << 6))	/* Control Registers */
-#define DMA_RSSR(x) (0x90 + ((x) << 6))	/* Request source select Registers */
-#define DMA_BLR(x)  (0x94 + ((x) << 6))	/* Burst length Registers */
-#define DMA_RTOR(x) (0x98 + ((x) << 6))	/* Request timeout Registers */
-#define DMA_BUCR(x) (0x98 + ((x) << 6))	/* Bus Utilization Registers */
-#define DMA_CCNR(x) (0x9C + ((x) << 6))	/* Channel counter Registers */
-
-#define DCR_DRST           (1<<1)
-#define DCR_DEN            (1<<0)
-#define DBTOCR_EN          (1<<15)
-#define DBTOCR_CNT(x)      ((x) & 0x7fff)
-#define CNTR_CNT(x)        ((x) & 0xffffff)
-#define CCR_ACRPT          (1<<14)
-#define CCR_DMOD_LINEAR    (0x0 << 12)
-#define CCR_DMOD_2D        (0x1 << 12)
-#define CCR_DMOD_FIFO      (0x2 << 12)
-#define CCR_DMOD_EOBFIFO   (0x3 << 12)
-#define CCR_SMOD_LINEAR    (0x0 << 10)
-#define CCR_SMOD_2D        (0x1 << 10)
-#define CCR_SMOD_FIFO      (0x2 << 10)
-#define CCR_SMOD_EOBFIFO   (0x3 << 10)
-#define CCR_MDIR_DEC       (1<<9)
-#define CCR_MSEL_B         (1<<8)
-#define CCR_DSIZ_32        (0x0 << 6)
-#define CCR_DSIZ_8         (0x1 << 6)
-#define CCR_DSIZ_16        (0x2 << 6)
-#define CCR_SSIZ_32        (0x0 << 4)
-#define CCR_SSIZ_8         (0x1 << 4)
-#define CCR_SSIZ_16        (0x2 << 4)
-#define CCR_REN            (1<<3)
-#define CCR_RPT            (1<<2)
-#define CCR_FRC            (1<<1)
-#define CCR_CEN            (1<<0)
-#define RTOR_EN            (1<<15)
-#define RTOR_CLK           (1<<14)
-#define RTOR_PSC           (1<<13)
-
-/*
- * struct imx_dma_channel - i.MX specific DMA extension
- * @name: name specified by DMA client
- * @irq_handler: client callback for end of transfer
- * @err_handler: client callback for error condition
- * @data: clients context data for callbacks
- * @dma_mode: direction of the transfer %DMA_MODE_READ or %DMA_MODE_WRITE
- * @sg: pointer to the actual read/written chunk for scatter-gather emulation
- * @resbytes: total residual number of bytes to transfer
- *            (it can be lower or same as sum of SG mapped chunk sizes)
- * @sgcount: number of chunks to be read/written
- *
- * Structure is used for IMX DMA processing. It would be probably good
- * @struct dma_struct in the future for external interfacing and use
- * @struct imx_dma_channel only as extension to it.
- */
-
-struct imx_dma_channel {
-	const char *name;
-	void (*irq_handler) (int, void *);
-	void (*err_handler) (int, void *, int errcode);
-	void (*prog_handler) (int, void *, struct scatterlist *);
-	void *data;
-	unsigned int dma_mode;
-	struct scatterlist *sg;
-	unsigned int resbytes;
-	int dma_num;
-
-	int in_use;
-
-	u32 ccr_from_device;
-	u32 ccr_to_device;
-
-	struct timer_list watchdog;
-
-	int hw_chaining;
-};
-
-static void __iomem *imx_dmav1_baseaddr;
-
-static void imx_dmav1_writel(unsigned val, unsigned offset)
-{
-	__raw_writel(val, imx_dmav1_baseaddr + offset);
-}
-
-static unsigned imx_dmav1_readl(unsigned offset)
-{
-	return __raw_readl(imx_dmav1_baseaddr + offset);
-}
-
-static struct imx_dma_channel imx_dma_channels[IMX_DMA_CHANNELS];
-
-static struct clk *dma_clk;
-
-static int imx_dma_hw_chain(struct imx_dma_channel *imxdma)
-{
-	if (cpu_is_mx27())
-		return imxdma->hw_chaining;
-	else
-		return 0;
-}
-
-/*
- * imx_dma_sg_next - prepare next chunk for scatter-gather DMA emulation
- */
-static inline int imx_dma_sg_next(int channel, struct scatterlist *sg)
-{
-	struct imx_dma_channel *imxdma = &imx_dma_channels[channel];
-	unsigned long now;
-
-	if (!imxdma->name) {
-		printk(KERN_CRIT "%s: called for  not allocated channel %d\n",
-		       __func__, channel);
-		return 0;
-	}
-
-	now = min(imxdma->resbytes, sg->length);
-	if (imxdma->resbytes != IMX_DMA_LENGTH_LOOP)
-		imxdma->resbytes -= now;
-
-	if ((imxdma->dma_mode & DMA_MODE_MASK) == DMA_MODE_READ)
-		imx_dmav1_writel(sg->dma_address, DMA_DAR(channel));
-	else
-		imx_dmav1_writel(sg->dma_address, DMA_SAR(channel));
-
-	imx_dmav1_writel(now, DMA_CNTR(channel));
-
-	pr_debug("imxdma%d: next sg chunk dst 0x%08x, src 0x%08x, "
-		"size 0x%08x\n", channel,
-		 imx_dmav1_readl(DMA_DAR(channel)),
-		 imx_dmav1_readl(DMA_SAR(channel)),
-		 imx_dmav1_readl(DMA_CNTR(channel)));
-
-	return now;
-}
-
-/**
- * imx_dma_setup_single - setup i.MX DMA channel for linear memory to/from
- * device transfer
- *
- * @channel: i.MX DMA channel number
- * @dma_address: the DMA/physical memory address of the linear data block
- *		to transfer
- * @dma_length: length of the data block in bytes
- * @dev_addr: physical device port address
- * @dmamode: DMA transfer mode, %DMA_MODE_READ from the device to the memory
- *           or %DMA_MODE_WRITE from memory to the device
- *
- * Return value: if incorrect parameters are provided -%EINVAL.
- *		Zero indicates success.
- */
-int
-imx_dma_setup_single(int channel, dma_addr_t dma_address,
-		     unsigned int dma_length, unsigned int dev_addr,
-		     unsigned int dmamode)
-{
-	struct imx_dma_channel *imxdma = &imx_dma_channels[channel];
-
-	imxdma->sg = NULL;
-	imxdma->dma_mode = dmamode;
-
-	if (!dma_address) {
-		printk(KERN_ERR "imxdma%d: imx_dma_setup_single null address\n",
-		       channel);
-		return -EINVAL;
-	}
-
-	if (!dma_length) {
-		printk(KERN_ERR "imxdma%d: imx_dma_setup_single zero length\n",
-		       channel);
-		return -EINVAL;
-	}
-
-	if ((dmamode & DMA_MODE_MASK) == DMA_MODE_READ) {
-		pr_debug("imxdma%d: %s dma_addressg=0x%08x dma_length=%d "
-			"dev_addr=0x%08x for read\n",
-			channel, __func__, (unsigned int)dma_address,
-			dma_length, dev_addr);
-
-		imx_dmav1_writel(dev_addr, DMA_SAR(channel));
-		imx_dmav1_writel(dma_address, DMA_DAR(channel));
-		imx_dmav1_writel(imxdma->ccr_from_device, DMA_CCR(channel));
-	} else if ((dmamode & DMA_MODE_MASK) == DMA_MODE_WRITE) {
-		pr_debug("imxdma%d: %s dma_addressg=0x%08x dma_length=%d "
-			"dev_addr=0x%08x for write\n",
-			channel, __func__, (unsigned int)dma_address,
-			dma_length, dev_addr);
-
-		imx_dmav1_writel(dma_address, DMA_SAR(channel));
-		imx_dmav1_writel(dev_addr, DMA_DAR(channel));
-		imx_dmav1_writel(imxdma->ccr_to_device,
-				DMA_CCR(channel));
-	} else {
-		printk(KERN_ERR "imxdma%d: imx_dma_setup_single bad dmamode\n",
-		       channel);
-		return -EINVAL;
-	}
-
-	imx_dmav1_writel(dma_length, DMA_CNTR(channel));
-
-	return 0;
-}
-EXPORT_SYMBOL(imx_dma_setup_single);
-
-/**
- * imx_dma_setup_sg - setup i.MX DMA channel SG list to/from device transfer
- * @channel: i.MX DMA channel number
- * @sg: pointer to the scatter-gather list/vector
- * @sgcount: scatter-gather list hungs count
- * @dma_length: total length of the transfer request in bytes
- * @dev_addr: physical device port address
- * @dmamode: DMA transfer mode, %DMA_MODE_READ from the device to the memory
- *           or %DMA_MODE_WRITE from memory to the device
- *
- * The function sets up DMA channel state and registers to be ready for
- * transfer specified by provided parameters. The scatter-gather emulation
- * is set up according to the parameters.
- *
- * The full preparation of the transfer requires setup of more register
- * by the caller before imx_dma_enable() can be called.
- *
- * %BLR(channel) holds transfer burst length in bytes, 0 means 64 bytes
- *
- * %RSSR(channel) has to be set to the DMA request line source %DMA_REQ_xxx
- *
- * %CCR(channel) has to specify transfer parameters, the next settings is
- * typical for linear or simple scatter-gather transfers if %DMA_MODE_READ is
- * specified
- *
- * %CCR_DMOD_LINEAR | %CCR_DSIZ_32 | %CCR_SMOD_FIFO | %CCR_SSIZ_x
- *
- * The typical setup for %DMA_MODE_WRITE is specified by next options
- * combination
- *
- * %CCR_SMOD_LINEAR | %CCR_SSIZ_32 | %CCR_DMOD_FIFO | %CCR_DSIZ_x
- *
- * Be careful here and do not mistakenly mix source and target device
- * port sizes constants, they are really different:
- * %CCR_SSIZ_8, %CCR_SSIZ_16, %CCR_SSIZ_32,
- * %CCR_DSIZ_8, %CCR_DSIZ_16, %CCR_DSIZ_32
- *
- * Return value: if incorrect parameters are provided -%EINVAL.
- * Zero indicates success.
- */
-int
-imx_dma_setup_sg(int channel,
-		 struct scatterlist *sg, unsigned int sgcount,
-		 unsigned int dma_length, unsigned int dev_addr,
-		 unsigned int dmamode)
-{
-	struct imx_dma_channel *imxdma = &imx_dma_channels[channel];
-
-	if (imxdma->in_use)
-		return -EBUSY;
-
-	imxdma->sg = sg;
-	imxdma->dma_mode = dmamode;
-	imxdma->resbytes = dma_length;
-
-	if (!sg || !sgcount) {
-		printk(KERN_ERR "imxdma%d: imx_dma_setup_sg empty sg list\n",
-		       channel);
-		return -EINVAL;
-	}
-
-	if (!sg->length) {
-		printk(KERN_ERR "imxdma%d: imx_dma_setup_sg zero length\n",
-		       channel);
-		return -EINVAL;
-	}
-
-	if ((dmamode & DMA_MODE_MASK) == DMA_MODE_READ) {
-		pr_debug("imxdma%d: %s sg=%p sgcount=%d total length=%d "
-			"dev_addr=0x%08x for read\n",
-			channel, __func__, sg, sgcount, dma_length, dev_addr);
-
-		imx_dmav1_writel(dev_addr, DMA_SAR(channel));
-		imx_dmav1_writel(imxdma->ccr_from_device, DMA_CCR(channel));
-	} else if ((dmamode & DMA_MODE_MASK) == DMA_MODE_WRITE) {
-		pr_debug("imxdma%d: %s sg=%p sgcount=%d total length=%d "
-			"dev_addr=0x%08x for write\n",
-			channel, __func__, sg, sgcount, dma_length, dev_addr);
-
-		imx_dmav1_writel(dev_addr, DMA_DAR(channel));
-		imx_dmav1_writel(imxdma->ccr_to_device, DMA_CCR(channel));
-	} else {
-		printk(KERN_ERR "imxdma%d: imx_dma_setup_sg bad dmamode\n",
-		       channel);
-		return -EINVAL;
-	}
-
-	imx_dma_sg_next(channel, sg);
-
-	return 0;
-}
-EXPORT_SYMBOL(imx_dma_setup_sg);
-
-int
-imx_dma_config_channel(int channel, unsigned int config_port,
-	unsigned int config_mem, unsigned int dmareq, int hw_chaining)
-{
-	struct imx_dma_channel *imxdma = &imx_dma_channels[channel];
-	u32 dreq = 0;
-
-	imxdma->hw_chaining = 0;
-
-	if (hw_chaining) {
-		imxdma->hw_chaining = 1;
-		if (!imx_dma_hw_chain(imxdma))
-			return -EINVAL;
-	}
-
-	if (dmareq)
-		dreq = CCR_REN;
-
-	imxdma->ccr_from_device = config_port | (config_mem << 2) | dreq;
-	imxdma->ccr_to_device = config_mem | (config_port << 2) | dreq;
-
-	imx_dmav1_writel(dmareq, DMA_RSSR(channel));
-
-	return 0;
-}
-EXPORT_SYMBOL(imx_dma_config_channel);
-
-void imx_dma_config_burstlen(int channel, unsigned int burstlen)
-{
-	imx_dmav1_writel(burstlen, DMA_BLR(channel));
-}
-EXPORT_SYMBOL(imx_dma_config_burstlen);
-
-/**
- * imx_dma_setup_handlers - setup i.MX DMA channel end and error notification
- * handlers
- * @channel: i.MX DMA channel number
- * @irq_handler: the pointer to the function called if the transfer
- *		ends successfully
- * @err_handler: the pointer to the function called if the premature
- *		end caused by error occurs
- * @data: user specified value to be passed to the handlers
- */
-int
-imx_dma_setup_handlers(int channel,
-		       void (*irq_handler) (int, void *),
-		       void (*err_handler) (int, void *, int),
-		       void *data)
-{
-	struct imx_dma_channel *imxdma = &imx_dma_channels[channel];
-	unsigned long flags;
-
-	if (!imxdma->name) {
-		printk(KERN_CRIT "%s: called for  not allocated channel %d\n",
-		       __func__, channel);
-		return -ENODEV;
-	}
-
-	local_irq_save(flags);
-	imx_dmav1_writel(1 << channel, DMA_DISR);
-	imxdma->irq_handler = irq_handler;
-	imxdma->err_handler = err_handler;
-	imxdma->data = data;
-	local_irq_restore(flags);
-	return 0;
-}
-EXPORT_SYMBOL(imx_dma_setup_handlers);
-
-/**
- * imx_dma_setup_progression_handler - setup i.MX DMA channel progression
- * handlers
- * @channel: i.MX DMA channel number
- * @prog_handler: the pointer to the function called if the transfer progresses
- */
-int
-imx_dma_setup_progression_handler(int channel,
-			void (*prog_handler) (int, void*, struct scatterlist*))
-{
-	struct imx_dma_channel *imxdma = &imx_dma_channels[channel];
-	unsigned long flags;
-
-	if (!imxdma->name) {
-		printk(KERN_CRIT "%s: called for  not allocated channel %d\n",
-		       __func__, channel);
-		return -ENODEV;
-	}
-
-	local_irq_save(flags);
-	imxdma->prog_handler = prog_handler;
-	local_irq_restore(flags);
-	return 0;
-}
-EXPORT_SYMBOL(imx_dma_setup_progression_handler);
-
-/**
- * imx_dma_enable - function to start i.MX DMA channel operation
- * @channel: i.MX DMA channel number
- *
- * The channel has to be allocated by driver through imx_dma_request()
- * or imx_dma_request_by_prio() function.
- * The transfer parameters has to be set to the channel registers through
- * call of the imx_dma_setup_single() or imx_dma_setup_sg() function
- * and registers %BLR(channel), %RSSR(channel) and %CCR(channel) has to
- * be set prior this function call by the channel user.
- */
-void imx_dma_enable(int channel)
-{
-	struct imx_dma_channel *imxdma = &imx_dma_channels[channel];
-	unsigned long flags;
-
-	pr_debug("imxdma%d: imx_dma_enable\n", channel);
-
-	if (!imxdma->name) {
-		printk(KERN_CRIT "%s: called for  not allocated channel %d\n",
-		       __func__, channel);
-		return;
-	}
-
-	if (imxdma->in_use)
-		return;
-
-	local_irq_save(flags);
-
-	imx_dmav1_writel(1 << channel, DMA_DISR);
-	imx_dmav1_writel(imx_dmav1_readl(DMA_DIMR) & ~(1 << channel), DMA_DIMR);
-	imx_dmav1_writel(imx_dmav1_readl(DMA_CCR(channel)) | CCR_CEN |
-		CCR_ACRPT, DMA_CCR(channel));
-
-	if ((cpu_is_mx21() || cpu_is_mx27()) &&
-			imxdma->sg && imx_dma_hw_chain(imxdma)) {
-		imxdma->sg = sg_next(imxdma->sg);
-		if (imxdma->sg) {
-			u32 tmp;
-			imx_dma_sg_next(channel, imxdma->sg);
-			tmp = imx_dmav1_readl(DMA_CCR(channel));
-			imx_dmav1_writel(tmp | CCR_RPT | CCR_ACRPT,
-				DMA_CCR(channel));
-		}
-	}
-	imxdma->in_use = 1;
-
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL(imx_dma_enable);
-
-/**
- * imx_dma_disable - stop, finish i.MX DMA channel operatin
- * @channel: i.MX DMA channel number
- */
-void imx_dma_disable(int channel)
-{
-	struct imx_dma_channel *imxdma = &imx_dma_channels[channel];
-	unsigned long flags;
-
-	pr_debug("imxdma%d: imx_dma_disable\n", channel);
-
-	if (imx_dma_hw_chain(imxdma))
-		del_timer(&imxdma->watchdog);
-
-	local_irq_save(flags);
-	imx_dmav1_writel(imx_dmav1_readl(DMA_DIMR) | (1 << channel), DMA_DIMR);
-	imx_dmav1_writel(imx_dmav1_readl(DMA_CCR(channel)) & ~CCR_CEN,
-			DMA_CCR(channel));
-	imx_dmav1_writel(1 << channel, DMA_DISR);
-	imxdma->in_use = 0;
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL(imx_dma_disable);
-
-static void imx_dma_watchdog(unsigned long chno)
-{
-	struct imx_dma_channel *imxdma = &imx_dma_channels[chno];
-
-	imx_dmav1_writel(0, DMA_CCR(chno));
-	imxdma->in_use = 0;
-	imxdma->sg = NULL;
-
-	if (imxdma->err_handler)
-		imxdma->err_handler(chno, imxdma->data, IMX_DMA_ERR_TIMEOUT);
-}
-
-static irqreturn_t dma_err_handler(int irq, void *dev_id)
-{
-	int i, disr;
-	struct imx_dma_channel *imxdma;
-	unsigned int err_mask;
-	int errcode;
-
-	disr = imx_dmav1_readl(DMA_DISR);
-
-	err_mask = imx_dmav1_readl(DMA_DBTOSR) |
-		   imx_dmav1_readl(DMA_DRTOSR) |
-		   imx_dmav1_readl(DMA_DSESR)  |
-		   imx_dmav1_readl(DMA_DBOSR);
-
-	if (!err_mask)
-		return IRQ_HANDLED;
-
-	imx_dmav1_writel(disr & err_mask, DMA_DISR);
-
-	for (i = 0; i < IMX_DMA_CHANNELS; i++) {
-		if (!(err_mask & (1 << i)))
-			continue;
-		imxdma = &imx_dma_channels[i];
-		errcode = 0;
-
-		if (imx_dmav1_readl(DMA_DBTOSR) & (1 << i)) {
-			imx_dmav1_writel(1 << i, DMA_DBTOSR);
-			errcode |= IMX_DMA_ERR_BURST;
-		}
-		if (imx_dmav1_readl(DMA_DRTOSR) & (1 << i)) {
-			imx_dmav1_writel(1 << i, DMA_DRTOSR);
-			errcode |= IMX_DMA_ERR_REQUEST;
-		}
-		if (imx_dmav1_readl(DMA_DSESR) & (1 << i)) {
-			imx_dmav1_writel(1 << i, DMA_DSESR);
-			errcode |= IMX_DMA_ERR_TRANSFER;
-		}
-		if (imx_dmav1_readl(DMA_DBOSR) & (1 << i)) {
-			imx_dmav1_writel(1 << i, DMA_DBOSR);
-			errcode |= IMX_DMA_ERR_BUFFER;
-		}
-		if (imxdma->name && imxdma->err_handler) {
-			imxdma->err_handler(i, imxdma->data, errcode);
-			continue;
-		}
-
-		imx_dma_channels[i].sg = NULL;
-
-		printk(KERN_WARNING
-		       "DMA timeout on channel %d (%s) -%s%s%s%s\n",
-		       i, imxdma->name,
-		       errcode & IMX_DMA_ERR_BURST ?    " burst" : "",
-		       errcode & IMX_DMA_ERR_REQUEST ?  " request" : "",
-		       errcode & IMX_DMA_ERR_TRANSFER ? " transfer" : "",
-		       errcode & IMX_DMA_ERR_BUFFER ?   " buffer" : "");
-	}
-	return IRQ_HANDLED;
-}
-
-static void dma_irq_handle_channel(int chno)
-{
-	struct imx_dma_channel *imxdma = &imx_dma_channels[chno];
-
-	if (!imxdma->name) {
-		/*
-		 * IRQ for an unregistered DMA channel:
-		 * let's clear the interrupts and disable it.
-		 */
-		printk(KERN_WARNING
-		       "spurious IRQ for DMA channel %d\n", chno);
-		return;
-	}
-
-	if (imxdma->sg) {
-		u32 tmp;
-		struct scatterlist *current_sg = imxdma->sg;
-		imxdma->sg = sg_next(imxdma->sg);
-
-		if (imxdma->sg) {
-			imx_dma_sg_next(chno, imxdma->sg);
-
-			tmp = imx_dmav1_readl(DMA_CCR(chno));
-
-			if (imx_dma_hw_chain(imxdma)) {
-				/* FIXME: The timeout should probably be
-				 * configurable
-				 */
-				mod_timer(&imxdma->watchdog,
-					jiffies + msecs_to_jiffies(500));
-
-				tmp |= CCR_CEN | CCR_RPT | CCR_ACRPT;
-				imx_dmav1_writel(tmp, DMA_CCR(chno));
-			} else {
-				imx_dmav1_writel(tmp & ~CCR_CEN, DMA_CCR(chno));
-				tmp |= CCR_CEN;
-			}
-
-			imx_dmav1_writel(tmp, DMA_CCR(chno));
-
-			if (imxdma->prog_handler)
-				imxdma->prog_handler(chno, imxdma->data,
-						current_sg);
-
-			return;
-		}
-
-		if (imx_dma_hw_chain(imxdma)) {
-			del_timer(&imxdma->watchdog);
-			return;
-		}
-	}
-
-	imx_dmav1_writel(0, DMA_CCR(chno));
-	imxdma->in_use = 0;
-	if (imxdma->irq_handler)
-		imxdma->irq_handler(chno, imxdma->data);
-}
-
-static irqreturn_t dma_irq_handler(int irq, void *dev_id)
-{
-	int i, disr;
-
-	if (cpu_is_mx21() || cpu_is_mx27())
-		dma_err_handler(irq, dev_id);
-
-	disr = imx_dmav1_readl(DMA_DISR);
-
-	pr_debug("imxdma: dma_irq_handler called, disr=0x%08x\n",
-		     disr);
-
-	imx_dmav1_writel(disr, DMA_DISR);
-	for (i = 0; i < IMX_DMA_CHANNELS; i++) {
-		if (disr & (1 << i))
-			dma_irq_handle_channel(i);
-	}
-
-	return IRQ_HANDLED;
-}
-
-/**
- * imx_dma_request - request/allocate specified channel number
- * @channel: i.MX DMA channel number
- * @name: the driver/caller own non-%NULL identification
- */
-int imx_dma_request(int channel, const char *name)
-{
-	struct imx_dma_channel *imxdma = &imx_dma_channels[channel];
-	unsigned long flags;
-	int ret = 0;
-
-	/* basic sanity checks */
-	if (!name)
-		return -EINVAL;
-
-	if (channel >= IMX_DMA_CHANNELS) {
-		printk(KERN_CRIT "%s: called for  non-existed channel %d\n",
-		       __func__, channel);
-		return -EINVAL;
-	}
-
-	local_irq_save(flags);
-	if (imxdma->name) {
-		local_irq_restore(flags);
-		return -EBUSY;
-	}
-	memset(imxdma, 0, sizeof(*imxdma));
-	imxdma->name = name;
-	local_irq_restore(flags); /* request_irq() can block */
-
-	if (cpu_is_mx21() || cpu_is_mx27()) {
-		ret = request_irq(MX2x_INT_DMACH0 + channel,
-				dma_irq_handler, 0, "DMA", NULL);
-		if (ret) {
-			imxdma->name = NULL;
-			pr_crit("Can't register IRQ %d for DMA channel %d\n",
-					MX2x_INT_DMACH0 + channel, channel);
-			return ret;
-		}
-		init_timer(&imxdma->watchdog);
-		imxdma->watchdog.function = &imx_dma_watchdog;
-		imxdma->watchdog.data = channel;
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL(imx_dma_request);
-
-/**
- * imx_dma_free - release previously acquired channel
- * @channel: i.MX DMA channel number
- */
-void imx_dma_free(int channel)
-{
-	unsigned long flags;
-	struct imx_dma_channel *imxdma = &imx_dma_channels[channel];
-
-	if (!imxdma->name) {
-		printk(KERN_CRIT
-		       "%s: trying to free free channel %d\n",
-		       __func__, channel);
-		return;
-	}
-
-	local_irq_save(flags);
-	/* Disable interrupts */
-	imx_dma_disable(channel);
-	imxdma->name = NULL;
-
-	if (cpu_is_mx21() || cpu_is_mx27())
-		free_irq(MX2x_INT_DMACH0 + channel, NULL);
-
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL(imx_dma_free);
-
-/**
- * imx_dma_request_by_prio - find and request some of free channels best
- * suiting requested priority
- * @channel: i.MX DMA channel number
- * @name: the driver/caller own non-%NULL identification
- *
- * This function tries to find a free channel in the specified priority group
- * if the priority cannot be achieved it tries to look for free channel
- * in the higher and then even lower priority groups.
- *
- * Return value: If there is no free channel to allocate, -%ENODEV is returned.
- *               On successful allocation channel is returned.
- */
-int imx_dma_request_by_prio(const char *name, enum imx_dma_prio prio)
-{
-	int i;
-	int best;
-
-	switch (prio) {
-	case (DMA_PRIO_HIGH):
-		best = 8;
-		break;
-	case (DMA_PRIO_MEDIUM):
-		best = 4;
-		break;
-	case (DMA_PRIO_LOW):
-	default:
-		best = 0;
-		break;
-	}
-
-	for (i = best; i < IMX_DMA_CHANNELS; i++)
-		if (!imx_dma_request(i, name))
-			return i;
-
-	for (i = best - 1; i >= 0; i--)
-		if (!imx_dma_request(i, name))
-			return i;
-
-	printk(KERN_ERR "%s: no free DMA channel found\n", __func__);
-
-	return -ENODEV;
-}
-EXPORT_SYMBOL(imx_dma_request_by_prio);
-
-static int __init imx_dma_init(void)
-{
-	int ret = 0;
-	int i;
-
-	if (cpu_is_mx1())
-		imx_dmav1_baseaddr = MX1_IO_ADDRESS(MX1_DMA_BASE_ADDR);
-	else if (cpu_is_mx21())
-		imx_dmav1_baseaddr = MX21_IO_ADDRESS(MX21_DMA_BASE_ADDR);
-	else if (cpu_is_mx27())
-		imx_dmav1_baseaddr = MX27_IO_ADDRESS(MX27_DMA_BASE_ADDR);
-	else
-		return 0;
-
-	dma_clk = clk_get(NULL, "dma");
-	if (IS_ERR(dma_clk))
-		return PTR_ERR(dma_clk);
-	clk_enable(dma_clk);
-
-	/* reset DMA module */
-	imx_dmav1_writel(DCR_DRST, DMA_DCR);
-
-	if (cpu_is_mx1()) {
-		ret = request_irq(MX1_DMA_INT, dma_irq_handler, 0, "DMA", NULL);
-		if (ret) {
-			pr_crit("Wow!  Can't register IRQ for DMA\n");
-			return ret;
-		}
-
-		ret = request_irq(MX1_DMA_ERR, dma_err_handler, 0, "DMA", NULL);
-		if (ret) {
-			pr_crit("Wow!  Can't register ERRIRQ for DMA\n");
-			free_irq(MX1_DMA_INT, NULL);
-			return ret;
-		}
-	}
-
-	/* enable DMA module */
-	imx_dmav1_writel(DCR_DEN, DMA_DCR);
-
-	/* clear all interrupts */
-	imx_dmav1_writel((1 << IMX_DMA_CHANNELS) - 1, DMA_DISR);
-
-	/* disable interrupts */
-	imx_dmav1_writel((1 << IMX_DMA_CHANNELS) - 1, DMA_DIMR);
-
-	for (i = 0; i < IMX_DMA_CHANNELS; i++) {
-		imx_dma_channels[i].sg = NULL;
-		imx_dma_channels[i].dma_num = i;
-	}
-
-	return ret;
-}
-
-arch_initcall(imx_dma_init);
diff --git a/arch/arm/mach-imx/include/mach/dma-v1.h b/arch/arm/mach-imx/include/mach/dma-v1.h
deleted file mode 100644
index ac6fd71..0000000
--- a/arch/arm/mach-imx/include/mach/dma-v1.h
+++ /dev/null
@@ -1,103 +0,0 @@
-/*
- *  linux/arch/arm/mach-imx/include/mach/dma-v1.h
- *
- *  i.MX DMA registration and IRQ dispatching
- *
- * Copyright 2006 Pavel Pisa <pisa@cmp.felk.cvut.cz>
- * Copyright 2008 Juergen Beisert, <kernel@pengutronix.de>
- * Copyright 2008 Sascha Hauer, <s.hauer@pengutronix.de>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
- * MA 02110-1301, USA.
- */
-
-#ifndef __MACH_DMA_V1_H__
-#define __MACH_DMA_V1_H__
-
-#define imx_has_dma_v1()	(cpu_is_mx1() || cpu_is_mx21() || cpu_is_mx27())
-
-#include <mach/dma.h>
-
-#define IMX_DMA_CHANNELS  16
-
-#define DMA_MODE_READ		0
-#define DMA_MODE_WRITE		1
-#define DMA_MODE_MASK		1
-
-#define MX1_DMA_REG(offset)	MX1_IO_ADDRESS(MX1_DMA_BASE_ADDR + (offset))
-
-/* DMA Interrupt Mask Register */
-#define MX1_DMA_DIMR		MX1_DMA_REG(0x08)
-
-/* Channel Control Register */
-#define MX1_DMA_CCR(x)		MX1_DMA_REG(0x8c + ((x) << 6))
-
-#define IMX_DMA_MEMSIZE_32	(0 << 4)
-#define IMX_DMA_MEMSIZE_8	(1 << 4)
-#define IMX_DMA_MEMSIZE_16	(2 << 4)
-#define IMX_DMA_TYPE_LINEAR	(0 << 10)
-#define IMX_DMA_TYPE_2D		(1 << 10)
-#define IMX_DMA_TYPE_FIFO	(2 << 10)
-
-#define IMX_DMA_ERR_BURST     (1 << 0)
-#define IMX_DMA_ERR_REQUEST   (1 << 1)
-#define IMX_DMA_ERR_TRANSFER  (1 << 2)
-#define IMX_DMA_ERR_BUFFER    (1 << 3)
-#define IMX_DMA_ERR_TIMEOUT   (1 << 4)
-
-int
-imx_dma_config_channel(int channel, unsigned int config_port,
-	unsigned int config_mem, unsigned int dmareq, int hw_chaining);
-
-void
-imx_dma_config_burstlen(int channel, unsigned int burstlen);
-
-int
-imx_dma_setup_single(int channel, dma_addr_t dma_address,
-		unsigned int dma_length, unsigned int dev_addr,
-		unsigned int dmamode);
-
-
-/*
- * Use this flag as the dma_length argument to imx_dma_setup_sg()
- * to create an endless running dma loop. The end of the scatterlist
- * must be linked to the beginning for this to work.
- */
-#define IMX_DMA_LENGTH_LOOP	((unsigned int)-1)
-
-int
-imx_dma_setup_sg(int channel, struct scatterlist *sg,
-		unsigned int sgcount, unsigned int dma_length,
-		unsigned int dev_addr, unsigned int dmamode);
-
-int
-imx_dma_setup_handlers(int channel,
-		void (*irq_handler) (int, void *),
-		void (*err_handler) (int, void *, int), void *data);
-
-int
-imx_dma_setup_progression_handler(int channel,
-		void (*prog_handler) (int, void*, struct scatterlist*));
-
-void imx_dma_enable(int channel);
-
-void imx_dma_disable(int channel);
-
-int imx_dma_request(int channel, const char *name);
-
-void imx_dma_free(int channel);
-
-int imx_dma_request_by_prio(const char *name, enum imx_dma_prio prio);
-
-#endif	/* __MACH_DMA_V1_H__ */
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index f1a2749..eb58b91 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -231,7 +231,6 @@ config IMX_SDMA
 
 config IMX_DMA
 	tristate "i.MX DMA support"
-	depends on IMX_HAVE_DMA_V1
 	select DMA_ENGINE
 	help
 	  Support the i.MX DMA engine. This engine is integrated into
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index c32103f..28d716c 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -14,7 +14,6 @@
  * http://www.opensource.org/licenses/gpl-license.html
  * http://www.gnu.org/copyleft/gpl.html
  */
-
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -25,14 +24,88 @@
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
+#include <linux/clk.h>
 #include <linux/dmaengine.h>
 #include <linux/module.h>
 
 #include <asm/irq.h>
-#include <mach/dma-v1.h>
+#include <mach/dma.h>
 #include <mach/hardware.h>
 
 #define IMXDMA_MAX_CHAN_DESCRIPTORS	16
+#define IMX_DMA_CHANNELS  16
+
+#define DMA_MODE_READ		0
+#define DMA_MODE_WRITE		1
+#define DMA_MODE_MASK		1
+
+#define IMX_DMA_LENGTH_LOOP	((unsigned int)-1)
+#define IMX_DMA_MEMSIZE_32	(0 << 4)
+#define IMX_DMA_MEMSIZE_8	(1 << 4)
+#define IMX_DMA_MEMSIZE_16	(2 << 4)
+#define IMX_DMA_TYPE_LINEAR	(0 << 10)
+#define IMX_DMA_TYPE_2D		(1 << 10)
+#define IMX_DMA_TYPE_FIFO	(2 << 10)
+
+#define IMX_DMA_ERR_BURST     (1 << 0)
+#define IMX_DMA_ERR_REQUEST   (1 << 1)
+#define IMX_DMA_ERR_TRANSFER  (1 << 2)
+#define IMX_DMA_ERR_BUFFER    (1 << 3)
+#define IMX_DMA_ERR_TIMEOUT   (1 << 4)
+
+#define DMA_DCR     0x00		/* Control Register */
+#define DMA_DISR    0x04		/* Interrupt status Register */
+#define DMA_DIMR    0x08		/* Interrupt mask Register */
+#define DMA_DBTOSR  0x0c		/* Burst timeout status Register */
+#define DMA_DRTOSR  0x10		/* Request timeout Register */
+#define DMA_DSESR   0x14		/* Transfer Error Status Register */
+#define DMA_DBOSR   0x18		/* Buffer overflow status Register */
+#define DMA_DBTOCR  0x1c		/* Burst timeout control Register */
+#define DMA_WSRA    0x40		/* W-Size Register A */
+#define DMA_XSRA    0x44		/* X-Size Register A */
+#define DMA_YSRA    0x48		/* Y-Size Register A */
+#define DMA_WSRB    0x4c		/* W-Size Register B */
+#define DMA_XSRB    0x50		/* X-Size Register B */
+#define DMA_YSRB    0x54		/* Y-Size Register B */
+#define DMA_SAR(x)  (0x80 + ((x) << 6))	/* Source Address Registers */
+#define DMA_DAR(x)  (0x84 + ((x) << 6))	/* Destination Address Registers */
+#define DMA_CNTR(x) (0x88 + ((x) << 6))	/* Count Registers */
+#define DMA_CCR(x)  (0x8c + ((x) << 6))	/* Control Registers */
+#define DMA_RSSR(x) (0x90 + ((x) << 6))	/* Request source select Registers */
+#define DMA_BLR(x)  (0x94 + ((x) << 6))	/* Burst length Registers */
+#define DMA_RTOR(x) (0x98 + ((x) << 6))	/* Request timeout Registers */
+#define DMA_BUCR(x) (0x98 + ((x) << 6))	/* Bus Utilization Registers */
+#define DMA_CCNR(x) (0x9C + ((x) << 6))	/* Channel counter Registers */
+
+#define DCR_DRST           (1<<1)
+#define DCR_DEN            (1<<0)
+#define DBTOCR_EN          (1<<15)
+#define DBTOCR_CNT(x)      ((x) & 0x7fff)
+#define CNTR_CNT(x)        ((x) & 0xffffff)
+#define CCR_ACRPT          (1<<14)
+#define CCR_DMOD_LINEAR    (0x0 << 12)
+#define CCR_DMOD_2D        (0x1 << 12)
+#define CCR_DMOD_FIFO      (0x2 << 12)
+#define CCR_DMOD_EOBFIFO   (0x3 << 12)
+#define CCR_SMOD_LINEAR    (0x0 << 10)
+#define CCR_SMOD_2D        (0x1 << 10)
+#define CCR_SMOD_FIFO      (0x2 << 10)
+#define CCR_SMOD_EOBFIFO   (0x3 << 10)
+#define CCR_MDIR_DEC       (1<<9)
+#define CCR_MSEL_B         (1<<8)
+#define CCR_DSIZ_32        (0x0 << 6)
+#define CCR_DSIZ_8         (0x1 << 6)
+#define CCR_DSIZ_16        (0x2 << 6)
+#define CCR_SSIZ_32        (0x0 << 4)
+#define CCR_SSIZ_8         (0x1 << 4)
+#define CCR_SSIZ_16        (0x2 << 4)
+#define CCR_REN            (1<<3)
+#define CCR_RPT            (1<<2)
+#define CCR_FRC            (1<<1)
+#define CCR_CEN            (1<<0)
+#define RTOR_EN            (1<<15)
+#define RTOR_CLK           (1<<14)
+#define RTOR_PSC           (1<<13)
 
 enum  imxdma_prep_type {
 	IMXDMA_DESC_MEMCPY,
@@ -41,6 +114,39 @@ enum  imxdma_prep_type {
 	IMXDMA_DESC_CYCLIC,
 };
 
+/*
+ * struct imxdma_channel_internal - i.MX specific DMA extension
+ * @name: name specified by DMA client
+ * @irq_handler: client callback for end of transfer
+ * @err_handler: client callback for error condition
+ * @data: clients context data for callbacks
+ * @dma_mode: direction of the transfer %DMA_MODE_READ or %DMA_MODE_WRITE
+ * @sg: pointer to the actual read/written chunk for scatter-gather emulation
+ * @resbytes: total residual number of bytes to transfer
+ *            (it can be lower or same as sum of SG mapped chunk sizes)
+ * @sgcount: number of chunks to be read/written
+ *
+ * Structure is used for IMX DMA processing. It would be probably good
+ * @struct dma_struct in the future for external interfacing and use
+ * @struct imxdma_channel_internal only as extension to it.
+ */
+
+struct imxdma_channel_internal {
+	void *data;
+	unsigned int dma_mode;
+	struct scatterlist *sg;
+	unsigned int resbytes;
+
+	int in_use;
+
+	u32 ccr_from_device;
+	u32 ccr_to_device;
+
+	struct timer_list watchdog;
+
+	int hw_chaining;
+};
+
 struct imxdma_desc {
 	struct list_head		node;
 	struct dma_async_tx_descriptor	desc;
@@ -63,9 +169,9 @@ struct imxdma_desc {
 };
 
 struct imxdma_channel {
+	struct imxdma_channel_internal	internal;
 	struct imxdma_engine		*imxdma;
 	unsigned int			channel;
-	unsigned int			imxdma_channel;
 
 	struct tasklet_struct		dma_tasklet;
 	struct list_head		ld_free;
@@ -109,28 +215,381 @@ static inline bool imxdma_chan_is_doing_cyclic(struct imxdma_channel *imxdmac)
 	return false;
 }
 
-static void imxdma_irq_handler(int channel, void *data)
+/* TODO: put this inside any struct */
+static void __iomem *imx_dmav1_baseaddr;
+static struct clk *dma_clk;
+
+static void imx_dmav1_writel(unsigned val, unsigned offset)
 {
-	struct imxdma_channel *imxdmac = data;
+	__raw_writel(val, imx_dmav1_baseaddr + offset);
+}
 
-	tasklet_schedule(&imxdmac->dma_tasklet);
+static unsigned imx_dmav1_readl(unsigned offset)
+{
+	return __raw_readl(imx_dmav1_baseaddr + offset);
 }
 
-static void imxdma_err_handler(int channel, void *data, int error)
+static int imxdma_hw_chain(struct imxdma_channel_internal *imxdma)
 {
-	struct imxdma_channel *imxdmac = data;
+	if (cpu_is_mx27())
+		return imxdma->hw_chaining;
+	else
+		return 0;
+}
+
+/*
+ * imxdma_sg_next - prepare next chunk for scatter-gather DMA emulation
+ */
+static inline int imxdma_sg_next(struct imxdma_channel *imxdmac, struct scatterlist *sg)
+{
+	struct imxdma_channel_internal *imxdma = &imxdmac->internal;
+	unsigned long now;
+
+	now = min(imxdma->resbytes, sg->length);
+	if (imxdma->resbytes != IMX_DMA_LENGTH_LOOP)
+		imxdma->resbytes -= now;
+
+	if ((imxdma->dma_mode & DMA_MODE_MASK) == DMA_MODE_READ)
+		imx_dmav1_writel(sg->dma_address, DMA_DAR(imxdmac->channel));
+	else
+		imx_dmav1_writel(sg->dma_address, DMA_SAR(imxdmac->channel));
+
+	imx_dmav1_writel(now, DMA_CNTR(imxdmac->channel));
+
+	pr_debug("imxdma%d: next sg chunk dst 0x%08x, src 0x%08x, "
+		"size 0x%08x\n", imxdmac->channel,
+		 imx_dmav1_readl(DMA_DAR(imxdmac->channel)),
+		 imx_dmav1_readl(DMA_SAR(imxdmac->channel)),
+		 imx_dmav1_readl(DMA_CNTR(imxdmac->channel)));
+
+	return now;
+}
+
+static int
+imxdma_setup_single_hw(struct imxdma_channel *imxdmac, dma_addr_t dma_address,
+		     unsigned int dma_length, unsigned int dev_addr,
+		     unsigned int dmamode)
+{
+	int channel = imxdmac->channel;
+
+	imxdmac->internal.sg = NULL;
+	imxdmac->internal.dma_mode = dmamode;
+
+	if (!dma_address) {
+		printk(KERN_ERR "imxdma%d: imx_dma_setup_single null address\n",
+		       channel);
+		return -EINVAL;
+	}
+
+	if (!dma_length) {
+		printk(KERN_ERR "imxdma%d: imx_dma_setup_single zero length\n",
+		       channel);
+		return -EINVAL;
+	}
+
+	if ((dmamode & DMA_MODE_MASK) == DMA_MODE_READ) {
+		pr_debug("imxdma%d: %s dma_addressg=0x%08x dma_length=%d "
+			"dev_addr=0x%08x for read\n",
+			channel, __func__, (unsigned int)dma_address,
+			dma_length, dev_addr);
+
+		imx_dmav1_writel(dev_addr, DMA_SAR(channel));
+		imx_dmav1_writel(dma_address, DMA_DAR(channel));
+		imx_dmav1_writel(imxdmac->internal.ccr_from_device, DMA_CCR(channel));
+	} else if ((dmamode & DMA_MODE_MASK) == DMA_MODE_WRITE) {
+		pr_debug("imxdma%d: %s dma_addressg=0x%08x dma_length=%d "
+			"dev_addr=0x%08x for write\n",
+			channel, __func__, (unsigned int)dma_address,
+			dma_length, dev_addr);
+
+		imx_dmav1_writel(dma_address, DMA_SAR(channel));
+		imx_dmav1_writel(dev_addr, DMA_DAR(channel));
+		imx_dmav1_writel(imxdmac->internal.ccr_to_device,
+				DMA_CCR(channel));
+	} else {
+		printk(KERN_ERR "imxdma%d: imx_dma_setup_single bad dmamode\n",
+		       channel);
+		return -EINVAL;
+	}
 
+	imx_dmav1_writel(dma_length, DMA_CNTR(channel));
+
+	return 0;
+}
+
+static void imxdma_enable_hw(struct imxdma_channel *imxdmac)
+{
+	int channel = imxdmac->channel;
+	unsigned long flags;
+
+	pr_debug("imxdma%d: imx_dma_enable\n", channel);
+
+	if (imxdmac->internal.in_use)
+		return;
+
+	local_irq_save(flags);
+
+	imx_dmav1_writel(1 << channel, DMA_DISR);
+	imx_dmav1_writel(imx_dmav1_readl(DMA_DIMR) & ~(1 << channel), DMA_DIMR);
+	imx_dmav1_writel(imx_dmav1_readl(DMA_CCR(channel)) | CCR_CEN |
+		CCR_ACRPT, DMA_CCR(channel));
+
+	if ((cpu_is_mx21() || cpu_is_mx27()) &&
+			imxdmac->internal.sg && imxdma_hw_chain(&imxdmac->internal)) {
+		imxdmac->internal.sg = sg_next(imxdmac->internal.sg);
+		if (imxdmac->internal.sg) {
+			u32 tmp;
+			imxdma_sg_next(imxdmac, imxdmac->internal.sg);
+			tmp = imx_dmav1_readl(DMA_CCR(channel));
+			imx_dmav1_writel(tmp | CCR_RPT | CCR_ACRPT,
+				DMA_CCR(channel));
+		}
+	}
+	imxdmac->internal.in_use = 1;
+
+	local_irq_restore(flags);
+}
+
+static void imxdma_disable_hw(struct imxdma_channel *imxdmac)
+{
+	int channel = imxdmac->channel;
+	unsigned long flags;
+
+	pr_debug("imxdma%d: imx_dma_disable\n", channel);
+
+	if (imxdma_hw_chain(&imxdmac->internal))
+		del_timer(&imxdmac->internal.watchdog);
+
+	local_irq_save(flags);
+	imx_dmav1_writel(imx_dmav1_readl(DMA_DIMR) | (1 << channel), DMA_DIMR);
+	imx_dmav1_writel(imx_dmav1_readl(DMA_CCR(channel)) & ~CCR_CEN,
+			DMA_CCR(channel));
+	imx_dmav1_writel(1 << channel, DMA_DISR);
+	imxdmac->internal.in_use = 0;
+	local_irq_restore(flags);
+}
+
+static int
+imxdma_config_channel_hw(struct imxdma_channel *imxdmac, unsigned int config_port,
+	unsigned int config_mem, unsigned int dmareq, int hw_chaining)
+{
+	int channel = imxdmac->channel;
+	u32 dreq = 0;
+
+	imxdmac->internal.hw_chaining = 0;
+
+	if (hw_chaining) {
+		imxdmac->internal.hw_chaining = 1;
+		if (!imxdma_hw_chain(&imxdmac->internal))
+			return -EINVAL;
+	}
+
+	if (dmareq)
+		dreq = CCR_REN;
+
+	imxdmac->internal.ccr_from_device = config_port | (config_mem << 2) | dreq;
+	imxdmac->internal.ccr_to_device = config_mem | (config_port << 2) | dreq;
+
+	imx_dmav1_writel(dmareq, DMA_RSSR(channel));
+
+	return 0;
+}
+
+static int
+imxdma_setup_sg_hw(struct imxdma_channel *imxdmac,
+		 struct scatterlist *sg, unsigned int sgcount,
+		 unsigned int dma_length, unsigned int dev_addr,
+		 unsigned int dmamode)
+{
+	int channel = imxdmac->channel;
+
+	if (imxdmac->internal.in_use)
+		return -EBUSY;
+
+	imxdmac->internal.sg = sg;
+	imxdmac->internal.dma_mode = dmamode;
+	imxdmac->internal.resbytes = dma_length;
+
+	if (!sg || !sgcount) {
+		printk(KERN_ERR "imxdma%d: imx_dma_setup_sg empty sg list\n",
+		       channel);
+		return -EINVAL;
+	}
+
+	if (!sg->length) {
+		printk(KERN_ERR "imxdma%d: imx_dma_setup_sg zero length\n",
+		       channel);
+		return -EINVAL;
+	}
+
+	if ((dmamode & DMA_MODE_MASK) == DMA_MODE_READ) {
+		pr_debug("imxdma%d: %s sg=%p sgcount=%d total length=%d "
+			"dev_addr=0x%08x for read\n",
+			channel, __func__, sg, sgcount, dma_length, dev_addr);
+
+		imx_dmav1_writel(dev_addr, DMA_SAR(channel));
+		imx_dmav1_writel(imxdmac->internal.ccr_from_device, DMA_CCR(channel));
+	} else if ((dmamode & DMA_MODE_MASK) == DMA_MODE_WRITE) {
+		pr_debug("imxdma%d: %s sg=%p sgcount=%d total length=%d "
+			"dev_addr=0x%08x for write\n",
+			channel, __func__, sg, sgcount, dma_length, dev_addr);
+
+		imx_dmav1_writel(dev_addr, DMA_DAR(channel));
+		imx_dmav1_writel(imxdmac->internal.ccr_to_device, DMA_CCR(channel));
+	} else {
+		printk(KERN_ERR "imxdma%d: imx_dma_setup_sg bad dmamode\n",
+		       channel);
+		return -EINVAL;
+	}
+
+	imxdma_sg_next(imxdmac, sg);
+
+	return 0;
+}
+
+static void imxdma_watchdog(unsigned long data)
+{
+	struct imxdma_channel *imxdmac = (struct imxdma_channel *)data;
+	int channel = imxdmac->channel;
+
+	imx_dmav1_writel(0, DMA_CCR(channel));
+	imxdmac->internal.in_use = 0;
+	imxdmac->internal.sg = NULL;
+
+	/* Tasklet watchdog error handler */
 	tasklet_schedule(&imxdmac->dma_tasklet);
+	pr_debug("imxdma%d: watchdog timeout!\n", imxdmac->channel);
+}
+
+static irqreturn_t imxdma_err_handler(int irq, void *dev_id)
+{
+	struct imxdma_engine *imxdma = dev_id;
+	struct imxdma_channel_internal *internal;
+	unsigned int err_mask;
+	int i, disr;
+	int errcode;
+
+	disr = imx_dmav1_readl(DMA_DISR);
+
+	err_mask = imx_dmav1_readl(DMA_DBTOSR) |
+		   imx_dmav1_readl(DMA_DRTOSR) |
+		   imx_dmav1_readl(DMA_DSESR)  |
+		   imx_dmav1_readl(DMA_DBOSR);
+
+	if (!err_mask)
+		return IRQ_HANDLED;
+
+	imx_dmav1_writel(disr & err_mask, DMA_DISR);
+
+	for (i = 0; i < IMX_DMA_CHANNELS; i++) {
+		if (!(err_mask & (1 << i)))
+			continue;
+		internal = &imxdma->channel[i].internal;
+		errcode = 0;
+
+		if (imx_dmav1_readl(DMA_DBTOSR) & (1 << i)) {
+			imx_dmav1_writel(1 << i, DMA_DBTOSR);
+			errcode |= IMX_DMA_ERR_BURST;
+		}
+		if (imx_dmav1_readl(DMA_DRTOSR) & (1 << i)) {
+			imx_dmav1_writel(1 << i, DMA_DRTOSR);
+			errcode |= IMX_DMA_ERR_REQUEST;
+		}
+		if (imx_dmav1_readl(DMA_DSESR) & (1 << i)) {
+			imx_dmav1_writel(1 << i, DMA_DSESR);
+			errcode |= IMX_DMA_ERR_TRANSFER;
+		}
+		if (imx_dmav1_readl(DMA_DBOSR) & (1 << i)) {
+			imx_dmav1_writel(1 << i, DMA_DBOSR);
+			errcode |= IMX_DMA_ERR_BUFFER;
+		}
+		/* Tasklet error handler */
+		tasklet_schedule(&imxdma->channel[i].dma_tasklet);
+
+		printk(KERN_WARNING
+		       "DMA timeout on channel %d -%s%s%s%s\n", i,
+		       errcode & IMX_DMA_ERR_BURST ?    " burst" : "",
+		       errcode & IMX_DMA_ERR_REQUEST ?  " request" : "",
+		       errcode & IMX_DMA_ERR_TRANSFER ? " transfer" : "",
+		       errcode & IMX_DMA_ERR_BUFFER ?   " buffer" : "");
+	}
+	return IRQ_HANDLED;
 }
 
-static void imxdma_progression(int channel, void *data,
-		struct scatterlist *sg)
+static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 {
-	struct imxdma_channel *imxdmac = data;
+	struct imxdma_channel_internal *imxdma = &imxdmac->internal;
+	int chno = imxdmac->channel;
+
+	if (imxdma->sg) {
+		u32 tmp;
+		imxdma->sg = sg_next(imxdma->sg);
+
+		if (imxdma->sg) {
+			imxdma_sg_next(imxdmac, imxdma->sg);
+
+			tmp = imx_dmav1_readl(DMA_CCR(chno));
+
+			if (imxdma_hw_chain(imxdma)) {
+				/* FIXME: The timeout should probably be
+				 * configurable
+				 */
+				mod_timer(&imxdma->watchdog,
+					jiffies + msecs_to_jiffies(500));
+
+				tmp |= CCR_CEN | CCR_RPT | CCR_ACRPT;
+				imx_dmav1_writel(tmp, DMA_CCR(chno));
+			} else {
+				imx_dmav1_writel(tmp & ~CCR_CEN, DMA_CCR(chno));
+				tmp |= CCR_CEN;
+			}
+
+			imx_dmav1_writel(tmp, DMA_CCR(chno));
+
+			if (imxdma_chan_is_doing_cyclic(imxdmac))
+				/* Tasklet progression */
+				tasklet_schedule(&imxdmac->dma_tasklet);
+
+			return;
+		}
 
+		if (imxdma_hw_chain(imxdma)) {
+			del_timer(&imxdma->watchdog);
+			return;
+		}
+	}
+
+	imx_dmav1_writel(0, DMA_CCR(chno));
+	imxdma->in_use = 0;
+	/* Tasklet irq */
 	tasklet_schedule(&imxdmac->dma_tasklet);
 }
 
+static irqreturn_t dma_irq_handler(int irq, void *dev_id)
+{
+	struct imxdma_engine *imxdma = dev_id;
+	struct imxdma_channel_internal *internal;
+	int i, disr;
+
+	if (cpu_is_mx21() || cpu_is_mx27())
+		imxdma_err_handler(irq, dev_id);
+
+	disr = imx_dmav1_readl(DMA_DISR);
+
+	pr_debug("imxdma: dma_irq_handler called, disr=0x%08x\n",
+		     disr);
+
+	imx_dmav1_writel(disr, DMA_DISR);
+	for (i = 0; i < IMX_DMA_CHANNELS; i++) {
+		if (disr & (1 << i)) {
+			internal = &imxdma->channel[i].internal;
+			dma_irq_handle_channel(&imxdma->channel[i]);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
 static int imxdma_xfer_desc(struct imxdma_desc *d)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
@@ -139,31 +598,24 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 	/* Configure and enable */
 	switch (d->type) {
 	case IMXDMA_DESC_MEMCPY:
-		ret = imx_dma_config_channel(imxdmac->imxdma_channel,
+		ret = imxdma_config_channel_hw(imxdmac,
 					  d->config_port, d->config_mem, 0, 0);
 		if (ret < 0)
 			return ret;
-		ret = imx_dma_setup_single(imxdmac->imxdma_channel, d->src,
+		ret = imxdma_setup_single_hw(imxdmac, d->src,
 					   d->len, d->dest, d->dmamode);
 		if (ret < 0)
 			return ret;
 		break;
+
+	/* Cyclic transfer is the same as slave_sg with special sg configuration. */
 	case IMXDMA_DESC_CYCLIC:
-		ret = imx_dma_setup_progression_handler(imxdmac->imxdma_channel,
-							imxdma_progression);
-		if (ret < 0)
-			return ret;
-		/*
-		 * We fall through here since cyclic transfer is the same as
-		 * slave_sg adding a progression handler and a specific sg
-		 * configuration which is done in 'imxdma_prep_dma_cyclic'.
-		 */
 	case IMXDMA_DESC_SLAVE_SG:
 		if (d->dmamode == DMA_MODE_READ)
-			ret = imx_dma_setup_sg(imxdmac->imxdma_channel, d->sg,
+			ret = imxdma_setup_sg_hw(imxdmac, d->sg,
 				       d->sgcount, d->len, d->src, d->dmamode);
 		else
-			ret = imx_dma_setup_sg(imxdmac->imxdma_channel, d->sg,
+			ret = imxdma_setup_sg_hw(imxdmac, d->sg,
 				      d->sgcount, d->len, d->dest, d->dmamode);
 		if (ret < 0)
 			return ret;
@@ -171,7 +623,7 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 	default:
 		return -EINVAL;
 	}
-	imx_dma_enable(imxdmac->imxdma_channel);
+	imxdma_enable_hw(imxdmac);
 	return 0;
 }
 
@@ -223,7 +675,7 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
-		imx_dma_disable(imxdmac->imxdma_channel);
+		imxdma_disable_hw(imxdmac);
 
 		spin_lock_irqsave(&imxdmac->lock, flags);
 		list_splice_tail_init(&imxdmac->ld_active, &imxdmac->ld_free);
@@ -253,16 +705,16 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 			mode = IMX_DMA_MEMSIZE_32;
 			break;
 		}
-		ret = imx_dma_config_channel(imxdmac->imxdma_channel,
+		ret = imxdma_config_channel_hw(imxdmac,
 				mode | IMX_DMA_TYPE_FIFO,
 				IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR,
 				imxdmac->dma_request, 1);
 
 		if (ret)
 			return ret;
-
-		imx_dma_config_burstlen(imxdmac->imxdma_channel,
-				imxdmac->watermark_level * imxdmac->word_size);
+		/* Set burst length */
+		imx_dmav1_writel(imxdmac->watermark_level * imxdmac->word_size,
+				 DMA_BLR(imxdmac->channel));
 
 		return 0;
 	default:
@@ -359,7 +811,7 @@ static void imxdma_free_chan_resources(struct dma_chan *chan)
 
 	spin_lock_irqsave(&imxdmac->lock, flags);
 
-	imx_dma_disable(imxdmac->imxdma_channel);
+	imxdma_disable_hw(imxdmac);
 	list_splice_tail_init(&imxdmac->ld_active, &imxdmac->ld_free);
 	list_splice_tail_init(&imxdmac->ld_queue, &imxdmac->ld_free);
 
@@ -545,10 +997,51 @@ static void imxdma_issue_pending(struct dma_chan *chan)
 }
 
 static int __init imxdma_probe(struct platform_device *pdev)
-{
+	{
 	struct imxdma_engine *imxdma;
 	int ret, i;
 
+	if (cpu_is_mx1())
+		imx_dmav1_baseaddr = MX1_IO_ADDRESS(MX1_DMA_BASE_ADDR);
+	else if (cpu_is_mx21())
+		imx_dmav1_baseaddr = MX21_IO_ADDRESS(MX21_DMA_BASE_ADDR);
+	else if (cpu_is_mx27())
+		imx_dmav1_baseaddr = MX27_IO_ADDRESS(MX27_DMA_BASE_ADDR);
+	else
+		return 0;
+
+	dma_clk = clk_get(NULL, "dma");
+	if (IS_ERR(dma_clk))
+		return PTR_ERR(dma_clk);
+	clk_enable(dma_clk);
+
+	/* reset DMA module */
+	imx_dmav1_writel(DCR_DRST, DMA_DCR);
+
+	if (cpu_is_mx1()) {
+		ret = request_irq(MX1_DMA_INT, dma_irq_handler, 0, "DMA", imxdma);
+		if (ret) {
+			pr_crit("Can't register IRQ for DMA\n");
+			return ret;
+		}
+
+		ret = request_irq(MX1_DMA_ERR, imxdma_err_handler, 0, "DMA", imxdma);
+		if (ret) {
+			pr_crit("Can't register ERRIRQ for DMA\n");
+			free_irq(MX1_DMA_INT, NULL);
+			return ret;
+		}
+	}
+
+	/* enable DMA module */
+	imx_dmav1_writel(DCR_DEN, DMA_DCR);
+
+	/* clear all interrupts */
+	imx_dmav1_writel((1 << IMX_DMA_CHANNELS) - 1, DMA_DISR);
+
+	/* disable interrupts */
+	imx_dmav1_writel((1 << IMX_DMA_CHANNELS) - 1, DMA_DIMR);
+
 	imxdma = kzalloc(sizeof(*imxdma), GFP_KERNEL);
 	if (!imxdma)
 		return -ENOMEM;
@@ -562,17 +1055,20 @@ static int __init imxdma_probe(struct platform_device *pdev)
 	/* Initialize channel parameters */
 	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
 		struct imxdma_channel *imxdmac = &imxdma->channel[i];
-
-		imxdmac->imxdma_channel = imx_dma_request_by_prio("dmaengine",
-				DMA_PRIO_MEDIUM);
-		if ((int)imxdmac->channel < 0) {
-			ret = -ENODEV;
-			goto err_init;
+		memset(&imxdmac->internal, 0, sizeof(imxdmac->internal));
+		if (cpu_is_mx21() || cpu_is_mx27()) {
+			ret = request_irq(MX2x_INT_DMACH0 + i,
+					dma_irq_handler, 0, "DMA", imxdma);
+			if (ret) {
+				pr_crit("Can't register IRQ %d for DMA channel %d\n",
+						MX2x_INT_DMACH0 + i, i);
+				goto err_init;
+			}
+			init_timer(&imxdmac->internal.watchdog);
+			imxdmac->internal.watchdog.function = &imxdma_watchdog;
+			imxdmac->internal.watchdog.data = (unsigned long)imxdmac;
 		}
 
-		imx_dma_setup_handlers(imxdmac->imxdma_channel,
-		       imxdma_irq_handler, imxdma_err_handler, imxdmac);
-
 		imxdmac->imxdma = imxdma;
 		spin_lock_init(&imxdmac->lock);
 
@@ -617,10 +1113,8 @@ static int __init imxdma_probe(struct platform_device *pdev)
 	return 0;
 
 err_init:
-	while (--i >= 0) {
-		struct imxdma_channel *imxdmac = &imxdma->channel[i];
-		imx_dma_free(imxdmac->imxdma_channel);
-	}
+	while (--i >= 0)
+		free_irq(MX2x_INT_DMACH0 + i, NULL);
 
 	kfree(imxdma);
 	return ret;
@@ -633,11 +1127,8 @@ static int __exit imxdma_remove(struct platform_device *pdev)
 
         dma_async_device_unregister(&imxdma->dma_device);
 
-	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
-		struct imxdma_channel *imxdmac = &imxdma->channel[i];
-
-		 imx_dma_free(imxdmac->imxdma_channel);
-	}
+	for (i = 0; i < MAX_DMA_CHANNELS; i++)
+		free_irq(MX2x_INT_DMACH0 + i, NULL);
 
         kfree(imxdma);
 
-- 
1.7.0.4

