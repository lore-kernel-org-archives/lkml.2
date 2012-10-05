Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2JEIP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:15:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55848 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab2JEIP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:15:56 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/28] leds-lp5521/5523: use lp55xx common dev attributes
Thread-Topic: [PATCH 11/28] leds-lp5521/5523: use lp55xx common dev
 attributes
Thread-Index: Ac2i0Z44XsPBB7SyTAuA6+QfAgKYuA==
Date: Fri, 5 Oct 2012 08:15:45 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64176788@DQHE02.ent.ti.com>
Accept-Language: en-US
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

 To run a pattern, LP5521 and LP5523/55231 use different device attributes.
 But it can be consolidated with common device attributes.

 select_engine : Select which engine is used for running program data
 run_engine    : Start program which is loaded via the firmware interface

 Use lp55xx_register_sysfs() rather than lp5521/5523_register_sysfs().
 If an error occurs while registering the device attributes,
 registered LEDs should be released.
 Therefore, new error handling condition is added with lp55xx_unregister_leds().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   18 ++++++++----------
 drivers/leds/leds-lp5523.c |   18 ++++++++----------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 4076f54..45a2d56 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -623,8 +623,7 @@ static struct lp55xx_device_config lp5521_cfg = {
 static int __devinit lp5521_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct lp5521_chip		*old_chip;
-	int ret, i;
+	int ret;
 	struct lp55xx_chip *chip;
 	struct lp55xx_led *led;
 	struct lp55xx_platform_data *pdata = client->dev.platform_data;
@@ -661,17 +660,16 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	if (ret)
 		goto err_register_leds;
 
-	ret = lp5521_register_sysfs(client);
+	ret = lp55xx_register_sysfs(chip);
 	if (ret) {
 		dev_err(&client->dev, "registering sysfs failed\n");
-		goto fail2;
-	}
-	return ret;
-fail2:
-	for (i = 0; i < old_chip->num_leds; i++) {
-		led_classdev_unregister(&old_chip->leds[i].cdev);
-		cancel_work_sync(&old_chip->leds[i].brightness_work);
+		goto err_register_sysfs;
 	}
+
+	return 0;
+
+err_register_sysfs:
+	lp55xx_unregister_leds(led, chip);
 err_register_leds:
 	lp55xx_deinit_device(chip);
 err_init:
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 85521f8..e262fdc 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -705,8 +705,7 @@ static struct lp55xx_device_config lp5523_cfg = {
 static int __devinit lp5523_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct lp5523_chip		*old_chip;
-	int ret, i;
+	int ret;
 	struct lp55xx_chip *chip;
 	struct lp55xx_led *led;
 	struct lp55xx_platform_data *pdata = client->dev.platform_data;
@@ -743,17 +742,16 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 	if (ret)
 		goto err_register_leds;
 
-	ret = lp5523_register_sysfs(client);
+	ret = lp55xx_register_sysfs(chip);
 	if (ret) {
 		dev_err(&client->dev, "registering sysfs failed\n");
-		goto fail2;
-	}
-	return ret;
-fail2:
-	for (i = 0; i < old_chip->num_leds; i++) {
-		led_classdev_unregister(&old_chip->leds[i].cdev);
-		flush_work(&old_chip->leds[i].brightness_work);
+		goto err_register_sysfs;
 	}
+
+	return 0;
+
+err_register_sysfs:
+	lp55xx_unregister_leds(led, chip);
 err_register_leds:
 	lp55xx_deinit_device(chip);
 err_init:
-- 
1.7.9.5


Best Regards,
Milo


