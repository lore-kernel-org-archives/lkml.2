Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab2JEITO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:19:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55987 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab2JEITL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:19:11 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/28] leds-lp5521/5523: use lp55xx data on _remove
Thread-Topic: [PATCH 15/28] leds-lp5521/5523: use lp55xx data on _remove
Thread-Index: Ac2i0hKOD/1/9NM7T1GNEziLjmuG4Q==
Date: Fri, 5 Oct 2012 08:19:00 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F641767C4@DQHE02.ent.ti.com>
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

 The lp55xx_led and lp55xx_chip are used in _probe().
 The lp5521_chip and lp5523_chip are not used any more.
 To avoid the compile error, old variable name is changed.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   20 +++++++++++---------
 drivers/leds/leds-lp5523.c |   18 ++++++++++--------
 2 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 06e5e76..56157e8 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -609,21 +609,23 @@ err_init:
 
 static int __devexit lp5521_remove(struct i2c_client *client)
 {
-	struct lp5521_chip *chip = i2c_get_clientdata(client);
+	struct lp5521_chip *old_chip = i2c_get_clientdata(client);
 	int i;
+	struct lp55xx_led *led = i2c_get_clientdata(client);
+	struct lp55xx_chip *chip = led->chip;
 
-	lp5521_run_led_pattern(PATTERN_OFF, chip);
+	lp5521_run_led_pattern(PATTERN_OFF, old_chip);
 	lp5521_unregister_sysfs(client);
 
-	for (i = 0; i < chip->num_leds; i++) {
-		led_classdev_unregister(&chip->leds[i].cdev);
-		cancel_work_sync(&chip->leds[i].brightness_work);
+	for (i = 0; i < old_chip->num_leds; i++) {
+		led_classdev_unregister(&old_chip->leds[i].cdev);
+		cancel_work_sync(&old_chip->leds[i].brightness_work);
 	}
 
-	if (chip->pdata->enable)
-		chip->pdata->enable(0);
-	if (chip->pdata->release_resources)
-		chip->pdata->release_resources();
+	if (old_chip->pdata->enable)
+		old_chip->pdata->enable(0);
+	if (old_chip->pdata->release_resources)
+		old_chip->pdata->release_resources();
 	return 0;
 }
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index f40b058..52a9d85 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -590,23 +590,25 @@ err_init:
 
 static int lp5523_remove(struct i2c_client *client)
 {
-	struct lp5523_chip *chip = i2c_get_clientdata(client);
+	struct lp5523_chip *old_chip = i2c_get_clientdata(client);
 	int i;
+	struct lp55xx_led *led = i2c_get_clientdata(client);
+	struct lp55xx_chip *chip = led->chip;
 
 	/* Disable engine mode */
 	lp5523_write(client, LP5523_REG_OP_MODE, LP5523_CMD_DISABLED);
 
 	lp5523_unregister_sysfs(client);
 
-	for (i = 0; i < chip->num_leds; i++) {
-		led_classdev_unregister(&chip->leds[i].cdev);
-		flush_work(&chip->leds[i].brightness_work);
+	for (i = 0; i < old_chip->num_leds; i++) {
+		led_classdev_unregister(&old_chip->leds[i].cdev);
+		flush_work(&old_chip->leds[i].brightness_work);
 	}
 
-	if (chip->pdata->enable)
-		chip->pdata->enable(0);
-	if (chip->pdata->release_resources)
-		chip->pdata->release_resources();
+	if (old_chip->pdata->enable)
+		old_chip->pdata->enable(0);
+	if (old_chip->pdata->release_resources)
+		old_chip->pdata->release_resources();
 	return 0;
 }
 
-- 
1.7.9.5


Best Regards,
Milo


