Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab0E1Rja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:39:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932559Ab0E1RjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:39:25 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] Quickstart Button ACPI driver to serve PNP0C32 ACPI devices
Date: Fri, 28 May 2010 19:40:09 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: linux-input@vger.kernel.org, Angelo Arrifano <miknix@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005281940.09925.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

if you have a recent Microsoft Office format reader you find some
documentation here:
http://www.microsoft.com/whdc/system/platform/firmware/DirAppLaunch.mspx	

I finally got it converted and these should be readable in OpenOffice as well:
ftp.suse.com/pub/people/trenn/hotstart_quickstart_docu

The idea of these buttons is that they are undefined from BIOS/kernel
point of view. Userspace has to map a functionality to them.
Therefore the idea to modify the input event keycode via sysfs file.
There should be 2 situations that perfectly are triggered via userspace:
   - DMI match (or similar) and assign the correct buttons on the known
     machine. I know that hal could do this rather well and had dmi
     tables pre-defined. AFAIK hal is already obsolete? What userspace
     tools/lists would be best to ask?

   - If the button is undefined, a higher level userspace X application
     could ask the user to set it to something useful. For this to
     happen the usage id has to be passed somehow through the input
     layer. Not sure how realistic such an implementation is and what
     is still needed in X to make this happen.

I based my work on an out-of-tree driver from Angelo.
Works here with a laptop with one such button
(always throws 0x2 -> woken up from suspend,
even it did not wake up suspend, but that should not matter).
The key isn't reachable otherwise, neither with WMI,
nor scancodes.
I didn't test the main feature (from the spec perspective): wake up from
suspend and launch the appropriate application.

I first like to have some opinions about this approach.
Especially the re-registering of the input device is not that nice,
but I couldn't see how to modify an input device' capabilities on the fly.
Seems as if it's not made for that.
Anyway, it works in this way.


Also be aware that I tested this a bit. But on review you should be able
to find the one or other bug. Hints/review appreciated.

Thanks,

       Thomas

X86 platform drivers: Introduce Quickstart Button ACPI driver to serve PNP0C32 ACPI devices

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Angelo Arrifano <miknix@gmail.com>
CC: linux-input@vger.kernel.org
CC: linux-acpi@vger.kernel.org
CC: platform-driver-x86@vger.kernel.org

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 3e1b8a2..f409d77 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -537,4 +537,15 @@ config INTEL_SCU_IPC
 	  some embedded Intel x86 platforms. This is not needed for PC-type
 	  machines.
 
+config ACPI_QUICKSTART
+       tristate "ACPI QUICKSTART quick launch button support"
+       depends on ACPI
+       select INPUT
+       default n
+       help
+         Some media and other buttons could get driven by this driver.
+	 It could get identified which button woke the machine up after
+	 a suspend and appropriate action, e.g. launch an application
+	 could be taken by userspace.
+
 endif # X86_PLATFORM_DEVICES
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 8770bfe..8dd24c0 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -25,4 +25,5 @@ obj-$(CONFIG_ACPI_ASUS)		+= asus_acpi.o
 obj-$(CONFIG_TOPSTAR_LAPTOP)	+= topstar-laptop.o
 obj-$(CONFIG_ACPI_TOSHIBA)	+= toshiba_acpi.o
 obj-$(CONFIG_TOSHIBA_BT_RFKILL)	+= toshiba_bluetooth.o
+obj-$(CONFIG_ACPI_QUICKSTART)   += quickstart.o
 obj-$(CONFIG_INTEL_SCU_IPC)	+= intel_scu_ipc.o
diff --git a/drivers/platform/x86/quickstart.c b/drivers/platform/x86/quickstart.c
new file mode 100644
index 0000000..e1e8e71
--- /dev/null
+++ b/drivers/platform/x86/quickstart.c
@@ -0,0 +1,374 @@
+/*
+ *  quickstart.c - ACPI Direct App Launch driver
+ *
+ *
+ *  Copyright (C) 2007-2010 Angelo Arrifano <miknix@gmail.com>
+ *  Copyright (C)      2010 Thomas Renninger <trenn@suse.de>
+ *
+ *  Information gathered from disassebled dsdt and from here:
+ *  "http://download.microsoft.com/download/9/c/5/
+ *  9c5b2167-8017-4bae-9fde-d599bac8184a/DirAppLaunch_Vista.doc"
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
+ *
+ */
+
+#define QUICKSTART_VERSION "1.04"
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <acpi/acpi_drivers.h>
+#include <linux/input.h>
+
+MODULE_AUTHOR("Angelo Arrifano");
+MODULE_DESCRIPTION("ACPI Direct App Launch driver");
+MODULE_LICENSE("GPL");
+
+#define QUICKSTART_ACPI_DEVICE_NAME   "quickstart"
+#define QUICKSTART_ACPI_CLASS         "quickstart"
+#define QUICKSTART_ACPI_HID           "PNP0C32"
+
+#define QUICKSTART_MAX_BTN_NAME_LEN   16
+
+/* There will be two events:
+	 * 0x02 - A hot button was pressed while device was off/sleeping.
+	 * 0x80 - A hot button was pressed while device was up. */
+#define QUICKSTART_EVENT_WAKE         0x02
+#define QUICKSTART_EVENT_RUNTIME      0x80
+
+static unsigned int max_defined_keycode = BTN_TRIGGER_HAPPY;
+
+/* ACPI driver Structs */
+struct quickstart_acpi {
+	struct acpi_device *device;
+	struct input_dev *input;
+	unsigned int id;
+	unsigned int keycode;
+};
+static int quickstart_acpi_add(struct acpi_device *device);
+static int quickstart_acpi_remove(struct acpi_device *device, int type);
+static const struct acpi_device_id  quickstart_device_ids[] = {
+	{QUICKSTART_ACPI_HID, 0},
+	{"", 0},
+};
+
+static struct acpi_driver quickstart_acpi_driver = {
+	.name = "quickstart",
+	.class = QUICKSTART_ACPI_CLASS,
+	.ids = quickstart_device_ids,
+	.ops = {
+			.add = quickstart_acpi_add,
+			.remove = quickstart_acpi_remove,
+		},
+};
+
+/* ACPI Driver functions */
+static void quickstart_acpi_notify(acpi_handle handle, u32 event, void *data)
+{
+	struct quickstart_acpi *quickstart = data;
+
+	printk(KERN_INFO "XXX Notify: Event: %d\n", event);
+
+	if (!quickstart)
+		return;
+
+	printk(KERN_INFO "Notify: Event: %d - keycode: %d\n", event,
+	       quickstart->keycode);
+	switch(event) {
+	case QUICKSTART_EVENT_WAKE:
+	case QUICKSTART_EVENT_RUNTIME:
+		printk(KERN_INFO "Send input key %d\n", quickstart->keycode);
+		input_report_key(quickstart->input, quickstart->keycode, 1);
+		input_sync(quickstart->input);
+		input_report_key(quickstart->input, quickstart->keycode, 0);
+		input_sync(quickstart->input);
+	}
+	acpi_bus_generate_netlink_event(quickstart->device->pnp.device_class,
+					dev_name(&quickstart->device->dev), event,
+					quickstart->id);
+	return;
+}
+
+static int quickstart_acpi_ghid(struct quickstart_acpi *quickstart)
+{
+	acpi_status status;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	uint32_t usageid = 0;
+	union acpi_object *obj;
+
+	if (!quickstart)
+		return -ENODEV;
+
+	/* This returns a buffer telling the button usage ID,
+	 * and triggers pending notify events (The ones before booting). */
+	status = acpi_evaluate_object(quickstart->device->handle,
+					"GHID", NULL, &buffer);
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_ERR "quickstart: %s GHID method failed\n",
+		       quickstart->device->pnp.bus_id);
+		/*
+		 * In which case do we have to free buffer.pointer?
+		 * ACPI_TYPE_BUFFER, ACPI_TYPE_STRING, ACPI_TYPE_PACKAGE
+		 * case?
+		 * A generic acpi_free_buffer(struct acpi_buffer) function
+		 * would be nice...
+		 */
+		return -EINVAL;
+	}
+
+	obj = (union acpi_object *)buffer.pointer;
+	if (!obj || obj->type != ACPI_TYPE_BUFFER)
+		return -EINVAL;
+
+	/*
+	 * <<The GHID method can return a BYTE, WORD, or DWORD.
+	 * The value must be encoded in little-endian byte
+	 * order (least significant byte first).>>
+	 *
+	 * Also handle 64 bit case, could be that a BIOS uses
+	 * an integer accidently.
+	 */
+	printk("Obj length: %d\n", obj->buffer.length);
+	switch(obj->buffer.length) {
+	case 1:
+		usageid = *((uint8_t *)(obj->buffer.pointer));
+		break;
+	case 2:
+		usageid = *((uint16_t *)(obj->buffer.pointer));
+		break;
+	case 4:
+		usageid = *((uint32_t *)(obj->buffer.pointer));
+		break;
+	case 8:
+		usageid = *((uint64_t *)(obj->buffer.pointer));
+		break;
+	default:
+		break;
+		kfree(obj->buffer.pointer);
+		return -EINVAL;
+	}
+	printk(KERN_INFO "Obj length: %d - UsageId: %d\n",
+	       obj->buffer.length, usageid);
+
+	kfree(obj->buffer.pointer);
+
+	quickstart->id = usageid;
+
+	return 0;
+}
+
+static ssize_t quickstart_usageid_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct quickstart_acpi *quickstart = acpi_dev->driver_data;
+
+	if (quickstart)
+		return sprintf(buf, "%d\n", quickstart->id);
+	return -ENODEV;
+}
+
+static ssize_t quickstart_keycode_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct quickstart_acpi *quickstart = acpi_dev->driver_data;
+
+	if (quickstart)
+		return sprintf(buf, "%d\n", quickstart->keycode);
+	return -ENODEV;
+}
+
+static ssize_t quickstart_keycode_store(struct device *dev,
+					struct device_attribute *devattr,
+					const char *buf, size_t count)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct quickstart_acpi *quickstart = acpi_dev->driver_data;
+	unsigned long temp;
+	int res;
+	char input_name[32];
+
+	if (!quickstart)
+		return -ENODEV;
+
+	res = strict_strtoul(buf, 10, &temp);
+	if (res)
+		return res;
+
+	quickstart->keycode = temp;
+	/*
+	 * Reregister input device with new capabilities
+	 * This is somewhat ugly, eventually this can be
+	 * solved somewhat more elegant.
+	*/
+	input_unregister_device(quickstart->input);
+	quickstart->input = input_allocate_device();
+	if (!quickstart->input)
+		return -ENOMEM;
+
+	sprintf(input_name, "Quickstart ACPI Button %s",
+		quickstart->device->pnp.bus_id);
+	quickstart->input->name = input_name;
+	quickstart->input->id.bustype = BUS_HOST;
+
+	input_set_capability(quickstart->input, EV_KEY,
+			     quickstart->keycode);
+	res = input_register_device(quickstart->input);
+	if (res) {
+		input_free_device(quickstart->input);
+		return -ENOMEM;
+	}
+	return count;
+}
+
+DEVICE_ATTR (keycode, 0644, quickstart_keycode_show, quickstart_keycode_store);
+DEVICE_ATTR (usageid, 0444, quickstart_usageid_show, NULL);
+
+static int quickstart_acpi_add(struct acpi_device *device)
+{
+	int ret = 0;
+	struct quickstart_acpi *quickstart = NULL;
+	acpi_status status;
+	char input_name[32];
+
+	if (max_defined_keycode >= BTN_TRIGGER_HAPPY40)
+		return -ENODEV;
+
+	if (!device)
+		return -EINVAL;
+
+	quickstart = kzalloc(sizeof(struct quickstart_acpi), GFP_KERNEL);
+	if (!quickstart)
+		return -ENOMEM;
+
+	quickstart->device = device;
+	strcpy(device->pnp.device_name, QUICKSTART_ACPI_DEVICE_NAME);
+	strcpy(device->pnp.device_class, QUICKSTART_ACPI_CLASS);
+	device->driver_data = quickstart;
+
+	ret = quickstart_acpi_ghid(quickstart);
+	printk("%s %d\n", __FUNCTION__, ret);
+	if (ret)
+		goto free_obj;
+
+	status = acpi_install_notify_handler(device->handle,
+					     ACPI_ALL_NOTIFY,
+					     quickstart_acpi_notify,
+					     quickstart);
+	if (ACPI_FAILURE(status))
+		goto free_obj;
+
+	ret = device_create_file(&device->dev, &dev_attr_keycode);
+	if (ret)
+		goto un_notify;
+
+	ret = device_create_file(&device->dev, &dev_attr_usageid);
+	if (ret)
+		goto file2;
+
+	quickstart->keycode = max_defined_keycode;
+	max_defined_keycode++;
+
+	/* Input device */
+	quickstart->input = input_allocate_device();
+	if (!quickstart->input)
+		goto file1;
+
+	sprintf(input_name, "Quickstart ACPI Button %s",
+	       quickstart->device->pnp.bus_id);
+	quickstart->input->name = input_name;
+	quickstart->input->id.bustype = BUS_HOST;
+
+	input_set_capability(quickstart->input, EV_KEY,
+			     quickstart->keycode);
+	ret = input_register_device(quickstart->input);
+	if (ret)
+		goto free_input;
+
+	return 0;
+
+ free_input:
+	input_free_device(quickstart->input);
+
+ file1:
+	device_remove_file(&device->dev, &dev_attr_usageid);
+ file2:
+	device_remove_file(&device->dev, &dev_attr_keycode);
+
+ un_notify:
+	acpi_remove_notify_handler(device->handle,
+				   ACPI_ALL_NOTIFY,
+				   quickstart_acpi_notify);
+ free_obj:
+	kfree(quickstart);
+
+	return ret;
+}
+
+static int quickstart_acpi_remove(struct acpi_device *device, int type)
+{
+	struct quickstart_acpi *quickstart;
+
+	if (!device || !device->driver_data)
+		return -EINVAL;
+
+	quickstart = device->driver_data;
+
+	input_unregister_device(quickstart->input);
+
+	acpi_remove_notify_handler(device->handle,
+				   ACPI_ALL_NOTIFY,
+				   quickstart_acpi_notify);
+
+	device_remove_file(&device->dev, &dev_attr_usageid);
+	device_remove_file(&device->dev, &dev_attr_keycode);
+
+	kfree(quickstart);
+
+	return 0;
+}
+
+/* Module functions */
+
+static void quickstart_exit(void)
+{
+	acpi_bus_unregister_driver(&quickstart_acpi_driver);
+}
+
+static int __init quickstart_init(void)
+{
+	acpi_status status = 0;
+
+	/* ACPI Check */
+	if (acpi_disabled)
+		return -ENODEV;
+
+	/* ACPI driver register */
+	status = acpi_bus_register_driver(&quickstart_acpi_driver);
+	printk("Status: %d\n", status);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	printk(KERN_INFO "quickstart: ACPI Direct App Launch ver %s\n",
+	       QUICKSTART_VERSION);
+	return 0;
+}
+
+module_init(quickstart_init);
+module_exit(quickstart_exit);
