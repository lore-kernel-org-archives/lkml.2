Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab3AIISu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:18:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:43357 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757326Ab3AIISs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:18:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,436,1355126400"; 
   d="scan'208";a="274634490"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [resend][PATCH 15/16] dma: dw_dmac: add dwc_chan_pause and dwc_chan_resume
Date: Wed,  9 Jan 2013 10:17:14 +0200
Message-Id: <1357719435-29955-16-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will use at least the dwc_chan_resume() later.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 8afbda6..6a8f8c7 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1008,6 +1008,26 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 	return 0;
 }
 
+static inline void dwc_chan_pause(struct dw_dma_chan *dwc)
+{
+	u32 cfglo = channel_readl(dwc, CFG_LO);
+
+	channel_writel(dwc, CFG_LO, cfglo | DWC_CFGL_CH_SUSP);
+	while (!(channel_readl(dwc, CFG_LO) & DWC_CFGL_FIFO_EMPTY))
+		cpu_relax();
+
+	dwc->paused = true;
+}
+
+static inline void dwc_chan_resume(struct dw_dma_chan *dwc)
+{
+	u32 cfglo = channel_readl(dwc, CFG_LO);
+
+	channel_writel(dwc, CFG_LO, cfglo & ~DWC_CFGL_CH_SUSP);
+
+	dwc->paused = false;
+}
+
 static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		       unsigned long arg)
 {
@@ -1015,18 +1035,13 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	struct dw_dma		*dw = to_dw_dma(chan->device);
 	struct dw_desc		*desc, *_desc;
 	unsigned long		flags;
-	u32			cfglo;
 	LIST_HEAD(list);
 
 	if (cmd == DMA_PAUSE) {
 		spin_lock_irqsave(&dwc->lock, flags);
 
-		cfglo = channel_readl(dwc, CFG_LO);
-		channel_writel(dwc, CFG_LO, cfglo | DWC_CFGL_CH_SUSP);
-		while (!(channel_readl(dwc, CFG_LO) & DWC_CFGL_FIFO_EMPTY))
-			cpu_relax();
+		dwc_chan_pause(dwc);
 
-		dwc->paused = true;
 		spin_unlock_irqrestore(&dwc->lock, flags);
 	} else if (cmd == DMA_RESUME) {
 		if (!dwc->paused)
@@ -1034,9 +1049,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 		spin_lock_irqsave(&dwc->lock, flags);
 
-		cfglo = channel_readl(dwc, CFG_LO);
-		channel_writel(dwc, CFG_LO, cfglo & ~DWC_CFGL_CH_SUSP);
-		dwc->paused = false;
+		dwc_chan_resume(dwc);
 
 		spin_unlock_irqrestore(&dwc->lock, flags);
 	} else if (cmd == DMA_TERMINATE_ALL) {
-- 
1.7.10.4

