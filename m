Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2JPPkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:40:20 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:42862 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755187Ab2JPPkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:40:13 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net 799595A9B6
Subject: [PATCH] HID: roccat: Added support for Roccat Lua
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Oct 2012 17:40:09 +0200
Message-ID: <1350402009.3151.0.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Roccat Lua gaming mouse.

Userland tools can soon be found at http://sourceforge.net/projects/roccat

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-lua        |    7 +
 drivers/hid/Makefile                               |    4 +-
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-roccat-lua.c                       |  227 ++++++++++++++++++++
 drivers/hid/hid-roccat-lua.h                       |   29 +++
 6 files changed, 267 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-lua
 create mode 100644 drivers/hid/hid-roccat-lua.c
 create mode 100644 drivers/hid/hid-roccat-lua.h

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-lua b/Documentation/ABI/testing/sysfs-driver-hid-roccat-lua
new file mode 100644
index 0000000..31c6c4c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-lua
@@ -0,0 +1,7 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/control
+Date:		October 2012
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When written, cpi, button and light settings can be configured.
+		When read, actual cpi setting and sensor data are returned.
+		The data has to be 8 bytes long.
+Users:		http://roccat.sourceforge.net
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index cef68ca..ffe848f 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -93,8 +93,8 @@ obj-$(CONFIG_HID_PRIMAX)	+= hid-primax.o
 obj-$(CONFIG_HID_PS3REMOTE)	+= hid-ps3remote.o
 obj-$(CONFIG_HID_ROCCAT)	+= hid-roccat.o hid-roccat-common.o \
 	hid-roccat-arvo.o hid-roccat-isku.o hid-roccat-kone.o \
-	hid-roccat-koneplus.o hid-roccat-kovaplus.o hid-roccat-pyra.o \
-	hid-roccat-savu.o
+	hid-roccat-koneplus.o hid-roccat-kovaplus.o hid-roccat-lua.o \
+	hid-roccat-pyra.o hid-roccat-savu.o
 obj-$(CONFIG_HID_SAITEK)	+= hid-saitek.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SMARTJOYPLUS)	+= hid-sjoy.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index bd3971b..9904776 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1655,6 +1655,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_ISKU) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONEPLUS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KOVAPLUS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_LUA) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRED) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_PYRA_WIRELESS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_SAVU) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 269b509..52b27b1 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -675,6 +675,7 @@
 #define USB_DEVICE_ID_ROCCAT_KONE	0x2ced
 #define USB_DEVICE_ID_ROCCAT_KONEPLUS	0x2d51
 #define USB_DEVICE_ID_ROCCAT_KOVAPLUS	0x2d50
+#define USB_DEVICE_ID_ROCCAT_LUA	0x2c2e
 #define USB_DEVICE_ID_ROCCAT_PYRA_WIRED	0x2c24
 #define USB_DEVICE_ID_ROCCAT_PYRA_WIRELESS	0x2cf6
 #define USB_DEVICE_ID_ROCCAT_SAVU	0x2d5a
diff --git a/drivers/hid/hid-roccat-lua.c b/drivers/hid/hid-roccat-lua.c
new file mode 100644
index 0000000..5084fb4
--- /dev/null
+++ b/drivers/hid/hid-roccat-lua.c
@@ -0,0 +1,227 @@
+/*
+ * Roccat Lua driver for Linux
+ *
+ * Copyright (c) 2012 Stefan Achatz <erazor_de@users.sourceforge.net>
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
+ * Roccat Lua is a gamer mouse which cpi, button and light settings can be
+ * configured.
+ */
+
+#include <linux/device.h>
+#include <linux/input.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/hid-roccat.h>
+#include "hid-ids.h"
+#include "hid-roccat-common.h"
+#include "hid-roccat-lua.h"
+
+static ssize_t lua_sysfs_read(struct file *fp, struct kobject *kobj,
+		char *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct lua_device *lua = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+
+	if (off >= real_size)
+		return 0;
+
+	if (off != 0 || count != real_size)
+		return -EINVAL;
+
+	mutex_lock(&lua->lua_lock);
+	retval = roccat_common2_receive(usb_dev, command, buf, real_size);
+	mutex_unlock(&lua->lua_lock);
+
+	return retval ? retval : real_size;
+}
+
+static ssize_t lua_sysfs_write(struct file *fp, struct kobject *kobj,
+		void const *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct lua_device *lua = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+
+	if (off != 0 || count != real_size)
+		return -EINVAL;
+
+	mutex_lock(&lua->lua_lock);
+	retval = roccat_common2_send(usb_dev, command, (void *)buf, real_size);
+	mutex_unlock(&lua->lua_lock);
+
+	return retval ? retval : real_size;
+}
+
+#define LUA_SYSFS_W(thingy, THINGY) \
+static ssize_t lua_sysfs_write_ ## thingy(struct file *fp, \
+		struct kobject *kobj, struct bin_attribute *attr, \
+		char *buf, loff_t off, size_t count) \
+{ \
+	return lua_sysfs_write(fp, kobj, buf, off, count, \
+			LUA_SIZE_ ## THINGY, LUA_COMMAND_ ## THINGY); \
+}
+
+#define LUA_SYSFS_R(thingy, THINGY) \
+static ssize_t lua_sysfs_read_ ## thingy(struct file *fp, \
+		struct kobject *kobj, struct bin_attribute *attr, \
+		char *buf, loff_t off, size_t count) \
+{ \
+	return lua_sysfs_read(fp, kobj, buf, off, count, \
+			LUA_SIZE_ ## THINGY, LUA_COMMAND_ ## THINGY); \
+}
+
+#define LUA_BIN_ATTRIBUTE_RW(thingy, THINGY) \
+LUA_SYSFS_W(thingy, THINGY) \
+LUA_SYSFS_R(thingy, THINGY) \
+static struct bin_attribute lua_ ## thingy ## _attr = { \
+	.attr = { .name = #thingy, .mode = 0660 }, \
+	.size = LUA_SIZE_ ## THINGY, \
+	.read = lua_sysfs_read_ ## thingy, \
+	.write = lua_sysfs_write_ ## thingy \
+};
+
+LUA_BIN_ATTRIBUTE_RW(control, CONTROL)
+
+static int lua_create_sysfs_attributes(struct usb_interface *intf)
+{
+	return sysfs_create_bin_file(&intf->dev.kobj, &lua_control_attr);
+}
+
+static void lua_remove_sysfs_attributes(struct usb_interface *intf)
+{
+	sysfs_remove_bin_file(&intf->dev.kobj, &lua_control_attr);
+}
+
+static int lua_init_lua_device_struct(struct usb_device *usb_dev,
+		struct lua_device *lua)
+{
+	mutex_init(&lua->lua_lock);
+
+	return 0;
+}
+
+static int lua_init_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct lua_device *lua;
+	int retval;
+
+	lua = kzalloc(sizeof(*lua), GFP_KERNEL);
+	if (!lua) {
+		hid_err(hdev, "can't alloc device descriptor\n");
+		return -ENOMEM;
+	}
+	hid_set_drvdata(hdev, lua);
+
+	retval = lua_init_lua_device_struct(usb_dev, lua);
+	if (retval) {
+		hid_err(hdev, "couldn't init struct lua_device\n");
+		goto exit;
+	}
+
+	retval = lua_create_sysfs_attributes(intf);
+	if (retval) {
+		hid_err(hdev, "cannot create sysfs files\n");
+		goto exit;
+	}
+
+	return 0;
+exit:
+	kfree(lua);
+	return retval;
+}
+
+static void lua_remove_specials(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct lua_device *lua;
+
+	lua_remove_sysfs_attributes(intf);
+
+	lua = hid_get_drvdata(hdev);
+	kfree(lua);
+}
+
+static int lua_probe(struct hid_device *hdev,
+		const struct hid_device_id *id)
+{
+	int retval;
+
+	retval = hid_parse(hdev);
+	if (retval) {
+		hid_err(hdev, "parse failed\n");
+		goto exit;
+	}
+
+	retval = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (retval) {
+		hid_err(hdev, "hw start failed\n");
+		goto exit;
+	}
+
+	retval = lua_init_specials(hdev);
+	if (retval) {
+		hid_err(hdev, "couldn't install mouse\n");
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
+static void lua_remove(struct hid_device *hdev)
+{
+	lua_remove_specials(hdev);
+	hid_hw_stop(hdev);
+}
+
+static const struct hid_device_id lua_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_LUA) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(hid, lua_devices);
+
+static struct hid_driver lua_driver = {
+		.name = "lua",
+		.id_table = lua_devices,
+		.probe = lua_probe,
+		.remove = lua_remove
+};
+
+static int __init lua_init(void)
+{
+	return hid_register_driver(&lua_driver);
+}
+
+static void __exit lua_exit(void)
+{
+	hid_unregister_driver(&lua_driver);
+}
+
+module_init(lua_init);
+module_exit(lua_exit);
+
+MODULE_AUTHOR("Stefan Achatz");
+MODULE_DESCRIPTION("USB Roccat Lua driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-roccat-lua.h b/drivers/hid/hid-roccat-lua.h
new file mode 100644
index 0000000..547d77a
--- /dev/null
+++ b/drivers/hid/hid-roccat-lua.h
@@ -0,0 +1,29 @@
+#ifndef __HID_ROCCAT_LUA_H
+#define __HID_ROCCAT_LUA_H
+
+/*
+ * Copyright (c) 2012 Stefan Achatz <erazor_de@users.sourceforge.net>
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
+enum {
+	LUA_SIZE_CONTROL = 8,
+};
+
+enum lua_commands {
+	LUA_COMMAND_CONTROL = 3,
+};
+
+struct lua_device {
+	struct mutex lua_lock;
+};
+
+#endif
-- 
1.7.3.4




