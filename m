Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1F1KPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:15:49 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:19891 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478Ab1F1KLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:11:03 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 1/3] dmaengine: at_hdmac: replace spin_lock* with irqsave variants
Date: Tue, 28 Jun 2011 13:17:55 +0200
Message-Id: <fb4657207f9eb34784c10333e11c48b5638542ed.1309259835.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmaengine routines can be called from interrupt context and with
interrupts disabled. Whereas spin_unlock_bh can't be called from
such contexts. So this patch converts all spin_lock* routines
to irqsave variants.

Also, spin_lock() used in tasklet is converted to irqsave variants,
as tasklet can be interrupted, and dma requests from such interruptions
may also call spin_lock.

Idea from dw_dmac patch by Viresh Kumar.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/dma/at_hdmac.c |   52 +++++++++++++++++++++++++++--------------------
 1 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 6a483ea..fd87b96 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -107,10 +107,11 @@ static struct at_desc *atc_desc_get(struct at_dma_chan *atchan)
 {
 	struct at_desc *desc, *_desc;
 	struct at_desc *ret = NULL;
+	unsigned long flags;
 	unsigned int i = 0;
 	LIST_HEAD(tmp_list);
 
-	spin_lock_bh(&atchan->lock);
+	spin_lock_irqsave(&atchan->lock, flags);
 	list_for_each_entry_safe(desc, _desc, &atchan->free_list, desc_node) {
 		i++;
 		if (async_tx_test_ack(&desc->txd)) {
@@ -121,7 +122,7 @@ static struct at_desc *atc_desc_get(struct at_dma_chan *atchan)
 		dev_dbg(chan2dev(&atchan->chan_common),
 				"desc %p not ACKed\n", desc);
 	}
-	spin_unlock_bh(&atchan->lock);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 	dev_vdbg(chan2dev(&atchan->chan_common),
 		"scanned %u descriptors on freelist\n", i);
 
@@ -129,9 +130,9 @@ static struct at_desc *atc_desc_get(struct at_dma_chan *atchan)
 	if (!ret) {
 		ret = atc_alloc_descriptor(&atchan->chan_common, GFP_ATOMIC);
 		if (ret) {
-			spin_lock_bh(&atchan->lock);
+			spin_lock_irqsave(&atchan->lock, flags);
 			atchan->descs_allocated++;
-			spin_unlock_bh(&atchan->lock);
+			spin_unlock_irqrestore(&atchan->lock, flags);
 		} else {
 			dev_err(chan2dev(&atchan->chan_common),
 					"not enough descriptors available\n");
@@ -150,8 +151,9 @@ static void atc_desc_put(struct at_dma_chan *atchan, struct at_desc *desc)
 {
 	if (desc) {
 		struct at_desc *child;
+		unsigned long flags;
 
-		spin_lock_bh(&atchan->lock);
+		spin_lock_irqsave(&atchan->lock, flags);
 		list_for_each_entry(child, &desc->tx_list, desc_node)
 			dev_vdbg(chan2dev(&atchan->chan_common),
 					"moving child desc %p to freelist\n",
@@ -160,7 +162,7 @@ static void atc_desc_put(struct at_dma_chan *atchan, struct at_desc *desc)
 		dev_vdbg(chan2dev(&atchan->chan_common),
 			 "moving desc %p to freelist\n", desc);
 		list_add(&desc->desc_node, &atchan->free_list);
-		spin_unlock_bh(&atchan->lock);
+		spin_unlock_irqrestore(&atchan->lock, flags);
 	}
 }
 
@@ -471,8 +473,9 @@ static void atc_handle_cyclic(struct at_dma_chan *atchan)
 static void atc_tasklet(unsigned long data)
 {
 	struct at_dma_chan *atchan = (struct at_dma_chan *)data;
+	unsigned long flags;
 
-	spin_lock(&atchan->lock);
+	spin_lock_irqsave(&atchan->lock, flags);
 	if (test_and_clear_bit(ATC_IS_ERROR, &atchan->status))
 		atc_handle_error(atchan);
 	else if (test_bit(ATC_IS_CYCLIC, &atchan->status))
@@ -480,7 +483,7 @@ static void atc_tasklet(unsigned long data)
 	else
 		atc_advance_work(atchan);
 
-	spin_unlock(&atchan->lock);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 }
 
 static irqreturn_t at_dma_interrupt(int irq, void *dev_id)
@@ -539,8 +542,9 @@ static dma_cookie_t atc_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct at_desc		*desc = txd_to_at_desc(tx);
 	struct at_dma_chan	*atchan = to_at_dma_chan(tx->chan);
 	dma_cookie_t		cookie;
+	unsigned long		flags;
 
-	spin_lock_bh(&atchan->lock);
+	spin_lock_irqsave(&atchan->lock, flags);
 	cookie = atc_assign_cookie(atchan, desc);
 
 	if (list_empty(&atchan->active_list)) {
@@ -554,7 +558,7 @@ static dma_cookie_t atc_tx_submit(struct dma_async_tx_descriptor *tx)
 		list_add_tail(&desc->desc_node, &atchan->queue);
 	}
 
-	spin_unlock_bh(&atchan->lock);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	return cookie;
 }
@@ -927,28 +931,29 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma		*atdma = to_at_dma(chan->device);
 	int			chan_id = atchan->chan_common.chan_id;
+	unsigned long		flags;
 
 	LIST_HEAD(list);
 
 	dev_vdbg(chan2dev(chan), "atc_control (%d)\n", cmd);
 
 	if (cmd == DMA_PAUSE) {
-		spin_lock_bh(&atchan->lock);
+		spin_lock_irqsave(&atchan->lock, flags);
 
 		dma_writel(atdma, CHER, AT_DMA_SUSP(chan_id));
 		set_bit(ATC_IS_PAUSED, &atchan->status);
 
-		spin_unlock_bh(&atchan->lock);
+		spin_unlock_irqrestore(&atchan->lock, flags);
 	} else if (cmd == DMA_RESUME) {
 		if (!test_bit(ATC_IS_PAUSED, &atchan->status))
 			return 0;
 
-		spin_lock_bh(&atchan->lock);
+		spin_lock_irqsave(&atchan->lock, flags);
 
 		dma_writel(atdma, CHDR, AT_DMA_RES(chan_id));
 		clear_bit(ATC_IS_PAUSED, &atchan->status);
 
-		spin_unlock_bh(&atchan->lock);
+		spin_unlock_irqrestore(&atchan->lock, flags);
 	} else if (cmd == DMA_TERMINATE_ALL) {
 		struct at_desc	*desc, *_desc;
 		/*
@@ -957,7 +962,7 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		 * channel. We still have to poll the channel enable bit due
 		 * to AHB/HSB limitations.
 		 */
-		spin_lock_bh(&atchan->lock);
+		spin_lock_irqsave(&atchan->lock, flags);
 
 		/* disabling channel: must also remove suspend state */
 		dma_writel(atdma, CHDR, AT_DMA_RES(chan_id) | atchan->mask);
@@ -978,7 +983,7 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		/* if channel dedicated to cyclic operations, free it */
 		clear_bit(ATC_IS_CYCLIC, &atchan->status);
 
-		spin_unlock_bh(&atchan->lock);
+		spin_unlock_irqrestore(&atchan->lock, flags);
 	} else {
 		return -ENXIO;
 	}
@@ -1004,9 +1009,10 @@ atc_tx_status(struct dma_chan *chan,
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	dma_cookie_t		last_used;
 	dma_cookie_t		last_complete;
+	unsigned long		flags;
 	enum dma_status		ret;
 
-	spin_lock_bh(&atchan->lock);
+	spin_lock_irqsave(&atchan->lock, flags);
 
 	last_complete = atchan->completed_cookie;
 	last_used = chan->cookie;
@@ -1021,7 +1027,7 @@ atc_tx_status(struct dma_chan *chan,
 		ret = dma_async_is_complete(cookie, last_complete, last_used);
 	}
 
-	spin_unlock_bh(&atchan->lock);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	if (ret != DMA_SUCCESS)
 		dma_set_tx_state(txstate, last_complete, last_used,
@@ -1046,6 +1052,7 @@ atc_tx_status(struct dma_chan *chan,
 static void atc_issue_pending(struct dma_chan *chan)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
+	unsigned long		flags;
 
 	dev_vdbg(chan2dev(chan), "issue_pending\n");
 
@@ -1053,11 +1060,11 @@ static void atc_issue_pending(struct dma_chan *chan)
 	if (test_bit(ATC_IS_CYCLIC, &atchan->status))
 		return;
 
-	spin_lock_bh(&atchan->lock);
+	spin_lock_irqsave(&atchan->lock, flags);
 	if (!atc_chan_is_enabled(atchan)) {
 		atc_advance_work(atchan);
 	}
-	spin_unlock_bh(&atchan->lock);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 }
 
 /**
@@ -1073,6 +1080,7 @@ static int atc_alloc_chan_resources(struct dma_chan *chan)
 	struct at_dma		*atdma = to_at_dma(chan->device);
 	struct at_desc		*desc;
 	struct at_dma_slave	*atslave;
+	unsigned long		flags;
 	int			i;
 	u32			cfg;
 	LIST_HEAD(tmp_list);
@@ -1116,11 +1124,11 @@ static int atc_alloc_chan_resources(struct dma_chan *chan)
 		list_add_tail(&desc->desc_node, &tmp_list);
 	}
 
-	spin_lock_bh(&atchan->lock);
+	spin_lock_irqsave(&atchan->lock, flags);
 	atchan->descs_allocated = i;
 	list_splice(&tmp_list, &atchan->free_list);
 	atchan->completed_cookie = chan->cookie = 1;
-	spin_unlock_bh(&atchan->lock);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	/* channel parameters */
 	channel_writel(atchan, CFG, cfg);
-- 
1.7.3

