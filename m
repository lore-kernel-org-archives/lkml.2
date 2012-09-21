Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2IUMGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:06:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:29627 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab2IUMG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:06:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,462,1344236400"; 
   d="scan'208";a="225027880"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 6/6] dw_dmac: introduce software emulation of LLP transfers
Date: Fri, 21 Sep 2012 15:05:49 +0300
Message-Id: <1348229149-29040-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some controllers have the reduced functionality where the LLP multi block
transfers are not supported. This patch introduces a support of such
controllers. In case of memory copy or scatter-gather lists it emulates LLP
transfers via bunch of the regular single block ones.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c      |   99 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/dma/dw_dmac_regs.h |    6 +++
 2 files changed, 101 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index d47b76a..47b9b3e 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -234,10 +234,29 @@ static inline void dwc_chan_disable(struct dw_dma *dw, struct dw_dma_chan *dwc)
 
 /*----------------------------------------------------------------------*/
 
+/* Perform single block transfer */
+static inline void dwc_do_single_block(struct dw_dma_chan *dwc,
+				       struct dw_desc *desc)
+{
+	struct dw_dma	*dw = to_dw_dma(dwc->chan.device);
+	u32		ctllo;
+
+	/* Software emulation of LLP mode relies on interrupts to continue
+	 * multi block transfer. */
+	ctllo = desc->lli.ctllo | DWC_CTLL_INT_EN;
+
+	channel_writel(dwc, SAR, desc->lli.sar);
+	channel_writel(dwc, DAR, desc->lli.dar);
+	channel_writel(dwc, CTL_LO, ctllo);
+	channel_writel(dwc, CTL_HI, desc->lli.ctlhi);
+	channel_set_bit(dw, CH_EN, dwc->mask);
+}
+
 /* Called with dwc->lock held and bh disabled */
 static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
 {
 	struct dw_dma	*dw = to_dw_dma(dwc->chan.device);
+	unsigned long	was_soft_llp;
 
 	/* ASSERT:  channel is idle */
 	if (dma_readl(dw, CH_EN) & dwc->mask) {
@@ -249,6 +268,26 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
 		return;
 	}
 
+	if (dwc->nollp) {
+		was_soft_llp = test_and_set_bit(DW_DMA_IS_SOFT_LLP,
+						&dwc->flags);
+		if (was_soft_llp) {
+			dev_err(chan2dev(&dwc->chan),
+				"BUG: Attempted to start new LLP transfer "
+				"inside ongoing one\n");
+			return;
+		}
+
+		dwc_initialize(dwc);
+
+		dwc->tx_list = &first->tx_list;
+		dwc->tx_node_active = first->tx_list.next;
+
+		dwc_do_single_block(dwc, first);
+
+		return;
+	}
+
 	dwc_initialize(dwc);
 
 	channel_writel(dwc, LLP, first->txd.phys);
@@ -560,8 +599,36 @@ static void dw_dma_tasklet(unsigned long data)
 			dwc_handle_cyclic(dw, dwc, status_err, status_xfer);
 		else if (status_err & (1 << i))
 			dwc_handle_error(dw, dwc);
-		else if (status_xfer & (1 << i))
+		else if (status_xfer & (1 << i)) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&dwc->lock, flags);
+			if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags)) {
+				if (dwc->tx_node_active != dwc->tx_list) {
+					struct dw_desc *desc =
+						list_entry(dwc->tx_node_active,
+							   struct dw_desc,
+							   desc_node);
+
+					dma_writel(dw, CLEAR.XFER, dwc->mask);
+
+					/* move pointer to next descriptor */
+					dwc->tx_node_active =
+						dwc->tx_node_active->next;
+
+					dwc_do_single_block(dwc, desc);
+
+					spin_unlock_irqrestore(&dwc->lock, flags);
+					continue;
+				} else {
+					/* we are done here */
+					clear_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags);
+				}
+			}
+			spin_unlock_irqrestore(&dwc->lock, flags);
+
 			dwc_scan_descriptors(dw, dwc);
+		}
 	}
 
 	/*
@@ -964,6 +1031,8 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	} else if (cmd == DMA_TERMINATE_ALL) {
 		spin_lock_irqsave(&dwc->lock, flags);
 
+		clear_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags);
+
 		dwc_chan_disable(dw, dwc);
 
 		dwc->paused = false;
@@ -1206,6 +1275,13 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
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
@@ -1473,6 +1549,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&dw->dma.channels);
 	for (i = 0; i < nr_channels; i++) {
 		struct dw_dma_chan	*dwc = &dw->chan[i];
+		int			r = nr_channels - i - 1;
 
 		dwc->chan.device = &dw->dma;
 		dma_cookie_init(&dwc->chan);
@@ -1484,7 +1561,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
 
 		/* 7 is highest priority & 0 is lowest. */
 		if (pdata->chan_priority == CHAN_PRIORITY_ASCENDING)
-			dwc->priority = nr_channels - i - 1;
+			dwc->priority = r;
 		else
 			dwc->priority = i;
 
@@ -1501,14 +1578,28 @@ static int __devinit dw_probe(struct platform_device *pdev)
 		dwc->dw = dw;
 
 		/* hardware configuration */
-		if (autocfg)
+		if (autocfg) {
+			unsigned int dwc_params;
+
+			dwc_params = dma_read_byaddr(regs + r * sizeof(u32),
+						     DWC_PARAMS);
+
 			/* Decode maximum block size for given channel. The
 			 * stored 4 bit value represents blocks from 0x00 for 3
 			 * up to 0x0a for 4095. */
 			dwc->block_size =
 				(4 << ((max_blk_size >> 4 * i) & 0xf)) - 1;
-		else
+			dwc->nollp =
+				(dwc_params >> DWC_PARAMS_MBLK_EN & 0x1) == 0;
+		} else {
 			dwc->block_size = pdata->block_size;
+
+			/* Check if channel supports multi block transfer */
+			channel_writel(dwc, LLP, 0xfffffffc);
+			dwc->nollp =
+				(channel_readl(dwc, LLP) & 0xfffffffc) == 0;
+			channel_writel(dwc, LLP, 0);
+		}
 	}
 
 	/* Clear all interrupts on all channels. */
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 06f0391..ff39fa6 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -172,6 +172,7 @@ struct dw_dma_regs {
 
 enum dw_dmac_flags {
 	DW_DMA_IS_CYCLIC = 0,
+	DW_DMA_IS_SOFT_LLP = 1,
 };
 
 struct dw_dma_chan {
@@ -182,6 +183,10 @@ struct dw_dma_chan {
 	bool			paused;
 	bool			initialized;
 
+	/* software emulation of the LLP transfers */
+	struct list_head	*tx_list;
+	struct list_head	*tx_node_active;
+
 	spinlock_t		lock;
 
 	/* these other elements are all protected by lock */
@@ -195,6 +200,7 @@ struct dw_dma_chan {
 
 	/* hardware configuration */
 	unsigned int		block_size;
+	bool			nollp;
 
 	/* configuration passed via DMA_SLAVE_CONFIG */
 	struct dma_slave_config dma_sconfig;
-- 
1.7.10.4

