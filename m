Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2GKAOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:14:05 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:33227 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2GKAOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:14:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-132.messagelabs.com!1341965640!13993295!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 63/83] staging: comedi: rtd520: remove RtdPlxInterruptWrite macro
Date: Tue, 10 Jul 2012 17:13:54 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101713.54726.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro uses the 'devpriv' macro which relies on a local variable
having a specific name. Plus it's just a wrapper around a simple
'writel'. Remove the macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 41 +++++++++++++++------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 486a7fc..202e1d8 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* PLX9080 interrupt mask and status */
-#define RtdPlxInterruptWrite(dev, v) \
-	writel(v, devpriv->lcfg+LCFG_ITCSR)
-
 /* Set  mode for DMA 0 */
 #define RtdDma0Mode(dev, m) \
 	writel((m), devpriv->lcfg+LCFG_DMAMODE0)
@@ -1008,8 +1004,8 @@ transferDone:
 	writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
 #ifdef USE_DMA
 	if (devpriv->flags & DMA0_ACTIVE) {
-		RtdPlxInterruptWrite(dev,
-			readl(devpriv->lcfg + LCFG_ITCSR) & ~ICS_DMA0_E);
+		writel(readl(devpriv->lcfg + LCFG_ITCSR) & ~ICS_DMA0_E,
+			devpriv->lcfg + LCFG_ITCSR);
 		abort_dma(dev, 0);
 		devpriv->flags &= ~DMA0_ACTIVE;
 		/* if Using DMA, then we should have read everything by now */
@@ -1279,8 +1275,8 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
 #ifdef USE_DMA
 	if (devpriv->flags & DMA0_ACTIVE) {	/* cancel anything running */
-		RtdPlxInterruptWrite(dev,
-			readl(devpriv->lcfg + LCFG_ITCSR) & ~ICS_DMA0_E);
+		writel(readl(devpriv->lcfg + LCFG_ITCSR) & ~ICS_DMA0_E,
+			devpriv->lcfg + LCFG_ITCSR);
 		abort_dma(dev, 0);
 		devpriv->flags &= ~DMA0_ACTIVE;
 		if (readl(devpriv->lcfg + LCFG_ITCSR) & ICS_DMA0_A)
@@ -1446,8 +1442,8 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		RtdDma0Next(dev,	/* point to first block */
 			    devpriv->dma0Chain[DMA_CHAIN_COUNT - 1].next);
 		writel(DMAS_ADFIFO_HALF_FULL, devpriv->las0 + LAS0_DMA0_SRC);
-		RtdPlxInterruptWrite(dev,
-			readl(devpriv->lcfg + LCFG_ITCSR) | ICS_DMA0_E);
+		writel(readl(devpriv->lcfg + LCFG_ITCSR) | ICS_DMA0_E,
+			devpriv->lcfg + LCFG_ITCSR);
 		/* Must be 2 steps.  See PLX app note about "Starting a DMA transfer" */
 		RtdDma0Control(dev, PLX_DMA_EN_BIT);	/* enable DMA (clear INTR?) */
 		RtdDma0Control(dev, PLX_DMA_EN_BIT | PLX_DMA_START_BIT);	/*start DMA */
@@ -1482,8 +1478,8 @@ static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->aiCount = 0;	/* stop and don't transfer any more */
 #ifdef USE_DMA
 	if (devpriv->flags & DMA0_ACTIVE) {
-		RtdPlxInterruptWrite(dev,
-			readl(devpriv->lcfg + LCFG_ITCSR) & ~ICS_DMA0_E);
+		writel(readl(devpriv->lcfg + LCFG_ITCSR) & ~ICS_DMA0_E,
+			devpriv->lcfg + LCFG_ITCSR);
 		abort_dma(dev, 0);
 		devpriv->flags &= ~DMA0_ACTIVE;
 	}
@@ -1832,7 +1828,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* also, initialize shadow registers */
 	writel(0, devpriv->las0 + LAS0_BOARD_RESET);
 	udelay(100);		/* needed? */
-	RtdPlxInterruptWrite(dev, 0);
+	writel(0, devpriv->lcfg + LCFG_ITCSR);
 	devpriv->intMask = 0;
 	writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
 	devpriv->intClearMask = ~0;
@@ -1947,9 +1943,8 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 #endif /* USE_DMA */
 
-	if (dev->irq) {		/* enable plx9080 interrupts */
-		RtdPlxInterruptWrite(dev, ICS_PIE | ICS_PLIE);
-	}
+	if (dev->irq)
+		writel(ICS_PIE | ICS_PLIE, devpriv->lcfg + LCFG_ITCSR);
 
 	printk("\ncomedi%d: rtd520 driver attached.\n", dev->minor);
 
@@ -1979,9 +1974,9 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif /* USE_DMA */
 	/* subdevices and priv are freed by the core */
 	if (dev->irq) {
-		RtdPlxInterruptWrite(dev,
-			readl(devpriv->lcfg + LCFG_ITCSR) &
-				~(ICS_PLIE | ICS_DMA0_E | ICS_DMA1_E));
+		writel(readl(devpriv->lcfg + LCFG_ITCSR) &
+			~(ICS_PLIE | ICS_DMA0_E | ICS_DMA1_E),
+			devpriv->lcfg + LCFG_ITCSR);
 		free_irq(dev->irq, dev);
 	}
 
@@ -2014,7 +2009,7 @@ static void rtd_detach(struct comedi_device *dev)
 		if (devpriv->lcfg) {
 			RtdDma0Control(dev, 0);	/* disable DMA */
 			RtdDma1Control(dev, 0);	/* disable DMA */
-			RtdPlxInterruptWrite(dev, ICS_PIE | ICS_PLIE);
+			writel(ICS_PIE | ICS_PLIE, devpriv->lcfg + LCFG_ITCSR);
 		}
 #endif /* USE_DMA */
 		if (devpriv->las0) {
@@ -2048,9 +2043,9 @@ static void rtd_detach(struct comedi_device *dev)
 		}
 #endif /* USE_DMA */
 		if (dev->irq) {
-			RtdPlxInterruptWrite(dev,
-				readl(devpriv->lcfg + LCFG_ITCSR) &
-					~(ICS_PLIE | ICS_DMA0_E | ICS_DMA1_E));
+			writel(readl(devpriv->lcfg + LCFG_ITCSR) &
+				~(ICS_PLIE | ICS_DMA0_E | ICS_DMA1_E),
+				devpriv->lcfg + LCFG_ITCSR);
 			free_irq(dev->irq, dev);
 		}
 		if (devpriv->las0)
-- 
1.7.11

