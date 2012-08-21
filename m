Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2HUGQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 02:16:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34585 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab2HUGQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 02:16:33 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-53-503327aaa1fd
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sameo@linux.intel.com
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/2] mfd: MAX77693: Fix NULL pointer error when initialize irqs
 of Maxim MAX77693
Date: Tue, 21 Aug 2012 15:16:23 +0900
Message-id: <1345529783-24892-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJMWRmVeSWpSXmKPExsVy+t9jQd1V6sYBBlPeWVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MljdPmQr6RSvuTmhmbWC8L9jFyMkhIWAi0dX5kg3CFpO4cG89
	kM3FISQwnVHiwLcfrBDOUiaJS0vWMINUsQloSex/cQOsQ0RAUuLZ43WMIDazwGZGib2N6l2M
	HBzCAskSLffsQUwWAVWJ9n1ZIBW8Aq4SZ45MYILYpSDRuuwQ+wRG7gWMDKsYRVMLkguKk9Jz
	jfSKE3OLS/PS9ZLzczcxgv33THoH46oGi0OMAhyMSjy8PxYZBQixJpYVV+YeYpTgYFYS4W1k
	MA4Q4k1JrKxKLcqPLyrNSS0+xCjNwaIkzsvfZxggJJCeWJKanZpakFoEk2Xi4JRqYOw/dlt0
	95ZtX848UmHk/jVVx9qYSePm33/vnT56XWw49Kph+t3ls6wf2rSqe31S6Nsh9Zt7hd+mJfeW
	Lwgvus6w2+jEJG+ry1Of5hotuWYRHrLtyrwajt1C2149+LXEdNGGq6HpZy/t0vm226fQP5D/
	xHNWu9mnhR/qzi5PKrjLoisyKzF7ueUFJZbijERDLeai4kQAb+O11dsBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch initialize register map of MUIC device because mfd driver
of Maxim MAX77693 use regmap-muic instance of MUIC device when irqs of
Maxim MAX77693 is initialized before call max77693-muic probe() function.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reported-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/extcon/extcon-max77693.c |   20 +++++++++++++-------
 drivers/mfd/max77693.c           |   14 ++++++++++++++
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 920a609..7e98afc 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -669,13 +669,19 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 	}
 	info->dev = &pdev->dev;
 	info->max77693 = max77693;
-	info->max77693->regmap_muic = regmap_init_i2c(info->max77693->muic,
-					 &max77693_muic_regmap_config);
-	if (IS_ERR(info->max77693->egmap_muic)) {
-		ret = PTR_ERR(info->max77693->regmap_muic);
-		dev_err(max77693->dev,
-			"failed to allocate register map: %d\n", ret);
-		goto err_regmap;
+
+	if (info->max77693->regmap_muic)
+		dev_dbg(&pdev->dev, "allocate register map\n");
+	else {
+		info->max77693->regmap_muic = devm_regmap_init_i2c(
+						info->max77693->muic,
+						&max77693_muic_regmap_config);
+		if (IS_ERR(info->max77693->regmap_muic)) {
+			ret = PTR_ERR(info->max77693->regmap_muic);
+			dev_err(max77693->dev,
+				"failed to allocate register map: %d\n", ret);
+			goto err_regmap;
+		}
 	}
 	platform_set_drvdata(pdev, info);
 	mutex_init(&info->mutex);
diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index a1811cb..e1a5a47 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -152,6 +152,20 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	max77693->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
 	i2c_set_clientdata(max77693->haptic, max77693);
 
+	/*
+	 * Initialize register map for MUIC device because use regmap-muic
+	 * instance of MUIC device when irq of max77693 is initialized
+	 * before call max77693-muic probe() function.
+	 */
+	max77693->regmap_muic = devm_regmap_init_i2c(max77693->muic,
+					 &max77693_regmap_config);
+	if (IS_ERR(max77693->regmap_muic)) {
+		ret = PTR_ERR(max77693->regmap_muic);
+		dev_err(max77693->dev,
+			"failed to allocate register map: %d\n", ret);
+		goto err_regmap;
+	}
+
 	ret = max77693_irq_init(max77693);
 	if (ret < 0)
 		goto err_irq;
-- 
1.7.0.4

