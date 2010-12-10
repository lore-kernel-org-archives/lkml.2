Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab0LJR2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:28:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55348 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752566Ab0LJR2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:28:12 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] regulator: Allow drivers to report voltages as selectors
Date: Fri, 10 Dec 2010 17:28:07 +0000
Message-Id: <1292002088-9644-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292002088-9644-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292002088-9644-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since drivers already have to provide an API for translating selectors
into voltages they may as well just report the selector values directly
to the core API rather than implement the lookup themselves. The old
interface is left in place for now, but may be removed in future.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |   25 ++++++++++++++++++++++---
 include/linux/regulator/driver.h |    3 +++
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 671eb53..b362dbd 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -577,7 +577,9 @@ static void drms_uA_update(struct regulator_dev *rdev)
 
 	err = regulator_check_drms(rdev);
 	if (err < 0 || !rdev->desc->ops->get_optimum_mode ||
-	    !rdev->desc->ops->get_voltage || !rdev->desc->ops->set_mode)
+	    (!rdev->desc->ops->get_voltage &&
+	     !rdev->desc->ops->get_voltage_sel) ||
+	    !rdev->desc->ops->set_mode)
 		return;
 
 	/* get output voltage */
@@ -1682,7 +1684,14 @@ EXPORT_SYMBOL_GPL(regulator_set_voltage);
 
 static int _regulator_get_voltage(struct regulator_dev *rdev)
 {
-	/* sanity check */
+	int sel;
+
+	if (rdev->desc->ops->get_voltage_sel) {
+		sel = rdev->desc->ops->get_voltage_sel(rdev);
+		if (sel < 0)
+			return sel;
+		return rdev->desc->ops->list_voltage(rdev, sel);
+	}
 	if (rdev->desc->ops->get_voltage)
 		return rdev->desc->ops->get_voltage(rdev);
 	else
@@ -2191,7 +2200,7 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
 	int			status = 0;
 
 	/* some attributes need specific methods to be displayed */
-	if (ops->get_voltage) {
+	if (ops->get_voltage || ops->get_voltage_sel) {
 		status = device_create_file(dev, &dev_attr_microvolts);
 		if (status < 0)
 			return status;
@@ -2327,6 +2336,16 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	if (!init_data)
 		return ERR_PTR(-EINVAL);
 
+	/* Only one of each should be implemented */
+	WARN_ON(regulator_desc->ops->get_voltage &&
+		regulator_desc->ops->get_voltage_sel);
+
+	/* If we're using selectors we must implement list_voltage. */
+	if (regulator_desc->ops->get_voltage_sel &&
+	    !regulator_desc->ops->list_voltage) {
+		return ERR_PTR(-EINVAL);
+	}
+
 	rdev = kzalloc(sizeof(struct regulator_dev), GFP_KERNEL);
 	if (rdev == NULL)
 		return ERR_PTR(-ENOMEM);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index cce5753..bf3e653 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -43,6 +43,8 @@ enum regulator_status {
  * @set_voltage: Set the voltage for the regulator within the range specified.
  *               The driver should select the voltage closest to min_uV.
  * @get_voltage: Return the currently configured voltage for the regulator.
+ * @get_voltage_sel: Return the currently configured voltage selector for the
+ *                   regulator.
  * @list_voltage: Return one of the supported voltages, in microvolts; zero
  *	if the selector indicates a voltage that is unusable on this system;
  *	or negative errno.  Selectors range from zero to one less than
@@ -82,6 +84,7 @@ struct regulator_ops {
 	int (*set_voltage) (struct regulator_dev *, int min_uV, int max_uV,
 			    unsigned *selector);
 	int (*get_voltage) (struct regulator_dev *);
+	int (*get_voltage_sel) (struct regulator_dev *);
 
 	/* get/set regulator current  */
 	int (*set_current_limit) (struct regulator_dev *,
-- 
1.7.1

