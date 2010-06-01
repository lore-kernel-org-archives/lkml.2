Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0FAMUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:20:49 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:57859 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756167Ab0FAMUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:20:45 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: [PATCH 02/18] DMAENGINE: ste_dma40: only write phy channel config first time
Date: Tue, 1 Jun 2010 14:20:35 +0200
Message-ID: <1275394835-26161-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only need to write the configuration to a physical channel if
it is free, else it is already written.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 4618d6c..1cd1ff7 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1211,9 +1211,9 @@ out:
 }
 
 static int d40_config_chan(struct d40_chan *d40c,
-			   struct stedma40_chan_cfg *info)
+			   struct stedma40_chan_cfg *info,
+			   bool is_free_phy)
 {
-
 	/* Fill in basic CFG register values */
 	d40_phy_cfg(&d40c->dma_cfg, &d40c->src_def_cfg,
 		    &d40c->dst_def_cfg, d40c->log_num != D40_PHY_CHAN);
@@ -1230,8 +1230,14 @@ static int d40_config_chan(struct d40_chan *d40c,
 				d40c->dma_cfg.dst_dev_type * 32 + 16;
 	}
 
-	/* Write channel configuration to the DMA */
-	return d40_config_write(d40c);
+	/*
+	 * Only write channel configuration to the DMA if the physical
+	 * resource is free. In case of multiple logical channels
+	 * on the same physical resource, only the first write is necessary.
+	 */
+	if (is_free_phy)
+		return d40_config_write(d40c);
+	return 0;
 }
 
 static int d40_config_memcpy(struct d40_chan *d40c)
@@ -1691,7 +1697,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	unsigned long flags;
 	struct d40_chan *d40c =
 		container_of(chan, struct d40_chan, chan);
-
+	bool is_free_phy;
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	d40c->completed = chan->cookie = 1;
@@ -1705,6 +1711,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 		if (err)
 			goto err_alloc;
 	}
+	is_free_phy = (d40c->phy_chan == NULL);
 
 	err = d40_allocate_channel(d40c);
 	if (err) {
@@ -1713,7 +1720,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 		goto err_alloc;
 	}
 
-	err = d40_config_chan(d40c, &d40c->dma_cfg);
+	err = d40_config_chan(d40c, &d40c->dma_cfg, is_free_phy);
 	if (err) {
 		dev_err(&d40c->chan.dev->device,
 			"[%s] Failed to configure channel\n",
-- 
1.6.3.3

