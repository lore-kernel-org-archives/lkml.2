Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2CGNkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:40:45 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12968 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab2CGNkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:40:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 07 Mar 2012 05:40:42 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        linus.walleij@linaro.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1] i2c: gpio: Use open drain support from gpio driver
Date: Wed,  7 Mar 2012 19:08:14 +0530
Message-Id: <1331127494-6913-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio core driver (gpio library) supports the open
drain pin handling. Therefore, it is not require it
to handle in the i2c-gpio driver, just require
to pass the OPEN_DRAIN type flag when requesting the gpio.

Remove the handling of open drain pin in the i2c-gpio driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/i2c/busses/i2c-gpio.c |   78 ++++++++++++++--------------------------
 1 files changed, 27 insertions(+), 51 deletions(-)

diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index 69fbfae..662a747 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -16,22 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 
-/* Toggle SDA by changing the direction of the pin */
-static void i2c_gpio_setsda_dir(void *data, int state)
-{
-	struct i2c_gpio_platform_data *pdata = data;
-
-	if (state)
-		gpio_direction_input(pdata->sda_pin);
-	else
-		gpio_direction_output(pdata->sda_pin, 0);
-}
-
-/*
- * Toggle SDA by changing the output value of the pin. This is only
- * valid for pins configured as open drain (i.e. setting the value
- * high effectively turns off the output driver.)
- */
+/* Toggle SDA by setting value, gpio library take care of open drain pins.*/
 static void i2c_gpio_setsda_val(void *data, int state)
 {
 	struct i2c_gpio_platform_data *pdata = data;
@@ -39,23 +24,7 @@ static void i2c_gpio_setsda_val(void *data, int state)
 	gpio_set_value(pdata->sda_pin, state);
 }
 
-/* Toggle SCL by changing the direction of the pin. */
-static void i2c_gpio_setscl_dir(void *data, int state)
-{
-	struct i2c_gpio_platform_data *pdata = data;
-
-	if (state)
-		gpio_direction_input(pdata->scl_pin);
-	else
-		gpio_direction_output(pdata->scl_pin, 0);
-}
-
-/*
- * Toggle SCL by changing the output value of the pin. This is used
- * for pins that are configured as open drain and for output-only
- * pins. The latter case will break the i2c protocol, but it will
- * often work in practice.
- */
+ /* Toggle SCL by setting value, gpio library take care of open drain pins.*/
 static void i2c_gpio_setscl_val(void *data, int state)
 {
 	struct i2c_gpio_platform_data *pdata = data;
@@ -83,6 +52,8 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
 	struct i2c_algo_bit_data *bit_data;
 	struct i2c_adapter *adap;
 	int ret;
+	unsigned long sda_gpio_flags;
+	unsigned long scl_gpio_flags;
 
 	pdata = pdev->dev.platform_data;
 	if (!pdata)
@@ -96,28 +67,33 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
 	if (!bit_data)
 		goto err_alloc_bit_data;
 
-	ret = gpio_request(pdata->sda_pin, "sda");
-	if (ret)
+	/* Initially, SCL and SDA pin should be HIGH */
+	sda_gpio_flags = GPIOF_OUT_INIT_HIGH;
+	scl_gpio_flags = GPIOF_OUT_INIT_HIGH;
+
+	if (pdata->sda_is_open_drain)
+		sda_gpio_flags |= GPIOF_OPEN_DRAIN;
+
+	if (pdata->scl_is_open_drain && !pdata->scl_is_output_only)
+		scl_gpio_flags |= GPIOF_OPEN_DRAIN;
+
+
+
+	ret = gpio_request_one(pdata->sda_pin, sda_gpio_flags, "sda");
+	if (ret) {
+		pr_err("%s(): Error in requesting sda gpio%d, ret %d\n",
+				__func__, pdata->sda_pin, ret);
 		goto err_request_sda;
-	ret = gpio_request(pdata->scl_pin, "scl");
-	if (ret)
+	}
+	ret = gpio_request_one(pdata->scl_pin, scl_gpio_flags, "scl");
+	if (ret) {
+		pr_err("%s(): Error in requesting scl gpio%d, ret %d\n",
+				__func__, pdata->scl_pin, ret);
 		goto err_request_scl;
-
-	if (pdata->sda_is_open_drain) {
-		gpio_direction_output(pdata->sda_pin, 1);
-		bit_data->setsda = i2c_gpio_setsda_val;
-	} else {
-		gpio_direction_input(pdata->sda_pin);
-		bit_data->setsda = i2c_gpio_setsda_dir;
 	}
 
-	if (pdata->scl_is_open_drain || pdata->scl_is_output_only) {
-		gpio_direction_output(pdata->scl_pin, 1);
-		bit_data->setscl = i2c_gpio_setscl_val;
-	} else {
-		gpio_direction_input(pdata->scl_pin);
-		bit_data->setscl = i2c_gpio_setscl_dir;
-	}
+	bit_data->setsda = i2c_gpio_setsda_val;
+	bit_data->setscl = i2c_gpio_setscl_val;
 
 	if (!pdata->scl_is_output_only)
 		bit_data->getscl = i2c_gpio_getscl;
-- 
1.7.1.1

