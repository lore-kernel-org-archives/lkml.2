Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1HLIbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:31:04 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:60213 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab1HLIa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:30:58 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Vijaya Kumar Kilari <vijay.kilari@stericsson.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 23/23] regulator/db5500-prcmu: add driver
Date: Fri, 12 Aug 2011 10:30:41 +0200
Message-ID: <1313137841-31349-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@stericsson.com>

This adds a driver for the DB5500 PRCMU voltage domain
regulators, in the same spirit as the DB8500 PRCMU VD
regulators.

Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Vijaya Kumar Kilari <vijay.kilari@stericsson.com>
Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Signed-off-by: Philippe Langlais <philippe.langlais@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/Kconfig            |    1 +
 drivers/regulator/db5500-prcmu.c       |  351 ++++++++++++++++++++++++++++++++
 include/linux/regulator/db5500-prcmu.h |   25 +++
 3 files changed, 377 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/db5500-prcmu.c
 create mode 100644 include/linux/regulator/db5500-prcmu.h

diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index 4210cb4..86188b2 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -12,6 +12,7 @@ menu "Ux500 SoC"
 config UX500_SOC_DB5500
 	bool "DB5500"
 	select MFD_DB5500_PRCMU
+	select REGULATOR_DB5500_PRCMU
 
 config UX500_SOC_DB8500
 	bool "DB8500"
diff --git a/drivers/regulator/db5500-prcmu.c b/drivers/regulator/db5500-prcmu.c
new file mode 100644
index 0000000..4da49c1
--- /dev/null
+++ b/drivers/regulator/db5500-prcmu.c
@@ -0,0 +1,351 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2011
+ *
+ * License Terms: GNU General Public License v2
+ * Authors: Sundar Iyer <sundar.iyer@stericsson.com> for ST-Ericsson
+ *          Bengt Jonsson <bengt.g.jonsson@stericsson.com> for ST-Ericsson
+ *
+ * Power domain regulators on DB5500
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/db5500-prcmu.h>
+#include <linux/mfd/dbx500-prcmu.h>
+#include "dbx500-prcmu.h"
+
+/**
+ * struct db5500_regulator_info - db5500 regulator information
+ * @dev: device pointer
+ * @desc: regulator description
+ * @rdev: regulator device pointer
+ * @is_enabled: status of the regulator
+ * @epod_id: id for EPOD (power domain)
+ * @is_ramret: RAM retention switch for EPOD (power domain)
+ * @operating_point: operating point (only for vape, to be removed)
+ *
+ */
+struct db5500_regulator_info {
+	struct device *dev;
+	struct regulator_desc desc;
+	struct regulator_dev *rdev;
+	bool is_enabled;
+	u16 epod_id;
+	bool is_ramret;
+	bool exclude_from_power_state;
+	unsigned int operating_point;
+};
+
+static int db5500_regulator_enable(struct regulator_dev *rdev)
+{
+	struct db5500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL)
+		return -EINVAL;
+
+	dev_vdbg(rdev_get_dev(rdev), "regulator-%s-enable\n",
+		info->desc.name);
+
+	info->is_enabled = true;
+	if (!info->exclude_from_power_state)
+		power_state_active_enable();
+
+	return 0;
+}
+
+static int db5500_regulator_disable(struct regulator_dev *rdev)
+{
+	struct db5500_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret = 0;
+
+	if (info == NULL)
+		return -EINVAL;
+
+	dev_vdbg(rdev_get_dev(rdev), "regulator-%s-disable\n",
+		info->desc.name);
+
+	info->is_enabled = false;
+	if (!info->exclude_from_power_state)
+		ret = power_state_active_disable();
+
+	return ret;
+}
+
+static int db5500_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	struct db5500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL)
+		return -EINVAL;
+
+	dev_vdbg(rdev_get_dev(rdev), "regulator-%s-is_enabled (is_enabled):"
+		" %i\n", info->desc.name, info->is_enabled);
+
+	return info->is_enabled;
+}
+
+/* db5500 regulator operations */
+static struct regulator_ops db5500_regulator_ops = {
+	.enable			= db5500_regulator_enable,
+	.disable		= db5500_regulator_disable,
+	.is_enabled		= db5500_regulator_is_enabled,
+};
+
+/*
+ * EPOD control
+ */
+static bool epod_on[NUM_EPOD_ID];
+static bool epod_ramret[NUM_EPOD_ID];
+
+static inline int epod_id_to_index(u16 epod_id)
+{
+	return epod_id - DB5500_EPOD_ID_BASE;
+}
+
+static int enable_epod(u16 epod_id, bool ramret)
+{
+	int idx = epod_id_to_index(epod_id);
+	int ret;
+
+	if (ramret) {
+		if (!epod_on[idx]) {
+			ret = prcmu_set_epod(epod_id, EPOD_STATE_RAMRET);
+			if (ret < 0)
+				return ret;
+		}
+		epod_ramret[idx] = true;
+	} else {
+		ret = prcmu_set_epod(epod_id, EPOD_STATE_ON);
+		if (ret < 0)
+			return ret;
+		epod_on[idx] = true;
+	}
+
+	return 0;
+}
+
+static int disable_epod(u16 epod_id, bool ramret)
+{
+	int idx = epod_id_to_index(epod_id);
+	int ret;
+
+	if (ramret) {
+		if (!epod_on[idx]) {
+			ret = prcmu_set_epod(epod_id, EPOD_STATE_OFF);
+			if (ret < 0)
+				return ret;
+		}
+		epod_ramret[idx] = false;
+	} else {
+		if (epod_ramret[idx]) {
+			ret = prcmu_set_epod(epod_id, EPOD_STATE_RAMRET);
+			if (ret < 0)
+				return ret;
+		} else {
+			ret = prcmu_set_epod(epod_id, EPOD_STATE_OFF);
+			if (ret < 0)
+				return ret;
+		}
+		epod_on[idx] = false;
+	}
+
+	return 0;
+}
+
+/*
+ * Regulator switch
+ */
+static int db5500_regulator_switch_enable(struct regulator_dev *rdev)
+{
+	struct db5500_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret;
+
+	if (info == NULL)
+		return -EINVAL;
+
+	dev_vdbg(rdev_get_dev(rdev), "regulator-switch-%s-enable\n",
+		info->desc.name);
+
+	ret = enable_epod(info->epod_id, info->is_ramret);
+	if (ret < 0) {
+		dev_err(rdev_get_dev(rdev),
+			"regulator-switch-%s-enable: prcmu call failed\n",
+			info->desc.name);
+		goto out;
+	}
+
+	info->is_enabled = true;
+out:
+	return ret;
+}
+
+static int db5500_regulator_switch_disable(struct regulator_dev *rdev)
+{
+	struct db5500_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret;
+
+	if (info == NULL)
+		return -EINVAL;
+
+	dev_vdbg(rdev_get_dev(rdev), "regulator-switch-%s-disable\n",
+		info->desc.name);
+
+	ret = disable_epod(info->epod_id, info->is_ramret);
+	if (ret < 0) {
+		dev_err(rdev_get_dev(rdev),
+			"regulator_switch-%s-disable: prcmu call failed\n",
+			info->desc.name);
+		goto out;
+	}
+
+	info->is_enabled = 0;
+out:
+	return ret;
+}
+
+static int db5500_regulator_switch_is_enabled(struct regulator_dev *rdev)
+{
+	struct db5500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL)
+		return -EINVAL;
+
+	dev_vdbg(rdev_get_dev(rdev),
+		"regulator-switch-%s-is_enabled (is_enabled): %i\n",
+		info->desc.name, info->is_enabled);
+
+	return info->is_enabled;
+}
+
+static struct regulator_ops db5500_regulator_switch_ops = {
+	.enable			= db5500_regulator_switch_enable,
+	.disable		= db5500_regulator_switch_disable,
+	.is_enabled		= db5500_regulator_switch_is_enabled,
+};
+
+/*
+ * Regulator information
+ */
+#define DB5500_REGULATOR_SWITCH(_name, reg)                               \
+	[DB5500_REGULATOR_SWITCH_##reg] = {                               \
+		.desc = {                                               \
+			.name   = _name,                                \
+			.id     = DB5500_REGULATOR_SWITCH_##reg,          \
+			.ops    = &db5500_regulator_switch_ops,          \
+			.type   = REGULATOR_VOLTAGE,                    \
+			.owner  = THIS_MODULE,                          \
+		},                                                      \
+		.epod_id = DB5500_EPOD_ID_##reg,                         \
+}
+
+static struct db5500_regulator_info
+		db5500_regulator_info[DB5500_NUM_REGULATORS] = {
+	[DB5500_REGULATOR_VAPE] = {
+		.desc = {
+			.name	= "db5500-vape",
+			.id	= DB5500_REGULATOR_VAPE,
+			.ops	= &db5500_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+	},
+	DB5500_REGULATOR_SWITCH("db5500-sga", SGA),
+	DB5500_REGULATOR_SWITCH("db5500-hva", HVA),
+	DB5500_REGULATOR_SWITCH("db5500-sia", SIA),
+	DB5500_REGULATOR_SWITCH("db5500-disp", DISP),
+	DB5500_REGULATOR_SWITCH("db5500-esram12", ESRAM12),
+};
+
+static int __devinit db5500_regulator_probe(struct platform_device *pdev)
+{
+	struct regulator_init_data *db5500_init_data =
+					dev_get_platdata(&pdev->dev);
+	int i, err;
+
+	/* register all regulators */
+	for (i = 0; i < ARRAY_SIZE(db5500_regulator_info); i++) {
+		struct db5500_regulator_info *info;
+		struct regulator_init_data *init_data = &db5500_init_data[i];
+
+		/* assign per-regulator data */
+		info = &db5500_regulator_info[i];
+		info->dev = &pdev->dev;
+
+		/* register with the regulator framework */
+		info->rdev = regulator_register(&info->desc, &pdev->dev,
+				init_data, info);
+		if (IS_ERR(info->rdev)) {
+			err = PTR_ERR(info->rdev);
+			dev_err(&pdev->dev, "failed to register %s: err %i\n",
+				info->desc.name, err);
+
+			/* if failing, unregister all earlier regulators */
+			i--;
+			while (i >= 0) {
+				info = &db5500_regulator_info[i];
+				regulator_unregister(info->rdev);
+				i--;
+			}
+			return err;
+		}
+
+		dev_dbg(rdev_get_dev(info->rdev),
+			"regulator-%s-probed\n", info->desc.name);
+	}
+
+	return 0;
+}
+
+static int __exit db5500_regulator_remove(struct platform_device *pdev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(db5500_regulator_info); i++) {
+		struct db5500_regulator_info *info;
+		info = &db5500_regulator_info[i];
+
+		dev_vdbg(rdev_get_dev(info->rdev),
+			"regulator-%s-remove\n", info->desc.name);
+
+		regulator_unregister(info->rdev);
+	}
+
+	return 0;
+}
+
+static struct platform_driver db5500_regulator_driver = {
+	.driver = {
+		.name = "db5500-prcmu-regulators",
+		.owner = THIS_MODULE,
+	},
+	.probe = db5500_regulator_probe,
+	.remove = __exit_p(db5500_regulator_remove),
+};
+
+static int __init db5500_regulator_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&db5500_regulator_driver);
+	if (ret < 0)
+		return -ENODEV;
+
+	return 0;
+}
+
+static void __exit db5500_regulator_exit(void)
+{
+	platform_driver_unregister(&db5500_regulator_driver);
+}
+
+arch_initcall(db5500_regulator_init);
+module_exit(db5500_regulator_exit);
+
+MODULE_AUTHOR("STMicroelectronics/ST-Ericsson");
+MODULE_DESCRIPTION("DB5500 regulator driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/regulator/db5500-prcmu.h b/include/linux/regulator/db5500-prcmu.h
new file mode 100644
index 0000000..c5701e4
--- /dev/null
+++ b/include/linux/regulator/db5500-prcmu.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Author: Bengt Jonsson <bengt.g.jonsson@stericsson.com> for ST-Ericsson
+ *
+ * Interface to power domain regulators on DB5500
+ */
+
+#ifndef __DB5500_REGULATOR_H__
+#define __DB5500_REGULATOR_H__
+
+/* Number of DB5500 regulators and regulator enumeration */
+enum db5500_regulator_id {
+	DB5500_REGULATOR_VAPE,
+	DB5500_REGULATOR_SWITCH_SGA,
+	DB5500_REGULATOR_SWITCH_HVA,
+	DB5500_REGULATOR_SWITCH_SIA,
+	DB5500_REGULATOR_SWITCH_DISP,
+	DB5500_REGULATOR_SWITCH_ESRAM12,
+	DB5500_NUM_REGULATORS
+};
+
+#endif
-- 
1.7.3.2

