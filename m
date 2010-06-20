Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0FTV0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:26:52 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:45565 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755130Ab0FTV0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:26:49 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 16/19] DMAENGINE: ste_dma40: fix suspend bug
Date: Sun, 20 Jun 2010 23:26:38 +0200
Message-ID: <1277069198-31392-1-git-send-email-linus.walleij@stericsson.com>
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
index 5748e96..e14c395 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1220,7 +1220,7 @@ static int d40_free_dma(struct d40_chan *d40c)
 {
 
 	int res = 0;
-	u32 event, dir;
+	u32 event;
 	struct d40_phy_res *phy = d40c->phy_chan;
 	bool is_src;
 	struct d40_desc *d;
@@ -1252,21 +1252,12 @@ static int d40_free_dma(struct d40_chan *d40c)
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
@@ -1274,16 +1265,17 @@ static int d40_free_dma(struct d40_chan *d40c)
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
@@ -1304,8 +1296,9 @@ static int d40_free_dma(struct d40_chan *d40c)
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

