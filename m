Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0EJSqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:46:34 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:40850 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab0EJSqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:46:30 -0400
From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, bryan.wu@canonical.com,
       amit.kucheria@canonical.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv3 2.6.34-rc7 1/3] mxc: gadget: remove 60mhz clock requirement for freescale mx51 usb core
Date: Mon, 10 May 2010 13:45:57 -0500
Message-Id: <1273517159-25173-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

renamed fsl_mx3_udc.c -> fsl_mxc_udc.c
for mx51, usb core is clocked from sources that are not 60mhz.

This patch applies to 2.6.34-rc7.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 drivers/usb/gadget/Makefile                        |    2 +-
 .../usb/gadget/{fsl_mx3_udc.c => fsl_mxc_udc.c}    |   14 ++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)
 rename drivers/usb/gadget/{fsl_mx3_udc.c => fsl_mxc_udc.c} (89%)

diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index 43b51da..c922eef 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_USB_ATMEL_USBA)	+= atmel_usba_udc.o
 obj-$(CONFIG_USB_FSL_USB2)	+= fsl_usb2_udc.o
 fsl_usb2_udc-objs		:= fsl_udc_core.o
 ifeq ($(CONFIG_ARCH_MXC),y)
-fsl_usb2_udc-objs		+= fsl_mx3_udc.o
+fsl_usb2_udc-objs		+= fsl_mxc_udc.o
 endif
 obj-$(CONFIG_USB_M66592)	+= m66592-udc.o
 obj-$(CONFIG_USB_R8A66597)	+= r8a66597-udc.o
diff --git a/drivers/usb/gadget/fsl_mx3_udc.c b/drivers/usb/gadget/fsl_mxc_udc.c
similarity index 89%
rename from drivers/usb/gadget/fsl_mx3_udc.c
rename to drivers/usb/gadget/fsl_mxc_udc.c
index 20a802e..d0b8bde 100644
--- a/drivers/usb/gadget/fsl_mx3_udc.c
+++ b/drivers/usb/gadget/fsl_mxc_udc.c
@@ -50,12 +50,14 @@ int fsl_udc_clk_init(struct platform_device *pdev)
 		goto egusb;
 	}
 
-	freq = clk_get_rate(mxc_usb_clk);
-	if (pdata->phy_mode != FSL_USB2_PHY_ULPI &&
-	    (freq < 59999000 || freq > 60001000)) {
-		dev_err(&pdev->dev, "USB_CLK=%lu, should be 60MHz\n", freq);
-		ret = -EINVAL;
-		goto eclkrate;
+	if (!cpu_is_mx51()) {
+		freq = clk_get_rate(mxc_usb_clk);
+		if (pdata->phy_mode != FSL_USB2_PHY_ULPI &&
+		    (freq < 59999000 || freq > 60001000)) {
+			dev_err(&pdev->dev, "USB_CLK=%lu, should be 60MHz\n", freq);
+			ret = -EINVAL;
+			goto eclkrate;
+		}
 	}
 
 	ret = clk_enable(mxc_usb_clk);
-- 
1.6.0.4

