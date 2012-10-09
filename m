Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab2JIGuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:50:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42427 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab2JIGuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:50:14 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5073C906.1070400@jp.fujitsu.com>
Date: Tue, 9 Oct 2012 15:49:42 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lenb@kernel.org>, <toshi.kani@hp.com>, <liuj97@gmail.com>
Subject: [PATCH v5] create sun sysfs file
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_SUN method provides the slot unique-ID in the ACPI namespace. And The value
is written in Advanced Configuration and Power Interface Specification as
follows:

"The _SUN value is required to be unique among the slots ofthe same type.
It is also recommended that this number match the slot number printed on
the physical slot whenever possible."

So if we can know the value, we can identify the physical position of the
slot in the system.

The patch creates "sun" file in sysfs for identifying physical position
of the slot.

Reviewed-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 Documentation/ABI/testing/sysfs-devices-sun |   14 ++++++++++++++
 drivers/acpi/scan.c                         |   24 ++++++++++++++++++++++++
 include/acpi/acpi_bus.h                     |    1 +
 3 files changed, 39 insertions(+)

Index: linux-3.6/include/acpi/acpi_bus.h
===================================================================
--- linux-3.6.orig/include/acpi/acpi_bus.h	2012-10-09 11:54:17.690072343 +0900
+++ linux-3.6/include/acpi/acpi_bus.h	2012-10-09 14:15:49.207794671 +0900
@@ -208,6 +208,7 @@ struct acpi_device_pnp {
 	struct list_head ids;		/* _HID and _CIDs */
 	acpi_device_name device_name;	/* Driver-determined */
 	acpi_device_class device_class;	/*        "          */
+	unsigned long sun;		/* _SUN */
 };
 
 #define acpi_device_bid(d)	((d)->pnp.bus_id)
Index: linux-3.6/drivers/acpi/scan.c
===================================================================
--- linux-3.6.orig/drivers/acpi/scan.c	2012-10-09 11:54:17.688072343 +0900
+++ linux-3.6/drivers/acpi/scan.c	2012-10-09 14:15:49.211794675 +0900
@@ -232,10 +232,20 @@ end:
 }
 static DEVICE_ATTR(path, 0444, acpi_device_path_show, NULL);
 
+static ssize_t
+acpi_device_sun_show(struct device *dev, struct device_attribute *attr,
+		     char *buf) {
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+
+	return sprintf(buf, "%lu\n", acpi_dev->pnp.sun);
+}
+static DEVICE_ATTR(sun, 0444, acpi_device_sun_show, NULL);
+
 static int acpi_device_setup_files(struct acpi_device *dev)
 {
 	acpi_status status;
 	acpi_handle temp;
+	unsigned long long sun;
 	int result = 0;
 
 	/*
@@ -257,6 +267,16 @@ static int acpi_device_setup_files(struc
 			goto end;
 	}
 
+	status = acpi_evaluate_integer(dev->handle, "_SUN", NULL, &sun);
+	if (ACPI_SUCCESS(status)) {
+		dev->pnp.sun = (unsigned long)sun;
+		result = device_create_file(&dev->dev, &dev_attr_sun);
+		if (result)
+			goto end;
+	} else {
+		dev->pnp.sun = (unsigned long)-1;
+	}
+
         /*
          * If device has _EJ0, 'eject' file is created that is used to trigger
          * hot-removal function from userland.
@@ -281,6 +301,10 @@ static void acpi_device_remove_files(str
 	if (ACPI_SUCCESS(status))
 		device_remove_file(&dev->dev, &dev_attr_eject);
 
+	status = acpi_get_handle(dev->handle, "_SUN", &temp);
+	if (ACPI_SUCCESS(status))
+		device_remove_file(&dev->dev, &dev_attr_sun);
+
 	device_remove_file(&dev->dev, &dev_attr_modalias);
 	device_remove_file(&dev->dev, &dev_attr_hid);
 	if (dev->handle)
Index: linux-3.6/Documentation/ABI/testing/sysfs-devices-sun
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-3.6/Documentation/ABI/testing/sysfs-devices-sun	2012-10-09 15:47:02.333245246 +0900
@@ -0,0 +1,14 @@
+Whatt:		/sys/devices/.../sun
+Date:		October 2012
+Contact:	Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
+Description:
+		The file contains a Slot-unique ID which provided by the _SUN
+		method in the ACPI namespace. The value is written in Advanced
+		Configuration and Power Interface Specification as follows:
+
+		"The _SUN value is required to be unique among the slots of
+		the same type. It is also recommended that this number match
+		the slot number printed on the physical slot whenever possible."
+
+		So reading the sysfs file, we can identify a physical position
+		of the slot in the system. 

