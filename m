Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab2BJWl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:41:26 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760405Ab2BJWlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:41:16 -0500
MIME-Version: 1.0
Message-Id: <20120210222947.372369414@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nikolaus Voss <n.voss@weinmann.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [patch 26/86] at_hdmac: bugfix for enabling channel irq
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolaus Voss <n.voss@weinmann.de>

commit bda3a47c886664e86ee14eb79e9072b9e341f575 upstream.

commit 463894705e4089d0ff69e7d877312d496ac70e5b deleted redundant
chan_id and chancnt initialization in dma drivers as this is done
in dma_async_device_register().

However, atc_enable_irq() relied on chan_id set before registering
the device, what left only channel 0 functional for this driver.

This patch introduces atc_enable/disable_chan_irq() as a variant
of atc_enable/disable_irq() with the channel as explicit argument.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/at_hdmac.c      |    4 ++--
 drivers/dma/at_hdmac_regs.h |   17 ++++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1286,7 +1286,7 @@ static int __init at_dma_probe(struct pl
 
 		tasklet_init(&atchan->tasklet, atc_tasklet,
 				(unsigned long)atchan);
-		atc_enable_irq(atchan);
+		atc_enable_chan_irq(atdma, i);
 	}
 
 	/* set base routines */
@@ -1353,7 +1353,7 @@ static int __exit at_dma_remove(struct p
 		struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 
 		/* Disable interrupts */
-		atc_disable_irq(atchan);
+		atc_disable_chan_irq(atdma, chan->chan_id);
 		tasklet_disable(&atchan->tasklet);
 
 		tasklet_kill(&atchan->tasklet);
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -326,28 +326,27 @@ static void atc_dump_lli(struct at_dma_c
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
 
 


