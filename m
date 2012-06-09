Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2FILK6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 07:10:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46959 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2FILK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 07:10:56 -0400
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH v2 1/2] regulator: core: Add regulator_set_voltage_time_sel to calculate ramp delay.
Date: Sat,  9 Jun 2012 16:40:38 +0530
Message-Id: <1339240239-5626-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds regulator_set_voltage_time_sel(), to move into core, the
commonly used code by drivers to provide the .set_voltage_time_sel callback.
It will also allow us to configure different ramp delay for different
regulators easily.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/core.c         |   24 ++++++++++++++++++++++++
 include/linux/regulator/driver.h |    5 +++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 876f5fc..f4c056a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2289,6 +2289,30 @@ int regulator_set_voltage_time(struct regulator *regulator,
 EXPORT_SYMBOL_GPL(regulator_set_voltage_time);
 
 /**
+ *regulator_set_voltage_time_sel - get raise/fall time
+ * @regulator: regulator source
+ * @old_selector: selector for starting voltage
+ * @new_selector: selector for target voltage
+ *
+ * Provided with the starting and target voltage selectors, this function
+ * returns time in microseconds required to rise or fall to this new voltage
+ *
+ * Drivers providing uV_step in their regulator_desc and ramp_delay in
+ * regulation_constraints can use this as their set_voltage_time_sel()
+ * operation.
+ */
+int regulator_set_voltage_time_sel(struct regulator_dev *rdev,
+				   unsigned int old_selector,
+				   unsigned int new_selector)
+{
+	if (rdev->desc->ramp_delay && rdev->desc->uV_step)
+		return DIV_ROUND_UP(rdev->desc->uV_step *
+			abs(new_selector - old_selector),
+			rdev->desc->ramp_delay) * 1000;
+	return 0;
+}
+
+/**
  * regulator_sync_voltage - re-apply last regulator output voltage
  * @regulator: regulator source
  *
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 8022638..ae5c253 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -170,6 +170,7 @@ enum regulator_type {
  *
  * @min_uV: Voltage given by the lowest selector (if linear mapping)
  * @uV_step: Voltage increase with each selector (if linear mapping)
+ * @ramp_delay: Time to settle down after voltage change (unit: mV/us)
  * @volt_table: Voltage mapping table (if table based mapping)
  *
  * @vsel_reg: Register for selector when using regulator_regmap_X_voltage_
@@ -189,6 +190,7 @@ struct regulator_desc {
 
 	unsigned int min_uV;
 	unsigned int uV_step;
+	unsigned int ramp_delay;
 
 	const unsigned int *volt_table;
 
@@ -285,6 +287,9 @@ int regulator_set_voltage_sel_regmap(struct regulator_dev *rdev, unsigned sel);
 int regulator_is_enabled_regmap(struct regulator_dev *rdev);
 int regulator_enable_regmap(struct regulator_dev *rdev);
 int regulator_disable_regmap(struct regulator_dev *rdev);
+int regulator_set_voltage_time_sel(struct regulator_dev *rdev,
+				   unsigned int old_selector,
+				   unsigned int new_selector);
 
 void *regulator_get_init_drvdata(struct regulator_init_data *reg_init_data);
 
-- 
1.7.0.4

