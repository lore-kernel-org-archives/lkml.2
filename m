Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1DOLE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 07:04:58 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3337 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab1DOLEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 07:04:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 15 Apr 2011 04:04:14 -0700
From: wni@nvidia.com
To: khali@linux-fr.org, guenter.roeck@ericsson.com
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, achew@nvidia.com, Wei Ni <wni@nvidia.com>
Subject: [PATCH 3/3] hwmon (lm90) Add alarm function for nct1008
Date: Fri, 15 Apr 2011 19:00:28 +0800
Message-Id: <1302865228-7185-4-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1302865228-7185-1-git-send-email-wni@nvidia.com>
References: <1302865228-7185-1-git-send-email-wni@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Ni <wni@nvidia.com>

This patch add alarm function for nct1008.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 drivers/hwmon/lm90.c    |   59 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/nct1008.h |    1 +
 2 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 8b639b0..11a0a9d 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -83,6 +83,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/interrupt.h>
 #include <linux/nct1008.h>
 
 /*
@@ -275,6 +276,8 @@ static const struct lm90_params lm90_params[] = {
 struct lm90_data {
 	struct device *hwmon_dev;
 	struct mutex update_lock;
+	struct work_struct work;
+	struct i2c_client *client;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
 	int kind;
@@ -308,6 +311,7 @@ struct lm90_data {
 			   7: remote 2 high limit (ma6695/96 only) */
 	u8 temp_hyst;
 	u16 alarms; /* bitvector (upper 8 bits for max6695/96) */
+	void (*alarm_fn)(int irq);
 };
 
 /*
@@ -1104,6 +1108,27 @@ static void lm90_disable(struct i2c_client *client)
 	i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, value);
 }
 
+static void lm90_work_func(struct work_struct *work)
+{
+	struct lm90_data *data = container_of(work, struct lm90_data, work);
+	int irq = data->client->irq;
+
+	mutex_lock(&data->update_lock);
+
+	if (data->alarm_fn)
+		data->alarm_fn(irq);
+
+	mutex_unlock(&data->update_lock);
+}
+
+static irqreturn_t lm90_irq(int irq, void *dev_id)
+{
+	struct lm90_data *data = dev_id;
+	schedule_work(&data->work);
+
+	return IRQ_HANDLED;
+}
+
 /* Return 0 if detection is successful, -ENODEV otherwise */
 static int lm90_detect(struct i2c_client *new_client,
 		       struct i2c_board_info *info)
@@ -1417,9 +1442,22 @@ static void lm90_configure_client(struct i2c_client *client)
 		/* THERM hysteresis */
 		value = pdata->hysteresis;
 		i2c_smbus_write_byte_data(client, LM90_REG_W_TCRIT_HYST, value);
+
+		data->alarm_fn = pdata->alarm_fn;
 	}
 }
 
+static int lm90_configure_irq(struct lm90_data *data)
+{
+	if (data->alarm_fn && data->client->irq) {
+		INIT_WORK(&data->work, lm90_work_func);
+		return request_irq(data->client->irq, lm90_irq,
+				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+				"lm90", data);
+	} else
+		return 0;
+}
+
 static int lm90_probe(struct i2c_client *new_client,
 		      const struct i2c_device_id *id)
 {
@@ -1432,6 +1470,7 @@ static int lm90_probe(struct i2c_client *new_client,
 		err = -ENOMEM;
 		goto exit;
 	}
+	data->client = new_client;
 	i2c_set_clientdata(new_client, data);
 	mutex_init(&data->update_lock);
 
@@ -1459,6 +1498,10 @@ static int lm90_probe(struct i2c_client *new_client,
 	if (new_client->dev.platform_data)
 		lm90_configure_client(new_client);
 
+	err = lm90_configure_irq(data);
+	if (err)
+		goto exit_free;
+
 	/* Register sysfs hooks */
 	err = sysfs_create_group(&new_client->dev.kobj, &lm90_group);
 	if (err)
@@ -1499,6 +1542,9 @@ static int lm90_probe(struct i2c_client *new_client,
 		goto exit_remove_files;
 	}
 
+	if (data->alarm_fn && client->irq)
+		schedule_work(&data->work);
+
 	return 0;
 
 exit_remove_files:
@@ -1513,6 +1559,8 @@ static int lm90_remove(struct i2c_client *client)
 {
 	struct lm90_data *data = i2c_get_clientdata(client);
 
+	if (data->alarm_fn && client->irq)
+		cancel_work_sync(&data->work);
 	hwmon_device_unregister(data->hwmon_dev);
 	lm90_remove_files(client, data);
 
@@ -1569,13 +1617,24 @@ static void lm90_alert(struct i2c_client *client, unsigned int flag)
 #ifdef CONFIG_PM
 static int lm90_suspend(struct i2c_client *client, pm_message_t state)
 {
+	if (client->irq)
+		disable_irq(client->irq);
 	lm90_disable(client);
+
 	return 0;
 }
 
 static int lm90_resume(struct i2c_client *client)
 {
+	struct lm90_data *data = i2c_get_clientdata(client);
+
 	lm90_enable(client);
+	if (client->irq) {
+		enable_irq(client->irq);
+		if (data->alarm_fn)
+			schedule_work(&data->work);
+	}
+
 	return 0;
 }
 #endif
diff --git a/include/linux/nct1008.h b/include/linux/nct1008.h
index 3a6ed69..8e36860 100644
--- a/include/linux/nct1008.h
+++ b/include/linux/nct1008.h
@@ -33,6 +33,7 @@ struct nct1008_platform_data {
 	long shutdown_ext_limit;
 	long shutdown_local_limit;
 	long throttle_ext_limit;
+	void (*alarm_fn)(int irq);
 };
 
 #endif /* _LINUX_NCT1008_H */
-- 
1.7.0

