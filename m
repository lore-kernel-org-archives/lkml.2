Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab2GKLo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:44:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37862 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab2GKLoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:44:24 -0400
Message-ID: <1342007053.4362.2.camel@phoenix>
Subject: [PATCH RFT] regulator: tps65910: Remvoe
 tps65910_reg_[read|modify_bits|read_locked|write_locked] functions
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, SamuelOrtiz <sameo@linux.intel.com>
Date: Wed, 11 Jul 2012 19:44:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tps65910 mfd driver has been converted to regmap APIs.
This patch adds tps65910_reg_update_bits() in include/linux/mfd/tps65910.h.
Thus we can use tps65910_reg_read/tps65910_reg_write/tps65910_reg_update_bits
directly and remove tps65910_reg_[read|modify_bits|read_locked|write_locked]
functions. With this change, we can also remove the mutex in struct tps65910_reg.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65910-regulator.c |  184 +++++++++++++-------------------
 include/linux/mfd/tps65910.h           |    6 ++
 2 files changed, 79 insertions(+), 111 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 64c93e0..d2ba066 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -296,7 +296,6 @@ struct tps65910_reg {
 	struct tps65910 *mfd;
 	struct regulator_dev **rdev;
 	struct tps_info **info;
-	struct mutex mutex;
 	int num_regulators;
 	int mode;
 	int  (*get_ctrl_reg)(int);
@@ -304,71 +303,6 @@ struct tps65910_reg {
 	unsigned int board_ext_control[TPS65910_NUM_REGS];
 };
 
-static inline int tps65910_read(struct tps65910_reg *pmic, u8 reg)
-{
-	unsigned int val;
-	int err;
-
-	err = tps65910_reg_read(pmic->mfd, reg, &val);
-	if (err)
-		return err;
-
-	return val;
-}
-
-static int tps65910_modify_bits(struct tps65910_reg *pmic, u8 reg,
-					u8 set_mask, u8 clear_mask)
-{
-	int err, data;
-
-	mutex_lock(&pmic->mutex);
-
-	data = tps65910_read(pmic, reg);
-	if (data < 0) {
-		dev_err(pmic->mfd->dev, "Read from reg 0x%x failed\n", reg);
-		err = data;
-		goto out;
-	}
-
-	data &= ~clear_mask;
-	data |= set_mask;
-	err = tps65910_reg_write(pmic->mfd, reg, data);
-	if (err)
-		dev_err(pmic->mfd->dev, "Write for reg 0x%x failed\n", reg);
-
-out:
-	mutex_unlock(&pmic->mutex);
-	return err;
-}
-
-static int tps65910_reg_read_locked(struct tps65910_reg *pmic, u8 reg)
-{
-	int data;
-
-	mutex_lock(&pmic->mutex);
-
-	data = tps65910_read(pmic, reg);
-	if (data < 0)
-		dev_err(pmic->mfd->dev, "Read from reg 0x%x failed\n", reg);
-
-	mutex_unlock(&pmic->mutex);
-	return data;
-}
-
-static int tps65910_reg_write_locked(struct tps65910_reg *pmic, u8 reg, u8 val)
-{
-	int err;
-
-	mutex_lock(&pmic->mutex);
-
-	err = tps65910_reg_write(pmic->mfd, reg, val);
-	if (err < 0)
-		dev_err(pmic->mfd->dev, "Write for reg 0x%x failed\n", reg);
-
-	mutex_unlock(&pmic->mutex);
-	return err;
-}
-
 static int tps65910_get_ctrl_register(int id)
 {
 	switch (id) {
@@ -449,8 +383,9 @@ static int tps65910_set_mode(struct regulator_dev *dev, unsigned int mode)
 
 	switch (mode) {
 	case REGULATOR_MODE_NORMAL:
-		return tps65910_modify_bits(pmic, reg, LDO_ST_ON_BIT,
-							LDO_ST_MODE_BIT);
+		return tps65910_reg_update_bits(pmic->mfd, reg,
+						LDO_ST_MODE_BIT | LDO_ST_ON_BIT,
+						LDO_ST_ON_BIT);
 	case REGULATOR_MODE_IDLE:
 		value = LDO_ST_ON_BIT | LDO_ST_MODE_BIT;
 		return tps65910_reg_set_bits(mfd, reg, value);
@@ -464,15 +399,15 @@ static int tps65910_set_mode(struct regulator_dev *dev, unsigned int mode)
 static unsigned int tps65910_get_mode(struct regulator_dev *dev)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
-	int reg, value, id = rdev_get_id(dev);
+	int ret, reg, value, id = rdev_get_id(dev);
 
 	reg = pmic->get_ctrl_reg(id);
 	if (reg < 0)
 		return reg;
 
-	value = tps65910_reg_read_locked(pmic, reg);
-	if (value < 0)
-		return value;
+	ret = tps65910_reg_read(pmic->mfd, reg, &value);
+	if (ret < 0)
+		return ret;
 
 	if (!(value & LDO_ST_ON_BIT))
 		return REGULATOR_MODE_STANDBY;
@@ -485,33 +420,51 @@ static unsigned int tps65910_get_mode(struct regulator_dev *dev)
 static int tps65910_get_voltage_dcdc_sel(struct regulator_dev *dev)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
-	int id = rdev_get_id(dev);
+	int ret, id = rdev_get_id(dev);
 	int opvsel = 0, srvsel = 0, vselmax = 0, mult = 0, sr = 0;
 
 	switch (id) {
 	case TPS65910_REG_VDD1:
-		opvsel = tps65910_reg_read_locked(pmic, TPS65910_VDD1_OP);
-		mult = tps65910_reg_read_locked(pmic, TPS65910_VDD1);
+		ret = tps65910_reg_read(pmic->mfd, TPS65910_VDD1_OP, &opvsel);
+		if (ret < 0)
+			return ret;
+		ret = tps65910_reg_read(pmic->mfd, TPS65910_VDD1, &mult);
+		if (ret < 0)
+			return ret;
 		mult = (mult & VDD1_VGAIN_SEL_MASK) >> VDD1_VGAIN_SEL_SHIFT;
-		srvsel = tps65910_reg_read_locked(pmic, TPS65910_VDD1_SR);
+		ret = tps65910_reg_read(pmic->mfd, TPS65910_VDD1_SR, &srvsel);
+		if (ret < 0)
+			return ret;
 		sr = opvsel & VDD1_OP_CMD_MASK;
 		opvsel &= VDD1_OP_SEL_MASK;
 		srvsel &= VDD1_SR_SEL_MASK;
 		vselmax = 75;
 		break;
 	case TPS65910_REG_VDD2:
-		opvsel = tps65910_reg_read_locked(pmic, TPS65910_VDD2_OP);
-		mult = tps65910_reg_read_locked(pmic, TPS65910_VDD2);
+		ret = tps65910_reg_read(pmic->mfd, TPS65910_VDD2_OP, &opvsel);
+		if (ret < 0)
+			return ret;
+		ret = tps65910_reg_read(pmic->mfd, TPS65910_VDD2, &mult);
+		if (ret < 0)
+			return ret;
 		mult = (mult & VDD2_VGAIN_SEL_MASK) >> VDD2_VGAIN_SEL_SHIFT;
-		srvsel = tps65910_reg_read_locked(pmic, TPS65910_VDD2_SR);
+		ret = tps65910_reg_read(pmic->mfd, TPS65910_VDD2_SR, &srvsel);
+		if (ret < 0)
+			return ret;
 		sr = opvsel & VDD2_OP_CMD_MASK;
 		opvsel &= VDD2_OP_SEL_MASK;
 		srvsel &= VDD2_SR_SEL_MASK;
 		vselmax = 75;
 		break;
 	case TPS65911_REG_VDDCTRL:
-		opvsel = tps65910_reg_read_locked(pmic, TPS65911_VDDCTRL_OP);
-		srvsel = tps65910_reg_read_locked(pmic, TPS65911_VDDCTRL_SR);
+		ret = tps65910_reg_read(pmic->mfd, TPS65911_VDDCTRL_OP,
+					&opvsel);
+		if (ret < 0)
+			return ret;
+		ret = tps65910_reg_read(pmic->mfd, TPS65911_VDDCTRL_SR,
+					&srvsel);
+		if (ret < 0)
+			return ret;
 		sr = opvsel & VDDCTRL_OP_CMD_MASK;
 		opvsel &= VDDCTRL_OP_SEL_MASK;
 		srvsel &= VDDCTRL_SR_SEL_MASK;
@@ -545,15 +498,15 @@ static int tps65910_get_voltage_dcdc_sel(struct regulator_dev *dev)
 static int tps65910_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
-	int reg, value, id = rdev_get_id(dev);
+	int ret, reg, value, id = rdev_get_id(dev);
 
 	reg = pmic->get_ctrl_reg(id);
 	if (reg < 0)
 		return reg;
 
-	value = tps65910_reg_read_locked(pmic, reg);
-	if (value < 0)
-		return value;
+	ret = tps65910_reg_read(pmic->mfd, reg, &value);
+	if (ret < 0)
+		return ret;
 
 	switch (id) {
 	case TPS65910_REG_VIO:
@@ -583,12 +536,14 @@ static int tps65910_get_voltage_vdd3(struct regulator_dev *dev)
 static int tps65911_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
-	int id = rdev_get_id(dev);
-	u8 value, reg;
+	int ret, id = rdev_get_id(dev);
+	unsigned int value, reg;
 
 	reg = pmic->get_ctrl_reg(id);
 
-	value = tps65910_reg_read_locked(pmic, reg);
+	ret = tps65910_reg_read(pmic->mfd, reg, &value);
+	if (ret < 0)
+		return ret;
 
 	switch (id) {
 	case TPS65911_REG_LDO1:
@@ -630,10 +585,10 @@ static int tps65910_set_voltage_dcdc_sel(struct regulator_dev *dev,
 			dcdc_mult--;
 		vsel = (selector % VDD1_2_NUM_VOLT_FINE) + 3;
 
-		tps65910_modify_bits(pmic, TPS65910_VDD1,
-				(dcdc_mult << VDD1_VGAIN_SEL_SHIFT),
-						VDD1_VGAIN_SEL_MASK);
-		tps65910_reg_write_locked(pmic, TPS65910_VDD1_OP, vsel);
+		tps65910_reg_update_bits(pmic->mfd, TPS65910_VDD1,
+					 VDD1_VGAIN_SEL_MASK,
+					 dcdc_mult << VDD1_VGAIN_SEL_SHIFT);
+		tps65910_reg_write(pmic->mfd, TPS65910_VDD1_OP, vsel);
 		break;
 	case TPS65910_REG_VDD2:
 		dcdc_mult = (selector / VDD1_2_NUM_VOLT_FINE) + 1;
@@ -641,14 +596,14 @@ static int tps65910_set_voltage_dcdc_sel(struct regulator_dev *dev,
 			dcdc_mult--;
 		vsel = (selector % VDD1_2_NUM_VOLT_FINE) + 3;
 
-		tps65910_modify_bits(pmic, TPS65910_VDD2,
-				(dcdc_mult << VDD2_VGAIN_SEL_SHIFT),
-						VDD1_VGAIN_SEL_MASK);
-		tps65910_reg_write_locked(pmic, TPS65910_VDD2_OP, vsel);
+		tps65910_reg_update_bits(pmic->mfd, TPS65910_VDD2,
+					 VDD1_VGAIN_SEL_MASK,
+					 dcdc_mult << VDD2_VGAIN_SEL_SHIFT);
+		tps65910_reg_write(pmic->mfd, TPS65910_VDD2_OP, vsel);
 		break;
 	case TPS65911_REG_VDDCTRL:
 		vsel = selector + 3;
-		tps65910_reg_write_locked(pmic, TPS65911_VDDCTRL_OP, vsel);
+		tps65910_reg_write(pmic->mfd, TPS65911_VDDCTRL_OP, vsel);
 	}
 
 	return 0;
@@ -674,8 +629,8 @@ static int tps65910_set_voltage_sel(struct regulator_dev *dev,
 	case TPS65910_REG_VAUX2:
 	case TPS65910_REG_VAUX33:
 	case TPS65910_REG_VMMC:
-		return tps65910_modify_bits(pmic, reg,
-				(selector << LDO_SEL_SHIFT), LDO_SEL_MASK);
+		return tps65910_reg_update_bits(pmic->mfd, reg, LDO_SEL_MASK,
+						selector << LDO_SEL_SHIFT);
 	}
 
 	return -EINVAL;
@@ -695,18 +650,18 @@ static int tps65911_set_voltage_sel(struct regulator_dev *dev,
 	case TPS65911_REG_LDO1:
 	case TPS65911_REG_LDO2:
 	case TPS65911_REG_LDO4:
-		return tps65910_modify_bits(pmic, reg,
-				(selector << LDO_SEL_SHIFT), LDO1_SEL_MASK);
+		return tps65910_reg_update_bits(pmic->mfd, reg, LDO1_SEL_MASK,
+						selector << LDO_SEL_SHIFT);
 	case TPS65911_REG_LDO3:
 	case TPS65911_REG_LDO5:
 	case TPS65911_REG_LDO6:
 	case TPS65911_REG_LDO7:
 	case TPS65911_REG_LDO8:
-		return tps65910_modify_bits(pmic, reg,
-				(selector << LDO_SEL_SHIFT), LDO3_SEL_MASK);
+		return tps65910_reg_update_bits(pmic->mfd, reg, LDO3_SEL_MASK,
+						selector << LDO_SEL_SHIFT);
 	case TPS65910_REG_VIO:
-		return tps65910_modify_bits(pmic, reg,
-				(selector << LDO_SEL_SHIFT), LDO_SEL_MASK);
+		return tps65910_reg_update_bits(pmic->mfd, reg, LDO_SEL_MASK,
+						selector << LDO_SEL_SHIFT);
 	}
 
 	return -EINVAL;
@@ -918,19 +873,27 @@ static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
 				(tps65910_chip_id(mfd) == TPS65911))) {
 		int op_reg_add = pmic->get_ctrl_reg(id) + 1;
 		int sr_reg_add = pmic->get_ctrl_reg(id) + 2;
-		int opvsel = tps65910_reg_read_locked(pmic, op_reg_add);
-		int srvsel = tps65910_reg_read_locked(pmic, sr_reg_add);
+		int opvsel, srvsel;
+
+		ret = tps65910_reg_read(pmic->mfd, op_reg_add, &opvsel);
+		if (ret < 0)
+			return ret;
+		ret = tps65910_reg_read(pmic->mfd, sr_reg_add, &srvsel);
+		if (ret < 0)
+			return ret;
+
 		if (opvsel & VDD1_OP_CMD_MASK) {
 			u8 reg_val = srvsel & VDD1_OP_SEL_MASK;
-			ret = tps65910_reg_write_locked(pmic, op_reg_add,
-							reg_val);
+
+			ret = tps65910_reg_write(pmic->mfd, op_reg_add,
+						 reg_val);
 			if (ret < 0) {
 				dev_err(mfd->dev,
 					"Error in configuring op register\n");
 				return ret;
 			}
 		}
-		ret = tps65910_reg_write_locked(pmic, sr_reg_add, 0);
+		ret = tps65910_reg_write(pmic->mfd, sr_reg_add, 0);
 		if (ret < 0) {
 			dev_err(mfd->dev, "Error in settting sr register\n");
 			return ret;
@@ -1100,7 +1063,6 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	mutex_init(&pmic->mutex);
 	pmic->mfd = tps65910;
 	platform_set_drvdata(pdev, pmic);
 
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index c5f8060..1aca1fb 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -882,4 +882,10 @@ static inline int tps65910_reg_clear_bits(struct tps65910 *tps65910, u8 reg,
 	return regmap_update_bits(tps65910->regmap, reg, mask, 0);
 }
 
+static inline int tps65910_reg_update_bits(struct tps65910 *tps65910, u8 reg,
+					   u8 mask, u8 val)
+{
+	return regmap_update_bits(tps65910->regmap, reg, mask, val);
+}
+
 #endif /*  __LINUX_MFD_TPS65910_H */
-- 
1.7.9.5



