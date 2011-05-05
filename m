Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1EEMBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:01:25 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:41289 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753337Ab1EEMBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:01:16 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <linux-arm-kernel@lists.infradead.org>,
        <viresh.linux@gmail.com>, <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V4 4/5] dmaengine/dw_dmac: Replace spin_lock* with irqsave variants and enable submission from callback
Date: Thu, 5 May 2011 17:30:32 +0530
Message-ID: <17ea40cb1127bb15a05e479aa3ba4b35b1fd49d7.1304596524.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1304596524.git.viresh.kumar@st.com>
References: <cover.1304596524.git.viresh.kumar@st.com>
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

Now, submission from callbacks are permitted as per dmaengine framework. So we
shouldn't hold any locks while calling callbacks. As locks were taken by parent
routines, so releasing them before calling callbacks doesn't look clean enough.
So, locks are taken inside all routine now, whereever they are required. And
dwc_descriptor_complete is always called without taking locks.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |  116 ++++++++++++++++++++++++++++++++----------------
 1 files changed, 77 insertions(+), 39 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 1662452..cc39090 100644
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
 
@@ -202,9 +205,11 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
 	void				*param = NULL;
 	struct dma_async_tx_descriptor	*txd = &desc->txd;
 	struct dw_desc			*child;
+	unsigned long			flags;
 
 	dev_vdbg(chan2dev(&dwc->chan), "descriptor %u complete\n", txd->cookie);
 
+	spin_lock_irqsave(&dwc->lock, flags);
 	dwc->completed = txd->cookie;
 	if (callback_required) {
 		callback = txd->callback;
@@ -241,6 +246,8 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
 		}
 	}
 
+	spin_unlock_irqrestore(&dwc->lock, flags);
+
 	if (callback_required) {
 		if (callback)
 			callback(param);
@@ -251,7 +258,9 @@ static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
 {
 	struct dw_desc *desc, *_desc;
 	LIST_HEAD(list);
+	unsigned long flags;
 
+	spin_lock_irqsave(&dwc->lock, flags);
 	if (dma_readl(dw, CH_EN) & dwc->mask) {
 		dev_err(chan2dev(&dwc->chan),
 			"BUG: XFER bit set, but channel not idle!\n");
@@ -272,6 +281,8 @@ static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		dwc_dostart(dwc, dwc_first_active(dwc));
 	}
 
+	spin_unlock_irqrestore(&dwc->lock, flags);
+
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
 		dwc_descriptor_complete(dwc, desc, true);
 }
@@ -282,7 +293,9 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	struct dw_desc *desc, *_desc;
 	struct dw_desc *child;
 	u32 status_xfer;
+	unsigned long flags;
 
+	spin_lock_irqsave(&dwc->lock, flags);
 	/*
 	 * Clear block interrupt flag before scanning so that we don't
 	 * miss any, and read LLP before RAW_XFER to ensure it is
@@ -295,35 +308,47 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	if (status_xfer & dwc->mask) {
 		/* Everything we've submitted is done */
 		dma_writel(dw, CLEAR.XFER, dwc->mask);
+		spin_unlock_irqrestore(&dwc->lock, flags);
+
 		dwc_complete_all(dw, dwc);
 		return;
 	}
 
-	if (list_empty(&dwc->active_list))
+	if (list_empty(&dwc->active_list)) {
+		spin_unlock_irqrestore(&dwc->lock, flags);
 		return;
+	}
 
 	dev_vdbg(chan2dev(&dwc->chan), "scan_descriptors: llp=0x%x\n", llp);
 
 	list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
 		/* check first descriptors addr */
-		if (desc->txd.phys == llp)
+		if (desc->txd.phys == llp) {
+			spin_unlock_irqrestore(&dwc->lock, flags);
 			return;
+		}
 
 		/* check first descriptors llp */
-		if (desc->lli.llp == llp)
+		if (desc->lli.llp == llp) {
 			/* This one is currently in progress */
+			spin_unlock_irqrestore(&dwc->lock, flags);
 			return;
+		}
 
 		list_for_each_entry(child, &desc->tx_list, desc_node)
-			if (child->lli.llp == llp)
+			if (child->lli.llp == llp) {
 				/* Currently in progress */
+				spin_unlock_irqrestore(&dwc->lock, flags);
 				return;
+			}
 
 		/*
 		 * No descriptors so far seem to be in progress, i.e.
 		 * this one must be done.
 		 */
+		spin_unlock_irqrestore(&dwc->lock, flags);
 		dwc_descriptor_complete(dwc, desc, true);
+		spin_lock_irqsave(&dwc->lock, flags);
 	}
 
 	dev_dbg(chan2dev(&dwc->chan),
@@ -338,6 +363,7 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		list_move(dwc->queue.next, &dwc->active_list);
 		dwc_dostart(dwc, dwc_first_active(dwc));
 	}
+	spin_unlock_irqrestore(&dwc->lock, flags);
 }
 
 static void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_lli *lli)
@@ -352,9 +378,12 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
 {
 	struct dw_desc *bad_desc;
 	struct dw_desc *child;
+	unsigned long flags;
 
 	dwc_scan_descriptors(dw, dwc);
 
+	spin_lock_irqsave(&dwc->lock, flags);
+
 	/*
 	 * The descriptor currently at the head of the active list is
 	 * borked. Since we don't have any way to report errors, we'll
@@ -384,6 +413,8 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	list_for_each_entry(child, &bad_desc->tx_list, desc_node)
 		dwc_dump_lli(dwc, &child->lli);
 
+	spin_unlock_irqrestore(&dwc->lock, flags);
+
 	/* Pretend the descriptor completed successfully */
 	dwc_descriptor_complete(dwc, bad_desc, true);
 }
@@ -408,6 +439,8 @@ EXPORT_SYMBOL(dw_dma_get_dst_addr);
 static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
 		u32 status_block, u32 status_err, u32 status_xfer)
 {
+	unsigned long flags;
+
 	if (status_block & dwc->mask) {
 		void (*callback)(void *param);
 		void *callback_param;
@@ -418,11 +451,9 @@ static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
 
 		callback = dwc->cdesc->period_callback;
 		callback_param = dwc->cdesc->period_callback_param;
-		if (callback) {
-			spin_unlock(&dwc->lock);
+
+		if (callback)
 			callback(callback_param);
-			spin_lock(&dwc->lock);
-		}
 	}
 
 	/*
@@ -436,6 +467,9 @@ static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
 		dev_err(chan2dev(&dwc->chan), "cyclic DMA unexpected %s "
 				"interrupt, stopping DMA transfer\n",
 				status_xfer ? "xfer" : "error");
+
+		spin_lock_irqsave(&dwc->lock, flags);
+
 		dev_err(chan2dev(&dwc->chan),
 			"  SAR: 0x%x DAR: 0x%x LLP: 0x%x CTL: 0x%x:%08x\n",
 			channel_readl(dwc, SAR),
@@ -459,6 +493,8 @@ static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
 
 		for (i = 0; i < dwc->cdesc->periods; i++)
 			dwc_dump_lli(dwc, &dwc->cdesc->desc[i]->lli);
+
+		spin_unlock_irqrestore(&dwc->lock, flags);
 	}
 }
 
@@ -482,7 +518,6 @@ static void dw_dma_tasklet(unsigned long data)
 
 	for (i = 0; i < dw->dma.chancnt; i++) {
 		dwc = &dw->chan[i];
-		spin_lock(&dwc->lock);
 		if (test_bit(DW_DMA_IS_CYCLIC, &dwc->flags))
 			dwc_handle_cyclic(dw, dwc, status_block, status_err,
 					status_xfer);
@@ -490,7 +525,6 @@ static void dw_dma_tasklet(unsigned long data)
 			dwc_handle_error(dw, dwc);
 		else if ((status_block | status_xfer) & (1 << i))
 			dwc_scan_descriptors(dw, dwc);
-		spin_unlock(&dwc->lock);
 	}
 
 	/*
@@ -545,8 +579,9 @@ static dma_cookie_t dwc_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct dw_desc		*desc = txd_to_dw_desc(tx);
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(tx->chan);
 	dma_cookie_t		cookie;
+	unsigned long		flags;
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, flags);
 	cookie = dwc_assign_cookie(dwc, desc);
 
 	/*
@@ -566,7 +601,7 @@ static dma_cookie_t dwc_tx_submit(struct dma_async_tx_descriptor *tx)
 		list_add_tail(&desc->desc_node, &dwc->queue);
 	}
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return cookie;
 }
@@ -828,6 +863,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma		*dw = to_dw_dma(chan->device);
 	struct dw_desc		*desc, *_desc;
+	unsigned long		flags;
 	LIST_HEAD(list);
 
 	/* Only supports DMA_TERMINATE_ALL */
@@ -840,7 +876,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	 * channel. We still have to poll the channel enable bit due
 	 * to AHB/HSB limitations.
 	 */
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, flags);
 
 	channel_clear_bit(dw, CH_EN, dwc->mask);
 
@@ -851,7 +887,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	list_splice_init(&dwc->queue, &list);
 	list_splice_init(&dwc->active_list, &list);
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	/* Flush all pending and queued descriptors */
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
@@ -875,9 +911,7 @@ dwc_tx_status(struct dma_chan *chan,
 
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 	if (ret != DMA_SUCCESS) {
-		spin_lock_bh(&dwc->lock);
 		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
-		spin_unlock_bh(&dwc->lock);
 
 		last_complete = dwc->completed;
 		last_used = chan->cookie;
@@ -898,10 +932,8 @@ static void dwc_issue_pending(struct dma_chan *chan)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 
-	spin_lock_bh(&dwc->lock);
 	if (!list_empty(&dwc->queue))
 		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
-	spin_unlock_bh(&dwc->lock);
 }
 
 static int dwc_alloc_chan_resources(struct dma_chan *chan)
@@ -913,6 +945,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	int			i;
 	u32			cfghi;
 	u32			cfglo;
+	unsigned long		flags;
 
 	dev_vdbg(chan2dev(chan), "alloc_chan_resources\n");
 
@@ -950,16 +983,16 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
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
 
@@ -971,7 +1004,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 				sizeof(desc->lli), DMA_TO_DEVICE);
 		dwc_desc_put(dwc, desc);
 
-		spin_lock_bh(&dwc->lock);
+		spin_lock_irqsave(&dwc->lock, flags);
 		i = ++dwc->descs_allocated;
 	}
 
@@ -980,7 +1013,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	/* channel_set_bit(dw, MASK.BLOCK, dwc->mask); */
 	channel_set_bit(dw, MASK.ERROR, dwc->mask);
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	dev_dbg(chan2dev(chan),
 		"alloc_chan_resources allocated %d descriptors\n", i);
@@ -993,6 +1026,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma		*dw = to_dw_dma(chan->device);
 	struct dw_desc		*desc, *_desc;
+	unsigned long		flags;
 	LIST_HEAD(list);
 
 	dev_dbg(chan2dev(chan), "free_chan_resources (descs allocated=%u)\n",
@@ -1003,7 +1037,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	BUG_ON(!list_empty(&dwc->queue));
 	BUG_ON(dma_readl(to_dw_dma(chan->device), CH_EN) & dwc->mask);
 
-	spin_lock_bh(&dwc->lock);
+	spin_lock_irqsave(&dwc->lock, flags);
 	list_splice_init(&dwc->free_list, &list);
 	dwc->descs_allocated = 0;
 
@@ -1012,7 +1046,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	/* channel_clear_bit(dw, MASK.BLOCK, dwc->mask); */
 	channel_clear_bit(dw, MASK.ERROR, dwc->mask);
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	list_for_each_entry_safe(desc, _desc, &list, desc_node) {
 		dev_vdbg(chan2dev(chan), "  freeing descriptor %p\n", desc);
@@ -1037,13 +1071,14 @@ int dw_dma_cyclic_start(struct dma_chan *chan)
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
@@ -1056,7 +1091,7 @@ int dw_dma_cyclic_start(struct dma_chan *chan)
 			channel_readl(dwc, LLP),
 			channel_readl(dwc, CTL_HI),
 			channel_readl(dwc, CTL_LO));
-		spin_unlock(&dwc->lock);
+		spin_unlock_irqrestore(&dwc->lock, flags);
 		return -EBUSY;
 	}
 
@@ -1071,7 +1106,7 @@ int dw_dma_cyclic_start(struct dma_chan *chan)
 
 	channel_set_bit(dw, CH_EN, dwc->mask);
 
-	spin_unlock(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return 0;
 }
@@ -1087,14 +1122,15 @@ void dw_dma_cyclic_stop(struct dma_chan *chan)
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
 
@@ -1123,17 +1159,18 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
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
@@ -1247,13 +1284,14 @@ void dw_dma_cyclic_free(struct dma_chan *chan)
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
@@ -1263,7 +1301,7 @@ void dw_dma_cyclic_free(struct dma_chan *chan)
 	dma_writel(dw, CLEAR.ERROR, dwc->mask);
 	dma_writel(dw, CLEAR.XFER, dwc->mask);
 
-	spin_unlock_bh(&dwc->lock);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	for (i = 0; i < cdesc->periods; i++)
 		dwc_desc_put(dwc, cdesc->desc[i]);
-- 
1.7.2.2

