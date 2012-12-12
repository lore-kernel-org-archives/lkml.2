Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab2LLOAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:00:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47763 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab2LLOAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:00:34 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/33] leds-lp55xx: cleanup init leds in lp5521/5523
Thread-Topic: [PATCH 03/33] leds-lp55xx: cleanup init leds in lp5521/5523
Thread-Index: Ac3YcQrv0CSOaB6PRayyT6zhR62QQw==
Date: Wed, 12 Dec 2012 14:00:30 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AAC0@DQHE02.ent.ti.com>
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

 To make LED initialization code simple, new function, _register_leds()
 is added at each driver.
 This patch is a preceding step for lp55xx common driver architecture.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   69 +++++++++++++++++++++++++----------------
 drivers/leds/leds-lp5523.c |   73 ++++++++++++++++++++++++++------------------
 2 files changed, 86 insertions(+), 56 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index d2b79b5..7f715fb 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -799,12 +799,50 @@ static int __devinit lp5521_init_led(struct lp5521_led *led,
 	return 0;
 }
 
+static int lp5521_register_leds(struct lp5521_chip *chip)
+{
+	struct lp5521_platform_data *pdata = chip->pdata;
+	struct i2c_client *client = chip->client;
+	int i;
+	int led;
+	int ret;
+
+	/* Initialize leds */
+	chip->num_channels = pdata->num_channels;
+	chip->num_leds = 0;
+	led = 0;
+	for (i = 0; i < pdata->num_channels; i++) {
+		/* Do not initialize channels that are not connected */
+		if (pdata->led_config[i].led_current == 0)
+			continue;
+
+		ret = lp5521_init_led(&chip->leds[led], client, i, pdata);
+		if (ret) {
+			dev_err(&client->dev, "error initializing leds\n");
+			return ret;
+		}
+		chip->num_leds++;
+
+		chip->leds[led].id = led;
+		/* Set initial LED current */
+		lp5521_set_led_current(chip, led,
+				chip->leds[led].led_current);
+
+		INIT_WORK(&(chip->leds[led].brightness_work),
+			lp5521_led_brightness_work);
+
+		led++;
+	}
+
+	return 0;
+}
+
 static int __devinit lp5521_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct lp5521_chip		*chip;
 	struct lp5521_platform_data	*pdata;
-	int ret, i, led;
+	int ret, i;
 
 	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
@@ -836,32 +874,9 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 		goto fail1;
 	}
 
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
-			goto fail2;
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
+	ret = lp5521_register_leds(chip);
+	if (ret)
+		goto fail2;
 
 	ret = lp5521_register_sysfs(client);
 	if (ret) {
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index b88251d..f62e92d 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -896,6 +896,46 @@ static int __devinit lp5523_init_led(struct lp5523_led *led, struct device *dev,
 	return 0;
 }
 
+static int lp5523_register_leds(struct lp5523_chip *chip, const char *name)
+{
+	struct lp5523_platform_data *pdata = chip->pdata;
+	struct i2c_client *client = chip->client;
+	int i;
+	int led;
+	int ret;
+
+	/* Initialize leds */
+	chip->num_channels = pdata->num_channels;
+	chip->num_leds = 0;
+	led = 0;
+	for (i = 0; i < pdata->num_channels; i++) {
+		/* Do not initialize channels that are not connected */
+		if (pdata->led_config[i].led_current == 0)
+			continue;
+
+		INIT_WORK(&chip->leds[led].brightness_work,
+			lp5523_led_brightness_work);
+
+		ret = lp5523_init_led(&chip->leds[led], &client->dev, i, pdata,
+				name);
+		if (ret) {
+			dev_err(&client->dev, "error initializing leds\n");
+			return ret;
+		}
+		chip->num_leds++;
+
+		chip->leds[led].id = led;
+		/* Set LED current */
+		lp5523_write(client,
+			  LP5523_REG_LED_CURRENT_BASE + chip->leds[led].chan_nr,
+			  chip->leds[led].led_current);
+
+		led++;
+	}
+
+	return 0;
+}
+
 static int lp5523_init_device(struct lp5523_chip *chip)
 {
 	struct lp5523_platform_data *pdata = chip->pdata;
@@ -938,7 +978,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 {
 	struct lp5523_chip		*chip;
 	struct lp5523_platform_data	*pdata;
-	int ret, i, led;
+	int ret, i;
 
 	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
@@ -978,34 +1018,9 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 		goto fail1;
 	}
 
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
-				id->name);
-		if (ret) {
-			dev_err(&client->dev, "error initializing leds\n");
-			goto fail2;
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
+	ret = lp5523_register_leds(chip, id->name);
+	if (ret)
+		goto fail2;
 
 	ret = lp5523_register_sysfs(client);
 	if (ret) {
-- 
1.7.9.5


Best Regards,
Milo


