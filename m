Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298Ab2EIXr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:47:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56969 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760680Ab2EIXrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:47:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Yadwinder Singh <yadi.brar@samsung.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/6] regulator: core: Allow regulators to provide a voltage to selector mapping
Date: Thu, 10 May 2012 00:47:29 +0100
Message-Id: <1336607255-4967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow more drivers to factor things out into data allow
drivers to provide a mapping function to convert voltages into selectors.
This allows any driver to use set_voltage_sel(). The existing mapping
based on iterating over list_voltage() is provided as an operation which
can be assigned to the new map_voltage() function though for ease of
transition it is treated as the default.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |   82 +++++++++++++++++++++++++-------------
 include/linux/regulator/driver.h |    4 ++
 2 files changed, 59 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f899af5..2633310 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1967,14 +1967,54 @@ int regulator_set_voltage_sel_regmap(struct regulator_dev *rdev, unsigned sel)
 }
 EXPORT_SYMBOL_GPL(regulator_set_voltage_sel_regmap);
 
+/**
+ * regulator_map_voltage_iterate - map_voltage() based on list_voltage()
+ *
+ * @rdev: Regulator to operate on
+ * @min_uV: Lower bound for voltage
+ * @max_uV: Upper bound for voltage
+ *
+ * Drivers implementing set_voltage_sel() and list_voltage() can use
+ * this as their map_voltage() operation.  It will find a suitable
+ * voltage by calling list_voltage() until it gets something in bounds
+ * for the requested voltages.
+ */
+int regulator_map_voltage_iterate(struct regulator_dev *rdev,
+				  int min_uV, int max_uV)
+{
+	int best_val = INT_MAX;
+	int selector = 0;
+	int i, ret;
+
+	/* Find the smallest voltage that falls within the specified
+	 * range.
+	 */
+	for (i = 0; i < rdev->desc->n_voltages; i++) {
+		ret = rdev->desc->ops->list_voltage(rdev, i);
+		if (ret < 0)
+			continue;
+
+		if (ret < best_val && ret >= min_uV && ret <= max_uV) {
+			best_val = ret;
+			selector = i;
+		}
+	}
+
+	if (best_val != INT_MAX)
+		return selector;
+	else
+		return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(regulator_map_voltage_iterate);
+
 static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 				     int min_uV, int max_uV)
 {
 	int ret;
 	int delay = 0;
+	int best_val;
 	unsigned int selector;
 	int old_selector = -1;
-	int best_val = INT_MAX;
 
 	trace_regulator_set_voltage(rdev_get_name(rdev), min_uV, max_uV);
 
@@ -1995,39 +2035,27 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 	if (rdev->desc->ops->set_voltage) {
 		ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV,
 						   &selector);
-
-		if (rdev->desc->ops->list_voltage)
-			best_val = rdev->desc->ops->list_voltage(rdev,
-								 selector);
-		else
-			best_val = -1;
 	} else if (rdev->desc->ops->set_voltage_sel) {
-		int i;
-
-		selector = 0;
-
-		/* Find the smallest voltage that falls within the specified
-		 * range.
-		 */
-		for (i = 0; i < rdev->desc->n_voltages; i++) {
-			ret = rdev->desc->ops->list_voltage(rdev, i);
-			if (ret < 0)
-				continue;
+		if (rdev->desc->ops->map_voltage)
+			ret = rdev->desc->ops->map_voltage(rdev, min_uV,
+							   max_uV);
+		else
+			ret = regulator_map_voltage_iterate(rdev, min_uV,
+							    max_uV);
 
-			if (ret < best_val && ret >= min_uV && ret <= max_uV) {
-				best_val = ret;
-				selector = i;
-			}
+		if (ret >= 0) {
+			selector = ret;
+			ret = rdev->desc->ops->set_voltage_sel(rdev, ret);
 		}
-
-		if (best_val != INT_MAX)
-			ret = rdev->desc->ops->set_voltage_sel(rdev, selector);
-		else
-			ret = -EINVAL;
 	} else {
 		ret = -EINVAL;
 	}
 
+	if (rdev->desc->ops->list_voltage)
+		best_val = rdev->desc->ops->list_voltage(rdev, selector);
+	else
+		best_val = -1;
+
 	/* Call set_voltage_time_sel if successfully obtained old_selector */
 	if (ret == 0 && old_selector >= 0 &&
 	    rdev->desc->ops->set_voltage_time_sel) {
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 8160bc8..13aa852 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -46,6 +46,7 @@ enum regulator_status {
  *               The driver should select the voltage closest to min_uV.
  * @set_voltage_sel: Set the voltage for the regulator using the specified
  *                   selector.
+ * @map_voltage: Convert a voltage into a selector
  * @get_voltage: Return the currently configured voltage for the regulator.
  * @get_voltage_sel: Return the currently configured voltage selector for the
  *                   regulator.
@@ -91,6 +92,7 @@ struct regulator_ops {
 	/* get/set regulator voltage */
 	int (*set_voltage) (struct regulator_dev *, int min_uV, int max_uV,
 			    unsigned *selector);
+	int (*map_voltage)(struct regulator_dev *, int min_uV, int max_uV);
 	int (*set_voltage_sel) (struct regulator_dev *, unsigned selector);
 	int (*get_voltage) (struct regulator_dev *);
 	int (*get_voltage_sel) (struct regulator_dev *);
@@ -260,6 +262,8 @@ int rdev_get_id(struct regulator_dev *rdev);
 
 int regulator_mode_to_status(unsigned int);
 
+int regulator_map_voltage_iterate(struct regulator_dev *rdev,
+				  int min_uV, int max_uV);
 int regulator_get_voltage_sel_regmap(struct regulator_dev *rdev);
 int regulator_set_voltage_sel_regmap(struct regulator_dev *rdev, unsigned sel);
 int regulator_is_enabled_regmap(struct regulator_dev *rdev);
-- 
1.7.10

