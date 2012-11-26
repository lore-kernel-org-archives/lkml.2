Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab2KZKu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:50:56 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:52526 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab2KZKuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:50:51 -0500
Date: Mon, 26 Nov 2012 10:50:45 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 3/5 v2] Input: bu21013_ts - Add support for Device Tree
 booting
Message-ID: <20121126105045.GF12782@gmail.com>
References: <1352900837-20759-1-git-send-email-lee.jones@linaro.org>
 <1352900837-20759-4-git-send-email-lee.jones@linaro.org>
 <20121123155258.GE28552@gmail.com>
 <20121124075009.GB24711@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121124075009.GB24711@core.coreip.homeip.net>
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

diff --git a/drivers/input/touchscreen/bu21013_ts.c b/drivers/input/touchscreen/bu21013_ts.c
index 08ffb19..7d240f0 100644
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
@@ -478,13 +480,30 @@ static void bu21013_free_irq(struct bu21013_ts_data *bu21013_data)
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
@@ -494,8 +513,17 @@ static int __devinit bu21013_probe(struct i2c_client *client,
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
