Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab1ATVw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:52:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46383 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755319Ab1ATVw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:52:26 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert pcf50633 to dev_pm_ops
Date: Thu, 20 Jan 2011 21:52:42 +0000
Message-Id: <1295560362-6693-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a move to deprecate bus-specific PM operations and move to
using dev_pm_ops instead in order to reduce the amount of boilerplate
code in buses and facilitiate updates to the PM core. Do this move for
the pcf50633 driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/pcf50633-core.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 501ce13..2640e4d 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -21,6 +21,7 @@
 #include <linux/workqueue.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
+#include <linux/pm.h>
 #include <linux/slab.h>
 
 #include <linux/mfd/pcf50633/core.h>
@@ -230,27 +231,26 @@ pcf50633_client_dev_register(struct pcf50633 *pcf, const char *name,
 	}
 }
 
-#ifdef CONFIG_PM
-static int pcf50633_suspend(struct i2c_client *client, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int pcf50633_suspend(struct device *dev)
 {
-	struct pcf50633 *pcf;
-	pcf = i2c_get_clientdata(client);
+	struct i2c_client *client = to_i2c_client(dev);
+	struct pcf50633 *pcf = i2c_get_clientdata(client);
 
 	return pcf50633_irq_suspend(pcf);
 }
 
-static int pcf50633_resume(struct i2c_client *client)
+static int pcf50633_resume(struct device *dev)
 {
-	struct pcf50633 *pcf;
-	pcf = i2c_get_clientdata(client);
+	struct i2c_client *client = to_i2c_client(dev);
+	struct pcf50633 *pcf = i2c_get_clientdata(client);
 
 	return pcf50633_irq_resume(pcf);
 }
-#else
-#define pcf50633_suspend NULL
-#define pcf50633_resume NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(pcf50633_pm, pcf50633_suspend, pcf50633_resume);
+
 static int __devinit pcf50633_probe(struct i2c_client *client,
 				const struct i2c_device_id *ids)
 {
@@ -364,12 +364,11 @@ static struct i2c_device_id pcf50633_id_table[] = {
 static struct i2c_driver pcf50633_driver = {
 	.driver = {
 		.name	= "pcf50633",
+		.pm	= &pcf50633_pm,
 	},
 	.id_table = pcf50633_id_table,
 	.probe = pcf50633_probe,
 	.remove = __devexit_p(pcf50633_remove),
-	.suspend = pcf50633_suspend,
-	.resume	= pcf50633_resume,
 };
 
 static int __init pcf50633_init(void)
-- 
1.7.2.3

