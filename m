Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2CIIzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 03:55:36 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:33666 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab2CIIzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 03:55:35 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-76-4f59c5852a79
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, sbkim01@gmail.com
Subject: [PATCH 2/2] regulator: Add support s5m8767 opmode operation
Date: Fri, 09 Mar 2012 17:55:34 +0900
Message-id: <06ad01ccfdd2$63ee8fc0$2bcbaf40$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acz90mN3Ut70BHHgTGibZTc0YugscA==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S5M8767A has 4 operation mode for BUCK/LDOs.
This patch can handle opmode for s5m8767a.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/s5m8767.c |   71 +++++++++++++++++++++++++++++++++++++------
 1 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 3592ccb..ff69f50 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -28,6 +28,7 @@ struct s5m8767_info {
 	struct s5m87xx_dev *iodev;
 	int num_regulators;
 	struct regulator_dev **rdev;
+	struct s5m_opmode_data *opmode;
 
 	int ramp_delay;
 	bool buck2_ramp;
@@ -141,9 +142,56 @@ static int s5m8767_list_voltage(struct regulator_dev *rdev,
 	return val;
 }
 
-static int s5m8767_get_register(struct regulator_dev *rdev, int *reg)
+unsigned int s5m8767_opmode_reg[][4] = {
+	/* {OFF, ON, LOWPOWER, SUSPEND} */
+	/* LDO1 ... LDO28 */
+	{0x0, 0x3, 0x2, 0x1}, /* LDO1 */
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x0, 0x0, 0x0},
+	{0x0, 0x3, 0x2, 0x1}, /* LDO5 */
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1}, /* LDO10 */
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1}, /* LDO15 */
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x0, 0x0, 0x0},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1}, /* LDO20 */
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x0, 0x0, 0x0},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1}, /* LDO25 */
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1},
+	{0x0, 0x3, 0x2, 0x1}, /* LDO28 */
+
+	/* BUCK1 ... BUCK9 */
+	{0x0, 0x3, 0x1, 0x1}, /* BUCK1 */
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x3, 0x2, 0x1}, /* BUCK5 */
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x3, 0x1, 0x1},
+	{0x0, 0x3, 0x1, 0x1}, /* BUCK9 */
+};
+
+static int s5m8767_get_register(struct regulator_dev *rdev, int *reg,
+				int *enable_ctrl)
 {
 	int reg_id = rdev_get_id(rdev);
+	unsigned int mode;
+	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 
 	switch (reg_id) {
 	case S5M8767_LDO1 ... S5M8767_LDO2:
@@ -168,6 +216,8 @@ static int s5m8767_get_register(struct regulator_dev *rdev, int *reg)
 		return -EINVAL;
 	}
 
+	mode = s5m8767->opmode[reg_id].mode;
+	*enable_ctrl = s5m8767_opmode_reg[reg_id][mode] << S5M8767_ENCTRL_SHIFT;
 	return 0;
 }
 
@@ -175,10 +225,10 @@ static int s5m8767_reg_is_enabled(struct regulator_dev *rdev)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	int ret, reg;
-	int mask = 0xc0, pattern = 0xc0;
+	int mask = 0xc0, enable_ctrl;
 	u8 val;
 
-	ret = s5m8767_get_register(rdev, &reg);
+	ret = s5m8767_get_register(rdev, &reg, &enable_ctrl);
 	if (ret == -EINVAL)
 		return 1;
 	else if (ret)
@@ -188,33 +238,33 @@ static int s5m8767_reg_is_enabled(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	return (val & mask) == pattern;
+	return (val & mask) == enable_ctrl;
 }
 
 static int s5m8767_reg_enable(struct regulator_dev *rdev)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	int ret, reg;
-	int mask = 0xc0, pattern = 0xc0;
+	int mask = 0xc0, enable_ctrl;
 
-	ret = s5m8767_get_register(rdev, &reg);
+	ret = s5m8767_get_register(rdev, &reg, &enable_ctrl);
 	if (ret)
 		return ret;
 
-	return s5m_reg_update(s5m8767->iodev, reg, pattern, mask);
+	return s5m_reg_update(s5m8767->iodev, reg, enable_ctrl, mask);
 }
 
 static int s5m8767_reg_disable(struct regulator_dev *rdev)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	int ret, reg;
-	int  mask = 0xc0, pattern = 0xc0;
+	int  mask = 0xc0, enable_ctrl;
 
-	ret = s5m8767_get_register(rdev, &reg);
+	ret = s5m8767_get_register(rdev, &reg, &enable_ctrl);
 	if (ret)
 		return ret;
 
-	return s5m_reg_update(s5m8767->iodev, reg, ~pattern, mask);
+	return s5m_reg_update(s5m8767->iodev, reg, ~mask, mask);
 }
 
 static int s5m8767_get_voltage_register(struct regulator_dev *rdev, int *_reg)
@@ -576,6 +626,7 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 	s5m8767->buck2_ramp = pdata->buck2_ramp_enable;
 	s5m8767->buck3_ramp = pdata->buck3_ramp_enable;
 	s5m8767->buck4_ramp = pdata->buck4_ramp_enable;
+	s5m8767->opmode = pdata->opmode;
 
 	for (i = 0; i < 8; i++) {
 		if (s5m8767->buck2_gpiodvs) {
-- 
1.7.1

