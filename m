Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab2JROHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:07:03 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14202 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab2JROHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:07:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 18 Oct 2012 07:06:53 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <sameo@linux.intel.com>,
        <lrg@ti.com>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] mfd: tps6586x: move regulator dt parsing to regulator driver
Date: Thu, 18 Oct 2012 19:36:09 +0530
Message-ID: <1350569169-27455-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving regulator node parsing to regulator driver in place
of parsing it on mfd driver.
The motivation for this change are:
- MFD core driver should not depends on regulator and able
  to instantiate device without regulator.
- The API for matching regulators are in regulator core and
  it is good that regulator driver only calls this API.
- Regulator specific support should be in regulator driver only
  to ease any enhancement/modification for regulators.
- The regulator driver is now registered as mfd sub device and
  all regulator registration is done from single probe call.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/Kconfig                    |    1 -
 drivers/mfd/tps6586x.c                 |   76 ++------------
 drivers/regulator/tps6586x-regulator.c |  181 +++++++++++++++++++++++++++-----
 include/linux/mfd/tps6586x.h           |    3 +
 4 files changed, 166 insertions(+), 95 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index acab3ef..05acef8 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -201,7 +201,6 @@ config MFD_TPS6586X
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
-	depends on REGULATOR
 	help
 	  If you say yes here you get support for the TPS6586X series of
 	  Power Management chips.
diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 4674643..9d67bd9 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -24,8 +24,6 @@
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/regmap.h>
-#include <linux/regulator/of_regulator.h>
-#include <linux/regulator/machine.h>
 
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps6586x.h>
@@ -99,6 +97,9 @@ static struct mfd_cell tps6586x_cell[] = {
 		.name = "tps6586x-gpio",
 	},
 	{
+		.name = "tps6586x-pmic",
+	},
+	{
 		.name = "tps6586x-rtc",
 	},
 	{
@@ -350,80 +351,19 @@ failed:
 }
 
 #ifdef CONFIG_OF
-static struct of_regulator_match tps6586x_matches[] = {
-	{ .name = "sys",     .driver_data = (void *)TPS6586X_ID_SYS     },
-	{ .name = "sm0",     .driver_data = (void *)TPS6586X_ID_SM_0    },
-	{ .name = "sm1",     .driver_data = (void *)TPS6586X_ID_SM_1    },
-	{ .name = "sm2",     .driver_data = (void *)TPS6586X_ID_SM_2    },
-	{ .name = "ldo0",    .driver_data = (void *)TPS6586X_ID_LDO_0   },
-	{ .name = "ldo1",    .driver_data = (void *)TPS6586X_ID_LDO_1   },
-	{ .name = "ldo2",    .driver_data = (void *)TPS6586X_ID_LDO_2   },
-	{ .name = "ldo3",    .driver_data = (void *)TPS6586X_ID_LDO_3   },
-	{ .name = "ldo4",    .driver_data = (void *)TPS6586X_ID_LDO_4   },
-	{ .name = "ldo5",    .driver_data = (void *)TPS6586X_ID_LDO_5   },
-	{ .name = "ldo6",    .driver_data = (void *)TPS6586X_ID_LDO_6   },
-	{ .name = "ldo7",    .driver_data = (void *)TPS6586X_ID_LDO_7   },
-	{ .name = "ldo8",    .driver_data = (void *)TPS6586X_ID_LDO_8   },
-	{ .name = "ldo9",    .driver_data = (void *)TPS6586X_ID_LDO_9   },
-	{ .name = "ldo_rtc", .driver_data = (void *)TPS6586X_ID_LDO_RTC },
-};
-
 static struct tps6586x_platform_data *tps6586x_parse_dt(struct i2c_client *client)
 {
-	const unsigned int num = ARRAY_SIZE(tps6586x_matches);
 	struct device_node *np = client->dev.of_node;
 	struct tps6586x_platform_data *pdata;
-	struct tps6586x_subdev_info *devs;
-	struct device_node *regs;
-	const char *sys_rail_name = NULL;
-	unsigned int count;
-	unsigned int i, j;
-	int err;
-
-	regs = of_find_node_by_name(np, "regulators");
-	if (!regs)
-		return NULL;
-
-	err = of_regulator_match(&client->dev, regs, tps6586x_matches, num);
-	if (err < 0) {
-		of_node_put(regs);
-		return NULL;
-	}
-
-	of_node_put(regs);
-	count = err;
-
-	devs = devm_kzalloc(&client->dev, count * sizeof(*devs), GFP_KERNEL);
-	if (!devs)
-		return NULL;
-
-	for (i = 0, j = 0; i < num && j < count; i++) {
-		struct regulator_init_data *reg_idata;
-
-		if (!tps6586x_matches[i].init_data)
-			continue;
-
-		reg_idata  = tps6586x_matches[i].init_data;
-		devs[j].name = "tps6586x-regulator";
-		devs[j].platform_data = tps6586x_matches[i].init_data;
-		devs[j].id = (int)tps6586x_matches[i].driver_data;
-		if (devs[j].id == TPS6586X_ID_SYS)
-			sys_rail_name = reg_idata->constraints.name;
-
-		if ((devs[j].id == TPS6586X_ID_LDO_5) ||
-			(devs[j].id == TPS6586X_ID_LDO_RTC))
-			reg_idata->supply_regulator = sys_rail_name;
-
-		devs[j].of_node = tps6586x_matches[i].of_node;
-		j++;
-	}
 
 	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata)
+	if (!pdata) {
+		dev_err(&client->dev, "Memory allocation failed\n");
 		return NULL;
+	}
 
-	pdata->num_subdevs = count;
-	pdata->subdevs = devs;
+	pdata->num_subdevs = 0;
+	pdata->subdevs = NULL;
 	pdata->gpio_base = -1;
 	pdata->irq_base = -1;
 	pdata->pm_off = of_property_read_bool(np, "ti,system-power-controller");
diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index ce1e7cb..913c903 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -17,10 +17,12 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/mfd/tps6586x.h>
 
 /* supply control and voltage setting  */
@@ -255,10 +257,10 @@ static inline int tps6586x_regulator_preinit(struct device *parent,
 				 1 << ri->enable_bit[1]);
 }
 
-static int tps6586x_regulator_set_slew_rate(struct platform_device *pdev)
+static int tps6586x_regulator_set_slew_rate(struct platform_device *pdev,
+			int id, struct regulator_init_data *p)
 {
 	struct device *parent = pdev->dev.parent;
-	struct regulator_init_data *p = pdev->dev.platform_data;
 	struct tps6586x_settings *setting = p->driver_data;
 	uint8_t reg;
 
@@ -269,7 +271,7 @@ static int tps6586x_regulator_set_slew_rate(struct platform_device *pdev)
 		return 0;
 
 	/* only SM0 and SM1 can have the slew rate settings */
-	switch (pdev->id) {
+	switch (id) {
 	case TPS6586X_ID_SM_0:
 		reg = TPS6586X_SM0SL;
 		break;
@@ -298,54 +300,181 @@ static inline struct tps6586x_regulator *find_regulator_info(int id)
 	return NULL;
 }
 
+#ifdef CONFIG_OF
+static struct of_regulator_match tps6586x_matches[] = {
+	{ .name = "sys",     .driver_data = (void *)TPS6586X_ID_SYS     },
+	{ .name = "sm0",     .driver_data = (void *)TPS6586X_ID_SM_0    },
+	{ .name = "sm1",     .driver_data = (void *)TPS6586X_ID_SM_1    },
+	{ .name = "sm2",     .driver_data = (void *)TPS6586X_ID_SM_2    },
+	{ .name = "ldo0",    .driver_data = (void *)TPS6586X_ID_LDO_0   },
+	{ .name = "ldo1",    .driver_data = (void *)TPS6586X_ID_LDO_1   },
+	{ .name = "ldo2",    .driver_data = (void *)TPS6586X_ID_LDO_2   },
+	{ .name = "ldo3",    .driver_data = (void *)TPS6586X_ID_LDO_3   },
+	{ .name = "ldo4",    .driver_data = (void *)TPS6586X_ID_LDO_4   },
+	{ .name = "ldo5",    .driver_data = (void *)TPS6586X_ID_LDO_5   },
+	{ .name = "ldo6",    .driver_data = (void *)TPS6586X_ID_LDO_6   },
+	{ .name = "ldo7",    .driver_data = (void *)TPS6586X_ID_LDO_7   },
+	{ .name = "ldo8",    .driver_data = (void *)TPS6586X_ID_LDO_8   },
+	{ .name = "ldo9",    .driver_data = (void *)TPS6586X_ID_LDO_9   },
+	{ .name = "ldo_rtc", .driver_data = (void *)TPS6586X_ID_LDO_RTC },
+};
+
+static struct tps6586x_platform_data *tps6586x_parse_regulator_dt(
+		struct platform_device *pdev,
+		struct of_regulator_match **tps6586x_reg_matches)
+{
+	const unsigned int num = ARRAY_SIZE(tps6586x_matches);
+	struct device_node *np = pdev->dev.parent->of_node;
+	struct device_node *regs;
+	const char *sys_rail = NULL;
+	unsigned int i;
+	struct tps6586x_platform_data *pdata;
+	int err;
+
+	regs = of_find_node_by_name(np, "regulators");
+	if (!regs) {
+		dev_err(&pdev->dev, "regulator node not found\n");
+		return NULL;
+	}
+
+	err = of_regulator_match(&pdev->dev, regs, tps6586x_matches, num);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Regulator match failed, e %d\n", err);
+		of_node_put(regs);
+		return NULL;
+	}
+
+	of_node_put(regs);
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(&pdev->dev, "Memory alloction failed\n");
+		return NULL;
+	}
+
+	for (i = 0; i < num; i++) {
+		int id;
+		if (!tps6586x_matches[i].init_data)
+			continue;
+
+		pdata->reg_init_data[i] = tps6586x_matches[i].init_data;
+		id = (int)tps6586x_matches[i].driver_data;
+		if (id == TPS6586X_ID_SYS)
+			sys_rail = pdata->reg_init_data[i]->constraints.name;
+
+		if ((id == TPS6586X_ID_LDO_5) || (id == TPS6586X_ID_LDO_RTC))
+			pdata->reg_init_data[i]->supply_regulator = sys_rail;
+	}
+	*tps6586x_reg_matches = tps6586x_matches;
+	return pdata;
+}
+#else
+static struct tps6586x_platform_data *tps6586x_parse_regulator_dt(
+		struct platform_device *pdev,
+		struct of_regulator_match **tps6586x_reg_matches)
+{
+	*tps6586x_reg_matches = NULL;
+	return NULL;
+}
+#endif
+
 static int __devinit tps6586x_regulator_probe(struct platform_device *pdev)
 {
 	struct tps6586x_regulator *ri = NULL;
 	struct regulator_config config = { };
-	struct regulator_dev *rdev;
-	int id = pdev->id;
+	struct regulator_dev **rdev;
+	struct regulator_init_data *reg_data;
+	struct tps6586x_platform_data *pdata;
+	struct of_regulator_match *tps6586x_reg_matches = NULL;
+	int id;
 	int err;
 
 	dev_dbg(&pdev->dev, "Probing regulator %d\n", id);
 
-	ri = find_regulator_info(id);
-	if (ri == NULL) {
-		dev_err(&pdev->dev, "invalid regulator ID specified\n");
-		return -EINVAL;
-	}
+	pdata = dev_get_platdata(pdev->dev.parent);
+	if ((!pdata) && (pdev->dev.parent->of_node))
+		pdata = tps6586x_parse_regulator_dt(pdev,
+					&tps6586x_reg_matches);
 
-	err = tps6586x_regulator_preinit(pdev->dev.parent, ri);
-	if (err)
-		return err;
+	if (!pdata) {
+		dev_err(&pdev->dev, "Platform data not available, exiting\n");
+		return -ENODEV;
+	}
 
-	config.dev = pdev->dev.parent;
-	config.of_node = pdev->dev.of_node;
-	config.init_data = pdev->dev.platform_data;
-	config.driver_data = ri;
+	rdev = devm_kzalloc(&pdev->dev, TPS6586X_ID_MAX_REGULATOR *
+				sizeof(*rdev), GFP_KERNEL);
+	if (!rdev) {
+		dev_err(&pdev->dev, "Mmemory alloc failed\n");
+		return -ENOMEM;
+	}
 
-	rdev = regulator_register(&ri->desc, &config);
-	if (IS_ERR(rdev)) {
-		dev_err(&pdev->dev, "failed to register regulator %s\n",
-				ri->desc.name);
-		return PTR_ERR(rdev);
+	for (id = 0; id < TPS6586X_ID_MAX_REGULATOR; ++id) {
+		reg_data = pdata->reg_init_data[id];
+
+		ri = find_regulator_info(id);
+		if (!ri) {
+			dev_err(&pdev->dev, "invalid regulator ID specified\n");
+			err = -EINVAL;
+			goto fail;
+		}
+
+		err = tps6586x_regulator_preinit(pdev->dev.parent, ri);
+		if (err) {
+			dev_err(&pdev->dev,
+				"regulator %d preinit failed, e %d\n", id, err);
+			goto fail;
+		}
+
+		config.dev = pdev->dev.parent;
+		config.init_data = reg_data;
+		config.driver_data = ri;
+
+		if (tps6586x_reg_matches)
+			config.of_node = tps6586x_reg_matches[id].of_node;
+
+		rdev[id] = regulator_register(&ri->desc, &config);
+		if (IS_ERR(rdev[id])) {
+			dev_err(&pdev->dev, "failed to register regulator %s\n",
+					ri->desc.name);
+			err = PTR_ERR(rdev[id]);
+			goto fail;
+		}
+
+		if (reg_data) {
+			err = tps6586x_regulator_set_slew_rate(pdev, id,
+					reg_data);
+			if (err < 0) {
+				dev_err(&pdev->dev,
+					"Slew rate config failed, e %d\n", err);
+				regulator_unregister(rdev[id]);
+				goto fail;
+			}
+		}
 	}
 
 	platform_set_drvdata(pdev, rdev);
+	return 0;
 
-	return tps6586x_regulator_set_slew_rate(pdev);
+fail:
+	while (--id >= 0)
+		regulator_unregister(rdev[id]);
+	return err;
 }
 
 static int __devexit tps6586x_regulator_remove(struct platform_device *pdev)
 {
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+	struct regulator_dev **rdev = platform_get_drvdata(pdev);
+	int id = TPS6586X_ID_MAX_REGULATOR;
+
+	while (--id >= 0)
+		regulator_unregister(rdev[id]);
 
-	regulator_unregister(rdev);
 	return 0;
 }
 
 static struct platform_driver tps6586x_regulator_driver = {
 	.driver	= {
-		.name	= "tps6586x-regulator",
+		.name	= "tps6586x-pmic",
 		.owner	= THIS_MODULE,
 	},
 	.probe		= tps6586x_regulator_probe,
diff --git a/include/linux/mfd/tps6586x.h b/include/linux/mfd/tps6586x.h
index 2dd1231..f8da0e1 100644
--- a/include/linux/mfd/tps6586x.h
+++ b/include/linux/mfd/tps6586x.h
@@ -29,6 +29,7 @@ enum {
 	TPS6586X_ID_LDO_8,
 	TPS6586X_ID_LDO_9,
 	TPS6586X_ID_LDO_RTC,
+	TPS6586X_ID_MAX_REGULATOR,
 };
 
 enum {
@@ -79,6 +80,8 @@ struct tps6586x_platform_data {
 	int gpio_base;
 	int irq_base;
 	bool pm_off;
+
+	struct regulator_init_data *reg_init_data[TPS6586X_ID_MAX_REGULATOR];
 };
 
 /*
-- 
1.7.1.1

