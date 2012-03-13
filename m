Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446Ab2CMC6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 22:58:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60992 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab2CMC63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 22:58:29 -0400
Message-ID: <1331607500.11322.3.camel@phoenix>
Subject: [PATCH] regulator: Check SET[1|2|3] GPIO settings earlier
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 13 Mar 2012 10:58:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unused GPIO is marked as -1, we need to check if one of the gpio is set to 0
here because gpio_is_valid considers 0 as a valid gpio.

Since we need to check the GPIOs anyway, check them altogether earlier makes
the code cleaner.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8998.c |   32 +++++++-------------------------
 1 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 5890265..67140fa 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -695,6 +695,13 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	/* Unused GPIO is marked as -1 */
+	if (!pdata->buck1_set1 || !pdata->buck1_set2 || !pdata->buck2_set3) {
+		dev_err(&pdev->dev,
+		    "MAX8998 SET1/SET2/SET3 GPIO must not be defined as 0 !\n");
+		return -EINVAL;
+	}
+
 	max8998 = kzalloc(sizeof(struct max8998_data), GFP_KERNEL);
 	if (!max8998)
 		return -ENOMEM;
@@ -716,27 +723,9 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 	max8998->buck1_idx = pdata->buck1_default_idx;
 	max8998->buck2_idx = pdata->buck2_default_idx;
 
-	/* NOTE: */
-	/* For unused GPIO NOT marked as -1 (thereof equal to 0)  WARN_ON */
-	/* will be displayed */
-
 	/* Check if MAX8998 voltage selection GPIOs are defined */
 	if (gpio_is_valid(pdata->buck1_set1) &&
 	    gpio_is_valid(pdata->buck1_set2)) {
-		/* Check if SET1 is not equal to 0 */
-		if (!pdata->buck1_set1) {
-			printk(KERN_ERR "MAX8998 SET1 GPIO defined as 0 !\n");
-			WARN_ON(!pdata->buck1_set1);
-			ret = -EIO;
-			goto err_free_mem;
-		}
-		/* Check if SET2 is not equal to 0 */
-		if (!pdata->buck1_set2) {
-			printk(KERN_ERR "MAX8998 SET2 GPIO defined as 0 !\n");
-			WARN_ON(!pdata->buck1_set2);
-			ret = -EIO;
-			goto err_free_mem;
-		}
 
 		gpio_request(pdata->buck1_set1, "MAX8998 BUCK1_SET1");
 		gpio_direction_output(pdata->buck1_set1,
@@ -796,13 +785,6 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 	}
 
 	if (gpio_is_valid(pdata->buck2_set3)) {
-		/* Check if SET3 is not equal to 0 */
-		if (!pdata->buck2_set3) {
-			printk(KERN_ERR "MAX8998 SET3 GPIO defined as 0 !\n");
-			WARN_ON(!pdata->buck2_set3);
-			ret = -EIO;
-			goto err_free_mem;
-		}
 		gpio_request(pdata->buck2_set3, "MAX8998 BUCK2_SET3");
 		gpio_direction_output(pdata->buck2_set3,
 				      max8998->buck2_idx & 0x1);
-- 
1.7.5.4



