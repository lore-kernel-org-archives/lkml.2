Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2GKAN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:13:28 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:5623 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2GKAN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:13:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1341965605!13975398!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 62/83] staging: comedi: rtd520: remove RtdPlxInterruptRead macro
Date: Tue, 10 Jul 2012 17:13:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101713.21958.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro uses the 'devpriv' macro which relies on a local variable
having a specific name. Plus it's just a wrapper around a simple
'readl'. Remove the macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 38 +++++++++++++++------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 6d3e4d3..486a7fc 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -407,8 +407,6 @@ struct rtdPrivate {
 /* Macros to access registers */
 
 /* PLX9080 interrupt mask and status */
-#define RtdPlxInterruptRead(dev) \
-	readl(devpriv->lcfg+LCFG_ITCSR)
 #define RtdPlxInterruptWrite(dev, v) \
 	writel(v, devpriv->lcfg+LCFG_ITCSR)
 
@@ -900,7 +898,7 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 	}
 #ifdef USE_DMA
 	if (devpriv->flags & DMA0_ACTIVE) {	/* Check DMA */
-		u32 istatus = RtdPlxInterruptRead(dev);
+		u32 istatus = readl(devpriv->lcfg + LCFG_ITCSR);
 
 		if (istatus & ICS_DMA0_A) {
 			if (ai_process_dma(dev, s) < 0) {
@@ -1010,8 +1008,8 @@ transferDone:
 	writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
 #ifdef USE_DMA
 	if (devpriv->flags & DMA0_ACTIVE) {
-		RtdPlxInterruptWrite(dev,	/* disable any more interrupts */
-				     RtdPlxInterruptRead(dev) & ~ICS_DMA0_E);
+		RtdPlxInterruptWrite(dev,
+			readl(devpriv->lcfg + LCFG_ITCSR) & ~ICS_DMA0_E);
 		abort_dma(dev, 0);
 		devpriv->flags &= ~DMA0_ACTIVE;
 		/* if Using DMA, then we should have read everything by now */
@@ -1281,13 +1279,12 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
 #ifdef USE_DMA
 	if (devpriv->flags & DMA0_ACTIVE) {	/* cancel anything running */
-		RtdPlxInterruptWrite(dev,	/* disable any more interrupts */
-				     RtdPlxInterruptRead(dev) & ~ICS_DMA0_E);
+		RtdPlxInterruptWrite(dev,
+			readl(devpriv->lcfg + LCFG_ITCSR) & ~ICS_DMA0_E);
 		abort_dma(dev, 0);
 		devpriv->flags &= ~DMA0_ACTIVE;
-		if (RtdPlxInterruptRead(dev) & ICS_DMA0_A) {	/*clear pending int */
+		if (readl(devpriv->lcfg + LCFG_ITCSR) & ICS_DMA0_A)
 			RtdDma0Control(dev, PLX_CLEAR_DMA_INTR_BIT);
-		}
 	}
 	writel(0, devpriv->las0 + LAS0_DMA0_RESET);
 #endif /* USE_DMA */
@@ -1449,14 +1446,13 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		RtdDma0Next(dev,	/* point to first block */
 			    devpriv->dma0Chain[DMA_CHAIN_COUNT - 1].next);
 		writel(DMAS_ADFIFO_HALF_FULL, devpriv->las0 + LAS0_DMA0_SRC);
-
-		RtdPlxInterruptWrite(dev,	/* enable interrupt */
-				     RtdPlxInterruptRead(dev) | ICS_DMA0_E);
+		RtdPlxInterruptWrite(dev,
+			readl(devpriv->lcfg + LCFG_ITCSR) | ICS_DMA0_E);
 		/* Must be 2 steps.  See PLX app note about "Starting a DMA transfer" */
 		RtdDma0Control(dev, PLX_DMA_EN_BIT);	/* enable DMA (clear INTR?) */
 		RtdDma0Control(dev, PLX_DMA_EN_BIT | PLX_DMA_START_BIT);	/*start DMA */
 		DPRINTK("rtd520: Using DMA0 transfers. plxInt %x RtdInt %x\n",
-			RtdPlxInterruptRead(dev), devpriv->intMask);
+			readl(devpriv->lcfg + LCFG_ITCSR), devpriv->intMask);
 #else /* USE_DMA */
 		devpriv->intMask = IRQM_ADC_ABOUT_CNT;
 		writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
@@ -1486,8 +1482,8 @@ static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->aiCount = 0;	/* stop and don't transfer any more */
 #ifdef USE_DMA
 	if (devpriv->flags & DMA0_ACTIVE) {
-		RtdPlxInterruptWrite(dev,	/* disable any more interrupts */
-				     RtdPlxInterruptRead(dev) & ~ICS_DMA0_E);
+		RtdPlxInterruptWrite(dev,
+			readl(devpriv->lcfg + LCFG_ITCSR) & ~ICS_DMA0_E);
 		abort_dma(dev, 0);
 		devpriv->flags &= ~DMA0_ACTIVE;
 	}
@@ -1983,9 +1979,9 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif /* USE_DMA */
 	/* subdevices and priv are freed by the core */
 	if (dev->irq) {
-		/* disable interrupt controller */
-		RtdPlxInterruptWrite(dev, RtdPlxInterruptRead(dev)
-				     & ~(ICS_PLIE | ICS_DMA0_E | ICS_DMA1_E));
+		RtdPlxInterruptWrite(dev,
+			readl(devpriv->lcfg + LCFG_ITCSR) &
+				~(ICS_PLIE | ICS_DMA0_E | ICS_DMA1_E));
 		free_irq(dev->irq, dev);
 	}
 
@@ -2052,9 +2048,9 @@ static void rtd_detach(struct comedi_device *dev)
 		}
 #endif /* USE_DMA */
 		if (dev->irq) {
-			RtdPlxInterruptWrite(dev, RtdPlxInterruptRead(dev)
-					     & ~(ICS_PLIE | ICS_DMA0_E |
-						 ICS_DMA1_E));
+			RtdPlxInterruptWrite(dev,
+				readl(devpriv->lcfg + LCFG_ITCSR) &
+					~(ICS_PLIE | ICS_DMA0_E | ICS_DMA1_E));
 			free_irq(dev->irq, dev);
 		}
 		if (devpriv->las0)
-- 
1.7.11

