Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293Ab2EDVSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:18:54 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759819Ab2EDUoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:44:37 -0400
Message-Id: <20120504204225.661768143@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [ 15/75] dmaengine: at_hdmac: remove clear-on-read in atc_dostart()
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/at_hdmac.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -241,10 +241,6 @@ static void atc_dostart(struct at_dma_ch
 
 	vdbg_dump_regs(atchan);
 
-	/* clear any pending interrupt */
-	while (dma_readl(atdma, EBCISR))
-		cpu_relax();
-
 	channel_writel(atchan, SADDR, 0);
 	channel_writel(atchan, DADDR, 0);
 	channel_writel(atchan, CTRLA, 0);


