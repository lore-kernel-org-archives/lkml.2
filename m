Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2DOLus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:50:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44649 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754232Ab2DOLto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:49:44 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 6/8] regulator: core: Provide standard enable operations for regmap users
Date: Sun, 15 Apr 2012 12:49:23 +0100
Message-Id: <1334490565-19808-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the enable(), disable() and is_enabled() operations for most regmap
based regulators come down to reading and updating a single register bit
we can factor out the code and allow these drivers to just define which
bit to update using the enable_reg and enable_mask fields in their desc
and then use operations provided by the core.

As well as the code saving this opens the door to future optimisation of
the bulk operations - if the core can realise that we are updating a
single register for multiple regulators then it should be able to combine
these updates into a single physical operation.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |   55 ++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/driver.h |    7 +++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 40a6605..ab9ba45 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1738,6 +1738,61 @@ int regulator_disable_deferred(struct regulator *regulator, int ms)
 }
 EXPORT_SYMBOL_GPL(regulator_disable_deferred);
 
+/**
+ * regulator_is_enabled_regmap - standard is_enabled() for regmap users
+ *
+ * @rdev: regulator to operate on
+ *
+ * Regulators that use regmap for their register I/O can set the
+ * enable_reg and enable_mask fields in their descriptor and then use
+ * this as their is_enabled operation, saving some code.
+ */
+int regulator_is_enabled_regmap(struct regulator_dev *rdev)
+{
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(rdev->regmap, rdev->desc->enable_reg, &val);
+	if (ret != 0)
+		return ret;
+
+	return (val & rdev->desc->enable_mask) != 0;
+}
+EXPORT_SYMBOL_GPL(regulator_is_enabled_regmap);
+
+/**
+ * regulator_enable_regmap - standard enable() for regmap users
+ *
+ * @rdev: regulator to operate on
+ *
+ * Regulators that use regmap for their register I/O can set the
+ * enable_reg and enable_mask fields in their descriptor and then use
+ * this as their enable() operation, saving some code.
+ */
+int regulator_enable_regmap(struct regulator_dev *rdev)
+{
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				  rdev->desc->enable_mask,
+				  rdev->desc->enable_mask);
+}
+EXPORT_SYMBOL_GPL(regulator_enable_regmap);
+
+/**
+ * regulator_disable_regmap - standard disable() for regmap users
+ *
+ * @rdev: regulator to operate on
+ *
+ * Regulators that use regmap for their register I/O can set the
+ * enable_reg and enable_mask fields in their descriptor and then use
+ * this as their disable() operation, saving some code.
+ */
+int regulator_disable_regmap(struct regulator_dev *rdev)
+{
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				  rdev->desc->enable_mask, 0);
+}
+EXPORT_SYMBOL_GPL(regulator_disable_regmap);
+
 static int _regulator_is_enabled(struct regulator_dev *rdev)
 {
 	/* If we don't know then assume that the regulator is always on */
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index d1c2389..8160bc8 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -167,6 +167,8 @@ enum regulator_type {
 
  * @vsel_reg: Register for selector when using regulator_regmap_X_voltage_
  * @vsel_mask: Mask for register bitfield used for selector
+ * @enable_reg: Register for control when using regmap enable/disable ops
+ * @enable_mask: Mask for control when using regmap enable/disable ops
  */
 struct regulator_desc {
 	const char *name;
@@ -180,6 +182,8 @@ struct regulator_desc {
 
 	unsigned int vsel_reg;
 	unsigned int vsel_mask;
+	unsigned int enable_reg;
+	unsigned int enable_mask;
 };
 
 /**
@@ -258,6 +262,9 @@ int regulator_mode_to_status(unsigned int);
 
 int regulator_get_voltage_sel_regmap(struct regulator_dev *rdev);
 int regulator_set_voltage_sel_regmap(struct regulator_dev *rdev, unsigned sel);
+int regulator_is_enabled_regmap(struct regulator_dev *rdev);
+int regulator_enable_regmap(struct regulator_dev *rdev);
+int regulator_disable_regmap(struct regulator_dev *rdev);
 
 void *regulator_get_init_drvdata(struct regulator_init_data *reg_init_data);
 
-- 
1.7.9.1

