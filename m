Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab2GJXoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:44:22 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:8650 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2GJXoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:44:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1341963847!9287775!12
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/83] staging: comedi: rtd520: remove RtdAdcConversionSource macro
Date: Tue, 10 Jul 2012 16:44:15 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101644.15702.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index eb46b5b..62748b9 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set ADC start conversion source select (write only) */
-#define RtdAdcConversionSource(dev, v) \
-	writel(v, devpriv->las0+LAS0_ADC_CONVERSION)
-
 /* Set burst start source select (write only) */
 #define RtdBurstStartSource(dev, v) \
 	writel(v, devpriv->las0+LAS0_BURST_START)
@@ -802,7 +798,7 @@ static int rtd520_probe_fifo_depth(struct comedi_device *dev)
 
 	writel(0, devpriv->las0 + LAS0_ADC_FIFO_CLEAR);
 	rtd_load_channelgain_list(dev, 1, &chanspec);
-	RtdAdcConversionSource(dev, 0);	/* software */
+	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 	/* convert  samples */
 	for (i = 0; i < limit; ++i) {
 		unsigned fifo_status;
@@ -852,7 +848,7 @@ static int rtd_ai_rinsn(struct comedi_device *dev,
 	rtd_load_channelgain_list(dev, 1, &insn->chanspec);
 
 	/* set conversion source */
-	RtdAdcConversionSource(dev, 0);	/* software */
+	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 
 	/* convert n samples */
 	for (n = 0; n < insn->n; n++) {
@@ -1208,7 +1204,7 @@ abortTransfer:
 transferDone:
 	RtdPacerStopSource(dev, 0);	/* stop on SOFTWARE stop */
 	RtdPacerStop(dev);	/* Stop PACER */
-	RtdAdcConversionSource(dev, 0);	/* software trigger only */
+	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 	RtdInterruptMask(dev, 0);	/* mask out SAMPLE */
 #ifdef USE_DMA
 	if (devpriv->flags & DMA0_ACTIVE) {
@@ -1477,7 +1473,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	/* stop anything currently running */
 	RtdPacerStopSource(dev, 0);	/* stop on SOFTWARE stop */
 	RtdPacerStop(dev);	/* make sure PACER is stopped */
-	RtdAdcConversionSource(dev, 0);	/* software trigger only */
+	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 	RtdInterruptMask(dev, 0);
 #ifdef USE_DMA
 	if (devpriv->flags & DMA0_ACTIVE) {	/* cancel anything running */
@@ -1509,11 +1505,11 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		/*DPRINTK ("rtd520: Multi channel setup\n"); */
 		RtdPacerStartSource(dev, 0);	/* software triggers pacer */
 		RtdBurstStartSource(dev, 1);	/* PACER triggers burst */
-		RtdAdcConversionSource(dev, 2);	/* BURST triggers ADC */
+		writel(2, devpriv->las0 + LAS0_ADC_CONVERSION);
 	} else {		/* single channel */
 		/*DPRINTK ("rtd520: single channel setup\n"); */
 		RtdPacerStartSource(dev, 0);	/* software triggers pacer */
-		RtdAdcConversionSource(dev, 1);	/* PACER triggers ADC */
+		writel(1, devpriv->las0 + LAS0_ADC_CONVERSION);
 	}
 	RtdAboutCounter(dev, devpriv->fifoLen / 2 - 1);	/* 1/2 FIFO */
 
@@ -1675,7 +1671,7 @@ static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	RtdPacerStopSource(dev, 0);	/* stop on SOFTWARE stop */
 	RtdPacerStop(dev);	/* Stop PACER */
-	RtdAdcConversionSource(dev, 0);	/* software trigger only */
+	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 	RtdInterruptMask(dev, 0);
 	devpriv->aiCount = 0;	/* stop and don't transfer any more */
 #ifdef USE_DMA
-- 
1.7.11

