Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab2GKAJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:09:29 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:52543 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab2GKAJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:09:28 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1341965366!8296463!5
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 53/83] staging: comedi: rtd520: remove RtdDacFifoPut macro
Date: Tue, 10 Jul 2012 17:08:59 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101708.59949.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index e7c550f..8ba7877 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,13 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Digital to Analog converter */
-/* Write one data value (sign + 12bit + marker bits) */
-/* Note: matches what DMA would put.  Actual value << 3 */
-#define RtdDacFifoPut(dev, n, v) \
-	writew((v), devpriv->las1 + (((n) == 0) ? LAS1_DAC1_FIFO : \
-				LAS1_DAC2_FIFO))
-
 /* Start single DAC conversion */
 #define RtdDacUpdate(dev, n) \
 	writew(0, devpriv->las0 + (((n) == 0) ? LAS0_DAC1 : LAS0_DAC2))
@@ -1577,7 +1570,8 @@ static int rtd_ao_winsn(struct comedi_device *dev,
 		     chan, range, data[i], val);
 
 		/* a typical programming sequence */
-		RtdDacFifoPut(dev, chan, val);	/* put the value in */
+		writew(val, devpriv->las1 +
+			((chan == 0) ? LAS1_DAC1_FIFO : LAS1_DAC2_FIFO));
 		RtdDacUpdate(dev, chan);	/* trigger the conversion */
 
 		devpriv->aoValue[chan] = data[i];	/* save for read back */
-- 
1.7.11

