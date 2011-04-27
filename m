Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1D0JhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:37:24 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:33193 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756588Ab1D0JhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:37:19 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <linux-arm-kernel@lists.infradead.org>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V3 2/7] dmaengine/dw_dmac: Replace spin_lock* with irqsave variants
Date: Wed, 27 Apr 2011 15:06:44 +0530
Message-ID: <50dc2f47f2c9f94fce78583568830a66af49307d.1303896567.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1303896566.git.viresh.kumar@st.com>
References: <cover.1303896566.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmaengine routines can be called from interrupt context and with interrupts
disabled.  Whereas spin_unlock_bh can't be called from such contexts. So this
patch converts all spin_*_bh routines to irqsave variants.

Also, spin_lock() used in tasklet is converted to irqsave variants, as tasklet
can be interrupted, and dma requests from such interruptions may also call
spin_lock.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |   82 +++++++++++++++++++++++++++++-------------------
 1 files changed, 49 insertions(+), 33 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index b8985af..b6dfc39 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -93,8 +93,9 @@ static struct dw_desc *dwc_desc_get(struct dw_dma_chan *dwc)
 	struct dw_desc *desc, *_desc;
 	struct dw_desc *ret = NULL;
 	unsigned int i = 0;
+	unsigned long flags;
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, flags);
 	list_for_each_entry_safe(desc, _desc, &dwc->free_list, desc_node) {
 		if (async_tx_test_ack(&desc->txd)) {
 			list_del(&desc->desc_node);
@@ -104,7 +105,7 @@ static struct dw_desc *dwc_desc_get(struct dw_dma_chan *dwc)
 		dev_dbg(chan2dev(&dwc->chan), "desc %p not ACKed\n", desc);
 		i++;
 	}
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	dev_vdbg(chan2dev(&dwc->chan), "scanned %u descriptors on freelist\n", i);
 
@@ -130,12 +131,14 @@ static void dwc_sync_desc_for_cpu(struct dw_dma_chan *dwc, struct dw_desc *desc)
  */
 static void dwc_desc_put(struct dw_dma_chan *dwc, struct dw_desc *desc)
 {
+	unsigned long flags;
+
 	if (desc) {
 		struct dw_desc *child;
 
 		dwc_sync_desc_for_cpu(dwc, desc);
 
-		spin_lock_bh(&dwc->lock);
+		spin_lock_irqsave(&dwc->lock, flags);
 		list_for_each_entry(child, &desc->tx_list, desc_node)
 			dev_vdbg(chan2dev(&dwc->chan),
 					"moving child desc %p to freelist\n",
@@ -143,7 +146,7 @@ static void dwc_desc_put(struct dw_dma_chan *dwc, struct dw_desc *desc)
 		list_splice_init(&desc->tx_list, &dwc->free_list);
 		dev_vdbg(chan2dev(&dwc->chan), "moving desc %p to freelist\n", desc);
 		list_add(&desc->desc_node, &dwc->free_list);
-		spin_unlock_bh(&dwc->lock);
+		spin_unlock_irqrestore(&dwc->lock, flags);
 	}
 }
 
@@ -407,6 +410,8 @@ EXPORT_SYMBOL(dw_dma_get_dst_addr);
 static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
 		u32 status_block, u32 status_err, u32 status_xfer)
 {
+	unsigned long flags;
+
 	if (status_block & dwc->mask) {
 		void (*callback)(void *param);
 		void *callback_param;
@@ -418,9 +423,9 @@ static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
 		callback = dwc->cdesc->period_callback;
 		callback_param = dwc->cdesc->period_callback_param;
 		if (callback) {
-			spin_unlock(&dwc->lock);
+			spin_unlock_irqrestore(&dwc->lock, flags);
 			callback(callback_param);
-			spin_lock(&dwc->lock);
+			spin_lock_irqsave(&dwc->lock, flags);
 		}
 	}
 
@@ -470,6 +475,7 @@ static void dw_dma_tasklet(unsigned long data)
 	u32 status_block;
 	u32 status_xfer;
 	u32 status_err;
+	unsigned long flags;
 	int i;
 
 	status_block = dma_readl(dw, RAW.BLOCK);
@@ -481,7 +487,7 @@ static void dw_dma_tasklet(unsigned long data)
 
 	for (i = 0; i < dw->dma.chancnt; i++) {
 		dwc = &dw->chan[i];
-		spin_lock(&dwc->lock);
+		spin_lock_irqsave(&dwc->lock, flags);
 		if (test_bit(DW_DMA_IS_CYCLIC, &dwc->flags))
 			dwc_handle_cyclic(dw, dwc, status_block, status_err,
 					status_xfer);
@@ -489,7 +495,7 @@ static void dw_dma_tasklet(unsigned long data)
 			dwc_handle_error(dw, dwc);
 		else if ((status_block | status_xfer) & (1 << i))
 			dwc_scan_descriptors(dw, dwc);
-		spin_unlock(&dwc->lock);
+		spin_unlock_irqrestore(&dwc->lock, flags);
 	}
 
 	/*
@@ -544,8 +550,9 @@ static dma_cookie_t dwc_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct dw_desc		*desc = txd_to_dw_desc(tx);
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(tx->chan);
 	dma_cookie_t		cookie;
+	unsigned long		flags;
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, flags);
 	cookie = dwc_assign_cookie(dwc, desc);
 
 	/*
@@ -565,7 +572,7 @@ static dma_cookie_t dwc_tx_submit(struct dma_async_tx_descriptor *tx)
 		list_add_tail(&desc->desc_node, &dwc->queue);
 	}
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return cookie;
 }
@@ -804,6 +811,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma		*dw = to_dw_dma(chan->device);
 	struct dw_desc		*desc, *_desc;
+	unsigned long		flags;
 	LIST_HEAD(list);
 
 	/* Only supports DMA_TERMINATE_ALL */
@@ -816,7 +824,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	 * channel. We still have to poll the channel enable bit due
 	 * to AHB/HSB limitations.
 	 */
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, flags);
 
 	channel_clear_bit(dw, CH_EN, dwc->mask);
 
@@ -831,7 +839,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
 		dwc_descriptor_complete(dwc, desc);
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return 0;
 }
@@ -845,15 +853,16 @@ dwc_tx_status(struct dma_chan *chan,
 	dma_cookie_t		last_used;
 	dma_cookie_t		last_complete;
 	int			ret;
+	unsigned long		flags;
 
 	last_complete = dwc->completed;
 	last_used = chan->cookie;
 
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 	if (ret != DMA_SUCCESS) {
-		spin_lock_bh(&dwc->lock);
+		spin_lock_irqsave(&dwc->lock, flags);
 		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
-		spin_unlock_bh(&dwc->lock);
+		spin_unlock_irqrestore(&dwc->lock, flags);
 
 		last_complete = dwc->completed;
 		last_used = chan->cookie;
@@ -869,11 +878,12 @@ dwc_tx_status(struct dma_chan *chan,
 static void dwc_issue_pending(struct dma_chan *chan)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	unsigned long		flags;
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, flags);
 	if (!list_empty(&dwc->queue))
 		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 }
 
 static int dwc_alloc_chan_resources(struct dma_chan *chan)
@@ -885,6 +895,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	int			i;
 	u32			cfghi;
 	u32			cfglo;
+	unsigned long		flags;
 
 	dev_vdbg(chan2dev(chan), "alloc_chan_resources\n");
 
@@ -922,16 +933,16 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	 * doesn't mean what you think it means), and status writeback.
 	 */
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, flags);
 	i = dwc->descs_allocated;
 	while (dwc->descs_allocated < NR_DESCS_PER_CHANNEL) {
-		spin_unlock_bh(&dwc->lock);
+		spin_unlock_irqrestore(&dwc->lock, flags);
 
 		desc = kzalloc(sizeof(struct dw_desc), GFP_KERNEL);
 		if (!desc) {
 			dev_info(chan2dev(chan),
 				"only allocated %d descriptors\n", i);
-			spin_lock_bh(&dwc->lock);
+			spin_lock_irqsave(&dwc->lock, flags);
 			break;
 		}
 
@@ -943,7 +954,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 				sizeof(desc->lli), DMA_TO_DEVICE);
 		dwc_desc_put(dwc, desc);
 
-		spin_lock_bh(&dwc->lock);
+		spin_lock_irqsave(&dwc->lock, flags);
 		i = ++dwc->descs_allocated;
 	}
 
@@ -952,7 +963,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	channel_set_bit(dw, MASK.BLOCK, dwc->mask);
 	channel_set_bit(dw, MASK.ERROR, dwc->mask);
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	dev_dbg(chan2dev(chan),
 		"alloc_chan_resources allocated %d descriptors\n", i);
@@ -965,6 +976,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma		*dw = to_dw_dma(chan->device);
 	struct dw_desc		*desc, *_desc;
+	unsigned long		flags;
 	LIST_HEAD(list);
 
 	dev_dbg(chan2dev(chan), "free_chan_resources (descs allocated=%u)\n",
@@ -975,7 +987,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	BUG_ON(!list_empty(&dwc->queue));
 	BUG_ON(dma_readl(to_dw_dma(chan->device), CH_EN) & dwc->mask);
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, flags);
 	list_splice_init(&dwc->free_list, &list);
 	dwc->descs_allocated = 0;
 
@@ -984,7 +996,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	channel_clear_bit(dw, MASK.BLOCK, dwc->mask);
 	channel_clear_bit(dw, MASK.ERROR, dwc->mask);
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	list_for_each_entry_safe(desc, _desc, &list, desc_node) {
 		dev_vdbg(chan2dev(chan), "  freeing descriptor %p\n", desc);
@@ -1009,13 +1021,14 @@ int dw_dma_cyclic_start(struct dma_chan *chan)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma		*dw = to_dw_dma(dwc->chan.device);
+	unsigned long		flags;
 
 	if (!test_bit(DW_DMA_IS_CYCLIC, &dwc->flags)) {
 		dev_err(chan2dev(&dwc->chan), "missing prep for cyclic DMA\n");
 		return -ENODEV;
 	}
 
-	spin_lock(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, flags);
 
 	/* assert channel is idle */
 	if (dma_readl(dw, CH_EN) & dwc->mask) {
@@ -1028,7 +1041,7 @@ int dw_dma_cyclic_start(struct dma_chan *chan)
 			channel_readl(dwc, LLP),
 			channel_readl(dwc, CTL_HI),
 			channel_readl(dwc, CTL_LO));
-		spin_unlock(&dwc->lock);
+		spin_unlock_irqrestore(&dwc->lock, flags);
 		return -EBUSY;
 	}
 
@@ -1043,7 +1056,7 @@ int dw_dma_cyclic_start(struct dma_chan *chan)
 
 	channel_set_bit(dw, CH_EN, dwc->mask);
 
-	spin_unlock(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return 0;
 }
@@ -1059,14 +1072,15 @@ void dw_dma_cyclic_stop(struct dma_chan *chan)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma		*dw = to_dw_dma(dwc->chan.device);
+	unsigned long		flags;
 
-	spin_lock(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, flags);
 
 	channel_clear_bit(dw, CH_EN, dwc->mask);
 	while (dma_readl(dw, CH_EN) & dwc->mask)
 		cpu_relax();
 
-	spin_unlock(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 }
 EXPORT_SYMBOL(dw_dma_cyclic_stop);
 
@@ -1095,17 +1109,18 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 	unsigned int			reg_width;
 	unsigned int			periods;
 	unsigned int			i;
+	unsigned long			flags;
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, flags);
 	if (!list_empty(&dwc->queue) || !list_empty(&dwc->active_list)) {
-		spin_unlock_bh(&dwc->lock);
+		spin_unlock_irqrestore(&dwc->lock, flags);
 		dev_dbg(chan2dev(&dwc->chan),
 				"queue and/or active list are not empty\n");
 		return ERR_PTR(-EBUSY);
 	}
 
 	was_cyclic = test_and_set_bit(DW_DMA_IS_CYCLIC, &dwc->flags);
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 	if (was_cyclic) {
 		dev_dbg(chan2dev(&dwc->chan),
 				"channel already prepared for cyclic DMA\n");
@@ -1219,13 +1234,14 @@ void dw_dma_cyclic_free(struct dma_chan *chan)
 	struct dw_dma		*dw = to_dw_dma(dwc->chan.device);
 	struct dw_cyclic_desc	*cdesc = dwc->cdesc;
 	int			i;
+	unsigned long		flags;
 
 	dev_dbg(chan2dev(&dwc->chan), "cyclic free\n");
 
 	if (!cdesc)
 		return;
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, flags);
 
 	channel_clear_bit(dw, CH_EN, dwc->mask);
 	while (dma_readl(dw, CH_EN) & dwc->mask)
@@ -1235,7 +1251,7 @@ void dw_dma_cyclic_free(struct dma_chan *chan)
 	dma_writel(dw, CLEAR.ERROR, dwc->mask);
 	dma_writel(dw, CLEAR.XFER, dwc->mask);
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	for (i = 0; i < cdesc->periods; i++)
 		dwc_desc_put(dwc, cdesc->desc[i]);
-- 
1.7.3.4

