Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2CLLTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 07:19:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46278 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2CLLTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 07:19:06 -0400
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] dmaengine: i.MX: Add support for interleaved transfers.
Date: Mon, 12 Mar 2012 12:18:52 +0100
Message-Id: <1331551132-29383-1-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i.MX2 and i.MX1 chips have the possibility to do
interleaved transfers with two constraints:
* Only one chunk can be used (i.e. only 2D transfers are allowed).
* Only 2 interleaved configurations can be applied at the same time
for all channels.

Since this patch adds a new resource 'slots_2d' which is shared
by all the DMA channels and to avoid disgustin locking BUGs, the
'lock' member has been moved to the global 'imxdma_engine' structure.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 NOTE: This patch must be applied on top of the following series:
 [PATCH v3 00/13] dmaengine: imx-dma: merge dma arch code into dmaengine.

---
 drivers/dma/imx-dma.c |  151 +++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 134 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 4584012..5931e02 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -35,6 +35,10 @@
 #define IMXDMA_MAX_CHAN_DESCRIPTORS	16
 #define IMX_DMA_CHANNELS  16
 
+#define IMX_DMA_2D_SLOTS	2
+#define IMX_DMA_2D_SLOT_A	0
+#define IMX_DMA_2D_SLOT_B	1
+
 #define IMX_DMA_LENGTH_LOOP	((unsigned int)-1)
 #define IMX_DMA_MEMSIZE_32	(0 << 4)
 #define IMX_DMA_MEMSIZE_8	(1 << 4)
@@ -110,6 +114,13 @@ enum  imxdma_prep_type {
 	IMXDMA_DESC_CYCLIC,
 };
 
+struct imx_dma_2d_config {
+	u16		xsr;
+	u16		ysr;
+	u16		wsr;
+	int		count;
+};
+
 struct imxdma_desc {
 	struct list_head		node;
 	struct dma_async_tx_descriptor	desc;
@@ -146,12 +157,13 @@ struct imxdma_channel {
 	dma_addr_t			per_address;
 	u32				watermark_level;
 	struct dma_chan			chan;
-	spinlock_t			lock;
 	dma_cookie_t			last_completed;
 	int				dma_request;
 	struct scatterlist		*sg_list;
 	u32				ccr_from_device;
 	u32				ccr_to_device;
+	bool				enabled_2d;
+	int				slot_2d;
 };
 
 struct imxdma_engine {
@@ -160,6 +172,8 @@ struct imxdma_engine {
 	struct dma_device		dma_device;
 	void __iomem			*base;
 	struct clk			*dma_clk;
+	spinlock_t			lock;
+	struct imx_dma_2d_config	slots_2d[IMX_DMA_2D_SLOTS];
 	struct imxdma_channel		channel[IMX_DMA_CHANNELS];
 };
 
@@ -359,16 +373,16 @@ static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 	int chno = imxdmac->channel;
 	struct imxdma_desc *desc;
 
-	spin_lock(&imxdmac->lock);
+	spin_lock(&imxdma->lock);
 	if (list_empty(&imxdmac->ld_active)) {
-		spin_unlock(&imxdmac->lock);
+		spin_unlock(&imxdma->lock);
 		goto out;
 	}
 
 	desc = list_first_entry(&imxdmac->ld_active,
 				struct imxdma_desc,
 				node);
-	spin_unlock(&imxdmac->lock);
+	spin_unlock(&imxdma->lock);
 
 	if (desc->sg) {
 		u32 tmp;
@@ -440,9 +454,53 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
+	unsigned long flags;
+	int slot = -1;
+	int i;
 
 	/* Configure and enable */
 	switch (d->type) {
+	case IMXDMA_DESC_INTERLEAVED:
+		/* Try to get a free 2D slot */
+		spin_lock_irqsave(&imxdma->lock, flags);
+		for (i = 0; i < IMX_DMA_2D_SLOTS; i++) {
+			if ((imxdma->slots_2d[i].count > 0) &&
+			((imxdma->slots_2d[i].xsr != d->x) ||
+			(imxdma->slots_2d[i].ysr != d->y) ||
+			(imxdma->slots_2d[i].wsr != d->w)))
+				continue;
+			slot = i;
+			break;
+		}
+		if (slot < 0)
+			return -EBUSY;
+
+		imxdma->slots_2d[slot].xsr = d->x;
+		imxdma->slots_2d[slot].ysr = d->y;
+		imxdma->slots_2d[slot].wsr = d->w;
+		imxdma->slots_2d[slot].count++;
+
+		imxdmac->slot_2d = slot;
+		imxdmac->enabled_2d = true;
+		spin_unlock_irqrestore(&imxdma->lock, flags);
+
+		if (slot == IMX_DMA_2D_SLOT_A) {
+			d->config_mem &= ~CCR_MSEL_B;
+			d->config_port &= ~CCR_MSEL_B;
+			imx_dmav1_writel(imxdma, d->x, DMA_XSRA);
+			imx_dmav1_writel(imxdma, d->y, DMA_YSRA);
+			imx_dmav1_writel(imxdma, d->w, DMA_WSRA);
+		} else {
+			d->config_mem |= CCR_MSEL_B;
+			d->config_port |= CCR_MSEL_B;
+			imx_dmav1_writel(imxdma, d->x, DMA_XSRB);
+			imx_dmav1_writel(imxdma, d->y, DMA_YSRB);
+			imx_dmav1_writel(imxdma, d->w, DMA_WSRB);
+		}
+		/*
+		 * We fall-through here intentionally, since a 2D transfer is
+		 * similar to MEMCPY just adding the 2D slot configuration.
+		 */
 	case IMXDMA_DESC_MEMCPY:
 		imx_dmav1_writel(imxdma, d->src, DMA_SAR(imxdmac->channel));
 		imx_dmav1_writel(imxdma, d->dest, DMA_DAR(imxdmac->channel));
@@ -501,7 +559,7 @@ static void imxdma_tasklet(unsigned long data)
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	struct imxdma_desc *desc;
 
-	spin_lock(&imxdmac->lock);
+	spin_lock(&imxdma->lock);
 
 	if (list_empty(&imxdmac->ld_active)) {
 		/* Someone might have called terminate all */
@@ -518,6 +576,12 @@ static void imxdma_tasklet(unsigned long data)
 	if (imxdma_chan_is_doing_cyclic(imxdmac))
 		goto out;
 
+	/* Free 2D slot if it was an interleaved transfer */
+	if (imxdmac->enabled_2d) {
+		imxdma->slots_2d[imxdmac->slot_2d].count--;
+		imxdmac->enabled_2d = false;
+	}
+
 	list_move_tail(imxdmac->ld_active.next, &imxdmac->ld_free);
 
 	if (!list_empty(&imxdmac->ld_queue)) {
@@ -529,7 +593,7 @@ static void imxdma_tasklet(unsigned long data)
 				 __func__, imxdmac->channel);
 	}
 out:
-	spin_unlock(&imxdmac->lock);
+	spin_unlock(&imxdma->lock);
 }
 
 static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
@@ -545,10 +609,10 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	case DMA_TERMINATE_ALL:
 		imxdma_disable_hw(imxdmac);
 
-		spin_lock_irqsave(&imxdmac->lock, flags);
+		spin_lock_irqsave(&imxdma->lock, flags);
 		list_splice_tail_init(&imxdmac->ld_active, &imxdmac->ld_free);
 		list_splice_tail_init(&imxdmac->ld_queue, &imxdmac->ld_free);
-		spin_unlock_irqrestore(&imxdmac->lock, flags);
+		spin_unlock_irqrestore(&imxdma->lock, flags);
 		return 0;
 	case DMA_SLAVE_CONFIG:
 		if (dmaengine_cfg->direction == DMA_DEV_TO_MEM) {
@@ -603,16 +667,17 @@ static enum dma_status imxdma_tx_status(struct dma_chan *chan,
 					    struct dma_tx_state *txstate)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	dma_cookie_t last_used;
 	enum dma_status ret;
 	unsigned long flags;
 
-	spin_lock_irqsave(&imxdmac->lock, flags);
+	spin_lock_irqsave(&imxdma->lock, flags);
 	last_used = chan->cookie;
 
 	ret = dma_async_is_complete(cookie, imxdmac->last_completed, last_used);
 	dma_set_tx_state(txstate, imxdmac->last_completed, last_used, 0);
-	spin_unlock_irqrestore(&imxdmac->lock, flags);
+	spin_unlock_irqrestore(&imxdma->lock, flags);
 
 	return ret;
 }
@@ -632,16 +697,17 @@ static dma_cookie_t imxdma_assign_cookie(struct imxdma_channel *imxdma)
 static dma_cookie_t imxdma_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(tx->chan);
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	dma_cookie_t cookie;
 	unsigned long flags;
 
-	spin_lock_irqsave(&imxdmac->lock, flags);
+	spin_lock_irqsave(&imxdma->lock, flags);
 
 	list_move_tail(imxdmac->ld_free.next, &imxdmac->ld_queue);
 	cookie = imxdma_assign_cookie(imxdmac);
 	tx->cookie = cookie;
 
-	spin_unlock_irqrestore(&imxdmac->lock, flags);
+	spin_unlock_irqrestore(&imxdma->lock, flags);
 
 	return cookie;
 }
@@ -680,16 +746,17 @@ static int imxdma_alloc_chan_resources(struct dma_chan *chan)
 static void imxdma_free_chan_resources(struct dma_chan *chan)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	struct imxdma_desc *desc, *_desc;
 	unsigned long flags;
 
-	spin_lock_irqsave(&imxdmac->lock, flags);
+	spin_lock_irqsave(&imxdma->lock, flags);
 
 	imxdma_disable_hw(imxdmac);
 	list_splice_tail_init(&imxdmac->ld_active, &imxdmac->ld_free);
 	list_splice_tail_init(&imxdmac->ld_queue, &imxdmac->ld_free);
 
-	spin_unlock_irqrestore(&imxdmac->lock, flags);
+	spin_unlock_irqrestore(&imxdma->lock, flags);
 
 	list_for_each_entry_safe(desc, _desc, &imxdmac->ld_free, node) {
 		kfree(desc);
@@ -843,6 +910,49 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_memcpy(
 	return &desc->desc;
 }
 
+static struct dma_async_tx_descriptor *imxdma_prep_dma_interleaved(
+	struct dma_chan *chan, struct dma_interleaved_template *xt,
+	unsigned long flags)
+{
+	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
+	struct imxdma_desc *desc;
+
+	dev_dbg(imxdma->dev, "%s channel: %d src_start=0x%x dst_start=0x%x\n"
+		"   src_sgl=%s dst_sgl=%s numf=%d frame_size=%d\n", __func__,
+		imxdmac->channel, xt->src_start, xt->dst_start,
+		xt->src_sgl ? "true" : "false", xt->dst_sgl ? "true" : "false",
+		xt->numf, xt->frame_size);
+
+	if (list_empty(&imxdmac->ld_free) ||
+	    imxdma_chan_is_doing_cyclic(imxdmac))
+		return NULL;
+
+	if (xt->frame_size != 1 || xt->numf <= 0 || xt->dir != DMA_MEM_TO_MEM)
+		return NULL;
+
+	desc = list_first_entry(&imxdmac->ld_free, struct imxdma_desc, node);
+
+	desc->type = IMXDMA_DESC_INTERLEAVED;
+	desc->src = xt->src_start;
+	desc->dest = xt->dst_start;
+	desc->x = xt->sgl[0].size;
+	desc->y = xt->numf;
+	desc->w = xt->sgl[0].icg + desc->x;
+	desc->len = desc->x * desc->y;
+	desc->direction = DMA_MEM_TO_MEM;
+	desc->config_port = IMX_DMA_MEMSIZE_32;
+	desc->config_mem = IMX_DMA_MEMSIZE_32;
+	if (xt->src_sgl)
+		desc->config_mem |= IMX_DMA_TYPE_2D;
+	if (xt->dst_sgl)
+		desc->config_port |= IMX_DMA_TYPE_2D;
+	desc->desc.callback = NULL;
+	desc->desc.callback_param = NULL;
+
+	return &desc->desc;
+}
+
 static void imxdma_issue_pending(struct dma_chan *chan)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
@@ -850,7 +960,7 @@ static void imxdma_issue_pending(struct dma_chan *chan)
 	struct imxdma_desc *desc;
 	unsigned long flags;
 
-	spin_lock_irqsave(&imxdmac->lock, flags);
+	spin_lock_irqsave(&imxdma->lock, flags);
 	if (list_empty(&imxdmac->ld_active) &&
 	    !list_empty(&imxdmac->ld_queue)) {
 		desc = list_first_entry(&imxdmac->ld_queue,
@@ -865,7 +975,7 @@ static void imxdma_issue_pending(struct dma_chan *chan)
 				       &imxdmac->ld_active);
 		}
 	}
-	spin_unlock_irqrestore(&imxdmac->lock, flags);
+	spin_unlock_irqrestore(&imxdma->lock, flags);
 }
 
 static int __init imxdma_probe(struct platform_device *pdev)
@@ -928,6 +1038,13 @@ static int __init imxdma_probe(struct platform_device *pdev)
 	dma_cap_set(DMA_SLAVE, imxdma->dma_device.cap_mask);
 	dma_cap_set(DMA_CYCLIC, imxdma->dma_device.cap_mask);
 	dma_cap_set(DMA_MEMCPY, imxdma->dma_device.cap_mask);
+	dma_cap_set(DMA_INTERLEAVE, imxdma->dma_device.cap_mask);
+
+	/* Initialize 2D global parameters */
+	for (i = 0; i < IMX_DMA_2D_SLOTS; i++)
+		imxdma->slots_2d[i].count = 0;
+
+	spin_lock_init(&imxdma->lock);
 
 	/* Initialize channel parameters */
 	for (i = 0; i < IMX_DMA_CHANNELS; i++) {
@@ -948,7 +1065,6 @@ static int __init imxdma_probe(struct platform_device *pdev)
 		}
 
 		imxdmac->imxdma = imxdma;
-		spin_lock_init(&imxdmac->lock);
 
 		INIT_LIST_HEAD(&imxdmac->ld_queue);
 		INIT_LIST_HEAD(&imxdmac->ld_free);
@@ -973,6 +1089,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
 	imxdma->dma_device.device_prep_slave_sg = imxdma_prep_slave_sg;
 	imxdma->dma_device.device_prep_dma_cyclic = imxdma_prep_dma_cyclic;
 	imxdma->dma_device.device_prep_dma_memcpy = imxdma_prep_dma_memcpy;
+	imxdma->dma_device.device_prep_interleaved_dma = imxdma_prep_dma_interleaved;
 	imxdma->dma_device.device_control = imxdma_control;
 	imxdma->dma_device.device_issue_pending = imxdma_issue_pending;
 
-- 
1.7.0.4

