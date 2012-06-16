Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab2FPOLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 10:11:21 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:57673 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756668Ab2FPOLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 10:11:20 -0400
From: Roland Stigge <stigge@antcom.de>
To: riku.voipio@iki.fi, bryan.wu@canonical.com, rpurdie@rpsys.net,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] leds: Add DT support for leds-pca9532
Date: Sat, 16 Jun 2012 16:10:51 +0200
Message-Id: <1339855851-9171-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT support for leds-pca9532.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 Documentation/devicetree/bindings/leds/leds-pca9532.txt |   43 ++++++++++++++
 drivers/leds/leds-pca9532.c                             |   47 ++++++++++++++++
 2 files changed, 90 insertions(+)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/leds/leds-pca9532.txt
@@ -0,0 +1,43 @@
+NXP PCA9532 LED (incl. GPIO) controller
+
+Required properties:
+- compatible: must be "nxp,pca9532"
+- reg: I2C address
+- gpio-controller: Marks the device node as a GPIO controller.
+- #gpio-cells: Should be 2:
+   1) pin number
+   2) optional parameters:
+      - bit 0 specifies polarity (0 for normal, 1 for inverted)
+- nxp,typecodes: groups of 2 bits for each of the 16 pins:
+  0: None
+  1: LED
+  2: Beep
+  3: GPIO
+- nxp,statecodes: groups of 2 bits for each of the 16 pins:
+  0: off
+  1: on
+  2: pwm0
+  3: pwm1
+
+Optional properties:
+- nxp,psc: array of 2 numbers: PSC values for the two PWM channels (see datasheet)
+- nxp,pwm: array of 2 numbers: PWM values for the two PWM channels (see datasheet)
+
+Example:
+
+	pca9532: pca9532@60 {
+		compatible = "nxp,pca9532";
+		gpio-controller;
+		#gpio-cells = <2>;
+		nxp,typecodes = <0xffffffff>;
+		nxp,statecodes = <0x00000000>;
+		reg = <0x60>;
+	};
+
+	sd@20098000 {
+		wp-gpios = <&pca9532 5 0>;
+		cd-gpios = <&pca9532 4 0>;
+		cd-inverted;
+		bus-width = <4>;
+		status = "okay";
+	};
--- linux-2.6.orig/drivers/leds/leds-pca9532.c
+++ linux-2.6/drivers/leds/leds-pca9532.c
@@ -21,6 +21,7 @@
 #include <linux/workqueue.h>
 #include <linux/leds-pca9532.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
 
 /* m =  num_leds*/
 #define PCA9532_REG_INPUT(i)	((i) >> 3)
@@ -444,6 +445,47 @@ exit:
 	return err;
 }
 
+#ifdef CONFIG_OF
+static struct pca9532_platform_data *pca9532_parse_dt(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct pca9532_platform_data *pca9532_pdata;
+	u32 typecodes, statecodes;
+	u32 pwm[2];
+	u32 psc[2];
+	int i;
+
+	pca9532_pdata = devm_kzalloc(dev, sizeof(*pca9532_pdata), GFP_KERNEL);
+	if (!pca9532_pdata) {
+		dev_err(dev, "could not allocate memory for platform data\n");
+		return NULL;
+	}
+
+	if (!of_property_read_u32(np, "nxp,typecodes", &typecodes)) {
+		for (i = 0; i < 16; i++)
+			pca9532_pdata->leds[i].type =
+				(typecodes >> (2 * i)) & 0x3;
+	}
+	if (!of_property_read_u32(np, "nxp,statecodes", &statecodes)) {
+		for (i = 0; i < 16; i++)
+			pca9532_pdata->leds[i].state =
+				(statecodes >> (2 * i)) & 0x3;
+	}
+	if (!of_property_read_u32_array(np, "nxp,pwm", &pwm[0], 2)) {
+		for (i = 0; i < 2; i++)
+			pca9532_pdata->pwm[i] = pwm[i];
+	}
+	if (!of_property_read_u32_array(np, "nxp,psc", &psc[0], 2)) {
+		for (i = 0; i < 2; i++)
+			pca9532_pdata->psc[i] = psc[i];
+	}
+
+	pca9532_pdata->gpio_base = -1; /* dynamically assign gpio base */
+
+	return pca9532_pdata;
+}
+#endif
+
 static int pca9532_probe(struct i2c_client *client,
 	const struct i2c_device_id *id)
 {
@@ -451,6 +493,11 @@ static int pca9532_probe(struct i2c_clie
 	struct pca9532_platform_data *pca9532_pdata = client->dev.platform_data;
 	int err;
 
+#ifdef CONFIG_OF
+	if (!pca9532_pdata && client->dev.of_node)
+		pca9532_pdata = pca9532_parse_dt(&client->dev);
+#endif
+
 	if (!pca9532_pdata)
 		return -EIO;
 
