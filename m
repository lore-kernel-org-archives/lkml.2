Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab1JRTBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 15:01:33 -0400
Received: from mail.fuel7.com ([74.222.0.51]:44538 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab1JRTAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 15:00:12 -0400
From: Kyle Manna <kyle.manna@fuel7.com>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@ti.com>
Cc: Kyle Manna <kyle.manna@fuel7.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 6/6] mfd: TPS65910: Improve regulator init data
Date: Tue, 18 Oct 2011 13:26:28 -0500
Message-Id: <1318962388-26151-7-git-send-email-kyle.manna@fuel7.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318962388-26151-1-git-send-email-kyle.manna@fuel7.com>
References: <1318962388-26151-1-git-send-email-kyle.manna@fuel7.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the interface between platform code/board files to the TPS65910
regulators.  The TWL4030/6030 code was used as an example interface.

This improved interface will allow use of the regulators without
specifying all the constraints. Also gets rid of an assumption that
the platform pass in an array of correct size and was unchecked.

Signed-off-by: Kyle Manna <kyle.manna@fuel7.com>
---
 drivers/regulator/tps65910-regulator.c |  209 +++++++++++++++++++++++++-------
 include/linux/mfd/tps65910.h           |   29 +++++-
 2 files changed, 192 insertions(+), 46 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 44ce2b0..4c2ae4b 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -900,22 +900,71 @@ static struct regulator_ops tps65911_ops = {
 	.list_voltage		= tps65911_list_voltage,
 };
 
+static __devinit struct regulator_dev *add_regulator(
+		struct tps65910_reg *pmic,
+		struct tps_info *info,
+		int i,
+		const struct regulator_init_data *init_data)
+{
+	struct tps65910 *tps65910 = pmic->mfd;
+	struct regulator_dev *rdev;
+
+	/* Register the regulators */
+	pmic->info[i] = &info[i];
+
+	if (init_data->constraints.name)
+		pmic->desc[i].name = init_data->constraints.name;
+	else
+		pmic->desc[i].name = info[i].name;
+
+	pmic->desc[i].id = i;
+	pmic->desc[i].n_voltages = info->table_len;
+
+	if (i == TPS65910_REG_VDD1 || i == TPS65910_REG_VDD2) {
+		pmic->desc[i].ops = &tps65910_ops_dcdc;
+	} else if (i == TPS65910_REG_VDD3) {
+		if (tps65910_chip_id(tps65910) == TPS65910)
+			pmic->desc[i].ops = &tps65910_ops_vdd3;
+		else
+			pmic->desc[i].ops = &tps65910_ops_dcdc;
+	} else {
+		if (tps65910_chip_id(tps65910) == TPS65910)
+			pmic->desc[i].ops = &tps65910_ops;
+		else
+			pmic->desc[i].ops = &tps65911_ops;
+	}
+
+	pmic->desc[i].type = REGULATOR_VOLTAGE;
+	pmic->desc[i].owner = THIS_MODULE;
+
+	rdev = regulator_register(&pmic->desc[i],
+			tps65910->dev, init_data, pmic);
+	if (IS_ERR(rdev)) {
+		dev_err(tps65910->dev,
+				"failed to register %s regulator\n",
+				pmic->desc[i].name);
+		rdev = (struct regulator_dev *)PTR_ERR(rdev);
+	} else {
+		/* Save regulator for cleanup */
+		pmic->rdev[i] = rdev;
+	}
+
+	return rdev;
+}
+
 static __devinit int tps65910_probe(struct platform_device *pdev)
 {
 	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
 	struct tps_info *info;
-	struct regulator_init_data *reg_data;
 	struct regulator_dev *rdev;
 	struct tps65910_reg *pmic;
 	struct tps65910_board *pmic_plat_data;
-	int i, err;
+	int err;
 
 	pmic_plat_data = dev_get_platdata(tps65910->dev);
 	if (!pmic_plat_data)
 		return -EINVAL;
 
-	reg_data = pmic_plat_data->tps65910_pmic_init_data;
-
 	pmic = kzalloc(sizeof(*pmic), GFP_KERNEL);
 	if (!pmic)
 		return -ENOMEM;
@@ -966,50 +1015,120 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		goto err_free_info;
 	}
 
-	for (i = 0; i < pmic->num_regulators; i++, info++, reg_data++) {
-		/* Register the regulators */
-		pmic->info[i] = info;
-
-		pmic->desc[i].name = info->name;
-		pmic->desc[i].id = i;
-		pmic->desc[i].n_voltages = info->table_len;
-
-		if (i == TPS65910_REG_VDD1 || i == TPS65910_REG_VDD2) {
-			pmic->desc[i].ops = &tps65910_ops_dcdc;
-		} else if (i == TPS65910_REG_VDD3) {
-			if (tps65910_chip_id(tps65910) == TPS65910)
-				pmic->desc[i].ops = &tps65910_ops_vdd3;
-			else
-				pmic->desc[i].ops = &tps65910_ops_dcdc;
-		} else {
-			if (tps65910_chip_id(tps65910) == TPS65910)
-				pmic->desc[i].ops = &tps65910_ops;
-			else
-				pmic->desc[i].ops = &tps65911_ops;
-		}
-
-		pmic->desc[i].type = REGULATOR_VOLTAGE;
-		pmic->desc[i].owner = THIS_MODULE;
-
-		rdev = regulator_register(&pmic->desc[i],
-				tps65910->dev, reg_data, pmic);
-		if (IS_ERR(rdev)) {
-			dev_err(tps65910->dev,
-				"failed to register %s regulator\n",
-				pdev->name);
-			err = PTR_ERR(rdev);
-			goto err_unregister_regulator;
-		}
-
-		/* Save regulator for cleanup */
-		pmic->rdev[i] = rdev;
+	/* TPS65910 and TPS65911 Regulators */
+	rdev = add_regulator(pmic, info, TPS65910_REG_VRTC,
+			pmic_plat_data->vrtc);
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
+	rdev = add_regulator(pmic, info, TPS65910_REG_VIO,
+			pmic_plat_data->vio);
+
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
+
+	rdev = add_regulator(pmic, info, TPS65910_REG_VDD1,
+			pmic_plat_data->vdd1);
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
+
+	rdev = add_regulator(pmic, info, TPS65910_REG_VDD2,
+			pmic_plat_data->vdd2);
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
+
+	if (tps65910_chip_id(tps65910) == TPS65910) {
+		/* TPS65910 Regulators */
+		rdev = add_regulator(pmic, info, TPS65910_REG_VDD3,
+				pmic_plat_data->vdd3);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65910_REG_VDIG1,
+				pmic_plat_data->vdig1);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65910_REG_VDIG2,
+				pmic_plat_data->vdig2);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65910_REG_VDAC,
+				pmic_plat_data->vdac);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65910_REG_VAUX1,
+				pmic_plat_data->vaux1);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65910_REG_VAUX2,
+				pmic_plat_data->vaux2);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65910_REG_VAUX33,
+				pmic_plat_data->vaux33);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65910_REG_VMMC,
+				pmic_plat_data->vmmc);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+
+	} else if (tps65910_chip_id(tps65910) == TPS65910) {
+		/* TPS65911 Regulators */
+		rdev = add_regulator(pmic, info, TPS65911_REG_VDDCTRL,
+				pmic_plat_data->vddctrl);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65911_REG_LDO1,
+				pmic_plat_data->ldo1);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65911_REG_LDO2,
+				pmic_plat_data->ldo2);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65911_REG_LDO3,
+				pmic_plat_data->ldo3);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65911_REG_LDO4,
+				pmic_plat_data->ldo4);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65911_REG_LDO5,
+				pmic_plat_data->ldo5);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65911_REG_LDO6,
+				pmic_plat_data->ldo6);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65911_REG_LDO7,
+				pmic_plat_data->ldo7);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		rdev = add_regulator(pmic, info, TPS65911_REG_LDO8,
+				pmic_plat_data->ldo8);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
 	}
+
 	return 0;
 
-err_unregister_regulator:
-	while (--i >= 0)
-		regulator_unregister(pmic->rdev[i]);
-	kfree(pmic->rdev);
 err_free_info:
 	kfree(pmic->info);
 err_free_desc:
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 503ded3..38d9821 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -757,7 +757,34 @@ struct tps65910_board {
 	int irq_base;
 	int vmbch_threshold;
 	int vmbch2_threshold;
-	struct regulator_init_data *tps65910_pmic_init_data;
+
+	/* TPS65910 and TPS65911 Regulators */
+	struct regulator_init_data *vrtc;
+	struct regulator_init_data *vio;
+	struct regulator_init_data *vdd1;
+	struct regulator_init_data *vdd2;
+
+	/* TPS65910 Regulators */
+	struct regulator_init_data *vdd3;
+	struct regulator_init_data *vdig1;
+	struct regulator_init_data *vdig2;
+	struct regulator_init_data *vpll;
+	struct regulator_init_data *vdac;
+	struct regulator_init_data *vaux1;
+	struct regulator_init_data *vaux2;
+	struct regulator_init_data *vaux33;
+	struct regulator_init_data *vmmc;
+
+	/* TPS65911 Regulators */
+	struct regulator_init_data *vddctrl;
+	struct regulator_init_data *ldo1;
+	struct regulator_init_data *ldo2;
+	struct regulator_init_data *ldo3;
+	struct regulator_init_data *ldo4;
+	struct regulator_init_data *ldo5;
+	struct regulator_init_data *ldo6;
+	struct regulator_init_data *ldo7;
+	struct regulator_init_data *ldo8;
 };
 
 /**
-- 
1.7.5.4

