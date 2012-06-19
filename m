Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2FSKf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:35:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:55050 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab2FSKef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:34:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167444383"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 10/10] dw_dmac: introduce dwc_chan_reset
Date: Tue, 19 Jun 2012 13:34:10 +0300
Message-Id: <1340102050-12697-11-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This piece of code is used often. Make it as a separate function.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index d3845ef..14fbee4 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -219,6 +219,14 @@ static void dwc_dump_chan_regs(struct dw_dma_chan *dwc)
 		channel_readl(dwc, CTL_LO));
 }
 
+
+static inline void dwc_chan_reset(struct dw_dma *dw, struct dw_dma_chan *dwc)
+{
+	channel_clear_bit(dw, CH_EN, dwc->mask);
+	while (dma_readl(dw, CH_EN) & dwc->mask)
+		cpu_relax();
+}
+
 /*----------------------------------------------------------------------*/
 
 /* Called with dwc->lock held and bh disabled */
@@ -314,9 +322,7 @@ static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
 			"BUG: XFER bit set, but channel not idle!\n");
 
 		/* Try to continue after resetting the channel... */
-		channel_clear_bit(dw, CH_EN, dwc->mask);
-		while (dma_readl(dw, CH_EN) & dwc->mask)
-			cpu_relax();
+		dwc_chan_reset(dw, dwc);
 	}
 
 	/*
@@ -398,9 +404,7 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		"BUG: All descriptors done, but channel not idle!\n");
 
 	/* Try to continue after resetting the channel... */
-	channel_clear_bit(dw, CH_EN, dwc->mask);
-	while (dma_readl(dw, CH_EN) & dwc->mask)
-		cpu_relax();
+	dwc_chan_reset(dw, dwc);
 
 	if (!list_empty(&dwc->queue)) {
 		list_move(dwc->queue.next, &dwc->active_list);
@@ -516,9 +520,7 @@ static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
 
 		dwc_dump_chan_regs(dwc);
 
-		channel_clear_bit(dw, CH_EN, dwc->mask);
-		while (dma_readl(dw, CH_EN) & dwc->mask)
-			cpu_relax();
+		dwc_chan_reset(dw, dwc);
 
 		/* make sure DMA does not restart by loading a new list */
 		channel_writel(dwc, LLP, 0);
@@ -948,9 +950,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	} else if (cmd == DMA_TERMINATE_ALL) {
 		spin_lock_irqsave(&dwc->lock, flags);
 
-		channel_clear_bit(dw, CH_EN, dwc->mask);
-		while (dma_readl(dw, CH_EN) & dwc->mask)
-			cpu_relax();
+		dwc_chan_reset(dw, dwc);
 
 		dwc->paused = false;
 
@@ -1158,9 +1158,7 @@ void dw_dma_cyclic_stop(struct dma_chan *chan)
 
 	spin_lock_irqsave(&dwc->lock, flags);
 
-	channel_clear_bit(dw, CH_EN, dwc->mask);
-	while (dma_readl(dw, CH_EN) & dwc->mask)
-		cpu_relax();
+	dwc_chan_reset(dw, dwc);
 
 	spin_unlock_irqrestore(&dwc->lock, flags);
 }
@@ -1338,9 +1336,7 @@ void dw_dma_cyclic_free(struct dma_chan *chan)
 
 	spin_lock_irqsave(&dwc->lock, flags);
 
-	channel_clear_bit(dw, CH_EN, dwc->mask);
-	while (dma_readl(dw, CH_EN) & dwc->mask)
-		cpu_relax();
+	dwc_chan_reset(dw, dwc);
 
 	dma_writel(dw, CLEAR.ERROR, dwc->mask);
 	dma_writel(dw, CLEAR.XFER, dwc->mask);
-- 
1.7.10

