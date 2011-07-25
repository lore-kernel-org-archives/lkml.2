Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab1GYVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:09:29 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:43810 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1GYVJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:09:28 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] dmaengine: at_hdmac: add wrappers for testing channel state
Date: Mon, 25 Jul 2011 23:09:23 +0200
Message-Id: <a04c691d57da727d0b68affb424e3fec44cfd421.1311627477.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310005222.20150.23.camel@psiaudioba-mobl1>
References: <1310005222.20150.23.camel@psiaudioba-mobl1>
In-Reply-To: <3c302a7166c2aa6ae4b6d7b7cdfe21e640b73603.1311627477.git.nicolas.ferre@atmel.com>
References: <3c302a7166c2aa6ae4b6d7b7cdfe21e640b73603.1311627477.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyclic property and paused state are encoded as bits in the channel status
bitfield. Tests of those bits are wrapped in convenient helper functions.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c      |   19 +++++++++----------
 drivers/dma/at_hdmac_regs.h |   17 +++++++++++++++++
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 99bd2c18..26a1196 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -301,7 +301,7 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 
 	/* for cyclic transfers,
 	 * no need to replay callback function while stopping */
-	if (!test_bit(ATC_IS_CYCLIC, &atchan->status)) {
+	if (!atc_chan_is_cyclic(atchan)) {
 		dma_async_tx_callback	callback = txd->callback;
 		void			*param = txd->callback_param;
 
@@ -478,7 +478,7 @@ static void atc_tasklet(unsigned long data)
 	spin_lock_irqsave(&atchan->lock, flags);
 	if (test_and_clear_bit(ATC_IS_ERROR, &atchan->status))
 		atc_handle_error(atchan);
-	else if (test_bit(ATC_IS_CYCLIC, &atchan->status))
+	else if (atc_chan_is_cyclic(atchan))
 		atc_handle_cyclic(atchan);
 	else
 		atc_advance_work(atchan);
@@ -945,7 +945,7 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 		spin_unlock_irqrestore(&atchan->lock, flags);
 	} else if (cmd == DMA_RESUME) {
-		if (!test_bit(ATC_IS_PAUSED, &atchan->status))
+		if (!atc_chan_is_paused(atchan))
 			return 0;
 
 		spin_lock_irqsave(&atchan->lock, flags);
@@ -1035,7 +1035,7 @@ atc_tx_status(struct dma_chan *chan,
 	else
 		dma_set_tx_state(txstate, last_complete, last_used, 0);
 
-	if (test_bit(ATC_IS_PAUSED, &atchan->status))
+	if (atc_chan_is_paused(atchan))
 		ret = DMA_PAUSED;
 
 	dev_vdbg(chan2dev(chan), "tx_status %d: cookie = %d (d%d, u%d)\n",
@@ -1057,7 +1057,7 @@ static void atc_issue_pending(struct dma_chan *chan)
 	dev_vdbg(chan2dev(chan), "issue_pending\n");
 
 	/* Not needed for cyclic transfers */
-	if (test_bit(ATC_IS_CYCLIC, &atchan->status))
+	if (atc_chan_is_cyclic(atchan))
 		return;
 
 	spin_lock_irqsave(&atchan->lock, flags);
@@ -1395,8 +1395,7 @@ static int at_dma_prepare(struct device *dev)
 			device_node) {
 		struct at_dma_chan *atchan = to_at_dma_chan(chan);
 		/* wait for transaction completion (except in cyclic case) */
-		if (atc_chan_is_enabled(atchan) &&
-			!test_bit(ATC_IS_CYCLIC, &atchan->status))
+		if (atc_chan_is_enabled(atchan) && !atc_chan_is_cyclic(atchan))
 			return -EAGAIN;
 	}
 	return 0;
@@ -1408,7 +1407,7 @@ static void atc_suspend_cyclic(struct at_dma_chan *atchan)
 
 	/* Channel should be paused by user
 	 * do it anyway even if it is not done already */
-	if (!test_bit(ATC_IS_PAUSED, &atchan->status)) {
+	if (!atc_chan_is_paused(atchan)) {
 		dev_warn(chan2dev(chan),
 		"cyclic channel not paused, should be done by channel user\n");
 		atc_control(chan, DMA_PAUSE, 0);
@@ -1432,7 +1431,7 @@ static int at_dma_suspend_noirq(struct device *dev)
 			device_node) {
 		struct at_dma_chan *atchan = to_at_dma_chan(chan);
 
-		if (test_bit(ATC_IS_CYCLIC, &atchan->status))
+		if (atc_chan_is_cyclic(atchan))
 			atc_suspend_cyclic(atchan);
 		atchan->save_cfg = channel_readl(atchan, CFG);
 	}
@@ -1484,7 +1483,7 @@ static int at_dma_resume_noirq(struct device *dev)
 		struct at_dma_chan *atchan = to_at_dma_chan(chan);
 
 		channel_writel(atchan, CFG, atchan->save_cfg);
-		if (test_bit(ATC_IS_CYCLIC, &atchan->status))
+		if (atc_chan_is_cyclic(atchan))
 			atc_resume_cyclic(atchan);
 	}
 	return 0;
diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index 6f0c4a3..aa4c9ae 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -362,6 +362,23 @@ static inline int atc_chan_is_enabled(struct at_dma_chan *atchan)
 	return !!(dma_readl(atdma, CHSR) & atchan->mask);
 }
 
+/**
+ * atc_chan_is_paused - test channel pause/resume status
+ * @atchan: channel we want to test status
+ */
+static inline int atc_chan_is_paused(struct at_dma_chan *atchan)
+{
+	return test_bit(ATC_IS_PAUSED, &atchan->status);
+}
+
+/**
+ * atc_chan_is_cyclic - test if given channel has cyclic property set
+ * @atchan: channel we want to test status
+ */
+static inline int atc_chan_is_cyclic(struct at_dma_chan *atchan)
+{
+	return test_bit(ATC_IS_CYCLIC, &atchan->status);
+}
 
 /**
  * set_desc_eol - set end-of-link to descriptor so it will end transfer
-- 
1.7.4.1

