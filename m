Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab2GJXns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:43:48 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:11849 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab2GJXnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:43:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-160.messagelabs.com!1341963820!6633373!14
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/83] staging: comedi: rtd520: remove RtdAdcClearFifo macro
Date: Tue, 10 Jul 2012 16:43:32 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101643.33057.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 3a7c030..eb46b5b 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Reset ADC FIFO */
-#define RtdAdcClearFifo(dev) \
-	writel(0, devpriv->las0+LAS0_ADC_FIFO_CLEAR)
-
 /* Set ADC start conversion source select (write only) */
 #define RtdAdcConversionSource(dev, v) \
 	writel(v, devpriv->las0+LAS0_ADC_CONVERSION)
@@ -804,7 +800,7 @@ static int rtd520_probe_fifo_depth(struct comedi_device *dev)
 	static const unsigned limit = 0x2000;
 	unsigned fifo_size = 0;
 
-	RtdAdcClearFifo(dev);
+	writel(0, devpriv->las0 + LAS0_ADC_FIFO_CLEAR);
 	rtd_load_channelgain_list(dev, 1, &chanspec);
 	RtdAdcConversionSource(dev, 0);	/* software */
 	/* convert  samples */
@@ -824,7 +820,7 @@ static int rtd520_probe_fifo_depth(struct comedi_device *dev)
 		       DRV_NAME);
 		return -EIO;
 	}
-	RtdAdcClearFifo(dev);
+	writel(0, devpriv->las0 + LAS0_ADC_FIFO_CLEAR);
 	if (fifo_size != 0x400 && fifo_size != 0x2000) {
 		printk
 		    (KERN_INFO "\ncomedi: %s: unexpected fifo size of %i, expected 1024 or 8192.\n",
@@ -850,7 +846,7 @@ static int rtd_ai_rinsn(struct comedi_device *dev,
 	int stat;
 
 	/* clear any old fifo data */
-	RtdAdcClearFifo(dev);
+	writel(0, devpriv->las0 + LAS0_ADC_FIFO_CLEAR);
 
 	/* write channel to multiplexer and clear channel gain table */
 	rtd_load_channelgain_list(dev, 1, &insn->chanspec);
@@ -1204,7 +1200,7 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 	return IRQ_HANDLED;
 
 abortTransfer:
-	RtdAdcClearFifo(dev);	/* clears full flag */
+	writel(0, devpriv->las0 + LAS0_ADC_FIFO_CLEAR);
 	s->async->events |= COMEDI_CB_ERROR;
 	devpriv->aiCount = 0;	/* stop and don't transfer any more */
 	/* fall into transferDone */
@@ -1495,7 +1491,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	}
 	RtdDma0Reset(dev);	/* reset onboard state */
 #endif /* USE_DMA */
-	RtdAdcClearFifo(dev);	/* clear any old data */
+	writel(0, devpriv->las0 + LAS0_ADC_FIFO_CLEAR);
 	RtdInterruptOverrunClear(dev);
 	devpriv->intCount = 0;
 
@@ -2036,7 +2032,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	RtdInterruptClear(dev);	/* clears bits set by mask */
 	RtdInterruptOverrunClear(dev);
 	writel(0, devpriv->las0 + LAS0_CGT_CLEAR);
-	RtdAdcClearFifo(dev);
+	writel(0, devpriv->las0 + LAS0_ADC_FIFO_CLEAR);
 	RtdDacClearFifo(dev, 0);
 	RtdDacClearFifo(dev, 1);
 	/* clear digital IO fifo */
-- 
1.7.11

