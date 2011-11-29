Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab1K2SNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:13:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59394 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756075Ab1K2SNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:13:11 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Allow regulators to register with no init_data
Date: Tue, 29 Nov 2011 18:13:07 +0000
Message-Id: <1322590387-27075-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows read-only access to the device configuration which may be
useful for diagnostics.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ca2efca..87e5363 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -912,8 +912,12 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	int ret = 0;
 	struct regulator_ops *ops = rdev->desc->ops;
 
-	rdev->constraints = kmemdup(constraints, sizeof(*constraints),
-				    GFP_KERNEL);
+	if (constraints)
+		rdev->constraints = kmemdup(constraints, sizeof(*constraints),
+					    GFP_KERNEL);
+	else
+		rdev->constraints = kzalloc(sizeof(*constraints),
+					    GFP_KERNEL);
 	if (!rdev->constraints)
 		return -ENOMEM;
 
@@ -922,7 +926,7 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		goto out;
 
 	/* do we need to setup our suspend state */
-	if (constraints->initial_state) {
+	if (rdev->constraints->initial_state) {
 		ret = suspend_prepare(rdev, rdev->constraints->initial_state);
 		if (ret < 0) {
 			rdev_err(rdev, "failed to set suspend state\n");
@@ -930,7 +934,7 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		}
 	}
 
-	if (constraints->initial_mode) {
+	if (rdev->constraints->initial_mode) {
 		if (!ops->set_mode) {
 			rdev_err(rdev, "no set_mode operation\n");
 			ret = -EINVAL;
@@ -2697,6 +2701,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	struct device *dev, const struct regulator_init_data *init_data,
 	void *driver_data, struct device_node *of_node)
 {
+	const struct regulation_constraints *constraints = NULL;
 	static atomic_t regulator_no = ATOMIC_INIT(0);
 	struct regulator_dev *rdev;
 	int ret, i;
@@ -2712,9 +2717,6 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	    regulator_desc->type != REGULATOR_CURRENT)
 		return ERR_PTR(-EINVAL);
 
-	if (!init_data)
-		return ERR_PTR(-EINVAL);
-
 	/* Only one of each should be implemented */
 	WARN_ON(regulator_desc->ops->get_voltage &&
 		regulator_desc->ops->get_voltage_sel);
@@ -2747,7 +2749,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	INIT_DELAYED_WORK(&rdev->disable_work, regulator_disable_work);
 
 	/* preform any regulator specific init */
-	if (init_data->regulator_init) {
+	if (init_data && init_data->regulator_init) {
 		ret = init_data->regulator_init(rdev->reg_data);
 		if (ret < 0)
 			goto clean;
@@ -2768,7 +2770,10 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	dev_set_drvdata(&rdev->dev, rdev);
 
 	/* set regulator constraints */
-	ret = set_machine_constraints(rdev, &init_data->constraints);
+	if (init_data)
+		constraints = &init_data->constraints;
+
+	ret = set_machine_constraints(rdev, constraints);
 	if (ret < 0)
 		goto scrub;
 
@@ -2777,7 +2782,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	if (ret < 0)
 		goto scrub;
 
-	if (init_data->supply_regulator)
+	if (init_data && init_data->supply_regulator)
 		supply = init_data->supply_regulator;
 	else if (regulator_desc->supply_name)
 		supply = regulator_desc->supply_name;
-- 
1.7.7.3

