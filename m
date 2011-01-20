Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab1ATVgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:36:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58368 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755004Ab1ATVgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:36:20 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kim Kyuwon <q1.kim@samsung.com>, Kim Kyuwon <chammoru@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] leds: Convert bd2802 driver to dev_pm_ops
Date: Thu, 20 Jan 2011 21:36:35 +0000
Message-Id: <1295559395-28942-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a move to deprecate bus-specific PM operations and move to
using dev_pm_ops instead in order to reduce the amount of boilerplate
code in buses and facilitiate updates to the PM core. Do this move for
the bs2802 driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/leds/leds-bd2802.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index 19dc4b6..22152a2 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -19,7 +19,7 @@
 #include <linux/leds.h>
 #include <linux/leds-bd2802.h>
 #include <linux/slab.h>
-
+#include <linux/pm.h>
 
 #define LED_CTL(rgb2en, rgb1en) ((rgb2en) << 4 | ((rgb1en) << 0))
 
@@ -761,8 +761,9 @@ static int __exit bd2802_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int bd2802_suspend(struct i2c_client *client, pm_message_t mesg)
+static int bd2802_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct bd2802_led *led = i2c_get_clientdata(client);
 
 	gpio_set_value(led->pdata->reset_gpio, 0);
@@ -770,8 +771,9 @@ static int bd2802_suspend(struct i2c_client *client, pm_message_t mesg)
 	return 0;
 }
 
-static int bd2802_resume(struct i2c_client *client)
+static int bd2802_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct bd2802_led *led = i2c_get_clientdata(client);
 
 	if (!bd2802_is_all_off(led) || led->adf_on) {
@@ -782,6 +784,8 @@ static int bd2802_resume(struct i2c_client *client)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(bd2802_pm, bd2802_suspend, bd2802_resume);
+
 static const struct i2c_device_id bd2802_id[] = {
 	{ "BD2802", 0 },
 	{ }
@@ -791,11 +795,10 @@ MODULE_DEVICE_TABLE(i2c, bd2802_id);
 static struct i2c_driver bd2802_i2c_driver = {
 	.driver	= {
 		.name	= "BD2802",
+		.pm	= &bd2802_pm,
 	},
 	.probe		= bd2802_probe,
 	.remove		= __exit_p(bd2802_remove),
-	.suspend	= bd2802_suspend,
-	.resume		= bd2802_resume,
 	.id_table	= bd2802_id,
 };
 
-- 
1.7.2.3

