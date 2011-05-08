Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab1EHXa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 19:30:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34096 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751163Ab1EHXaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 19:30:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Remove supply_regulator_dev from machine configuration
Date: Sun,  8 May 2011 22:30:18 +0100
Message-Id: <1304890218-19332-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

supply_regulator_dev (using a struct pointer) has been deprecated in favour
of supply_regulator (using a regulator name) for quite a few releases
now with a warning generated if it is used and there are no current in tree
users so just remove the code.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 Documentation/power/regulator/machine.txt |    4 ++--
 drivers/regulator/core.c                  |   16 ----------------
 include/linux/regulator/machine.h         |    3 ---
 3 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/Documentation/power/regulator/machine.txt b/Documentation/power/regulator/machine.txt
index bdec39b..b42419b 100644
--- a/Documentation/power/regulator/machine.txt
+++ b/Documentation/power/regulator/machine.txt
@@ -53,11 +53,11 @@ static struct regulator_init_data regulator1_data = {
 
 Regulator-1 supplies power to Regulator-2. This relationship must be registered
 with the core so that Regulator-1 is also enabled when Consumer A enables its
-supply (Regulator-2). The supply regulator is set by the supply_regulator_dev
+supply (Regulator-2). The supply regulator is set by the supply_regulator
 field below:-
 
 static struct regulator_init_data regulator2_data = {
-	.supply_regulator_dev = &platform_regulator1_device.dev,
+	.supply_regulator = "regulator_name",
 	.constraints = {
 		.min_uV = 1800000,
 		.max_uV = 2000000,
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b483efa..c5b3c50 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2604,14 +2604,6 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	if (ret < 0)
 		goto scrub;
 
-	/* set supply regulator if it exists */
-	if (init_data->supply_regulator && init_data->supply_regulator_dev) {
-		dev_err(dev,
-			"Supply regulator specified by both name and dev\n");
-		ret = -EINVAL;
-		goto scrub;
-	}
-
 	if (init_data->supply_regulator) {
 		struct regulator_dev *r;
 		int found = 0;
@@ -2636,14 +2628,6 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 			goto scrub;
 	}
 
-	if (init_data->supply_regulator_dev) {
-		dev_warn(dev, "Uses supply_regulator_dev instead of regulator_supply\n");
-		ret = set_supply(rdev,
-			dev_get_drvdata(init_data->supply_regulator_dev));
-		if (ret < 0)
-			goto scrub;
-	}
-
 	/* add consumers devices */
 	for (i = 0; i < init_data->num_consumer_supplies; i++) {
 		ret = set_consumer_device_supply(rdev,
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 598e08b..ce3127a 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -164,8 +164,6 @@ struct regulator_consumer_supply {
  * @supply_regulator: Parent regulator.  Specified using the regulator name
  *                    as it appears in the name field in sysfs, which can
  *                    be explicitly set using the constraints field 'name'.
- * @supply_regulator_dev: Parent regulator (if any) - DEPRECATED in favour
- *                        of supply_regulator.
  *
  * @constraints: Constraints.  These must be specified for the regulator to
  *               be usable.
@@ -177,7 +175,6 @@ struct regulator_consumer_supply {
  */
 struct regulator_init_data {
 	const char *supply_regulator;        /* or NULL for system supply */
-	struct device *supply_regulator_dev; /* or NULL for system supply */
 
 	struct regulation_constraints constraints;
 
-- 
1.7.4.1

