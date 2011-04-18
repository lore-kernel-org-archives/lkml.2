Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab1DRKvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 06:51:16 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:35209 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626Ab1DRKur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 06:50:47 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-kernel@vger.kernel.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>, <viresh.linux@gmail.com>,
        <jamie@jamieiles.com>, <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 1/6] dmaengine/dw_dmac: Replace spin_lock_bh with irqsave variants
Date: Mon, 18 Apr 2011 16:19:59 +0530
Message-ID: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmaengine routines can be called from interrupt context and with interrupts
disabled.  Whereas spin_unlock_bh can't be called from such contexts. So this
patch converts all spin_*_bh routines to irqsave variants.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c      |   56 +++++++++++++++++++++++++------------------
 drivers/dma/dw_dmac_regs.h |    1 +
 2 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 1bd4803..357265f 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -90,11 +90,12 @@ static struct dw_desc *dwc_first_active(struct dw_dma_chan *dwc)
 
 static struct dw_desc *dwc_desc_get(struct dw_dma_chan *dwc)
 {
+	struct dw_dma *dw = to_dw_dma(dwc->chan.device);
 	struct dw_desc *desc, *_desc;
 	struct dw_desc *ret = NULL;
 	unsigned int i = 0;
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, dw->flags);
 	list_for_each_entry_safe(desc, _desc, &dwc->free_list, desc_node) {
 		if (async_tx_test_ack(&desc->txd)) {
 			list_del(&desc->desc_node);
@@ -104,7 +105,7 @@ static struct dw_desc *dwc_desc_get(struct dw_dma_chan *dwc)
 		dev_dbg(chan2dev(&dwc->chan), "desc %p not ACKed\n", desc);
 		i++;
 	}
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, dw->flags);
 
 	dev_vdbg(chan2dev(&dwc->chan), "scanned %u descriptors on freelist\n", i);
 
@@ -130,12 +131,14 @@ static void dwc_sync_desc_for_cpu(struct dw_dma_chan *dwc, struct dw_desc *desc)
  */
 static void dwc_desc_put(struct dw_dma_chan *dwc, struct dw_desc *desc)
 {
+	struct dw_dma *dw = to_dw_dma(dwc->chan.device);
+
 	if (desc) {
 		struct dw_desc *child;
 
 		dwc_sync_desc_for_cpu(dwc, desc);
 
-		spin_lock_bh(&dwc->lock);
+		spin_lock_irqsave(&dwc->lock, dw->flags);
 		list_for_each_entry(child, &desc->tx_list, desc_node)
 			dev_vdbg(chan2dev(&dwc->chan),
 					"moving child desc %p to freelist\n",
@@ -143,7 +146,7 @@ static void dwc_desc_put(struct dw_dma_chan *dwc, struct dw_desc *desc)
 		list_splice_init(&desc->tx_list, &dwc->free_list);
 		dev_vdbg(chan2dev(&dwc->chan), "moving desc %p to freelist\n", desc);
 		list_add(&desc->desc_node, &dwc->free_list);
-		spin_unlock_bh(&dwc->lock);
+		spin_unlock_irqrestore(&dwc->lock, dw->flags);
 	}
 }
 
@@ -199,6 +202,7 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
 {
 	dma_async_tx_callback		callback;
 	void				*param;
+	struct dw_dma			*dw = to_dw_dma(dwc->chan.device);
 	struct dma_async_tx_descriptor	*txd = &desc->txd;
 	struct dw_desc			*child;
 
@@ -543,9 +547,10 @@ static dma_cookie_t dwc_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct dw_desc		*desc = txd_to_dw_desc(tx);
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(tx->chan);
+	struct dw_dma		*dw = to_dw_dma(dwc->chan.device);
 	dma_cookie_t		cookie;
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, dw->flags);
 	cookie = dwc_assign_cookie(dwc, desc);
 
 	/*
@@ -565,7 +570,7 @@ static dma_cookie_t dwc_tx_submit(struct dma_async_tx_descriptor *tx)
 		list_add_tail(&desc->desc_node, &dwc->queue);
 	}
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, dw->flags);
 
 	return cookie;
 }
@@ -816,7 +821,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	 * channel. We still have to poll the channel enable bit due
 	 * to AHB/HSB limitations.
 	 */
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, dw->flags);
 
 	channel_clear_bit(dw, CH_EN, dwc->mask);
 
@@ -827,7 +832,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	list_splice_init(&dwc->queue, &list);
 	list_splice_init(&dwc->active_list, &list);
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, dw->flags);
 
 	/* Flush all pending and queued descriptors */
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
@@ -842,6 +847,7 @@ dwc_tx_status(struct dma_chan *chan,
 	      struct dma_tx_state *txstate)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_dma		*dw = to_dw_dma(dwc->chan.device);
 	dma_cookie_t		last_used;
 	dma_cookie_t		last_complete;
 	int			ret;
@@ -851,9 +857,9 @@ dwc_tx_status(struct dma_chan *chan,
 
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 	if (ret != DMA_SUCCESS) {
-		spin_lock_bh(&dwc->lock);
+		spin_lock_irqsave(&dwc->lock, dw->flags);
 		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
-		spin_unlock_bh(&dwc->lock);
+		spin_unlock_irqrestore(&dwc->lock, dw->flags);
 
 		last_complete = dwc->completed;
 		last_used = chan->cookie;
@@ -869,11 +875,12 @@ dwc_tx_status(struct dma_chan *chan,
 static void dwc_issue_pending(struct dma_chan *chan)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_dma		*dw = to_dw_dma(dwc->chan.device);
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, dw->flags);
 	if (!list_empty(&dwc->queue))
 		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, dw->flags);
 }
 
 static int dwc_alloc_chan_resources(struct dma_chan *chan)
@@ -922,16 +929,16 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	 * doesn't mean what you think it means), and status writeback.
 	 */
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, dw->flags);
 	i = dwc->descs_allocated;
 	while (dwc->descs_allocated < NR_DESCS_PER_CHANNEL) {
-		spin_unlock_bh(&dwc->lock);
+		spin_unlock_irqrestore(&dwc->lock, dw->flags);
 
 		desc = kzalloc(sizeof(struct dw_desc), GFP_KERNEL);
 		if (!desc) {
 			dev_info(chan2dev(chan),
 				"only allocated %d descriptors\n", i);
-			spin_lock_bh(&dwc->lock);
+			spin_lock_irqsave(&dwc->lock, dw->flags);
 			break;
 		}
 
@@ -943,7 +950,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 				sizeof(desc->lli), DMA_TO_DEVICE);
 		dwc_desc_put(dwc, desc);
 
-		spin_lock_bh(&dwc->lock);
+		spin_lock_irqsave(&dwc->lock, dw->flags);
 		i = ++dwc->descs_allocated;
 	}
 
@@ -952,7 +959,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	/* channel_set_bit(dw, MASK.BLOCK, dwc->mask); */
 	channel_set_bit(dw, MASK.ERROR, dwc->mask);
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, dw->flags);
 
 	dev_dbg(chan2dev(chan),
 		"alloc_chan_resources allocated %d descriptors\n", i);
@@ -975,7 +982,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	BUG_ON(!list_empty(&dwc->queue));
 	BUG_ON(dma_readl(to_dw_dma(chan->device), CH_EN) & dwc->mask);
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, dw->flags);
 	list_splice_init(&dwc->free_list, &list);
 	dwc->descs_allocated = 0;
 
@@ -984,7 +991,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	/* channel_clear_bit(dw, MASK.BLOCK, dwc->mask); */
 	channel_clear_bit(dw, MASK.ERROR, dwc->mask);
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, dw->flags);
 
 	list_for_each_entry_safe(desc, _desc, &list, desc_node) {
 		dev_vdbg(chan2dev(chan), "  freeing descriptor %p\n", desc);
@@ -1086,6 +1093,7 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 		enum dma_data_direction direction)
 {
 	struct dw_dma_chan		*dwc = to_dw_dma_chan(chan);
+	struct dw_dma			*dw = to_dw_dma(dwc->chan.device);
 	struct dw_cyclic_desc		*cdesc;
 	struct dw_cyclic_desc		*retval = NULL;
 	struct dw_desc			*desc;
@@ -1096,16 +1104,16 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 	unsigned int			periods;
 	unsigned int			i;
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, dw->flags);
 	if (!list_empty(&dwc->queue) || !list_empty(&dwc->active_list)) {
-		spin_unlock_bh(&dwc->lock);
+		spin_unlock_irqrestore(&dwc->lock, dw->flags);
 		dev_dbg(chan2dev(&dwc->chan),
 				"queue and/or active list are not empty\n");
 		return ERR_PTR(-EBUSY);
 	}
 
 	was_cyclic = test_and_set_bit(DW_DMA_IS_CYCLIC, &dwc->flags);
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, dw->flags);
 	if (was_cyclic) {
 		dev_dbg(chan2dev(&dwc->chan),
 				"channel already prepared for cyclic DMA\n");
@@ -1225,7 +1233,7 @@ void dw_dma_cyclic_free(struct dma_chan *chan)
 	if (!cdesc)
 		return;
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, dw->flags);
 
 	channel_clear_bit(dw, CH_EN, dwc->mask);
 	while (dma_readl(dw, CH_EN) & dwc->mask)
@@ -1235,7 +1243,7 @@ void dw_dma_cyclic_free(struct dma_chan *chan)
 	dma_writel(dw, CLEAR.ERROR, dwc->mask);
 	dma_writel(dw, CLEAR.XFER, dwc->mask);
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, dw->flags);
 
 	for (i = 0; i < cdesc->periods; i++)
 		dwc_desc_put(dwc, cdesc->desc[i]);
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 720f821..c89fd83 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -173,6 +173,7 @@ struct dw_dma {
 	void __iomem		*regs;
 	struct tasklet_struct	tasklet;
 	struct clk		*clk;
+	unsigned long		flags; /* for spin_lock_irqsave */
 
 	u8			all_chan_mask;
 
-- 
1.7.2.2

