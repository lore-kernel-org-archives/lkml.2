Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab2GXDDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 23:03:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52786 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab2GXDDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 23:03:35 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <500E107A.7030907@jp.fujitsu.com>
Date: Tue, 24 Jul 2012 12:03:22 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: <lenb@kernel.org>, <linux-acpi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] acpi : create sun sysfs file in container device
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no comment on the patch about a month. But I want to merge the patch
into linux-3.6. So I resend it. 

---
Even if container device has _SUN method, the method is ignored. So we cannot
know slot-unique ID number of the container device. The patch creates "sun"
file in sysfs so that we can recognize it.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 drivers/acpi/container.c |   36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

Index: linux-3.5-rc1/drivers/acpi/container.c
===================================================================
--- linux-3.5-rc1.orig/drivers/acpi/container.c	2012-06-14 15:35:31.045500166 +0900
+++ linux-3.5-rc1/drivers/acpi/container.c	2012-06-14 16:40:13.010405144 +0900
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/acpi.h>
+#include <linux/device.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include <acpi/container.h>
@@ -93,10 +94,30 @@ static int is_device_present(acpi_handle
 }

 /*******************************************************************/
+
+static ssize_t acpi_device_sun_show(struct device *dev,
+				    struct device_attribute *attr, char *buf) {
+	struct acpi_device *device = to_acpi_device(dev);
+	acpi_status status;
+	unsigned long long sun;
+
+	status = acpi_evaluate_integer(device->handle, "_SUN", NULL,  &sun);
+	if (ACPI_FAILURE(status))
+		return 0;
+
+	return sprintf(buf, "%llu\n", sun);
+}
+
+static DEVICE_ATTR(sun, 0444, acpi_device_sun_show, NULL);
+
+/*******************************************************************/
+
 static int acpi_container_add(struct acpi_device *device)
 {
 	struct acpi_container *container;
-
+	acpi_status status;
+	acpi_handle temp;
+	int result = 0;

 	if (!device) {
 		printk(KERN_ERR PREFIX "device is NULL\n");
@@ -115,13 +136,22 @@ static int acpi_container_add(struct acp
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device <%s> bid <%s>\n",
 			  acpi_device_name(device), acpi_device_bid(device)));

-	return 0;
+	status = acpi_get_handle(device->handle, "_SUN", &temp);
+	if (ACPI_SUCCESS(status))
+		result = device_create_file(&device->dev, &dev_attr_sun);
+
+	return result;
 }

 static int acpi_container_remove(struct acpi_device *device, int type)
 {
-	acpi_status status = AE_OK;
+	acpi_status status;
 	struct acpi_container *pc = NULL;
+	acpi_handle temp;
+
+	status = acpi_get_handle(device->handle, "_SUN", &temp);
+	if (ACPI_SUCCESS(status))
+		device_remove_file(&device->dev, &dev_attr_sun);

 	pc = acpi_driver_data(device);
 	kfree(pc);

