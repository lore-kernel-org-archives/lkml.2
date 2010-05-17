Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab0EQWk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:40:57 -0400
Received: from mail.df.lth.se ([194.47.250.12]:45424 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751381Ab0EQWk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:40:56 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 1/3] DMAENGINE: DMA40 support paused channel status
Date: Tue, 18 May 2010 00:41:09 +0200
Message-Id: <1274136069-11850-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Support determining whether a channel is paused or
not using the status function.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
The majority of this patch was a bugfix for the PrimeCell
extensions which included the paused channel status. This
breaks out that small generic part and integrates the bugfix
patch.
---
 drivers/dma/ste_dma40.c |   75 ++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 67 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index e4295a2..16a7d2b 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -659,7 +659,7 @@ static void d40_config_set_event(struct d40_chan *d40c, bool do_enable)
 	spin_unlock_irqrestore(&d40c->phy_chan->lock, flags);
 }
 
-static bool d40_chan_has_events(struct d40_chan *d40c)
+static u32 d40_chan_has_events(struct d40_chan *d40c)
 {
 	u32 val = 0;
 
@@ -674,7 +674,7 @@ static bool d40_chan_has_events(struct d40_chan *d40c)
 		val = readl(d40c->base->virtbase + D40_DREG_PCBASE +
 			    d40c->phy_chan->num * D40_DREG_PCDELTA +
 			    D40_CHAN_REG_SDLNK);
-	return (bool) val;
+	return val;
 }
 
 static void d40_config_enable_lidx(struct d40_chan *d40c)
@@ -1389,6 +1389,65 @@ static int d40_pause(struct dma_chan *chan)
 	return res;
 }
 
+static bool d40_is_paused(struct d40_chan *d40c)
+{
+	bool is_paused = false;
+	unsigned long flags;
+	void __iomem *active_reg;
+	u32 status;
+	u32 event;
+	int res;
+
+	spin_lock_irqsave(&d40c->lock, flags);
+
+	if (d40c->log_num == D40_PHY_CHAN) {
+		if (d40c->phy_chan->num % 2 == 0)
+			active_reg = d40c->base->virtbase + D40_DREG_ACTIVE;
+		else
+			active_reg = d40c->base->virtbase + D40_DREG_ACTIVO;
+
+		status = (readl(active_reg) &
+			  D40_CHAN_POS_MASK(d40c->phy_chan->num)) >>
+			D40_CHAN_POS(d40c->phy_chan->num);
+		if (status == D40_DMA_SUSPENDED || status == D40_DMA_STOP)
+			is_paused = true;
+
+		goto _exit;
+	}
+
+	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
+	if (res != 0)
+		goto _exit;
+
+	if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_PERIPH ||
+	    d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM)
+		event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dst_dev_type);
+	else if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
+		event = D40_TYPE_TO_EVENT(d40c->dma_cfg.src_dev_type);
+	else {
+		dev_err(&d40c->chan.dev->device,
+			"[%s] Unknown direction\n", __func__);
+		goto _exit;
+	}
+	status = d40_chan_has_events(d40c);
+	status = (status & D40_EVENTLINE_MASK(event)) >>
+		D40_EVENTLINE_POS(event);
+
+	if (status != D40_DMA_RUN)
+		is_paused = true;
+
+	/* Resume the other logical channels if any */
+	if (d40_chan_has_events(d40c))
+		res = d40_channel_execute_command(d40c,
+						  D40_DMA_RUN);
+
+_exit:
+	spin_unlock_irqrestore(&d40c->lock, flags);
+	return is_paused;
+
+}
+
+
 static bool d40_tx_is_linked(struct d40_chan *d40c)
 {
 	bool is_link;
@@ -1980,13 +2039,13 @@ static enum dma_status d40_tx_status(struct dma_chan *chan,
 	last_complete = d40c->completed;
 	last_used = chan->cookie;
 
-	ret = dma_async_is_complete(cookie, last_complete, last_used);
+	if (d40_is_paused(d40c))
+		ret = DMA_PAUSED;
+	else
+		ret = dma_async_is_complete(cookie, last_complete, last_used);
 
-	if (txstate) {
-		txstate->last = last_complete;
-		txstate->used = last_used;
-		txstate->residue = stedma40_residue(chan);
-	}
+	dma_set_tx_state(txstate, last_complete, last_used,
+			 stedma40_residue(chan));
 
 	return ret;
 }
-- 
1.7.0.1

