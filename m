Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0K2Pze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:55:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59449 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751689Ab0K2Pzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:55:33 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Copy constraints from regulators when initialising them
Date: Mon, 29 Nov 2010 15:55:17 +0000
Message-Id: <1291046117-9090-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the regulator API uses the constraints structure passed in to
the core throughout the lifetime of the object. This means that it is not
possible to mark the constraints as __initdata so if the kernel supports
many boards the constraints for all of them are kept around throughout the
lifetime of the system, consuming memory needlessly. By copying constraints
that are actually used we allow the use of __initdata, saving memory when
multiple boards are supported.

This also means the constraints can be const.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |   19 ++++++++++++-------
 include/linux/regulator/driver.h |    2 +-
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 64a56a7..40cf7b9 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -813,23 +813,26 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
  * set_mode.
  */
 static int set_machine_constraints(struct regulator_dev *rdev,
-	struct regulation_constraints *constraints)
+	const struct regulation_constraints *constraints)
 {
 	int ret = 0;
 	const char *name;
 	struct regulator_ops *ops = rdev->desc->ops;
 
-	rdev->constraints = constraints;
+	rdev->constraints = kmemdup(constraints, sizeof(*constraints),
+				    GFP_KERNEL);
+	if (!rdev->constraints)
+		return -ENOMEM;
 
 	name = rdev_get_name(rdev);
 
-	ret = machine_constraints_voltage(rdev, constraints);
+	ret = machine_constraints_voltage(rdev, rdev->constraints);
 	if (ret != 0)
 		goto out;
 
 	/* do we need to setup our suspend state */
 	if (constraints->initial_state) {
-		ret = suspend_prepare(rdev, constraints->initial_state);
+		ret = suspend_prepare(rdev, rdev->constraints->initial_state);
 		if (ret < 0) {
 			pr_err("failed to set suspend state for %s\n",
 				name);
@@ -846,7 +849,7 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 			goto out;
 		}
 
-		ret = ops->set_mode(rdev, constraints->initial_mode);
+		ret = ops->set_mode(rdev, rdev->constraints->initial_mode);
 		if (ret < 0) {
 			pr_err("failed to set initial mode for %s: %d\n",
 				name, ret);
@@ -857,7 +860,8 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
 	 */
-	if ((constraints->always_on || constraints->boot_on) && ops->enable) {
+	if ((rdev->constraints->always_on || rdev->constraints->boot_on) &&
+	    ops->enable) {
 		ret = ops->enable(rdev);
 		if (ret < 0) {
 			pr_err("failed to enable %s\n", name);
@@ -2289,7 +2293,7 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
  * Returns 0 on success.
  */
 struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
-	struct device *dev, struct regulator_init_data *init_data,
+	struct device *dev, const struct regulator_init_data *init_data,
 	void *driver_data)
 {
 	static atomic_t regulator_no = ATOMIC_INIT(0);
@@ -2444,6 +2448,7 @@ void regulator_unregister(struct regulator_dev *rdev)
 	if (rdev->supply)
 		sysfs_remove_link(&rdev->dev.kobj, "supply");
 	device_unregister(&rdev->dev);
+	kfree(rdev->constraints);
 	mutex_unlock(&regulator_list_mutex);
 }
 EXPORT_SYMBOL_GPL(regulator_unregister);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 4275cd4..cce5753 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -192,7 +192,7 @@ struct regulator_dev {
 };
 
 struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
-	struct device *dev, struct regulator_init_data *init_data,
+	struct device *dev, const struct regulator_init_data *init_data,
 	void *driver_data);
 void regulator_unregister(struct regulator_dev *rdev);
 
-- 
1.7.1

