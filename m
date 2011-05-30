Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab1E3MTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:19:54 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:60162 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755512Ab1E3MTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:19:53 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <greg@kroah.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH] staging: synaptics: Implement error handling for rmi4 touch regulator
Date: Mon, 30 May 2011 14:16:50 +0200
Message-ID: <1306757810-5291-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>

Implement the error handling for regulator in synaptics
rmi4 touch screen

Signed-off-by: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
---
Somehow this patch has been lost and is pending in my local tree,
so resending. The slowness of the "big" Synaptics driver to emerge
gives me ideas about moving this to drivers/input :-P
---
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c |   43 +++++++++++-------------
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h |    2 -
 2 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index 3e68d58..36f4cb7 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@ -926,17 +926,19 @@ static int __devinit synaptics_rmi4_probe
 		goto err_input;
 	}
 
-	if (platformdata->regulator_en) {
-		rmi4_data->regulator = regulator_get(&client->dev, "vdd");
-		if (IS_ERR(rmi4_data->regulator)) {
-			dev_err(&client->dev, "%s:get regulator failed\n",
-								__func__);
-			retval = PTR_ERR(rmi4_data->regulator);
-			goto err_regulator;
-		}
-		regulator_enable(rmi4_data->regulator);
+	rmi4_data->regulator = regulator_get(&client->dev, "vdd");
+	if (IS_ERR(rmi4_data->regulator)) {
+		dev_err(&client->dev, "%s:get regulator failed\n",
+							__func__);
+		retval = PTR_ERR(rmi4_data->regulator);
+		goto err_get_regulator;
+	}
+	retval = regulator_enable(rmi4_data->regulator);
+	if (retval < 0) {
+		dev_err(&client->dev, "%s:regulator enable failed\n",
+							__func__);
+		goto err_regulator_enable;
 	}
-
 	init_waitqueue_head(&rmi4_data->wait);
 	/*
 	 * Copy i2c_client pointer into RTID's i2c_client pointer for
@@ -1011,11 +1013,10 @@ static int __devinit synaptics_rmi4_probe
 err_free_irq:
 	free_irq(platformdata->irq_number, rmi4_data);
 err_query_dev:
-	if (platformdata->regulator_en) {
-		regulator_disable(rmi4_data->regulator);
-		regulator_put(rmi4_data->regulator);
-	}
-err_regulator:
+	regulator_disable(rmi4_data->regulator);
+err_regulator_enable:
+	regulator_put(rmi4_data->regulator);
+err_get_regulator:
 	input_free_device(rmi4_data->input_dev);
 	rmi4_data->input_dev = NULL;
 err_input:
@@ -1039,10 +1040,8 @@ static int __devexit synaptics_rmi4_remove(struct i2c_client *client)
 	wake_up(&rmi4_data->wait);
 	free_irq(pdata->irq_number, rmi4_data);
 	input_unregister_device(rmi4_data->input_dev);
-	if (pdata->regulator_en) {
-		regulator_disable(rmi4_data->regulator);
-		regulator_put(rmi4_data->regulator);
-	}
+	regulator_disable(rmi4_data->regulator);
+	regulator_put(rmi4_data->regulator);
 	kfree(rmi4_data);
 
 	return 0;
@@ -1080,8 +1079,7 @@ static int synaptics_rmi4_suspend(struct device *dev)
 	if (retval < 0)
 		return retval;
 
-	if (pdata->regulator_en)
-		regulator_disable(rmi4_data->regulator);
+	regulator_disable(rmi4_data->regulator);
 
 	return 0;
 }
@@ -1099,8 +1097,7 @@ static int synaptics_rmi4_resume(struct device *dev)
 	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
 	const struct synaptics_rmi4_platform_data *pdata = rmi4_data->board;
 
-	if (pdata->regulator_en)
-		regulator_enable(rmi4_data->regulator);
+	regulator_enable(rmi4_data->regulator);
 
 	enable_irq(pdata->irq_number);
 	rmi4_data->touch_stopped = false;
diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h
index 3686a2f..384436e 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h
@@ -34,7 +34,6 @@
  * @irq_type: irq type
  * @x flip: x flip flag
  * @y flip: y flip flag
- * @regulator_en: regulator enable flag
  *
  * This structure gives platform data for rmi4.
  */
@@ -43,7 +42,6 @@ struct synaptics_rmi4_platform_data {
 	int irq_type;
 	bool x_flip;
 	bool y_flip;
-	bool regulator_en;
 };
 
 #endif
-- 
1.7.3.2

