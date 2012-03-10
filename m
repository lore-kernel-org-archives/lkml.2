Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab2CJC77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 21:59:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56643 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab2CJC76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 21:59:58 -0500
Message-ID: <1331348383.3654.1.camel@phoenix>
Subject: [PATCH] regulator: Make s5m8767_get_voltage_register always return
 correct register
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sat, 10 Mar 2012 10:59:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check s5m8767->buck[2|3|4]_gpiodvs status in s5m8767_get_voltage_register
and return correct register accordingly.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/s5m8767.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 611d02d..58447db 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -219,6 +219,7 @@ static int s5m8767_reg_disable(struct regulator_dev *rdev)
 
 static int s5m8767_get_voltage_register(struct regulator_dev *rdev, int *_reg)
 {
+	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	int reg_id = rdev_get_id(rdev);
 	int reg;
 
@@ -234,12 +235,18 @@ static int s5m8767_get_voltage_register(struct regulator_dev *rdev, int *_reg)
 		break;
 	case S5M8767_BUCK2:
 		reg = S5M8767_REG_BUCK2DVS1;
+		if (s5m8767->buck2_gpiodvs)
+			reg += s5m8767->buck_gpioindex;
 		break;
 	case S5M8767_BUCK3:
 		reg = S5M8767_REG_BUCK3DVS1;
+		if (s5m8767->buck3_gpiodvs)
+			reg += s5m8767->buck_gpioindex;
 		break;
 	case S5M8767_BUCK4:
 		reg = S5M8767_REG_BUCK4DVS1;
+		if (s5m8767->buck4_gpiodvs)
+			reg += s5m8767->buck_gpioindex;
 		break;
 	case S5M8767_BUCK5:
 		reg = S5M8767_REG_BUCK5CTRL2;
@@ -259,7 +266,7 @@ static int s5m8767_get_voltage_register(struct regulator_dev *rdev, int *_reg)
 static int s5m8767_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	int reg, mask = 0xff, ret;
+	int reg, mask, ret;
 	int reg_id = rdev_get_id(rdev);
 	u8 val;
 
@@ -267,23 +274,7 @@ static int s5m8767_get_voltage_sel(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	switch (reg_id) {
-	case S5M8767_LDO1 ... S5M8767_LDO28:
-		mask = 0x3f;
-		break;
-	case S5M8767_BUCK2:
-		if (s5m8767->buck2_gpiodvs)
-			reg += s5m8767->buck_gpioindex;
-		break;
-	case S5M8767_BUCK3:
-		if (s5m8767->buck3_gpiodvs)
-			reg += s5m8767->buck_gpioindex;
-		break;
-	case S5M8767_BUCK4:
-		if (s5m8767->buck4_gpiodvs)
-			reg += s5m8767->buck_gpioindex;
-		break;
-	}
+	mask = (reg_id < S5M8767_BUCK1) ? 0x3f : 0xff;
 
 	ret = s5m_reg_read(s5m8767->iodev, reg, &val);
 	if (ret)
-- 
1.7.5.4



