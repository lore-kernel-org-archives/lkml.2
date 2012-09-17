Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab2IQHj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:39:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:53225 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab2IQHjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:39:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,433,1344236400"; 
   d="scan'208";a="145798360"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6/7] dw_dmac: check if controller supports LLP
Date: Mon, 17 Sep 2012 10:39:36 +0300
Message-Id: <1347867577-13170-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some controllers have the reduced functionality where the LLP multi block
transfers are not supported. This patch introduces a check and refuses to deal
with such devices.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c      |   35 ++++++++++++++++++++++++++++++++++-
 drivers/dma/dw_dmac_regs.h |    4 ++++
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index fdb7d5a..00958ad 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -647,6 +647,12 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	unsigned int		dst_width;
 	u32			ctllo;
 
+	if (dwc->nollp) {
+		dev_dbg(chan2dev(&dwc->chan),
+				"channel doesn't support LLP transfers\n");
+		return NULL;
+	}
+
 	dev_vdbg(chan2dev(chan),
 			"%s: d0x%llx s0x%llx l0x%zx f0x%lx\n", __func__,
 			(unsigned long long)dest, (unsigned long long)src,
@@ -741,6 +747,12 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	if (unlikely(!dws || !sg_len))
 		return NULL;
 
+	if (dwc->nollp) {
+		dev_dbg(chan2dev(&dwc->chan),
+				"channel doesn't support LLP transfers\n");
+		return NULL;
+	}
+
 	prev = first = NULL;
 
 	switch (direction) {
@@ -1202,6 +1214,13 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 	unsigned long			flags;
 
 	spin_lock_irqsave(&dwc->lock, flags);
+	if (dwc->nollp) {
+		spin_unlock_irqrestore(&dwc->lock, flags);
+		dev_dbg(chan2dev(&dwc->chan),
+				"channel doesn't support LLP transfers\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	if (!list_empty(&dwc->queue) || !list_empty(&dwc->active_list)) {
 		spin_unlock_irqrestore(&dwc->lock, flags);
 		dev_dbg(chan2dev(&dwc->chan),
@@ -1469,6 +1488,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&dw->dma.channels);
 	for (i = 0; i < nr_channels; i++) {
 		struct dw_dma_chan	*dwc = &dw->chan[i];
+		int			r = nr_channels - i - 1;
 
 		dwc->chan.device = &dw->dma;
 		dma_cookie_init(&dwc->chan);
@@ -1480,7 +1500,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
 
 		/* 7 is highest priority & 0 is lowest. */
 		if (pdata->chan_priority == CHAN_PRIORITY_ASCENDING)
-			dwc->priority = nr_channels - i - 1;
+			dwc->priority = r;
 		else
 			dwc->priority = i;
 
@@ -1498,10 +1518,23 @@ static int __devinit dw_probe(struct platform_device *pdev)
 
 		/* hardware configuration */
 		if (autocfg) {
+			unsigned int dwc_params;
+
+			dwc_params = dma_raw_readl(regs + r * sizeof(u32),
+						   DWC_PARAMS);
+
 			dwc->block_size =
 				(4 << ((max_blk_size >> 4 * i) & 0xf)) - 1;
+			dwc->nollp =
+				(dwc_params >> DWC_PARAMS_MBLK_EN & 0x1) == 0;
 		} else {
 			dwc->block_size = pdata->block_size;
+
+			/* Check if channel supports multi block transfer */
+			channel_writel(dwc, LLP, 0xfffffffc);
+			dwc->nollp =
+				(channel_readl(dwc, LLP) & 0xfffffffc) == 0;
+			channel_writel(dwc, LLP, 0);
 		}
 	}
 
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 9beaef0..b66a716 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -114,6 +114,9 @@ struct dw_dma_regs {
 #define DW_PARAMS_DATA_WIDTH4	21		/* master 4 data width */
 #define DW_PARAMS_EN		28		/* encoded parameters */
 
+/* Bitfields in DWC_PARAMS */
+#define DWC_PARAMS_MBLK_EN	11		/* multi block transfer */
+
 /* Bitfields in CTL_LO */
 #define DWC_CTLL_INT_EN		(1 << 0)	/* irqs enabled? */
 #define DWC_CTLL_DST_WIDTH(n)	((n)<<1)	/* bytes per element */
@@ -194,6 +197,7 @@ struct dw_dma_chan {
 
 	/* hardware configuration */
 	unsigned short		block_size;
+	bool			nollp;
 
 	/* configuration passed via DMA_SLAVE_CONFIG */
 	struct dma_slave_config dma_sconfig;
-- 
1.7.10.4

