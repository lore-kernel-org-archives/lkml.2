Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab0FAMVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:21:48 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:58508 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756095Ab0FAMVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:21:45 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 09/18] DMAENGINE: ste_dma40: avoid doing unnessecary suspend
Date: Tue, 1 Jun 2010 14:21:35 +0200
Message-ID: <1275394895-26490-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Avoid doing unnessecary suspend when modifying logical channels.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   39 +++++++--------------------------------
 1 files changed, 7 insertions(+), 32 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index c4b0d37..0e7ed4f 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -595,6 +595,7 @@ static void d40_config_set_event(struct d40_chan *d40c, bool do_enable)
 	u32 val;
 	unsigned long flags;
 
+	/* Notice, that disable requires the physical channel to be stopped */
 	if (do_enable)
 		val = D40_ACTIVATE_EVENTLINE;
 	else
@@ -740,18 +741,10 @@ static dma_cookie_t d40_tx_submit(struct dma_async_tx_descriptor *tx)
 
 static int d40_start(struct d40_chan *d40c)
 {
-	int err;
-
-	if (d40c->log_num != D40_PHY_CHAN) {
-		err = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
-		if (err)
-			return err;
+	if (d40c->log_num != D40_PHY_CHAN)
 		d40_config_set_event(d40c, true);
-	}
-
-	err = d40_channel_execute_command(d40c, D40_DMA_RUN);
 
-	return err;
+	return d40_channel_execute_command(d40c, D40_DMA_RUN);
 }
 
 static struct d40_desc *d40_queue_start(struct d40_chan *d40c)
@@ -1370,7 +1363,6 @@ static bool d40_is_paused(struct d40_chan *d40c)
 	void __iomem *active_reg;
 	u32 status;
 	u32 event;
-	int res;
 
 	spin_lock_irqsave(&d40c->lock, flags);
 
@@ -1389,10 +1381,6 @@ static bool d40_is_paused(struct d40_chan *d40c)
 		goto _exit;
 	}
 
-	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
-	if (res != 0)
-		goto _exit;
-
 	if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_PERIPH ||
 	    d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM)
 		event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dst_dev_type);
@@ -1409,12 +1397,6 @@ static bool d40_is_paused(struct d40_chan *d40c)
 
 	if (status != D40_DMA_RUN)
 		is_paused = true;
-
-	/* Resume the other logical channels if any */
-	if (d40_chan_has_events(d40c))
-		res = d40_channel_execute_command(d40c,
-						  D40_DMA_RUN);
-
 _exit:
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return is_paused;
@@ -1460,20 +1442,13 @@ static int d40_resume(struct dma_chan *chan)
 
 	spin_lock_irqsave(&d40c->lock, flags);
 
-	if (d40c->log_num != D40_PHY_CHAN) {
-		res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
-		if (res)
-			goto out;
-
-		/* If bytes left to transfer or linked tx resume job */
-		if (d40_residue(d40c) || d40_tx_is_linked(d40c)) {
+	/* If bytes left to transfer or linked tx resume job */
+	if (d40_residue(d40c) || d40_tx_is_linked(d40c)) {
+		if (d40c->log_num != D40_PHY_CHAN)
 			d40_config_set_event(d40c, true);
-			res = d40_channel_execute_command(d40c, D40_DMA_RUN);
-		}
-	} else if (d40_residue(d40c) || d40_tx_is_linked(d40c))
 		res = d40_channel_execute_command(d40c, D40_DMA_RUN);
+	}
 
-out:
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
 }
-- 
1.6.3.3

