Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0H2Ka1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 06:30:27 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:56558 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492Ab0H2KaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 06:30:24 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-14.arcor-online.net C86559C296
Subject: [PATCH] HID: roccat: add driver for Roccat Pyra mouse
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>,
        Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Stephane Chatty <chatty@enac.fr>,
        Don Prince <dhprince-devel@yahoo.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, Kees Bakker <kees.bakker@xs4all.nl>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Aug 2010 12:30:18 +0200
Message-ID: <1283077818.2086.1.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for Pyra mobile gaming mouse from Roccat.
It provides access to profiles, settings, actual settings etc.
through sysfs attributes.
This driver is conceptual similar to the existing Kone driver.
Userland tools can soon be found at http://sourceforge.net/projects/roccat

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-pyra       |   98 ++
 drivers/hid/Kconfig                                |    7 +
 drivers/hid/Makefile                               |    1 +
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    2 +
 drivers/hid/hid-roccat-pyra.c                      |  964 ++++++++++++++++++++
 drivers/hid/hid-roccat-pyra.h                      |  186 ++++
 7 files changed, 1259 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
 create mode 100644 drivers/hid/hid-roccat-pyra.c
 create mode 100644 drivers/hid/hid-roccat-pyra.h

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra b/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
new file mode 100644
index 0000000..ad1125b
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
@@ -0,0 +1,98 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/actual_cpi
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
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/actual_profile
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the number of the actual profile in
+		range 0-4.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/firmware_version
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the raw integer version number of the
+		firmware reported by the mouse. Using the integer value eases
+		further usage in other programs. To receive the real version
+		number the decimal point has to be shifted 2 positions to the
+		left. E.g. a returned value of 138 means 1.38
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile_settings
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_settings holds informations like resolution, sensitivity
+		and light effects.
+		When written, this file lets one write the respective profile
+		settings back to the mouse. The data has to be 13 bytes long.
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
+		The returned data is 13 bytes in size.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile_buttons
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+		press of a button. A profile is split in settings and buttons.
+		profile_buttons holds informations about button layout.
+		When written, this file lets one write the respective profile
+		buttons back to the mouse. The data has to be 19 bytes long.
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
+		The returned data is 19 bytes in size.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/startup_profile
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 0-4.
+                When read, this attribute returns the number of the profile
+                that's active when the mouse is powered on.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/settings
+Date:		August 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the settings stored in the mouse.
+		The size of the data is 3 bytes and holds information on the
+		startup_profile.
+		When written, this file lets write settings back to the mouse.
+		The data has to be 3 bytes long. The mouse will reject invalid
+		data.
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 6369ba7..b07440a 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -376,6 +376,13 @@ config HID_ROCCAT_KONE
 	---help---
 	Support for Roccat Kone mouse.
 
+config HID_ROCCAT_PYRA
+	tristate "Roccat Pyra mouse support"
+	depends on USB_HID
+	select HID_ROCCAT
+	---help---
+	Support for Roccat Pyra mouse.
+
 config HID_SAMSUNG
 	tristate "Samsung"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 46f037f..d224fa3 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_HID_PETALYNX)	+= hid-petalynx.o
 obj-$(CONFIG_HID_PICOLCD)	+= hid-picolcd.o
 obj-$(CONFIG_HID_ROCCAT)	+= hid-roccat.o
 obj-$(CONFIG_HID_ROCCAT_KONE)	+= hid-roccat-kone.o
+obj-$(CONFIG_HID_ROCCAT_PYRA)	+= hid-roccat-pyra.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SMARTJOYPLUS)	+= hid-sjoy.o
 obj-$(CONFIG_HID_SONY)		+= hid-sony.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 0c52899..18608b8 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1367,6 +1367,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRED) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 85c6d13..5787b1a 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -459,6 +459,8 @@
 
 #define USB_VENDOR_ID_ROCCAT		0x1e7d
 #define USB_DEVICE_ID_ROCCAT_KONE	0x2ced
+#define USB_DEVICE_ID_ROCCAT_PYRA_WIRED	0x2c24
+#define USB_DEVICE_ID_ROCCAT_PYRA_WIRELESS	0x2cf6
 
 #define USB_VENDOR_ID_SAITEK		0x06a3
 #define USB_DEVICE_ID_SAITEK_RUMBLEPAD	0xff17
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
new file mode 100644
index 0000000..6c09c15
--- /dev/null
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -0,0 +1,964 @@
+/*
+ * Roccat Pyra driver for Linux
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
+ * Roccat Pyra is a mobile gamer mouse which comes in wired and wireless
+ * variant. Wireless variant is not tested.
+ * Userland tools can be found at http://sourceforge.net/projects/roccat
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
+#include "hid-roccat-pyra.h"
+
+static void profile_activated(struct pyra_device *pyra,
+		unsigned int new_profile)
+{
+	pyra->actual_profile = new_profile;
+	pyra->actual_cpi = pyra->profile_settings[pyra->actual_profile].y_cpi;
+}
+
+static int pyra_send_control(struct usb_device *usb_dev, int value,
+		enum pyra_control_requests request)
+{
+	int len;
+	struct pyra_control control;
+
+	if ((request == PYRA_CONTROL_REQUEST_PROFILE_SETTINGS ||
+			request == PYRA_CONTROL_REQUEST_PROFILE_BUTTONS) &&
+			(value < 0 || value > 4))
+		return -EINVAL;
+
+	control.command = PYRA_COMMAND_CONTROL;
+	control.value = value;
+	control.request = request;
+
+	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+			USB_REQ_SET_CONFIGURATION,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			PYRA_USB_COMMAND_CONTROL, 0, (char *)&control,
+			sizeof(struct pyra_control),
+			USB_CTRL_SET_TIMEOUT);
+
+	if (len != sizeof(struct pyra_control))
+		return len;
+
+	return 0;
+}
+
+static int pyra_receive_control_status(struct usb_device *usb_dev)
+{
+	int len;
+	struct pyra_control control;
+
+	do {
+		msleep(10);
+
+		len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+				USB_REQ_CLEAR_FEATURE,
+				USB_TYPE_CLASS | USB_RECIP_INTERFACE |
+				USB_DIR_IN,
+				PYRA_USB_COMMAND_CONTROL, 0, (char *)&control,
+				sizeof(struct pyra_control),
+				USB_CTRL_SET_TIMEOUT);
+
+		/* requested too early, try again */
+	} while (len == -EPROTO);
+
+	if (len == sizeof(struct pyra_control) &&
+			control.command == PYRA_COMMAND_CONTROL &&
+			control.request == PYRA_CONTROL_REQUEST_STATUS &&
+			control.value == 1)
+			return 0;
+	else {
+		dev_err(&usb_dev->dev, "receive control status: "
+				"unknown response 0x%x 0x%x\n",
+				control.request, control.value);
+		return -EINVAL;
+	}
+}
+
+static int pyra_get_profile_settings(struct usb_device *usb_dev,
+		struct pyra_profile_settings *buf, int number)
+{
+	int retval;
+
+	retval = pyra_send_control(usb_dev, number,
+			PYRA_CONTROL_REQUEST_PROFILE_SETTINGS);
+
+	if (retval)
+		return retval;
+
+	retval = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			USB_REQ_CLEAR_FEATURE,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
+			PYRA_USB_COMMAND_PROFILE_SETTINGS, 0, (char *)buf,
+			sizeof(struct pyra_profile_settings),
+			USB_CTRL_SET_TIMEOUT);
+
+	if (retval != sizeof(struct pyra_profile_settings))
+		return retval;
+
+	return 0;
+}
+
+static int pyra_get_profile_buttons(struct usb_device *usb_dev,
+		struct pyra_profile_buttons *buf, int number)
+{
+	int retval;
+
+	retval = pyra_send_control(usb_dev, number,
+			PYRA_CONTROL_REQUEST_PROFILE_BUTTONS);
+
+	if (retval)
+		return retval;
+
+	retval = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			USB_REQ_CLEAR_FEATURE,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
+			PYRA_USB_COMMAND_PROFILE_BUTTONS, 0, (char *)buf,
+			sizeof(struct pyra_profile_buttons),
+			USB_CTRL_SET_TIMEOUT);
+
+	if (retval != sizeof(struct pyra_profile_buttons))
+		return retval;
+
+	return 0;
+}
+
+static int pyra_get_settings(struct usb_device *usb_dev,
+		struct pyra_settings *buf)
+{
+	int len;
+	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			USB_REQ_CLEAR_FEATURE,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
+			PYRA_USB_COMMAND_SETTINGS, 0, buf,
+			sizeof(struct pyra_settings), USB_CTRL_SET_TIMEOUT);
+	if (len != sizeof(struct pyra_settings))
+		return -EIO;
+	return 0;
+}
+
+static int pyra_get_info(struct usb_device *usb_dev, struct pyra_info *buf)
+{
+	int len;
+	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			USB_REQ_CLEAR_FEATURE,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
+			PYRA_USB_COMMAND_INFO, 0, buf,
+			sizeof(struct pyra_info), USB_CTRL_SET_TIMEOUT);
+	if (len != sizeof(struct pyra_info))
+		return -EIO;
+	return 0;
+}
+
+static int pyra_set_profile_settings(struct usb_device *usb_dev,
+		struct pyra_profile_settings const *settings)
+{
+	int len;
+	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+			USB_REQ_SET_CONFIGURATION,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			PYRA_USB_COMMAND_PROFILE_SETTINGS, 0, (char *)settings,
+			sizeof(struct pyra_profile_settings),
+			USB_CTRL_SET_TIMEOUT);
+	if (len != sizeof(struct pyra_profile_settings))
+		return -EIO;
+	if (pyra_receive_control_status(usb_dev))
+		return -EIO;
+	return 0;
+}
+
+static int pyra_set_profile_buttons(struct usb_device *usb_dev,
+		struct pyra_profile_buttons const *buttons)
+{
+	int len;
+	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+			USB_REQ_SET_CONFIGURATION,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			PYRA_USB_COMMAND_PROFILE_BUTTONS, 0, (char *)buttons,
+			sizeof(struct pyra_profile_buttons),
+			USB_CTRL_SET_TIMEOUT);
+	if (len != sizeof(struct pyra_profile_buttons))
+		return -EIO;
+	if (pyra_receive_control_status(usb_dev))
+		return -EIO;
+	return 0;
+}
+
+static int pyra_set_settings(struct usb_device *usb_dev,
+		struct pyra_settings const *settings)
+{
+	int len;
+	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+			USB_REQ_SET_CONFIGURATION,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			PYRA_USB_COMMAND_SETTINGS, 0, (char *)settings,
+			sizeof(struct pyra_settings), USB_CTRL_SET_TIMEOUT);
+	if (len != sizeof(struct pyra_settings))
+		return -EIO;
+	if (pyra_receive_control_status(usb_dev))
+		return -EIO;
+	return 0;
+}
+
+static ssize_t pyra_sysfs_read_profilex_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count, int number)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
+
+	if (off >= sizeof(struct pyra_profile_settings))
+		return 0;
+
+	if (off + count > sizeof(struct pyra_profile_settings))
+		count = sizeof(struct pyra_profile_settings) - off;
+
+	mutex_lock(&pyra->pyra_lock);
+	memcpy(buf, ((char const *)&pyra->profile_settings[number]) + off,
+			count);
+	mutex_unlock(&pyra->pyra_lock);
+
+	return count;
+}
+
+static ssize_t pyra_sysfs_read_profile1_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return pyra_sysfs_read_profilex_settings(fp, kobj,
+			attr, buf, off, count, 0);
+}
+
+static ssize_t pyra_sysfs_read_profile2_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return pyra_sysfs_read_profilex_settings(fp, kobj,
+			attr, buf, off, count, 1);
+}
+
+static ssize_t pyra_sysfs_read_profile3_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return pyra_sysfs_read_profilex_settings(fp, kobj,
+			attr, buf, off, count, 2);
+}
+
+static ssize_t pyra_sysfs_read_profile4_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return pyra_sysfs_read_profilex_settings(fp, kobj,
+			attr, buf, off, count, 3);
+}
+
+static ssize_t pyra_sysfs_read_profile5_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return pyra_sysfs_read_profilex_settings(fp, kobj,
+			attr, buf, off, count, 4);
+}
+
+static ssize_t pyra_sysfs_read_profilex_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count, int number)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
+
+	if (off >= sizeof(struct pyra_profile_buttons))
+		return 0;
+
+	if (off + count > sizeof(struct pyra_profile_buttons))
+		count = sizeof(struct pyra_profile_buttons) - off;
+
+	mutex_lock(&pyra->pyra_lock);
+	memcpy(buf, ((char const *)&pyra->profile_buttons[number]) + off,
+			count);
+	mutex_unlock(&pyra->pyra_lock);
+
+	return count;
+}
+
+static ssize_t pyra_sysfs_read_profile1_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return pyra_sysfs_read_profilex_buttons(fp, kobj,
+			attr, buf, off, count, 0);
+}
+
+static ssize_t pyra_sysfs_read_profile2_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return pyra_sysfs_read_profilex_buttons(fp, kobj,
+			attr, buf, off, count, 1);
+}
+
+static ssize_t pyra_sysfs_read_profile3_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return pyra_sysfs_read_profilex_buttons(fp, kobj,
+			attr, buf, off, count, 2);
+}
+
+static ssize_t pyra_sysfs_read_profile4_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return pyra_sysfs_read_profilex_buttons(fp, kobj,
+			attr, buf, off, count, 3);
+}
+
+static ssize_t pyra_sysfs_read_profile5_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return pyra_sysfs_read_profilex_buttons(fp, kobj,
+			attr, buf, off, count, 4);
+}
+
+static ssize_t pyra_sysfs_write_profile_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval = 0;
+	int difference;
+	int profile_number;
+	struct pyra_profile_settings *profile_settings;
+
+	if (off != 0 || count != sizeof(struct pyra_profile_settings))
+		return -EINVAL;
+
+	profile_number = ((struct pyra_profile_settings const *)buf)->number;
+	profile_settings = &pyra->profile_settings[profile_number];
+
+	mutex_lock(&pyra->pyra_lock);
+	difference = memcmp(buf, profile_settings,
+			sizeof(struct pyra_profile_settings));
+	if (difference) {
+		retval = pyra_set_profile_settings(usb_dev,
+				(struct pyra_profile_settings const *)buf);
+		if (!retval)
+			memcpy(profile_settings, buf,
+					sizeof(struct pyra_profile_settings));
+	}
+	mutex_unlock(&pyra->pyra_lock);
+
+	if (retval)
+		return retval;
+
+	return sizeof(struct pyra_profile_settings);
+}
+
+static ssize_t pyra_sysfs_write_profile_buttons(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval = 0;
+	int difference;
+	int profile_number;
+	struct pyra_profile_buttons *profile_buttons;
+
+	if (off != 0 || count != sizeof(struct pyra_profile_buttons))
+		return -EINVAL;
+
+	profile_number = ((struct pyra_profile_buttons const *)buf)->number;
+	profile_buttons = &pyra->profile_buttons[profile_number];
+
+	mutex_lock(&pyra->pyra_lock);
+	difference = memcmp(buf, profile_buttons,
+			sizeof(struct pyra_profile_buttons));
+	if (difference) {
+		retval = pyra_set_profile_buttons(usb_dev,
+				(struct pyra_profile_buttons const *)buf);
+		if (!retval)
+			memcpy(profile_buttons, buf,
+					sizeof(struct pyra_profile_buttons));
+	}
+	mutex_unlock(&pyra->pyra_lock);
+
+	if (retval)
+		return retval;
+
+	return sizeof(struct pyra_profile_buttons);
+}
+
+static ssize_t pyra_sysfs_read_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
+
+	if (off >= sizeof(struct pyra_settings))
+		return 0;
+
+	if (off + count > sizeof(struct pyra_settings))
+		count = sizeof(struct pyra_settings) - off;
+
+	mutex_lock(&pyra->pyra_lock);
+	memcpy(buf, ((char const *)&pyra->settings) + off, count);
+	mutex_unlock(&pyra->pyra_lock);
+
+	return count;
+}
+
+static ssize_t pyra_sysfs_write_settings(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval = 0;
+	int difference;
+
+	if (off != 0 || count != sizeof(struct pyra_settings))
+		return -EINVAL;
+
+	mutex_lock(&pyra->pyra_lock);
+	difference = memcmp(buf, &pyra->settings, sizeof(struct pyra_settings));
+	if (difference) {
+		retval = pyra_set_settings(usb_dev,
+				(struct pyra_settings const *)buf);
+		if (!retval)
+			memcpy(&pyra->settings, buf,
+					sizeof(struct pyra_settings));
+	}
+	mutex_unlock(&pyra->pyra_lock);
+
+	if (retval)
+		return retval;
+
+	profile_activated(pyra, pyra->settings.startup_profile);
+
+	return sizeof(struct pyra_settings);
+}
+
+
+static ssize_t pyra_sysfs_show_actual_cpi(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
+	return snprintf(buf, PAGE_SIZE, "%d\n", pyra->actual_cpi);
+}
+
+static ssize_t pyra_sysfs_show_actual_profile(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
+	return snprintf(buf, PAGE_SIZE, "%d\n", pyra->actual_profile);
+}
+
+static ssize_t pyra_sysfs_show_firmware_version(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
+	return snprintf(buf, PAGE_SIZE, "%d\n", pyra->firmware_version);
+}
+
+static ssize_t pyra_sysfs_show_startup_profile(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
+	return snprintf(buf, PAGE_SIZE, "%d\n", pyra->settings.startup_profile);
+}
+
+static DEVICE_ATTR(actual_cpi, 0440, pyra_sysfs_show_actual_cpi, NULL);
+
+static DEVICE_ATTR(actual_profile, 0440, pyra_sysfs_show_actual_profile, NULL);
+
+static DEVICE_ATTR(firmware_version, 0440,
+		pyra_sysfs_show_firmware_version, NULL);
+
+static DEVICE_ATTR(startup_profile, 0440,
+		pyra_sysfs_show_startup_profile, NULL);
+
+static struct attribute *pyra_attributes[] = {
+		&dev_attr_actual_cpi.attr,
+		&dev_attr_actual_profile.attr,
+		&dev_attr_firmware_version.attr,
+		&dev_attr_startup_profile.attr,
+		NULL
+};
+
+static struct attribute_group pyra_attribute_group = {
+		.attrs = pyra_attributes
+};
+
+static struct bin_attribute pyra_profile_settings_attr = {
+		.attr = { .name = "profile_settings", .mode = 0220 },
+		.size = sizeof(struct pyra_profile_settings),
+		.write = pyra_sysfs_write_profile_settings
+};
+
+static struct bin_attribute pyra_profile1_settings_attr = {
+		.attr = { .name = "profile1_settings", .mode = 0440 },
+		.size = sizeof(struct pyra_profile_settings),
+		.read = pyra_sysfs_read_profile1_settings
+};
+
+static struct bin_attribute pyra_profile2_settings_attr = {
+		.attr = { .name = "profile2_settings", .mode = 0440 },
+		.size = sizeof(struct pyra_profile_settings),
+		.read = pyra_sysfs_read_profile2_settings
+};
+
+static struct bin_attribute pyra_profile3_settings_attr = {
+		.attr = { .name = "profile3_settings", .mode = 0440 },
+		.size = sizeof(struct pyra_profile_settings),
+		.read = pyra_sysfs_read_profile3_settings
+};
+
+static struct bin_attribute pyra_profile4_settings_attr = {
+		.attr = { .name = "profile4_settings", .mode = 0440 },
+		.size = sizeof(struct pyra_profile_settings),
+		.read = pyra_sysfs_read_profile4_settings
+};
+
+static struct bin_attribute pyra_profile5_settings_attr = {
+		.attr = { .name = "profile5_settings", .mode = 0440 },
+		.size = sizeof(struct pyra_profile_settings),
+		.read = pyra_sysfs_read_profile5_settings
+};
+
+static struct bin_attribute pyra_profile_buttons_attr = {
+		.attr = { .name = "profile_buttons", .mode = 0220 },
+		.size = sizeof(struct pyra_profile_buttons),
+		.write = pyra_sysfs_write_profile_buttons
+};
+
+static struct bin_attribute pyra_profile1_buttons_attr = {
+		.attr = { .name = "profile1_buttons", .mode = 0440 },
+		.size = sizeof(struct pyra_profile_buttons),
+		.read = pyra_sysfs_read_profile1_buttons
+};
+
+static struct bin_attribute pyra_profile2_buttons_attr = {
+		.attr = { .name = "profile2_buttons", .mode = 0440 },
+		.size = sizeof(struct pyra_profile_buttons),
+		.read = pyra_sysfs_read_profile2_buttons
+};
+
+static struct bin_attribute pyra_profile3_buttons_attr = {
+		.attr = { .name = "profile3_buttons", .mode = 0440 },
+		.size = sizeof(struct pyra_profile_buttons),
+		.read = pyra_sysfs_read_profile3_buttons
+};
+
+static struct bin_attribute pyra_profile4_buttons_attr = {
+		.attr = { .name = "profile4_buttons", .mode = 0440 },
+		.size = sizeof(struct pyra_profile_buttons),
+		.read = pyra_sysfs_read_profile4_buttons
+};
+
+static struct bin_attribute pyra_profile5_buttons_attr = {
+		.attr = { .name = "profile5_buttons", .mode = 0440 },
+		.size = sizeof(struct pyra_profile_buttons),
+		.read = pyra_sysfs_read_profile5_buttons
+};
+
+static struct bin_attribute pyra_settings_attr = {
+		.attr = { .name = "settings", .mode = 0660 },
+		.size = sizeof(struct pyra_settings),
+		.read = pyra_sysfs_read_settings,
+		.write = pyra_sysfs_write_settings
+};
+
+static int pyra_create_sysfs_attributes(struct usb_interface *intf)
+{
+	int retval;
+
+	retval = sysfs_create_group(&intf->dev.kobj, &pyra_attribute_group);
+	if (retval)
+		goto exit_1;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&pyra_profile_settings_attr);
+	if (retval)
+		goto exit_2;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&pyra_profile1_settings_attr);
+	if (retval)
+		goto exit_3;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&pyra_profile2_settings_attr);
+	if (retval)
+		goto exit_4;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&pyra_profile3_settings_attr);
+	if (retval)
+		goto exit_5;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&pyra_profile4_settings_attr);
+	if (retval)
+		goto exit_6;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&pyra_profile5_settings_attr);
+	if (retval)
+		goto exit_7;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&pyra_profile_buttons_attr);
+	if (retval)
+		goto exit_8;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&pyra_profile1_buttons_attr);
+	if (retval)
+		goto exit_9;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&pyra_profile2_buttons_attr);
+	if (retval)
+		goto exit_10;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&pyra_profile3_buttons_attr);
+	if (retval)
+		goto exit_11;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&pyra_profile4_buttons_attr);
+	if (retval)
+		goto exit_12;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&pyra_profile5_buttons_attr);
+	if (retval)
+		goto exit_13;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj,
+			&pyra_settings_attr);
+	if (retval)
+		goto exit_14;
+
+	return 0;
+
+exit_14:
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile5_buttons_attr);
+exit_13:
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile4_buttons_attr);
+exit_12:
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile3_buttons_attr);
+exit_11:
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile2_buttons_attr);
+exit_10:
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile1_buttons_attr);
+exit_9:
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile_buttons_attr);
+exit_8:
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile5_settings_attr);
+exit_7:
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile4_settings_attr);
+exit_6:
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile3_settings_attr);
+exit_5:
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile2_settings_attr);
+exit_4:
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile1_settings_attr);
+exit_3:
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile_settings_attr);
+exit_2:
+	sysfs_remove_group(&intf->dev.kobj, &pyra_attribute_group);
+exit_1:
+	return retval;
+}
+
+static void pyra_remove_sysfs_attributes(struct usb_interface *intf)
+{
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_settings_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile5_buttons_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile4_buttons_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile3_buttons_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile2_buttons_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile1_buttons_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile_buttons_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile5_settings_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile4_settings_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile3_settings_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile2_settings_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile1_settings_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &pyra_profile_settings_attr);
+	sysfs_remove_group(&intf->dev.kobj, &pyra_attribute_group);
+}
+
+static int pyra_init_pyra_device_struct(struct usb_device *usb_dev,
+		struct pyra_device *pyra)
+{
+	struct pyra_info *info;
+	int retval, i;
+
+	mutex_init(&pyra->pyra_lock);
+
+	info = kmalloc(sizeof(struct pyra_info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+	retval = pyra_get_info(usb_dev, info);
+	if (retval) {
+		kfree(info);
+		return retval;
+	}
+	pyra->firmware_version = info->firmware_version;
+	kfree(info);
+
+	retval = pyra_get_settings(usb_dev, &pyra->settings);
+	if (retval)
+		return retval;
+
+	for (i = 0; i < 5; ++i) {
+		retval = pyra_get_profile_settings(usb_dev,
+				&pyra->profile_settings[i], i);
+		if (retval)
+			return retval;
+
+		retval = pyra_get_profile_buttons(usb_dev,
+				&pyra->profile_buttons[i], i);
+		if (retval)
+			return retval;
+	}
+
+	profile_activated(pyra, pyra->settings.startup_profile);
+
+	return 0;
+}
+
+static int pyra_init_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct pyra_device *pyra;
+	int retval;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			== USB_INTERFACE_PROTOCOL_MOUSE) {
+
+		pyra = kzalloc(sizeof(*pyra), GFP_KERNEL);
+		if (!pyra) {
+			dev_err(&hdev->dev, "can't alloc device descriptor\n");
+			return -ENOMEM;
+		}
+		hid_set_drvdata(hdev, pyra);
+
+		retval = pyra_init_pyra_device_struct(usb_dev, pyra);
+		if (retval) {
+			dev_err(&hdev->dev,
+					"couldn't init struct pyra_device\n");
+			goto exit_free;
+		}
+
+		retval = roccat_connect(hdev);
+		if (retval < 0) {
+			dev_err(&hdev->dev, "couldn't init char dev\n");
+		} else {
+			pyra->chrdev_minor = retval;
+			pyra->roccat_claimed = 1;
+		}
+
+		retval = pyra_create_sysfs_attributes(intf);
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
+	kfree(pyra);
+	return retval;
+}
+
+static void pyra_remove_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct pyra_device *pyra;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			== USB_INTERFACE_PROTOCOL_MOUSE) {
+		pyra_remove_sysfs_attributes(intf);
+		pyra = hid_get_drvdata(hdev);
+		if (pyra->roccat_claimed)
+			roccat_disconnect(pyra->chrdev_minor);
+		kfree(hid_get_drvdata(hdev));
+	}
+}
+
+static int pyra_probe(struct hid_device *hdev, const struct hid_device_id *id)
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
+	retval = pyra_init_specials(hdev);
+	if (retval) {
+		dev_err(&hdev->dev, "couldn't install mouse\n");
+		goto exit_stop;
+	}
+	return 0;
+
+exit_stop:
+	hid_hw_stop(hdev);
+exit:
+	return retval;
+}
+
+static void pyra_remove(struct hid_device *hdev)
+{
+	pyra_remove_specials(hdev);
+	hid_hw_stop(hdev);
+}
+
+static void pyra_keep_values_up_to_date(struct pyra_device *pyra,
+		u8 const *data)
+{
+	struct pyra_mouse_event_button const *button_event;
+
+	switch (data[0]) {
+	case PYRA_MOUSE_REPORT_NUMBER_BUTTON:
+		button_event = (struct pyra_mouse_event_button const *)data;
+		switch (button_event->type) {
+		case PYRA_MOUSE_EVENT_BUTTON_TYPE_PROFILE_2:
+			profile_activated(pyra, button_event->data1 - 1);
+			break;
+		case PYRA_MOUSE_EVENT_BUTTON_TYPE_CPI:
+			pyra->actual_cpi = button_event->data1;
+			break;
+		}
+		break;
+	}
+}
+
+static void pyra_report_to_chrdev(struct pyra_device const *pyra,
+		u8 const *data)
+{
+	struct pyra_roccat_report roccat_report;
+	struct pyra_mouse_event_button const *button_event;
+
+	if (data[0] != PYRA_MOUSE_REPORT_NUMBER_BUTTON)
+		return;
+
+	button_event = (struct pyra_mouse_event_button const *)data;
+
+	switch (button_event->type) {
+	case PYRA_MOUSE_EVENT_BUTTON_TYPE_PROFILE_2:
+	case PYRA_MOUSE_EVENT_BUTTON_TYPE_CPI:
+		roccat_report.type = button_event->type;
+		roccat_report.value = button_event->data1;
+		roccat_report.key = 0;
+		roccat_report_event(pyra->chrdev_minor,
+				(uint8_t const *)&roccat_report,
+				sizeof(struct pyra_roccat_report));
+		break;
+	case PYRA_MOUSE_EVENT_BUTTON_TYPE_MACRO:
+	case PYRA_MOUSE_EVENT_BUTTON_TYPE_SHORTCUT:
+	case PYRA_MOUSE_EVENT_BUTTON_TYPE_QUICKLAUNCH:
+		if (button_event->data2 == PYRA_MOUSE_EVENT_BUTTON_PRESS) {
+			roccat_report.type = button_event->type;
+			roccat_report.key = button_event->data1;
+			roccat_report.value = pyra->actual_profile;
+			roccat_report_event(pyra->chrdev_minor,
+					(uint8_t const *)&roccat_report,
+					sizeof(struct pyra_roccat_report));
+		}
+		break;
+	}
+}
+
+static int pyra_raw_event(struct hid_device *hdev, struct hid_report *report,
+		u8 *data, int size)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct pyra_device *pyra = hid_get_drvdata(hdev);
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			!= USB_INTERFACE_PROTOCOL_MOUSE)
+		return 0;
+
+	pyra_keep_values_up_to_date(pyra, data);
+
+	if (pyra->roccat_claimed)
+		pyra_report_to_chrdev(pyra, data);
+
+	return 0;
+}
+
+static const struct hid_device_id pyra_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT,
+			USB_DEVICE_ID_ROCCAT_PYRA_WIRED) },
+	/* TODO add USB_DEVICE_ID_ROCCAT_PYRA_WIRELESS after testing */
+	{ }
+};
+
+MODULE_DEVICE_TABLE(hid, pyra_devices);
+
+static struct hid_driver pyra_driver = {
+		.name = "pyra",
+		.id_table = pyra_devices,
+		.probe = pyra_probe,
+		.remove = pyra_remove,
+		.raw_event = pyra_raw_event
+};
+
+static int __init pyra_init(void)
+{
+	return hid_register_driver(&pyra_driver);
+}
+
+static void __exit pyra_exit(void)
+{
+	hid_unregister_driver(&pyra_driver);
+}
+
+module_init(pyra_init);
+module_exit(pyra_exit);
+
+MODULE_AUTHOR("Stefan Achatz");
+MODULE_DESCRIPTION("USB Roccat Pyra driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-roccat-pyra.h b/drivers/hid/hid-roccat-pyra.h
new file mode 100644
index 0000000..22f80a8
--- /dev/null
+++ b/drivers/hid/hid-roccat-pyra.h
@@ -0,0 +1,186 @@
+#ifndef __HID_ROCCAT_PYRA_H
+#define __HID_ROCCAT_PYRA_H
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
+struct pyra_b {
+	uint8_t command; /* PYRA_COMMAND_B */
+	uint8_t size; /* always 3 */
+	uint8_t unknown; /* 1 */
+};
+
+struct pyra_control {
+	uint8_t command; /* PYRA_COMMAND_CONTROL */
+	/*
+	 * value is profile number for request_settings and request_buttons
+	 * 1 if status ok for request_status
+	 */
+	uint8_t value; /* Range 0-4 */
+	uint8_t request;
+};
+
+enum pyra_control_requests {
+	PYRA_CONTROL_REQUEST_STATUS = 0x00,
+	PYRA_CONTROL_REQUEST_PROFILE_SETTINGS = 0x10,
+	PYRA_CONTROL_REQUEST_PROFILE_BUTTONS = 0x20
+};
+
+struct pyra_settings {
+	uint8_t command; /* PYRA_COMMAND_SETTINGS */
+	uint8_t size; /* always 3 */
+	uint8_t startup_profile; /* Range 0-4! */
+};
+
+struct pyra_profile_settings {
+	uint8_t command; /* PYRA_COMMAND_PROFILE_SETTINGS */
+	uint8_t size; /* always 0xd */
+	uint8_t number; /* Range 0-4 */
+	uint8_t xysync;
+	uint8_t x_sensitivity; /* 0x1-0xa */
+	uint8_t y_sensitivity;
+	uint8_t x_cpi; /* unused */
+	uint8_t y_cpi; /* this value is for x and y */
+	uint8_t lightswitch; /* 0 = off, 1 = on */
+	uint8_t light_effect;
+	uint8_t handedness;
+	uint16_t checksum; /* byte sum */
+};
+
+struct pyra_profile_buttons {
+	uint8_t command; /* PYRA_COMMAND_PROFILE_BUTTONS */
+	uint8_t size; /* always 0x13 */
+	uint8_t number; /* Range 0-4 */
+	uint8_t buttons[14];
+	uint16_t checksum; /* byte sum */
+};
+
+struct pyra_info {
+	uint8_t command; /* PYRA_COMMAND_INFO */
+	uint8_t size; /* always 6 */
+	uint8_t firmware_version;
+	uint8_t unknown1; /* always 0 */
+	uint8_t unknown2; /* always 1 */
+	uint8_t unknown3; /* always 0 */
+};
+
+enum pyra_commands {
+	PYRA_COMMAND_CONTROL = 0x4,
+	PYRA_COMMAND_SETTINGS = 0x5,
+	PYRA_COMMAND_PROFILE_SETTINGS = 0x6,
+	PYRA_COMMAND_PROFILE_BUTTONS = 0x7,
+	PYRA_COMMAND_INFO = 0x9,
+	PYRA_COMMAND_B = 0xb
+};
+
+enum pyra_usb_commands {
+	PYRA_USB_COMMAND_CONTROL = 0x304,
+	PYRA_USB_COMMAND_SETTINGS = 0x305,
+	PYRA_USB_COMMAND_PROFILE_SETTINGS = 0x306,
+	PYRA_USB_COMMAND_PROFILE_BUTTONS = 0x307,
+	PYRA_USB_COMMAND_INFO = 0x309,
+	PYRA_USB_COMMAND_B = 0x30b /* writes 3 bytes */
+};
+
+enum pyra_mouse_report_numbers {
+	PYRA_MOUSE_REPORT_NUMBER_HID = 1,
+	PYRA_MOUSE_REPORT_NUMBER_AUDIO = 2,
+	PYRA_MOUSE_REPORT_NUMBER_BUTTON = 3,
+};
+
+struct pyra_mouse_event_button {
+	uint8_t report_number; /* always 3 */
+	uint8_t unknown; /* always 0 */
+	uint8_t type;
+	uint8_t data1;
+	uint8_t data2;
+};
+
+struct pyra_mouse_event_audio {
+	uint8_t report_number; /* always 2 */
+	uint8_t type;
+	uint8_t unused; /* always 0 */
+};
+
+/* hid audio controls */
+enum pyra_mouse_event_audio_types {
+	PYRA_MOUSE_EVENT_AUDIO_TYPE_MUTE = 0xe2,
+	PYRA_MOUSE_EVENT_AUDIO_TYPE_VOLUME_UP = 0xe9,
+	PYRA_MOUSE_EVENT_AUDIO_TYPE_VOLUME_DOWN = 0xea,
+};
+
+enum pyra_mouse_event_button_types {
+	/*
+	 * Mouse sends tilt events on report_number 1 and 3
+	 * Tilt events are sent repeatedly with 0.94s between first and second
+	 * event and 0.22s on subsequent
+	 */
+	PYRA_MOUSE_EVENT_BUTTON_TYPE_TILT = 0x10,
+
+	/*
+	 * These are sent sequentially
+	 * data1 contains new profile number in range 1-5
+	 */
+	PYRA_MOUSE_EVENT_BUTTON_TYPE_PROFILE_1 = 0x20,
+	PYRA_MOUSE_EVENT_BUTTON_TYPE_PROFILE_2 = 0x30,
+
+	/*
+	 * data1 = button_number (rmp index)
+	 * data2 = pressed/released
+	 */
+	PYRA_MOUSE_EVENT_BUTTON_TYPE_MACRO = 0x40,
+	PYRA_MOUSE_EVENT_BUTTON_TYPE_SHORTCUT = 0x50,
+
+	/*
+	 * data1 = button_number (rmp index)
+	 */
+	PYRA_MOUSE_EVENT_BUTTON_TYPE_QUICKLAUNCH = 0x60,
+
+	/* data1 = new cpi */
+	PYRA_MOUSE_EVENT_BUTTON_TYPE_CPI = 0xb0,
+
+	/* data1 and data2 = new sensitivity */
+	PYRA_MOUSE_EVENT_BUTTON_TYPE_SENSITIVITY = 0xc0,
+
+	PYRA_MOUSE_EVENT_BUTTON_TYPE_MULTIMEDIA = 0xf0,
+};
+
+enum {
+	PYRA_MOUSE_EVENT_BUTTON_PRESS = 0,
+	PYRA_MOUSE_EVENT_BUTTON_RELEASE = 1,
+};
+
+struct pyra_roccat_report {
+	uint8_t type;
+	uint8_t value;
+	uint8_t key;
+};
+
+#pragma pack(pop)
+
+struct pyra_device {
+	int actual_profile;
+	int actual_cpi;
+	int firmware_version;
+	int roccat_claimed;
+	int chrdev_minor;
+	struct mutex pyra_lock;
+	struct pyra_settings settings;
+	struct pyra_profile_settings profile_settings[5];
+	struct pyra_profile_buttons profile_buttons[5];
+};
+
+#endif
-- 
1.7.2.2



