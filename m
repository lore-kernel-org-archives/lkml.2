Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2LLOCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:02:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47839 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab2LLOCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:02:03 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/33] leds-lp55xx: use lp55xx_unregister_leds()
Thread-Topic: [PATCH 16/33] leds-lp55xx: use lp55xx_unregister_leds()
Thread-Index: Ac3YcT+mzzsRrDVzQ82r850oFANP4A==
Date: Wed, 12 Dec 2012 14:01:58 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AB5D@DQHE02.ent.ti.com>
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

 To unregister led class devices and sysfs attributes,
 LP5521 and LP5523 have each driver function.
 This patch makes both drivers simple using common driver function,
 lp55xx_unregister_leds().

 And some unused variables are removed.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c        |   21 ++-------------------
 drivers/leds/leds-lp5523.c        |   24 +++---------------------
 drivers/leds/leds-lp55xx-common.c |   16 ++++++++++++++++
 drivers/leds/leds-lp55xx-common.h |    2 ++
 4 files changed, 23 insertions(+), 40 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index acf2495..0ae0b5f 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -599,25 +599,9 @@ static int lp5521_register_sysfs(struct i2c_client *client)
 
 static void lp5521_unregister_sysfs(struct i2c_client *client)
 {
-	struct lp5521_chip *chip = i2c_get_clientdata(client);
 	struct device *dev = &client->dev;
-	int i;
 
 	sysfs_remove_group(&dev->kobj, &lp5521_group);
-
-	for (i = 0; i < chip->num_leds; i++)
-		sysfs_remove_group(&chip->leds[i].cdev.dev->kobj,
-				&lp5521_led_attribute_group);
-}
-
-static void lp5521_unregister_leds(struct lp5521_chip *chip)
-{
-	int i;
-
-	for (i = 0; i < chip->num_leds; i++) {
-		led_classdev_unregister(&chip->leds[i].cdev);
-		cancel_work_sync(&chip->leds[i].brightness_work);
-	}
 }
 
 /* Chip specific configurations */
@@ -639,7 +623,6 @@ static struct lp55xx_device_config lp5521_cfg = {
 static int __devinit lp5521_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct lp5521_chip		*old_chip;
 	int ret;
 	struct lp55xx_chip *chip;
 	struct lp55xx_led *led;
@@ -684,7 +667,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	}
 	return ret;
 fail2:
-	lp5521_unregister_leds(old_chip);
+	lp55xx_unregister_leds(led, chip);
 err_register_leds:
 	lp55xx_deinit_device(chip);
 err_init:
@@ -700,7 +683,7 @@ static int __devexit lp5521_remove(struct i2c_client *client)
 	lp5521_run_led_pattern(PATTERN_OFF, old_chip);
 	lp5521_unregister_sysfs(client);
 
-	lp5521_unregister_leds(old_chip);
+	lp55xx_unregister_leds(led, chip);
 	lp55xx_deinit_device(chip);
 
 	return 0;
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 4ae43ac..cb19eb8 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -659,15 +659,9 @@ static int lp5523_register_sysfs(struct i2c_client *client)
 
 static void lp5523_unregister_sysfs(struct i2c_client *client)
 {
-	struct lp5523_chip *chip = i2c_get_clientdata(client);
 	struct device *dev = &client->dev;
-	int i;
 
 	sysfs_remove_group(&dev->kobj, &lp5523_group);
-
-	for (i = 0; i < chip->num_leds; i++)
-		sysfs_remove_group(&chip->leds[i].cdev.dev->kobj,
-				&lp5523_led_attribute_group);
 }
 
 /*--------------------------------------------------------------*/
@@ -712,16 +706,6 @@ static int __init lp5523_init_engine(struct lp5523_engine *engine, int id)
 	return 0;
 }
 
-static void lp5523_unregister_leds(struct lp5523_chip *chip)
-{
-	int i;
-
-	for (i = 0; i < chip->num_leds; i++) {
-		led_classdev_unregister(&chip->leds[i].cdev);
-		flush_work(&chip->leds[i].brightness_work);
-	}
-}
-
 /* Chip specific configurations */
 static struct lp55xx_device_config lp5523_cfg = {
 	.reset = {
@@ -741,8 +725,7 @@ static struct lp55xx_device_config lp5523_cfg = {
 static int __devinit lp5523_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct lp5523_chip		*old_chip;
-	int ret, i;
+	int ret;
 	struct lp55xx_chip *chip;
 	struct lp55xx_led *led;
 	struct lp55xx_platform_data *pdata = client->dev.platform_data;
@@ -786,7 +769,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 	}
 	return ret;
 fail2:
-	lp5523_unregister_leds(old_chip);
+	lp55xx_unregister_leds(led, chip);
 err_register_leds:
 	lp55xx_deinit_device(chip);
 err_init:
@@ -795,7 +778,6 @@ err_init:
 
 static int lp5523_remove(struct i2c_client *client)
 {
-	struct lp5523_chip *old_chip = i2c_get_clientdata(client);
 	struct lp55xx_led *led = i2c_get_clientdata(client);
 	struct lp55xx_chip *chip = led->chip;
 
@@ -804,7 +786,7 @@ static int lp5523_remove(struct i2c_client *client)
 
 	lp5523_unregister_sysfs(client);
 
-	lp5523_unregister_leds(old_chip);
+	lp55xx_unregister_leds(led, chip);
 	lp55xx_deinit_device(chip);
 
 	return 0;
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 81ed90d..b423539 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -352,3 +352,19 @@ err_init_led:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(lp55xx_register_leds);
+
+void lp55xx_unregister_leds(struct lp55xx_led *led, struct lp55xx_chip *chip)
+{
+	int i;
+	struct lp55xx_led *each;
+	struct kobject *kobj;
+
+	for (i = 0; i < chip->num_leds; i++) {
+		each = led + i;
+		kobj = &led->cdev.dev->kobj;
+		sysfs_remove_group(kobj, &lp55xx_led_attr_group);
+		led_classdev_unregister(&each->cdev);
+		flush_work(&each->brightness_work);
+	}
+}
+EXPORT_SYMBOL_GPL(lp55xx_unregister_leds);
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index 595bbf3..c69c73a 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -100,4 +100,6 @@ extern void lp55xx_deinit_device(struct lp55xx_chip *chip);
 /* common LED class device functions */
 extern int lp55xx_register_leds(struct lp55xx_led *led,
 				struct lp55xx_chip *chip);
+extern void lp55xx_unregister_leds(struct lp55xx_led *led,
+				struct lp55xx_chip *chip);
 #endif /* _LEDS_LP55XX_COMMON_H */
-- 
1.7.9.5


Best Regards,
Milo


