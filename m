Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab2LTB4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:56:15 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38307 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab2LTBzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:55:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 9/16] ACPI: Remove the arguments of acpi_bus_add() that are not used
Date: Thu, 20 Dec 2012 02:54:07 +0100
Message-ID: <1660011.8JbRcsJcvH@vostro.rjw.lan>
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

Notice that acpi_bus_add() uses only 2 of its 4 arguments and
redefine its header to match the body.  Update all of its callers as
necessary and observe that this leads to quite a number of removed
lines of code (Linus will like that).

Add a kerneldoc comment documenting acpi_bus_add() and wonder how
its callers make wrong assumptions about the second argument (make
note to self to take care of that later).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/acpi_memhotplug.c     |   19 +------------------
 drivers/acpi/container.c           |   16 +---------------
 drivers/acpi/dock.c                |   13 ++-----------
 drivers/acpi/processor_driver.c    |   24 +-----------------------
 drivers/acpi/scan.c                |   34 +++++++++++++++++++++-------------
 drivers/pci/hotplug/acpiphp_glue.c |   21 ++++-----------------
 drivers/pci/hotplug/sgi_hotplug.c  |    3 +--
 include/acpi/acpi_bus.h            |    3 +--
 8 files changed, 32 insertions(+), 101 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -1691,25 +1691,33 @@ static int acpi_bus_scan(acpi_handle han
 	return ret;
 }
 
-/*
- * acpi_bus_add
+/**
+ * acpi_bus_add - Add ACPI device node objects in a given namespace scope.
+ * @handle: Root of the namespace scope to scan.
+ * @ret: Location to store a return struct acpi_device pointer.
  *
- * scan a given ACPI tree and (probably recently hot-plugged)
- * create and add found devices.
+ * Scan a given ACPI tree (probably recently hot-plugged) and create and add
+ * found devices.
  *
- * If no devices were found -ENODEV is returned which does not
- * mean that this is a real error, there just have been no suitable
- * ACPI objects in the table trunk from which the kernel could create
- * a device and add an appropriate driver.
+ * If no devices were found, -ENODEV is returned, but it does not mean that
+ * there has been a real error.  There just have been no suitable ACPI objects
+ * in the table trunk from which the kernel could create a device and add an
+ * appropriate driver.
+ *
+ * If 0 is returned, the memory location pointed to by @ret will be populated
+ * with a pointer to a struct acpi_device created while scanning the namespace.
+ * If @handle corresponds to a device node, that will be a pointer to the struct
+ * acpi_device object corresponding to @handle.  Otherwise, it will be a pointer
+ * to a struct acpi_device corresponding to one of its descendants.
+ *
+ * If an error code is returned, NULL will be stored in the memory location
+ * pointed to by @ret.
  */
-
-int
-acpi_bus_add(struct acpi_device **child,
-	     struct acpi_device *parent, acpi_handle handle, int type)
+int acpi_bus_add(acpi_handle handle, struct acpi_device **ret)
 {
 	int err;
 
-	err = acpi_bus_scan(handle, false, child);
+	err = acpi_bus_scan(handle, false, ret);
 	if (err)
 		return err;
 
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -398,8 +398,7 @@ static inline int acpi_bus_generate_proc
 #endif
 int acpi_bus_register_driver(struct acpi_driver *driver);
 void acpi_bus_unregister_driver(struct acpi_driver *driver);
-int acpi_bus_add(struct acpi_device **child, struct acpi_device *parent,
-		 acpi_handle handle, int type);
+int acpi_bus_add(acpi_handle handle, struct acpi_device **ret);
 void acpi_bus_hot_remove_device(void *context);
 int acpi_bus_trim(struct acpi_device *start, int rmdevice);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
Index: linux/drivers/pci/hotplug/sgi_hotplug.c
===================================================================
--- linux.orig/drivers/pci/hotplug/sgi_hotplug.c
+++ linux/drivers/pci/hotplug/sgi_hotplug.c
@@ -448,8 +448,7 @@ static int enable_slot(struct hotplug_sl
 			if (ACPI_SUCCESS(ret) &&
 			    (adr>>16) == (slot->device_num + 1)) {
 
-				ret = acpi_bus_add(&device, pdevice, chandle,
-						   ACPI_BUS_TYPE_DEVICE);
+				ret = acpi_bus_add(chandle, &device);
 				if (ACPI_FAILURE(ret)) {
 					printk(KERN_ERR "%s: acpi_bus_add "
 					       "failed (0x%x) for slot %d "
Index: linux/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux/drivers/pci/hotplug/acpiphp_glue.c
@@ -734,15 +734,9 @@ static unsigned char acpiphp_max_busnr(s
  */
 static int acpiphp_bus_add(struct acpiphp_func *func)
 {
-	acpi_handle phandle;
-	struct acpi_device *device, *pdevice;
+	struct acpi_device *device;
 	int ret_val;
 
-	acpi_get_parent(func->handle, &phandle);
-	if (acpi_bus_get_device(phandle, &pdevice)) {
-		dbg("no parent device, assuming NULL\n");
-		pdevice = NULL;
-	}
 	if (!acpi_bus_get_device(func->handle, &device)) {
 		dbg("bus exists... trim\n");
 		/* this shouldn't be in here, so remove
@@ -752,8 +746,7 @@ static int acpiphp_bus_add(struct acpiph
 		dbg("acpi_bus_trim return %x\n", ret_val);
 	}
 
-	ret_val = acpi_bus_add(&device, pdevice, func->handle,
-		ACPI_BUS_TYPE_DEVICE);
+	ret_val = acpi_bus_add(func->handle, &device);
 	if (ret_val) {
 		dbg("error adding bus, %x\n",
 			-ret_val);
@@ -1129,8 +1122,7 @@ static int acpiphp_configure_bridge (acp
 
 static void handle_bridge_insertion(acpi_handle handle, u32 type)
 {
-	struct acpi_device *device, *pdevice;
-	acpi_handle phandle;
+	struct acpi_device *device;
 
 	if ((type != ACPI_NOTIFY_BUS_CHECK) &&
 			(type != ACPI_NOTIFY_DEVICE_CHECK)) {
@@ -1138,12 +1130,7 @@ static void handle_bridge_insertion(acpi
 		return;
 	}
 
-	acpi_get_parent(handle, &phandle);
-	if (acpi_bus_get_device(phandle, &pdevice)) {
-		dbg("no parent device, assuming NULL\n");
-		pdevice = NULL;
-	}
-	if (acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE)) {
+	if (acpi_bus_add(handle, &device)) {
 		err("cannot add bridge to acpi list\n");
 		return;
 	}
Index: linux/drivers/acpi/processor_driver.c
===================================================================
--- linux.orig/drivers/acpi/processor_driver.c
+++ linux/drivers/acpi/processor_driver.c
@@ -677,28 +677,6 @@ static int is_processor_present(acpi_han
 	return 0;
 }
 
-static
-int acpi_processor_device_add(acpi_handle handle, struct acpi_device **device)
-{
-	acpi_handle phandle;
-	struct acpi_device *pdev;
-
-
-	if (acpi_get_parent(handle, &phandle)) {
-		return -ENODEV;
-	}
-
-	if (acpi_bus_get_device(phandle, &pdev)) {
-		return -ENODEV;
-	}
-
-	if (acpi_bus_add(device, pdev, handle, ACPI_BUS_TYPE_PROCESSOR)) {
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
 static void acpi_processor_hotplug_notify(acpi_handle handle,
 					  u32 event, void *data)
 {
@@ -721,7 +699,7 @@ static void acpi_processor_hotplug_notif
 		if (!acpi_bus_get_device(handle, &device))
 			break;
 
-		result = acpi_processor_device_add(handle, &device);
+		result = acpi_bus_add(handle, &device);
 		if (result) {
 			acpi_handle_err(handle, "Unable to add the device\n");
 			break;
Index: linux/drivers/acpi/dock.c
===================================================================
--- linux.orig/drivers/acpi/dock.c
+++ linux/drivers/acpi/dock.c
@@ -310,8 +310,6 @@ static int dock_present(struct dock_stat
 static struct acpi_device * dock_create_acpi_device(acpi_handle handle)
 {
 	struct acpi_device *device;
-	struct acpi_device *parent_device;
-	acpi_handle parent;
 	int ret;
 
 	if (acpi_bus_get_device(handle, &device)) {
@@ -319,16 +317,9 @@ static struct acpi_device * dock_create_
 		 * no device created for this object,
 		 * so we should create one.
 		 */
-		acpi_get_parent(handle, &parent);
-		if (acpi_bus_get_device(parent, &parent_device))
-			parent_device = NULL;
-
-		ret = acpi_bus_add(&device, parent_device, handle,
-			ACPI_BUS_TYPE_DEVICE);
-		if (ret) {
+		ret = acpi_bus_add(handle, &device);
+		if (ret)
 			pr_debug("error adding bus, %x\n", -ret);
-			return NULL;
-		}
 	}
 	return device;
 }
Index: linux/drivers/acpi/container.c
===================================================================
--- linux.orig/drivers/acpi/container.c
+++ linux/drivers/acpi/container.c
@@ -135,20 +135,6 @@ static int acpi_container_remove(struct
 	return status;
 }
 
-static int container_device_add(struct acpi_device **device, acpi_handle handle)
-{
-	acpi_handle phandle;
-	struct acpi_device *pdev;
-
-	if (acpi_get_parent(handle, &phandle))
-		return -ENODEV;
-
-	if (acpi_bus_get_device(phandle, &pdev))
-		return -ENODEV;
-
-	return acpi_bus_add(device, pdev, handle, ACPI_BUS_TYPE_DEVICE);
-}
-
 static void container_notify_cb(acpi_handle handle, u32 type, void *context)
 {
 	struct acpi_device *device = NULL;
@@ -180,7 +166,7 @@ static void container_notify_cb(acpi_han
 		if (!ACPI_FAILURE(status) || device)
 			break;
 
-		result = container_device_add(&device, handle);
+		result = acpi_bus_add(handle, &device);
 		if (result) {
 			acpi_handle_warn(handle, "Failed to add container\n");
 			break;
Index: linux/drivers/acpi/acpi_memhotplug.c
===================================================================
--- linux.orig/drivers/acpi/acpi_memhotplug.c
+++ linux/drivers/acpi/acpi_memhotplug.c
@@ -157,34 +157,17 @@ static int
 acpi_memory_get_device(acpi_handle handle,
 		       struct acpi_memory_device **mem_device)
 {
-	acpi_status status;
-	acpi_handle phandle;
 	struct acpi_device *device = NULL;
-	struct acpi_device *pdevice = NULL;
 	int result;
 
-
 	if (!acpi_bus_get_device(handle, &device) && device)
 		goto end;
 
-	status = acpi_get_parent(handle, &phandle);
-	if (ACPI_FAILURE(status)) {
-		ACPI_EXCEPTION((AE_INFO, status, "Cannot find acpi parent"));
-		return -EINVAL;
-	}
-
-	/* Get the parent device */
-	result = acpi_bus_get_device(phandle, &pdevice);
-	if (result) {
-		acpi_handle_warn(phandle, "Cannot get acpi bus device\n");
-		return -EINVAL;
-	}
-
 	/*
 	 * Now add the notified device.  This creates the acpi_device
 	 * and invokes .add function
 	 */
-	result = acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE);
+	result = acpi_bus_add(handle, &device);
 	if (result) {
 		acpi_handle_warn(handle, "Cannot add acpi bus\n");
 		return -EINVAL;

