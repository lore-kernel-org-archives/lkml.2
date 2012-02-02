Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab2BBL1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 06:27:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41415 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755475Ab2BBL1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 06:27:06 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Remove support for supplies specified by struct device
Date: Thu,  2 Feb 2012 11:27:02 +0000
Message-Id: <1328182022-6218-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been deprecated for a very long time now.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c          |   23 ++++++++---------------
 include/linux/regulator/machine.h |    2 --
 2 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8057451..dd493b8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -996,7 +996,6 @@ static int set_supply(struct regulator_dev *rdev,
 /**
  * set_consumer_device_supply - Bind a regulator to a symbolic supply
  * @rdev:         regulator source
- * @consumer_dev: device the supply applies to
  * @consumer_dev_name: dev_name() string for device supply applies to
  * @supply:       symbolic name for supply
  *
@@ -1008,18 +1007,12 @@ static int set_supply(struct regulator_dev *rdev,
  * Only one of consumer_dev and consumer_dev_name may be specified.
  */
 static int set_consumer_device_supply(struct regulator_dev *rdev,
-	struct device *consumer_dev, const char *consumer_dev_name,
-	const char *supply)
+				      const char *consumer_dev_name,
+				      const char *supply)
 {
 	struct regulator_map *node;
 	int has_dev;
 
-	if (consumer_dev && consumer_dev_name)
-		return -EINVAL;
-
-	if (!consumer_dev_name && consumer_dev)
-		consumer_dev_name = dev_name(consumer_dev);
-
 	if (supply == NULL)
 		return -EINVAL;
 
@@ -1039,11 +1032,12 @@ static int set_consumer_device_supply(struct regulator_dev *rdev,
 		if (strcmp(node->supply, supply) != 0)
 			continue;
 
-		dev_dbg(consumer_dev, "%s/%s is '%s' supply; fail %s/%s\n",
-			dev_name(&node->regulator->dev),
-			node->regulator->desc->name,
-			supply,
-			dev_name(&rdev->dev), rdev_get_name(rdev));
+		pr_debug("%s: %s/%s is '%s' supply; fail %s/%s\n",
+			 consumer_dev_name,
+			 dev_name(&node->regulator->dev),
+			 node->regulator->desc->name,
+			 supply,
+			 dev_name(&rdev->dev), rdev_get_name(rdev));
 		return -EBUSY;
 	}
 
@@ -2963,7 +2957,6 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	if (init_data) {
 		for (i = 0; i < init_data->num_consumer_supplies; i++) {
 			ret = set_consumer_device_supply(rdev,
-				init_data->consumer_supplies[i].dev,
 				init_data->consumer_supplies[i].dev_name,
 				init_data->consumer_supplies[i].supply);
 			if (ret < 0) {
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index f3f13fd..7abb160 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -139,12 +139,10 @@ struct regulation_constraints {
  * make struct device available late such as I2C and is the preferred
  * form.
  *
- * @dev: Device structure for the consumer.
  * @dev_name: Result of dev_name() for the consumer.
  * @supply: Name for the supply.
  */
 struct regulator_consumer_supply {
-	struct device *dev;	/* consumer */
 	const char *dev_name;   /* dev_name() for consumer */
 	const char *supply;	/* consumer supply - e.g. "vcc" */
 };
-- 
1.7.9.rc1

