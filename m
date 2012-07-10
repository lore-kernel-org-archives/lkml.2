Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2GJXvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:51:22 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:57813 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2GJXvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:51:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1341964279!9274217!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/83] staging: comedi: rtd520: remove RtdFifoStatus macro
Date: Tue, 10 Jul 2012 16:51:16 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101651.16362.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 8e9265d..3b44776 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* FIFO status */
-#define RtdFifoStatus(dev) \
-	readl(devpriv->las0+LAS0_ADC)
-
 /* pacer start/stop read=start, write=stop*/
 #define RtdPacerStart(dev) \
 	readl(devpriv->las0+LAS0_PACER)
@@ -760,7 +756,7 @@ static int rtd520_probe_fifo_depth(struct comedi_device *dev)
 		/* trigger conversion */
 		writew(0, devpriv->las0 + LAS0_ADC);
 		udelay(1);
-		fifo_status = RtdFifoStatus(dev);
+		fifo_status = readl(devpriv->las0 + LAS0_ADC);
 		if ((fifo_status & FS_ADC_HEMPTY) == 0) {
 			fifo_size = 2 * i;
 			break;
@@ -812,7 +808,7 @@ static int rtd_ai_rinsn(struct comedi_device *dev,
 		writew(0, devpriv->las0 + LAS0_ADC);
 
 		for (ii = 0; ii < RTD_ADC_TIMEOUT; ++ii) {
-			stat = RtdFifoStatus(dev);
+			stat = readl(devpriv->las0 + LAS0_ADC);
 			if (stat & FS_ADC_NOT_EMPTY)	/* 1 -> not empty */
 				break;
 			WAIT_QUIETLY;
@@ -859,7 +855,7 @@ static int ai_read_n(struct comedi_device *dev, struct comedi_subdevice *s,
 			continue;
 		}
 #if 0
-		if (0 == (RtdFifoStatus(dev) & FS_ADC_NOT_EMPTY)) {	/* DEBUG */
+		if (!(readl(devpriv->las0 + LAS0_ADC) & FS_ADC_NOT_EMPTY)) {
 			DPRINTK("comedi: READ OOPS on %d of %d\n", ii + 1,
 				count);
 			break;
@@ -888,7 +884,7 @@ static int ai_read_n(struct comedi_device *dev, struct comedi_subdevice *s,
 */
 static int ai_read_dregs(struct comedi_device *dev, struct comedi_subdevice *s)
 {
-	while (RtdFifoStatus(dev) & FS_ADC_NOT_EMPTY) {	/* 1 -> not empty */
+	while (readl(devpriv->las0 + LAS0_ADC) & FS_ADC_NOT_EMPTY) {
 		short sample;
 		s16 d = readw(devpriv->las1 + LAS1_ADC_FIFO);
 
@@ -1048,7 +1044,7 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 
 	devpriv->intCount++;	/* DEBUG statistics */
 
-	fifoStatus = RtdFifoStatus(dev);
+	fifoStatus = readl(devpriv->las0 + LAS0_ADC);
 	/* check for FIFO full, this automatically halts the ADC! */
 	if (!(fifoStatus & FS_ADC_NOT_FULL)) {	/* 0 -> full */
 		DPRINTK("rtd520: FIFO full! fifo_status=0x%x\n", (fifoStatus ^ 0x6666) & 0x7777);	/* should be all 0s */
@@ -1176,7 +1172,7 @@ transferDone:
 #endif /* USE_DMA */
 
 	if (devpriv->aiCount > 0) {	/* there shouldn't be anything left */
-		fifoStatus = RtdFifoStatus(dev);
+		fifoStatus = readl(devpriv->las0 + LAS0_ADC);
 		DPRINTK("rtd520: Finishing up. %ld remain, fifoStat=%x\n", devpriv->aiCount, (fifoStatus ^ 0x6666) & 0x7777);	/* should read all 0s */
 		ai_read_dregs(dev, s);	/* read anything left in FIFO */
 	}
@@ -1189,7 +1185,7 @@ transferDone:
 	RtdInterruptClearMask(dev, status);
 	RtdInterruptClear(dev);
 
-	fifoStatus = RtdFifoStatus(dev);	/* DEBUG */
+	fifoStatus = readl(devpriv->las0 + LAS0_ADC);
 	DPRINTK
 	    ("rtd520: Acquisition complete. %ld ints, intStat=%x, overStat=%x\n",
 	     devpriv->intCount, status,
@@ -1687,7 +1683,7 @@ static int rtd_ao_winsn(struct comedi_device *dev,
 		devpriv->aoValue[chan] = data[i];	/* save for read back */
 
 		for (ii = 0; ii < RTD_DAC_TIMEOUT; ++ii) {
-			stat = RtdFifoStatus(dev);
+			stat = readl(devpriv->las0 + LAS0_ADC);
 			/* 1 -> not empty */
 			if (stat & ((0 == chan) ? FS_DAC1_NOT_EMPTY :
 				    FS_DAC2_NOT_EMPTY))
-- 
1.7.11

