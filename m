Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab1L1Rki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 12:40:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42729 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332Ab1L1Rkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 12:40:36 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Jin Park <jinyoungp@nvidia.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert aat2870 to dev_pm_ops
Date: Wed, 28 Dec 2011 17:40:28 +0000
Message-Id: <1325094028-8501-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C suspend and resume functions have been deprecated since the driver
was introduced.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/aat2870-core.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
index e6da563..3aa36eb 100644
--- a/drivers/mfd/aat2870-core.c
+++ b/drivers/mfd/aat2870-core.c
@@ -468,9 +468,10 @@ static int aat2870_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int aat2870_i2c_suspend(struct i2c_client *client, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int aat2870_i2c_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct aat2870_data *aat2870 = i2c_get_clientdata(client);
 
 	aat2870_disable(aat2870);
@@ -478,8 +479,9 @@ static int aat2870_i2c_suspend(struct i2c_client *client, pm_message_t state)
 	return 0;
 }
 
-static int aat2870_i2c_resume(struct i2c_client *client)
+static int aat2870_i2c_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct aat2870_data *aat2870 = i2c_get_clientdata(client);
 	struct aat2870_register *reg = NULL;
 	int i;
@@ -495,10 +497,10 @@ static int aat2870_i2c_resume(struct i2c_client *client)
 
 	return 0;
 }
-#else
-#define aat2870_i2c_suspend	NULL
-#define aat2870_i2c_resume	NULL
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
+
+static SIMPLE_DEV_PM_OPS(aat2870_pm_ops, aat2870_i2c_suspend,
+			 aat2870_i2c_resume);
 
 static const struct i2c_device_id aat2870_i2c_id_table[] = {
 	{ "aat2870", 0 },
@@ -510,11 +512,10 @@ static struct i2c_driver aat2870_i2c_driver = {
 	.driver = {
 		.name	= "aat2870",
 		.owner	= THIS_MODULE,
+		.pm	= &aat2870_pm_ops,
 	},
 	.probe		= aat2870_i2c_probe,
 	.remove		= aat2870_i2c_remove,
-	.suspend	= aat2870_i2c_suspend,
-	.resume		= aat2870_i2c_resume,
 	.id_table	= aat2870_i2c_id_table,
 };
 
-- 
1.7.7.3

