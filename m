Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab2AIJda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:33:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46634 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2AIJd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:33:27 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Vinod Koul <vinod.koul@intel.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chris Ball <cjb@laptop.org>, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 4/4] dma: imx-sdma: start transfer in issue_pending
Date: Mon,  9 Jan 2012 10:32:50 +0100
Message-Id: <1326101570-3716-5-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1326101570-3716-1-git-send-email-s.hauer@pengutronix.de>
References: <1326101570-3716-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA API requires that transfers are started in issue_pending
instead of tx_submit. Fix this.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/dma/imx-sdma.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index f993955..eb28bb0 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -833,15 +833,12 @@ static struct sdma_channel *to_sdma_chan(struct dma_chan *chan)
 static dma_cookie_t sdma_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct sdma_channel *sdmac = to_sdma_chan(tx->chan);
-	struct sdma_engine *sdma = sdmac->sdma;
 	dma_cookie_t cookie;
 
 	spin_lock_irq(&sdmac->lock);
 
 	cookie = sdma_assign_cookie(sdmac);
 
-	sdma_enable_channel(sdma, sdmac->channel);
-
 	spin_unlock_irq(&sdmac->lock);
 
 	return cookie;
@@ -1126,9 +1123,11 @@ static enum dma_status sdma_tx_status(struct dma_chan *chan,
 
 static void sdma_issue_pending(struct dma_chan *chan)
 {
-	/*
-	 * Nothing to do. We only have a single descriptor
-	 */
+	struct sdma_channel *sdmac = to_sdma_chan(chan);
+	struct sdma_engine *sdma = sdmac->sdma;
+
+	if (sdmac->status == DMA_IN_PROGRESS)
+		sdma_enable_channel(sdma, sdmac->channel);
 }
 
 #define SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1	34
-- 
1.7.7.3

