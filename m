Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab2GJXlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:41:01 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:56463 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab2GJXlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:41:00 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1341963658!9287568!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/83] staging: comedi: rtd520: remove RtdClearCGT macro
Date: Tue, 10 Jul 2012 16:40:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101640.55682.hartleys@visionengravers.com>
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
index ff30253..781f081 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -407,10 +407,6 @@ struct rtdPrivate {
 /* Macros to access registers */
 
 /* Reset channel gain table read and write pointers */
-#define RtdClearCGT(dev) \
-	writel(0, devpriv->las0+LAS0_CGT_CLEAR)
-
-/* Reset channel gain table read and write pointers */
 #define RtdEnableCGT(dev, v) \
 	writel((v > 0) ? 1 : 0, devpriv->las0+LAS0_CGT_ENABLE)
 
@@ -797,7 +793,8 @@ static void rtd_load_channelgain_list(struct comedi_device *dev,
 {
 	if (n_chan > 1) {	/* setup channel gain table */
 		int ii;
-		RtdClearCGT(dev);
+
+		writel(0, devpriv->las0 + LAS0_CGT_CLEAR);
 		RtdEnableCGT(dev, 1);	/* enable table */
 		for (ii = 0; ii < n_chan; ii++) {
 			RtdWriteCGTable(dev, rtdConvertChanGain(dev, list[ii],
@@ -2049,7 +2046,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	RtdInterruptClearMask(dev, ~0);	/* and sets shadow */
 	RtdInterruptClear(dev);	/* clears bits set by mask */
 	RtdInterruptOverrunClear(dev);
-	RtdClearCGT(dev);
+	writel(0, devpriv->las0 + LAS0_CGT_CLEAR);
 	RtdAdcClearFifo(dev);
 	RtdDacClearFifo(dev, 0);
 	RtdDacClearFifo(dev, 1);
-- 
1.7.11

