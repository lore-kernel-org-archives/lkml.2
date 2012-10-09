Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2JIKXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:23:49 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17866 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab2JIKXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:23:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 09 Oct 2012 03:23:01 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <sameo@linux.intel.com>, <vbyravarasu@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 1/4] regulator; tps65090: Register all regulators in single probe call
Date: Tue, 9 Oct 2012 15:18:59 +0530
Message-ID: <1349776142-6409-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com>
References: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MFD driver registers the regulator driver once per device and
hence it is require to register all regulators in single probe
call.
Following are details of changes done to achieve this:
- Move the regulator enums to mfd header and remove the
  tps65090-regulator.h as it does not contain more info.
- Add max regulator and register all regulators even if there
  is no regulator init data from platform.
- Convert regulator init data to pointer type in platform data.
- Add input supply name in regulator desc to provide input supply.
- Separate desc information from driver information.
- Disable external control bit to have control through register write.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1: 
- Move this change to Patch1 from older patch2.
- Disable external control on init sequence.
- Move content of tps65090-regualtor.h to mfd/tps65090.h.

 drivers/regulator/tps65090-regulator.c       |  195 ++++++++++++++++++--------
 include/linux/mfd/tps65090.h                 |   28 ++++
 include/linux/regulator/tps65090-regulator.h |   50 -------
 3 files changed, 165 insertions(+), 108 deletions(-)
 delete mode 100644 include/linux/regulator/tps65090-regulator.h

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 001ad55..5f7f931 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -24,15 +24,11 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/mfd/tps65090.h>
-#include <linux/regulator/tps65090-regulator.h>
 
 struct tps65090_regulator {
-	int		id;
-	/* used by regulator core */
-	struct regulator_desc	desc;
-
-	/* Device */
 	struct device		*dev;
+	struct regulator_desc	*desc;
+	struct regulator_dev	*rdev;
 };
 
 static struct regulator_ops tps65090_ops = {
@@ -41,44 +37,80 @@ static struct regulator_ops tps65090_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 };
 
-#define tps65090_REG(_id)				\
+#define tps65090_REG_DESC(_id, _sname, _en_reg, _ops)	\
 {							\
-	.id		= TPS65090_ID_##_id,		\
-	.desc = {					\
-		.name = tps65090_rails(_id),		\
-		.id = TPS65090_ID_##_id,		\
-		.ops = &tps65090_ops,			\
-		.type = REGULATOR_VOLTAGE,		\
-		.owner = THIS_MODULE,			\
-		.enable_reg = (TPS65090_ID_##_id) + 12,	\
-		.enable_mask = BIT(0),			\
-	},						\
+	.name = "TPS65090_RAILS"#_id,			\
+	.supply_name = _sname,				\
+	.id = TPS65090_ID_##_id,			\
+	.ops = &_ops,					\
+	.enable_reg = _en_reg,				\
+	.enable_mask = BIT(0),				\
+	.type = REGULATOR_VOLTAGE,			\
+	.owner = THIS_MODULE,				\
 }
 
-static struct tps65090_regulator TPS65090_regulator[] = {
-	tps65090_REG(DCDC1),
-	tps65090_REG(DCDC2),
-	tps65090_REG(DCDC3),
-	tps65090_REG(FET1),
-	tps65090_REG(FET2),
-	tps65090_REG(FET3),
-	tps65090_REG(FET4),
-	tps65090_REG(FET5),
-	tps65090_REG(FET6),
-	tps65090_REG(FET7),
+static struct regulator_desc tps65090_regulator_desc[] = {
+	tps65090_REG_DESC(DCDC1, "vsys1",   0x0C, tps65090_ops),
+	tps65090_REG_DESC(DCDC2, "vsys2",   0x0D, tps65090_ops),
+	tps65090_REG_DESC(DCDC3, "vsys3",   0x0E, tps65090_ops),
+	tps65090_REG_DESC(FET1,  "infet1",  0x0F, tps65090_ops),
+	tps65090_REG_DESC(FET2,  "infet2",  0x10, tps65090_ops),
+	tps65090_REG_DESC(FET3,  "infet3",  0x11, tps65090_ops),
+	tps65090_REG_DESC(FET4,  "infet4",  0x12, tps65090_ops),
+	tps65090_REG_DESC(FET5,  "infet5",  0x13, tps65090_ops),
+	tps65090_REG_DESC(FET6,  "infet6",  0x14, tps65090_ops),
+	tps65090_REG_DESC(FET7,  "infet7",  0x15, tps65090_ops),
 };
 
-static inline struct tps65090_regulator *find_regulator_info(int id)
+static inline bool is_dcdc(int id)
 {
-	struct tps65090_regulator *ri;
-	int i;
+	switch (id) {
+	case TPS65090_ID_DCDC1:
+	case TPS65090_ID_DCDC2:
+	case TPS65090_ID_DCDC3:
+		return true;
+	default:
+		return false;
+	}
+}
 
-	for (i = 0; i < ARRAY_SIZE(TPS65090_regulator); i++) {
-		ri = &TPS65090_regulator[i];
-		if (ri->desc.id == id)
-			return ri;
+static int __devinit tps65090_config_ext_control(
+	struct tps65090_regulator *ri, bool enable)
+{
+	int ret;
+	struct device *parent = ri->dev->parent;
+	unsigned int reg_en_reg = ri->desc->enable_reg;
+
+	if (enable)
+		ret = tps65090_set_bits(parent, reg_en_reg, 1);
+	else
+		ret =  tps65090_clr_bits(parent, reg_en_reg, 1);
+	if (ret < 0)
+		dev_err(ri->dev, "Error in updating reg 0x%x\n", reg_en_reg);
+	return ret;
+}
+
+static int __devinit tps65090_regulator_disable_ext_control(
+		struct tps65090_regulator *ri,
+		struct tps65090_regulator_plat_data *tps_pdata)
+{
+	int ret = 0;
+	struct device *parent = ri->dev->parent;
+	unsigned int reg_en_reg = ri->desc->enable_reg;
+
+	/*
+	 * First enable output for internal control if require.
+	 * And then disable external control.
+	 */
+	if (tps_pdata->reg_init_data->constraints.always_on ||
+			tps_pdata->reg_init_data->constraints.boot_on) {
+		ret =  tps65090_set_bits(parent, reg_en_reg, 0);
+		if (ret < 0) {
+			dev_err(ri->dev, "Error in set reg 0x%x\n", reg_en_reg);
+			return ret;
+		}
 	}
-	return NULL;
+	return tps65090_config_ext_control(ri, false);
 }
 
 static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
@@ -87,40 +119,87 @@ static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
 	struct tps65090_regulator *ri = NULL;
 	struct regulator_config config = { };
 	struct regulator_dev *rdev;
-	struct tps65090_regulator_platform_data *tps_pdata;
-	int id = pdev->id;
+	struct tps65090_regulator_plat_data *tps_pdata;
+	struct tps65090_regulator *pmic;
+	struct tps65090_platform_data *tps65090_pdata;
+	int num;
+	int ret;
 
-	dev_dbg(&pdev->dev, "Probing regulator %d\n", id);
+	dev_dbg(&pdev->dev, "Probing regulator\n");
 
-	ri = find_regulator_info(id);
-	if (ri == NULL) {
-		dev_err(&pdev->dev, "invalid regulator ID specified\n");
+	tps65090_pdata = dev_get_platdata(pdev->dev.parent);
+	if (!tps65090_pdata) {
+		dev_err(&pdev->dev, "Platform data missing\n");
 		return -EINVAL;
 	}
-	tps_pdata = pdev->dev.platform_data;
-	ri->dev = &pdev->dev;
-
-	config.dev = &pdev->dev;
-	config.init_data = &tps_pdata->regulator;
-	config.driver_data = ri;
-	config.regmap = tps65090_mfd->rmap;
-
-	rdev = regulator_register(&ri->desc, &config);
-	if (IS_ERR(rdev)) {
-		dev_err(&pdev->dev, "failed to register regulator %s\n",
-				ri->desc.name);
-		return PTR_ERR(rdev);
+
+	pmic = devm_kzalloc(&pdev->dev, TPS65090_ID_MAX * sizeof(*pmic),
+			GFP_KERNEL);
+	if (!pmic) {
+		dev_err(&pdev->dev, "mem alloc for pmic failed\n");
+		return -ENOMEM;
+	}
+
+	for (num = 0; num < TPS65090_ID_MAX; num++) {
+		tps_pdata = tps65090_pdata->reg_pdata[num];
+
+		ri = &pmic[num];
+		ri->dev = &pdev->dev;
+		ri->desc = &tps65090_regulator_desc[num];
+
+		/*
+		 * TPS5090 DCDC support the control from external digital input.
+		 * It may be possible that during boot, the external control is
+		 * enabled. Disabling external control for DCDC.
+		 */
+		if (tps_pdata && is_dcdc(num) && tps_pdata->reg_init_data) {
+			ret = tps65090_regulator_disable_ext_control(
+						ri, tps_pdata);
+			if (ret < 0) {
+				dev_err(&pdev->dev,
+						"failed disable ext control\n");
+				goto scrub;
+			}
+		}
+		config.dev = &pdev->dev;
+		config.driver_data = ri;
+		config.regmap = tps65090_mfd->rmap;
+		if (tps_pdata)
+			config.init_data = tps_pdata->reg_init_data;
+		else
+			config.init_data = NULL;
+
+		rdev = regulator_register(ri->desc, &config);
+		if (IS_ERR(rdev)) {
+			dev_err(&pdev->dev, "failed to register regulator %s\n",
+				ri->desc->name);
+			ret = PTR_ERR(rdev);
+			goto scrub;
+		}
+		ri->rdev = rdev;
 	}
 
-	platform_set_drvdata(pdev, rdev);
+	platform_set_drvdata(pdev, pmic);
 	return 0;
+
+scrub:
+	while (--num >= 0) {
+		ri = &pmic[num];
+		regulator_unregister(ri->rdev);
+	}
+	return ret;
 }
 
 static int __devexit tps65090_regulator_remove(struct platform_device *pdev)
 {
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+	struct tps65090_regulator *pmic = platform_get_drvdata(pdev);
+	struct tps65090_regulator *ri;
+	int num;
 
-	regulator_unregister(rdev);
+	for (num = 0; num < TPS65090_ID_MAX; ++num) {
+		ri = &pmic[num];
+		regulator_unregister(ri->rdev);
+	}
 	return 0;
 }
 
diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
index 6bc31d8..d06c633 100644
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@ -24,6 +24,23 @@
 
 #include <linux/irq.h>
 
+/* TPS65090 Regulator ID */
+enum {
+	TPS65090_ID_DCDC1,
+	TPS65090_ID_DCDC2,
+	TPS65090_ID_DCDC3,
+	TPS65090_ID_FET1,
+	TPS65090_ID_FET2,
+	TPS65090_ID_FET3,
+	TPS65090_ID_FET4,
+	TPS65090_ID_FET5,
+	TPS65090_ID_FET6,
+	TPS65090_ID_FET7,
+
+	/* Last entry for maximum ID */
+	TPS65090_ID_MAX,
+};
+
 struct tps65090 {
 	struct mutex		lock;
 	struct device		*dev;
@@ -41,10 +58,21 @@ struct tps65090_subdev_info {
 	void		*platform_data;
 };
 
+/*
+ * struct tps65090_regulator_plat_data
+ *
+ * @reg_init_data: The regulator init data.
+ */
+
+struct tps65090_regulator_plat_data {
+	struct regulator_init_data *reg_init_data;
+};
+
 struct tps65090_platform_data {
 	int irq_base;
 	int num_subdevs;
 	struct tps65090_subdev_info *subdevs;
+	struct tps65090_regulator_plat_data *reg_pdata[TPS65090_ID_MAX];
 };
 
 /*
diff --git a/include/linux/regulator/tps65090-regulator.h b/include/linux/regulator/tps65090-regulator.h
deleted file mode 100644
index 0fa04b6..0000000
--- a/include/linux/regulator/tps65090-regulator.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * Regulator driver interface for TI TPS65090 PMIC family
- *
- * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
-
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
-
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
-
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef __REGULATOR_TPS65090_H
-#define __REGULATOR_TPS65090_H
-
-#include <linux/regulator/machine.h>
-
-#define tps65090_rails(_name) "tps65090_"#_name
-
-enum {
-	TPS65090_ID_DCDC1,
-	TPS65090_ID_DCDC2,
-	TPS65090_ID_DCDC3,
-	TPS65090_ID_FET1,
-	TPS65090_ID_FET2,
-	TPS65090_ID_FET3,
-	TPS65090_ID_FET4,
-	TPS65090_ID_FET5,
-	TPS65090_ID_FET6,
-	TPS65090_ID_FET7,
-};
-
-/*
- * struct tps65090_regulator_platform_data
- *
- * @regulator: The regulator init data.
- * @slew_rate_uV_per_us: Slew rate microvolt per microsec.
- */
-
-struct tps65090_regulator_platform_data {
-	struct regulator_init_data regulator;
-};
-
-#endif	/* __REGULATOR_TPS65090_H */
-- 
1.7.1.1

