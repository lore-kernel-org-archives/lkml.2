Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab2GJXpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:45:32 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:11049 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab2GJXpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:45:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1341963904!8306894!16
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/83] staging: comedi: rtd520: remove RtdPacerStartSource macro
Date: Tue, 10 Jul 2012 16:45:22 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101645.22880.hartleys@visionengravers.com>
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
index 26bdcab..0a92ae5 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set Pacer start source select (write only) */
-#define RtdPacerStartSource(dev, v) \
-	writel(v, devpriv->las0+LAS0_PACER_START)
-
 /* Set Pacer stop source select (write only) */
 #define RtdPacerStopSource(dev, v) \
 	writel(v, devpriv->las0+LAS0_PACER_STOP)
@@ -1499,12 +1495,12 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	/* setup the common case and override if needed */
 	if (cmd->chanlist_len > 1) {
 		/*DPRINTK ("rtd520: Multi channel setup\n"); */
-		RtdPacerStartSource(dev, 0);	/* software triggers pacer */
+		writel(0, devpriv->las0 + LAS0_PACER_START);
 		writel(1, devpriv->las0 + LAS0_BURST_START);
 		writel(2, devpriv->las0 + LAS0_ADC_CONVERSION);
 	} else {		/* single channel */
 		/*DPRINTK ("rtd520: single channel setup\n"); */
-		RtdPacerStartSource(dev, 0);	/* software triggers pacer */
+		writel(0, devpriv->las0 + LAS0_PACER_START);
 		writel(1, devpriv->las0 + LAS0_ADC_CONVERSION);
 	}
 	RtdAboutCounter(dev, devpriv->fifoLen / 2 - 1);	/* 1/2 FIFO */
@@ -1588,7 +1584,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		break;
 
 	case TRIG_EXT:
-		RtdPacerStartSource(dev, 1);	/* EXTERNALy trigger pacer */
+		writel(1, devpriv->las0 + LAS0_PACER_START);
 		break;
 
 	default:
-- 
1.7.11

