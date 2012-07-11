Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab2GKAHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:07:32 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:42949 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab2GKAHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:07:30 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1341965247!13974082!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 50/83] staging: comedi: rtd520: remove RtdDioStatusWrite macro
Date: Tue, 10 Jul 2012 17:07:23 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101707.24253.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index b7e1322..bcf15ae 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,9 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-#define RtdDioStatusWrite(dev, v) \
-	writew((devpriv->dioStatus = (v)), devpriv->las0+LAS0_DIO_STATUS)
-
 #define RtdDio0CtrlRead(dev) \
 	(readw(devpriv->las0+LAS0_DIO0_CTRL) & 0xff)
 #define RtdDio0CtrlWrite(dev, v) \
@@ -1689,9 +1686,11 @@ static int rtd_dio_insn_config(struct comedi_device *dev,
 
 	DPRINTK("rtd520: port_0_direction=0x%x (1 means out)\n", s->io_bits);
 	/* TODO support digital match interrupts and strobes */
-	RtdDioStatusWrite(dev, 0x01);	/* make Dio0Ctrl point to direction */
+	devpriv->dioStatus = 0x01;	/* set direction */
+	writew(devpriv->dioStatus, devpriv->las0 + LAS0_DIO_STATUS);
 	RtdDio0CtrlWrite(dev, s->io_bits);	/* set direction 1 means Out */
-	RtdDioStatusWrite(dev, 0);	/* make Dio0Ctrl clear interrupts */
+	devpriv->dioStatus = 0x00;	/* clear interrupts */
+	writew(devpriv->dioStatus, devpriv->las0 + LAS0_DIO_STATUS);
 
 	/* port1 can only be all input or all output */
 
@@ -1893,7 +1892,8 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	RtdDacClearFifo(dev, 0);
 	RtdDacClearFifo(dev, 1);
 	/* clear digital IO fifo */
-	RtdDioStatusWrite(dev, 0);	/* safe state, set shadow */
+	devpriv->dioStatus = 0;
+	writew(devpriv->dioStatus, devpriv->las0 + LAS0_DIO_STATUS);
 	devpriv->utcCtrl[0] = (0 << 6) | 0x30;
 	devpriv->utcCtrl[1] = (1 << 6) | 0x30;
 	devpriv->utcCtrl[2] = (2 << 6) | 0x30;
-- 
1.7.11

