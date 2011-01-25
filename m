Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1AYKX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:23:27 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:49159 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226Ab1AYKTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:35 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 17/32] dma40: remove duplicated dev addr code
Date: Tue, 25 Jan 2011 11:18:20 +0100
Message-ID: <1295950715-22340-18-git-send-email-linus.walleij@stericsson.com>
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
 drivers/dma/ste_dma40.c |   66 +++++++++++++++++++++-------------------------
 1 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 495f9eb..65b5aad 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1909,25 +1909,10 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 				 struct scatterlist *sgl,
 				 unsigned int sg_len,
 				 enum dma_data_direction direction,
-				 unsigned long dma_flags)
+				 dma_addr_t dev_addr)
 {
-	dma_addr_t dev_addr = 0;
 	int total_size;
 
-	if (direction == DMA_FROM_DEVICE)
-		if (d40c->runtime_addr)
-			dev_addr = d40c->runtime_addr;
-		else
-			dev_addr = d40c->base->plat_data->dev_rx[d40c->dma_cfg.src_dev_type];
-	else if (direction == DMA_TO_DEVICE)
-		if (d40c->runtime_addr)
-			dev_addr = d40c->runtime_addr;
-		else
-			dev_addr = d40c->base->plat_data->dev_tx[d40c->dma_cfg.dst_dev_type];
-
-	else
-		return -EINVAL;
-
 	total_size = d40_log_sg_to_dev(sgl, sg_len,
 				       &d40d->lli_log,
 				       &d40c->log_def,
@@ -1947,27 +1932,12 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 				 struct scatterlist *sgl,
 				 unsigned int sgl_len,
 				 enum dma_data_direction direction,
-				 unsigned long dma_flags)
+				 dma_addr_t dev_addr)
 {
-	dma_addr_t src_dev_addr;
-	dma_addr_t dst_dev_addr;
+	dma_addr_t src_dev_addr = direction == DMA_FROM_DEVICE ? dev_addr : 0;
+	dma_addr_t dst_dev_addr = direction == DMA_TO_DEVICE ? dev_addr : 0;
 	int res;
 
-	if (direction == DMA_FROM_DEVICE) {
-		dst_dev_addr = 0;
-		if (d40c->runtime_addr)
-			src_dev_addr = d40c->runtime_addr;
-		else
-			src_dev_addr = d40c->base->plat_data->dev_rx[d40c->dma_cfg.src_dev_type];
-	} else if (direction == DMA_TO_DEVICE) {
-		if (d40c->runtime_addr)
-			dst_dev_addr = d40c->runtime_addr;
-		else
-			dst_dev_addr = d40c->base->plat_data->dev_tx[d40c->dma_cfg.dst_dev_type];
-		src_dev_addr = 0;
-	} else
-		return -EINVAL;
-
 	res = d40_phy_sg_to_lli(sgl,
 				sgl_len,
 				src_dev_addr,
@@ -1997,6 +1967,24 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 	return 0;
 }
 
+static dma_addr_t
+d40_get_dev_addr(struct d40_chan *chan, enum dma_data_direction direction)
+{
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
 static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 							 struct scatterlist *sgl,
 							 unsigned int sg_len,
@@ -2006,6 +1994,7 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 	struct d40_desc *d40d;
 	struct d40_chan *d40c = container_of(chan, struct d40_chan,
 					     chan);
+	dma_addr_t dev_addr;
 	unsigned long flags;
 	int err;
 
@@ -2014,18 +2003,23 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (direction != DMA_FROM_DEVICE && direction != DMA_TO_DEVICE)
+		return NULL;
+
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	d40d = d40_prep_desc(d40c, sgl, sg_len, dma_flags);
 	if (d40d == NULL)
 		goto err;
 
+	dev_addr = d40_get_dev_addr(d40c, direction);
+
 	if (chan_is_logical(d40c))
 		err = d40_prep_slave_sg_log(d40d, d40c, sgl, sg_len,
-					    direction, dma_flags);
+					    direction, dev_addr);
 	else
 		err = d40_prep_slave_sg_phy(d40d, d40c, sgl, sg_len,
-					    direction, dma_flags);
+					    direction, dev_addr);
 	if (err) {
 		chan_err(d40c, "Failed to prepare %s slave sg job: %d\n",
 			chan_is_logical(d40c) ? "log" : "phy", err);
-- 
1.7.3.2

