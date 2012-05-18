Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab2ERIje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:39:34 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53297 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab2ERIja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:39:30 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/16] regulator: db8500-prcmu: Separate regulator registration from probe
Date: Fri, 18 May 2012 09:39:04 +0100
Message-Id: <1337330355-17747-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337330355-17747-1-git-send-email-lee.jones@linaro.org>
References: <1337330355-17747-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will provide us with a convenient way to register regulators when
booting with Device Tree both enabled & disabled and will save us a
great deal of code duplication in time.

Cc: linux-kernel@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/db8500-prcmu.c |   71 +++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/db8500-prcmu.c b/drivers/regulator/db8500-prcmu.c
index 87b2e83..d6b4d4c 100644
--- a/drivers/regulator/db8500-prcmu.c
+++ b/drivers/regulator/db8500-prcmu.c
@@ -410,40 +410,58 @@ dbx500_regulator_info[DB8500_NUM_REGULATORS] = {
 	},
 };
 
+static __devinit int db8500_regulator_register(struct platform_device *pdev,
+					struct regulator_init_data *init_data,
+					int id,
+					struct device_node *np)
+{
+	struct dbx500_regulator_info *info;
+	struct regulator_config config = { };
+	int err;
+
+	/* assign per-regulator data */
+	info = &dbx500_regulator_info[id];
+	info->dev = &pdev->dev;
+
+	config.dev = &pdev->dev;
+	config.init_data = init_data;
+	config.driver_data = info;
+	config.of_node = np;
+
+	/* register with the regulator framework */
+	info->rdev = regulator_register(&info->desc, &config);
+	if (IS_ERR(info->rdev)) {
+		err = PTR_ERR(info->rdev);
+		dev_err(&pdev->dev, "failed to register %s: err %i\n",
+			info->desc.name, err);
+
+		/* if failing, unregister all earlier regulators */
+		while (--id >= 0) {
+			info = &dbx500_regulator_info[id];
+			regulator_unregister(info->rdev);
+		}
+		return err;
+	}
+
+	dev_dbg(rdev_get_dev(info->rdev),
+		"regulator-%s-probed\n", info->desc.name);
+
+	return 0;
+}
+
 static int __devinit db8500_regulator_probe(struct platform_device *pdev)
 {
 	struct regulator_init_data *db8500_init_data =
 					dev_get_platdata(&pdev->dev);
-	struct regulator_config config = { };
 	int i, err;
 
 	/* register all regulators */
 	for (i = 0; i < ARRAY_SIZE(dbx500_regulator_info); i++) {
-		struct dbx500_regulator_info *info;
-		struct regulator_init_data *init_data = &db8500_init_data[i];
-
-		/* assign per-regulator data */
-		info = &dbx500_regulator_info[i];
-		info->dev = &pdev->dev;
-
-		config.dev = &pdev->dev;
-		config.init_data = init_data;
-		config.driver_data = info;
-
-		/* register with the regulator framework */
-		info->rdev = regulator_register(&info->desc, &config);
-		if (IS_ERR(info->rdev)) {
-			err = PTR_ERR(info->rdev);
-			dev_err(&pdev->dev, "failed to register %s: err %i\n",
-				info->desc.name, err);
-
-			/* if failing, unregister all earlier regulators */
-			while (--i >= 0) {
-				info = &dbx500_regulator_info[i];
-				regulator_unregister(info->rdev);
-			}
+		err = db8500_regulator_register(pdev,
+						&db8500_init_data[i],
+						i, NULL);
+		if (err)
 			return err;
-		}
 
 		dev_dbg(rdev_get_dev(info->rdev),
 			"regulator-%s-probed\n", info->desc.name);
@@ -451,8 +469,7 @@ static int __devinit db8500_regulator_probe(struct platform_device *pdev)
 	err = ux500_regulator_debug_init(pdev,
 					 dbx500_regulator_info,
 					 ARRAY_SIZE(dbx500_regulator_info));
-
-	return err;
+	return 0;
 }
 
 static int __exit db8500_regulator_remove(struct platform_device *pdev)
-- 
1.7.9.5

