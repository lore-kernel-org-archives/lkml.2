Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab2GJXzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:55:24 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:56278 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab2GJXzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:55:23 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1341964519!9288506!9
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 27/83] staging: comedi: rtd520: remove RtdInterruptOverrunStatus macro
Date: Tue, 10 Jul 2012 16:55:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101655.04827.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 07260cd..3c501ca 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Interrupt overrun status */
-#define RtdInterruptOverrunStatus(dev) \
-	readl(devpriv->las0+LAS0_OVERRUN)
-
 /* Interrupt overrun clear */
 #define RtdInterruptOverrunClear(dev) \
 	writel(0, devpriv->las0+LAS0_OVERRUN)
@@ -1013,9 +1009,10 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 				 void *d)
 {				/* our data *//* cpu context (ignored) */
 	struct comedi_device *dev = d;	/* must be called "dev" for devpriv */
+	struct comedi_subdevice *s = dev->subdevices + 0;	/* analog in subdevice */
+	u32 overrun;
 	u16 status;
 	u16 fifoStatus;
-	struct comedi_subdevice *s = dev->subdevices + 0;	/* analog in subdevice */
 
 	if (!dev->attached)
 		return IRQ_NONE;
@@ -1112,10 +1109,11 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 		DPRINTK("rtd520: unknown interrupt source!\n");
 	}
 
-	if (0xffff & RtdInterruptOverrunStatus(dev)) {	/* interrupt overrun */
+	overrun = readl(devpriv->las0 + LAS0_OVERRUN) & 0xffff;
+	if (overrun) {
 		DPRINTK
 		    ("rtd520: Interrupt overrun with %ld to go! over_status=0x%x\n",
-		     devpriv->aiCount, 0xffff & RtdInterruptOverrunStatus(dev));
+		     devpriv->aiCount, overrun);
 		goto abortTransfer;
 	}
 
@@ -1167,10 +1165,10 @@ transferDone:
 	readw(devpriv->las0 + LAS0_CLEAR);
 
 	fifoStatus = readl(devpriv->las0 + LAS0_ADC);
+	overrun = readl(devpriv->las0 + LAS0_OVERRUN) & 0xffff;
 	DPRINTK
 	    ("rtd520: Acquisition complete. %ld ints, intStat=%x, overStat=%x\n",
-	     devpriv->intCount, status,
-	     0xffff & RtdInterruptOverrunStatus(dev));
+	     devpriv->intCount, status, overrun);
 
 	return IRQ_HANDLED;
 }
@@ -1603,6 +1601,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 */
 static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	u32 overrun;
 	u16 status;
 
 	writel(0, devpriv->las0 + LAS0_PACER_STOP);
@@ -1620,10 +1619,10 @@ static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 	}
 #endif /* USE_DMA */
 	status = readw(devpriv->las0 + LAS0_IT);
+	overrun = readl(devpriv->las0 + LAS0_OVERRUN) & 0xffff;
 	DPRINTK
 	    ("rtd520: Acquisition canceled. %ld ints, intStat=%x, overStat=%x\n",
-	     devpriv->intCount, status,
-	     0xffff & RtdInterruptOverrunStatus(dev));
+	     devpriv->intCount, status, overrun);
 	return 0;
 }
 
-- 
1.7.11

