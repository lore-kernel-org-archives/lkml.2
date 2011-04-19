Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1DSKMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 06:12:55 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:52448 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477Ab1DSKMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 06:12:53 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-kernel@vger.kernel.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>, <jamie@jamieiles.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>, <viresh.linux@gmail.com>,
        <linus.walleij@linaro.org>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 7/7 resend] dmaengine/dw_dmac: implement pause and resume in dwc_control
Date: Tue, 19 Apr 2011 15:42:32 +0530
Message-ID: <8028d0d16e2376154c60c05c1afad04b61d65d0d.1303194836.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1303194835.git.viresh.kumar@st.com>
References: <cover.1303194835.git.viresh.kumar@st.com>
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
index c30f0ba..971d4df 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -830,34 +830,50 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma		*dw = to_dw_dma(chan->device);
 	struct dw_desc		*desc, *_desc;
+	u32			cfglo;
 	LIST_HEAD(list);
 
-	/* Only supports DMA_TERMINATE_ALL */
-	if (cmd != DMA_TERMINATE_ALL)
-		return -ENXIO;
+	if (cmd == DMA_PAUSE) {
+		spin_lock_irqsave(&dwc->lock, dwc->lflags);
 
-	/*
-	 * This is only called when something went wrong elsewhere, so
-	 * we don't really care about the data. Just disable the
-	 * channel. We still have to poll the channel enable bit due
-	 * to AHB/HSB limitations.
-	 */
-	spin_lock_irqsave(&dwc->lock, dwc->lflags);
+		cfglo = channel_readl(dwc, CFG_LO);
+		channel_writel(dwc, CFG_LO, cfglo | DWC_CFGL_CH_SUSP);
+		while (!(channel_readl(dwc, CFG_LO) & DWC_CFGL_FIFO_EMPTY))
+			cpu_relax();
 
-	channel_clear_bit(dw, CH_EN, dwc->mask);
+		dwc->paused = true;
+		spin_unlock_irqrestore(&dwc->lock, dwc->lflags);
+	} else if (cmd == DMA_RESUME) {
+		if (!dwc->paused)
+			return 0;
 
-	while (dma_readl(dw, CH_EN) & dwc->mask)
-		cpu_relax();
+		spin_lock_irqsave(&dwc->lock, dwc->lflags);
 
-	/* active_list entries will end up before queued entries */
-	list_splice_init(&dwc->queue, &list);
-	list_splice_init(&dwc->active_list, &list);
+		cfglo = channel_readl(dwc, CFG_LO);
+		channel_writel(dwc, CFG_LO, cfglo & ~DWC_CFGL_CH_SUSP);
+		dwc->paused = false;
 
-	/* Flush all pending and queued descriptors */
-	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		dwc_descriptor_complete(dwc, desc, 0);
+		spin_unlock_irqrestore(&dwc->lock, dwc->lflags);
+	} else if (cmd == DMA_TERMINATE_ALL) {
+		spin_lock_irqsave(&dwc->lock, dwc->lflags);
 
-	spin_unlock_irqrestore(&dwc->lock, dwc->lflags);
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
+			dwc_descriptor_complete(dwc, desc, 0);
+
+		spin_unlock_irqrestore(&dwc->lock, dwc->lflags);
+	} else
+		return -ENXIO;
 
 	return 0;
 }
@@ -893,6 +909,9 @@ dwc_tx_status(struct dma_chan *chan,
 	else
 		dma_set_tx_state(txstate, last_complete, last_used, 0);
 
+	if (dwc->paused)
+		return DMA_PAUSED;
+
 	return ret;
 }
 
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 5915743..47138b1 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -138,6 +138,7 @@ struct dw_dma_chan {
 	void __iomem		*ch_regs;
 	u8			mask;
 	u8			priority;
+	bool			paused;
 
 	spinlock_t		lock;
 	unsigned long		lflags;
-- 
1.7.2.2

