Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab0CRPnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:43:11 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:34347 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab0CRPnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:43:07 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net B6BF8333580
Subject: [PATCH] HID: add driver for Roccat Kone gaming mouse 2nd Attempt
From: Stefan Achatz <erazor_de@users.sourceforge.net>
To: Randy Dunlap <rdunlap@xenotime.net>,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Michael Poole <mdpoole@troilus.org>, simon.windows@gmail.com,
       Sean Hildebrand <silverwraithii@gmail.com>,
       Sid Boyce <sboyce@blueyonder.co.uk>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 16:43:01 +0100
Message-ID: <1268926981.11269.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This Patch adds support for Kone gaming mouse from Roccat.
It provides access to profiles, settings, firmware, weight,
actual settings etc. through sysfs attributes.
Event handling of this mouse differs from standard hid behaviour
in that tilt button press is reported in each move event which
results in strange behaviour if not handled by the driver.

This is a heavily reworked version of the previously introduced driver.
The changes include most of the previously raised concerns,
memory leak and other fixes, code cleanups, adoption of additional
achieved knowlege about the hardware and is (IMHO) a much better version
than before even when I exchanged reduced USB-IO with a bigger memory
consumption.

I refused to implement one mentioned point:
Removing the 'just-because-we-can' attributes. Motivation:
Reading the clipped in weight: I'm no gamer and can't determine the
usefulness of this feature but if the manufacturer implements such a
feature it might make sense to someone and I would unwillingly limit the
functionality besides its such a small feature.
Reading the actual profile and dpi settings: Here I can testify that one
can get lost of the actual settings when switching back and forth.
The manufacturers windows driver has the ability for on-screen-display
of the values and there is a mouse in the market that has an lcd on the
underside of it to show these values. So I think this feature makes sense
not only for me and shouldn't be removed.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-kone       |  111 +++
 drivers/hid/Kconfig                                |    7 +
 drivers/hid/Makefile                               |    1 +
 drivers/hid/hid-ids.h                              |    3 +
 drivers/hid/hid-roccat-kone.c                      | 1001 ++++++++++++++++++++
 drivers/hid/hid-roccat-kone.h                      |  214 +++++
 6 files changed, 1337 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
 create mode 100644 drivers/hid/hid-roccat-kone.c
 create mode 100644 drivers/hid/hid-roccat-kone.h

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
new file mode 100644
index 0000000..88340a2
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
@@ -0,0 +1,111 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/actual_dpi
+Date:		March 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	It is possible to switch the dpi setting of the mouse with the
+		press of a button.
+		When read, this file returns the raw number of the actual dpi
+		setting reported by the mouse. This number has to be further
+		processed to receive the real dpi value.
+
+		VALUE DPI
+		1     800
+		2     1200
+		3     1600
+		4     2000
+		5     2400
+		6     3200
+
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/actual_profile
+Date:		March 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the number of the actual profile.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/firmware_version
+Date:		March 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the raw integer version number of the
+		firmware reported by the mouse. Using the integer value eases
+		further usage in other programs. To receive the real version
+		number the decimal point has to be shifted 2 positions to the
+		left. E.g. a returned value of 138 means 1.38
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/kone_driver_version
+Date:		March 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the driver version.
+		The format of the string is "v<major>.<minor>.<patchlevel>".
+		This attribute is used by the userland tools to find the sysfs-
+		paths of installed kone-mice and determine the capabilites of
+		the driver. Versions of this driver for old kernels replace
+		usbhid instead of generic-usb. The way to scan for this file
+		has been chosen to provide a consistent way for all supported
+		kernel versions.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile[1-5]
+Date:		March 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can store 5 profiles which can be switched by the
+                press of a button. A profile holds informations like button
+                mappings, sensitivity, the colors of the 5 leds and light
+                effects.
+                When read, these files return the respective profile. The
+                returned data is 975 bytes in size.
+		When written, this file lets one write the respective profile
+		data back to the mouse. The data has to be 975 bytes long.
+		The mouse will reject invalid data, whereas the profile number
+		stored in the profile doesn't need to fit the number of the
+		store.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/settings
+Date:		March 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the settings stored in the mouse.
+		The size of the data is 36 bytes and holds information like the
+		startup_profile, tcu state and calibration_data.
+		When written, this file lets write settings back to the mouse.
+		The data has to be 36 bytes long. The mouse will reject invalid
+		data.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/startup_profile
+Date:		March 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 1 to 5.
+                When read, this attribute returns the number of the profile
+                that's active when the mouse is powered on.
+		When written, this file sets the number of the startup profile
+		and the mouse activates this profile immediately.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/tcu
+Date:		March 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse has a "Tracking Control Unit" which lets the user
+		calibrate the laser power to fit the mousepad surface.
+		When read, this file returns the current state of the TCU,
+		where 0 means off and 1 means on.
+		Writing 0 in this file will switch the TCU off.
+		Writing 1 in this file will start the calibration which takes
+		around 6 seconds to complete and activates the TCU.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/weight
+Date:		March 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The mouse can be equipped with one of four supplied weights
+		ranging from 5 to 20 grams which are recognized by the mouse
+		and its value can be read out. When read, this file returns the
+		raw value returned by the mouse which eases further processing
+		in other software.
+		The values map to the weights as follows:
+
+		VALUE WEIGHT
+		0     none
+		1     5g
+		2     10g
+		3     15g
+		4     20g
+
+		This file is readonly.
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 71d4c07..d819b02 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -268,6 +268,13 @@ config HID_QUANTA
 	---help---
 	Support for Quanta Optical Touch dual-touch panels.
 
+config HID_ROCCAT_KONE
+	tristate "Roccat Kone" if EMBEDDED
+	depends on USB_HID
+	default !EMBEDDED
+	---help---
+	Support for Roccat Kone mouse.
+
 config HID_SAMSUNG
 	tristate "Samsung" if EMBEDDED
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 0b2618f..08b83cc 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_HID_ORTEK)		+= hid-ortek.o
 obj-$(CONFIG_HID_QUANTA)	+= hid-quanta.o
 obj-$(CONFIG_HID_PANTHERLORD)	+= hid-pl.o
 obj-$(CONFIG_HID_PETALYNX)	+= hid-petalynx.o
+obj-$(CONFIG_HID_ROCCAT_KONE)	+= hid-roccat-kone.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SMARTJOYPLUS)	+= hid-sjoy.o
 obj-$(CONFIG_HID_SONY)		+= hid-sony.o
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 72c05f9..237c583 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -399,6 +399,9 @@
 #define USB_VENDOR_ID_PRODIGE		0x05af
 #define USB_DEVICE_ID_PRODIGE_CORDLESS	0x3062
 
+#define USB_VENDOR_ID_ROCCAT		0x1e7d
+#define USB_DEVICE_ID_ROCCAT_KONE	0x2ced
+
 #define USB_VENDOR_ID_SAITEK		0x06a3
 #define USB_DEVICE_ID_SAITEK_RUMBLEPAD	0xff17
 
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
new file mode 100644
index 0000000..1a5e993
--- /dev/null
+++ b/drivers/hid/hid-roccat-kone.c
@@ -0,0 +1,1001 @@
+/*
+ * Roccat Kone driver for Linux
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
+ * Roccat Kone is a gamer mouse which consists of a mouse part and a keyboard
+ * part. The keyboard part enables the mouse to execute stored macros with mixed
+ * key- and button-events.
+ *
+ * TODO implement on-the-fly polling-rate change
+ *      The windows driver has the ability to change the polling rate of the
+ *      device on the press of a mousebutton.
+ *      Is it possible to remove and reinstall the urb in raw-event- or any
+ *      other handler, or to defer this action to be executed somewhere else?
+ *
+ * TODO implement notification mechanism for overlong macro execution
+ *      If user wants to execute an overlong macro only the names of macroset
+ *      and macro are given. Should userland tap hidraw or is there an
+ *      additional streaming mechanism?
+ *
+ * TODO is it possible to overwrite group for sysfs attributes via udev?
+ */
+
+#include <linux/device.h>
+#include <linux/input.h>
+#include <linux/hid.h>
+#include <linux/usb.h>
+#include <linux/module.h>
+#include "hid-ids.h"
+#include "hid-roccat-kone.h"
+
+static void kone_set_settings_checksum(struct kone_settings *settings)
+{
+	uint16_t checksum = 0;
+	unsigned char *address = (unsigned char *)settings;
+	int i;
+
+	for (i = 0; i < sizeof(struct kone_settings) - 2; ++i, ++address)
+		checksum += *address;
+	settings->checksum = cpu_to_le16(checksum);
+}
+
+/*
+ * Checks success after writing data to mouse
+ * On success returns 0
+ * On failure returns errno
+ */
+static int kone_check_write(struct usb_device *usb_dev)
+{
+	int len;
+	unsigned char *data;
+
+	data = kmalloc(1, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	do {
+		/*
+		 * Mouse needs 50 msecs until it says ok, but there are
+		 * 30 more msecs needed for next write to work.
+		 */
+		msleep(80);
+
+		len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+				USB_REQ_CLEAR_FEATURE,
+				USB_TYPE_CLASS | USB_RECIP_INTERFACE |
+				USB_DIR_IN,
+				kone_command_confirm_write, 0, data, 1,
+				USB_CTRL_SET_TIMEOUT);
+
+		if (len != 1) {
+			kfree(data);
+			return -EIO;
+		}
+
+		/*
+		 * value of 3 seems to mean something like
+		 * "not finished yet, but it looks good"
+		 * So check again after a moment.
+		 */
+	} while (*data == 3);
+
+	if (*data == 1) { /* everything alright */
+		kfree(data);
+		return 0;
+	} else { /* unknown answer */
+		dev_err(&usb_dev->dev, "got retval %d when checking write\n",
+				*data);
+		kfree(data);
+		return -EIO;
+	}
+}
+
+/*
+ * Reads settings from mouse and stores it in @buf
+ * @buf has to be alloced with GFP_KERNEL
+ * On success returns 0
+ * On failure returns errno
+ */
+static int kone_get_settings(struct usb_device *usb_dev,
+		struct kone_settings *buf)
+{
+	int len;
+
+	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			USB_REQ_CLEAR_FEATURE,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
+			kone_command_settings, 0, buf,
+			sizeof(struct kone_settings), USB_CTRL_SET_TIMEOUT);
+
+	if (len != sizeof(struct kone_settings))
+		return -EIO;
+
+	return 0;
+}
+
+/*
+ * Writes settings from @buf to mouse
+ * On success returns 0
+ * On failure returns errno
+ */
+static int kone_set_settings(struct usb_device *usb_dev,
+		struct kone_settings const *settings)
+{
+	int len;
+
+	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+			USB_REQ_SET_CONFIGURATION,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			kone_command_settings, 0, (char *)settings,
+			sizeof(struct kone_settings),
+			USB_CTRL_SET_TIMEOUT);
+
+	if (len != sizeof(struct kone_settings))
+		return -EIO;
+
+	if (kone_check_write(usb_dev))
+		return -EIO;
+
+	return 0;
+}
+
+/*
+ * Reads profile data from mouse and stores it in @buf
+ * @number: profile number to read
+ * On success returns 0
+ * On failure returns errno
+ */
+static int kone_get_profile(struct usb_device *usb_dev,
+		struct kone_profile *buf, int number)
+{
+	int len;
+
+	if (number < 1 || number > 5)
+		return -EINVAL;
+
+	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			USB_REQ_CLEAR_FEATURE,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
+			kone_command_profile, number, buf,
+			sizeof(struct kone_profile), USB_CTRL_SET_TIMEOUT);
+
+	if (len != sizeof(struct kone_profile))
+		return -EIO;
+
+	return 0;
+}
+
+/*
+ * Writes profile data to mouse.
+ * @number: profile number to write
+ * On success returns 0
+ * On failure returns errno
+ */
+static int kone_set_profile(struct usb_device *usb_dev,
+		struct kone_profile const *profile, int number)
+{
+	int len;
+
+	if (number < 1 || number > 5)
+		return -EINVAL;
+
+	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+			USB_REQ_SET_CONFIGURATION,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			kone_command_profile, number, (char *)profile,
+			sizeof(struct kone_profile),
+			USB_CTRL_SET_TIMEOUT);
+
+	if (len != sizeof(struct kone_profile))
+		return len;
+
+	if (kone_check_write(usb_dev))
+		return -EIO;
+
+	return 0;
+}
+
+/*
+ * Reads value of "fast-clip-weight" and stores it in @result
+ * On success returns 0
+ * On failure returns errno
+ */
+static int kone_get_weight(struct usb_device *usb_dev, int *result)
+{
+	int len;
+	uint8_t *data;
+
+	data = kmalloc(1, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			USB_REQ_CLEAR_FEATURE,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
+			kone_command_weight, 0, data, 1, USB_CTRL_SET_TIMEOUT);
+
+	if (len != 1) {
+		kfree(data);
+		return -EIO;
+	}
+	*result = (int)*data;
+	kfree(data);
+	return 0;
+}
+
+/*
+ * Reads firmware_version of mouse and stores it in @result
+ * On success returns 0
+ * On failure returns errno
+ */
+static int kone_get_firmware_version(struct usb_device *usb_dev, int *result)
+{
+	int len;
+	unsigned char *data;
+
+	data = kmalloc(2, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			USB_REQ_CLEAR_FEATURE,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
+			kone_command_firmware_version, 0, data, 2,
+			USB_CTRL_SET_TIMEOUT);
+
+	if (len != 2) {
+		kfree(data);
+		return -EIO;
+	}
+	*result = le16_to_cpu(*data);
+	kfree(data);
+	return 0;
+}
+
+static ssize_t kone_sysfs_read_settings(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count) {
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+
+	if (off >= sizeof(struct kone_settings))
+		return 0;
+
+	if (off + count > sizeof(struct kone_settings))
+		count = sizeof(struct kone_settings) - off;
+
+	mutex_lock(&kone->kone_lock);
+	memcpy(buf, &kone->settings + off, count);
+	mutex_unlock(&kone->kone_lock);
+
+	return count;
+}
+
+/*
+ * Writing settings automatically activates startup_profile.
+ * This function keeps values in kone_device up to date and assumes that in
+ * case of error the old data is still valid
+ */
+static ssize_t kone_sysfs_write_settings(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count) {
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval = 0, difference;
+
+	/* I need to get my data in one piece */
+	if (off != 0 || count != sizeof(struct kone_settings))
+		return -EINVAL;
+
+	mutex_lock(&kone->kone_lock);
+	difference = memcmp(buf, &kone->settings, sizeof(struct kone_settings));
+	if (difference) {
+		retval = kone_set_settings(usb_dev,
+				(struct kone_settings const *)buf);
+		if (!retval)
+			memcpy(&kone->settings, buf,
+					sizeof(struct kone_settings));
+	}
+	mutex_unlock(&kone->kone_lock);
+
+	if (retval)
+		return retval;
+
+	/*
+	 * If we get here, treat settings as okay and update actual values
+	 * according to startup_profile
+	 */
+	kone->actual_profile = kone->settings.startup_profile;
+	kone->actual_dpi = kone->profiles[kone->actual_profile - 1].startup_dpi;
+
+	return sizeof(struct kone_settings);
+}
+
+static ssize_t kone_sysfs_read_profilex(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count, int number) {
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+
+	if (off >= sizeof(struct kone_profile))
+		return 0;
+
+	if (off + count > sizeof(struct kone_profile))
+		count = sizeof(struct kone_profile) - off;
+
+	mutex_lock(&kone->kone_lock);
+	memcpy(buf, &kone->profiles[number - 1], sizeof(struct kone_profile));
+	mutex_unlock(&kone->kone_lock);
+
+	return count;
+}
+
+static ssize_t kone_sysfs_read_profile1(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count) {
+	return kone_sysfs_read_profilex(kobj, attr, buf, off, count, 1);
+}
+
+static ssize_t kone_sysfs_read_profile2(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count) {
+	return kone_sysfs_read_profilex(kobj, attr, buf, off, count, 2);
+}
+
+static ssize_t kone_sysfs_read_profile3(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count) {
+	return kone_sysfs_read_profilex(kobj, attr, buf, off, count, 3);
+}
+
+static ssize_t kone_sysfs_read_profile4(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count) {
+	return kone_sysfs_read_profilex(kobj, attr, buf, off, count, 4);
+}
+
+static ssize_t kone_sysfs_read_profile5(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count) {
+	return kone_sysfs_read_profilex(kobj, attr, buf, off, count, 5);
+}
+
+/* Writes data only if different to stored data */
+static ssize_t kone_sysfs_write_profilex(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count, int number) {
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	struct kone_profile *profile;
+	int retval = 0, difference;
+
+	/* I need to get my data in one piece */
+	if (off != 0 || count != sizeof(struct kone_profile))
+		return -EINVAL;
+
+	profile = &kone->profiles[number - 1];
+
+	mutex_lock(&kone->kone_lock);
+	difference = memcmp(buf, profile, sizeof(struct kone_profile));
+	if (difference) {
+		retval = kone_set_profile(usb_dev,
+				(struct kone_profile const *)buf, number);
+		if (!retval)
+			memcpy(profile, buf, sizeof(struct kone_profile));
+	}
+	mutex_unlock(&kone->kone_lock);
+
+	if (retval)
+		return retval;
+
+	return sizeof(struct kone_profile);
+}
+
+static ssize_t kone_sysfs_write_profile1(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count) {
+	return kone_sysfs_write_profilex(kobj, attr, buf, off, count, 1);
+}
+
+static ssize_t kone_sysfs_write_profile2(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count) {
+	return kone_sysfs_write_profilex(kobj, attr, buf, off, count, 2);
+}
+
+static ssize_t kone_sysfs_write_profile3(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count) {
+	return kone_sysfs_write_profilex(kobj, attr, buf, off, count, 3);
+}
+
+static ssize_t kone_sysfs_write_profile4(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count) {
+	return kone_sysfs_write_profilex(kobj, attr, buf, off, count, 4);
+}
+
+static ssize_t kone_sysfs_write_profile5(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count) {
+	return kone_sysfs_write_profilex(kobj, attr, buf, off, count, 5);
+}
+
+static ssize_t kone_sysfs_show_actual_profile(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	return snprintf(buf, PAGE_SIZE, "%d\n", kone->actual_profile);
+}
+
+static ssize_t kone_sysfs_show_actual_dpi(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	return snprintf(buf, PAGE_SIZE, "%d\n", kone->actual_dpi);
+}
+
+/* weight is read each time, since we don't get informed when it's changed */
+static ssize_t kone_sysfs_show_weight(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int weight = 0;
+	int retval;
+
+	mutex_lock(&kone->kone_lock);
+	retval = kone_get_weight(usb_dev, &weight);
+	mutex_unlock(&kone->kone_lock);
+
+	if (retval)
+		return retval;
+	return snprintf(buf, PAGE_SIZE, "%d\n", weight);
+}
+
+static ssize_t kone_sysfs_show_firmware_version(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	return snprintf(buf, PAGE_SIZE, "%d\n", kone->firmware_version);
+}
+
+static ssize_t kone_sysfs_show_tcu(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	return snprintf(buf, PAGE_SIZE, "%d\n", kone->settings.tcu);
+}
+
+static int kone_tcu_command(struct usb_device *usb_dev, int number)
+{
+	int len;
+	char *value;
+
+	value = kmalloc(1, GFP_KERNEL);
+	if (!value)
+		return -ENOMEM;
+
+	*value = number;
+
+	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+			USB_REQ_SET_CONFIGURATION,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			kone_command_calibrate, 0, value, 1,
+			USB_CTRL_SET_TIMEOUT);
+
+	kfree(value);
+	return ((len != 1) ? -EIO : 0);
+}
+
+/*
+ * Calibrating the tcu is the only action that changes settings data inside the
+ * mouse, so this data needs to be reread
+ */
+static ssize_t kone_sysfs_set_tcu(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval, checksum;
+	unsigned long state;
+
+	retval = strict_strtoul(buf, 10, &state);
+	if (retval)
+		return retval;
+
+	if (state != 0 && state != 1)
+		return -EINVAL;
+
+	mutex_lock(&kone->kone_lock);
+
+	if (state == 1) { /* state activate */
+		retval = kone_tcu_command(usb_dev, 1);
+		if (retval)
+			goto exit_unlock;
+		retval = kone_tcu_command(usb_dev, 2);
+		if (retval)
+			goto exit_unlock;
+		ssleep(5); /* tcu needs this time for calibration */
+		retval = kone_tcu_command(usb_dev, 3);
+		if (retval)
+			goto exit_unlock;
+		retval = kone_tcu_command(usb_dev, 0);
+		if (retval)
+			goto exit_unlock;
+		retval = kone_tcu_command(usb_dev, 4);
+		if (retval)
+			goto exit_unlock;
+		/*
+		 * Kone needs this time to settle things.
+		 * Reading settings too early will result in invalid data.
+		 * Roccat's driver waits 1 sec, maybe this time could be
+		 * shortened.
+		 */
+		ssleep(1);
+	}
+
+	/* calibration changes values in settings, so reread */
+	retval = kone_get_settings(usb_dev, &kone->settings);
+	if (retval)
+		goto exit_no_settings;
+
+	/* only write settings back if activation state is different */
+	if (kone->settings.tcu != state) {
+		kone->settings.tcu = state;
+		kone_set_settings_checksum(&kone->settings);
+
+		retval = kone_set_settings(usb_dev, &kone->settings);
+		if (retval) {
+			dev_err(&usb_dev->dev, "couldn't set tcu state\n");
+			/*
+			 * try to reread valid settings into buffer overwriting
+			 * first error code
+			 */
+			retval = kone_get_settings(usb_dev, &kone->settings);
+			if (retval)
+				goto exit_no_settings;
+			goto exit_unlock;
+		}
+	}
+
+	retval = size;
+exit_no_settings:
+	dev_err(&usb_dev->dev, "couldn't read settings\n");
+exit_unlock:
+	mutex_unlock(&kone->kone_lock);
+	return retval;
+}
+
+static ssize_t kone_sysfs_show_startup_profile(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	return snprintf(buf, PAGE_SIZE, "%d\n", kone->settings.startup_profile);
+}
+
+static ssize_t kone_sysfs_set_startup_profile(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+	unsigned long new_startup_profile;
+
+	retval = strict_strtoul(buf, 10, &new_startup_profile);
+	if (retval)
+		return retval;
+
+	if (new_startup_profile  < 1 || new_startup_profile > 5)
+		return -EINVAL;
+
+	mutex_lock(&kone->kone_lock);
+
+	kone->settings.startup_profile = new_startup_profile;
+	kone_set_settings_checksum(&kone->settings);
+
+	retval = kone_set_settings(usb_dev, &kone->settings);
+
+	mutex_unlock(&kone->kone_lock);
+
+	if (retval)
+		return retval;
+
+	/* changing the startup profile immediately activates this profile */
+	kone->actual_profile = new_startup_profile;
+	kone->actual_dpi = kone->profiles[kone->actual_profile - 1].startup_dpi;
+
+	return size;
+}
+
+/*
+ * This file is used by userland software to find devices that are handled by
+ * this driver. This provides a consistent way for actual and older kernels
+ * where this driver replaced usbhid instead of generic-usb.
+ * Driver capabilities are determined by version number.
+ */
+static ssize_t kone_sysfs_show_driver_version(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, DRIVER_VERSION "\n");
+}
+
+/*
+ * Read actual dpi settings.
+ * Returns raw value for further processing. Refer to enum kone_polling_rates to
+ * get real value.
+ */
+static DEVICE_ATTR(actual_dpi, 0440, kone_sysfs_show_actual_dpi, NULL);
+
+static DEVICE_ATTR(actual_profile, 0440, kone_sysfs_show_actual_profile, NULL);
+
+/*
+ * The mouse can be equipped with one of four supplied weights from 5 to 20
+ * grams which are recognized and its value can be read out.
+ * This returns the raw value reported by the mouse for easy evaluation by
+ * software. Refer to enum kone_weights to get corresponding real weight.
+ */
+static DEVICE_ATTR(weight, 0440, kone_sysfs_show_weight, NULL);
+
+/*
+ * Prints firmware version stored in mouse as integer.
+ * The raw value reported by the mouse is returned for easy evaluation, to get
+ * the real version number the decimal point has to be shifted 2 positions to
+ * the left. E.g. a value of 138 means 1.38.
+ */
+static DEVICE_ATTR(firmware_version, 0440,
+		kone_sysfs_show_firmware_version, NULL);
+
+/*
+ * Prints state of Tracking Control Unit as number where 0 = off and 1 = on
+ * Writing 0 deactivates tcu and writing 1 calibrates and activates the tcu
+ */
+static DEVICE_ATTR(tcu, 0660, kone_sysfs_show_tcu, kone_sysfs_set_tcu);
+
+/* Prints and takes the number of the profile the mouse starts with */
+static DEVICE_ATTR(startup_profile, 0660,
+		kone_sysfs_show_startup_profile,
+		kone_sysfs_set_startup_profile);
+
+static DEVICE_ATTR(kone_driver_version, 0440,
+		kone_sysfs_show_driver_version, NULL);
+
+static struct attribute *kone_attributes[] = {
+		&dev_attr_actual_dpi.attr,
+		&dev_attr_actual_profile.attr,
+		&dev_attr_weight.attr,
+		&dev_attr_firmware_version.attr,
+		&dev_attr_tcu.attr,
+		&dev_attr_startup_profile.attr,
+		&dev_attr_kone_driver_version.attr,
+		NULL
+};
+
+static struct attribute_group kone_attribute_group = {
+		.attrs = kone_attributes
+};
+
+static struct bin_attribute kone_settings_attr = {
+	.attr = { .name = "settings", .mode = 0660 },
+	.size = sizeof(struct kone_settings),
+	.read = kone_sysfs_read_settings,
+	.write = kone_sysfs_write_settings
+};
+
+static struct bin_attribute kone_profile1_attr = {
+	.attr = { .name = "profile1", .mode = 0660 },
+	.size = sizeof(struct kone_profile),
+	.read = kone_sysfs_read_profile1,
+	.write = kone_sysfs_write_profile1
+};
+
+static struct bin_attribute kone_profile2_attr = {
+	.attr = { .name = "profile2", .mode = 0660 },
+	.size = sizeof(struct kone_profile),
+	.read = kone_sysfs_read_profile2,
+	.write = kone_sysfs_write_profile2
+};
+
+static struct bin_attribute kone_profile3_attr = {
+	.attr = { .name = "profile3", .mode = 0660 },
+	.size = sizeof(struct kone_profile),
+	.read = kone_sysfs_read_profile3,
+	.write = kone_sysfs_write_profile3
+};
+
+static struct bin_attribute kone_profile4_attr = {
+	.attr = { .name = "profile4", .mode = 0660 },
+	.size = sizeof(struct kone_profile),
+	.read = kone_sysfs_read_profile4,
+	.write = kone_sysfs_write_profile4
+};
+
+static struct bin_attribute kone_profile5_attr = {
+	.attr = { .name = "profile5", .mode = 0660 },
+	.size = sizeof(struct kone_profile),
+	.read = kone_sysfs_read_profile5,
+	.write = kone_sysfs_write_profile5
+};
+
+static int kone_create_sysfs_attributes(struct usb_interface *intf)
+{
+	int retval;
+
+	retval = sysfs_create_group(&intf->dev.kobj, &kone_attribute_group);
+	if (retval)
+		goto exit_1;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj, &kone_settings_attr);
+	if (retval)
+		goto exit_2;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj, &kone_profile1_attr);
+	if (retval)
+		goto exit_3;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj, &kone_profile2_attr);
+	if (retval)
+		goto exit_4;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj, &kone_profile3_attr);
+	if (retval)
+		goto exit_5;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj, &kone_profile4_attr);
+	if (retval)
+		goto exit_6;
+
+	retval = sysfs_create_bin_file(&intf->dev.kobj, &kone_profile5_attr);
+	if (retval)
+		goto exit_7;
+
+	return 0;
+
+exit_7:
+	sysfs_remove_bin_file(&intf->dev.kobj, &kone_profile4_attr);
+exit_6:
+	sysfs_remove_bin_file(&intf->dev.kobj, &kone_profile3_attr);
+exit_5:
+	sysfs_remove_bin_file(&intf->dev.kobj, &kone_profile2_attr);
+exit_4:
+	sysfs_remove_bin_file(&intf->dev.kobj, &kone_profile1_attr);
+exit_3:
+	sysfs_remove_bin_file(&intf->dev.kobj, &kone_settings_attr);
+exit_2:
+	sysfs_remove_group(&intf->dev.kobj, &kone_attribute_group);
+exit_1:
+	return retval;
+}
+
+static void kone_remove_sysfs_attributes(struct usb_interface *intf)
+{
+	sysfs_remove_bin_file(&intf->dev.kobj, &kone_profile5_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &kone_profile4_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &kone_profile3_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &kone_profile2_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &kone_profile1_attr);
+	sysfs_remove_bin_file(&intf->dev.kobj, &kone_settings_attr);
+	sysfs_remove_group(&intf->dev.kobj, &kone_attribute_group);
+}
+
+static int kone_init_kone_device_struct(struct usb_device *usb_dev,
+		struct kone_device *kone)
+{
+	uint i;
+	int retval;
+
+	mutex_init(&kone->kone_lock);
+
+	for (i = 0; i < 5; ++i) {
+		retval = kone_get_profile(usb_dev, &kone->profiles[i], i + 1);
+		if (retval)
+			return retval;
+	}
+
+	retval = kone_get_settings(usb_dev, &kone->settings);
+	if (retval)
+		return retval;
+
+	retval = kone_get_firmware_version(usb_dev, &kone->firmware_version);
+	if (retval)
+		return retval;
+
+	kone->actual_profile = kone->settings.startup_profile;
+	kone->actual_dpi = kone->profiles[kone->actual_profile].startup_dpi;
+
+	return 0;
+}
+
+/*
+ * Since IGNORE_MOUSE quirk moved to hid-apple, there is no way to bind only to
+ * mousepart if usb_hid is compiled into the kernel and kone is compiled as
+ * module.
+ * Secial behaviour is bound only to mousepart since only mouseevents contain
+ * additional notifications.
+ */
+static int kone_init_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct kone_device *kone;
+	int retval;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			== USB_INTERFACE_PROTOCOL_MOUSE) {
+
+		kone = kzalloc(sizeof(*kone), GFP_KERNEL);
+		if (!kone) {
+			dev_err(&hdev->dev, "can't alloc device descriptor\n");
+			return -ENOMEM;
+		}
+		hid_set_drvdata(hdev, kone);
+
+		retval = kone_init_kone_device_struct(usb_dev, kone);
+		if (retval) {
+			dev_err(&hdev->dev,
+					"couldn't init struct kone_device\n");
+			goto exit_free;
+		}
+		retval = kone_create_sysfs_attributes(intf);
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
+	kfree(kone);
+	return retval;
+}
+
+
+static void kone_remove_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			== USB_INTERFACE_PROTOCOL_MOUSE) {
+		kone_remove_sysfs_attributes(intf);
+		kfree(hid_get_drvdata(hdev));
+	}
+}
+
+static int kone_probe(struct hid_device *hdev, const struct hid_device_id *id)
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
+	retval = kone_init_specials(hdev);
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
+static void kone_remove(struct hid_device *hdev)
+{
+	kone_remove_specials(hdev);
+	hid_hw_stop(hdev);
+}
+
+/*
+ * Is called for keyboard- and mousepart.
+ * Only mousepart gets informations about special events in its extended event
+ * structure.
+ */
+static int kone_raw_event(struct hid_device *hdev, struct hid_report *report,
+		u8 *data, int size)
+{
+	struct kone_device *kone = hid_get_drvdata(hdev);
+	struct kone_mouse_event *event = (struct kone_mouse_event *)data;
+
+	/* keyboard events are always processed by default handler */
+	if (size != sizeof(struct kone_mouse_event))
+		return 0;
+
+	/*
+	 * Firmware 1.38 introduced new behaviour for tilt buttons.
+	 * Pressed tilt button is reported in each movement event.
+	 * Workaround sends only one event per press.
+	 */
+	if (kone->last_tilt_state == event->tilt)
+		event->tilt = 0;
+	else
+		kone->last_tilt_state = event->tilt;
+
+	/*
+	 * handle special events and keep actual profile and dpi values
+	 * up to date
+	 */
+	switch (event->event) {
+	case kone_mouse_event_osd_dpi:
+		dev_dbg(&hdev->dev, "osd dpi event. actual dpi %d\n",
+				event->value);
+		return 1; /* return 1 if event was handled */
+	case kone_mouse_event_switch_dpi:
+		kone->actual_dpi = event->value;
+		dev_dbg(&hdev->dev, "switched dpi to %d\n", event->value);
+		return 1;
+	case kone_mouse_event_osd_profile:
+		dev_dbg(&hdev->dev, "osd profile event. actual profile %d\n",
+				event->value);
+		return 1;
+	case kone_mouse_event_switch_profile:
+		kone->actual_profile = event->value;
+		kone->actual_dpi = kone->profiles[kone->actual_profile - 1].
+				startup_dpi;
+		dev_dbg(&hdev->dev, "switched profile to %d\n", event->value);
+		return 1;
+	case kone_mouse_event_call_overlong_macro:
+		dev_dbg(&hdev->dev, "overlong macro called, button %d %s/%s\n",
+				event->macro_key,
+				kone->profiles[kone->actual_profile - 1].
+				button_infos[event->macro_key].macro_set_name,
+				kone->profiles[kone->actual_profile - 1].
+				button_infos[event->macro_key].macro_name
+				);
+		return 1;
+	}
+
+	return 0; /* do further processing */
+}
+
+static const struct hid_device_id kone_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONE) },
+	{ } };
+
+MODULE_DEVICE_TABLE(hid, kone_devices);
+
+static struct hid_driver kone_driver = { .name = "kone",
+		.id_table = kone_devices, .probe = kone_probe,
+		.remove = kone_remove, .raw_event = kone_raw_event, };
+
+static int kone_init(void)
+{
+	return hid_register_driver(&kone_driver);
+}
+
+static void kone_exit(void)
+{
+	hid_unregister_driver(&kone_driver);
+}
+
+module_init(kone_init);
+module_exit(kone_exit);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE(DRIVER_LICENSE);
diff --git a/drivers/hid/hid-roccat-kone.h b/drivers/hid/hid-roccat-kone.h
new file mode 100644
index 0000000..ee6898c
--- /dev/null
+++ b/drivers/hid/hid-roccat-kone.h
@@ -0,0 +1,214 @@
+#ifndef __HID_ROCCAT_KONE_H
+#define __HID_ROCCAT_KONE_H
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
+#define DRIVER_VERSION "v0.3.0"
+#define DRIVER_AUTHOR "Stefan Achatz"
+#define DRIVER_DESC "USB Roccat Kone driver"
+#define DRIVER_LICENSE "GPL v2"
+
+#pragma pack(push)
+#pragma pack(1)
+
+struct kone_keystroke {
+	uint8_t key;
+	uint8_t action;
+	uint16_t period; /* in milliseconds */
+};
+
+enum kone_keystroke_buttons {
+	kone_keystroke_button_1 = 0xf0, /* left mouse button */
+	kone_keystroke_button_2 = 0xf1, /* right mouse button */
+	kone_keystroke_button_3 = 0xf2, /* wheel */
+	kone_keystroke_button_9 = 0xf3, /* side button up */
+	kone_keystroke_button_8 = 0xf4 /* side button down */
+};
+
+enum kone_keystroke_actions {
+	kone_keystroke_action_press = 0,
+	kone_keystroke_action_release = 1
+};
+
+struct kone_button_info {
+	uint8_t number; /* range 1-8 */
+	uint8_t type;
+	uint8_t macro_type; /* 0 = short, 1 = overlong */
+	uint8_t macro_set_name[16]; /* can be max 15 chars long */
+	uint8_t macro_name[16]; /* can be max 15 chars long */
+	uint8_t count;
+	struct kone_keystroke keystrokes[20];
+};
+
+enum kone_button_info_types {
+	/* valid button types until firmware 1.32 */
+	kone_button_info_type_button_1 = 0x1, /* click (left mouse button) */
+	kone_button_info_type_button_2 = 0x2, /* menu (right mouse button)*/
+	kone_button_info_type_button_3 = 0x3, /* scroll (wheel) */
+	kone_button_info_type_double_click = 0x4,
+	kone_button_info_type_key = 0x5,
+	kone_button_info_type_macro = 0x6,
+	kone_button_info_type_off = 0x7,
+	/* TODO clarify function and rename */
+	kone_button_info_type_osd_xy_prescaling = 0x8,
+	kone_button_info_type_osd_dpi = 0x9,
+	kone_button_info_type_osd_profile = 0xa,
+	kone_button_info_type_button_9 = 0xb, /* ie forward */
+	kone_button_info_type_button_8 = 0xc, /* ie backward */
+	kone_button_info_type_dpi_up = 0xd, /* internal */
+	kone_button_info_type_dpi_down = 0xe, /* internal */
+	kone_button_info_type_button_7 = 0xf, /* tilt left */
+	kone_button_info_type_button_6 = 0x10, /* tilt right */
+	kone_button_info_type_profile_up = 0x11, /* internal */
+	kone_button_info_type_profile_down = 0x12, /* internal */
+	/* additional valid button types since firmware 1.38 */
+	kone_button_info_type_multimedia_open_player = 0x20,
+	kone_button_info_type_multimedia_next_track = 0x21,
+	kone_button_info_type_multimedia_prev_track = 0x22,
+	kone_button_info_type_multimedia_play_pause = 0x23,
+	kone_button_info_type_multimedia_stop = 0x24,
+	kone_button_info_type_multimedia_mute = 0x25,
+	kone_button_info_type_multimedia_volume_up = 0x26,
+	kone_button_info_type_multimedia_volume_down = 0x27
+};
+
+struct kone_light_info {
+	uint8_t number; /* number of light 1-5 */
+	uint8_t mod;   /* 1 = on, 2 = off */
+	uint8_t red;   /* range 0x00-0xff */
+	uint8_t green; /* range 0x00-0xff */
+	uint8_t blue;  /* range 0x00-0xff */
+};
+
+struct kone_profile {
+	uint16_t size; /* always 975 */
+	uint16_t unused; /* always 0 */
+
+	/*
+	 * range 1-5
+	 * This number does not need to correspond with location where profile
+	 * saved
+	 */
+	uint8_t profile; /* range 1-5 */
+
+	uint16_t main_sensitivity; /* range 100-1000 */
+	uint8_t xy_sensitivity_enabled; /* 1 = on, 2 = off */
+	uint16_t x_sensitivity; /* range 100-1000 */
+	uint16_t y_sensitivity; /* range 100-1000 */
+	uint8_t dpi_rate; /* bit 1 = 800, ... */
+	uint8_t startup_dpi; /* range 1-6 */
+	uint8_t polling_rate; /* 1 = 125Hz, 2 = 500Hz, 3 = 1000Hz */
+	/* kone has no dcu
+	 * value is always 2 in firmwares <= 1.32 and
+	 * 1 in firmwares > 1.32
+	 */
+	uint8_t dcu_flag;
+	uint8_t light_effect_1; /* range 1-3 */
+	uint8_t light_effect_2; /* range 1-5 */
+	uint8_t light_effect_3; /* range 1-4 */
+	uint8_t light_effect_speed; /* range 0-255 */
+
+	struct kone_light_info light_infos[5];
+	struct kone_button_info button_infos[8];
+
+	uint16_t checksum; /* \brief holds checksum of struct */
+};
+
+enum kone_polling_rates {
+	kone_polling_rate_125 = 1,
+	kone_polling_rate_500 = 2,
+	kone_polling_rate_1000 = 3
+};
+
+struct kone_settings {
+	uint16_t size; /* always 36 */
+	uint8_t  startup_profile; /* 1-5 */
+	uint8_t	 unknown1;
+	uint8_t  tcu; /* 0 = off, 1 = on */
+	uint8_t  unknown2[23];
+	uint8_t  calibration_data[4];
+	uint8_t  unknown3[2];
+	uint16_t checksum;
+};
+
+/*
+ * 12 byte mouse event read by interrupt_read
+ */
+struct kone_mouse_event {
+	uint8_t report_number; /* always 1 */
+	uint8_t button;
+	uint16_t x;
+	uint16_t y;
+	uint8_t wheel; /* up = 1, down = -1 */
+	uint8_t tilt; /* right = 1, left = -1 */
+	uint8_t unknown;
+	uint8_t event;
+	uint8_t value; /* press = 0, release = 1 */
+	uint8_t macro_key; /* 0 to 8 */
+};
+
+enum kone_mouse_events {
+	/* osd events are thought to be display on screen */
+	kone_mouse_event_osd_dpi = 0xa0,
+	kone_mouse_event_osd_profile = 0xb0,
+	/* TODO clarify meaning and occurence of kone_mouse_event_calibration */
+	kone_mouse_event_calibration = 0xc0,
+	kone_mouse_event_call_overlong_macro = 0xe0,
+	/* switch events notify if user changed values wiht mousebutton click */
+	kone_mouse_event_switch_dpi = 0xf0,
+	kone_mouse_event_switch_profile = 0xf1
+};
+
+enum kone_commands {
+	kone_command_profile = 0x5a,
+	kone_command_settings = 0x15a,
+	kone_command_firmware_version = 0x25a,
+	kone_command_weight = 0x45a,
+	kone_command_calibrate = 0x55a,
+	kone_command_confirm_write = 0x65a,
+	kone_command_firmware = 0xe5a
+};
+
+#pragma pack(pop)
+
+struct kone_device {
+	/*
+	 * Storing actual values when we get informed about changes since there
+	 * is no way of getting this information from the device on demand
+	 */
+	int actual_profile, actual_dpi;
+	/* Used for neutralizing abnormal tilt button behaviour */
+	int last_tilt_state;
+	/*
+	 * It's unlikely that multiple sysfs attributes are accessed at a time,
+	 * so only one mutex is used to secure hardware access and profiles and
+	 * settings of this struct.
+	 */
+	struct mutex kone_lock;
+
+	/*
+	 * Storing the data here reduces IO and ensures that data is available
+	 * when its needed (E.g. interrupt handler).
+	 */
+	struct kone_profile profiles[5];
+	struct kone_settings settings;
+
+	/*
+	 * firmware doesn't change unless firmware update is implemented,
+	 * so it's read only once
+	 */
+	int firmware_version;
+};
+
+#endif
-- 
1.6.6.1




