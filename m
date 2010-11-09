Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab0KIPRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:17:50 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:54402 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318Ab0KIPRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:17:44 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 08/11] hwmon: applesmc: Dynamic creation of fan files (rev2)
Date: Tue,  9 Nov 2010 16:15:08 +0100
Message-Id: <1289315711-3011-9-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PFpwq-0003MO-4n.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PFpwq-0003MO-4n e8cd9e5fa645db69a14029c21066cc43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the dynamic temperature group in place, the setup of fans
can be simplified. This patch sets up the fans dynamically, removing
a hundred lines of code.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |  188 +++++++++++-----------------------------------
 1 files changed, 43 insertions(+), 145 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 4e45aa7..733d4c9 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -77,20 +77,15 @@
 
 #define FANS_COUNT		"FNum" /* r-o ui8 */
 #define FANS_MANUAL		"FS! " /* r-w ui16 */
-#define FAN_ACTUAL_SPEED	"F0Ac" /* r-o fpe2 (2 bytes) */
-#define FAN_MIN_SPEED		"F0Mn" /* r-o fpe2 (2 bytes) */
-#define FAN_MAX_SPEED		"F0Mx" /* r-o fpe2 (2 bytes) */
-#define FAN_SAFE_SPEED		"F0Sf" /* r-o fpe2 (2 bytes) */
-#define FAN_TARGET_SPEED	"F0Tg" /* r-w fpe2 (2 bytes) */
-#define FAN_POSITION		"F0ID" /* r-o char[16] */
+#define FAN_ID_FMT		"F%dID" /* r-o char[16] */
 
 /* List of keys used to read/write fan speeds */
-static const char* fan_speed_keys[] = {
-	FAN_ACTUAL_SPEED,
-	FAN_MIN_SPEED,
-	FAN_MAX_SPEED,
-	FAN_SAFE_SPEED,
-	FAN_TARGET_SPEED
+static const char *const fan_speed_fmt[] = {
+	"F%dAc",		/* actual speed */
+	"F%dMn",		/* minimum speed (rw) */
+	"F%dMx",		/* maximum speed */
+	"F%dSf",		/* safe speed - not all models */
+	"F%dTg",		/* target speed (manual: rw) */
 };
 
 #define INIT_TIMEOUT_MSECS	5000	/* wait up to 5s for device init ... */
@@ -104,7 +99,8 @@ static const char* fan_speed_keys[] = {
 #define SENSOR_Y 1
 #define SENSOR_Z 2
 
-#define to_index(attr) (to_sensor_dev_attr(attr)->index)
+#define to_index(attr) (to_sensor_dev_attr(attr)->index & 0xffff)
+#define to_option(attr) (to_sensor_dev_attr(attr)->index >> 16)
 
 /* Dynamic device node attributes */
 struct applesmc_dev_attr {
@@ -117,6 +113,7 @@ struct applesmc_node_group {
 	char *format;				/* format string */
 	void *show;				/* show function */
 	void *store;				/* store function */
+	int option;				/* function argument */
 	struct applesmc_dev_attr *nodes;	/* dynamic node array */
 };
 
@@ -133,6 +130,7 @@ struct applesmc_entry {
 static struct applesmc_registers {
 	struct mutex mutex;		/* register read/write mutex */
 	unsigned int key_count;		/* number of SMC registers */
+	unsigned int fan_count;		/* number of fans */
 	unsigned int temp_count;	/* number of temperature registers */
 	unsigned int temp_begin;	/* temperature lower index bound */
 	unsigned int temp_end;		/* temperature upper index bound */
@@ -152,9 +150,6 @@ static u8 backlight_state[2];
 static struct device *hwmon_dev;
 static struct input_polled_dev *applesmc_idev;
 
-/* The number of fans handled by the driver */
-static unsigned int fans_handled;
-
 /*
  * Last index written to key_at_index sysfs file, and value to use for all other
  * key_at_index_* sysfs files.
@@ -482,28 +477,13 @@ static void applesmc_device_init(void)
 }
 
 /*
- * applesmc_get_fan_count - get the number of fans.
- */
-static int applesmc_get_fan_count(void)
-{
-	int ret;
-	u8 buffer[1];
-
-	ret = applesmc_read_key(FANS_COUNT, buffer, 1);
-
-	if (ret)
-		return ret;
-	else
-		return buffer[0];
-}
-
-/*
  * applesmc_init_smcreg_try - Try to initialize register cache. Idempotent.
  */
 static int applesmc_init_smcreg_try(void)
 {
 	struct applesmc_registers *s = &smcreg;
 	bool left_light_sensor, right_light_sensor;
+	u8 tmp[1];
 	int ret;
 
 	if (s->init_complete)
@@ -520,6 +500,11 @@ static int applesmc_init_smcreg_try(void)
 	if (!s->cache)
 		return -ENOMEM;
 
+	ret = applesmc_read_key(FANS_COUNT, tmp, 1);
+	if (ret)
+		return ret;
+	s->fan_count = tmp[0];
+
 	ret = applesmc_get_lower_bound(&s->temp_begin, "T");
 	if (ret)
 		return ret;
@@ -544,8 +529,8 @@ static int applesmc_init_smcreg_try(void)
 	s->num_light_sensors = left_light_sensor + right_light_sensor;
 	s->init_complete = true;
 
-	pr_info("key=%d temp=%d acc=%d lux=%d kbd=%d\n",
-	       s->key_count, s->temp_count,
+	pr_info("key=%d fan=%d temp=%d acc=%d lux=%d kbd=%d\n",
+	       s->key_count, s->fan_count, s->temp_count,
 	       s->has_accelerometer,
 	       s->num_light_sensors,
 	       s->has_key_backlight);
@@ -770,14 +755,8 @@ static ssize_t applesmc_show_fan_speed(struct device *dev,
 	unsigned int speed = 0;
 	char newkey[5];
 	u8 buffer[2];
-	struct sensor_device_attribute_2 *sensor_attr =
-						to_sensor_dev_attr_2(attr);
 
-	newkey[0] = fan_speed_keys[sensor_attr->nr][0];
-	newkey[1] = '0' + sensor_attr->index;
-	newkey[2] = fan_speed_keys[sensor_attr->nr][2];
-	newkey[3] = fan_speed_keys[sensor_attr->nr][3];
-	newkey[4] = 0;
+	sprintf(newkey, fan_speed_fmt[to_option(attr)], to_index(attr));
 
 	ret = applesmc_read_key(newkey, buffer, 2);
 	speed = ((buffer[0] << 8 | buffer[1]) >> 2);
@@ -796,19 +775,13 @@ static ssize_t applesmc_store_fan_speed(struct device *dev,
 	u32 speed;
 	char newkey[5];
 	u8 buffer[2];
-	struct sensor_device_attribute_2 *sensor_attr =
-						to_sensor_dev_attr_2(attr);
 
 	speed = simple_strtoul(sysfsbuf, NULL, 10);
 
 	if (speed > 0x4000) /* Bigger than a 14-bit value */
 		return -EINVAL;
 
-	newkey[0] = fan_speed_keys[sensor_attr->nr][0];
-	newkey[1] = '0' + sensor_attr->index;
-	newkey[2] = fan_speed_keys[sensor_attr->nr][2];
-	newkey[3] = fan_speed_keys[sensor_attr->nr][3];
-	newkey[4] = 0;
+	sprintf(newkey, fan_speed_fmt[to_option(attr)], to_index(attr));
 
 	buffer[0] = (speed >> 6) & 0xff;
 	buffer[1] = (speed << 2) & 0xff;
@@ -821,15 +794,14 @@ static ssize_t applesmc_store_fan_speed(struct device *dev,
 }
 
 static ssize_t applesmc_show_fan_manual(struct device *dev,
-			struct device_attribute *devattr, char *sysfsbuf)
+			struct device_attribute *attr, char *sysfsbuf)
 {
 	int ret;
 	u16 manual = 0;
 	u8 buffer[2];
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 
 	ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
-	manual = ((buffer[0] << 8 | buffer[1]) >> attr->index) & 0x01;
+	manual = ((buffer[0] << 8 | buffer[1]) >> to_index(attr)) & 0x01;
 
 	if (ret)
 		return ret;
@@ -838,14 +810,13 @@ static ssize_t applesmc_show_fan_manual(struct device *dev,
 }
 
 static ssize_t applesmc_store_fan_manual(struct device *dev,
-					 struct device_attribute *devattr,
+					 struct device_attribute *attr,
 					 const char *sysfsbuf, size_t count)
 {
 	int ret;
 	u8 buffer[2];
 	u32 input;
 	u16 val;
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 
 	input = simple_strtoul(sysfsbuf, NULL, 10);
 
@@ -855,9 +826,9 @@ static ssize_t applesmc_store_fan_manual(struct device *dev,
 		goto out;
 
 	if (input)
-		val = val | (0x01 << attr->index);
+		val = val | (0x01 << to_index(attr));
 	else
-		val = val & ~(0x01 << attr->index);
+		val = val & ~(0x01 << to_index(attr));
 
 	buffer[0] = (val >> 8) & 0xFF;
 	buffer[1] = val & 0xFF;
@@ -877,14 +848,8 @@ static ssize_t applesmc_show_fan_position(struct device *dev,
 	int ret;
 	char newkey[5];
 	u8 buffer[17];
-	struct sensor_device_attribute_2 *sensor_attr =
-						to_sensor_dev_attr_2(attr);
 
-	newkey[0] = FAN_POSITION[0];
-	newkey[1] = '0' + sensor_attr->index;
-	newkey[2] = FAN_POSITION[2];
-	newkey[3] = FAN_POSITION[3];
-	newkey[4] = 0;
+	sprintf(newkey, FAN_ID_FMT, to_index(attr));
 
 	ret = applesmc_read_key(newkey, buffer, 16);
 	buffer[16] = 0;
@@ -1058,62 +1023,15 @@ static struct attribute *key_enumeration_attributes[] = {
 static const struct attribute_group key_enumeration_group =
 	{ .attrs = key_enumeration_attributes };
 
-/*
- * Macro defining SENSOR_DEVICE_ATTR for a fan sysfs entries.
- *  - show actual speed
- *  - show/store minimum speed
- *  - show maximum speed
- *  - show safe speed
- *  - show/store target speed
- *  - show/store manual mode
- */
-#define sysfs_fan_speeds_offset(offset) \
-static SENSOR_DEVICE_ATTR_2(fan##offset##_input, S_IRUGO, \
-			applesmc_show_fan_speed, NULL, 0, offset-1); \
-\
-static SENSOR_DEVICE_ATTR_2(fan##offset##_min, S_IRUGO | S_IWUSR, \
-	applesmc_show_fan_speed, applesmc_store_fan_speed, 1, offset-1); \
-\
-static SENSOR_DEVICE_ATTR_2(fan##offset##_max, S_IRUGO, \
-			applesmc_show_fan_speed, NULL, 2, offset-1); \
-\
-static SENSOR_DEVICE_ATTR_2(fan##offset##_safe, S_IRUGO, \
-			applesmc_show_fan_speed, NULL, 3, offset-1); \
-\
-static SENSOR_DEVICE_ATTR_2(fan##offset##_output, S_IRUGO | S_IWUSR, \
-	applesmc_show_fan_speed, applesmc_store_fan_speed, 4, offset-1); \
-\
-static SENSOR_DEVICE_ATTR(fan##offset##_manual, S_IRUGO | S_IWUSR, \
-	applesmc_show_fan_manual, applesmc_store_fan_manual, offset-1); \
-\
-static SENSOR_DEVICE_ATTR(fan##offset##_label, S_IRUGO, \
-	applesmc_show_fan_position, NULL, offset-1); \
-\
-static struct attribute *fan##offset##_attributes[] = { \
-	&sensor_dev_attr_fan##offset##_input.dev_attr.attr, \
-	&sensor_dev_attr_fan##offset##_min.dev_attr.attr, \
-	&sensor_dev_attr_fan##offset##_max.dev_attr.attr, \
-	&sensor_dev_attr_fan##offset##_safe.dev_attr.attr, \
-	&sensor_dev_attr_fan##offset##_output.dev_attr.attr, \
-	&sensor_dev_attr_fan##offset##_manual.dev_attr.attr, \
-	&sensor_dev_attr_fan##offset##_label.dev_attr.attr, \
-	NULL \
-};
-
-/*
- * Create the needed functions for each fan using the macro defined above
- * (4 fans are supported)
- */
-sysfs_fan_speeds_offset(1);
-sysfs_fan_speeds_offset(2);
-sysfs_fan_speeds_offset(3);
-sysfs_fan_speeds_offset(4);
-
-static const struct attribute_group fan_attribute_groups[] = {
-	{ .attrs = fan1_attributes },
-	{ .attrs = fan2_attributes },
-	{ .attrs = fan3_attributes },
-	{ .attrs = fan4_attributes },
+static struct applesmc_node_group fan_group[] = {
+	{ "fan%d_label", applesmc_show_fan_position },
+	{ "fan%d_input", applesmc_show_fan_speed, NULL, 0 },
+	{ "fan%d_min", applesmc_show_fan_speed, applesmc_store_fan_speed, 1 },
+	{ "fan%d_max", applesmc_show_fan_speed, NULL, 2 },
+	{ "fan%d_safe", applesmc_show_fan_speed, NULL, 3 },
+	{ "fan%d_output", applesmc_show_fan_speed, applesmc_store_fan_speed, 4 },
+	{ "fan%d_manual", applesmc_show_fan_manual, applesmc_store_fan_manual },
+	{ }
 };
 
 static struct applesmc_node_group temp_group[] = {
@@ -1160,7 +1078,7 @@ static int applesmc_create_nodes(struct applesmc_node_group *groups, int num)
 		for (i = 0; i < num; i++) {
 			node = &grp->nodes[i];
 			sprintf(node->name, grp->format, i + 1);
-			node->sda.index = i;
+			node->sda.index = (grp->option << 16) | (i & 0xffff);
 			node->sda.dev_attr.show = grp->show;
 			node->sda.dev_attr.store = grp->store;
 			attr = &node->sda.dev_attr.attr;
@@ -1276,7 +1194,6 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 static int __init applesmc_init(void)
 {
 	int ret;
-	int count;
 
 	if (!dmi_check_system(applesmc_whitelist)) {
 		pr_warn("supported laptop not found!\n");
@@ -1315,25 +1232,9 @@ static int __init applesmc_init(void)
 	if (ret)
 		goto out_name;
 
-	/* create fan files */
-	count = applesmc_get_fan_count();
-	if (count < 0)
-		pr_err("Cannot get the number of fans\n");
-	else
-		pr_info("%d fans found\n", count);
-
-	if (count > 4) {
-		count = 4;
-		pr_warn("A maximum of 4 fans are supported by this driver\n");
-	}
-
-	while (fans_handled < count) {
-		ret = sysfs_create_group(&pdev->dev.kobj,
-					 &fan_attribute_groups[fans_handled]);
-		if (ret)
-			goto out_fans;
-		fans_handled++;
-	}
+	ret = applesmc_create_nodes(fan_group, smcreg.fan_count);
+	if (ret)
+		goto out_info;
 
 	ret = applesmc_create_nodes(temp_group, smcreg.temp_count);
 	if (ret)
@@ -1391,9 +1292,8 @@ out_accelerometer:
 out_temperature:
 	applesmc_destroy_nodes(temp_group);
 out_fans:
-	while (fans_handled)
-		sysfs_remove_group(&pdev->dev.kobj,
-				   &fan_attribute_groups[--fans_handled]);
+	applesmc_destroy_nodes(fan_group);
+out_info:
 	sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
 out_name:
 	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_name.attr);
@@ -1422,9 +1322,7 @@ static void __exit applesmc_exit(void)
 	if (smcreg.has_accelerometer)
 		applesmc_release_accelerometer();
 	applesmc_destroy_nodes(temp_group);
-	while (fans_handled)
-		sysfs_remove_group(&pdev->dev.kobj,
-				   &fan_attribute_groups[--fans_handled]);
+	applesmc_destroy_nodes(fan_group);
 	sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
 	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_name.attr);
 	applesmc_destroy_smcreg();
-- 
1.7.1

