Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2LTB5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:57:48 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38318 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab2LTBzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:55:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 12/16] ACPI: Make acpi_bus_scan() and acpi_bus_add() take only one argument
Date: Thu, 20 Dec 2012 02:56:11 +0100
Message-ID: <1450734.GdNQMdHee5@vostro.rjw.lan>
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

The callers of acpi_bus_add() usually assume that if it has
succeeded, then a struct acpi_device object has been attached to
the handle passed as the first argument.  Unfortunately, however,
this assumption is wrong, because acpi_bus_scan(), and acpi_bus_add()
too as a result, may return a pointer to a different struct
acpi_device object on success (it may be an object corresponding to
one of the descendant ACPI nodes in the namespace scope below that
handle).

For this reason, the callers of acpi_bus_add() who care about
whether or not a struct acpi_device object has been created for
its first argument need to check that using acpi_bus_get_device()
anyway, so the second argument of acpi_bus_add() is not really
useful for them.  The same observation applies to acpi_bus_scan()
executed directly from acpi_scan_init().

Therefore modify the relevant callers of acpi_bus_add() to check the
existence of the struct acpi_device in question with the help of
acpi_bus_get_device() and drop the no longer necessary second
argument of acpi_bus_add().  Accordingly, modify acpi_scan_init() to
use acpi_bus_get_device() to get acpi_root and drop the no longer
needed second argument of acpi_bus_scan().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/acpi_memhotplug.c     |    7 +++++-
 drivers/acpi/container.c           |    7 +++++-
 drivers/acpi/dock.c                |    4 ++-
 drivers/acpi/processor_driver.c    |    8 +++++--
 drivers/acpi/scan.c                |   38 ++++++++++---------------------------
 drivers/pci/hotplug/acpiphp_glue.c |   19 ++++++++++--------
 drivers/pci/hotplug/sgi_hotplug.c  |    3 --
 include/acpi/acpi_bus.h            |    2 -
 8 files changed, 45 insertions(+), 43 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -1661,37 +1661,27 @@ static acpi_status acpi_bus_device_attac
 	return status;
 }
 
-static int acpi_bus_scan(acpi_handle handle, struct acpi_device **child)
+static int acpi_bus_scan(acpi_handle handle)
 {
 	void *device = NULL;
-	acpi_status status;
-	int ret = -ENODEV;
 
-	status = acpi_bus_check_add(handle, 0, NULL, &device);
-	if (ACPI_SUCCESS(status))
+	if (ACPI_SUCCESS(acpi_bus_check_add(handle, 0, NULL, &device)))
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
 				    acpi_bus_check_add, NULL, NULL, &device);
 
 	if (!device)
-		goto out;
+		return -ENODEV;
 
-	ret = 0;
-	status = acpi_bus_device_attach(handle, 0, NULL, NULL);
-	if (ACPI_SUCCESS(status))
+	if (ACPI_SUCCESS(acpi_bus_device_attach(handle, 0, NULL, NULL)))
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
 				    acpi_bus_device_attach, NULL, NULL, NULL);
 
- out:
-	if (child)
-		*child = device;
-
-	return ret;
+	return 0;
 }
 
 /**
  * acpi_bus_add - Add ACPI device node objects in a given namespace scope.
  * @handle: Root of the namespace scope to scan.
- * @ret: Location to store a return struct acpi_device pointer.
  *
  * Scan a given ACPI tree (probably recently hot-plugged) and create and add
  * found devices.
@@ -1700,21 +1690,12 @@ static int acpi_bus_scan(acpi_handle han
  * there has been a real error.  There just have been no suitable ACPI objects
  * in the table trunk from which the kernel could create a device and add an
  * appropriate driver.
- *
- * If 0 is returned, the memory location pointed to by @ret will be populated
- * with a pointer to a struct acpi_device created while scanning the namespace.
- * If @handle corresponds to a device node, that will be a pointer to the struct
- * acpi_device object corresponding to @handle.  Otherwise, it will be a pointer
- * to a struct acpi_device corresponding to one of its descendants.
- *
- * If an error code is returned, NULL will be stored in the memory location
- * pointed to by @ret.
  */
-int acpi_bus_add(acpi_handle handle, struct acpi_device **ret)
+int acpi_bus_add(acpi_handle handle)
 {
 	int err;
 
-	err = acpi_bus_scan(handle, ret);
+	err = acpi_bus_scan(handle);
 	if (err)
 		return err;
 
@@ -1818,8 +1799,11 @@ int __init acpi_scan_init(void)
 	/*
 	 * Enumerate devices in the ACPI namespace.
 	 */
-	result = acpi_bus_scan(ACPI_ROOT_OBJECT, &acpi_root);
+	result = acpi_bus_scan(ACPI_ROOT_OBJECT);
+	if (result)
+		return result;
 
+	result = acpi_bus_get_device(ACPI_ROOT_OBJECT, &acpi_root);
 	if (!result)
 		result = acpi_bus_scan_fixed();
 
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -391,7 +391,7 @@ static inline int acpi_bus_generate_proc
 #endif
 int acpi_bus_register_driver(struct acpi_driver *driver);
 void acpi_bus_unregister_driver(struct acpi_driver *driver);
-int acpi_bus_add(acpi_handle handle, struct acpi_device **ret);
+int acpi_bus_add(acpi_handle handle);
 void acpi_bus_hot_remove_device(void *context);
 int acpi_bus_trim(struct acpi_device *start, int rmdevice);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
Index: linux/drivers/pci/hotplug/sgi_hotplug.c
===================================================================
--- linux.orig/drivers/pci/hotplug/sgi_hotplug.c
+++ linux/drivers/pci/hotplug/sgi_hotplug.c
@@ -412,7 +412,6 @@ static int enable_slot(struct hotplug_sl
 	if (SN_ACPI_BASE_SUPPORT() && ssdt) {
 		unsigned long long adr;
 		struct acpi_device *pdevice;
-		struct acpi_device *device;
 		acpi_handle phandle;
 		acpi_handle chandle = NULL;
 		acpi_handle rethandle;
@@ -448,7 +447,7 @@ static int enable_slot(struct hotplug_sl
 			if (ACPI_SUCCESS(ret) &&
 			    (adr>>16) == (slot->device_num + 1)) {
 
-				ret = acpi_bus_add(chandle, &device);
+				ret = acpi_bus_add(chandle);
 				if (ACPI_FAILURE(ret)) {
 					printk(KERN_ERR "%s: acpi_bus_add "
 					       "failed (0x%x) for slot %d "
Index: linux/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux/drivers/pci/hotplug/acpiphp_glue.c
@@ -746,14 +746,13 @@ static int acpiphp_bus_add(struct acpiph
 		dbg("acpi_bus_trim return %x\n", ret_val);
 	}
 
-	ret_val = acpi_bus_add(func->handle, &device);
-	if (ret_val) {
-		dbg("error adding bus, %x\n",
-			-ret_val);
-		goto acpiphp_bus_add_out;
-	}
+	ret_val = acpi_bus_add(func->handle);
+	if (!ret_val)
+		ret_val = acpi_bus_get_device(func->handle, &device);
+
+	if (ret_val)
+		dbg("error adding bus, %x\n", -ret_val);
 
-acpiphp_bus_add_out:
 	return ret_val;
 }
 
@@ -1130,10 +1129,14 @@ static void handle_bridge_insertion(acpi
 		return;
 	}
 
-	if (acpi_bus_add(handle, &device)) {
+	if (acpi_bus_add(handle)) {
 		err("cannot add bridge to acpi list\n");
 		return;
 	}
+	if (acpi_bus_get_device(handle, &device)) {
+		err("ACPI device object missing\n");
+		return;
+	}
 	if (!acpiphp_configure_bridge(handle))
 		add_bridge(handle);
 	else
Index: linux/drivers/acpi/processor_driver.c
===================================================================
--- linux.orig/drivers/acpi/processor_driver.c
+++ linux/drivers/acpi/processor_driver.c
@@ -699,12 +699,16 @@ static void acpi_processor_hotplug_notif
 		if (!acpi_bus_get_device(handle, &device))
 			break;
 
-		result = acpi_bus_add(handle, &device);
+		result = acpi_bus_add(handle);
 		if (result) {
 			acpi_handle_err(handle, "Unable to add the device\n");
 			break;
 		}
-
+		result = acpi_bus_get_device(handle, &device);
+		if (result) {
+			acpi_handle_err(handle, "Missing device object\n");
+			break;
+		}
 		ost_code = ACPI_OST_SC_SUCCESS;
 		break;
 
Index: linux/drivers/acpi/dock.c
===================================================================
--- linux.orig/drivers/acpi/dock.c
+++ linux/drivers/acpi/dock.c
@@ -317,9 +317,11 @@ static struct acpi_device * dock_create_
 		 * no device created for this object,
 		 * so we should create one.
 		 */
-		ret = acpi_bus_add(handle, &device);
+		ret = acpi_bus_add(handle);
 		if (ret)
 			pr_debug("error adding bus, %x\n", -ret);
+
+		acpi_bus_get_device(handle, &device);
 	}
 	return device;
 }
Index: linux/drivers/acpi/container.c
===================================================================
--- linux.orig/drivers/acpi/container.c
+++ linux/drivers/acpi/container.c
@@ -166,11 +166,16 @@ static void container_notify_cb(acpi_han
 		if (!ACPI_FAILURE(status) || device)
 			break;
 
-		result = acpi_bus_add(handle, &device);
+		result = acpi_bus_add(handle);
 		if (result) {
 			acpi_handle_warn(handle, "Failed to add container\n");
 			break;
 		}
+		result = acpi_bus_get_device(handle, &device);
+		if (result) {
+			acpi_handle_warn(handle, "Missing device object\n");
+			break;
+		}
 
 		kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
 		ost_code = ACPI_OST_SC_SUCCESS;
Index: linux/drivers/acpi/acpi_memhotplug.c
===================================================================
--- linux.orig/drivers/acpi/acpi_memhotplug.c
+++ linux/drivers/acpi/acpi_memhotplug.c
@@ -167,11 +167,16 @@ acpi_memory_get_device(acpi_handle handl
 	 * Now add the notified device.  This creates the acpi_device
 	 * and invokes .add function
 	 */
-	result = acpi_bus_add(handle, &device);
+	result = acpi_bus_add(handle);
 	if (result) {
 		acpi_handle_warn(handle, "Cannot add acpi bus\n");
 		return -EINVAL;
 	}
+	result = acpi_bus_get_device(handle, &device);
+	if (result) {
+		acpi_handle_warn(handle, "Missing device object\n");
+		return -EINVAL;
+	}
 
       end:
 	*mem_device = acpi_driver_data(device);

