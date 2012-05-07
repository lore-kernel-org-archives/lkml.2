Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2EGJDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 05:03:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60730 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755960Ab2EGJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 05:03:37 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/7] mfd: tps65090: Don't use I2C-specific suspend and resume operations
Date: Mon,  7 May 2012 10:03:18 +0100
Message-Id: <1336381403-7840-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336381403-7840-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336381403-7840-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy suspend operations have been deprecated and printing warnings
on boot for over a year now.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/mfd/tps65090.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 4d60556..781df42 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -324,21 +324,27 @@ static int __devexit tps65090_i2c_remove(struct i2c_client *client)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int tps65090_i2c_suspend(struct i2c_client *client, pm_message_t state)
+static int tps65090_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	if (client->irq)
 		disable_irq(client->irq);
 	return 0;
 }
 
-static int tps65090_i2c_resume(struct i2c_client *client)
+static int tps65090_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	if (client->irq)
 		enable_irq(client->irq);
 	return 0;
 }
 #endif
 
+static const struct dev_pm_ops tps65090_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(tps65090_suspend, tps65090_resume)
+};
+
 static const struct i2c_device_id tps65090_id_table[] = {
 	{ "tps65090", 0 },
 	{ },
@@ -349,13 +355,10 @@ static struct i2c_driver tps65090_driver = {
 	.driver	= {
 		.name	= "tps65090",
 		.owner	= THIS_MODULE,
+		.pm	= &tps65090_pm_ops,
 	},
 	.probe		= tps65090_i2c_probe,
 	.remove		= __devexit_p(tps65090_i2c_remove),
-#ifdef CONFIG_PM_SLEEP
-	.suspend	= tps65090_i2c_suspend,
-	.resume		= tps65090_i2c_resume,
-#endif
 	.id_table	= tps65090_id_table,
 };
 
-- 
1.7.10

