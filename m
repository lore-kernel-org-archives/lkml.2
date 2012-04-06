Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab2DFKnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 06:43:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36619 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755706Ab2DFKnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 06:43:05 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Use a struct to pass in regulator runtime configuration
Date: Fri,  6 Apr 2012 11:43:00 +0100
Message-Id: <1333708980-5594-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than adding new arguments to regulator_register() every time we
want to add a new bit of dynamic information at runtime change the function
to take these via a struct. By doing this we avoid needing to do further
changes like the recent addition of device tree support which required each
regulator driver to be updated to take an additional parameter.

The regulator_desc which should (mostly) be static data is still passed
separately as most drivers are able to configure this statically at build
time.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/88pm8607.c           |    8 ++++++--
 drivers/regulator/aat2870-regulator.c  |    8 ++++++--
 drivers/regulator/ab3100.c             |   11 ++++++-----
 drivers/regulator/ab8500.c             |    8 ++++++--
 drivers/regulator/ad5398.c             |    8 ++++++--
 drivers/regulator/core.c               |   19 +++++++++----------
 drivers/regulator/da903x.c             |    8 ++++++--
 drivers/regulator/da9052-regulator.c   |   10 +++++++---
 drivers/regulator/db8500-prcmu.c       |    8 ++++++--
 drivers/regulator/dummy.c              |    6 ++++--
 drivers/regulator/fixed.c              |   10 +++++++---
 drivers/regulator/gpio-regulator.c     |    8 ++++++--
 drivers/regulator/isl6271a-regulator.c |   11 +++++++++--
 drivers/regulator/lp3971.c             |    9 +++++++--
 drivers/regulator/lp3972.c             |    9 +++++++--
 drivers/regulator/max1586.c            |   10 +++++++---
 drivers/regulator/max8649.c            |    8 ++++++--
 drivers/regulator/max8660.c            |    9 ++++++---
 drivers/regulator/max8925-regulator.c  |    8 ++++++--
 drivers/regulator/max8952.c            |    8 ++++++--
 drivers/regulator/max8997.c            |    8 ++++++--
 drivers/regulator/max8998.c            |    9 +++++++--
 drivers/regulator/pcap-regulator.c     |    8 ++++++--
 drivers/regulator/pcf50633-regulator.c |    8 ++++++--
 drivers/regulator/rc5t583-regulator.c  |    9 +++++++--
 drivers/regulator/s5m8767.c            |    8 ++++++--
 drivers/regulator/tps6105x-regulator.c |    9 ++++++---
 drivers/regulator/tps62360-regulator.c |    8 ++++++--
 drivers/regulator/tps65023-regulator.c |    8 ++++++--
 drivers/regulator/tps6507x-regulator.c |    8 ++++++--
 drivers/regulator/tps65090-regulator.c |    8 ++++++--
 drivers/regulator/tps65217-regulator.c |    8 ++++++--
 drivers/regulator/tps6524x-regulator.c |    8 ++++++--
 drivers/regulator/tps6586x-regulator.c |    8 ++++++--
 drivers/regulator/tps65910-regulator.c |    8 ++++++--
 drivers/regulator/tps65912-regulator.c |    9 +++++++--
 drivers/regulator/twl-regulator.c      |    9 +++++++--
 drivers/regulator/wm831x-dcdc.c        |   32 ++++++++++++++++++++++++--------
 drivers/regulator/wm831x-isink.c       |    8 ++++++--
 drivers/regulator/wm831x-ldo.c         |   24 ++++++++++++++++++------
 drivers/regulator/wm8350-regulator.c   |    9 ++++++---
 drivers/regulator/wm8400-regulator.c   |    7 +++++--
 drivers/regulator/wm8994-regulator.c   |    8 ++++++--
 include/linux/regulator/driver.h       |   31 ++++++++++++++++++++++++++-----
 sound/soc/codecs/sgtl5000.c            |    8 ++++++--
 45 files changed, 332 insertions(+), 120 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 11e5ddd..d04fbe9 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -365,6 +365,7 @@ static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
 	struct pm8607_regulator_info *info = NULL;
 	struct regulator_init_data *pdata = pdev->dev.platform_data;
+	struct regulator_config config = { };
 	struct resource *res;
 	int i;
 
@@ -390,9 +391,12 @@ static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
 	if ((i == PM8607_ID_BUCK3) && info->chip->buck3_double)
 		info->slope_double = 1;
 
+	config.dev = &pdev->dev;
+	config.init_data = pdata;
+	config.driver_data = info;
+
 	/* replace driver_data with info */
-	info->regulator = regulator_register(&info->desc, &pdev->dev,
-					     pdata, info, NULL);
+	info->regulator = regulator_register(&info->desc, &config);
 	if (IS_ERR(info->regulator)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 			info->desc.name);
diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
index 7cc380e..7f000d6 100644
--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -178,6 +178,7 @@ static struct aat2870_regulator *aat2870_get_regulator(int id)
 static int aat2870_regulator_probe(struct platform_device *pdev)
 {
 	struct aat2870_regulator *ri;
+	struct regulator_config config = { 0 };
 	struct regulator_dev *rdev;
 
 	ri = aat2870_get_regulator(pdev->id);
@@ -187,8 +188,11 @@ static int aat2870_regulator_probe(struct platform_device *pdev)
 	}
 	ri->aat2870 = dev_get_drvdata(pdev->dev.parent);
 
-	rdev = regulator_register(&ri->desc, &pdev->dev,
-				  pdev->dev.platform_data, ri, NULL);
+	config.dev = &pdev->dev;
+	config.driver_data = ri;
+	config.init_data = pdev->dev.platform_data;
+
+	rdev = regulator_register(&ri->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "Failed to register regulator %s\n",
 			ri->desc.name);
diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index ed56c93..ce61925 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -574,6 +574,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 static int __devinit ab3100_regulators_probe(struct platform_device *pdev)
 {
 	struct ab3100_platform_data *plfdata = pdev->dev.platform_data;
+	struct regulator_config config = { };
 	int err = 0;
 	u8 data;
 	int i;
@@ -619,15 +620,15 @@ static int __devinit ab3100_regulators_probe(struct platform_device *pdev)
 		reg->dev = &pdev->dev;
 		reg->plfdata = plfdata;
 
+		config.dev = &pdev->dev;
+		config.driver_data = reg;
+		config.init_data = &plfdata->reg_constraints[i];
+
 		/*
 		 * Register the regulator, pass around
 		 * the ab3100_regulator struct
 		 */
-		rdev = regulator_register(&ab3100_regulator_desc[i],
-					  &pdev->dev,
-					  &plfdata->reg_constraints[i],
-					  reg, NULL);
-
+		rdev = regulator_register(&ab3100_regulator_desc[i], &config);
 		if (IS_ERR(rdev)) {
 			err = PTR_ERR(rdev);
 			dev_err(&pdev->dev,
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 0d095b6..93feada 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -712,6 +712,7 @@ static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct ab8500_platform_data *pdata;
+	struct regulator_config config = { };
 	int i, err;
 
 	if (!ab8500) {
@@ -779,6 +780,10 @@ static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 		info = &ab8500_regulator_info[i];
 		info->dev = &pdev->dev;
 
+		config->dev = &pdev->dev;
+		config->init_data = &pdata->regulator[i];
+		config->driver_data = info;
+
 		/* fix for hardware before ab8500v2.0 */
 		if (abx500_get_chip_id(info->dev) < 0x20) {
 			if (info->desc.id == AB8500_LDO_AUX3) {
@@ -792,8 +797,7 @@ static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 		}
 
 		/* register regulator with framework */
-		info->regulator = regulator_register(&info->desc, &pdev->dev,
-				&pdata->regulator[i], info, NULL);
+		info->regulator = regulator_register(&info->desc, &config);
 		if (IS_ERR(info->regulator)) {
 			err = PTR_ERR(info->regulator);
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index 7d51793..795601a 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -212,6 +212,7 @@ static int __devinit ad5398_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
 	struct regulator_init_data *init_data = client->dev.platform_data;
+	struct regulator_config config = { };
 	struct ad5398_chip_info *chip;
 	const struct ad5398_current_data_format *df =
 			(struct ad5398_current_data_format *)id->driver_data;
@@ -224,6 +225,10 @@ static int __devinit ad5398_probe(struct i2c_client *client,
 	if (!chip)
 		return -ENOMEM;
 
+	config.dev = &client->dev;
+	config.init_data = init_data;
+	config.driver_data = chip;
+
 	chip->client = client;
 
 	chip->min_uA = df->min_uA;
@@ -232,8 +237,7 @@ static int __devinit ad5398_probe(struct i2c_client *client,
 	chip->current_offset = df->current_offset;
 	chip->current_mask = (chip->current_level - 1) << chip->current_offset;
 
-	chip->rdev = regulator_register(&ad5398_reg, &client->dev,
-					init_data, chip, NULL);
+	chip->rdev = regulator_register(&ad5398_reg, &config);
 	if (IS_ERR(chip->rdev)) {
 		ret = PTR_ERR(chip->rdev);
 		dev_err(&client->dev, "failed to register %s %s\n",
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 74008c0..38d0d26 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2837,27 +2837,24 @@ static void rdev_init_debugfs(struct regulator_dev *rdev)
 /**
  * regulator_register - register regulator
  * @regulator_desc: regulator to register
- * @dev: struct device for the regulator
- * @init_data: platform provided init data, passed through by driver
- * @driver_data: private regulator data
- * @of_node: OpenFirmware node to parse for device tree bindings (may be
- *           NULL).
+ * @config: runtime configuration for regulator
  *
  * Called by regulator drivers to register a regulator.
  * Returns 0 on success.
  */
 struct regulator_dev *
 regulator_register(const struct regulator_desc *regulator_desc,
-	struct device *dev, const struct regulator_init_data *init_data,
-	void *driver_data, struct device_node *of_node)
+		   const struct regulator_config *config)
 {
 	const struct regulation_constraints *constraints = NULL;
+	const struct regulator_init_data *init_data;
 	static atomic_t regulator_no = ATOMIC_INIT(0);
 	struct regulator_dev *rdev;
+	struct device *dev = config->dev;
 	int ret, i;
 	const char *supply = NULL;
 
-	if (regulator_desc == NULL)
+	if (regulator_desc == NULL || config == NULL)
 		return ERR_PTR(-EINVAL);
 
 	if (regulator_desc->name == NULL || regulator_desc->ops == NULL)
@@ -2883,6 +2880,8 @@ regulator_register(const struct regulator_desc *regulator_desc,
 		return ERR_PTR(-EINVAL);
 	}
 
+	init_data = config->init_data;
+
 	rdev = kzalloc(sizeof(struct regulator_dev), GFP_KERNEL);
 	if (rdev == NULL)
 		return ERR_PTR(-ENOMEM);
@@ -2890,7 +2889,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	mutex_lock(&regulator_list_mutex);
 
 	mutex_init(&rdev->mutex);
-	rdev->reg_data = driver_data;
+	rdev->reg_data = config->driver_data;
 	rdev->owner = regulator_desc->owner;
 	rdev->desc = regulator_desc;
 	INIT_LIST_HEAD(&rdev->consumer_list);
@@ -2907,7 +2906,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 
 	/* register with sysfs */
 	rdev->dev.class = &regulator_class;
-	rdev->dev.of_node = of_node;
+	rdev->dev.of_node = config->of_node;
 	rdev->dev.parent = dev;
 	dev_set_name(&rdev->dev, "regulator.%d",
 		     atomic_inc_return(&regulator_no) - 1);
diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 1851f09..4630b1e 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -517,6 +517,7 @@ static int __devinit da903x_regulator_probe(struct platform_device *pdev)
 {
 	struct da903x_regulator_info *ri = NULL;
 	struct regulator_dev *rdev;
+	struct regulator_config config = { };
 
 	ri = find_regulator_info(pdev->id);
 	if (ri == NULL) {
@@ -536,8 +537,11 @@ static int __devinit da903x_regulator_probe(struct platform_device *pdev)
 	if (ri->desc.id == DA9030_ID_LDO1 || ri->desc.id == DA9030_ID_LDO15)
 		ri->desc.ops = &da9030_regulator_ldo1_15_ops;
 
-	rdev = regulator_register(&ri->desc, &pdev->dev,
-				  pdev->dev.platform_data, ri, NULL);
+	config.dev = &pdev->dev;
+	conifg.init_data = pdev->dev.platform_data;
+	config.driver_data = ri;
+
+	rdev = regulator_register(&ri->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc.name);
diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 7eb7293..48548978 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -403,6 +403,7 @@ static inline struct da9052_regulator_info *find_regulator_info(u8 chip_id,
 
 static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 {
+	struct regulator_config config = { };
 	struct da9052_regulator *regulator;
 	struct da9052 *da9052;
 	struct da9052_pdata *pdata;
@@ -424,10 +425,13 @@ static int __devinit da9052_regulator_probe(struct platform_device *pdev)
 		ret = -EINVAL;
 		goto err;
 	}
+
+	config.dev = &pdev->dev;
+	config.init_data = pdata->regulators[pdev->id];
+	config.driver_data = regulator;
+
 	regulator->rdev = regulator_register(&regulator->info->reg_desc,
-					     &pdev->dev,
-					     pdata->regulators[pdev->id],
-					     regulator, NULL);
+					     &config);
 	if (IS_ERR(regulator->rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 			regulator->info->reg_desc.name);
diff --git a/drivers/regulator/db8500-prcmu.c b/drivers/regulator/db8500-prcmu.c
index 4bd25e7..87b2e83 100644
--- a/drivers/regulator/db8500-prcmu.c
+++ b/drivers/regulator/db8500-prcmu.c
@@ -414,6 +414,7 @@ static int __devinit db8500_regulator_probe(struct platform_device *pdev)
 {
 	struct regulator_init_data *db8500_init_data =
 					dev_get_platdata(&pdev->dev);
+	struct regulator_config config = { };
 	int i, err;
 
 	/* register all regulators */
@@ -425,9 +426,12 @@ static int __devinit db8500_regulator_probe(struct platform_device *pdev)
 		info = &dbx500_regulator_info[i];
 		info->dev = &pdev->dev;
 
+		config.dev = &pdev->dev;
+		config.init_data = init_data;
+		config.driver_data = info;
+
 		/* register with the regulator framework */
-		info->rdev = regulator_register(&info->desc, &pdev->dev,
-				init_data, info, NULL);
+		info->rdev = regulator_register(&info->desc, &config);
 		if (IS_ERR(info->rdev)) {
 			err = PTR_ERR(info->rdev);
 			dev_err(&pdev->dev, "failed to register %s: err %i\n",
diff --git a/drivers/regulator/dummy.c b/drivers/regulator/dummy.c
index 0ee00de..1571bee 100644
--- a/drivers/regulator/dummy.c
+++ b/drivers/regulator/dummy.c
@@ -39,10 +39,12 @@ static struct regulator_desc dummy_desc = {
 
 static int __devinit dummy_regulator_probe(struct platform_device *pdev)
 {
+	struct regulator_config config = { };
 	int ret;
 
-	dummy_regulator_rdev = regulator_register(&dummy_desc, NULL,
-						  &dummy_initdata, NULL, NULL);
+	config.init_data = &dummy_initdata;
+
+	dummy_regulator_rdev = regulator_register(&dummy_desc, &config);
 	if (IS_ERR(dummy_regulator_rdev)) {
 		ret = PTR_ERR(dummy_regulator_rdev);
 		pr_err("Failed to register regulator: %d\n", ret);
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 9a7d70a..b47b005 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -167,6 +167,7 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 {
 	struct fixed_voltage_config *config;
 	struct fixed_voltage_data *drvdata;
+	struct regulator_config cfg = { };
 	int ret;
 
 	if (pdev->dev.of_node)
@@ -247,9 +248,12 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 		drvdata->desc.ops = &fixed_voltage_ops;
 	}
 
-	drvdata->dev = regulator_register(&drvdata->desc, &pdev->dev,
-					  config->init_data, drvdata,
-					  pdev->dev.of_node);
+	cfg.dev = &pdev->dev;
+	cfg.init_data = config->init_data;
+	cfg.driver_data = drvdata;
+	cfg.of_node = pdev->dev.of_node;
+
+	drvdata->dev = regulator_register(&drvdata->desc, &cfg);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index ad0fc78..f93b06b 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -172,6 +172,7 @@ static int __devinit gpio_regulator_probe(struct platform_device *pdev)
 {
 	struct gpio_regulator_config *config = pdev->dev.platform_data;
 	struct gpio_regulator_data *drvdata;
+	struct regulator_config cfg = { };
 	int ptr, ret, state;
 
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct gpio_regulator_data),
@@ -284,8 +285,11 @@ static int __devinit gpio_regulator_probe(struct platform_device *pdev)
 	}
 	drvdata->state = state;
 
-	drvdata->dev = regulator_register(&drvdata->desc, &pdev->dev,
-					  config->init_data, drvdata, NULL);
+	cfg.dev = &pdev->dev;
+	cfg.init_data = config->init_data;
+	cfg.driver_data = &drvdata;
+
+	drvdata->dev = regulator_register(&drvdata->desc, &cfg);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index 6539ef9..998901e 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -140,6 +140,7 @@ static struct regulator_desc isl_rd[] = {
 static int __devinit isl6271a_probe(struct i2c_client *i2c,
 				     const struct i2c_device_id *id)
 {
+	struct regulator_config config = { };
 	struct regulator_init_data *init_data	= i2c->dev.platform_data;
 	struct isl_pmic *pmic;
 	int err, i;
@@ -156,8 +157,14 @@ static int __devinit isl6271a_probe(struct i2c_client *i2c,
 	mutex_init(&pmic->mtx);
 
 	for (i = 0; i < 3; i++) {
-		pmic->rdev[i] = regulator_register(&isl_rd[i], &i2c->dev,
-						init_data, pmic, NULL);
+		config.dev = &i2c->dev;
+		if (i == 0)
+			config.init_data = init_data;
+		else
+			config.init_data = 0;
+		config.driver_data = pmic;
+
+		pmic->rdev[i] = regulator_register(&isl_rd[i], &config);
 		if (IS_ERR(pmic->rdev[i])) {
 			dev_err(&i2c->dev, "failed to register %s\n", id->name);
 			err = PTR_ERR(pmic->rdev[i]);
diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 2013525..3b5accd 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -421,10 +421,15 @@ static int __devinit setup_regulators(struct lp3971 *lp3971,
 
 	/* Instantiate the regulators */
 	for (i = 0; i < pdata->num_regulators; i++) {
+		struct regulator_config config = { };
 		struct lp3971_regulator_subdev *reg = &pdata->regulators[i];
-		lp3971->rdev[i] = regulator_register(&regulators[reg->id],
-				lp3971->dev, reg->initdata, lp3971, NULL);
 
+		config.dev = lp3971->dev;
+		config.init_data = reg->initdata;
+		config.driver_data = lp3971;
+
+		lp3971->rdev[i] = regulator_register(&regulators[reg->id],
+						     &config);
 		if (IS_ERR(lp3971->rdev[i])) {
 			err = PTR_ERR(lp3971->rdev[i]);
 			dev_err(lp3971->dev, "regulator init failed: %d\n",
diff --git a/drivers/regulator/lp3972.c b/drivers/regulator/lp3972.c
index 4f28d36..28e5b7a 100644
--- a/drivers/regulator/lp3972.c
+++ b/drivers/regulator/lp3972.c
@@ -527,9 +527,14 @@ static int __devinit setup_regulators(struct lp3972 *lp3972,
 	/* Instantiate the regulators */
 	for (i = 0; i < pdata->num_regulators; i++) {
 		struct lp3972_regulator_subdev *reg = &pdata->regulators[i];
-		lp3972->rdev[i] = regulator_register(&regulators[reg->id],
-				lp3972->dev, reg->initdata, lp3972, NULL);
+		struct regulator_config config = { };
+
+		config.dev = lp3972->dev;
+		config.init_data = reg->initdata;
+		config.driver_data = lp3972;
 
+		lp3972->rdev[i] = regulator_register(&regulators[reg->id],
+						     &config);
 		if (IS_ERR(lp3972->rdev[i])) {
 			err = PTR_ERR(lp3972->rdev[i]);
 			dev_err(lp3972->dev, "regulator init failed: %d\n",
diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index 282d2ee..ce4b944 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -185,6 +185,7 @@ static int __devinit max1586_pmic_probe(struct i2c_client *client,
 {
 	struct regulator_dev **rdev;
 	struct max1586_platform_data *pdata = client->dev.platform_data;
+	struct regulator_config config = { };
 	struct max1586_data *max1586;
 	int i, id, ret = -ENOMEM;
 
@@ -212,9 +213,12 @@ static int __devinit max1586_pmic_probe(struct i2c_client *client,
 			dev_err(&client->dev, "invalid regulator id %d\n", id);
 			goto err;
 		}
-		rdev[i] = regulator_register(&max1586_reg[id], &client->dev,
-					     pdata->subdevs[i].platform_data,
-					     max1586, NULL);
+
+		config.dev = &client->dev;
+		config.init_data = pdata->subdevs[i].platform_data;
+		config.driver_data = max1586;
+
+		rdev[i] = regulator_register(&max1586_reg[id], &config);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
 			dev_err(&client->dev, "failed to register %s\n",
diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 2e9ffbe..01a78c4 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -225,6 +225,7 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 {
 	struct max8649_platform_data *pdata = client->dev.platform_data;
 	struct max8649_regulator_info *info = NULL;
+	struct regulator_config config = { };
 	unsigned int val;
 	unsigned char data;
 	int ret;
@@ -297,8 +298,11 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 				   MAX8649_RAMP_DOWN);
 	}
 
-	info->regulator = regulator_register(&dcdc_desc, &client->dev,
-					     pdata->regulator, info, NULL);
+	config.dev = &client->dev;
+	config.init_data = pdata->regulator;
+	config.driver_data = info;
+
+	info->regulator = regulator_register(&dcdc_desc, &config);
 	if (IS_ERR(info->regulator)) {
 		dev_err(info->dev, "failed to register regulator %s\n",
 			dcdc_desc.name);
diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index e42db53..03407e8 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -361,6 +361,7 @@ static int __devinit max8660_probe(struct i2c_client *client,
 {
 	struct regulator_dev **rdev;
 	struct max8660_platform_data *pdata = client->dev.platform_data;
+	struct regulator_config config = { };
 	struct max8660 *max8660;
 	int boot_on, i, id, ret = -EINVAL;
 
@@ -449,9 +450,11 @@ static int __devinit max8660_probe(struct i2c_client *client,
 
 		id = pdata->subdevs[i].id;
 
-		rdev[i] = regulator_register(&max8660_reg[id], &client->dev,
-					     pdata->subdevs[i].platform_data,
-					     max8660, NULL);
+		config.dev = &client->dev;
+		config.init_data = pdata->subdevs[i].platform_data;
+		config.driver_data = max8660;
+
+		rdev[i] = regulator_register(&max8660_reg[id], &config);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
 			dev_err(&client->dev, "failed to register %s\n",
diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index a62f3b5..de30ea2 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -258,6 +258,7 @@ static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
 	struct max8925_platform_data *pdata = chip->dev->platform_data;
+	struct regulator_config config = { };
 	struct max8925_regulator_info *ri;
 	struct regulator_dev *rdev;
 
@@ -269,8 +270,11 @@ static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 	ri->i2c = chip->i2c;
 	ri->chip = chip;
 
-	rdev = regulator_register(&ri->desc, &pdev->dev,
-				  pdata->regulator[pdev->id], ri, NULL);
+	config.dev = &pdev->dev;
+	config.init_data = pdata->regulator[pdev->id];
+	config.driver_data = ri;
+
+	rdev = regulator_register(&ri->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc.name);
diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index c35236a..28866bf 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -173,6 +173,7 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
 {
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct max8952_platform_data *pdata = client->dev.platform_data;
+	struct regulator_config config = { };
 	struct max8952_data *max8952;
 
 	int ret = 0, err = 0;
@@ -193,8 +194,11 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
 	max8952->dev = &client->dev;
 	max8952->pdata = pdata;
 
-	max8952->rdev = regulator_register(&regulator, max8952->dev,
-			&pdata->reg_data, max8952, NULL);
+	config.dev = max8952->dev;
+	config.init_data = &pdata->reg_data;
+	config.driver_data = max8952;
+
+	max8952->rdev = regulator_register(&regulator, &config);
 
 	if (IS_ERR(max8952->rdev)) {
 		ret = PTR_ERR(max8952->rdev);
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 6e7beee..48fa966 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -913,6 +913,7 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 {
 	struct max8997_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct max8997_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct regulator_config config = { };
 	struct regulator_dev **rdev;
 	struct max8997_data *max8997;
 	struct i2c_client *i2c;
@@ -1096,8 +1097,11 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
 		else if (id == MAX8997_CHARGER_CV)
 			regulators[id].n_voltages = 16;
 
-		rdev[i] = regulator_register(&regulators[id], max8997->dev,
-				pdata->regulators[i].initdata, max8997, NULL);
+		config.dev = max8997->dev;
+		config.init_data = pdata->regulators[i].initdata;
+		config.driver_data = max8997;
+
+		rdev[i] = regulator_register(&regulators[id], &config);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
 			dev_err(max8997->dev, "regulator init failed for %d\n",
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 5890265..74b0b0c9 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -685,6 +685,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 {
 	struct max8998_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct max8998_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct regulator_config config = { };
 	struct regulator_dev **rdev;
 	struct max8998_data *max8998;
 	struct i2c_client *i2c;
@@ -840,8 +841,12 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 			int count = (desc->max - desc->min) / desc->step + 1;
 			regulators[index].n_voltages = count;
 		}
-		rdev[i] = regulator_register(&regulators[index], max8998->dev,
-				pdata->regulators[i].initdata, max8998, NULL);
+
+		config.dev = max8998->dev;
+		config.init_data = pdata->regulators[i].initdata;
+		config.driver_data = max8998;
+
+		rdev[i] = regulator_register(&regulators[index], &config);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
 			dev_err(max8998->dev, "regulator init failed\n");
diff --git a/drivers/regulator/pcap-regulator.c b/drivers/regulator/pcap-regulator.c
index 781bf34..ec76126 100644
--- a/drivers/regulator/pcap-regulator.c
+++ b/drivers/regulator/pcap-regulator.c
@@ -251,9 +251,13 @@ static int __devinit pcap_regulator_probe(struct platform_device *pdev)
 {
 	struct regulator_dev *rdev;
 	void *pcap = dev_get_drvdata(pdev->dev.parent);
+	struct regulator_config config = { };
 
-	rdev = regulator_register(&pcap_regulators[pdev->id], &pdev->dev,
-				pdev->dev.platform_data, pcap, NULL);
+	config.dev = &pdev->dev;
+	config.init_data = pdev->dev.platform_data;
+	config.driver_data = pcap;
+
+	rdev = regulator_register(&pcap_regulators[pdev->id], &config);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index b62f4c8..ce58100 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -296,12 +296,16 @@ static int __devinit pcf50633_regulator_probe(struct platform_device *pdev)
 {
 	struct regulator_dev *rdev;
 	struct pcf50633 *pcf;
+	struct regulator_config config = { };
 
 	/* Already set by core driver */
 	pcf = dev_to_pcf50633(pdev->dev.parent);
 
-	rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
-				  pdev->dev.platform_data, pcf, NULL);
+	config.dev = &pdev->dev;
+	config.init_data = pdev->dev.platform_data;
+	config.driver_data = pcf;
+
+	rdev = regulator_register(&regulators[pdev->id], &config);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index 37732f7..e055134 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -261,6 +261,7 @@ static int __devinit rc5t583_regulator_probe(struct platform_device *pdev)
 	struct rc5t583 *rc5t583 = dev_get_drvdata(pdev->dev.parent);
 	struct rc5t583_platform_data *pdata = dev_get_platdata(rc5t583->dev);
 	struct regulator_init_data *reg_data;
+	struct regulator_config config = { };
 	struct rc5t583_regulator *reg = NULL;
 	struct rc5t583_regulator *regs;
 	struct regulator_dev *rdev;
@@ -310,8 +311,12 @@ static int __devinit rc5t583_regulator_probe(struct platform_device *pdev)
 				"Failed to configure ext control %d\n", id);
 
 skip_ext_pwr_config:
-		rdev = regulator_register(&ri->desc, &pdev->dev,
-					reg_data, reg, NULL);
+
+		config.dev = &pdev->dev;
+		config.init_data = reg_data;
+		config.driver_data = reg;
+
+		rdev = regulator_register(&ri->desc, &config);
 		if (IS_ERR_OR_NULL(rdev)) {
 			dev_err(&pdev->dev, "Failed to register regulator %s\n",
 						ri->desc.name);
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index c1685ae..c4a584c 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -579,6 +579,7 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 {
 	struct s5m87xx_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct s5m_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct regulator_config config = { };
 	struct regulator_dev **rdev;
 	struct s5m8767_info *s5m8767;
 	int i, ret, size;
@@ -774,8 +775,11 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 			regulators[id].n_voltages =
 				(desc->max - desc->min) / desc->step + 1;
 
-		rdev[i] = regulator_register(&regulators[id], s5m8767->dev,
-				pdata->regulators[i].initdata, s5m8767, NULL);
+		config.dev = s5m8767->dev;
+		config.init_data = pdata->regulators[i].initdata;
+		config.driver_data = s5m8767;
+
+		rdev[i] = regulator_register(&regulators[id], &config);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
 			dev_err(s5m8767->dev, "regulator init failed for %d\n",
diff --git a/drivers/regulator/tps6105x-regulator.c b/drivers/regulator/tps6105x-regulator.c
index d9278da..c8aee2d 100644
--- a/drivers/regulator/tps6105x-regulator.c
+++ b/drivers/regulator/tps6105x-regulator.c
@@ -139,6 +139,7 @@ static int __devinit tps6105x_regulator_probe(struct platform_device *pdev)
 {
 	struct tps6105x *tps6105x = dev_get_platdata(&pdev->dev);
 	struct tps6105x_platform_data *pdata = tps6105x->pdata;
+	struct regulator_config config = { };
 	int ret;
 
 	/* This instance is not set for regulator mode so bail out */
@@ -148,11 +149,13 @@ static int __devinit tps6105x_regulator_probe(struct platform_device *pdev)
 		return 0;
 	}
 
+	config.dev = &tps6105x->client->dev;
+	config.init_data = pdata->regulator_data;
+	config.driver_data = tps6105x;
+
 	/* Register regulator with framework */
 	tps6105x->regulator = regulator_register(&tps6105x_regulator_desc,
-					     &tps6105x->client->dev,
-					     pdata->regulator_data, tps6105x,
-					     NULL);
+						 &config);
 	if (IS_ERR(tps6105x->regulator)) {
 		ret = PTR_ERR(tps6105x->regulator);
 		dev_err(&tps6105x->client->dev,
diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index aa57632..8fffc6e 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -270,6 +270,7 @@ static const struct regmap_config tps62360_regmap_config = {
 static int __devinit tps62360_probe(struct i2c_client *client,
 				     const struct i2c_device_id *id)
 {
+	struct regulator_config config = { };
 	struct tps62360_regulator_platform_data *pdata;
 	struct regulator_dev *rdev;
 	struct tps62360_chip *tps;
@@ -384,9 +385,12 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 		goto err_init;
 	}
 
+	config.dev = &client->dev;
+	config.init_data = &pdata->reg_init_data;
+	config.driver_data = tps;
+
 	/* Register the regulators */
-	rdev = regulator_register(&tps->desc, &client->dev,
-				&pdata->reg_init_data, tps, NULL);
+	rdev = regulator_register(&tps->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(tps->dev, "%s() Err: Failed to register %s\n",
 				__func__, id->name);
diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 5c9a900..7755afe 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -376,6 +376,7 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 {
 	const struct tps_driver_data *drv_data = (void *)id->driver_data;
 	const struct tps_info *info = drv_data->info;
+	struct regulator_config config = { };
 	struct regulator_init_data *init_data;
 	struct regulator_dev *rdev;
 	struct tps_pmic *tps;
@@ -420,9 +421,12 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 		tps->desc[i].type = REGULATOR_VOLTAGE;
 		tps->desc[i].owner = THIS_MODULE;
 
+		config.dev = &client->dev;
+		config.init_data = init_data;
+		config.driver_data = tps;
+
 		/* Register the regulators */
-		rdev = regulator_register(&tps->desc[i], &client->dev,
-					  init_data, tps, NULL);
+		rdev = regulator_register(&tps->desc[i], &config);
 		if (IS_ERR(rdev)) {
 			dev_err(&client->dev, "failed to register %s\n",
 				id->name);
diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 832833f..16d27fc 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -404,6 +404,7 @@ static __devinit int tps6507x_pmic_probe(struct platform_device *pdev)
 {
 	struct tps6507x_dev *tps6507x_dev = dev_get_drvdata(pdev->dev.parent);
 	struct tps_info *info = &tps6507x_pmic_regs[0];
+	struct regulator_config config = { };
 	struct regulator_init_data *init_data;
 	struct regulator_dev *rdev;
 	struct tps6507x_pmic *tps;
@@ -453,8 +454,11 @@ static __devinit int tps6507x_pmic_probe(struct platform_device *pdev)
 		tps->desc[i].type = REGULATOR_VOLTAGE;
 		tps->desc[i].owner = THIS_MODULE;
 
-		rdev = regulator_register(&tps->desc[i],
-					tps6507x_dev->dev, init_data, tps, NULL);
+		config.dev = tps6507x_dev->dev;
+		config.init_data = init_data;
+		config.driver_data = tps;
+
+		rdev = regulator_register(&tps->desc[i], &config);
 		if (IS_ERR(rdev)) {
 			dev_err(tps6507x_dev->dev,
 				"failed to register %s regulator\n",
diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 7baff2e..6bbf760 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -137,6 +137,7 @@ static inline struct tps65090_regulator *find_regulator_info(int id)
 static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
 {
 	struct tps65090_regulator *ri = NULL;
+	struct regulator_config config = { };
 	struct regulator_dev *rdev;
 	struct tps65090_regulator_platform_data *tps_pdata;
 	int id = pdev->id;
@@ -151,8 +152,11 @@ static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
 	tps_pdata = pdev->dev.platform_data;
 	ri->dev = &pdev->dev;
 
-	rdev = regulator_register(&ri->desc, &pdev->dev,
-				&tps_pdata->regulator, ri, NULL);
+	config.dev = &pdev->dev;
+	config.init_data = &tps_pdata->regulator;
+	config.driver_data = ri;
+
+	rdev = regulator_register(&ri->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc.name);
diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index e39521b..d8b5fff 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -327,13 +327,17 @@ static int __devinit tps65217_regulator_probe(struct platform_device *pdev)
 	struct regulator_dev *rdev;
 	struct tps65217 *tps;
 	struct tps_info *info = &tps65217_pmic_regs[pdev->id];
+	struct regulator_config config = { };
 
 	/* Already set by core driver */
 	tps = dev_to_tps65217(pdev->dev.parent);
 	tps->info[pdev->id] = info;
 
-	rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
-				  pdev->dev.platform_data, tps, NULL);
+	config.dev = &pdev->dev;
+	config.init_data = pdev->dev.platform_data;
+	config.driver_data = tps;
+
+	rdev = regulator_register(&regulators[pdev->id], &config);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index eabf0e6..6616af7 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -605,6 +605,7 @@ static int __devinit pmic_probe(struct spi_device *spi)
 	struct device *dev = &spi->dev;
 	const struct supply_info *info = supply_info;
 	struct regulator_init_data *init_data;
+	struct regulator_config config = { };
 	int ret = 0, i;
 
 	init_data = dev->platform_data;
@@ -636,8 +637,11 @@ static int __devinit pmic_probe(struct spi_device *spi)
 		if (info->flags & FIXED_VOLTAGE)
 			hw->desc[i].n_voltages = 1;
 
-		hw->rdev[i] = regulator_register(&hw->desc[i], dev,
-						 init_data, hw, NULL);
+		config.dev = dev;
+		config.init_data = init_data;
+		config.driver_data = hw;
+
+		hw->rdev[i] = regulator_register(&hw->desc[i], &config);
 		if (IS_ERR(hw->rdev[i])) {
 			ret = PTR_ERR(hw->rdev[i]);
 			hw->rdev[i] = NULL;
diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index bb05744..9a4029a 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -345,6 +345,7 @@ static inline struct tps6586x_regulator *find_regulator_info(int id)
 static int __devinit tps6586x_regulator_probe(struct platform_device *pdev)
 {
 	struct tps6586x_regulator *ri = NULL;
+	struct regulator_config config = { };
 	struct regulator_dev *rdev;
 	int id = pdev->id;
 	int err;
@@ -361,8 +362,11 @@ static int __devinit tps6586x_regulator_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	rdev = regulator_register(&ri->desc, &pdev->dev,
-				  pdev->dev.platform_data, ri, NULL);
+	config.dev = &pdev->dev;
+	config.init_data = pdev->dev.platform_data;
+	config.driver_data = ri;
+
+	rdev = regulator_register(&ri->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc.name);
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 4a37c2b6..e7a4ece 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1097,6 +1097,7 @@ static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
 static __devinit int tps65910_probe(struct platform_device *pdev)
 {
 	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
+	struct regulator_config config = { };
 	struct tps_info *info;
 	struct regulator_init_data *reg_data;
 	struct regulator_dev *rdev;
@@ -1206,8 +1207,11 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		pmic->desc[i].type = REGULATOR_VOLTAGE;
 		pmic->desc[i].owner = THIS_MODULE;
 
-		rdev = regulator_register(&pmic->desc[i],
-				tps65910->dev, reg_data, pmic, NULL);
+		config.dev = tps65910->dev;
+		config.init_data = reg_data;
+		config.driver_data = pmic;
+
+		rdev = regulator_register(&pmic->desc[i], &config);
 		if (IS_ERR(rdev)) {
 			dev_err(tps65910->dev,
 				"failed to register %s regulator\n",
diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index 05ea096..8c9c613 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -463,6 +463,7 @@ static struct regulator_ops tps65912_ops_ldo = {
 static __devinit int tps65912_probe(struct platform_device *pdev)
 {
 	struct tps65912 *tps65912 = dev_get_drvdata(pdev->dev.parent);
+	struct regulator_config config = { };
 	struct tps_info *info;
 	struct regulator_init_data *reg_data;
 	struct regulator_dev *rdev;
@@ -500,8 +501,12 @@ static __devinit int tps65912_probe(struct platform_device *pdev)
 		pmic->desc[i].type = REGULATOR_VOLTAGE;
 		pmic->desc[i].owner = THIS_MODULE;
 		range = tps65912_get_range(pmic, i);
-		rdev = regulator_register(&pmic->desc[i],
-					tps65912->dev, reg_data, pmic, NULL);
+
+		config.dev = tps65912->dev;
+		config.init_data = reg_data;
+		config.driver_data = pmic;
+
+		rdev = regulator_register(&pmic->desc[i], &config);
 		if (IS_ERR(rdev)) {
 			dev_err(tps65912->dev,
 				"failed to register %s regulator\n",
diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 9cdfc38..cead7a7 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1194,6 +1194,7 @@ static int __devinit twlreg_probe(struct platform_device *pdev)
 	struct regulator_dev		*rdev;
 	struct twl_regulator_driver_data	*drvdata;
 	const struct of_device_id	*match;
+	struct regulator_config		config = { };
 
 	match = of_match_device(twl_of_match, &pdev->dev);
 	if (match) {
@@ -1273,8 +1274,12 @@ static int __devinit twlreg_probe(struct platform_device *pdev)
 		break;
 	}
 
-	rdev = regulator_register(&info->desc, &pdev->dev, initdata, info,
-							pdev->dev.of_node);
+	config.dev = &pdev->dev;
+	config.init_data = initdata;
+	config.driver_data = info;
+	config.of_node = pdev->dev.of_node;
+
+	rdev = regulator_register(&info->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "can't register %s, %ld\n",
 				info->desc.name, PTR_ERR(rdev));
diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 7df7229..c964863 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -499,6 +499,7 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct regulator_config config = { };
 	int id;
 	struct wm831x_dcdc *dcdc;
 	struct resource *res;
@@ -562,8 +563,11 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 	if (pdata->dcdc[id])
 		wm831x_buckv_dvs_init(dcdc, pdata->dcdc[id]->driver_data);
 
-	dcdc->regulator = regulator_register(&dcdc->desc, pdev->dev.parent,
-					     pdata->dcdc[id], dcdc, NULL);
+	config.dev = pdev->dev.parent;
+	config.init_data = pdata->dcdc[id];
+	config.driver_data = dcdc;
+
+	dcdc->regulator = regulator_register(&dcdc->desc, &config);
 	if (IS_ERR(dcdc->regulator)) {
 		ret = PTR_ERR(dcdc->regulator);
 		dev_err(wm831x->dev, "Failed to register DCDC%d: %d\n",
@@ -714,6 +718,7 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct regulator_config config = { };
 	int id;
 	struct wm831x_dcdc *dcdc;
 	struct resource *res;
@@ -760,8 +765,11 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 	dcdc->desc.ops = &wm831x_buckp_ops;
 	dcdc->desc.owner = THIS_MODULE;
 
-	dcdc->regulator = regulator_register(&dcdc->desc, pdev->dev.parent,
-					     pdata->dcdc[id], dcdc, NULL);
+	config.dev = pdev->dev.parent;
+	config.init_data = pdata->dcdc[id];
+	config.driver_data = dcdc;
+
+	dcdc->regulator = regulator_register(&dcdc->desc, &config);
 	if (IS_ERR(dcdc->regulator)) {
 		ret = PTR_ERR(dcdc->regulator);
 		dev_err(wm831x->dev, "Failed to register DCDC%d: %d\n",
@@ -852,6 +860,7 @@ static __devinit int wm831x_boostp_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct regulator_config config = { };
 	int id = pdev->id % ARRAY_SIZE(pdata->dcdc);
 	struct wm831x_dcdc *dcdc;
 	struct resource *res;
@@ -885,8 +894,11 @@ static __devinit int wm831x_boostp_probe(struct platform_device *pdev)
 	dcdc->desc.ops = &wm831x_boostp_ops;
 	dcdc->desc.owner = THIS_MODULE;
 
-	dcdc->regulator = regulator_register(&dcdc->desc, pdev->dev.parent,
-					     pdata->dcdc[id], dcdc, NULL);
+	config.dev = pdev->dev.parent;
+	config.init_data = pdata->dcdc[id];
+	config.driver_data = dcdc;
+
+	dcdc->regulator = regulator_register(&dcdc->desc, &config);
 	if (IS_ERR(dcdc->regulator)) {
 		ret = PTR_ERR(dcdc->regulator);
 		dev_err(wm831x->dev, "Failed to register DCDC%d: %d\n",
@@ -955,6 +967,7 @@ static __devinit int wm831x_epe_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct regulator_config config = { };
 	int id = pdev->id % ARRAY_SIZE(pdata->epe);
 	struct wm831x_dcdc *dcdc;
 	int ret;
@@ -982,8 +995,11 @@ static __devinit int wm831x_epe_probe(struct platform_device *pdev)
 	dcdc->desc.type = REGULATOR_VOLTAGE;
 	dcdc->desc.owner = THIS_MODULE;
 
-	dcdc->regulator = regulator_register(&dcdc->desc, pdev->dev.parent,
-					     pdata->epe[id], dcdc, NULL);
+	config.dev = pdev->dev.parent;
+	config.init_data = pdata->epe[id];
+	config.driver_data = dcdc;
+
+	dcdc->regulator = regulator_register(&dcdc->desc, &config);
 	if (IS_ERR(dcdc->regulator)) {
 		ret = PTR_ERR(dcdc->regulator);
 		dev_err(wm831x->dev, "Failed to register EPE%d: %d\n",
diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index b414e09..b50ab77 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -154,6 +154,7 @@ static __devinit int wm831x_isink_probe(struct platform_device *pdev)
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
 	struct wm831x_isink *isink;
 	int id = pdev->id % ARRAY_SIZE(pdata->isink);
+	struct regulator_config config = { };
 	struct resource *res;
 	int ret, irq;
 
@@ -189,8 +190,11 @@ static __devinit int wm831x_isink_probe(struct platform_device *pdev)
 	isink->desc.type = REGULATOR_CURRENT;
 	isink->desc.owner = THIS_MODULE;
 
-	isink->regulator = regulator_register(&isink->desc, &pdev->dev,
-					     pdata->isink[id], isink, NULL);
+	config.dev = pdev->dev.parent;
+	config.init_data = pdata->isink[id];
+	config.driver_data = isink;
+
+	isink->regulator = regulator_register(&isink->desc, &config);
 	if (IS_ERR(isink->regulator)) {
 		ret = PTR_ERR(isink->regulator);
 		dev_err(wm831x->dev, "Failed to register ISINK%d: %d\n",
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index b8cb666..344beb8 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -311,6 +311,7 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct regulator_config config = { };
 	int id;
 	struct wm831x_ldo *ldo;
 	struct resource *res;
@@ -356,8 +357,11 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 	ldo->desc.ops = &wm831x_gp_ldo_ops;
 	ldo->desc.owner = THIS_MODULE;
 
-	ldo->regulator = regulator_register(&ldo->desc, pdev->dev.parent,
-					     pdata->ldo[id], ldo, NULL);
+	config.dev = pdev->dev.parent;
+	config.init_data = pdata->ldo[id];
+	config.driver_data = ldo;
+
+	ldo->regulator = regulator_register(&ldo->desc, &config);
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
 		dev_err(wm831x->dev, "Failed to register LDO%d: %d\n",
@@ -581,6 +585,7 @@ static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct regulator_config config = { };
 	int id;
 	struct wm831x_ldo *ldo;
 	struct resource *res;
@@ -626,8 +631,11 @@ static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
 	ldo->desc.ops = &wm831x_aldo_ops;
 	ldo->desc.owner = THIS_MODULE;
 
-	ldo->regulator = regulator_register(&ldo->desc, pdev->dev.parent,
-					     pdata->ldo[id], ldo, NULL);
+	config.dev = pdev->dev.parent;
+	config.init_data = pdata->ldo[id];
+	config.driver_data = ldo;
+
+	ldo->regulator = regulator_register(&ldo->desc, &config);
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
 		dev_err(wm831x->dev, "Failed to register LDO%d: %d\n",
@@ -780,6 +788,7 @@ static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct regulator_config config = { };
 	int id;
 	struct wm831x_ldo *ldo;
 	struct resource *res;
@@ -826,8 +835,11 @@ static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
 	ldo->desc.ops = &wm831x_alive_ldo_ops;
 	ldo->desc.owner = THIS_MODULE;
 
-	ldo->regulator = regulator_register(&ldo->desc, pdev->dev.parent,
-					     pdata->ldo[id], ldo, NULL);
+	config.dev = pdev->dev.parent;
+	config.init_data = pdata->ldo[id];
+	config.driver_data = ldo;
+
+	ldo->regulator = regulator_register(&ldo->desc, &config);
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
 		dev_err(wm831x->dev, "Failed to register LDO%d: %d\n",
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index dda351c..94e550d 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1398,6 +1398,7 @@ static irqreturn_t pmic_uv_handler(int irq, void *data)
 static int wm8350_regulator_probe(struct platform_device *pdev)
 {
 	struct wm8350 *wm8350 = dev_get_drvdata(&pdev->dev);
+	struct regulator_config config = { };
 	struct regulator_dev *rdev;
 	int ret;
 	u16 val;
@@ -1425,10 +1426,12 @@ static int wm8350_regulator_probe(struct platform_device *pdev)
 		break;
 	}
 
+	config.dev = &pdev->dev;
+	config.init_data = pdev->dev.platform_data;
+	config.driver_data = dev_get_drvdata(&pdev->dev);
+
 	/* register regulator */
-	rdev = regulator_register(&wm8350_reg[pdev->id], &pdev->dev,
-				  pdev->dev.platform_data,
-				  dev_get_drvdata(&pdev->dev), NULL);
+	rdev = regulator_register(&wm8350_reg[pdev->id], &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register %s\n",
 			wm8350_reg[pdev->id].name);
diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 8477153..4408b78 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -323,11 +323,14 @@ static struct regulator_desc regulators[] = {
 static int __devinit wm8400_regulator_probe(struct platform_device *pdev)
 {
 	struct wm8400 *wm8400 = container_of(pdev, struct wm8400, regulators[pdev->id]);
+	struct regulator_config config = { };
 	struct regulator_dev *rdev;
 
-	rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
-				  pdev->dev.platform_data, wm8400, NULL);
+	config.dev = &pdev->dev;
+	config.init_data = pdev->dev.platform_data;
+	config.driver_data = wm8400;
 
+	rdev = regulator_register(&regulators[pdev->id], &config);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 8a4897a..f4a6294 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -233,6 +233,7 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 	struct wm8994 *wm8994 = dev_get_drvdata(pdev->dev.parent);
 	struct wm8994_pdata *pdata = wm8994->dev->platform_data;
 	int id = pdev->id % ARRAY_SIZE(pdata->ldo);
+	struct regulator_config config = { };
 	struct wm8994_ldo *ldo;
 	int ret;
 
@@ -268,8 +269,11 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 	} else
 		ldo->is_enabled = true;
 
-	ldo->regulator = regulator_register(&wm8994_ldo_desc[id], &pdev->dev,
-					     pdata->ldo[id].init_data, ldo, NULL);
+	config.dev = &pdev->dev;
+	config.init_data = pdata->ldo[id].init_data;
+	config.driver_data = ldo;
+
+	ldo->regulator = regulator_register(&wm8994_ldo_desc[id], &config);
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
 		dev_err(wm8994->dev, "Failed to register LDO%d: %d\n",
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 1dcdf00..4f529ed 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -148,10 +148,12 @@ enum regulator_type {
 };
 
 /**
- * struct regulator_desc - Regulator descriptor
+ * struct regulator_desc - Static regulator descriptor
  *
- * Each regulator registered with the core is described with a structure of
- * this type.
+ * Each regulator registered with the core is described with a
+ * structure of this type and a struct regulator_config.  This
+ * structure contains the non-varying parts of the regulator
+ * description.
  *
  * @name: Identifying name for the regulator.
  * @supply_name: Identifying the regulator supply
@@ -173,6 +175,26 @@ struct regulator_desc {
 	struct module *owner;
 };
 
+/**
+ * struct regulator_config - Dynamic regulator descriptor
+ *
+ * Each regulator registered with the core is described with a
+ * structure of this type and a struct regulator_desc.  This structure
+ * contains the runtime variable parts of the regulator description.
+ *
+ * @dev: struct device for the regulator
+ * @init_data: platform provided init data, passed through by driver
+ * @driver_data: private regulator data
+ * @of_node: OpenFirmware node to parse for device tree bindings (may be
+ *           NULL).
+ */
+struct regulator_config {
+	struct device *dev;
+	const struct regulator_init_data *init_data;
+	void *driver_data;
+	struct device_node *of_node;
+};
+
 /*
  * struct regulator_dev
  *
@@ -212,8 +234,7 @@ struct regulator_dev {
 
 struct regulator_dev *
 regulator_register(const struct regulator_desc *regulator_desc,
-	struct device *dev, const struct regulator_init_data *init_data,
-	void *driver_data, struct device_node *of_node);
+		   const struct regulator_config *config);
 void regulator_unregister(struct regulator_dev *rdev);
 
 int regulator_notifier_call_chain(struct regulator_dev *rdev,
diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 8005fe6..8af6a524 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -808,6 +808,7 @@ static int ldo_regulator_register(struct snd_soc_codec *codec,
 {
 	struct ldo_regulator *ldo;
 	struct sgtl5000_priv *sgtl5000 = snd_soc_codec_get_drvdata(codec);
+	struct regulator_config config = { };
 
 	ldo = kzalloc(sizeof(struct ldo_regulator), GFP_KERNEL);
 
@@ -831,8 +832,11 @@ static int ldo_regulator_register(struct snd_soc_codec *codec,
 	ldo->codec_data = codec;
 	ldo->voltage = voltage;
 
-	ldo->dev = regulator_register(&ldo->desc, codec->dev,
-					  init_data, ldo, NULL);
+	config.dev = codec->dev;
+	config.driver_data = ldo;
+	config.init_data = init_data;
+
+	ldo->dev = regulator_register(&ldo->desc, &config);
 	if (IS_ERR(ldo->dev)) {
 		int ret = PTR_ERR(ldo->dev);
 
-- 
1.7.9.1

