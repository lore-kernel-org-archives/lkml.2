Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab1AFIAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:00:41 -0500
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:36456 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498Ab1AFIAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:00:37 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-11.arcor-online.net 5467035A5A1
Subject: [PATCH 1/2] Hid: roccat: Add support for Roccat Arvo keyboard
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 09:00:34 +0100
Message-ID: <1294300834.5622.58.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for Roccat Arvo keyboard. Arvo has 5 additional
configurable buttons and the ability to deactivate certain keys.
Userland tools can soon be found at http://sourceforge.net/projects/roccat

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-arvo       |   48 ++
 drivers/hid/Kconfig                                |    7 +
 drivers/hid/Makefile                               |    1 +
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-roccat-arvo.c                      |  516 ++++++++++++++++++++
 drivers/hid/hid-roccat-arvo.h                      |   98 ++++
 7 files changed, 672 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo
 create mode 100644 drivers/hid/hid-roccat-arvo.c
 create mode 100644 drivers/hid/hid-roccat-arvo.h

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo b/Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo
new file mode 100644
index 0000000..d54827d
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo
@@ -0,0 +1,48 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/actual_profile
+Date:		Januar 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The integer value of this attribute ranges from 1-5.
+		When read, this attribute returns the number of the actual
+		profile which is also the profile that's active on device startup.
+		When written this attribute activates the selected profile
+		immediately.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/button
+Date:		Januar 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The keyboard can store short macros with consist of 1 button with
+		several modifier keys internally.
+		When written, this file lets one set the sequence for a specific
+		button for a specific profile. Button and profile numbers are
+		included in written data. The data has to be 24 bytes long.
+		This file is writeonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/info
+Date:		Januar 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns some info about the device like the
+		installed firmware version.
+		The size of the data is 8 bytes in size.
+		This file is readonly.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/key_mask
+Date:		Januar 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The keyboard lets the user deactivate 5 certain keys like the
+		windows and application keys, to protect the user from the outcome
+		of accidentally pressing them.
+		The integer value of this attribute has bits 0-4 set depending
+		on the state of the corresponding key.
+		When read, this file returns the current state of the buttons.
+		When written, the given buttons are activated/deactivated
+		immediately.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/mode_key
+Date:		Januar 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	The keyboard has a condensed layout without num-lock key.
+		Instead it uses a mode-key which activates a gaming mode where
+		the assignment of the number block changes.
+		The integer value of this attribute ranges from 0 (OFF) to 1 (ON).
+		When read, this file returns the actual state of the key.
+		When written, the key is activated/deactivated immediately.
\ No newline at end of file
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index d2a2751..3068403 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -399,6 +399,13 @@ config HID_ROCCAT
 	Say Y here if you have a Roccat mouse or keyboard and want OSD or
 	macro execution support.
 
+config HID_ROCCAT_ARVO
+	tristate "Roccat Arvo keyboard support"
+	depends on USB_HID
+	select HID_ROCCAT
+	---help---
+	Support for Roccat Arvo keyboard.
+
 config HID_ROCCAT_KONE
 	tristate "Roccat Kone Mouse support"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 6eae9a9..0dfbef4 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_HID_PANTHERLORD)	+= hid-pl.o
 obj-$(CONFIG_HID_PETALYNX)	+= hid-petalynx.o
 obj-$(CONFIG_HID_PICOLCD)	+= hid-picolcd.o
 obj-$(CONFIG_HID_ROCCAT)	+= hid-roccat.o
+obj-$(CONFIG_HID_ROCCAT_ARVO)	+= hid-roccat-arvo.o
 obj-$(CONFIG_HID_ROCCAT_KONE)	+= hid-roccat-kone.o
 obj-$(CONFIG_HID_ROCCAT_KONEPLUS)	+= hid-roccat-koneplus.o
 obj-$(CONFIG_HID_ROCCAT_PYRA)	+= hid-roccat-pyra.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index ecfe88d..4db7a8c 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1377,6 +1377,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ARVO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPLUS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRED) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index a945d79..2bdd4e0 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -484,6 +484,7 @@
 #define USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN	0x3001
 
 #define USB_VENDOR_ID_ROCCAT		0x1e7d
+#define USB_DEVICE_ID_ROCCAT_ARVO	0x30d4
 #define USB_DEVICE_ID_ROCCAT_KONE	0x2ced
 #define USB_DEVICE_ID_ROCCAT_KONEPLUS	0x2d51
 #define USB_DEVICE_ID_ROCCAT_PYRA_WIRED	0x2c24
diff --git a/drivers/hid/hid-roccat-arvo.c b/drivers/hid/hid-roccat-arvo.c
new file mode 100644
index 0000000..8facbd3
--- /dev/null
+++ b/drivers/hid/hid-roccat-arvo.c
@@ -0,0 +1,516 @@
+/*
+ * Roccat Arvo driver for Linux
+ *
+ * Copyright (c) 2011 Stefan Achatz <erazor_de@users.sourceforge.net>
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
+ * Roccat Arvo is a gamer keyboard with 5 macro keys that can be configured in
+ * 5 profiles.
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
+#include "hid-roccat-arvo.h"
+
+static struct class *arvo_class;
+
+static int arvo_receive(struct usb_device *usb_dev, uint usb_command,
+		void *buf, uint size)
+{
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
+static int arvo_send(struct usb_device *usb_dev, uint usb_command,
+		void const *buf, uint size)
+{
+	int len;
+
+	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+			USB_REQ_SET_CONFIGURATION,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			usb_command, 0, (void *)buf, size, USB_CTRL_SET_TIMEOUT);
+
+	return (len != size) ? -EIO : 0;
+}
+
+static ssize_t arvo_sysfs_show_mode_key(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct arvo_device *arvo =
+			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
+	struct usb_device *usb_dev =
+			interface_to_usbdev(to_usb_interface(dev->parent->parent));
+	struct arvo_mode_key *temp_buf;
+	int retval;
+
+	temp_buf = kmalloc(sizeof(struct arvo_mode_key), GFP_KERNEL);
+	if (!temp_buf)
+		return -ENOMEM;
+
+	mutex_lock(&arvo->arvo_lock);
+	retval = arvo_receive(usb_dev, ARVO_USB_COMMAND_MODE_KEY,
+			temp_buf, sizeof(struct arvo_mode_key));
+	mutex_unlock(&arvo->arvo_lock);
+	if (retval)
+		goto out;
+
+	retval = snprintf(buf, PAGE_SIZE, "%d\n", temp_buf->state);
+out:
+	kfree(temp_buf);
+	return retval;
+}
+
+static ssize_t arvo_sysfs_set_mode_key(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	struct arvo_device *arvo =
+			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
+	struct usb_device *usb_dev =
+			interface_to_usbdev(to_usb_interface(dev->parent->parent));
+	struct arvo_mode_key *temp_buf;
+	unsigned long state;
+	int retval;
+
+	temp_buf = kmalloc(sizeof(struct arvo_mode_key), GFP_KERNEL);
+	if (!temp_buf)
+		return -ENOMEM;
+
+	retval = strict_strtoul(buf, 10, &state);
+	if (retval)
+		goto out;
+
+	temp_buf->command = ARVO_COMMAND_MODE_KEY;
+	temp_buf->state = state;
+
+	mutex_lock(&arvo->arvo_lock);
+	retval = arvo_send(usb_dev, ARVO_USB_COMMAND_MODE_KEY,
+			temp_buf, sizeof(struct arvo_mode_key));
+	mutex_unlock(&arvo->arvo_lock);
+	if (retval)
+		goto out;
+
+	retval = size;
+out:
+	kfree(temp_buf);
+	return retval;
+}
+
+static ssize_t arvo_sysfs_show_key_mask(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct arvo_device *arvo =
+			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
+	struct usb_device *usb_dev =
+			interface_to_usbdev(to_usb_interface(dev->parent->parent));
+	struct arvo_key_mask *temp_buf;
+	int retval;
+
+	temp_buf = kmalloc(sizeof(struct arvo_key_mask), GFP_KERNEL);
+	if (!temp_buf)
+		return -ENOMEM;
+
+	mutex_lock(&arvo->arvo_lock);
+	retval = arvo_receive(usb_dev, ARVO_USB_COMMAND_KEY_MASK,
+			temp_buf, sizeof(struct arvo_key_mask));
+	mutex_unlock(&arvo->arvo_lock);
+	if (retval)
+		goto out;
+
+	retval = snprintf(buf, PAGE_SIZE, "%d\n", temp_buf->key_mask);
+out:
+	kfree(temp_buf);
+	return retval;
+}
+
+static ssize_t arvo_sysfs_set_key_mask(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	struct arvo_device *arvo =
+			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
+	struct usb_device *usb_dev =
+			interface_to_usbdev(to_usb_interface(dev->parent->parent));
+	struct arvo_key_mask *temp_buf;
+	unsigned long key_mask;
+	int retval;
+
+	temp_buf = kmalloc(sizeof(struct arvo_key_mask), GFP_KERNEL);
+	if (!temp_buf)
+		return -ENOMEM;
+
+	retval = strict_strtoul(buf, 10, &key_mask);
+	if (retval)
+		goto out;
+
+	temp_buf->command = ARVO_COMMAND_KEY_MASK;
+	temp_buf->key_mask = key_mask;
+
+	mutex_lock(&arvo->arvo_lock);
+	retval = arvo_send(usb_dev, ARVO_USB_COMMAND_KEY_MASK,
+			temp_buf, sizeof(struct arvo_key_mask));
+	mutex_unlock(&arvo->arvo_lock);
+	if (retval)
+		goto out;
+
+	retval = size;
+out:
+	kfree(temp_buf);
+	return retval;
+}
+
+/* retval is 1-5 on success, < 0 on error */
+static int arvo_get_actual_profile(struct usb_device *usb_dev)
+{
+	struct arvo_actual_profile *temp_buf;
+	int retval;
+
+	temp_buf = kmalloc(sizeof(struct arvo_actual_profile), GFP_KERNEL);
+	if (!temp_buf)
+		return -ENOMEM;
+
+	retval = arvo_receive(usb_dev, ARVO_USB_COMMAND_ACTUAL_PROFILE,
+			temp_buf, sizeof(struct arvo_actual_profile));
+
+	if (!retval)
+		retval = temp_buf->actual_profile;
+
+	kfree(temp_buf);
+	return retval;
+}
+
+static ssize_t arvo_sysfs_show_actual_profile(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct arvo_device *arvo =
+			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", arvo->actual_profile);
+}
+
+static ssize_t arvo_sysfs_set_actual_profile(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	struct arvo_device *arvo =
+			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
+	struct usb_device *usb_dev =
+			interface_to_usbdev(to_usb_interface(dev->parent->parent));
+	struct arvo_actual_profile *temp_buf;
+	unsigned long profile;
+	int retval;
+
+	temp_buf = kmalloc(sizeof(struct arvo_actual_profile), GFP_KERNEL);
+	if (!temp_buf)
+		return -ENOMEM;
+
+	retval = strict_strtoul(buf, 10, &profile);
+	if (retval)
+		goto out;
+
+	temp_buf->command = ARVO_COMMAND_ACTUAL_PROFILE;
+	temp_buf->actual_profile = profile;
+
+	mutex_lock(&arvo->arvo_lock);
+	retval = arvo_send(usb_dev, ARVO_USB_COMMAND_ACTUAL_PROFILE,
+			temp_buf, sizeof(struct arvo_actual_profile));
+	if (!retval) {
+		arvo->actual_profile = profile;
+		retval = size;
+	}
+	mutex_unlock(&arvo->arvo_lock);
+
+out:
+	kfree(temp_buf);
+	return retval;
+}
+
+static ssize_t arvo_sysfs_write(struct file *fp,
+		struct kobject *kobj, void const *buf,
+		loff_t off, size_t count, size_t real_size, uint command)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct arvo_device *arvo = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+
+	if (off != 0 || count != real_size)
+		return -EINVAL;
+
+	mutex_lock(&arvo->arvo_lock);
+	retval = arvo_send(usb_dev, command, buf, real_size);
+	mutex_unlock(&arvo->arvo_lock);
+
+	return (retval ? retval : real_size);
+}
+
+static ssize_t arvo_sysfs_read(struct file *fp,
+		struct kobject *kobj, void *buf, loff_t off,
+		size_t count, size_t real_size, uint command)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct arvo_device *arvo = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+
+	if (off >= real_size)
+		return 0;
+
+	if (off != 0 || count != real_size)
+		return -EINVAL;
+
+	mutex_lock(&arvo->arvo_lock);
+	retval = arvo_receive(usb_dev, command, buf, real_size);
+	mutex_unlock(&arvo->arvo_lock);
+
+	return (retval ? retval : real_size);
+}
+
+static ssize_t arvo_sysfs_write_button(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return arvo_sysfs_write(fp, kobj, buf, off, count,
+			sizeof(struct arvo_button), ARVO_USB_COMMAND_BUTTON);
+}
+
+static ssize_t arvo_sysfs_read_info(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return arvo_sysfs_read(fp, kobj, buf, off, count,
+			sizeof(struct arvo_info), ARVO_USB_COMMAND_INFO);
+}
+
+
+static struct device_attribute arvo_attributes[] = {
+	__ATTR(mode_key, 0660,
+			arvo_sysfs_show_mode_key, arvo_sysfs_set_mode_key),
+	__ATTR(key_mask, 0660,
+			arvo_sysfs_show_key_mask, arvo_sysfs_set_key_mask),
+	__ATTR(actual_profile, 0660,
+			arvo_sysfs_show_actual_profile,
+			arvo_sysfs_set_actual_profile),
+	__ATTR_NULL
+};
+
+static struct bin_attribute arvo_bin_attributes[] = {
+	{
+		.attr = { .name = "button", .mode = 0220 },
+		.size = sizeof(struct arvo_button),
+		.write = arvo_sysfs_write_button
+	},
+	{
+		.attr = { .name = "info", .mode = 0440 },
+		.size = sizeof(struct arvo_info),
+		.read = arvo_sysfs_read_info
+	},
+	__ATTR_NULL
+};
+
+static int arvo_init_arvo_device_struct(struct usb_device *usb_dev,
+		struct arvo_device *arvo)
+{
+	int retval;
+
+	mutex_init(&arvo->arvo_lock);
+
+	retval = arvo_get_actual_profile(usb_dev);
+	if (retval < 0)
+		return retval;
+	arvo->actual_profile = retval;
+
+	return 0;
+}
+
+static int arvo_init_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct arvo_device *arvo;
+	int retval;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			== USB_INTERFACE_PROTOCOL_KEYBOARD) {
+		hid_set_drvdata(hdev, NULL);
+		return 0;
+	}
+
+	arvo = kzalloc(sizeof(*arvo), GFP_KERNEL);
+	if (!arvo) {
+		dev_err(&hdev->dev, "can't alloc device descriptor\n");
+		return -ENOMEM;
+	}
+	hid_set_drvdata(hdev, arvo);
+
+	retval = arvo_init_arvo_device_struct(usb_dev, arvo);
+	if (retval) {
+		dev_err(&hdev->dev,
+				"couldn't init struct arvo_device\n");
+		goto exit_free;
+	}
+
+	retval = roccat_connect(arvo_class, hdev);
+	if (retval < 0) {
+		dev_err(&hdev->dev, "couldn't init char dev\n");
+	} else {
+		arvo->chrdev_minor = retval;
+		arvo->roccat_claimed = 1;
+	}
+
+	return 0;
+exit_free:
+	kfree(arvo);
+	return retval;
+}
+
+static void arvo_remove_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct arvo_device *arvo;
+
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			== USB_INTERFACE_PROTOCOL_KEYBOARD)
+		return;
+
+	arvo = hid_get_drvdata(hdev);
+	if (arvo->roccat_claimed)
+		roccat_disconnect(arvo->chrdev_minor);
+	kfree(arvo);
+}
+
+static int arvo_probe(struct hid_device *hdev,
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
+	retval = arvo_init_specials(hdev);
+	if (retval) {
+		dev_err(&hdev->dev, "couldn't install keyboard\n");
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
+static void arvo_remove(struct hid_device *hdev)
+{
+	arvo_remove_specials(hdev);
+	hid_hw_stop(hdev);
+}
+
+static void arvo_report_to_chrdev(struct arvo_device const *arvo,
+		u8 const *data)
+{
+	struct arvo_special_report const *special_report;
+	struct arvo_roccat_report roccat_report;
+
+	special_report = (struct arvo_special_report const *)data;
+
+	roccat_report.profile = arvo->actual_profile;
+	roccat_report.button = special_report->event &
+			ARVO_SPECIAL_REPORT_EVENT_MASK_BUTTON;
+	if ((special_report->event & ARVO_SPECIAL_REPORT_EVENT_MASK_ACTION) ==
+			ARVO_SPECIAL_REPORT_EVENT_ACTION_PRESS)
+		roccat_report.action = ARVO_ROCCAT_REPORT_ACTION_PRESS;
+	else
+		roccat_report.action = ARVO_ROCCAT_REPORT_ACTION_RELEASE;
+
+	roccat_report_event(arvo->chrdev_minor, (uint8_t const *)&roccat_report,
+			sizeof(struct arvo_roccat_report));
+}
+
+static int arvo_raw_event(struct hid_device *hdev,
+		struct hid_report *report, u8 *data, int size)
+{
+	struct arvo_device *arvo = hid_get_drvdata(hdev);
+
+	if (size != 3)
+		return 0;
+
+	if (arvo->roccat_claimed)
+		arvo_report_to_chrdev(arvo, data);
+
+	return 0;
+}
+
+static const struct hid_device_id arvo_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ARVO) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(hid, arvo_devices);
+
+static struct hid_driver arvo_driver = {
+	.name = "arvo",
+	.id_table = arvo_devices,
+	.probe = arvo_probe,
+	.remove = arvo_remove,
+	.raw_event = arvo_raw_event
+};
+
+static int __init arvo_init(void)
+{
+	int retval;
+
+	arvo_class = class_create(THIS_MODULE, "arvo");
+	if (IS_ERR(arvo_class))
+		return PTR_ERR(arvo_class);
+	arvo_class->dev_attrs = arvo_attributes;
+	arvo_class->dev_bin_attrs = arvo_bin_attributes;
+
+	retval = hid_register_driver(&arvo_driver);
+	if (retval)
+		class_destroy(arvo_class);
+	return retval;
+}
+
+static void __exit arvo_exit(void)
+{
+	class_destroy(arvo_class);
+	hid_unregister_driver(&arvo_driver);
+}
+
+module_init(arvo_init);
+module_exit(arvo_exit);
+
+MODULE_AUTHOR("Stefan Achatz");
+MODULE_DESCRIPTION("USB Roccat Arvo driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-roccat-arvo.h b/drivers/hid/hid-roccat-arvo.h
new file mode 100644
index 0000000..d284a78
--- /dev/null
+++ b/drivers/hid/hid-roccat-arvo.h
@@ -0,0 +1,98 @@
+#ifndef __HID_ROCCAT_ARVO_H
+#define __HID_ROCCAT_ARVO_H
+
+/*
+ * Copyright (c) 2011 Stefan Achatz <erazor_de@users.sourceforge.net>
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
+struct arvo_mode_key { /* 2 bytes */
+	uint8_t command; /* ARVO_COMMAND_MODE_KEY */
+	uint8_t state;
+} __packed;
+
+struct arvo_button {
+	uint8_t unknown[24];
+} __packed;
+
+struct arvo_info {
+	uint8_t unknown[8];
+} __packed;
+
+struct arvo_key_mask { /* 2 bytes */
+	uint8_t command; /* ARVO_COMMAND_KEY_MASK */
+	uint8_t key_mask;
+} __packed;
+
+/* selected profile is persistent */
+struct arvo_actual_profile { /* 2 bytes */
+	uint8_t command; /* ARVO_COMMAND_ACTUAL_PROFILE */
+	uint8_t actual_profile;
+} __packed;
+
+enum arvo_commands {
+	ARVO_COMMAND_MODE_KEY = 0x3,
+	ARVO_COMMAND_BUTTON = 0x4,
+	ARVO_COMMAND_INFO = 0x5,
+	ARVO_COMMAND_KEY_MASK = 0x6,
+	ARVO_COMMAND_ACTUAL_PROFILE = 0x7,
+};
+
+enum arvo_usb_commands {
+	ARVO_USB_COMMAND_MODE_KEY = 0x303,
+	/*
+	 * read/write
+	 * Read uses both index bytes as profile/key indexes
+	 * Write has index 0, profile/key is determined by payload
+	 */
+	ARVO_USB_COMMAND_BUTTON = 0x304,
+	ARVO_USB_COMMAND_INFO = 0x305,
+	ARVO_USB_COMMAND_KEY_MASK = 0x306,
+	ARVO_USB_COMMAND_ACTUAL_PROFILE = 0x307,
+};
+
+struct arvo_special_report {
+	uint8_t unknown1; /* always 0x01 */
+	uint8_t event;
+	uint8_t unknown2; /* always 0x70 */
+} __packed;
+
+enum arvo_special_report_events {
+	ARVO_SPECIAL_REPORT_EVENT_ACTION_PRESS = 0x10,
+	ARVO_SPECIAL_REPORT_EVENT_ACTION_RELEASE = 0x0,
+};
+
+enum arvo_special_report_event_masks {
+	ARVO_SPECIAL_REPORT_EVENT_MASK_ACTION = 0xf0,
+	ARVO_SPECIAL_REPORT_EVENT_MASK_BUTTON = 0x0f,
+};
+
+struct arvo_roccat_report {
+	uint8_t profile;
+	uint8_t button;
+	uint8_t action;
+} __packed;
+
+enum arvo_roccat_report_action {
+	ARVO_ROCCAT_REPORT_ACTION_RELEASE = 0,
+	ARVO_ROCCAT_REPORT_ACTION_PRESS = 1,
+};
+
+struct arvo_device {
+	int roccat_claimed;
+	int chrdev_minor;
+
+	struct mutex arvo_lock;
+
+	int actual_profile;
+};
+
+#endif
-- 
1.7.3.4



