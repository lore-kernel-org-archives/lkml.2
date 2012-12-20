Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab2LTB47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:56:59 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38325 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab2LTBzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:55:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 1/16] ACPI: Separate adding ACPI device objects from probing ACPI drivers
Date: Thu, 20 Dec 2012 02:47:47 +0100
Message-ID: <23002897.6xbQGtPaGy@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1855256.SyhOJGYMIh@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <4082842.31rfDviYHK@vostro.rjw.lan> <1855256.SyhOJGYMIh@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Split the ACPI namespace scanning for devices into two passes, such
that struct acpi_device objects are registerd in the first pass
without probing ACPI drivers and the drivers are probed against them
directly in the second pass.

There are two main reasons for doing that.

First, the ACPI PCI root bridge driver's .add() routine,
acpi_pci_root_add(), causes struct pci_dev objects to be created for
all PCI devices under the given root bridge.  Usually, there are
corresponding ACPI device nodes in the ACPI namespace for some of
those devices and therefore there should be "companion" struct
acpi_device objects to attach those struct pci_dev objects to.  These
struct acpi_device objects should exist when the corresponding
struct pci_dev objects are created, but that is only guaranteed
during boot and not during hotplug.  This leads to a number of
functional differences between the boot and the hotplug cases which
are not strictly necessary and make the code more complicated.

For example, this forces the ACPI PCI root bridge driver to defer the
registration of the just created struct pci_dev objects and to use a
special .start() callback routine, acpi_pci_root_start(), to make
sure that all of the "companion" struct acpi_device objects will be
present at PCI devices registration time during hotplug.

If those differences can be eliminated, we will be able to
consolidate the boot and hotplug code paths for the enumeration and
registration of PCI devices and to reduce the complexity of that
code quite a bit.

The second reason is that, in general, it should be possible to
resolve conflicts of resources assigned by the BIOS to different
devices represented by ACPI namespace nodes before any drivers bind
to them and before they are attached to "companion" objects
representing physical devices (such as struct pci_dev).  However, for
this purpose we first need to enumerate all ACPI device nodes in the
given namespace scope.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/scan.c     |  103 +++++++++++++++++++++++++++++++++---------------
 include/acpi/acpi_bus.h |    1 
 2 files changed, 73 insertions(+), 31 deletions(-)

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
 
@@ -1596,52 +1604,84 @@ static acpi_status acpi_bus_check_add(ac
 		return AE_CTRL_DEPTH;
 	}
 
-	/*
-	 * We may already have an acpi_device from a previous enumeration.  If
-	 * so, we needn't add it again, but we may still have to start it.
-	 */
-	device = NULL;
 	acpi_bus_get_device(handle, &device);
 	if (ops->acpi_op_add && !device) {
-		acpi_add_single_object(&device, handle, type, sta, ops);
-		/* Is the device a known good platform device? */
-		if (device
-		    && !acpi_match_device_ids(device, acpi_platform_device_ids))
-			acpi_create_platform_device(device);
-	}
-
-	if (!device)
-		return AE_CTRL_DEPTH;
+		struct acpi_bus_ops add_ops = *ops;
 
-	if (ops->acpi_op_start && !(ops->acpi_op_add)) {
-		status = acpi_start_single_object(device);
-		if (ACPI_FAILURE(status))
+		add_ops.acpi_op_match = 0;
+		acpi_add_single_object(&device, handle, type, sta, &add_ops);
+		if (!device)
 			return AE_CTRL_DEPTH;
+
+		device->bus_ops.acpi_op_match = 1;
+		acpi_hot_add_bind(device);
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
+	acpi_status status = AE_OK;
+	struct acpi_device *device;
+	unsigned long long sta_not_used;
+	int type_not_used;
+
+	/*
+	 * Ignore errors ignored by acpi_bus_check_add() to avoid terminating
+	 * namespace walks prematurely.
+	 */
+	if (acpi_bus_type_and_status(handle, &type_not_used, &sta_not_used))
+		return AE_OK;
+
+	if (acpi_bus_get_device(handle, &device))
+		return AE_CTRL_DEPTH;
+
+	if (ops->acpi_op_add) {
+		if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
+			/* This is a known good platform device. */
+			acpi_create_platform_device(device);
+		} else if (device_attach(&device->dev)) {
+			status = AE_CTRL_DEPTH;
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
+	int ret = -ENODEV;
 
 	status = acpi_bus_check_add(handle, 0, ops, &device);
 	if (ACPI_SUCCESS(status))
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
 				    acpi_bus_check_add, NULL, ops, &device);
 
+	if (!device)
+		goto out;
+
+	ret = 0;
+	status = acpi_bus_probe_start(handle, 0, ops, NULL);
+	if (ACPI_SUCCESS(status))
+		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
+				    acpi_bus_probe_start, NULL, ops, NULL);
+
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
@@ -1752,6 +1792,7 @@ static int acpi_bus_scan_fixed(void)
 	memset(&ops, 0, sizeof(ops));
 	ops.acpi_op_add = 1;
 	ops.acpi_op_start = 1;
+	ops.acpi_op_match = 1;
 
 	/*
 	 * Enumerate all fixed-feature devices.

