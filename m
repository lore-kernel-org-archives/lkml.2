Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1EIIQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:16:35 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:56815 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959Ab1EIIQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 04:16:33 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <linux-arm-kernel@lists.infradead.org>,
        <viresh.linux@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V5 5/5] dmaengine/dw_dmac: implement pause and resume in dwc_control
Date: Mon, 9 May 2011 13:45:53 +0530
Message-ID: <ffb042703545d546bc9c939ea49a8c3888510d9a.1304928776.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1304928776.git.viresh.kumar@st.com>
References: <cover.1304928776.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Some peripherals like amba-pl011 needs pause to be implemented in DMA controller
drivers. This also returns correct status from dwc_tx_status() in case chan is
paused.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c      |   59 +++++++++++++++++++++++++++++---------------
 drivers/dma/dw_dmac_regs.h |    1 +
 2 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 1a3fe3e..d83fd24 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -862,34 +862,50 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	struct dw_dma		*dw = to_dw_dma(chan->device);
 	struct dw_desc		*desc, *_desc;
 	unsigned long		flags;
+	u32			cfglo;
 	LIST_HEAD(list);
 
-	/* Only supports DMA_TERMINATE_ALL */
-	if (cmd != DMA_TERMINATE_ALL)
-		return -ENXIO;
+	if (cmd == DMA_PAUSE) {
+		spin_lock_irqsave(&dwc->lock, flags);
 
-	/*
-	 * This is only called when something went wrong elsewhere, so
-	 * we don't really care about the data. Just disable the
-	 * channel. We still have to poll the channel enable bit due
-	 * to AHB/HSB limitations.
-	 */
-	spin_lock_irqsave(&dwc->lock, flags);
+		cfglo = channel_readl(dwc, CFG_LO);
+		channel_writel(dwc, CFG_LO, cfglo | DWC_CFGL_CH_SUSP);
+		while (!(channel_readl(dwc, CFG_LO) & DWC_CFGL_FIFO_EMPTY))
+			cpu_relax();
 
-	channel_clear_bit(dw, CH_EN, dwc->mask);
+		dwc->paused = true;
+		spin_unlock_irqrestore(&dwc->lock, flags);
+	} else if (cmd == DMA_RESUME) {
+		if (!dwc->paused)
+			return 0;
 
-	while (dma_readl(dw, CH_EN) & dwc->mask)
-		cpu_relax();
+		spin_lock_irqsave(&dwc->lock, flags);
 
-	/* active_list entries will end up before queued entries */
-	list_splice_init(&dwc->queue, &list);
-	list_splice_init(&dwc->active_list, &list);
+		cfglo = channel_readl(dwc, CFG_LO);
+		channel_writel(dwc, CFG_LO, cfglo & ~DWC_CFGL_CH_SUSP);
+		dwc->paused = false;
 
-	spin_unlock_irqrestore(&dwc->lock, flags);
+		spin_unlock_irqrestore(&dwc->lock, flags);
+	} else if (cmd == DMA_TERMINATE_ALL) {
+		spin_lock_irqsave(&dwc->lock, flags);
 
-	/* Flush all pending and queued descriptors */
-	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		dwc_descriptor_complete(dwc, desc, false);
+		channel_clear_bit(dw, CH_EN, dwc->mask);
+		while (dma_readl(dw, CH_EN) & dwc->mask)
+			cpu_relax();
+
+		dwc->paused = false;
+
+		/* active_list entries will end up before queued entries */
+		list_splice_init(&dwc->queue, &list);
+		list_splice_init(&dwc->active_list, &list);
+
+		spin_unlock_irqrestore(&dwc->lock, flags);
+
+		/* Flush all pending and queued descriptors */
+		list_for_each_entry_safe(desc, _desc, &list, desc_node)
+			dwc_descriptor_complete(dwc, desc, false);
+	} else
+		return -ENXIO;
 
 	return 0;
 }
@@ -923,6 +939,9 @@ dwc_tx_status(struct dma_chan *chan,
 	else
 		dma_set_tx_state(txstate, last_complete, last_used, 0);
 
+	if (dwc->paused)
+		return DMA_PAUSED;
+
 	return ret;
 }
 
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 720f821..c968597 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -138,6 +138,7 @@ struct dw_dma_chan {
 	void __iomem		*ch_regs;
 	u8			mask;
 	u8			priority;
+	bool			paused;
 
 	spinlock_t		lock;
 
-- 
1.7.2.2

