Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1BVGoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 01:44:16 -0500
Received: from smtp-out-090.synserver.de ([212.40.185.90]:1107 "EHLO
	smtp-out-090.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab1BVGmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 01:42:49 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 18504
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Pali Rohar <pali.rohar@gmail.com>, Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v3 10/16] bq27x00: Poll battery state
Date: Tue, 22 Feb 2011 07:37:55 +0100
Message-Id: <1298356681-8317-11-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298356681-8317-1-git-send-email-lars@metafoo.de>
References: <1298356681-8317-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for polling the battery state and generating a
power_supply_changed() event if it has changed.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Tested-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/power/bq27x00_battery.c |   58 +++++++++++++++++++++++++++++++++++---
 1 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index dbe3fcb..25350fc 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -74,10 +74,13 @@ struct bq27x00_device_info {
 
 	struct bq27x00_reg_cache cache;
 	unsigned long last_update;
+	struct delayed_work work;
 
 	struct power_supply	bat;
 
 	struct bq27x00_access_methods bus;
+
+	struct mutex lock;
 };
 
 static enum power_supply_property bq27x00_battery_props[] = {
@@ -93,6 +96,11 @@ static enum power_supply_property bq27x00_battery_props[] = {
 	POWER_SUPPLY_PROP_TECHNOLOGY,
 };
 
+static unsigned int poll_interval = 360;
+module_param(poll_interval, uint, 0644);
+MODULE_PARM_DESC(poll_interval, "battery poll interval in seconds - " \
+				"0 disables polling");
+
 /*
  * Common code for BQ27x00 devices
  */
@@ -169,6 +177,21 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 	di->last_update = jiffies;
 }
 
+static void bq27x00_battery_poll(struct work_struct *work)
+{
+	struct bq27x00_device_info *di =
+		container_of(work, struct bq27x00_device_info, work.work);
+
+	bq27x00_update(di);
+
+	if (poll_interval > 0) {
+		/* The timer does not have to be accurate. */
+		set_timer_slack(&di->work.timer, poll_interval * HZ / 4);
+		schedule_delayed_work(&di->work, poll_interval * HZ);
+	}
+}
+
+
 /*
  * Return the battery temperature in tenths of degree Celsius
  * Or < 0 if something fails.
@@ -283,8 +306,12 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 	int ret = 0;
 	struct bq27x00_device_info *di = to_bq27x00_device_info(psy);
 
-	if (time_is_before_jiffies(di->last_update + 5 * HZ))
-		bq27x00_update(di);
+	mutex_lock(&di->lock);
+	if (time_is_before_jiffies(di->last_update + 5 * HZ)) {
+		cancel_delayed_work_sync(&di->work);
+		bq27x00_battery_poll(&di->work.work);
+	}
+	mutex_unlock(&di->lock);
 
 	if (psp != POWER_SUPPLY_PROP_PRESENT && di->cache.flags < 0)
 		return -ENODEV;
@@ -327,6 +354,14 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 	return ret;
 }
 
+static void bq27x00_external_power_changed(struct power_supply *psy)
+{
+	struct bq27x00_device_info *di = to_bq27x00_device_info(psy);
+
+	cancel_delayed_work_sync(&di->work);
+	schedule_delayed_work(&di->work, 0);
+}
+
 static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 {
 	int ret;
@@ -335,7 +370,10 @@ static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 	di->bat.properties = bq27x00_battery_props;
 	di->bat.num_properties = ARRAY_SIZE(bq27x00_battery_props);
 	di->bat.get_property = bq27x00_battery_get_property;
-	di->bat.external_power_changed = NULL;
+	di->bat.external_power_changed = bq27x00_external_power_changed;
+
+	INIT_DELAYED_WORK(&di->work, bq27x00_battery_poll);
+	mutex_init(&di->lock);
 
 	ret = power_supply_register(di->dev, &di->bat);
 	if (ret) {
@@ -350,6 +388,15 @@ static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 	return 0;
 }
 
+static void bq27x00_powersupply_unregister(struct bq27x00_device_info *di)
+{
+	cancel_delayed_work_sync(&di->work);
+
+	power_supply_unregister(&di->bat);
+
+	mutex_destroy(&di->lock);
+}
+
 
 /* i2c specific code */
 #ifdef CONFIG_BATTERY_BQ27X00_I2C
@@ -457,7 +504,7 @@ static int bq27x00_battery_remove(struct i2c_client *client)
 {
 	struct bq27x00_device_info *di = i2c_get_clientdata(client);
 
-	power_supply_unregister(&di->bat);
+	bq27x00_powersupply_unregister(di);
 
 	kfree(di->bat.name);
 
@@ -590,7 +637,8 @@ static int __devexit bq27000_battery_remove(struct platform_device *pdev)
 {
 	struct bq27x00_device_info *di = platform_get_drvdata(pdev);
 
-	power_supply_unregister(&di->bat);
+	bq27x00_powersupply_unregister(di);
+
 	platform_set_drvdata(pdev, NULL);
 	kfree(di);
 
-- 
1.7.2.3

