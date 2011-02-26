Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab1BZJWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 04:22:33 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:45895 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab1BZJWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 04:22:23 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.35
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <rdunlap@xenotime.net> (maintainer:DOCUMENTATION),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        platform-driver-x86@vger.kernel.org (open list:X86 PLATFORM DRIVERS),
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...)
Subject: [PATCH 02/14] eeepc-wmi: asus generic asus-wmi.ko module
Date: Sat, 26 Feb 2011 10:20:31 +0100
Message-Id: <1298712045-17671-3-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
References: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New Asus notebooks are using a WMI device similar to
the one used in Eee PCs. Since we don't want to load
eeepc-wmi module on Asus notebooks, and we want to
keep the eeepc-wmi module for backward compatibility,
this patch introduce a new module, named asus-wmi, that
will be used by eeepc-wmi and the new Asus Notebook WMI
Driver.

eeepc-wmi's input device strings (device name and phys)
are kept, but rfkill and led names are changed (s/eeepc/asus/).
This should not break anything since rfkill are used by type or
index, not by name, and the eeepc::touchpad led wasn't working
correctly before 2.6.39 anyway.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 Documentation/ABI/testing/sysfs-platform-asus-wmi  |   31 +
 Documentation/ABI/testing/sysfs-platform-eeepc-wmi |   31 -
 drivers/platform/x86/Kconfig                       |   24 +-
 drivers/platform/x86/Makefile                      |    3 +-
 drivers/platform/x86/asus-wmi.c                    |  924 +++++++++-----------
 drivers/platform/x86/asus-wmi.h                    |   58 ++
 drivers/platform/x86/eeepc-wmi.c                   |  162 ++++
 7 files changed, 708 insertions(+), 525 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-asus-wmi
 delete mode 100644 Documentation/ABI/testing/sysfs-platform-eeepc-wmi
 create mode 100644 drivers/platform/x86/asus-wmi.h
 create mode 100644 drivers/platform/x86/eeepc-wmi.c

diff --git a/Documentation/ABI/testing/sysfs-platform-asus-wmi b/Documentation/ABI/testing/sysfs-platform-asus-wmi
new file mode 100644
index 0000000..2e7df91
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-asus-wmi
@@ -0,0 +1,31 @@
+What:		/sys/devices/platform/<platform>/cpufv
+Date:		Oct 2010
+KernelVersion:	2.6.37
+Contact:	"Corentin Chary" <corentincj@iksaif.net>
+Description:
+		Change CPU clock configuration (write-only).
+		There are three available clock configuration:
+		    * 0 -> Super Performance Mode
+		    * 1 -> High Performance Mode
+		    * 2 -> Power Saving Mode
+
+What:		/sys/devices/platform/<platform>/camera
+Date:		Jan 2010
+KernelVersion:	2.6.39
+Contact:	"Corentin Chary" <corentincj@iksaif.net>
+Description:
+		Control the camera. 1 means on, 0 means off.
+
+What:		/sys/devices/platform/<platform>/cardr
+Date:		Jan 2010
+KernelVersion:	2.6.39
+Contact:	"Corentin Chary" <corentincj@iksaif.net>
+Description:
+		Control the card reader. 1 means on, 0 means off.
+
+What:		/sys/devices/platform/<platform>/touchpad
+Date:		Jan 2010
+KernelVersion:	2.6.39
+Contact:	"Corentin Chary" <corentincj@iksaif.net>
+Description:
+		Control the card touchpad. 1 means on, 0 means off.
diff --git a/Documentation/ABI/testing/sysfs-platform-eeepc-wmi b/Documentation/ABI/testing/sysfs-platform-eeepc-wmi
deleted file mode 100644
index 26acb68..0000000
--- a/Documentation/ABI/testing/sysfs-platform-eeepc-wmi
+++ /dev/null
@@ -1,31 +0,0 @@
-What:		/sys/devices/platform/eeepc-wmi/cpufv
-Date:		Oct 2010
-KernelVersion:	2.6.37
-Contact:	"Corentin Chary" <corentincj@iksaif.net>
-Description:
-		Change CPU clock configuration (write-only).
-		There are three available clock configuration:
-		    * 0 -> Super Performance Mode
-		    * 1 -> High Performance Mode
-		    * 2 -> Power Saving Mode
-
-What:		/sys/devices/platform/eeepc-wmi/camera
-Date:		Jan 2010
-KernelVersion:	2.6.39
-Contact:	"Corentin Chary" <corentincj@iksaif.net>
-Description:
-		Control the camera. 1 means on, 0 means off.
-
-What:		/sys/devices/platform/eeepc-wmi/cardr
-Date:		Jan 2010
-KernelVersion:	2.6.39
-Contact:	"Corentin Chary" <corentincj@iksaif.net>
-Description:
-		Control the card reader. 1 means on, 0 means off.
-
-What:		/sys/devices/platform/eeepc-wmi/touchpad
-Date:		Jan 2010
-KernelVersion:	2.6.39
-Contact:	"Corentin Chary" <corentincj@iksaif.net>
-Description:
-		Control the card touchpad. 1 means on, 0 means off.
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 906e1fb..22e5225 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -433,10 +433,11 @@ config EEEPC_LAPTOP
 	  Bluetooth, backlight and allows powering on/off some other
 	  devices.
 
-	  If you have an Eee PC laptop, say Y or M here.
+	  If you have an Eee PC laptop, say Y or M here. If this driver
+	  doesn't work on your Eee PC, try eeepc-wmi instead.
 
-config EEEPC_WMI
-	tristate "Eee PC WMI Hotkey Driver (EXPERIMENTAL)"
+config ASUS_WMI
+	tristate "ASUS WMI Driver (EXPERIMENTAL)"
 	depends on ACPI_WMI
 	depends on INPUT
 	depends on EXPERIMENTAL
@@ -446,10 +447,23 @@ config EEEPC_WMI
 	select LEDS_CLASS
 	select NEW_LEDS
 	---help---
-	  Say Y here if you want to support WMI-based hotkeys on Eee PC laptops.
+	  Say Y here if you have a WMI aware Asus laptop (like Eee PCs).
 
 	  To compile this driver as a module, choose M here: the module will
-	  be called eeepc-wmi.
+	  be called asus-wmi.
+
+config EEEPC_WMI
+	tristate "Eee PC WMI Driver (EXPERIMENTAL)"
+	depends on ASUS_WMI
+	---help---
+	  This is a driver for newer Eee PC laptops. It adds extra features
+	  like wireless radio and bluetooth control, leds, hotkeys, backlight...
+
+	  For more informations, see
+	  <file:Documentation/ABI/testing/sysfs-platform-asus-wmi>
+
+	  If you have an ACPI-WMI compatible Eee PC laptop (>= 1000), say Y or M
+	  here.
 
 config ACPI_WMI
 	tristate "WMI"
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 3672b04..f8d35f1 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -3,8 +3,9 @@
 # x86 Platform-Specific Drivers
 #
 obj-$(CONFIG_ASUS_LAPTOP)	+= asus-laptop.o
+obj-$(CONFIG_ASUS_WMI)		+= asus-wmi.o
 obj-$(CONFIG_EEEPC_LAPTOP)	+= eeepc-laptop.o
-obj-$(CONFIG_EEEPC_WMI)		+= asus-wmi.o eeepc-wmi.o
+obj-$(CONFIG_EEEPC_WMI)		+= eeepc-wmi.o
 obj-$(CONFIG_MSI_LAPTOP)	+= msi-laptop.o
 obj-$(CONFIG_ACPI_CMPC)		+= classmate-laptop.o
 obj-$(CONFIG_COMPAL_LAPTOP)	+= compal-laptop.o
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index d399775..35e6bb6 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1,5 +1,5 @@
 /*
- * Eee PC WMI hotkey driver
+ * Asus PC WMI hotkey driver
  *
  * Copyright(C) 2010 Intel Corporation.
  * Copyright(C) 2010 Corentin Chary <corentin.chary@gmail.com>
@@ -42,23 +42,23 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/platform_device.h>
-#include <linux/dmi.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
-#define	EEEPC_WMI_FILE	"eeepc-wmi"
+#include "asus-wmi.h"
 
-MODULE_AUTHOR("Yong Wang <yong.y.wang@intel.com>");
-MODULE_DESCRIPTION("Eee PC WMI Hotkey Driver");
+MODULE_AUTHOR("Corentin Chary <corentincj@iksaif.net>, "
+	      "Yong Wang <yong.y.wang@intel.com>");
+MODULE_DESCRIPTION("Asus Generic WMI Driver");
 MODULE_LICENSE("GPL");
 
-#define EEEPC_ACPI_HID		"ASUS010" /* old _HID used in eeepc-laptop */
+#define to_platform_driver(drv)					\
+	(container_of((drv), struct platform_driver, driver))
 
-#define EEEPC_WMI_EVENT_GUID	"ABBC0F72-8EA1-11D1-00A0-C90629100000"
-#define EEEPC_WMI_MGMT_GUID	"97845ED0-4E6D-11DE-8A39-0800200C9A66"
+#define to_asus_wmi_driver(pdrv)					\
+	(container_of((pdrv), struct asus_wmi_driver, platform_driver))
 
-MODULE_ALIAS("wmi:"EEEPC_WMI_EVENT_GUID);
-MODULE_ALIAS("wmi:"EEEPC_WMI_MGMT_GUID);
+#define ASUS_WMI_MGMT_GUID	"97845ED0-4E6D-11DE-8A39-0800200C9A66"
 
 #define NOTIFY_BRNUP_MIN		0x11
 #define NOTIFY_BRNUP_MAX		0x1f
@@ -66,90 +66,55 @@ MODULE_ALIAS("wmi:"EEEPC_WMI_MGMT_GUID);
 #define NOTIFY_BRNDOWN_MAX		0x2e
 
 /* WMI Methods */
-#define EEEPC_WMI_METHODID_DSTS		0x53544344
-#define EEEPC_WMI_METHODID_DEVS		0x53564544
-#define EEEPC_WMI_METHODID_CFVS		0x53564643
+#define ASUS_WMI_METHODID_DSTS		0x53544344
+#define ASUS_WMI_METHODID_DEVS		0x53564544
+#define ASUS_WMI_METHODID_CFVS		0x53564643
 
 /* Wireless */
-#define EEEPC_WMI_DEVID_WLAN		0x00010011
-#define EEEPC_WMI_DEVID_BLUETOOTH	0x00010013
-#define EEEPC_WMI_DEVID_WIMAX		0x00010017
-#define EEEPC_WMI_DEVID_WWAN3G		0x00010019
+#define ASUS_WMI_DEVID_WLAN		0x00010011
+#define ASUS_WMI_DEVID_BLUETOOTH	0x00010013
+#define ASUS_WMI_DEVID_WIMAX		0x00010017
+#define ASUS_WMI_DEVID_WWAN3G		0x00010019
 
 /* Backlight and Brightness */
-#define EEEPC_WMI_DEVID_BACKLIGHT	0x00050011
-#define EEEPC_WMI_DEVID_BRIGHTNESS	0x00050012
+#define ASUS_WMI_DEVID_BACKLIGHT	0x00050011
+#define ASUS_WMI_DEVID_BRIGHTNESS	0x00050012
 
 /* Misc */
-#define EEEPC_WMI_DEVID_CAMERA		0x00060013
+#define ASUS_WMI_DEVID_CAMERA		0x00060013
 
 /* Storage */
-#define EEEPC_WMI_DEVID_CARDREADER	0x00080013
+#define ASUS_WMI_DEVID_CARDREADER	0x00080013
 
 /* Input */
-#define EEEPC_WMI_DEVID_TOUCHPAD	0x00100011
-#define EEEPC_WMI_DEVID_TOUCHPAD_LED	0x00100012
+#define ASUS_WMI_DEVID_TOUCHPAD	0x00100011
+#define ASUS_WMI_DEVID_TOUCHPAD_LED	0x00100012
 
 /* DSTS masks */
-#define EEEPC_WMI_DSTS_STATUS_BIT	0x00000001
-#define EEEPC_WMI_DSTS_PRESENCE_BIT	0x00010000
-#define EEEPC_WMI_DSTS_BRIGHTNESS_MASK	0x000000FF
-#define EEEPC_WMI_DSTS_MAX_BRIGTH_MASK	0x0000FF00
-
-static bool hotplug_wireless;
-
-module_param(hotplug_wireless, bool, 0444);
-MODULE_PARM_DESC(hotplug_wireless,
-		 "Enable hotplug for wireless device. "
-		 "If your laptop needs that, please report to "
-		 "acpi4asus-user@lists.sourceforge.net.");
-
-static const struct key_entry eeepc_wmi_keymap[] = {
-	/* Sleep already handled via generic ACPI code */
-	{ KE_IGNORE, NOTIFY_BRNDOWN_MIN, { KEY_BRIGHTNESSDOWN } },
-	{ KE_IGNORE, NOTIFY_BRNUP_MIN, { KEY_BRIGHTNESSUP } },
-	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
-	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
-	{ KE_KEY, 0x32, { KEY_MUTE } },
-	{ KE_KEY, 0x5c, { KEY_F15 } }, /* Power Gear key */
-	{ KE_KEY, 0x5d, { KEY_WLAN } },
-	{ KE_KEY, 0x6b, { KEY_F13 } }, /* Disable Touchpad */
-	{ KE_KEY, 0x82, { KEY_CAMERA } },
-	{ KE_KEY, 0x83, { KEY_CAMERA_ZOOMIN } },
-	{ KE_KEY, 0x88, { KEY_WLAN } },
-	{ KE_KEY, 0xcc, { KEY_SWITCHVIDEOMODE } },
-	{ KE_KEY, 0xe0, { KEY_PROG1 } }, /* Task Manager */
-	{ KE_KEY, 0xe1, { KEY_F14 } }, /* Change Resolution */
-	{ KE_KEY, 0xe9, { KEY_BRIGHTNESS_ZERO } },
-	{ KE_KEY, 0xeb, { KEY_CAMERA_ZOOMOUT } },
-	{ KE_KEY, 0xec, { KEY_CAMERA_UP } },
-	{ KE_KEY, 0xed, { KEY_CAMERA_DOWN } },
-	{ KE_KEY, 0xee, { KEY_CAMERA_LEFT } },
-	{ KE_KEY, 0xef, { KEY_CAMERA_RIGHT } },
-	{ KE_END, 0},
-};
+#define ASUS_WMI_DSTS_STATUS_BIT	0x00000001
+#define ASUS_WMI_DSTS_PRESENCE_BIT	0x00010000
+#define ASUS_WMI_DSTS_BRIGHTNESS_MASK	0x000000FF
+#define ASUS_WMI_DSTS_MAX_BRIGTH_MASK	0x0000FF00
 
 struct bios_args {
-	u32	dev_id;
-	u32	ctrl_param;
+	u32 dev_id;
+	u32 ctrl_param;
 };
 
 /*
- * eeepc-wmi/    - debugfs root directory
+ * <platform>/    - debugfs root directory
  *   dev_id      - current dev_id
  *   ctrl_param  - current ctrl_param
  *   devs        - call DEVS(dev_id, ctrl_param) and print result
  *   dsts        - call DSTS(dev_id)  and print result
  */
-struct eeepc_wmi_debug {
+struct asus_wmi_debug {
 	struct dentry *root;
 	u32 dev_id;
 	u32 ctrl_param;
 };
 
-struct eeepc_wmi {
-	bool hotplug_wireless;
-
+struct asus_wmi {
 	struct input_dev *inputdev;
 	struct backlight_device *backlight_device;
 	struct platform_device *platform_device;
@@ -170,59 +135,61 @@ struct eeepc_wmi {
 	struct workqueue_struct *hotplug_workqueue;
 	struct work_struct hotplug_work;
 
-	struct eeepc_wmi_debug debug;
+	struct asus_wmi_debug debug;
+
+	struct asus_wmi_driver *driver;
 };
 
-static int eeepc_wmi_input_init(struct eeepc_wmi *eeepc)
+static int asus_wmi_input_init(struct asus_wmi *asus)
 {
 	int err;
 
-	eeepc->inputdev = input_allocate_device();
-	if (!eeepc->inputdev)
+	asus->inputdev = input_allocate_device();
+	if (!asus->inputdev)
 		return -ENOMEM;
 
-	eeepc->inputdev->name = "Eee PC WMI hotkeys";
-	eeepc->inputdev->phys = EEEPC_WMI_FILE "/input0";
-	eeepc->inputdev->id.bustype = BUS_HOST;
-	eeepc->inputdev->dev.parent = &eeepc->platform_device->dev;
+	asus->inputdev->name = asus->driver->input_phys;
+	asus->inputdev->phys = asus->driver->input_name;
+	asus->inputdev->id.bustype = BUS_HOST;
+	asus->inputdev->dev.parent = &asus->platform_device->dev;
 
-	err = sparse_keymap_setup(eeepc->inputdev, eeepc_wmi_keymap, NULL);
+	err = sparse_keymap_setup(asus->inputdev, asus->driver->keymap, NULL);
 	if (err)
 		goto err_free_dev;
 
-	err = input_register_device(eeepc->inputdev);
+	err = input_register_device(asus->inputdev);
 	if (err)
 		goto err_free_keymap;
 
 	return 0;
 
 err_free_keymap:
-	sparse_keymap_free(eeepc->inputdev);
+	sparse_keymap_free(asus->inputdev);
 err_free_dev:
-	input_free_device(eeepc->inputdev);
+	input_free_device(asus->inputdev);
 	return err;
 }
 
-static void eeepc_wmi_input_exit(struct eeepc_wmi *eeepc)
+static void asus_wmi_input_exit(struct asus_wmi *asus)
 {
-	if (eeepc->inputdev) {
-		sparse_keymap_free(eeepc->inputdev);
-		input_unregister_device(eeepc->inputdev);
+	if (asus->inputdev) {
+		sparse_keymap_free(asus->inputdev);
+		input_unregister_device(asus->inputdev);
 	}
 
-	eeepc->inputdev = NULL;
+	asus->inputdev = NULL;
 }
 
-static acpi_status eeepc_wmi_get_devstate(u32 dev_id, u32 *retval)
+static acpi_status asus_wmi_get_devstate(u32 dev_id, u32 *retval)
 {
-	struct acpi_buffer input = { (acpi_size)sizeof(u32), &dev_id };
+	struct acpi_buffer input = { (acpi_size) sizeof(u32), &dev_id };
 	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
 	acpi_status status;
 	u32 tmp;
 
-	status = wmi_evaluate_method(EEEPC_WMI_MGMT_GUID,
-				     1, EEEPC_WMI_METHODID_DSTS,
+	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
+				     1, ASUS_WMI_METHODID_DSTS,
 				     &input, &output);
 
 	if (ACPI_FAILURE(status))
@@ -230,7 +197,7 @@ static acpi_status eeepc_wmi_get_devstate(u32 dev_id, u32 *retval)
 
 	obj = (union acpi_object *)output.pointer;
 	if (obj && obj->type == ACPI_TYPE_INTEGER)
-		tmp = (u32)obj->integer.value;
+		tmp = (u32) obj->integer.value;
 	else
 		tmp = 0;
 
@@ -243,27 +210,27 @@ static acpi_status eeepc_wmi_get_devstate(u32 dev_id, u32 *retval)
 
 }
 
-static acpi_status eeepc_wmi_set_devstate(u32 dev_id, u32 ctrl_param,
-					  u32 *retval)
+static acpi_status asus_wmi_set_devstate(u32 dev_id, u32 ctrl_param,
+					 u32 *retval)
 {
 	struct bios_args args = {
 		.dev_id = dev_id,
 		.ctrl_param = ctrl_param,
 	};
-	struct acpi_buffer input = { (acpi_size)sizeof(args), &args };
+	struct acpi_buffer input = { (acpi_size) sizeof(args), &args };
 	acpi_status status;
 
 	if (!retval) {
-		status = wmi_evaluate_method(EEEPC_WMI_MGMT_GUID, 1,
-					     EEEPC_WMI_METHODID_DEVS,
+		status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 1,
+					     ASUS_WMI_METHODID_DEVS,
 					     &input, NULL);
 	} else {
 		struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
 		union acpi_object *obj;
 		u32 tmp;
 
-		status = wmi_evaluate_method(EEEPC_WMI_MGMT_GUID, 1,
-					     EEEPC_WMI_METHODID_DEVS,
+		status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 1,
+					     ASUS_WMI_METHODID_DEVS,
 					     &input, &output);
 
 		if (ACPI_FAILURE(status))
@@ -271,7 +238,7 @@ static acpi_status eeepc_wmi_set_devstate(u32 dev_id, u32 ctrl_param,
 
 		obj = (union acpi_object *)output.pointer;
 		if (obj && obj->type == ACPI_TYPE_INTEGER)
-			tmp = (u32)obj->integer.value;
+			tmp = (u32) obj->integer.value;
 		else
 			tmp = 0;
 
@@ -284,25 +251,25 @@ static acpi_status eeepc_wmi_set_devstate(u32 dev_id, u32 ctrl_param,
 }
 
 /* Helper for special devices with magic return codes */
-static int eeepc_wmi_get_devstate_bits(u32 dev_id, u32 mask)
+static int asus_wmi_get_devstate_bits(u32 dev_id, u32 mask)
 {
 	u32 retval = 0;
 	acpi_status status;
 
-	status = eeepc_wmi_get_devstate(dev_id, &retval);
+	status = asus_wmi_get_devstate(dev_id, &retval);
 
 	if (ACPI_FAILURE(status))
 		return -EINVAL;
 
-	if (!(retval & EEEPC_WMI_DSTS_PRESENCE_BIT))
+	if (!(retval & ASUS_WMI_DSTS_PRESENCE_BIT))
 		return -ENODEV;
 
 	return retval & mask;
 }
 
-static int eeepc_wmi_get_devstate_simple(u32 dev_id)
+static int asus_wmi_get_devstate_simple(u32 dev_id)
 {
-	return eeepc_wmi_get_devstate_bits(dev_id, EEEPC_WMI_DSTS_STATUS_BIT);
+	return asus_wmi_get_devstate_bits(dev_id, ASUS_WMI_DSTS_STATUS_BIT);
 }
 
 /*
@@ -311,93 +278,92 @@ static int eeepc_wmi_get_devstate_simple(u32 dev_id)
 /*
  * These functions actually update the LED's, and are called from a
  * workqueue. By doing this as separate work rather than when the LED
- * subsystem asks, we avoid messing with the Eeepc ACPI stuff during a
+ * subsystem asks, we avoid messing with the Asus ACPI stuff during a
  * potentially bad time, such as a timer interrupt.
  */
 static void tpd_led_update(struct work_struct *work)
 {
 	int ctrl_param;
-	struct eeepc_wmi *eeepc;
+	struct asus_wmi *asus;
 
-	eeepc = container_of(work, struct eeepc_wmi, tpd_led_work);
+	asus = container_of(work, struct asus_wmi, tpd_led_work);
 
-	ctrl_param = eeepc->tpd_led_wk;
-	eeepc_wmi_set_devstate(EEEPC_WMI_DEVID_TOUCHPAD_LED, ctrl_param, NULL);
+	ctrl_param = asus->tpd_led_wk;
+	asus_wmi_set_devstate(ASUS_WMI_DEVID_TOUCHPAD_LED, ctrl_param, NULL);
 }
 
 static void tpd_led_set(struct led_classdev *led_cdev,
 			enum led_brightness value)
 {
-	struct eeepc_wmi *eeepc;
+	struct asus_wmi *asus;
 
-	eeepc = container_of(led_cdev, struct eeepc_wmi, tpd_led);
+	asus = container_of(led_cdev, struct asus_wmi, tpd_led);
 
-	eeepc->tpd_led_wk = !!value;
-	queue_work(eeepc->led_workqueue, &eeepc->tpd_led_work);
+	asus->tpd_led_wk = !!value;
+	queue_work(asus->led_workqueue, &asus->tpd_led_work);
 }
 
-static int read_tpd_led_state(struct eeepc_wmi *eeepc)
+static int read_tpd_led_state(struct asus_wmi *asus)
 {
-	return eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_TOUCHPAD_LED);
+	return asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_TOUCHPAD_LED);
 }
 
 static enum led_brightness tpd_led_get(struct led_classdev *led_cdev)
 {
-	struct eeepc_wmi *eeepc;
+	struct asus_wmi *asus;
 
-	eeepc = container_of(led_cdev, struct eeepc_wmi, tpd_led);
+	asus = container_of(led_cdev, struct asus_wmi, tpd_led);
 
-	return read_tpd_led_state(eeepc);
+	return read_tpd_led_state(asus);
 }
 
-static int eeepc_wmi_led_init(struct eeepc_wmi *eeepc)
+static int asus_wmi_led_init(struct asus_wmi *asus)
 {
 	int rv;
 
-	if (read_tpd_led_state(eeepc) < 0)
+	if (read_tpd_led_state(asus) < 0)
 		return 0;
 
-	eeepc->led_workqueue = create_singlethread_workqueue("led_workqueue");
-	if (!eeepc->led_workqueue)
+	asus->led_workqueue = create_singlethread_workqueue("led_workqueue");
+	if (!asus->led_workqueue)
 		return -ENOMEM;
-	INIT_WORK(&eeepc->tpd_led_work, tpd_led_update);
+	INIT_WORK(&asus->tpd_led_work, tpd_led_update);
 
-	eeepc->tpd_led.name = "eeepc::touchpad";
-	eeepc->tpd_led.brightness_set = tpd_led_set;
-	eeepc->tpd_led.brightness_get = tpd_led_get;
-	eeepc->tpd_led.max_brightness = 1;
+	asus->tpd_led.name = "asus::touchpad";
+	asus->tpd_led.brightness_set = tpd_led_set;
+	asus->tpd_led.brightness_get = tpd_led_get;
+	asus->tpd_led.max_brightness = 1;
 
-	rv = led_classdev_register(&eeepc->platform_device->dev,
-				   &eeepc->tpd_led);
+	rv = led_classdev_register(&asus->platform_device->dev, &asus->tpd_led);
 	if (rv) {
-		destroy_workqueue(eeepc->led_workqueue);
+		destroy_workqueue(asus->led_workqueue);
 		return rv;
 	}
 
 	return 0;
 }
 
-static void eeepc_wmi_led_exit(struct eeepc_wmi *eeepc)
+static void asus_wmi_led_exit(struct asus_wmi *asus)
 {
-	if (eeepc->tpd_led.dev)
-		led_classdev_unregister(&eeepc->tpd_led);
-	if (eeepc->led_workqueue)
-		destroy_workqueue(eeepc->led_workqueue);
+	if (asus->tpd_led.dev)
+		led_classdev_unregister(&asus->tpd_led);
+	if (asus->led_workqueue)
+		destroy_workqueue(asus->led_workqueue);
 }
 
 /*
  * PCI hotplug (for wlan rfkill)
  */
-static bool eeepc_wlan_rfkill_blocked(struct eeepc_wmi *eeepc)
+static bool asus_wlan_rfkill_blocked(struct asus_wmi *asus)
 {
-	int result = eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_WLAN);
+	int result = asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_WLAN);
 
 	if (result < 0)
 		return false;
 	return !result;
 }
 
-static void eeepc_rfkill_hotplug(struct eeepc_wmi *eeepc)
+static void asus_rfkill_hotplug(struct asus_wmi *asus)
 {
 	struct pci_dev *dev;
 	struct pci_bus *bus;
@@ -405,16 +371,16 @@ static void eeepc_rfkill_hotplug(struct eeepc_wmi *eeepc)
 	bool absent;
 	u32 l;
 
-	mutex_lock(&eeepc->wmi_lock);
-	blocked = eeepc_wlan_rfkill_blocked(eeepc);
-	mutex_unlock(&eeepc->wmi_lock);
+	mutex_lock(&asus->wmi_lock);
+	blocked = asus_wlan_rfkill_blocked(asus);
+	mutex_unlock(&asus->wmi_lock);
 
-	mutex_lock(&eeepc->hotplug_lock);
+	mutex_lock(&asus->hotplug_lock);
 
-	if (eeepc->wlan_rfkill)
-		rfkill_set_sw_state(eeepc->wlan_rfkill, blocked);
+	if (asus->wlan_rfkill)
+		rfkill_set_sw_state(asus->wlan_rfkill, blocked);
 
-	if (eeepc->hotplug_slot) {
+	if (asus->hotplug_slot) {
 		bus = pci_find_bus(0, 1);
 		if (!bus) {
 			pr_warning("Unable to find PCI bus 1?\n");
@@ -429,11 +395,11 @@ static void eeepc_rfkill_hotplug(struct eeepc_wmi *eeepc)
 
 		if (blocked != absent) {
 			pr_warning("BIOS says wireless lan is %s, "
-					"but the pci device is %s\n",
-				blocked ? "blocked" : "unblocked",
-				absent ? "absent" : "present");
+				   "but the pci device is %s\n",
+				   blocked ? "blocked" : "unblocked",
+				   absent ? "absent" : "present");
 			pr_warning("skipped wireless hotplug as probably "
-					"inappropriate for this model\n");
+				   "inappropriate for this model\n");
 			goto out_unlock;
 		}
 
@@ -460,28 +426,27 @@ static void eeepc_rfkill_hotplug(struct eeepc_wmi *eeepc)
 	}
 
 out_unlock:
-	mutex_unlock(&eeepc->hotplug_lock);
+	mutex_unlock(&asus->hotplug_lock);
 }
 
-static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
+static void asus_rfkill_notify(acpi_handle handle, u32 event, void *data)
 {
-	struct eeepc_wmi *eeepc = data;
+	struct asus_wmi *asus = data;
 
 	if (event != ACPI_NOTIFY_BUS_CHECK)
 		return;
 
 	/*
-	 * We can't call directly eeepc_rfkill_hotplug because most
+	 * We can't call directly asus_rfkill_hotplug because most
 	 * of the time WMBC is still being executed and not reetrant.
 	 * There is currently no way to tell ACPICA that  we want this
-	 * method to be serialized, we schedule a eeepc_rfkill_hotplug
+	 * method to be serialized, we schedule a asus_rfkill_hotplug
 	 * call later, in a safer context.
 	 */
-	queue_work(eeepc->hotplug_workqueue, &eeepc->hotplug_work);
+	queue_work(asus->hotplug_workqueue, &asus->hotplug_work);
 }
 
-static int eeepc_register_rfkill_notifier(struct eeepc_wmi *eeepc,
-					  char *node)
+static int asus_register_rfkill_notifier(struct asus_wmi *asus, char *node)
 {
 	acpi_status status;
 	acpi_handle handle;
@@ -491,8 +456,7 @@ static int eeepc_register_rfkill_notifier(struct eeepc_wmi *eeepc,
 	if (ACPI_SUCCESS(status)) {
 		status = acpi_install_notify_handler(handle,
 						     ACPI_SYSTEM_NOTIFY,
-						     eeepc_rfkill_notify,
-						     eeepc);
+						     asus_rfkill_notify, asus);
 		if (ACPI_FAILURE(status))
 			pr_warning("Failed to register notify on %s\n", node);
 	} else
@@ -501,8 +465,7 @@ static int eeepc_register_rfkill_notifier(struct eeepc_wmi *eeepc,
 	return 0;
 }
 
-static void eeepc_unregister_rfkill_notifier(struct eeepc_wmi *eeepc,
-					     char *node)
+static void asus_unregister_rfkill_notifier(struct asus_wmi *asus, char *node)
 {
 	acpi_status status = AE_OK;
 	acpi_handle handle;
@@ -511,18 +474,18 @@ static void eeepc_unregister_rfkill_notifier(struct eeepc_wmi *eeepc,
 
 	if (ACPI_SUCCESS(status)) {
 		status = acpi_remove_notify_handler(handle,
-						     ACPI_SYSTEM_NOTIFY,
-						     eeepc_rfkill_notify);
+						    ACPI_SYSTEM_NOTIFY,
+						    asus_rfkill_notify);
 		if (ACPI_FAILURE(status))
 			pr_err("Error removing rfkill notify handler %s\n",
-				node);
+			       node);
 	}
 }
 
-static int eeepc_get_adapter_status(struct hotplug_slot *hotplug_slot,
-				    u8 *value)
+static int asus_get_adapter_status(struct hotplug_slot *hotplug_slot,
+				   u8 *value)
 {
-	int result = eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_WLAN);
+	int result = asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_WLAN);
 
 	if (result < 0)
 		return result;
@@ -531,27 +494,27 @@ static int eeepc_get_adapter_status(struct hotplug_slot *hotplug_slot,
 	return 0;
 }
 
-static void eeepc_cleanup_pci_hotplug(struct hotplug_slot *hotplug_slot)
+static void asus_cleanup_pci_hotplug(struct hotplug_slot *hotplug_slot)
 {
 	kfree(hotplug_slot->info);
 	kfree(hotplug_slot);
 }
 
-static struct hotplug_slot_ops eeepc_hotplug_slot_ops = {
+static struct hotplug_slot_ops asus_hotplug_slot_ops = {
 	.owner = THIS_MODULE,
-	.get_adapter_status = eeepc_get_adapter_status,
-	.get_power_status = eeepc_get_adapter_status,
+	.get_adapter_status = asus_get_adapter_status,
+	.get_power_status = asus_get_adapter_status,
 };
 
-static void eeepc_hotplug_work(struct work_struct *work)
+static void asus_hotplug_work(struct work_struct *work)
 {
-	struct eeepc_wmi *eeepc;
+	struct asus_wmi *asus;
 
-	eeepc = container_of(work, struct eeepc_wmi, hotplug_work);
-	eeepc_rfkill_hotplug(eeepc);
+	asus = container_of(work, struct asus_wmi, hotplug_work);
+	asus_rfkill_hotplug(asus);
 }
 
-static int eeepc_setup_pci_hotplug(struct eeepc_wmi *eeepc)
+static int asus_setup_pci_hotplug(struct asus_wmi *asus)
 {
 	int ret = -ENOMEM;
 	struct pci_bus *bus = pci_find_bus(0, 1);
@@ -561,29 +524,29 @@ static int eeepc_setup_pci_hotplug(struct eeepc_wmi *eeepc)
 		return -ENODEV;
 	}
 
-	eeepc->hotplug_workqueue =
-		create_singlethread_workqueue("hotplug_workqueue");
-	if (!eeepc->hotplug_workqueue)
+	asus->hotplug_workqueue =
+	    create_singlethread_workqueue("hotplug_workqueue");
+	if (!asus->hotplug_workqueue)
 		goto error_workqueue;
 
-	INIT_WORK(&eeepc->hotplug_work, eeepc_hotplug_work);
+	INIT_WORK(&asus->hotplug_work, asus_hotplug_work);
 
-	eeepc->hotplug_slot = kzalloc(sizeof(struct hotplug_slot), GFP_KERNEL);
-	if (!eeepc->hotplug_slot)
+	asus->hotplug_slot = kzalloc(sizeof(struct hotplug_slot), GFP_KERNEL);
+	if (!asus->hotplug_slot)
 		goto error_slot;
 
-	eeepc->hotplug_slot->info = kzalloc(sizeof(struct hotplug_slot_info),
-					    GFP_KERNEL);
-	if (!eeepc->hotplug_slot->info)
+	asus->hotplug_slot->info = kzalloc(sizeof(struct hotplug_slot_info),
+					   GFP_KERNEL);
+	if (!asus->hotplug_slot->info)
 		goto error_info;
 
-	eeepc->hotplug_slot->private = eeepc;
-	eeepc->hotplug_slot->release = &eeepc_cleanup_pci_hotplug;
-	eeepc->hotplug_slot->ops = &eeepc_hotplug_slot_ops;
-	eeepc_get_adapter_status(eeepc->hotplug_slot,
-				 &eeepc->hotplug_slot->info->adapter_status);
+	asus->hotplug_slot->private = asus;
+	asus->hotplug_slot->release = &asus_cleanup_pci_hotplug;
+	asus->hotplug_slot->ops = &asus_hotplug_slot_ops;
+	asus_get_adapter_status(asus->hotplug_slot,
+				&asus->hotplug_slot->info->adapter_status);
 
-	ret = pci_hp_register(eeepc->hotplug_slot, bus, 0, "eeepc-wifi");
+	ret = pci_hp_register(asus->hotplug_slot, bus, 0, "asus-wifi");
 	if (ret) {
 		pr_err("Unable to register hotplug slot - %d\n", ret);
 		goto error_register;
@@ -592,12 +555,12 @@ static int eeepc_setup_pci_hotplug(struct eeepc_wmi *eeepc)
 	return 0;
 
 error_register:
-	kfree(eeepc->hotplug_slot->info);
+	kfree(asus->hotplug_slot->info);
 error_info:
-	kfree(eeepc->hotplug_slot);
-	eeepc->hotplug_slot = NULL;
+	kfree(asus->hotplug_slot);
+	asus->hotplug_slot = NULL;
 error_slot:
-	destroy_workqueue(eeepc->hotplug_workqueue);
+	destroy_workqueue(asus->hotplug_workqueue);
 error_workqueue:
 	return ret;
 }
@@ -605,13 +568,13 @@ error_workqueue:
 /*
  * Rfkill devices
  */
-static int eeepc_rfkill_set(void *data, bool blocked)
+static int asus_rfkill_set(void *data, bool blocked)
 {
 	int dev_id = (unsigned long)data;
 	u32 ctrl_param = !blocked;
 	acpi_status status;
 
-	status = eeepc_wmi_set_devstate(dev_id, ctrl_param, NULL);
+	status = asus_wmi_set_devstate(dev_id, ctrl_param, NULL);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
@@ -619,68 +582,67 @@ static int eeepc_rfkill_set(void *data, bool blocked)
 	return 0;
 }
 
-static void eeepc_rfkill_query(struct rfkill *rfkill, void *data)
+static void asus_rfkill_query(struct rfkill *rfkill, void *data)
 {
 	int dev_id = (unsigned long)data;
 	int result;
 
-	result = eeepc_wmi_get_devstate_simple(dev_id);
+	result = asus_wmi_get_devstate_simple(dev_id);
 
 	if (result < 0)
-		return ;
+		return;
 
 	rfkill_set_sw_state(rfkill, !result);
 }
 
-static int eeepc_rfkill_wlan_set(void *data, bool blocked)
+static int asus_rfkill_wlan_set(void *data, bool blocked)
 {
-	struct eeepc_wmi *eeepc = data;
+	struct asus_wmi *asus = data;
 	int ret;
 
 	/*
 	 * This handler is enabled only if hotplug is enabled.
-	 * In this case, the eeepc_wmi_set_devstate() will
+	 * In this case, the asus_wmi_set_devstate() will
 	 * trigger a wmi notification and we need to wait
 	 * this call to finish before being able to call
 	 * any wmi method
 	 */
-	mutex_lock(&eeepc->wmi_lock);
-	ret = eeepc_rfkill_set((void *)(long)EEEPC_WMI_DEVID_WLAN, blocked);
-	mutex_unlock(&eeepc->wmi_lock);
+	mutex_lock(&asus->wmi_lock);
+	ret = asus_rfkill_set((void *)(long)ASUS_WMI_DEVID_WLAN, blocked);
+	mutex_unlock(&asus->wmi_lock);
 	return ret;
 }
 
-static void eeepc_rfkill_wlan_query(struct rfkill *rfkill, void *data)
+static void asus_rfkill_wlan_query(struct rfkill *rfkill, void *data)
 {
-	eeepc_rfkill_query(rfkill, (void *)(long)EEEPC_WMI_DEVID_WLAN);
+	asus_rfkill_query(rfkill, (void *)(long)ASUS_WMI_DEVID_WLAN);
 }
 
-static const struct rfkill_ops eeepc_rfkill_wlan_ops = {
-	.set_block = eeepc_rfkill_wlan_set,
-	.query = eeepc_rfkill_wlan_query,
+static const struct rfkill_ops asus_rfkill_wlan_ops = {
+	.set_block = asus_rfkill_wlan_set,
+	.query = asus_rfkill_wlan_query,
 };
 
-static const struct rfkill_ops eeepc_rfkill_ops = {
-	.set_block = eeepc_rfkill_set,
-	.query = eeepc_rfkill_query,
+static const struct rfkill_ops asus_rfkill_ops = {
+	.set_block = asus_rfkill_set,
+	.query = asus_rfkill_query,
 };
 
-static int eeepc_new_rfkill(struct eeepc_wmi *eeepc,
-			    struct rfkill **rfkill,
-			    const char *name,
-			    enum rfkill_type type, int dev_id)
+static int asus_new_rfkill(struct asus_wmi *asus,
+			   struct rfkill **rfkill,
+			   const char *name, enum rfkill_type type, int dev_id)
 {
-	int result = eeepc_wmi_get_devstate_simple(dev_id);
+	int result = asus_wmi_get_devstate_simple(dev_id);
 
 	if (result < 0)
 		return result;
 
-	if (dev_id == EEEPC_WMI_DEVID_WLAN && eeepc->hotplug_wireless)
-		*rfkill = rfkill_alloc(name, &eeepc->platform_device->dev, type,
-				       &eeepc_rfkill_wlan_ops, eeepc);
+	if (dev_id == ASUS_WMI_DEVID_WLAN && asus->driver->hotplug_wireless)
+		*rfkill = rfkill_alloc(name, &asus->platform_device->dev, type,
+				       &asus_rfkill_wlan_ops, asus);
 	else
-		*rfkill = rfkill_alloc(name, &eeepc->platform_device->dev, type,
-				       &eeepc_rfkill_ops, (void *)(long)dev_id);
+		*rfkill = rfkill_alloc(name, &asus->platform_device->dev, type,
+				       &asus_rfkill_ops, (void *)(long)dev_id);
 
 	if (!*rfkill)
 		return -EINVAL;
@@ -695,82 +657,82 @@ static int eeepc_new_rfkill(struct eeepc_wmi *eeepc,
 	return 0;
 }
 
-static void eeepc_wmi_rfkill_exit(struct eeepc_wmi *eeepc)
+static void asus_wmi_rfkill_exit(struct asus_wmi *asus)
 {
-	eeepc_unregister_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P5");
-	eeepc_unregister_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P6");
-	eeepc_unregister_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P7");
-	if (eeepc->wlan_rfkill) {
-		rfkill_unregister(eeepc->wlan_rfkill);
-		rfkill_destroy(eeepc->wlan_rfkill);
-		eeepc->wlan_rfkill = NULL;
+	asus_unregister_rfkill_notifier(asus, "\\_SB.PCI0.P0P5");
+	asus_unregister_rfkill_notifier(asus, "\\_SB.PCI0.P0P6");
+	asus_unregister_rfkill_notifier(asus, "\\_SB.PCI0.P0P7");
+	if (asus->wlan_rfkill) {
+		rfkill_unregister(asus->wlan_rfkill);
+		rfkill_destroy(asus->wlan_rfkill);
+		asus->wlan_rfkill = NULL;
 	}
 	/*
 	 * Refresh pci hotplug in case the rfkill state was changed after
-	 * eeepc_unregister_rfkill_notifier()
+	 * asus_unregister_rfkill_notifier()
 	 */
-	eeepc_rfkill_hotplug(eeepc);
-	if (eeepc->hotplug_slot)
-		pci_hp_deregister(eeepc->hotplug_slot);
-	if (eeepc->hotplug_workqueue)
-		destroy_workqueue(eeepc->hotplug_workqueue);
-
-	if (eeepc->bluetooth_rfkill) {
-		rfkill_unregister(eeepc->bluetooth_rfkill);
-		rfkill_destroy(eeepc->bluetooth_rfkill);
-		eeepc->bluetooth_rfkill = NULL;
+	asus_rfkill_hotplug(asus);
+	if (asus->hotplug_slot)
+		pci_hp_deregister(asus->hotplug_slot);
+	if (asus->hotplug_workqueue)
+		destroy_workqueue(asus->hotplug_workqueue);
+
+	if (asus->bluetooth_rfkill) {
+		rfkill_unregister(asus->bluetooth_rfkill);
+		rfkill_destroy(asus->bluetooth_rfkill);
+		asus->bluetooth_rfkill = NULL;
 	}
-	if (eeepc->wimax_rfkill) {
-		rfkill_unregister(eeepc->wimax_rfkill);
-		rfkill_destroy(eeepc->wimax_rfkill);
-		eeepc->wimax_rfkill = NULL;
+	if (asus->wimax_rfkill) {
+		rfkill_unregister(asus->wimax_rfkill);
+		rfkill_destroy(asus->wimax_rfkill);
+		asus->wimax_rfkill = NULL;
 	}
-	if (eeepc->wwan3g_rfkill) {
-		rfkill_unregister(eeepc->wwan3g_rfkill);
-		rfkill_destroy(eeepc->wwan3g_rfkill);
-		eeepc->wwan3g_rfkill = NULL;
+	if (asus->wwan3g_rfkill) {
+		rfkill_unregister(asus->wwan3g_rfkill);
+		rfkill_destroy(asus->wwan3g_rfkill);
+		asus->wwan3g_rfkill = NULL;
 	}
 }
 
-static int eeepc_wmi_rfkill_init(struct eeepc_wmi *eeepc)
+static int asus_wmi_rfkill_init(struct asus_wmi *asus)
 {
 	int result = 0;
 
-	mutex_init(&eeepc->hotplug_lock);
-	mutex_init(&eeepc->wmi_lock);
+	mutex_init(&asus->hotplug_lock);
+	mutex_init(&asus->wmi_lock);
 
-	result = eeepc_new_rfkill(eeepc, &eeepc->wlan_rfkill,
-				  "eeepc-wlan", RFKILL_TYPE_WLAN,
-				  EEEPC_WMI_DEVID_WLAN);
+	result = asus_new_rfkill(asus, &asus->wlan_rfkill,
+				 "asus-wlan", RFKILL_TYPE_WLAN,
+				 ASUS_WMI_DEVID_WLAN);
 
 	if (result && result != -ENODEV)
 		goto exit;
 
-	result = eeepc_new_rfkill(eeepc, &eeepc->bluetooth_rfkill,
-				  "eeepc-bluetooth", RFKILL_TYPE_BLUETOOTH,
-				  EEEPC_WMI_DEVID_BLUETOOTH);
+	result = asus_new_rfkill(asus, &asus->bluetooth_rfkill,
+				 "asus-bluetooth", RFKILL_TYPE_BLUETOOTH,
+				 ASUS_WMI_DEVID_BLUETOOTH);
 
 	if (result && result != -ENODEV)
 		goto exit;
 
-	result = eeepc_new_rfkill(eeepc, &eeepc->wimax_rfkill,
-				  "eeepc-wimax", RFKILL_TYPE_WIMAX,
-				  EEEPC_WMI_DEVID_WIMAX);
+	result = asus_new_rfkill(asus, &asus->wimax_rfkill,
+				 "asus-wimax", RFKILL_TYPE_WIMAX,
+				 ASUS_WMI_DEVID_WIMAX);
 
 	if (result && result != -ENODEV)
 		goto exit;
 
-	result = eeepc_new_rfkill(eeepc, &eeepc->wwan3g_rfkill,
-				  "eeepc-wwan3g", RFKILL_TYPE_WWAN,
-				  EEEPC_WMI_DEVID_WWAN3G);
+	result = asus_new_rfkill(asus, &asus->wwan3g_rfkill,
+				 "asus-wwan3g", RFKILL_TYPE_WWAN,
+				 ASUS_WMI_DEVID_WWAN3G);
 
 	if (result && result != -ENODEV)
 		goto exit;
 
-	if (!eeepc->hotplug_wireless)
+	if (!asus->driver->hotplug_wireless)
 		goto exit;
 
-	result = eeepc_setup_pci_hotplug(eeepc);
+	result = asus_setup_pci_hotplug(asus);
 	/*
 	 * If we get -EBUSY then something else is handling the PCI hotplug -
 	 * don't fail in this case
@@ -778,18 +740,18 @@ static int eeepc_wmi_rfkill_init(struct eeepc_wmi *eeepc)
 	if (result == -EBUSY)
 		result = 0;
 
-	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P5");
-	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P6");
-	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P7");
+	asus_register_rfkill_notifier(asus, "\\_SB.PCI0.P0P5");
+	asus_register_rfkill_notifier(asus, "\\_SB.PCI0.P0P6");
+	asus_register_rfkill_notifier(asus, "\\_SB.PCI0.P0P7");
 	/*
 	 * Refresh pci hotplug in case the rfkill state was changed during
 	 * setup.
 	 */
-	eeepc_rfkill_hotplug(eeepc);
+	asus_rfkill_hotplug(asus);
 
 exit:
 	if (result && result != -ENODEV)
-		eeepc_wmi_rfkill_exit(eeepc);
+		asus_wmi_rfkill_exit(asus);
 
 	if (result == -ENODEV)
 		result = 0;
@@ -802,7 +764,7 @@ exit:
  */
 static int read_backlight_power(void)
 {
-	int ret = eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_BACKLIGHT);
+	int ret = asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_BACKLIGHT);
 
 	if (ret < 0)
 		return ret;
@@ -815,12 +777,12 @@ static int read_brightness(struct backlight_device *bd)
 	u32 retval;
 	acpi_status status;
 
-	status = eeepc_wmi_get_devstate(EEEPC_WMI_DEVID_BRIGHTNESS, &retval);
+	status = asus_wmi_get_devstate(ASUS_WMI_DEVID_BRIGHTNESS, &retval);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
 	else
-		return retval & EEEPC_WMI_DSTS_BRIGHTNESS_MASK;
+		return retval & ASUS_WMI_DSTS_BRIGHTNESS_MASK;
 }
 
 static int update_bl_status(struct backlight_device *bd)
@@ -831,8 +793,8 @@ static int update_bl_status(struct backlight_device *bd)
 
 	ctrl_param = bd->props.brightness;
 
-	status = eeepc_wmi_set_devstate(EEEPC_WMI_DEVID_BRIGHTNESS,
-					ctrl_param, NULL);
+	status = asus_wmi_set_devstate(ASUS_WMI_DEVID_BRIGHTNESS,
+				       ctrl_param, NULL);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
@@ -840,8 +802,8 @@ static int update_bl_status(struct backlight_device *bd)
 	power = read_backlight_power();
 	if (power != -ENODEV && bd->props.power != power) {
 		ctrl_param = !!(bd->props.power == FB_BLANK_UNBLANK);
-		status = eeepc_wmi_set_devstate(EEEPC_WMI_DEVID_BACKLIGHT,
-						ctrl_param, NULL);
+		status = asus_wmi_set_devstate(ASUS_WMI_DEVID_BACKLIGHT,
+					       ctrl_param, NULL);
 
 		if (ACPI_FAILURE(status))
 			return -EIO;
@@ -849,14 +811,14 @@ static int update_bl_status(struct backlight_device *bd)
 	return 0;
 }
 
-static const struct backlight_ops eeepc_wmi_bl_ops = {
+static const struct backlight_ops asus_wmi_bl_ops = {
 	.get_brightness = read_brightness,
 	.update_status = update_bl_status,
 };
 
-static int eeepc_wmi_backlight_notify(struct eeepc_wmi *eeepc, int code)
+static int asus_wmi_backlight_notify(struct asus_wmi *asus, int code)
 {
-	struct backlight_device *bd = eeepc->backlight_device;
+	struct backlight_device *bd = asus->backlight_device;
 	int old = bd->props.brightness;
 	int new = old;
 
@@ -872,15 +834,15 @@ static int eeepc_wmi_backlight_notify(struct eeepc_wmi *eeepc, int code)
 	return old;
 }
 
-static int eeepc_wmi_backlight_init(struct eeepc_wmi *eeepc)
+static int asus_wmi_backlight_init(struct asus_wmi *asus)
 {
 	struct backlight_device *bd;
 	struct backlight_properties props;
 	int max;
 	int power;
 
-	max = eeepc_wmi_get_devstate_bits(EEEPC_WMI_DEVID_BRIGHTNESS,
-					  EEEPC_WMI_DSTS_MAX_BRIGTH_MASK);
+	max = asus_wmi_get_devstate_bits(ASUS_WMI_DEVID_BRIGHTNESS,
+					 ASUS_WMI_DSTS_MAX_BRIGTH_MASK);
 	power = read_backlight_power();
 
 	if (max < 0 && power < 0) {
@@ -899,15 +861,15 @@ static int eeepc_wmi_backlight_init(struct eeepc_wmi *eeepc)
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.max_brightness = max;
-	bd = backlight_device_register(EEEPC_WMI_FILE,
-				       &eeepc->platform_device->dev, eeepc,
-				       &eeepc_wmi_bl_ops, &props);
+	bd = backlight_device_register(asus->driver->name,
+				       &asus->platform_device->dev, asus,
+				       &asus_wmi_bl_ops, &props);
 	if (IS_ERR(bd)) {
 		pr_err("Could not register backlight device\n");
 		return PTR_ERR(bd);
 	}
 
-	eeepc->backlight_device = bd;
+	asus->backlight_device = bd;
 
 	bd->props.brightness = read_brightness(bd);
 	bd->props.power = power;
@@ -916,17 +878,17 @@ static int eeepc_wmi_backlight_init(struct eeepc_wmi *eeepc)
 	return 0;
 }
 
-static void eeepc_wmi_backlight_exit(struct eeepc_wmi *eeepc)
+static void asus_wmi_backlight_exit(struct asus_wmi *asus)
 {
-	if (eeepc->backlight_device)
-		backlight_device_unregister(eeepc->backlight_device);
+	if (asus->backlight_device)
+		backlight_device_unregister(asus->backlight_device);
 
-	eeepc->backlight_device = NULL;
+	asus->backlight_device = NULL;
 }
 
-static void eeepc_wmi_notify(u32 value, void *context)
+static void asus_wmi_notify(u32 value, void *context)
 {
-	struct eeepc_wmi *eeepc = context;
+	struct asus_wmi *asus = context;
 	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
 	acpi_status status;
@@ -953,11 +915,10 @@ static void eeepc_wmi_notify(u32 value, void *context)
 
 		if (code == NOTIFY_BRNUP_MIN || code == NOTIFY_BRNDOWN_MIN) {
 			if (!acpi_video_backlight_support())
-				eeepc_wmi_backlight_notify(eeepc, orig_code);
+				asus_wmi_backlight_notify(asus, orig_code);
 		}
 
-		if (!sparse_keymap_report_event(eeepc->inputdev,
-						code, 1, true))
+		if (!sparse_keymap_report_event(asus->inputdev, code, 1, true))
 			pr_info("Unknown key %x pressed\n", code);
 	}
 
@@ -982,12 +943,12 @@ static ssize_t store_sys_wmi(int devid, const char *buf, size_t count)
 	u32 retval;
 	int rv, value;
 
-	value = eeepc_wmi_get_devstate_simple(devid);
-	if (value == -ENODEV) /* Check device presence */
+	value = asus_wmi_get_devstate_simple(devid);
+	if (value == -ENODEV)	/* Check device presence */
 		return value;
 
 	rv = parse_arg(buf, count, &value);
-	status = eeepc_wmi_set_devstate(devid, value, &retval);
+	status = asus_wmi_set_devstate(devid, value, &retval);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
@@ -996,7 +957,7 @@ static ssize_t store_sys_wmi(int devid, const char *buf, size_t count)
 
 static ssize_t show_sys_wmi(int devid, char *buf)
 {
-	int value = eeepc_wmi_get_devstate_simple(devid);
+	int value = asus_wmi_get_devstate_simple(devid);
 
 	if (value < 0)
 		return value;
@@ -1004,7 +965,7 @@ static ssize_t show_sys_wmi(int devid, char *buf)
 	return sprintf(buf, "%d\n", value);
 }
 
-#define EEEPC_WMI_CREATE_DEVICE_ATTR(_name, _mode, _cm)			\
+#define ASUS_WMI_CREATE_DEVICE_ATTR(_name, _mode, _cm)			\
 	static ssize_t show_##_name(struct device *dev,			\
 				    struct device_attribute *attr,	\
 				    char *buf)				\
@@ -1025,15 +986,15 @@ static ssize_t show_sys_wmi(int devid, char *buf)
 		.store  = store_##_name,				\
 	}
 
-EEEPC_WMI_CREATE_DEVICE_ATTR(touchpad, 0644, EEEPC_WMI_DEVID_TOUCHPAD);
-EEEPC_WMI_CREATE_DEVICE_ATTR(camera, 0644, EEEPC_WMI_DEVID_CAMERA);
-EEEPC_WMI_CREATE_DEVICE_ATTR(cardr, 0644, EEEPC_WMI_DEVID_CARDREADER);
+ASUS_WMI_CREATE_DEVICE_ATTR(touchpad, 0644, ASUS_WMI_DEVID_TOUCHPAD);
+ASUS_WMI_CREATE_DEVICE_ATTR(camera, 0644, ASUS_WMI_DEVID_CAMERA);
+ASUS_WMI_CREATE_DEVICE_ATTR(cardr, 0644, ASUS_WMI_DEVID_CARDREADER);
 
 static ssize_t store_cpufv(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
 	int value;
-	struct acpi_buffer input = { (acpi_size)sizeof(value), &value };
+	struct acpi_buffer input = { (acpi_size) sizeof(value), &value };
 	acpi_status status;
 
 	if (!count || sscanf(buf, "%i", &value) != 1)
@@ -1041,8 +1002,8 @@ static ssize_t store_cpufv(struct device *dev, struct device_attribute *attr,
 	if (value < 0 || value > 2)
 		return -EINVAL;
 
-	status = wmi_evaluate_method(EEEPC_WMI_MGMT_GUID,
-				     1, EEEPC_WMI_METHODID_CFVS, &input, NULL);
+	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
+				     1, ASUS_WMI_METHODID_CFVS, &input, NULL);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
@@ -1060,37 +1021,36 @@ static struct attribute *platform_attributes[] = {
 	NULL
 };
 
-static mode_t eeepc_sysfs_is_visible(struct kobject *kobj,
-				     struct attribute *attr,
-				     int idx)
+static mode_t asus_sysfs_is_visible(struct kobject *kobj,
+				    struct attribute *attr, int idx)
 {
 	bool supported = true;
 	int devid = -1;
 
 	if (attr == &dev_attr_camera.attr)
-		devid = EEEPC_WMI_DEVID_CAMERA;
+		devid = ASUS_WMI_DEVID_CAMERA;
 	else if (attr == &dev_attr_cardr.attr)
-		devid = EEEPC_WMI_DEVID_CARDREADER;
+		devid = ASUS_WMI_DEVID_CARDREADER;
 	else if (attr == &dev_attr_touchpad.attr)
-		devid = EEEPC_WMI_DEVID_TOUCHPAD;
+		devid = ASUS_WMI_DEVID_TOUCHPAD;
 
 	if (devid != -1)
-		supported = eeepc_wmi_get_devstate_simple(devid) != -ENODEV;
+		supported = asus_wmi_get_devstate_simple(devid) != -ENODEV;
 
 	return supported ? attr->mode : 0;
 }
 
 static struct attribute_group platform_attribute_group = {
-	.is_visible	= eeepc_sysfs_is_visible,
-	.attrs		= platform_attributes
+	.is_visible = asus_sysfs_is_visible,
+	.attrs = platform_attributes
 };
 
-static void eeepc_wmi_sysfs_exit(struct platform_device *device)
+static void asus_wmi_sysfs_exit(struct platform_device *device)
 {
 	sysfs_remove_group(&device->dev.kobj, &platform_attribute_group);
 }
 
-static int eeepc_wmi_sysfs_init(struct platform_device *device)
+static int asus_wmi_sysfs_init(struct platform_device *device)
 {
 	return sysfs_create_group(&device->dev.kobj, &platform_attribute_group);
 }
@@ -1098,111 +1058,111 @@ static int eeepc_wmi_sysfs_init(struct platform_device *device)
 /*
  * Platform device
  */
-static int __init eeepc_wmi_platform_init(struct eeepc_wmi *eeepc)
+static int __init asus_wmi_platform_init(struct asus_wmi *asus)
 {
-	return eeepc_wmi_sysfs_init(eeepc->platform_device);
+	return asus_wmi_sysfs_init(asus->platform_device);
 }
 
-static void eeepc_wmi_platform_exit(struct eeepc_wmi *eeepc)
+static void asus_wmi_platform_exit(struct asus_wmi *asus)
 {
-	eeepc_wmi_sysfs_exit(eeepc->platform_device);
+	asus_wmi_sysfs_exit(asus->platform_device);
 }
 
 /*
  * debugfs
  */
-struct eeepc_wmi_debugfs_node {
-	struct eeepc_wmi *eeepc;
+struct asus_wmi_debugfs_node {
+	struct asus_wmi *asus;
 	char *name;
-	int (*show)(struct seq_file *m, void *data);
+	int (*show) (struct seq_file *m, void *data);
 };
 
 static int show_dsts(struct seq_file *m, void *data)
 {
-	struct eeepc_wmi *eeepc = m->private;
+	struct asus_wmi *asus = m->private;
 	acpi_status status;
 	u32 retval = -1;
 
-	status = eeepc_wmi_get_devstate(eeepc->debug.dev_id, &retval);
+	status = asus_wmi_get_devstate(asus->debug.dev_id, &retval);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
-	seq_printf(m, "DSTS(%x) = %x\n", eeepc->debug.dev_id, retval);
+	seq_printf(m, "DSTS(%x) = %x\n", asus->debug.dev_id, retval);
 
 	return 0;
 }
 
 static int show_devs(struct seq_file *m, void *data)
 {
-	struct eeepc_wmi *eeepc = m->private;
+	struct asus_wmi *asus = m->private;
 	acpi_status status;
 	u32 retval = -1;
 
-	status = eeepc_wmi_set_devstate(eeepc->debug.dev_id,
-					eeepc->debug.ctrl_param, &retval);
+	status = asus_wmi_set_devstate(asus->debug.dev_id,
+				       asus->debug.ctrl_param, &retval);
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
-	seq_printf(m, "DEVS(%x, %x) = %x\n", eeepc->debug.dev_id,
-		   eeepc->debug.ctrl_param, retval);
+	seq_printf(m, "DEVS(%x, %x) = %x\n", asus->debug.dev_id,
+		   asus->debug.ctrl_param, retval);
 
 	return 0;
 }
 
-static struct eeepc_wmi_debugfs_node eeepc_wmi_debug_files[] = {
-	{ NULL, "devs", show_devs },
-	{ NULL, "dsts", show_dsts },
+static struct asus_wmi_debugfs_node asus_wmi_debug_files[] = {
+	{NULL, "devs", show_devs},
+	{NULL, "dsts", show_dsts},
 };
 
-static int eeepc_wmi_debugfs_open(struct inode *inode, struct file *file)
+static int asus_wmi_debugfs_open(struct inode *inode, struct file *file)
 {
-	struct eeepc_wmi_debugfs_node *node = inode->i_private;
+	struct asus_wmi_debugfs_node *node = inode->i_private;
 
-	return single_open(file, node->show, node->eeepc);
+	return single_open(file, node->show, node->asus);
 }
 
-static const struct file_operations eeepc_wmi_debugfs_io_ops = {
+static const struct file_operations asus_wmi_debugfs_io_ops = {
 	.owner = THIS_MODULE,
-	.open  = eeepc_wmi_debugfs_open,
+	.open = asus_wmi_debugfs_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
 };
 
-static void eeepc_wmi_debugfs_exit(struct eeepc_wmi *eeepc)
+static void asus_wmi_debugfs_exit(struct asus_wmi *asus)
 {
-	debugfs_remove_recursive(eeepc->debug.root);
+	debugfs_remove_recursive(asus->debug.root);
 }
 
-static int eeepc_wmi_debugfs_init(struct eeepc_wmi *eeepc)
+static int asus_wmi_debugfs_init(struct asus_wmi *asus)
 {
 	struct dentry *dent;
 	int i;
 
-	eeepc->debug.root = debugfs_create_dir(EEEPC_WMI_FILE, NULL);
-	if (!eeepc->debug.root) {
+	asus->debug.root = debugfs_create_dir(asus->driver->name, NULL);
+	if (!asus->debug.root) {
 		pr_err("failed to create debugfs directory");
 		goto error_debugfs;
 	}
 
-	dent = debugfs_create_x32("dev_id", S_IRUGO|S_IWUSR,
-				  eeepc->debug.root, &eeepc->debug.dev_id);
+	dent = debugfs_create_x32("dev_id", S_IRUGO | S_IWUSR,
+				  asus->debug.root, &asus->debug.dev_id);
 	if (!dent)
 		goto error_debugfs;
 
-	dent = debugfs_create_x32("ctrl_param", S_IRUGO|S_IWUSR,
-				  eeepc->debug.root, &eeepc->debug.ctrl_param);
+	dent = debugfs_create_x32("ctrl_param", S_IRUGO | S_IWUSR,
+				  asus->debug.root, &asus->debug.ctrl_param);
 	if (!dent)
 		goto error_debugfs;
 
-	for (i = 0; i < ARRAY_SIZE(eeepc_wmi_debug_files); i++) {
-		struct eeepc_wmi_debugfs_node *node = &eeepc_wmi_debug_files[i];
+	for (i = 0; i < ARRAY_SIZE(asus_wmi_debug_files); i++) {
+		struct asus_wmi_debugfs_node *node = &asus_wmi_debug_files[i];
 
-		node->eeepc = eeepc;
+		node->asus = asus;
 		dent = debugfs_create_file(node->name, S_IFREG | S_IRUGO,
-					   eeepc->debug.root, node,
-					   &eeepc_wmi_debugfs_io_ops);
+					   asus->debug.root, node,
+					   &asus_wmi_debugfs_io_ops);
 		if (!dent) {
 			pr_err("failed to create debug file: %s\n", node->name);
 			goto error_debugfs;
@@ -1212,131 +1172,112 @@ static int eeepc_wmi_debugfs_init(struct eeepc_wmi *eeepc)
 	return 0;
 
 error_debugfs:
-	eeepc_wmi_debugfs_exit(eeepc);
+	asus_wmi_debugfs_exit(asus);
 	return -ENOMEM;
 }
 
 /*
  * WMI Driver
  */
-static void eeepc_dmi_check(struct eeepc_wmi *eeepc)
+static int asus_wmi_add(struct platform_device *pdev)
 {
-	const char *model;
-
-	model = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (!model)
-		return;
-
-	/*
-	 * Whitelist for wlan hotplug
-	 *
-	 * Eeepc 1000H needs the current hotplug code to handle
-	 * Fn+F2 correctly. We may add other Eeepc here later, but
-	 * it seems that most of the laptops supported by eeepc-wmi
-	 * don't need to be on this list
-	 */
-	if (strcmp(model, "1000H") == 0) {
-		eeepc->hotplug_wireless = true;
-		pr_info("wlan hotplug enabled\n");
-	}
-}
-
-static int __init eeepc_wmi_add(struct platform_device *pdev)
-{
-	struct eeepc_wmi *eeepc;
+	struct platform_driver *pdrv = to_platform_driver(pdev->dev.driver);
+	struct asus_wmi_driver *wdrv = to_asus_wmi_driver(pdrv);
+	struct asus_wmi *asus;
 	acpi_status status;
 	int err;
 
-	eeepc = kzalloc(sizeof(struct eeepc_wmi), GFP_KERNEL);
-	if (!eeepc)
+	asus = kzalloc(sizeof(struct asus_wmi), GFP_KERNEL);
+	if (!asus)
 		return -ENOMEM;
 
-	eeepc->platform_device = pdev;
-	platform_set_drvdata(eeepc->platform_device, eeepc);
+	asus->driver = wdrv;
+	asus->platform_device = pdev;
+	wdrv->platform_device = pdev;
+	platform_set_drvdata(asus->platform_device, asus);
 
-	eeepc->hotplug_wireless = hotplug_wireless;
-	eeepc_dmi_check(eeepc);
+	if (wdrv->quirks)
+		wdrv->quirks(asus->driver);
 
-	err = eeepc_wmi_platform_init(eeepc);
+	err = asus_wmi_platform_init(asus);
 	if (err)
 		goto fail_platform;
 
-	err = eeepc_wmi_input_init(eeepc);
+	err = asus_wmi_input_init(asus);
 	if (err)
 		goto fail_input;
 
-	err = eeepc_wmi_led_init(eeepc);
+	err = asus_wmi_led_init(asus);
 	if (err)
 		goto fail_leds;
 
-	err = eeepc_wmi_rfkill_init(eeepc);
+	err = asus_wmi_rfkill_init(asus);
 	if (err)
 		goto fail_rfkill;
 
 	if (!acpi_video_backlight_support()) {
-		err = eeepc_wmi_backlight_init(eeepc);
+		err = asus_wmi_backlight_init(asus);
 		if (err && err != -ENODEV)
 			goto fail_backlight;
 	} else
 		pr_info("Backlight controlled by ACPI video driver\n");
 
-	status = wmi_install_notify_handler(EEEPC_WMI_EVENT_GUID,
-					    eeepc_wmi_notify, eeepc);
+	status = wmi_install_notify_handler(asus->driver->event_guid,
+					    asus_wmi_notify, asus);
 	if (ACPI_FAILURE(status)) {
-		pr_err("Unable to register notify handler - %d\n",
-			status);
+		pr_err("Unable to register notify handler - %d\n", status);
 		err = -ENODEV;
 		goto fail_wmi_handler;
 	}
 
-	err = eeepc_wmi_debugfs_init(eeepc);
+	err = asus_wmi_debugfs_init(asus);
 	if (err)
 		goto fail_debugfs;
 
 	return 0;
 
 fail_debugfs:
-	wmi_remove_notify_handler(EEEPC_WMI_EVENT_GUID);
+	wmi_remove_notify_handler(asus->driver->event_guid);
 fail_wmi_handler:
-	eeepc_wmi_backlight_exit(eeepc);
+	asus_wmi_backlight_exit(asus);
 fail_backlight:
-	eeepc_wmi_rfkill_exit(eeepc);
+	asus_wmi_rfkill_exit(asus);
 fail_rfkill:
-	eeepc_wmi_led_exit(eeepc);
+	asus_wmi_led_exit(asus);
 fail_leds:
-	eeepc_wmi_input_exit(eeepc);
+	asus_wmi_input_exit(asus);
 fail_input:
-	eeepc_wmi_platform_exit(eeepc);
+	asus_wmi_platform_exit(asus);
 fail_platform:
-	kfree(eeepc);
+	kfree(asus);
 	return err;
 }
 
-static int __exit eeepc_wmi_remove(struct platform_device *device)
+static int asus_wmi_remove(struct platform_device *device)
 {
-	struct eeepc_wmi *eeepc;
-
-	eeepc = platform_get_drvdata(device);
-	wmi_remove_notify_handler(EEEPC_WMI_EVENT_GUID);
-	eeepc_wmi_backlight_exit(eeepc);
-	eeepc_wmi_input_exit(eeepc);
-	eeepc_wmi_led_exit(eeepc);
-	eeepc_wmi_rfkill_exit(eeepc);
-	eeepc_wmi_debugfs_exit(eeepc);
-	eeepc_wmi_platform_exit(eeepc);
-
-	kfree(eeepc);
+	struct asus_wmi *asus;
+
+	asus = platform_get_drvdata(device);
+	wmi_remove_notify_handler(asus->driver->event_guid);
+	asus_wmi_backlight_exit(asus);
+	asus_wmi_input_exit(asus);
+	asus_wmi_led_exit(asus);
+	asus_wmi_rfkill_exit(asus);
+	asus_wmi_debugfs_exit(asus);
+	asus_wmi_platform_exit(asus);
+
+	kfree(asus);
 	return 0;
 }
 
 /*
  * Platform driver - hibernate/resume callbacks
  */
-static int eeepc_hotk_thaw(struct device *device)
+static int asus_hotk_thaw(struct device *device)
 {
-	struct eeepc_wmi *eeepc = dev_get_drvdata(device);
+	struct asus_wmi *asus = dev_get_drvdata(device);
 
-	if (eeepc->wlan_rfkill) {
+	if (asus->wlan_rfkill) {
 		bool wlan;
 
 		/*
@@ -1344,111 +1285,118 @@ static int eeepc_hotk_thaw(struct device *device)
 		 * during suspend.  Normally it restores it on resume, but
 		 * we should kick it ourselves in case hibernation is aborted.
 		 */
-		wlan = eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_WLAN);
-		eeepc_wmi_set_devstate(EEEPC_WMI_DEVID_WLAN, wlan, NULL);
+		wlan = asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_WLAN);
+		asus_wmi_set_devstate(ASUS_WMI_DEVID_WLAN, wlan, NULL);
 	}
 
 	return 0;
 }
 
-static int eeepc_hotk_restore(struct device *device)
+static int asus_hotk_restore(struct device *device)
 {
-	struct eeepc_wmi *eeepc = dev_get_drvdata(device);
+	struct asus_wmi *asus = dev_get_drvdata(device);
 	int bl;
 
 	/* Refresh both wlan rfkill state and pci hotplug */
-	if (eeepc->wlan_rfkill)
-		eeepc_rfkill_hotplug(eeepc);
+	if (asus->wlan_rfkill)
+		asus_rfkill_hotplug(asus);
 
-	if (eeepc->bluetooth_rfkill) {
-		bl = !eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_BLUETOOTH);
-		rfkill_set_sw_state(eeepc->bluetooth_rfkill, bl);
+	if (asus->bluetooth_rfkill) {
+		bl = !asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_BLUETOOTH);
+		rfkill_set_sw_state(asus->bluetooth_rfkill, bl);
 	}
-	if (eeepc->wimax_rfkill) {
-		bl = !eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_WIMAX);
-		rfkill_set_sw_state(eeepc->wimax_rfkill, bl);
+	if (asus->wimax_rfkill) {
+		bl = !asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_WIMAX);
+		rfkill_set_sw_state(asus->wimax_rfkill, bl);
 	}
-	if (eeepc->wwan3g_rfkill) {
-		bl = !eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_WWAN3G);
-		rfkill_set_sw_state(eeepc->wwan3g_rfkill, bl);
+	if (asus->wwan3g_rfkill) {
+		bl = !asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_WWAN3G);
+		rfkill_set_sw_state(asus->wwan3g_rfkill, bl);
 	}
 
 	return 0;
 }
 
-static const struct dev_pm_ops eeepc_pm_ops = {
-	.thaw = eeepc_hotk_thaw,
-	.restore = eeepc_hotk_restore,
-};
-
-static struct platform_driver platform_driver = {
-	.remove = __exit_p(eeepc_wmi_remove),
-	.driver = {
-		.name = EEEPC_WMI_FILE,
-		.owner = THIS_MODULE,
-		.pm = &eeepc_pm_ops,
-	},
+static const struct dev_pm_ops asus_pm_ops = {
+	.thaw = asus_hotk_thaw,
+	.restore = asus_hotk_restore,
 };
 
-static acpi_status __init eeepc_wmi_parse_device(acpi_handle handle, u32 level,
-						 void *context, void **retval)
+static int asus_wmi_probe(struct platform_device *pdev)
 {
-	pr_warning("Found legacy ATKD device (%s)", EEEPC_ACPI_HID);
-	*(bool *)context = true;
-	return AE_CTRL_TERMINATE;
-}
-
-static int __init eeepc_wmi_check_atkd(void)
-{
-	acpi_status status;
-	bool found = false;
-
-	status = acpi_get_devices(EEEPC_ACPI_HID, eeepc_wmi_parse_device,
-				  &found, NULL);
-
-	if (ACPI_FAILURE(status) || !found)
-		return 0;
-	return -1;
-}
+	struct platform_driver *pdrv = to_platform_driver(pdev->dev.driver);
+	struct asus_wmi_driver *wdrv = to_asus_wmi_driver(pdrv);
+	int ret;
 
-static int __init eeepc_wmi_probe(struct platform_device *pdev)
-{
-	if (!wmi_has_guid(EEEPC_WMI_EVENT_GUID) ||
-	    !wmi_has_guid(EEEPC_WMI_MGMT_GUID)) {
-		pr_warning("No known WMI GUID found\n");
+	if (!wmi_has_guid(ASUS_WMI_MGMT_GUID)) {
+		pr_warning("Management GUID not found\n");
 		return -ENODEV;
 	}
 
-	if (eeepc_wmi_check_atkd()) {
-		pr_warning("WMI device present, but legacy ATKD device is also "
-			   "present and enabled.");
-		pr_warning("You probably booted with acpi_osi=\"Linux\" or "
-			   "acpi_osi=\"!Windows 2009\"");
-		pr_warning("Can't load eeepc-wmi, use default acpi_osi "
-			   "(preferred) or eeepc-laptop");
+	if (wdrv->event_guid && !wmi_has_guid(wdrv->event_guid)) {
+		pr_warning("Event GUID not found\n");
 		return -ENODEV;
 	}
 
-	return eeepc_wmi_add(pdev);
+	if (wdrv->probe) {
+		ret = wdrv->probe(pdev);
+		if (ret)
+			return ret;
+	}
+
+	return asus_wmi_add(pdev);
 }
 
-static struct platform_device *platform_device;
+static bool used;
 
-static int __init eeepc_wmi_init(void)
+int asus_wmi_register_driver(struct asus_wmi_driver *driver)
 {
-	platform_device = platform_create_bundle(&platform_driver,
-						 eeepc_wmi_probe,
+	struct platform_driver *platform_driver;
+	struct platform_device *platform_device;
+
+	if (used)
+		return -EBUSY;
+
+	platform_driver = &driver->platform_driver;
+	platform_driver->remove = asus_wmi_remove;
+	platform_driver->driver.owner = driver->owner;
+	platform_driver->driver.name = driver->name;
+	platform_driver->driver.pm = &asus_pm_ops;
+
+	platform_device = platform_create_bundle(platform_driver,
+						 asus_wmi_probe,
 						 NULL, 0, NULL, 0);
 	if (IS_ERR(platform_device))
 		return PTR_ERR(platform_device);
+
+	used = true;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(asus_wmi_register_driver);
+
+void asus_wmi_unregister_driver(struct asus_wmi_driver *driver)
+{
+	platform_device_unregister(driver->platform_device);
+	platform_driver_unregister(&driver->platform_driver);
+	used = false;
+}
+EXPORT_SYMBOL_GPL(asus_wmi_unregister_driver);
+
+static int __init asus_wmi_init(void)
+{
+	if (!wmi_has_guid(ASUS_WMI_MGMT_GUID)) {
+		pr_info("Asus Management GUID not found");
+		return -ENODEV;
+	}
+
+	pr_info("ASUS WMI generic driver loaded");
 	return 0;
 }
 
-static void __exit eeepc_wmi_exit(void)
+static void __exit asus_wmi_exit(void)
 {
-	platform_device_unregister(platform_device);
-	platform_driver_unregister(&platform_driver);
+	pr_info("ASUS WMI generic driver unloaded");
 }
 
-module_init(eeepc_wmi_init);
-module_exit(eeepc_wmi_exit);
+module_init(asus_wmi_init);
+module_exit(asus_wmi_exit);
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
new file mode 100644
index 0000000..c044522
--- /dev/null
+++ b/drivers/platform/x86/asus-wmi.h
@@ -0,0 +1,58 @@
+/*
+ * Asus PC WMI hotkey driver
+ *
+ * Copyright(C) 2010 Intel Corporation.
+ * Copyright(C) 2010-2011 Corentin Chary <corentin.chary@gmail.com>
+ *
+ * Portions based on wistron_btns.c:
+ * Copyright (C) 2005 Miloslav Trmac <mitr@volny.cz>
+ * Copyright (C) 2005 Bernhard Rosenkraenzer <bero@arklinux.org>
+ * Copyright (C) 2005 Dmitry Torokhov <dtor@mail.ru>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _ASUS_WMI_H_
+#define _ASUS_WMI_H_
+
+#include <linux/platform_device.h>
+
+struct module;
+struct key_entry;
+struct asus_wmi;
+
+struct asus_wmi_driver {
+	bool			hotplug_wireless;
+
+	const char		*name;
+	struct module		*owner;
+
+	const char		*event_guid;
+
+	const struct key_entry	*keymap;
+	const char		*input_name;
+	const char		*input_phys;
+
+	int (*probe) (struct platform_device *device);
+	void (*quirks) (struct asus_wmi_driver *driver);
+
+	struct platform_driver	platform_driver;
+	struct platform_device *platform_device;
+};
+
+int asus_wmi_register_driver(struct asus_wmi_driver *driver);
+void asus_wmi_unregister_driver(struct asus_wmi_driver *driver);
+
+#endif /* !_ASUS_WMI_H_ */
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
new file mode 100644
index 0000000..3a060ae
--- /dev/null
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -0,0 +1,162 @@
+/*
+ * Eee PC WMI hotkey driver
+ *
+ * Copyright(C) 2010 Intel Corporation.
+ * Copyright(C) 2010 Corentin Chary <corentin.chary@gmail.com>
+ *
+ * Portions based on wistron_btns.c:
+ * Copyright (C) 2005 Miloslav Trmac <mitr@volny.cz>
+ * Copyright (C) 2005 Bernhard Rosenkraenzer <bero@arklinux.org>
+ * Copyright (C) 2005 Dmitry Torokhov <dtor@mail.ru>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/input/sparse-keymap.h>
+#include <linux/dmi.h>
+#include <acpi/acpi_bus.h>
+
+#include "asus-wmi.h"
+
+#define	EEEPC_WMI_FILE	"eeepc-wmi"
+
+MODULE_AUTHOR("Corentin Chary <corentincj@iksaif.net>");
+MODULE_DESCRIPTION("Eee PC WMI Hotkey Driver");
+MODULE_LICENSE("GPL");
+
+#define EEEPC_ACPI_HID		"ASUS010" /* old _HID used in eeepc-laptop */
+
+#define EEEPC_WMI_EVENT_GUID	"ABBC0F72-8EA1-11D1-00A0-C90629100000"
+
+MODULE_ALIAS("wmi:"EEEPC_WMI_EVENT_GUID);
+
+static bool hotplug_wireless;
+
+module_param(hotplug_wireless, bool, 0444);
+MODULE_PARM_DESC(hotplug_wireless,
+		 "Enable hotplug for wireless device. "
+		 "If your laptop needs that, please report to "
+		 "acpi4asus-user@lists.sourceforge.net.");
+
+static const struct key_entry eeepc_wmi_keymap[] = {
+	/* Sleep already handled via generic ACPI code */
+	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
+	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
+	{ KE_KEY, 0x32, { KEY_MUTE } },
+	{ KE_KEY, 0x5c, { KEY_F15 } }, /* Power Gear key */
+	{ KE_KEY, 0x5d, { KEY_WLAN } },
+	{ KE_KEY, 0x6b, { KEY_F13 } }, /* Disable Touchpad */
+	{ KE_KEY, 0x82, { KEY_CAMERA } },
+	{ KE_KEY, 0x88, { KEY_WLAN } },
+	{ KE_KEY, 0xcc, { KEY_SWITCHVIDEOMODE } },
+	{ KE_KEY, 0xe0, { KEY_PROG1 } }, /* Task Manager */
+	{ KE_KEY, 0xe1, { KEY_F14 } }, /* Change Resolution */
+	{ KE_KEY, 0xe9, { KEY_BRIGHTNESS_ZERO } },
+	{ KE_END, 0},
+};
+
+static acpi_status eeepc_wmi_parse_device(acpi_handle handle, u32 level,
+						 void *context, void **retval)
+{
+	pr_warning("Found legacy ATKD device (%s)", EEEPC_ACPI_HID);
+	*(bool *)context = true;
+	return AE_CTRL_TERMINATE;
+}
+
+static int eeepc_wmi_check_atkd(void)
+{
+	acpi_status status;
+	bool found = false;
+
+	status = acpi_get_devices(EEEPC_ACPI_HID, eeepc_wmi_parse_device,
+				  &found, NULL);
+
+	if (ACPI_FAILURE(status) || !found)
+		return 0;
+	return -1;
+}
+
+static int eeepc_wmi_probe(struct platform_device *pdev)
+{
+	if (eeepc_wmi_check_atkd()) {
+		pr_warning("WMI device present, but legacy ATKD device is also "
+			   "present and enabled.");
+		pr_warning("You probably booted with acpi_osi=\"Linux\" or "
+			   "acpi_osi=\"!Windows 2009\"");
+		pr_warning("Can't load eeepc-wmi, use default acpi_osi "
+			   "(preferred) or eeepc-laptop");
+		return -EBUSY;
+	}
+	return 0;
+}
+
+static void eeepc_dmi_check(struct asus_wmi_driver *driver)
+{
+	const char *model;
+
+	model = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!model)
+		return;
+
+	/*
+	 * Whitelist for wlan hotplug
+	 *
+	 * Asus 1000H needs the current hotplug code to handle
+	 * Fn+F2 correctly. We may add other Asus here later, but
+	 * it seems that most of the laptops supported by asus-wmi
+	 * don't need to be on this list
+	 */
+	if (strcmp(model, "1000H") == 0) {
+		driver->hotplug_wireless = true;
+		pr_info("wlan hotplug enabled\n");
+	}
+}
+
+static void eeepc_wmi_quirks(struct asus_wmi_driver *driver)
+{
+	driver->hotplug_wireless = hotplug_wireless;
+	eeepc_dmi_check(driver);
+}
+
+static struct asus_wmi_driver asus_wmi_driver = {
+	.name = EEEPC_WMI_FILE,
+	.owner = THIS_MODULE,
+	.event_guid = EEEPC_WMI_EVENT_GUID,
+	.keymap = eeepc_wmi_keymap,
+	.input_name = "Eee PC WMI hotkeys",
+	.input_phys = EEEPC_WMI_FILE "/input0",
+	.probe = eeepc_wmi_probe,
+	.quirks = eeepc_wmi_quirks,
+};
+
+
+static int __init eeepc_wmi_init(void)
+{
+	return asus_wmi_register_driver(&asus_wmi_driver);
+}
+
+static void __exit eeepc_wmi_exit(void)
+{
+	asus_wmi_unregister_driver(&asus_wmi_driver);
+}
+
+module_init(eeepc_wmi_init);
+module_exit(eeepc_wmi_exit);
-- 
1.7.4

