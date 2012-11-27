Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2K0Li4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:38:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38428 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab2K0Lix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:38:53 -0500
Date: Tue, 27 Nov 2012 11:38:48 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH 3/5 v3] Input: bu21013_ts - Add support for Device Tree
 booting
Message-ID: <20121127113848.GD2013@gmail.com>
References: <1352900837-20759-1-git-send-email-lee.jones@linaro.org>
 <1352900837-20759-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352900837-20759-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Lee Jones <lee.jones@linaro.org>
Date:   Fri Sep 28 14:35:43 2012 +0100

    Input: bu21013_ts - Add support for Device Tree booting
    
    Now we can register the BU21013_ts touch screen when booting with
    Device Tree enabled. Here we parse all the necessary components
    previously expected to be passed from platform data.
    
    Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Cc: linux-input@vger.kernel.org
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/Documentation/devicetree/bindings/input/touchscreen/bu21013.txt b/Documentation/devicetree/bindings/input/touchscreen/bu21013.txt
new file mode 100644
index 0000000..ca5a2c8
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/touchscreen/bu21013.txt
@@ -0,0 +1,28 @@
+* Rohm BU21013 Touch Screen
+
+Required properties:
+ - compatible              : "rohm,bu21013_tp"
+ - reg                     :  I2C device address
+
+Optional properties:
+ - touch-gpio              : GPIO pin registering a touch event
+ - <supply_name>-supply    : Phandle to a regulator supply
+ - rohm,touch-max-x        : Maximum outward permitted limit in the X axis
+ - rohm,touch-max-y        : Maximum outward permitted limit in the Y axis
+ - rohm,flip-x             : Flip touch coordinates on the X axis
+ - rohm,flip-y             : Flip touch coordinates on the Y axis
+
+Example:
+
+	i2c@80110000 {
+		bu21013_tp@0x5c {
+			compatible = "rohm,bu21013_tp";
+			reg = <0x5c>;
+			touch-gpio = <&gpio2 20 0x4>;
+			avdd-supply = <&ab8500_ldo_aux1_reg>;
+
+			rohm,touch-max-x = <384>;
+			rohm,touch-max-y = <704>;
+			rohm,flip-y;
+		};
+	};
diff --git a/drivers/input/touchscreen/bu21013_ts.c b/drivers/input/touchscreen/bu21013_ts.c
index 16f29d6..07335ac 100644
--- a/drivers/input/touchscreen/bu21013_ts.c
+++ b/drivers/input/touchscreen/bu21013_ts.c
@@ -15,6 +15,8 @@
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 
 #define PEN_DOWN_INTR	0
 #define MAX_FINGERS	2
@@ -473,13 +475,30 @@ static void bu21013_free_irq(struct bu21013_ts_data *bu21013_data)
  * This function used to initializes the i2c-client touchscreen
  * driver and returns integer.
  */
+static void __devinit bu21013_of_probe(struct device_node *np,
+				struct bu21013_platform_device *pdata)
+{
+	pdata->y_flip = pdata->x_flip = false;
+
+	pdata->x_flip = of_property_read_bool(np, "rohm,flip-x");
+	pdata->y_flip = of_property_read_bool(np, "rohm,flip-y");
+
+	of_property_read_u32(np, "rohm,touch-max-x", &pdata->touch_x_max);
+	of_property_read_u32(np, "rohm,touch-max-y", &pdata->touch_y_max);
+
+	pdata->touch_pin = of_get_named_gpio(np, "touch-gpio", 0);
+	pdata->cs_pin = of_get_named_gpio(np, "reset-gpio", 0);
+
+	pdata->ext_clk = false;
+}
+
 static int __devinit bu21013_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
 	struct bu21013_ts_data *bu21013_data;
 	struct input_dev *in_dev;
-	const struct bu21013_platform_device *pdata =
-					client->dev.platform_data;
+	struct device_node *np = client->dev.of_node;
+	struct bu21013_platform_device *pdata = client->dev.platform_data;
 	int error;
 
 	if (!i2c_check_functionality(client->adapter,
@@ -489,8 +508,17 @@ static int __devinit bu21013_probe(struct i2c_client *client,
 	}
 
 	if (!pdata) {
-		dev_err(&client->dev, "platform data not defined\n");
-		return -EINVAL;
+		if (np) {
+			pdata = devm_kzalloc(&client->dev, sizeof(*pdata),
+					GFP_KERNEL);
+			if (!pdata)
+				return -ENOMEM;
+
+			bu21013_of_probe(np, pdata);
+		} else {
+			dev_err(&client->dev, "no device tree or platform data\n");
+			return -EINVAL;
+		}
 	}
 
 	pdata->irq = gpio_to_irq(pdata->touch_pin);

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
