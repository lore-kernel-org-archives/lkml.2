Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab2DTTt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:49:29 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:36262 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757495Ab2DTTt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:49:28 -0400
From: Roland Stigge <stigge@antcom.de>
To: jic23@cam.ac.uk, gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v4] iio: Add device tree support to LPC32xx ADC
Date: Fri, 20 Apr 2012 21:48:26 +0200
Message-Id: <1334951307-1269-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support to the LPC32xx's ADC.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Applies to v3.4-rc3

Changes since v3:
* Changed "compatible" strings to non-wildcard versions

Thanks to Arnd Bergmann and Lars-Peter Clausen for reviewing!

 Documentation/devicetree/bindings/staging/iio/adc/lpc32xx-adc.txt |   17 ++++++++++
 drivers/staging/iio/adc/lpc32xx_adc.c                             |   13 +++++++
 2 files changed, 30 insertions(+)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/staging/iio/adc/lpc32xx-adc.txt
@@ -0,0 +1,17 @@
+* NXP LPC32xx SoC ADC controller
+
+Required properties:
+- compatible: must be "nxp,lpc3220-adc", "nxp,lpc3230-adc", "nxp,lpc3240-adc"
+  or "nxp,lpc3250-adc"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: The ADC interrupt
+
+Example:
+
+	adc@40048000 {
+		compatible = "nxp,lpc3250-adc";
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
@@ -221,12 +222,24 @@ static int __devexit lpc32xx_adc_remove(
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id lpc32xx_adc_match[] = {
+	{ .compatible = "nxp,lpc3220-adc" },
+	{ .compatible = "nxp,lpc3230-adc" },
+	{ .compatible = "nxp,lpc3240-adc" },
+	{ .compatible = "nxp,lpc3250-adc" },
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
 
