Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab2EIGJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:09:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39025 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754951Ab2EIFxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:34 -0400
Message-Id: <20120509055043.572522896@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [ 100/167] [PATCH] dmaengine: at_hdmac: remove clear-on-read in atc_dostart()
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit ed8b0d67f33518a16c6b2450fe5ebebf180c2d04 upstream.

This loop on EBCISR register was designed to clear IRQ sources before enabling
a DMA channel. This register is clear-on-read so a race condition can appear if
another channel is already active and has just finished its transfer.
Removing this read on EBCISR is fixing the issue as there is no case where an IRQ
could be pending: we already make sure that this register is drained at probe()
time and during resume.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/dma/at_hdmac.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 7aa58d2..445fdf8 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -221,10 +221,6 @@ static void atc_dostart(struct at_dma_chan *atchan, struct at_desc *first)
 
 	vdbg_dump_regs(atchan);
 
-	/* clear any pending interrupt */
-	while (dma_readl(atdma, EBCISR))
-		cpu_relax();
-
 	channel_writel(atchan, SADDR, 0);
 	channel_writel(atchan, DADDR, 0);
 	channel_writel(atchan, CTRLA, 0);
-- 
1.7.10



