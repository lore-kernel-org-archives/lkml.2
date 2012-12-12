Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2LLOH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:07:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50785 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab2LLOB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:01:29 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/33] leds-lp55xx: use lp55xx common deinit function
Thread-Topic: [PATCH 11/33] leds-lp55xx: use lp55xx common deinit function
Thread-Index: Ac3YcSwoyJ3e4osiQZy88q3b6Ax2ZA==
Date: Wed, 12 Dec 2012 14:01:25 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AB35@DQHE02.ent.ti.com>
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

 Two separate de-init functions are merged into one common function.
 And it is used in err_post_init of lp55xx_init_device().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c        |   16 ++++------------
 drivers/leds/leds-lp5523.c        |   16 ++++------------
 drivers/leds/leds-lp55xx-common.c |   15 ++++++++++++---
 drivers/leds/leds-lp55xx-common.h |    3 ++-
 4 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index b07784c..99f35b8 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -684,16 +684,6 @@ static void lp5521_unregister_sysfs(struct i2c_client *client)
 				&lp5521_led_attribute_group);
 }
 
-static void lp5521_deinit_device(struct lp5521_chip *chip)
-{
-	struct lp5521_platform_data *pdata = chip->pdata;
-
-	if (pdata->enable)
-		pdata->enable(0);
-	if (pdata->release_resources)
-		pdata->release_resources();
-}
-
 static int __devinit lp5521_init_led(struct lp5521_led *led,
 				struct i2c_client *client,
 				int chan, struct lp5521_platform_data *pdata)
@@ -854,7 +844,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 fail2:
 	lp5521_unregister_leds(old_chip);
 fail1:
-	lp5521_deinit_device(old_chip);
+	lp55xx_deinit_device(chip);
 err_init:
 	return ret;
 }
@@ -862,13 +852,15 @@ err_init:
 static int __devexit lp5521_remove(struct i2c_client *client)
 {
 	struct lp5521_chip *old_chip = i2c_get_clientdata(client);
+	struct lp55xx_led *led = i2c_get_clientdata(client);
+	struct lp55xx_chip *chip = led->chip;
 
 	lp5521_run_led_pattern(PATTERN_OFF, old_chip);
 	lp5521_unregister_sysfs(client);
 
 	lp5521_unregister_leds(old_chip);
+	lp55xx_deinit_device(chip);
 
-	lp5521_deinit_device(old_chip);
 	return 0;
 }
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 63e74d2..2f5213d 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -884,16 +884,6 @@ static void lp5523_unregister_leds(struct lp5523_chip *chip)
 	}
 }
 
-static void lp5523_deinit_device(struct lp5523_chip *chip)
-{
-	struct lp5523_platform_data *pdata = chip->pdata;
-
-	if (pdata->enable)
-		pdata->enable(0);
-	if (pdata->release_resources)
-		pdata->release_resources();
-}
-
 /* Chip specific configurations */
 static struct lp55xx_device_config lp5523_cfg = {
 	.reset = {
@@ -957,7 +947,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 fail2:
 	lp5523_unregister_leds(old_chip);
 fail1:
-	lp5523_deinit_device(old_chip);
+	lp55xx_deinit_device(chip);
 err_init:
 	return ret;
 }
@@ -965,6 +955,8 @@ err_init:
 static int lp5523_remove(struct i2c_client *client)
 {
 	struct lp5523_chip *old_chip = i2c_get_clientdata(client);
+	struct lp55xx_led *led = i2c_get_clientdata(client);
+	struct lp55xx_chip *chip = led->chip;
 
 	/* Disable engine mode */
 	lp5523_write(client, LP5523_REG_OP_MODE, LP5523_CMD_DISABLED);
@@ -972,8 +964,8 @@ static int lp5523_remove(struct i2c_client *client)
 	lp5523_unregister_sysfs(client);
 
 	lp5523_unregister_leds(old_chip);
+	lp55xx_deinit_device(chip);
 
-	lp5523_deinit_device(old_chip);
 	return 0;
 }
 
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index bf21765..66ba500 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -152,11 +152,20 @@ int lp55xx_init_device(struct lp55xx_chip *chip)
 	return 0;
 
 err_post_init:
+	lp55xx_deinit_device(chip);
+err:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lp55xx_init_device);
+
+void lp55xx_deinit_device(struct lp55xx_chip *chip)
+{
+	struct lp55xx_platform_data *pdata = chip->pdata;
+
 	if (pdata->enable)
 		pdata->enable(0);
+
 	if (pdata->release_resources)
 		pdata->release_resources();
-err:
-	return ret;
 }
-EXPORT_SYMBOL_GPL(lp55xx_init_device);
+EXPORT_SYMBOL_GPL(lp55xx_deinit_device);
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index ffedc77..908b00a 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -84,7 +84,8 @@ extern int lp55xx_read(struct lp55xx_chip *chip, u8 reg, u8 *val);
 extern int lp55xx_update_bits(struct lp55xx_chip *chip, u8 reg,
 			u8 mask, u8 val);
 
-/* common device init functions */
+/* common device init/deinit functions */
 extern int lp55xx_init_device(struct lp55xx_chip *chip);
+extern void lp55xx_deinit_device(struct lp55xx_chip *chip);
 
 #endif /* _LEDS_LP55XX_COMMON_H */
-- 
1.7.9.5


Best Regards,
Milo


