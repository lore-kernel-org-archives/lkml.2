Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1AYKUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:20:14 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:48960 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155Ab1AYKUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:20:11 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 20/32] dma40: combine mem and slave prep_sg functions
Date: Tue, 25 Jan 2011 11:18:23 +0100
Message-ID: <1295950715-22340-21-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |  156 +++++++++++++++++++----------------------------
 1 files changed, 62 insertions(+), 94 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 0f5d617..4e9d6c5 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1732,44 +1732,70 @@ err:
 	return NULL;
 }
 
-struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
-static struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
-						   struct scatterlist *sgl_dst,
-						   struct scatterlist *sgl_src,
-						   unsigned int sgl_len,
-						   unsigned long dma_flags)
+static dma_addr_t
+d40_get_dev_addr(struct d40_chan *chan, enum dma_data_direction direction)
 {
-	struct d40_desc *d40d;
-	struct d40_chan *d40c = container_of(chan, struct d40_chan,
-					     chan);
+	struct stedma40_platform_data *plat = chan->base->plat_data;
+	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
+	dma_addr_t addr;
+
+	if (chan->runtime_addr)
+		return chan->runtime_addr;
+
+	if (direction == DMA_FROM_DEVICE)
+		addr = plat->dev_rx[cfg->src_dev_type];
+	else if (direction == DMA_TO_DEVICE)
+		addr = plat->dev_tx[cfg->dst_dev_type];
+
+	return addr;
+}
+
+static struct dma_async_tx_descriptor *
+d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
+	    struct scatterlist *sg_dst, unsigned int sg_len,
+	    enum dma_data_direction direction, unsigned long dma_flags)
+{
+	struct d40_chan *chan = container_of(dchan, struct d40_chan, chan);
+	dma_addr_t dev_addr = 0;
+	struct d40_desc *desc;
 	unsigned long flags;
+	int ret;
 
-	if (d40c->phy_chan == NULL) {
-		chan_err(d40c, "Unallocated channel.\n");
-		return ERR_PTR(-EINVAL);
+	if (!chan->phy_chan) {
+		chan_err(chan, "Cannot prepare unallocated channel\n");
+		return NULL;
 	}
 
-	spin_lock_irqsave(&d40c->lock, flags);
+	spin_lock_irqsave(&chan->lock, flags);
 
-	d40d = d40_prep_desc(d40c, sgl_dst, sgl_len, dma_flags);
-	if (!d40d)
+	desc = d40_prep_desc(chan, sg_src, sg_len, dma_flags);
+	if (desc == NULL)
 		goto err;
 
-	if (chan_is_logical(d40c)) {
-		d40_prep_sg_log(d40c, d40d, sgl_src, sgl_dst,
-				sgl_len, DMA_NONE, 0);
-	} else {
-		d40_prep_sg_phy(d40c, d40d, sgl_src, sgl_dst,
-				sgl_len, DMA_NONE, 0);
+	if (direction != DMA_NONE)
+		dev_addr = d40_get_dev_addr(chan, direction);
+
+	if (chan_is_logical(chan))
+		ret = d40_prep_sg_log(chan, desc, sg_src, sg_dst,
+				      sg_len, direction, dev_addr);
+	else
+		ret = d40_prep_sg_phy(chan, desc, sg_src, sg_dst,
+				      sg_len, direction, dev_addr);
+
+	if (ret) {
+		chan_err(chan, "Failed to prepare %s sg job: %d\n",
+			 chan_is_logical(chan) ? "log" : "phy", ret);
+		goto err;
 	}
 
-	spin_unlock_irqrestore(&d40c->lock, flags);
+	spin_unlock_irqrestore(&chan->lock, flags);
+
+	return &desc->txd;
 
-	return &d40d->txd;
 err:
-	if (d40d)
-		d40_desc_free(d40c, d40d);
-	spin_unlock_irqrestore(&d40c->lock, flags);
+	if (desc)
+		d40_desc_free(chan, desc);
+	spin_unlock_irqrestore(&chan->lock, flags);
 	return NULL;
 }
 
@@ -1925,37 +1951,19 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 	sg_dma_len(&dst_sg) = size;
 	sg_dma_len(&src_sg) = size;
 
-	return stedma40_memcpy_sg(chan, &dst_sg, &src_sg, 1, dma_flags);
+	return d40_prep_sg(chan, &src_sg, &dst_sg, 1, DMA_NONE, dma_flags);
 }
 
 static struct dma_async_tx_descriptor *
-d40_prep_sg(struct dma_chan *chan,
-	    struct scatterlist *dst_sg, unsigned int dst_nents,
-	    struct scatterlist *src_sg, unsigned int src_nents,
-	    unsigned long dma_flags)
+d40_prep_memcpy_sg(struct dma_chan *chan,
+		   struct scatterlist *dst_sg, unsigned int dst_nents,
+		   struct scatterlist *src_sg, unsigned int src_nents,
+		   unsigned long dma_flags)
 {
 	if (dst_nents != src_nents)
 		return NULL;
 
-	return stedma40_memcpy_sg(chan, dst_sg, src_sg, dst_nents, dma_flags);
-}
-
-static dma_addr_t
-d40_get_dev_addr(struct d40_chan *chan, enum dma_data_direction direction)
-{
-	struct stedma40_platform_data *plat = chan->base->plat_data;
-	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
-	dma_addr_t addr;
-
-	if (chan->runtime_addr)
-		return chan->runtime_addr;
-
-	if (direction == DMA_FROM_DEVICE)
-		addr = plat->dev_rx[cfg->src_dev_type];
-	else if (direction == DMA_TO_DEVICE)
-		addr = plat->dev_tx[cfg->dst_dev_type];
-
-	return addr;
+	return d40_prep_sg(chan, src_sg, dst_sg, src_nents, DMA_NONE, dma_flags);
 }
 
 static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
@@ -1964,50 +1972,10 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 							 enum dma_data_direction direction,
 							 unsigned long dma_flags)
 {
-	struct d40_desc *d40d;
-	struct d40_chan *d40c = container_of(chan, struct d40_chan,
-					     chan);
-	dma_addr_t dev_addr;
-	unsigned long flags;
-	int err;
-
-	if (d40c->phy_chan == NULL) {
-		chan_err(d40c, "Cannot prepare unallocated channel\n");
-		return ERR_PTR(-EINVAL);
-	}
-
 	if (direction != DMA_FROM_DEVICE && direction != DMA_TO_DEVICE)
 		return NULL;
 
-	spin_lock_irqsave(&d40c->lock, flags);
-
-	d40d = d40_prep_desc(d40c, sgl, sg_len, dma_flags);
-	if (d40d == NULL)
-		goto err;
-
-	dev_addr = d40_get_dev_addr(d40c, direction);
-
-	if (chan_is_logical(d40c))
-		err = d40_prep_sg_log(d40c, d40d, sgl, NULL,
-				      sg_len, direction, dev_addr);
-	else
-		err = d40_prep_sg_phy(d40c, d40d, sgl, NULL,
-				      sg_len, direction, dev_addr);
-
-	if (err) {
-		chan_err(d40c, "Failed to prepare %s slave sg job: %d\n",
-			chan_is_logical(d40c) ? "log" : "phy", err);
-		goto err;
-	}
-
-	spin_unlock_irqrestore(&d40c->lock, flags);
-	return &d40d->txd;
-
-err:
-	if (d40d)
-		d40_desc_free(d40c, d40d);
-	spin_unlock_irqrestore(&d40c->lock, flags);
-	return NULL;
+	return d40_prep_sg(chan, sgl, sgl, sg_len, direction, dma_flags);
 }
 
 static enum dma_status d40_tx_status(struct dma_chan *chan,
@@ -2267,7 +2235,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	base->dma_slave.device_alloc_chan_resources = d40_alloc_chan_resources;
 	base->dma_slave.device_free_chan_resources = d40_free_chan_resources;
 	base->dma_slave.device_prep_dma_memcpy = d40_prep_memcpy;
-	base->dma_slave.device_prep_dma_sg = d40_prep_sg;
+	base->dma_slave.device_prep_dma_sg = d40_prep_memcpy_sg;
 	base->dma_slave.device_prep_slave_sg = d40_prep_slave_sg;
 	base->dma_slave.device_tx_status = d40_tx_status;
 	base->dma_slave.device_issue_pending = d40_issue_pending;
@@ -2291,7 +2259,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	base->dma_memcpy.device_alloc_chan_resources = d40_alloc_chan_resources;
 	base->dma_memcpy.device_free_chan_resources = d40_free_chan_resources;
 	base->dma_memcpy.device_prep_dma_memcpy = d40_prep_memcpy;
-	base->dma_slave.device_prep_dma_sg = d40_prep_sg;
+	base->dma_slave.device_prep_dma_sg = d40_prep_memcpy_sg;
 	base->dma_memcpy.device_prep_slave_sg = d40_prep_slave_sg;
 	base->dma_memcpy.device_tx_status = d40_tx_status;
 	base->dma_memcpy.device_issue_pending = d40_issue_pending;
@@ -2322,7 +2290,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	base->dma_both.device_alloc_chan_resources = d40_alloc_chan_resources;
 	base->dma_both.device_free_chan_resources = d40_free_chan_resources;
 	base->dma_both.device_prep_dma_memcpy = d40_prep_memcpy;
-	base->dma_slave.device_prep_dma_sg = d40_prep_sg;
+	base->dma_slave.device_prep_dma_sg = d40_prep_memcpy_sg;
 	base->dma_both.device_prep_slave_sg = d40_prep_slave_sg;
 	base->dma_both.device_tx_status = d40_tx_status;
 	base->dma_both.device_issue_pending = d40_issue_pending;
-- 
1.7.3.2

