Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab0HIMIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:08:19 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:48728 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756326Ab0HIMIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:08:14 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 04/14] DMAENGINE: ste_dma40: Code clean-up and removed an unneeded suspend request
Date: Mon, 9 Aug 2010 14:08:02 +0200
Message-ID: <1281355682-13158-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

This patch cleans up some code and removes a suspend request that was pointless
since the hw was never configured nor running when it was called.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   46 ++++++++++++++++------------------------------
 1 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 538c35d..1adaebf 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -652,29 +652,10 @@ static u32 d40_chan_has_events(struct d40_chan *d40c)
 	return val;
 }
 
-static void d40_config_enable_lidx(struct d40_chan *d40c)
-{
-	/* Set LIDX for lcla */
-	writel((d40c->phy_chan->num << D40_SREG_ELEM_LOG_LIDX_POS) &
-	       D40_SREG_ELEM_LOG_LIDX_MASK,
-	       d40c->base->virtbase + D40_DREG_PCBASE +
-	       d40c->phy_chan->num * D40_DREG_PCDELTA + D40_CHAN_REG_SDELT);
-
-	writel((d40c->phy_chan->num << D40_SREG_ELEM_LOG_LIDX_POS) &
-	       D40_SREG_ELEM_LOG_LIDX_MASK,
-	       d40c->base->virtbase + D40_DREG_PCBASE +
-	       d40c->phy_chan->num * D40_DREG_PCDELTA + D40_CHAN_REG_SSELT);
-}
-
-static int d40_config_write(struct d40_chan *d40c)
+static void d40_config_write(struct d40_chan *d40c)
 {
 	u32 addr_base;
 	u32 var;
-	int res;
-
-	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
-	if (res)
-		return res;
 
 	/* Odd addresses are even addresses + 4 */
 	addr_base = (d40c->phy_chan->num % 2) * 4;
@@ -700,9 +681,20 @@ static int d40_config_write(struct d40_chan *d40c)
 		       d40c->phy_chan->num * D40_DREG_PCDELTA +
 		       D40_CHAN_REG_SDCFG);
 
-		d40_config_enable_lidx(d40c);
+		/* Set LIDX for lcla */
+		writel((d40c->phy_chan->num << D40_SREG_ELEM_LOG_LIDX_POS) &
+		       D40_SREG_ELEM_LOG_LIDX_MASK,
+		       d40c->base->virtbase + D40_DREG_PCBASE +
+		       d40c->phy_chan->num * D40_DREG_PCDELTA +
+		       D40_CHAN_REG_SDELT);
+
+		writel((d40c->phy_chan->num << D40_SREG_ELEM_LOG_LIDX_POS) &
+		       D40_SREG_ELEM_LOG_LIDX_MASK,
+		       d40c->base->virtbase + D40_DREG_PCBASE +
+		       d40c->phy_chan->num * D40_DREG_PCDELTA +
+		       D40_CHAN_REG_SSELT);
+
 	}
-	return res;
 }
 
 static void d40_desc_load(struct d40_chan *d40c, struct d40_desc *d40d)
@@ -1730,14 +1722,8 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	 * resource is free. In case of multiple logical channels
 	 * on the same physical resource, only the first write is necessary.
 	 */
-	if (is_free_phy) {
-		err = d40_config_write(d40c);
-		if (err) {
-			dev_err(&d40c->chan.dev->device,
-				"[%s] Failed to configure channel\n",
-				__func__);
-		}
-	}
+	if (is_free_phy)
+		d40_config_write(d40c);
 fail:
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return err;
-- 
1.6.3.3

