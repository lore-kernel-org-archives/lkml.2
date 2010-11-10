Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0KJK6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 05:58:49 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:46006 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747Ab0KJK6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 05:58:45 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 04/11] hwmon: applesmc: Introduce a register lookup table (rev3)
Date: Wed, 10 Nov 2010 11:58:03 +0100
Message-Id: <1289386685-9988-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PG8NZ-0004tG-9X.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PG8NZ-0004tG-9X 2ca36389dbeeaa427aae9fc606f6d59b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One main problem with the current driver is the inability to quickly
search for supported keys, resulting in detailed feature maps per
machine model which are cumbersome to maintain.

This patch adds a register lookup table, which enables binary search
for supported keys. The lookup also reduces the io frequency, so the
original mutex is replaced by locks around the actual io.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |  534 +++++++++++++++++++++++++---------------------
 1 files changed, 292 insertions(+), 242 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 5f67e39..3963fd5 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -32,6 +32,7 @@
 #include <linux/platform_device.h>
 #include <linux/input-polldev.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/timer.h>
 #include <linux/dmi.h>
@@ -51,6 +52,7 @@
 
 #define APPLESMC_MAX_DATA_LENGTH 32
 
+/* wait up to 32 ms for a status change. */
 #define APPLESMC_MIN_WAIT	0x0040
 #define APPLESMC_MAX_WAIT	0x8000
 
@@ -200,6 +202,25 @@ struct dmi_match_data {
 	int temperature_set;
 };
 
+/* AppleSMC entry - cached register information */
+struct applesmc_entry {
+	char key[5];		/* four-letter key code */
+	u8 valid;		/* set when entry is successfully read once */
+	u8 len;			/* bounded by APPLESMC_MAX_DATA_LENGTH */
+	char type[5];		/* four-letter type code */
+	u8 flags;		/* 0x10: func; 0x40: write; 0x80: read */
+};
+
+/* Register lookup and registers common to all SMCs */
+static struct applesmc_registers {
+	struct mutex mutex;		/* register read/write mutex */
+	unsigned int key_count;		/* number of SMC registers */
+	bool init_complete;		/* true when fully initialized */
+	struct applesmc_entry *cache;	/* cached key entries */
+} smcreg = {
+	.mutex = __MUTEX_INITIALIZER(smcreg.mutex),
+};
+
 static const int debug;
 static struct platform_device *pdev;
 static s16 rest_x;
@@ -221,8 +242,6 @@ static unsigned int fans_handled;
 /* Indicates which temperature sensors set to use. */
 static unsigned int applesmc_temperature_set;
 
-static DEFINE_MUTEX(applesmc_lock);
-
 /*
  * Last index written to key_at_index sysfs file, and value to use for all other
  * key_at_index_* sysfs files.
@@ -245,16 +264,10 @@ static int __wait_status(u8 val)
 	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
 		udelay(us);
 		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val) {
-			if (debug)
-				printk(KERN_DEBUG
-					"Waited %d us for status %x\n",
-					2 * us - APPLESMC_MIN_WAIT, val);
 			return 0;
 		}
 	}
 
-	pr_warn("wait status failed: %x != %x\n", val, inb(APPLESMC_CMD_PORT));
-
 	return -EIO;
 }
 
@@ -272,156 +285,228 @@ static int send_command(u8 cmd)
 		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == 0x0c)
 			return 0;
 	}
-	pr_warn("command failed: %x -> %x\n", cmd, inb(APPLESMC_CMD_PORT));
 	return -EIO;
 }
 
-/*
- * applesmc_read_key - reads len bytes from a given key, and put them in buffer.
- * Returns zero on success or a negative error on failure. Callers must
- * hold applesmc_lock.
- */
-static int applesmc_read_key(const char* key, u8* buffer, u8 len)
+static int send_argument(const char *key)
 {
 	int i;
 
-	if (len > APPLESMC_MAX_DATA_LENGTH) {
-		pr_err("%s(): cannot read more than %d bytes\n",
-		       __func__, APPLESMC_MAX_DATA_LENGTH);
-		return -EINVAL;
-	}
-
-	if (send_command(APPLESMC_READ_CMD))
-		return -EIO;
-
 	for (i = 0; i < 4; i++) {
 		outb(key[i], APPLESMC_DATA_PORT);
 		if (__wait_status(0x04))
 			return -EIO;
 	}
-	if (debug)
-		printk(KERN_DEBUG "<%s", key);
+	return 0;
+}
+
+static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
+{
+	int i;
+
+	if (send_command(cmd) || send_argument(key)) {
+		pr_warn("%s: read arg fail\n", key);
+		return -EIO;
+	}
 
 	outb(len, APPLESMC_DATA_PORT);
-	if (debug)
-		printk(KERN_DEBUG ">%x", len);
 
 	for (i = 0; i < len; i++) {
-		if (__wait_status(0x05))
+		if (__wait_status(0x05)) {
+			pr_warn("%s: read data fail\n", key);
 			return -EIO;
+		}
 		buffer[i] = inb(APPLESMC_DATA_PORT);
-		if (debug)
-			printk(KERN_DEBUG "<%x", buffer[i]);
 	}
-	if (debug)
-		printk(KERN_DEBUG "\n");
 
 	return 0;
 }
 
-/*
- * applesmc_write_key - writes len bytes from buffer to a given key.
- * Returns zero on success or a negative error on failure. Callers must
- * hold applesmc_lock.
- */
-static int applesmc_write_key(const char* key, u8* buffer, u8 len)
+static int write_smc(u8 cmd, const char *key, const u8 *buffer, u8 len)
 {
 	int i;
 
-	if (len > APPLESMC_MAX_DATA_LENGTH) {
-		pr_err("%s(): cannot write more than %d bytes\n",
-		       __func__, APPLESMC_MAX_DATA_LENGTH);
-		return -EINVAL;
-	}
-
-	if (send_command(APPLESMC_WRITE_CMD))
+	if (send_command(cmd) || send_argument(key)) {
+		pr_warn("%s: write arg fail\n", key);
 		return -EIO;
-
-	for (i = 0; i < 4; i++) {
-		outb(key[i], APPLESMC_DATA_PORT);
-		if (__wait_status(0x04))
-			return -EIO;
 	}
 
 	outb(len, APPLESMC_DATA_PORT);
 
 	for (i = 0; i < len; i++) {
-		if (__wait_status(0x04))
+		if (__wait_status(0x04)) {
+			pr_warn("%s: write data fail\n", key);
 			return -EIO;
+		}
 		outb(buffer[i], APPLESMC_DATA_PORT);
 	}
 
 	return 0;
 }
 
+static int read_register_count(unsigned int *count)
+{
+	__be32 be;
+	int ret;
+
+	ret = read_smc(APPLESMC_READ_CMD, KEY_COUNT_KEY, (u8 *)&be, 4);
+	if (ret)
+		return ret;
+
+	*count = be32_to_cpu(be);
+	return 0;
+}
+
 /*
- * applesmc_get_key_at_index - get key at index, and put the result in key
- * (char[6]). Returns zero on success or a negative error on failure. Callers
- * must hold applesmc_lock.
+ * Serialized I/O
+ *
+ * Returns zero on success or a negative error on failure.
+ * All functions below are concurrency safe - callers should NOT hold lock.
  */
-static int applesmc_get_key_at_index(int index, char* key)
+
+static int applesmc_read_entry(const struct applesmc_entry *entry,
+			       u8 *buf, u8 len)
 {
-	int i;
-	u8 readkey[4];
-	readkey[0] = index >> 24;
-	readkey[1] = index >> 16;
-	readkey[2] = index >> 8;
-	readkey[3] = index;
+	int ret;
 
-	if (send_command(APPLESMC_GET_KEY_BY_INDEX_CMD))
-		return -EIO;
+	if (entry->len != len)
+		return -EINVAL;
+	mutex_lock(&smcreg.mutex);
+	ret = read_smc(APPLESMC_READ_CMD, entry->key, buf, len);
+	mutex_unlock(&smcreg.mutex);
 
-	for (i = 0; i < 4; i++) {
-		outb(readkey[i], APPLESMC_DATA_PORT);
-		if (__wait_status(0x04))
-			return -EIO;
+	return ret;
+}
+
+static int applesmc_write_entry(const struct applesmc_entry *entry,
+				const u8 *buf, u8 len)
+{
+	int ret;
+
+	if (entry->len != len)
+		return -EINVAL;
+	mutex_lock(&smcreg.mutex);
+	ret = write_smc(APPLESMC_WRITE_CMD, entry->key, buf, len);
+	mutex_unlock(&smcreg.mutex);
+	return ret;
+}
+
+static const struct applesmc_entry *applesmc_get_entry_by_index(int index)
+{
+	struct applesmc_entry *cache = &smcreg.cache[index];
+	u8 key[4], info[6];
+	__be32 be;
+	int ret = 0;
+
+	if (cache->valid)
+		return cache;
+
+	mutex_lock(&smcreg.mutex);
+
+	if (cache->valid)
+		goto out;
+	be = cpu_to_be32(index);
+	ret = read_smc(APPLESMC_GET_KEY_BY_INDEX_CMD, (u8 *)&be, key, 4);
+	if (ret)
+		goto out;
+	ret = read_smc(APPLESMC_GET_KEY_TYPE_CMD, key, info, 6);
+	if (ret)
+		goto out;
+
+	memcpy(cache->key, key, 4);
+	cache->len = info[0];
+	memcpy(cache->type, &info[1], 4);
+	cache->flags = info[5];
+	cache->valid = 1;
+
+out:
+	mutex_unlock(&smcreg.mutex);
+	if (ret)
+		return ERR_PTR(ret);
+	return cache;
+}
+
+static int applesmc_get_lower_bound(unsigned int *lo, const char *key)
+{
+	int begin = 0, end = smcreg.key_count;
+	const struct applesmc_entry *entry;
+
+	while (begin != end) {
+		int middle = begin + (end - begin) / 2;
+		entry = applesmc_get_entry_by_index(middle);
+		if (IS_ERR(entry))
+			return PTR_ERR(entry);
+		if (strcmp(entry->key, key) < 0)
+			begin = middle + 1;
+		else
+			end = middle;
 	}
 
-	outb(4, APPLESMC_DATA_PORT);
+	*lo = begin;
+	return 0;
+}
 
-	for (i = 0; i < 4; i++) {
-		if (__wait_status(0x05))
-			return -EIO;
-		key[i] = inb(APPLESMC_DATA_PORT);
+static int applesmc_get_upper_bound(unsigned int *hi, const char *key)
+{
+	int begin = 0, end = smcreg.key_count;
+	const struct applesmc_entry *entry;
+
+	while (begin != end) {
+		int middle = begin + (end - begin) / 2;
+		entry = applesmc_get_entry_by_index(middle);
+		if (IS_ERR(entry))
+			return PTR_ERR(entry);
+		if (strcmp(key, entry->key) < 0)
+			end = middle;
+		else
+			begin = middle + 1;
 	}
-	key[4] = 0;
 
+	*hi = begin;
 	return 0;
 }
 
-/*
- * applesmc_get_key_type - get key type, and put the result in type (char[6]).
- * Returns zero on success or a negative error on failure. Callers must
- * hold applesmc_lock.
- */
-static int applesmc_get_key_type(char* key, char* type)
+static const struct applesmc_entry *applesmc_get_entry_by_key(const char *key)
 {
-	int i;
+	int begin, end;
+	int ret;
 
-	if (send_command(APPLESMC_GET_KEY_TYPE_CMD))
-		return -EIO;
+	ret = applesmc_get_lower_bound(&begin, key);
+	if (ret)
+		return ERR_PTR(ret);
+	ret = applesmc_get_upper_bound(&end, key);
+	if (ret)
+		return ERR_PTR(ret);
+	if (end - begin != 1)
+		return ERR_PTR(-EINVAL);
 
-	for (i = 0; i < 4; i++) {
-		outb(key[i], APPLESMC_DATA_PORT);
-		if (__wait_status(0x04))
-			return -EIO;
-	}
+	return applesmc_get_entry_by_index(begin);
+}
 
-	outb(6, APPLESMC_DATA_PORT);
+static int applesmc_read_key(const char *key, u8 *buffer, u8 len)
+{
+	const struct applesmc_entry *entry;
 
-	for (i = 0; i < 6; i++) {
-		if (__wait_status(0x05))
-			return -EIO;
-		type[i] = inb(APPLESMC_DATA_PORT);
-	}
-	type[5] = 0;
+	entry = applesmc_get_entry_by_key(key);
+	if (IS_ERR(entry))
+		return PTR_ERR(entry);
 
-	return 0;
+	return applesmc_read_entry(entry, buffer, len);
+}
+
+static int applesmc_write_key(const char *key, const u8 *buffer, u8 len)
+{
+	const struct applesmc_entry *entry;
+
+	entry = applesmc_get_entry_by_key(key);
+	if (IS_ERR(entry))
+		return PTR_ERR(entry);
+
+	return applesmc_write_entry(entry, buffer, len);
 }
 
 /*
- * applesmc_read_motion_sensor - Read motion sensor (X, Y or Z). Callers must
- * hold applesmc_lock.
+ * applesmc_read_motion_sensor - Read motion sensor (X, Y or Z).
  */
 static int applesmc_read_motion_sensor(int index, s16* value)
 {
@@ -458,12 +543,10 @@ static void applesmc_device_init(void)
 	if (!applesmc_accelerometer)
 		return;
 
-	mutex_lock(&applesmc_lock);
-
 	for (total = INIT_TIMEOUT_MSECS; total > 0; total -= INIT_WAIT_MSECS) {
 		if (!applesmc_read_key(MOTION_SENSOR_KEY, buffer, 2) &&
 				(buffer[0] != 0x00 || buffer[1] != 0x00))
-			goto out;
+			return;
 		buffer[0] = 0xe0;
 		buffer[1] = 0x00;
 		applesmc_write_key(MOTION_SENSOR_KEY, buffer, 2);
@@ -471,34 +554,93 @@ static void applesmc_device_init(void)
 	}
 
 	pr_warn("failed to init the device\n");
-
-out:
-	mutex_unlock(&applesmc_lock);
 }
 
 /*
- * applesmc_get_fan_count - get the number of fans. Callers must NOT hold
- * applesmc_lock.
+ * applesmc_get_fan_count - get the number of fans.
  */
 static int applesmc_get_fan_count(void)
 {
 	int ret;
 	u8 buffer[1];
 
-	mutex_lock(&applesmc_lock);
-
 	ret = applesmc_read_key(FANS_COUNT, buffer, 1);
 
-	mutex_unlock(&applesmc_lock);
 	if (ret)
 		return ret;
 	else
 		return buffer[0];
 }
 
+/*
+ * applesmc_init_smcreg_try - Try to initialize register cache. Idempotent.
+ */
+static int applesmc_init_smcreg_try(void)
+{
+	struct applesmc_registers *s = &smcreg;
+	int ret;
+
+	if (s->init_complete)
+		return 0;
+
+	ret = read_register_count(&s->key_count);
+	if (ret)
+		return ret;
+
+	if (!s->cache)
+		s->cache = kcalloc(s->key_count, sizeof(*s->cache), GFP_KERNEL);
+	if (!s->cache)
+		return -ENOMEM;
+
+	s->init_complete = true;
+
+	pr_info("key=%d\n", s->key_count);
+
+	return 0;
+}
+
+/*
+ * applesmc_init_smcreg - Initialize register cache.
+ *
+ * Retries until initialization is successful, or the operation times out.
+ *
+ */
+static int applesmc_init_smcreg(void)
+{
+	int ms, ret;
+
+	for (ms = 0; ms < INIT_TIMEOUT_MSECS; ms += INIT_WAIT_MSECS) {
+		ret = applesmc_init_smcreg_try();
+		if (!ret) {
+			if (ms)
+				pr_info("init_smcreg() took %d ms\n", ms);
+			return 0;
+		}
+		msleep(INIT_WAIT_MSECS);
+	}
+
+	kfree(smcreg.cache);
+	smcreg.cache = NULL;
+
+	return ret;
+}
+
+static void applesmc_destroy_smcreg(void)
+{
+	kfree(smcreg.cache);
+	smcreg.cache = NULL;
+	smcreg.init_complete = false;
+}
+
 /* Device model stuff */
 static int applesmc_probe(struct platform_device *dev)
 {
+	int ret;
+
+	ret = applesmc_init_smcreg();
+	if (ret)
+		return ret;
+
 	applesmc_device_init();
 
 	return 0;
@@ -507,10 +649,8 @@ static int applesmc_probe(struct platform_device *dev)
 /* Synchronize device with memorized backlight state */
 static int applesmc_pm_resume(struct device *dev)
 {
-	mutex_lock(&applesmc_lock);
 	if (applesmc_light)
 		applesmc_write_key(BACKLIGHT_KEY, backlight_state, 2);
-	mutex_unlock(&applesmc_lock);
 	return 0;
 }
 
@@ -551,20 +691,15 @@ static void applesmc_idev_poll(struct input_polled_dev *dev)
 	struct input_dev *idev = dev->input;
 	s16 x, y;
 
-	mutex_lock(&applesmc_lock);
-
 	if (applesmc_read_motion_sensor(SENSOR_X, &x))
-		goto out;
+		return;
 	if (applesmc_read_motion_sensor(SENSOR_Y, &y))
-		goto out;
+		return;
 
 	x = -x;
 	input_report_abs(idev, ABS_X, x - rest_x);
 	input_report_abs(idev, ABS_Y, y - rest_y);
 	input_sync(idev);
-
-out:
-	mutex_unlock(&applesmc_lock);
 }
 
 /* Sysfs Files */
@@ -581,8 +716,6 @@ static ssize_t applesmc_position_show(struct device *dev,
 	int ret;
 	s16 x, y, z;
 
-	mutex_lock(&applesmc_lock);
-
 	ret = applesmc_read_motion_sensor(SENSOR_X, &x);
 	if (ret)
 		goto out;
@@ -594,7 +727,6 @@ static ssize_t applesmc_position_show(struct device *dev,
 		goto out;
 
 out:
-	mutex_unlock(&applesmc_lock);
 	if (ret)
 		return ret;
 	else
@@ -604,18 +736,19 @@ out:
 static ssize_t applesmc_light_show(struct device *dev,
 				struct device_attribute *attr, char *sysfsbuf)
 {
+	const struct applesmc_entry *entry;
 	static int data_length;
 	int ret;
 	u8 left = 0, right = 0;
-	u8 buffer[10], query[6];
-
-	mutex_lock(&applesmc_lock);
+	u8 buffer[10];
 
 	if (!data_length) {
-		ret = applesmc_get_key_type(LIGHT_SENSOR_LEFT_KEY, query);
-		if (ret)
-			goto out;
-		data_length = clamp_val(query[0], 0, 10);
+		entry = applesmc_get_entry_by_key(LIGHT_SENSOR_LEFT_KEY);
+		if (IS_ERR(entry))
+			return PTR_ERR(entry);
+		if (entry->len > 10)
+			return -ENXIO;
+		data_length = entry->len;
 		pr_info("light sensor data length set to %d\n", data_length);
 	}
 
@@ -632,7 +765,6 @@ static ssize_t applesmc_light_show(struct device *dev,
 	right = buffer[2];
 
 out:
-	mutex_unlock(&applesmc_lock);
 	if (ret)
 		return ret;
 	else
@@ -661,14 +793,10 @@ static ssize_t applesmc_show_temperature(struct device *dev,
 	const char* key =
 		temperature_sensors_sets[applesmc_temperature_set][attr->index];
 
-	mutex_lock(&applesmc_lock);
-
 	ret = applesmc_read_key(key, buffer, 2);
 	temp = buffer[0]*1000;
 	temp += (buffer[1] >> 6) * 250;
 
-	mutex_unlock(&applesmc_lock);
-
 	if (ret)
 		return ret;
 	else
@@ -691,12 +819,9 @@ static ssize_t applesmc_show_fan_speed(struct device *dev,
 	newkey[3] = fan_speed_keys[sensor_attr->nr][3];
 	newkey[4] = 0;
 
-	mutex_lock(&applesmc_lock);
-
 	ret = applesmc_read_key(newkey, buffer, 2);
 	speed = ((buffer[0] << 8 | buffer[1]) >> 2);
 
-	mutex_unlock(&applesmc_lock);
 	if (ret)
 		return ret;
 	else
@@ -725,13 +850,10 @@ static ssize_t applesmc_store_fan_speed(struct device *dev,
 	newkey[3] = fan_speed_keys[sensor_attr->nr][3];
 	newkey[4] = 0;
 
-	mutex_lock(&applesmc_lock);
-
 	buffer[0] = (speed >> 6) & 0xff;
 	buffer[1] = (speed << 2) & 0xff;
 	ret = applesmc_write_key(newkey, buffer, 2);
 
-	mutex_unlock(&applesmc_lock);
 	if (ret)
 		return ret;
 	else
@@ -746,12 +868,9 @@ static ssize_t applesmc_show_fan_manual(struct device *dev,
 	u8 buffer[2];
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 
-	mutex_lock(&applesmc_lock);
-
 	ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
 	manual = ((buffer[0] << 8 | buffer[1]) >> attr->index) & 0x01;
 
-	mutex_unlock(&applesmc_lock);
 	if (ret)
 		return ret;
 	else
@@ -770,8 +889,6 @@ static ssize_t applesmc_store_fan_manual(struct device *dev,
 
 	input = simple_strtoul(sysfsbuf, NULL, 10);
 
-	mutex_lock(&applesmc_lock);
-
 	ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
 	val = (buffer[0] << 8 | buffer[1]);
 	if (ret)
@@ -788,7 +905,6 @@ static ssize_t applesmc_store_fan_manual(struct device *dev,
 	ret = applesmc_write_key(FANS_MANUAL, buffer, 2);
 
 out:
-	mutex_unlock(&applesmc_lock);
 	if (ret)
 		return ret;
 	else
@@ -810,12 +926,9 @@ static ssize_t applesmc_show_fan_position(struct device *dev,
 	newkey[3] = FAN_POSITION[3];
 	newkey[4] = 0;
 
-	mutex_lock(&applesmc_lock);
-
 	ret = applesmc_read_key(newkey, buffer, 16);
 	buffer[16] = 0;
 
-	mutex_unlock(&applesmc_lock);
 	if (ret)
 		return ret;
 	else
@@ -831,18 +944,14 @@ static ssize_t applesmc_calibrate_show(struct device *dev,
 static ssize_t applesmc_calibrate_store(struct device *dev,
 	struct device_attribute *attr, const char *sysfsbuf, size_t count)
 {
-	mutex_lock(&applesmc_lock);
 	applesmc_calibrate();
-	mutex_unlock(&applesmc_lock);
 
 	return count;
 }
 
 static void applesmc_backlight_set(struct work_struct *work)
 {
-	mutex_lock(&applesmc_lock);
 	applesmc_write_key(BACKLIGHT_KEY, backlight_state, 2);
-	mutex_unlock(&applesmc_lock);
 }
 static DECLARE_WORK(backlight_work, &applesmc_backlight_set);
 
@@ -865,13 +974,10 @@ static ssize_t applesmc_key_count_show(struct device *dev,
 	u8 buffer[4];
 	u32 count;
 
-	mutex_lock(&applesmc_lock);
-
 	ret = applesmc_read_key(KEY_COUNT_KEY, buffer, 4);
 	count = ((u32)buffer[0]<<24) + ((u32)buffer[1]<<16) +
 						((u32)buffer[2]<<8) + buffer[3];
 
-	mutex_unlock(&applesmc_lock);
 	if (ret)
 		return ret;
 	else
@@ -881,113 +987,53 @@ static ssize_t applesmc_key_count_show(struct device *dev,
 static ssize_t applesmc_key_at_index_read_show(struct device *dev,
 				struct device_attribute *attr, char *sysfsbuf)
 {
-	char key[5];
-	char info[6];
+	const struct applesmc_entry *entry;
 	int ret;
 
-	mutex_lock(&applesmc_lock);
-
-	ret = applesmc_get_key_at_index(key_at_index, key);
-
-	if (ret || !key[0]) {
-		mutex_unlock(&applesmc_lock);
-
-		return -EINVAL;
-	}
-
-	ret = applesmc_get_key_type(key, info);
-
-	if (ret) {
-		mutex_unlock(&applesmc_lock);
-
+	entry = applesmc_get_entry_by_index(key_at_index);
+	if (IS_ERR(entry))
+		return PTR_ERR(entry);
+	ret = applesmc_read_entry(entry, sysfsbuf, entry->len);
+	if (ret)
 		return ret;
-	}
 
-	/*
-	 * info[0] maximum value (APPLESMC_MAX_DATA_LENGTH) is much lower than
-	 * PAGE_SIZE, so we don't need any checks before writing to sysfsbuf.
-	 */
-	ret = applesmc_read_key(key, sysfsbuf, info[0]);
-
-	mutex_unlock(&applesmc_lock);
-
-	if (!ret) {
-		return info[0];
-	} else {
-		return ret;
-	}
+	return entry->len;
 }
 
 static ssize_t applesmc_key_at_index_data_length_show(struct device *dev,
 				struct device_attribute *attr, char *sysfsbuf)
 {
-	char key[5];
-	char info[6];
-	int ret;
-
-	mutex_lock(&applesmc_lock);
+	const struct applesmc_entry *entry;
 
-	ret = applesmc_get_key_at_index(key_at_index, key);
+	entry = applesmc_get_entry_by_index(key_at_index);
+	if (IS_ERR(entry))
+		return PTR_ERR(entry);
 
-	if (ret || !key[0]) {
-		mutex_unlock(&applesmc_lock);
-
-		return -EINVAL;
-	}
-
-	ret = applesmc_get_key_type(key, info);
-
-	mutex_unlock(&applesmc_lock);
-
-	if (!ret)
-		return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", info[0]);
-	else
-		return ret;
+	return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", entry->len);
 }
 
 static ssize_t applesmc_key_at_index_type_show(struct device *dev,
 				struct device_attribute *attr, char *sysfsbuf)
 {
-	char key[5];
-	char info[6];
-	int ret;
-
-	mutex_lock(&applesmc_lock);
-
-	ret = applesmc_get_key_at_index(key_at_index, key);
-
-	if (ret || !key[0]) {
-		mutex_unlock(&applesmc_lock);
-
-		return -EINVAL;
-	}
-
-	ret = applesmc_get_key_type(key, info);
+	const struct applesmc_entry *entry;
 
-	mutex_unlock(&applesmc_lock);
+	entry = applesmc_get_entry_by_index(key_at_index);
+	if (IS_ERR(entry))
+		return PTR_ERR(entry);
 
-	if (!ret)
-		return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", info+1);
-	else
-		return ret;
+	return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", entry->type);
 }
 
 static ssize_t applesmc_key_at_index_name_show(struct device *dev,
 				struct device_attribute *attr, char *sysfsbuf)
 {
-	char key[5];
-	int ret;
-
-	mutex_lock(&applesmc_lock);
+	const struct applesmc_entry *entry;
 
-	ret = applesmc_get_key_at_index(key_at_index, key);
+	entry = applesmc_get_entry_by_index(key_at_index);
+	if (IS_ERR(entry))
+		return PTR_ERR(entry);
 
-	mutex_unlock(&applesmc_lock);
-
-	if (!ret && key[0])
-		return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", key);
-	else
-		return -EINVAL;
+	return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", entry->key);
 }
 
 static ssize_t applesmc_key_at_index_show(struct device *dev,
@@ -999,12 +1045,8 @@ static ssize_t applesmc_key_at_index_show(struct device *dev,
 static ssize_t applesmc_key_at_index_store(struct device *dev,
 	struct device_attribute *attr, const char *sysfsbuf, size_t count)
 {
-	mutex_lock(&applesmc_lock);
-
 	key_at_index = simple_strtoul(sysfsbuf, NULL, 10);
 
-	mutex_unlock(&applesmc_lock);
-
 	return count;
 }
 
@@ -1646,10 +1688,15 @@ static int __init applesmc_init(void)
 		goto out_driver;
 	}
 
-	ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_name.attr);
+	/* create register cache */
+	ret = applesmc_init_smcreg();
 	if (ret)
 		goto out_device;
 
+	ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_name.attr);
+	if (ret)
+		goto out_smcreg;
+
 	/* Create key enumeration sysfs files */
 	ret = sysfs_create_group(&pdev->dev.kobj, &key_enumeration_group);
 	if (ret)
@@ -1751,6 +1798,8 @@ out_fans:
 	sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
 out_name:
 	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_name.attr);
+out_smcreg:
+	applesmc_destroy_smcreg();
 out_device:
 	platform_device_unregister(pdev);
 out_driver:
@@ -1779,6 +1828,7 @@ static void __exit applesmc_exit(void)
 				   &fan_attribute_groups[--fans_handled]);
 	sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
 	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_name.attr);
+	applesmc_destroy_smcreg();
 	platform_device_unregister(pdev);
 	platform_driver_unregister(&applesmc_driver);
 	release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
-- 
1.7.1

