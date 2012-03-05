Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab2CEQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:16:56 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50087 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab2CEQQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:16:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of javier.martin@vista-silicon.com designates 10.180.105.194 as permitted sender) smtp.mail=javier.martin@vista-silicon.com
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 01/14] dmaengine: imx-dma: merge old dma-v1.c with imx-dma.c
Date: Mon,  5 Mar 2012 17:16:23 +0100
Message-Id: <1330964196-32623-2-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
References: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 arch/arm/mach-imx/Kconfig  |    6 -
 arch/arm/mach-imx/Makefile |    2 -
 drivers/dma/Kconfig        |    1 -
 drivers/dma/imx-dma.c      |  591 ++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 541 insertions(+), 59 deletions(-)

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

