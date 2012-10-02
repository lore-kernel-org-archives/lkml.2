Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab2JBINy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:13:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55594 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab2JBINk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:13:40 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 05/10] Input: bu21013_ts - Add support for Device Tree booting
Date: Tue,  2 Oct 2012 09:13:18 +0100
Message-Id: <1349165603-24401-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
References: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we can register the BU21013_ts touch screen when booting with
Device Tree enabled. Here we parse all the necessary components
previously expected to be passed from platform data.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/input/touchscreen/bu21013_ts.c |   39 ++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/bu21013_ts.c b/drivers/input/touchscreen/bu21013_ts.c
index 5d8fc75..3d1bff2 100644
--- a/drivers/input/touchscreen/bu21013_ts.c
+++ b/drivers/input/touchscreen/bu21013_ts.c
@@ -15,6 +15,8 @@
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 
 /* Reference tracking for multiple displays. */
 static int bu21013_devices = 0;
@@ -487,13 +489,33 @@ static void bu21013_free_irq(struct bu21013_ts_data *bu21013_data)
  * This function used to initializes the i2c-client touchscreen
  * driver and returns integer.
  */
+static void __devinit bu21013_of_probe(struct device_node *np,
+				struct bu21013_platform_device *pdata)
+{
+	pdata->y_flip = pdata->x_flip = false;
+
+	if (of_get_property(np, "stricsson,flip-x", NULL))
+		pdata->x_flip = true;
+
+	if (of_get_property(np, "stricsson,flip-y", NULL))
+		pdata->y_flip = true;
+
+	of_property_read_u32(np, "stericsson,touch-max-x", &pdata->touch_x_max);
+	of_property_read_u32(np, "stericsson,touch-max-y", &pdata->touch_y_max);
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
@@ -503,8 +525,17 @@ static int __devinit bu21013_probe(struct i2c_client *client,
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
1.7.9.5

