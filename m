Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1DSAcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 20:32:07 -0400
Received: from mail.df.lth.se ([194.47.250.12]:46740 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751662Ab1DSAcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 20:32:06 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, linux-arm-kernel@lists.infradead.org,
        amit.goel@st.com, armando.visconti@st.com, shiraz.hashim@st.com,
        linux-serial@vger.kernel.org, viresh.linux@gmail.com,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] dmaengine: implement pause and resume for dw_dmac
Date: Tue, 19 Apr 2011 02:31:32 +0200
Message-Id: <1303173092-21785-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that the SPEAr needs this.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/dw_dmac.c      |   22 ++++++++++++++++++++--
 drivers/dma/dw_dmac_regs.h |    1 +
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 9c25c7d..60ac779 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -801,8 +801,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	struct dw_desc		*desc, *_desc;
 	LIST_HEAD(list);
 
-	/* Only supports DMA_TERMINATE_ALL */
-	if (cmd != DMA_TERMINATE_ALL)
+	if (cmd != DMA_TERMINATE_ALL && cmd != DMA_PAUSE && cmd != DMA_RESUME)
 		return -ENXIO;
 
 	/*
@@ -813,11 +812,30 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	 */
 	spin_lock_bh(&dwc->lock);
 
+	if (cmd == DMA_RESUME) {
+		if (dwc->paused) {
+			channel_set_bit(dw, CH_EN, dwc->mask);
+			while (!dma_readl(dw, CH_EN) & dwc->mask)
+				cpu_relax();
+		}
+		spin_unlock_bh(&dwc->lock);
+		return 0;
+	}
+
 	channel_clear_bit(dw, CH_EN, dwc->mask);
 
 	while (dma_readl(dw, CH_EN) & dwc->mask)
 		cpu_relax();
 
+	if (cmd == DMA_PAUSE) {
+		dwc->paused = true;
+		spin_unlock_bh(&dwc->lock);
+		return 0;
+	}
+
+	/* Terminating a paused transfer */
+	dwc->paused = false;
+
 	/* active_list entries will end up before queued entries */
 	list_splice_init(&dwc->queue, &list);
 	list_splice_init(&dwc->active_list, &list);
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
1.7.4

