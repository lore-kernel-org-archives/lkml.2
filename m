Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2GJXlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:41:49 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:3185 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab2GJXls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:41:48 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-160.messagelabs.com!1341963702!9244599!15
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/83] staging: comedi: rtd520: remove RtdEnableCGT macro
Date: Tue, 10 Jul 2012 16:41:29 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101641.29746.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/rtd520.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 781f081..550ebbd 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Reset channel gain table read and write pointers */
-#define RtdEnableCGT(dev, v) \
-	writel((v > 0) ? 1 : 0, devpriv->las0+LAS0_CGT_ENABLE)
-
 /* Write channel gain table entry */
 #define RtdWriteCGTable(dev, v) \
 	writel(v, devpriv->las0+LAS0_CGT_WRITE)
@@ -795,13 +791,13 @@ static void rtd_load_channelgain_list(struct comedi_device *dev,
 		int ii;
 
 		writel(0, devpriv->las0 + LAS0_CGT_CLEAR);
-		RtdEnableCGT(dev, 1);	/* enable table */
+		writel(1, devpriv->las0 + LAS0_CGT_ENABLE);
 		for (ii = 0; ii < n_chan; ii++) {
 			RtdWriteCGTable(dev, rtdConvertChanGain(dev, list[ii],
 								ii));
 		}
 	} else {		/* just use the channel gain latch */
-		RtdEnableCGT(dev, 0);	/* disable table, enable latch */
+		writel(0, devpriv->las0 + LAS0_CGT_ENABLE);
 		RtdWriteCGLatch(dev, rtdConvertChanGain(dev, list[0], 0));
 	}
 }
-- 
1.7.11

