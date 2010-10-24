Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab0JXR5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 13:57:13 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:40193 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757050Ab0JXR5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 13:57:10 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-17.arcor-online.net A3478CC3A8
Subject: [PATCH] HID: roccat: Add support for Roccat Kone[+]
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>,
        Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Stephane Chatty <chatty@enac.fr>,
        Don Prince <dhprince-devel@yahoo.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Oct 2010 19:57:05 +0200
Message-ID: <1287943025.2623.16.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Roccat Kone[+] gaming mouse. Kone[+] is an enhanced version
of the old Kone with more memory for macros, a better sensor and more functionality.
This driver is conceptual similar to the existing Kone and Pyra drivers.
Userland tools can soon be found at http://sourceforge.net/projects/roccat

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |  108 ++
 drivers/hid/Kconfig                                |    7 +
 drivers/hid/Makefile                               |    1 +
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-roccat-koneplus.c                  | 1053 ++++++++++++++++++++
 drivers/hid/hid-roccat-koneplus.h                  |  229 +++++
 7 files changed, 1400 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
 create mode 100644 drivers/hid/hid-roccat-koneplus.c
 create mode 100644 drivers/hid/hid-roccat-koneplus.h

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
new file mode 100644
index 0000000..0ebb640
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
@@ -0,0 +1,108 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/actual_profile
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the number of the actual profile in
+		range 0-4.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/firmware_version
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the raw integer version number of the
+		firmware reported by the mouse. Using the integer value eases
+		further usage in other programs. To receive the real version
+		number the decimal point has to be shifted 2 positions to the
+		left. E.g. a returned value of 121 means 1.21
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/macro
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store a macro with max 500 key/button strokes
+		internally.
+		When written, this file lets one set the sequence for a specific
+		button for a specific profile. Button and profile numbers are
+		included in written data. The data has to be 2082 bytes long.
+		This file is writeonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile_buttons
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_buttons holds informations about button layout.
+		When written, this file lets one write the respective profile
+		buttons back to the mouse. The data has to be 77 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		This file is writeonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile[1-5]_buttons
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_buttons holds informations about button layout.
+		When read, these files return the respective profile buttons.
+		The returned data is 77 bytes in size.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile_settings
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_settings holds informations like resolution, sensitivity
+		and light effects.
+		When written, this file lets one write the respective profile
+		settings back to the mouse. The data has to be 43 bytes long.
+		The mouse will reject invalid data.
+		Which profile to write is determined by the profile number
+		contained in the data.
+		This file is writeonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile[1-5]_settings
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_settings holds informations like resolution, sensitivity
+		and light effects.
+		When read, these files return the respective profile settings.
+		The returned data is 43 bytes in size.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/sensor
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse has a tracking- and a distance-control-unit. These
+		can be activated/deactivated and the lift-off distance can be
+		set. The data has to be 6 bytes long.
+		This file is writeonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/startup_profile
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 0-4.
+                When read, this attribute returns the number of the profile
+                that's active when the mouse is powered on.
+		When written, this file sets the number of the startup profile
+		and the mouse activates this profile immediately.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/tcu
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written a calibration process for the tracking control unit
+		can be initiated/cancelled.
+		The data has to be 3 bytes long.
+		This file is writeonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/tcu_image
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read the mouse returns a 30x30 pixel image of the
+		sampled underground. This works only in the course of a
+		calibration process initiated with tcu.
+		The returned data is 1028 bytes in size.
+		This file is readonly.
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index b07440a..c47c6da 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -376,6 +376,13 @@ config HID_ROCCAT_KONE
 	---help---
 	Support for Roccat Kone mouse.
 
+config HID_ROCCAT_KONEPLUS
+	tristate "Roccat Kone[+] mouse support"
+	depends on USB_HID
+	select HID_ROCCAT
+	---help---
+	Support for Roccat Kone[+] mouse.
+
 config HID_ROCCAT_PYRA
 	tristate "Roccat Pyra mouse support"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index d224fa3..30d58ed 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_HID_PETALYNX)	+= hid-petalynx.o
 obj-$(CONFIG_HID_PICOLCD)	+= hid-picolcd.o
 obj-$(CONFIG_HID_ROCCAT)	+= hid-roccat.o
 obj-$(CONFIG_HID_ROCCAT_KONE)	+= hid-roccat-kone.o
+obj-$(CONFIG_HID_ROCCAT_KONEPLUS)	+= hid-roccat-koneplus.o
 obj-$(CONFIG_HID_ROCCAT_PYRA)	+= hid-roccat-pyra.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SMARTJOYPLUS)	+= hid-sjoy.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 8418dd9..5851393 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1371,6 +1371,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPLUS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRED) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 84a3b2c..6542b95 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -466,6 +466,7 @@
 
 #define USB_VENDOR_ID_ROCCAT		0x1e7d
 #define USB_DEVICE_ID_ROCCAT_KONE	0x2ced
+#define USB_DEVICE_ID_ROCCAT_KONEPLUS	0x2d51
 #define USB_DEVICE_ID_ROCCAT_PYRA_WIRED	0x2c24
 #define USB_DEVICE_ID_ROCCAT_PYRA_WIRELESS	0x2cf6
 
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
new file mode 100644
index 0000000..780acb4
--- /dev/null
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -0,0 +1,1053 @@
+/*
+ * Roccat Kone[+] driver for Linux
+ *
+ * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+/*
+ * Roccat Kone[+] is an updated/improved version of the Kone with more memory
+ * and functionality and without the non-standard behaviours the Kone had.
+ */
+
+#include <linux/device.h>
+#include <linux/input.h>
+#include <linux/hid.h>
+#include <linux/usb.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "hid-ids.h"
+#include "hid-roccat.h"
+#include "hid-roccat-koneplus.h"
+
+static void koneplus_profile_activated(struct koneplus_device *koneplus,
+		uint new_profile)
+{
+	koneplus->actual_profile = new_profile;
+}
+
+static int koneplus_send_control(struct usb_device *usb_dev, uint value,
+		enum koneplus_control_requests request)
+{
+	int len;
+	struct koneplus_control *control;
+
+	if ((request == KONEPLUS_CONTROL_REQUEST_PROFILE_SETTINGS ||
+			request == KONEPLUS_CONTROL_REQUEST_PROFILE_BUTTONS) &&
+			value > 4)
+		return -EINVAL;
+
+	control = kmalloc(sizeof(struct koneplus_control), GFP_KERNEL);
+	if (!control)
+		return -ENOMEM;
+
+	control->command = KONEPLUS_COMMAND_CONTROL;
+	control->value = value;
+	control->request = request;
+
+	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+			USB_REQ_SET_CONFIGURATION,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			KONEPLUS_USB_COMMAND_CONTROL, 0, control,
+			sizeof(struct koneplus_control),
+			USB_CTRL_SET_TIMEOUT);
+
+	kfree(control);
+
+	if (len != sizeof(struct koneplus_control))
+		return len;
+
+	return 0;
+}
+
+static int koneplus_receive(struct usb_device *usb_dev, uint usb_command,
+		void *buf, uint size) {
+	int len;
+
+	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			USB_REQ_CLEAR_FEATURE,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
+			usb_command, 0, buf, size, USB_CTRL_SET_TIMEOUT);
+
+	return (len != size) ? -EIO : 0;
+}
+
+static int koneplus_receive_control_status(struct usb_device *usb_dev)
+{
+	int retval;
+	struct koneplus_control *control;
+
+	control = kmalloc(sizeof(struct koneplus_control), GFP_KERNEL);
+	if (!control)
+		return -ENOMEM;
+
+	do {
+		retval = koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_CONTROL,
+				control, sizeof(struct koneplus_control));
+
+		/* check if we get a completely wrong answer */
+		if (retval)
+			goto out;
+
+		if (control->value == KONEPLUS_CONTROL_REQUEST_STATUS_OK) {
+			retval = 0;
+			goto out;
+		}
+
+		/* indicates that hardware needs some more time to complete action */
+		if (control->value == KONEPLUS_CONTROL_REQUEST_STATUS_WAIT) {
+			msleep(500); /* windows driver uses 1000 */
+			continue;
+		}
+
+		/* seems to be critical - replug necessary */
+		if (control->value == KONEPLUS_CONTROL_REQUEST_STATUS_OVERLOAD) {
+			retval = -EINVAL;
+			goto out;
+		}
+
+		dev_err(&usb_dev->dev, "koneplus_receive_control_status: "
+				"unknown response value 0x%x\n", control->value);
+		retval = -EINVAL;
+		goto out;
+
+	} while (1);
+out:
+	kfree(control);
+	return retval;
+}
+
+static int koneplus_send(struct usb_device *usb_dev, uint command,
+		void *buf, uint size) {
+	int len;
+
+	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+			USB_REQ_SET_CONFIGURATION,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			command, 0, buf, size, USB_CTRL_SET_TIMEOUT);
+
+	if (len != size)
+		return -EIO;
+
+	if (koneplus_receive_control_status(usb_dev))
+		return -EIO;
+
+	return 0;
+}
+
+static int koneplus_select_profile(struct usb_device *usb_dev, uint number,
+		enum koneplus_control_requests request)
+{
+	int retval;
+
+	retval = koneplus_send_control(usb_dev, number, request);
+	if (retval)
+		return retval;
+
+	/* allow time to settle things - windows driver uses 500 */
+	msleep(100);
+
+	retval = koneplus_receive_control_status(usb_dev);
+	if (retval)
+		return retval;
+
+	return 0;
+}
+
+static int koneplus_get_info(struct usb_device *usb_dev,
+		struct koneplus_info *buf)
+{
+	return koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_INFO,
+			buf, sizeof(struct koneplus_info));
+}
+
+static int koneplus_get_profile_settings(struct usb_device *usb_dev,
+		struct koneplus_profile_settings *buf, uint number)
+{
+	int retval;
+
+	retval = koneplus_select_profile(usb_dev, number,
+			KONEPLUS_CONTROL_REQUEST_PROFILE_SETTINGS);
+	if (retval)
+		return retval;
+
+	return koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_SETTINGS,
+			buf, sizeof(struct koneplus_profile_settings));
+}
+
+static int koneplus_set_profile_settings(struct usb_device *usb_dev,
+		struct koneplus_profile_settings const *settings)
+{
+	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_SETTINGS,
+			(void *)settings, sizeof(struct koneplus_profile_settings));
+}
+
+static int koneplus_get_profile_buttons(struct usb_device *usb_dev,
+		struct koneplus_profile_buttons *buf, int number)
+{
+	int retval;
+
+	retval = koneplus_select_profile(usb_dev, number,
+			KONEPLUS_CONTROL_REQUEST_PROFILE_BUTTONS);
+	if (retval)
+		return retval;
+
+	return koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_BUTTONS,
+			buf, sizeof(struct koneplus_profile_buttons));
+}
+
+static int koneplus_set_profile_buttons(struct usb_device *usb_dev,
+		struct koneplus_profile_buttons const *buttons)
+{
+	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_BUTTONS,
+			(void *)buttons, sizeof(struct koneplus_profile_buttons));
+}
+
+/* retval is 0-4 on success, < 0 on error */
+static int koneplus_get_startup_profile(struct usb_device *usb_dev)
+{
+	struct koneplus_startup_profile *buf;
+	int retval;
+
+	buf = kmalloc(sizeof(struct koneplus_startup_profile), GFP_KERNEL);
+
+	retval = koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_STARTUP_PROFILE,
+			buf, sizeof(struct koneplus_startup_profile));
+
+	if (retval)
+		goto out;
+
+	retval = buf->startup_profile;
+out:
+	kfree(buf);
+	return retval;
+}
+
+static int koneplus_set_startup_profile(struct usb_device *usb_dev,
+		int startup_profile)
+{
+	struct koneplus_startup_profile buf;
+
+	buf.command = KONEPLUS_COMMAND_STARTUP_PROFILE;
+	buf.size = sizeof(struct koneplus_startup_profile);
+	buf.startup_profile = startup_profile;
+
+	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_STARTUP_PROFILE,
+			(char *)&buf, sizeof(struct koneplus_profile_buttons));
+}
+
+static ssize_t koneplus_sysfs_read(struct file *fp, struct kobject *kobj,
+		char *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+
+	if (off != 0 || count != real_size)
+		return -EINVAL;
+
+	mutex_lock(&koneplus->koneplus_lock);
+	retval = koneplus_receive(usb_dev, command, buf, real_size);
+	mutex_unlock(&koneplus->koneplus_lock);
+
+	if (retval)
+		return retval;
+
+	return real_size;
+}
+
+static ssize_t koneplus_sysfs_write(struct file *fp, struct kobject *kobj,
+		void const *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+
+	if (off != 0 || count != real_size)
+		return -EINVAL;
+
+	mutex_lock(&koneplus->koneplus_lock);
+	retval = koneplus_send(usb_dev, command, (void *)buf, real_size);
+	mutex_unlock(&koneplus->koneplus_lock);
+
+	if (retval)
+		return retval;
+
+	return real_size;
+}
+
+static ssize_t koneplus_sysfs_write_macro(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_write(fp, kobj, buf, off, count,
+			sizeof(struct koneplus_macro), KONEPLUS_USB_COMMAND_MACRO);
+}
+
+static ssize_t koneplus_sysfs_read_sensor(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_read(fp, kobj, buf, off, count,
+			sizeof(struct koneplus_sensor), KONEPLUS_USB_COMMAND_SENSOR);
+}
+
+static ssize_t koneplus_sysfs_write_sensor(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_write(fp, kobj, buf, off, count,
+			sizeof(struct koneplus_sensor), KONEPLUS_USB_COMMAND_SENSOR);
+}
+
+static ssize_t koneplus_sysfs_write_tcu(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_write(fp, kobj, buf, off, count,
+			sizeof(struct koneplus_tcu), KONEPLUS_USB_COMMAND_TCU);
+}
+
+static ssize_t koneplus_sysfs_read_tcu_image(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_read(fp, kobj, buf, off, count,
+			sizeof(struct koneplus_tcu_image), KONEPLUS_USB_COMMAND_TCU);
+}
+
+static ssize_t koneplus_sysfs_read_profilex_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count, uint number)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
+
+	if (off >= sizeof(struct koneplus_profile_settings))
+		return 0;
+
+	if (off + count > sizeof(struct koneplus_profile_settings))
+		count = sizeof(struct koneplus_profile_settings) - off;
+
+	mutex_lock(&koneplus->koneplus_lock);
+	memcpy(buf, ((void const *)&koneplus->profile_settings[number]) + off,
+			count);
+	mutex_unlock(&koneplus->koneplus_lock);
+
+	return count;
+}
+
+static ssize_t koneplus_sysfs_read_profile1_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_read_profilex_settings(fp, kobj,
+			attr, buf, off, count, 0);
+}
+
+static ssize_t koneplus_sysfs_read_profile2_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_read_profilex_settings(fp, kobj,
+			attr, buf, off, count, 1);
+}
+
+static ssize_t koneplus_sysfs_read_profile3_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_read_profilex_settings(fp, kobj,
+			attr, buf, off, count, 2);
+}
+
+static ssize_t koneplus_sysfs_read_profile4_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_read_profilex_settings(fp, kobj,
+			attr, buf, off, count, 3);
+}
+
+static ssize_t koneplus_sysfs_read_profile5_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_read_profilex_settings(fp, kobj,
+			attr, buf, off, count, 4);
+}
+
+static ssize_t koneplus_sysfs_write_profile_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval = 0;
+	int difference;
+	int profile_number;
+	struct koneplus_profile_settings *profile_settings;
+
+	if (off != 0 || count != sizeof(struct koneplus_profile_settings))
+		return -EINVAL;
+
+	profile_number = ((struct koneplus_profile_settings const *)buf)->number;
+	profile_settings = &koneplus->profile_settings[profile_number];
+
+	mutex_lock(&koneplus->koneplus_lock);
+	difference = memcmp(buf, profile_settings,
+			sizeof(struct koneplus_profile_settings));
+	if (difference) {
+		retval = koneplus_set_profile_settings(usb_dev,
+				(struct koneplus_profile_settings const *)buf);
+		if (!retval)
+			memcpy(profile_settings, buf,
+					sizeof(struct koneplus_profile_settings));
+	}
+	mutex_unlock(&koneplus->koneplus_lock);
+
+	if (retval)
+		return retval;
+
+	return sizeof(struct koneplus_profile_settings);
+}
+
+static ssize_t koneplus_sysfs_read_profilex_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count, uint number)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
+
+	if (off >= sizeof(struct koneplus_profile_buttons))
+		return 0;
+
+	if (off + count > sizeof(struct koneplus_profile_buttons))
+		count = sizeof(struct koneplus_profile_buttons) - off;
+
+	mutex_lock(&koneplus->koneplus_lock);
+	memcpy(buf, ((void const *)&koneplus->profile_buttons[number]) + off,
+			count);
+	mutex_unlock(&koneplus->koneplus_lock);
+
+	return count;
+}
+
+static ssize_t koneplus_sysfs_read_profile1_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_read_profilex_buttons(fp, kobj,
+			attr, buf, off, count, 0);
+}
+
+static ssize_t koneplus_sysfs_read_profile2_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_read_profilex_buttons(fp, kobj,
+			attr, buf, off, count, 1);
+}
+
+static ssize_t koneplus_sysfs_read_profile3_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_read_profilex_buttons(fp, kobj,
+			attr, buf, off, count, 2);
+}
+
+static ssize_t koneplus_sysfs_read_profile4_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_read_profilex_buttons(fp, kobj,
+			attr, buf, off, count, 3);
+}
+
+static ssize_t koneplus_sysfs_read_profile5_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_read_profilex_buttons(fp, kobj,
+			attr, buf, off, count, 4);
+}
+
+static ssize_t koneplus_sysfs_write_profile_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval = 0;
+	int difference;
+	uint profile_number;
+	struct koneplus_profile_buttons *profile_buttons;
+
+	if (off != 0 || count != sizeof(struct koneplus_profile_buttons))
+		return -EINVAL;
+
+	profile_number = ((struct koneplus_profile_buttons const *)buf)->number;
+	profile_buttons = &koneplus->profile_buttons[profile_number];
+
+	mutex_lock(&koneplus->koneplus_lock);
+	difference = memcmp(buf, profile_buttons,
+			sizeof(struct koneplus_profile_buttons));
+	if (difference) {
+		retval = koneplus_set_profile_buttons(usb_dev,
+				(struct koneplus_profile_buttons const *)buf);
+		if (!retval)
+			memcpy(profile_buttons, buf,
+					sizeof(struct koneplus_profile_buttons));
+	}
+	mutex_unlock(&koneplus->koneplus_lock);
+
+	if (retval)
+		return retval;
+
+	return sizeof(struct koneplus_profile_buttons);
+}
+
+static ssize_t koneplus_sysfs_show_startup_profile(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
+	return snprintf(buf, PAGE_SIZE, "%d\n", koneplus->startup_profile);
+}
+
+static ssize_t koneplus_sysfs_set_startup_profile(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	unsigned long profile;
+	int retval;
+
+	retval = strict_strtoul(buf, 10, &profile);
+	if (retval)
+		return retval;
+
+	mutex_lock(&koneplus->koneplus_lock);
+	retval = koneplus_set_startup_profile(usb_dev, profile);
+	mutex_unlock(&koneplus->koneplus_lock);
+	if (retval)
+		return retval;
+
+	return size;
+}
+
+static ssize_t koneplus_sysfs_show_actual_profile(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
+	return snprintf(buf, PAGE_SIZE, "%d\n", koneplus->actual_profile);
+}
+
+static ssize_t koneplus_sysfs_show_firmware_version(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
+	return snprintf(buf, PAGE_SIZE, "%d\n", koneplus->info.firmware_version);
+}
+
+static DEVICE_ATTR(startup_profile, 0660,
+		koneplus_sysfs_show_startup_profile,
+		koneplus_sysfs_set_startup_profile);
+
+static DEVICE_ATTR(actual_profile, 0440,
+		koneplus_sysfs_show_actual_profile, NULL);
+
+static DEVICE_ATTR(firmware_version, 0440,
+		koneplus_sysfs_show_firmware_version, NULL);
+
+static struct attribute *koneplus_attributes[] = {
+		&dev_attr_startup_profile.attr,
+		&dev_attr_actual_profile.attr,
+		&dev_attr_firmware_version.attr,
+		NULL
+};
+
+static struct attribute_group koneplus_attribute_group = {
+		.attrs = koneplus_attributes
+};
+
+static struct bin_attribute koneplus_sensor_attr = {
+		.attr = { .name = "sensor", .mode = 0220 },
+		.size = sizeof(struct koneplus_sensor),
+		.read = koneplus_sysfs_read_sensor,
+		.write = koneplus_sysfs_write_sensor
+};
+
+static struct bin_attribute koneplus_tcu_attr = {
+		.attr = { .name = "tcu", .mode = 0220 },
+		.size = sizeof(struct koneplus_tcu),
+		.write = koneplus_sysfs_write_tcu
+};
+
+static struct bin_attribute koneplus_tcu_image_attr = {
+		.attr = { .name = "tcu_image", .mode = 0440 },
+		.size = sizeof(struct koneplus_tcu_image),
+		.read = koneplus_sysfs_read_tcu_image
+};
+
+static struct bin_attribute koneplus_profile_settings_attr = {
+		.attr = { .name = "profile_settings", .mode = 0220 },
+		.size = sizeof(struct koneplus_profile_settings),
+		.write = koneplus_sysfs_write_profile_settings
+};
+
+static struct bin_attribute koneplus_profile1_settings_attr = {
+		.attr = { .name = "profile1_settings", .mode = 0440 },
+		.size = sizeof(struct koneplus_profile_settings),
+		.read = koneplus_sysfs_read_profile1_settings
+};
+
+static struct bin_attribute koneplus_profile2_settings_attr = {
+		.attr = { .name = "profile2_settings", .mode = 0440 },
+		.size = sizeof(struct koneplus_profile_settings),
+		.read = koneplus_sysfs_read_profile2_settings
+};
+
+static struct bin_attribute koneplus_profile3_settings_attr = {
+		.attr = { .name = "profile3_settings", .mode = 0440 },
+		.size = sizeof(struct koneplus_profile_settings),
+		.read = koneplus_sysfs_read_profile3_settings
+};
+
+static struct bin_attribute koneplus_profile4_settings_attr = {
+		.attr = { .name = "profile4_settings", .mode = 0440 },
+		.size = sizeof(struct koneplus_profile_settings),
+		.read = koneplus_sysfs_read_profile4_settings
+};
+
+static struct bin_attribute koneplus_profile5_settings_attr = {
+		.attr = { .name = "profile5_settings", .mode = 0440 },
+		.size = sizeof(struct koneplus_profile_settings),
+		.read = koneplus_sysfs_read_profile5_settings
+};
+
+static struct bin_attribute koneplus_profile_buttons_attr = {
+		.attr = { .name = "profile_buttons", .mode = 0220 },
+		.size = sizeof(struct koneplus_profile_buttons),
+		.write = koneplus_sysfs_write_profile_buttons
+};
+
+static struct bin_attribute koneplus_profile1_buttons_attr = {
+		.attr = { .name = "profile1_buttons", .mode = 0440 },
+		.size = sizeof(struct koneplus_profile_buttons),
+		.read = koneplus_sysfs_read_profile1_buttons
+};
+
+static struct bin_attribute koneplus_profile2_buttons_attr = {
+		.attr = { .name = "profile2_buttons", .mode = 0440 },
+		.size = sizeof(struct koneplus_profile_buttons),
+		.read = koneplus_sysfs_read_profile2_buttons
+};
+
+static struct bin_attribute koneplus_profile3_buttons_attr = {
+		.attr = { .name = "profile3_buttons", .mode = 0440 },
+		.size = sizeof(struct koneplus_profile_buttons),
+		.read = koneplus_sysfs_read_profile3_buttons
+};
+
+static struct bin_attribute koneplus_profile4_buttons_attr = {
+		.attr = { .name = "profile4_buttons", .mode = 0440 },
+		.size = sizeof(struct koneplus_profile_buttons),
+		.read = koneplus_sysfs_read_profile4_buttons
+};
+
+static struct bin_attribute koneplus_profile5_buttons_attr = {
+		.attr = { .name = "profile5_buttons", .mode = 0440 },
+		.size = sizeof(struct koneplus_profile_buttons),
+		.read = koneplus_sysfs_read_profile5_buttons
+};
+
+static struct bin_attribute koneplus_macro_attr = {
+		.attr = { .name = "macro", .mode = 0220 },
+		.size = sizeof(struct koneplus_macro),
+		.write = koneplus_sysfs_write_macro
+};
+
+static int koneplus_create_sysfs_attributes(struct usb_interface *intf)
+{
+	int retval;
+
+	retval = sysfs_create_group(&intf->dev.kobj, &koneplus_attribute_group);
+	if (retval)
+		goto exit_1;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_profile_settings_attr);
+	if (retval)
+		goto exit_2;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_profile1_settings_attr);
+	if (retval)
+		goto exit_3;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_profile2_settings_attr);
+	if (retval)
+		goto exit_4;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_profile3_settings_attr);
+	if (retval)
+		goto exit_5;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_profile4_settings_attr);
+	if (retval)
+		goto exit_6;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_profile5_settings_attr);
+	if (retval)
+		goto exit_7;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_profile_buttons_attr);
+	if (retval)
+		goto exit_8;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_profile1_buttons_attr);
+	if (retval)
+		goto exit_9;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_profile2_buttons_attr);
+	if (retval)
+		goto exit_10;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_profile3_buttons_attr);
+	if (retval)
+		goto exit_11;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_profile4_buttons_attr);
+	if (retval)
+		goto exit_12;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_profile5_buttons_attr);
+	if (retval)
+		goto exit_13;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_macro_attr);
+	if (retval)
+		goto exit_14;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_tcu_image_attr);
+	if (retval)
+		goto exit_15;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_tcu_attr);
+	if (retval)
+		goto exit_16;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&koneplus_sensor_attr);
+	if (retval)
+		goto exit_17;
+
+	return 0;
+
+exit_17:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_tcu_attr);
+exit_16:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_tcu_image_attr);
+exit_15:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_macro_attr);
+exit_14:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile5_buttons_attr);
+exit_13:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile4_buttons_attr);
+exit_12:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile3_buttons_attr);
+exit_11:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile2_buttons_attr);
+exit_10:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile1_buttons_attr);
+exit_9:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile_buttons_attr);
+exit_8:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile5_settings_attr);
+exit_7:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile4_settings_attr);
+exit_6:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile3_settings_attr);
+exit_5:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile2_settings_attr);
+exit_4:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile1_settings_attr);
+exit_3:
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile_settings_attr);
+exit_2:
+	sysfs_remove_group(&intf->dev.kobj, &koneplus_attribute_group);
+exit_1:
+	return retval;
+}
+
+static void koneplus_remove_sysfs_attributes(struct usb_interface *intf)
+{
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_sensor_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_tcu_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_tcu_image_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_macro_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile5_buttons_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile4_buttons_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile3_buttons_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile2_buttons_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile1_buttons_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile_buttons_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile5_settings_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile4_settings_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile3_settings_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile2_settings_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile1_settings_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &koneplus_profile_settings_attr);
+	sysfs_remove_group(&intf->dev.kobj, &koneplus_attribute_group);
+}
+
+static int koneplus_init_koneplus_device_struct(struct usb_device *usb_dev,
+		struct koneplus_device *koneplus)
+{
+	int retval, i;
+	static uint wait = 70; /* device will freeze with just 60 */
+
+	mutex_init(&koneplus->koneplus_lock);
+
+	koneplus->startup_profile = koneplus_get_startup_profile(usb_dev);
+
+	msleep(wait);
+	retval = koneplus_get_info(usb_dev, &koneplus->info);
+	if (retval)
+		return retval;
+
+	for (i = 0; i < 5; ++i) {
+		msleep(wait);
+		retval = koneplus_get_profile_settings(usb_dev,
+				&koneplus->profile_settings[i], i);
+		if (retval)
+			return retval;
+
+		msleep(wait);
+		retval = koneplus_get_profile_buttons(usb_dev,
+				&koneplus->profile_buttons[i], i);
+		if (retval)
+			return retval;
+	}
+
+	koneplus_profile_activated(koneplus, koneplus->startup_profile);
+
+	return 0;
+}
+
+static int koneplus_init_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct koneplus_device *koneplus;
+	int retval;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			== USB_INTERFACE_PROTOCOL_MOUSE) {
+
+		koneplus = kzalloc(sizeof(*koneplus), GFP_KERNEL);
+		if (!koneplus) {
+			dev_err(&hdev->dev, "can't alloc device descriptor\n");
+			return -ENOMEM;
+		}
+		hid_set_drvdata(hdev, koneplus);
+
+		retval = koneplus_init_koneplus_device_struct(usb_dev, koneplus);
+		if (retval) {
+			dev_err(&hdev->dev,
+					"couldn't init struct koneplus_device\n");
+			goto exit_free;
+		}
+
+		retval = roccat_connect(hdev);
+		if (retval < 0) {
+			dev_err(&hdev->dev, "couldn't init char dev\n");
+		} else {
+			koneplus->chrdev_minor = retval;
+			koneplus->roccat_claimed = 1;
+		}
+
+		retval = koneplus_create_sysfs_attributes(intf);
+		if (retval) {
+			dev_err(&hdev->dev, "cannot create sysfs files\n");
+			goto exit_free;
+		}
+	} else {
+		hid_set_drvdata(hdev, NULL);
+	}
+
+	return 0;
+exit_free:
+	kfree(koneplus);
+	return retval;
+}
+
+static void koneplus_remove_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct koneplus_device *koneplus;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			== USB_INTERFACE_PROTOCOL_MOUSE) {
+		koneplus_remove_sysfs_attributes(intf);
+		koneplus = hid_get_drvdata(hdev);
+		if (koneplus->roccat_claimed)
+			roccat_disconnect(koneplus->chrdev_minor);
+		kfree(koneplus);
+	}
+}
+
+static int koneplus_probe(struct hid_device *hdev,
+		const struct hid_device_id *id)
+{
+	int retval;
+
+	retval = hid_parse(hdev);
+	if (retval) {
+		dev_err(&hdev->dev, "parse failed\n");
+		goto exit;
+	}
+
+	retval = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (retval) {
+		dev_err(&hdev->dev, "hw start failed\n");
+		goto exit;
+	}
+
+	retval = koneplus_init_specials(hdev);
+	if (retval) {
+		dev_err(&hdev->dev, "couldn't install mouse\n");
+		goto exit_stop;
+	}
+
+	return 0;
+
+exit_stop:
+	hid_hw_stop(hdev);
+exit:
+	return retval;
+}
+
+static void koneplus_remove(struct hid_device *hdev)
+{
+	koneplus_remove_specials(hdev);
+	hid_hw_stop(hdev);
+}
+
+static void koneplus_keep_values_up_to_date(struct koneplus_device *koneplus,
+		u8 const *data)
+{
+	struct koneplus_mouse_report_button const *button_report;
+
+	switch (data[0]) {
+	case KONEPLUS_MOUSE_REPORT_NUMBER_BUTTON:
+		button_report = (struct koneplus_mouse_report_button const *)data;
+		switch (button_report->type) {
+		case KONEPLUS_MOUSE_REPORT_BUTTON_TYPE_PROFILE:
+			koneplus_profile_activated(koneplus, button_report->data1 - 1);
+			break;
+		}
+		break;
+	}
+}
+
+static void koneplus_report_to_chrdev(struct koneplus_device const *koneplus,
+		u8 const *data)
+{
+	struct koneplus_roccat_report roccat_report;
+	struct koneplus_mouse_report_button const *button_report;
+
+	if (data[0] != KONEPLUS_MOUSE_REPORT_NUMBER_BUTTON)
+		return;
+
+	button_report = (struct koneplus_mouse_report_button const *)data;
+
+	if ((button_report->type == KONEPLUS_MOUSE_REPORT_BUTTON_TYPE_QUICKLAUNCH ||
+			button_report->type == KONEPLUS_MOUSE_REPORT_BUTTON_TYPE_TIMER) &&
+			button_report->data2 != KONEPLUS_MOUSE_REPORT_BUTTON_ACTION_PRESS)
+		return;
+
+	roccat_report.type = button_report->type;
+	roccat_report.data1 = button_report->data1;
+	roccat_report.data2 = button_report->data2;
+	roccat_report.profile = koneplus->actual_profile + 1;
+	roccat_report_event(koneplus->chrdev_minor,
+			(uint8_t const *)&roccat_report,
+			sizeof(struct koneplus_roccat_report));
+}
+
+static int koneplus_raw_event(struct hid_device *hdev,
+		struct hid_report *report, u8 *data, int size)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct koneplus_device *koneplus = hid_get_drvdata(hdev);
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= USB_INTERFACE_PROTOCOL_MOUSE)
+		return 0;
+
+	koneplus_keep_values_up_to_date(koneplus, data);
+
+	if (koneplus->roccat_claimed)
+		koneplus_report_to_chrdev(koneplus, data);
+
+	return 0;
+}
+
+static const struct hid_device_id koneplus_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPLUS) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(hid, koneplus_devices);
+
+static struct hid_driver koneplus_driver = {
+		.name = "koneplus",
+		.id_table = koneplus_devices,
+		.probe = koneplus_probe,
+		.remove = koneplus_remove,
+		.raw_event = koneplus_raw_event
+};
+
+static int __init koneplus_init(void)
+{
+	return hid_register_driver(&koneplus_driver);
+}
+
+static void __exit koneplus_exit(void)
+{
+	hid_unregister_driver(&koneplus_driver);
+}
+
+module_init(koneplus_init);
+module_exit(koneplus_exit);
+
+MODULE_AUTHOR("Stefan Achatz");
+MODULE_DESCRIPTION("USB Roccat Kone[+] driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-roccat-koneplus.h b/drivers/hid/hid-roccat-koneplus.h
new file mode 100644
index 0000000..bf750fa
--- /dev/null
+++ b/drivers/hid/hid-roccat-koneplus.h
@@ -0,0 +1,229 @@
+#ifndef __HID_ROCCAT_KONEPLUS_H
+#define __HID_ROCCAT_KONEPLUS_H
+
+/*
+ * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/types.h>
+
+#pragma pack(push)
+#pragma pack(1)
+
+/*
+ * case 1: writes request 80 and reads value 1
+ *
+ */
+struct koneplus_control {
+	uint8_t command; /* KONEPLUS_COMMAND_CONTROL */
+	/*
+	 * value is profile number in range 0-4 for requesting settings and buttons
+	 * 1 if status ok for requesting status
+	 */
+	uint8_t value;
+	uint8_t request;
+};
+
+enum koneplus_control_requests {
+	KONEPLUS_CONTROL_REQUEST_STATUS = 0x00,
+	KONEPLUS_CONTROL_REQUEST_PROFILE_SETTINGS = 0x80,
+	KONEPLUS_CONTROL_REQUEST_PROFILE_BUTTONS = 0x90,
+};
+
+enum koneplus_control_values {
+	KONEPLUS_CONTROL_REQUEST_STATUS_OVERLOAD = 0,
+	KONEPLUS_CONTROL_REQUEST_STATUS_OK = 1,
+	KONEPLUS_CONTROL_REQUEST_STATUS_WAIT = 3,
+};
+
+struct koneplus_startup_profile {
+	uint8_t command; /* KONEPLUS_COMMAND_STARTUP_PROFILE */
+	uint8_t size; /* always 3 */
+	uint8_t startup_profile; /* Range 0-4! */
+};
+
+struct koneplus_profile_settings {
+	uint8_t command; /* KONEPLUS_COMMAND_PROFILE_SETTINGS */
+	uint8_t size; /* always 43 */
+	uint8_t number; /* range 0-4 */
+	uint8_t advanced_sensitivity;
+	uint8_t sensitivity_x;
+	uint8_t sensitivity_y;
+	uint8_t cpi_levels_enabled;
+	uint8_t cpi_levels_x[5];
+	uint8_t cpi_startup_level; /* range 0-4 */
+	uint8_t cpi_levels_y[5]; /* range 1-60 means 100-6000 cpi */
+	uint8_t unknown1;
+	uint8_t polling_rate;
+	uint8_t lights_enabled;
+	uint8_t light_effect_mode;
+	uint8_t color_flow_effect;
+	uint8_t light_effect_type;
+	uint8_t light_effect_speed;
+	uint8_t lights[16];
+	uint16_t checksum;
+};
+
+struct koneplus_profile_buttons {
+	uint8_t command; /* KONEPLUS_COMMAND_PROFILE_BUTTONS */
+	uint8_t size; /* always 77 */
+	uint8_t number; /* range 0-4 */
+	uint8_t data[72];
+	uint16_t checksum;
+};
+
+struct koneplus_macro {
+	uint8_t command; /* KONEPLUS_COMMAND_MACRO */
+	uint16_t size; /* always 0x822 little endian */
+	uint8_t profile; /* range 0-4 */
+	uint8_t button; /* range 0-23 */
+	uint8_t data[2075];
+	uint16_t checksum;
+};
+
+struct koneplus_info {
+	uint8_t command; /* KONEPLUS_COMMAND_INFO */
+	uint8_t size; /* always 6 */
+	uint8_t firmware_version;
+	uint8_t unknown[3];
+};
+
+struct koneplus_e {
+	uint8_t command; /* KONEPLUS_COMMAND_E */
+	uint8_t size; /* always 3 */
+	uint8_t unknown; /* TODO 1; 0 before firmware update */
+};
+
+struct koneplus_sensor {
+	uint8_t command;  /* KONEPLUS_COMMAND_SENSOR */
+	uint8_t size; /* always 6 */
+	uint8_t data[4];
+};
+
+struct koneplus_firmware_write {
+	uint8_t command; /* KONEPLUS_COMMAND_FIRMWARE_WRITE */
+	uint8_t unknown[1025];
+};
+
+struct koneplus_firmware_write_control {
+	uint8_t command; /* KONEPLUS_COMMAND_FIRMWARE_WRITE_CONTROL */
+	/*
+	 * value is 1 on success
+	 * 3 means "not finished yet"
+	 */
+	uint8_t value;
+	uint8_t unknown; /* always 0x75 */
+};
+
+struct koneplus_tcu {
+	uint16_t usb_command; /* KONEPLUS_USB_COMMAND_TCU */
+	uint8_t data[2];
+};
+
+struct koneplus_tcu_image {
+	uint16_t usb_command; /* KONEPLUS_USB_COMMAND_TCU */
+	uint8_t data[1024];
+	uint16_t checksum;
+};
+
+enum koneplus_commands {
+	KONEPLUS_COMMAND_CONTROL = 0x4,
+	KONEPLUS_COMMAND_STARTUP_PROFILE = 0x5,
+	KONEPLUS_COMMAND_PROFILE_SETTINGS = 0x6,
+	KONEPLUS_COMMAND_PROFILE_BUTTONS = 0x7,
+	KONEPLUS_COMMAND_MACRO = 0x8,
+	KONEPLUS_COMMAND_INFO = 0x9,
+	KONEPLUS_COMMAND_E = 0xe,
+	KONEPLUS_COMMAND_SENSOR = 0xf,
+	KONEPLUS_COMMAND_FIRMWARE_WRITE = 0x1b,
+	KONEPLUS_COMMAND_FIRMWARE_WRITE_CONTROL = 0x1c,
+};
+
+enum koneplus_usb_commands {
+	KONEPLUS_USB_COMMAND_CONTROL = 0x304,
+	KONEPLUS_USB_COMMAND_STARTUP_PROFILE = 0x305,
+	KONEPLUS_USB_COMMAND_PROFILE_SETTINGS = 0x306,
+	KONEPLUS_USB_COMMAND_PROFILE_BUTTONS = 0x307,
+	KONEPLUS_USB_COMMAND_MACRO = 0x308,
+	KONEPLUS_USB_COMMAND_INFO = 0x309,
+	KONEPLUS_USB_COMMAND_TCU = 0x30c,
+	KONEPLUS_USB_COMMAND_E = 0x30e,
+	KONEPLUS_USB_COMMAND_SENSOR = 0x30f,
+	KONEPLUS_USB_COMMAND_FIRMWARE_WRITE = 0x31b,
+	KONEPLUS_USB_COMMAND_FIRMWARE_WRITE_CONTROL = 0x31c,
+};
+
+enum koneplus_mouse_report_numbers {
+	KONEPLUS_MOUSE_REPORT_NUMBER_HID = 1,
+	KONEPLUS_MOUSE_REPORT_NUMBER_AUDIO = 2,
+	KONEPLUS_MOUSE_REPORT_NUMBER_BUTTON = 3,
+};
+
+struct koneplus_mouse_report_button {
+	uint8_t report_number; /* always KONEPLUS_MOUSE_REPORT_NUMBER_BUTTON */
+	uint8_t zero1;
+	uint8_t type;
+	uint8_t data1;
+	uint8_t data2;
+	uint8_t zero2;
+	uint8_t unknown[2];
+};
+
+enum koneplus_mouse_report_button_types {
+	/* data1 = new profile range 1-5 */
+	KONEPLUS_MOUSE_REPORT_BUTTON_TYPE_PROFILE = 0x20,
+
+	/* data1 = button number range 1-24; data2 = action */
+	KONEPLUS_MOUSE_REPORT_BUTTON_TYPE_QUICKLAUNCH = 0x60,
+
+	/* data1 = button number range 1-24; data2 = action */
+	KONEPLUS_MOUSE_REPORT_BUTTON_TYPE_TIMER = 0x80,
+
+	/* data1 = setting number range 1-5 */
+	KONEPLUS_MOUSE_REPORT_BUTTON_TYPE_CPI = 0xb0,
+
+	/* data1 and data2 = range 0x1-0xb */
+	KONEPLUS_MOUSE_REPORT_BUTTON_TYPE_SENSITIVITY = 0xc0,
+
+	/* data1 = 22 = next track...
+	 * data2 = action
+	 */
+	KONEPLUS_MOUSE_REPORT_BUTTON_TYPE_MULTIMEDIA = 0xf0,
+};
+
+enum koneplus_mouse_report_button_action {
+	KONEPLUS_MOUSE_REPORT_BUTTON_ACTION_PRESS = 0,
+	KONEPLUS_MOUSE_REPORT_BUTTON_ACTION_RELEASE = 1,
+};
+
+struct koneplus_roccat_report {
+	uint8_t type;
+	uint8_t data1;
+	uint8_t data2;
+	uint8_t profile;
+};
+
+#pragma pack(pop)
+
+struct koneplus_device {
+	int actual_profile;
+
+	int roccat_claimed;
+	int chrdev_minor;
+
+	struct mutex koneplus_lock;
+
+	int startup_profile;
+	struct koneplus_info info;
+	struct koneplus_profile_settings profile_settings[5];
+	struct koneplus_profile_buttons profile_buttons[5];
+};
+
+#endif
-- 
1.7.2.3



