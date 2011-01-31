Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1AaP02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:26:28 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:41488 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab1AaPZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:25:59 -0500
From: Thomas Chou <thomas@wytron.com.tw>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH 3/3 v2] i2c-gpio: add devicetree support
Date: Mon, 31 Jan 2011 23:25:51 +0800
Message-Id: <1296487551-30938-3-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <AANLkTimS70uHqmv3jhr+7mPz4QFKXRXuFnWj8s3EpKsO@mail.gmail.com>
References: <AANLkTimS70uHqmv3jhr+7mPz4QFKXRXuFnWj8s3EpKsO@mail.gmail.com>
X-SA-Exim-Connect-IP: 192.168.1.250
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Albert Herranz <albert_herranz@yahoo.es>

This patch is based on an earlier patch from Albert Herranz,
http://git.infradead.org/users/herraa1/gc-linux-2.6.git/commit/
9854eb78607c641ab5ae85bcbe3c9d14ac113733

The dts binding is modified as Grant suggested. The of probing
is merged inline instead of a separate file. It uses the newer
of gpio probe.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
for v2.6.39
v2 move of nodes probing to a hook, which will be optimized out
     when devicetree is not used.
   use linux/gpio.h.
   move binding doc to i2c/i2c-gpio.txt.

 Documentation/devicetree/bindings/i2c/i2c-gpio.txt |   40 +++++++++++
 drivers/i2c/busses/i2c-gpio.c                      |   73 +++++++++++++++++++-
 2 files changed, 110 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-gpio.txt

diff --git a/Documentation/devicetree/bindings/i2c/i2c-gpio.txt b/Documentation/devicetree/bindings/i2c/i2c-gpio.txt
new file mode 100644
index 0000000..541fb10
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/i2c-gpio.txt
@@ -0,0 +1,40 @@
+GPIO-based I2C
+
+Required properties:
+- compatible : should be "i2c-gpio".
+- gpios : should specify GPIOs used for SDA and SCL lines, in that order.
+Optional properties:
+- sda-is-open-drain : present if SDA gpio is open-drain.
+- scl-is-open-drain : present if SCL gpio is open-drain.
+- scl-is-output-only : present if the output driver for SCL cannot be
+	turned off. this will prevent clock stretching from working.
+- udelay : signal toggle delay. SCL frequency is (500 / udelay) kHz
+- timeout : clock stretching timeout in milliseconds.
+
+Example:
+
+gpio0: starlet-gpio@0d8000c0 {
+	compatible = "nintendo,starlet-gpio";
+	reg = <0d8000c0 4>;
+	gpio-controller;
+	#gpio-cells = <2>;
+};
+
+i2c-video {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	compatible = "i2c-gpio";
+
+	gpios = <&gpio0 10 0	/* SDA line */
+		 &gpio0 11 0	/* SCL line */
+		>;
+	sda-is-open-drain;
+	scl-is-open-drain;
+	scl-is-output-only;
+	udelay = <2>;
+
+	audio-video-encoder {
+		compatible = "nintendo,wii-ave-rvl";
+		reg = <70>;
+	};
+};
diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index d9aa9a6..dbf5b85 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -14,8 +14,10 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
-
-#include <asm/gpio.h>
+#include <linux/gpio.h>
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
+#include <linux/of_i2c.h>
 
 /* Toggle SDA by changing the direction of the pin */
 static void i2c_gpio_setsda_dir(void *data, int state)
@@ -78,6 +80,53 @@ static int i2c_gpio_getscl(void *data)
 	return gpio_get_value(pdata->scl_pin);
 }
 
+/* Check if devicetree nodes exist and build platform data */
+static struct i2c_gpio_platform_data *i2c_gpio_of_probe(
+	struct platform_device *pdev)
+{
+	struct i2c_gpio_platform_data *pdata = NULL;
+	struct device_node *np = pdev->dev.of_node;
+
+	if (np && of_gpio_count(np) >= 2) {
+		const __be32 *prop;
+		int sda_pin, scl_pin;
+
+		sda_pin = of_get_gpio_flags(np, 0, NULL);
+		scl_pin = of_get_gpio_flags(np, 1, NULL);
+		if (sda_pin < 0 || scl_pin < 0) {
+			pr_err("%s: invalid GPIO pins, sda=%d/scl=%d\n",
+			       np->full_name, sda_pin, scl_pin);
+			goto err_gpio_pin;
+		}
+		pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+		if (!pdata)
+			goto err_alloc_pdata;
+		pdata->sda_pin = sda_pin;
+		pdata->scl_pin = scl_pin;
+		prop = of_get_property(np, "sda-is-open-drain", NULL);
+		if (prop)
+			pdata->sda_is_open_drain = 1;
+		prop = of_get_property(np, "scl-is-open-drain", NULL);
+		if (prop)
+			pdata->scl_is_open_drain = 1;
+		prop = of_get_property(np, "scl-is-output-only", NULL);
+		if (prop)
+			pdata->scl_is_output_only = 1;
+		prop = of_get_property(np, "udelay", NULL);
+		if (prop)
+			pdata->udelay = be32_to_cpup(prop);
+		prop = of_get_property(np, "timeout", NULL);
+		if (prop) {
+			pdata->timeout =
+				msecs_to_jiffies(be32_to_cpup(prop));
+		}
+	}
+
+err_gpio_pin:
+err_alloc_pdata:
+	return pdata;
+}
+
 static int __devinit i2c_gpio_probe(struct platform_device *pdev)
 {
 	struct i2c_gpio_platform_data *pdata;
@@ -87,6 +136,8 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
 
 	pdata = pdev->dev.platform_data;
 	if (!pdata)
+		pdata = i2c_gpio_of_probe(pdev);
+	if (!pdata)
 		return -ENXIO;
 
 	ret = -ENOMEM;
@@ -143,6 +194,7 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
 	adap->algo_data = bit_data;
 	adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
 	adap->dev.parent = &pdev->dev;
+	adap->dev.of_node = pdev->dev.of_node;
 
 	/*
 	 * If "dev->id" is negative we consider it as zero.
@@ -161,6 +213,9 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
 		 pdata->scl_is_output_only
 		 ? ", no clock stretching" : "");
 
+	/* Now register all the child nodes */
+	of_i2c_register_devices(adap);
+
 	return 0;
 
 err_add_bus:
@@ -172,6 +227,8 @@ err_request_sda:
 err_alloc_bit_data:
 	kfree(adap);
 err_alloc_adap:
+	if (!pdev->dev.platform_data)
+		kfree(pdata);
 	return ret;
 }
 
@@ -179,23 +236,33 @@ static int __devexit i2c_gpio_remove(struct platform_device *pdev)
 {
 	struct i2c_gpio_platform_data *pdata;
 	struct i2c_adapter *adap;
+	struct i2c_algo_bit_data *bit_data;
 
 	adap = platform_get_drvdata(pdev);
-	pdata = pdev->dev.platform_data;
+	bit_data = adap->algo_data;
+	pdata = bit_data->data;
 
 	i2c_del_adapter(adap);
 	gpio_free(pdata->scl_pin);
 	gpio_free(pdata->sda_pin);
 	kfree(adap->algo_data);
 	kfree(adap);
+	if (!pdev->dev.platform_data)
+		kfree(pdata);
 
 	return 0;
 }
 
+static const struct of_device_id i2c_gpio_match[] = {
+	{ .compatible = "i2c-gpio", },
+	{},
+};
+
 static struct platform_driver i2c_gpio_driver = {
 	.driver		= {
 		.name	= "i2c-gpio",
 		.owner	= THIS_MODULE,
+		.of_match_table = i2c_gpio_match,
 	},
 	.probe		= i2c_gpio_probe,
 	.remove		= __devexit_p(i2c_gpio_remove),
-- 
1.7.3.5

