Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab1AYKTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:19:37 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:40805 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293Ab1AYKTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:33 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 18/32] dma40: combine mem and slave sg-to-lli functions
Date: Tue, 25 Jan 2011 11:18:21 +0100
Message-ID: <1295950715-22340-19-git-send-email-linus.walleij@stericsson.com>
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
 drivers/dma/ste_dma40.c |  194 ++++++++++++++++++++--------------------------
 1 files changed, 84 insertions(+), 110 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 65b5aad..8c6abc2 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1618,6 +1618,81 @@ static u32 stedma40_residue(struct dma_chan *chan)
 	return bytes_left;
 }
 
+static int
+d40_prep_sg_log(struct d40_chan *chan, struct d40_desc *desc,
+		struct scatterlist *sg_src, struct scatterlist *sg_dst,
+		unsigned int sg_len, enum dma_data_direction direction,
+		dma_addr_t dev_addr)
+{
+	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
+	struct stedma40_half_channel_info *src_info = &cfg->src_info;
+	struct stedma40_half_channel_info *dst_info = &cfg->dst_info;
+
+	if (direction == DMA_NONE) {
+		/* memcpy */
+		(void) d40_log_sg_to_lli(sg_src, sg_len,
+					 desc->lli_log.src,
+					 chan->log_def.lcsp1,
+					 src_info->data_width,
+					 dst_info->data_width);
+
+		(void) d40_log_sg_to_lli(sg_dst, sg_len,
+					 desc->lli_log.dst,
+					 chan->log_def.lcsp3,
+					 dst_info->data_width,
+					 src_info->data_width);
+	} else {
+		unsigned int total_size;
+
+		total_size = d40_log_sg_to_dev(sg_src, sg_len,
+					       &desc->lli_log,
+					       &chan->log_def,
+					       src_info->data_width,
+					       dst_info->data_width,
+					       direction, dev_addr);
+		if (total_size < 0)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+d40_prep_sg_phy(struct d40_chan *chan, struct d40_desc *desc,
+		struct scatterlist *sg_src, struct scatterlist *sg_dst,
+		unsigned int sg_len, enum dma_data_direction direction,
+		dma_addr_t dev_addr)
+{
+	dma_addr_t src_dev_addr = direction == DMA_FROM_DEVICE ? dev_addr : 0;
+	dma_addr_t dst_dev_addr = direction == DMA_TO_DEVICE ? dev_addr : 0;
+	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
+	struct stedma40_half_channel_info *src_info = &cfg->src_info;
+	struct stedma40_half_channel_info *dst_info = &cfg->dst_info;
+	int ret;
+
+	ret = d40_phy_sg_to_lli(sg_src, sg_len, src_dev_addr,
+				desc->lli_phy.src,
+				virt_to_phys(desc->lli_phy.src),
+				chan->src_def_cfg,
+				src_info->data_width,
+				dst_info->data_width,
+				src_info->psize);
+
+	ret = d40_phy_sg_to_lli(sg_dst, sg_len, dst_dev_addr,
+				desc->lli_phy.dst,
+				virt_to_phys(desc->lli_phy.dst),
+				chan->dst_def_cfg,
+				dst_info->data_width,
+				src_info->data_width,
+				dst_info->psize);
+
+	dma_sync_single_for_device(chan->base->dev, desc->lli_pool.dma_addr,
+				   desc->lli_pool.size, DMA_TO_DEVICE);
+
+	return ret < 0 ? ret : 0;
+}
+
+
 static struct d40_desc *
 d40_prep_desc(struct d40_chan *chan, struct scatterlist *sg,
 	      unsigned int sg_len, unsigned long dma_flags)
@@ -1663,7 +1738,6 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 						   unsigned int sgl_len,
 						   unsigned long dma_flags)
 {
-	int res;
 	struct d40_desc *d40d;
 	struct d40_chan *d40c = container_of(chan, struct d40_chan,
 					     chan);
@@ -1681,49 +1755,11 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 		goto err;
 
 	if (chan_is_logical(d40c)) {
-		(void) d40_log_sg_to_lli(sgl_src,
-					 sgl_len,
-					 d40d->lli_log.src,
-					 d40c->log_def.lcsp1,
-					 d40c->dma_cfg.src_info.data_width,
-					 d40c->dma_cfg.dst_info.data_width);
-
-		(void) d40_log_sg_to_lli(sgl_dst,
-					 sgl_len,
-					 d40d->lli_log.dst,
-					 d40c->log_def.lcsp3,
-					 d40c->dma_cfg.dst_info.data_width,
-					 d40c->dma_cfg.src_info.data_width);
+		d40_prep_sg_log(d40c, d40d, sgl_src, sgl_dst,
+				sgl_len, DMA_NONE, 0);
 	} else {
-		res = d40_phy_sg_to_lli(sgl_src,
-					sgl_len,
-					0,
-					d40d->lli_phy.src,
-					virt_to_phys(d40d->lli_phy.src),
-					d40c->src_def_cfg,
-					d40c->dma_cfg.src_info.data_width,
-					d40c->dma_cfg.dst_info.data_width,
-					d40c->dma_cfg.src_info.psize);
-
-		if (res < 0)
-			goto err;
-
-		res = d40_phy_sg_to_lli(sgl_dst,
-					sgl_len,
-					0,
-					d40d->lli_phy.dst,
-					virt_to_phys(d40d->lli_phy.dst),
-					d40c->dst_def_cfg,
-					d40c->dma_cfg.dst_info.data_width,
-					d40c->dma_cfg.src_info.data_width,
-					d40c->dma_cfg.dst_info.psize);
-
-		if (res < 0)
-			goto err;
-
-		dma_sync_single_for_device(d40c->base->dev,
-					   d40d->lli_pool.dma_addr,
-					   d40d->lli_pool.size, DMA_TO_DEVICE);
+		d40_prep_sg_phy(d40c, d40d, sgl_src, sgl_dst,
+				sgl_len, DMA_NONE, 0);
 	}
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
@@ -1904,69 +1940,6 @@ d40_prep_sg(struct dma_chan *chan,
 	return stedma40_memcpy_sg(chan, dst_sg, src_sg, dst_nents, dma_flags);
 }
 
-static int d40_prep_slave_sg_log(struct d40_desc *d40d,
-				 struct d40_chan *d40c,
-				 struct scatterlist *sgl,
-				 unsigned int sg_len,
-				 enum dma_data_direction direction,
-				 dma_addr_t dev_addr)
-{
-	int total_size;
-
-	total_size = d40_log_sg_to_dev(sgl, sg_len,
-				       &d40d->lli_log,
-				       &d40c->log_def,
-				       d40c->dma_cfg.src_info.data_width,
-				       d40c->dma_cfg.dst_info.data_width,
-				       direction,
-				       dev_addr);
-
-	if (total_size < 0)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
-				 struct d40_chan *d40c,
-				 struct scatterlist *sgl,
-				 unsigned int sgl_len,
-				 enum dma_data_direction direction,
-				 dma_addr_t dev_addr)
-{
-	dma_addr_t src_dev_addr = direction == DMA_FROM_DEVICE ? dev_addr : 0;
-	dma_addr_t dst_dev_addr = direction == DMA_TO_DEVICE ? dev_addr : 0;
-	int res;
-
-	res = d40_phy_sg_to_lli(sgl,
-				sgl_len,
-				src_dev_addr,
-				d40d->lli_phy.src,
-				virt_to_phys(d40d->lli_phy.src),
-				d40c->src_def_cfg,
-				d40c->dma_cfg.src_info.data_width,
-				d40c->dma_cfg.dst_info.data_width,
-				d40c->dma_cfg.src_info.psize);
-	if (res < 0)
-		return res;
-
-	res = d40_phy_sg_to_lli(sgl,
-				sgl_len,
-				dst_dev_addr,
-				d40d->lli_phy.dst,
-				virt_to_phys(d40d->lli_phy.dst),
-				d40c->dst_def_cfg,
-				d40c->dma_cfg.dst_info.data_width,
-				d40c->dma_cfg.src_info.data_width,
-				d40c->dma_cfg.dst_info.psize);
-	if (res < 0)
-		return res;
-
-	dma_sync_single_for_device(d40c->base->dev, d40d->lli_pool.dma_addr,
-				   d40d->lli_pool.size, DMA_TO_DEVICE);
-	return 0;
-}
-
 static dma_addr_t
 d40_get_dev_addr(struct d40_chan *chan, enum dma_data_direction direction)
 {
@@ -2015,11 +1988,12 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 	dev_addr = d40_get_dev_addr(d40c, direction);
 
 	if (chan_is_logical(d40c))
-		err = d40_prep_slave_sg_log(d40d, d40c, sgl, sg_len,
-					    direction, dev_addr);
+		err = d40_prep_sg_log(d40c, d40d, sgl, NULL,
+				      sg_len, direction, dev_addr);
 	else
-		err = d40_prep_slave_sg_phy(d40d, d40c, sgl, sg_len,
-					    direction, dev_addr);
+		err = d40_prep_sg_phy(d40c, d40d, sgl, NULL,
+				      sg_len, direction, dev_addr);
+
 	if (err) {
 		chan_err(d40c, "Failed to prepare %s slave sg job: %d\n",
 			chan_is_logical(d40c) ? "log" : "phy", err);
-- 
1.7.3.2

