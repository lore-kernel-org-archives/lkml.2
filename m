Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1IPJ6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:58:19 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:42070 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1IPJ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:58:17 -0400
From: Barry Song <Baohua.Song@csr.com>
To: <vinod.koul@intel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <workgroup.linux@csr.com>, Rongjun Ying <rongjun.ying@csr.com>,
        Jassi Brar <jaswinder.singh@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Barry Song <Baohua.Song@csr.com>
Subject: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
Date: Fri, 16 Sep 2011 02:56:00 -0700
Message-ID: <1316166960-20964-1-git-send-email-Baohua.Song@csr.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rongjun Ying <rongjun.ying@csr.com>

Cc: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
---
 -v2:
 use generic xfer API from jassi;
 delete sirf self-defined slave config;
 fix feedback from vinod;
 fix filter function: we have two dmac, clients drivers think the chan id as 0~31;
 rename regs to base;
 delete redundant chan_id initialization in probe since dmaengine core will
 re-write it, refer to my patch too:
 [PATCH] dmaengine: delete redundant chan_id and chancnt initialization in dma drivers
 http://www.spinics.net/lists/kernel/msg1237455.html

 this patch doesn't provide a common way for filter and doesn't use the jassi's v2 patch.

 MAINTAINERS            |    1 +
 drivers/dma/Kconfig    |    7 +
 drivers/dma/Makefile   |    1 +
 drivers/dma/sirf-dma.c |  603 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 612 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/sirf-dma.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 28f65c2..c1237ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -739,6 +739,7 @@ M:	Barry Song <baohua.song@csr.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-prima2/
+F:	drivers/dma/sirf-dma*
 
 ARM/EBSA110 MACHINE SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 2e3b3d3..1341bcd 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -187,6 +187,13 @@ config TIMB_DMA
 	help
 	  Enable support for the Timberdale FPGA DMA engine.
 
+config SIRF_DMA
+	tristate "CSR SiRFprimaII DMA support"
+	depends on ARCH_PRIMA2
+	select DMA_ENGINE
+	help
+	  Enable support for the CSR SiRFprimaII DMA engine.
+
 config ARCH_HAS_ASYNC_TX_FIND_CHANNEL
 	bool
 
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 30cf3b1..009a222 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_IMX_SDMA) += imx-sdma.o
 obj-$(CONFIG_IMX_DMA) += imx-dma.o
 obj-$(CONFIG_MXS_DMA) += mxs-dma.o
 obj-$(CONFIG_TIMB_DMA) += timb_dma.o
+obj-$(CONFIG_SIRF_DMA) += sirf-dma.o
 obj-$(CONFIG_STE_DMA40) += ste_dma40.o ste_dma40_ll.o
 obj-$(CONFIG_PL330_DMA) += pl330.o
 obj-$(CONFIG_PCH_DMA) += pch_dma.o
diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
new file mode 100644
index 0000000..90a4660
--- /dev/null
+++ b/drivers/dma/sirf-dma.c
@@ -0,0 +1,603 @@
+/*
+ * DMA controller driver for CSR SiRFprimaII
+ *
+ * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#include <linux/module.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <linux/sirfsoc_dma.h>
+
+#define SIRFSOC_DMA_DESCRIPTORS                 16
+#define SIRFSOC_DMA_CHANNELS                    16
+
+#define SIRFSOC_DMA_CH_ADDR                     0x00
+#define SIRFSOC_DMA_CH_XLEN                     0x04
+#define SIRFSOC_DMA_CH_YLEN                     0x08
+#define SIRFSOC_DMA_CH_CTRL                     0x0C
+
+#define SIRFSOC_DMA_WIDTH_0                     0x100
+#define SIRFSOC_DMA_CH_VALID                    0x140
+#define SIRFSOC_DMA_CH_INT                      0x144
+#define SIRFSOC_DMA_INT_EN                      0x148
+#define SIRFSOC_DMA_CH_LOOP_CTRL                0x150
+
+#define SIRFSOC_DMA_MODE_CTRL_BIT               4
+#define SIRFSOC_DMA_DIR_CTRL_BIT                5
+
+struct sirfsoc_dma_desc {
+	struct dma_async_tx_descriptor	desc;
+	struct list_head		node;
+
+	/* SiRFprimaII 2D-DMA parameters */
+	int             xlen;           /* DMA xlen */
+	int             ylen;           /* DMA ylen */
+	int             width;          /* DMA width */
+};
+
+struct sirfsoc_dma_chan {
+	struct dma_chan			chan;
+	struct list_head		free;
+	struct list_head		prepared;
+	struct list_head		queued;
+	struct list_head		active;
+	struct list_head		completed;
+	dma_cookie_t			completed_cookie;
+
+	/* Lock for this structure */
+	spinlock_t			lock;
+
+	int             direction;
+	int             mode;
+	u32             addr;
+};
+
+struct sirfsoc_dma {
+	struct dma_device		dma;
+	struct tasklet_struct		tasklet;
+	struct sirfsoc_dma_chan		channels[SIRFSOC_DMA_CHANNELS];
+	void __iomem			*base;
+	int				irq;
+};
+
+#define DRV_NAME	"sirfsoc_dma"
+
+/* Convert struct dma_chan to struct sirfsoc_dma_chan */
+static inline struct sirfsoc_dma_chan *dma_chan_to_sirfsoc_dma_chan(struct dma_chan *c)
+{
+	return container_of(c, struct sirfsoc_dma_chan, chan);
+}
+
+/* Convert struct dma_chan to struct sirfsoc_dma */
+static inline struct sirfsoc_dma *dma_chan_to_sirfsoc_dma(struct dma_chan *c)
+{
+	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(c);
+	return container_of(schan, struct sirfsoc_dma, channels[c->chan_id]);
+}
+
+/* Execute all queued DMA descriptors */
+static void sirfsoc_dma_execute(struct sirfsoc_dma_chan *schan)
+{
+	struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(&schan->chan);
+	int cid = schan->chan.chan_id;
+	struct sirfsoc_dma_desc *sdesc = NULL;
+
+	sdesc = list_first_entry(&schan->queued, struct sirfsoc_dma_desc,
+		node);
+	/* Move the first queued descriptor to active list */
+	list_move_tail(&schan->queued, &schan->active);
+
+	/* Start the DMA transfer */
+	writel_relaxed(sdesc->width, sdma->base + SIRFSOC_DMA_WIDTH_0 + cid * 4);
+	writel_relaxed(cid | (schan->mode << SIRFSOC_DMA_MODE_CTRL_BIT) |
+		(schan->direction << SIRFSOC_DMA_DIR_CTRL_BIT),
+		sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_CTRL);
+	writel_relaxed(sdesc->xlen, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_XLEN);
+	writel_relaxed(sdesc->ylen, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_YLEN);
+	writel_relaxed(readl_relaxed(sdma->base + SIRFSOC_DMA_INT_EN) | (1 << cid),
+		sdma->base + SIRFSOC_DMA_INT_EN);
+	writel_relaxed(schan->addr >> 2, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_ADDR);
+}
+
+/* Interrupt handler */
+static irqreturn_t sirfsoc_dma_irq(int irq, void *data)
+{
+	struct sirfsoc_dma *sdma = data;
+	struct sirfsoc_dma_chan *schan;
+	u32 is;
+	int ch;
+
+	is = readl_relaxed(sdma->base + SIRFSOC_DMA_CH_INT);
+	while ((ch = fls(is) - 1) >= 0) {
+		is &= ~(1 << ch);
+		writel_relaxed(1 << ch, sdma->base + SIRFSOC_DMA_CH_INT);
+		schan = &sdma->channels[ch];
+
+		spin_lock(&schan->lock);
+
+		/* Execute queued descriptors */
+		list_splice_tail_init(&schan->active, &schan->completed);
+		if (!list_empty(&schan->queued))
+			sirfsoc_dma_execute(schan);
+
+		spin_unlock(&schan->lock);
+	}
+
+	/* Schedule tasklet */
+	tasklet_schedule(&sdma->tasklet);
+
+	return IRQ_HANDLED;
+}
+
+/* process completed descriptors */
+static void sirfsoc_dma_process_completed(struct sirfsoc_dma *sdma)
+{
+	dma_cookie_t last_cookie = 0;
+	struct sirfsoc_dma_chan *schan;
+	struct sirfsoc_dma_desc *sdesc;
+	struct dma_async_tx_descriptor *desc;
+	unsigned long flags;
+	LIST_HEAD(list);
+	int i;
+
+	for (i = 0; i < sdma->dma.chancnt; i++) {
+		schan = &sdma->channels[i];
+
+		/* Get all completed descriptors */
+		spin_lock_irqsave(&schan->lock, flags);
+		if (!list_empty(&schan->completed))
+			list_splice_tail_init(&schan->completed, &list);
+		spin_unlock_irqrestore(&schan->lock, flags);
+
+		if (list_empty(&list))
+			continue;
+
+		/* Execute callbacks and run dependencies */
+		list_for_each_entry(sdesc, &list, node) {
+			desc = &sdesc->desc;
+
+			if (desc->callback)
+				desc->callback(desc->callback_param);
+
+			last_cookie = desc->cookie;
+			dma_run_dependencies(desc);
+		}
+
+		/* Free descriptors */
+		spin_lock_irqsave(&schan->lock, flags);
+		list_splice_tail_init(&list, &schan->free);
+		schan->completed_cookie = last_cookie;
+		spin_unlock_irqrestore(&schan->lock, flags);
+	}
+}
+
+/* DMA Tasklet */
+static void sirfsoc_dma_tasklet(unsigned long data)
+{
+	struct sirfsoc_dma *sdma = (void *)data;
+
+	sirfsoc_dma_process_completed(sdma);
+}
+
+/* Submit descriptor to hardware */
+static dma_cookie_t sirfsoc_dma_tx_submit(struct dma_async_tx_descriptor *txd)
+{
+	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(txd->chan);
+	struct sirfsoc_dma_desc *sdesc;
+	unsigned long flags;
+	dma_cookie_t cookie;
+
+	sdesc = container_of(txd, struct sirfsoc_dma_desc, desc);
+
+	spin_lock_irqsave(&schan->lock, flags);
+
+	/* Move descriptor to queue */
+	list_move_tail(&sdesc->node, &schan->queued);
+
+	/* Update cookie */
+	cookie = schan->chan.cookie + 1;
+	if (cookie <= 0)
+		cookie = 1;
+
+	schan->chan.cookie = cookie;
+	sdesc->desc.cookie = cookie;
+
+	spin_unlock_irqrestore(&schan->lock, flags);
+
+	return cookie;
+}
+
+static int sirfsoc_dma_slave_config(struct sirfsoc_dma_chan *schan,
+	struct dma_slave_config *config)
+{
+	u32 addr, direction;
+	unsigned long flags;
+
+	switch (config->direction) {
+	case DMA_FROM_DEVICE:
+		direction = 0;
+		addr = config->dst_addr;
+		break;
+
+	case DMA_TO_DEVICE:
+		direction = 1;
+		addr = config->src_addr;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if ((config->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
+		(config->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES))
+		return -EINVAL;
+
+	spin_lock_irqsave(&schan->lock, flags);
+	schan->addr = addr;
+	schan->direction = direction;
+	schan->mode = (config->src_maxburst == 4 ? 1 : 0);
+	spin_unlock_irqrestore(&schan->lock, flags);
+
+	return 0;
+}
+
+static int sirfsoc_dma_terminate_all(struct sirfsoc_dma_chan *schan)
+{
+	struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(&schan->chan);
+	int cid = schan->chan.chan_id;
+	unsigned long flags;
+
+	writel_relaxed(readl_relaxed(sdma->base + SIRFSOC_DMA_INT_EN) & ~(1 << cid),
+		sdma->base + SIRFSOC_DMA_INT_EN);
+	writel_relaxed(1 << cid, sdma->base + SIRFSOC_DMA_CH_VALID);
+
+	spin_lock_irqsave(&schan->lock, flags);
+	list_splice_tail_init(&schan->active, &schan->free);
+	list_splice_tail_init(&schan->queued, &schan->free);
+	spin_unlock_irqrestore(&schan->lock, flags);
+
+	return 0;
+}
+
+static int sirfsoc_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+	unsigned long arg)
+{
+	struct dma_slave_config *config;
+	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
+
+	switch (cmd) {
+	case DMA_TERMINATE_ALL:
+		return sirfsoc_dma_terminate_all(schan);
+	case DMA_SLAVE_CONFIG:
+		config = (struct dma_slave_config *)arg;
+		return sirfsoc_dma_slave_config(schan, config);
+
+	default:
+		break;
+	}
+
+	return -ENOSYS;
+}
+
+/* Alloc channel resources */
+static int sirfsoc_dma_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(chan);
+	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
+	struct sirfsoc_dma_desc *sdesc;
+	unsigned long flags;
+	LIST_HEAD(descs);
+	int i;
+
+	/* Alloc descriptors for this channel */
+	for (i = 0; i < SIRFSOC_DMA_DESCRIPTORS; i++) {
+		sdesc = kzalloc(sizeof(struct sirfsoc_dma_desc), GFP_KERNEL);
+		if (!sdesc) {
+			dev_notice(sdma->dma.dev, "Memory allocation error. "
+				"Allocated only %u descriptors\n", i);
+			break;
+		}
+
+		dma_async_tx_descriptor_init(&sdesc->desc, chan);
+		sdesc->desc.flags = DMA_CTRL_ACK;
+		sdesc->desc.tx_submit = sirfsoc_dma_tx_submit;
+
+		list_add_tail(&sdesc->node, &descs);
+	}
+
+	/* Return error only if no descriptors were allocated */
+	if (i == 0)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&schan->lock, flags);
+
+	list_splice_tail_init(&descs, &schan->free);
+	spin_unlock_irqrestore(&schan->lock, flags);
+
+	return 0;
+}
+
+/* Free channel resources */
+static void sirfsoc_dma_free_chan_resources(struct dma_chan *chan)
+{
+	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
+	struct sirfsoc_dma_desc *sdesc, *tmp;
+	unsigned long flags;
+	LIST_HEAD(descs);
+
+	spin_lock_irqsave(&schan->lock, flags);
+
+	/* Channel must be idle */
+	BUG_ON(!list_empty(&schan->prepared));
+	BUG_ON(!list_empty(&schan->queued));
+	BUG_ON(!list_empty(&schan->active));
+	BUG_ON(!list_empty(&schan->completed));
+
+	/* Move data */
+	list_splice_tail_init(&schan->free, &descs);
+
+	spin_unlock_irqrestore(&schan->lock, flags);
+
+	/* Free descriptors */
+	list_for_each_entry_safe(sdesc, tmp, &descs, node)
+		kfree(sdesc);
+}
+
+/* Send pending descriptor to hardware */
+static void sirfsoc_dma_issue_pending(struct dma_chan *chan)
+{
+	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
+	unsigned long flags;
+
+	spin_lock_irqsave(&schan->lock, flags);
+
+	if (list_empty(&schan->active) && !list_empty(&schan->queued))
+		sirfsoc_dma_execute(schan);
+
+	spin_unlock_irqrestore(&schan->lock, flags);
+}
+
+/* Check request completion status */
+static enum dma_status
+sirfsoc_dma_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
+	struct dma_tx_state *txstate)
+{
+	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
+	unsigned long flags;
+	dma_cookie_t last_used;
+	dma_cookie_t last_complete;
+
+	spin_lock_irqsave(&schan->lock, flags);
+	last_used = schan->chan.cookie;
+	last_complete = schan->completed_cookie;
+	spin_unlock_irqrestore(&schan->lock, flags);
+
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
+	return dma_async_is_complete(cookie, last_complete, last_used);
+}
+
+static struct dma_async_tx_descriptor *sirfsoc_dma_prep_slave_sg(
+	struct dma_chan *chan, struct scatterlist *sgl,
+	unsigned int sg_len, enum dma_data_direction direction,
+	unsigned long flags)
+{
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *sirfsoc_dma_prep_genxfer(
+	struct dma_chan *chan, struct xfer_template *xt)
+{
+	struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(chan);
+	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
+	struct sirfsoc_dma_desc *sdesc = NULL;
+	unsigned long iflags;
+	int ret;
+
+	/* Get free descriptor */
+	spin_lock_irqsave(&schan->lock, iflags);
+	if (!list_empty(&schan->free)) {
+		sdesc = list_first_entry(&schan->free, struct sirfsoc_dma_desc,
+			node);
+		list_del(&sdesc->node);
+	}
+	spin_unlock_irqrestore(&schan->lock, iflags);
+
+	if (!sdesc) {
+		/* try to free completed descriptors */
+		sirfsoc_dma_process_completed(sdma);
+		ret = 0;
+		goto no_desc;
+	}
+
+	/* Place descriptor in prepared list */
+	spin_lock_irqsave(&schan->lock, iflags);
+	if ((xt->frame_size == 1) && (xt->numf > 0)) {
+		sdesc->xlen = xt->sgl[0].size;
+		sdesc->width = xt->sgl[0].size + xt->sgl[0].icg;
+		sdesc->ylen = xt->numf - 1;
+		list_add_tail(&sdesc->node, &schan->prepared);
+	} else {
+		pr_err("sirfsoc DMA Invalid xfer\n");
+		ret = -EINVAL;
+		goto err_xfer;
+	}
+	spin_unlock_irqrestore(&schan->lock, iflags);
+
+	return &sdesc->desc;
+err_xfer:
+	spin_unlock_irqrestore(&schan->lock, iflags);
+no_desc:
+	return ERR_PTR(ret);
+}
+
+/*
+ * The DMA controller consists of 16 independent DMA channels.
+ * Each channel is allocated to a different function
+ */
+bool sirfsoc_dma_filter_id(struct dma_chan *chan, void *chan_id)
+{
+	unsigned int ch_nr = (unsigned int) chan_id;
+
+	if (ch_nr == chan->chan_id +
+		chan->device->dev_id * SIRFSOC_DMA_CHANNELS)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(sirfsoc_dma_filter_id);
+
+static int __devinit sirfsoc_dma_probe(struct platform_device *op)
+{
+	struct device_node *dn = op->dev.of_node;
+	struct device *dev = &op->dev;
+	struct dma_device *dma;
+	struct sirfsoc_dma *sdma;
+	struct sirfsoc_dma_chan *schan;
+	struct resource res;
+	ulong regs_start, regs_size;
+	u32 id;
+	int retval, i;
+
+	sdma = devm_kzalloc(dev, sizeof(struct sirfsoc_dma), GFP_KERNEL);
+	if (!sdma) {
+		dev_err(dev, "Memory exhausted!\n");
+		return -ENOMEM;
+	}
+
+	if (of_property_read_u32(dn, "cell-index", &id)) {
+		dev_err(dev, "Fail to get DMAC index\n");
+		return -ENODEV;
+	}
+
+	sdma->irq = irq_of_parse_and_map(dn, 0);
+	if (sdma->irq == NO_IRQ) {
+		dev_err(dev, "Error mapping IRQ!\n");
+		return -EINVAL;
+	}
+
+	retval = of_address_to_resource(dn, 0, &res);
+	if (retval) {
+		dev_err(dev, "Error parsing memory region!\n");
+		return retval;
+	}
+
+	regs_start = res.start;
+	regs_size = resource_size(&res);
+
+	if (!devm_request_mem_region(dev, regs_start, regs_size, DRV_NAME)) {
+		dev_err(dev, "Error requesting memory region!\n");
+		return -EBUSY;
+	}
+
+	sdma->base = devm_ioremap(dev, regs_start, regs_size);
+	if (!sdma->base) {
+		dev_err(dev, "Error mapping memory region!\n");
+		return -ENOMEM;
+	}
+
+	retval = devm_request_irq(dev, sdma->irq, &sirfsoc_dma_irq, 0, DRV_NAME,
+		sdma);
+	if (retval) {
+		dev_err(dev, "Error requesting IRQ!\n");
+		return -EINVAL;
+	}
+
+	dma = &sdma->dma;
+	dma->dev = dev;
+	dma->chancnt = SIRFSOC_DMA_CHANNELS;
+
+	dma->device_alloc_chan_resources = sirfsoc_dma_alloc_chan_resources;
+	dma->device_free_chan_resources = sirfsoc_dma_free_chan_resources;
+	dma->device_issue_pending = sirfsoc_dma_issue_pending;
+	dma->device_control = sirfsoc_dma_control;
+	dma->device_tx_status = sirfsoc_dma_tx_status;
+	dma->device_prep_slave_sg = sirfsoc_dma_prep_slave_sg;
+	dma->device_prep_dma_genxfer = sirfsoc_dma_prep_genxfer;
+
+	INIT_LIST_HEAD(&dma->channels);
+	dma_cap_set(DMA_SLAVE, dma->cap_mask);
+	dma_cap_set(DMA_PRIVATE, dma->cap_mask);
+
+	for (i = 0; i < dma->chancnt; i++) {
+		schan = &sdma->channels[i];
+
+		schan->chan.device = dma;
+		schan->chan.cookie = 1;
+		schan->completed_cookie = schan->chan.cookie;
+
+		INIT_LIST_HEAD(&schan->free);
+		INIT_LIST_HEAD(&schan->prepared);
+		INIT_LIST_HEAD(&schan->queued);
+		INIT_LIST_HEAD(&schan->active);
+		INIT_LIST_HEAD(&schan->completed);
+
+		spin_lock_init(&schan->lock);
+		list_add_tail(&schan->chan.device_node, &dma->channels);
+	}
+
+	tasklet_init(&sdma->tasklet, sirfsoc_dma_tasklet, (unsigned long)sdma);
+
+	/* Register DMA engine */
+	dev_set_drvdata(dev, sdma);
+	retval = dma_async_device_register(dma);
+	if (retval) {
+		devm_free_irq(dev, sdma->irq, sdma);
+		irq_dispose_mapping(sdma->irq);
+	}
+
+	return retval;
+}
+
+static int __devexit sirfsoc_dma_remove(struct platform_device *op)
+{
+	struct device *dev = &op->dev;
+	struct sirfsoc_dma *sdma = dev_get_drvdata(dev);
+
+	dma_async_device_unregister(&sdma->dma);
+	devm_free_irq(dev, sdma->irq, sdma);
+	irq_dispose_mapping(sdma->irq);
+
+	return 0;
+}
+
+static struct of_device_id sirfsoc_dma_match[] = {
+	{ .compatible = "sirf,prima2-dmac", },
+	{},
+};
+
+static struct platform_driver sirfsoc_dma_driver = {
+	.probe		= sirfsoc_dma_probe,
+	.remove		= __devexit_p(sirfsoc_dma_remove),
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table	= sirfsoc_dma_match,
+	},
+};
+
+static int __init sirfsoc_dma_init(void)
+{
+	return platform_driver_register(&sirfsoc_dma_driver);
+}
+module_init(sirfsoc_dma_init);
+
+static void __exit sirfsoc_dma_exit(void)
+{
+	platform_driver_unregister(&sirfsoc_dma_driver);
+}
+module_exit(sirfsoc_dma_exit);
+
+MODULE_AUTHOR("Rongjun Ying <rongjun.ying@csr.com>, "
+	"Barry Song <baohua.song@csr.com>");
+MODULE_DESCRIPTION("SIRFSOC DMA control driver");
+MODULE_LICENSE("GPL");
-- 
1.7.1



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
