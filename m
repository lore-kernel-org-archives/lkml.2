Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2LTB4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:56:35 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38313 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325Ab2LTBzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:55:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 8/16] ACPI: Remove acpi_start_single_object() and acpi_bus_start()
Date: Thu, 20 Dec 2012 02:53:18 +0100
Message-ID: <5623563.KZFO8lSJrC@vostro.rjw.lan>
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

The ACPI PCI root bridge driver was the only ACPI driver implementing
the .start() callback, which isn't used by any ACPI drivers any more
now.

For this reason, acpi_start_single_object() has no purpose any more,
so remove it and all references to it.  Also remove
acpi_bus_start_device(), whose only purpose was to call
acpi_start_single_object().

Moreover, since after the removal of acpi_bus_start_device() the
only purpose of acpi_bus_start() remains to call
acpi_update_all_gpes(), move that into acpi_bus_add() and drop
acpi_bus_start() too, remove its header from acpi_bus.h and
update all of its former users accordingly.

This change was previously proposed in a different from by
Yinghai Lu.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/container.c           |   16 +-------
 drivers/acpi/scan.c                |   66 ++++---------------------------------
 drivers/pci/hotplug/acpiphp_glue.c |    4 --
 drivers/pci/hotplug/sgi_hotplug.c  |    2 -
 include/acpi/acpi_bus.h            |    1 
 5 files changed, 12 insertions(+), 77 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -612,7 +612,6 @@ static void acpi_device_remove_notify_ha
 }
 
 static int acpi_bus_driver_init(struct acpi_device *, struct acpi_driver *);
-static int acpi_start_single_object(struct acpi_device *);
 static int acpi_device_probe(struct device * dev)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
@@ -621,9 +620,6 @@ static int acpi_device_probe(struct devi
 
 	ret = acpi_bus_driver_init(acpi_dev, acpi_drv);
 	if (!ret) {
-		if (acpi_dev->add_type == ACPI_BUS_ADD_START)
-			acpi_start_single_object(acpi_dev);
-
 		if (acpi_drv->ops.notify) {
 			ret = acpi_device_install_notify_handler(acpi_dev);
 			if (ret) {
@@ -802,24 +798,6 @@ acpi_bus_driver_init(struct acpi_device
 	return 0;
 }
 
-static int acpi_start_single_object(struct acpi_device *device)
-{
-	int result = 0;
-	struct acpi_driver *driver;
-
-
-	if (!(driver = device->driver))
-		return 0;
-
-	if (driver->ops.start) {
-		result = driver->ops.start(device);
-		if (result && driver->ops.remove)
-			driver->ops.remove(device, ACPI_BUS_REMOVAL_NORMAL);
-	}
-
-	return result;
-}
-
 /**
  * acpi_bus_register_driver - register a driver with the ACPI bus
  * @driver: driver being registered
@@ -1714,59 +1692,31 @@ static int acpi_bus_scan(acpi_handle han
 }
 
 /*
- * acpi_bus_add and acpi_bus_start
+ * acpi_bus_add
  *
  * scan a given ACPI tree and (probably recently hot-plugged)
- * create and add or starts found devices.
+ * create and add found devices.
  *
  * If no devices were found -ENODEV is returned which does not
  * mean that this is a real error, there just have been no suitable
  * ACPI objects in the table trunk from which the kernel could create
- * a device and add/start an appropriate driver.
+ * a device and add an appropriate driver.
  */
 
 int
 acpi_bus_add(struct acpi_device **child,
 	     struct acpi_device *parent, acpi_handle handle, int type)
 {
-	return acpi_bus_scan(handle, false, child);
-}
-EXPORT_SYMBOL(acpi_bus_add);
-
-static acpi_status acpi_bus_start_device(acpi_handle handle, u32 lvl,
-					 void *not_used, void **ret_not_used)
-{
-	struct acpi_device *device;
-	unsigned long long sta_not_used;
-	int type_not_used;
-
-	/*
-	 * Ignore errors ignored by acpi_bus_check_add() to avoid terminating
-	 * namespace walks prematurely.
-	 */
-	if (acpi_bus_type_and_status(handle, &type_not_used, &sta_not_used))
-		return AE_OK;
-
-	if (acpi_bus_get_device(handle, &device))
-		return AE_CTRL_DEPTH;
-
-	return acpi_start_single_object(device);
-}
-
-int acpi_bus_start(struct acpi_device *device)
-{
-	if (!device)
-		return -EINVAL;
+	int err;
 
-	if (ACPI_SUCCESS(acpi_start_single_object(device)))
-		acpi_walk_namespace(ACPI_TYPE_ANY, device->handle,
-				    ACPI_UINT32_MAX, acpi_bus_start_device,
-				    NULL, NULL, NULL);
+	err = acpi_bus_scan(handle, false, child);
+	if (err)
+		return err;
 
 	acpi_update_all_gpes();
 	return 0;
 }
-EXPORT_SYMBOL(acpi_bus_start);
+EXPORT_SYMBOL(acpi_bus_add);
 
 int acpi_bus_trim(struct acpi_device *start, int rmdevice)
 {
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -402,7 +402,6 @@ int acpi_bus_add(struct acpi_device **ch
 		 acpi_handle handle, int type);
 void acpi_bus_hot_remove_device(void *context);
 int acpi_bus_trim(struct acpi_device *start, int rmdevice);
-int acpi_bus_start(struct acpi_device *device);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
 int acpi_match_device_ids(struct acpi_device *device,
 			  const struct acpi_device_id *ids);
Index: linux/drivers/pci/hotplug/sgi_hotplug.c
===================================================================
--- linux.orig/drivers/pci/hotplug/sgi_hotplug.c
+++ linux/drivers/pci/hotplug/sgi_hotplug.c
@@ -457,8 +457,6 @@ static int enable_slot(struct hotplug_sl
 					       ret, (int)(adr>>16),
 					       (int)(adr&0xffff));
 					/* try to continue on */
-				} else {
-					acpi_bus_start(device);
 				}
 			}
 		}
Index: linux/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux/drivers/pci/hotplug/acpiphp_glue.c
@@ -759,7 +759,6 @@ static int acpiphp_bus_add(struct acpiph
 			-ret_val);
 		goto acpiphp_bus_add_out;
 	}
-	ret_val = acpi_bus_start(device);
 
 acpiphp_bus_add_out:
 	return ret_val;
@@ -1148,8 +1147,7 @@ static void handle_bridge_insertion(acpi
 		err("cannot add bridge to acpi list\n");
 		return;
 	}
-	if (!acpiphp_configure_bridge(handle) &&
-		!acpi_bus_start(device))
+	if (!acpiphp_configure_bridge(handle))
 		add_bridge(handle);
 	else
 		err("cannot configure and start bridge\n");
Index: linux/drivers/acpi/container.c
===================================================================
--- linux.orig/drivers/acpi/container.c
+++ linux/drivers/acpi/container.c
@@ -139,24 +139,14 @@ static int container_device_add(struct a
 {
 	acpi_handle phandle;
 	struct acpi_device *pdev;
-	int result;
 
-
-	if (acpi_get_parent(handle, &phandle)) {
-		return -ENODEV;
-	}
-
-	if (acpi_bus_get_device(phandle, &pdev)) {
+	if (acpi_get_parent(handle, &phandle))
 		return -ENODEV;
-	}
 
-	if (acpi_bus_add(device, pdev, handle, ACPI_BUS_TYPE_DEVICE)) {
+	if (acpi_bus_get_device(phandle, &pdev))
 		return -ENODEV;
-	}
-
-	result = acpi_bus_start(*device);
 
-	return result;
+	return acpi_bus_add(device, pdev, handle, ACPI_BUS_TYPE_DEVICE);
 }
 
 static void container_notify_cb(acpi_handle handle, u32 type, void *context)

