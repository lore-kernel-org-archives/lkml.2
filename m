Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab2B1H2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:28:39 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:35081 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755798Ab2B1H2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:28:23 -0500
From: zhaoy <zhaoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk, hzhuang1@marvell.com,
        cxie4@marvell.com, leoy@marvell.com
Cc: zhaoy <zhaoy@marvell.com>
Subject: [PATCH 03/13] dmaengine: mmp: add two-channel dma driver
Date: Tue, 28 Feb 2012 15:27:35 +0800
Message-Id: <1330414065-2949-4-git-send-email-zhaoy@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <Y>
References: <Y>
X-OriginalArrivalTime: 28 Feb 2012 07:28:03.0298 (UTC) FILETIME=[81A2BC20:01CCF5EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1,Add support for two-channel dma, mainly for audio dma
	and memory dma.

Change-Id: I9b0f26e368c451d30fcfd73b0eda211c6f6c0468
Signed-off-by: zhaoy <zhaoy@marvell.com>
---
 arch/arm/mach-mmp/include/mach/mmp_dma.h |   89 +++-
 drivers/dma/mmp_tdma.c                   |  858 ++++++++++++++++++++++++++++++
 sound/soc/pxa/mmp-pcm.c                  |   11 +-
 sound/soc/pxa/mmp2-squ.c                 |   12 +-
 4 files changed, 948 insertions(+), 22 deletions(-)
 create mode 100644 drivers/dma/mmp_tdma.c

diff --git a/arch/arm/mach-mmp/include/mach/mmp_dma.h b/arch/arm/mach-mmp/include/mach/mmp_dma.h
index a36cdc1..eb39cd1 100644
--- a/arch/arm/mach-mmp/include/mach/mmp_dma.h
+++ b/arch/arm/mach-mmp/include/mach/mmp_dma.h
@@ -1,8 +1,28 @@
 #ifndef __MACH_MMP_DMA_H
 #define __MACH_MMP_DMA_H
 
+#if defined(CONFIG_CPU_MMP2) || defined(CONFIG_CPU_MMP3)
+#include <linux/device.h>
+#include <linux/dmaengine.h>
+#else
 #include <mach/mmp_audisland.h>
+#endif
 
+#if defined(CONFIG_CPU_MMP2) || defined(CONFIG_CPU_MMP3)
+/*
+ * Two-Channel DMA registers
+ */
+#define TDBCR			0x0	/* Byte Count Register */
+#define TDSAR			0x10	/* Src Addr Register */
+#define TDDAR			0x20	/* Dst Addr Register */
+#define TDNDPR			0x30	/* Next Desc Pointer Register */
+#define TDCR			0x40	/* Control Register */
+#define TDCP			0x60	/* Priority Register */
+#define TDCDPR			0x70	/* Current Desc Pointer Register */
+#define TDIMR			0x80	/* Int Mask Register */
+#define TDISR			0xa0	/* Int Status Register */
+#define FILLDATA		0xa8	/* Fill Data Register */
+#else
 #define __DMA_REG(x, y)		(*((volatile u32 *)(x + y)))
 
 #define ADMA1_CH0_BASE		(AUD_VIRT_BASE + 0x800)
@@ -25,6 +45,7 @@
 #define TDIMR(base)		__DMA_REG(base, 0x80)   /* Int Mask Register */
 #define TDISR(base)		__DMA_REG(base, 0xa0)   /* Int Status Register */
 #define VDCR(base)		__DMA_REG(base, 0x28)	/* FIXME: Remove VDMA from this file */
+#endif
 
 /* Two-Channel DMA Control Register */
 #define TDCR_SSZ_8_BITS		(0x0 << 22)	/* Sample Size */
@@ -68,6 +89,26 @@
 /* Two-Channel DMA Int Status Register */
 #define TDISR_COMP		(0x1 << 0)
 
+/*
+ * Two-Channel DMA Descriptor Struct
+ * NOTE: desc's buf must be aligned to 16 bytes.
+ */
+#if defined(CONFIG_CPU_MMP2) || defined(CONFIG_CPU_MMP3)
+struct mmp_tdma_desc {
+	u32 byte_cnt;
+	u32 src_addr;
+	u32 dst_addr;
+	u32 nxt_desc;
+};
+#else
+typedef struct mmp_tdma_desc {
+	volatile u32 byte_cnt;	/* byte count */
+	volatile u32 src_addr;	/* source address */
+	volatile u32 dst_addr;	/* target address */
+	volatile u32 nxt_desc;	/* next descriptor dress */
+} mmp_tdma_desc;
+#endif
+
 enum mmp_tdma_type {
 	MDMA1_CH0 = 0,
 	MDMA1_CH1,
@@ -80,22 +121,48 @@ enum mmp_tdma_type {
 	DMA_CH_NUM,
 };
 
-/*
- * Two-Channel DMA Descriptor Struct
- * NOTE: desc's buf must be aligned to 16 bytes.
- */
-typedef struct mmp_tdma_desc {
-	volatile u32 byte_cnt;	/* byte count */
-	volatile u32 src_addr;	/* source address */
-	volatile u32 dst_addr;	/* target address */
-	volatile u32 nxt_desc;	/* next descriptor dress */
-} mmp_tdma_desc;
+struct mmp_tdma_chan_info {
+	enum mmp_tdma_type type;
+	unsigned long reg_base;
+};
 
+struct mmp_tdma_platform_data {
+	unsigned int nr_ch;
+	struct mmp_tdma_chan_info *info;
+};
+
+struct mmp_tdma_data {
+	u32 bus_size;
+	u32 pack_mod;
+	int priority;
+};
+
+#if defined(CONFIG_CPU_MMP2) || defined(CONFIG_CPU_MMP3)
+static inline int mmp_tdma_is_this_type(struct dma_chan *chan)
+{
+	return !strcmp(dev_name(chan->device->dev), "mmp-tdma");
+}
+
+static inline int mmp_adma_is_this_type(struct dma_chan *chan)
+{
+	return !strcmp(dev_name(chan->device->dev), "mmp-adma");
+}
+
+static inline int mmp_mdma_is_this_type(struct dma_chan *chan)
+{
+	return !strcmp(dev_name(chan->device->dev), "mmp-mdma");
+}
+
+
+extern unsigned long mmp_tdma_chan_get_ptr(struct dma_chan *dmac);
+extern int mmp_tdma_is_specific_chan(struct dma_chan *chan,
+				     enum mmp_tdma_type type);
+#else
 int __init mmp_init_dma(unsigned int irq);
 unsigned int mmp_request_dma(char *name, unsigned int dma_ch,
 		void (*irq_handler)(int, void *), void *data);
 void mmp_free_dma(unsigned int dma_ch);
-
 u32 mmp_get_dma_reg_base(enum mmp_tdma_type dma_type);
+#endif
 
 #endif /* __MACH_MMP_DMA_H */
diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
new file mode 100644
index 0000000..29209f0
--- /dev/null
+++ b/drivers/dma/mmp_tdma.c
@@ -0,0 +1,858 @@
+/*
+ * drivers/dma/mmp-tdma.c
+ *
+ * Driver for Marvell Two-channel DMA engine
+ *
+ * Copyright 2011 Leo Yan <leoy@marvell.com>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ */
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/dmaengine.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+
+#include <asm/irq.h>
+#include <mach/dma.h>
+#include <mach/mmp_dma.h>
+#include <mach/regs-icu.h>
+#include <mach/sram.h>
+
+#define TDMA_DESC_SIZE		512
+#define TDMA_DESC_NUM		((int)(TDMA_DESC_SIZE / \
+				sizeof(struct mmp_tdma_desc)))
+#define TDMA_MAX_XFER_BYTES	SZ_64K
+#define TDMA_CYCLIC_LOOP	(1 << 0)
+#define TDMA_ALIGNMENT		3
+
+struct mmp_tdma_chan {
+	struct mmp_tdma_engine		*mmp_tdma;
+	struct dma_chan			chan;
+	struct dma_async_tx_descriptor	desc;
+
+	struct mmp_tdma_desc		*desc_arr;
+	phys_addr_t			desc_arr_phys;
+	enum dma_data_direction		dir;
+	dma_addr_t			dev_addr;
+	u32				burst_sz;
+
+	dma_cookie_t			last_completed;
+	enum dma_status			status;
+	unsigned int			flags;
+
+	enum mmp_tdma_type		type;
+	int				irq;
+	unsigned long			reg_base;
+};
+
+struct mmp_tdma_engine {
+	struct device			*dev;
+	unsigned int			version;
+	void __iomem			*base;
+	unsigned int			irq_shift;
+	struct dma_device		tdma_device;
+	struct device_dma_parameters	tdma_parms;
+	unsigned int			tdmac_nr;
+	struct mmp_tdma_chan		tdmac[0];
+};
+
+static DEFINE_SPINLOCK(lock);
+static void mmp_tdma_dump_tdma_list(struct mmp_tdma_chan *tdma_chan)
+{
+	struct mmp_tdma_desc *desc = tdma_chan->desc_arr;
+	unsigned long flags;
+
+	if (!desc) {
+		dev_dbg(tdma_chan->mmp_tdma->dev,
+		 "dma description list has no node!\n");
+		return;
+	}
+
+	spin_lock_irqsave(&lock, flags);
+
+	dev_dbg(tdma_chan->mmp_tdma->dev, "dma description list nodes:\n");
+	do {
+		dev_dbg(tdma_chan->mmp_tdma->dev, "---------------------\n");
+		dev_dbg(tdma_chan->mmp_tdma->dev, "src_addr = 0x%08x\n",
+			desc->src_addr);
+		dev_dbg(tdma_chan->mmp_tdma->dev, "dst_addr = 0x%08x\n",
+			desc->dst_addr);
+		dev_dbg(tdma_chan->mmp_tdma->dev, "byte_cnt = 0x%08x\n",
+			desc->byte_cnt);
+		dev_dbg(tdma_chan->mmp_tdma->dev, "nxt_desc = 0x%08x\n",
+			desc->nxt_desc);
+
+		if (!desc->nxt_desc)
+			break;
+
+		desc = (struct mmp_tdma_desc *)(desc->nxt_desc -
+				(int)tdma_chan->desc_arr_phys +
+				(int)tdma_chan->desc_arr);
+
+	} while (desc != tdma_chan->desc_arr);
+
+	spin_unlock_irqrestore(&lock, flags);
+	return;
+}
+
+static int mmp_tdma_is_adma(struct mmp_tdma_chan *tdmac)
+{
+	if ((tdmac->type >= ADMA1_CH0) &&
+	    (tdmac->type <= ADMA2_CH1))
+		return 1;
+
+	return 0;
+}
+
+static int mmp_tdma_is_mdma(struct mmp_tdma_chan *tdmac)
+{
+	if ((tdmac->type >= MDMA1_CH0) &&
+	    (tdmac->type <= MDMA1_CH1))
+		return 1;
+
+	return 0;
+}
+
+static struct mmp_tdma_chan *to_mmp_tdma_chan(struct dma_chan *chan)
+{
+	return container_of(chan, struct mmp_tdma_chan, chan);
+}
+
+static void mmp_tdma_enable_chan(struct mmp_tdma_chan *tdmac)
+{
+	if (mmp_tdma_is_mdma(tdmac))
+		writel(readl(tdmac->reg_base + TDCR) | TDCR_CLK_GATE_ON,
+			tdmac->reg_base + TDCR);
+	/* set dma desc */
+	writel(tdmac->desc_arr_phys, tdmac->reg_base + TDNDPR);
+
+	/* enable irq */
+	writel(TDIMR_COMP, tdmac->reg_base + TDIMR);
+
+	/* enable dma chan */
+	writel(readl(tdmac->reg_base + TDCR) | TDCR_CHANEN,
+		tdmac->reg_base + TDCR);
+
+	dev_dbg(tdmac->mmp_tdma->dev, "%s: (%x) TDRC:%x TDNDPR:%x\n", __func__,
+		 (int)tdmac->reg_base, readl(tdmac->reg_base + TDCR),
+		 readl(tdmac->reg_base + TDNDPR));
+}
+
+static void mmp_tdma_disable_chan(struct mmp_tdma_chan *tdmac)
+{
+	/* disable dma chan */
+	writel(readl(tdmac->reg_base + TDCR) & ~TDCR_CHANEN,
+		tdmac->reg_base + TDCR);
+
+	if (mmp_tdma_is_mdma(tdmac))
+		writel(readl(tdmac->reg_base + TDCR) & ~TDCR_CLK_GATE_ON,
+			tdmac->reg_base + TDCR);
+
+	tdmac->status = DMA_SUCCESS;
+}
+
+static void mmp_tdma_resume_chan(struct mmp_tdma_chan *tdmac)
+{
+	if (mmp_tdma_is_mdma(tdmac))
+		writel(readl(tdmac->reg_base + TDCR) | TDCR_CLK_GATE_ON,
+			tdmac->reg_base + TDCR);
+
+	writel(readl(tdmac->reg_base + TDCR) | TDCR_CHANEN,
+		tdmac->reg_base + TDCR);
+
+	tdmac->status = DMA_IN_PROGRESS;
+}
+
+static void mmp_tdma_pause_chan(struct mmp_tdma_chan *tdmac)
+{
+	writel(readl(tdmac->reg_base + TDCR) & ~TDCR_CHANEN,
+		tdmac->reg_base + TDCR);
+
+	if (mmp_tdma_is_mdma(tdmac))
+		writel(readl(tdmac->reg_base + TDCR) & ~TDCR_CLK_GATE_ON,
+			tdmac->reg_base + TDCR);
+
+	tdmac->status = DMA_PAUSED;
+}
+
+static dma_cookie_t mmp_tdma_assign_cookie(struct mmp_tdma_chan *tdmac)
+{
+	dma_cookie_t cookie = tdmac->chan.cookie;
+
+	if (++cookie < 0)
+		cookie = 1;
+
+	tdmac->chan.cookie = cookie;
+	tdmac->desc.cookie = cookie;
+
+	return cookie;
+}
+
+unsigned long mmp_tdma_chan_get_ptr(struct dma_chan *dmac)
+{
+	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(dmac);
+	int base = tdmac->reg_base;
+
+	if (tdmac->dir == DMA_TO_DEVICE)
+		return readl(base + TDSAR);
+	else
+		return readl(base + TDDAR);
+}
+EXPORT_SYMBOL(mmp_tdma_chan_get_ptr);
+
+int mmp_tdma_is_specific_chan(struct dma_chan *chan, enum mmp_tdma_type type)
+{
+	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(chan);
+
+	if (tdmac->type == type)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(mmp_tdma_is_specific_chan);
+
+static dma_cookie_t mmp_tdma_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(tx->chan);
+
+	mmp_tdma_enable_chan(tdmac);
+
+	return mmp_tdma_assign_cookie(tdmac);
+}
+
+static irqreturn_t mmp_tdma_int_handler(int irq, void *dev_id)
+{
+	struct mmp_tdma_chan *tdmac = dev_id;
+
+	if (readl(tdmac->reg_base + TDISR) & TDISR_COMP) {
+		/* clear irq */
+		writel(readl(tdmac->reg_base + TDISR) & ~TDISR_COMP,
+			tdmac->reg_base + TDISR);
+
+		if (tdmac->flags & TDMA_CYCLIC_LOOP)
+			tdmac->status = DMA_IN_PROGRESS;
+		else
+			tdmac->status = DMA_SUCCESS;
+
+		if (tdmac->desc.callback)
+			tdmac->desc.callback(tdmac->desc.callback_param);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int mmp_tdma_alloc_descriptor(struct mmp_tdma_chan *tdmac)
+{
+	struct mmp_tdma_engine *mmp_tdma = tdmac->mmp_tdma;
+
+	dev_dbg(tdmac->mmp_tdma->dev, "%s: enter\n", __func__);
+
+	if (mmp_tdma_is_adma(tdmac)) {
+		tdmac->desc_arr = (void *)sram_alloc("audio sram",
+				TDMA_DESC_SIZE,
+				(dma_addr_t *)&(tdmac->desc_arr_phys));
+		if (!tdmac->desc_arr)
+			return -ENOMEM;
+	} else {
+		tdmac->desc_arr = dma_alloc_coherent(mmp_tdma->dev,
+			TDMA_DESC_SIZE, &tdmac->desc_arr_phys, GFP_KERNEL);
+
+		if (!tdmac->desc_arr)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void mmp_tdma_free_descriptor(struct mmp_tdma_chan *tdmac)
+{
+	struct mmp_tdma_engine *mmp_tdma = tdmac->mmp_tdma;
+
+	if (mmp_tdma_is_adma(tdmac)) {
+		sram_free("audio sram", (void *)tdmac->desc_arr, PAGE_SIZE);
+	} else {
+		dma_free_coherent(mmp_tdma->dev, TDMA_DESC_SIZE,
+			tdmac->desc_arr, tdmac->desc_arr_phys);
+	}
+}
+
+static int mmp_tdma_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(chan);
+	int ret;
+
+	dev_dbg(tdmac->mmp_tdma->dev, "%s: enter\n", __func__);
+
+	ret = mmp_tdma_alloc_descriptor(tdmac);
+	if (ret < 0)
+		return ret;
+
+	dma_async_tx_descriptor_init(&tdmac->desc, chan);
+	tdmac->desc.tx_submit = mmp_tdma_tx_submit;
+
+	/* the descriptor is ready */
+	async_tx_ack(&tdmac->desc);
+
+	ret = request_irq(tdmac->irq, mmp_tdma_int_handler, IRQF_DISABLED,
+			  "tdma", tdmac);
+	if (ret)
+		goto err_request_irq;
+
+	if (mmp_tdma_is_mdma(tdmac)) {
+		writel(readl(tdmac->reg_base + TDCR) | TDCR_CLK_GATE_CTL,
+			tdmac->reg_base + TDCR);
+		writel(readl(tdmac->reg_base + TDCR) | TDCR_TRANSMOD,
+			tdmac->reg_base + TDCR);
+	}
+
+	return 0;
+
+err_request_irq:
+	mmp_tdma_free_descriptor(tdmac);
+	return ret;
+}
+
+static void mmp_tdma_free_chan_resources(struct dma_chan *chan)
+{
+	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(chan);
+
+	dev_dbg(tdmac->mmp_tdma->dev, "%s: enter\n", __func__);
+
+	free_irq(tdmac->irq, tdmac);
+	mmp_tdma_disable_chan(tdmac);
+	mmp_tdma_free_descriptor(tdmac);
+}
+
+static int mmp_tdma_config_chan(struct mmp_tdma_chan *tdmac)
+{
+	struct mmp_tdma_data *tdma_data = tdmac->chan.private;
+	unsigned int tdcr;
+	int ret = 0;
+
+	mmp_tdma_disable_chan(tdmac);
+
+	if (tdmac->dir == DMA_TO_DEVICE)
+		tdcr = TDCR_DSTDIR_ADDR_HOLD | TDCR_SRCDIR_ADDR_INC;
+	else if (tdmac->dir == DMA_FROM_DEVICE)
+		tdcr = TDCR_SRCDIR_ADDR_HOLD | TDCR_DSTDIR_ADDR_INC;
+	else
+		tdcr = TDCR_SRCDIR_ADDR_INC | TDCR_DSTDIR_ADDR_INC;
+
+	tdcr |= tdmac->burst_sz;
+
+	if (tdma_data->pack_mod)
+		tdcr |= TDCR_PACKMOD;
+
+	tdcr |= tdma_data->bus_size;
+
+	writel(tdcr, tdmac->reg_base + TDCR);
+
+	dev_dbg(tdmac->mmp_tdma->dev, "%s: (%x) TDCR:%x\n", __func__,
+		 (int)tdmac->reg_base, readl(tdmac->reg_base + TDCR));
+
+	return ret;
+}
+
+static struct dma_async_tx_descriptor *mmp_tdma_prep_memcpy(
+		struct dma_chan *chan,
+		dma_addr_t dma_dst, dma_addr_t dma_src,
+		size_t len, unsigned long flags)
+{
+	struct mmp_tdma_chan *tdmac;
+	struct mmp_tdma_desc *desc;
+	size_t copy;
+	int i = 0;
+
+	if (!chan)
+		return NULL;
+
+	if (!len)
+		return NULL;
+
+	tdmac = to_mmp_tdma_chan(chan);
+
+	dev_dbg(tdmac->mmp_tdma->dev, "%s: desc_arr %p desc_arr_phys %x\n",
+		__func__, tdmac->desc_arr, tdmac->desc_arr_phys);
+
+	do {
+		dev_dbg(tdmac->mmp_tdma->dev, "%s: dst %x src %x len %d\n",
+			__func__, dma_dst, dma_src, len);
+
+		desc = &tdmac->desc_arr[i];
+		copy = min(len, (size_t)TDMA_MAX_XFER_BYTES);
+
+		desc->dst_addr = dma_dst;
+		desc->src_addr = dma_src;
+		desc->byte_cnt = copy;
+
+		len -= copy;
+		dma_src += copy;
+		dma_dst += copy;
+
+		if (!len)
+			desc->nxt_desc = 0;
+		else
+			desc->nxt_desc = tdmac->desc_arr_phys +
+				sizeof(*desc) * (i + 1);
+
+		i++;
+	} while (len);
+
+	writel(readl(tdmac->reg_base + TDCR) | TDCR_INTMODE,
+		tdmac->reg_base + TDCR);
+	writel(readl(tdmac->reg_base + TDCR) | TDCR_FETCHND,
+		tdmac->reg_base + TDCR);
+	/* default burst size is 8B, can modify from control api */
+	writel(readl(tdmac->reg_base + TDCR) | TDCR_BURSTSZ_8B,
+		tdmac->reg_base + TDCR);
+	mmp_tdma_dump_tdma_list(tdmac);
+
+	return &tdmac->desc;
+}
+
+static struct dma_async_tx_descriptor *mmp_tdma_prep_memset(
+		struct dma_chan *chan, dma_addr_t dest, int value, size_t len,
+		unsigned long flags)
+{
+	struct mmp_tdma_chan *tdmac;
+	struct mmp_tdma_desc *desc;
+	size_t copy;
+	int i = 0;
+
+	if (!chan)
+		return NULL;
+
+	if (!len)
+		return NULL;
+
+	tdmac = to_mmp_tdma_chan(chan);
+
+	dev_dbg(tdmac->mmp_tdma->dev, "%s: desc_arr %p desc_arr_phys %x\n",
+		__func__, tdmac->desc_arr, tdmac->desc_arr_phys);
+
+	do {
+		dev_dbg(tdmac->mmp_tdma->dev, "%s: dst %x value %x len %d\n",
+			__func__, dest, value, len);
+
+		desc = &tdmac->desc_arr[i];
+		copy = min(len, (size_t)TDMA_MAX_XFER_BYTES);
+
+		desc->dst_addr = dest;
+		desc->src_addr = value;
+		desc->byte_cnt = copy;
+
+		len -= copy;
+		dest += copy;
+
+		if (!len)
+			desc->nxt_desc = 0;
+		else
+			desc->nxt_desc = tdmac->desc_arr_phys +
+				sizeof(*desc) * (i + 1);
+
+		i++;
+	} while (len);
+
+	writel(value, tdmac->reg_base + FILLDATA);
+	writel(readl(tdmac->reg_base + TDCR) | TDCR_INTMODE,
+		tdmac->reg_base + TDCR);
+	writel(readl(tdmac->reg_base + TDCR) | TDCR_FETCHND,
+		tdmac->reg_base + TDCR);
+	/* default burst size is 8B, can modify from control api */
+	writel(readl(tdmac->reg_base + TDCR) | TDCR_BURSTSZ_8B,
+		tdmac->reg_base + TDCR);
+
+	mmp_tdma_dump_tdma_list(tdmac);
+	return &tdmac->desc;
+}
+
+static struct dma_async_tx_descriptor *mmp_tdma_prep_sg(struct dma_chan *chan,
+	struct scatterlist *dst_sg, unsigned int dst_nents,
+	struct scatterlist *src_sg, unsigned int src_nents,
+	unsigned long flags)
+{
+	struct mmp_tdma_chan *tdmac;
+	struct mmp_tdma_desc *desc, *first = NULL, *prev = NULL;
+	size_t dst_avail, src_avail;
+	dma_addr_t dst, src;
+	size_t len;
+	int i = 0;
+
+	/* basic sanity checks */
+	if (dst_nents == 0 || src_nents == 0)
+		return NULL;
+
+	if (dst_sg == NULL || src_sg == NULL)
+		return NULL;
+
+	tdmac = to_mmp_tdma_chan(chan);
+
+	/* get prepared for the loop */
+	dst_avail = sg_dma_len(dst_sg);
+	src_avail = sg_dma_len(src_sg);
+
+	/* run until we are out of scatterlist entries */
+	while (true) {
+		dev_dbg(tdmac->mmp_tdma->dev, "%s: dst_avail %x src_avail %x\n",
+			__func__, dst_avail, src_avail);
+
+		/* create the largest transaction possible */
+		len = min_t(size_t, src_avail, dst_avail);
+		len = min_t(size_t, len, TDMA_MAX_XFER_BYTES);
+		if (len == 0)
+			goto fetch;
+
+		dst = sg_dma_address(dst_sg) + sg_dma_len(dst_sg) - dst_avail;
+		src = sg_dma_address(src_sg) + sg_dma_len(src_sg) - src_avail;
+
+		dev_dbg(tdmac->mmp_tdma->dev, "%s: dst %x src %x len %x\n",
+			__func__, dst, src, len);
+
+		if (i >= TDMA_DESC_NUM)
+			goto fail;
+
+		desc = &tdmac->desc_arr[i];
+		desc->dst_addr = dst;
+		desc->src_addr = src;
+		desc->byte_cnt = len;
+		desc->nxt_desc = 0;
+
+		if (!first)
+			first = desc;
+		else
+			prev->nxt_desc = tdmac->desc_arr_phys +
+				sizeof(*desc) * i;
+
+		tdmac->desc.cookie = 0;
+		async_tx_ack(&tdmac->desc);
+		prev = desc;
+
+		/* update metadata */
+		dst_avail -= len;
+		src_avail -= len;
+		i++;
+
+fetch:
+		/* fetch the next dst scatterlist entry */
+		if (dst_avail == 0) {
+
+			/* no more entries: we're done */
+			if (dst_nents == 0)
+				break;
+
+			/* fetch the next entry: if there are no more: done */
+			dst_sg = sg_next(dst_sg);
+			if (dst_sg == NULL)
+				break;
+
+			dst_nents--;
+			dst_avail = sg_dma_len(dst_sg);
+		}
+
+		/* fetch the next src scatterlist entry */
+		if (src_avail == 0) {
+
+			/* no more entries: we're done */
+			if (src_nents == 0)
+				break;
+
+			/* fetch the next entry: if there are no more: done */
+			src_sg = sg_next(src_sg);
+			if (src_sg == NULL)
+				break;
+
+			src_nents--;
+			src_avail = sg_dma_len(src_sg);
+		}
+	}
+
+	writel(readl(tdmac->reg_base + TDCR) | TDCR_INTMODE,
+		tdmac->reg_base + TDCR);
+	writel(readl(tdmac->reg_base + TDCR) | TDCR_FETCHND,
+		tdmac->reg_base + TDCR);
+	/* default burst size is 8B, can modify from control api */
+	writel(readl(tdmac->reg_base + TDCR) | TDCR_BURSTSZ_8B,
+		tdmac->reg_base + TDCR);
+	mmp_tdma_dump_tdma_list(tdmac);
+
+	return &tdmac->desc;
+
+fail:
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *mmp_tdma_prep_slave_sg(
+		struct dma_chan *chan, struct scatterlist *sgl,
+		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned long append)
+{
+	/*
+	 * This operation is not supported on the TDMA controller
+	 *
+	 * However, we need to provide the function pointer to allow the
+	 * device_control() method to work.
+	 */
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *mmp_tdma_prep_dma_cyclic(
+		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
+		size_t period_len, enum dma_data_direction direction)
+{
+	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(chan);
+	struct mmp_tdma_engine *mmp_tdma = tdmac->mmp_tdma;
+	int num_periods = buf_len / period_len;
+	int i = 0, buf = 0;
+
+	if (tdmac->status == DMA_IN_PROGRESS)
+		return NULL;
+
+	tdmac->status = DMA_IN_PROGRESS;
+	tdmac->flags |= TDMA_CYCLIC_LOOP;
+
+	if (num_periods > TDMA_DESC_NUM) {
+		dev_err(mmp_tdma->tdma_device.dev,
+				"maximum number of sg exceeded: %d > %d\n",
+				num_periods, TDMA_DESC_NUM);
+		goto err_out;
+	}
+
+	if (period_len > TDMA_MAX_XFER_BYTES) {
+		dev_err(mmp_tdma->tdma_device.dev,
+				"maximum period size exceeded: %d > %d\n",
+				period_len, TDMA_MAX_XFER_BYTES);
+		goto err_out;
+	}
+
+	while (buf < buf_len) {
+		struct mmp_tdma_desc *desc = &tdmac->desc_arr[i];
+
+		if (i + 1 == num_periods)
+			desc->nxt_desc = tdmac->desc_arr_phys;
+		else
+			desc->nxt_desc = tdmac->desc_arr_phys +
+				sizeof(*desc) * (i + 1);;
+
+		if (direction == DMA_TO_DEVICE) {
+			desc->src_addr = dma_addr;
+			desc->dst_addr = tdmac->dev_addr;
+		} else {
+			desc->src_addr = tdmac->dev_addr;
+			desc->dst_addr = dma_addr;
+		}
+
+		desc->byte_cnt = period_len;
+
+		dma_addr += period_len;
+		buf += period_len;
+
+		i++;
+	}
+
+	writel(readl(tdmac->reg_base + TDCR) | TDCR_FETCHND,
+		tdmac->reg_base + TDCR);
+	mmp_tdma_dump_tdma_list(tdmac);
+
+	return &tdmac->desc;
+
+err_out:
+	tdmac->status = DMA_ERROR;
+	return NULL;
+}
+
+static int mmp_tdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+		unsigned long arg)
+{
+	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(chan);
+	struct dma_slave_config *dmaengine_cfg = (void *)arg;
+	int ret = 0;
+
+	switch (cmd) {
+	case DMA_TERMINATE_ALL:
+		mmp_tdma_disable_chan(tdmac);
+		break;
+	case DMA_PAUSE:
+		mmp_tdma_pause_chan(tdmac);
+		break;
+	case DMA_RESUME:
+		mmp_tdma_resume_chan(tdmac);
+		break;
+	case DMA_SLAVE_CONFIG:
+		if (dmaengine_cfg->direction == DMA_FROM_DEVICE) {
+			tdmac->dev_addr = dmaengine_cfg->src_addr;
+			tdmac->burst_sz = dmaengine_cfg->src_maxburst;
+		} else {
+			tdmac->dev_addr = dmaengine_cfg->dst_addr;
+			tdmac->burst_sz = dmaengine_cfg->dst_maxburst;
+		}
+		tdmac->dir = dmaengine_cfg->direction;
+		return mmp_tdma_config_chan(tdmac);
+	default:
+		ret = -ENOSYS;
+	}
+
+	return ret;
+}
+
+static enum dma_status mmp_tdma_tx_status(struct dma_chan *chan,
+			dma_cookie_t cookie, struct dma_tx_state *txstate)
+{
+	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(chan);
+	dma_cookie_t last_used;
+
+	last_used = chan->cookie;
+	dma_set_tx_state(txstate, tdmac->last_completed, last_used, 0);
+
+	return tdmac->status;
+}
+
+static void mmp_tdma_issue_pending(struct dma_chan *chan)
+{
+	/*
+	 * Nothing to do. We only have a single descriptor.
+	 */
+}
+
+static int __devinit mmp_tdma_probe(struct platform_device *pdev)
+{
+	struct mmp_tdma_engine *mmp_tdma;
+	struct mmp_tdma_chan *tdmac;
+	struct resource *iores;
+	struct mmp_tdma_platform_data *pdata = pdev->dev.platform_data;
+	struct mmp_tdma_chan_info *info;
+	int ret;
+	int irq;
+	int i;
+
+	if (!pdata || !pdata->info)
+		return -ENODEV;
+
+	info = pdata->info;
+
+	mmp_tdma = kzalloc(pdata->nr_ch * sizeof(*tdmac) +
+			   sizeof(*mmp_tdma), GFP_KERNEL);
+	if (!mmp_tdma)
+		return -ENOMEM;
+
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irq = platform_get_irq(pdev, 0);
+	if (!iores || irq < 0) {
+		ret = -EINVAL;
+		goto err_irq;
+	}
+
+	if (!request_mem_region(iores->start, resource_size(iores),
+				pdev->name)) {
+		ret = -EBUSY;
+		goto err_request_region;
+	}
+
+	mmp_tdma->base = ioremap(iores->start, resource_size(iores));
+	if (!mmp_tdma->base) {
+		ret = -ENOMEM;
+		goto err_ioremap;
+	}
+
+	dma_cap_set(DMA_MEMCPY, mmp_tdma->tdma_device.cap_mask);
+	dma_cap_set(DMA_MEMSET, mmp_tdma->tdma_device.cap_mask);
+	dma_cap_set(DMA_SLAVE, mmp_tdma->tdma_device.cap_mask);
+	dma_cap_set(DMA_SG, mmp_tdma->tdma_device.cap_mask);
+	dma_cap_set(DMA_CYCLIC, mmp_tdma->tdma_device.cap_mask);
+
+	INIT_LIST_HEAD(&mmp_tdma->tdma_device.channels);
+
+	/* initialize channel parameters */
+	for (i = 0; i < pdata->nr_ch; i++) {
+
+		BUG_ON((info[i].reg_base < iores->start) ||
+		       (info[i].reg_base >= iores->start +
+		       resource_size(iores)));
+
+		tdmac = &mmp_tdma->tdmac[i];
+
+		tdmac->mmp_tdma	   = mmp_tdma;
+		tdmac->chan.device = &mmp_tdma->tdma_device;
+		tdmac->type	   = info[i].type;
+		tdmac->irq	   = irq + i;
+		tdmac->reg_base	   = (unsigned long)mmp_tdma->base +
+				info[i].reg_base - iores->start;
+
+		/* add the channel to tdma_chan list */
+		list_add_tail(&tdmac->chan.device_node,
+			      &mmp_tdma->tdma_device.channels);
+	}
+
+	mmp_tdma->dev = &pdev->dev;
+	mmp_tdma->tdmac_nr  = pdata->nr_ch;
+	mmp_tdma->tdma_device.dev = &pdev->dev;
+	mmp_tdma->tdma_device.device_alloc_chan_resources =
+					mmp_tdma_alloc_chan_resources;
+	mmp_tdma->tdma_device.device_free_chan_resources =
+					mmp_tdma_free_chan_resources;
+	mmp_tdma->tdma_device.device_prep_dma_memcpy = mmp_tdma_prep_memcpy;
+	mmp_tdma->tdma_device.device_prep_dma_memset = mmp_tdma_prep_memset;
+	mmp_tdma->tdma_device.device_prep_slave_sg = mmp_tdma_prep_slave_sg;
+	mmp_tdma->tdma_device.device_prep_dma_sg = mmp_tdma_prep_sg;
+	mmp_tdma->tdma_device.device_prep_dma_cyclic = mmp_tdma_prep_dma_cyclic;
+	mmp_tdma->tdma_device.device_tx_status = mmp_tdma_tx_status;
+	mmp_tdma->tdma_device.device_issue_pending = mmp_tdma_issue_pending;
+	mmp_tdma->tdma_device.device_control = mmp_tdma_control;
+	mmp_tdma->tdma_device.copy_align = TDMA_ALIGNMENT;
+
+	dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
+
+	ret = dma_async_device_register(&mmp_tdma->tdma_device);
+	if (ret) {
+		dev_err(mmp_tdma->tdma_device.dev, "unable to register\n");
+		goto err_init;
+	}
+
+	dev_info(mmp_tdma->tdma_device.dev, "initialized\n");
+	return 0;
+
+err_init:
+	iounmap(mmp_tdma->base);
+err_ioremap:
+	release_mem_region(iores->start, resource_size(iores));
+err_request_region:
+err_irq:
+	kfree(mmp_tdma);
+	return ret;
+}
+
+static const struct platform_device_id mmp_tdma_id_table[] = {
+	{ "mmp-adma", },
+	{ "mmp-mdma", },
+	{ },
+};
+
+static struct platform_driver mmp_tdma_driver = {
+	.driver		= {
+		.name	= "mmp-tdma",
+	},
+	.id_table	= mmp_tdma_id_table,
+};
+
+static int __init mmp_tdma_module_init(void)
+{
+	return platform_driver_probe(&mmp_tdma_driver, mmp_tdma_probe);
+}
+subsys_initcall(mmp_tdma_module_init);
+
+MODULE_AUTHOR("Leo Yan <leoy@marvell.com>");
+MODULE_DESCRIPTION("MMP Two-Channel DMA driver");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/pxa/mmp-pcm.c b/sound/soc/pxa/mmp-pcm.c
index 85495f4..7469e19 100644
--- a/sound/soc/pxa/mmp-pcm.c
+++ b/sound/soc/pxa/mmp-pcm.c
@@ -43,7 +43,8 @@ static const struct snd_pcm_hardware mmp2_pcm_hardware = {
 	.period_bytes_min	= 1024,
 	.period_bytes_max	= 2048,
 	.periods_min		= 2,
-	.periods_max		= MMP2_ADMA_DESC_SIZE / sizeof(mmp_tdma_desc),
+	.periods_max		= MMP2_ADMA_DESC_SIZE /
+				sizeof(struct mmp_tdma_desc),
 	.buffer_bytes_max	= MMP2_DDR_BUF_SIZE,
 	.fifo_size		= 32,
 };
@@ -53,7 +54,7 @@ static DECLARE_WAIT_QUEUE_HEAD(dma_wq);
 #ifdef DEBUG
 static void mmp2_pcm_dump_adma_list(struct mmp2_runtime_data *prtd)
 {
-	mmp_tdma_desc *adma_desc;
+	struct mmp_tdma_desc *adma_desc;
 
 	pr_debug("audio dma list description is:\n");
 	adma_desc = prtd->adma_desc_array;
@@ -64,7 +65,7 @@ static void mmp2_pcm_dump_adma_list(struct mmp2_runtime_data *prtd)
 		pr_debug("byte_cnt = 0x%08x\n", adma_desc->byte_cnt);
 		pr_debug("nxt_desc = 0x%08x\n", adma_desc->nxt_desc);
 
-		adma_desc = (mmp_tdma_desc *)(adma_desc->nxt_desc -
+		adma_desc = (struct mmp_tdma_desc *)(adma_desc->nxt_desc -
 				(int)prtd->adma_desc_array_phys +
 				(int)prtd->adma_desc_array);
 
@@ -245,7 +246,7 @@ static int mmp2_pcm_hw_params(struct snd_pcm_substream *substream,
 	struct mmp2_adma_params *dma;
 	size_t totsize = params_buffer_bytes(params);
 	size_t period = params_period_bytes(params);
-	mmp_tdma_desc *adma_desc;
+	struct mmp_tdma_desc *adma_desc;
 	dma_addr_t dma_buff_phys, next_desc_phys;
 	int ret;
 
@@ -298,7 +299,7 @@ static int mmp2_pcm_hw_params(struct snd_pcm_substream *substream,
 	adma_desc      = prtd->adma_desc_array;
 
 	do {
-		next_desc_phys += sizeof(mmp_tdma_desc);
+		next_desc_phys += sizeof(struct mmp_tdma_desc);
 
 		adma_desc->nxt_desc = next_desc_phys;
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
diff --git a/sound/soc/pxa/mmp2-squ.c b/sound/soc/pxa/mmp2-squ.c
index 986cc59..6d3cc10 100644
--- a/sound/soc/pxa/mmp2-squ.c
+++ b/sound/soc/pxa/mmp2-squ.c
@@ -56,7 +56,7 @@ static const struct snd_pcm_hardware mmp2_pcm_hardware_playback = {
 	.period_bytes_min	= 1024,
 	.period_bytes_max	= 2048,
 	.periods_min		= 2,
-	.periods_max		= PAGE_SIZE / sizeof(mmp_tdma_desc),
+	.periods_max		= PAGE_SIZE / sizeof(struct mmp_tdma_desc),
 	.buffer_bytes_max	= PAGE_SIZE,
 	.fifo_size		= 32,
 };
@@ -73,7 +73,7 @@ static const struct snd_pcm_hardware mmp2_pcm_hardware_capture = {
 	.period_bytes_min	= 1024,
 	.period_bytes_max	= 2048,
 	.periods_min		= 2,
-	.periods_max		= PAGE_SIZE / sizeof(mmp_tdma_desc),
+	.periods_max		= PAGE_SIZE / sizeofs(struct mmp_tdma_desc),
 	.buffer_bytes_max	= PAGE_SIZE,
 	.fifo_size		= 32,
 };
@@ -90,7 +90,7 @@ static const struct snd_pcm_hardware mmp2_pcm_hardware_playback = {
 	.period_bytes_min = 32,
 	.period_bytes_max = 10 * 1024,
 	.periods_min = 1,
-	.periods_max = PAGE_SIZE / sizeof(mmp_tdma_desc),
+	.periods_max = PAGE_SIZE / sizeof(struct mmp_tdma_desc),
 	.buffer_bytes_max = 24 * 1024,
 	.fifo_size = 32,
 };
@@ -105,7 +105,7 @@ static const struct snd_pcm_hardware mmp2_pcm_hardware_capture = {
 	.period_bytes_min = 32,
 	.period_bytes_max = 10 * 1024,
 	.periods_min = 1,
-	.periods_max = PAGE_SIZE / sizeof(mmp_tdma_desc),
+	.periods_max = PAGE_SIZE / sizeof(struct mmp_tdma_desc),
 	.buffer_bytes_max = 24 * 1024,
 	.fifo_size = 32,
 };
@@ -157,7 +157,7 @@ static int mmp2_pcm_hw_params(struct snd_pcm_substream *substream,
 	struct mmp2_adma_params *dma;
 	size_t totsize = params_buffer_bytes(params);
 	size_t period = params_period_bytes(params);
-	mmp_tdma_desc *adma_desc;
+	struct mmp_tdma_desc *adma_desc;
 	dma_addr_t dma_buff_phys, next_desc_phys;
 	int ret;
 
@@ -197,7 +197,7 @@ static int mmp2_pcm_hw_params(struct snd_pcm_substream *substream,
 
 	adma_desc = prtd->adma_desc_array;
 	do {
-		next_desc_phys += sizeof(mmp_tdma_desc);
+		next_desc_phys += sizeof(struct mmp_tdma_desc);
 
 		adma_desc->nxt_desc = next_desc_phys;
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-- 
1.7.0.4

