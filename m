Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab2KKFVO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 00:21:14 -0500
Received: from mout.web.de ([212.227.15.4]:64817 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab2KKFVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 00:21:09 -0500
Subject: [PATCH 2/7] HID: roccat: Cleanup of pyra module
From: Stefan Achatz <stefan_achatz@web.de>
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Nov 2012 06:20:58 +0100
Message-ID: <1352611258.2463.222.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:HKaAVCuzXJRpEj4F9dfR1krJqLeks83JFrRlT2lMd3N
 sQFTxtRfDTQZgPFutKPgVck97eoFAeTvI7qmIJx2YG054innzF
 5eGA0TEI7IKgZ10zXpvDsbRVortpTy1fjv78Qj0TGrjJ/ISkKV
 w2ZXFyXSERHRU3jYjO+/x/CwpFRGRj2LgLZQnkbE/qMwEFLdt5
 kv+tvlZiarhG1ViBHzhuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Partially removed unneeded informations and data caching.
Moved code nearer to format of newer drivers.
Added "info" sysfs attribute to support device reset and deprecate
"firmware_version" attribute.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/obsolete/sysfs-driver-hid-roccat-pyra      |   48 +++
 .../ABI/testing/sysfs-driver-hid-roccat-pyra       |   45 ---
 drivers/hid/hid-roccat-pyra.c                      |  340 +++++++++-----------
 drivers/hid/hid-roccat-pyra.h                      |   22 +-
 4 files changed, 198 insertions(+), 257 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra

diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
new file mode 100644
index 0000000..0a661b3
--- /dev/null
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
@@ -0,0 +1,48 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/actual_cpi
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	It is possible to switch the cpi setting of the mouse with the
+		press of a button.
+		When read, this file returns the raw number of the actual cpi
+		setting reported by the mouse. This number has to be further
+		processed to receive the real dpi value.
+
+		VALUE DPI
+		1     400
+		2     800
+		4     1600
+
+		This file is readonly.
+		Has never been used. If bookkeeping is done, it's done in userland tools.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/actual_profile
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the number of the actual profile in
+		range 0-4.
+		This file is readonly.
+		Please use binary attribute "settings" which provides this information.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/firmware_version
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the raw integer version number of the
+		firmware reported by the mouse. Using the integer value eases
+		further usage in other programs. To receive the real version
+		number the decimal point has to be shifted 2 positions to the
+		left. E.g. a returned value of 138 means 1.38
+		This file is readonly.
+		Please use binary attribute "info" which provides this information.
+Users:		http://roccat.sourceforge.net
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/startup_profile
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 0-4.
+                When read, this attribute returns the number of the profile
+                that's active when the mouse is powered on.
+		This file is readonly.
+		Please use binary attribute "settings" which provides this information.
+Users:		http://roccat.sourceforge.net
\ No newline at end of file
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra b/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
index 3f8de50..b0fab8b 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
@@ -1,39 +1,3 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/actual_cpi
-Date:		August 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	It is possible to switch the cpi setting of the mouse with the
-		press of a button.
-		When read, this file returns the raw number of the actual cpi
-		setting reported by the mouse. This number has to be further
-		processed to receive the real dpi value.
-
-		VALUE DPI
-		1     400
-		2     800
-		4     1600
-
-		This file is readonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/actual_profile
-Date:		August 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns the number of the actual profile in
-		range 0-4.
-		This file is readonly.
-Users:		http://roccat.sourceforge.net
-
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/firmware_version
-Date:		August 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns the raw integer version number of the
-		firmware reported by the mouse. Using the integer value eases
-		further usage in other programs. To receive the real version
-		number the decimal point has to be shifted 2 positions to the
-		left. E.g. a returned value of 138 means 1.38
-		This file is readonly.
-Users:		http://roccat.sourceforge.net
-
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile_settings
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
@@ -86,15 +50,6 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		This file is readonly.
 Users:		http://roccat.sourceforge.net
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/startup_profile
-Date:		August 2010
-Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	The integer value of this attribute ranges from 0-4.
-                When read, this attribute returns the number of the profile
-                that's active when the mouse is powered on.
-		This file is readonly.
-Users:		http://roccat.sourceforge.net
-
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/settings
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index 1317c17..76199fa 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -66,48 +66,14 @@ static int pyra_get_profile_settings(struct usb_device *usb_dev,
 	if (retval)
 		return retval;
 	return roccat_common2_receive(usb_dev, PYRA_COMMAND_PROFILE_SETTINGS,
-			buf, sizeof(struct pyra_profile_settings));
-}
-
-static int pyra_get_profile_buttons(struct usb_device *usb_dev,
-		struct pyra_profile_buttons *buf, int number)
-{
-	int retval;
-	retval = pyra_send_control(usb_dev, number,
-			PYRA_CONTROL_REQUEST_PROFILE_BUTTONS);
-	if (retval)
-		return retval;
-	return roccat_common2_receive(usb_dev, PYRA_COMMAND_PROFILE_BUTTONS,
-			buf, sizeof(struct pyra_profile_buttons));
+			buf, PYRA_SIZE_PROFILE_SETTINGS);
 }
 
 static int pyra_get_settings(struct usb_device *usb_dev,
 		struct pyra_settings *buf)
 {
 	return roccat_common2_receive(usb_dev, PYRA_COMMAND_SETTINGS,
-			buf, sizeof(struct pyra_settings));
-}
-
-static int pyra_get_info(struct usb_device *usb_dev, struct pyra_info *buf)
-{
-	return roccat_common2_receive(usb_dev, PYRA_COMMAND_INFO,
-			buf, sizeof(struct pyra_info));
-}
-
-static int pyra_set_profile_settings(struct usb_device *usb_dev,
-		struct pyra_profile_settings const *settings)
-{
-	return roccat_common2_send_with_status(usb_dev,
-			PYRA_COMMAND_PROFILE_SETTINGS, settings,
-			sizeof(struct pyra_profile_settings));
-}
-
-static int pyra_set_profile_buttons(struct usb_device *usb_dev,
-		struct pyra_profile_buttons const *buttons)
-{
-	return roccat_common2_send_with_status(usb_dev,
-			PYRA_COMMAND_PROFILE_BUTTONS, buttons,
-			sizeof(struct pyra_profile_buttons));
+			buf, PYRA_SIZE_SETTINGS);
 }
 
 static int pyra_set_settings(struct usb_device *usb_dev,
@@ -115,146 +81,143 @@ static int pyra_set_settings(struct usb_device *usb_dev,
 {
 	return roccat_common2_send_with_status(usb_dev,
 			PYRA_COMMAND_SETTINGS, settings,
-			sizeof(struct pyra_settings));
+			PYRA_SIZE_SETTINGS);
 }
 
-static ssize_t pyra_sysfs_read_profilex_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
+static ssize_t pyra_sysfs_read(struct file *fp, struct kobject *kobj,
+		char *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
 {
 	struct device *dev =
 			container_of(kobj, struct device, kobj)->parent->parent;
 	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
 
-	if (off >= sizeof(struct pyra_profile_settings))
+	if (off >= real_size)
 		return 0;
 
-	if (off + count > sizeof(struct pyra_profile_settings))
-		count = sizeof(struct pyra_profile_settings) - off;
+	if (off != 0 || count != real_size)
+		return -EINVAL;
 
 	mutex_lock(&pyra->pyra_lock);
-	memcpy(buf, ((char const *)&pyra->profile_settings[*(uint *)(attr->private)]) + off,
-			count);
+	retval = roccat_common2_receive(usb_dev, command, buf, real_size);
 	mutex_unlock(&pyra->pyra_lock);
 
-	return count;
+	if (retval)
+		return retval;
+
+	return real_size;
 }
 
-static ssize_t pyra_sysfs_read_profilex_buttons(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
+static ssize_t pyra_sysfs_write(struct file *fp, struct kobject *kobj,
+		void const *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
 {
 	struct device *dev =
 			container_of(kobj, struct device, kobj)->parent->parent;
 	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
 
-	if (off >= sizeof(struct pyra_profile_buttons))
-		return 0;
-
-	if (off + count > sizeof(struct pyra_profile_buttons))
-		count = sizeof(struct pyra_profile_buttons) - off;
+	if (off != 0 || count != real_size)
+		return -EINVAL;
 
 	mutex_lock(&pyra->pyra_lock);
-	memcpy(buf, ((char const *)&pyra->profile_buttons[*(uint *)(attr->private)]) + off,
-			count);
+	retval = roccat_common2_send_with_status(usb_dev, command, (void *)buf, real_size);
 	mutex_unlock(&pyra->pyra_lock);
 
-	return count;
+	if (retval)
+		return retval;
+
+	return real_size;
 }
 
-static ssize_t pyra_sysfs_write_profile_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	struct device *dev =
-			container_of(kobj, struct device, kobj)->parent->parent;
-	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
-	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
-	int retval = 0;
-	int difference;
-	int profile_number;
-	struct pyra_profile_settings *profile_settings;
+#define PYRA_SYSFS_W(thingy, THINGY) \
+static ssize_t pyra_sysfs_write_ ## thingy(struct file *fp, \
+		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
+		loff_t off, size_t count) \
+{ \
+	return pyra_sysfs_write(fp, kobj, buf, off, count, \
+			PYRA_SIZE_ ## THINGY, PYRA_COMMAND_ ## THINGY); \
+}
 
-	if (off != 0 || count != sizeof(struct pyra_profile_settings))
-		return -EINVAL;
+#define PYRA_SYSFS_R(thingy, THINGY) \
+static ssize_t pyra_sysfs_read_ ## thingy(struct file *fp, \
+		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
+		loff_t off, size_t count) \
+{ \
+	return pyra_sysfs_read(fp, kobj, buf, off, count, \
+			PYRA_SIZE_ ## THINGY, PYRA_COMMAND_ ## THINGY); \
+}
 
-	profile_number = ((struct pyra_profile_settings const *)buf)->number;
-	profile_settings = &pyra->profile_settings[profile_number];
+#define PYRA_SYSFS_RW(thingy, THINGY) \
+PYRA_SYSFS_W(thingy, THINGY) \
+PYRA_SYSFS_R(thingy, THINGY)
 
-	mutex_lock(&pyra->pyra_lock);
-	difference = memcmp(buf, profile_settings,
-			sizeof(struct pyra_profile_settings));
-	if (difference) {
-		retval = pyra_set_profile_settings(usb_dev,
-				(struct pyra_profile_settings const *)buf);
-		if (!retval)
-			memcpy(profile_settings, buf,
-					sizeof(struct pyra_profile_settings));
-	}
-	mutex_unlock(&pyra->pyra_lock);
+#define PYRA_BIN_ATTRIBUTE_RW(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0660 }, \
+	.size = PYRA_SIZE_ ## THINGY, \
+	.read = pyra_sysfs_read_ ## thingy, \
+	.write = pyra_sysfs_write_ ## thingy \
+}
 
-	if (retval)
-		return retval;
+#define PYRA_BIN_ATTRIBUTE_R(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0440 }, \
+	.size = PYRA_SIZE_ ## THINGY, \
+	.read = pyra_sysfs_read_ ## thingy, \
+}
 
-	return sizeof(struct pyra_profile_settings);
+#define PYRA_BIN_ATTRIBUTE_W(thingy, THINGY) \
+{ \
+	.attr = { .name = #thingy, .mode = 0220 }, \
+	.size = PYRA_SIZE_ ## THINGY, \
+	.write = pyra_sysfs_write_ ## thingy \
 }
 
-static ssize_t pyra_sysfs_write_profile_buttons(struct file *fp,
+PYRA_SYSFS_RW(info, INFO)
+PYRA_SYSFS_W(profile_settings, PROFILE_SETTINGS)
+PYRA_SYSFS_W(profile_buttons, PROFILE_BUTTONS)
+PYRA_SYSFS_R(settings, SETTINGS)
+
+static ssize_t pyra_sysfs_read_profilex_settings(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
 		loff_t off, size_t count)
 {
 	struct device *dev =
 			container_of(kobj, struct device, kobj)->parent->parent;
-	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
-	int retval = 0;
-	int difference;
-	int profile_number;
-	struct pyra_profile_buttons *profile_buttons;
-
-	if (off != 0 || count != sizeof(struct pyra_profile_buttons))
-		return -EINVAL;
-
-	profile_number = ((struct pyra_profile_buttons const *)buf)->number;
-	profile_buttons = &pyra->profile_buttons[profile_number];
-
-	mutex_lock(&pyra->pyra_lock);
-	difference = memcmp(buf, profile_buttons,
-			sizeof(struct pyra_profile_buttons));
-	if (difference) {
-		retval = pyra_set_profile_buttons(usb_dev,
-				(struct pyra_profile_buttons const *)buf);
-		if (!retval)
-			memcpy(profile_buttons, buf,
-					sizeof(struct pyra_profile_buttons));
-	}
-	mutex_unlock(&pyra->pyra_lock);
+	ssize_t retval;
 
+	retval = pyra_send_control(usb_dev, *(uint *)(attr->private),
+			PYRA_CONTROL_REQUEST_PROFILE_SETTINGS);
 	if (retval)
 		return retval;
 
-	return sizeof(struct pyra_profile_buttons);
+	return pyra_sysfs_read(fp, kobj, buf, off, count,
+			PYRA_SIZE_PROFILE_SETTINGS,
+			PYRA_COMMAND_PROFILE_SETTINGS);
 }
 
-static ssize_t pyra_sysfs_read_settings(struct file *fp,
+static ssize_t pyra_sysfs_read_profilex_buttons(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
 		loff_t off, size_t count)
 {
 	struct device *dev =
 			container_of(kobj, struct device, kobj)->parent->parent;
-	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
-
-	if (off >= sizeof(struct pyra_settings))
-		return 0;
-
-	if (off + count > sizeof(struct pyra_settings))
-		count = sizeof(struct pyra_settings) - off;
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	ssize_t retval;
 
-	mutex_lock(&pyra->pyra_lock);
-	memcpy(buf, ((char const *)&pyra->settings) + off, count);
-	mutex_unlock(&pyra->pyra_lock);
+	retval = pyra_send_control(usb_dev, *(uint *)(attr->private),
+			PYRA_CONTROL_REQUEST_PROFILE_BUTTONS);
+	if (retval)
+		return retval;
 
-	return count;
+	return pyra_sysfs_read(fp, kobj, buf, off, count,
+			PYRA_SIZE_PROFILE_BUTTONS,
+			PYRA_COMMAND_PROFILE_BUTTONS);
 }
 
 static ssize_t pyra_sysfs_write_settings(struct file *fp,
@@ -266,35 +229,32 @@ static ssize_t pyra_sysfs_write_settings(struct file *fp,
 	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int retval = 0;
-	int difference;
 	struct pyra_roccat_report roccat_report;
+	struct pyra_settings const *settings;
 
-	if (off != 0 || count != sizeof(struct pyra_settings))
+	if (off != 0 || count != PYRA_SIZE_SETTINGS)
 		return -EINVAL;
 
 	mutex_lock(&pyra->pyra_lock);
-	difference = memcmp(buf, &pyra->settings, sizeof(struct pyra_settings));
-	if (difference) {
-		retval = pyra_set_settings(usb_dev,
-				(struct pyra_settings const *)buf);
-		if (retval) {
-			mutex_unlock(&pyra->pyra_lock);
-			return retval;
-		}
-
-		memcpy(&pyra->settings, buf,
-				sizeof(struct pyra_settings));
 
-		profile_activated(pyra, pyra->settings.startup_profile);
+	settings = (struct pyra_settings const *)buf;
 
-		roccat_report.type = PYRA_MOUSE_EVENT_BUTTON_TYPE_PROFILE_2;
-		roccat_report.value = pyra->settings.startup_profile + 1;
-		roccat_report.key = 0;
-		roccat_report_event(pyra->chrdev_minor,
-				(uint8_t const *)&roccat_report);
+	retval = pyra_set_settings(usb_dev, settings);
+	if (retval) {
+		mutex_unlock(&pyra->pyra_lock);
+		return retval;
 	}
+
+	profile_activated(pyra, settings->startup_profile);
+
+	roccat_report.type = PYRA_MOUSE_EVENT_BUTTON_TYPE_PROFILE_2;
+	roccat_report.value = settings->startup_profile + 1;
+	roccat_report.key = 0;
+	roccat_report_event(pyra->chrdev_minor,
+			(uint8_t const *)&roccat_report);
+
 	mutex_unlock(&pyra->pyra_lock);
-	return sizeof(struct pyra_settings);
+	return PYRA_SIZE_SETTINGS;
 }
 
 
@@ -311,23 +271,34 @@ static ssize_t pyra_sysfs_show_actual_profile(struct device *dev,
 {
 	struct pyra_device *pyra =
 			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
-	return snprintf(buf, PAGE_SIZE, "%d\n", pyra->actual_profile);
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	struct pyra_settings settings;
+
+	mutex_lock(&pyra->pyra_lock);
+	roccat_common2_receive(usb_dev, PYRA_COMMAND_SETTINGS,
+			&settings, PYRA_SIZE_SETTINGS);
+	mutex_unlock(&pyra->pyra_lock);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", settings.startup_profile);
 }
 
 static ssize_t pyra_sysfs_show_firmware_version(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct pyra_device *pyra =
-			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
-	return snprintf(buf, PAGE_SIZE, "%d\n", pyra->firmware_version);
-}
+	struct pyra_device *pyra;
+	struct usb_device *usb_dev;
+	struct pyra_info info;
 
-static ssize_t pyra_sysfs_show_startup_profile(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct pyra_device *pyra =
-			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
-	return snprintf(buf, PAGE_SIZE, "%d\n", pyra->settings.startup_profile);
+	dev = dev->parent->parent;
+	pyra = hid_get_drvdata(dev_get_drvdata(dev));
+	usb_dev = interface_to_usbdev(to_usb_interface(dev));
+
+	mutex_lock(&pyra->pyra_lock);
+	roccat_common2_receive(usb_dev, PYRA_COMMAND_INFO,
+			&info, PYRA_SIZE_INFO);
+	mutex_unlock(&pyra->pyra_lock);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", info.firmware_version);
 }
 
 static struct device_attribute pyra_attributes[] = {
@@ -336,105 +307,87 @@ static struct device_attribute pyra_attributes[] = {
 	__ATTR(firmware_version, 0440,
 			pyra_sysfs_show_firmware_version, NULL),
 	__ATTR(startup_profile, 0440,
-			pyra_sysfs_show_startup_profile, NULL),
+			pyra_sysfs_show_actual_profile, NULL),
 	__ATTR_NULL
 };
 
 static struct bin_attribute pyra_bin_attributes[] = {
-	{
-		.attr = { .name = "profile_settings", .mode = 0220 },
-		.size = sizeof(struct pyra_profile_settings),
-		.write = pyra_sysfs_write_profile_settings
-	},
+	PYRA_BIN_ATTRIBUTE_RW(info, INFO),
+	PYRA_BIN_ATTRIBUTE_W(profile_settings, PROFILE_SETTINGS),
+	PYRA_BIN_ATTRIBUTE_W(profile_buttons, PROFILE_BUTTONS),
+	PYRA_BIN_ATTRIBUTE_RW(settings, SETTINGS),
 	{
 		.attr = { .name = "profile1_settings", .mode = 0440 },
-		.size = sizeof(struct pyra_profile_settings),
+		.size = PYRA_SIZE_PROFILE_SETTINGS,
 		.read = pyra_sysfs_read_profilex_settings,
 		.private = &profile_numbers[0]
 	},
 	{
 		.attr = { .name = "profile2_settings", .mode = 0440 },
-		.size = sizeof(struct pyra_profile_settings),
+		.size = PYRA_SIZE_PROFILE_SETTINGS,
 		.read = pyra_sysfs_read_profilex_settings,
 		.private = &profile_numbers[1]
 	},
 	{
 		.attr = { .name = "profile3_settings", .mode = 0440 },
-		.size = sizeof(struct pyra_profile_settings),
+		.size = PYRA_SIZE_PROFILE_SETTINGS,
 		.read = pyra_sysfs_read_profilex_settings,
 		.private = &profile_numbers[2]
 	},
 	{
 		.attr = { .name = "profile4_settings", .mode = 0440 },
-		.size = sizeof(struct pyra_profile_settings),
+		.size = PYRA_SIZE_PROFILE_SETTINGS,
 		.read = pyra_sysfs_read_profilex_settings,
 		.private = &profile_numbers[3]
 	},
 	{
 		.attr = { .name = "profile5_settings", .mode = 0440 },
-		.size = sizeof(struct pyra_profile_settings),
+		.size = PYRA_SIZE_PROFILE_SETTINGS,
 		.read = pyra_sysfs_read_profilex_settings,
 		.private = &profile_numbers[4]
 	},
 	{
-		.attr = { .name = "profile_buttons", .mode = 0220 },
-		.size = sizeof(struct pyra_profile_buttons),
-		.write = pyra_sysfs_write_profile_buttons
-	},
-	{
 		.attr = { .name = "profile1_buttons", .mode = 0440 },
-		.size = sizeof(struct pyra_profile_buttons),
+		.size = PYRA_SIZE_PROFILE_BUTTONS,
 		.read = pyra_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[0]
 	},
 	{
 		.attr = { .name = "profile2_buttons", .mode = 0440 },
-		.size = sizeof(struct pyra_profile_buttons),
+		.size = PYRA_SIZE_PROFILE_BUTTONS,
 		.read = pyra_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[1]
 	},
 	{
 		.attr = { .name = "profile3_buttons", .mode = 0440 },
-		.size = sizeof(struct pyra_profile_buttons),
+		.size = PYRA_SIZE_PROFILE_BUTTONS,
 		.read = pyra_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[2]
 	},
 	{
 		.attr = { .name = "profile4_buttons", .mode = 0440 },
-		.size = sizeof(struct pyra_profile_buttons),
+		.size = PYRA_SIZE_PROFILE_BUTTONS,
 		.read = pyra_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[3]
 	},
 	{
 		.attr = { .name = "profile5_buttons", .mode = 0440 },
-		.size = sizeof(struct pyra_profile_buttons),
+		.size = PYRA_SIZE_PROFILE_BUTTONS,
 		.read = pyra_sysfs_read_profilex_buttons,
 		.private = &profile_numbers[4]
 	},
-	{
-		.attr = { .name = "settings", .mode = 0660 },
-		.size = sizeof(struct pyra_settings),
-		.read = pyra_sysfs_read_settings,
-		.write = pyra_sysfs_write_settings
-	},
 	__ATTR_NULL
 };
 
 static int pyra_init_pyra_device_struct(struct usb_device *usb_dev,
 		struct pyra_device *pyra)
 {
-	struct pyra_info info;
+	struct pyra_settings settings;
 	int retval, i;
 
 	mutex_init(&pyra->pyra_lock);
 
-	retval = pyra_get_info(usb_dev, &info);
-	if (retval)
-		return retval;
-
-	pyra->firmware_version = info.firmware_version;
-
-	retval = pyra_get_settings(usb_dev, &pyra->settings);
+	retval = pyra_get_settings(usb_dev, &settings);
 	if (retval)
 		return retval;
 
@@ -443,14 +396,9 @@ static int pyra_init_pyra_device_struct(struct usb_device *usb_dev,
 				&pyra->profile_settings[i], i);
 		if (retval)
 			return retval;
-
-		retval = pyra_get_profile_buttons(usb_dev,
-				&pyra->profile_buttons[i], i);
-		if (retval)
-			return retval;
 	}
 
-	profile_activated(pyra, pyra->settings.startup_profile);
+	profile_activated(pyra, settings.startup_profile);
 
 	return 0;
 }
diff --git a/drivers/hid/hid-roccat-pyra.h b/drivers/hid/hid-roccat-pyra.h
index eada783..93e4949 100644
--- a/drivers/hid/hid-roccat-pyra.h
+++ b/drivers/hid/hid-roccat-pyra.h
@@ -14,11 +14,12 @@
 
 #include <linux/types.h>
 
-struct pyra_b {
-	uint8_t command; /* PYRA_COMMAND_B */
-	uint8_t size; /* always 3 */
-	uint8_t unknown; /* 1 */
-} __attribute__ ((__packed__));
+enum {
+	PYRA_SIZE_INFO = 0x06,
+	PYRA_SIZE_PROFILE_SETTINGS = 0x0d,
+	PYRA_SIZE_PROFILE_BUTTONS = 0x13,
+	PYRA_SIZE_SETTINGS = 0x03,
+};
 
 enum pyra_control_requests {
 	PYRA_CONTROL_REQUEST_PROFILE_SETTINGS = 0x10,
@@ -46,14 +47,6 @@ struct pyra_profile_settings {
 	uint16_t checksum; /* byte sum */
 } __attribute__ ((__packed__));
 
-struct pyra_profile_buttons {
-	uint8_t command; /* PYRA_COMMAND_PROFILE_BUTTONS */
-	uint8_t size; /* always 0x13 */
-	uint8_t number; /* Range 0-4 */
-	uint8_t buttons[14];
-	uint16_t checksum; /* byte sum */
-} __attribute__ ((__packed__));
-
 struct pyra_info {
 	uint8_t command; /* PYRA_COMMAND_INFO */
 	uint8_t size; /* always 6 */
@@ -148,13 +141,10 @@ struct pyra_roccat_report {
 struct pyra_device {
 	int actual_profile;
 	int actual_cpi;
-	int firmware_version;
 	int roccat_claimed;
 	int chrdev_minor;
 	struct mutex pyra_lock;
-	struct pyra_settings settings;
 	struct pyra_profile_settings profile_settings[5];
-	struct pyra_profile_buttons profile_buttons[5];
 };
 
 #endif
-- 
1.7.3.4



