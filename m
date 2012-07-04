Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614Ab2GDFNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:13:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54673 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933156Ab2GDFNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:13:12 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/25] leds: convert LM3530 LED driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:10:10 +0800
Message-Id: <1341378617-10386-19-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-lm3530.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 84ba6de..23637bd 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -386,28 +386,24 @@ static int __devinit lm3530_probe(struct i2c_client *client,
 
 	if (pdata == NULL) {
 		dev_err(&client->dev, "platform data required\n");
-		err = -ENODEV;
-		goto err_out;
+		return -ENODEV;
 	}
 
 	/* BL mode */
 	if (pdata->mode > LM3530_BL_MODE_PWM) {
 		dev_err(&client->dev, "Illegal Mode request\n");
-		err = -EINVAL;
-		goto err_out;
+		return -EINVAL;
 	}
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		dev_err(&client->dev, "I2C_FUNC_I2C not supported\n");
-		err = -EIO;
-		goto err_out;
+		return -EIO;
 	}
 
-	drvdata = kzalloc(sizeof(struct lm3530_data), GFP_KERNEL);
-	if (drvdata == NULL) {
-		err = -ENOMEM;
-		goto err_out;
-	}
+	drvdata = devm_kzalloc(&client->dev, sizeof(struct lm3530_data),
+				GFP_KERNEL);
+	if (drvdata == NULL)
+		return -ENOMEM;
 
 	drvdata->mode = pdata->mode;
 	drvdata->client = client;
@@ -425,7 +421,7 @@ static int __devinit lm3530_probe(struct i2c_client *client,
 		dev_err(&client->dev, "regulator get failed\n");
 		err = PTR_ERR(drvdata->regulator);
 		drvdata->regulator = NULL;
-		goto err_regulator_get;
+		return err;
 	}
 
 	if (drvdata->pdata->brt_val) {
@@ -458,9 +454,6 @@ err_create_file:
 err_class_register:
 err_reg_init:
 	regulator_put(drvdata->regulator);
-err_regulator_get:
-	kfree(drvdata);
-err_out:
 	return err;
 }
 
@@ -474,7 +467,6 @@ static int __devexit lm3530_remove(struct i2c_client *client)
 		regulator_disable(drvdata->regulator);
 	regulator_put(drvdata->regulator);
 	led_classdev_unregister(&drvdata->led_dev);
-	kfree(drvdata);
 	return 0;
 }
 
-- 
1.7.10.4

