Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab2DRBEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 21:04:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13453 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2DRBEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 21:04:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 17 Apr 2012 18:04:09 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 3/4] mfd: tps65910: Add device-tree support
Date: Tue, 17 Apr 2012 18:00:28 -0700
Message-ID: <1334710829-22777-4-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1334710829-22777-1-git-send-email-rklein@nvidia.com>
References: <1334710829-22777-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree based initialization support for TI's tps65910 pmic.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/gpio/gpio-tps65910.c           |   39 ++++++++++++++-
 drivers/mfd/tps65910-irq.c             |   21 ++++++--
 drivers/mfd/tps65910.c                 |   78 +++++++++++++++++++++++++++++-
 drivers/regulator/tps65910-regulator.c |   84 +++++++++++++++++++++++++++++++-
 include/linux/mfd/tps65910.h           |    3 +-
 5 files changed, 214 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-tps65910.c b/drivers/gpio/gpio-tps65910.c
index 7eef648..079aff1 100644
--- a/drivers/gpio/gpio-tps65910.c
+++ b/drivers/gpio/gpio-tps65910.c
@@ -66,9 +66,38 @@ static int tps65910_gpio_input(struct gpio_chip *gc, unsigned offset)
 						GPIO_CFG_MASK);
 }
 
+#ifdef CONFIG_OF
+static int tps65910_gpio_parse_dt(struct device *dev,
+					struct tps65910_board *board)
+{
+	struct device_node *np = dev->of_node;
+	unsigned int prop_array[TPS6591X_MAX_NUM_GPIO];
+	int idx = 0, ret;
+
+	ret = of_property_read_u32_array(np, "ti,en-gpio-sleep",
+				   prop_array, TPS6591X_MAX_NUM_GPIO);
+	if (!ret)
+		for (idx = 0; idx < ARRAY_SIZE(prop_array); idx++)
+			board->en_gpio_sleep[idx] = (prop_array[idx] != 0);
+	else if (ret != -EINVAL) {
+		dev_err(dev,
+			"error reading property ti,en-gpio-sleep: %d\n.", ret);
+		return ret;
+	}
+
+	return 0;
+}
+#else
+static int tps65910_gpio_parse_dt(struct device *dev,
+					struct tps65910_board *board)
+{
+	return 0;
+}
+#endif
+
 void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base)
 {
-	int ret;
+	int ret = 0;
 	struct tps65910_board *board_data;
 
 	if (!gpio_base)
@@ -97,7 +126,13 @@ void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base)
 	tps65910->gpio.get		= tps65910_gpio_get;
 
 	/* Configure sleep control for gpios */
-	board_data = dev_get_platdata(tps65910->dev);
+	board_data = tps65910->board_data;
+	if (board_data->use_dt_for_init_data && tps65910->dev->of_node)
+		ret = tps65910_gpio_parse_dt(tps65910->dev, board_data);
+
+	if (ret)
+		return;
+
 	if (board_data) {
 		int i;
 		for (i = 0; i < tps65910->gpio.ngpio; ++i) {
diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
index c9ed5c0..5bec078 100644
--- a/drivers/mfd/tps65910-irq.c
+++ b/drivers/mfd/tps65910-irq.c
@@ -180,12 +180,6 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 		return -EINVAL;
 	}
 
-	tps65910->irq_mask = 0xFFFFFF;
-
-	mutex_init(&tps65910->irq_lock);
-	tps65910->chip_irq = irq;
-	tps65910->irq_base = pdata->irq_base;
-
 	switch (tps65910_chip_id(tps65910)) {
 	case TPS65910:
 		tps65910->irq_num = TPS65910_NUM_IRQ;
@@ -195,6 +189,21 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 		break;
 	}
 
+	if (pdata->irq_base <= 0)
+		pdata->irq_base = irq_alloc_descs(-1, 0, tps65910->irq_num, -1);
+
+	if (pdata->irq_base <= 0) {
+		dev_err(tps65910->dev, "Failed to allocate irq descs: %d\n",
+			pdata->irq_base);
+		return pdata->irq_base;
+	}
+
+	tps65910->irq_mask = 0xFFFFFF;
+
+	mutex_init(&tps65910->irq_lock);
+	tps65910->chip_irq = irq;
+	tps65910->irq_base = pdata->irq_base;
+
 	/* Register with genirq */
 	for (cur_irq = tps65910->irq_base;
 	     cur_irq < tps65910->irq_num + tps65910->irq_base;
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index bf2b25e..a076715 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -23,6 +23,7 @@
 #include <linux/mfd/core.h>
 #include <linux/regmap.h>
 #include <linux/mfd/tps65910.h>
+#include <linux/of_device.h>
 
 static struct mfd_cell tps65910s[] = {
 	{
@@ -90,6 +91,67 @@ static const struct regmap_config tps65910_regmap_config = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
+#ifdef CONFIG_OF
+static struct of_device_id tps65910_of_match[] = {
+	{ .compatible = "ti,tps65910", .data = (void *)TPS65910},
+	{ .compatible = "ti,tps65911", .data = (void *)TPS65911},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tps65910_of_match);
+
+static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
+						int *chip_id)
+{
+	struct device_node *np = client->dev.of_node;
+	struct tps65910_board *pmic_plat_data;
+	unsigned int prop;
+	const struct of_device_id *match;
+	int ret = 0;
+
+	match = of_match_device(tps65910_of_match, &client->dev);
+	if (!match) {
+		dev_err(&client->dev, "Failed to find matching dt id\n");
+		return NULL;
+	}
+
+	*chip_id  = (int)match->data;
+
+	pmic_plat_data = devm_kzalloc(&client->dev, sizeof(*pmic_plat_data),
+			GFP_KERNEL);
+	if (!pmic_plat_data) {
+		dev_err(&client->dev, "Failed to allocate pdata\n");
+		return NULL;
+	}
+
+	ret = of_property_read_u32(np, "ti,vmbch-threshold", &prop);
+	if (!ret)
+		pmic_plat_data->vmbch_threshold = prop;
+	else if (*chip_id == TPS65911)
+		dev_warn(&client->dev, "VMBCH-Threshold not specified");
+
+	ret = of_property_read_u32(np, "ti,vmbch2-threshold", &prop);
+	if (!ret)
+		pmic_plat_data->vmbch2_threshold = prop;
+	else if (*chip_id == TPS65911)
+		dev_warn(&client->dev, "VMBCH2-Threshold not specified");
+
+	pmic_plat_data->use_dt_for_init_data = true;
+
+	pmic_plat_data->irq = client->irq;
+	pmic_plat_data->irq_base = -1;
+
+	pmic_plat_data->gpio_base = -1;
+
+	return pmic_plat_data;
+}
+#else
+static inline struct tps65910_board *tps65910_parse_dt(
+					struct i2c_client *client)
+{
+	return NULL;
+}
+#endif
+
 static int tps65910_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
@@ -97,11 +159,23 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	struct tps65910_board *pmic_plat_data;
 	struct tps65910_platform_data *init_data;
 	int ret = 0;
+	int chip_id = id->driver_data;
+	int idx;
 
 	pmic_plat_data = dev_get_platdata(&i2c->dev);
+
+	if (!pmic_plat_data && i2c->dev.of_node)
+		pmic_plat_data = tps65910_parse_dt(i2c, &chip_id);
+
 	if (!pmic_plat_data)
 		return -EINVAL;
 
+	/* Pass of data to child devices */
+	for (idx = 0; idx < ARRAY_SIZE(tps65910s); idx++) {
+		tps65910s[idx].platform_data = pmic_plat_data;
+		tps65910s[idx].pdata_size = sizeof(*pmic_plat_data);
+	}
+
 	init_data = kzalloc(sizeof(struct tps65910_platform_data), GFP_KERNEL);
 	if (init_data == NULL)
 		return -ENOMEM;
@@ -115,7 +189,8 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	i2c_set_clientdata(i2c, tps65910);
 	tps65910->dev = &i2c->dev;
 	tps65910->i2c_client = i2c;
-	tps65910->id = id->driver_data;
+	tps65910->board_data = pmic_plat_data;
+	tps65910->id = chip_id;
 	tps65910->read = tps65910_i2c_read;
 	tps65910->write = tps65910_i2c_write;
 	mutex_init(&tps65910->io_mutex);
@@ -175,6 +250,7 @@ static struct i2c_driver tps65910_i2c_driver = {
 	.driver = {
 		   .name = "tps65910",
 		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(tps65910_of_match),
 	},
 	.probe = tps65910_i2c_probe,
 	.remove = tps65910_i2c_remove,
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 9fd0fe1..121f202 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/gpio.h>
 #include <linux/mfd/tps65910.h>
+#include <linux/regulator/of_regulator.h>
 
 #define TPS65910_SUPPLY_STATE_ENABLED	0x1
 #define EXT_SLEEP_CONTROL (TPS65910_SLEEP_CONTROL_EXT_INPUT_EN1 |	\
@@ -1094,6 +1095,79 @@ static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
 	return ret;
 }
 
+#ifdef CONFIG_OF
+static int tps65910_parse_dt_reg_data(struct platform_device *pdev,
+		struct tps65910_board *pmic_plat_data, struct tps_info *info)
+{
+	struct device_node *np = pdev->dev.parent->of_node;
+	struct tps65910_reg *pmic = dev_get_drvdata(&pdev->dev);
+	struct device_node *regulators;
+	struct device_node *child;
+	unsigned int prop_array[TPS65910_NUM_REGS];
+	struct regulator_init_data **all_data;
+	int idx = 0, ret;
+
+	all_data = pmic_plat_data->tps65910_pmic_init_data;
+
+	regulators = of_find_node_by_name(np, "regulators");
+
+	for_each_child_of_node(regulators, child) {
+		struct regulator_init_data *init_data;
+
+		init_data = of_get_regulator_init_data(&pdev->dev, child);
+		if (!init_data) {
+			dev_err(&pdev->dev,
+				"failed to parse DT for regulator %s\n",
+				child->name);
+			return -EINVAL;
+		}
+
+		for (idx = 0; idx < pmic->num_regulators; idx++) {
+			if (!strcasecmp(info[idx].name, child->name)) {
+				if (all_data[idx]) {
+					dev_err(&pdev->dev,
+						"Duplicate Regulator Node %s\n",
+						child->name);
+					return -EINVAL;
+				}
+				all_data[idx] = init_data;
+				break;
+			}
+		}
+
+		/* Check to see if we iterated without finding its name */
+		if (idx == pmic->num_regulators) {
+			dev_err(&pdev->dev,
+				"Unknown regulator node found [%s]\n",
+				child->name);
+			return -EINVAL;
+		}
+	}
+
+	ret = of_property_read_u32_array(np, "ti,regulator-ext-sleep-control",
+					 prop_array, TPS65910_NUM_REGS);
+
+	if (!ret)
+		for (idx = 0; idx < ARRAY_SIZE(prop_array); idx++)
+			pmic_plat_data->regulator_ext_sleep_control[idx] =
+				prop_array[idx];
+	else if (ret != -EINVAL) {
+		dev_err(&pdev->dev,
+			"error reading ti,regulator-ext-sleep-control: %d\n",
+			ret);
+		return ret;
+	}
+
+	return 0;
+}
+#else
+static inline int tps65910_parse_dt_reg_data(struct platform_device *pdev,
+		struct tps65910_board *pmic_plat_data, struct tps_info *info)
+{
+	return 0;
+}
+#endif
+
 static __devinit int tps65910_probe(struct platform_device *pdev)
 {
 	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
@@ -1105,7 +1179,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	struct tps65910_board *pmic_plat_data;
 	int i, err;
 
-	pmic_plat_data = dev_get_platdata(tps65910->dev);
+	pmic_plat_data = dev_get_platdata(&pdev->dev);
 	if (!pmic_plat_data)
 		return -EINVAL;
 
@@ -1139,6 +1213,14 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	if (pmic_plat_data->use_dt_for_init_data) {
+		err = tps65910_parse_dt_reg_data(pdev, pmic_plat_data, info);
+		if (err) {
+			dev_err(&pdev->dev, "Error Parsing DT Information");
+			goto err_out;
+		}
+	}
+
 	pmic->desc = kcalloc(pmic->num_regulators,
 			sizeof(struct regulator_desc), GFP_KERNEL);
 	if (!pmic->desc) {
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 1c6c286..32b320a 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -787,13 +787,13 @@
  * struct tps65910_board
  * Board platform data may be used to initialize regulators.
  */
-
 struct tps65910_board {
 	int gpio_base;
 	int irq;
 	int irq_base;
 	int vmbch_threshold;
 	int vmbch2_threshold;
+	bool use_dt_for_init_data; /* signal to parse dt for reg init data*/
 	bool en_gpio_sleep[TPS6591X_MAX_NUM_GPIO];
 	unsigned long regulator_ext_sleep_control[TPS65910_NUM_REGS];
 	struct regulator_init_data *tps65910_pmic_init_data[TPS65910_NUM_REGS];
@@ -807,6 +807,7 @@ struct tps65910 {
 	struct device *dev;
 	struct i2c_client *i2c_client;
 	struct regmap *regmap;
+	struct tps65910_board *board_data;
 	struct mutex io_mutex;
 	unsigned int id;
 	int (*read)(struct tps65910 *tps65910, u8 reg, int size, void *dest);
-- 
1.7.0.4

