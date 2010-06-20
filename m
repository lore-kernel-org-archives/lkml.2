Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0FTVZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:25:27 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:51528 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753340Ab0FTVZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:25:10 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: [PATCH 02/19] DMAENGINE: ste_dma40: only write phy channel config first time
Date: Sun, 20 Jun 2010 23:24:52 +0200
Message-ID: <1277069092-30684-1-git-send-email-linus.walleij@stericsson.com>
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
 drivers/dma/ste_dma40.c    |   64 ++++++++++++++++++++++----------------------
 drivers/dma/ste_dma40_ll.h |    3 ++
 2 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 4618d6c..9655452 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1210,30 +1210,6 @@ out:
 
 }
 
-static int d40_config_chan(struct d40_chan *d40c,
-			   struct stedma40_chan_cfg *info)
-{
-
-	/* Fill in basic CFG register values */
-	d40_phy_cfg(&d40c->dma_cfg, &d40c->src_def_cfg,
-		    &d40c->dst_def_cfg, d40c->log_num != D40_PHY_CHAN);
-
-	if (d40c->log_num != D40_PHY_CHAN) {
-		d40_log_cfg(&d40c->dma_cfg,
-			    &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
-
-		if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
-			d40c->lcpa = d40c->base->lcpa_base +
-				d40c->dma_cfg.src_dev_type * 32;
-		else
-			d40c->lcpa = d40c->base->lcpa_base +
-				d40c->dma_cfg.dst_dev_type * 32 + 16;
-	}
-
-	/* Write channel configuration to the DMA */
-	return d40_config_write(d40c);
-}
-
 static int d40_config_memcpy(struct d40_chan *d40c)
 {
 	dma_cap_mask_t cap = d40c->chan.device->cap_mask;
@@ -1691,20 +1667,21 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	unsigned long flags;
 	struct d40_chan *d40c =
 		container_of(chan, struct d40_chan, chan);
-
+	bool is_free_phy;
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	d40c->completed = chan->cookie = 1;
 
 	/*
 	 * If no dma configuration is set (channel_type == 0)
-	 * use default configuration
+	 * use default configuration (memcpy)
 	 */
 	if (d40c->dma_cfg.channel_type == 0) {
 		err = d40_config_memcpy(d40c);
 		if (err)
 			goto err_alloc;
 	}
+	is_free_phy = (d40c->phy_chan == NULL);
 
 	err = d40_allocate_channel(d40c);
 	if (err) {
@@ -1713,12 +1690,35 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 		goto err_alloc;
 	}
 
-	err = d40_config_chan(d40c, &d40c->dma_cfg);
-	if (err) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Failed to configure channel\n",
-			__func__);
-		goto err_config;
+	/* Fill in basic CFG register values */
+	d40_phy_cfg(&d40c->dma_cfg, &d40c->src_def_cfg,
+		    &d40c->dst_def_cfg, d40c->log_num != D40_PHY_CHAN);
+
+	if (d40c->log_num != D40_PHY_CHAN) {
+		d40_log_cfg(&d40c->dma_cfg,
+			    &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
+
+		if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
+			d40c->lcpa = d40c->base->lcpa_base +
+			  d40c->dma_cfg.src_dev_type * D40_LCPA_CHAN_SIZE;
+		else
+			d40c->lcpa = d40c->base->lcpa_base +
+			  d40c->dma_cfg.dst_dev_type *
+			  D40_LCPA_CHAN_SIZE + D40_LCPA_CHAN_DST_DELTA;
+	}
+
+	/*
+	 * Only write channel configuration to the DMA if the physical
+	 * resource is free. In case of multiple logical channels
+	 * on the same physical resource, only the first write is necessary.
+	 */
+	if (is_free_phy) {
+		err = d40_config_write(d40c);
+		if (err) {
+			dev_err(&d40c->chan.dev->device,
+				"[%s] Failed to configure channel\n",
+				__func__);
+		}
 	}
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 2029280..c081f28 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -13,6 +13,9 @@
 #define D40_DREG_PCDELTA	(8 * 4)
 #define D40_LLI_ALIGN		16 /* LLI alignment must be 16 bytes. */
 
+#define D40_LCPA_CHAN_SIZE 32
+#define D40_LCPA_CHAN_DST_DELTA 16
+
 #define D40_TYPE_TO_GROUP(type) (type / 16)
 #define D40_TYPE_TO_EVENT(type) (type % 16)
 
-- 
1.6.3.3

