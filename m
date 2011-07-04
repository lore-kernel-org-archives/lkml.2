Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab1GDIoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:44:10 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5701 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1GDIoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:44:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 04 Jul 2011 01:44:05 -0700
From: Jin Park <jinyoungp@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Richard Purdie <rpurdie@rpsys.net>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jin Park <jinyoungp@nvidia.com>
Subject: RE: [PATCH 3/3] regulator: aat2870: Add AAT2870 regulator driver
Date: Mon,  4 Jul 2011 17:43:42 +0900
Message-Id: <1309769022-11083-1-git-send-email-jinyoungp@nvidia.com>
X-Mailer: git-send-email 1.7.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

Thanks for your review.

>> +config REGULATOR_AAT2870
>> +	bool "AnalogicTech AAT2870 Regulators"
> 
> Why bool?
There is no specific reason, so I have changed to tristate.

> This should be a set_voltage_sel(), the core will do all the above for
> you and the driver only needs to worry about the register writes.  Note
> also that the first test isn't well formed - so long as we can select a
> voltage between min_uV and max_uV we're fine even if one or both of
> those limits is outside the valid range.

> Again, get_voltage_sel().
I have changed set_voltage() and get_voltage() to set_voltage_sel() and 
get_voltage_sel(), according to your mention.
Please review below codes.

Thanks,
Jin.



Add regulator driver for AnalogicTech AAT2870.

Signed-off-by: Jin Park <jinyoungp@nvidia.com>
---
 drivers/regulator/Kconfig             |    7 +
 drivers/regulator/Makefile            |    1 +
 drivers/regulator/aat2870-regulator.c |  232 +++++++++++++++++++++++++++++++++
 3 files changed, 240 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/aat2870-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index a1dffd9..065892a 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -309,5 +309,12 @@ config REGULATOR_TPS65910
 	help
 	  This driver supports TPS65910 voltage regulator chips.
 
+config REGULATOR_AAT2870
+	tristate "AnalogicTech AAT2870 Regulators"
+	depends on MFD_AAT2870_CORE
+	help
+	  If you have a AnalogicTech AAT2870 say Y to enable the
+	  regulator driver.
+
 endif
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 87ba2fd..040d5aa 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -44,5 +44,6 @@ obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
 obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
+obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
new file mode 100644
index 0000000..cd41045
--- /dev/null
+++ b/drivers/regulator/aat2870-regulator.c
@@ -0,0 +1,232 @@
+/*
+ * linux/drivers/regulator/aat2870-regulator.c
+ *
+ * Copyright (c) 2011, NVIDIA Corporation.
+ * Author: Jin Park <jinyoungp@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/mfd/aat2870.h>
+
+struct aat2870_regulator {
+	struct platform_device *pdev;
+	struct regulator_desc desc;
+
+	const int *voltages; /* uV */
+
+	int min_uV;
+	int max_uV;
+
+	u8 enable_addr;
+	u8 enable_shift;
+	u8 enable_mask;
+
+	u8 voltage_addr;
+	u8 voltage_shift;
+	u8 voltage_mask;
+};
+
+static int aat2870_ldo_list_voltage(struct regulator_dev *rdev,
+				    unsigned selector)
+{
+	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
+
+	return ri->voltages[selector];
+}
+
+static int aat2870_ldo_set_voltage_sel(struct regulator_dev *rdev,
+				       unsigned selector)
+{
+	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
+	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+
+	return aat2870->update(aat2870, ri->voltage_addr, ri->voltage_mask,
+			(selector << ri->voltage_shift) & ri->voltage_mask);
+}
+
+static int aat2870_ldo_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
+	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+	u8 val;
+	int ret;
+
+	ret = aat2870->read(aat2870, ri->voltage_addr, &val);
+	if (ret)
+		return ret;
+
+	return (val & ri->voltage_mask) >> ri->voltage_shift;
+}
+
+static int aat2870_ldo_enable(struct regulator_dev *rdev)
+{
+	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
+	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+
+	return aat2870->update(aat2870, ri->enable_addr, ri->enable_mask,
+			       ri->enable_mask);
+}
+
+static int aat2870_ldo_disable(struct regulator_dev *rdev)
+{
+	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
+	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+
+	return aat2870->update(aat2870, ri->enable_addr, ri->enable_mask, 0);
+}
+
+static int aat2870_ldo_is_enabled(struct regulator_dev *rdev)
+{
+	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
+	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+	u8 val;
+	int ret;
+
+	ret = aat2870->read(aat2870, ri->enable_addr, &val);
+	if (ret)
+		return ret;
+
+	return val & ri->enable_mask ? 1 : 0;
+}
+
+static struct regulator_ops aat2870_ldo_ops = {
+	.list_voltage = aat2870_ldo_list_voltage,
+	.set_voltage_sel = aat2870_ldo_set_voltage_sel,
+	.get_voltage_sel = aat2870_ldo_get_voltage_sel,
+	.enable = aat2870_ldo_enable,
+	.disable = aat2870_ldo_disable,
+	.is_enabled = aat2870_ldo_is_enabled,
+};
+
+static const int aat2870_ldo_voltages[] = {
+	1200000, 1300000, 1500000, 1600000,
+	1800000, 2000000, 2200000, 2500000,
+	2600000, 2700000, 2800000, 2900000,
+	3000000, 3100000, 3200000, 3300000,
+};
+
+#define AAT2870_LDO(ids)				\
+	{						\
+		.desc = {				\
+			.name = #ids,			\
+			.id = AAT2870_ID_##ids,		\
+			.n_voltages = ARRAY_SIZE(aat2870_ldo_voltages),	\
+			.ops = &aat2870_ldo_ops,	\
+			.type = REGULATOR_VOLTAGE,	\
+			.owner = THIS_MODULE,		\
+		},					\
+		.voltages = aat2870_ldo_voltages,	\
+		.min_uV = 1200000,			\
+		.max_uV = 3300000,			\
+	}
+
+static struct aat2870_regulator aat2870_regulators[] = {
+	AAT2870_LDO(LDOA),
+	AAT2870_LDO(LDOB),
+	AAT2870_LDO(LDOC),
+	AAT2870_LDO(LDOD),
+};
+
+static struct aat2870_regulator *aat2870_get_regulator(int id)
+{
+	struct aat2870_regulator *ri = NULL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(aat2870_regulators); i++) {
+		ri = &aat2870_regulators[i];
+		if (ri->desc.id == id)
+			break;
+	}
+
+	if (!ri)
+		return NULL;
+
+	ri->enable_addr = AAT2870_LDO_EN;
+	ri->enable_shift = id - AAT2870_ID_LDOA;
+	ri->enable_mask = 0x1 << ri->enable_shift;
+
+	ri->voltage_addr = (id - AAT2870_ID_LDOA) / 2 ?
+			   AAT2870_LDO_CD : AAT2870_LDO_AB;
+	ri->voltage_shift = (id - AAT2870_ID_LDOA) % 2 ? 0 : 4;
+	ri->voltage_mask = 0xF << ri->voltage_shift;
+
+	return ri;
+}
+
+static int aat2870_regulator_probe(struct platform_device *pdev)
+{
+	struct aat2870_regulator *ri;
+	struct regulator_dev *rdev;
+
+	ri = aat2870_get_regulator(pdev->id);
+	if (!ri) {
+		dev_err(&pdev->dev, "Invalid device ID, %d\n", pdev->id);
+		return -EINVAL;
+	}
+	ri->pdev = pdev;
+
+	rdev = regulator_register(&ri->desc, &pdev->dev,
+				  pdev->dev.platform_data, ri);
+	if (IS_ERR(rdev)) {
+		dev_err(&pdev->dev, "Failed to register regulator %s\n",
+			ri->desc.name);
+		return PTR_ERR(rdev);
+	}
+	platform_set_drvdata(pdev, rdev);
+
+	return 0;
+}
+
+static int __devexit aat2870_regulator_remove(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+
+	regulator_unregister(rdev);
+	return 0;
+}
+
+static struct platform_driver aat2870_regulator_driver = {
+	.driver = {
+		.name	= "aat2870-regulator",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= aat2870_regulator_probe,
+	.remove	= __devexit_p(aat2870_regulator_remove),
+};
+
+static int __init aat2870_regulator_init(void)
+{
+	return platform_driver_register(&aat2870_regulator_driver);
+}
+subsys_initcall(aat2870_regulator_init);
+
+static void __exit aat2870_regulator_exit(void)
+{
+	platform_driver_unregister(&aat2870_regulator_driver);
+}
+module_exit(aat2870_regulator_exit);
+
+MODULE_DESCRIPTION("AnalogicTech AAT2870 Regulator");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jin Park <jinyoungp@nvidia.com>");
-- 
1.7.1

