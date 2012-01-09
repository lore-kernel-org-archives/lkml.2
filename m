Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab2AIJdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:33:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46606 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2AIJdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:33:09 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Vinod Koul <vinod.koul@intel.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chris Ball <cjb@laptop.org>, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/4] dma: imx-dma: start transfer in issue_pending
Date: Mon,  9 Jan 2012 10:32:49 +0100
Message-Id: <1326101570-3716-4-git-send-email-s.hauer@pengutronix.de>
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
 drivers/dma/imx-dma.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 4be55f9..217207b 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -186,8 +186,6 @@ static dma_cookie_t imxdma_tx_submit(struct dma_async_tx_descriptor *tx)
 
 	cookie = imxdma_assign_cookie(imxdmac);
 
-	imx_dma_enable(imxdmac->imxdma_channel);
-
 	spin_unlock_irq(&imxdmac->lock);
 
 	return cookie;
@@ -332,9 +330,10 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 
 static void imxdma_issue_pending(struct dma_chan *chan)
 {
-	/*
-	 * Nothing to do. We only have a single descriptor
-	 */
+	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
+
+	if (imxdmac->status == DMA_IN_PROGRESS)
+		imx_dma_enable(imxdmac->imxdma_channel);
 }
 
 static int __init imxdma_probe(struct platform_device *pdev)
-- 
1.7.7.3

