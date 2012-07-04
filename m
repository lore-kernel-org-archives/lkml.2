Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab2GDFLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:11:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54642 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2GDFLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:11:20 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/25] leds: convert LP5521 LED driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:09:58 +0800
Message-Id: <1341378617-10386-7-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-lp5521.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 2381562..760d743 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -744,7 +744,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	int ret, i, led;
 	u8 buf;
 
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
@@ -755,8 +755,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 
 	if (!pdata) {
 		dev_err(&client->dev, "no platform data\n");
-		ret = -EINVAL;
-		goto fail1;
+		return -EINVAL;
 	}
 
 	mutex_init(&chip->lock);
@@ -766,7 +765,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	if (pdata->setup_resources) {
 		ret = pdata->setup_resources();
 		if (ret < 0)
-			goto fail1;
+			return ret;
 	}
 
 	if (pdata->enable) {
@@ -807,7 +806,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	ret = lp5521_configure(client);
 	if (ret < 0) {
 		dev_err(&client->dev, "error configuring chip\n");
-		goto fail2;
+		goto fail1;
 	}
 
 	/* Initialize leds */
@@ -840,21 +839,19 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	ret = lp5521_register_sysfs(client);
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
 
@@ -875,7 +872,6 @@ static int __devexit lp5521_remove(struct i2c_client *client)
 		chip->pdata->enable(0);
 	if (chip->pdata->release_resources)
 		chip->pdata->release_resources();
-	kfree(chip);
 	return 0;
 }
 
-- 
1.7.10.4

