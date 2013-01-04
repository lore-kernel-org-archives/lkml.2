Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3ADAHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:07:37 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59166 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353Ab3ADAHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:07:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/12] ACPI / scan: More straightforward preparation of ACPI device objects
Date: Fri, 04 Jan 2013 01:02:23 +0100
Message-ID: <2122008.mrpYzIx2o3@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <1418767.4KIZOTK1lk@vostro.rjw.lan>
References: <1418767.4KIZOTK1lk@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Simplify the code preparing struct acpi_device objects for
registration by removing useless code, moving different pieces of
code into the functions they belong to and making a couple of int
functions always returning 0 void.

This also fixes a possible memory leak in ACPI device registration
error code path by making acpi_device_register() detach data from
device->handle if device_register() fails and prepares the scanning
code for special-casing ACPI power resources (next patch).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |  184 ++++++++++++++++++----------------------------------
 1 file changed, 64 insertions(+), 120 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -478,6 +478,7 @@ static void acpi_free_ids(struct acpi_de
 		kfree(id->id);
 		kfree(id);
 	}
+	kfree(device->pnp.unique_id);
 }
 
 static void acpi_device_release(struct device *dev)
@@ -485,7 +486,6 @@ static void acpi_device_release(struct d
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 
 	acpi_free_ids(acpi_dev);
-	kfree(acpi_dev->pnp.unique_id);
 	kfree(acpi_dev);
 }
 
@@ -629,6 +629,18 @@ static int acpi_device_register(struct a
 	struct acpi_device_bus_id *acpi_device_bus_id, *new_bus_id;
 	int found = 0;
 
+	if (device->handle) {
+		acpi_status status;
+
+		status = acpi_attach_data(device->handle, acpi_bus_data_handler,
+					  device);
+		if (ACPI_FAILURE(status)) {
+			acpi_handle_err(device->handle,
+					"Unable to attach device data\n");
+			return -ENODEV;
+		}
+	}
+
 	/*
 	 * Linkage
 	 * -------
@@ -643,8 +655,9 @@ static int acpi_device_register(struct a
 
 	new_bus_id = kzalloc(sizeof(struct acpi_device_bus_id), GFP_KERNEL);
 	if (!new_bus_id) {
-		printk(KERN_ERR PREFIX "Memory allocation error\n");
-		return -ENOMEM;
+		pr_err(PREFIX "Memory allocation error\n");
+		result = -ENOMEM;
+		goto err_detach;
 	}
 
 	mutex_lock(&acpi_device_lock);
@@ -683,7 +696,7 @@ static int acpi_device_register(struct a
 	result = device_register(&device->dev);
 	if (result) {
 		dev_err(&device->dev, "Error registering device\n");
-		goto end;
+		goto err;
 	}
 
 	result = acpi_device_setup_files(device);
@@ -693,12 +706,16 @@ static int acpi_device_register(struct a
 
 	device->removal_type = ACPI_BUS_REMOVAL_NORMAL;
 	return 0;
-end:
+
+ err:
 	mutex_lock(&acpi_device_lock);
 	if (device->parent)
 		list_del(&device->node);
 	list_del(&device->wakeup_list);
 	mutex_unlock(&acpi_device_lock);
+
+ err_detach:
+	acpi_detach_data(device->handle, acpi_bus_data_handler);
 	return result;
 }
 
@@ -863,12 +880,6 @@ void acpi_bus_data_handler(acpi_handle h
 	return;
 }
 
-static int acpi_bus_get_perf_flags(struct acpi_device *device)
-{
-	device->performance.state = ACPI_STATE_UNKNOWN;
-	return 0;
-}
-
 static acpi_status
 acpi_bus_extract_wakeup_device_power_package(acpi_handle handle,
 					     struct acpi_device_wakeup *wakeup)
@@ -1019,12 +1030,25 @@ static void acpi_bus_get_wakeup_device_f
 
 static void acpi_bus_add_power_resource(acpi_handle handle);
 
-static int acpi_bus_get_power_flags(struct acpi_device *device)
+static void acpi_bus_get_power_flags(struct acpi_device *device)
 {
 	acpi_status status = 0;
 	acpi_handle handle = NULL;
 	u32 i = 0;
 
+	/* Power resources cannot be power manageable. */
+	if (device->device_type == ACPI_BUS_TYPE_POWER)
+		return;
+
+	/* Presence of _PS0|_PR0 indicates 'power manageable' */
+	status = acpi_get_handle(device->handle, "_PS0", &handle);
+	if (ACPI_FAILURE(status)) {
+		status = acpi_get_handle(device->handle, "_PR0", &handle);
+		if (ACPI_FAILURE(status))
+			return;
+	}
+
+	device->flags.power_manageable = 1;
 
 	/*
 	 * Power Management Flags
@@ -1090,16 +1114,13 @@ static int acpi_bus_get_power_flags(stru
 		device->power.states[ACPI_STATE_D3_COLD].flags.os_accessible = 1;
 
 	acpi_bus_init_power(device);
-
-	return 0;
 }
 
-static int acpi_bus_get_flags(struct acpi_device *device)
+static void acpi_bus_get_flags(struct acpi_device *device)
 {
 	acpi_status status = AE_OK;
 	acpi_handle temp = NULL;
 
-
 	/* Presence of _STA indicates 'dynamic_status' */
 	status = acpi_get_handle(device->handle, "_STA", &temp);
 	if (ACPI_SUCCESS(status))
@@ -1119,21 +1140,6 @@ static int acpi_bus_get_flags(struct acp
 		if (ACPI_SUCCESS(status))
 			device->flags.ejectable = 1;
 	}
-
-	/* Power resources cannot be power manageable. */
-	if (device->device_type == ACPI_BUS_TYPE_POWER)
-		return 0;
-
-	/* Presence of _PS0|_PR0 indicates 'power manageable' */
-	status = acpi_get_handle(device->handle, "_PS0", &temp);
-	if (ACPI_FAILURE(status))
-		status = acpi_get_handle(device->handle, "_PR0", &temp);
-	if (ACPI_SUCCESS(status))
-		device->flags.power_manageable = 1;
-
-	/* TBD: Performance management */
-
-	return 0;
 }
 
 static void acpi_device_get_busid(struct acpi_device *device)
@@ -1358,29 +1364,6 @@ static void acpi_device_set_id(struct ac
 	}
 }
 
-static int acpi_device_set_context(struct acpi_device *device)
-{
-	acpi_status status;
-
-	/*
-	 * Context
-	 * -------
-	 * Attach this 'struct acpi_device' to the ACPI object.  This makes
-	 * resolutions from handle->device very efficient.  Fixed hardware
-	 * devices have no handles, so we skip them.
-	 */
-	if (!device->handle)
-		return 0;
-
-	status = acpi_attach_data(device->handle,
-				  acpi_bus_data_handler, device);
-	if (ACPI_SUCCESS(status))
-		return 0;
-
-	printk(KERN_ERR PREFIX "Error attaching device data\n");
-	return -ENODEV;
-}
-
 static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
 {
 	if (!dev)
@@ -1397,6 +1380,20 @@ static int acpi_bus_remove(struct acpi_d
 	return 0;
 }
 
+static void acpi_init_device_object(struct acpi_device *device,
+				     acpi_handle handle,
+				     int type, unsigned long long sta)
+{
+	INIT_LIST_HEAD(&device->pnp.ids);
+	device->device_type = type;
+	device->handle = handle;
+	device->parent = acpi_bus_get_parent(handle);
+	STRUCT_TO_INT(device->status) = sta;
+	acpi_device_get_busid(device);
+	acpi_device_set_id(device);
+	acpi_bus_get_flags(device);
+}
+
 static int acpi_add_single_object(struct acpi_device **child,
 				  acpi_handle handle, int type,
 				  unsigned long long sta, bool match_driver)
@@ -1411,78 +1408,25 @@ static int acpi_add_single_object(struct
 		return -ENOMEM;
 	}
 
-	INIT_LIST_HEAD(&device->pnp.ids);
-	device->device_type = type;
-	device->handle = handle;
-	device->parent = acpi_bus_get_parent(handle);
-	STRUCT_TO_INT(device->status) = sta;
-
-	acpi_device_get_busid(device);
-
-	/*
-	 * Flags
-	 * -----
-	 * Note that we only look for object handles -- cannot evaluate objects
-	 * until we know the device is present and properly initialized.
-	 */
-	result = acpi_bus_get_flags(device);
-	if (result)
-		goto end;
-
-	/*
-	 * Initialize Device
-	 * -----------------
-	 * TBD: Synch with Core's enumeration/initialization process.
-	 */
-	acpi_device_set_id(device);
-
-	/*
-	 * Power Management
-	 * ----------------
-	 */
-	if (device->flags.power_manageable) {
-		result = acpi_bus_get_power_flags(device);
-		if (result)
-			goto end;
-	}
-
-	/*
-	 * Wakeup device management
-	 *-----------------------
-	 */
+	acpi_init_device_object(device, handle, type, sta);
+	acpi_bus_get_power_flags(device);
 	acpi_bus_get_wakeup_device_flags(device);
 
-	/*
-	 * Performance Management
-	 * ----------------------
-	 */
-	if (device->flags.performance_manageable) {
-		result = acpi_bus_get_perf_flags(device);
-		if (result)
-			goto end;
-	}
-
-	if ((result = acpi_device_set_context(device)))
-		goto end;
-
 	device->flags.match_driver = match_driver;
 	result = acpi_device_register(device);
-
-end:
-	if (!result) {
-		acpi_power_add_remove_device(device, true);
-		acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-			"Adding %s [%s] parent %s\n", dev_name(&device->dev),
-			 (char *) buffer.pointer,
-			 device->parent ? dev_name(&device->parent->dev) :
-					  "(null)"));
-		kfree(buffer.pointer);
-		*child = device;
-	} else
+	if (result) {
 		acpi_device_release(&device->dev);
+		return result;
+	}
 
-	return result;
+	acpi_power_add_remove_device(device, true);
+	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Added %s [%s] parent %s\n",
+		dev_name(&device->dev), (char *) buffer.pointer,
+		device->parent ? dev_name(&device->parent->dev) : "(null)"));
+	kfree(buffer.pointer);
+	*child = device;
+	return 0;
 }
 
 #define ACPI_STA_DEFAULT (ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED | \

