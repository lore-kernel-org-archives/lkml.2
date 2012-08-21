Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab2HUKII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:08:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2HUKIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:08:06 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] PM/devfreq: Use devm_* functions in exynos4_bus.c
Date: Tue, 21 Aug 2012 15:35:32 +0530
Message-Id: <1345543532-6714-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* functions are device managed functions and make cleanup code
simpler and smaller.
devm_kzalloc and devm_regulator_get functions are used.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/devfreq/exynos4_bus.c |   41 +++++++++++------------------------------
 1 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index 88ddc77..6814531 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -987,7 +987,7 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	int err = 0;
 
-	data = kzalloc(sizeof(struct busfreq_data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(struct busfreq_data), GFP_KERNEL);
 	if (data == NULL) {
 		dev_err(dev, "Cannot allocate memory.\n");
 		return -ENOMEM;
@@ -1012,22 +1012,18 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
 		err = -EINVAL;
 	}
 	if (err)
-		goto err_regulator;
+		return err;
 
-	data->vdd_int = regulator_get(dev, "vdd_int");
+	data->vdd_int = devm_regulator_get(dev, "vdd_int");
 	if (IS_ERR(data->vdd_int)) {
 		dev_err(dev, "Cannot get the regulator \"vdd_int\"\n");
-		err = PTR_ERR(data->vdd_int);
-		goto err_regulator;
+		return PTR_ERR(data->vdd_int);
 	}
 	if (data->type == TYPE_BUSF_EXYNOS4x12) {
-		data->vdd_mif = regulator_get(dev, "vdd_mif");
+		data->vdd_mif = devm_regulator_get(dev, "vdd_mif");
 		if (IS_ERR(data->vdd_mif)) {
 			dev_err(dev, "Cannot get the regulator \"vdd_mif\"\n");
-			err = PTR_ERR(data->vdd_mif);
-			regulator_put(data->vdd_int);
-			goto err_regulator;
-
+			return PTR_ERR(data->vdd_mif);
 		}
 	}
 
@@ -1035,8 +1031,7 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
 	if (IS_ERR(opp)) {
 		dev_err(dev, "Invalid initial frequency %lu kHz.\n",
 		       exynos4_devfreq_profile.initial_freq);
-		err = PTR_ERR(opp);
-		goto err_opp_add;
+		return PTR_ERR(opp);
 	}
 	data->curr_opp = opp;
 
@@ -1046,29 +1041,19 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
 
 	data->devfreq = devfreq_add_device(dev, &exynos4_devfreq_profile,
 					   &devfreq_simple_ondemand, NULL);
-	if (IS_ERR(data->devfreq)) {
-		err = PTR_ERR(data->devfreq);
-		goto err_opp_add;
-	}
+	if (IS_ERR(data->devfreq))
+		return PTR_ERR(data->devfreq);
 
 	devfreq_register_opp_notifier(dev, data->devfreq);
 
 	err = register_pm_notifier(&data->pm_notifier);
 	if (err) {
 		dev_err(dev, "Failed to setup pm notifier\n");
-		goto err_devfreq_add;
+		devfreq_remove_device(data->devfreq);
+		return err;
 	}
 
 	return 0;
-err_devfreq_add:
-	devfreq_remove_device(data->devfreq);
-err_opp_add:
-	if (data->vdd_mif)
-		regulator_put(data->vdd_mif);
-	regulator_put(data->vdd_int);
-err_regulator:
-	kfree(data);
-	return err;
 }
 
 static __devexit int exynos4_busfreq_remove(struct platform_device *pdev)
@@ -1077,10 +1062,6 @@ static __devexit int exynos4_busfreq_remove(struct platform_device *pdev)
 
 	unregister_pm_notifier(&data->pm_notifier);
 	devfreq_remove_device(data->devfreq);
-	regulator_put(data->vdd_int);
-	if (data->vdd_mif)
-		regulator_put(data->vdd_mif);
-	kfree(data);
 
 	return 0;
 }
-- 
1.7.4.1

