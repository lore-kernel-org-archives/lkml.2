Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1LMGcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:32:05 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:53406 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab1LMGcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:32:02 -0500
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <kernel@pengutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Li Yang <leoli@freescale.com>,
        Felipe Balbi <balbi@ti.com> (maintainer:USB GADGET/PERIPH...),
        linux-usb@vger.kernel.org (open list:FREESCALE USB PER...),
        linuxppc-dev@lists.ozlabs.org (open list:FREESCALE USB PER...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 01/19] mxc_udc: add workaround for ENGcm09152 for i.MX25
Date: Tue, 13 Dec 2011 07:31:33 +0100
Message-Id: <1323757911-25217-1-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.6.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch gives the possibility to workaround bug ENGcm09152
on i.MX25 when the hardware workaround is also implemented on
the board.
It covers the workaround described on page 42 of the following Errata :
http://cache.freescale.com/files/dsp/doc/errata/IMX25CE.pdf

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Li Yang <leoli@freescale.com>
---
 drivers/usb/gadget/fsl_mxc_udc.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/gadget/fsl_mxc_udc.c b/drivers/usb/gadget/fsl_mxc_udc.c
index dcbc0a2..4aff05d 100644
--- a/drivers/usb/gadget/fsl_mxc_udc.c
+++ b/drivers/usb/gadget/fsl_mxc_udc.c
@@ -23,7 +23,7 @@
 static struct clk *mxc_ahb_clk;
 static struct clk *mxc_usb_clk;
 
-/* workaround ENGcm09152 for i.MX35 */
+/* workaround ENGcm09152 for i.MX25/35 */
 #define USBPHYCTRL_OTGBASE_OFFSET	0x608
 #define USBPHYCTRL_EVDO			(1 << 23)
 
@@ -89,16 +89,20 @@ eenahb:
 void fsl_udc_clk_finalize(struct platform_device *pdev)
 {
 	struct fsl_usb2_platform_data *pdata = pdev->dev.platform_data;
-	if (cpu_is_mx35()) {
+	if (cpu_is_mx25() || cpu_is_mx35()) {
 		unsigned int v;
-
-		/* workaround ENGcm09152 for i.MX35 */
+		void __iomem *otgbase;
+		if (cpu_is_mx25())
+			otgbase = MX25_IO_ADDRESS(MX25_USB_BASE_ADDR +
+					USBPHYCTRL_OTGBASE_OFFSET);
+		else if (cpu_is_mx35())
+			otgbase = MX35_IO_ADDRESS(MX35_USB_BASE_ADDR +
+					USBPHYCTRL_OTGBASE_OFFSET);
+
+		/* workaround ENGcm09152 for i.MX25/35 */
 		if (pdata->workaround & FLS_USB2_WORKAROUND_ENGCM09152) {
-			v = readl(MX35_IO_ADDRESS(MX35_USB_BASE_ADDR +
-					USBPHYCTRL_OTGBASE_OFFSET));
-			writel(v | USBPHYCTRL_EVDO,
-				MX35_IO_ADDRESS(MX35_USB_BASE_ADDR +
-					USBPHYCTRL_OTGBASE_OFFSET));
+			v = readl(otgbase);
+			writel(v | USBPHYCTRL_EVDO, otgbase);
 		}
 	}
 
-- 
1.7.6.4

