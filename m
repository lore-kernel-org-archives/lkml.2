Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2GKAS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:18:56 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:6164 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2GKASz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:18:55 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-160.messagelabs.com!1341965934!9288382!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 68/83] staging: comedi: rtd520: remove RtdDma0Next macro
Date: Tue, 10 Jul 2012 17:18:48 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101718.48817.hartleys@visionengravers.com>
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
index c3400ea..5296723 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -406,10 +406,6 @@ struct rtdPrivate {
 
 /* Macros to access registers */
 
-/* Set next descriptor for DMA 0 */
-#define RtdDma0Next(dev, a) \
-	writel((a), devpriv->lcfg+LCFG_DMADPR0)
-
 /* Set  mode for DMA 1 */
 #define RtdDma1Mode(dev, m) \
 	writel((m), devpriv->lcfg+LCFG_DMAMODE1)
@@ -1423,8 +1419,9 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		/* point to first transfer in ring */
 		devpriv->dma0Offset = 0;
 		writel(DMA_MODE_BITS, devpriv->lcfg + LCFG_DMAMODE0);
-		RtdDma0Next(dev,	/* point to first block */
-			    devpriv->dma0Chain[DMA_CHAIN_COUNT - 1].next);
+		/* point to first block */
+		writel(devpriv->dma0Chain[DMA_CHAIN_COUNT - 1].next,
+			devpriv->lcfg + LCFG_DMADPR0);
 		writel(DMAS_ADFIFO_HALF_FULL, devpriv->las0 + LAS0_DMA0_SRC);
 		writel(readl(devpriv->lcfg + LCFG_ITCSR) | ICS_DMA0_E,
 			devpriv->lcfg + LCFG_ITCSR);
-- 
1.7.11

