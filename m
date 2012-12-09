Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934618Ab2LIXAC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 18:00:02 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:50192 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934583Ab2LIW75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 17:59:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 5/6] ACPI: Replace struct acpi_bus_ops with enum type
Date: Mon, 10 Dec 2012 00:03:38 +0100
Message-ID: <2097693.II1PNyeFLY@vostro.rjw.lan>
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

Notice that one member of struct acpi_bus_ops, acpi_op_add, is not
used anywhere any more and the relationship between its remaining
members, acpi_op_match and acpi_op_start, is such that it doesn't
make sense to set the latter without setting the former at the same
time.  Therefore, replace struct acpi_bus_ops with new a enum type,
enum acpi_bus_add_type, with three values, ACPI_BUS_ADD_BASIC,
ACPI_BUS_ADD_MATCH, ACPI_BUS_ADD_START, corresponding to
both acpi_op_match and acpi_op_start unset, acpi_op_match set and
acpi_op_start unset, and both acpi_op_match and acpi_op_start set,
respectively.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c     |   35 ++++++++++++-----------------------
 include/acpi/acpi_bus.h |   15 ++++++++-------
 2 files changed, 20 insertions(+), 30 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -494,7 +494,7 @@ static int acpi_bus_match(struct device
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	struct acpi_driver *acpi_drv = to_acpi_driver(drv);
 
-	return acpi_dev->bus_ops.acpi_op_match
+	return acpi_dev->add_type >= ACPI_BUS_ADD_MATCH
 		&& !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
 }
 
@@ -580,7 +580,7 @@ static int acpi_device_probe(struct devi
 
 	ret = acpi_bus_driver_init(acpi_dev, acpi_drv);
 	if (!ret) {
-		if (acpi_dev->bus_ops.acpi_op_start)
+		if (acpi_dev->add_type == ACPI_BUS_ADD_START)
 			acpi_start_single_object(acpi_dev);
 
 		if (acpi_drv->ops.notify) {
@@ -1433,7 +1433,7 @@ static void acpi_hot_add_bind(struct acp
 static int acpi_add_single_object(struct acpi_device **child,
 				  acpi_handle handle, int type,
 				  unsigned long long sta,
-				  struct acpi_bus_ops *ops)
+				  enum acpi_bus_add_type add_type)
 {
 	int result;
 	struct acpi_device *device;
@@ -1449,7 +1449,7 @@ static int acpi_add_single_object(struct
 	device->device_type = type;
 	device->handle = handle;
 	device->parent = acpi_bus_get_parent(handle);
-	device->bus_ops = *ops; /* workround for not call .start */
+	device->add_type = add_type;
 	STRUCT_TO_INT(device->status) = sta;
 
 	acpi_device_get_busid(device);
@@ -1502,7 +1502,7 @@ static int acpi_add_single_object(struct
 
 	result = acpi_device_register(device);
 
-	if (device->bus_ops.acpi_op_match)
+	if (device->add_type >= ACPI_BUS_ADD_MATCH)
 		acpi_hot_add_bind(device);
 
 end:
@@ -1526,16 +1526,12 @@ end:
 
 static void acpi_bus_add_power_resource(acpi_handle handle)
 {
-	struct acpi_bus_ops ops = {
-		.acpi_op_start = 1,
-		.acpi_op_match = 1,
-	};
 	struct acpi_device *device = NULL;
 
 	acpi_bus_get_device(handle, &device);
 	if (!device)
 		acpi_add_single_object(&device, handle, ACPI_BUS_TYPE_POWER,
-					ACPI_STA_DEFAULT, &ops);
+					ACPI_STA_DEFAULT, ACPI_BUS_ADD_START);
 }
 
 static int acpi_bus_type_and_status(acpi_handle handle, int *type,
@@ -1608,16 +1604,13 @@ static acpi_status acpi_bus_check_add(ac
 	 */
 	acpi_bus_get_device(handle, &device);
 	if (!device) {
-		struct acpi_bus_ops ops = {
-			.acpi_op_start = !!context,
-			.acpi_op_match = 0,
-		};
-
-		acpi_add_single_object(&device, handle, type, sta, &ops);
+		acpi_add_single_object(&device, handle, type, sta,
+				       ACPI_BUS_ADD_BASIC);
 		if (!device)
 			return AE_CTRL_DEPTH;
 
-		device->bus_ops.acpi_op_match = 1;
+		device->add_type = context ?
+					ACPI_BUS_ADD_START : ACPI_BUS_ADD_MATCH;
 	}
 
 	if (!*return_value)
@@ -1779,10 +1772,6 @@ static int acpi_bus_scan_fixed(void)
 {
 	int result = 0;
 	struct acpi_device *device = NULL;
-	struct acpi_bus_ops ops = {
-		.acpi_op_start = 1,
-		.acpi_op_match = 1,
-	};
 
 	/*
 	 * Enumerate all fixed-feature devices.
@@ -1791,7 +1780,7 @@ static int acpi_bus_scan_fixed(void)
 		result = acpi_add_single_object(&device, NULL,
 						ACPI_BUS_TYPE_POWER_BUTTON,
 						ACPI_STA_DEFAULT,
-						&ops);
+						ACPI_BUS_ADD_START);
 		device_init_wakeup(&device->dev, true);
 	}
 
@@ -1799,7 +1788,7 @@ static int acpi_bus_scan_fixed(void)
 		result = acpi_add_single_object(&device, NULL,
 						ACPI_BUS_TYPE_SLEEP_BUTTON,
 						ACPI_STA_DEFAULT,
-						&ops);
+						ACPI_BUS_ADD_START);
 	}
 
 	return result;
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -63,6 +63,13 @@ acpi_get_physical_device_location(acpi_h
 #define ACPI_BUS_FILE_ROOT	"acpi"
 extern struct proc_dir_entry *acpi_root_dir;
 
+enum acpi_bus_add_type {
+	ACPI_BUS_ADD_BASIC = 0,
+	ACPI_BUS_ADD_MATCH,
+	ACPI_BUS_ADD_START,
+	ACPI_BUS_ADD_TYPE_COUNT
+};
+
 enum acpi_bus_removal_type {
 	ACPI_BUS_REMOVAL_NORMAL = 0,
 	ACPI_BUS_REMOVAL_EJECT,
@@ -95,12 +102,6 @@ typedef int (*acpi_op_bind) (struct acpi
 typedef int (*acpi_op_unbind) (struct acpi_device * device);
 typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
 
-struct acpi_bus_ops {
-	u32 acpi_op_add:1;
-	u32 acpi_op_start:1;
-	u32 acpi_op_match:1;
-};
-
 struct acpi_device_ops {
 	acpi_op_add add;
 	acpi_op_remove remove;
@@ -284,7 +285,7 @@ struct acpi_device {
 	struct acpi_driver *driver;
 	void *driver_data;
 	struct device dev;
-	struct acpi_bus_ops bus_ops;	/* workaround for different code path for hotplug */
+	enum acpi_bus_add_type add_type;	/* how to handle adding */
 	enum acpi_bus_removal_type removal_type;	/* indicate for different removal type */
 	u8 physical_node_count;
 	struct list_head physical_node_list;

