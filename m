Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab2AQKfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:35:14 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:46612 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab2AQKfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:35:10 -0500
X-Greylist: delayed 655 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 05:35:10 EST
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <201201171023.q0HANwSE024485@gatekeeper.vosshq.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Tue, 17 Jan 2012 10:28:33 +0100
Subject: [PATCH] at_hdmac: bugfix for enabling channel irq
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 463894705e4089d0ff69e7d877312d496ac70e5b deleted redundant
chan_id and chancnt initialization in dma drivers as this is done
in dma_async_device_register().

However, atc_enable_irq() relied on chan_id set before registering
the device, what left only channel 0 functional for this driver.

This patch introduces atc_enable/disable_chan_irq() as a variant
of atc_enable/disable_irq() with the channel as explicit argument.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
 drivers/dma/at_hdmac.c      |    4 ++--
 drivers/dma/at_hdmac_regs.h |   17 ++++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index fcfa0a8..a60adbf 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1286,7 +1286,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 
 		tasklet_init(&atchan->tasklet, atc_tasklet,
 				(unsigned long)atchan);
-		atc_enable_irq(atchan);
+		atc_enable_chan_irq(atdma, i);
 	}
 
 	/* set base routines */
@@ -1353,7 +1353,7 @@ static int __exit at_dma_remove(struct platform_device *pdev)
 		struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 
 		/* Disable interrupts */
-		atc_disable_irq(atchan);
+		atc_disable_chan_irq(atdma, chan->chan_id);
 		tasklet_disable(&atchan->tasklet);
 
 		tasklet_kill(&atchan->tasklet);
diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index aa4c9ae..5aa82b4 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -326,28 +326,27 @@ static void atc_dump_lli(struct at_dma_chan *atchan, struct at_lli *lli)
 }
 
 
-static void atc_setup_irq(struct at_dma_chan *atchan, int on)
+static void atc_setup_irq(struct at_dma *atdma, int chan_id, int on)
 {
-	struct at_dma	*atdma = to_at_dma(atchan->chan_common.device);
-	u32		ebci;
+	u32 ebci;
 
 	/* enable interrupts on buffer transfer completion & error */
-	ebci =    AT_DMA_BTC(atchan->chan_common.chan_id)
-		| AT_DMA_ERR(atchan->chan_common.chan_id);
+	ebci =    AT_DMA_BTC(chan_id)
+		| AT_DMA_ERR(chan_id);
 	if (on)
 		dma_writel(atdma, EBCIER, ebci);
 	else
 		dma_writel(atdma, EBCIDR, ebci);
 }
 
-static inline void atc_enable_irq(struct at_dma_chan *atchan)
+static void atc_enable_chan_irq(struct at_dma *atdma, int chan_id)
 {
-	atc_setup_irq(atchan, 1);
+	atc_setup_irq(atdma, chan_id, 1);
 }
 
-static inline void atc_disable_irq(struct at_dma_chan *atchan)
+static void atc_disable_chan_irq(struct at_dma *atdma, int chan_id)
 {
-	atc_setup_irq(atchan, 0);
+	atc_setup_irq(atdma, chan_id, 0);
 }
 
 
-- 
1.7.5.4

