Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab2DOLtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:49:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44667 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754500Ab2DOLtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:49:47 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/8] regulator: core: Provide regmap based voltage_sel operations
Date: Sun, 15 Apr 2012 12:49:19 +0100
Message-Id: <1334490565-19808-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the voltage selector operations are intended to directly map a
bitfield in the device register map into regulator API operations the
code for implementing them is usually very standard we can save some
code by providing standard implementations for devices using the regmap
API.

Drivers using regmap can pass their regmap in in the regmap_config
struct, set vsel_reg and vsel_mask in their regulator_desc and then
use regulator_{get,set}_voltage_sel_regmap in their ops. This saves
a small amount of code from each driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |   44 ++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/driver.h |    9 +++++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 10ba8d3..40a6605 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1851,6 +1851,50 @@ int regulator_is_supported_voltage(struct regulator *regulator,
 }
 EXPORT_SYMBOL_GPL(regulator_is_supported_voltage);
 
+/**
+ * regulator_get_voltage_sel_regmap - standard get_voltage_sel for regmap users
+ *
+ * @rdev: regulator to operate on
+ *
+ * Regulators that use regmap for their register I/O can set the
+ * vsel_reg and vsel_mask fields in their descriptor and then use this
+ * as their get_voltage_vsel operation, saving some code.
+ */
+int regulator_get_voltage_sel_regmap(struct regulator_dev *rdev)
+{
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(rdev->regmap, rdev->desc->vsel_reg, &val);
+	if (ret != 0)
+		return ret;
+
+	val &= rdev->desc->vsel_mask;
+	val >>= ffs(rdev->desc->vsel_mask) - 1;
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(regulator_get_voltage_sel_regmap);
+
+/**
+ * regulator_set_voltage_sel_regmap - standard set_voltage_sel for regmap users
+ *
+ * @rdev: regulator to operate on
+ * @sel: Selector to set
+ *
+ * Regulators that use regmap for their register I/O can set the
+ * vsel_reg and vsel_mask fields in their descriptor and then use this
+ * as their set_voltage_vsel operation, saving some code.
+ */
+int regulator_set_voltage_sel_regmap(struct regulator_dev *rdev, unsigned sel)
+{
+	sel <<= ffs(rdev->desc->vsel_mask) - 1;
+
+	return regmap_update_bits(rdev->regmap, rdev->desc->vsel_reg,
+				  rdev->desc->vsel_mask, sel);
+}
+EXPORT_SYMBOL_GPL(regulator_set_voltage_sel_regmap);
+
 static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 				     int min_uV, int max_uV)
 {
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 2e75373..d1c2389 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -164,6 +164,9 @@ enum regulator_type {
  * @irq: Interrupt number for the regulator.
  * @type: Indicates if the regulator is a voltage or current regulator.
  * @owner: Module providing the regulator, used for refcounting.
+
+ * @vsel_reg: Register for selector when using regulator_regmap_X_voltage_
+ * @vsel_mask: Mask for register bitfield used for selector
  */
 struct regulator_desc {
 	const char *name;
@@ -174,6 +177,9 @@ struct regulator_desc {
 	int irq;
 	enum regulator_type type;
 	struct module *owner;
+
+	unsigned int vsel_reg;
+	unsigned int vsel_mask;
 };
 
 /**
@@ -250,6 +256,9 @@ int rdev_get_id(struct regulator_dev *rdev);
 
 int regulator_mode_to_status(unsigned int);
 
+int regulator_get_voltage_sel_regmap(struct regulator_dev *rdev);
+int regulator_set_voltage_sel_regmap(struct regulator_dev *rdev, unsigned sel);
+
 void *regulator_get_init_drvdata(struct regulator_init_data *reg_init_data);
 
 #endif
-- 
1.7.9.1

