Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285Ab2EIXr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:47:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56971 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761272Ab2EIXrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:47:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Yadwinder Singh <yadi.brar@samsung.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/6] regulator: core: Allow drivers to set simple linear voltage maps as data
Date: Thu, 10 May 2012 00:47:30 +0100
Message-Id: <1336607255-4967-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336607255-4967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336607255-4967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of regulator hardware maps selectors on to voltages with a simple
linear mapping function

    selector = base + (selector * step size)

Provide off the shelf list_voltage() and map_voltage() operations which
use new min_uV and uV_step members in the regulator_desc to implement
this function.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |   53 ++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/driver.h |   15 +++++++++--
 2 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2633310..a3cfaea 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1860,6 +1860,26 @@ int regulator_count_voltages(struct regulator *regulator)
 EXPORT_SYMBOL_GPL(regulator_count_voltages);
 
 /**
+ * regulator_list_voltage_linear - List voltages with simple calculation
+ *
+ * @rdev: Regulator device
+ * @selector: Selector to convert into a voltage
+ *
+ * Regulators with a simple linear mapping between voltages and
+ * selectors can set min_uV and uV_step in the regulator descriptor
+ * and then use this function as their list_voltage() operation,
+ */
+int regulator_list_voltage_linear(struct regulator_dev *rdev,
+				  unsigned int selector)
+{
+	if (selector >= rdev->desc->n_voltages)
+		return -EINVAL;
+
+	return rdev->desc->min_uV + (rdev->desc->uV_step * selector);
+}
+EXPORT_SYMBOL_GPL(regulator_list_voltage_linear);
+
+/**
  * regulator_list_voltage - enumerate supported voltages
  * @regulator: regulator source
  * @selector: identify voltage to list
@@ -2007,6 +2027,39 @@ int regulator_map_voltage_iterate(struct regulator_dev *rdev,
 }
 EXPORT_SYMBOL_GPL(regulator_map_voltage_iterate);
 
+/**
+ * regulator_map_voltage_linear - map_voltage() for simple linear mappings
+ *
+ * @rdev: Regulator to operate on
+ * @min_uV: Lower bound for voltage
+ * @max_uV: Upper bound for voltage
+ *
+ * Drivers providing min_uV and uV_step in their regulator_desc can
+ * use this as their map_voltage() operation.
+ */
+int regulator_map_voltage_linear(struct regulator_dev *rdev,
+				 int min_uV, int max_uV)
+{
+	int ret, voltage;
+
+	if (!rdev->desc->uV_step) {
+		BUG_ON(!rdev->desc->uV_step);
+		return -EINVAL;
+	}
+
+	ret = (min_uV - rdev->desc->min_uV) / rdev->desc->uV_step;
+	if (ret < 0)
+		return ret;
+
+	/* Map back into a voltage to verify we're still in bounds */
+	voltage = rdev->desc->ops->list_voltage(rdev, ret);
+	if (voltage < min_uV || voltage > max_uV)
+		return -EINVAL;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_map_voltage_linear);
+
 static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 				     int min_uV, int max_uV)
 {
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 13aa852..b0432cc 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -161,12 +161,16 @@ enum regulator_type {
  * @name: Identifying name for the regulator.
  * @supply_name: Identifying the regulator supply
  * @id: Numerical identifier for the regulator.
- * @n_voltages: Number of selectors available for ops.list_voltage().
  * @ops: Regulator operations table.
  * @irq: Interrupt number for the regulator.
  * @type: Indicates if the regulator is a voltage or current regulator.
  * @owner: Module providing the regulator, used for refcounting.
-
+ *
+ * @n_voltages: Number of selectors available for ops.list_voltage().
+ *
+ * @min_uV: Voltage given by the lowest selector (if linear mapping)
+ * @uV_step: Voltage increase with each selector (if linear mapping)
+ *
  * @vsel_reg: Register for selector when using regulator_regmap_X_voltage_
  * @vsel_mask: Mask for register bitfield used for selector
  * @enable_reg: Register for control when using regmap enable/disable ops
@@ -182,6 +186,9 @@ struct regulator_desc {
 	enum regulator_type type;
 	struct module *owner;
 
+	unsigned int min_uV;
+	unsigned int uV_step;
+
 	unsigned int vsel_reg;
 	unsigned int vsel_mask;
 	unsigned int enable_reg;
@@ -262,6 +269,10 @@ int rdev_get_id(struct regulator_dev *rdev);
 
 int regulator_mode_to_status(unsigned int);
 
+int regulator_list_voltage_linear(struct regulator_dev *rdev,
+				  unsigned int selector);
+int regulator_map_voltage_linear(struct regulator_dev *rdev,
+				  int min_uV, int max_uV);
 int regulator_map_voltage_iterate(struct regulator_dev *rdev,
 				  int min_uV, int max_uV);
 int regulator_get_voltage_sel_regmap(struct regulator_dev *rdev);
-- 
1.7.10

