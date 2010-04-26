Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab0DZOST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:18:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34592 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751682Ab0DZOSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:18:18 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Allow regulator-regulator supplies to be specified by name
Date: Mon, 26 Apr 2010 15:18:14 +0100
Message-Id: <1272291494-31682-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When one regulator supplies another allow the relationship to be specified
using names rather than struct regulators, in a similar manner to that
allowed for consumer supplies. This allows static configuration at compile
time, reducing the need for dynamic init code.

Also change the references to LINE supply to be system supply since line
is sometimes used for actual supplies and therefore potentially confusing.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c          |   30 ++++++++++++++++++++++++++++++
 include/linux/regulator/machine.h |    9 +++++++--
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 51cf2bb..eb112d9 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2328,7 +2328,37 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 		goto scrub;
 
 	/* set supply regulator if it exists */
+	if (init_data->supply_regulator && init_data->supply_regulator_dev) {
+		dev_err(dev,
+			"Supply regulator specified by both name and dev\n");
+		goto scrub;
+	}
+
+	if (init_data->supply_regulator) {
+		struct regulator_dev *r;
+		int found = 0;
+
+		list_for_each_entry(r, &regulator_list, list) {
+			if (strcmp(rdev_get_name(r),
+				   init_data->supply_regulator) == 0) {
+				found = 1;
+				break;
+			}
+		}
+
+		if (!found) {
+			dev_err(dev, "Failed to find supply %s\n",
+				init_data->supply_regulator);
+			goto scrub;
+		}
+
+		ret = set_supply(rdev, r);
+		if (ret < 0)
+			goto scrub;
+	}
+
 	if (init_data->supply_regulator_dev) {
+		dev_warn(dev, "Uses supply_regulator_dev instead of regulator_supply\n");
 		ret = set_supply(rdev,
 			dev_get_drvdata(init_data->supply_regulator_dev));
 		if (ret < 0)
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 234a847..e298028 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -157,7 +157,11 @@ struct regulator_consumer_supply {
  *
  * Initialisation constraints, our supply and consumers supplies.
  *
- * @supply_regulator_dev: Parent regulator (if any).
+ * @supply_regulator: Parent regulator.  Specified using the regulator name
+ *                    as it appears in the name field in sysfs, which can
+ *                    be explicitly set using the constraints field 'name'.
+ * @supply_regulator_dev: Parent regulator (if any) - DEPRECATED in favour
+ *                        of supply_regulator.
  *
  * @constraints: Constraints.  These must be specified for the regulator to
  *               be usable.
@@ -168,7 +172,8 @@ struct regulator_consumer_supply {
  * @driver_data: Data passed to regulator_init.
  */
 struct regulator_init_data {
-	struct device *supply_regulator_dev; /* or NULL for LINE */
+	const char *supply_regulator;        /* or NULL for system supply */
+	struct device *supply_regulator_dev; /* or NULL for system supply */
 
 	struct regulation_constraints constraints;
 
-- 
1.7.0.3

