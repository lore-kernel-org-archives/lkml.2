Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab2GKAV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:21:57 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:54638 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2GKAV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:21:56 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-209.messagelabs.com!1341966103!8326377!4
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 74/83] staging: comedi: rtd520: remove RtdDma0Control macro
Date: Tue, 10 Jul 2012 17:21:45 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101721.45774.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro uses the 'devpriv' macro which relies on a local variable
having a specific name. Plus it's just a wrapper around a simple
'writeb'. Remove the macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 39 +++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 7d12380..d92c682 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set control for DMA 0 (write only, shadow?) */
-#define RtdDma0Control(dev, n) \
-	writeb(devpriv->dma0Control = (n), devpriv->lcfg+LCFG_DMACSR0)
-
 /* Get status for DMA 0 */
 #define RtdDma0Status(dev) \
 	readb(devpriv->lcfg+LCFG_DMACSR0)
@@ -861,19 +857,19 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 				DPRINTK
 				    ("rtd520: comedi read buffer overflow (DMA) with %ld to go!\n",
 				     devpriv->aiCount);
-				RtdDma0Control(dev,
-					       (devpriv->dma0Control &
-						~PLX_DMA_START_BIT)
-					       | PLX_CLEAR_DMA_INTR_BIT);
+				devpriv->dma0Control &= ~PLX_DMA_START_BIT;
+				devpriv->dma0Control |= PLX_CLEAR_DMA_INTR_BIT;
+				writeb(devpriv->dma0Control,
+					devpriv->lcfg + LCFG_DMACSR0);
 				goto abortTransfer;
 			}
 
 			/*DPRINTK ("rtd520: DMA transfer: %ld to go, istatus %x\n",
 			   devpriv->aiCount, istatus); */
-			RtdDma0Control(dev,
-				       (devpriv->
-					dma0Control & ~PLX_DMA_START_BIT)
-				       | PLX_CLEAR_DMA_INTR_BIT);
+			devpriv->dma0Control &= ~PLX_DMA_START_BIT;
+			devpriv->dma0Control |= PLX_CLEAR_DMA_INTR_BIT;
+			writeb(devpriv->dma0Control,
+				devpriv->lcfg + LCFG_DMACSR0);
 			if (0 == devpriv->aiCount) {	/* counted down */
 				DPRINTK("rtd520: Samples Done (DMA).\n");
 				goto transferDone;
@@ -1239,8 +1235,11 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 			devpriv->lcfg + LCFG_ITCSR);
 		abort_dma(dev, 0);
 		devpriv->flags &= ~DMA0_ACTIVE;
-		if (readl(devpriv->lcfg + LCFG_ITCSR) & ICS_DMA0_A)
-			RtdDma0Control(dev, PLX_CLEAR_DMA_INTR_BIT);
+		if (readl(devpriv->lcfg + LCFG_ITCSR) & ICS_DMA0_A) {
+			devpriv->dma0Control = PLX_CLEAR_DMA_INTR_BIT;
+			writeb(devpriv->dma0Control,
+				devpriv->lcfg + LCFG_DMACSR0);
+		}
 	}
 	writel(0, devpriv->las0 + LAS0_DMA0_RESET);
 #endif /* USE_DMA */
@@ -1406,8 +1405,12 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		writel(readl(devpriv->lcfg + LCFG_ITCSR) | ICS_DMA0_E,
 			devpriv->lcfg + LCFG_ITCSR);
 		/* Must be 2 steps.  See PLX app note about "Starting a DMA transfer" */
-		RtdDma0Control(dev, PLX_DMA_EN_BIT);	/* enable DMA (clear INTR?) */
-		RtdDma0Control(dev, PLX_DMA_EN_BIT | PLX_DMA_START_BIT);	/*start DMA */
+		devpriv->dma0Control = PLX_DMA_EN_BIT;
+		writeb(devpriv->dma0Control,
+			devpriv->lcfg + LCFG_DMACSR0);
+		devpriv->dma0Control |= PLX_DMA_START_BIT;
+		writeb(devpriv->dma0Control,
+			devpriv->lcfg + LCFG_DMACSR0);
 		DPRINTK("rtd520: Using DMA0 transfers. plxInt %x RtdInt %x\n",
 			readl(devpriv->lcfg + LCFG_ITCSR), devpriv->intMask);
 #else /* USE_DMA */
@@ -1968,7 +1971,9 @@ static void rtd_detach(struct comedi_device *dev)
 		/* Shut down any board ops by resetting it */
 #ifdef USE_DMA
 		if (devpriv->lcfg) {
-			RtdDma0Control(dev, 0);	/* disable DMA */
+			devpriv->dma0Control = 0;
+			writeb(devpriv->dma0Control,
+				devpriv->lcfg + LCFG_DMACSR0);
 			RtdDma1Control(dev, 0);	/* disable DMA */
 			writel(ICS_PIE | ICS_PLIE, devpriv->lcfg + LCFG_ITCSR);
 		}
-- 
1.7.11

