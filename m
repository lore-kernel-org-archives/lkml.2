Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2GJXuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:50:18 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:48783 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2GJXuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:50:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1341964216!8244336!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/83] staging: comedi: rtd520: remove RtdAdcFifoGet macro
Date: Tue, 10 Jul 2012 16:50:12 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101650.12574.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index b76bb75..b37a281 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,11 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Read one ADC data value (12bit (with sign extend) as 16bit) */
-/* Note: matches what DMA would get.  Actual value >> 3 */
-#define RtdAdcFifoGet(dev) \
-	readw(devpriv->las1+LAS1_ADC_FIFO)
-
 /* Read two ADC data values (DOESN'T WORK) */
 #define RtdAdcFifoGet2(dev) \
 	readl(devpriv->las1+LAS1_ADC_FIFO)
@@ -834,7 +829,7 @@ static int rtd_ai_rinsn(struct comedi_device *dev,
 		}
 
 		/* read data */
-		d = RtdAdcFifoGet(dev);	/* get 2s comp value */
+		d = readw(devpriv->las1 + LAS1_ADC_FIFO);
 		/*printk ("rtd520: Got 0x%x after %d usec\n", d, ii+1); */
 		d = d >> 3;	/* low 3 bits are marker lines */
 		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, 0))
@@ -864,7 +859,7 @@ static int ai_read_n(struct comedi_device *dev, struct comedi_subdevice *s,
 		s16 d;
 
 		if (0 == devpriv->aiCount) {	/* done */
-			d = RtdAdcFifoGet(dev);	/* Read N and discard */
+			d = readw(devpriv->las1 + LAS1_ADC_FIFO);
 			continue;
 		}
 #if 0
@@ -874,7 +869,7 @@ static int ai_read_n(struct comedi_device *dev, struct comedi_subdevice *s,
 			break;
 		}
 #endif
-		d = RtdAdcFifoGet(dev);	/* get 2s comp value */
+		d = readw(devpriv->las1 + LAS1_ADC_FIFO);
 
 		d = d >> 3;	/* low 3 bits are marker lines */
 		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan)) {
@@ -899,7 +894,7 @@ static int ai_read_dregs(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	while (RtdFifoStatus(dev) & FS_ADC_NOT_EMPTY) {	/* 1 -> not empty */
 		short sample;
-		s16 d = RtdAdcFifoGet(dev);	/* get 2s comp value */
+		s16 d = readw(devpriv->las1 + LAS1_ADC_FIFO);
 
 		if (0 == devpriv->aiCount) {	/* done */
 			continue;	/* read rest */
-- 
1.7.11

