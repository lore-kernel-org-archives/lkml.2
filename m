Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1ESXBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:01:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8725 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab1ESXBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:01:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 19 May 2011 16:01:34 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: cbouatmailru@gmail.com
Cc: bleung@google.com, olof@lixom.net, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 1/2] power: bq20z75: support external notification
Date: Thu, 19 May 2011 16:00:03 -0700
Message-Id: <1305846004-11895-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for external power change notification. One problem found
is that there is a lag time before the sensor will return a new status. To
ensure that we only fire off the power_supply_changed event when the status
returned from the sensor is actually different, we delay sending the
the notification, and instead poll on it looking for a change. The amount
of time to poll is configurable via platform data.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/bq20z75.c       |  103 +++++++++++++++++++++++++++++++++++++----
 include/linux/power/bq20z75.h |    3 +
 2 files changed, 97 insertions(+), 9 deletions(-)

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index 506585e..9c5e5be 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -152,6 +152,10 @@ struct bq20z75_info {
 	bool				gpio_detect;
 	bool				enable_detection;
 	int				irq;
+	int				last_state;
+	int				poll_time;
+	struct delayed_work		work;
+	int				ignore_changes;
 };
 
 static int bq20z75_read_word_data(struct i2c_client *client, u8 address)
@@ -279,6 +283,7 @@ static int bq20z75_get_battery_property(struct i2c_client *client,
 	int reg_offset, enum power_supply_property psp,
 	union power_supply_propval *val)
 {
+	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
 	s32 ret;
 
 	ret = bq20z75_read_word_data(client,
@@ -293,15 +298,24 @@ static int bq20z75_get_battery_property(struct i2c_client *client,
 	if (ret >= bq20z75_data[reg_offset].min_value &&
 	    ret <= bq20z75_data[reg_offset].max_value) {
 		val->intval = ret;
-		if (psp == POWER_SUPPLY_PROP_STATUS) {
-			if (ret & BATTERY_FULL_CHARGED)
-				val->intval = POWER_SUPPLY_STATUS_FULL;
-			else if (ret & BATTERY_FULL_DISCHARGED)
-				val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
-			else if (ret & BATTERY_DISCHARGING)
-				val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
-			else
-				val->intval = POWER_SUPPLY_STATUS_CHARGING;
+		if (psp != POWER_SUPPLY_PROP_STATUS)
+			return 0;
+
+		if (ret & BATTERY_FULL_CHARGED)
+			val->intval = POWER_SUPPLY_STATUS_FULL;
+		else if (ret & BATTERY_FULL_DISCHARGED)
+			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+		else if (ret & BATTERY_DISCHARGING)
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		else
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+
+		if (bq20z75_device->poll_time == 0)
+			bq20z75_device->last_state = val->intval;
+		else if (bq20z75_device->last_state != val->intval) {
+			cancel_delayed_work_sync(&bq20z75_device->work);
+			power_supply_changed(&bq20z75_device->power_supply);
+			bq20z75_device->poll_time = 0;
 		}
 	} else {
 		if (psp == POWER_SUPPLY_PROP_STATUS)
@@ -545,6 +559,60 @@ static irqreturn_t bq20z75_irq(int irq, void *devid)
 	return IRQ_HANDLED;
 }
 
+static void bq20z75_external_power_changed(struct power_supply *psy)
+{
+	struct bq20z75_info *bq20z75_device;
+
+	bq20z75_device = container_of(psy, struct bq20z75_info, power_supply);
+
+	if (bq20z75_device->ignore_changes > 0) {
+		bq20z75_device->ignore_changes--;
+		return;
+	}
+
+	/* cancel outstanding work */
+	cancel_delayed_work_sync(&bq20z75_device->work);
+
+	schedule_delayed_work(&bq20z75_device->work, HZ);
+	bq20z75_device->poll_time = bq20z75_device->pdata->poll_retry_count;
+}
+
+static void bq20z75_delayed_work(struct work_struct *work)
+{
+	struct bq20z75_info *bq20z75_device;
+	s32 ret;
+
+	bq20z75_device = container_of(work, struct bq20z75_info, work.work);
+
+	ret = bq20z75_read_word_data(bq20z75_device->client,
+				     bq20z75_data[REG_STATUS].addr);
+	/* if the read failed, give up on this work */
+	if (ret < 0) {
+		bq20z75_device->poll_time = 0;
+		return;
+	}
+
+	if (ret & BATTERY_FULL_CHARGED)
+		ret = POWER_SUPPLY_STATUS_FULL;
+	else if (ret & BATTERY_FULL_DISCHARGED)
+		ret = POWER_SUPPLY_STATUS_NOT_CHARGING;
+	else if (ret & BATTERY_DISCHARGING)
+		ret = POWER_SUPPLY_STATUS_DISCHARGING;
+	else
+		ret = POWER_SUPPLY_STATUS_CHARGING;
+
+	if (bq20z75_device->last_state != ret) {
+		bq20z75_device->poll_time = 0;
+		power_supply_changed(&bq20z75_device->power_supply);
+		return;
+	}
+	if (bq20z75_device->poll_time > 0) {
+		schedule_delayed_work(&bq20z75_device->work, HZ);
+		bq20z75_device->poll_time--;
+		return;
+	}
+}
+
 static int __devinit bq20z75_probe(struct i2c_client *client,
 	const struct i2c_device_id *id)
 {
@@ -566,6 +634,13 @@ static int __devinit bq20z75_probe(struct i2c_client *client,
 	bq20z75_device->power_supply.num_properties =
 		ARRAY_SIZE(bq20z75_properties);
 	bq20z75_device->power_supply.get_property = bq20z75_get_property;
+	/* ignore first notification of external change, it is generated
+	 * from the power_supply_register call back
+	 */
+	bq20z75_device->ignore_changes = 1;
+	bq20z75_device->last_state = POWER_SUPPLY_STATUS_UNKNOWN;
+	bq20z75_device->power_supply.external_power_changed =
+		bq20z75_external_power_changed;
 
 	if (pdata) {
 		bq20z75_device->gpio_detect =
@@ -625,6 +700,10 @@ skip_gpio:
 	dev_info(&client->dev,
 		"%s: battery gas gauge device registered\n", client->name);
 
+	INIT_DELAYED_WORK(&bq20z75_device->work, bq20z75_delayed_work);
+
+	bq20z75_device->enable_detection = true;
+
 	return 0;
 
 exit_psupply:
@@ -648,6 +727,9 @@ static int __devexit bq20z75_remove(struct i2c_client *client)
 		gpio_free(bq20z75_device->pdata->battery_detect);
 
 	power_supply_unregister(&bq20z75_device->power_supply);
+
+	cancel_delayed_work_sync(&bq20z75_device->work);
+
 	kfree(bq20z75_device);
 	bq20z75_device = NULL;
 
@@ -661,6 +743,9 @@ static int bq20z75_suspend(struct i2c_client *client,
 	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
 	s32 ret;
 
+	if (bq20z75_device->poll_time > 0)
+		cancel_delayed_work_sync(&bq20z75_device->work);
+
 	/* write to manufacturer access with sleep command */
 	ret = bq20z75_write_word_data(client,
 		bq20z75_data[REG_MANUFACTURER_DATA].addr,
diff --git a/include/linux/power/bq20z75.h b/include/linux/power/bq20z75.h
index b0843b6..1398eb0 100644
--- a/include/linux/power/bq20z75.h
+++ b/include/linux/power/bq20z75.h
@@ -29,11 +29,14 @@
  * @battery_detect:		GPIO which is used to detect battery presence
  * @battery_detect_present:	gpio state when battery is present (0 / 1)
  * @i2c_retry_count:		# of times to retry on i2c IO failure
+ * @poll_retry_count:		# of times to retry looking for new status after
+ *				external change notification
  */
 struct bq20z75_platform_data {
 	int battery_detect;
 	int battery_detect_present;
 	int i2c_retry_count;
+	int poll_retry_count;
 };
 
 #endif
-- 
1.7.5.1

