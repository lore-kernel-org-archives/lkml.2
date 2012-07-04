Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab2GDFLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:11:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54649 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2GDFLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:11:45 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/25] leds: convert LP5523 LED driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:10:01 +0800
Message-Id: <1341378617-10386-10-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Mathias Nyman <mathias.nyman@nokia.com>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-lp5523.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index e8a2712..fbc12ac 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -877,7 +877,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 	struct lp5523_platform_data	*pdata;
 	int ret, i, led;
 
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
@@ -888,8 +888,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 
 	if (!pdata) {
 		dev_err(&client->dev, "no platform data\n");
-		ret = -EINVAL;
-		goto fail1;
+		return -EINVAL;
 	}
 
 	mutex_init(&chip->lock);
@@ -899,7 +898,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 	if (pdata->setup_resources) {
 		ret = pdata->setup_resources();
 		if (ret < 0)
-			goto fail1;
+			return ret;
 	}
 
 	if (pdata->enable) {
@@ -916,7 +915,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 				     */
 	ret = lp5523_detect(client);
 	if (ret)
-		goto fail2;
+		goto fail1;
 
 	dev_info(&client->dev, "LP5523 Programmable led chip found\n");
 
@@ -925,13 +924,13 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 		ret = lp5523_init_engine(&chip->engines[i], i + 1);
 		if (ret) {
 			dev_err(&client->dev, "error initializing engine\n");
-			goto fail2;
+			goto fail1;
 		}
 	}
 	ret = lp5523_configure(client);
 	if (ret < 0) {
 		dev_err(&client->dev, "error configuring chip\n");
-		goto fail2;
+		goto fail1;
 	}
 
 	/* Initialize leds */
@@ -949,7 +948,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 		ret = lp5523_init_led(&chip->leds[led], &client->dev, i, pdata);
 		if (ret) {
 			dev_err(&client->dev, "error initializing leds\n");
-			goto fail3;
+			goto fail2;
 		}
 		chip->num_leds++;
 
@@ -965,21 +964,19 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 	ret = lp5523_register_sysfs(client);
 	if (ret) {
 		dev_err(&client->dev, "registering sysfs failed\n");
-		goto fail3;
+		goto fail2;
 	}
 	return ret;
-fail3:
+fail2:
 	for (i = 0; i < chip->num_leds; i++) {
 		led_classdev_unregister(&chip->leds[i].cdev);
 		cancel_work_sync(&chip->leds[i].brightness_work);
 	}
-fail2:
+fail1:
 	if (pdata->enable)
 		pdata->enable(0);
 	if (pdata->release_resources)
 		pdata->release_resources();
-fail1:
-	kfree(chip);
 	return ret;
 }
 
@@ -999,7 +996,6 @@ static int lp5523_remove(struct i2c_client *client)
 		chip->pdata->enable(0);
 	if (chip->pdata->release_resources)
 		chip->pdata->release_resources();
-	kfree(chip);
 	return 0;
 }
 
-- 
1.7.10.4

