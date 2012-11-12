Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab2KLOle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:41:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42979 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab2KLOlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:41:32 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
CC: <linux-leds@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 2/3] leds: leds-pwm: Preparing the driver for device tree support
Date: Mon, 12 Nov 2012 15:41:09 +0100
Message-ID: <1352731270-27534-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com>
References: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be able to add device tree support for leds-pwm driver we need
to rearrange the data structures used by the drivers.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/leds/leds-pwm.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index c953c75..b219ea9 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -30,6 +30,11 @@ struct led_pwm_data {
 	unsigned int		period;
 };
 
+struct led_pwm_priv {
+	int num_leds;
+	struct led_pwm_data leds[];
+};
+
 static void led_pwm_set(struct led_classdev *led_cdev,
 	enum led_brightness brightness)
 {
@@ -47,25 +52,29 @@ static void led_pwm_set(struct led_classdev *led_cdev,
 	}
 }
 
+static inline int sizeof_pwm_leds_priv(int num_leds)
+{
+	return sizeof(struct led_pwm_priv) +
+		      (sizeof(struct led_pwm_data) * num_leds);
+}
+
 static int led_pwm_probe(struct platform_device *pdev)
 {
 	struct led_pwm_platform_data *pdata = pdev->dev.platform_data;
-	struct led_pwm *cur_led;
-	struct led_pwm_data *leds_data, *led_dat;
+	struct led_pwm_priv *priv;
 	int i, ret = 0;
 
 	if (!pdata)
 		return -EBUSY;
 
-	leds_data = devm_kzalloc(&pdev->dev,
-			sizeof(struct led_pwm_data) * pdata->num_leds,
-				GFP_KERNEL);
-	if (!leds_data)
+	priv = devm_kzalloc(&pdev->dev, sizeof_pwm_leds_priv(pdata->num_leds),
+			    GFP_KERNEL);
+	if (!priv)
 		return -ENOMEM;
 
 	for (i = 0; i < pdata->num_leds; i++) {
-		cur_led = &pdata->leds[i];
-		led_dat = &leds_data[i];
+		struct led_pwm *cur_led = &pdata->leds[i];
+		struct led_pwm_data *led_dat = &priv->leds[i];
 
 		led_dat->pwm = devm_pwm_get(&pdev->dev, cur_led->name);
 		if (IS_ERR(led_dat->pwm)) {
@@ -88,15 +97,16 @@ static int led_pwm_probe(struct platform_device *pdev)
 		if (ret < 0)
 			goto err;
 	}
+	priv->num_leds = pdata->num_leds;
 
-	platform_set_drvdata(pdev, leds_data);
+	platform_set_drvdata(pdev, priv);
 
 	return 0;
 
 err:
 	if (i > 0) {
 		for (i = i - 1; i >= 0; i--)
-			led_classdev_unregister(&leds_data[i].cdev);
+			led_classdev_unregister(&priv->leds[i].cdev);
 	}
 
 	return ret;
@@ -104,14 +114,11 @@ err:
 
 static int __devexit led_pwm_remove(struct platform_device *pdev)
 {
+	struct led_pwm_priv *priv = platform_get_drvdata(pdev);
 	int i;
-	struct led_pwm_platform_data *pdata = pdev->dev.platform_data;
-	struct led_pwm_data *leds_data;
-
-	leds_data = platform_get_drvdata(pdev);
 
-	for (i = 0; i < pdata->num_leds; i++)
-		led_classdev_unregister(&leds_data[i].cdev);
+	for (i = 0; i < priv->num_leds; i++)
+		led_classdev_unregister(&priv->leds[i].cdev);
 
 	return 0;
 }
-- 
1.8.0

