Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2GJXqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:46:04 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:11669 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab2GJXqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:46:01 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-127.messagelabs.com!1341963960!8239630!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/83] staging: comedi: rtd520: remove RtdPacerStopSource macro
Date: Tue, 10 Jul 2012 16:45:57 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101645.57710.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 0a92ae5..6636b26 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set Pacer stop source select (write only) */
-#define RtdPacerStopSource(dev, v) \
-	writel(v, devpriv->las0+LAS0_PACER_STOP)
-
 /* Set Pacer clock source select (write only) 0=external 1=internal */
 #define RtdPacerClockSource(dev, v) \
 	writel((v > 0) ? 1 : 0, devpriv->las0+LAS0_PACER_SELECT)
@@ -1194,7 +1190,7 @@ abortTransfer:
 	/* fall into transferDone */
 
 transferDone:
-	RtdPacerStopSource(dev, 0);	/* stop on SOFTWARE stop */
+	writel(0, devpriv->las0 + LAS0_PACER_STOP);
 	RtdPacerStop(dev);	/* Stop PACER */
 	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 	RtdInterruptMask(dev, 0);	/* mask out SAMPLE */
@@ -1463,7 +1459,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	int timer;
 
 	/* stop anything currently running */
-	RtdPacerStopSource(dev, 0);	/* stop on SOFTWARE stop */
+	writel(0, devpriv->las0 + LAS0_PACER_STOP);
 	RtdPacerStop(dev);	/* make sure PACER is stopped */
 	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 	RtdInterruptMask(dev, 0);
@@ -1661,7 +1657,7 @@ static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	u16 status;
 
-	RtdPacerStopSource(dev, 0);	/* stop on SOFTWARE stop */
+	writel(0, devpriv->las0 + LAS0_PACER_STOP);
 	RtdPacerStop(dev);	/* Stop PACER */
 	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 	RtdInterruptMask(dev, 0);
-- 
1.7.11

