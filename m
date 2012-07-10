Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab2GJXxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:53:53 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:7711 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab2GJXxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:53:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1341964425!8229835!5
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/83] staging: comedi: rtd520: remove RtdInterruptClear macro
Date: Tue, 10 Jul 2012 16:53:44 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101653.44921.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro uses the 'devpriv' macro which relies on a local variable
having a specific name. Plus it's just a wrapper around a simple
'readw'. Remove the macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 74ababc..591091c 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Interrupt status clear (only bits set in mask) */
-#define RtdInterruptClear(dev) \
-	readw(devpriv->las0+LAS0_CLEAR)
-
 /* Interrupt clear mask */
 #define RtdInterruptClearMask(dev, v) \
 	writew((devpriv->intClearMask = (v)), devpriv->las0+LAS0_CLEAR)
@@ -1129,7 +1125,7 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 
 	/* clear the interrupt */
 	RtdInterruptClearMask(dev, status);
-	RtdInterruptClear(dev);
+	readw(devpriv->las0 + LAS0_CLEAR);
 	return IRQ_HANDLED;
 
 abortTransfer:
@@ -1170,7 +1166,7 @@ transferDone:
 	/* clear the interrupt */
 	status = readw(devpriv->las0 + LAS0_IT);
 	RtdInterruptClearMask(dev, status);
-	RtdInterruptClear(dev);
+	readw(devpriv->las0 + LAS0_CLEAR);
 
 	fifoStatus = readl(devpriv->las0 + LAS0_ADC);
 	DPRINTK
@@ -1565,7 +1561,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	/* This doesn't seem to work.  There is no way to clear an interrupt
 	   that the priority controller has queued! */
 	RtdInterruptClearMask(dev, ~0);	/* clear any existing flags */
-	RtdInterruptClear(dev);
+	readw(devpriv->las0 + LAS0_CLEAR);
 
 	/* TODO: allow multiple interrupt sources */
 	if (devpriv->transCount > 0) {	/* transfer every N samples */
@@ -1968,7 +1964,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->intMask = 0;
 	writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
 	RtdInterruptClearMask(dev, ~0);	/* and sets shadow */
-	RtdInterruptClear(dev);	/* clears bits set by mask */
+	readw(devpriv->las0 + LAS0_CLEAR);
 	RtdInterruptOverrunClear(dev);
 	writel(0, devpriv->las0 + LAS0_CGT_CLEAR);
 	writel(0, devpriv->las0 + LAS0_ADC_FIFO_CLEAR);
@@ -2148,7 +2144,7 @@ static void rtd_detach(struct comedi_device *dev)
 			devpriv->intMask = 0;
 			writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
 			RtdInterruptClearMask(dev, ~0);
-			RtdInterruptClear(dev);	/* clears bits set by mask */
+			readw(devpriv->las0 + LAS0_CLEAR);
 		}
 #ifdef USE_DMA
 		/* release DMA */
-- 
1.7.11

