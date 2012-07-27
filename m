Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2G0DER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 23:04:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41256 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab2G0DEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 23:04:15 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5012051A.4050706@jp.fujitsu.com>
Date: Fri, 27 Jul 2012 12:03:54 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: <lenb@kernel.org>, <linux-acpi@vger.kernel.org>
CC: <toshi.kani@hp.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] create sun sysfs file
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if a device has _SUN method, there is no way to know the slot unique-ID.
Thus the patch creates "sun" file in sysfs so that we can recognize it.

Index: linux-3.5/include/acpi/acpi_bus.h
===================================================================
--- linux-3.5.orig/include/acpi/acpi_bus.h	2012-07-22 05:58:29.000000000 +0900
+++ linux-3.5/include/acpi/acpi_bus.h	2012-07-27 10:05:13.860598455 +0900
@@ -209,6 +209,7 @@ struct acpi_device_pnp {
 	struct list_head ids;		/* _HID and _CIDs */
 	acpi_device_name device_name;	/* Driver-determined */
 	acpi_device_class device_class;	/*        "          */
+	unsigned long sun;		/* _SUN */
 };
 
 #define acpi_device_bid(d)	((d)->pnp.bus_id)
Index: linux-3.5/drivers/acpi/scan.c
===================================================================
--- linux-3.5.orig/drivers/acpi/scan.c	2012-07-22 05:58:29.000000000 +0900
+++ linux-3.5/drivers/acpi/scan.c	2012-07-27 10:17:55.670550879 +0900
@@ -192,10 +192,21 @@ end:
 }
 static DEVICE_ATTR(path, 0444, acpi_device_path_show, NULL);
 
+static ssize_t
+acpi_device_sun_show(struct device *dev, struct device_attribute *attr, char *buf) {
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	int result;
+
+	result = sprintf(buf, "%lu\n", acpi_dev->pnp.sun);
+	return result;
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
@@ -217,6 +228,14 @@ static int acpi_device_setup_files(struc
 			goto end;
 	}
 
+	status = acpi_evaluate_integer(dev->handle, "_SUN", NULL, &sun);
+	if (ACPI_SUCCESS(status)) {
+		dev->pnp.sun = (unsigned long)sun;
+		result = device_create_file(&dev->dev, &dev_attr_sun);
+		if (result)
+			goto end;
+	}
+
         /*
          * If device has _EJ0, 'eject' file is created that is used to trigger
          * hot-removal function from userland.
@@ -241,6 +260,10 @@ static void acpi_device_remove_files(str
 	if (ACPI_SUCCESS(status))
 		device_remove_file(&dev->dev, &dev_attr_eject);
 
+	status = acpi_get_handle(dev->handle, "_SUN", &temp);
+	if (ACPI_SUCCESS(status))
+		device_remove_file(&dev->dev, &dev_attr_sun);
+
 	device_remove_file(&dev->dev, &dev_attr_modalias);
 	device_remove_file(&dev->dev, &dev_attr_hid);
 	if (dev->handle)

