Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab2GJXyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:54:22 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:62293 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab2GJXyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:54:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-131.messagelabs.com!1341964459!24739326!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 26/83] staging: comedi: rtd520: remove RtdInterruptClearMask macro
Date: Tue, 10 Jul 2012 16:54:15 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101654.16243.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 591091c..07260cd 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Interrupt clear mask */
-#define RtdInterruptClearMask(dev, v) \
-	writew((devpriv->intClearMask = (v)), devpriv->las0+LAS0_CLEAR)
-
 /* Interrupt overrun status */
 #define RtdInterruptOverrunStatus(dev) \
 	readl(devpriv->las0+LAS0_OVERRUN)
@@ -1124,7 +1120,8 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 	}
 
 	/* clear the interrupt */
-	RtdInterruptClearMask(dev, status);
+	devpriv->intClearMask = status;
+	writew(devpriv->intClearMask, devpriv->las0 + LAS0_CLEAR);
 	readw(devpriv->las0 + LAS0_CLEAR);
 	return IRQ_HANDLED;
 
@@ -1165,7 +1162,8 @@ transferDone:
 
 	/* clear the interrupt */
 	status = readw(devpriv->las0 + LAS0_IT);
-	RtdInterruptClearMask(dev, status);
+	devpriv->intClearMask = status;
+	writew(devpriv->intClearMask, devpriv->las0 + LAS0_CLEAR);
 	readw(devpriv->las0 + LAS0_CLEAR);
 
 	fifoStatus = readl(devpriv->las0 + LAS0_ADC);
@@ -1560,7 +1558,8 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	/* This doesn't seem to work.  There is no way to clear an interrupt
 	   that the priority controller has queued! */
-	RtdInterruptClearMask(dev, ~0);	/* clear any existing flags */
+	devpriv->intClearMask = ~0;
+	writew(devpriv->intClearMask, devpriv->las0 + LAS0_CLEAR);
 	readw(devpriv->las0 + LAS0_CLEAR);
 
 	/* TODO: allow multiple interrupt sources */
@@ -1963,7 +1962,8 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	RtdPlxInterruptWrite(dev, 0);
 	devpriv->intMask = 0;
 	writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
-	RtdInterruptClearMask(dev, ~0);	/* and sets shadow */
+	devpriv->intClearMask = ~0;
+	writew(devpriv->intClearMask, devpriv->las0 + LAS0_CLEAR);
 	readw(devpriv->las0 + LAS0_CLEAR);
 	RtdInterruptOverrunClear(dev);
 	writel(0, devpriv->las0 + LAS0_CGT_CLEAR);
@@ -2143,7 +2143,9 @@ static void rtd_detach(struct comedi_device *dev)
 			writel(0, devpriv->las0 + LAS0_BOARD_RESET);
 			devpriv->intMask = 0;
 			writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
-			RtdInterruptClearMask(dev, ~0);
+			devpriv->intClearMask = ~0;
+			writew(devpriv->intClearMask,
+				devpriv->las0 + LAS0_CLEAR);
 			readw(devpriv->las0 + LAS0_CLEAR);
 		}
 #ifdef USE_DMA
-- 
1.7.11

