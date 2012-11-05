Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2KEJwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:52:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62836 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2KEJwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:52:10 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH 2/3] dmaengine: PL08x: Add cyclic transfer support
Date: Mon,  5 Nov 2012 10:51:43 +0100
Message-Id: <1352109104-2969-3-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352109104-2969-1-git-send-email-alban.bedel@avionic-design.de>
References: <1352109104-2969-1-git-send-email-alban.bedel@avionic-design.de>
X-Provags-ID: V02:K0:AhcAHERjPmdmYXSb6ifcfz3Zsu+yWcEr/5k1jvhaWJ2
 jLnR78PcvFQrfGxGEdrLuqtgjkIj0CIQfOeqji7gSYor4DWjuM
 udnvkqmGoM9PAkYpFvGg7agsO8p3LivNx5vs8/C8sH6il2QdVU
 6fPzqPCQK7qSU6qR5286lPXI4Lw2N2fF06EYGJ1zbNedE4ej5t
 B5bFbontkAbMy1gMmU2zrsmDkVqsrwWdEpXz6EBep5Ce2IIPEN
 PWT6NLMmXvocbm4lsorM6OhopGpmhYLEYWyLFQ3thK48YXQ+Xm
 fOQX0ZS8HXQl8ybkG2oONJZtm8jCPpV5leyQNygEZ4UDD5hm15
 qcDNVlt4HBimSqYkvj7gBwqWi6DyRS+YobM5QxyC1fye4gsa0p
 1Af4zRPTAP6J18Ftv0OvzYetXStzciKQ02AmJw2y7xIGexJWrJ
 OrSvT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/dma/amba-pl08x.c |  184 ++++++++++++++++++++++++++++++++++------------
 1 files changed, 138 insertions(+), 46 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index fc8bedf..b097788 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -174,6 +174,7 @@ struct pl08x_sg {
  * @ccfg: config reg values for current txd
  * @done: this marks completed descriptors, which should not have their
  *   mux released.
+ * @cyclic: indicate cyclic transfers
  */
 struct pl08x_txd {
 	struct virt_dma_desc vd;
@@ -188,6 +189,8 @@ struct pl08x_txd {
 	 */
 	u32 ccfg;
 	bool done;
+
+	bool cyclic;
 };
 
 /**
@@ -505,9 +508,10 @@ static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
 				bytes += get_bytes_in_cctl(llis_va[index].cctl);
 
 				/*
-				 * A LLI pointer of 0 terminates the LLI list
+				 * A LLI pointer going backward terminates
+				 * the LLI list
 				 */
-				if (!llis_va[index].lli)
+				if (llis_va[index].lli <= clli)
 					break;
 			}
 		}
@@ -1010,10 +1014,14 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	}
 
 	llis_va = txd->llis_va;
-	/* The final LLI terminates the LLI. */
-	llis_va[num_llis - 1].lli = 0;
-	/* The final LLI element shall also fire an interrupt. */
-	llis_va[num_llis - 1].cctl |= PL080_CONTROL_TC_IRQ_EN;
+	if (txd->cyclic) {
+		/* Link back to the first LLI. */
+		llis_va[num_llis - 1].lli = txd->llis_bus | bd.lli_bus;
+	} else {
+		/* The final LLI terminates the LLI. */
+		llis_va[num_llis - 1].lli = 0;
+		llis_va[num_llis - 1].cctl |= PL080_CONTROL_TC_IRQ_EN;
+	}
 
 #ifdef VERBOSE_DEBUG
 	{
@@ -1411,25 +1419,19 @@ static struct dma_async_tx_descriptor *pl08x_prep_dma_memcpy(
 	return vchan_tx_prep(&plchan->vc, &txd->vd, flags);
 }
 
-static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
-		struct dma_chan *chan, struct scatterlist *sgl,
-		unsigned int sg_len, enum dma_transfer_direction direction,
-		unsigned long flags, void *context)
+static struct pl08x_txd *pl08x_init_txd(
+		struct dma_chan *chan,
+		enum dma_transfer_direction direction,
+		dma_addr_t *slave_addr)
 {
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
 	struct pl08x_driver_data *pl08x = plchan->host;
 	struct pl08x_txd *txd;
-	struct pl08x_sg *dsg;
-	struct scatterlist *sg;
 	enum dma_slave_buswidth addr_width;
-	dma_addr_t slave_addr;
 	int ret, tmp;
 	u8 src_buses, dst_buses;
 	u32 maxburst, cctl;
 
-	dev_dbg(&pl08x->adev->dev, "%s prepare transaction of %d bytes from %s\n",
-			__func__, sg_dma_len(sgl), plchan->name);
-
 	txd = pl08x_get_txd(plchan);
 	if (!txd) {
 		dev_err(&pl08x->adev->dev, "%s no txd\n", __func__);
@@ -1443,14 +1445,14 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 	 */
 	if (direction == DMA_MEM_TO_DEV) {
 		cctl = PL080_CONTROL_SRC_INCR;
-		slave_addr = plchan->cfg.dst_addr;
+		*slave_addr = plchan->cfg.dst_addr;
 		addr_width = plchan->cfg.dst_addr_width;
 		maxburst = plchan->cfg.dst_maxburst;
 		src_buses = pl08x->mem_buses;
 		dst_buses = plchan->cd->periph_buses;
 	} else if (direction == DMA_DEV_TO_MEM) {
 		cctl = PL080_CONTROL_DST_INCR;
-		slave_addr = plchan->cfg.src_addr;
+		*slave_addr = plchan->cfg.src_addr;
 		addr_width = plchan->cfg.src_addr_width;
 		maxburst = plchan->cfg.src_maxburst;
 		src_buses = plchan->cd->periph_buses;
@@ -1499,24 +1501,107 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 	else
 		txd->ccfg |= plchan->signal << PL080_CONFIG_SRC_SEL_SHIFT;
 
+	return txd;
+}
+
+static int pl08x_tx_add_sg(struct pl08x_txd *txd,
+			   enum dma_transfer_direction direction,
+			   dma_addr_t slave_addr,
+			   dma_addr_t buf_addr,
+			   unsigned int len)
+{
+	struct pl08x_sg *dsg;
+
+	dsg = kzalloc(sizeof(struct pl08x_sg), GFP_NOWAIT);
+	if (!dsg)
+		return -ENOMEM;
+
+	list_add_tail(&dsg->node, &txd->dsg_list);
+
+	dsg->len = len;
+	if (direction == DMA_MEM_TO_DEV) {
+		dsg->src_addr = buf_addr;
+		dsg->dst_addr = slave_addr;
+	} else {
+		dsg->src_addr = slave_addr;
+		dsg->dst_addr = buf_addr;
+	}
+
+	return 0;
+}
+
+static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
+		struct dma_chan *chan, struct scatterlist *sgl,
+		unsigned int sg_len, enum dma_transfer_direction direction,
+		unsigned long flags, void *context)
+{
+	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
+	struct pl08x_driver_data *pl08x = plchan->host;
+	struct pl08x_txd *txd;
+	struct scatterlist *sg;
+	int ret, tmp;
+	dma_addr_t slave_addr;
+
+	dev_dbg(&pl08x->adev->dev, "%s prepare transaction of %d bytes from %s\n",
+			__func__, sg_dma_len(sgl), plchan->name);
+
+	txd = pl08x_init_txd(chan, direction, &slave_addr);
+	if (!txd)
+		return NULL;
+
 	for_each_sg(sgl, sg, sg_len, tmp) {
-		dsg = kzalloc(sizeof(struct pl08x_sg), GFP_NOWAIT);
-		if (!dsg) {
+		ret = pl08x_tx_add_sg(txd, direction, slave_addr,
+				      sg_dma_address(sg),
+				      sg_dma_len(sg));
+		if (ret) {
 			pl08x_release_mux(plchan);
 			pl08x_free_txd(pl08x, txd);
 			dev_err(&pl08x->adev->dev, "%s no mem for pl080 sg\n",
 					__func__);
 			return NULL;
 		}
-		list_add_tail(&dsg->node, &txd->dsg_list);
+	}
 
-		dsg->len = sg_dma_len(sg);
-		if (direction == DMA_MEM_TO_DEV) {
-			dsg->src_addr = sg_dma_address(sg);
-			dsg->dst_addr = slave_addr;
-		} else {
-			dsg->src_addr = slave_addr;
-			dsg->dst_addr = sg_dma_address(sg);
+	ret = pl08x_fill_llis_for_desc(plchan->host, txd);
+	if (!ret) {
+		pl08x_release_mux(plchan);
+		pl08x_free_txd(pl08x, txd);
+		return NULL;
+	}
+
+	return vchan_tx_prep(&plchan->vc, &txd->vd, flags);
+}
+
+static struct dma_async_tx_descriptor *pl08x_prep_dma_cyclic(
+		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
+		size_t period_len, enum dma_transfer_direction direction,
+		void *context)
+{
+	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
+	struct pl08x_driver_data *pl08x = plchan->host;
+	struct pl08x_txd *txd;
+	int ret, tmp;
+	dma_addr_t slave_addr;
+
+	dev_dbg(&pl08x->adev->dev,
+		"%s prepare cyclic transaction of %d/%d bytes %s %s\n",
+		__func__, period_len, buf_len,
+		direction == DMA_MEM_TO_DEV ? "to" : "from",
+		plchan->name);
+
+	txd = pl08x_init_txd(chan, direction, &slave_addr);
+	if (!txd)
+		return NULL;
+
+	txd->cyclic = true;
+	txd->cctl |= PL080_CONTROL_TC_IRQ_EN;
+	for (tmp = 0 ; tmp < buf_len ; tmp += period_len) {
+		ret = pl08x_tx_add_sg(txd, direction, slave_addr,
+				      buf_addr + tmp, period_len);
+		if (ret) {
+			pl08x_release_mux(plchan);
+			pl08x_free_txd(pl08x, txd);
+			return NULL;
 		}
 	}
 
@@ -1527,7 +1612,7 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 		return NULL;
 	}
 
-	return vchan_tx_prep(&plchan->vc, &txd->vd, flags);
+	return vchan_tx_prep(&plchan->vc, &txd->vd, 0);
 }
 
 static int pl08x_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
@@ -1660,23 +1745,28 @@ static irqreturn_t pl08x_irq(int irq, void *dev)
 			spin_lock(&plchan->vc.lock);
 			tx = plchan->at;
 			if (tx) {
-				plchan->at = NULL;
-				/*
-				 * This descriptor is done, release its mux
-				 * reservation.
-				 */
-				pl08x_release_mux(plchan);
-				tx->done = true;
-				vchan_cookie_complete(&tx->vd);
-
-				/*
-				 * And start the next descriptor (if any),
-				 * otherwise free this channel.
-				 */
-				if (vchan_next_desc(&plchan->vc))
-					pl08x_start_next_txd(plchan);
-				else
-					pl08x_phy_free(plchan);
+				if (tx->cyclic) {
+					vchan_cyclic_callback(&tx->vd);
+				} else {
+					plchan->at = NULL;
+					/*
+					 * This descriptor is done, release
+					 * its mux reservation.
+					 */
+					pl08x_release_mux(plchan);
+					tx->done = true;
+					vchan_cookie_complete(&tx->vd);
+
+					/*
+					 * And start the next descriptor
+					 * (if any), otherwise free this
+					 * channel.
+					 */
+					if (vchan_next_desc(&plchan->vc))
+						pl08x_start_next_txd(plchan);
+					else
+						pl08x_phy_free(plchan);
+				}
 			}
 			spin_unlock(&plchan->vc.lock);
 
@@ -1880,6 +1970,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 
 	/* Initialize slave engine */
 	dma_cap_set(DMA_SLAVE, pl08x->slave.cap_mask);
+	dma_cap_set(DMA_CYCLIC, pl08x->slave.cap_mask);
 	pl08x->slave.dev = &adev->dev;
 	pl08x->slave.device_alloc_chan_resources = pl08x_alloc_chan_resources;
 	pl08x->slave.device_free_chan_resources = pl08x_free_chan_resources;
@@ -1887,6 +1978,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	pl08x->slave.device_tx_status = pl08x_dma_tx_status;
 	pl08x->slave.device_issue_pending = pl08x_issue_pending;
 	pl08x->slave.device_prep_slave_sg = pl08x_prep_slave_sg;
+	pl08x->slave.device_prep_dma_cyclic = pl08x_prep_dma_cyclic;
 	pl08x->slave.device_control = pl08x_control;
 
 	/* Get the platform data */
-- 
1.7.0.4

