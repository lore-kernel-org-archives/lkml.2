Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab2CJAnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 19:43:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48396 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab2CJAnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 19:43:08 -0500
Message-ID: <1331340182.18199.3.camel@phoenix>
Subject: [PATCH] regulator: s5m8767: Check pdata->buck[2|3|4]_gpiodvs earlier
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sat, 10 Mar 2012 08:43:02 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we need to ensure only one of the buck[2|3|4]_gpiodvs can be specificed,
check them earlier.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/s5m8767.c |   45 ++++++++++++++++++++----------------------
 1 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index e369d9e..f1514f1 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -549,6 +549,27 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	if (pdata->buck2_gpiodvs) {
+		if (pdata->buck3_gpiodvs || pdata->buck4_gpiodvs) {
+			dev_err(&pdev->dev, "S5M8767 GPIO DVS NOT VALID\n");
+			return -EINVAL;
+		}
+	}
+
+	if (pdata->buck3_gpiodvs) {
+		if (pdata->buck2_gpiodvs || pdata->buck4_gpiodvs) {
+			dev_err(&pdev->dev, "S5M8767 GPIO DVS NOT VALID\n");
+			return -EINVAL;
+		}
+	}
+
+	if (pdata->buck4_gpiodvs) {
+		if (pdata->buck2_gpiodvs || pdata->buck3_gpiodvs) {
+			dev_err(&pdev->dev, "S5M8767 GPIO DVS NOT VALID\n");
+			return -EINVAL;
+		}
+	}
+
 	s5m8767 = devm_kzalloc(&pdev->dev, sizeof(struct s5m8767_info),
 				GFP_KERNEL);
 	if (!s5m8767)
@@ -642,30 +663,6 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (pdata->buck2_gpiodvs) {
-		if (pdata->buck3_gpiodvs || pdata->buck4_gpiodvs) {
-			dev_err(&pdev->dev, "S5M8767 GPIO DVS NOT VALID\n");
-			ret = -EINVAL;
-			return ret;
-		}
-	}
-
-	if (pdata->buck3_gpiodvs) {
-		if (pdata->buck2_gpiodvs || pdata->buck4_gpiodvs) {
-			dev_err(&pdev->dev, "S5M8767 GPIO DVS NOT VALID\n");
-			ret = -EINVAL;
-			return ret;
-		}
-	}
-
-	if (pdata->buck4_gpiodvs) {
-		if (pdata->buck2_gpiodvs || pdata->buck3_gpiodvs) {
-			dev_err(&pdev->dev, "S5M8767 GPIO DVS NOT VALID\n");
-			ret = -EINVAL;
-			return ret;
-		}
-	}
-
 	s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL,
 			(pdata->buck2_gpiodvs) ? (1 << 1) : (0 << 1), 1 << 1);
 	s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL,
-- 
1.7.5.4



