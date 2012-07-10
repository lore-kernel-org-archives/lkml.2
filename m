Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2GJX7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:59:54 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:7852 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab2GJX7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:59:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1341964791!12975222!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 36/83] staging: comedi: rtd520: remove RtdAboutCounter macro
Date: Tue, 10 Jul 2012 16:59:46 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101659.46959.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 9c0236b..87446ec 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* About counter, 16bit */
-#define RtdAboutCounter(dev, v) \
-	writel((v) & 0xffff, devpriv->las0+LAS0_ACNT)
-
 /* ADC sample counter, 10bit */
 #define RtdAdcSampleCount(dev) \
 	readl(devpriv->las0+LAS0_ADC_SCNT)
@@ -1418,7 +1414,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		writel(0, devpriv->las0 + LAS0_PACER_START);
 		writel(1, devpriv->las0 + LAS0_ADC_CONVERSION);
 	}
-	RtdAboutCounter(dev, devpriv->fifoLen / 2 - 1);	/* 1/2 FIFO */
+	writel((devpriv->fifoLen / 2 - 1) & 0xffff, devpriv->las0 + LAS0_ACNT);
 
 	if (TRIG_TIMER == cmd->scan_begin_src) {
 		/* scan_begin_arg is in nanoseconds */
@@ -1452,7 +1448,8 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 			devpriv->flags &= ~SEND_EOS;
 		} else {
 			/* interrupt for each transfer */
-			RtdAboutCounter(dev, devpriv->transCount - 1);
+			writel((devpriv->transCount - 1) & 0xffff,
+				devpriv->las0 + LAS0_ACNT);
 		}
 
 		DPRINTK
-- 
1.7.11

