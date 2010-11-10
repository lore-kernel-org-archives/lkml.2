Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0KJK6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 05:58:43 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:45972 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747Ab0KJK6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 05:58:42 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 05/11] hwmon: applesmc: Dynamic creation of temperature files (rev3)
Date: Wed, 10 Nov 2010 11:58:04 +0100
Message-Id: <1289386685-9988-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289386685-9988-1-git-send-email-rydberg@euromail.se>
References: <1289386685-9988-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PG8Nn-0004zq-7L.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PG8Nn-0004zq-7L af5b4baad45afbb3e3c158d174eb2d2b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current driver creates temperature files based on a list
of temperature keys given per device. Apart from slow adaption
to new machine models, the number of sensors also depends on
the number of processors. This patch looks up the temperature
keys dynamically, thereby supporting all models.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |  500 ++++++++++-----------------------------------
 1 files changed, 111 insertions(+), 389 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 3963fd5..7a6ffd1 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -84,94 +84,6 @@
 #define FAN_TARGET_SPEED	"F0Tg" /* r-w fpe2 (2 bytes) */
 #define FAN_POSITION		"F0ID" /* r-o char[16] */
 
-/*
- * Temperature sensors keys (sp78 - 2 bytes).
- */
-static const char *temperature_sensors_sets[][41] = {
-/* Set 0: Macbook Pro */
-	{ "TA0P", "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "Th0H",
-	  "Th1H", "Tm0P", "Ts0P", "Ts1P", NULL },
-/* Set 1: Macbook2 set */
-	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TN1P", "TTF0", "Th0H",
-	  "Th0S", "Th1H", NULL },
-/* Set 2: Macbook set */
-	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TN1P", "Th0H", "Th0S",
-	  "Th1H", "Ts0P", NULL },
-/* Set 3: Macmini set */
-	{ "TC0D", "TC0P", NULL },
-/* Set 4: Mac Pro (2 x Quad-Core) */
-	{ "TA0P", "TCAG", "TCAH", "TCBG", "TCBH", "TC0C", "TC0D", "TC0P",
-	  "TC1C", "TC1D", "TC2C", "TC2D", "TC3C", "TC3D", "THTG", "TH0P",
-	  "TH1P", "TH2P", "TH3P", "TMAP", "TMAS", "TMBS", "TM0P", "TM0S",
-	  "TM1P", "TM1S", "TM2P", "TM2S", "TM3S", "TM8P", "TM8S", "TM9P",
-	  "TM9S", "TN0H", "TS0C", NULL },
-/* Set 5: iMac */
-	{ "TC0D", "TA0P", "TG0P", "TG0D", "TG0H", "TH0P", "Tm0P", "TO0P",
-	  "Tp0C", NULL },
-/* Set 6: Macbook3 set */
-	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TTF0", "TW0P", "Th0H",
-	  "Th0S", "Th1H", NULL },
-/* Set 7: Macbook Air */
-	{ "TB0T", "TB1S", "TB1T", "TB2S", "TB2T", "TC0D", "TC0P", "TCFP",
-	  "TTF0", "TW0P", "Th0H", "Tp0P", "TpFP", "Ts0P", "Ts0S", NULL },
-/* Set 8: Macbook Pro 4,1 (Penryn) */
-	{ "TB0T", "TC0D", "TC0P", "TG0D", "TG0H", "TTF0", "TW0P", "Th0H",
-	  "Th1H", "Th2H", "Tm0P", "Ts0P", NULL },
-/* Set 9: Macbook Pro 3,1 (Santa Rosa) */
-	{ "TALP", "TB0T", "TC0D", "TC0P", "TG0D", "TG0H", "TTF0", "TW0P",
-	  "Th0H", "Th1H", "Th2H", "Tm0P", "Ts0P", NULL },
-/* Set 10: iMac 5,1 */
-	{ "TA0P", "TC0D", "TC0P", "TG0D", "TH0P", "TO0P", "Tm0P", NULL },
-/* Set 11: Macbook 5,1 */
-	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0P", "TN0D", "TN0P",
-	  "TTF0", "Th0H", "Th1H", "ThFH", "Ts0P", "Ts0S", NULL },
-/* Set 12: Macbook Pro 5,1 */
-	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0F", "TC0P", "TG0D",
-	  "TG0F", "TG0H", "TG0P", "TG0T", "TG1H", "TN0D", "TN0P", "TTF0",
-	  "Th2H", "Tm0P", "Ts0P", "Ts0S", NULL },
-/* Set 13: iMac 8,1 */
-	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TG0P", "TH0P",
-	  "TL0P", "TO0P", "TW0P", "Tm0P", "Tp0P", NULL },
-/* Set 14: iMac 6,1 */
-	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TG0P", "TH0P",
-	  "TO0P", "Tp0P", NULL },
-/* Set 15: MacBook Air 2,1 */
-	{ "TB0T", "TB1S", "TB1T", "TB2S", "TB2T", "TC0D", "TN0D", "TTF0",
-	  "TV0P", "TVFP", "TW0P", "Th0P", "Tp0P", "Tp1P", "TpFP", "Ts0P",
-	  "Ts0S", NULL },
-/* Set 16: Mac Pro 3,1 (2 x Quad-Core) */
-	{ "TA0P", "TCAG", "TCAH", "TCBG", "TCBH", "TC0C", "TC0D", "TC0P",
-	  "TC1C", "TC1D", "TC2C", "TC2D", "TC3C", "TC3D", "TH0P", "TH1P",
-	  "TH2P", "TH3P", "TMAP", "TMAS", "TMBS", "TM0P", "TM0S", "TM1P",
-	  "TM1S", "TM2P", "TM2S", "TM3S", "TM8P", "TM8S", "TM9P", "TM9S",
-	  "TN0C", "TN0D", "TN0H", "TS0C", "Tp0C", "Tp1C", "Tv0S", "Tv1S",
-	  NULL },
-/* Set 17: iMac 9,1 */
-	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TH0P", "TL0P",
-	  "TN0D", "TN0H", "TN0P", "TO0P", "Tm0P", "Tp0P", NULL },
-/* Set 18: MacBook Pro 2,2 */
-	{ "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "TM0P", "TTF0",
-	  "Th0H", "Th1H", "Tm0P", "Ts0P", NULL },
-/* Set 19: Macbook Pro 5,3 */
-	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0F", "TC0P", "TG0D",
-	  "TG0F", "TG0H", "TG0P", "TG0T", "TN0D", "TN0P", "TTF0", "Th2H",
-	  "Tm0P", "Ts0P", "Ts0S", NULL },
-/* Set 20: MacBook Pro 5,4 */
-	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0F", "TC0P", "TN0D",
-	  "TN0P", "TTF0", "Th2H", "Ts0P", "Ts0S", NULL },
-/* Set 21: MacBook Pro 6,2 */
-	{ "TB0T", "TB1T", "TB2T", "TC0C", "TC0D", "TC0P", "TC1C", "TG0D",
-	  "TG0P", "TG0T", "TMCD", "TP0P", "TPCD", "Th1H", "Th2H", "Tm0P",
-	  "Ts0P", "Ts0S", NULL },
-/* Set 22: MacBook Pro 7,1 */
-	{ "TB0T", "TB1T", "TB2T", "TC0D", "TC0P", "TN0D", "TN0P", "TN0S",
-	  "TN1D", "TN1F", "TN1G", "TN1S", "Th1H", "Ts0P", "Ts0S", NULL },
-/* Set 23: MacBook Air 3,1 */
-	{ "TB0T", "TB1T", "TB2T", "TC0D", "TC0E", "TC0P", "TC1E", "TCZ3",
-	  "TCZ4", "TCZ5", "TG0E", "TG1E", "TG2E", "TGZ3", "TGZ4", "TGZ5",
-	  "TH0F", "TH0O", "TM0P" },
-};
-
 /* List of keys used to read/write fan speeds */
 static const char* fan_speed_keys[] = {
 	FAN_ACTUAL_SPEED,
@@ -192,6 +104,8 @@ static const char* fan_speed_keys[] = {
 #define SENSOR_Y 1
 #define SENSOR_Z 2
 
+#define to_index(attr) (to_sensor_dev_attr(attr)->index)
+
 /* Structure to be passed to DMI_MATCH function */
 struct dmi_match_data {
 /* Indicates whether this computer has an accelerometer. */
@@ -202,6 +116,20 @@ struct dmi_match_data {
 	int temperature_set;
 };
 
+/* Dynamic device node attributes */
+struct applesmc_dev_attr {
+	struct sensor_device_attribute sda;	/* hwmon attributes */
+	char name[32];				/* room for node file name */
+};
+
+/* Dynamic device node group */
+struct applesmc_node_group {
+	char *format;				/* format string */
+	void *show;				/* show function */
+	void *store;				/* store function */
+	struct applesmc_dev_attr *nodes;	/* dynamic node array */
+};
+
 /* AppleSMC entry - cached register information */
 struct applesmc_entry {
 	char key[5];		/* four-letter key code */
@@ -215,6 +143,9 @@ struct applesmc_entry {
 static struct applesmc_registers {
 	struct mutex mutex;		/* register read/write mutex */
 	unsigned int key_count;		/* number of SMC registers */
+	unsigned int temp_count;	/* number of temperature registers */
+	unsigned int temp_begin;	/* temperature lower index bound */
+	unsigned int temp_end;		/* temperature upper index bound */
 	bool init_complete;		/* true when fully initialized */
 	struct applesmc_entry *cache;	/* cached key entries */
 } smcreg = {
@@ -239,9 +170,6 @@ static unsigned int applesmc_light;
 /* The number of fans handled by the driver */
 static unsigned int fans_handled;
 
-/* Indicates which temperature sensors set to use. */
-static unsigned int applesmc_temperature_set;
-
 /*
  * Last index written to key_at_index sysfs file, and value to use for all other
  * key_at_index_* sysfs files.
@@ -592,9 +520,17 @@ static int applesmc_init_smcreg_try(void)
 	if (!s->cache)
 		return -ENOMEM;
 
+	ret = applesmc_get_lower_bound(&s->temp_begin, "T");
+	if (ret)
+		return ret;
+	ret = applesmc_get_lower_bound(&s->temp_end, "U");
+	if (ret)
+		return ret;
+	s->temp_count = s->temp_end - s->temp_begin;
+
 	s->init_complete = true;
 
-	pr_info("key=%d\n", s->key_count);
+	pr_info("key=%d temp=%d\n", s->key_count, s->temp_count);
 
 	return 0;
 }
@@ -775,32 +711,38 @@ out:
 static ssize_t applesmc_show_sensor_label(struct device *dev,
 			struct device_attribute *devattr, char *sysfsbuf)
 {
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
-	const char *key =
-		temperature_sensors_sets[applesmc_temperature_set][attr->index];
+	int index = smcreg.temp_begin + to_index(devattr);
+	const struct applesmc_entry *entry;
 
-	return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", key);
+	entry = applesmc_get_entry_by_index(index);
+	if (IS_ERR(entry))
+		return PTR_ERR(entry);
+
+	return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", entry->key);
 }
 
 /* Displays degree Celsius * 1000 */
 static ssize_t applesmc_show_temperature(struct device *dev,
 			struct device_attribute *devattr, char *sysfsbuf)
 {
+	int index = smcreg.temp_begin + to_index(devattr);
+	const struct applesmc_entry *entry;
 	int ret;
 	u8 buffer[2];
 	unsigned int temp;
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
-	const char* key =
-		temperature_sensors_sets[applesmc_temperature_set][attr->index];
 
-	ret = applesmc_read_key(key, buffer, 2);
-	temp = buffer[0]*1000;
-	temp += (buffer[1] >> 6) * 250;
+	entry = applesmc_get_entry_by_index(index);
+	if (IS_ERR(entry))
+		return PTR_ERR(entry);
 
+	ret = applesmc_read_entry(entry, buffer, 2);
 	if (ret)
 		return ret;
-	else
-		return snprintf(sysfsbuf, PAGE_SIZE, "%u\n", temp);
+
+	temp = buffer[0]*1000;
+	temp += (buffer[1] >> 6) * 250;
+
+	return snprintf(sysfsbuf, PAGE_SIZE, "%u\n", temp);
 }
 
 static ssize_t applesmc_show_fan_speed(struct device *dev,
@@ -1156,263 +1098,10 @@ static const struct attribute_group fan_attribute_groups[] = {
 	{ .attrs = fan4_attributes },
 };
 
-/*
- * Temperature sensors sysfs entries.
- */
-static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 0);
-static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 1);
-static SENSOR_DEVICE_ATTR(temp3_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 2);
-static SENSOR_DEVICE_ATTR(temp4_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 3);
-static SENSOR_DEVICE_ATTR(temp5_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 4);
-static SENSOR_DEVICE_ATTR(temp6_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 5);
-static SENSOR_DEVICE_ATTR(temp7_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 6);
-static SENSOR_DEVICE_ATTR(temp8_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 7);
-static SENSOR_DEVICE_ATTR(temp9_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 8);
-static SENSOR_DEVICE_ATTR(temp10_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 9);
-static SENSOR_DEVICE_ATTR(temp11_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 10);
-static SENSOR_DEVICE_ATTR(temp12_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 11);
-static SENSOR_DEVICE_ATTR(temp13_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 12);
-static SENSOR_DEVICE_ATTR(temp14_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 13);
-static SENSOR_DEVICE_ATTR(temp15_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 14);
-static SENSOR_DEVICE_ATTR(temp16_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 15);
-static SENSOR_DEVICE_ATTR(temp17_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 16);
-static SENSOR_DEVICE_ATTR(temp18_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 17);
-static SENSOR_DEVICE_ATTR(temp19_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 18);
-static SENSOR_DEVICE_ATTR(temp20_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 19);
-static SENSOR_DEVICE_ATTR(temp21_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 20);
-static SENSOR_DEVICE_ATTR(temp22_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 21);
-static SENSOR_DEVICE_ATTR(temp23_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 22);
-static SENSOR_DEVICE_ATTR(temp24_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 23);
-static SENSOR_DEVICE_ATTR(temp25_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 24);
-static SENSOR_DEVICE_ATTR(temp26_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 25);
-static SENSOR_DEVICE_ATTR(temp27_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 26);
-static SENSOR_DEVICE_ATTR(temp28_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 27);
-static SENSOR_DEVICE_ATTR(temp29_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 28);
-static SENSOR_DEVICE_ATTR(temp30_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 29);
-static SENSOR_DEVICE_ATTR(temp31_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 30);
-static SENSOR_DEVICE_ATTR(temp32_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 31);
-static SENSOR_DEVICE_ATTR(temp33_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 32);
-static SENSOR_DEVICE_ATTR(temp34_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 33);
-static SENSOR_DEVICE_ATTR(temp35_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 34);
-static SENSOR_DEVICE_ATTR(temp36_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 35);
-static SENSOR_DEVICE_ATTR(temp37_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 36);
-static SENSOR_DEVICE_ATTR(temp38_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 37);
-static SENSOR_DEVICE_ATTR(temp39_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 38);
-static SENSOR_DEVICE_ATTR(temp40_label, S_IRUGO,
-					applesmc_show_sensor_label, NULL, 39);
-static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 0);
-static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 1);
-static SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 2);
-static SENSOR_DEVICE_ATTR(temp4_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 3);
-static SENSOR_DEVICE_ATTR(temp5_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 4);
-static SENSOR_DEVICE_ATTR(temp6_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 5);
-static SENSOR_DEVICE_ATTR(temp7_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 6);
-static SENSOR_DEVICE_ATTR(temp8_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 7);
-static SENSOR_DEVICE_ATTR(temp9_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 8);
-static SENSOR_DEVICE_ATTR(temp10_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 9);
-static SENSOR_DEVICE_ATTR(temp11_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 10);
-static SENSOR_DEVICE_ATTR(temp12_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 11);
-static SENSOR_DEVICE_ATTR(temp13_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 12);
-static SENSOR_DEVICE_ATTR(temp14_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 13);
-static SENSOR_DEVICE_ATTR(temp15_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 14);
-static SENSOR_DEVICE_ATTR(temp16_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 15);
-static SENSOR_DEVICE_ATTR(temp17_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 16);
-static SENSOR_DEVICE_ATTR(temp18_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 17);
-static SENSOR_DEVICE_ATTR(temp19_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 18);
-static SENSOR_DEVICE_ATTR(temp20_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 19);
-static SENSOR_DEVICE_ATTR(temp21_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 20);
-static SENSOR_DEVICE_ATTR(temp22_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 21);
-static SENSOR_DEVICE_ATTR(temp23_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 22);
-static SENSOR_DEVICE_ATTR(temp24_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 23);
-static SENSOR_DEVICE_ATTR(temp25_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 24);
-static SENSOR_DEVICE_ATTR(temp26_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 25);
-static SENSOR_DEVICE_ATTR(temp27_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 26);
-static SENSOR_DEVICE_ATTR(temp28_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 27);
-static SENSOR_DEVICE_ATTR(temp29_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 28);
-static SENSOR_DEVICE_ATTR(temp30_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 29);
-static SENSOR_DEVICE_ATTR(temp31_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 30);
-static SENSOR_DEVICE_ATTR(temp32_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 31);
-static SENSOR_DEVICE_ATTR(temp33_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 32);
-static SENSOR_DEVICE_ATTR(temp34_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 33);
-static SENSOR_DEVICE_ATTR(temp35_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 34);
-static SENSOR_DEVICE_ATTR(temp36_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 35);
-static SENSOR_DEVICE_ATTR(temp37_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 36);
-static SENSOR_DEVICE_ATTR(temp38_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 37);
-static SENSOR_DEVICE_ATTR(temp39_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 38);
-static SENSOR_DEVICE_ATTR(temp40_input, S_IRUGO,
-					applesmc_show_temperature, NULL, 39);
-
-static struct attribute *label_attributes[] = {
-	&sensor_dev_attr_temp1_label.dev_attr.attr,
-	&sensor_dev_attr_temp2_label.dev_attr.attr,
-	&sensor_dev_attr_temp3_label.dev_attr.attr,
-	&sensor_dev_attr_temp4_label.dev_attr.attr,
-	&sensor_dev_attr_temp5_label.dev_attr.attr,
-	&sensor_dev_attr_temp6_label.dev_attr.attr,
-	&sensor_dev_attr_temp7_label.dev_attr.attr,
-	&sensor_dev_attr_temp8_label.dev_attr.attr,
-	&sensor_dev_attr_temp9_label.dev_attr.attr,
-	&sensor_dev_attr_temp10_label.dev_attr.attr,
-	&sensor_dev_attr_temp11_label.dev_attr.attr,
-	&sensor_dev_attr_temp12_label.dev_attr.attr,
-	&sensor_dev_attr_temp13_label.dev_attr.attr,
-	&sensor_dev_attr_temp14_label.dev_attr.attr,
-	&sensor_dev_attr_temp15_label.dev_attr.attr,
-	&sensor_dev_attr_temp16_label.dev_attr.attr,
-	&sensor_dev_attr_temp17_label.dev_attr.attr,
-	&sensor_dev_attr_temp18_label.dev_attr.attr,
-	&sensor_dev_attr_temp19_label.dev_attr.attr,
-	&sensor_dev_attr_temp20_label.dev_attr.attr,
-	&sensor_dev_attr_temp21_label.dev_attr.attr,
-	&sensor_dev_attr_temp22_label.dev_attr.attr,
-	&sensor_dev_attr_temp23_label.dev_attr.attr,
-	&sensor_dev_attr_temp24_label.dev_attr.attr,
-	&sensor_dev_attr_temp25_label.dev_attr.attr,
-	&sensor_dev_attr_temp26_label.dev_attr.attr,
-	&sensor_dev_attr_temp27_label.dev_attr.attr,
-	&sensor_dev_attr_temp28_label.dev_attr.attr,
-	&sensor_dev_attr_temp29_label.dev_attr.attr,
-	&sensor_dev_attr_temp30_label.dev_attr.attr,
-	&sensor_dev_attr_temp31_label.dev_attr.attr,
-	&sensor_dev_attr_temp32_label.dev_attr.attr,
-	&sensor_dev_attr_temp33_label.dev_attr.attr,
-	&sensor_dev_attr_temp34_label.dev_attr.attr,
-	&sensor_dev_attr_temp35_label.dev_attr.attr,
-	&sensor_dev_attr_temp36_label.dev_attr.attr,
-	&sensor_dev_attr_temp37_label.dev_attr.attr,
-	&sensor_dev_attr_temp38_label.dev_attr.attr,
-	&sensor_dev_attr_temp39_label.dev_attr.attr,
-	&sensor_dev_attr_temp40_label.dev_attr.attr,
-	NULL
-};
-
-static struct attribute *temperature_attributes[] = {
-	&sensor_dev_attr_temp1_input.dev_attr.attr,
-	&sensor_dev_attr_temp2_input.dev_attr.attr,
-	&sensor_dev_attr_temp3_input.dev_attr.attr,
-	&sensor_dev_attr_temp4_input.dev_attr.attr,
-	&sensor_dev_attr_temp5_input.dev_attr.attr,
-	&sensor_dev_attr_temp6_input.dev_attr.attr,
-	&sensor_dev_attr_temp7_input.dev_attr.attr,
-	&sensor_dev_attr_temp8_input.dev_attr.attr,
-	&sensor_dev_attr_temp9_input.dev_attr.attr,
-	&sensor_dev_attr_temp10_input.dev_attr.attr,
-	&sensor_dev_attr_temp11_input.dev_attr.attr,
-	&sensor_dev_attr_temp12_input.dev_attr.attr,
-	&sensor_dev_attr_temp13_input.dev_attr.attr,
-	&sensor_dev_attr_temp14_input.dev_attr.attr,
-	&sensor_dev_attr_temp15_input.dev_attr.attr,
-	&sensor_dev_attr_temp16_input.dev_attr.attr,
-	&sensor_dev_attr_temp17_input.dev_attr.attr,
-	&sensor_dev_attr_temp18_input.dev_attr.attr,
-	&sensor_dev_attr_temp19_input.dev_attr.attr,
-	&sensor_dev_attr_temp20_input.dev_attr.attr,
-	&sensor_dev_attr_temp21_input.dev_attr.attr,
-	&sensor_dev_attr_temp22_input.dev_attr.attr,
-	&sensor_dev_attr_temp23_input.dev_attr.attr,
-	&sensor_dev_attr_temp24_input.dev_attr.attr,
-	&sensor_dev_attr_temp25_input.dev_attr.attr,
-	&sensor_dev_attr_temp26_input.dev_attr.attr,
-	&sensor_dev_attr_temp27_input.dev_attr.attr,
-	&sensor_dev_attr_temp28_input.dev_attr.attr,
-	&sensor_dev_attr_temp29_input.dev_attr.attr,
-	&sensor_dev_attr_temp30_input.dev_attr.attr,
-	&sensor_dev_attr_temp31_input.dev_attr.attr,
-	&sensor_dev_attr_temp32_input.dev_attr.attr,
-	&sensor_dev_attr_temp33_input.dev_attr.attr,
-	&sensor_dev_attr_temp34_input.dev_attr.attr,
-	&sensor_dev_attr_temp35_input.dev_attr.attr,
-	&sensor_dev_attr_temp36_input.dev_attr.attr,
-	&sensor_dev_attr_temp37_input.dev_attr.attr,
-	&sensor_dev_attr_temp38_input.dev_attr.attr,
-	&sensor_dev_attr_temp39_input.dev_attr.attr,
-	&sensor_dev_attr_temp40_input.dev_attr.attr,
-	NULL
-};
-
-static const struct attribute_group temperature_attributes_group =
-	{ .attrs = temperature_attributes };
-
-static const struct attribute_group label_attributes_group = {
-	.attrs = label_attributes
+static struct applesmc_node_group temp_group[] = {
+	{ "temp%d_label", applesmc_show_sensor_label },
+	{ "temp%d_input", applesmc_show_temperature },
+	{ }
 };
 
 /* Module stuff */
@@ -1422,7 +1111,6 @@ static const struct attribute_group label_attributes_group = {
  */
 static int applesmc_dmi_match(const struct dmi_system_id *id)
 {
-	int i = 0;
 	struct dmi_match_data* dmi_data = id->driver_data;
 	pr_info("%s detected:\n", id->ident);
 	applesmc_accelerometer = dmi_data->accelerometer;
@@ -1432,13 +1120,65 @@ static int applesmc_dmi_match(const struct dmi_system_id *id)
 	pr_info(" - Model %s light sensors and backlight\n",
 		applesmc_light ? "with" : "without");
 
-	applesmc_temperature_set =  dmi_data->temperature_set;
-	while (temperature_sensors_sets[applesmc_temperature_set][i] != NULL)
-		i++;
-	pr_info(" - Model with %d temperature sensors\n", i);
 	return 1;
 }
 
+/*
+ * applesmc_destroy_nodes - remove files and free associated memory
+ */
+static void applesmc_destroy_nodes(struct applesmc_node_group *groups)
+{
+	struct applesmc_node_group *grp;
+	struct applesmc_dev_attr *node;
+
+	for (grp = groups; grp->nodes; grp++) {
+		for (node = grp->nodes; node->sda.dev_attr.attr.name; node++)
+			sysfs_remove_file(&pdev->dev.kobj,
+					  &node->sda.dev_attr.attr);
+		kfree(grp->nodes);
+		grp->nodes = NULL;
+	}
+}
+
+/*
+ * applesmc_create_nodes - create a two-dimensional group of sysfs files
+ */
+static int applesmc_create_nodes(struct applesmc_node_group *groups, int num)
+{
+	struct applesmc_node_group *grp;
+	struct applesmc_dev_attr *node;
+	struct attribute *attr;
+	int ret, i;
+
+	for (grp = groups; grp->format; grp++) {
+		grp->nodes = kcalloc(num + 1, sizeof(*node), GFP_KERNEL);
+		if (!grp->nodes) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		for (i = 0; i < num; i++) {
+			node = &grp->nodes[i];
+			sprintf(node->name, grp->format, i + 1);
+			node->sda.index = i;
+			node->sda.dev_attr.show = grp->show;
+			node->sda.dev_attr.store = grp->store;
+			attr = &node->sda.dev_attr.attr;
+			attr->name = node->name;
+			attr->mode = S_IRUGO | (grp->store ? S_IWUSR : 0);
+			ret = sysfs_create_file(&pdev->dev.kobj, attr);
+			if (ret) {
+				attr->name = NULL;
+				goto out;
+			}
+		}
+	}
+
+	return 0;
+out:
+	applesmc_destroy_nodes(groups);
+	return ret;
+}
+
 /* Create accelerometer ressources */
 static int applesmc_create_accelerometer(void)
 {
@@ -1663,7 +1403,6 @@ static int __init applesmc_init(void)
 {
 	int ret;
 	int count;
-	int i;
 
 	if (!dmi_check_system(applesmc_whitelist)) {
 		pr_warn("supported laptop not found!\n");
@@ -1722,24 +1461,9 @@ static int __init applesmc_init(void)
 		fans_handled++;
 	}
 
-	for (i = 0;
-	     temperature_sensors_sets[applesmc_temperature_set][i] != NULL;
-	     i++) {
-		if (temperature_attributes[i] == NULL ||
-		    label_attributes[i] == NULL) {
-			pr_err("More temperature sensors in temperature_sensors_sets (at least %i) than available sysfs files in temperature_attributes (%i), please report this bug\n",
-			       i, i-1);
-			goto out_temperature;
-		}
-		ret = sysfs_create_file(&pdev->dev.kobj,
-						temperature_attributes[i]);
-		if (ret)
-			goto out_temperature;
-		ret = sysfs_create_file(&pdev->dev.kobj,
-						label_attributes[i]);
-		if (ret)
-			goto out_temperature;
-	}
+	ret = applesmc_create_nodes(temp_group, smcreg.temp_count);
+	if (ret)
+		goto out_fans;
 
 	if (applesmc_accelerometer) {
 		ret = applesmc_create_accelerometer();
@@ -1789,8 +1513,7 @@ out_accelerometer:
 	if (applesmc_accelerometer)
 		applesmc_release_accelerometer();
 out_temperature:
-	sysfs_remove_group(&pdev->dev.kobj, &label_attributes_group);
-	sysfs_remove_group(&pdev->dev.kobj, &temperature_attributes_group);
+	applesmc_destroy_nodes(temp_group);
 out_fans:
 	while (fans_handled)
 		sysfs_remove_group(&pdev->dev.kobj,
@@ -1821,8 +1544,7 @@ static void __exit applesmc_exit(void)
 	}
 	if (applesmc_accelerometer)
 		applesmc_release_accelerometer();
-	sysfs_remove_group(&pdev->dev.kobj, &label_attributes_group);
-	sysfs_remove_group(&pdev->dev.kobj, &temperature_attributes_group);
+	applesmc_destroy_nodes(temp_group);
 	while (fans_handled)
 		sysfs_remove_group(&pdev->dev.kobj,
 				   &fan_attribute_groups[--fans_handled]);
-- 
1.7.1

