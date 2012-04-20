Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab2DTOjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:39:21 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:34514 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754768Ab2DTOjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:39:20 -0400
From: Roland Stigge <stigge@antcom.de>
To: jic23@cam.ac.uk, gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RESEND v3] iio: Add device tree support to LPC32xx ADC
Date: Fri, 20 Apr 2012 16:38:33 +0200
Message-Id: <1334932713-19231-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support to the LPC32xx's ADC.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>

---

NOTE: I separated out this patch from the first patch series of the LPC32xx
device tree conversion because most of those patches are already applied to
-next and are basically unrelated. The LPC32xx devicetree conversion builds
upon this patch.

Applies to v3.4-rc3

 Documentation/devicetree/bindings/staging/iio/adc/lpc32xx-adc.txt |   16 ++++++++++
 drivers/staging/iio/adc/lpc32xx_adc.c                             |   10 ++++++
 2 files changed, 26 insertions(+)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/staging/iio/adc/lpc32xx-adc.txt
@@ -0,0 +1,16 @@
+* NXP LPC32xx SoC ADC controller
+
+Required properties:
+- compatible: must be "nxp,lpc32xx-adc"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: The ADC interrupt
+
+Example:
+
+	adc@40048000 {
+		compatible = "nxp,lpc32xx-adc";
+		reg = <0x40048000 0x1000>;
+		interrupt-parent = <&mic>;
+		interrupts = <39 0>;
+	};
--- linux-2.6.orig/drivers/staging/iio/adc/lpc32xx_adc.c
+++ linux-2.6/drivers/staging/iio/adc/lpc32xx_adc.c
@@ -30,6 +30,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/completion.h>
+#include <linux/of.h>
 
 #include "../iio.h"
 #include "../sysfs.h"
@@ -221,12 +222,21 @@ static int __devexit lpc32xx_adc_remove(
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id lpc32xx_adc_match[] = {
+	{ .compatible = "nxp,lpc32xx-adc" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, lpc32xx_adc_match);
+#endif
+
 static struct platform_driver lpc32xx_adc_driver = {
 	.probe		= lpc32xx_adc_probe,
 	.remove		= __devexit_p(lpc32xx_adc_remove),
 	.driver		= {
 		.name	= MOD_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(lpc32xx_adc_match),
 	},
 };
 
