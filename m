Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1HELoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 07:44:04 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:30034 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1HELoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 07:44:02 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] dmaengine: at_hdmac: fix way to specify cyclic capability
Date: Fri,  5 Aug 2011 12:43:44 +0100
Message-Id: <1312544624-8793-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this driver, we can trigger cyclic transfer on peripherals-DMA interfaces.
It is dependent on driver implementation but cannot depend on a platform
property: we remove the dma_has_cap(DMA_CYCLIC, ) test which has no meaning.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 6a483ea..e2a5f3e 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1293,15 +1293,13 @@ static int __init at_dma_probe(struct platform_device *pdev)
 	if (dma_has_cap(DMA_MEMCPY, atdma->dma_common.cap_mask))
 		atdma->dma_common.device_prep_dma_memcpy = atc_prep_dma_memcpy;
 
-	if (dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask))
+	if (dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)) {
 		atdma->dma_common.device_prep_slave_sg = atc_prep_slave_sg;
-
-	if (dma_has_cap(DMA_CYCLIC, atdma->dma_common.cap_mask))
+		/* controller can do slave DMA: can trigger cyclic transfers */
+		dma_cap_set(DMA_CYCLIC, atdma->dma_common.cap_mask);
 		atdma->dma_common.device_prep_dma_cyclic = atc_prep_dma_cyclic;
-
-	if (dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask) ||
-	    dma_has_cap(DMA_CYCLIC, atdma->dma_common.cap_mask))
 		atdma->dma_common.device_control = atc_control;
+	}
 
 	dma_writel(atdma, EN, AT_DMA_ENABLE);
 
-- 
1.7.4.1

