Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2LLOBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:01:38 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50790 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab2LLOBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:01:35 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/33] leds-lp55xx: use lp55xx common led registration
 function
Thread-Topic: [PATCH 12/33] leds-lp55xx: use lp55xx common led registration
 function
Thread-Index: Ac3YcS/TLvKKyqciQA6Ter/jIsUNrQ==
Date: Wed, 12 Dec 2012 14:01:32 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AB3D@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 LED class devices are registered in lp5521_register_leds() and
 lp5523_register_leds().
 Two separate functions are merged into consolidated lp55xx function,
 lp55xx_register_leds().

 Error handling fix:
 When LED registration failure occurs, device should be de-initialized
 rather than unregistering LEDs.

 This patch is not complete one because LED registration needs
 additional patches. Please refer next patches.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c        |   44 +++------------------------------
 drivers/leds/leds-lp5523.c        |   46 +++-------------------------------
 drivers/leds/leds-lp55xx-common.c |   49 +++++++++++++++++++++++++++++++++++++
 drivers/leds/leds-lp55xx-common.h |    3 +++
 4 files changed, 58 insertions(+), 84 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 99f35b8..33c3110 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -733,44 +733,6 @@ static int __devinit lp5521_init_led(struct lp5521_led *led,
 	return 0;
 }
 
-static int lp5521_register_leds(struct lp5521_chip *chip)
-{
-	struct lp5521_platform_data *pdata = chip->pdata;
-	struct i2c_client *client = chip->client;
-	int i;
-	int led;
-	int ret;
-
-	/* Initialize leds */
-	chip->num_channels = pdata->num_channels;
-	chip->num_leds = 0;
-	led = 0;
-	for (i = 0; i < pdata->num_channels; i++) {
-		/* Do not initialize channels that are not connected */
-		if (pdata->led_config[i].led_current == 0)
-			continue;
-
-		ret = lp5521_init_led(&chip->leds[led], client, i, pdata);
-		if (ret) {
-			dev_err(&client->dev, "error initializing leds\n");
-			return ret;
-		}
-		chip->num_leds++;
-
-		chip->leds[led].id = led;
-		/* Set initial LED current */
-		lp5521_set_led_current(chip, led,
-				chip->leds[led].led_current);
-
-		INIT_WORK(&(chip->leds[led].brightness_work),
-			lp5521_led_brightness_work);
-
-		led++;
-	}
-
-	return 0;
-}
-
 static void lp5521_unregister_leds(struct lp5521_chip *chip)
 {
 	int i;
@@ -831,9 +793,9 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 
 	dev_info(&client->dev, "%s programmable led chip found\n", id->name);
 
-	ret = lp5521_register_leds(old_chip);
+	ret = lp55xx_register_leds(led, chip);
 	if (ret)
-		goto fail2;
+		goto err_register_leds;
 
 	ret = lp5521_register_sysfs(client);
 	if (ret) {
@@ -843,7 +805,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	return ret;
 fail2:
 	lp5521_unregister_leds(old_chip);
-fail1:
+err_register_leds:
 	lp55xx_deinit_device(chip);
 err_init:
 	return ret;
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 2f5213d..aa77f40 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -834,46 +834,6 @@ static int __devinit lp5523_init_led(struct lp5523_led *led, struct device *dev,
 	return 0;
 }
 
-static int lp5523_register_leds(struct lp5523_chip *chip, const char *name)
-{
-	struct lp5523_platform_data *pdata = chip->pdata;
-	struct i2c_client *client = chip->client;
-	int i;
-	int led;
-	int ret;
-
-	/* Initialize leds */
-	chip->num_channels = pdata->num_channels;
-	chip->num_leds = 0;
-	led = 0;
-	for (i = 0; i < pdata->num_channels; i++) {
-		/* Do not initialize channels that are not connected */
-		if (pdata->led_config[i].led_current == 0)
-			continue;
-
-		INIT_WORK(&chip->leds[led].brightness_work,
-			lp5523_led_brightness_work);
-
-		ret = lp5523_init_led(&chip->leds[led], &client->dev, i, pdata,
-				name);
-		if (ret) {
-			dev_err(&client->dev, "error initializing leds\n");
-			return ret;
-		}
-		chip->num_leds++;
-
-		chip->leds[led].id = led;
-		/* Set LED current */
-		lp5523_write(client,
-			  LP5523_REG_LED_CURRENT_BASE + chip->leds[led].chan_nr,
-			  chip->leds[led].led_current);
-
-		led++;
-	}
-
-	return 0;
-}
-
 static void lp5523_unregister_leds(struct lp5523_chip *chip)
 {
 	int i;
@@ -934,9 +894,9 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 
 	dev_info(&client->dev, "%s Programmable led chip found\n", id->name);
 
-	ret = lp5523_register_leds(old_chip, id->name);
+	ret = lp55xx_register_leds(led, chip);
 	if (ret)
-		goto fail2;
+		goto err_register_leds;
 
 	ret = lp5523_register_sysfs(client);
 	if (ret) {
@@ -946,7 +906,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 	return ret;
 fail2:
 	lp5523_unregister_leds(old_chip);
-fail1:
+err_register_leds:
 	lp55xx_deinit_device(chip);
 err_init:
 	return ret;
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 66ba500..55ac340 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -169,3 +169,52 @@ void lp55xx_deinit_device(struct lp55xx_chip *chip)
 		pdata->release_resources();
 }
 EXPORT_SYMBOL_GPL(lp55xx_deinit_device);
+
+int lp55xx_register_leds(struct lp55xx_led *led, struct lp55xx_chip *chip)
+{
+	struct lp55xx_platform_data *pdata = chip->pdata;
+	struct lp55xx_device_config *cfg = chip->cfg;
+	int num_channels = pdata->num_channels;
+	struct lp55xx_led *each;
+	u8 led_current;
+	int ret;
+	int i;
+
+	if (!cfg->brightness_work_fn) {
+		dev_err(&chip->cl->dev, "empty brightness configuration\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_channels; i++) {
+
+		/* do not initialize channels that are not connected */
+		if (pdata->led_config[i].led_current == 0)
+			continue;
+
+		led_current = pdata->led_config[i].led_current;
+		each = led + i;
+		ret = lp55xx_init_led(each, chip, i);
+		if (ret)
+			goto err_init_led;
+
+		INIT_WORK(&each->brightness_work, cfg->brightness_work_fn);
+
+		chip->num_leds++;
+		each->chip = chip;
+
+		/* setting led current at each channel */
+		if (cfg->set_led_current)
+			cfg->set_led_current(each, led_current);
+	}
+
+	return 0;
+
+err_init_led:
+	for (i = 0; i < chip->num_leds; i++) {
+		each = led + i;
+		led_classdev_unregister(&each->cdev);
+		flush_work(&each->brightness_work);
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lp55xx_register_leds);
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index 908b00a..8283906 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -88,4 +88,7 @@ extern int lp55xx_update_bits(struct lp55xx_chip *chip, u8 reg,
 extern int lp55xx_init_device(struct lp55xx_chip *chip);
 extern void lp55xx_deinit_device(struct lp55xx_chip *chip);
 
+/* common LED class device functions */
+extern int lp55xx_register_leds(struct lp55xx_led *led,
+				struct lp55xx_chip *chip);
 #endif /* _LEDS_LP55XX_COMMON_H */
-- 
1.7.9.5


Best Regards,
Milo


