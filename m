Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab0HMEIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 00:08:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37571 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0HMEIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 00:08:12 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Corentin Chary <corentincj@iksaif.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ideapad-laptop: add new driver
Date: Fri, 13 Aug 2010 12:08:02 +0800
Message-Id: <1281672482-10909-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ideapad-laptop is a new driver which enable hotkeys on Lenovo Ideapad laptops

The driver will bind on ACPI HID:VPC2004. When hotkey pressed, the notify
function will be called and query EC to tell which key pressed.

Hotkeys enabled listed below:
 * LCD backlight switch - reports KEY_DISPLAY_OFF
 * One key restore - reports KEY_PROG1
 * Brightness Up/down - reports KEY_BRIGHTNESS_CYCLE
   Both up/down keys reports the same event. Need to find other way to detect
 * Touchpad switch - reports KEY_F13
 * Video output switch - reports KEY_SWITCHVIDEOMODE
 * Camera switch - reports KEY_CAMERA
 * Video resolution switch - reports KEY_VIDEO_NEXT
 * S/W rfkill key - reports KEY_WLAN

The developing git tree as reference:
  git://kernel.ubuntu.com/ikepanhc/ideapad-laptop.git

This patch made against current checkout of mainline kernel.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/Kconfig          |   11 +
 drivers/platform/x86/Makefile         |    1 +
 drivers/platform/x86/ideapad-laptop.c |  398 +++++++++++++++++++++++++++++++++
 3 files changed, 410 insertions(+), 0 deletions(-)
 create mode 100644 drivers/platform/x86/ideapad-laptop.c

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 79baa63..e9a203d 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -581,4 +581,15 @@ config INTEL_IPS
 	  functionality.  If in doubt, say Y here; it will only load on
 	  supported platforms.
 
+config IDEAPAD_LAPTOP
+	tristate "Ideapad Laptop Extras"
+	depends on ACPI
+	depends on INPUT
+	select INPUT_SPARSEKMAP
+	---help---
+	  This is the ACPI extra Linux driver for ideapad laptops which enable
+	  ACPI event based hotkey.
+
+	  If you have an Ideapad laptop, say Y or M here.
+
 endif # X86_PLATFORM_DEVICES
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 4744c77..47ca2b9 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -29,4 +29,5 @@ obj-$(CONFIG_INTEL_SCU_IPC)	+= intel_scu_ipc.o
 obj-$(CONFIG_RAR_REGISTER)	+= intel_rar_register.o
 obj-$(CONFIG_INTEL_IPS)		+= intel_ips.o
 obj-$(CONFIG_GPIO_INTEL_PMIC)	+= intel_pmic_gpio.o
+obj-$(CONFIG_IDEAPAD_LAPTOP)	+= ideapad-laptop.o
 
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
new file mode 100644
index 0000000..d666d24
--- /dev/null
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -0,0 +1,398 @@
+/*
+ *  ideapad-laptop.c: ACPI extra driver for ideapad series laptop
+ *
+ *  This driver is based on eeepc-laptop.c
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
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <acpi/acpi_drivers.h>
+#include <acpi/acpi_bus.h>
+#include <linux/uaccess.h>
+#include <linux/input.h>
+#include <linux/input/sparse-keymap.h>
+
+#define IDEAPAD_LAPTOP_NAME	"Ideapad ACPI extra driver"
+#define IDEAPAD_LAPTOP_FILE	"ideapad"
+
+#define IDEAPAD_ACPI_CLASS		"hotkey"
+#define IDEAPAD_ACPI_DEVICE_NAME	"Hotkey"
+#define IDEAPAD_ACPI_HID		"VPC2004"
+
+#define IDEAPAD_EC_TIMEOUT	(25)
+
+MODULE_AUTHOR("Ike Panhc");
+MODULE_DESCRIPTION(IDEAPAD_LAPTOP_NAME);
+MODULE_LICENSE("GPL");
+
+/*
+ * This is the main structure, we can use it to store useful information
+ */
+struct ideapad_laptop {
+	acpi_handle handle;		/* the handle of the acpi device */
+	u32 cm_supported;		/* the control methods supported
+					   by this BIOS */
+	u16 event_count[128];		/* count for each event */
+
+	struct platform_device *platform_device;
+	struct input_dev *inputdev;
+
+	int cfg;
+};
+
+/*
+ * ACPI Helpers
+ */
+static int read_method_int(acpi_handle handle, const char *method, int *val)
+{
+	acpi_status status;
+	unsigned long long result;
+
+	status = acpi_evaluate_integer(handle, (char *)method, NULL, &result);
+	if (ACPI_FAILURE(status)) {
+		*val = -1;
+		return -1;
+	} else {
+		*val = result;
+		return 0;
+	}
+}
+
+static int method_vpcr(acpi_handle handle, int cmd, int *ret)
+{
+	acpi_status status;
+	unsigned long long result;
+	struct acpi_object_list params;
+	union acpi_object in_obj;
+
+	params.count = 1;
+	params.pointer = &in_obj;
+	in_obj.type = ACPI_TYPE_INTEGER;
+	in_obj.integer.value = cmd;
+
+	status = acpi_evaluate_integer(handle, "VPCR", &params, &result);
+
+	if (ACPI_FAILURE(status)) {
+		*ret = -1;
+		return -1;
+	} else {
+		*ret = result;
+		return 0;
+	}
+}
+
+static int method_vpcw(acpi_handle handle, int cmd, int data)
+{
+	struct acpi_object_list params;
+	union acpi_object in_obj[2];
+	acpi_status status;
+
+	params.count = 2;
+	params.pointer = in_obj;
+	in_obj[0].type = ACPI_TYPE_INTEGER;
+	in_obj[0].integer.value = cmd;
+	in_obj[1].type = ACPI_TYPE_INTEGER;
+	in_obj[1].integer.value = data;
+	status = acpi_evaluate_object(handle, "VPCW", &params, NULL);
+	if (status != AE_OK)
+		return -1;
+	return 0;
+}
+
+static int read_ec_data(acpi_handle handle, int cmd, unsigned long *data)
+{
+	int val;
+	unsigned long int start_jiffies, now_jiffies;
+
+	if (method_vpcw(handle, 1, cmd))
+		return -1;
+
+	for (start_jiffies = jiffies;; ) {
+		if (method_vpcr(handle, 1, &val))
+			return -1;
+		if (val == 0) {
+			if (method_vpcr(handle, 0, &val))
+				return -1;
+			*data = val;
+			return 0;
+		}
+		now_jiffies = jiffies;
+		if ((now_jiffies-start_jiffies) > (HZ)/IDEAPAD_EC_TIMEOUT+1) {
+			pr_err("timeout in read_ec_cmd\n");
+			return -1;
+		}
+	}
+}
+
+/*
+ * Platform driver
+ */
+static struct platform_driver platform_driver = {
+	.driver = {
+		.name = IDEAPAD_LAPTOP_FILE,
+		.owner = THIS_MODULE,
+	}
+};
+
+static int ideapad_platform_init(struct ideapad_laptop *ideapad)
+{
+	int result;
+
+	ideapad->platform_device = platform_device_alloc(IDEAPAD_LAPTOP_FILE,
+							-1);
+	if (!ideapad->platform_device)
+		return -ENOMEM;
+	platform_set_drvdata(ideapad->platform_device, ideapad);
+
+	result = platform_device_add(ideapad->platform_device);
+	if (result)
+		goto fail_platform_device;
+
+	return 0;
+
+fail_platform_device:
+	platform_device_put(ideapad->platform_device);
+	return result;
+}
+
+static void ideapad_platform_exit(struct ideapad_laptop *ideapad)
+{
+	platform_device_unregister(ideapad->platform_device);
+}
+
+/*
+ * Input device
+ */
+static const struct key_entry ideapad_keymap[] = {
+	{ KE_KEY, 0x02, { KEY_DISPLAY_OFF } },
+	{ KE_KEY, 0x03, { KEY_PROG1 } },
+	{ KE_KEY, 0x04, { KEY_BRIGHTNESS_CYCLE } },
+	{ KE_KEY, 0x05, { KEY_F13 } },
+	{ KE_KEY, 0x06, { KEY_SWITCHVIDEOMODE } },
+	{ KE_KEY, 0x07, { KEY_CAMERA } },
+	{ KE_KEY, 0x0B, { KEY_VIDEO_NEXT } },
+	{ KE_KEY, 0x0D, { KEY_WLAN } },
+	{ KE_END, 0},
+};
+
+static int ideapad_input_init(struct ideapad_laptop *ideapad)
+{
+	struct input_dev *input;
+	int error;
+
+	input = input_allocate_device();
+	if (!input) {
+		pr_info("Unable to allocate input device\n");
+		return -ENOMEM;
+	}
+
+	input->name = "Lenovo Ideapad Hotkeys";
+	input->phys = IDEAPAD_LAPTOP_FILE "/input0";
+	input->id.bustype = BUS_HOST;
+	input->dev.parent = &ideapad->platform_device->dev;
+
+	error = sparse_keymap_setup(input, ideapad_keymap, NULL);
+	if (error) {
+		pr_err("Unable to setup input device keymap\n");
+		goto err_free_dev;
+	}
+
+	error = input_register_device(input);
+	if (error) {
+		pr_err("Unable to register input device\n");
+		goto err_free_keymap;
+	}
+
+	ideapad->inputdev = input;
+	return 0;
+
+err_free_keymap:
+	sparse_keymap_free(input);
+err_free_dev:
+	input_free_device(input);
+	return error;
+}
+
+static void ideapad_input_exit(struct ideapad_laptop *ideapad)
+{
+	if (ideapad->inputdev)
+		input_unregister_device(ideapad->inputdev);
+}
+
+/*
+ * ACPI driver
+ */
+static void ideapad_acpi_notify(struct acpi_device *device, u32 event)
+{
+	struct ideapad_laptop *ideapad = device->driver_data;
+	acpi_handle handle = ideapad->handle;
+	unsigned long vpc1, vpc2, vpc_bit;
+
+	if (read_ec_data(handle, 0x10, &vpc1))
+		return;
+	if (read_ec_data(handle, 0x1A, &vpc2))
+		return;
+
+	vpc1 = (vpc2 << 8) | vpc1;
+	for (vpc_bit = 0; vpc_bit < 16; vpc_bit++) {
+		if (test_bit(vpc_bit, &vpc1)) {
+			if (vpc_bit == 9)
+				continue;
+			sparse_keymap_report_event(ideapad->inputdev, event, 1,
+						true);
+		}
+	}
+}
+
+static int ideapad_acpi_init(struct ideapad_laptop *ideapad,
+			   struct acpi_device *device)
+{
+	int result;
+	acpi_handle handle = ideapad->handle;
+
+	result = acpi_bus_get_status(device);
+	if (result)
+		return result;
+	if (!device->status.present) {
+		pr_err("Hotkey device not present, aborting\n");
+		return -ENODEV;
+	}
+
+	if (read_method_int(handle, "_STA", &result)) {
+		pr_err("Access _STA failed\n");
+		return -ENODEV;
+	}
+	if (result != 0x0F) {
+		pr_err("_STA return unknown value: 0x%X\n", result);
+		return -ENODEV;
+	}
+
+	if (read_method_int(handle, "_CFG", &result)) {
+		pr_err("Access _CFG failed\n");
+		return -ENODEV;
+	}
+	ideapad->cfg = result;
+
+	return 0;
+}
+
+static bool ideapad_device_present;
+
+static int __devinit ideapad_acpi_add(struct acpi_device *device)
+{
+	struct ideapad_laptop *ideapad;
+	int result;
+
+	ideapad = kzalloc(sizeof(struct ideapad_laptop), GFP_KERNEL);
+	if (!ideapad)
+		return -ENOMEM;
+	ideapad->handle = device->handle;
+	strcpy(acpi_device_name(device), IDEAPAD_ACPI_DEVICE_NAME);
+	strcpy(acpi_device_class(device), IDEAPAD_ACPI_CLASS);
+	device->driver_data = ideapad;
+
+	result = ideapad_acpi_init(ideapad, device);
+	if (result)
+		goto fail_platform;
+
+	result = ideapad_platform_init(ideapad);
+	if (result)
+		goto fail_platform;
+
+	result = ideapad_input_init(ideapad);
+	if (result)
+		goto fail_input;
+
+	ideapad_device_present = true;
+	return 0;
+
+fail_input:
+	ideapad_platform_exit(ideapad);
+fail_platform:
+	kfree(ideapad);
+
+	return result;
+}
+
+static int ideapad_acpi_remove(struct acpi_device *device, int type)
+{
+	struct ideapad_laptop *ideapad = acpi_driver_data(device);
+
+	ideapad_input_exit(ideapad);
+	ideapad_platform_exit(ideapad);
+
+	kfree(ideapad);
+	return 0;
+}
+
+
+static const struct acpi_device_id ideapad_device_ids[] = {
+	{IDEAPAD_ACPI_HID, 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, ideapad_device_ids);
+
+static struct acpi_driver ideapad_acpi_driver = {
+	.name = IDEAPAD_LAPTOP_NAME,
+	.class = IDEAPAD_ACPI_CLASS,
+	.owner = THIS_MODULE,
+	.ids = ideapad_device_ids,
+	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
+	.ops = {
+		.add = ideapad_acpi_add,
+		.remove = ideapad_acpi_remove,
+		.notify = ideapad_acpi_notify,
+	},
+};
+
+
+static int __init ideapad_laptop_init(void)
+{
+	int result;
+
+	result = platform_driver_register(&platform_driver);
+	if (result < 0)
+		return result;
+
+	result = acpi_bus_register_driver(&ideapad_acpi_driver);
+	if (result < 0)
+		goto fail_acpi_driver;
+
+	if (!ideapad_device_present) {
+		result = -ENODEV;
+		goto fail_no_device;
+	}
+
+	return 0;
+
+fail_no_device:
+	acpi_bus_unregister_driver(&ideapad_acpi_driver);
+fail_acpi_driver:
+	platform_driver_unregister(&platform_driver);
+	return result;
+}
+
+static void __exit ideapad_laptop_exit(void)
+{
+	acpi_bus_unregister_driver(&ideapad_acpi_driver);
+	platform_driver_unregister(&platform_driver);
+}
+
+module_init(ideapad_laptop_init);
+module_exit(ideapad_laptop_exit);
-- 
1.7.0.4

