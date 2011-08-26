Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1HZLz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 07:55:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38126 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1HZLzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 07:55:25 -0400
Subject: [RFC][PATCH] power_supply: tosa_battery: convert to
 gpio_request_array() / gpio_free_array()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 19:55:17 +0800
Message-ID: <1314359717.12599.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change simplifies the implementation.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
hi,
I don't have this hardware handy. I appreciate if someone can test this patch.

Thanks,
Axel

 drivers/power/tosa_battery.c |   66 ++++++++++++------------------------------
 1 files changed, 19 insertions(+), 47 deletions(-)

diff --git a/drivers/power/tosa_battery.c b/drivers/power/tosa_battery.c
index 53f0d35..ada86a4 100644
--- a/drivers/power/tosa_battery.c
+++ b/drivers/power/tosa_battery.c
@@ -307,25 +307,20 @@ static struct tosa_bat tosa_bat_bu = {
 	.adc_temp_divider = -1,
 };
 
-static struct {
-	int gpio;
-	char *name;
-	bool output;
-	int value;
-} gpios[] = {
-	{ TOSA_GPIO_CHARGE_OFF,		"main charge off",	1, 1 },
-	{ TOSA_GPIO_CHARGE_OFF_JC,	"jacket charge off",	1, 1 },
-	{ TOSA_GPIO_BAT_SW_ON,		"battery switch",	1, 0 },
-	{ TOSA_GPIO_BAT0_V_ON,		"main battery",		1, 0 },
-	{ TOSA_GPIO_BAT1_V_ON,		"jacket battery",	1, 0 },
-	{ TOSA_GPIO_BAT1_TH_ON,		"main battery temp",	1, 0 },
-	{ TOSA_GPIO_BAT0_TH_ON,		"jacket battery temp",	1, 0 },
-	{ TOSA_GPIO_BU_CHRG_ON,		"backup battery",	1, 0 },
-	{ TOSA_GPIO_BAT0_CRG,		"main battery full",	0, 0 },
-	{ TOSA_GPIO_BAT1_CRG,		"jacket battery full",	0, 0 },
-	{ TOSA_GPIO_BAT0_LOW,		"main battery low",	0, 0 },
-	{ TOSA_GPIO_BAT1_LOW,		"jacket battery low",	0, 0 },
-	{ TOSA_GPIO_JACKET_DETECT,	"jacket detect",	0, 0 },
+static struct gpio tosa_bat_gpios[] = {
+	{ TOSA_GPIO_CHARGE_OFF,	   GPIOF_OUT_INIT_HIGH, "main charge off" },
+	{ TOSA_GPIO_CHARGE_OFF_JC, GPIOF_OUT_INIT_HIGH, "jacket charge off" },
+	{ TOSA_GPIO_BAT_SW_ON,	   GPIOF_OUT_INIT_LOW,	"battery switch" },
+	{ TOSA_GPIO_BAT0_V_ON,	   GPIOF_OUT_INIT_LOW,	"main battery" },
+	{ TOSA_GPIO_BAT1_V_ON,	   GPIOF_OUT_INIT_LOW,	"jacket battery" },
+	{ TOSA_GPIO_BAT1_TH_ON,	   GPIOF_OUT_INIT_LOW,	"main battery temp" },
+	{ TOSA_GPIO_BAT0_TH_ON,	   GPIOF_OUT_INIT_LOW,	"jacket battery temp" },
+	{ TOSA_GPIO_BU_CHRG_ON,	   GPIOF_OUT_INIT_LOW,	"backup battery" },
+	{ TOSA_GPIO_BAT0_CRG,	   GPIOF_IN,		"main battery full" },
+	{ TOSA_GPIO_BAT1_CRG,	   GPIOF_IN,		"jacket battery full" },
+	{ TOSA_GPIO_BAT0_LOW,	   GPIOF_IN,		"main battery low" },
+	{ TOSA_GPIO_BAT1_LOW,	   GPIOF_IN,		"jacket battery low" },
+	{ TOSA_GPIO_JACKET_DETECT, GPIOF_IN,		"jacket detect" },
 };
 
 #ifdef CONFIG_PM
@@ -350,27 +345,13 @@ static int tosa_bat_resume(struct platform_device *dev)
 static int __devinit tosa_bat_probe(struct platform_device *dev)
 {
 	int ret;
-	int i;
 
 	if (!machine_is_tosa())
 		return -ENODEV;
 
-	for (i = 0; i < ARRAY_SIZE(gpios); i++) {
-		ret = gpio_request(gpios[i].gpio, gpios[i].name);
-		if (ret) {
-			i--;
-			goto err_gpio;
-		}
-
-		if (gpios[i].output)
-			ret = gpio_direction_output(gpios[i].gpio,
-					gpios[i].value);
-		else
-			ret = gpio_direction_input(gpios[i].gpio);
-
-		if (ret)
-			goto err_gpio;
-	}
+	ret = gpio_request_array(tosa_bat_gpios, ARRAY_SIZE(tosa_bat_gpios));
+	if (ret)
+		return ret;
 
 	mutex_init(&tosa_bat_main.work_lock);
 	mutex_init(&tosa_bat_jacket.work_lock);
@@ -424,18 +405,12 @@ err_psy_reg_main:
 	/* see comment in tosa_bat_remove */
 	cancel_work_sync(&bat_work);
 
-	i--;
-err_gpio:
-	for (; i >= 0; i--)
-		gpio_free(gpios[i].gpio);
-
+	gpio_free_array(tosa_bat_gpios, ARRAY_SIZE(tosa_bat_gpios));
 	return ret;
 }
 
 static int __devexit tosa_bat_remove(struct platform_device *dev)
 {
-	int i;
-
 	free_irq(gpio_to_irq(TOSA_GPIO_JACKET_DETECT), &tosa_bat_jacket);
 	free_irq(gpio_to_irq(TOSA_GPIO_BAT1_CRG), &tosa_bat_jacket);
 	free_irq(gpio_to_irq(TOSA_GPIO_BAT0_CRG), &tosa_bat_main);
@@ -450,10 +425,7 @@ static int __devexit tosa_bat_remove(struct platform_device *dev)
 	 * unregistered now.
 	 */
 	cancel_work_sync(&bat_work);
-
-	for (i = ARRAY_SIZE(gpios) - 1; i >= 0; i--)
-		gpio_free(gpios[i].gpio);
-
+	gpio_free_array(tosa_bat_gpios, ARRAY_SIZE(tosa_bat_gpios));
 	return 0;
 }
 
-- 
1.7.4.1



