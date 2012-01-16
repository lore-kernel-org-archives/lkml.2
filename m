Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2APJwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:52:44 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:40417 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907Ab2APJvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:51:38 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux@arm.linux.org.uk>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <armando.visconti@st.com>, <shiraz.hashim@st.com>,
        <vipin.kumar@st.com>, <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH 6/8] dmaengine/dw_dmac: Don't handle block interrupts
Date: Mon, 16 Jan 2012 15:20:34 +0530
Message-ID: <5de6fe5e4560f459075e2b82bbcfd04e56eedc41.1326707233.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
In-Reply-To: <cover.1326707233.git.viresh.kumar@st.com>
References: <cover.1326707233.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block interrupts give interrupt on completion of every LLI, which is actually
too much interrupts. This is just not required for current functioning of
dw_dmac.

So, just don't handle them at all.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |   36 ++++++------------------------------
 1 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index f061daa..8698d3b 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -192,7 +192,6 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
 
 	/* Enable interrupts */
 	channel_set_bit(dw, MASK.XFER, dwc->mask);
-	channel_set_bit(dw, MASK.BLOCK, dwc->mask);
 	channel_set_bit(dw, MASK.ERROR, dwc->mask);
 
 	dwc->initialized = true;
@@ -329,12 +328,6 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	unsigned long flags;
 
 	spin_lock_irqsave(&dwc->lock, flags);
-	/*
-	 * Clear block interrupt flag before scanning so that we don't
-	 * miss any, and read LLP before RAW_XFER to ensure it is
-	 * valid if we decide to scan the list.
-	 */
-	dma_writel(dw, CLEAR.BLOCK, dwc->mask);
 	llp = channel_readl(dwc, LLP);
 	status_xfer = dma_readl(dw, RAW.XFER);
 
@@ -470,17 +463,16 @@ EXPORT_SYMBOL(dw_dma_get_dst_addr);
 
 /* called with dwc->lock held and all DMAC interrupts disabled */
 static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
-		u32 status_block, u32 status_err, u32 status_xfer)
+		u32 status_err, u32 status_xfer)
 {
 	unsigned long flags;
 
-	if (status_block & dwc->mask) {
+	if (dwc->mask) {
 		void (*callback)(void *param);
 		void *callback_param;
 
 		dev_vdbg(chan2dev(&dwc->chan), "new cyclic period llp 0x%08x\n",
 				channel_readl(dwc, LLP));
-		dma_writel(dw, CLEAR.BLOCK, dwc->mask);
 
 		callback = dwc->cdesc->period_callback;
 		callback_param = dwc->cdesc->period_callback_param;
@@ -520,7 +512,6 @@ static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
 		channel_writel(dwc, CTL_LO, 0);
 		channel_writel(dwc, CTL_HI, 0);
 
-		dma_writel(dw, CLEAR.BLOCK, dwc->mask);
 		dma_writel(dw, CLEAR.ERROR, dwc->mask);
 		dma_writel(dw, CLEAR.XFER, dwc->mask);
 
@@ -537,36 +528,29 @@ static void dw_dma_tasklet(unsigned long data)
 {
 	struct dw_dma *dw = (struct dw_dma *)data;
 	struct dw_dma_chan *dwc;
-	u32 status_block;
 	u32 status_xfer;
 	u32 status_err;
 	int i;
 
-	status_block = dma_readl(dw, RAW.BLOCK);
 	status_xfer = dma_readl(dw, RAW.XFER);
 	status_err = dma_readl(dw, RAW.ERROR);
 
-	dev_vdbg(dw->dma.dev, "tasklet: status_block=%x status_err=%x\n",
-			status_block, status_err);
+	dev_vdbg(dw->dma.dev, "tasklet: status_err=%x\n", status_err);
 
 	for (i = 0; i < dw->dma.chancnt; i++) {
 		dwc = &dw->chan[i];
 		if (test_bit(DW_DMA_IS_CYCLIC, &dwc->flags))
-			dwc_handle_cyclic(dw, dwc, status_block, status_err,
-					status_xfer);
+			dwc_handle_cyclic(dw, dwc, status_err, status_xfer);
 		else if (status_err & (1 << i))
 			dwc_handle_error(dw, dwc);
-		else if ((status_block | status_xfer) & (1 << i))
+		else if (status_xfer & (1 << i))
 			dwc_scan_descriptors(dw, dwc);
 	}
 
 	/*
-	 * Re-enable interrupts. Block Complete interrupts are only
-	 * enabled if the INT_EN bit in the descriptor is set. This
-	 * will trigger a scan before the whole list is done.
+	 * Re-enable interrupts.
 	 */
 	channel_set_bit(dw, MASK.XFER, dw->all_chan_mask);
-	channel_set_bit(dw, MASK.BLOCK, dw->all_chan_mask);
 	channel_set_bit(dw, MASK.ERROR, dw->all_chan_mask);
 }
 
@@ -583,7 +567,6 @@ static irqreturn_t dw_dma_interrupt(int irq, void *dev_id)
 	 * softirq handler.
 	 */
 	channel_clear_bit(dw, MASK.XFER, dw->all_chan_mask);
-	channel_clear_bit(dw, MASK.BLOCK, dw->all_chan_mask);
 	channel_clear_bit(dw, MASK.ERROR, dw->all_chan_mask);
 
 	status = dma_readl(dw, STATUS_INT);
@@ -594,7 +577,6 @@ static irqreturn_t dw_dma_interrupt(int irq, void *dev_id)
 
 		/* Try to recover */
 		channel_clear_bit(dw, MASK.XFER, (1 << 8) - 1);
-		channel_clear_bit(dw, MASK.BLOCK, (1 << 8) - 1);
 		channel_clear_bit(dw, MASK.SRC_TRAN, (1 << 8) - 1);
 		channel_clear_bit(dw, MASK.DST_TRAN, (1 << 8) - 1);
 		channel_clear_bit(dw, MASK.ERROR, (1 << 8) - 1);
@@ -1068,7 +1050,6 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 
 	/* Disable interrupts */
 	channel_clear_bit(dw, MASK.XFER, dwc->mask);
-	channel_clear_bit(dw, MASK.BLOCK, dwc->mask);
 	channel_clear_bit(dw, MASK.ERROR, dwc->mask);
 
 	spin_unlock_irqrestore(&dwc->lock, flags);
@@ -1120,7 +1101,6 @@ int dw_dma_cyclic_start(struct dma_chan *chan)
 		return -EBUSY;
 	}
 
-	dma_writel(dw, CLEAR.BLOCK, dwc->mask);
 	dma_writel(dw, CLEAR.ERROR, dwc->mask);
 	dma_writel(dw, CLEAR.XFER, dwc->mask);
 
@@ -1322,7 +1302,6 @@ void dw_dma_cyclic_free(struct dma_chan *chan)
 	while (dma_readl(dw, CH_EN) & dwc->mask)
 		cpu_relax();
 
-	dma_writel(dw, CLEAR.BLOCK, dwc->mask);
 	dma_writel(dw, CLEAR.ERROR, dwc->mask);
 	dma_writel(dw, CLEAR.XFER, dwc->mask);
 
@@ -1347,7 +1326,6 @@ static void dw_dma_off(struct dw_dma *dw)
 	dma_writel(dw, CFG, 0);
 
 	channel_clear_bit(dw, MASK.XFER, dw->all_chan_mask);
-	channel_clear_bit(dw, MASK.BLOCK, dw->all_chan_mask);
 	channel_clear_bit(dw, MASK.SRC_TRAN, dw->all_chan_mask);
 	channel_clear_bit(dw, MASK.DST_TRAN, dw->all_chan_mask);
 	channel_clear_bit(dw, MASK.ERROR, dw->all_chan_mask);
@@ -1449,13 +1427,11 @@ static int __init dw_probe(struct platform_device *pdev)
 
 	/* Clear/disable all interrupts on all channels. */
 	dma_writel(dw, CLEAR.XFER, dw->all_chan_mask);
-	dma_writel(dw, CLEAR.BLOCK, dw->all_chan_mask);
 	dma_writel(dw, CLEAR.SRC_TRAN, dw->all_chan_mask);
 	dma_writel(dw, CLEAR.DST_TRAN, dw->all_chan_mask);
 	dma_writel(dw, CLEAR.ERROR, dw->all_chan_mask);
 
 	channel_clear_bit(dw, MASK.XFER, dw->all_chan_mask);
-	channel_clear_bit(dw, MASK.BLOCK, dw->all_chan_mask);
 	channel_clear_bit(dw, MASK.SRC_TRAN, dw->all_chan_mask);
 	channel_clear_bit(dw, MASK.DST_TRAN, dw->all_chan_mask);
 	channel_clear_bit(dw, MASK.ERROR, dw->all_chan_mask);
-- 
1.7.8.110.g4cb5d

