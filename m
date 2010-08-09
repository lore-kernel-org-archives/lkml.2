Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab0HIMIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:08:42 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:42986 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756434Ab0HIMIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:08:38 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 07/14] DMAENGINE: ste_dma40: added support for link jobs in hw
Date: Mon, 9 Aug 2010 14:08:26 +0200
Message-ID: <1281355706-13312-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

If a new job is added on a physical channel that already has
a job, the new job is linked in hw to the old job instead of
queueing up the jobs.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c    |  314 ++++++++++++++++++++++++++++----------------
 drivers/dma/ste_dma40_ll.h |    4 -
 2 files changed, 202 insertions(+), 116 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index c042103..b8987e7 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -92,6 +92,8 @@ struct d40_lli_pool {
  * @node: List entry.
  * @dir: The transfer direction of this job.
  * @is_in_client_list: true if the client owns this descriptor.
+ * @is_hw_linked: true if this job will automatically be continued for
+ * the previous one.
  *
  * This descriptor is used for both logical and physical transfers.
  */
@@ -112,6 +114,7 @@ struct d40_desc {
 
 	enum dma_data_direction		 dir;
 	bool				 is_in_client_list;
+	bool				 is_hw_linked;
 };
 
 /**
@@ -340,9 +343,6 @@ static int d40_pool_lli_alloc(struct d40_desc *d40d,
 					      align);
 		d40d->lli_phy.dst = PTR_ALIGN(d40d->lli_phy.src + lli_len,
 					      align);
-
-		d40d->lli_phy.src_addr = virt_to_phys(d40d->lli_phy.src);
-		d40d->lli_phy.dst_addr = virt_to_phys(d40d->lli_phy.dst);
 	}
 
 	return 0;
@@ -357,22 +357,6 @@ static void d40_pool_lli_free(struct d40_desc *d40d)
 	d40d->lli_log.dst = NULL;
 	d40d->lli_phy.src = NULL;
 	d40d->lli_phy.dst = NULL;
-	d40d->lli_phy.src_addr = 0;
-	d40d->lli_phy.dst_addr = 0;
-}
-
-static dma_cookie_t d40_assign_cookie(struct d40_chan *d40c,
-				      struct d40_desc *desc)
-{
-	dma_cookie_t cookie = d40c->chan.cookie;
-
-	if (++cookie < 0)
-		cookie = 1;
-
-	d40c->chan.cookie = cookie;
-	desc->txd.cookie = cookie;
-
-	return cookie;
 }
 
 static void d40_desc_remove(struct d40_desc *d40d)
@@ -443,6 +427,18 @@ static struct d40_desc *d40_first_queued(struct d40_chan *d40c)
 	return d;
 }
 
+static struct d40_desc *d40_last_queued(struct d40_chan *d40c)
+{
+	struct d40_desc *d;
+
+	if (list_empty(&d40c->queue))
+		return NULL;
+	list_for_each_entry(d, &d40c->queue, node)
+		if (list_is_last(&d->node, &d40c->queue))
+			break;
+	return d;
+}
+
 /* Support functions for logical channels */
 
 static int d40_lcla_id_get(struct d40_chan *d40c)
@@ -729,6 +725,161 @@ static void d40_desc_load(struct d40_chan *d40c, struct d40_desc *d40d)
 	d40d->lli_count += d40d->lli_tx_len;
 }
 
+static u32 d40_residue(struct d40_chan *d40c)
+{
+	u32 num_elt;
+
+	if (d40c->log_num != D40_PHY_CHAN)
+		num_elt = (readl(&d40c->lcpa->lcsp2) & D40_MEM_LCSP2_ECNT_MASK)
+			>> D40_MEM_LCSP2_ECNT_POS;
+	else
+		num_elt = (readl(d40c->base->virtbase + D40_DREG_PCBASE +
+				 d40c->phy_chan->num * D40_DREG_PCDELTA +
+				 D40_CHAN_REG_SDELT) &
+			   D40_SREG_ELEM_PHY_ECNT_MASK) >>
+			D40_SREG_ELEM_PHY_ECNT_POS;
+	return num_elt * (1 << d40c->dma_cfg.dst_info.data_width);
+}
+
+static bool d40_tx_is_linked(struct d40_chan *d40c)
+{
+	bool is_link;
+
+	if (d40c->log_num != D40_PHY_CHAN)
+		is_link = readl(&d40c->lcpa->lcsp3) &  D40_MEM_LCSP3_DLOS_MASK;
+	else
+		is_link = readl(d40c->base->virtbase + D40_DREG_PCBASE +
+				d40c->phy_chan->num * D40_DREG_PCDELTA +
+				D40_CHAN_REG_SDLNK) &
+			D40_SREG_LNK_PHYS_LNK_MASK;
+	return is_link;
+}
+
+static int d40_pause(struct dma_chan *chan)
+{
+	struct d40_chan *d40c =
+		container_of(chan, struct d40_chan, chan);
+	int res = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&d40c->lock, flags);
+
+	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
+	if (res == 0) {
+		if (d40c->log_num != D40_PHY_CHAN) {
+			d40_config_set_event(d40c, false);
+			/* Resume the other logical channels if any */
+			if (d40_chan_has_events(d40c))
+				res = d40_channel_execute_command(d40c,
+								  D40_DMA_RUN);
+		}
+	}
+
+	spin_unlock_irqrestore(&d40c->lock, flags);
+	return res;
+}
+
+static int d40_resume(struct dma_chan *chan)
+{
+	struct d40_chan *d40c =
+		container_of(chan, struct d40_chan, chan);
+	int res = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&d40c->lock, flags);
+
+	if (d40c->base->rev == 0)
+		if (d40c->log_num != D40_PHY_CHAN) {
+			res = d40_channel_execute_command(d40c,
+							  D40_DMA_SUSPEND_REQ);
+			goto no_suspend;
+		}
+
+	/* If bytes left to transfer or linked tx resume job */
+	if (d40_residue(d40c) || d40_tx_is_linked(d40c)) {
+
+		if (d40c->log_num != D40_PHY_CHAN)
+			d40_config_set_event(d40c, true);
+
+		res = d40_channel_execute_command(d40c, D40_DMA_RUN);
+	}
+
+no_suspend:
+	spin_unlock_irqrestore(&d40c->lock, flags);
+	return res;
+}
+
+static void d40_tx_submit_log(struct d40_chan *d40c, struct d40_desc *d40d)
+{
+	/* TODO: Write */
+}
+
+static void d40_tx_submit_phy(struct d40_chan *d40c, struct d40_desc *d40d)
+{
+	struct d40_desc *d40d_prev = NULL;
+	int i;
+	u32 val;
+
+	if (!list_empty(&d40c->queue))
+		d40d_prev = d40_last_queued(d40c);
+	else if (!list_empty(&d40c->active))
+		d40d_prev = d40_first_active_get(d40c);
+
+	if (!d40d_prev)
+		return;
+
+	/* Here we try to join this job with previous jobs */
+	val = readl(d40c->base->virtbase + D40_DREG_PCBASE +
+		    d40c->phy_chan->num * D40_DREG_PCDELTA +
+		    D40_CHAN_REG_SSLNK);
+
+	/* Figure out which link we're currently transmitting */
+	for (i = 0; i < d40d_prev->lli_len; i++)
+		if (val == d40d_prev->lli_phy.src[i].reg_lnk)
+			break;
+
+	val = readl(d40c->base->virtbase + D40_DREG_PCBASE +
+		    d40c->phy_chan->num * D40_DREG_PCDELTA +
+		    D40_CHAN_REG_SSELT) >> D40_SREG_ELEM_LOG_ECNT_POS;
+
+	if (i == (d40d_prev->lli_len - 1) && val > 0) {
+		/* Change the current one */
+		writel(virt_to_phys(d40d->lli_phy.src),
+		       d40c->base->virtbase + D40_DREG_PCBASE +
+		       d40c->phy_chan->num * D40_DREG_PCDELTA +
+		       D40_CHAN_REG_SSLNK);
+		writel(virt_to_phys(d40d->lli_phy.dst),
+		       d40c->base->virtbase + D40_DREG_PCBASE +
+		       d40c->phy_chan->num * D40_DREG_PCDELTA +
+		       D40_CHAN_REG_SDLNK);
+
+		d40d->is_hw_linked = true;
+
+	} else if (i < d40d_prev->lli_len) {
+		(void) dma_unmap_single(d40c->base->dev,
+					virt_to_phys(d40d_prev->lli_phy.src),
+					d40d_prev->lli_pool.size,
+					DMA_TO_DEVICE);
+
+		/* Keep the settings */
+		val = d40d_prev->lli_phy.src[d40d_prev->lli_len - 1].reg_lnk &
+			~D40_SREG_LNK_PHYS_LNK_MASK;
+		d40d_prev->lli_phy.src[d40d_prev->lli_len - 1].reg_lnk =
+			val | virt_to_phys(d40d->lli_phy.src);
+
+		val = d40d_prev->lli_phy.dst[d40d_prev->lli_len - 1].reg_lnk &
+			~D40_SREG_LNK_PHYS_LNK_MASK;
+		d40d_prev->lli_phy.dst[d40d_prev->lli_len - 1].reg_lnk =
+			val | virt_to_phys(d40d->lli_phy.dst);
+
+		(void) dma_map_single(d40c->base->dev,
+				      d40d_prev->lli_phy.src,
+				      d40d_prev->lli_pool.size,
+				      DMA_TO_DEVICE);
+		d40d->is_hw_linked = true;
+	}
+}
+
 static dma_cookie_t d40_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct d40_chan *d40c = container_of(tx->chan,
@@ -737,14 +888,28 @@ static dma_cookie_t d40_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct d40_desc *d40d = container_of(tx, struct d40_desc, txd);
 	unsigned long flags;
 
+	(void) d40_pause(&d40c->chan);
+
 	spin_lock_irqsave(&d40c->lock, flags);
 
-	tx->cookie = d40_assign_cookie(d40c, d40d);
+	d40c->chan.cookie++;
+
+	if (d40c->chan.cookie < 0)
+		d40c->chan.cookie = 1;
+
+	d40d->txd.cookie = d40c->chan.cookie;
+
+	if (d40c->log_num == D40_PHY_CHAN)
+		d40_tx_submit_phy(d40c, d40d);
+	else
+		d40_tx_submit_log(d40c, d40d);
 
 	d40_desc_queue(d40c, d40d);
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
 
+	(void) d40_resume(&d40c->chan);
+
 	return tx->cookie;
 }
 
@@ -784,14 +949,20 @@ static struct d40_desc *d40_queue_start(struct d40_chan *d40c)
 		/* Add to active queue */
 		d40_desc_submit(d40c, d40d);
 
-		/* Initiate DMA job */
-		d40_desc_load(d40c, d40d);
+		/*
+		 * If this job is already linked in hw,
+		 * do not submit it.
+		 */
+		if (!d40d->is_hw_linked) {
+			/* Initiate DMA job */
+			d40_desc_load(d40c, d40d);
 
-		/* Start dma job */
-		err = d40_start(d40c);
+			/* Start dma job */
+			err = d40_start(d40c);
 
-		if (err)
-			return NULL;
+			if (err)
+				return NULL;
+		}
 	}
 
 	return d40d;
@@ -1341,30 +1512,6 @@ static int d40_free_dma(struct d40_chan *d40c)
 	return 0;
 }
 
-static int d40_pause(struct dma_chan *chan)
-{
-	struct d40_chan *d40c =
-		container_of(chan, struct d40_chan, chan);
-	int res;
-	unsigned long flags;
-
-	spin_lock_irqsave(&d40c->lock, flags);
-
-	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
-	if (res == 0) {
-		if (d40c->log_num != D40_PHY_CHAN) {
-			d40_config_set_event(d40c, false);
-			/* Resume the other logical channels if any */
-			if (d40_chan_has_events(d40c))
-				res = d40_channel_execute_command(d40c,
-								  D40_DMA_RUN);
-		}
-	}
-
-	spin_unlock_irqrestore(&d40c->lock, flags);
-	return res;
-}
-
 static bool d40_is_paused(struct d40_chan *d40c)
 {
 	bool is_paused = false;
@@ -1413,64 +1560,6 @@ _exit:
 }
 
 
-static bool d40_tx_is_linked(struct d40_chan *d40c)
-{
-	bool is_link;
-
-	if (d40c->log_num != D40_PHY_CHAN)
-		is_link = readl(&d40c->lcpa->lcsp3) &  D40_MEM_LCSP3_DLOS_MASK;
-	else
-		is_link = readl(d40c->base->virtbase + D40_DREG_PCBASE +
-				d40c->phy_chan->num * D40_DREG_PCDELTA +
-				D40_CHAN_REG_SDLNK) &
-			D40_SREG_LNK_PHYS_LNK_MASK;
-	return is_link;
-}
-
-static u32 d40_residue(struct d40_chan *d40c)
-{
-	u32 num_elt;
-
-	if (d40c->log_num != D40_PHY_CHAN)
-		num_elt = (readl(&d40c->lcpa->lcsp2) & D40_MEM_LCSP2_ECNT_MASK)
-			>> D40_MEM_LCSP2_ECNT_POS;
-	else
-		num_elt = (readl(d40c->base->virtbase + D40_DREG_PCBASE +
-				 d40c->phy_chan->num * D40_DREG_PCDELTA +
-				 D40_CHAN_REG_SDELT) &
-			   D40_SREG_ELEM_PHY_ECNT_MASK) >>
-			D40_SREG_ELEM_PHY_ECNT_POS;
-	return num_elt * (1 << d40c->dma_cfg.dst_info.data_width);
-}
-
-static int d40_resume(struct dma_chan *chan)
-{
-	struct d40_chan *d40c =
-		container_of(chan, struct d40_chan, chan);
-	int res = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&d40c->lock, flags);
-
-	if (d40c->base->rev == 0)
-		if (d40c->log_num != D40_PHY_CHAN) {
-			res = d40_channel_execute_command(d40c,
-							  D40_DMA_SUSPEND_REQ);
-			goto no_suspend;
-		}
-
-	/* If bytes left to transfer or linked tx resume job */
-	if (d40_residue(d40c) || d40_tx_is_linked(d40c)) {
-		if (d40c->log_num != D40_PHY_CHAN)
-			d40_config_set_event(d40c, true);
-		res = d40_channel_execute_command(d40c, D40_DMA_RUN);
-	}
-
-no_suspend:
-	spin_unlock_irqrestore(&d40c->lock, flags);
-	return res;
-}
-
 static u32 stedma40_residue(struct dma_chan *chan)
 {
 	struct d40_chan *d40c =
@@ -1607,7 +1696,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					sgl_len,
 					0,
 					d40d->lli_phy.src,
-					d40d->lli_phy.src_addr,
+					virt_to_phys(d40d->lli_phy.src),
 					d40c->src_def_cfg,
 					d40c->dma_cfg.src_info.data_width,
 					d40c->dma_cfg.src_info.psize);
@@ -1619,7 +1708,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					sgl_len,
 					0,
 					d40d->lli_phy.dst,
-					d40d->lli_phy.dst_addr,
+					virt_to_phys(d40d->lli_phy.dst),
 					d40c->dst_def_cfg,
 					d40c->dma_cfg.dst_info.data_width,
 					d40c->dma_cfg.dst_info.psize);
@@ -1679,6 +1768,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	 * use default configuration (memcpy)
 	 */
 	if (d40c->dma_cfg.channel_type == 0) {
+
 		err = d40_config_memcpy(d40c);
 		if (err) {
 			dev_err(&d40c->chan.dev->device,
@@ -1957,7 +2047,7 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 				sgl_len,
 				src_dev_addr,
 				d40d->lli_phy.src,
-				d40d->lli_phy.src_addr,
+				virt_to_phys(d40d->lli_phy.src),
 				d40c->src_def_cfg,
 				d40c->dma_cfg.src_info.data_width,
 				d40c->dma_cfg.src_info.psize);
@@ -1968,7 +2058,7 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 				sgl_len,
 				dst_dev_addr,
 				d40d->lli_phy.dst,
-				d40d->lli_phy.dst_addr,
+				virt_to_phys(d40d->lli_phy.dst),
 				d40c->dst_def_cfg,
 				d40c->dma_cfg.dst_info.data_width,
 				d40c->dma_cfg.dst_info.psize);
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 7a6acec..be35fad 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -202,8 +202,6 @@ struct d40_phy_lli {
  *
  * @src: Register settings for src channel.
  * @dst: Register settings for dst channel.
- * @dst_addr: Physical destination address.
- * @src_addr: Physical source address.
  *
  * All DMA transfers have a source and a destination.
  */
@@ -211,8 +209,6 @@ struct d40_phy_lli {
 struct d40_phy_lli_bidir {
 	struct d40_phy_lli	*src;
 	struct d40_phy_lli	*dst;
-	dma_addr_t		 dst_addr;
-	dma_addr_t		 src_addr;
 };
 
 
-- 
1.6.3.3

