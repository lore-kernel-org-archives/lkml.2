Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab2IQHj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:39:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:55699 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab2IQHjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:39:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,433,1344236400"; 
   d="scan'208";a="145798362"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 7/7] dw_dmac: introduce software emulation of LLP transfers
Date: Mon, 17 Sep 2012 10:39:37 +0300
Message-Id: <1347867577-13170-8-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some controllers have the reduced functionality where the LLP multi block
transfers are not supported. This patch introduces a support of such
controllers. In case of memory copy or scatter-gather lists it emulates LLP
transfers via bunch of the regular single block ones.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c      |   83 +++++++++++++++++++++++++++++++++++++-------
 drivers/dma/dw_dmac_regs.h |    5 +++
 2 files changed, 75 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 00958ad..fa23711 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -229,10 +229,29 @@ static inline void dwc_chan_disable(struct dw_dma *dw, struct dw_dma_chan *dwc)
 
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
@@ -244,6 +263,26 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
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
@@ -555,8 +594,36 @@ static void dw_dma_tasklet(unsigned long data)
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
@@ -647,12 +714,6 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	unsigned int		dst_width;
 	u32			ctllo;
 
-	if (dwc->nollp) {
-		dev_dbg(chan2dev(&dwc->chan),
-				"channel doesn't support LLP transfers\n");
-		return NULL;
-	}
-
 	dev_vdbg(chan2dev(chan),
 			"%s: d0x%llx s0x%llx l0x%zx f0x%lx\n", __func__,
 			(unsigned long long)dest, (unsigned long long)src,
@@ -747,12 +808,6 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	if (unlikely(!dws || !sg_len))
 		return NULL;
 
-	if (dwc->nollp) {
-		dev_dbg(chan2dev(&dwc->chan),
-				"channel doesn't support LLP transfers\n");
-		return NULL;
-	}
-
 	prev = first = NULL;
 
 	switch (direction) {
@@ -972,6 +1027,8 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	} else if (cmd == DMA_TERMINATE_ALL) {
 		spin_lock_irqsave(&dwc->lock, flags);
 
+		clear_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags);
+
 		dwc_chan_disable(dw, dwc);
 
 		dwc->paused = false;
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index b66a716..297ab18 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -174,6 +174,7 @@ struct dw_dma_regs {
 
 enum dw_dmac_flags {
 	DW_DMA_IS_CYCLIC = 0,
+	DW_DMA_IS_SOFT_LLP = 1,
 };
 
 struct dw_dma_chan {
@@ -184,6 +185,10 @@ struct dw_dma_chan {
 	bool			paused;
 	bool			initialized;
 
+	/* software emulation of the LLP transfers */
+	struct list_head	*tx_list;
+	struct list_head	*tx_node_active;
+
 	spinlock_t		lock;
 
 	/* these other elements are all protected by lock */
-- 
1.7.10.4

