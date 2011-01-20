Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1ATVpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:45:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55289 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755137Ab1ATVpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:45:33 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Michael Hennerich <michael.hennerich@analog.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert adp5520 to dev_pm_ops
Date: Thu, 20 Jan 2011 21:45:46 +0000
Message-Id: <1295559946-3947-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a move to deprecate bus-specific PM operations and move to
using dev_pm_ops instead in order to reduce the amount of boilerplate
code in buses and facilitiate updates to the PM core. Do this move for
the adp5520 driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/adp5520.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index 3122139..f1d8848 100644
--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -321,27 +321,27 @@ static int __devexit adp5520_remove(struct i2c_client *client)
 }
 
 #ifdef CONFIG_PM
-static int adp5520_suspend(struct i2c_client *client,
-				 pm_message_t state)
+static int adp5520_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
 
 	adp5520_clr_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
 	return 0;
 }
 
-static int adp5520_resume(struct i2c_client *client)
+static int adp5520_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
 
 	adp5520_set_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
 	return 0;
 }
-#else
-#define adp5520_suspend	NULL
-#define adp5520_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(adp5520_pm, adp5520_suspend, adp5520_resume);
+
 static const struct i2c_device_id adp5520_id[] = {
 	{ "pmic-adp5520", ID_ADP5520 },
 	{ "pmic-adp5501", ID_ADP5501 },
@@ -353,11 +353,10 @@ static struct i2c_driver adp5520_driver = {
 	.driver = {
 		.name	= "adp5520",
 		.owner	= THIS_MODULE,
+		.pm	= &adp5520_pm,
 	},
 	.probe		= adp5520_probe,
 	.remove		= __devexit_p(adp5520_remove),
-	.suspend	= adp5520_suspend,
-	.resume		= adp5520_resume,
 	.id_table 	= adp5520_id,
 };
 
-- 
1.7.2.3

