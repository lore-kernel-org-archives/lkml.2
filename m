Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab1DMPR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:17:59 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:59070 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757130Ab1DMPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:17:57 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-17.arcor-online.net F1B33CCCF4
Subject: [PATCH v2] HID: roccat: fixing actual/startup profile sysfs
 attribute in koneplus
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1302444165.12514.2.camel@neuromancer>
References: <1302444165.12514.2.camel@neuromancer>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 17:17:52 +0200
Message-ID: <1302707872.2252.3.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

startup_profile and actual_profile didn't work as expected. Also
as the actual profile is persistent, the distinction between the
two was ambiguous, so both use the same code now and startup_profile
has been deprecated. Also the event is now propagated through
chardev. The userland tool has been updated to support this change.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/obsolete/sysfs-driver-hid-roccat-koneplus  |   10 +++
 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |   19 ++---
 drivers/hid/hid-roccat-koneplus.c                  |   82 +++++++++++---------
 drivers/hid/hid-roccat-koneplus.h                  |   11 +--
 4 files changed, 65 insertions(+), 57 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus

diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus
new file mode 100644
index 0000000..c2a270b
--- /dev/null
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus
@@ -0,0 +1,10 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/startup_profile
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 0-4.
+                When read, this attribute returns the number of the actual
+                profile. This value is persistent, so its equivalent to the
+                profile that's active when the mouse is powered on next time.
+		When written, this file sets the number of the startup profile
+		and the mouse activates this profile immediately.
+		Please use actual_profile, it does the same thing.
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
index 00efced..e5311a0 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
@@ -1,9 +1,12 @@
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/actual_profile
 Date:		October 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns the number of the actual profile in
-		range 0-4.
-		This file is readonly.
+Description:	The integer value of this attribute ranges from 0-4.
+                When read, this attribute returns the number of the actual
+                profile. This value is persistent, so its equivalent to the
+                profile that's active when the mouse is powered on next time.
+		When written, this file sets the number of the startup profile
+		and the mouse activates this profile immediately.
 Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/firmware_version
@@ -89,16 +92,6 @@ Description:	The mouse has a tracking- and a distance-control-unit. These
 		This file is writeonly.
 Users:		http://roccat.sourceforge.net
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/startup_profile
-Date:		October 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The integer value of this attribute ranges from 0-4.
-                When read, this attribute returns the number of the profile
-                that's active when the mouse is powered on.
-		When written, this file sets the number of the startup profile
-		and the mouse activates this profile immediately.
-Users:		http://roccat.sourceforge.net
-
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu
 Date:		October 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 33eec74..5b640a7 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -167,28 +167,28 @@ static int koneplus_set_profile_buttons(struct usb_device *usb_dev,
 }
 
 /* retval is 0-4 on success, < 0 on error */
-static int koneplus_get_startup_profile(struct usb_device *usb_dev)
+static int koneplus_get_actual_profile(struct usb_device *usb_dev)
 {
-	struct koneplus_startup_profile buf;
+	struct koneplus_actual_profile buf;
 	int retval;
 
-	retval = roccat_common_receive(usb_dev, KONEPLUS_USB_COMMAND_STARTUP_PROFILE,
-			&buf, sizeof(struct koneplus_startup_profile));
+	retval = roccat_common_receive(usb_dev, KONEPLUS_USB_COMMAND_ACTUAL_PROFILE,
+			&buf, sizeof(struct koneplus_actual_profile));
 
-	return retval ? retval : buf.startup_profile;
+	return retval ? retval : buf.actual_profile;
 }
 
-static int koneplus_set_startup_profile(struct usb_device *usb_dev,
-		int startup_profile)
+static int koneplus_set_actual_profile(struct usb_device *usb_dev,
+		int new_profile)
 {
-	struct koneplus_startup_profile buf;
+	struct koneplus_actual_profile buf;
 
-	buf.command = KONEPLUS_COMMAND_STARTUP_PROFILE;
-	buf.size = sizeof(struct koneplus_startup_profile);
-	buf.startup_profile = startup_profile;
+	buf.command = KONEPLUS_COMMAND_ACTUAL_PROFILE;
+	buf.size = sizeof(struct koneplus_actual_profile);
+	buf.actual_profile = new_profile;
 
-	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_STARTUP_PROFILE,
-			&buf, sizeof(struct koneplus_profile_buttons));
+	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_ACTUAL_PROFILE,
+			&buf, sizeof(struct koneplus_actual_profile));
 }
 
 static ssize_t koneplus_sysfs_read(struct file *fp, struct kobject *kobj,
@@ -398,21 +398,22 @@ static ssize_t koneplus_sysfs_write_profile_buttons(struct file *fp,
 	return sizeof(struct koneplus_profile_buttons);
 }
 
-static ssize_t koneplus_sysfs_show_startup_profile(struct device *dev,
+static ssize_t koneplus_sysfs_show_actual_profile(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct koneplus_device *koneplus =
 			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
-	return snprintf(buf, PAGE_SIZE, "%d\n", koneplus->startup_profile);
+	return snprintf(buf, PAGE_SIZE, "%d\n", koneplus->actual_profile);
 }
 
-static ssize_t koneplus_sysfs_set_startup_profile(struct device *dev,
+static ssize_t koneplus_sysfs_set_actual_profile(struct device *dev,
 		struct device_attribute *attr, char const *buf, size_t size)
 {
 	struct koneplus_device *koneplus;
 	struct usb_device *usb_dev;
 	unsigned long profile;
 	int retval;
+	struct koneplus_roccat_report roccat_report;
 
 	dev = dev->parent->parent;
 	koneplus = hid_get_drvdata(dev_get_drvdata(dev));
@@ -423,20 +424,25 @@ static ssize_t koneplus_sysfs_set_startup_profile(struct device *dev,
 		return retval;
 
 	mutex_lock(&koneplus->koneplus_lock);
-	retval = koneplus_set_startup_profile(usb_dev, profile);
-	mutex_unlock(&koneplus->koneplus_lock);
-	if (retval)
+
+	retval = koneplus_set_actual_profile(usb_dev, profile);
+	if (retval) {
+		mutex_unlock(&koneplus->koneplus_lock);
 		return retval;
+	}
 
-	return size;
-}
+	koneplus->actual_profile = profile;
 
-static ssize_t koneplus_sysfs_show_actual_profile(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct koneplus_device *koneplus =
-			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
-	return snprintf(buf, PAGE_SIZE, "%d\n", koneplus->actual_profile);
+	roccat_report.type = KONEPLUS_MOUSE_REPORT_BUTTON_TYPE_PROFILE;
+	roccat_report.data1 = profile + 1;
+	roccat_report.data2 = 0;
+	roccat_report.profile = profile + 1;
+	roccat_report_event(koneplus->chrdev_minor,
+			(uint8_t const *)&roccat_report);
+
+	mutex_unlock(&koneplus->koneplus_lock);
+
+	return size;
 }
 
 static ssize_t koneplus_sysfs_show_firmware_version(struct device *dev,
@@ -448,11 +454,12 @@ static ssize_t koneplus_sysfs_show_firmware_version(struct device *dev,
 }
 
 static struct device_attribute koneplus_attributes[] = {
+	__ATTR(actual_profile, 0660,
+			koneplus_sysfs_show_actual_profile,
+			koneplus_sysfs_set_actual_profile),
 	__ATTR(startup_profile, 0660,
-			koneplus_sysfs_show_startup_profile,
-			koneplus_sysfs_set_startup_profile),
-	__ATTR(actual_profile, 0440,
-			koneplus_sysfs_show_actual_profile, NULL),
+			koneplus_sysfs_show_actual_profile,
+			koneplus_sysfs_set_actual_profile),
 	__ATTR(firmware_version, 0440,
 			koneplus_sysfs_show_firmware_version, NULL),
 	__ATTR_NULL
@@ -557,15 +564,10 @@ static int koneplus_init_koneplus_device_struct(struct usb_device *usb_dev,
 		struct koneplus_device *koneplus)
 {
 	int retval, i;
-	static uint wait = 100; /* device will freeze with just 60 */
+	static uint wait = 200;
 
 	mutex_init(&koneplus->koneplus_lock);
 
-	koneplus->startup_profile = koneplus_get_startup_profile(usb_dev);
-	if (koneplus->startup_profile < 0)
-		return koneplus->startup_profile;
-
-	msleep(wait);
 	retval = koneplus_get_info(usb_dev, &koneplus->info);
 	if (retval)
 		return retval;
@@ -584,7 +586,11 @@ static int koneplus_init_koneplus_device_struct(struct usb_device *usb_dev,
 			return retval;
 	}
 
-	koneplus_profile_activated(koneplus, koneplus->startup_profile);
+	msleep(wait);
+	retval = koneplus_get_actual_profile(usb_dev);
+	if (retval < 0)
+		return retval;
+	koneplus_profile_activated(koneplus, retval);
 
 	return 0;
 }
diff --git a/drivers/hid/hid-roccat-koneplus.h b/drivers/hid/hid-roccat-koneplus.h
index 57a5c1a..c57a376 100644
--- a/drivers/hid/hid-roccat-koneplus.h
+++ b/drivers/hid/hid-roccat-koneplus.h
@@ -40,10 +40,10 @@ enum koneplus_control_values {
 	KONEPLUS_CONTROL_REQUEST_STATUS_WAIT = 3,
 };
 
-struct koneplus_startup_profile {
-	uint8_t command; /* KONEPLUS_COMMAND_STARTUP_PROFILE */
+struct koneplus_actual_profile {
+	uint8_t command; /* KONEPLUS_COMMAND_ACTUAL_PROFILE */
 	uint8_t size; /* always 3 */
-	uint8_t startup_profile; /* Range 0-4! */
+	uint8_t actual_profile; /* Range 0-4! */
 } __attribute__ ((__packed__));
 
 struct koneplus_profile_settings {
@@ -132,7 +132,7 @@ struct koneplus_tcu_image {
 
 enum koneplus_commands {
 	KONEPLUS_COMMAND_CONTROL = 0x4,
-	KONEPLUS_COMMAND_STARTUP_PROFILE = 0x5,
+	KONEPLUS_COMMAND_ACTUAL_PROFILE = 0x5,
 	KONEPLUS_COMMAND_PROFILE_SETTINGS = 0x6,
 	KONEPLUS_COMMAND_PROFILE_BUTTONS = 0x7,
 	KONEPLUS_COMMAND_MACRO = 0x8,
@@ -145,7 +145,7 @@ enum koneplus_commands {
 
 enum koneplus_usb_commands {
 	KONEPLUS_USB_COMMAND_CONTROL = 0x304,
-	KONEPLUS_USB_COMMAND_STARTUP_PROFILE = 0x305,
+	KONEPLUS_USB_COMMAND_ACTUAL_PROFILE = 0x305,
 	KONEPLUS_USB_COMMAND_PROFILE_SETTINGS = 0x306,
 	KONEPLUS_USB_COMMAND_PROFILE_BUTTONS = 0x307,
 	KONEPLUS_USB_COMMAND_MACRO = 0x308,
@@ -215,7 +215,6 @@ struct koneplus_device {
 
 	struct mutex koneplus_lock;
 
-	int startup_profile;
 	struct koneplus_info info;
 	struct koneplus_profile_settings profile_settings[5];
 	struct koneplus_profile_buttons profile_buttons[5];
-- 
1.7.3.4



