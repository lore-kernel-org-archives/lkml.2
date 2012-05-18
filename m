Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658Ab2ERIji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:39:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53297 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933617Ab2ERIje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:39:34 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/16] regulator: Enable Device Tree for the db8500-prcmu regulator driver
Date: Fri, 18 May 2012 09:39:06 +0100
Message-Id: <1337330355-17747-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337330355-17747-1-git-send-email-lee.jones@linaro.org>
References: <1337330355-17747-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we use the previous regulator register code separated from probe to
register each of the regulators mentioned in Device Tree.

Cc: linux-kernel@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/db8500-prcmu.c |   76 ++++++++++++++++++++++++++++++++++----
 1 file changed, 69 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/db8500-prcmu.c b/drivers/regulator/db8500-prcmu.c
index d6b4d4c..968f97f 100644
--- a/drivers/regulator/db8500-prcmu.c
+++ b/drivers/regulator/db8500-prcmu.c
@@ -17,6 +17,8 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/db8500-prcmu.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/of.h>
 #include <linux/module.h>
 #include "dbx500-prcmu.h"
 
@@ -449,23 +451,77 @@ static __devinit int db8500_regulator_register(struct platform_device *pdev,
 	return 0;
 }
 
+static struct of_regulator_match db8500_regulator_matches[] = {
+	{ .name	= "db8500-vape",          .driver_data = (void *) DB8500_REGULATOR_VAPE, },
+	{ .name	= "db8500-varm",          .driver_data = (void *) DB8500_REGULATOR_VARM, },
+	{ .name	= "db8500-vmodem",        .driver_data = (void *) DB8500_REGULATOR_VMODEM, },
+	{ .name	= "db8500-vpll",          .driver_data = (void *) DB8500_REGULATOR_VPLL, },
+	{ .name	= "db8500-vsmps1",        .driver_data = (void *) DB8500_REGULATOR_VSMPS1, },
+	{ .name	= "db8500-vsmps2",        .driver_data = (void *) DB8500_REGULATOR_VSMPS2, },
+	{ .name	= "db8500-vsmps3",        .driver_data = (void *) DB8500_REGULATOR_VSMPS3, },
+	{ .name	= "db8500-vrf1",          .driver_data = (void *) DB8500_REGULATOR_VRF1, },
+	{ .name	= "db8500-sva-mmdsp",     .driver_data = (void *) DB8500_REGULATOR_SWITCH_SVAMMDSP, },
+	{ .name	= "db8500-sva-mmdsp-ret", .driver_data = (void *) DB8500_REGULATOR_SWITCH_SVAMMDSPRET, },
+	{ .name	= "db8500-sva-pipe",      .driver_data = (void *) DB8500_REGULATOR_SWITCH_SVAPIPE, },
+	{ .name	= "db8500-sia-mmdsp",     .driver_data = (void *) DB8500_REGULATOR_SWITCH_SIAMMDSP, },
+	{ .name	= "db8500-sia-mmdsp-ret", .driver_data = (void *) DB8500_REGULATOR_SWITCH_SIAMMDSPRET, },
+	{ .name	= "db8500-sia-pipe",      .driver_data = (void *) DB8500_REGULATOR_SWITCH_SIAPIPE, },
+	{ .name	= "db8500-sga",           .driver_data = (void *) DB8500_REGULATOR_SWITCH_SGA, },
+	{ .name	= "db8500-b2r2-mcde",     .driver_data = (void *) DB8500_REGULATOR_SWITCH_B2R2_MCDE, },
+	{ .name	= "db8500-esram12",       .driver_data = (void *) DB8500_REGULATOR_SWITCH_ESRAM12, },
+	{ .name	= "db8500-esram12-ret",   .driver_data = (void *) DB8500_REGULATOR_SWITCH_ESRAM12RET, },
+	{ .name	= "db8500-esram34",       .driver_data = (void *) DB8500_REGULATOR_SWITCH_ESRAM34, },
+	{ .name	= "db8500-esram34-ret",   .driver_data = (void *) DB8500_REGULATOR_SWITCH_ESRAM34RET, },
+};
+
+static __devinit int
+db8500_regulator_of_probe(struct platform_device *pdev,
+			struct device_node *np)
+{
+	int i, err;
+
+	for (i = 0; i < ARRAY_SIZE(dbx500_regulator_info); i++) {
+		err = db8500_regulator_register(
+			pdev, db8500_regulator_matches[i].init_data,
+			i, db8500_regulator_matches[i].of_node);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int __devinit db8500_regulator_probe(struct platform_device *pdev)
 {
 	struct regulator_init_data *db8500_init_data =
 					dev_get_platdata(&pdev->dev);
+	struct device_node *np = pdev->dev.of_node;
 	int i, err;
 
 	/* register all regulators */
-	for (i = 0; i < ARRAY_SIZE(dbx500_regulator_info); i++) {
-		err = db8500_regulator_register(pdev,
-						&db8500_init_data[i],
-						i, NULL);
-		if (err)
+	if (np) {
+		err = of_regulator_match(&pdev->dev, np,
+					db8500_regulator_matches,
+					ARRAY_SIZE(db8500_regulator_matches));
+		if (err < 0) {
+			dev_err(&pdev->dev,
+				"Error parsing regulator init data: %d\n", err);
 			return err;
+		}
 
-		dev_dbg(rdev_get_dev(info->rdev),
-			"regulator-%s-probed\n", info->desc.name);
+		err = db8500_regulator_of_probe(pdev, np);
+		if (err)
+			return err;
+	} else {
+		for (i = 0; i < ARRAY_SIZE(dbx500_regulator_info); i++) {
+			err = db8500_regulator_register(pdev,
+							&db8500_init_data[i],
+							i, NULL);
+			if (err)
+				return err;
+		}
 	}
+
 	err = ux500_regulator_debug_init(pdev,
 					 dbx500_regulator_info,
 					 ARRAY_SIZE(dbx500_regulator_info));
@@ -491,10 +547,16 @@ static int __exit db8500_regulator_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id db8500_prcmu_regulator_match[] = {
+        { .compatible = "stericsson,db8500-prcmu-regulator", },
+        {}
+};
+
 static struct platform_driver db8500_regulator_driver = {
 	.driver = {
 		.name = "db8500-prcmu-regulators",
 		.owner = THIS_MODULE,
+		.of_match_table = db8500_prcmu_regulator_match,
 	},
 	.probe = db8500_regulator_probe,
 	.remove = __exit_p(db8500_regulator_remove),
-- 
1.7.9.5

