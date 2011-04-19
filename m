Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab1DSIdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:33:17 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:49207 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753985Ab1DSIcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:32:48 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-kernel@vger.kernel.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>, <viresh.linux@gmail.com>,
        <linus.walleij@linaro.org>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 7/7] dmaengine/dw_dmac: implement pause and resume in dwc_control
Date: Tue, 19 Apr 2011 14:02:12 +0530
Message-ID: <a1168e413888e35badd9fab6b1626fcfe355dc9b.1303194836.git.viresh.kumar@st.com>
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
 drivers/dma/dw_dmac.c      |   25 +++++++++++++++++++++++--
 drivers/dma/dw_dmac_regs.h |    1 +
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index c30f0ba..48d2d7e 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -832,8 +832,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	struct dw_desc		*desc, *_desc;
 	LIST_HEAD(list);
 
-	/* Only supports DMA_TERMINATE_ALL */
-	if (cmd != DMA_TERMINATE_ALL)
+	if (cmd != DMA_TERMINATE_ALL && cmd != DMA_PAUSE && cmd != DMA_RESUME)
 		return -ENXIO;
 
 	/*
@@ -844,11 +843,30 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	 */
 	spin_lock_irqsave(&dwc->lock, dwc->lflags);
 
+	if (cmd == DMA_RESUME) {
+		if (dwc->paused) {
+			channel_set_bit(dw, CH_EN, dwc->mask);
+			while (!(dma_readl(dw, CH_EN) & dwc->mask))
+				cpu_relax();
+		}
+		spin_unlock_irqrestore(&dwc->lock, dwc->lflags);
+		return 0;
+	}
+
 	channel_clear_bit(dw, CH_EN, dwc->mask);
 
 	while (dma_readl(dw, CH_EN) & dwc->mask)
 		cpu_relax();
 
+	if (cmd == DMA_PAUSE) {
+		dwc->paused = true;
+		spin_unlock_irqrestore(&dwc->lock, dwc->lflags);
+		return 0;
+	}
+
+	/* Terminating a paused transfer */
+	dwc->paused = false;
+
 	/* active_list entries will end up before queued entries */
 	list_splice_init(&dwc->queue, &list);
 	list_splice_init(&dwc->active_list, &list);
@@ -893,6 +911,9 @@ dwc_tx_status(struct dma_chan *chan,
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

