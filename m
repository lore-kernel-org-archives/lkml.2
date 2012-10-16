Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab2JPPYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:24:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35839 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab2JPPYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:24:03 -0400
From: Sebastien Guiriec <s-guiriec@ti.com>
To: Sebastien Guiriec <s-guiriec@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Shubhrajyoti Datta <shubhrajyoti@ti.com>
Subject: [PATCH] i2c: omap: adopt pinctrl support
Date: Tue, 16 Oct 2012 17:23:20 +0200
Message-ID: <1350401000-9453-1-git-send-email-s-guiriec@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some GPIO expanders need some early pin control muxing. Due to
legacy boards sometimes the driver uses subsys_initcall instead of
module_init. This patch takes advantage of defer probe feature
and pin control in order to wait until pin control probing before
GPIO driver probing. It has been tested on OMAP5 board with TCA6424
driver.

log:

[0.482299] omap_i2c i2c.15: could not find pctldev for node /ocp/pinmux@4a00
2840/pinmux_i2c5_pins, deferring probe
[0.482330] platform i2c.15: Driver omap_i2c requests probe deferral
[0.484466] Advanced Linux Sound Architecture Driver Initialized.

[4.746917] omap_i2c i2c.15: bus 4 rev2.4.0 at 100 kHz
[4.755279] gpiochip_find_base: found new base at 477
[4.761169] gpiochip_add: registered GPIOs 477 to 500 on device: tca6424a

Signed-off-by: Sebastien Guiriec <s-guiriec@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index db31eae..661d8a2 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -44,6 +44,7 @@
 #include <linux/i2c-omap.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_qos.h>
+#include <linux/pinctrl/consumer.h>
 
 /* I2C controller revisions */
 #define OMAP_I2C_OMAP1_REV_2		0x20
@@ -213,6 +214,8 @@ struct omap_i2c_dev {
 	u16			syscstate;
 	u16			westate;
 	u16			errata;
+
+	struct pinctrl		*pins;
 };
 
 static const u8 reg_map_ip_v1[] = {
@@ -1107,6 +1110,16 @@ omap_i2c_probe(struct platform_device *pdev)
 		dev->dtrev = pdata->rev;
 	}
 
+	dev->pins = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(dev->pins)) {
+		if (PTR_ERR(dev->pins) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
+		dev_warn(&pdev->dev, "did not get pins for i2c error: %li\n",
+			 PTR_ERR(dev->pins));
+		dev->pins = NULL;
+	}
+
 	dev->dev = &pdev->dev;
 	dev->irq = irq;
 
-- 
1.7.10.4

