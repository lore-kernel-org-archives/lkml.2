Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2GKAC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:02:57 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:46318 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab2GKACz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:02:55 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1341964974!13980518!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 41/83] staging: comedi: rtd520: remove RtdUtcCtrlPut macro
Date: Tue, 10 Jul 2012 17:02:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101702.27374.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro uses the 'devpriv' macro which relies on a local variable
having a specific name. Plus it's just a wrapper around a simple
'writeb'. Remove the macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 21c9291..2201d11 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,11 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set UTC (8254) control byte  */
-#define RtdUtcCtrlPut(dev, n, v) \
-	writeb(devpriv->utcCtrl[(n) & 3] = (((n) & 3) << 6) | ((v) & 0x3f), \
-		devpriv->las0 + LAS0_UTC_CTRL)
-
 /* Set UTCn clock source (write only) */
 #define RtdUtcClockSource(dev, n, v) \
 	writew(v, devpriv->las0 \
@@ -1929,10 +1924,14 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	RtdDacClearFifo(dev, 1);
 	/* clear digital IO fifo */
 	RtdDioStatusWrite(dev, 0);	/* safe state, set shadow */
-	RtdUtcCtrlPut(dev, 0, 0x30);	/* safe state, set shadow */
-	RtdUtcCtrlPut(dev, 1, 0x30);	/* safe state, set shadow */
-	RtdUtcCtrlPut(dev, 2, 0x30);	/* safe state, set shadow */
-	RtdUtcCtrlPut(dev, 3, 0);	/* safe state, set shadow */
+	devpriv->utcCtrl[0] = (0 << 6) | 0x30;
+	devpriv->utcCtrl[1] = (1 << 6) | 0x30;
+	devpriv->utcCtrl[2] = (2 << 6) | 0x30;
+	devpriv->utcCtrl[3] = (3 << 6) | 0x00;
+	writeb(devpriv->utcCtrl[0], devpriv->las0 + LAS0_UTC_CTRL);
+	writeb(devpriv->utcCtrl[1], devpriv->las0 + LAS0_UTC_CTRL);
+	writeb(devpriv->utcCtrl[2], devpriv->las0 + LAS0_UTC_CTRL);
+	writeb(devpriv->utcCtrl[3], devpriv->las0 + LAS0_UTC_CTRL);
 	/* TODO: set user out source ??? */
 
 	/* check if our interrupt is available and get it */
-- 
1.7.11

