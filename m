Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965761Ab2B1QIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:08:42 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35990 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965740Ab2B1QIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:08:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of javier.martin@vista-silicon.com designates 10.180.86.105 as permitted sender) smtp.mail=javier.martin@vista-silicon.com
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, s.hauer@pengutronix.de, vinod.koul@intel.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 2/2] dmaengine: Add support for multiple descriptors for imx-dma.
Date: Tue, 28 Feb 2012 17:08:18 +0100
Message-Id: <1330445298-3522-3-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330445298-3522-1-git-send-email-javier.martin@vista-silicon.com>
References: <1330445298-3522-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmaengine specifies the possibility that several descriptors
can be queued for transfer. It also indicates that tasklets
must be used for DMA callbacks.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |  327 ++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 253 insertions(+), 74 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 9aa6e85..953dea3 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -5,6 +5,7 @@
  * found on i.MX1/21/27
  *
  * Copyright 2010 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
+ * Copyright 2012 Javier Martin, Vista Silicon <javier.martin@vista-silicon.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
@@ -13,6 +14,7 @@
  * http://www.opensource.org/licenses/gpl-license.html
  * http://www.gnu.org/copyleft/gpl.html
  */
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -30,19 +32,52 @@
 #include <mach/dma-v1.h>
 #include <mach/hardware.h>
 
+#define IMXDMA_MAX_CHAN_DESCRIPTORS	16
+
+enum  imxdma_prep_type {
+	IMXDMA_DESC_MEMCPY,
+	IMXDMA_DESC_INTERLEAVED,
+	IMXDMA_DESC_SLAVE_SG,
+	IMXDMA_DESC_CYCLIC,
+};
+
+struct imxdma_desc {
+	struct list_head		node;
+	struct dma_async_tx_descriptor	desc;
+	enum dma_status			status;
+	dma_addr_t			src;
+	dma_addr_t			dest;
+	size_t				len;
+	unsigned int			dmamode;
+	enum imxdma_prep_type		type;
+	/* For memcpy and interleaved */
+	unsigned int			config_port;
+	unsigned int			config_mem;
+	/* For interleaved transfers */
+	unsigned int			x;
+	unsigned int			y;
+	unsigned int			w;
+	/* For slave sg and cyclic */
+	struct scatterlist		*sg;
+	unsigned int			sgcount;
+};
+
 struct imxdma_channel {
 	struct imxdma_engine		*imxdma;
 	unsigned int			channel;
 	unsigned int			imxdma_channel;
 
+	struct tasklet_struct		dma_tasklet;
+	struct list_head		ld_free;
+	struct list_head		ld_queue;
+	struct list_head		ld_active;
+	int				descs_allocated;
 	enum dma_slave_buswidth		word_size;
 	dma_addr_t			per_address;
 	u32				watermark_level;
 	struct dma_chan			chan;
 	spinlock_t			lock;
-	struct dma_async_tx_descriptor	desc;
 	dma_cookie_t			last_completed;
-	enum dma_status			status;
 	int				dma_request;
 	struct scatterlist		*sg_list;
 };
@@ -61,27 +96,31 @@ static struct imxdma_channel *to_imxdma_chan(struct dma_chan *chan)
 	return container_of(chan, struct imxdma_channel, chan);
 }
 
-static void imxdma_handle(struct imxdma_channel *imxdmac)
+static inline bool imxdma_chan_is_doing_cyclic(struct imxdma_channel *imxdmac)
 {
-	if (imxdmac->desc.callback)
-		imxdmac->desc.callback(imxdmac->desc.callback_param);
-	imxdmac->last_completed = imxdmac->desc.cookie;
+	struct imxdma_desc *desc;
+
+	if (!list_empty(&imxdmac->ld_active)) {
+		desc = list_first_entry(&imxdmac->ld_active, struct imxdma_desc,
+					node);
+		if (desc->type == IMXDMA_DESC_CYCLIC)
+			return true;
+	}
+	return false;
 }
 
 static void imxdma_irq_handler(int channel, void *data)
 {
 	struct imxdma_channel *imxdmac = data;
 
-	imxdmac->status = DMA_SUCCESS;
-	imxdma_handle(imxdmac);
+	tasklet_schedule(&imxdmac->dma_tasklet);
 }
 
 static void imxdma_err_handler(int channel, void *data, int error)
 {
 	struct imxdma_channel *imxdmac = data;
 
-	imxdmac->status = DMA_ERROR;
-	imxdma_handle(imxdmac);
+	tasklet_schedule(&imxdmac->dma_tasklet);
 }
 
 static void imxdma_progression(int channel, void *data,
@@ -89,8 +128,83 @@ static void imxdma_progression(int channel, void *data,
 {
 	struct imxdma_channel *imxdmac = data;
 
-	imxdmac->status = DMA_SUCCESS;
-	imxdma_handle(imxdmac);
+	tasklet_schedule(&imxdmac->dma_tasklet);
+}
+
+static int imxdma_xfer_desc(struct imxdma_desc *d)
+{
+	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
+	int ret;
+
+	/* Configure and enable */
+	switch (d->type) {
+	case IMXDMA_DESC_MEMCPY:
+		ret = imx_dma_config_channel(imxdmac->imxdma_channel,
+					  d->config_port, d->config_mem, 0, 0);
+		if (ret < 0)
+			return ret;
+		ret = imx_dma_setup_single(imxdmac->imxdma_channel, d->src,
+					   d->len, d->dest, d->dmamode);
+		if (ret < 0)
+			return ret;
+		break;
+	case IMXDMA_DESC_CYCLIC:
+		ret = imx_dma_setup_progression_handler(imxdmac->imxdma_channel,
+							imxdma_progression);
+		if (ret < 0)
+			return ret;
+	case IMXDMA_DESC_SLAVE_SG:
+		if (d->dmamode == DMA_MODE_READ)
+			ret = imx_dma_setup_sg(imxdmac->imxdma_channel, d->sg,
+				       d->sgcount, d->len, d->src, d->dmamode);
+		else
+			ret = imx_dma_setup_sg(imxdmac->imxdma_channel, d->sg,
+				      d->sgcount, d->len, d->dest, d->dmamode);
+		if (ret < 0)
+			return ret;
+		break;
+	default:
+		return -EINVAL;
+	}
+	imx_dma_enable(imxdmac->imxdma_channel);
+	return 0;
+}
+
+static void imxdma_tasklet(unsigned long data)
+{
+	struct imxdma_channel *imxdmac = (void *)data;
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
+	struct imxdma_desc *desc;
+
+	spin_lock(&imxdmac->lock);
+
+	if (list_empty(&imxdmac->ld_active)) {
+		/* Someone might have called terminate all */
+		goto out;
+	}
+	desc = list_first_entry(&imxdmac->ld_active, struct imxdma_desc, node);
+
+	if (desc->desc.callback)
+		desc->desc.callback(desc->desc.callback_param);
+
+	imxdmac->last_completed = desc->desc.cookie;
+
+	/* If we are dealing with a cyclic descriptor keep it on ld_active */
+	if (imxdma_chan_is_doing_cyclic(imxdmac))
+		goto out;
+
+	list_move_tail(imxdmac->ld_active.next, &imxdmac->ld_free);
+
+	if (!list_empty(&imxdmac->ld_queue)) {
+		desc = list_first_entry(&imxdmac->ld_queue, struct imxdma_desc,
+					node);
+		list_move_tail(imxdmac->ld_queue.next, &imxdmac->ld_active);
+		if (imxdma_xfer_desc(desc) < 0)
+			dev_warn(imxdma->dev, "%s: channel: %d couldn't xfer desc\n",
+				 __func__, imxdmac->channel);
+	}
+out:
+	spin_unlock(&imxdmac->lock);
 }
 
 static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
@@ -99,12 +213,17 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	struct dma_slave_config *dmaengine_cfg = (void *)arg;
 	int ret;
+	unsigned long flags;
 	unsigned int mode = 0;
 
 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
-		imxdmac->status = DMA_ERROR;
 		imx_dma_disable(imxdmac->imxdma_channel);
+
+		spin_lock_irqsave(&imxdmac->lock, flags);
+		list_splice_tail_init(&imxdmac->ld_active, &imxdmac->ld_free);
+		list_splice_tail_init(&imxdmac->ld_queue, &imxdmac->ld_free);
+		spin_unlock_irqrestore(&imxdmac->lock, flags);
 		return 0;
 	case DMA_SLAVE_CONFIG:
 		if (dmaengine_cfg->direction == DMA_DEV_TO_MEM) {
@@ -155,11 +274,14 @@ static enum dma_status imxdma_tx_status(struct dma_chan *chan,
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	dma_cookie_t last_used;
 	enum dma_status ret;
+	unsigned long flags;
 
+	spin_lock_irqsave(&imxdmac->lock, flags);
 	last_used = chan->cookie;
 
 	ret = dma_async_is_complete(cookie, imxdmac->last_completed, last_used);
 	dma_set_tx_state(txstate, imxdmac->last_completed, last_used, 0);
+	spin_unlock_irqrestore(&imxdmac->lock, flags);
 
 	return ret;
 }
@@ -172,7 +294,6 @@ static dma_cookie_t imxdma_assign_cookie(struct imxdma_channel *imxdma)
 		cookie = 1;
 
 	imxdma->chan.cookie = cookie;
-	imxdma->desc.cookie = cookie;
 
 	return cookie;
 }
@@ -181,12 +302,15 @@ static dma_cookie_t imxdma_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(tx->chan);
 	dma_cookie_t cookie;
+	unsigned long flags;
 
-	spin_lock_irq(&imxdmac->lock);
+	spin_lock_irqsave(&imxdmac->lock, flags);
 
+	list_move_tail(imxdmac->ld_free.next, &imxdmac->ld_queue);
 	cookie = imxdma_assign_cookie(imxdmac);
+	tx->cookie = cookie;
 
-	spin_unlock_irq(&imxdmac->lock);
+	spin_unlock_irqrestore(&imxdmac->lock, flags);
 
 	return cookie;
 }
@@ -199,21 +323,48 @@ static int imxdma_alloc_chan_resources(struct dma_chan *chan)
 	if (data != NULL)
 		imxdmac->dma_request = data->dma_request;
 
-	dma_async_tx_descriptor_init(&imxdmac->desc, chan);
-	imxdmac->desc.tx_submit = imxdma_tx_submit;
-	/* txd.flags will be overwritten in prep funcs */
-	imxdmac->desc.flags = DMA_CTRL_ACK;
+	while (imxdmac->descs_allocated < IMXDMA_MAX_CHAN_DESCRIPTORS) {
+		struct imxdma_desc *desc;
 
-	imxdmac->status = DMA_SUCCESS;
+		desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+		if (!desc)
+			break;
+		__memzero(&desc->desc, sizeof(struct dma_async_tx_descriptor));
+		dma_async_tx_descriptor_init(&desc->desc, chan);
+		desc->desc.tx_submit = imxdma_tx_submit;
+		/* txd.flags will be overwritten in prep funcs */
+		desc->desc.flags = DMA_CTRL_ACK;
+		desc->status = DMA_SUCCESS;
+
+		list_add_tail(&desc->node, &imxdmac->ld_free);
+		imxdmac->descs_allocated++;
+	}
 
-	return 0;
+	if (!imxdmac->descs_allocated)
+		return -ENOMEM;
+
+	return imxdmac->descs_allocated;
 }
 
 static void imxdma_free_chan_resources(struct dma_chan *chan)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
+	struct imxdma_desc *desc, *_desc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&imxdmac->lock, flags);
 
 	imx_dma_disable(imxdmac->imxdma_channel);
+	list_splice_tail_init(&imxdmac->ld_active, &imxdmac->ld_free);
+	list_splice_tail_init(&imxdmac->ld_queue, &imxdmac->ld_free);
+
+	spin_unlock_irqrestore(&imxdmac->lock, flags);
+
+	list_for_each_entry_safe(desc, _desc, &imxdmac->ld_free, node) {
+		kfree(desc);
+		imxdmac->descs_allocated--;
+	}
+	INIT_LIST_HEAD(&imxdmac->ld_free);
 
 	if (imxdmac->sg_list) {
 		kfree(imxdmac->sg_list);
@@ -228,23 +379,19 @@ static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	struct scatterlist *sg;
-	int i, ret, dma_length = 0;
-	unsigned int dmamode;
+	int i, dma_length = 0;
+	struct imxdma_desc *desc;
 
-	if (imxdmac->status == DMA_IN_PROGRESS)
+	if (list_empty(&imxdmac->ld_free) ||
+	    imxdma_chan_is_doing_cyclic(imxdmac))
 		return NULL;
 
-	imxdmac->status = DMA_IN_PROGRESS;
+	desc = list_first_entry(&imxdmac->ld_free, struct imxdma_desc, node);
 
 	for_each_sg(sgl, sg, sg_len, i) {
 		dma_length += sg->length;
 	}
 
-	if (direction == DMA_DEV_TO_MEM)
-		dmamode = DMA_MODE_READ;
-	else
-		dmamode = DMA_MODE_WRITE;
-
 	switch (imxdmac->word_size) {
 	case DMA_SLAVE_BUSWIDTH_4_BYTES:
 		if (sgl->length & 3 || sgl->dma_address & 3)
@@ -260,12 +407,21 @@ static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
 		return NULL;
 	}
 
-	ret = imx_dma_setup_sg(imxdmac->imxdma_channel, sgl, sg_len,
-		 dma_length, imxdmac->per_address, dmamode);
-	if (ret)
-		return NULL;
+	desc->type = IMXDMA_DESC_SLAVE_SG;
+	desc->sg = sgl;
+	desc->sgcount = sg_len;
+	desc->len = dma_length;
+	if (direction == DMA_DEV_TO_MEM) {
+		desc->dmamode = DMA_MODE_READ;
+		desc->src = imxdmac->per_address;
+	} else {
+		desc->dmamode = DMA_MODE_WRITE;
+		desc->dest = imxdmac->per_address;
+	}
+	desc->desc.callback = NULL;
+	desc->desc.callback_param = NULL;
 
-	return &imxdmac->desc;
+	return &desc->desc;
 }
 
 static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
@@ -274,23 +430,18 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
-	int i, ret;
+	struct imxdma_desc *desc;
+	int i;
 	unsigned int periods = buf_len / period_len;
-	unsigned int dmamode;
 
 	dev_dbg(imxdma->dev, "%s channel: %d buf_len=%d period_len=%d\n",
 			__func__, imxdmac->channel, buf_len, period_len);
 
-	if (imxdmac->status == DMA_IN_PROGRESS)
+	if (list_empty(&imxdmac->ld_free) ||
+	    imxdma_chan_is_doing_cyclic(imxdmac))
 		return NULL;
-	imxdmac->status = DMA_IN_PROGRESS;
 
-	ret = imx_dma_setup_progression_handler(imxdmac->imxdma_channel,
-			imxdma_progression);
-	if (ret) {
-		dev_err(imxdma->dev, "Failed to setup the DMA handler\n");
-		return NULL;
-	}
+	desc = list_first_entry(&imxdmac->ld_free, struct imxdma_desc, node);
 
 	if (imxdmac->sg_list)
 		kfree(imxdmac->sg_list);
@@ -316,17 +467,21 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 	imxdmac->sg_list[periods].page_link =
 		((unsigned long)imxdmac->sg_list | 0x01) & ~0x02;
 
-	if (direction == DMA_DEV_TO_MEM)
-		dmamode = DMA_MODE_READ;
-	else
-		dmamode = DMA_MODE_WRITE;
-
-	ret = imx_dma_setup_sg(imxdmac->imxdma_channel, imxdmac->sg_list, periods,
-		 IMX_DMA_LENGTH_LOOP, imxdmac->per_address, dmamode);
-	if (ret)
-		return NULL;
+	desc->type = IMXDMA_DESC_CYCLIC;
+	desc->sg = imxdmac->sg_list;
+	desc->sgcount = periods;
+	desc->len = IMX_DMA_LENGTH_LOOP;
+	if (direction == DMA_DEV_TO_MEM) {
+		desc->dmamode = DMA_MODE_READ;
+		desc->src = imxdmac->per_address;
+	} else {
+		desc->dmamode = DMA_MODE_WRITE;
+		desc->dest = imxdmac->per_address;
+	}
+	desc->desc.callback = NULL;
+	desc->desc.callback_param = NULL;
 
-	return &imxdmac->desc;
+	return &desc->desc;
 }
 
 static struct dma_async_tx_descriptor *imxdma_prep_dma_memcpy(
@@ -335,36 +490,53 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_memcpy(
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
-	int ret;
+	struct imxdma_desc *desc;
 
 	dev_dbg(imxdma->dev, "%s channel: %d src=0x%x dst=0x%x len=%d\n",
 			__func__, imxdmac->channel, src, dest, len);
 
-	if (imxdmac->status == DMA_IN_PROGRESS)
+	if (list_empty(&imxdmac->ld_free) ||
+	    imxdma_chan_is_doing_cyclic(imxdmac))
 		return NULL;
-	imxdmac->status = DMA_IN_PROGRESS;
 
-	ret = imx_dma_config_channel(imxdmac->imxdma_channel,
-			       IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR,
-			       IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR,
-			       0, 0);
-	if (ret)
-		return NULL;
+	desc = list_first_entry(&imxdmac->ld_free, struct imxdma_desc, node);
 
-	ret = imx_dma_setup_single(imxdmac->imxdma_channel, src, len,
-				   dest, DMA_MODE_WRITE);
-	if (ret)
-		return NULL;
+	desc->type = IMXDMA_DESC_MEMCPY;
+	desc->src = src;
+	desc->dest = dest;
+	desc->len = len;
+	desc->dmamode = DMA_MODE_WRITE;
+	desc->config_port = IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR;
+	desc->config_mem = IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR;
+	desc->desc.callback = NULL;
+	desc->desc.callback_param = NULL;
 
-	return &imxdmac->desc;
+	return &desc->desc;
 }
 
 static void imxdma_issue_pending(struct dma_chan *chan)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
-
-	if (imxdmac->status == DMA_IN_PROGRESS)
-		imx_dma_enable(imxdmac->imxdma_channel);
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
+	struct imxdma_desc *desc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&imxdmac->lock, flags);
+	if (list_empty(&imxdmac->ld_active) &&
+	    !list_empty(&imxdmac->ld_queue)) {
+		desc = list_first_entry(&imxdmac->ld_queue,
+					struct imxdma_desc, node);
+
+		if (imxdma_xfer_desc(desc) < 0) {
+			dev_warn(imxdma->dev,
+				 "%s: channel: %d couldn't issue DMA xfer\n",
+				 __func__, imxdmac->channel);
+		} else {
+			list_move_tail(imxdmac->ld_queue.next,
+				       &imxdmac->ld_active);
+		}
+	}
+	spin_unlock_irqrestore(&imxdmac->lock, flags);
 }
 
 static int __init imxdma_probe(struct platform_device *pdev)
@@ -399,11 +571,18 @@ static int __init imxdma_probe(struct platform_device *pdev)
 		imxdmac->imxdma = imxdma;
 		spin_lock_init(&imxdmac->lock);
 
+		INIT_LIST_HEAD(&imxdmac->ld_queue);
+		INIT_LIST_HEAD(&imxdmac->ld_free);
+		INIT_LIST_HEAD(&imxdmac->ld_active);
+
+		tasklet_init(&imxdmac->dma_tasklet, imxdma_tasklet,
+			     (unsigned long)imxdmac);
 		imxdmac->chan.device = &imxdma->dma_device;
 		imxdmac->channel = i;
 
 		/* Add the channel to the DMAC list */
-		list_add_tail(&imxdmac->chan.device_node, &imxdma->dma_device.channels);
+		list_add_tail(&imxdmac->chan.device_node,
+			      &imxdma->dma_device.channels);
 	}
 
 	imxdma->dev = &pdev->dev;
-- 
1.7.0.4

