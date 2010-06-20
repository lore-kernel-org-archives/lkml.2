Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab0FTV2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:28:24 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:51743 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902Ab0FTVZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:25:30 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 06/19] DMAENGINE: ste_dma40: various cosmetic clean-ups
Date: Sun, 20 Jun 2010 23:25:24 +0200
Message-ID: <1277069124-30889-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

This cleans up some extra newlines, removes some code duplication
and moves the code to comply better with checkpatch.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c    |   95 ++++++++++++++++++-------------------------
 drivers/dma/ste_dma40_ll.c |   24 ++++++------
 2 files changed, 52 insertions(+), 67 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 8ed1547..1d17664 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -161,7 +161,8 @@ struct d40_base;
  * @pending_tx: The number of pending transfers. Used between interrupt handler
  * and tasklet.
  * @busy: Set to true when transfer is ongoing on this channel.
- * @phy_chan: Pointer to physical channel which this instance runs on.
+ * @phy_chan: Pointer to physical channel which this instance runs on. If this
+ * point is NULL, then the channel is not allocated.
  * @chan: DMA engine handle.
  * @tasklet: Tasklet that gets scheduled from interrupt context to complete a
  * transfer and call client callback.
@@ -1236,7 +1237,6 @@ static int d40_free_dma(struct d40_chan *d40c)
 		return -EINVAL;
 	}
 
-
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
 	if (res) {
 		dev_err(&d40c->chan.dev->device, "[%s] suspend failed\n",
@@ -1305,8 +1305,6 @@ static int d40_free_dma(struct d40_chan *d40c)
 	d40c->base->lookup_phy_chans[phy->num] = NULL;
 
 	return 0;
-
-
 }
 
 static int d40_pause(struct dma_chan *chan)
@@ -1314,7 +1312,6 @@ static int d40_pause(struct dma_chan *chan)
 	struct d40_chan *d40c =
 		container_of(chan, struct d40_chan, chan);
 	int res;
-
 	unsigned long flags;
 
 	spin_lock_irqsave(&d40c->lock, flags);
@@ -1510,25 +1507,23 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 						   struct scatterlist *sgl_dst,
 						   struct scatterlist *sgl_src,
 						   unsigned int sgl_len,
-						   unsigned long flags)
+						   unsigned long dma_flags)
 {
 	int res;
 	struct d40_desc *d40d;
 	struct d40_chan *d40c = container_of(chan, struct d40_chan,
 					     chan);
-	unsigned long flg;
-
+	unsigned long flags;
 
-	spin_lock_irqsave(&d40c->lock, flg);
+	spin_lock_irqsave(&d40c->lock, flags);
 	d40d = d40_desc_get(d40c);
 
 	if (d40d == NULL)
 		goto err;
 
-	memset(d40d, 0, sizeof(struct d40_desc));
 	d40d->lli_len = sgl_len;
 	d40d->lli_tx_len = d40d->lli_len;
-	d40d->txd.flags = flags;
+	d40d->txd.flags = dma_flags;
 
 	if (d40c->log_num != D40_PHY_CHAN) {
 		if (d40d->lli_len > d40c->base->plat_data->llis_per_log)
@@ -1556,7 +1551,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					 d40d->lli_log.src,
 					 d40c->log_def.lcsp1,
 					 d40c->dma_cfg.src_info.data_width,
-					 flags & DMA_PREP_INTERRUPT,
+					 dma_flags & DMA_PREP_INTERRUPT,
 					 d40d->lli_tx_len,
 					 d40c->base->plat_data->llis_per_log);
 
@@ -1566,7 +1561,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					 d40d->lli_log.dst,
 					 d40c->log_def.lcsp3,
 					 d40c->dma_cfg.dst_info.data_width,
-					 flags & DMA_PREP_INTERRUPT,
+					 dma_flags & DMA_PREP_INTERRUPT,
 					 d40d->lli_tx_len,
 					 d40c->base->plat_data->llis_per_log);
 
@@ -1612,11 +1607,11 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 
 	d40d->txd.tx_submit = d40_tx_submit;
 
-	spin_unlock_irqrestore(&d40c->lock, flg);
+	spin_unlock_irqrestore(&d40c->lock, flags);
 
 	return &d40d->txd;
 err:
-	spin_unlock_irqrestore(&d40c->lock, flg);
+	spin_unlock_irqrestore(&d40c->lock, flags);
 	return NULL;
 }
 EXPORT_SYMBOL(stedma40_memcpy_sg);
@@ -1729,15 +1724,15 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 						       dma_addr_t dst,
 						       dma_addr_t src,
 						       size_t size,
-						       unsigned long flags)
+						       unsigned long dma_flags)
 {
 	struct d40_desc *d40d;
 	struct d40_chan *d40c = container_of(chan, struct d40_chan,
 					     chan);
-	unsigned long flg;
+	unsigned long flags;
 	int err = 0;
 
-	spin_lock_irqsave(&d40c->lock, flg);
+	spin_lock_irqsave(&d40c->lock, flags);
 	d40d = d40_desc_get(d40c);
 
 	if (d40d == NULL) {
@@ -1746,9 +1741,7 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 		goto err;
 	}
 
-	memset(d40d, 0, sizeof(struct d40_desc));
-
-	d40d->txd.flags = flags;
+	d40d->txd.flags = dma_flags;
 
 	dma_async_tx_descriptor_init(&d40d->txd, chan);
 
@@ -1817,7 +1810,7 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 				      d40d->lli_pool.size, DMA_TO_DEVICE);
 	}
 
-	spin_unlock_irqrestore(&d40c->lock, flg);
+	spin_unlock_irqrestore(&d40c->lock, flags);
 	return &d40d->txd;
 
 err_fill_lli:
@@ -1825,7 +1818,7 @@ err_fill_lli:
 		"[%s] Failed filling in PHY LLI\n", __func__);
 	d40_pool_lli_free(d40d);
 err:
-	spin_unlock_irqrestore(&d40c->lock, flg);
+	spin_unlock_irqrestore(&d40c->lock, flags);
 	return NULL;
 }
 
@@ -1834,7 +1827,7 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 				 struct scatterlist *sgl,
 				 unsigned int sg_len,
 				 enum dma_data_direction direction,
-				 unsigned long flags)
+				 unsigned long dma_flags)
 {
 	dma_addr_t dev_addr = 0;
 	int total_size;
@@ -1860,32 +1853,24 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 		if (d40_lcla_id_get(d40c, &d40c->base->lcla_pool) != 0)
 			d40d->lli_tx_len = 1;
 
-	if (direction == DMA_FROM_DEVICE) {
+	if (direction == DMA_FROM_DEVICE)
 		dev_addr = d40c->base->plat_data->dev_rx[d40c->dma_cfg.src_dev_type];
-		total_size = d40_log_sg_to_dev(&d40c->lcla,
-					       sgl, sg_len,
-					       &d40d->lli_log,
-					       &d40c->log_def,
-					       d40c->dma_cfg.src_info.data_width,
-					       d40c->dma_cfg.dst_info.data_width,
-					       direction,
-					       flags & DMA_PREP_INTERRUPT,
-					       dev_addr, d40d->lli_tx_len,
-					       d40c->base->plat_data->llis_per_log);
-	} else if (direction == DMA_TO_DEVICE) {
+	else if (direction == DMA_TO_DEVICE)
 		dev_addr = d40c->base->plat_data->dev_tx[d40c->dma_cfg.dst_dev_type];
-		total_size = d40_log_sg_to_dev(&d40c->lcla,
-					       sgl, sg_len,
-					       &d40d->lli_log,
-					       &d40c->log_def,
-					       d40c->dma_cfg.src_info.data_width,
-					       d40c->dma_cfg.dst_info.data_width,
-					       direction,
-					       flags & DMA_PREP_INTERRUPT,
-					       dev_addr, d40d->lli_tx_len,
-					       d40c->base->plat_data->llis_per_log);
-	} else
+	else
 		return -EINVAL;
+
+	total_size = d40_log_sg_to_dev(&d40c->lcla,
+				       sgl, sg_len,
+				       &d40d->lli_log,
+				       &d40c->log_def,
+				       d40c->dma_cfg.src_info.data_width,
+				       d40c->dma_cfg.dst_info.data_width,
+				       direction,
+				       dma_flags & DMA_PREP_INTERRUPT,
+				       dev_addr, d40d->lli_tx_len,
+				       d40c->base->plat_data->llis_per_log);
+
 	if (total_size < 0)
 		return -EINVAL;
 
@@ -1897,7 +1882,7 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 				 struct scatterlist *sgl,
 				 unsigned int sgl_len,
 				 enum dma_data_direction direction,
-				 unsigned long flags)
+				 unsigned long dma_flags)
 {
 	dma_addr_t src_dev_addr;
 	dma_addr_t dst_dev_addr;
@@ -1954,12 +1939,12 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 							 struct scatterlist *sgl,
 							 unsigned int sg_len,
 							 enum dma_data_direction direction,
-							 unsigned long flags)
+							 unsigned long dma_flags)
 {
 	struct d40_desc *d40d;
 	struct d40_chan *d40c = container_of(chan, struct d40_chan,
 					     chan);
-	unsigned long flg;
+	unsigned long flags;
 	int err;
 
 	if (d40c->dma_cfg.pre_transfer)
@@ -1967,9 +1952,9 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 					   d40c->dma_cfg.pre_transfer_data,
 					   sg_dma_len(sgl));
 
-	spin_lock_irqsave(&d40c->lock, flg);
+	spin_lock_irqsave(&d40c->lock, flags);
 	d40d = d40_desc_get(d40c);
-	spin_unlock_irqrestore(&d40c->lock, flg);
+	spin_unlock_irqrestore(&d40c->lock, flags);
 
 	if (d40d == NULL)
 		return NULL;
@@ -1978,10 +1963,10 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 
 	if (d40c->log_num != D40_PHY_CHAN)
 		err = d40_prep_slave_sg_log(d40d, d40c, sgl, sg_len,
-					    direction, flags);
+					    direction, dma_flags);
 	else
 		err = d40_prep_slave_sg_phy(d40d, d40c, sgl, sg_len,
-					    direction, flags);
+					    direction, dma_flags);
 	if (err) {
 		dev_err(&d40c->chan.dev->device,
 			"[%s] Failed to prepare %s slave sg job: %d\n",
@@ -1990,7 +1975,7 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 		return NULL;
 	}
 
-	d40d->txd.flags = flags;
+	d40d->txd.flags = dma_flags;
 
 	dma_async_tx_descriptor_init(&d40d->txd, chan);
 
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 561fdd8..e0194e4 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -430,25 +430,25 @@ void d40_log_lli_write(struct d40_log_lli_full *lcpa,
 		       struct d40_log_lli *lli_src,
 		       int llis_per_log)
 {
-	u32 slos = 0;
-	u32 dlos = 0;
+	u32 slos;
+	u32 dlos;
 	int i;
 
-	lcpa->lcsp0 = lli_src->lcsp02;
-	lcpa->lcsp1 = lli_src->lcsp13;
-	lcpa->lcsp2 = lli_dst->lcsp02;
-	lcpa->lcsp3 = lli_dst->lcsp13;
+	writel(lli_src->lcsp02, &lcpa->lcsp0);
+	writel(lli_src->lcsp13, &lcpa->lcsp1);
+	writel(lli_dst->lcsp02, &lcpa->lcsp2);
+	writel(lli_dst->lcsp13, &lcpa->lcsp3);
 
 	slos = lli_src->lcsp13 & D40_MEM_LCSP1_SLOS_MASK;
 	dlos = lli_dst->lcsp13 & D40_MEM_LCSP3_DLOS_MASK;
 
 	for (i = 0; (i < llis_per_log) && slos && dlos; i++) {
-		writel(lli_src[i+1].lcsp02, &lcla_src[i].lcsp02);
-		writel(lli_src[i+1].lcsp13, &lcla_src[i].lcsp13);
-		writel(lli_dst[i+1].lcsp02, &lcla_dst[i].lcsp02);
-		writel(lli_dst[i+1].lcsp13, &lcla_dst[i].lcsp13);
+		writel(lli_src[i + 1].lcsp02, &lcla_src[i].lcsp02);
+		writel(lli_src[i + 1].lcsp13, &lcla_src[i].lcsp13);
+		writel(lli_dst[i + 1].lcsp02, &lcla_dst[i].lcsp02);
+		writel(lli_dst[i + 1].lcsp13, &lcla_dst[i].lcsp13);
 
-		slos = lli_src[i+1].lcsp13 & D40_MEM_LCSP1_SLOS_MASK;
-		dlos = lli_dst[i+1].lcsp13 & D40_MEM_LCSP3_DLOS_MASK;
+		slos = lli_src[i + 1].lcsp13 & D40_MEM_LCSP1_SLOS_MASK;
+		dlos = lli_dst[i + 1].lcsp13 & D40_MEM_LCSP3_DLOS_MASK;
 	}
 }
-- 
1.6.3.3

