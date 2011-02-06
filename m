Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1BFTgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:36:47 -0500
Received: from smtp-out-015.synserver.de ([212.40.185.15]:1389 "HELO
	smtp-out-014.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753991Ab1BFTgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:36:45 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24265
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 05/14] POWER: bq27x00: Prepare code for addition of bq27000 platform driver
Date: Sun,  6 Feb 2011 01:48:02 +0100
Message-Id: <1296953291-10373-6-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296953291-10373-1-git-send-email-lars@metafoo.de>
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies the drivers data structure and moves code to be shared by
both init functions into a common function.
This patch has no functional changes, it only moves code around.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/bq27x00_battery.c |   86 +++++++++++++++++---------------------
 1 files changed, 39 insertions(+), 47 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 9f16666..eee0120 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -54,8 +54,8 @@ static DEFINE_MUTEX(battery_mutex);
 
 struct bq27x00_device_info;
 struct bq27x00_access_methods {
-	int (*read)(u8 reg, int *rt_value, int b_single,
-		struct bq27x00_device_info *di);
+	int (*read)(struct bq27x00_device_info *, u8 reg, int *rt_value,
+			bool single);
 };
 
 enum bq27x00_chip { BQ27000, BQ27500 };
@@ -63,11 +63,11 @@ enum bq27x00_chip { BQ27000, BQ27500 };
 struct bq27x00_device_info {
 	struct device 		*dev;
 	int			id;
-	struct bq27x00_access_methods	*bus;
-	struct power_supply	bat;
 	enum bq27x00_chip	chip;
 
-	struct i2c_client	*client;
+	struct power_supply	bat;
+
+	struct bq27x00_access_methods bus;
 };
 
 static enum power_supply_property bq27x00_battery_props[] = {
@@ -87,10 +87,10 @@ static enum power_supply_property bq27x00_battery_props[] = {
  * Common code for BQ27x00 devices
  */
 
-static int bq27x00_read(u8 reg, int *rt_value, int b_single,
-			struct bq27x00_device_info *di)
+static inline int bq27x00_read(struct bq27x00_device_info *di, u8 reg,
+		int *rt_value, bool single)
 {
-	return di->bus->read(reg, rt_value, b_single, di);
+	return di->bus.read(di, reg, rt_value, single);
 }
 
 /*
@@ -102,7 +102,7 @@ static int bq27x00_battery_temperature(struct bq27x00_device_info *di)
 	int ret;
 	int temp = 0;
 
-	ret = bq27x00_read(BQ27x00_REG_TEMP, &temp, 0, di);
+	ret = bq27x00_read(di, BQ27x00_REG_TEMP, &temp, false);
 	if (ret) {
 		dev_err(di->dev, "error reading temperature\n");
 		return ret;
@@ -123,7 +123,7 @@ static int bq27x00_battery_voltage(struct bq27x00_device_info *di)
 	int ret;
 	int volt = 0;
 
-	ret = bq27x00_read(BQ27x00_REG_VOLT, &volt, 0, di);
+	ret = bq27x00_read(di, BQ27x00_REG_VOLT, &volt, false);
 	if (ret) {
 		dev_err(di->dev, "error reading voltage\n");
 		return ret;
@@ -143,7 +143,7 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di)
 	int curr = 0;
 	int flags = 0;
 
-	ret = bq27x00_read(BQ27x00_REG_AI, &curr, 0, di);
+	ret = bq27x00_read(di, BQ27x00_REG_AI, &curr, false);
 	if (ret) {
 		dev_err(di->dev, "error reading current\n");
 		return 0;
@@ -153,7 +153,7 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di)
 		/* bq27500 returns signed value */
 		curr = (int)((s16)curr) * 1000;
 	} else {
-		ret = bq27x00_read(BQ27x00_REG_FLAGS, &flags, 0, di);
+		ret = bq27x00_read(di, BQ27x00_REG_FLAGS, &flags, false);
 		if (ret < 0) {
 			dev_err(di->dev, "error reading flags\n");
 			return 0;
@@ -178,9 +178,9 @@ static int bq27x00_battery_rsoc(struct bq27x00_device_info *di)
 	int rsoc = 0;
 
 	if (di->chip == BQ27500)
-		ret = bq27x00_read(BQ27500_REG_SOC, &rsoc, 0, di);
+		ret = bq27x00_read(di, BQ27500_REG_SOC, &rsoc, false);
 	else
-		ret = bq27x00_read(BQ27000_REG_RSOC, &rsoc, 1, di);
+		ret = bq27x00_read(di, BQ27000_REG_RSOC, &rsoc, true);
 	if (ret) {
 		dev_err(di->dev, "error reading relative State-of-Charge\n");
 		return ret;
@@ -196,7 +196,7 @@ static int bq27x00_battery_status(struct bq27x00_device_info *di,
 	int status;
 	int ret;
 
-	ret = bq27x00_read(BQ27x00_REG_FLAGS, &flags, 0, di);
+	ret = bq27x00_read(di, BQ27x00_REG_FLAGS, &flags, false);
 	if (ret < 0) {
 		dev_err(di->dev, "error reading flags\n");
 		return ret;
@@ -230,7 +230,7 @@ static int bq27x00_battery_time(struct bq27x00_device_info *di, int reg,
 	int tval = 0;
 	int ret;
 
-	ret = bq27x00_read(reg, &tval, 0, di);
+	ret = bq27x00_read(reg, &tval, false);
 	if (ret) {
 		dev_err(di->dev, "error reading register %02x\n", reg);
 		return ret;
@@ -296,23 +296,35 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 	return ret;
 }
 
-static void bq27x00_powersupply_init(struct bq27x00_device_info *di)
+static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 {
+	int ret;
+
 	di->bat.type = POWER_SUPPLY_TYPE_BATTERY;
 	di->bat.properties = bq27x00_battery_props;
 	di->bat.num_properties = ARRAY_SIZE(bq27x00_battery_props);
 	di->bat.get_property = bq27x00_battery_get_property;
 	di->bat.external_power_changed = NULL;
+
+	ret = power_supply_register(di->dev, &di->bat);
+	if (ret) {
+		dev_err(di->dev, "failed to register battery: %d\n", ret);
+		return ret;
+	}
+
+	dev_info(di->dev, "support ver. %s enabled\n", DRIVER_VERSION);
+
+	return 0;
 }
 
 /*
  * i2c specific code
  */
 
-static int bq27x00_read_i2c(u8 reg, int *rt_value, int b_single,
-			struct bq27x00_device_info *di)
+static int bq27x00_read_i2c(struct bq27x00_device_info *di, u8 reg,
+			int *rt_value, bool single)
 {
-	struct i2c_client *client = di->client;
+	struct i2c_client *client = to_i2c_client(di->dev);
 	struct i2c_msg msg[1];
 	unsigned char data[2];
 	int err;
@@ -329,7 +341,7 @@ static int bq27x00_read_i2c(u8 reg, int *rt_value, int b_single,
 	err = i2c_transfer(client->adapter, msg, 1);
 
 	if (err >= 0) {
-		if (!b_single)
+		if (!single)
 			msg->len = 2;
 		else
 			msg->len = 1;
@@ -337,7 +349,7 @@ static int bq27x00_read_i2c(u8 reg, int *rt_value, int b_single,
 		msg->flags = I2C_M_RD;
 		err = i2c_transfer(client->adapter, msg, 1);
 		if (err >= 0) {
-			if (!b_single)
+			if (!single)
 				*rt_value = get_unaligned_le16(data);
 			else
 				*rt_value = data[0];
@@ -353,7 +365,6 @@ static int bq27x00_battery_probe(struct i2c_client *client,
 {
 	char *name;
 	struct bq27x00_device_info *di;
-	struct bq27x00_access_methods *bus;
 	int num;
 	int retval = 0;
 
@@ -380,38 +391,20 @@ static int bq27x00_battery_probe(struct i2c_client *client,
 		retval = -ENOMEM;
 		goto batt_failed_2;
 	}
+
 	di->id = num;
+	di->dev = &client->dev;
 	di->chip = id->driver_data;
+	di->bat.name = name;
+	di->bus.read = &bq27x00_read_i2c;
 
-	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
-	if (!bus) {
-		dev_err(&client->dev, "failed to allocate access method "
-					"data\n");
-		retval = -ENOMEM;
+	if (bq27x00_powersupply_init(di))
 		goto batt_failed_3;
-	}
 
 	i2c_set_clientdata(client, di);
-	di->dev = &client->dev;
-	di->bat.name = name;
-	bus->read = &bq27x00_read_i2c;
-	di->bus = bus;
-	di->client = client;
-
-	bq27x00_powersupply_init(di);
-
-	retval = power_supply_register(&client->dev, &di->bat);
-	if (retval) {
-		dev_err(&client->dev, "failed to register battery\n");
-		goto batt_failed_4;
-	}
-
-	dev_info(&client->dev, "support ver. %s enabled\n", DRIVER_VERSION);
 
 	return 0;
 
-batt_failed_4:
-	kfree(bus);
 batt_failed_3:
 	kfree(di);
 batt_failed_2:
@@ -430,7 +423,6 @@ static int bq27x00_battery_remove(struct i2c_client *client)
 
 	power_supply_unregister(&di->bat);
 
-	kfree(di->bus);
 	kfree(di->bat.name);
 
 	mutex_lock(&battery_mutex);
-- 
1.7.2.3

