Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab0FAMWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:22:50 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:47975 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756093Ab0FAMWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:22:48 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 16/18] DMAENGINE: ste_dma40: fix suspend bug
Date: Tue, 1 Jun 2010 14:22:36 +0200
Message-ID: <1275394956-26820-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

This fixes a bug when suspending channels: first make the checks,
then suspend the channel, not the other way around.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   33 +++++++++++++--------------------
 1 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ec092fa..5cde3c3 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1250,7 +1250,7 @@ static int d40_free_dma(struct d40_chan *d40c)
 {
 
 	int res = 0;
-	u32 event, dir;
+	u32 event;
 	struct d40_phy_res *phy = d40c->phy_chan;
 	bool is_src;
 	struct d40_desc *d;
@@ -1282,21 +1282,12 @@ static int d40_free_dma(struct d40_chan *d40c)
 		return -EINVAL;
 	}
 
-	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
-	if (res) {
-		dev_err(&d40c->chan.dev->device, "[%s] suspend failed\n",
-			__func__);
-		return res;
-	}
-
 	if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_PERIPH ||
 	    d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM) {
 		event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dst_dev_type);
-		dir = D40_CHAN_REG_SDLNK;
 		is_src = false;
 	} else if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM) {
 		event = D40_TYPE_TO_EVENT(d40c->dma_cfg.src_dev_type);
-		dir = D40_CHAN_REG_SSLNK;
 		is_src = true;
 	} else {
 		dev_err(&d40c->chan.dev->device,
@@ -1304,16 +1295,17 @@ static int d40_free_dma(struct d40_chan *d40c)
 		return -EINVAL;
 	}
 
+	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
+	if (res) {
+		dev_err(&d40c->chan.dev->device, "[%s] suspend failed\n",
+			__func__);
+		return res;
+	}
+
 	if (d40c->log_num != D40_PHY_CHAN) {
-		/*
-		 * Release logical channel, deactivate the event line during
-		 * the time physical res is suspended.
-		 */
-		writel((D40_DEACTIVATE_EVENTLINE << D40_EVENTLINE_POS(event)) &
-		       D40_EVENTLINE_MASK(event),
-		       d40c->base->virtbase + D40_DREG_PCBASE +
-		       phy->num * D40_DREG_PCDELTA + dir);
+		/* Release logical channel, deactivate the event line */
 
+		d40_config_set_event(d40c, false);
 		d40c->base->lookup_log_chans[d40c->log_num] = NULL;
 
 		/*
@@ -1334,8 +1326,9 @@ static int d40_free_dma(struct d40_chan *d40c)
 			}
 			return 0;
 		}
-	} else
-		d40_alloc_mask_free(phy, is_src, 0);
+	} else {
+		(void) d40_alloc_mask_free(phy, is_src, 0);
+	}
 
 	/* Release physical channel */
 	res = d40_channel_execute_command(d40c, D40_DMA_STOP);
-- 
1.6.3.3

