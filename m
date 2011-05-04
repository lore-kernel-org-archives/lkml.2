Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab1EDRHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:07:15 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:56406 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1EDRHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:07:13 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/2] dmaengine: at_hdmac: implement pause and resume in atc_control
Date: Wed,  4 May 2011 20:14:13 +0200
Message-Id: <47964dd140b0d36db6979f6cd945212ae566e60a.1304532833.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <f4341d4672a23a958398b75cb4305e0e680f2e32.1304532833.git.nicolas.ferre@atmel.com>
References: <f4341d4672a23a958398b75cb4305e0e680f2e32.1304532833.git.nicolas.ferre@atmel.com>
In-Reply-To: <f4341d4672a23a958398b75cb4305e0e680f2e32.1304532833.git.nicolas.ferre@atmel.com>
References: <f4341d4672a23a958398b75cb4305e0e680f2e32.1304532833.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pause and resume controls are useful for audio devices. This also returns
correct status from atc_tx_status() in case chan is paused.

Idea from dw_dmac patch by Linus Walleij.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c      |   85 +++++++++++++++++++++++++++++--------------
 drivers/dma/at_hdmac_regs.h |    1 +
 2 files changed, 59 insertions(+), 27 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index ba0b5ec..99ae628 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -508,7 +508,8 @@ static irqreturn_t at_dma_interrupt(int irq, void *dev_id)
 			if (pending & (AT_DMA_BTC(i) | AT_DMA_ERR(i))) {
 				if (pending & AT_DMA_ERR(i)) {
 					/* Disable channel on AHB error */
-					dma_writel(atdma, CHDR, atchan->mask);
+					dma_writel(atdma, CHDR,
+						AT_DMA_RES(i) | atchan->mask);
 					/* Give information to tasklet */
 					set_bit(ATC_IS_ERROR, &atchan->status);
 				}
@@ -952,39 +953,66 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma		*atdma = to_at_dma(chan->device);
-	struct at_desc		*desc, *_desc;
+	int			chan_id = atchan->chan_common.chan_id;
+
 	LIST_HEAD(list);
 
-	/* Only supports DMA_TERMINATE_ALL */
-	if (cmd != DMA_TERMINATE_ALL)
-		return -ENXIO;
+	dev_vdbg(chan2dev(chan), "atc_control (%d)\n", cmd);
 
-	/*
-	 * This is only called when something went wrong elsewhere, so
-	 * we don't really care about the data. Just disable the
-	 * channel. We still have to poll the channel enable bit due
-	 * to AHB/HSB limitations.
-	 */
-	spin_lock_bh(&atchan->lock);
+	if (cmd == DMA_PAUSE) {
+		spin_lock_bh(&atchan->lock);
 
-	dma_writel(atdma, CHDR, atchan->mask);
+		dma_writel(atdma, CHER, AT_DMA_SUSP(chan_id));
 
-	/* confirm that this channel is disabled */
-	while (dma_readl(atdma, CHSR) & atchan->mask)
-		cpu_relax();
+		while (!(dma_readl(atdma, CHSR) & AT_DMA_EMPT(chan_id)))
+			cpu_relax();
 
-	/* active_list entries will end up before queued entries */
-	list_splice_init(&atchan->queue, &list);
-	list_splice_init(&atchan->active_list, &list);
+		set_bit(ATC_IS_PAUSED, &atchan->status);
 
-	/* Flush all pending and queued descriptors */
-	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		atc_chain_complete(atchan, desc);
+		spin_unlock_bh(&atchan->lock);
+	} else if (cmd == DMA_RESUME) {
+		if (!test_bit(ATC_IS_PAUSED, &atchan->status))
+			return 0;
 
-	/* if channel dedicated to cyclic operations, free it */
-	clear_bit(ATC_IS_CYCLIC, &atchan->status);
+		spin_lock_bh(&atchan->lock);
 
-	spin_unlock_bh(&atchan->lock);
+		dma_writel(atdma, CHDR, AT_DMA_RES(chan_id));
+		clear_bit(ATC_IS_PAUSED, &atchan->status);
+
+		spin_unlock_bh(&atchan->lock);
+	} else if (cmd == DMA_TERMINATE_ALL) {
+		struct at_desc	*desc, *_desc;
+		/*
+		 * This is only called when something went wrong elsewhere, so
+		 * we don't really care about the data. Just disable the
+		 * channel. We still have to poll the channel enable bit due
+		 * to AHB/HSB limitations.
+		 */
+		spin_lock_bh(&atchan->lock);
+
+		/* disabling channel: must also remove suspend state */
+		dma_writel(atdma, CHDR, AT_DMA_RES(chan_id) | atchan->mask);
+
+		/* confirm that this channel is disabled */
+		while (dma_readl(atdma, CHSR) & atchan->mask)
+			cpu_relax();
+
+		/* active_list entries will end up before queued entries */
+		list_splice_init(&atchan->queue, &list);
+		list_splice_init(&atchan->active_list, &list);
+
+		/* Flush all pending and queued descriptors */
+		list_for_each_entry_safe(desc, _desc, &list, desc_node)
+			atc_chain_complete(atchan, desc);
+
+		clear_bit(ATC_IS_PAUSED, &atchan->status);
+		/* if channel dedicated to cyclic operations, free it */
+		clear_bit(ATC_IS_CYCLIC, &atchan->status);
+
+		spin_unlock_bh(&atchan->lock);
+	} else {
+		return -ENXIO;
+	}
 
 	return 0;
 }
@@ -1032,8 +1060,11 @@ atc_tx_status(struct dma_chan *chan,
 	else
 		dma_set_tx_state(txstate, last_complete, last_used, 0);
 
-	dev_vdbg(chan2dev(chan), "tx_status: %d (d%d, u%d)\n",
-		 cookie, last_complete ? last_complete : 0,
+	if (test_bit(ATC_IS_PAUSED, &atchan->status))
+		ret = DMA_PAUSED;
+
+	dev_vdbg(chan2dev(chan), "tx_status %d: cookie = %d (d%d, u%d)\n",
+		 ret, cookie, last_complete ? last_complete : 0,
 		 last_used ? last_used : 0);
 
 	return ret;
diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index ae3056d..087dbf1 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -191,6 +191,7 @@ txd_to_at_desc(struct dma_async_tx_descriptor *txd)
  */
 enum atc_status {
 	ATC_IS_ERROR = 0,
+	ATC_IS_PAUSED = 1,
 	ATC_IS_CYCLIC = 24,
 };
 
-- 
1.7.3

