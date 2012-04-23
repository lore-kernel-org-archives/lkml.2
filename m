Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2DWKEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:04:45 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:60836 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2DWKEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:04:43 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArldAAQolU9V5qnhPGdsb2JhbABEiiqnGRkBAQEBHhkNJ4IKAQVWEwEBDhAIETg5ChQGE4gTuXQTkSAEm32NJg
X-IronPort-AV: E=Sophos;i="4.75,466,1330902000"; 
   d="scan'208";a="101375927"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        Gustavo Padovan <gustavo@padovan.org>
Subject: [PATCH 6/6] hid: Create a common generic driver
Date: Mon, 23 Apr 2012 12:07:07 +0200
Message-Id: <1335175627-2270-7-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the hid drivers of the bus drivers to a common generic hid
driver, and make it a proper module. This ought to simplify device
handling moving forward.

Cc: Gustavo Padovan <gustavo@padovan.org>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/Kconfig           |   12 ++++++++++
 drivers/hid/Makefile          |    2 ++
 drivers/hid/hid-generic.c     |   53 +++++++++++++++++++++++++++++++++++++++++
 drivers/hid/usbhid/hid-core.c |   16 -------------
 net/bluetooth/hidp/core.c     |   27 +--------------------
 5 files changed, 68 insertions(+), 42 deletions(-)
 create mode 100644 drivers/hid/hid-generic.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index ffddcba..9a581e1 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -60,6 +60,18 @@ source "drivers/hid/usbhid/Kconfig"
 menu "Special HID drivers"
 	depends on HID
 
+config HID_GENERIC
+	tristate "Generic HID driver"
+	depends on HID
+	default y
+	---help---
+	Support for generic HID devices.
+
+	To compile this driver as a module, choose M here: the module
+	will be called hid-generic.
+
+	If unsure, say Y.
+
 config HID_A4TECH
 	tristate "A4 tech mice" if EXPERT
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 22f1d16..a04cffa 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -9,6 +9,8 @@ endif
 
 obj-$(CONFIG_HID)		+= hid.o
 
+obj-$(CONFIG_HID_GENERIC)	+= hid-generic.o
+
 hid-$(CONFIG_HIDRAW)		+= hidraw.o
 
 hid-logitech-y		:= hid-lg.o
diff --git a/drivers/hid/hid-generic.c b/drivers/hid/hid-generic.c
new file mode 100644
index 0000000..a8b3148
--- /dev/null
+++ b/drivers/hid/hid-generic.c
@@ -0,0 +1,53 @@
+/*
+ *  HID support for Linux
+ *
+ *  Copyright (c) 1999 Andreas Gal
+ *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
+ *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
+ *  Copyright (c) 2007-2008 Oliver Neukum
+ *  Copyright (c) 2006-2012 Jiri Kosina
+ *  Copyright (c) 2012 Henrik Rydberg
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <asm/unaligned.h>
+#include <asm/byteorder.h>
+
+#include <linux/hid.h>
+
+static const struct hid_device_id hid_table[] = {
+	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_GENERIC, HID_ANY_ID, HID_ANY_ID) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, hid_table);
+
+static struct hid_driver hid_generic = {
+	.name = "hid-generic",
+	.id_table = hid_table,
+};
+
+static int __init hid_init(void)
+{
+	return hid_register_driver(&hid_generic);
+}
+
+static void __exit hid_exit(void)
+{
+	hid_unregister_driver(&hid_generic);
+}
+
+module_init(hid_init);
+module_exit(hid_exit);
+
+MODULE_AUTHOR("Henrik Rydberg");
+MODULE_DESCRIPTION("HID generic driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 9abf718..9cba500 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1504,28 +1504,15 @@ static struct usb_driver hid_driver = {
 	.supports_autosuspend = 1,
 };
 
-static const struct hid_device_id hid_usb_table[] = {
-	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC, HID_ANY_ID, HID_ANY_ID) },
-	{ }
-};
-
 struct usb_interface *usbhid_find_interface(int minor)
 {
 	return usb_find_interface(&hid_driver, minor);
 }
 
-static struct hid_driver hid_usb_driver = {
-	.name = "generic-usb",
-	.id_table = hid_usb_table,
-};
-
 static int __init hid_init(void)
 {
 	int retval = -ENOMEM;
 
-	retval = hid_register_driver(&hid_usb_driver);
-	if (retval)
-		goto hid_register_fail;
 	retval = usbhid_quirks_init(quirks_param);
 	if (retval)
 		goto usbhid_quirks_init_fail;
@@ -1538,8 +1525,6 @@ static int __init hid_init(void)
 usb_register_fail:
 	usbhid_quirks_exit();
 usbhid_quirks_init_fail:
-	hid_unregister_driver(&hid_usb_driver);
-hid_register_fail:
 	return retval;
 }
 
@@ -1547,7 +1532,6 @@ static void __exit hid_exit(void)
 {
 	usb_deregister(&hid_driver);
 	usbhid_quirks_exit();
-	hid_unregister_driver(&hid_usb_driver);
 }
 
 module_init(hid_init);
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index b6fa982..2c20d76 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -1195,41 +1195,16 @@ int hidp_get_conninfo(struct hidp_conninfo *ci)
 	return err;
 }
 
-static const struct hid_device_id hidp_table[] = {
-	{ HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_GENERIC, HID_ANY_ID, HID_ANY_ID) },
-	{ }
-};
-
-static struct hid_driver hidp_driver = {
-	.name = "generic-bluetooth",
-	.id_table = hidp_table,
-};
-
 static int __init hidp_init(void)
 {
-	int ret;
-
 	BT_INFO("HIDP (Human Interface Emulation) ver %s", VERSION);
 
-	ret = hid_register_driver(&hidp_driver);
-	if (ret)
-		goto err;
-
-	ret = hidp_init_sockets();
-	if (ret)
-		goto err_drv;
-
-	return 0;
-err_drv:
-	hid_unregister_driver(&hidp_driver);
-err:
-	return ret;
+	return hidp_init_sockets();
 }
 
 static void __exit hidp_exit(void)
 {
 	hidp_cleanup_sockets();
-	hid_unregister_driver(&hidp_driver);
 }
 
 module_init(hidp_init);
-- 
1.7.10

