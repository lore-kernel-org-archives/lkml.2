Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab2GLBhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 21:37:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52064 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab2GLBhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 21:37:43 -0400
Message-ID: <1342057057.19192.2.camel@phoenix>
Subject: [PATCH 2/3] regulator: s2mps11: Fix wrong setting for config.dev
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Jul 2012 09:37:37 +0800
In-Reply-To: <1342056950.19192.0.camel@phoenix>
References: <1342056950.19192.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently s2mps11->iodev, s2mps11->dev and config.dev point to NULL.
This patch fixes the settings for config.dev.
Current code does not need the *dev and *iodev of struct s2mps11_info,
so remove them.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/s2mps11.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index da8c3d1..b3c2705 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -24,8 +24,6 @@
 #include <linux/mfd/samsung/s2mps11.h>
 
 struct s2mps11_info {
-	struct device *dev;
-	struct sec_pmic_dev *iodev;
 	struct regulator_dev **rdev;
 
 	int ramp_delay2;
@@ -260,8 +258,6 @@ static __devinit int s2mps11_pmic_probe(struct platform_device *pdev)
 	}
 
 	rdev = s2mps11->rdev;
-	config.dev = &pdev->dev;
-	config.regmap = iodev->regmap;
 	platform_set_drvdata(pdev, s2mps11);
 
 	s2mps11->ramp_delay2 = pdata->buck2_ramp_delay;
@@ -284,7 +280,7 @@ static __devinit int s2mps11_pmic_probe(struct platform_device *pdev)
 			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay2) >> 6;
 		if (s2mps11->buck3_ramp || s2mps11->buck4_ramp)
 			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay34) >> 4;
-		sec_reg_update(s2mps11->iodev, S2MPS11_REG_RAMP,
+		sec_reg_update(iodev, S2MPS11_REG_RAMP,
 			ramp_reg | ramp_enable, 0xff);
 	}
 
@@ -293,11 +289,11 @@ static __devinit int s2mps11_pmic_probe(struct platform_device *pdev)
 	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay16) >> 4;
 	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay7810) >> 2;
 	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay9);
-	sec_reg_update(s2mps11->iodev, S2MPS11_REG_RAMP_BUCK, ramp_reg, 0xff);
+	sec_reg_update(iodev, S2MPS11_REG_RAMP_BUCK, ramp_reg, 0xff);
 
 	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
 
-		config.dev = s2mps11->dev;
+		config.dev = &pdev->dev;
 		config.regmap = iodev->regmap;
 		config.init_data = pdata->regulators[i].initdata;
 		config.driver_data = s2mps11;
@@ -305,8 +301,8 @@ static __devinit int s2mps11_pmic_probe(struct platform_device *pdev)
 		rdev[i] = regulator_register(&regulators[i], &config);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
-			dev_err(s2mps11->dev, "regulator init failed for %d\n",
-					i);
+			dev_err(&pdev->dev, "regulator init failed for %d\n",
+				i);
 			rdev[i] = NULL;
 			goto err;
 		}
-- 
1.7.9.5



