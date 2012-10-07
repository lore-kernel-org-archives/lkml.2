Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2JGCpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 22:45:04 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35578 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2JGCo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 22:44:59 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lance Ortiz <lance.ortiz@hp.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 49/49] ACPI: Add new sysfs interface to export device description
Date: Sat,  6 Oct 2012 22:43:19 -0400
Message-Id: <d1efe3c324ead77d3f6cd85093b50f6bd2e17aba.1349554106.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349577799-566-1-git-send-email-lenb@kernel.org>
References: <1349577799-566-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lance Ortiz <lance.ortiz@hp.com>

Add support to export the device description obtained from the ACPI _STR
method, if one exists for a device, to user-space via a sysfs interface.
This new interface provides a standard and platform neutral way for users
to obtain the description text stored in the ACPI _STR method.  If no
_STR method exists for the device, no sysfs 'description' file will be
created.  The 'description' file will be located in the /sys/devices/
directory using the device's path.

/sys/device/<bus>/<bridge path>/<device path>.../firmware_node/description

Example:

/sys/devices/pci0000:00/0000:00.07.0/0000:0e:00.0/firmware_node/description

It can also be located using the ACPI device path, for example:

/sys/devices/LNXSYSTM:00/device:00/ACPI0004:00/PNP0A08:00/device:13/device:15/description
/sys/devices/LNXSYSTM:00/device:00/ACPI0004:00/ACPI0004:01/ACPI0007:02/description

Execute the 'cat' command on the 'description' file to obtain the
description string for that device.

This patch also includes documentation describing how the new sysfs
interface works

Changes from v1-v2 based on comments by Len Brown and Fengguang Wu
* Removed output "No Description" and leaving a NULL attribute if the
_STR method failed to evaluate.

* In acpi_device_remove_files() removed the redundent check of
dev->pnp.str_obj before calling free.  This check triggered a message
from smatch.

Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 .../ABI/testing/sysfs-devices-firmware_node        | 17 +++++++
 drivers/acpi/scan.c                                | 54 +++++++++++++++++++++-
 include/acpi/acpi_bus.h                            |  1 +
 3 files changed, 70 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-firmware_node

diff --git a/Documentation/ABI/testing/sysfs-devices-firmware_node b/Documentation/ABI/testing/sysfs-devices-firmware_node
new file mode 100644
index 0000000..46badc9
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-firmware_node
@@ -0,0 +1,17 @@
+What:		/sys/devices/.../firmware_node/
+Date:		September 2012
+Contact:	<>
+Description:
+		The /sys/devices/.../firmware_node directory contains attributes
+		allowing the user space to check and modify some firmware
+		related properties of given device.
+
+What:		/sys/devices/.../firmware_node/description
+Date:		September 2012
+Contact:	Lance Ortiz <lance.ortiz@hp.com>
+Description:
+		The /sys/devices/.../firmware/description attribute contains a string
+		that describes the device as provided by the _STR method in the ACPI
+		namespace.  This attribute is read-only.  If the device does not have
+		an _STR method associated with it in the ACPI namespace, this
+		attribute is not present.
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index d1ecca2..0430283 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -10,6 +10,7 @@
 #include <linux/signal.h>
 #include <linux/kthread.h>
 #include <linux/dmi.h>
+#include <linux/nls.h>
 
 #include <acpi/acpi_drivers.h>
 
@@ -232,8 +233,35 @@ end:
 }
 static DEVICE_ATTR(path, 0444, acpi_device_path_show, NULL);
 
+/* sysfs file that shows description text from the ACPI _STR method */
+static ssize_t description_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf) {
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	int result;
+
+	if (acpi_dev->pnp.str_obj == NULL)
+		return 0;
+
+	/*
+	 * The _STR object contains a Unicode identifier for a device.
+	 * We need to convert to utf-8 so it can be displayed.
+	 */
+	result = utf16s_to_utf8s(
+		(wchar_t *)acpi_dev->pnp.str_obj->buffer.pointer,
+		acpi_dev->pnp.str_obj->buffer.length,
+		UTF16_LITTLE_ENDIAN, buf,
+		PAGE_SIZE);
+
+	buf[result++] = '\n';
+
+	return result;
+}
+static DEVICE_ATTR(description, 0444, description_show, NULL);
+
 static int acpi_device_setup_files(struct acpi_device *dev)
 {
+	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
 	acpi_status status;
 	acpi_handle temp;
 	int result = 0;
@@ -257,6 +285,21 @@ static int acpi_device_setup_files(struct acpi_device *dev)
 			goto end;
 	}
 
+	/*
+	 * If device has _STR, 'description' file is created
+	 */
+	status = acpi_get_handle(dev->handle, "_STR", &temp);
+	if (ACPI_SUCCESS(status)) {
+		status = acpi_evaluate_object(dev->handle, "_STR",
+					NULL, &buffer);
+		if (ACPI_FAILURE(status))
+			buffer.pointer = NULL;
+		dev->pnp.str_obj = buffer.pointer;
+		result = device_create_file(&dev->dev, &dev_attr_description);
+		if (result)
+			goto end;
+	}
+
         /*
          * If device has _EJ0, 'eject' file is created that is used to trigger
          * hot-removal function from userland.
@@ -274,8 +317,15 @@ static void acpi_device_remove_files(struct acpi_device *dev)
 	acpi_handle temp;
 
 	/*
-	 * If device has _EJ0, 'eject' file is created that is used to trigger
-	 * hot-removal function from userland.
+	 * If device has _STR, remove 'description' file
+	 */
+	status = acpi_get_handle(dev->handle, "_STR", &temp);
+	if (ACPI_SUCCESS(status)) {
+		kfree(dev->pnp.str_obj);
+		device_remove_file(&dev->dev, &dev_attr_description);
+	}
+	/*
+	 * If device has _EJ0, remove 'eject' file.
 	 */
 	status = acpi_get_handle(dev->handle, "_EJ0", &temp);
 	if (ACPI_SUCCESS(status))
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index bde976e..3eb9de3 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -208,6 +208,7 @@ struct acpi_device_pnp {
 	struct list_head ids;		/* _HID and _CIDs */
 	acpi_device_name device_name;	/* Driver-determined */
 	acpi_device_class device_class;	/*        "          */
+	union acpi_object *str_obj;	/* unicode string for _STR method */
 };
 
 #define acpi_device_bid(d)	((d)->pnp.bus_id)
-- 
1.8.0.rc0.18.gf84667d

