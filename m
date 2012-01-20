Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab2ATVZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 16:25:49 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:40277 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab2ATVZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 16:25:40 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: kernel-janitors@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] drivers/video/backlight: use devm_ functions
Date: Fri, 20 Jan 2012 22:25:31 +0100
Message-Id: <1327094732-9050-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1327094732-9050-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1327094732-9050-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/video/backlight/88pm860x_bl.c        |    8 ++------
 drivers/video/backlight/aat2870_bl.c         |    9 ++++-----
 drivers/video/backlight/cr_bllcd.c           |    3 +--
 drivers/video/backlight/da903x_bl.c          |    6 +-----
 drivers/video/backlight/max8925_bl.c         |    7 ++-----
 drivers/video/backlight/omap1_bl.c           |    9 +++------
 drivers/video/backlight/pcf50633-backlight.c |   16 +++-------------
 drivers/video/backlight/pwm_bl.c             |    7 ++-----
 8 files changed, 18 insertions(+), 47 deletions(-)

diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index a1376dc..915943a 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -187,7 +187,8 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	data = kzalloc(sizeof(struct pm860x_backlight_data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(struct pm860x_backlight_data),
+			    GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 	strncpy(name, res->name, MFD_NAME_SIZE);
@@ -200,7 +201,6 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 	data->port = pdata->flags;
 	if (data->port < 0) {
 		dev_err(&pdev->dev, "wrong platform data is assigned");
-		kfree(data);
 		return -EINVAL;
 	}
 
@@ -211,7 +211,6 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 					&pm860x_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
-		kfree(data);
 		return PTR_ERR(bl);
 	}
 	bl->props.brightness = MAX_BRIGHTNESS;
@@ -247,17 +246,14 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 	return 0;
 out:
 	backlight_device_unregister(bl);
-	kfree(data);
 	return ret;
 }
 
 static int pm860x_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
-	struct pm860x_backlight_data *data = bl_get_data(bl);
 
 	backlight_device_unregister(bl);
-	kfree(data);
 	return 0;
 }
 
diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
index 331f1ef..7ff7522 100644
--- a/drivers/video/backlight/aat2870_bl.c
+++ b/drivers/video/backlight/aat2870_bl.c
@@ -145,7 +145,9 @@ static int aat2870_bl_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	aat2870_bl = kzalloc(sizeof(struct aat2870_bl_driver_data), GFP_KERNEL);
+	aat2870_bl = devm_kzalloc(&pdev->dev,
+				  sizeof(struct aat2870_bl_driver_data),
+				  GFP_KERNEL);
 	if (!aat2870_bl) {
 		dev_err(&pdev->dev,
 			"Failed to allocate memory for aat2870 backlight\n");
@@ -162,7 +164,7 @@ static int aat2870_bl_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev,
 			"Failed allocate memory for backlight device\n");
 		ret = PTR_ERR(bd);
-		goto out_kfree;
+		goto out;
 	}
 
 	aat2870_bl->pdev = pdev;
@@ -199,8 +201,6 @@ static int aat2870_bl_probe(struct platform_device *pdev)
 
 out_bl_dev_unregister:
 	backlight_device_unregister(bd);
-out_kfree:
-	kfree(aat2870_bl);
 out:
 	return ret;
 }
@@ -215,7 +215,6 @@ static int aat2870_bl_remove(struct platform_device *pdev)
 	backlight_update_status(bd);
 
 	backlight_device_unregister(bd);
-	kfree(aat2870_bl);
 
 	return 0;
 }
diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index 6c8c540..22489eb 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -212,7 +212,7 @@ static int cr_backlight_probe(struct platform_device *pdev)
 			      &gpio_bar);
 	gpio_bar &= ~0x3F;
 
-	crp = kzalloc(sizeof(*crp), GFP_KERNEL);
+	crp = devm_kzalloc(&pdev->dev, sizeof(*crp), GFP_KERNEL);
 	if (!crp) {
 		lcd_device_unregister(ldp);
 		backlight_device_unregister(bdp);
@@ -243,7 +243,6 @@ static int cr_backlight_remove(struct platform_device *pdev)
 	backlight_device_unregister(crp->cr_backlight_device);
 	lcd_device_unregister(crp->cr_lcd_device);
 	pci_dev_put(lpc_dev);
-	kfree(crp);
 
 	return 0;
 }
diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index abb4a06..30e1968 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -110,7 +110,7 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 	struct backlight_properties props;
 	int max_brightness;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -124,7 +124,6 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 	default:
 		dev_err(&pdev->dev, "invalid backlight device ID(%d)\n",
 				pdev->id);
-		kfree(data);
 		return -EINVAL;
 	}
 
@@ -143,7 +142,6 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 				       &da903x_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
-		kfree(data);
 		return PTR_ERR(bl);
 	}
 
@@ -157,10 +155,8 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 static int da903x_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
-	struct da903x_backlight_data *data = bl_get_data(bl);
 
 	backlight_device_unregister(bl);
-	kfree(data);
 	return 0;
 }
 
diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index c915e3b..e833ac7 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -129,7 +129,8 @@ static int __devinit max8925_backlight_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	data = kzalloc(sizeof(struct max8925_backlight_data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(struct max8925_backlight_data),
+			    GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 	strncpy(name, res->name, MAX8925_NAME_SIZE);
@@ -143,7 +144,6 @@ static int __devinit max8925_backlight_probe(struct platform_device *pdev)
 					&max8925_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
-		kfree(data);
 		return PTR_ERR(bl);
 	}
 	bl->props.brightness = MAX_BRIGHTNESS;
@@ -165,17 +165,14 @@ static int __devinit max8925_backlight_probe(struct platform_device *pdev)
 	return 0;
 out:
 	backlight_device_unregister(bl);
-	kfree(data);
 	return ret;
 }
 
 static int __devexit max8925_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
-	struct max8925_backlight_data *data = bl_get_data(bl);
 
 	backlight_device_unregister(bl);
-	kfree(data);
 	return 0;
 }
 
diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index d8cde27..0175bfb 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -141,7 +141,8 @@ static int omapbl_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -ENXIO;
 
-	bl = kzalloc(sizeof(struct omap_backlight), GFP_KERNEL);
+	bl = devm_kzalloc(&pdev->dev, sizeof(struct omap_backlight),
+			  GFP_KERNEL);
 	if (unlikely(!bl))
 		return -ENOMEM;
 
@@ -150,10 +151,8 @@ static int omapbl_probe(struct platform_device *pdev)
 	props.max_brightness = OMAPBL_MAX_INTENSITY;
 	dev = backlight_device_register("omap-bl", &pdev->dev, bl, &omapbl_ops,
 					&props);
-	if (IS_ERR(dev)) {
-		kfree(bl);
+	if (IS_ERR(dev))
 		return PTR_ERR(dev);
-	}
 
 	bl->powermode = FB_BLANK_POWERDOWN;
 	bl->current_intensity = 0;
@@ -177,10 +176,8 @@ static int omapbl_probe(struct platform_device *pdev)
 static int omapbl_remove(struct platform_device *pdev)
 {
 	struct backlight_device *dev = platform_get_drvdata(pdev);
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
 
 	backlight_device_unregister(dev);
-	kfree(bl);
 
 	return 0;
 }
diff --git a/drivers/video/backlight/pcf50633-backlight.c b/drivers/video/backlight/pcf50633-backlight.c
index 13e88b7..c65853c 100644
--- a/drivers/video/backlight/pcf50633-backlight.c
+++ b/drivers/video/backlight/pcf50633-backlight.c
@@ -101,14 +101,13 @@ static const struct backlight_ops pcf50633_bl_ops = {
 
 static int __devinit pcf50633_bl_probe(struct platform_device *pdev)
 {
-	int ret;
 	struct pcf50633_bl *pcf_bl;
 	struct device *parent = pdev->dev.parent;
 	struct pcf50633_platform_data *pcf50633_data = parent->platform_data;
 	struct pcf50633_bl_platform_data *pdata = pcf50633_data->backlight_data;
 	struct backlight_properties bl_props;
 
-	pcf_bl = kzalloc(sizeof(*pcf_bl), GFP_KERNEL);
+	pcf_bl = devm_kzalloc(&pdev->dev, sizeof(*pcf_bl), GFP_KERNEL);
 	if (!pcf_bl)
 		return -ENOMEM;
 
@@ -129,10 +128,8 @@ static int __devinit pcf50633_bl_probe(struct platform_device *pdev)
 	pcf_bl->bl = backlight_device_register(pdev->name, &pdev->dev, pcf_bl,
 						&pcf50633_bl_ops, &bl_props);
 
-	if (IS_ERR(pcf_bl->bl)) {
-		ret = PTR_ERR(pcf_bl->bl);
-		goto err_free;
-	}
+	if (IS_ERR(pcf_bl->bl))
+		return PTR_ERR(pcf_bl->bl);
 
 	platform_set_drvdata(pdev, pcf_bl);
 
@@ -145,11 +142,6 @@ static int __devinit pcf50633_bl_probe(struct platform_device *pdev)
 	backlight_update_status(pcf_bl->bl);
 
 	return 0;
-
-err_free:
-	kfree(pcf_bl);
-
-	return ret;
 }
 
 static int __devexit pcf50633_bl_remove(struct platform_device *pdev)
@@ -160,8 +152,6 @@ static int __devexit pcf50633_bl_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	kfree(pcf_bl);
-
 	return 0;
 }
 
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 7496d04..342b7d7 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -102,7 +102,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 			return ret;
 	}
 
-	pb = kzalloc(sizeof(*pb), GFP_KERNEL);
+	pb = devm_kzalloc(&pdev->dev, sizeof(*pb), GFP_KERNEL);
 	if (!pb) {
 		dev_err(&pdev->dev, "no memory for state\n");
 		ret = -ENOMEM;
@@ -121,7 +121,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	if (IS_ERR(pb->pwm)) {
 		dev_err(&pdev->dev, "unable to request PWM for backlight\n");
 		ret = PTR_ERR(pb->pwm);
-		goto err_pwm;
+		goto err_alloc;
 	} else
 		dev_dbg(&pdev->dev, "got pwm for backlight\n");
 
@@ -144,8 +144,6 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 
 err_bl:
 	pwm_free(pb->pwm);
-err_pwm:
-	kfree(pb);
 err_alloc:
 	if (data->exit)
 		data->exit(&pdev->dev);
@@ -162,7 +160,6 @@ static int pwm_backlight_remove(struct platform_device *pdev)
 	pwm_config(pb->pwm, 0, pb->period);
 	pwm_disable(pb->pwm);
 	pwm_free(pb->pwm);
-	kfree(pb);
 	if (data->exit)
 		data->exit(&pdev->dev);
 	return 0;

