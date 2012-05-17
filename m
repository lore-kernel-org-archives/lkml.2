Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761174Ab2EQNqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 09:46:46 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40874 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760910Ab2EQNqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 09:46:44 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/18] regulator: ab8500: Split up probe() into manageable pieces
Date: Thu, 17 May 2012 14:45:14 +0100
Message-Id: <1337262323-27692-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337262323-27692-1-git-send-email-lee.jones@linaro.org>
References: <1337262323-27692-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ab8500's probe() function is becoming quite large, so in the lead
up to Device Tree enablement which will fork the thread of execution
this patch splits it into 3 main areas; basic error checking will
remain in probe(), but regulator register initialisation and regulator
registration have been moved to their own functions which will
be called in sequence by probe() and the DT equivalent.

Cc: linux-kernel@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |  150 +++++++++++++++++++++++++-------------------
 1 file changed, 87 insertions(+), 63 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index d156390..3571b54 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -708,11 +708,92 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	REG_INIT(AB8500_REGUCTRLDISCH2,		0x04, 0x44, 0x16),
 };
 
+static __devinit int
+ab8500_regulator_init_registers(struct platform_device *pdev, int id, int value)
+{
+	int err;
+
+	if (value & ~ab8500_reg_init[id].mask) {
+		dev_err(&pdev->dev,
+			"Configuration error: value outside mask.\n");
+		return -EINVAL;
+	}
+
+	err = abx500_mask_and_set_register_interruptible(
+		&pdev->dev,
+		ab8500_reg_init[id].bank,
+		ab8500_reg_init[id].addr,
+		ab8500_reg_init[id].mask,
+		value);
+	if (err < 0) {
+		dev_err(&pdev->dev,
+			"Failed to initialize 0x%02x, 0x%02x.\n",
+			ab8500_reg_init[id].bank,
+			ab8500_reg_init[id].addr);
+		return err;
+	}
+
+	dev_vdbg(&pdev->dev,
+		"init: 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
+		ab8500_reg_init[id].bank,
+		ab8500_reg_init[id].addr,
+		ab8500_reg_init[id].mask,
+		value);
+
+	return 0;
+}
+
+static __devinit int ab8500_regulator_register(struct platform_device *pdev,
+					struct regulator_init_data *init_data,
+					int id,
+					struct device_node *np)
+{
+	struct ab8500_regulator_info *info = NULL;
+	struct regulator_config config = { };
+	int err;
+
+	/* assign per-regulator data */
+	info = &ab8500_regulator_info[id];
+	info->dev = &pdev->dev;
+
+	config.dev = &pdev->dev;
+	config.init_data = init_data;
+	config.driver_data = info;
+	config.of_node = np;
+
+	/* fix for hardware before ab8500v2.0 */
+	if (abx500_get_chip_id(info->dev) < 0x20) {
+		if (info->desc.id == AB8500_LDO_AUX3) {
+			info->desc.n_voltages =
+				ARRAY_SIZE(ldo_vauxn_voltages);
+			info->voltages = ldo_vauxn_voltages;
+			info->voltages_len =
+				ARRAY_SIZE(ldo_vauxn_voltages);
+			info->voltage_mask = 0xf;
+		}
+	}
+
+	/* register regulator with framework */
+	info->regulator = regulator_register(&info->desc, &config);
+	if (IS_ERR(info->regulator)) {
+		err = PTR_ERR(info->regulator);
+		dev_err(&pdev->dev, "failed to register regulator %s\n",
+			info->desc.name);
+		/* when we fail, un-register all earlier regulators */
+		while (--id >= 0) {
+			info = &ab8500_regulator_info[id];
+			regulator_unregister(info->regulator);
+		}
+		return err;
+	}
+
+	return 0;
+}
+
 static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct ab8500_platform_data *pdata;
-	struct regulator_config config = { };
 	int i, err;
 
 	if (!ab8500) {
@@ -733,8 +814,7 @@ static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 
 	/* initialize registers */
 	for (i = 0; i < pdata->num_regulator_reg_init; i++) {
-		int id;
-		u8 value;
+		int id, value;
 
 		id = pdata->regulator_reg_init[i].id;
 		value = pdata->regulator_reg_init[i].value;
@@ -745,73 +825,17 @@ static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 				"Configuration error: id outside range.\n");
 			return -EINVAL;
 		}
-		if (value & ~ab8500_reg_init[id].mask) {
-			dev_err(&pdev->dev,
-				"Configuration error: value outside mask.\n");
-			return -EINVAL;
-		}
 
-		/* initialize register */
-		err = abx500_mask_and_set_register_interruptible(&pdev->dev,
-			ab8500_reg_init[id].bank,
-			ab8500_reg_init[id].addr,
-			ab8500_reg_init[id].mask,
-			value);
-		if (err < 0) {
-			dev_err(&pdev->dev,
-				"Failed to initialize 0x%02x, 0x%02x.\n",
-				ab8500_reg_init[id].bank,
-				ab8500_reg_init[id].addr);
+		err = ab8500_regulator_init_registers(pdev, id, value);
+		if (err < 0)
 			return err;
-		}
-		dev_vdbg(&pdev->dev,
-			"  init: 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
-			ab8500_reg_init[id].bank,
-			ab8500_reg_init[id].addr,
-			ab8500_reg_init[id].mask,
-			value);
 	}
 
 	/* register all regulators */
 	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
-		struct ab8500_regulator_info *info = NULL;
-
-		/* assign per-regulator data */
-		info = &ab8500_regulator_info[i];
-		info->dev = &pdev->dev;
-
-		config.dev = &pdev->dev;
-		config.init_data = &pdata->regulator[i];
-		config.driver_data = info;
-
-		/* fix for hardware before ab8500v2.0 */
-		if (abx500_get_chip_id(info->dev) < 0x20) {
-			if (info->desc.id == AB8500_LDO_AUX3) {
-				info->desc.n_voltages =
-					ARRAY_SIZE(ldo_vauxn_voltages);
-				info->voltages = ldo_vauxn_voltages;
-				info->voltages_len =
-					ARRAY_SIZE(ldo_vauxn_voltages);
-				info->voltage_mask = 0xf;
-			}
-		}
-
-		/* register regulator with framework */
-		info->regulator = regulator_register(&info->desc, &config);
-		if (IS_ERR(info->regulator)) {
-			err = PTR_ERR(info->regulator);
-			dev_err(&pdev->dev, "failed to register regulator %s\n",
-					info->desc.name);
-			/* when we fail, un-register all earlier regulators */
-			while (--i >= 0) {
-				info = &ab8500_regulator_info[i];
-				regulator_unregister(info->regulator);
-			}
+		err = ab8500_regulator_register(pdev, &pdata->regulator[i], i, NULL);
+		if (err < 0)
 			return err;
-		}
-
-		dev_vdbg(rdev_get_dev(info->regulator),
-			"%s-probed\n", info->desc.name);
 	}
 
 	return 0;
-- 
1.7.9.5

