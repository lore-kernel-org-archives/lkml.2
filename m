Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab2KKFWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 00:22:51 -0500
Received: from mout.web.de ([212.227.17.11]:61766 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab2KKFVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 00:21:06 -0500
Subject: [PATCH 1/7] HID: roccat: Cleanup of kovaplus module
From: Stefan Achatz <stefan_achatz@web.de>
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Nov 2012 06:20:52 +0100
Message-ID: <1352611252.2463.215.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:3HKIcPU2ixz4HDchLJOA6yCzG3HHbYUwwsyKehlqKbW
 nugm3oXBXoh0QFpfjgQVmyCGx8AoAww2bgmWc0Cpjlq5aE2A3g
 MlYySXBBqsjmlSLK2jp/DiPL/QAeBEZXFmusXVSLX7yHYpJAgu
 MpfObnaR2X7W1xuUj5YzG63lOR8vvxpo2hiGH23t1iqJ/FFng9
 1lD4RijwSKCh0lBwANMKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Partially removed unneeded informations and data caching.
Moved code nearer to format of newer drivers.
Added "info" sysfs attribute to support device reset and deprecate other attributes.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/obsolete/sysfs-driver-hid-roccat-kovaplus  |   41 ++++
 .../ABI/testing/sysfs-driver-hid-roccat-kovaplus   |   40 +---
 drivers/hid/hid-roccat-kovaplus.c                  |  235 ++++++++++----------
 drivers/hid/hid-roccat-kovaplus.h                  |   14 +-
 4 files changed, 167 insertions(+), 163 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus

diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus
new file mode 100644
index 0000000..4d9fb262
--- /dev/null
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-kovaplus
@@ -0,0 +1,41 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_cpi
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 1-4.
+		When read, this attribute returns the number of the active
+		cpi level.
+		This file is readonly.
+		Has never been used. If bookkeeping is done, it's done in userland tools.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_sensitivity_x
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 1-10.
+		When read, this attribute returns the number of the actual
+		sensitivity in x direction.
+		This file is readonly.
+		Has never been used. If bookkeeping is done, it's done in userland tools.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_sensitivity_y
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 1-10.
+		When read, this attribute returns the number of the actual
+		sensitivity in y direction.
+		This file is readonly.
+		Has never been used. If bookkeeping is done, it's done in userland tools.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/firmware_version
+Date:		January 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the raw integer version number of the
+		firmware reported by the mouse. Using the integer value eases
+		further usage in other programs. To receive the real version
+		number the decimal point has to be shifted 2 positions to the
+		left. E.g. a returned value of 121 means 1.21
+		This file is readonly.
+		Obsoleted by binary sysfs attribute "info".
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
index 20f937c..507f2c7 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
@@ -1,12 +1,3 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_cpi
-Date:		January 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The integer value of this attribute ranges from 1-4.
-		When read, this attribute returns the number of the active
-		cpi level.
-		This file is readonly.
-Users:		http://roccat.sourceforge.net
-
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_profile
 Date:		January 2011
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
@@ -18,33 +9,12 @@ Description:	The integer value of this attribute ranges from 0-4.
 		active when the mouse is powered on.
 Users:		http://roccat.sourceforge.net
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_sensitivity_x
-Date:		January 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The integer value of this attribute ranges from 1-10.
-		When read, this attribute returns the number of the actual
-		sensitivity in x direction.
-		This file is readonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_sensitivity_y
-Date:		January 2011
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/info
+Date:		November 2012
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The integer value of this attribute ranges from 1-10.
-		When read, this attribute returns the number of the actual
-		sensitivity in y direction.
-		This file is readonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/firmware_version
-Date:		January 2011
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns the raw integer version number of the
-		firmware reported by the mouse. Using the integer value eases
-		further usage in other programs. To receive the real version
-		number the decimal point has to be shifted 2 positions to the
-		left. E.g. a returned value of 121 means 1.21
-		This file is readonly.
+Description:	When read, this file returns general data like firmware version.
+		When written, the device can be reset.
+		The data is 6 bytes long.
 Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile_buttons
diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index ca6527a..1589fd3 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -70,13 +70,6 @@ static int kovaplus_select_profile(struct usb_device *usb_dev, uint number,
 	return kovaplus_send_control(usb_dev, number, request);
 }
 
-static int kovaplus_get_info(struct usb_device *usb_dev,
-		struct kovaplus_info *buf)
-{
-	return roccat_common2_receive(usb_dev, KOVAPLUS_COMMAND_INFO,
-			buf, sizeof(struct kovaplus_info));
-}
-
 static int kovaplus_get_profile_settings(struct usb_device *usb_dev,
 		struct kovaplus_profile_settings *buf, uint number)
 {
@@ -88,15 +81,7 @@ static int kovaplus_get_profile_settings(struct usb_device *usb_dev,
 		return retval;
 
 	return roccat_common2_receive(usb_dev, KOVAPLUS_COMMAND_PROFILE_SETTINGS,
-			buf, sizeof(struct kovaplus_profile_settings));
-}
-
-static int kovaplus_set_profile_settings(struct usb_device *usb_dev,
-		struct kovaplus_profile_settings const *settings)
-{
-	return roccat_common2_send_with_status(usb_dev,
-			KOVAPLUS_COMMAND_PROFILE_SETTINGS,
-			settings, sizeof(struct kovaplus_profile_settings));
+			buf, KOVAPLUS_SIZE_PROFILE_SETTINGS);
 }
 
 static int kovaplus_get_profile_buttons(struct usb_device *usb_dev,
@@ -110,15 +95,7 @@ static int kovaplus_get_profile_buttons(struct usb_device *usb_dev,
 		return retval;
 
 	return roccat_common2_receive(usb_dev, KOVAPLUS_COMMAND_PROFILE_BUTTONS,
-			buf, sizeof(struct kovaplus_profile_buttons));
-}
-
-static int kovaplus_set_profile_buttons(struct usb_device *usb_dev,
-		struct kovaplus_profile_buttons const *buttons)
-{
-	return roccat_common2_send_with_status(usb_dev,
-			KOVAPLUS_COMMAND_PROFILE_BUTTONS,
-			buttons, sizeof(struct kovaplus_profile_buttons));
+			buf, KOVAPLUS_SIZE_PROFILE_BUTTONS);
 }
 
 /* retval is 0-4 on success, < 0 on error */
@@ -147,122 +124,140 @@ static int kovaplus_set_actual_profile(struct usb_device *usb_dev,
 			&buf, sizeof(struct kovaplus_actual_profile));
 }
 
-static ssize_t kovaplus_sysfs_read_profilex_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
+static ssize_t kovaplus_sysfs_read(struct file *fp, struct kobject *kobj,
+		char *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
 {
 	struct device *dev =
 			container_of(kobj, struct device, kobj)->parent->parent;
 	struct kovaplus_device *kovaplus = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
 
-	if (off >= sizeof(struct kovaplus_profile_settings))
+	if (off >= real_size)
 		return 0;
 
-	if (off + count > sizeof(struct kovaplus_profile_settings))
-		count = sizeof(struct kovaplus_profile_settings) - off;
+	if (off != 0 || count != real_size)
+		return -EINVAL;
 
 	mutex_lock(&kovaplus->kovaplus_lock);
-	memcpy(buf, ((char const *)&kovaplus->profile_settings[*(uint *)(attr->private)]) + off,
-			count);
+	retval = roccat_common2_receive(usb_dev, command, buf, real_size);
 	mutex_unlock(&kovaplus->kovaplus_lock);
 
-	return count;
+	if (retval)
+		return retval;
+
+	return real_size;
 }
 
-static ssize_t kovaplus_sysfs_write_profile_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
+static ssize_t kovaplus_sysfs_write(struct file *fp, struct kobject *kobj,
+		void const *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
 {
 	struct device *dev =
 			container_of(kobj, struct device, kobj)->parent->parent;
 	struct kovaplus_device *kovaplus = hid_get_drvdata(dev_get_drvdata(dev));
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
-	int retval = 0;
-	int difference;
-	int profile_index;
-	struct kovaplus_profile_settings *profile_settings;
+	int retval;
 
-	if (off != 0 || count != sizeof(struct kovaplus_profile_settings))
+	if (off != 0 || count != real_size)
 		return -EINVAL;
 
-	profile_index = ((struct kovaplus_profile_settings const *)buf)->profile_index;
-	profile_settings = &kovaplus->profile_settings[profile_index];
-
 	mutex_lock(&kovaplus->kovaplus_lock);
-	difference = memcmp(buf, profile_settings,
-			sizeof(struct kovaplus_profile_settings));
-	if (difference) {
-		retval = kovaplus_set_profile_settings(usb_dev,
-				(struct kovaplus_profile_settings const *)buf);
-		if (!retval)
-			memcpy(profile_settings, buf,
-					sizeof(struct kovaplus_profile_settings));
-	}
+	retval = roccat_common2_send_with_status(usb_dev, command,
+			buf, real_size);
 	mutex_unlock(&kovaplus->kovaplus_lock);
 
 	if (retval)
 		return retval;
 
-	return sizeof(struct kovaplus_profile_settings);
+	return real_size;
 }
 
-static ssize_t kovaplus_sysfs_read_profilex_buttons(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	struct device *dev =
-			container_of(kobj, struct device, kobj)->parent->parent;
-	struct kovaplus_device *kovaplus = hid_get_drvdata(dev_get_drvdata(dev));
+#define KOVAPLUS_SYSFS_W(thingy, THINGY) \
+static ssize_t kovaplus_sysfs_write_ ## thingy(struct file *fp, \
+		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
+		loff_t off, size_t count) \
+{ \
+	return kovaplus_sysfs_write(fp, kobj, buf, off, count, \
+			KOVAPLUS_SIZE_ ## THINGY, KOVAPLUS_COMMAND_ ## THINGY); \
+}
 
-	if (off >= sizeof(struct kovaplus_profile_buttons))
-		return 0;
+#define KOVAPLUS_SYSFS_R(thingy, THINGY) \
+static ssize_t kovaplus_sysfs_read_ ## thingy(struct file *fp, \
+		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
+		loff_t off, size_t count) \
+{ \
+	return kovaplus_sysfs_read(fp, kobj, buf, off, count, \
+			KOVAPLUS_SIZE_ ## THINGY, KOVAPLUS_COMMAND_ ## THINGY); \
+}
 
-	if (off + count > sizeof(struct kovaplus_profile_buttons))
-		count = sizeof(struct kovaplus_profile_buttons) - off;
+#define KOVAPLUS_SYSFS_RW(thingy, THINGY) \
+KOVAPLUS_SYSFS_W(thingy, THINGY) \
+KOVAPLUS_SYSFS_R(thingy, THINGY)
 
-	mutex_lock(&kovaplus->kovaplus_lock);
-	memcpy(buf, ((char const *)&kovaplus->profile_buttons[*(uint *)(attr->private)]) + off,
-			count);
-	mutex_unlock(&kovaplus->kovaplus_lock);
+#define KOVAPLUS_BIN_ATTRIBUTE_RW(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0660 }, \
+	.size = KOVAPLUS_SIZE_ ## THINGY, \
+	.read = kovaplus_sysfs_read_ ## thingy, \
+	.write = kovaplus_sysfs_write_ ## thingy \
+}
+
+#define KOVAPLUS_BIN_ATTRIBUTE_R(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0440 }, \
+	.size = KOVAPLUS_SIZE_ ## THINGY, \
+	.read = kovaplus_sysfs_read_ ## thingy, \
+}
 
-	return count;
+#define KOVAPLUS_BIN_ATTRIBUTE_W(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0220 }, \
+	.size = KOVAPLUS_SIZE_ ## THINGY, \
+	.write = kovaplus_sysfs_write_ ## thingy \
 }
 
-static ssize_t kovaplus_sysfs_write_profile_buttons(struct file *fp,
+KOVAPLUS_SYSFS_RW(info, INFO)
+KOVAPLUS_SYSFS_W(profile_settings, PROFILE_SETTINGS)
+KOVAPLUS_SYSFS_W(profile_buttons, PROFILE_BUTTONS)
+
+static ssize_t kovaplus_sysfs_read_profilex_settings(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
 		loff_t off, size_t count)
 {
 	struct device *dev =
 			container_of(kobj, struct device, kobj)->parent->parent;
-	struct kovaplus_device *kovaplus = hid_get_drvdata(dev_get_drvdata(dev));
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
-	int retval = 0;
-	int difference;
-	uint profile_index;
-	struct kovaplus_profile_buttons *profile_buttons;
+	ssize_t retval;
 
-	if (off != 0 || count != sizeof(struct kovaplus_profile_buttons))
-		return -EINVAL;
+	retval = kovaplus_select_profile(usb_dev, *(uint *)(attr->private),
+			KOVAPLUS_CONTROL_REQUEST_PROFILE_SETTINGS);
+	if (retval)
+		return retval;
 
-	profile_index = ((struct kovaplus_profile_buttons const *)buf)->profile_index;
-	profile_buttons = &kovaplus->profile_buttons[profile_index];
+	return kovaplus_sysfs_read(fp, kobj, buf, off, count,
+			KOVAPLUS_SIZE_PROFILE_SETTINGS,
+			KOVAPLUS_COMMAND_PROFILE_SETTINGS);
+}
 
-	mutex_lock(&kovaplus->kovaplus_lock);
-	difference = memcmp(buf, profile_buttons,
-			sizeof(struct kovaplus_profile_buttons));
-	if (difference) {
-		retval = kovaplus_set_profile_buttons(usb_dev,
-				(struct kovaplus_profile_buttons const *)buf);
-		if (!retval)
-			memcpy(profile_buttons, buf,
-					sizeof(struct kovaplus_profile_buttons));
-	}
-	mutex_unlock(&kovaplus->kovaplus_lock);
+static ssize_t kovaplus_sysfs_read_profilex_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	ssize_t retval;
 
+	retval = kovaplus_select_profile(usb_dev, *(uint *)(attr->private),
+			KOVAPLUS_CONTROL_REQUEST_PROFILE_BUTTONS);
 	if (retval)
 		return retval;
 
-	return sizeof(struct kovaplus_profile_buttons);
+	return kovaplus_sysfs_read(fp, kobj, buf, off, count,
+			KOVAPLUS_SIZE_PROFILE_BUTTONS,
+			KOVAPLUS_COMMAND_PROFILE_BUTTONS);
 }
 
 static ssize_t kovaplus_sysfs_show_actual_profile(struct device *dev,
@@ -342,9 +337,20 @@ static ssize_t kovaplus_sysfs_show_actual_sensitivity_y(struct device *dev,
 static ssize_t kovaplus_sysfs_show_firmware_version(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct kovaplus_device *kovaplus =
-			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
-	return snprintf(buf, PAGE_SIZE, "%d\n", kovaplus->info.firmware_version);
+	struct kovaplus_device *kovaplus;
+	struct usb_device *usb_dev;
+	struct kovaplus_info info;
+
+	dev = dev->parent->parent;
+	kovaplus = hid_get_drvdata(dev_get_drvdata(dev));
+	usb_dev = interface_to_usbdev(to_usb_interface(dev));
+
+	mutex_lock(&kovaplus->kovaplus_lock);
+	roccat_common2_receive(usb_dev, KOVAPLUS_COMMAND_INFO,
+			&info, KOVAPLUS_SIZE_INFO);
+	mutex_unlock(&kovaplus->kovaplus_lock);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", info.firmware_version);
 }
 
 static struct device_attribute kovaplus_attributes[] = {
@@ -363,73 +369,66 @@ static struct device_attribute kovaplus_attributes[] = {
 };
 
 static struct bin_attribute kovaplus_bin_attributes[] = {
-	{
-		.attr = { .name = "profile_settings", .mode = 0220 },
-		.size = sizeof(struct kovaplus_profile_settings),
-		.write = kovaplus_sysfs_write_profile_settings
-	},
+	KOVAPLUS_BIN_ATTRIBUTE_RW(info, INFO),
+	KOVAPLUS_BIN_ATTRIBUTE_W(profile_settings, PROFILE_SETTINGS),
+	KOVAPLUS_BIN_ATTRIBUTE_W(profile_buttons, PROFILE_BUTTONS),
 	{
 		.attr = { .name = "profile1_settings", .mode = 0440 },
-		.size = sizeof(struct kovaplus_profile_settings),
+		.size = KOVAPLUS_SIZE_PROFILE_SETTINGS,
 		.read = kovaplus_sysfs_read_profilex_settings,
 		.private = &profile_numbers[0]
 	},
 	{
 		.attr = { .name = "profile2_settings", .mode = 0440 },
-		.size = sizeof(struct kovaplus_profile_settings),
+		.size = KOVAPLUS_SIZE_PROFILE_SETTINGS,
 		.read = kovaplus_sysfs_read_profilex_settings,
 		.private = &profile_numbers[1]
 	},
 	{
 		.attr = { .name = "profile3_settings", .mode = 0440 },
-		.size = sizeof(struct kovaplus_profile_settings),
+		.size = KOVAPLUS_SIZE_PROFILE_SETTINGS,
 		.read = kovaplus_sysfs_read_profilex_settings,
 		.private = &profile_numbers[2]
 	},
 	{
 		.attr = { .name = "profile4_settings", .mode = 0440 },
-		.size = sizeof(struct kovaplus_profile_settings),
+		.size = KOVAPLUS_SIZE_PROFILE_SETTINGS,
 		.read = kovaplus_sysfs_read_profilex_settings,
 		.private = &profile_numbers[3]
 	},
 	{
 		.attr = { .name = "profile5_settings", .mode = 0440 },
-		.size = sizeof(struct kovaplus_profile_settings),
+		.size = KOVAPLUS_SIZE_PROFILE_SETTINGS,
 		.read = kovaplus_sysfs_read_profilex_settings,
 		.private = &profile_numbers[4]
 	},
 	{
-		.attr = { .name = "profile_buttons", .mode = 0220 },
-		.size = sizeof(struct kovaplus_profile_buttons),
-		.write = kovaplus_sysfs_write_profile_buttons
-	},
-	{
 		.attr = { .name = "profile1_buttons", .mode = 0440 },
-		.size = sizeof(struct kovaplus_profile_buttons),
+		.size = KOVAPLUS_SIZE_PROFILE_BUTTONS,
 		.read = kovaplus_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[0]
 	},
 	{
 		.attr = { .name = "profile2_buttons", .mode = 0440 },
-		.size = sizeof(struct kovaplus_profile_buttons),
+		.size = KOVAPLUS_SIZE_PROFILE_BUTTONS,
 		.read = kovaplus_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[1]
 	},
 	{
 		.attr = { .name = "profile3_buttons", .mode = 0440 },
-		.size = sizeof(struct kovaplus_profile_buttons),
+		.size = KOVAPLUS_SIZE_PROFILE_BUTTONS,
 		.read = kovaplus_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[2]
 	},
 	{
 		.attr = { .name = "profile4_buttons", .mode = 0440 },
-		.size = sizeof(struct kovaplus_profile_buttons),
+		.size = KOVAPLUS_SIZE_PROFILE_BUTTONS,
 		.read = kovaplus_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[3]
 	},
 	{
 		.attr = { .name = "profile5_buttons", .mode = 0440 },
-		.size = sizeof(struct kovaplus_profile_buttons),
+		.size = KOVAPLUS_SIZE_PROFILE_BUTTONS,
 		.read = kovaplus_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[4]
 	},
@@ -444,10 +443,6 @@ static int kovaplus_init_kovaplus_device_struct(struct usb_device *usb_dev,
 
 	mutex_init(&kovaplus->kovaplus_lock);
 
-	retval = kovaplus_get_info(usb_dev, &kovaplus->info);
-	if (retval)
-		return retval;
-
 	for (i = 0; i < 5; ++i) {
 		msleep(wait);
 		retval = kovaplus_get_profile_settings(usb_dev,
diff --git a/drivers/hid/hid-roccat-kovaplus.h b/drivers/hid/hid-roccat-kovaplus.h
index f82daa1..1189573 100644
--- a/drivers/hid/hid-roccat-kovaplus.h
+++ b/drivers/hid/hid-roccat-kovaplus.h
@@ -14,6 +14,12 @@
 
 #include <linux/types.h>
 
+enum {
+	KOVAPLUS_SIZE_INFO = 0x06,
+	KOVAPLUS_SIZE_PROFILE_SETTINGS = 0x10,
+	KOVAPLUS_SIZE_PROFILE_BUTTONS = 0x17,
+};
+
 enum kovaplus_control_requests {
 	/* write; value = profile number range 0-4 */
 	KOVAPLUS_CONTROL_REQUEST_PROFILE_SETTINGS = 0x10,
@@ -53,13 +59,6 @@ struct kovaplus_info {
 	uint8_t unknown[3];
 } __packed;
 
-/* writes 1 on plugin */
-struct kovaplus_a {
-	uint8_t command; /* KOVAPLUS_COMMAND_A */
-	uint8_t size; /* 3 */
-	uint8_t unknown;
-} __packed;
-
 enum kovaplus_commands {
 	KOVAPLUS_COMMAND_ACTUAL_PROFILE = 0x5,
 	KOVAPLUS_COMMAND_PROFILE_SETTINGS = 0x6,
@@ -125,7 +124,6 @@ struct kovaplus_device {
 	int roccat_claimed;
 	int chrdev_minor;
 	struct mutex kovaplus_lock;
-	struct kovaplus_info info;
 	struct kovaplus_profile_settings profile_settings[5];
 	struct kovaplus_profile_buttons profile_buttons[5];
 };
-- 
1.7.3.4



