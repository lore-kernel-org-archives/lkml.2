Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab0KJOiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:38:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60342 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756250Ab0KJOii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:38:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: Report actual configured voltage to set_voltage()
Date: Wed, 10 Nov 2010 14:38:29 +0000
Message-Id: <1289399910-7779-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the interface used by set_voltage() to report the selected value
to the regulator core in terms of a selector used by list_voltage().
This allows the regulator core to know the voltage that was chosen
without having to do an explict get_voltage(), which would be much more
expensive as it will generally access hardware.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/88pm8607.c           |    3 +-
 drivers/regulator/ab3100.c             |    5 +++-
 drivers/regulator/ab8500.c             |    5 +++-
 drivers/regulator/core.c               |   14 +++++++++-
 drivers/regulator/da903x.c             |   17 +++++++++----
 drivers/regulator/isl6271a-regulator.c |    6 ++++-
 drivers/regulator/lp3971.c             |   10 ++++++-
 drivers/regulator/lp3972.c             |   10 ++++++-
 drivers/regulator/max1586.c            |   30 +++++++++++-----------
 drivers/regulator/max8649.c            |    3 +-
 drivers/regulator/max8660.c            |   14 ++++++++--
 drivers/regulator/max8925-regulator.c  |    3 +-
 drivers/regulator/max8952.c            |    3 +-
 drivers/regulator/max8998.c            |    8 ++++-
 drivers/regulator/mc13783-regulator.c  |   10 ++++++-
 drivers/regulator/pcap-regulator.c     |    7 ++++-
 drivers/regulator/pcf50633-regulator.c |    5 +++-
 drivers/regulator/tps65023-regulator.c |    9 +++++-
 drivers/regulator/tps6507x-regulator.c |   10 ++++++-
 drivers/regulator/tps6586x-regulator.c |   15 +++++++----
 drivers/regulator/twl-regulator.c      |   11 ++++++--
 drivers/regulator/wm831x-dcdc.c        |   17 +++++++++----
 drivers/regulator/wm831x-ldo.c         |   41 ++++++++++++++++++++++---------
 drivers/regulator/wm8350-regulator.c   |    8 ++++-
 drivers/regulator/wm8400-regulator.c   |    8 ++++-
 drivers/regulator/wm8994-regulator.c   |    6 +++-
 include/linux/regulator/driver.h       |    3 +-
 27 files changed, 202 insertions(+), 79 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 2ce2eb7..dd63084 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -249,7 +249,7 @@ static int choose_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
 }
 
 static int pm8607_set_voltage(struct regulator_dev *rdev,
-			      int min_uV, int max_uV)
+			      int min_uV, int max_uV, unsigned *selector)
 {
 	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
 	uint8_t val, mask;
@@ -263,6 +263,7 @@ static int pm8607_set_voltage(struct regulator_dev *rdev,
 	ret = choose_voltage(rdev, min_uV, max_uV);
 	if (ret < 0)
 		return -EINVAL;
+	*selector = ret;
 	val = (uint8_t)(ret << info->vol_shift);
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 
diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index b349266..ed6feaf 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -362,7 +362,8 @@ static int ab3100_get_best_voltage_index(struct regulator_dev *reg,
 }
 
 static int ab3100_set_voltage_regulator(struct regulator_dev *reg,
-					int min_uV, int max_uV)
+					int min_uV, int max_uV,
+					unsigned *selector)
 {
 	struct ab3100_regulator *abreg = reg->reg_data;
 	u8 regval;
@@ -373,6 +374,8 @@ static int ab3100_set_voltage_regulator(struct regulator_dev *reg,
 	if (bestindex < 0)
 		return bestindex;
 
+	*selector = bestindex;
+
 	err = abx500_get_register_interruptible(abreg->dev, 0,
 						abreg->regreg, &regval);
 	if (err) {
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index db6b70f..2f4ec0f 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -215,7 +215,8 @@ static int ab8500_get_best_voltage_index(struct regulator_dev *rdev,
 }
 
 static int ab8500_regulator_set_voltage(struct regulator_dev *rdev,
-		int min_uV, int max_uV)
+					int min_uV, int max_uV,
+					unsigned *selector)
 {
 	int regulator_id, ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
@@ -232,6 +233,8 @@ static int ab8500_regulator_set_voltage(struct regulator_dev *rdev,
 		return ret;
 	}
 
+	*selector = ret;
+
 	/* set the registers for the request */
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 		info->voltage_bank, info->voltage_reg,
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 27d062e..6616bc9 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -723,13 +723,16 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 	struct regulator_ops *ops = rdev->desc->ops;
 	const char *name = rdev_get_name(rdev);
 	int ret;
+	unsigned selector;
 
 	/* do we need to apply the constraint voltage */
 	if (rdev->constraints->apply_uV &&
 		rdev->constraints->min_uV == rdev->constraints->max_uV &&
 		ops->set_voltage) {
 		ret = ops->set_voltage(rdev,
-			rdev->constraints->min_uV, rdev->constraints->max_uV);
+				       rdev->constraints->min_uV,
+				       rdev->constraints->max_uV,
+				       &selector);
 			if (ret < 0) {
 				printk(KERN_ERR "%s: failed to apply %duV constraint to %s\n",
 				       __func__,
@@ -1625,6 +1628,7 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 {
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret;
+	unsigned selector;
 
 	mutex_lock(&rdev->mutex);
 
@@ -1640,7 +1644,13 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 		goto out;
 	regulator->min_uV = min_uV;
 	regulator->max_uV = max_uV;
-	ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV);
+
+	ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV, &selector);
+
+	if (rdev->desc->ops->list_voltage)
+		selector = rdev->desc->ops->list_voltage(rdev, selector);
+	else
+		selector = -1;
 
 out:
 	_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE, NULL);
diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index f8c4661..362e082 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -107,7 +107,7 @@ static inline int check_range(struct da903x_regulator_info *info,
 
 /* DA9030/DA9034 common operations */
 static int da903x_set_ldo_voltage(struct regulator_dev *rdev,
-				  int min_uV, int max_uV)
+				  int min_uV, int max_uV, unsigned *selector)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
 	struct device *da9034_dev = to_da903x_dev(rdev);
@@ -119,6 +119,7 @@ static int da903x_set_ldo_voltage(struct regulator_dev *rdev,
 	}
 
 	val = (min_uV - info->min_uV + info->step_uV - 1) / info->step_uV;
+	*selector = val;
 	val <<= info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 
@@ -187,7 +188,8 @@ static int da903x_list_voltage(struct regulator_dev *rdev, unsigned selector)
 
 /* DA9030 specific operations */
 static int da9030_set_ldo1_15_voltage(struct regulator_dev *rdev,
-				       int min_uV, int max_uV)
+				      int min_uV, int max_uV,
+				      unsigned *selector)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
 	struct device *da903x_dev = to_da903x_dev(rdev);
@@ -200,6 +202,7 @@ static int da9030_set_ldo1_15_voltage(struct regulator_dev *rdev,
 	}
 
 	val = (min_uV - info->min_uV + info->step_uV - 1) / info->step_uV;
+	*selector = val;
 	val <<= info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 	val |= DA9030_LDO_UNLOCK; /* have to set UNLOCK bits */
@@ -214,7 +217,8 @@ static int da9030_set_ldo1_15_voltage(struct regulator_dev *rdev,
 }
 
 static int da9030_set_ldo14_voltage(struct regulator_dev *rdev,
-				  int min_uV, int max_uV)
+				    int min_uV, int max_uV,
+				    unsigned *selector)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
 	struct device *da903x_dev = to_da903x_dev(rdev);
@@ -234,6 +238,7 @@ static int da9030_set_ldo14_voltage(struct regulator_dev *rdev,
 		val = (min_uV - thresh + info->step_uV - 1) / info->step_uV;
 	}
 
+	*selector = val;
 	val <<= info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 
@@ -263,7 +268,7 @@ static int da9030_get_ldo14_voltage(struct regulator_dev *rdev)
 
 /* DA9034 specific operations */
 static int da9034_set_dvc_voltage(struct regulator_dev *rdev,
-				  int min_uV, int max_uV)
+				  int min_uV, int max_uV, unsigned *selector)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
 	struct device *da9034_dev = to_da903x_dev(rdev);
@@ -276,6 +281,7 @@ static int da9034_set_dvc_voltage(struct regulator_dev *rdev,
 	}
 
 	val = (min_uV - info->min_uV + info->step_uV - 1) / info->step_uV;
+	*selector = val;
 	val <<= info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 
@@ -289,7 +295,7 @@ static int da9034_set_dvc_voltage(struct regulator_dev *rdev,
 }
 
 static int da9034_set_ldo12_voltage(struct regulator_dev *rdev,
-				    int min_uV, int max_uV)
+				    int min_uV, int max_uV, unsigned *selector)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
 	struct device *da9034_dev = to_da903x_dev(rdev);
@@ -302,6 +308,7 @@ static int da9034_set_ldo12_voltage(struct regulator_dev *rdev,
 
 	val = (min_uV - info->min_uV + info->step_uV - 1) / info->step_uV;
 	val = (val >= 20) ? val - 12 : ((val > 7) ? 8 : val);
+	*selector = val;
 	val <<= info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 
diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index b8cc638..b5639e8 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -58,7 +58,9 @@ out:
 	return data;
 }
 
-static int isl6271a_set_voltage(struct regulator_dev *dev, int minuV, int maxuV)
+static int isl6271a_set_voltage(struct regulator_dev *dev,
+				int minuV, int maxuV,
+				unsigned *selector)
 {
 	struct isl_pmic *pmic = rdev_get_drvdata(dev);
 	int vsel, err, data;
@@ -78,6 +80,8 @@ static int isl6271a_set_voltage(struct regulator_dev *dev, int minuV, int maxuV)
 	/* Convert the microvolts to data for the chip */
 	data = (vsel - ISL6271A_VOLTAGE_MIN) / ISL6271A_VOLTAGE_STEP;
 
+	*selector = data;
+
 	mutex_lock(&pmic->mtx);
 
 	err = i2c_smbus_write_byte(pmic->client, data);
diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 3bb82b6..0f22ef1 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -168,7 +168,8 @@ static int lp3971_ldo_get_voltage(struct regulator_dev *dev)
 }
 
 static int lp3971_ldo_set_voltage(struct regulator_dev *dev,
-				  int min_uV, int max_uV)
+				  int min_uV, int max_uV,
+				  unsigned int *selector)
 {
 	struct lp3971 *lp3971 = rdev_get_drvdata(dev);
 	int ldo = rdev_get_id(dev) - LP3971_LDO1;
@@ -187,6 +188,8 @@ static int lp3971_ldo_set_voltage(struct regulator_dev *dev,
 	if (val > LDO_VOL_MAX_IDX || vol_map[val] > max_vol)
 		return -EINVAL;
 
+	*selector = val;
+
 	return lp3971_set_bits(lp3971, LP3971_LDO_VOL_CONTR_REG(ldo),
 			LDO_VOL_CONTR_MASK << LDO_VOL_CONTR_SHIFT(ldo),
 			val << LDO_VOL_CONTR_SHIFT(ldo));
@@ -256,7 +259,8 @@ static int lp3971_dcdc_get_voltage(struct regulator_dev *dev)
 }
 
 static int lp3971_dcdc_set_voltage(struct regulator_dev *dev,
-				  int min_uV, int max_uV)
+				   int min_uV, int max_uV,
+				   unsigned int *selector)
 {
 	struct lp3971 *lp3971 = rdev_get_drvdata(dev);
 	int buck = rdev_get_id(dev) - LP3971_DCDC1;
@@ -277,6 +281,8 @@ static int lp3971_dcdc_set_voltage(struct regulator_dev *dev,
 	if (val > BUCK_TARGET_VOL_MAX_IDX || vol_map[val] > max_vol)
 		return -EINVAL;
 
+	*selector = val;
+
 	ret = lp3971_set_bits(lp3971, LP3971_BUCK_TARGET_VOL1_REG(buck),
 	       BUCK_TARGET_VOL_MASK, val);
 	if (ret)
diff --git a/drivers/regulator/lp3972.c b/drivers/regulator/lp3972.c
index e07062f..6aa1b50 100644
--- a/drivers/regulator/lp3972.c
+++ b/drivers/regulator/lp3972.c
@@ -292,7 +292,8 @@ static int lp3972_ldo_get_voltage(struct regulator_dev *dev)
 }
 
 static int lp3972_ldo_set_voltage(struct regulator_dev *dev,
-				  int min_uV, int max_uV)
+				  int min_uV, int max_uV,
+				  unsigned int *selector)
 {
 	struct lp3972 *lp3972 = rdev_get_drvdata(dev);
 	int ldo = rdev_get_id(dev) - LP3972_LDO1;
@@ -313,6 +314,8 @@ static int lp3972_ldo_set_voltage(struct regulator_dev *dev,
 	if (val > LP3972_LDO_VOL_MAX_IDX(ldo) || vol_map[val] > max_vol)
 		return -EINVAL;
 
+	*selector = val;
+
 	shift = LP3972_LDO_VOL_CONTR_SHIFT(ldo);
 	ret = lp3972_set_bits(lp3972, LP3972_LDO_VOL_CONTR_REG(ldo),
 		LP3972_LDO_VOL_MASK(ldo) << shift, val << shift);
@@ -416,7 +419,8 @@ static int lp3972_dcdc_get_voltage(struct regulator_dev *dev)
 }
 
 static int lp3972_dcdc_set_voltage(struct regulator_dev *dev,
-				  int min_uV, int max_uV)
+				   int min_uV, int max_uV,
+				   unsigned int *selector)
 {
 	struct lp3972 *lp3972 = rdev_get_drvdata(dev);
 	int buck = rdev_get_id(dev) - LP3972_DCDC1;
@@ -438,6 +442,8 @@ static int lp3972_dcdc_set_voltage(struct regulator_dev *dev,
 	    vol_map[val] > max_vol)
 		return -EINVAL;
 
+	*selector = val;
+
 	ret = lp3972_set_bits(lp3972, LP3972_BUCK_VOL1_REG(buck),
 				LP3972_BUCK_VOL_MASK, val);
 	if (ret)
diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index 559cfa2..3f49512 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -63,12 +63,12 @@ static int max1586_v3_calc_voltage(struct max1586_data *max1586,
 	return max1586->min_uV + (selector * range_uV / MAX1586_V3_MAX_VSEL);
 }
 
-static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV)
+static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV,
+			  unsigned *selector)
 {
 	struct max1586_data *max1586 = rdev_get_drvdata(rdev);
 	struct i2c_client *client = max1586->client;
 	unsigned range_uV = max1586->max_uV - max1586->min_uV;
-	unsigned selector;
 	u8 v3_prog;
 
 	if (min_uV > max1586->max_uV || max_uV < max1586->min_uV)
@@ -76,15 +76,15 @@ static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV)
 	if (min_uV < max1586->min_uV)
 		min_uV = max1586->min_uV;
 
-	selector = ((min_uV - max1586->min_uV) * MAX1586_V3_MAX_VSEL +
+	*selector = ((min_uV - max1586->min_uV) * MAX1586_V3_MAX_VSEL +
 			range_uV - 1) / range_uV;
-	if (max1586_v3_calc_voltage(max1586, selector) > max_uV)
+	if (max1586_v3_calc_voltage(max1586, *selector) > max_uV)
 		return -EINVAL;
 
 	dev_dbg(&client->dev, "changing voltage v3 to %dmv\n",
-		max1586_v3_calc_voltage(max1586, selector) / 1000);
+		max1586_v3_calc_voltage(max1586, *selector) / 1000);
 
-	v3_prog = I2C_V3_SELECT | (u8) selector;
+	v3_prog = I2C_V3_SELECT | (u8) *selector;
 	return i2c_smbus_write_byte(client, v3_prog);
 }
 
@@ -110,10 +110,10 @@ static int max1586_v6_calc_voltage(unsigned selector)
 	return voltages_uv[selector];
 }
 
-static int max1586_v6_set(struct regulator_dev *rdev, int min_uV, int max_uV)
+static int max1586_v6_set(struct regulator_dev *rdev, int min_uV, int max_uV,
+			  unsigned int *selector)
 {
 	struct i2c_client *client = rdev_get_drvdata(rdev);
-	unsigned selector;
 	u8 v6_prog;
 
 	if (min_uV < MAX1586_V6_MIN_UV || min_uV > MAX1586_V6_MAX_UV)
@@ -122,21 +122,21 @@ static int max1586_v6_set(struct regulator_dev *rdev, int min_uV, int max_uV)
 		return -EINVAL;
 
 	if (min_uV < 1800000)
-		selector = 0;
+		*selector = 0;
 	else if (min_uV < 2500000)
-		selector = 1;
+		*selector = 1;
 	else if (min_uV < 3000000)
-		selector = 2;
+		*selector = 2;
 	else if (min_uV >= 3000000)
-		selector = 3;
+		*selector = 3;
 
-	if (max1586_v6_calc_voltage(selector) > max_uV)
+	if (max1586_v6_calc_voltage(*selector) > max_uV)
 		return -EINVAL;
 
 	dev_dbg(&client->dev, "changing voltage v6 to %dmv\n",
-		max1586_v6_calc_voltage(selector) / 1000);
+		max1586_v6_calc_voltage(*selector) / 1000);
 
-	v6_prog = I2C_V6_SELECT | (u8) selector;
+	v6_prog = I2C_V6_SELECT | (u8) *selector;
 	return i2c_smbus_write_byte(client, v6_prog);
 }
 
diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 6b60a9c..30eb9e5 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -155,7 +155,7 @@ static int max8649_get_voltage(struct regulator_dev *rdev)
 }
 
 static int max8649_set_voltage(struct regulator_dev *rdev,
-			       int min_uV, int max_uV)
+			       int min_uV, int max_uV, unsigned *selector)
 {
 	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
 	unsigned char data, mask;
@@ -168,6 +168,7 @@ static int max8649_set_voltage(struct regulator_dev *rdev,
 	data = (min_uV - MAX8649_DCDC_VMIN + MAX8649_DCDC_STEP - 1)
 		/ MAX8649_DCDC_STEP;
 	mask = MAX8649_VOL_MASK;
+	*selector = data & mask;
 
 	return max8649_set_bits(info->i2c, info->vol_reg, mask, data);
 }
diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index c570e6e..33f5d9a 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -141,7 +141,8 @@ static int max8660_dcdc_get(struct regulator_dev *rdev)
 	return MAX8660_DCDC_MIN_UV + selector * MAX8660_DCDC_STEP;
 }
 
-static int max8660_dcdc_set(struct regulator_dev *rdev, int min_uV, int max_uV)
+static int max8660_dcdc_set(struct regulator_dev *rdev, int min_uV, int max_uV,
+			    unsigned int *s)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
 	u8 reg, selector, bits;
@@ -154,6 +155,7 @@ static int max8660_dcdc_set(struct regulator_dev *rdev, int min_uV, int max_uV)
 
 	selector = (min_uV - (MAX8660_DCDC_MIN_UV - MAX8660_DCDC_STEP + 1))
 			/ MAX8660_DCDC_STEP;
+	*s = selector;
 
 	ret = max8660_dcdc_list(rdev, selector);
 	if (ret < 0 || ret > max_uV)
@@ -196,7 +198,8 @@ static int max8660_ldo5_get(struct regulator_dev *rdev)
 	return MAX8660_LDO5_MIN_UV + selector * MAX8660_LDO5_STEP;
 }
 
-static int max8660_ldo5_set(struct regulator_dev *rdev, int min_uV, int max_uV)
+static int max8660_ldo5_set(struct regulator_dev *rdev, int min_uV, int max_uV,
+			    unsigned int *s)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
 	u8 selector;
@@ -213,6 +216,8 @@ static int max8660_ldo5_set(struct regulator_dev *rdev, int min_uV, int max_uV)
 	if (ret < 0 || ret > max_uV)
 		return -EINVAL;
 
+	*s = selector;
+
 	ret = max8660_write(max8660, MAX8660_MDTV2, 0, selector);
 	if (ret)
 		return ret;
@@ -270,7 +275,8 @@ static int max8660_ldo67_get(struct regulator_dev *rdev)
 	return MAX8660_LDO67_MIN_UV + selector * MAX8660_LDO67_STEP;
 }
 
-static int max8660_ldo67_set(struct regulator_dev *rdev, int min_uV, int max_uV)
+static int max8660_ldo67_set(struct regulator_dev *rdev, int min_uV,
+			     int max_uV, unsigned int *s)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
 	u8 selector;
@@ -288,6 +294,8 @@ static int max8660_ldo67_set(struct regulator_dev *rdev, int min_uV, int max_uV)
 	if (ret < 0 || ret > max_uV)
 		return -EINVAL;
 
+	*s = selector;
+
 	if (rdev_get_id(rdev) == MAX8660_V6)
 		return max8660_write(max8660, MAX8660_L12VCR, 0xf0, selector);
 	else
diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 552cad8..8ae1475 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -55,7 +55,7 @@ static int max8925_list_voltage(struct regulator_dev *rdev, unsigned index)
 }
 
 static int max8925_set_voltage(struct regulator_dev *rdev,
-			       int min_uV, int max_uV)
+			       int min_uV, int max_uV, unsigned int *selector)
 {
 	struct max8925_regulator_info *info = rdev_get_drvdata(rdev);
 	unsigned char data, mask;
@@ -66,6 +66,7 @@ static int max8925_set_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 	data = (min_uV - info->min_uV + info->step_uV - 1) / info->step_uV;
+	*selector = data;
 	data <<= info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1) << info->vol_shift;
 
diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 0d5dda4..a8f4ecf 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -133,7 +133,7 @@ static int max8952_get_voltage(struct regulator_dev *rdev)
 }
 
 static int max8952_set_voltage(struct regulator_dev *rdev,
-				int min_uV, int max_uV)
+			       int min_uV, int max_uV, unsigned *selector)
 {
 	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
 	s8 vid = -1, i;
@@ -156,6 +156,7 @@ static int max8952_set_voltage(struct regulator_dev *rdev,
 	if (vid >= 0 && vid < MAX8952_NUM_DVS_MODE) {
 		max8952->vid0 = (vid % 2 == 1);
 		max8952->vid1 = (((vid >> 1) % 2) == 1);
+		*selector = vid;
 		gpio_set_value(max8952->pdata->gpio_vid0, max8952->vid0);
 		gpio_set_value(max8952->pdata->gpio_vid1, max8952->vid1);
 	} else
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 5c20756..cb28cf8 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -304,7 +304,7 @@ static int max8998_get_voltage(struct regulator_dev *rdev)
 }
 
 static int max8998_set_voltage_ldo(struct regulator_dev *rdev,
-				int min_uV, int max_uV)
+				   int min_uV, int max_uV, unsigned *selector)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
 	struct i2c_client *i2c = max8998->iodev->i2c;
@@ -331,6 +331,8 @@ static int max8998_set_voltage_ldo(struct regulator_dev *rdev,
 	if (desc->min + desc->step*i > max_vol)
 		return -EINVAL;
 
+	*selector = i;
+
 	ret = max8998_get_voltage_register(rdev, &reg, &shift, &mask);
 	if (ret)
 		return ret;
@@ -352,7 +354,7 @@ static inline void buck2_gpio_set(int gpio, int v)
 }
 
 static int max8998_set_voltage_buck(struct regulator_dev *rdev,
-				    int min_uV, int max_uV)
+				    int min_uV, int max_uV, int *selector)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
 	struct max8998_platform_data *pdata =
@@ -384,6 +386,8 @@ static int max8998_set_voltage_buck(struct regulator_dev *rdev,
 	if (desc->min + desc->step*i > max_vol)
 		return -EINVAL;
 
+	*selector = i;
+
 	ret = max8998_get_voltage_register(rdev, &reg, &shift, &mask);
 	if (ret)
 		return ret;
diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index ecd99f5..47ea999 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -373,7 +373,8 @@ static int mc13783_get_best_voltage_index(struct regulator_dev *rdev,
 }
 
 static int mc13783_regulator_set_voltage(struct regulator_dev *rdev,
-						int min_uV, int max_uV)
+					 int min_uV, int max_uV,
+					 unsigned *selector)
 {
 	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
 	int value, id = rdev_get_id(rdev);
@@ -388,6 +389,8 @@ static int mc13783_regulator_set_voltage(struct regulator_dev *rdev,
 	if (value < 0)
 		return value;
 
+	*selector = value;
+
 	mc13783_lock(priv->mc13783);
 	ret = mc13783_reg_rmw(priv->mc13783, mc13783_regulators[id].vsel_reg,
 			mc13783_regulators[id].vsel_mask,
@@ -433,13 +436,16 @@ static struct regulator_ops mc13783_regulator_ops = {
 };
 
 static int mc13783_fixed_regulator_set_voltage(struct regulator_dev *rdev,
-						int min_uV, int max_uV)
+					       int min_uV, int max_uV,
+					       unsigned int *selector)
 {
 	int id = rdev_get_id(rdev);
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d min_uV: %d max_uV: %d\n",
 		__func__, id, min_uV, max_uV);
 
+	*selector = 0;
+
 	if (min_uV >= mc13783_regulators[id].voltages[0] &&
 	    max_uV <= mc13783_regulators[id].voltages[0])
 		return 0;
diff --git a/drivers/regulator/pcap-regulator.c b/drivers/regulator/pcap-regulator.c
index 29d0566..8dca116 100644
--- a/drivers/regulator/pcap-regulator.c
+++ b/drivers/regulator/pcap-regulator.c
@@ -151,7 +151,8 @@ static struct pcap_regulator vreg_table[] = {
 };
 
 static int pcap_regulator_set_voltage(struct regulator_dev *rdev,
-						int min_uV, int max_uV)
+				      int min_uV, int max_uV,
+				      unsiged *selector)
 {
 	struct pcap_regulator *vreg = &vreg_table[rdev_get_id(rdev)];
 	void *pcap = rdev_get_drvdata(rdev);
@@ -170,10 +171,12 @@ static int pcap_regulator_set_voltage(struct regulator_dev *rdev,
 			i = 0;
 
 		uV = vreg->voltage_table[i] * 1000;
-		if (min_uV <= uV && uV <= max_uV)
+		if (min_uV <= uV && uV <= max_uV) {
+			*selector = i;
 			return ezx_pcap_set_bits(pcap, vreg->reg,
 					(vreg->n_voltages - 1) << vreg->index,
 					i << vreg->index);
+		}
 
 		if (i == 0 && rdev_get_id(rdev) == V1)
 			i = vreg->n_voltages - 1;
diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index c8f41dc..69a11d9 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -108,7 +108,8 @@ static unsigned int ldo_voltage_value(u8 bits)
 }
 
 static int pcf50633_regulator_set_voltage(struct regulator_dev *rdev,
-						int min_uV, int max_uV)
+					  int min_uV, int max_uV,
+					  unsigned *selector)
 {
 	struct pcf50633 *pcf;
 	int regulator_id, millivolts;
@@ -147,6 +148,8 @@ static int pcf50633_regulator_set_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
+	*selector = volt_bits;
+
 	return pcf50633_reg_write(pcf, regnr, volt_bits);
 }
 
diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index cd6d4fc..60a7ca5 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -321,7 +321,8 @@ static int tps65023_dcdc_get_voltage(struct regulator_dev *dev)
 }
 
 static int tps65023_dcdc_set_voltage(struct regulator_dev *dev,
-				int min_uV, int max_uV)
+				     int min_uV, int max_uV,
+				     unsigned *selector)
 {
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
 	int dcdc = rdev_get_id(dev);
@@ -346,6 +347,8 @@ static int tps65023_dcdc_set_voltage(struct regulator_dev *dev,
 			break;
 	}
 
+	*selector = vsel;
+
 	/* write to the register in case we found a match */
 	if (vsel == tps->info[dcdc]->table_len)
 		return -EINVAL;
@@ -371,7 +374,7 @@ static int tps65023_ldo_get_voltage(struct regulator_dev *dev)
 }
 
 static int tps65023_ldo_set_voltage(struct regulator_dev *dev,
-				int min_uV, int max_uV)
+				    int min_uV, int max_uV, unsigned *selector)
 {
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
 	int data, vsel, ldo = rdev_get_id(dev);
@@ -396,6 +399,8 @@ static int tps65023_ldo_set_voltage(struct regulator_dev *dev,
 	if (vsel == tps->info[ldo]->table_len)
 		return -EINVAL;
 
+	*selector = vsel;
+
 	data = tps_65023_reg_read(tps, TPS65023_REG_LDO_CTRL);
 	if (data < 0)
 		return data;
diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 020f587..0647552 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -369,7 +369,8 @@ static int tps6507x_pmic_dcdc_get_voltage(struct regulator_dev *dev)
 }
 
 static int tps6507x_pmic_dcdc_set_voltage(struct regulator_dev *dev,
-				int min_uV, int max_uV)
+					  int min_uV, int max_uV,
+					  unsigned *selector)
 {
 	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int data, vsel, dcdc = rdev_get_id(dev);
@@ -415,6 +416,8 @@ static int tps6507x_pmic_dcdc_set_voltage(struct regulator_dev *dev,
 	if (vsel == tps->info[dcdc]->table_len)
 		return -EINVAL;
 
+	*selector = vsel;
+
 	data = tps6507x_pmic_reg_read(tps, reg);
 	if (data < 0)
 		return data;
@@ -450,7 +453,8 @@ static int tps6507x_pmic_ldo_get_voltage(struct regulator_dev *dev)
 }
 
 static int tps6507x_pmic_ldo_set_voltage(struct regulator_dev *dev,
-				int min_uV, int max_uV)
+					 int min_uV, int max_uV,
+					 unsigned *selector)
 {
 	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int data, vsel, ldo = rdev_get_id(dev);
@@ -483,6 +487,8 @@ static int tps6507x_pmic_ldo_set_voltage(struct regulator_dev *dev,
 	if (vsel == tps->info[ldo]->table_len)
 		return -EINVAL;
 
+	*selector = vsel;
+
 	data = tps6507x_pmic_reg_read(tps, reg);
 	if (data < 0)
 		return data;
diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 51237fb..b997bee 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -85,7 +85,8 @@ static int tps6586x_ldo_list_voltage(struct regulator_dev *rdev,
 
 static int __tps6586x_ldo_set_voltage(struct device *parent,
 				      struct tps6586x_regulator *ri,
-				      int min_uV, int max_uV)
+				      int min_uV, int max_uV,
+				      unsigned *selector)
 {
 	int val, uV;
 	uint8_t mask;
@@ -100,6 +101,8 @@ static int __tps6586x_ldo_set_voltage(struct device *parent,
 		/* use the first in-range value */
 		if (min_uV <= uV && uV <= max_uV) {
 
+			*selector = val;
+
 			val <<= ri->volt_shift;
 			mask = ((1 << ri->volt_nbits) - 1) << ri->volt_shift;
 
@@ -111,12 +114,13 @@ static int __tps6586x_ldo_set_voltage(struct device *parent,
 }
 
 static int tps6586x_ldo_set_voltage(struct regulator_dev *rdev,
-				    int min_uV, int max_uV)
+				    int min_uV, int max_uV, unsigned *selector)
 {
 	struct tps6586x_regulator *ri = rdev_get_drvdata(rdev);
 	struct device *parent = to_tps6586x_dev(rdev);
 
-	return __tps6586x_ldo_set_voltage(parent, ri, min_uV, max_uV);
+	return __tps6586x_ldo_set_voltage(parent, ri, min_uV, max_uV,
+					  selector);
 }
 
 static int tps6586x_ldo_get_voltage(struct regulator_dev *rdev)
@@ -140,13 +144,14 @@ static int tps6586x_ldo_get_voltage(struct regulator_dev *rdev)
 }
 
 static int tps6586x_dvm_set_voltage(struct regulator_dev *rdev,
-				    int min_uV, int max_uV)
+				    int min_uV, int max_uV, unsigned *selector)
 {
 	struct tps6586x_regulator *ri = rdev_get_drvdata(rdev);
 	struct device *parent = to_tps6586x_dev(rdev);
 	int ret;
 
-	ret = __tps6586x_ldo_set_voltage(parent, ri, min_uV, max_uV);
+	ret = __tps6586x_ldo_set_voltage(parent, ri, min_uV, max_uV,
+					 selector);
 	if (ret)
 		return ret;
 
diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index a57262a..bd332cf 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -329,7 +329,8 @@ static int twl4030ldo_list_voltage(struct regulator_dev *rdev, unsigned index)
 }
 
 static int
-twl4030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
+twl4030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
+		       unsigned *selector)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 	int			vsel;
@@ -345,9 +346,11 @@ twl4030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
 		/* REVISIT for VAUX2, first match may not be best/lowest */
 
 		/* use the first in-range value */
-		if (min_uV <= uV && uV <= max_uV)
+		if (min_uV <= uV && uV <= max_uV) {
+			*selector = vsel;
 			return twlreg_write(info, TWL_MODULE_PM_RECEIVER,
 							VREG_VOLTAGE, vsel);
+		}
 	}
 
 	return -EDOM;
@@ -389,7 +392,8 @@ static int twl6030ldo_list_voltage(struct regulator_dev *rdev, unsigned index)
 }
 
 static int
-twl6030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
+twl6030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
+		       unsigned *selector)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 	int			vsel;
@@ -402,6 +406,7 @@ twl6030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
 	 * mV = 1000mv + 100mv * (vsel - 1)
 	 */
 	vsel = (min_uV/1000 - 1000)/100 + 1;
+	*selector = vsel;
 	return twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_VOLTAGE, vsel);
 
 }
diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index dbfaf59..71da6b2 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -302,7 +302,7 @@ static int wm831x_buckv_set_dvs(struct regulator_dev *rdev, int state)
 }
 
 static int wm831x_buckv_set_voltage(struct regulator_dev *rdev,
-				    int min_uV, int max_uV)
+				    int min_uV, int max_uV, unsigned *selector)
 {
 	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
 	struct wm831x *wm831x = dcdc->wm831x;
@@ -314,6 +314,8 @@ static int wm831x_buckv_set_voltage(struct regulator_dev *rdev,
 	if (vsel < 0)
 		return vsel;
 
+	*selector = vsel;
+
 	/* If this value is already set then do a GPIO update if we can */
 	if (dcdc->dvs_gpio && dcdc->on_vsel == vsel)
 		return wm831x_buckv_set_dvs(rdev, 0);
@@ -636,7 +638,7 @@ static int wm831x_buckp_list_voltage(struct regulator_dev *rdev,
 }
 
 static int wm831x_buckp_set_voltage_int(struct regulator_dev *rdev, int reg,
-					int min_uV, int max_uV)
+					int min_uV, int max_uV, int *selector)
 {
 	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
 	struct wm831x *wm831x = dcdc->wm831x;
@@ -650,16 +652,20 @@ static int wm831x_buckp_set_voltage_int(struct regulator_dev *rdev, int reg,
 	if (wm831x_buckp_list_voltage(rdev, vsel) > max_uV)
 		return -EINVAL;
 
+	*selector = vsel;
+
 	return wm831x_set_bits(wm831x, reg, WM831X_DC3_ON_VSEL_MASK, vsel);
 }
 
 static int wm831x_buckp_set_voltage(struct regulator_dev *rdev,
-				    int min_uV, int max_uV)
+				    int min_uV, int max_uV,
+				    unsigned *selector)
 {
 	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
 	u16 reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
 
-	return wm831x_buckp_set_voltage_int(rdev, reg, min_uV, max_uV);
+	return wm831x_buckp_set_voltage_int(rdev, reg, min_uV, max_uV,
+					    selector);
 }
 
 static int wm831x_buckp_set_suspend_voltage(struct regulator_dev *rdev,
@@ -667,8 +673,9 @@ static int wm831x_buckp_set_suspend_voltage(struct regulator_dev *rdev,
 {
 	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
 	u16 reg = dcdc->base + WM831X_DCDC_SLEEP_CONTROL;
+	unsigned selector;
 
-	return wm831x_buckp_set_voltage_int(rdev, reg, uV, uV);
+	return wm831x_buckp_set_voltage_int(rdev, reg, uV, uV, &selector);
 }
 
 static int wm831x_buckp_get_voltage(struct regulator_dev *rdev)
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 9edf8f6..9594e71 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -113,7 +113,8 @@ static int wm831x_gp_ldo_list_voltage(struct regulator_dev *rdev,
 }
 
 static int wm831x_gp_ldo_set_voltage_int(struct regulator_dev *rdev, int reg,
-					 int min_uV, int max_uV)
+					 int min_uV, int max_uV,
+					 unsigned *selector)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
 	struct wm831x *wm831x = ldo->wm831x;
@@ -133,16 +134,20 @@ static int wm831x_gp_ldo_set_voltage_int(struct regulator_dev *rdev, int reg,
 	if (ret < min_uV || ret > max_uV)
 		return -EINVAL;
 
+	*selector = vsel;
+
 	return wm831x_set_bits(wm831x, reg, WM831X_LDO1_ON_VSEL_MASK, vsel);
 }
 
 static int wm831x_gp_ldo_set_voltage(struct regulator_dev *rdev,
-				     int min_uV, int max_uV)
+				     int min_uV, int max_uV,
+				     unsigned *selector)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
 	int reg = ldo->base + WM831X_LDO_ON_CONTROL;
 
-	return wm831x_gp_ldo_set_voltage_int(rdev, reg, min_uV, max_uV);
+	return wm831x_gp_ldo_set_voltage_int(rdev, reg, min_uV, max_uV,
+					     selector);
 }
 
 static int wm831x_gp_ldo_set_suspend_voltage(struct regulator_dev *rdev,
@@ -150,8 +155,9 @@ static int wm831x_gp_ldo_set_suspend_voltage(struct regulator_dev *rdev,
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
 	int reg = ldo->base + WM831X_LDO_SLEEP_CONTROL;
+	unsigned int selector;
 
-	return wm831x_gp_ldo_set_voltage_int(rdev, reg, uV, uV);
+	return wm831x_gp_ldo_set_voltage_int(rdev, reg, uV, uV, &selector);
 }
 
 static int wm831x_gp_ldo_get_voltage(struct regulator_dev *rdev)
@@ -413,7 +419,8 @@ static int wm831x_aldo_list_voltage(struct regulator_dev *rdev,
 }
 
 static int wm831x_aldo_set_voltage_int(struct regulator_dev *rdev, int reg,
-					 int min_uV, int max_uV)
+				       int min_uV, int max_uV,
+				       unsigned *selector)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
 	struct wm831x *wm831x = ldo->wm831x;
@@ -433,16 +440,19 @@ static int wm831x_aldo_set_voltage_int(struct regulator_dev *rdev, int reg,
 	if (ret < min_uV || ret > max_uV)
 		return -EINVAL;
 
+	*selector = vsel;
+
 	return wm831x_set_bits(wm831x, reg, WM831X_LDO7_ON_VSEL_MASK, vsel);
 }
 
 static int wm831x_aldo_set_voltage(struct regulator_dev *rdev,
-				     int min_uV, int max_uV)
+				   int min_uV, int max_uV, unsigned *selector)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
 	int reg = ldo->base + WM831X_LDO_ON_CONTROL;
 
-	return wm831x_aldo_set_voltage_int(rdev, reg, min_uV, max_uV);
+	return wm831x_aldo_set_voltage_int(rdev, reg, min_uV, max_uV,
+					   selector);
 }
 
 static int wm831x_aldo_set_suspend_voltage(struct regulator_dev *rdev,
@@ -450,8 +460,9 @@ static int wm831x_aldo_set_suspend_voltage(struct regulator_dev *rdev,
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
 	int reg = ldo->base + WM831X_LDO_SLEEP_CONTROL;
+	unsigned int selector;
 
-	return wm831x_aldo_set_voltage_int(rdev, reg, uV, uV);
+	return wm831x_aldo_set_voltage_int(rdev, reg, uV, uV, &selector);
 }
 
 static int wm831x_aldo_get_voltage(struct regulator_dev *rdev)
@@ -666,7 +677,8 @@ static int wm831x_alive_ldo_list_voltage(struct regulator_dev *rdev,
 
 static int wm831x_alive_ldo_set_voltage_int(struct regulator_dev *rdev,
 					    int reg,
-					    int min_uV, int max_uV)
+					    int min_uV, int max_uV,
+					    unsigned *selector)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
 	struct wm831x *wm831x = ldo->wm831x;
@@ -680,16 +692,20 @@ static int wm831x_alive_ldo_set_voltage_int(struct regulator_dev *rdev,
 	if (ret < min_uV || ret > max_uV)
 		return -EINVAL;
 
+	*selector = vsel;
+
 	return wm831x_set_bits(wm831x, reg, WM831X_LDO11_ON_VSEL_MASK, vsel);
 }
 
 static int wm831x_alive_ldo_set_voltage(struct regulator_dev *rdev,
-				     int min_uV, int max_uV)
+					int min_uV, int max_uV,
+					unsigned *selector)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
 	int reg = ldo->base + WM831X_ALIVE_LDO_ON_CONTROL;
 
-	return wm831x_alive_ldo_set_voltage_int(rdev, reg, min_uV, max_uV);
+	return wm831x_alive_ldo_set_voltage_int(rdev, reg, min_uV, max_uV,
+						selector);
 }
 
 static int wm831x_alive_ldo_set_suspend_voltage(struct regulator_dev *rdev,
@@ -697,8 +713,9 @@ static int wm831x_alive_ldo_set_suspend_voltage(struct regulator_dev *rdev,
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
 	int reg = ldo->base + WM831X_ALIVE_LDO_SLEEP_CONTROL;
+	unsigned selector;
 
-	return wm831x_alive_ldo_set_voltage_int(rdev, reg, uV, uV);
+	return wm831x_alive_ldo_set_voltage_int(rdev, reg, uV, uV, &selector);
 }
 
 static int wm831x_alive_ldo_get_voltage(struct regulator_dev *rdev)
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index fe4b8a8..7e45b0d 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -360,7 +360,7 @@ int wm8350_isink_set_flash(struct wm8350 *wm8350, int isink, u16 mode,
 EXPORT_SYMBOL_GPL(wm8350_isink_set_flash);
 
 static int wm8350_dcdc_set_voltage(struct regulator_dev *rdev, int min_uV,
-	int max_uV)
+				   int max_uV, unsigned *selector)
 {
 	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
 	int volt_reg, dcdc = rdev_get_id(rdev), mV,
@@ -397,6 +397,8 @@ static int wm8350_dcdc_set_voltage(struct regulator_dev *rdev, int min_uV,
 		return -EINVAL;
 	}
 
+	*selector = mV;
+
 	/* all DCDCs have same mV bits */
 	val = wm8350_reg_read(wm8350, volt_reg) & ~WM8350_DC1_VSEL_MASK;
 	wm8350_reg_write(wm8350, volt_reg, val | mV);
@@ -754,7 +756,7 @@ static int wm8350_ldo_set_suspend_disable(struct regulator_dev *rdev)
 }
 
 static int wm8350_ldo_set_voltage(struct regulator_dev *rdev, int min_uV,
-	int max_uV)
+				  int max_uV, unsigned *selector)
 {
 	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
 	int volt_reg, ldo = rdev_get_id(rdev), mV, min_mV = min_uV / 1000,
@@ -797,6 +799,8 @@ static int wm8350_ldo_set_voltage(struct regulator_dev *rdev, int min_uV,
 		return -EINVAL;
 	}
 
+	*selector = mV;
+
 	/* all LDOs have same mV bits */
 	val = wm8350_reg_read(wm8350, volt_reg) & ~WM8350_LDO1_VSEL_MASK;
 	wm8350_reg_write(wm8350, volt_reg, val | mV);
diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 924c7eb..b42d01c 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -67,7 +67,7 @@ static int wm8400_ldo_get_voltage(struct regulator_dev *dev)
 }
 
 static int wm8400_ldo_set_voltage(struct regulator_dev *dev,
-				  int min_uV, int max_uV)
+				  int min_uV, int max_uV, unsigned *selector)
 {
 	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
 	u16 val;
@@ -93,6 +93,8 @@ static int wm8400_ldo_set_voltage(struct regulator_dev *dev,
 		val += 0xf;
 	}
 
+	*selector = val;
+
 	return wm8400_set_bits(wm8400, WM8400_LDO1_CONTROL + rdev_get_id(dev),
 			       WM8400_LDO1_VSEL_MASK, val);
 }
@@ -156,7 +158,7 @@ static int wm8400_dcdc_get_voltage(struct regulator_dev *dev)
 }
 
 static int wm8400_dcdc_set_voltage(struct regulator_dev *dev,
-				  int min_uV, int max_uV)
+				   int min_uV, int max_uV, unsigned *selector)
 {
 	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
 	u16 val;
@@ -171,6 +173,8 @@ static int wm8400_dcdc_set_voltage(struct regulator_dev *dev,
 		return -EINVAL;
 	BUG_ON(850000 + (25000 * val) < min_uV);
 
+	*selector = val;
+
 	return wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_1 + offset,
 			       WM8400_DC1_VSEL_MASK, val);
 }
diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 03713bc..1b162e6 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -101,7 +101,7 @@ static int wm8994_ldo1_get_voltage(struct regulator_dev *rdev)
 }
 
 static int wm8994_ldo1_set_voltage(struct regulator_dev *rdev,
-				   int min_uV, int max_uV)
+				   int min_uV, int max_uV, unsigned *s)
 {
 	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
 	int selector, v;
@@ -111,6 +111,7 @@ static int wm8994_ldo1_set_voltage(struct regulator_dev *rdev,
 	if (v < 0 || v > max_uV)
 		return -EINVAL;
 
+	*s = selector;
 	selector <<= WM8994_LDO1_VSEL_SHIFT;
 
 	return wm8994_set_bits(ldo->wm8994, WM8994_LDO_1,
@@ -152,7 +153,7 @@ static int wm8994_ldo2_get_voltage(struct regulator_dev *rdev)
 }
 
 static int wm8994_ldo2_set_voltage(struct regulator_dev *rdev,
-				   int min_uV, int max_uV)
+				   int min_uV, int max_uV, unsigned *s)
 {
 	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
 	int selector, v;
@@ -162,6 +163,7 @@ static int wm8994_ldo2_set_voltage(struct regulator_dev *rdev,
 	if (v < 0 || v > max_uV)
 		return -EINVAL;
 
+	*s = selector;
 	selector <<= WM8994_LDO2_VSEL_SHIFT;
 
 	return wm8994_set_bits(ldo->wm8994, WM8994_LDO_2,
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 592cd7c..4275cd4 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -79,7 +79,8 @@ struct regulator_ops {
 	int (*list_voltage) (struct regulator_dev *, unsigned selector);
 
 	/* get/set regulator voltage */
-	int (*set_voltage) (struct regulator_dev *, int min_uV, int max_uV);
+	int (*set_voltage) (struct regulator_dev *, int min_uV, int max_uV,
+			    unsigned *selector);
 	int (*get_voltage) (struct regulator_dev *);
 
 	/* get/set regulator current  */
-- 
1.7.1

