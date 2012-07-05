Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab2GEPM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:12:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42449 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2GEPMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:12:54 -0400
Message-ID: <1341501169.14503.4.camel@phoenix>
Subject: [RFC/RFT][PATCH 2/2] regulator: s5m8767: Properly handle
 gpio_request failure
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Jul 2012 23:12:49 +0800
In-Reply-To: <1341500817.14503.1.camel@phoenix>
References: <1341500817.14503.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to devm_gpio_request to save a few error handling code.

This patch properly handle the gpio_request failure, we should return error
when gpio_request fails rather than just show warning.

I think one of the reason we got -EBUSY is because current code does not free
gpios in s5m8767_pmic_remove(). So it got -EBUSY when reload the module.

Yest another reason is in current code if gpio_request() returns error,
the rest of the code still calls gpio_direction_output to config buck_gpios
and buck_ds gpios. This looks wrong to me.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/s5m8767.c |   49 +++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 5df3358..297f696 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -559,20 +559,21 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 	if (gpio_is_valid(pdata->buck_gpios[0]) &&
 		gpio_is_valid(pdata->buck_gpios[1]) &&
 		gpio_is_valid(pdata->buck_gpios[2])) {
-		ret = gpio_request(pdata->buck_gpios[0], "S5M8767 SET1");
-		if (ret == -EBUSY)
-			dev_warn(&pdev->dev, "Duplicated gpio request"
-				" for SET1\n");
-
-		ret = gpio_request(pdata->buck_gpios[1], "S5M8767 SET2");
-		if (ret == -EBUSY)
-			dev_warn(&pdev->dev, "Duplicated gpio request"
-				" for SET2\n");
-
-		ret = gpio_request(pdata->buck_gpios[2], "S5M8767 SET3");
-		if (ret == -EBUSY)
-			dev_warn(&pdev->dev, "Duplicated gpio request"
-					" for SET3\n");
+		ret = devm_gpio_request(&pdev->dev, pdata->buck_gpios[0],
+					"S5M8767 SET1");
+		if (ret)
+			return ret;
+
+		ret = devm_gpio_request(&pdev->dev, pdata->buck_gpios[1],
+					"S5M8767 SET2");
+		if (ret)
+			return ret;
+
+		ret = devm_gpio_request(&pdev->dev, pdata->buck_gpios[2],
+					"S5M8767 SET3");
+		if (ret)
+			return ret;
+
 		/* SET1 GPIO */
 		gpio_direction_output(pdata->buck_gpios[0],
 				(s5m8767->buck_gpioindex >> 2) & 0x1);
@@ -582,25 +583,23 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 		/* SET3 GPIO */
 		gpio_direction_output(pdata->buck_gpios[2],
 				(s5m8767->buck_gpioindex >> 0) & 0x1);
-		ret = 0;
-
 	} else {
 		dev_err(&pdev->dev, "GPIO NOT VALID\n");
 		ret = -EINVAL;
 		return ret;
 	}
 
-	ret = gpio_request(pdata->buck_ds[0], "S5M8767 DS2");
-	if (ret == -EBUSY)
-		dev_warn(&pdev->dev, "Duplicated gpio request for DS2\n");
+	ret = devm_gpio_request(&pdev->dev, pdata->buck_ds[0], "S5M8767 DS2");
+	if (ret)
+		return ret;
 
-	ret = gpio_request(pdata->buck_ds[1], "S5M8767 DS3");
-	if (ret == -EBUSY)
-		dev_warn(&pdev->dev, "Duplicated gpio request for DS3\n");
+	ret = devm_gpio_request(&pdev->dev, pdata->buck_ds[1], "S5M8767 DS3");
+	if (ret)
+		return ret;
 
-	ret = gpio_request(pdata->buck_ds[2], "S5M8767 DS4");
-	if (ret == -EBUSY)
-		dev_warn(&pdev->dev, "Duplicated gpio request for DS4\n");
+	ret = devm_gpio_request(&pdev->dev, pdata->buck_ds[2], "S5M8767 DS4");
+	if (ret)
+		return ret;
 
 	/* DS2 GPIO */
 	gpio_direction_output(pdata->buck_ds[0], 0x0);
-- 
1.7.9.5



