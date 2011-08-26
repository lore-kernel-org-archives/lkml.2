Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1HZHw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 03:52:57 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63026 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1HZHw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 03:52:56 -0400
Subject: [RFC][PATCH] power_supply: collie_battery: convert to
 gpio_request_array() / gpio_free_array()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Kunze <thommycheck@gmx.de>, Igor Grinberg <grinberg@compulab.co.il>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 15:52:48 +0800
Message-ID: <1314345168.10901.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Igor Grinberg, this change make the implementation looks simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
hi,
I don't have this hardware handy, I appreciate if someone can test this patch.

Thanks,
Axel

 drivers/power/collie_battery.c |   53 ++++++++++------------------------------
 1 files changed, 13 insertions(+), 40 deletions(-)

diff --git a/drivers/power/collie_battery.c b/drivers/power/collie_battery.c
index 548d263..1b4c17b 100644
--- a/drivers/power/collie_battery.c
+++ b/drivers/power/collie_battery.c
@@ -277,18 +277,13 @@ static struct collie_bat collie_bat_bu = {
 	.adc_temp_divider = -1,
 };
 
-static struct {
-	int gpio;
-	char *name;
-	bool output;
-	int value;
-} gpios[] = {
-	{ COLLIE_GPIO_CO,		"main battery full",	0, 0 },
-	{ COLLIE_GPIO_MAIN_BAT_LOW,	"main battery low",	0, 0 },
-	{ COLLIE_GPIO_CHARGE_ON,	"main charge on",	1, 0 },
-	{ COLLIE_GPIO_MBAT_ON,		"main battery",		1, 0 },
-	{ COLLIE_GPIO_TMP_ON,		"main battery temp",	1, 0 },
-	{ COLLIE_GPIO_BBAT_ON,		"backup battery",	1, 0 },
+static struct gpio collie_batt_gpios[] = {
+	{ COLLIE_GPIO_CO,	    GPIOF_IN,		"main battery full" },
+	{ COLLIE_GPIO_MAIN_BAT_LOW, GPIOF_IN,		"main battery low" },
+	{ COLLIE_GPIO_CHARGE_ON,    GPIOF_OUT_INIT_LOW,	"main charge on" },
+	{ COLLIE_GPIO_MBAT_ON,	    GPIOF_OUT_INIT_LOW,	"main battery" },
+	{ COLLIE_GPIO_TMP_ON,	    GPIOF_OUT_INIT_LOW,	"main battery temp" },
+	{ COLLIE_GPIO_BBAT_ON,	    GPIOF_OUT_INIT_LOW,	"backup battery" },
 };
 
 #ifdef CONFIG_PM
@@ -313,29 +308,16 @@ static int collie_bat_resume(struct ucb1x00_dev *dev)
 static int __devinit collie_bat_probe(struct ucb1x00_dev *dev)
 {
 	int ret;
-	int i;
 
 	if (!machine_is_collie())
 		return -ENODEV;
 
 	ucb = dev->ucb;
 
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
+	ret = gpio_request_array(collie_batt_gpios,
+				 ARRAY_SIZE(collie_batt_gpios));
+	if (ret)
+		return ret;
 
 	mutex_init(&collie_bat_main.work_lock);
 
@@ -363,19 +345,12 @@ err_psy_reg_main:
 
 	/* see comment in collie_bat_remove */
 	cancel_work_sync(&bat_work);
-
-	i--;
-err_gpio:
-	for (; i >= 0; i--)
-		gpio_free(gpios[i].gpio);
-
+	gpio_free_array(collie_batt_gpios, ARRAY_SIZE(collie_batt_gpios));
 	return ret;
 }
 
 static void __devexit collie_bat_remove(struct ucb1x00_dev *dev)
 {
-	int i;
-
 	free_irq(gpio_to_irq(COLLIE_GPIO_CO), &collie_bat_main);
 
 	power_supply_unregister(&collie_bat_bu.psy);
@@ -387,9 +362,7 @@ static void __devexit collie_bat_remove(struct ucb1x00_dev *dev)
 	 * unregistered now.
 	 */
 	cancel_work_sync(&bat_work);
-
-	for (i = ARRAY_SIZE(gpios) - 1; i >= 0; i--)
-		gpio_free(gpios[i].gpio);
+	gpio_free_array(collie_batt_gpios, ARRAY_SIZE(collie_batt_gpios));
 }
 
 static struct ucb1x00_driver collie_bat_driver = {
-- 
1.7.4.1



