Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab1FGWgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:36:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43650 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752100Ab1FGWgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:36:22 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Properly register dummy regulator driver
Date: Tue,  7 Jun 2011 23:36:18 +0100
Message-Id: <1307486178-29718-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent changes in the driver core appear to mean that the data structures
for the driver core are not fully initialised unless the driver is bound.
Make sure the driver core knows the dummy driver is in use by binding it
to a driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/dummy.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/dummy.c b/drivers/regulator/dummy.c
index c7410bd..f6ef669 100644
--- a/drivers/regulator/dummy.c
+++ b/drivers/regulator/dummy.c
@@ -36,6 +36,29 @@ static struct regulator_desc dummy_desc = {
 	.ops = &dummy_ops,
 };
 
+static int __devinit dummy_regulator_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	dummy_regulator_rdev = regulator_register(&dummy_desc, NULL,
+						  &dummy_initdata, NULL);
+	if (IS_ERR(dummy_regulator_rdev)) {
+		ret = PTR_ERR(dummy_regulator_rdev);
+		pr_err("Failed to register regulator: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct platform_driver dummy_regulator_driver = {
+	.probe		= dummy_regulator_probe,
+	.driver		= {
+		.name		= "reg-dummy",
+		.owner		= THIS_MODULE,
+	},
+};
+
 static struct platform_device *dummy_pdev;
 
 void __init regulator_dummy_init(void)
@@ -55,12 +78,9 @@ void __init regulator_dummy_init(void)
 		return;
 	}
 
-	dummy_regulator_rdev = regulator_register(&dummy_desc, NULL,
-						  &dummy_initdata, NULL);
-	if (IS_ERR(dummy_regulator_rdev)) {
-		ret = PTR_ERR(dummy_regulator_rdev);
-		pr_err("Failed to register regulator: %d\n", ret);
+	ret = platform_driver_register(&dummy_regulator_driver);
+	if (ret != 0) {
+		pr_err("Failed to register dummy regulator driver: %d\n", ret);
 		platform_device_unregister(dummy_pdev);
-		return;
 	}
 }
-- 
1.7.5.3

