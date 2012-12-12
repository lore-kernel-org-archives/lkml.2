Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2LLOAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:00:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44339 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab2LLOAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:00:47 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/33] leds-lp55xx: cleanup deinit leds in lp5521/5523
Thread-Topic: [PATCH 04/33] leds-lp55xx: cleanup deinit leds in lp5521/5523
Thread-Index: Ac3YcRIMoyn9vWzKRT2G6uSIqlvdJQ==
Date: Wed, 12 Dec 2012 14:00:41 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AAC8@DQHE02.ent.ti.com>
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

 To make LED unregistration code simple, new function, _unregister_leds()
 is added at each driver.
 This patch is a preceding step for lp55xx common driver architecture.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   23 +++++++++++++----------
 drivers/leds/leds-lp5523.c |   21 ++++++++++++---------
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 7f715fb..f729f7a 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -837,12 +837,22 @@ static int lp5521_register_leds(struct lp5521_chip *chip)
 	return 0;
 }
 
+static void lp5521_unregister_leds(struct lp5521_chip *chip)
+{
+	int i;
+
+	for (i = 0; i < chip->num_leds; i++) {
+		led_classdev_unregister(&chip->leds[i].cdev);
+		cancel_work_sync(&chip->leds[i].brightness_work);
+	}
+}
+
 static int __devinit lp5521_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct lp5521_chip		*chip;
 	struct lp5521_platform_data	*pdata;
-	int ret, i;
+	int ret;
 
 	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
@@ -885,10 +895,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	}
 	return ret;
 fail2:
-	for (i = 0; i < chip->num_leds; i++) {
-		led_classdev_unregister(&chip->leds[i].cdev);
-		cancel_work_sync(&chip->leds[i].brightness_work);
-	}
+	lp5521_unregister_leds(chip);
 fail1:
 	lp5521_deinit_device(chip);
 	return ret;
@@ -897,15 +904,11 @@ fail1:
 static int __devexit lp5521_remove(struct i2c_client *client)
 {
 	struct lp5521_chip *chip = i2c_get_clientdata(client);
-	int i;
 
 	lp5521_run_led_pattern(PATTERN_OFF, chip);
 	lp5521_unregister_sysfs(client);
 
-	for (i = 0; i < chip->num_leds; i++) {
-		led_classdev_unregister(&chip->leds[i].cdev);
-		cancel_work_sync(&chip->leds[i].brightness_work);
-	}
+	lp5521_unregister_leds(chip);
 
 	lp5521_deinit_device(chip);
 	return 0;
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index f62e92d..6a1c4f2 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -936,6 +936,16 @@ static int lp5523_register_leds(struct lp5523_chip *chip, const char *name)
 	return 0;
 }
 
+static void lp5523_unregister_leds(struct lp5523_chip *chip)
+{
+	int i;
+
+	for (i = 0; i < chip->num_leds; i++) {
+		led_classdev_unregister(&chip->leds[i].cdev);
+		flush_work(&chip->leds[i].brightness_work);
+	}
+}
+
 static int lp5523_init_device(struct lp5523_chip *chip)
 {
 	struct lp5523_platform_data *pdata = chip->pdata;
@@ -1029,10 +1039,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 	}
 	return ret;
 fail2:
-	for (i = 0; i < chip->num_leds; i++) {
-		led_classdev_unregister(&chip->leds[i].cdev);
-		flush_work(&chip->leds[i].brightness_work);
-	}
+	lp5523_unregister_leds(chip);
 fail1:
 	lp5523_deinit_device(chip);
 	return ret;
@@ -1041,17 +1048,13 @@ fail1:
 static int lp5523_remove(struct i2c_client *client)
 {
 	struct lp5523_chip *chip = i2c_get_clientdata(client);
-	int i;
 
 	/* Disable engine mode */
 	lp5523_write(client, LP5523_REG_OP_MODE, LP5523_CMD_DISABLED);
 
 	lp5523_unregister_sysfs(client);
 
-	for (i = 0; i < chip->num_leds; i++) {
-		led_classdev_unregister(&chip->leds[i].cdev);
-		flush_work(&chip->leds[i].brightness_work);
-	}
+	lp5523_unregister_leds(chip);
 
 	lp5523_deinit_device(chip);
 	return 0;
-- 
1.7.9.5


Best Regards,
Milo


