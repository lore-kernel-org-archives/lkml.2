Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2C0FAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 01:00:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:23872 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab2C0FAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 01:00:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="125461545"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] max17042_battery: add suspend/resume hooks
Date: Tue, 27 Mar 2012 02:23:40 +0530
Message-Id: <1332795220-8343-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds suspend/resume methods to the driver.

In suspend method irq line is disabled to avoid i2c
read/write errors from the interrupt handler as the
i2c bus itself could be in suspend state.
In resume function irq  line will be re-enabled.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/max17042_battery.c |   41 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index d4868c5..cf5c855 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -28,6 +28,7 @@
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/pm.h>
 #include <linux/mod_devicetable.h>
 #include <linux/power_supply.h>
 #include <linux/power/max17042_battery.h>
@@ -728,6 +729,40 @@ static int __devexit max17042_remove(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int max17042_suspend(struct device *dev)
+{
+	struct max17042_chip *chip = dev_get_drvdata(dev);
+
+	/* disable the irq and enable irq_wake
+	 * capability to the interrupt line.
+	 */
+	if (chip->client->irq) {
+		disable_irq(chip->client->irq);
+		enable_irq_wake(chip->client->irq);
+	}
+
+	return 0;
+}
+
+static int max17042_resume(struct device *dev)
+{
+	struct max17042_chip *chip = dev_get_drvdata(dev);
+
+	if (chip->client->irq) {
+		disable_irq_wake(chip->client->irq);
+		enable_irq(chip->client->irq);
+		/* re-program the SOC thresholds to 1% change */
+		max17042_set_soc_threshold(chip, 1);
+	}
+
+	return 0;
+}
+#else
+#define max17042_suspend NULL
+#define max17042_resume NULL
+#endif
+
 #ifdef CONFIG_OF
 static const struct of_device_id max17042_dt_match[] = {
 	{ .compatible = "maxim,max17042" },
@@ -742,10 +777,16 @@ static const struct i2c_device_id max17042_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, max17042_id);
 
+static const struct dev_pm_ops max17042_pm_ops = {
+	.suspend		= max17042_suspend,
+	.resume			= max17042_resume,
+};
+
 static struct i2c_driver max17042_i2c_driver = {
 	.driver	= {
 		.name	= "max17042",
 		.of_match_table = of_match_ptr(max17042_dt_match),
+		.pm	= &max17042_pm_ops,
 	},
 	.probe		= max17042_probe,
 	.remove		= __devexit_p(max17042_remove),
-- 
1.7.0.4

