Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab1KQKdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 05:33:18 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:51319 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab1KQKdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 05:33:16 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH] dmaengine/dw_dmac: Reconfigure interrupt and chan_cfg register on resume
Date: Thu, 17 Nov 2011 16:01:29 +0530
Message-ID: <69e29c139ba027029e11940c6693e9d50dc21613.1321525673.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In S2R all DMA registers are reset by hardware and thus they are required to be
reprogrammed. The channels which aren't reprogrammed are channel configuration
and interrupt enable registers, which are currently programmed at chan_alloc
time.

This patch creates another routine to initialize a channel. It will try to
initialize channel on every dwc_dostart() call. If channel is already
initialised then it simply returns, otherwise it configures registers.

This routine will also initialize registers on wakeup from S2R, as we mark
channels as uninitialized on suspend.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---

Vinod,

This is rebased over your next branch with top commit:

commit 9b3fd2438c9cb19e7c7211c8dc33c45e1cb58bdf
Author: Ciaran McCormick <ciaranmccormick@gmail.com>
Date:   Mon Oct 31 19:29:26 2011 +0000

dma: fix spacing for method declaration, coding style issue in iop-adma.c
        
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 9bfd6d3..8980893 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -166,6 +166,38 @@ dwc_assign_cookie(struct dw_dma_chan *dwc, struct dw_desc *desc)
 	return cookie;
 }
 
+static void dwc_initialize(struct dw_dma_chan *dwc)
+{
+	struct dw_dma *dw = to_dw_dma(dwc->chan.device);
+	struct dw_dma_slave *dws = dwc->chan.private;
+	u32 cfghi = DWC_CFGH_FIFO_MODE;
+	u32 cfglo = DWC_CFGL_CH_PRIOR(dwc->priority);
+
+	if (dwc->initialized == true)
+		return;
+
+	if (dws) {
+		/*
+		 * We need controller-specific data to set up slave
+		 * transfers.
+		 */
+		BUG_ON(!dws->dma_dev || dws->dma_dev != dw->dma.dev);
+
+		cfghi = dws->cfg_hi;
+		cfglo |= dws->cfg_lo & ~DWC_CFGL_CH_PRIOR_MASK;
+	}
+
+	channel_writel(dwc, CFG_LO, cfglo);
+	channel_writel(dwc, CFG_HI, cfghi);
+
+	/* Enable interrupts */
+	channel_set_bit(dw, MASK.XFER, dwc->mask);
+	channel_set_bit(dw, MASK.BLOCK, dwc->mask);
+	channel_set_bit(dw, MASK.ERROR, dwc->mask);
+
+	dwc->initialized = true;
+}
+
 /*----------------------------------------------------------------------*/
 
 /* Called with dwc->lock held and bh disabled */
@@ -189,6 +221,8 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
 		return;
 	}
 
+	dwc_initialize(dwc);
+
 	channel_writel(dwc, LLP, first->txd.phys);
 	channel_writel(dwc, CTL_LO,
 			DWC_CTLL_LLP_D_EN | DWC_CTLL_LLP_S_EN);
@@ -959,10 +993,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma		*dw = to_dw_dma(chan->device);
 	struct dw_desc		*desc;
-	struct dw_dma_slave	*dws;
 	int			i;
-	u32			cfghi;
-	u32			cfglo;
 	unsigned long		flags;
 
 	dev_vdbg(chan2dev(chan), "alloc_chan_resources\n");
@@ -975,26 +1006,6 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 
 	dwc->completed = chan->cookie = 1;
 
-	cfghi = DWC_CFGH_FIFO_MODE;
-	cfglo = 0;
-
-	dws = chan->private;
-	if (dws) {
-		/*
-		 * We need controller-specific data to set up slave
-		 * transfers.
-		 */
-		BUG_ON(!dws->dma_dev || dws->dma_dev != dw->dma.dev);
-
-		cfghi = dws->cfg_hi;
-		cfglo = dws->cfg_lo & ~DWC_CFGL_CH_PRIOR_MASK;
-	}
-
-	cfglo |= DWC_CFGL_CH_PRIOR(dwc->priority);
-
-	channel_writel(dwc, CFG_LO, cfglo);
-	channel_writel(dwc, CFG_HI, cfghi);
-
 	/*
 	 * NOTE: some controllers may have additional features that we
 	 * need to initialize here, like "scatter-gather" (which
@@ -1026,11 +1037,6 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 		i = ++dwc->descs_allocated;
 	}
 
-	/* Enable interrupts */
-	channel_set_bit(dw, MASK.XFER, dwc->mask);
-	channel_set_bit(dw, MASK.BLOCK, dwc->mask);
-	channel_set_bit(dw, MASK.ERROR, dwc->mask);
-
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	dev_dbg(chan2dev(chan),
@@ -1058,6 +1064,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	spin_lock_irqsave(&dwc->lock, flags);
 	list_splice_init(&dwc->free_list, &list);
 	dwc->descs_allocated = 0;
+	dwc->initialized = false;
 
 	/* Disable interrupts */
 	channel_clear_bit(dw, MASK.XFER, dwc->mask);
@@ -1335,6 +1342,8 @@ EXPORT_SYMBOL(dw_dma_cyclic_free);
 
 static void dw_dma_off(struct dw_dma *dw)
 {
+	int i;
+
 	dma_writel(dw, CFG, 0);
 
 	channel_clear_bit(dw, MASK.XFER, dw->all_chan_mask);
@@ -1345,6 +1354,9 @@ static void dw_dma_off(struct dw_dma *dw)
 
 	while (dma_readl(dw, CFG) & DW_CFG_DMA_EN)
 		cpu_relax();
+
+	for (i = 0; i < dw->dma.chancnt; i++)
+		dw->chan[i].initialized = false;
 }
 
 static int __init dw_probe(struct platform_device *pdev)
@@ -1533,6 +1545,7 @@ static int dw_suspend_noirq(struct device *dev)
 
 	dw_dma_off(platform_get_drvdata(pdev));
 	clk_disable(dw->clk);
+
 	return 0;
 }
 
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index c341951..5eef694 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -140,6 +140,7 @@ struct dw_dma_chan {
 	u8			mask;
 	u8			priority;
 	bool			paused;
+	bool			initialized;
 
 	spinlock_t		lock;
 
-- 
1.7.2.2

