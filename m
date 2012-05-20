Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab2ETCae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:30:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56888 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab2ETCac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:30:32 -0400
Message-ID: <1337481021.7204.1.camel@phoenix>
Subject: [PATCH RFC/RFT 1/7] regulator: core: Allow drivers to set voltage
 mapping table in regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Date: Sun, 20 May 2012 10:30:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some regulator hardware use table based mapping can set volt_table in
regulator_desc and use regulator_list_voltage_table() for their list_voltage
callback.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c         |   25 +++++++++++++++++++++++++
 include/linux/regulator/driver.h |    5 +++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index faa0532..0b15587 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1880,6 +1880,31 @@ int regulator_list_voltage_linear(struct regulator_dev *rdev,
 EXPORT_SYMBOL_GPL(regulator_list_voltage_linear);
 
 /**
+ * regulator_list_voltage_table - List voltages with table based mapping
+ *
+ * @rdev: Regulator device
+ * @selector: Selector to convert into a voltage
+ *
+ * Regulators with table based mapping between voltages and
+ * selectors can set volt_table in the regulator descriptor
+ * and then use this function as their list_voltage() operation.
+ */
+int regulator_list_voltage_table(struct regulator_dev *rdev,
+				 unsigned int selector)
+{
+	if (!rdev->desc->volt_table) {
+		BUG_ON(!rdev->desc->volt_table);
+		return -EINVAL;
+	}
+
+	if (selector >= rdev->desc->n_voltages)
+		return -EINVAL;
+
+	return rdev->desc->volt_table[selector];
+}
+EXPORT_SYMBOL_GPL(regulator_list_voltage_table);
+
+/**
  * regulator_list_voltage - enumerate supported voltages
  * @regulator: regulator source
  * @selector: identify voltage to list
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index b0432cc..8022638 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -170,6 +170,7 @@ enum regulator_type {
  *
  * @min_uV: Voltage given by the lowest selector (if linear mapping)
  * @uV_step: Voltage increase with each selector (if linear mapping)
+ * @volt_table: Voltage mapping table (if table based mapping)
  *
  * @vsel_reg: Register for selector when using regulator_regmap_X_voltage_
  * @vsel_mask: Mask for register bitfield used for selector
@@ -189,6 +190,8 @@ struct regulator_desc {
 	unsigned int min_uV;
 	unsigned int uV_step;
 
+	const unsigned int *volt_table;
+
 	unsigned int vsel_reg;
 	unsigned int vsel_mask;
 	unsigned int enable_reg;
@@ -271,6 +274,8 @@ int regulator_mode_to_status(unsigned int);
 
 int regulator_list_voltage_linear(struct regulator_dev *rdev,
 				  unsigned int selector);
+int regulator_list_voltage_table(struct regulator_dev *rdev,
+				  unsigned int selector);
 int regulator_map_voltage_linear(struct regulator_dev *rdev,
 				  int min_uV, int max_uV);
 int regulator_map_voltage_iterate(struct regulator_dev *rdev,
-- 
1.7.5.4



