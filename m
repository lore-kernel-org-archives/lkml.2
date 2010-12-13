Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0LMPik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:38:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46605 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752012Ab0LMPii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:38:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Graeme Gregory <dp@xora.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Provide a selector based set_voltage_sel() operation
Date: Mon, 13 Dec 2010 15:38:27 +0000
Message-Id: <1292254707-776-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292254707-776-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292254707-776-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many regulator drivers implement voltage setting by looping through a
table of possible values, normally because the set of available voltages
can't be mapped onto selectors with simple calcuation. Factor out these
loops by providing a variant of set_voltage() which takes a selector rather
than a voltage range as an argument and implementing a loop through the
available selectors in the core.

This is not going to be suitable for use with all devices as when the
regulator voltage can be mapped onto selector values with a simple
calculation the linear scan through the available values will be more
expensive than just doing the calculation, especially for regulators
that provide fine grained voltage control.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |   37 +++++++++++++++++++++++++++++++++++--
 include/linux/regulator/driver.h |    3 +++
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 23c5f7c..a0579f0 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1637,6 +1637,32 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 								 selector);
 		else
 			selector = -1;
+	} else if (rdev->desc->ops->set_voltage_sel) {
+		int best_val = INT_MAX;
+		int i;
+
+		selector = 0;
+
+		/* Find the smallest voltage that falls within the specified
+		 * range.
+		 */
+		for (i = 0; i < rdev->desc->n_voltages; i++) {
+			ret = rdev->desc->ops->list_voltage(rdev, i);
+			if (ret < 0)
+				continue;
+
+			if (ret < best_val && ret >= min_uV && ret <= max_uV) {
+				best_val = ret;
+				selector = i;
+			}
+		}
+
+		if (best_val != INT_MAX) {
+			ret = rdev->desc->ops->set_voltage_sel(rdev, selector);
+			selector = best_val;
+		} else {
+			ret = -EINVAL;
+		}
 	} else {
 		ret = -EINVAL;
 	}
@@ -1672,7 +1698,8 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	mutex_lock(&rdev->mutex);
 
 	/* sanity check */
-	if (!rdev->desc->ops->set_voltage) {
+	if (!rdev->desc->ops->set_voltage &&
+	    !rdev->desc->ops->set_voltage_sel) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -2256,7 +2283,7 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
 		return status;
 
 	/* constraints need specific supporting methods */
-	if (ops->set_voltage) {
+	if (ops->set_voltage || ops->set_voltage_sel) {
 		status = device_create_file(dev, &dev_attr_min_microvolts);
 		if (status < 0)
 			return status;
@@ -2354,12 +2381,18 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	/* Only one of each should be implemented */
 	WARN_ON(regulator_desc->ops->get_voltage &&
 		regulator_desc->ops->get_voltage_sel);
+	WARN_ON(regulator_desc->ops->set_voltage &&
+		regulator_desc->ops->set_voltage_sel);
 
 	/* If we're using selectors we must implement list_voltage. */
 	if (regulator_desc->ops->get_voltage_sel &&
 	    !regulator_desc->ops->list_voltage) {
 		return ERR_PTR(-EINVAL);
 	}
+	if (regulator_desc->ops->set_voltage_sel &&
+	    !regulator_desc->ops->list_voltage) {
+		return ERR_PTR(-EINVAL);
+	}
 
 	rdev = kzalloc(sizeof(struct regulator_dev), GFP_KERNEL);
 	if (rdev == NULL)
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index bf3e653..975ae06 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -42,6 +42,8 @@ enum regulator_status {
  *
  * @set_voltage: Set the voltage for the regulator within the range specified.
  *               The driver should select the voltage closest to min_uV.
+ * @set_voltage_sel: Set the voltage for the regulator using the specified
+ *                   selector.
  * @get_voltage: Return the currently configured voltage for the regulator.
  * @get_voltage_sel: Return the currently configured voltage selector for the
  *                   regulator.
@@ -83,6 +85,7 @@ struct regulator_ops {
 	/* get/set regulator voltage */
 	int (*set_voltage) (struct regulator_dev *, int min_uV, int max_uV,
 			    unsigned *selector);
+	int (*set_voltage_sel) (struct regulator_dev *, unsigned selector);
 	int (*get_voltage) (struct regulator_dev *);
 	int (*get_voltage_sel) (struct regulator_dev *);
 
-- 
1.7.1

