Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0HIMH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:07:59 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:41306 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756304Ab0HIMH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:07:57 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 02/14] DMAENGINE: ste_dma40: Fix failed to restart logical channel bug
Date: Mon, 9 Aug 2010 14:07:44 +0200
Message-ID: <1281355664-13051-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

A transfer that runs in the different direction on the same
channel will now be resumed when the other is suspend/stopped.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index df2e1a3..8aff865 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -640,19 +640,15 @@ static void d40_config_set_event(struct d40_chan *d40c, bool do_enable)
 
 static u32 d40_chan_has_events(struct d40_chan *d40c)
 {
-	u32 val = 0;
+	u32 val;
 
-	/* If SSLNK or SDLNK is zero all events are disabled */
-	if ((d40c->dma_cfg.dir ==  STEDMA40_PERIPH_TO_MEM) ||
-	    (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_PERIPH))
-		val = readl(d40c->base->virtbase + D40_DREG_PCBASE +
-			    d40c->phy_chan->num * D40_DREG_PCDELTA +
-			    D40_CHAN_REG_SSLNK);
-
-	if (d40c->dma_cfg.dir !=  STEDMA40_PERIPH_TO_MEM)
-		val = readl(d40c->base->virtbase + D40_DREG_PCBASE +
-			    d40c->phy_chan->num * D40_DREG_PCDELTA +
-			    D40_CHAN_REG_SDLNK);
+	val = readl(d40c->base->virtbase + D40_DREG_PCBASE +
+		    d40c->phy_chan->num * D40_DREG_PCDELTA +
+		    D40_CHAN_REG_SSLNK);
+
+	val |= readl(d40c->base->virtbase + D40_DREG_PCBASE +
+		     d40c->phy_chan->num * D40_DREG_PCDELTA +
+		     D40_CHAN_REG_SDLNK);
 	return val;
 }
 
-- 
1.6.3.3

