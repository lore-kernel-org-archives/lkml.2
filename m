Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2JEIVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:21:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58151 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab2JEIVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:21:49 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/28] leds-lp5521/5523: use lp55xx common unregister
 function
Thread-Topic: [PATCH 18/28] leds-lp5521/5523: use lp55xx common unregister
 function
Thread-Index: Ac2i0m6/aawIb6g9Tqemo6ZGRCTdAw==
Date: Fri, 5 Oct 2012 08:21:35 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F641767F7@DQHE02.ent.ti.com>
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

 On _probe(), the lp55xx common function is used for LEDs registration.
 While unloading the driver, use lp55xx common function to unregister LEDs

 LP5521 driver uses cancel_work_sync(), but flush_work() makes sense
 because the brightness is set to 0 on removing the driver.
 The flush_work() is called in the lp55xx_unregister_leds().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |    7 +------
 drivers/leds/leds-lp5523.c |    7 +------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 786b539..8aa4a90 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -529,18 +529,13 @@ err_init:
 static int __devexit lp5521_remove(struct i2c_client *client)
 {
 	struct lp5521_chip *old_chip = i2c_get_clientdata(client);
-	int i;
 	struct lp55xx_led *led = i2c_get_clientdata(client);
 	struct lp55xx_chip *chip = led->chip;
 
 	lp5521_stop_engine(chip);
 
 	lp55xx_unregister_sysfs(chip);
-
-	for (i = 0; i < old_chip->num_leds; i++) {
-		led_classdev_unregister(&old_chip->leds[i].cdev);
-		cancel_work_sync(&old_chip->leds[i].brightness_work);
-	}
+	lp55xx_unregister_leds(led, chip);
 
 	if (old_chip->pdata->enable)
 		old_chip->pdata->enable(0);
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index c9229fc..b029a09 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -584,18 +584,13 @@ err_init:
 static int lp5523_remove(struct i2c_client *client)
 {
 	struct lp5523_chip *old_chip = i2c_get_clientdata(client);
-	int i;
 	struct lp55xx_led *led = i2c_get_clientdata(client);
 	struct lp55xx_chip *chip = led->chip;
 
 	lp5523_stop_engine(chip);
 
 	lp55xx_unregister_sysfs(chip);
-
-	for (i = 0; i < old_chip->num_leds; i++) {
-		led_classdev_unregister(&old_chip->leds[i].cdev);
-		flush_work(&old_chip->leds[i].brightness_work);
-	}
+	lp55xx_unregister_leds(led, chip);
 
 	if (old_chip->pdata->enable)
 		old_chip->pdata->enable(0);
-- 
1.7.9.5


Best Regards,
Milo


