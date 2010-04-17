Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0DQFNH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 01:13:07 -0400
Received: from mail.df.lth.se ([194.47.250.12]:52949 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752647Ab0DQFMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 01:12:49 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       Linus Walleij <linus.walleij@stericsson.com>,
       Jonas Aaberg <jonas.aberg@stericsson.com>,
       Marcin Mielczarczyk <marcin.mielczarczyk@tieto.com>
Subject: [PATCH 2/3] DMAENGINE: DMA40 logical channel fixes
Date: Sat, 17 Apr 2010 07:12:31 +0200
Message-Id: <1271481151-9589-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes some small bugs relating to the handling of logical
channels in the DMA40 driver:

- Fix a bug when asking for paused status of a logical channel
  would fail (bug found by Jonas Aaberg)
- Handle DMA channel request for logical channel 0 (bug found by
  Marcin Mielczarczyk)

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Marcin Mielczarczyk <marcin.mielczarczyk@tieto.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   92 +++++++++++++++++++++++++++++++++++-----------
 1 files changed, 70 insertions(+), 22 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index f86b99f..0ac6543 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -663,7 +663,7 @@ static void d40_config_set_event(struct d40_chan *d40c, bool do_enable)
 	spin_unlock_irqrestore(&d40c->phy_chan->lock, flags);
 }
 
-static bool d40_chan_has_events(struct d40_chan *d40c)
+static u32 d40_chan_has_events(struct d40_chan *d40c)
 {
 	u32 val = 0;
 
@@ -678,7 +678,7 @@ static bool d40_chan_has_events(struct d40_chan *d40c)
 		val = readl(d40c->base->virtbase + D40_DREG_PCBASE +
 			    d40c->phy_chan->num * D40_DREG_PCDELTA +
 			    D40_CHAN_REG_SDLNK);
-	return (bool) val;
+	return val;
 }
 
 static void d40_config_enable_lidx(struct d40_chan *d40c)
@@ -1043,11 +1043,11 @@ static int d40_validate_conf(struct d40_chan *d40c,
 }
 
 static bool d40_alloc_mask_set(struct d40_phy_res *phy, bool is_src,
-			       int log_event_line)
+			       int log_event_line, bool is_log)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&phy->lock, flags);
-	if (!log_event_line) {
+	if (!is_log) {
 		/* Physical interrupts are masked per physical full channel */
 		if (phy->allocated_src == D40_ALLOC_FREE &&
 		    phy->allocated_dst == D40_ALLOC_FREE) {
@@ -1165,15 +1165,16 @@ static int d40_allocate_channel(struct d40_chan *d40c)
 			/* Find physical half channel */
 			for (i = 0; i < d40c->base->num_phy_chans; i++) {
 
-				if (d40_alloc_mask_set(&phys[i], is_src, 0))
+				if (d40_alloc_mask_set(&phys[i], is_src,
+						       0, is_log))
 					goto found_phy;
 			}
 		} else
 			for (j = 0; j < d40c->base->num_phy_chans; j += 8) {
 				int phy_num = j  + event_group * 2;
 				for (i = phy_num; i < phy_num + 2; i++) {
-					if (d40_alloc_mask_set(&phys[i],
-							       is_src, 0))
+					if (d40_alloc_mask_set(&phys[i], is_src,
+							       0, is_log))
 						goto found_phy;
 				}
 			}
@@ -1197,13 +1198,13 @@ found_phy:
 		if (is_src) {
 			for (i = phy_num; i < phy_num + 2; i++) {
 				if (d40_alloc_mask_set(&phys[i], is_src,
-						       event_line))
+						       event_line, is_log))
 					goto found_log;
 			}
 		} else {
 			for (i = phy_num + 1; i >= phy_num; i--) {
 				if (d40_alloc_mask_set(&phys[i], is_src,
-						       event_line))
+						       event_line, is_log))
 					goto found_log;
 			}
 		}
@@ -1393,6 +1394,65 @@ static int d40_pause(struct dma_chan *chan)
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
@@ -1983,26 +2043,14 @@ static enum dma_status d40_tx_status(struct dma_chan *chan,
 				     struct dma_tx_state *txstate)
 {
 	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
-	void __iomem *active_reg;
 	dma_cookie_t last_used;
 	dma_cookie_t last_complete;
-	u32 status;
 	int ret;
 
 	last_complete = d40c->completed;
 	last_used = chan->cookie;
 
-	/* check for pause first */
-	if (d40c->phy_chan->num % 2 == 0)
-		active_reg = d40c->base->virtbase + D40_DREG_ACTIVE;
-	else
-		active_reg = d40c->base->virtbase + D40_DREG_ACTIVO;
-
-	status = (readl(active_reg) &
-		  D40_CHAN_POS_MASK(d40c->phy_chan->num)) >>
-		D40_CHAN_POS(d40c->phy_chan->num);
-
-	if (status == D40_DMA_SUSPENDED)
+	if (d40_is_paused(d40c))
 		ret = DMA_PAUSED;
 	else
 		ret = dma_async_is_complete(cookie, last_complete, last_used);
-- 
1.7.0.1

