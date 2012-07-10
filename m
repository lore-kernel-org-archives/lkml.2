Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab2GJXwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:52:53 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:48206 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab2GJXwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:52:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-160.messagelabs.com!1341964370!6633954!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 23/83] staging: comedi: rtd520: remove RtdInterruptStatus macro
Date: Tue, 10 Jul 2012 16:52:45 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101652.46716.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 5fca77b..c3810ea 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Interrupt status */
-#define RtdInterruptStatus(dev) \
-	readw(devpriv->las0+LAS0_IT)
-
 /* Interrupt mask */
 #define RtdInterruptMask(dev, v) \
 	writew((devpriv->intMask = (v)), devpriv->las0+LAS0_IT)
@@ -1078,7 +1074,7 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 	/* Fall through and check for other interrupt sources */
 #endif /* USE_DMA */
 
-	status = RtdInterruptStatus(dev);
+	status = readw(devpriv->las0 + LAS0_IT);
 	/* if interrupt was not caused by our board, or handled above */
 	if (0 == status)
 		return IRQ_HANDLED;
@@ -1175,7 +1171,7 @@ transferDone:
 	comedi_event(dev, s);
 
 	/* clear the interrupt */
-	status = RtdInterruptStatus(dev);
+	status = readw(devpriv->las0 + LAS0_IT);
 	RtdInterruptClearMask(dev, status);
 	RtdInterruptClear(dev);
 
@@ -1627,7 +1623,7 @@ static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->flags &= ~DMA0_ACTIVE;
 	}
 #endif /* USE_DMA */
-	status = RtdInterruptStatus(dev);
+	status = readw(devpriv->las0 + LAS0_IT);
 	DPRINTK
 	    ("rtd520: Acquisition canceled. %ld ints, intStat=%x, overStat=%x\n",
 	     devpriv->intCount, status,
-- 
1.7.11

