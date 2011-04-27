Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab1D0JiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:38:05 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:38391 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756422Ab1D0JiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:38:02 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <linux-arm-kernel@lists.infradead.org>,
        <viresh.linux@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V3 7/7] dmaengine/dw_dmac: implement pause and resume in dwc_control
Date: Wed, 27 Apr 2011 15:06:49 +0530
Message-ID: <b65d6a70ba743112de3c02247b1298c84783e5d4.1303896567.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1303896566.git.viresh.kumar@st.com>
References: <cover.1303896566.git.viresh.kumar@st.com>
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
index 014654d..ba1a2a4 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -841,34 +841,50 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
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
 
-	/* Flush all pending and queued descriptors */
-	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		dwc_descriptor_complete(dwc, desc, 0, flags);
+		spin_unlock_irqrestore(&dwc->lock, flags);
+	} else if (cmd == DMA_TERMINATE_ALL) {
+		spin_lock_irqsave(&dwc->lock, flags);
 
-	spin_unlock_irqrestore(&dwc->lock, flags);
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
+		/* Flush all pending and queued descriptors */
+		list_for_each_entry_safe(desc, _desc, &list, desc_node)
+			dwc_descriptor_complete(dwc, desc, 0, flags);
+
+		spin_unlock_irqrestore(&dwc->lock, flags);
+	} else
+		return -ENXIO;
 
 	return 0;
 }
@@ -905,6 +921,9 @@ dwc_tx_status(struct dma_chan *chan,
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
1.7.3.4

