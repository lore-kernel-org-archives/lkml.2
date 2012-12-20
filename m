Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab2LTB55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:57:57 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38320 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab2LTBzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:55:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 11/16] ACPI: Replace ACPI device add_type field with a match_driver flag
Date: Thu, 20 Dec 2012 02:55:30 +0100
Message-ID: <9569462.ymarRRAK6s@vostro.rjw.lan>
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

After the removal of the second argument of acpi_bus_scan() there is
no difference between the ACPI_BUS_ADD_MATCH and ACPI_BUS_ADD_START
add types, so the add_type field in struct acpi_device may be
replaced with a single flag.  Do that calling the flag match_driver.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/scan.c     |   21 +++++++++------------
 include/acpi/acpi_bus.h |   11 ++---------
 2 files changed, 11 insertions(+), 21 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -535,7 +535,7 @@ static int acpi_bus_match(struct device
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	struct acpi_driver *acpi_drv = to_acpi_driver(drv);
 
-	return acpi_dev->add_type >= ACPI_BUS_ADD_MATCH
+	return acpi_dev->flags.match_driver
 		&& !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
 }
 
@@ -1451,8 +1451,7 @@ static void acpi_hot_add_bind(struct acp
 
 static int acpi_add_single_object(struct acpi_device **child,
 				  acpi_handle handle, int type,
-				  unsigned long long sta,
-				  enum acpi_bus_add_type add_type)
+				  unsigned long long sta, bool match_driver)
 {
 	int result;
 	struct acpi_device *device;
@@ -1468,7 +1467,6 @@ static int acpi_add_single_object(struct
 	device->device_type = type;
 	device->handle = handle;
 	device->parent = acpi_bus_get_parent(handle);
-	device->add_type = add_type;
 	STRUCT_TO_INT(device->status) = sta;
 
 	acpi_device_get_busid(device);
@@ -1519,9 +1517,10 @@ static int acpi_add_single_object(struct
 	if ((result = acpi_device_set_context(device)))
 		goto end;
 
+	device->flags.match_driver = match_driver;
 	result = acpi_device_register(device);
 
-	if (device->add_type >= ACPI_BUS_ADD_MATCH)
+	if (device->flags.match_driver)
 		acpi_hot_add_bind(device);
 
 end:
@@ -1550,7 +1549,7 @@ static void acpi_bus_add_power_resource(
 	acpi_bus_get_device(handle, &device);
 	if (!device)
 		acpi_add_single_object(&device, handle, ACPI_BUS_TYPE_POWER,
-					ACPI_STA_DEFAULT, ACPI_BUS_ADD_START);
+					ACPI_STA_DEFAULT, true);
 }
 
 static int acpi_bus_type_and_status(acpi_handle handle, int *type,
@@ -1621,11 +1620,11 @@ static acpi_status acpi_bus_check_add(ac
 		return AE_CTRL_DEPTH;
 	}
 
-	acpi_add_single_object(&device, handle, type, sta, ACPI_BUS_ADD_BASIC);
+	acpi_add_single_object(&device, handle, type, sta, false);
 	if (!device)
 		return AE_CTRL_DEPTH;
 
-	device->add_type = ACPI_BUS_ADD_START;
+	device->flags.match_driver = true;
 	acpi_hot_add_bind(device);
 
  out:
@@ -1790,16 +1789,14 @@ static int acpi_bus_scan_fixed(void)
 	if ((acpi_gbl_FADT.flags & ACPI_FADT_POWER_BUTTON) == 0) {
 		result = acpi_add_single_object(&device, NULL,
 						ACPI_BUS_TYPE_POWER_BUTTON,
-						ACPI_STA_DEFAULT,
-						ACPI_BUS_ADD_START);
+						ACPI_STA_DEFAULT, true);
 		device_init_wakeup(&device->dev, true);
 	}
 
 	if ((acpi_gbl_FADT.flags & ACPI_FADT_SLEEP_BUTTON) == 0) {
 		result = acpi_add_single_object(&device, NULL,
 						ACPI_BUS_TYPE_SLEEP_BUTTON,
-						ACPI_STA_DEFAULT,
-						ACPI_BUS_ADD_START);
+						ACPI_STA_DEFAULT, true);
 	}
 
 	return result;
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -63,13 +63,6 @@ acpi_get_physical_device_location(acpi_h
 #define ACPI_BUS_FILE_ROOT	"acpi"
 extern struct proc_dir_entry *acpi_root_dir;
 
-enum acpi_bus_add_type {
-	ACPI_BUS_ADD_BASIC = 0,
-	ACPI_BUS_ADD_MATCH,
-	ACPI_BUS_ADD_START,
-	ACPI_BUS_ADD_TYPE_COUNT
-};
-
 enum acpi_bus_removal_type {
 	ACPI_BUS_REMOVAL_NORMAL = 0,
 	ACPI_BUS_REMOVAL_EJECT,
@@ -150,7 +143,8 @@ struct acpi_device_flags {
 	u32 power_manageable:1;
 	u32 performance_manageable:1;
 	u32 eject_pending:1;
-	u32 reserved:24;
+	u32 match_driver:1;
+	u32 reserved:23;
 };
 
 /* File System */
@@ -285,7 +279,6 @@ struct acpi_device {
 	struct acpi_driver *driver;
 	void *driver_data;
 	struct device dev;
-	enum acpi_bus_add_type add_type;	/* how to handle adding */
 	enum acpi_bus_removal_type removal_type;	/* indicate for different removal type */
 	u8 physical_node_count;
 	struct list_head physical_node_list;

