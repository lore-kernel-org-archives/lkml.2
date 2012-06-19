Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab2FSKee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:34:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:45792 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab2FSKea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:34:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="182051028"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 03/10] dw_dmac: introduce dwc_dump_chan_regs to dump registers
Date: Tue, 19 Jun 2012 13:34:03 +0300
Message-Id: <1340102050-12697-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is three places where values of the most significant registers were
printed. Make such piece of code as separate function.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 45861b6..b6251dc 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -193,6 +193,19 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
 
 /*----------------------------------------------------------------------*/
 
+static void dwc_dump_chan_regs(struct dw_dma_chan *dwc)
+{
+	dev_err(chan2dev(&dwc->chan),
+		"  SAR: 0x%x DAR: 0x%x LLP: 0x%x CTL: 0x%x:%08x\n",
+		channel_readl(dwc, SAR),
+		channel_readl(dwc, DAR),
+		channel_readl(dwc, LLP),
+		channel_readl(dwc, CTL_HI),
+		channel_readl(dwc, CTL_LO));
+}
+
+/*----------------------------------------------------------------------*/
+
 /* Called with dwc->lock held and bh disabled */
 static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
 {
@@ -202,13 +215,7 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
 	if (dma_readl(dw, CH_EN) & dwc->mask) {
 		dev_err(chan2dev(&dwc->chan),
 			"BUG: Attempted to start non-idle channel\n");
-		dev_err(chan2dev(&dwc->chan),
-			"  SAR: 0x%x DAR: 0x%x LLP: 0x%x CTL: 0x%x:%08x\n",
-			channel_readl(dwc, SAR),
-			channel_readl(dwc, DAR),
-			channel_readl(dwc, LLP),
-			channel_readl(dwc, CTL_HI),
-			channel_readl(dwc, CTL_LO));
+		dwc_dump_chan_regs(dwc);
 
 		/* The tasklet will hopefully advance the queue... */
 		return;
@@ -492,13 +499,7 @@ static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
 
 		spin_lock_irqsave(&dwc->lock, flags);
 
-		dev_err(chan2dev(&dwc->chan),
-			"  SAR: 0x%x DAR: 0x%x LLP: 0x%x CTL: 0x%x:%08x\n",
-			channel_readl(dwc, SAR),
-			channel_readl(dwc, DAR),
-			channel_readl(dwc, LLP),
-			channel_readl(dwc, CTL_HI),
-			channel_readl(dwc, CTL_LO));
+		dwc_dump_chan_regs(dwc);
 
 		channel_clear_bit(dw, CH_EN, dwc->mask);
 		while (dma_readl(dw, CH_EN) & dwc->mask)
@@ -1133,13 +1134,7 @@ int dw_dma_cyclic_start(struct dma_chan *chan)
 	if (dma_readl(dw, CH_EN) & dwc->mask) {
 		dev_err(chan2dev(&dwc->chan),
 			"BUG: Attempted to start non-idle channel\n");
-		dev_err(chan2dev(&dwc->chan),
-			"  SAR: 0x%x DAR: 0x%x LLP: 0x%x CTL: 0x%x:%08x\n",
-			channel_readl(dwc, SAR),
-			channel_readl(dwc, DAR),
-			channel_readl(dwc, LLP),
-			channel_readl(dwc, CTL_HI),
-			channel_readl(dwc, CTL_LO));
+		dwc_dump_chan_regs(dwc);
 		spin_unlock_irqrestore(&dwc->lock, flags);
 		return -EBUSY;
 	}
-- 
1.7.10

