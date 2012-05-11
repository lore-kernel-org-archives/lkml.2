Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214Ab2EKGaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:30:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:30228 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758371Ab2EKGaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:30:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141755921"
Subject: [PATCH] dmaengine: fix cyclic dma usage
From: Vinod Koul <vinod.koul@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: rmk <rmk@arm.linux.org.uk>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 May 2012 11:54:09 +0530
Message-ID: <1336717449.15424.1585.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 24db9e25a31ac46327253f11908463c48518dec8 Mon Sep 17 00:00:00 2001
From: Vinod Koul <vinod.koul@linux.intel.com>
Date: Fri, 11 May 2012 11:48:21 +0530
Subject: [PATCH] dmaengine: fix cyclic dma usage

for cyclic dma, dont mark the descriptor as complete.
Fix the remaining users of cyclic dma which do so

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
---
Looking for tested by for these two
---
 drivers/dma/at_hdmac.c   |    4 +++-
 drivers/dma/ep93xx_dma.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 445fdf8..bf0d7e4 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -245,7 +245,9 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	dev_vdbg(chan2dev(&atchan->chan_common),
 		"descriptor %u complete\n", txd->cookie);
 
-	dma_cookie_complete(txd);
+	/* mark the descriptor as complete for non cyclic cases only */
+	if (!atc_chan_is_cyclic(atchan))
+		dma_cookie_complete(txd);
 
 	/* move children to free_list */
 	list_splice_init(&desc->tx_list, &atchan->free_list);
diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index e6f133b..f6e9b57 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -703,7 +703,9 @@ static void ep93xx_dma_tasklet(unsigned long data)
 	desc = ep93xx_dma_get_active(edmac);
 	if (desc) {
 		if (desc->complete) {
-			dma_cookie_complete(&desc->txd);
+			/* mark descriptor complete for non cyclic case only */
+			if (!test_bit(EP93XX_DMA_IS_CYCLIC, &edmac->flags))
+				dma_cookie_complete(&desc->txd);
 			list_splice_init(&edmac->active, &list);
 		}
 		callback = desc->txd.callback;
-- 
1.7.0.4


-- 
~Vinod

