Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2KDIjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 03:39:17 -0500
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:43854 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047Ab2KDIjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 03:39:12 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-16.arcor-online.net A658A862F
Subject: [PATCH 4/4] HID: roccat: Cleanup of koneplus module
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Nov 2012 09:39:09 +0100
Message-ID: <1352018349.2673.134.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed caching of profile data which lowers memory footprint,
speeds up init and fixes problems with device reset.
Removed unnecessary infos in header.
Code moved nearer to format of newer drivers.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-koneplus.c |  371 +++++++++----------------------------
 drivers/hid/hid-roccat-koneplus.h |   99 ++---------
 2 files changed, 102 insertions(+), 368 deletions(-)

diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 69592f4..9fe4450 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -56,56 +56,6 @@ static int koneplus_send_control(struct usb_device *usb_dev, uint value,
 			&control, sizeof(struct roccat_common2_control));
 }
 
-static int koneplus_get_info(struct usb_device *usb_dev,
-		struct koneplus_info *buf)
-{
-	return roccat_common2_receive(usb_dev, KONEPLUS_COMMAND_INFO,
-			buf, sizeof(struct koneplus_info));
-}
-
-static int koneplus_get_profile_settings(struct usb_device *usb_dev,
-		struct koneplus_profile_settings *buf, uint number)
-{
-	int retval;
-
-	retval = koneplus_send_control(usb_dev, number,
-			KONEPLUS_CONTROL_REQUEST_PROFILE_SETTINGS);
-	if (retval)
-		return retval;
-
-	return roccat_common2_receive(usb_dev, KONEPLUS_COMMAND_PROFILE_SETTINGS,
-			buf, sizeof(struct koneplus_profile_settings));
-}
-
-static int koneplus_set_profile_settings(struct usb_device *usb_dev,
-		struct koneplus_profile_settings const *settings)
-{
-	return roccat_common2_send_with_status(usb_dev,
-			KONEPLUS_COMMAND_PROFILE_SETTINGS,
-			settings, sizeof(struct koneplus_profile_settings));
-}
-
-static int koneplus_get_profile_buttons(struct usb_device *usb_dev,
-		struct koneplus_profile_buttons *buf, int number)
-{
-	int retval;
-
-	retval = koneplus_send_control(usb_dev, number,
-			KONEPLUS_CONTROL_REQUEST_PROFILE_BUTTONS);
-	if (retval)
-		return retval;
-
-	return roccat_common2_receive(usb_dev, KONEPLUS_COMMAND_PROFILE_BUTTONS,
-			buf, sizeof(struct koneplus_profile_buttons));
-}
-
-static int koneplus_set_profile_buttons(struct usb_device *usb_dev,
-		struct koneplus_profile_buttons const *buttons)
-{
-	return roccat_common2_send_with_status(usb_dev,
-			KONEPLUS_COMMAND_PROFILE_BUTTONS,
-			buttons, sizeof(struct koneplus_profile_buttons));
-}
 
 /* retval is 0-4 on success, < 0 on error */
 static int koneplus_get_actual_profile(struct usb_device *usb_dev)
@@ -114,7 +64,7 @@ static int koneplus_get_actual_profile(struct usb_device *usb_dev)
 	int retval;
 
 	retval = roccat_common2_receive(usb_dev, KONEPLUS_COMMAND_ACTUAL_PROFILE,
-			&buf, sizeof(struct koneplus_actual_profile));
+			&buf, KONEPLUS_SIZE_ACTUAL_PROFILE);
 
 	return retval ? retval : buf.actual_profile;
 }
@@ -125,12 +75,12 @@ static int koneplus_set_actual_profile(struct usb_device *usb_dev,
 	struct koneplus_actual_profile buf;
 
 	buf.command = KONEPLUS_COMMAND_ACTUAL_PROFILE;
-	buf.size = sizeof(struct koneplus_actual_profile);
+	buf.size = KONEPLUS_SIZE_ACTUAL_PROFILE;
 	buf.actual_profile = new_profile;
 
 	return roccat_common2_send_with_status(usb_dev,
 			KONEPLUS_COMMAND_ACTUAL_PROFILE,
-			&buf, sizeof(struct koneplus_actual_profile));
+			&buf, KONEPLUS_SIZE_ACTUAL_PROFILE);
 }
 
 static ssize_t koneplus_sysfs_read(struct file *fp, struct kobject *kobj,
@@ -183,77 +133,58 @@ static ssize_t koneplus_sysfs_write(struct file *fp, struct kobject *kobj,
 	return real_size;
 }
 
-static ssize_t koneplus_sysfs_read_info(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_read(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_info), KONEPLUS_COMMAND_INFO);
+#define KONEPLUS_SYSFS_W(thingy, THINGY) \
+static ssize_t koneplus_sysfs_write_ ## thingy(struct file *fp, \
+		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
+		loff_t off, size_t count) \
+{ \
+	return koneplus_sysfs_write(fp, kobj, buf, off, count, \
+			KONEPLUS_SIZE_ ## THINGY, KONEPLUS_COMMAND_ ## THINGY); \
 }
 
-static ssize_t koneplus_sysfs_write_info(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_write(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_info), KONEPLUS_COMMAND_INFO);
+#define KONEPLUS_SYSFS_R(thingy, THINGY) \
+static ssize_t koneplus_sysfs_read_ ## thingy(struct file *fp, \
+		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
+		loff_t off, size_t count) \
+{ \
+	return koneplus_sysfs_read(fp, kobj, buf, off, count, \
+			KONEPLUS_SIZE_ ## THINGY, KONEPLUS_COMMAND_ ## THINGY); \
 }
 
-static ssize_t koneplus_sysfs_write_talk(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_write(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_talk), KONEPLUS_COMMAND_TALK);
-}
+#define KONEPLUS_SYSFS_RW(thingy, THINGY) \
+KONEPLUS_SYSFS_W(thingy, THINGY) \
+KONEPLUS_SYSFS_R(thingy, THINGY)
 
-static ssize_t koneplus_sysfs_write_macro(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_write(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_macro), KONEPLUS_COMMAND_MACRO);
+#define KONEPLUS_BIN_ATTRIBUTE_RW(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0660 }, \
+	.size = KONEPLUS_SIZE_ ## THINGY, \
+	.read = koneplus_sysfs_read_ ## thingy, \
+	.write = koneplus_sysfs_write_ ## thingy \
 }
 
-static ssize_t koneplus_sysfs_read_sensor(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_read(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_sensor), KONEPLUS_COMMAND_SENSOR);
+#define KONEPLUS_BIN_ATTRIBUTE_R(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0440 }, \
+	.size = KONEPLUS_SIZE_ ## THINGY, \
+	.read = koneplus_sysfs_read_ ## thingy, \
 }
 
-static ssize_t koneplus_sysfs_write_sensor(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_write(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_sensor), KONEPLUS_COMMAND_SENSOR);
+#define KONEPLUS_BIN_ATTRIBUTE_W(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0220 }, \
+	.size = KONEPLUS_SIZE_ ## THINGY, \
+	.write = koneplus_sysfs_write_ ## thingy \
 }
 
-static ssize_t koneplus_sysfs_write_tcu(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_write(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_tcu), KONEPLUS_COMMAND_TCU);
-}
-
-static ssize_t koneplus_sysfs_read_tcu(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_read(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_tcu), KONEPLUS_COMMAND_TCU);
-}
-
-static ssize_t koneplus_sysfs_read_tcu_image(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_read(fp, kobj, buf, off, count,
-			sizeof(struct koneplus_tcu_image), KONEPLUS_COMMAND_TCU);
-}
+KONEPLUS_SYSFS_RW(info, INFO)
+KONEPLUS_SYSFS_W(talk, TALK)
+KONEPLUS_SYSFS_W(macro, MACRO)
+KONEPLUS_SYSFS_RW(sensor, SENSOR)
+KONEPLUS_SYSFS_RW(tcu, TCU)
+KONEPLUS_SYSFS_R(tcu_image, TCU_IMAGE)
+KONEPLUS_SYSFS_W(profile_settings, PROFILE_SETTINGS)
+KONEPLUS_SYSFS_W(profile_buttons, PROFILE_BUTTONS)
 
 static ssize_t koneplus_sysfs_read_profilex_settings(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
@@ -261,57 +192,17 @@ static ssize_t koneplus_sysfs_read_profilex_settings(struct file *fp,
 {
 	struct device *dev =
 			container_of(kobj, struct device, kobj)->parent->parent;
-	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
-
-	if (off >= sizeof(struct koneplus_profile_settings))
-		return 0;
-
-	if (off + count > sizeof(struct koneplus_profile_settings))
-		count = sizeof(struct koneplus_profile_settings) - off;
-
-	mutex_lock(&koneplus->koneplus_lock);
-	memcpy(buf, ((char const *)&koneplus->profile_settings[*(uint *)(attr->private)]) + off,
-			count);
-	mutex_unlock(&koneplus->koneplus_lock);
-
-	return count;
-}
-
-static ssize_t koneplus_sysfs_write_profile_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	struct device *dev =
-			container_of(kobj, struct device, kobj)->parent->parent;
-	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
-	int retval = 0;
-	int difference;
-	int profile_number;
-	struct koneplus_profile_settings *profile_settings;
-
-	if (off != 0 || count != sizeof(struct koneplus_profile_settings))
-		return -EINVAL;
-
-	profile_number = ((struct koneplus_profile_settings const *)buf)->number;
-	profile_settings = &koneplus->profile_settings[profile_number];
-
-	mutex_lock(&koneplus->koneplus_lock);
-	difference = memcmp(buf, profile_settings,
-			sizeof(struct koneplus_profile_settings));
-	if (difference) {
-		retval = koneplus_set_profile_settings(usb_dev,
-				(struct koneplus_profile_settings const *)buf);
-		if (!retval)
-			memcpy(profile_settings, buf,
-					sizeof(struct koneplus_profile_settings));
-	}
-	mutex_unlock(&koneplus->koneplus_lock);
+	ssize_t retval;
 
+	retval = koneplus_send_control(usb_dev, *(uint *)(attr->private),
+			KONEPLUS_CONTROL_REQUEST_PROFILE_SETTINGS);
 	if (retval)
 		return retval;
 
-	return sizeof(struct koneplus_profile_settings);
+	return koneplus_sysfs_read(fp, kobj, buf, off, count,
+			KONEPLUS_SIZE_PROFILE_SETTINGS,
+			KONEPLUS_COMMAND_PROFILE_SETTINGS);
 }
 
 static ssize_t koneplus_sysfs_read_profilex_buttons(struct file *fp,
@@ -320,57 +211,17 @@ static ssize_t koneplus_sysfs_read_profilex_buttons(struct file *fp,
 {
 	struct device *dev =
 			container_of(kobj, struct device, kobj)->parent->parent;
-	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
-
-	if (off >= sizeof(struct koneplus_profile_buttons))
-		return 0;
-
-	if (off + count > sizeof(struct koneplus_profile_buttons))
-		count = sizeof(struct koneplus_profile_buttons) - off;
-
-	mutex_lock(&koneplus->koneplus_lock);
-	memcpy(buf, ((char const *)&koneplus->profile_buttons[*(uint *)(attr->private)]) + off,
-			count);
-	mutex_unlock(&koneplus->koneplus_lock);
-
-	return count;
-}
-
-static ssize_t koneplus_sysfs_write_profile_buttons(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	struct device *dev =
-			container_of(kobj, struct device, kobj)->parent->parent;
-	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
-	int retval = 0;
-	int difference;
-	uint profile_number;
-	struct koneplus_profile_buttons *profile_buttons;
-
-	if (off != 0 || count != sizeof(struct koneplus_profile_buttons))
-		return -EINVAL;
-
-	profile_number = ((struct koneplus_profile_buttons const *)buf)->number;
-	profile_buttons = &koneplus->profile_buttons[profile_number];
-
-	mutex_lock(&koneplus->koneplus_lock);
-	difference = memcmp(buf, profile_buttons,
-			sizeof(struct koneplus_profile_buttons));
-	if (difference) {
-		retval = koneplus_set_profile_buttons(usb_dev,
-				(struct koneplus_profile_buttons const *)buf);
-		if (!retval)
-			memcpy(profile_buttons, buf,
-					sizeof(struct koneplus_profile_buttons));
-	}
-	mutex_unlock(&koneplus->koneplus_lock);
+	ssize_t retval;
 
+	retval = koneplus_send_control(usb_dev, *(uint *)(attr->private),
+			KONEPLUS_CONTROL_REQUEST_PROFILE_BUTTONS);
 	if (retval)
 		return retval;
 
-	return sizeof(struct koneplus_profile_buttons);
+	return koneplus_sysfs_read(fp, kobj, buf, off, count,
+			KONEPLUS_SIZE_PROFILE_BUTTONS,
+			KONEPLUS_COMMAND_PROFILE_BUTTONS);
 }
 
 static ssize_t koneplus_sysfs_show_actual_profile(struct device *dev,
@@ -426,9 +277,20 @@ static ssize_t koneplus_sysfs_set_actual_profile(struct device *dev,
 static ssize_t koneplus_sysfs_show_firmware_version(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct koneplus_device *koneplus =
-			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
-	return snprintf(buf, PAGE_SIZE, "%d\n", koneplus->info.firmware_version);
+	struct koneplus_device *koneplus;
+	struct usb_device *usb_dev;
+	struct koneplus_info info;
+
+	dev = dev->parent->parent;
+	koneplus = hid_get_drvdata(dev_get_drvdata(dev));
+	usb_dev = interface_to_usbdev(to_usb_interface(dev));
+
+	mutex_lock(&koneplus->koneplus_lock);
+	roccat_common2_receive(usb_dev, KONEPLUS_COMMAND_INFO,
+			&info, KONEPLUS_SIZE_INFO);
+	mutex_unlock(&koneplus->koneplus_lock);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", info.firmware_version);
 }
 
 static struct device_attribute koneplus_attributes[] = {
@@ -444,139 +306,84 @@ static struct device_attribute koneplus_attributes[] = {
 };
 
 static struct bin_attribute koneplus_bin_attributes[] = {
-	{
-		.attr = { .name = "info", .mode = 0660 },
-		.size = sizeof(struct koneplus_info),
-		.read = koneplus_sysfs_read_info,
-		.write = koneplus_sysfs_write_info
-	},
-	{
-		.attr = { .name = "sensor", .mode = 0660 },
-		.size = sizeof(struct koneplus_sensor),
-		.read = koneplus_sysfs_read_sensor,
-		.write = koneplus_sysfs_write_sensor
-	},
-	{
-		.attr = { .name = "tcu", .mode = 0660 },
-		.size = sizeof(struct koneplus_tcu),
-		.read = koneplus_sysfs_read_tcu,
-		.write = koneplus_sysfs_write_tcu
-	},
-	{
-		.attr = { .name = "tcu_image", .mode = 0440 },
-		.size = sizeof(struct koneplus_tcu_image),
-		.read = koneplus_sysfs_read_tcu_image
-	},
-	{
-		.attr = { .name = "profile_settings", .mode = 0220 },
-		.size = sizeof(struct koneplus_profile_settings),
-		.write = koneplus_sysfs_write_profile_settings
-	},
+	KONEPLUS_BIN_ATTRIBUTE_RW(info, INFO),
+	KONEPLUS_BIN_ATTRIBUTE_W(talk, TALK),
+	KONEPLUS_BIN_ATTRIBUTE_W(macro, MACRO),
+	KONEPLUS_BIN_ATTRIBUTE_RW(sensor, SENSOR),
+	KONEPLUS_BIN_ATTRIBUTE_RW(tcu, TCU),
+	KONEPLUS_BIN_ATTRIBUTE_R(tcu_image, TCU_IMAGE),
+	KONEPLUS_BIN_ATTRIBUTE_W(profile_settings, PROFILE_SETTINGS),
+	KONEPLUS_BIN_ATTRIBUTE_W(profile_buttons, PROFILE_BUTTONS),
 	{
 		.attr = { .name = "profile1_settings", .mode = 0440 },
-		.size = sizeof(struct koneplus_profile_settings),
+		.size = KONEPLUS_SIZE_PROFILE_SETTINGS,
 		.read = koneplus_sysfs_read_profilex_settings,
 		.private = &profile_numbers[0]
 	},
 	{
 		.attr = { .name = "profile2_settings", .mode = 0440 },
-		.size = sizeof(struct koneplus_profile_settings),
+		.size = KONEPLUS_SIZE_PROFILE_SETTINGS,
 		.read = koneplus_sysfs_read_profilex_settings,
 		.private = &profile_numbers[1]
 	},
 	{
 		.attr = { .name = "profile3_settings", .mode = 0440 },
-		.size = sizeof(struct koneplus_profile_settings),
+		.size = KONEPLUS_SIZE_PROFILE_SETTINGS,
 		.read = koneplus_sysfs_read_profilex_settings,
 		.private = &profile_numbers[2]
 	},
 	{
 		.attr = { .name = "profile4_settings", .mode = 0440 },
-		.size = sizeof(struct koneplus_profile_settings),
+		.size = KONEPLUS_SIZE_PROFILE_SETTINGS,
 		.read = koneplus_sysfs_read_profilex_settings,
 		.private = &profile_numbers[3]
 	},
 	{
 		.attr = { .name = "profile5_settings", .mode = 0440 },
-		.size = sizeof(struct koneplus_profile_settings),
+		.size = KONEPLUS_SIZE_PROFILE_SETTINGS,
 		.read = koneplus_sysfs_read_profilex_settings,
 		.private = &profile_numbers[4]
 	},
 	{
-		.attr = { .name = "profile_buttons", .mode = 0220 },
-		.size = sizeof(struct koneplus_profile_buttons),
-		.write = koneplus_sysfs_write_profile_buttons
-	},
-	{
 		.attr = { .name = "profile1_buttons", .mode = 0440 },
-		.size = sizeof(struct koneplus_profile_buttons),
+		.size = KONEPLUS_SIZE_PROFILE_BUTTONS,
 		.read = koneplus_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[0]
 	},
 	{
 		.attr = { .name = "profile2_buttons", .mode = 0440 },
-		.size = sizeof(struct koneplus_profile_buttons),
+		.size = KONEPLUS_SIZE_PROFILE_BUTTONS,
 		.read = koneplus_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[1]
 	},
 	{
 		.attr = { .name = "profile3_buttons", .mode = 0440 },
-		.size = sizeof(struct koneplus_profile_buttons),
+		.size = KONEPLUS_SIZE_PROFILE_BUTTONS,
 		.read = koneplus_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[2]
 	},
 	{
 		.attr = { .name = "profile4_buttons", .mode = 0440 },
-		.size = sizeof(struct koneplus_profile_buttons),
+		.size = KONEPLUS_SIZE_PROFILE_BUTTONS,
 		.read = koneplus_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[3]
 	},
 	{
 		.attr = { .name = "profile5_buttons", .mode = 0440 },
-		.size = sizeof(struct koneplus_profile_buttons),
+		.size = KONEPLUS_SIZE_PROFILE_BUTTONS,
 		.read = koneplus_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[4]
 	},
-	{
-		.attr = { .name = "macro", .mode = 0220 },
-		.size = sizeof(struct koneplus_macro),
-		.write = koneplus_sysfs_write_macro
-	},
-	{
-		.attr = { .name = "talk", .mode = 0220 },
-		.size = sizeof(struct koneplus_talk),
-		.write = koneplus_sysfs_write_talk
-	},
 	__ATTR_NULL
 };
 
 static int koneplus_init_koneplus_device_struct(struct usb_device *usb_dev,
 		struct koneplus_device *koneplus)
 {
-	int retval, i;
-	static uint wait = 200;
+	int retval;
 
 	mutex_init(&koneplus->koneplus_lock);
 
-	retval = koneplus_get_info(usb_dev, &koneplus->info);
-	if (retval)
-		return retval;
-
-	for (i = 0; i < 5; ++i) {
-		msleep(wait);
-		retval = koneplus_get_profile_settings(usb_dev,
-				&koneplus->profile_settings[i], i);
-		if (retval)
-			return retval;
-
-		msleep(wait);
-		retval = koneplus_get_profile_buttons(usb_dev,
-				&koneplus->profile_buttons[i], i);
-		if (retval)
-			return retval;
-	}
-
-	msleep(wait);
 	retval = koneplus_get_actual_profile(usb_dev);
 	if (retval < 0)
 		return retval;
diff --git a/drivers/hid/hid-roccat-koneplus.h b/drivers/hid/hid-roccat-koneplus.h
index 7074b2a..563b9d3 100644
--- a/drivers/hid/hid-roccat-koneplus.h
+++ b/drivers/hid/hid-roccat-koneplus.h
@@ -14,11 +14,18 @@
 
 #include <linux/types.h>
 
-struct koneplus_talk {
-	uint8_t command; /* KONEPLUS_COMMAND_TALK */
-	uint8_t size; /* always 0x10 */
-	uint8_t data[14];
-} __packed;
+enum {
+	KONEPLUS_SIZE_ACTUAL_PROFILE = 0x03,
+	KONEPLUS_SIZE_FIRMWARE_WRITE = 0x0402,
+	KONEPLUS_SIZE_INFO = 0x06,
+	KONEPLUS_SIZE_MACRO = 0x0822,
+	KONEPLUS_SIZE_PROFILE_SETTINGS = 0x2b,
+	KONEPLUS_SIZE_PROFILE_BUTTONS = 0x4d,
+	KONEPLUS_SIZE_SENSOR = 0x06,
+	KONEPLUS_SIZE_TALK = 0x10,
+	KONEPLUS_SIZE_TCU = 0x03,
+	KONEPLUS_SIZE_TCU_IMAGE = 0x0404,
+};
 
 enum koneplus_control_requests {
 	KONEPLUS_CONTROL_REQUEST_PROFILE_SETTINGS = 0x80,
@@ -31,45 +38,6 @@ struct koneplus_actual_profile {
 	uint8_t actual_profile; /* Range 0-4! */
 } __attribute__ ((__packed__));
 
-struct koneplus_profile_settings {
-	uint8_t command; /* KONEPLUS_COMMAND_PROFILE_SETTINGS */
-	uint8_t size; /* always 43 */
-	uint8_t number; /* range 0-4 */
-	uint8_t advanced_sensitivity;
-	uint8_t sensitivity_x;
-	uint8_t sensitivity_y;
-	uint8_t cpi_levels_enabled;
-	uint8_t cpi_levels_x[5];
-	uint8_t cpi_startup_level; /* range 0-4 */
-	uint8_t cpi_levels_y[5]; /* range 1-60 means 100-6000 cpi */
-	uint8_t unknown1;
-	uint8_t polling_rate;
-	uint8_t lights_enabled;
-	uint8_t light_effect_mode;
-	uint8_t color_flow_effect;
-	uint8_t light_effect_type;
-	uint8_t light_effect_speed;
-	uint8_t lights[16];
-	uint16_t checksum;
-} __attribute__ ((__packed__));
-
-struct koneplus_profile_buttons {
-	uint8_t command; /* KONEPLUS_COMMAND_PROFILE_BUTTONS */
-	uint8_t size; /* always 77 */
-	uint8_t number; /* range 0-4 */
-	uint8_t data[72];
-	uint16_t checksum;
-} __attribute__ ((__packed__));
-
-struct koneplus_macro {
-	uint8_t command; /* KONEPLUS_COMMAND_MACRO */
-	uint16_t size; /* always 0x822 little endian */
-	uint8_t profile; /* range 0-4 */
-	uint8_t button; /* range 0-23 */
-	uint8_t data[2075];
-	uint16_t checksum;
-} __attribute__ ((__packed__));
-
 struct koneplus_info {
 	uint8_t command; /* KONEPLUS_COMMAND_INFO */
 	uint8_t size; /* always 6 */
@@ -77,44 +45,6 @@ struct koneplus_info {
 	uint8_t unknown[3];
 } __attribute__ ((__packed__));
 
-struct koneplus_e {
-	uint8_t command; /* KONEPLUS_COMMAND_E */
-	uint8_t size; /* always 3 */
-	uint8_t unknown; /* TODO 1; 0 before firmware update */
-} __attribute__ ((__packed__));
-
-struct koneplus_sensor {
-	uint8_t command;  /* KONEPLUS_COMMAND_SENSOR */
-	uint8_t size; /* always 6 */
-	uint8_t data[4];
-} __attribute__ ((__packed__));
-
-struct koneplus_firmware_write {
-	uint8_t command; /* KONEPLUS_COMMAND_FIRMWARE_WRITE */
-	uint8_t unknown[1025];
-} __attribute__ ((__packed__));
-
-struct koneplus_firmware_write_control {
-	uint8_t command; /* KONEPLUS_COMMAND_FIRMWARE_WRITE_CONTROL */
-	/*
-	 * value is 1 on success
-	 * 3 means "not finished yet"
-	 */
-	uint8_t value;
-	uint8_t unknown; /* always 0x75 */
-} __attribute__ ((__packed__));
-
-struct koneplus_tcu {
-	uint16_t usb_command; /* KONEPLUS_USB_COMMAND_TCU */
-	uint8_t data[2];
-} __attribute__ ((__packed__));
-
-struct koneplus_tcu_image {
-	uint16_t usb_command; /* KONEPLUS_USB_COMMAND_TCU */
-	uint8_t data[1024];
-	uint16_t checksum;
-} __attribute__ ((__packed__));
-
 enum koneplus_commands {
 	KONEPLUS_COMMAND_ACTUAL_PROFILE = 0x5,
 	KONEPLUS_COMMAND_PROFILE_SETTINGS = 0x6,
@@ -122,6 +52,7 @@ enum koneplus_commands {
 	KONEPLUS_COMMAND_MACRO = 0x8,
 	KONEPLUS_COMMAND_INFO = 0x9,
 	KONEPLUS_COMMAND_TCU = 0xc,
+	KONEPLUS_COMMAND_TCU_IMAGE = 0xc,
 	KONEPLUS_COMMAND_E = 0xe,
 	KONEPLUS_COMMAND_SENSOR = 0xf,
 	KONEPLUS_COMMAND_TALK = 0x10,
@@ -187,10 +118,6 @@ struct koneplus_device {
 	int chrdev_minor;
 
 	struct mutex koneplus_lock;
-
-	struct koneplus_info info;
-	struct koneplus_profile_settings profile_settings[5];
-	struct koneplus_profile_buttons profile_buttons[5];
 };
 
 #endif
-- 
1.7.3.4



