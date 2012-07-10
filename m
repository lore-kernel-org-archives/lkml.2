Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab2GJXx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:53:28 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:63271 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab2GJXx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:53:27 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-209.messagelabs.com!1341964406!8332353!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/83] staging: comedi: rtd520: remove RtdInterruptMask macro
Date: Tue, 10 Jul 2012 16:53:15 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101653.15783.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro uses the 'devpriv' macro which relies on a local variable
having a specific name. Plus it's just a wrapper around a simple
'writew'. Remove the macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index c3810ea..74ababc 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Interrupt mask */
-#define RtdInterruptMask(dev, v) \
-	writew((devpriv->intMask = (v)), devpriv->las0+LAS0_IT)
-
 /* Interrupt status clear (only bits set in mask) */
 #define RtdInterruptClear(dev) \
 	readw(devpriv->las0+LAS0_CLEAR)
@@ -1146,7 +1142,8 @@ transferDone:
 	writel(0, devpriv->las0 + LAS0_PACER_STOP);
 	writel(0, devpriv->las0 + LAS0_PACER);
 	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
-	RtdInterruptMask(dev, 0);	/* mask out SAMPLE */
+	devpriv->intMask = 0;
+	writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
 #ifdef USE_DMA
 	if (devpriv->flags & DMA0_ACTIVE) {
 		RtdPlxInterruptWrite(dev,	/* disable any more interrupts */
@@ -1415,7 +1412,8 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	writel(0, devpriv->las0 + LAS0_PACER_STOP);
 	writel(0, devpriv->las0 + LAS0_PACER);
 	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
-	RtdInterruptMask(dev, 0);
+	devpriv->intMask = 0;
+	writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
 #ifdef USE_DMA
 	if (devpriv->flags & DMA0_ACTIVE) {	/* cancel anything running */
 		RtdPlxInterruptWrite(dev,	/* disable any more interrupts */
@@ -1571,7 +1569,8 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	/* TODO: allow multiple interrupt sources */
 	if (devpriv->transCount > 0) {	/* transfer every N samples */
-		RtdInterruptMask(dev, IRQM_ADC_ABOUT_CNT);
+		devpriv->intMask = IRQM_ADC_ABOUT_CNT;
+		writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
 		DPRINTK("rtd520: Transferring every %d\n", devpriv->transCount);
 	} else {		/* 1/2 FIFO transfers */
 #ifdef USE_DMA
@@ -1592,7 +1591,8 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		DPRINTK("rtd520: Using DMA0 transfers. plxInt %x RtdInt %x\n",
 			RtdPlxInterruptRead(dev), devpriv->intMask);
 #else /* USE_DMA */
-		RtdInterruptMask(dev, IRQM_ADC_ABOUT_CNT);
+		devpriv->intMask = IRQM_ADC_ABOUT_CNT;
+		writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
 		DPRINTK("rtd520: Transferring every 1/2 FIFO\n");
 #endif /* USE_DMA */
 	}
@@ -1613,7 +1613,8 @@ static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 	writel(0, devpriv->las0 + LAS0_PACER_STOP);
 	writel(0, devpriv->las0 + LAS0_PACER);
 	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
-	RtdInterruptMask(dev, 0);
+	devpriv->intMask = 0;
+	writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
 	devpriv->aiCount = 0;	/* stop and don't transfer any more */
 #ifdef USE_DMA
 	if (devpriv->flags & DMA0_ACTIVE) {
@@ -1964,7 +1965,8 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	writel(0, devpriv->las0 + LAS0_BOARD_RESET);
 	udelay(100);		/* needed? */
 	RtdPlxInterruptWrite(dev, 0);
-	RtdInterruptMask(dev, 0);	/* and sets shadow */
+	devpriv->intMask = 0;
+	writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
 	RtdInterruptClearMask(dev, ~0);	/* and sets shadow */
 	RtdInterruptClear(dev);	/* clears bits set by mask */
 	RtdInterruptOverrunClear(dev);
@@ -2143,7 +2145,8 @@ static void rtd_detach(struct comedi_device *dev)
 #endif /* USE_DMA */
 		if (devpriv->las0) {
 			writel(0, devpriv->las0 + LAS0_BOARD_RESET);
-			RtdInterruptMask(dev, 0);
+			devpriv->intMask = 0;
+			writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
 			RtdInterruptClearMask(dev, ~0);
 			RtdInterruptClear(dev);	/* clears bits set by mask */
 		}
-- 
1.7.11

