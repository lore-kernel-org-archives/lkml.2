Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2LLOCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:02:51 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47957 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816Ab2LLOCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:02:47 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/33] leds-lp55xx: clean up _remove()
Thread-Topic: [PATCH 25/33] leds-lp55xx: clean up _remove()
Thread-Index: Ac3YcVr4fOHtMjuFQbuhMlVwaTubLA==
Date: Wed, 12 Dec 2012 14:02:44 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0ABDF@DQHE02.ent.ti.com>
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

 Replaced lp5521_unregister_sysfs() and lp5523_unregister_sysfs()
 with lp55xx_unregister_sysfs().

 On unloading the driver, running LED pattern should be stopped.
 Use explicit driver functions rather than old functions and direct access code.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   13 ++-----------
 drivers/leds/leds-lp5523.c |   14 ++------------
 2 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 9d37cb4..65eaaeb 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -505,13 +505,6 @@ static const struct attribute_group lp5521_group = {
 	.attrs = lp5521_attributes,
 };
 
-static void lp5521_unregister_sysfs(struct i2c_client *client)
-{
-	struct device *dev = &client->dev;
-
-	sysfs_remove_group(&dev->kobj, &lp5521_group);
-}
-
 /* Chip specific configurations */
 static struct lp55xx_device_config lp5521_cfg = {
 	.reset = {
@@ -589,13 +582,11 @@ err_init:
 
 static int __devexit lp5521_remove(struct i2c_client *client)
 {
-	struct lp5521_chip *old_chip = i2c_get_clientdata(client);
 	struct lp55xx_led *led = i2c_get_clientdata(client);
 	struct lp55xx_chip *chip = led->chip;
 
-	lp5521_run_led_pattern(PATTERN_OFF, old_chip);
-	lp5521_unregister_sysfs(client);
-
+	lp5521_stop_engine(chip);
+	lp55xx_unregister_sysfs(chip);
 	lp55xx_unregister_leds(led, chip);
 	lp55xx_deinit_device(chip);
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index a0b49fc..63dec47 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -482,13 +482,6 @@ static const struct attribute_group lp5523_group = {
 	.attrs = lp5523_attributes,
 };
 
-static void lp5523_unregister_sysfs(struct i2c_client *client)
-{
-	struct device *dev = &client->dev;
-
-	sysfs_remove_group(&dev->kobj, &lp5523_group);
-}
-
 /* Chip specific configurations */
 static struct lp55xx_device_config lp5523_cfg = {
 	.reset = {
@@ -569,11 +562,8 @@ static int lp5523_remove(struct i2c_client *client)
 	struct lp55xx_led *led = i2c_get_clientdata(client);
 	struct lp55xx_chip *chip = led->chip;
 
-	/* Disable engine mode */
-	lp5523_write(client, LP5523_REG_OP_MODE, LP5523_CMD_DISABLED);
-
-	lp5523_unregister_sysfs(client);
-
+	lp5523_stop_engine(chip);
+	lp55xx_unregister_sysfs(chip);
 	lp55xx_unregister_leds(led, chip);
 	lp55xx_deinit_device(chip);
 
-- 
1.7.9.5


Best Regards,
Milo


