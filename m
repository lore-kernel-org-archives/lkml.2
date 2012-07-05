Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2GEPHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:07:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34484 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2GEPHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:07:08 -0400
Message-ID: <1341500817.14503.1.camel@phoenix>
Subject: [RFC/RFT][PATCH 1/2] regulator: max8997: Properly handle
 gpio_request failure
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Jul 2012 23:06:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to devm_gpio_request to save a few error handling code.

This patch properly handle the gpio_request failure with -EBUSY, we should
return error rather than ommit the gpio_request failure with -EBUSY.

I think one of the reason we got -EBUSY is because current code does not free
gpios in max8997_pmic_remove(). So it got -EBUSY when reload the module.

Yest another reason is in current code if gpio_request() returns -EBUSY,
the rest of the code still calls gpio_direction_output to config buck125_gpios
and set gpio value in max8997_set_gpio().  This looks wrong to me.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8997.c |   40 +++++++++-------------------------------
 1 file changed, 9 insertions(+), 31 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 704cd49..e39a0c7 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -1025,7 +1025,6 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 	 */
 	if (pdata->buck1_gpiodvs || pdata->buck2_gpiodvs ||
 			pdata->buck5_gpiodvs) {
-		bool gpio1set = false, gpio2set = false;
 
 		if (!gpio_is_valid(pdata->buck125_gpios[0]) ||
 				!gpio_is_valid(pdata->buck125_gpios[1]) ||
@@ -1035,40 +1034,20 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 			goto err_out;
 		}
 
-		ret = gpio_request(pdata->buck125_gpios[0],
-				"MAX8997 SET1");
-		if (ret == -EBUSY)
-			dev_warn(&pdev->dev, "Duplicated gpio request"
-					" on SET1\n");
-		else if (ret)
+		ret = devm_gpio_request(&pdev->dev, pdata->buck125_gpios[0],
+					"MAX8997 SET1");
+		if (ret)
 			goto err_out;
-		else
-			gpio1set = true;
-
-		ret = gpio_request(pdata->buck125_gpios[1],
-				"MAX8997 SET2");
-		if (ret == -EBUSY)
-			dev_warn(&pdev->dev, "Duplicated gpio request"
-					" on SET2\n");
-		else if (ret) {
-			if (gpio1set)
-				gpio_free(pdata->buck125_gpios[0]);
+
+		ret = devm_gpio_request(&pdev->dev, pdata->buck125_gpios[1],
+					"MAX8997 SET2");
+		if (ret)
 			goto err_out;
-		} else
-			gpio2set = true;
 
-		ret = gpio_request(pdata->buck125_gpios[2],
+		ret = devm_gpio_request(&pdev->dev, pdata->buck125_gpios[2],
 				"MAX8997 SET3");
-		if (ret == -EBUSY)
-			dev_warn(&pdev->dev, "Duplicated gpio request"
-					" on SET3\n");
-		else if (ret) {
-			if (gpio1set)
-				gpio_free(pdata->buck125_gpios[0]);
-			if (gpio2set)
-				gpio_free(pdata->buck125_gpios[1]);
+		if (ret)
 			goto err_out;
-		}
 
 		gpio_direction_output(pdata->buck125_gpios[0],
 				(max8997->buck125_gpioindex >> 2)
@@ -1079,7 +1058,6 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 		gpio_direction_output(pdata->buck125_gpios[2],
 				(max8997->buck125_gpioindex >> 0)
 				& 0x1); /* SET3 */
-		ret = 0;
 	}
 
 	/* DVS-GPIO disabled */
-- 
1.7.9.5



