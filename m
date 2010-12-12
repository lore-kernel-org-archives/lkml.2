Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab0LLXxB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:53:01 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36835 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab0LLXsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:31 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: peter.ujfalusi@nokia.com, jhnikula@gmail.com, ak@linux.intel.com,
        tony@atomide.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [203/223] OMAP3: DMA: Errata i541: sDMA FIFO draining does not finish
Message-Id: <20101212234829.EF11EB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>

commit 0e4905c0199d683497833be60a428c784d7575b8 upstream.

Implement the suggested workaround for OMAP3 regarding to sDMA draining
issue, when the channel is disabled on the fly.
This errata affects the following configuration:
sDMA transfer is source synchronized
Buffering is enabled
SmartStandby is selected.

The issue can be easily reproduced by creating overrun situation while
recording audio.
Either introduce load to the CPU:
nice -19 arecord -D hw:0 -M -B 10000 -F 5000 -f dat > /dev/null & \
dd if=/dev/urandom of=/dev/null

or suspending the arecord, and resuming it:
arecord -D hw:0 -M -B 10000 -F 5000 -f dat > /dev/null
CTRL+Z; fg; CTRL+Z; fg; ...

In case of overrun audio stops DMA, and restarts it (without reseting
the sDMA channel). When we hit this errata in stop case (sDMA drain did
not complete), at the coming start the sDMA will not going to be
operational (it is still draining).
This leads to DMA stall condition.
On OMAP3 we can recover with sDMA channel reset, it has been observed
that by introducing unrelated sDMA activity might also help (reading
from MMC for example).

The same errata exists for OMAP2, where the suggestion is to disable the
buffering to avoid this type of error.
On OMAP3 the suggestion is to set sDMA to NoStandby before disabling
the channel, and wait for the drain to finish, than configure sDMA to
SmartStandby again.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Acked-by: Jarkko Nikula <jhnikula@gmail.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by : Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by : Manjunath Kondaiah G <manjugk@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/plat-omap/dma.c              |   36 ++++++++++++++++++++++++++++++++--
 arch/arm/plat-omap/include/plat/dma.h |    3 ++
 2 files changed, 37 insertions(+), 2 deletions(-)

Index: linux/arch/arm/plat-omap/dma.c
===================================================================
--- linux.orig/arch/arm/plat-omap/dma.c
+++ linux/arch/arm/plat-omap/dma.c
@@ -30,6 +30,7 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 
 #include <asm/system.h>
 #include <mach/hardware.h>
@@ -1021,8 +1022,39 @@ void omap_stop_dma(int lch)
 		dma_write(0, CICR(lch));
 
 	l = dma_read(CCR(lch));
-	l &= ~OMAP_DMA_CCR_EN;
-	dma_write(l, CCR(lch));
+	/* OMAP3 Errata i541: sDMA FIFO draining does not finish */
+	if (cpu_is_omap34xx() && (l & OMAP_DMA_CCR_SEL_SRC_DST_SYNC)) {
+		int i = 0;
+		u32 sys_cf;
+
+		/* Configure No-Standby */
+		l = dma_read(OCP_SYSCONFIG);
+		sys_cf = l;
+		l &= ~DMA_SYSCONFIG_MIDLEMODE_MASK;
+		l |= DMA_SYSCONFIG_MIDLEMODE(DMA_IDLEMODE_NO_IDLE);
+		dma_write(l , OCP_SYSCONFIG);
+
+		l = dma_read(CCR(lch));
+		l &= ~OMAP_DMA_CCR_EN;
+		dma_write(l, CCR(lch));
+
+		/* Wait for sDMA FIFO drain */
+		l = dma_read(CCR(lch));
+		while (i < 100 && (l & (OMAP_DMA_CCR_RD_ACTIVE |
+					OMAP_DMA_CCR_WR_ACTIVE))) {
+			udelay(5);
+			i++;
+			l = dma_read(CCR(lch));
+		}
+		if (i >= 100)
+			printk(KERN_ERR "DMA drain did not complete on "
+					"lch %d\n", lch);
+		/* Restore OCP_SYSCONFIG */
+		dma_write(sys_cf, OCP_SYSCONFIG);
+	} else {
+		l &= ~OMAP_DMA_CCR_EN;
+		dma_write(l, CCR(lch));
+	}
 
 	if (!omap_dma_in_1510_mode() && dma_chan[lch].next_lch != -1) {
 		int next_lch, cur_lch = lch;
Index: linux/arch/arm/plat-omap/include/plat/dma.h
===================================================================
--- linux.orig/arch/arm/plat-omap/include/plat/dma.h
+++ linux/arch/arm/plat-omap/include/plat/dma.h
@@ -335,6 +335,9 @@
 #define OMAP2_DMA_MISALIGNED_ERR_IRQ	(1 << 11)
 
 #define OMAP_DMA_CCR_EN			(1 << 7)
+#define OMAP_DMA_CCR_RD_ACTIVE		(1 << 9)
+#define OMAP_DMA_CCR_WR_ACTIVE		(1 << 10)
+#define OMAP_DMA_CCR_SEL_SRC_DST_SYNC	(1 << 24)
 #define OMAP_DMA_CCR_BUFFERING_DISABLE	(1 << 25)
 
 #define OMAP_DMA_DATA_TYPE_S8		0x00
