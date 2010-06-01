Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab0FAMUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:20:43 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:46151 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408Ab0FAMUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:20:41 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Per Friden <per.friden@stericsson.com>,
       Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 01/18] DMAENGINE: ste_dma40: fixed lli_max=1 issue
Date: Tue, 1 Jun 2010 14:20:26 +0200
Message-ID: <1275394826-26111-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Friden <per.friden@stericsson.com>

Fixed lli_max=1 issue in case of full lcla, currently this case
is not properly handled.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   62 ++++++++++++++++++++++-------------------------
 1 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index c426829..4618d6c 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -81,9 +81,10 @@ struct d40_lli_pool {
  * lli_len equals one.
  * @lli_log: Same as above but for logical channels.
  * @lli_pool: The pool with two entries pre-allocated.
- * @lli_len: Number of LLI's in lli_pool
- * @lli_tcount: Number of LLIs processed in the transfer. When equals lli_len
- * then this transfer job is done.
+ * @lli_len: Number of llis of current descriptor.
+ * @lli_count: Number of transfered llis.
+ * @lli_tx_len: Max number of LLIs per transfer, there can be
+ * many transfer for one descriptor.
  * @txd: DMA engine struct. Used for among other things for communication
  * during a transfer.
  * @node: List entry.
@@ -100,8 +101,9 @@ struct d40_desc {
 	struct d40_log_lli_bidir	 lli_log;
 
 	struct d40_lli_pool		 lli_pool;
-	u32				 lli_len;
-	u32				 lli_tcount;
+	int				 lli_len;
+	int				 lli_count;
+	u32				 lli_tx_len;
 
 	struct dma_async_tx_descriptor	 txd;
 	struct list_head		 node;
@@ -365,11 +367,6 @@ static dma_cookie_t d40_assign_cookie(struct d40_chan *d40c,
 	return cookie;
 }
 
-static void d40_desc_reset(struct d40_desc *d40d)
-{
-	d40d->lli_tcount = 0;
-}
-
 static void d40_desc_remove(struct d40_desc *d40d)
 {
 	list_del(&d40d->node);
@@ -738,25 +735,18 @@ static void d40_desc_load(struct d40_chan *d40c, struct d40_desc *d40d)
 				  d40c->phy_chan->num,
 				  d40d->lli_phy.dst,
 				  d40d->lli_phy.src);
-		d40d->lli_tcount = d40d->lli_len;
 	} else if (d40d->lli_log.dst && d40d->lli_log.src) {
-		u32 lli_len;
 		struct d40_log_lli *src = d40d->lli_log.src;
 		struct d40_log_lli *dst = d40d->lli_log.dst;
 
-		src += d40d->lli_tcount;
-		dst += d40d->lli_tcount;
-
-		if (d40d->lli_len <= d40c->base->plat_data->llis_per_log)
-			lli_len = d40d->lli_len;
-		else
-			lli_len = d40c->base->plat_data->llis_per_log;
-		d40d->lli_tcount += lli_len;
+		src += d40d->lli_count;
+		dst += d40d->lli_count;
 		d40_log_lli_write(d40c->lcpa, d40c->lcla.src,
 				  d40c->lcla.dst,
 				  dst, src,
 				  d40c->base->plat_data->llis_per_log);
 	}
+	d40d->lli_count += d40d->lli_tx_len;
 }
 
 static dma_cookie_t d40_tx_submit(struct dma_async_tx_descriptor *tx)
@@ -838,7 +828,7 @@ static void dma_tc_handle(struct d40_chan *d40c)
 	if (d40d == NULL)
 		return;
 
-	if (d40d->lli_tcount < d40d->lli_len) {
+	if (d40d->lli_count < d40d->lli_len) {
 
 		d40_desc_load(d40c, d40d);
 		/* Start dma job */
@@ -891,7 +881,6 @@ static void dma_tasklet(unsigned long data)
 		/* Return desc to free-list */
 		d40_desc_free(d40c, d40d_fin);
 	} else {
-		d40_desc_reset(d40d_fin);
 		if (!d40d_fin->is_in_client_list) {
 			d40_desc_remove(d40d_fin);
 			list_add_tail(&d40d_fin->node, &d40c->client);
@@ -1573,7 +1562,6 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 	struct d40_chan *d40c = container_of(chan, struct d40_chan,
 					     chan);
 	unsigned long flg;
-	int lli_max = d40c->base->plat_data->llis_per_log;
 
 
 	spin_lock_irqsave(&d40c->lock, flg);
@@ -1584,10 +1572,13 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 
 	memset(d40d, 0, sizeof(struct d40_desc));
 	d40d->lli_len = sgl_len;
-
+	d40d->lli_tx_len = d40d->lli_len;
 	d40d->txd.flags = flags;
 
 	if (d40c->log_num != D40_PHY_CHAN) {
+		if (d40d->lli_len > d40c->base->plat_data->llis_per_log)
+			d40d->lli_tx_len = d40c->base->plat_data->llis_per_log;
+
 		if (sgl_len > 1)
 			/*
 			 * Check if there is space available in lcla. If not,
@@ -1596,7 +1587,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 			 */
 			if (d40_lcla_id_get(d40c,
 					    &d40c->base->lcla_pool) != 0)
-				lli_max = 1;
+				d40d->lli_tx_len = 1;
 
 		if (d40_pool_lli_alloc(d40d, sgl_len, true) < 0) {
 			dev_err(&d40c->chan.dev->device,
@@ -1610,7 +1601,8 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					 d40d->lli_log.src,
 					 d40c->log_def.lcsp1,
 					 d40c->dma_cfg.src_info.data_width,
-					 flags & DMA_PREP_INTERRUPT, lli_max,
+					 flags & DMA_PREP_INTERRUPT,
+					 d40d->lli_tx_len,
 					 d40c->base->plat_data->llis_per_log);
 
 		(void) d40_log_sg_to_lli(d40c->lcla.dst_id,
@@ -1619,7 +1611,8 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					 d40d->lli_log.dst,
 					 d40c->log_def.lcsp3,
 					 d40c->dma_cfg.dst_info.data_width,
-					 flags & DMA_PREP_INTERRUPT, lli_max,
+					 flags & DMA_PREP_INTERRUPT,
+					 d40d->lli_tx_len,
 					 d40c->base->plat_data->llis_per_log);
 
 
@@ -1794,6 +1787,7 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 			goto err;
 		}
 		d40d->lli_len = 1;
+		d40d->lli_tx_len = 1;
 
 		d40_log_fill_lli(d40d->lli_log.src,
 				 src,
@@ -1869,7 +1863,6 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 {
 	dma_addr_t dev_addr = 0;
 	int total_size;
-	int lli_max = d40c->base->plat_data->llis_per_log;
 
 	if (d40_pool_lli_alloc(d40d, sg_len, true) < 0) {
 		dev_err(&d40c->chan.dev->device,
@@ -1878,7 +1871,10 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 	}
 
 	d40d->lli_len = sg_len;
-	d40d->lli_tcount = 0;
+	if (d40d->lli_len <= d40c->base->plat_data->llis_per_log)
+		d40d->lli_tx_len = d40d->lli_len;
+	else
+		d40d->lli_tx_len = d40c->base->plat_data->llis_per_log;
 
 	if (sg_len > 1)
 		/*
@@ -1887,7 +1883,7 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 		 * in lcpa space.
 		 */
 		if (d40_lcla_id_get(d40c, &d40c->base->lcla_pool) != 0)
-			lli_max = 1;
+			d40d->lli_tx_len = 1;
 
 	if (direction == DMA_FROM_DEVICE) {
 		dev_addr = d40c->base->plat_data->dev_rx[d40c->dma_cfg.src_dev_type];
@@ -1899,7 +1895,7 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 					       d40c->dma_cfg.dst_info.data_width,
 					       direction,
 					       flags & DMA_PREP_INTERRUPT,
-					       dev_addr, lli_max,
+					       dev_addr, d40d->lli_tx_len,
 					       d40c->base->plat_data->llis_per_log);
 	} else if (direction == DMA_TO_DEVICE) {
 		dev_addr = d40c->base->plat_data->dev_tx[d40c->dma_cfg.dst_dev_type];
@@ -1911,7 +1907,7 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 					       d40c->dma_cfg.dst_info.data_width,
 					       direction,
 					       flags & DMA_PREP_INTERRUPT,
-					       dev_addr, lli_max,
+					       dev_addr, d40d->lli_tx_len,
 					       d40c->base->plat_data->llis_per_log);
 	} else
 		return -EINVAL;
@@ -1939,7 +1935,7 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 	}
 
 	d40d->lli_len = sgl_len;
-	d40d->lli_tcount = 0;
+	d40d->lli_tx_len = sgl_len;
 
 	if (direction == DMA_FROM_DEVICE) {
 		dst_dev_addr = 0;
-- 
1.6.3.3

