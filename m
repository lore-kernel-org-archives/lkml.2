Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1BJC0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:26:53 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:59402 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1BJC0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:26:51 -0500
From: Thomas Chou <thomas@wytron.com.tw>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH v4] i2c-gpio: add devicetree support
Date: Thu, 10 Feb 2011 10:29:27 +0800
Message-Id: <1297304967-3759-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <20110203180707.GE6180@angua.secretlab.ca>
References: <20110203180707.GE6180@angua.secretlab.ca>
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds devicetree support to i2c-gpio driver. The allocation
of local data is integrated to a private structure, and use devm_*
helper for easy cleanup.

It is base on an earlier patch for gc-linux from
Albert Herranz <albert_herranz@yahoo.es>.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
Acked-by: Haavard Skinnemoen <hskinnemoen@gmail.com>
---
for v2.6.39
v2 move of nodes probing to a hook, which will be optimized out
     when devicetree is not used.
   use linux/gpio.h.
   move binding doc to i2c/i2c-gpio.txt.
v3 use speed-hz instead of udelay in dts binding.
   condition the devicetree probe.
v4 simplify private allocation.

 Documentation/devicetree/bindings/i2c/i2c-gpio.txt |   40 +++++++
 drivers/i2c/busses/i2c-gpio.c                      |  108 ++++++++++++++++----
 2 files changed, 128 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-gpio.txt

diff --git a/Documentation/devicetree/bindings/i2c/i2c-gpio.txt b/Documentation/devicetree/bindings/i2c/i2c-gpio.txt
new file mode 100644
index 0000000..38ef4f2
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
+- speed-hz : SCL frequency.
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
+	speed-hz = <250000>;
+
+	audio-video-encoder {
+		compatible = "nintendo,wii-ave-rvl";
+		reg = <70>;
+	};
+};
diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index d9aa9a6..3b2d694 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -14,8 +14,14 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/of_i2c.h>
 
-#include <asm/gpio.h>
+struct i2c_gpio_private_data {
+	struct i2c_adapter adap;
+	struct i2c_algo_bit_data bit_data;
+	struct i2c_gpio_platform_data pdata;
+};
 
 /* Toggle SDA by changing the direction of the pin */
 static void i2c_gpio_setsda_dir(void *data, int state)
@@ -78,24 +84,80 @@ static int i2c_gpio_getscl(void *data)
 	return gpio_get_value(pdata->scl_pin);
 }
 
+#ifdef CONFIG_OF
+#include <linux/of_gpio.h>
+
+/* Check if devicetree nodes exist and build platform data */
+static int i2c_gpio_of_probe(struct platform_device *pdev,
+			     struct i2c_gpio_platform_data *pdata)
+{
+	struct device_node *np = pdev->dev.of_node;
+	const __be32 *prop;
+	int sda_pin, scl_pin;
+	int len;
+
+	if (!np || of_gpio_count(np) < 2)
+		return -ENXIO;
+
+	sda_pin = of_get_gpio_flags(np, 0, NULL);
+	scl_pin = of_get_gpio_flags(np, 1, NULL);
+	if (sda_pin < 0 || scl_pin < 0) {
+		pr_err("%s: invalid GPIO pins, sda=%d/scl=%d\n",
+		       np->full_name, sda_pin, scl_pin);
+		return -ENXIO;
+	}
+
+	pdata->sda_pin = sda_pin;
+	pdata->scl_pin = scl_pin;
+	prop = of_get_property(np, "sda-is-open-drain", NULL);
+	if (prop)
+		pdata->sda_is_open_drain = 1;
+	prop = of_get_property(np, "scl-is-open-drain", NULL);
+	if (prop)
+		pdata->scl_is_open_drain = 1;
+	prop = of_get_property(np, "scl-is-output-only", NULL);
+	if (prop)
+		pdata->scl_is_output_only = 1;
+	prop = of_get_property(np, "speed-hz", &len);
+	if (prop && len >= sizeof(__be32))
+		pdata->udelay = DIV_ROUND_UP(1000000, be32_to_cpup(prop) * 2);
+	prop = of_get_property(np, "timeout", &len);
+	if (prop && len >= sizeof(__be32))
+		pdata->timeout = msecs_to_jiffies(be32_to_cpup(prop));
+
+	return 0;
+}
+#else
+static int i2c_gpio_of_probe(struct platform_device *pdev,
+			     struct i2c_gpio_platform_data *pdata)
+{
+	return -ENXIO;
+}
+#endif
+
 static int __devinit i2c_gpio_probe(struct platform_device *pdev)
 {
+	struct i2c_gpio_private_data *priv;
 	struct i2c_gpio_platform_data *pdata;
 	struct i2c_algo_bit_data *bit_data;
 	struct i2c_adapter *adap;
 	int ret;
 
-	pdata = pdev->dev.platform_data;
-	if (!pdata)
-		return -ENXIO;
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	adap = &priv->adap;
+	bit_data = &priv->bit_data;
+	pdata = &priv->pdata;
 
-	ret = -ENOMEM;
-	adap = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
-	if (!adap)
-		goto err_alloc_adap;
-	bit_data = kzalloc(sizeof(struct i2c_algo_bit_data), GFP_KERNEL);
-	if (!bit_data)
-		goto err_alloc_bit_data;
+	if (pdev->dev.platform_data) {
+		*pdata = *(struct i2c_gpio_platform_data *)
+			pdev->dev.platform_data;
+	} else {
+		ret = i2c_gpio_of_probe(pdev, pdata);
+		if (ret)
+			return ret;
+	}
 
 	ret = gpio_request(pdata->sda_pin, "sda");
 	if (ret)
@@ -143,6 +205,7 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
 	adap->algo_data = bit_data;
 	adap->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
 	adap->dev.parent = &pdev->dev;
+	adap->dev.of_node = pdev->dev.of_node;
 
 	/*
 	 * If "dev->id" is negative we consider it as zero.
@@ -154,13 +217,16 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_add_bus;
 
-	platform_set_drvdata(pdev, adap);
+	platform_set_drvdata(pdev, priv);
 
 	dev_info(&pdev->dev, "using pins %u (SDA) and %u (SCL%s)\n",
 		 pdata->sda_pin, pdata->scl_pin,
 		 pdata->scl_is_output_only
 		 ? ", no clock stretching" : "");
 
+	/* Now register all the child nodes */
+	of_i2c_register_devices(adap);
+
 	return 0;
 
 err_add_bus:
@@ -168,34 +234,36 @@ err_add_bus:
 err_request_scl:
 	gpio_free(pdata->sda_pin);
 err_request_sda:
-	kfree(bit_data);
-err_alloc_bit_data:
-	kfree(adap);
-err_alloc_adap:
 	return ret;
 }
 
 static int __devexit i2c_gpio_remove(struct platform_device *pdev)
 {
+	struct i2c_gpio_private_data *priv;
 	struct i2c_gpio_platform_data *pdata;
 	struct i2c_adapter *adap;
 
-	adap = platform_get_drvdata(pdev);
-	pdata = pdev->dev.platform_data;
+	priv = platform_get_drvdata(pdev);
+	adap = &priv->adap;
+	pdata = &priv->pdata;
 
 	i2c_del_adapter(adap);
 	gpio_free(pdata->scl_pin);
 	gpio_free(pdata->sda_pin);
-	kfree(adap->algo_data);
-	kfree(adap);
 
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
1.7.4

