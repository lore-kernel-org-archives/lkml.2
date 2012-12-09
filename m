Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934643Ab2LIXA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 18:00:29 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:50207 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934600Ab2LIXAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 18:00:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 1/6] ACPI: Separate adding ACPI device objects from probing ACPI drivers
Date: Mon, 10 Dec 2012 00:00:02 +0100
Message-ID: <4002729.BbipMAJtM0@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8; KDE/4.9.3; x86_64; ; )
In-Reply-To: <8498184.VilrUmatxI@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Currently, as soon as an ACPI device node object (struct acpi_device)
is created, the driver core attempts to probe ACPI drivers against
it.  That leads to some unpleasant side effects, like the fact that
the boot code path for ACPI namespace scanning is different from the
analogous hot-plug code path (during boot ACPI drivers are not
present when ACPI device node objects are registered, so they are
guaranteed not to be probed, which is not the case during hot-plug).
That, in turn, leads to unnecessary complications in the PCI
enumeration algorithm.

Reduce the differences between the boot and hot-plug cases by
splitting the ACPI namespace scanning for devices into two passes,
such that struct acpi_device objects are registerd in the first
patch without probing ACPI drivers and the drivers are probed
against them directly in the second pass.  This way ACPI drivers
can assume that all of the ACPI device node objects in the given
scope will be registered when their .add() routines run and the
hot-plug case becomes the same as the boot case from their
perspective.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c     |   96 +++++++++++++++++++++++++++++++++---------------
 include/acpi/acpi_bus.h |    1 
 2 files changed, 68 insertions(+), 29 deletions(-)

Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -98,6 +98,7 @@ typedef void (*acpi_op_notify) (struct a
 struct acpi_bus_ops {
 	u32 acpi_op_add:1;
 	u32 acpi_op_start:1;
+	u32 acpi_op_match:1;
 };
 
 struct acpi_device_ops {
Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -494,7 +494,8 @@ static int acpi_bus_match(struct device
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	struct acpi_driver *acpi_drv = to_acpi_driver(drv);
 
-	return !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
+	return acpi_dev->bus_ops.acpi_op_match
+		&& !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
 }
 
 static int acpi_device_uevent(struct device *dev, struct kobj_uevent_env *env)
@@ -1418,6 +1419,17 @@ static int acpi_bus_remove(struct acpi_d
 	return 0;
 }
 
+/*
+ * acpi_hot_add_bind - Bind _ADR-based devices on hot-add.
+ * @device: ACPI device node to bind.
+ */
+static void acpi_hot_add_bind(struct acpi_device *device)
+{
+	if (device->flags.bus_address
+	    && device->parent && device->parent->ops.bind)
+		device->parent->ops.bind(device);
+}
+
 static int acpi_add_single_object(struct acpi_device **child,
 				  acpi_handle handle, int type,
 				  unsigned long long sta,
@@ -1490,13 +1502,8 @@ static int acpi_add_single_object(struct
 
 	result = acpi_device_register(device);
 
-	/*
-	 * Bind _ADR-Based Devices when hot add
-	 */
-	if (device->flags.bus_address) {
-		if (device->parent && device->parent->ops.bind)
-			device->parent->ops.bind(device);
-	}
+	if (device->bus_ops.acpi_op_match)
+		acpi_hot_add_bind(device);
 
 end:
 	if (!result) {
@@ -1522,6 +1529,7 @@ static void acpi_bus_add_power_resource(
 	struct acpi_bus_ops ops = {
 		.acpi_op_add = 1,
 		.acpi_op_start = 1,
+		.acpi_op_match = 1,
 	};
 	struct acpi_device *device = NULL;
 
@@ -1574,9 +1582,9 @@ static acpi_status acpi_bus_check_add(ac
 				      void *context, void **return_value)
 {
 	struct acpi_bus_ops *ops = context;
+	struct acpi_device *device = NULL;
 	int type;
 	unsigned long long sta;
-	struct acpi_device *device;
 	acpi_status status;
 	int result;
 
@@ -1600,48 +1608,77 @@ static acpi_status acpi_bus_check_add(ac
 	 * We may already have an acpi_device from a previous enumeration.  If
 	 * so, we needn't add it again, but we may still have to start it.
 	 */
-	device = NULL;
 	acpi_bus_get_device(handle, &device);
 	if (ops->acpi_op_add && !device) {
-		acpi_add_single_object(&device, handle, type, sta, ops);
-		/* Is the device a known good platform device? */
-		if (device
-		    && !acpi_match_device_ids(device, acpi_platform_device_ids))
-			acpi_create_platform_device(device);
-	}
+		struct acpi_bus_ops add_ops = *ops;
 
-	if (!device)
-		return AE_CTRL_DEPTH;
-
-	if (ops->acpi_op_start && !(ops->acpi_op_add)) {
-		status = acpi_start_single_object(device);
-		if (ACPI_FAILURE(status))
+		add_ops.acpi_op_match = 0;
+		acpi_add_single_object(&device, handle, type, sta, &add_ops);
+		if (!device)
 			return AE_CTRL_DEPTH;
+
+		device->bus_ops.acpi_op_match = 1;
 	}
 
 	if (!*return_value)
 		*return_value = device;
+
 	return AE_OK;
 }
 
+static acpi_status acpi_bus_probe_start(acpi_handle handle, u32 lvl,
+					void *context, void **not_used)
+{
+	struct acpi_bus_ops *ops = context;
+	struct acpi_device *device;
+	acpi_status status = AE_OK;
+
+	if (acpi_bus_get_device(handle, &device))
+		return AE_CTRL_DEPTH;
+
+	if (ops->acpi_op_add) {
+		if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
+			/* This is a known good platform device. */
+			acpi_create_platform_device(device);
+		} else {
+			int ret = device_attach(&device->dev);
+			acpi_hot_add_bind(device);
+			if (ret)
+				status = AE_CTRL_DEPTH;
+		}
+	} else if (ops->acpi_op_start) {
+		if (ACPI_FAILURE(acpi_start_single_object(device)))
+			status = AE_CTRL_DEPTH;
+	}
+	return status;
+}
+
 static int acpi_bus_scan(acpi_handle handle, struct acpi_bus_ops *ops,
 			 struct acpi_device **child)
 {
-	acpi_status status;
 	void *device = NULL;
+	acpi_status status;
+	int ret = 0;
 
 	status = acpi_bus_check_add(handle, 0, ops, &device);
-	if (ACPI_SUCCESS(status))
+	if (ACPI_FAILURE(status)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
+			    acpi_bus_check_add, NULL, ops, &device);
+	if (device)
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
-				    acpi_bus_check_add, NULL, ops, &device);
+				    acpi_bus_probe_start, NULL, ops, NULL);
+	else
+		ret = -ENODEV;
 
+ out:
 	if (child)
 		*child = device;
 
-	if (device)
-		return 0;
-	else
-		return -ENODEV;
+	return ret;
 }
 
 /*
@@ -1752,6 +1789,7 @@ static int acpi_bus_scan_fixed(void)
 	memset(&ops, 0, sizeof(ops));
 	ops.acpi_op_add = 1;
 	ops.acpi_op_start = 1;
+	ops.acpi_op_match = 1;
 
 	/*
 	 * Enumerate all fixed-feature devices.

