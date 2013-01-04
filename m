Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3ADAHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:07:41 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59168 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab3ADAHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:07:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/12] ACPI / scan: Treat power resources in a special way
Date: Fri, 04 Jan 2013 01:03:06 +0100
Message-ID: <6094257.2kIAOBQZMd@vostro.rjw.lan>
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

ACPI power resources need to be treated in a special way by the
namespace scanning code, because they need to be ready to use as
soon as they have been discovered (even before registering ACPI
device nodes using them for power management).

For this reason, it doesn't make sense to separate the preparation
of struct acpi_device objects representing them in the device
hierarchy from the creation of struct acpi_power_resource objects
actually used for power resource manipulation.  Accordingly, it
doesn't make sense to define non-empty .add() and .remove() callbacks
in the power resources "driver" (in fact, it is questionable whether
or not it is useful to register such a "driver" at all).

Rearrange the code in scan.c and power.c so that power resources are
initialized entirely by one routine, acpi_add_power_resource(), that
also prepares their struct acpi_device objects and registers them
with the driver core, telling it to use a special release routine,
acpi_release_power_resource(), for removing objects that represent
power resources from memory.  Make the ACPI namespace scanning code
in scan.c always use acpi_add_power_resource() for preparing and
registering objects that represent power resources.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |   13 +++
 drivers/acpi/power.c    |  157 ++++++++++++++++++++++--------------------------
 drivers/acpi/scan.c     |   47 +++++---------
 3 files changed, 102 insertions(+), 115 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -470,7 +470,7 @@ int acpi_match_device_ids(struct acpi_de
 }
 EXPORT_SYMBOL(acpi_match_device_ids);
 
-static void acpi_free_ids(struct acpi_device *device)
+void acpi_free_ids(struct acpi_device *device)
 {
 	struct acpi_hardware_id *id, *tmp;
 
@@ -623,7 +623,8 @@ struct bus_type acpi_bus_type = {
 	.uevent		= acpi_device_uevent,
 };
 
-static int acpi_device_register(struct acpi_device *device)
+int acpi_device_register(struct acpi_device *device,
+			 void (*release)(struct device *))
 {
 	int result;
 	struct acpi_device_bus_id *acpi_device_bus_id, *new_bus_id;
@@ -692,7 +693,7 @@ static int acpi_device_register(struct a
 	if (device->parent)
 		device->dev.parent = &device->parent->dev;
 	device->dev.bus = &acpi_bus_type;
-	device->dev.release = &acpi_device_release;
+	device->dev.release = release;
 	result = device_register(&device->dev);
 	if (result) {
 		dev_err(&device->dev, "Error registering device\n");
@@ -1028,18 +1029,12 @@ static void acpi_bus_get_wakeup_device_f
 				"error in _DSW or _PSW evaluation\n"));
 }
 
-static void acpi_bus_add_power_resource(acpi_handle handle);
-
 static void acpi_bus_get_power_flags(struct acpi_device *device)
 {
 	acpi_status status = 0;
 	acpi_handle handle = NULL;
 	u32 i = 0;
 
-	/* Power resources cannot be power manageable. */
-	if (device->device_type == ACPI_BUS_TYPE_POWER)
-		return;
-
 	/* Presence of _PS0|_PR0 indicates 'power manageable' */
 	status = acpi_get_handle(device->handle, "_PS0", &handle);
 	if (ACPI_FAILURE(status)) {
@@ -1074,8 +1069,10 @@ static void acpi_bus_get_power_flags(str
 			int j;
 
 			device->power.flags.power_resources = 1;
-			for (j = 0; j < ps->resources.count; j++)
-				acpi_bus_add_power_resource(ps->resources.handles[j]);
+			for (j = 0; j < ps->resources.count; j++) {
+				acpi_handle rhandle = ps->resources.handles[j];
+				acpi_add_power_resource(rhandle);
+			}
 		}
 
 		/* Evaluate "_PSx" to see if we can do explicit sets */
@@ -1380,9 +1377,8 @@ static int acpi_bus_remove(struct acpi_d
 	return 0;
 }
 
-static void acpi_init_device_object(struct acpi_device *device,
-				     acpi_handle handle,
-				     int type, unsigned long long sta)
+void acpi_init_device_object(struct acpi_device *device, acpi_handle handle,
+			     int type, unsigned long long sta)
 {
 	INIT_LIST_HEAD(&device->pnp.ids);
 	device->device_type = type;
@@ -1413,7 +1409,7 @@ static int acpi_add_single_object(struct
 	acpi_bus_get_wakeup_device_flags(device);
 
 	device->flags.match_driver = match_driver;
-	result = acpi_device_register(device);
+	result = acpi_device_register(device, acpi_device_release);
 	if (result) {
 		acpi_device_release(&device->dev);
 		return result;
@@ -1429,19 +1425,6 @@ static int acpi_add_single_object(struct
 	return 0;
 }
 
-#define ACPI_STA_DEFAULT (ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED | \
-			  ACPI_STA_DEVICE_UI      | ACPI_STA_DEVICE_FUNCTIONING)
-
-static void acpi_bus_add_power_resource(acpi_handle handle)
-{
-	struct acpi_device *device = NULL;
-
-	acpi_bus_get_device(handle, &device);
-	if (!device)
-		acpi_add_single_object(&device, handle, ACPI_BUS_TYPE_POWER,
-					ACPI_STA_DEFAULT, true);
-}
-
 static int acpi_bus_type_and_status(acpi_handle handle, int *type,
 				    unsigned long long *sta)
 {
@@ -1498,6 +1481,11 @@ static acpi_status acpi_bus_check_add(ac
 	if (result)
 		return AE_OK;
 
+	if (type == ACPI_BUS_TYPE_POWER) {
+		acpi_add_power_resource(handle);
+		return AE_OK;
+	}
+
 	if (!(sta & ACPI_STA_DEVICE_PRESENT) &&
 	    !(sta & ACPI_STA_DEVICE_FUNCTIONING)) {
 		struct acpi_device_wakeup wakeup;
@@ -1510,8 +1498,7 @@ static acpi_status acpi_bus_check_add(ac
 		return AE_CTRL_DEPTH;
 	}
 
-	acpi_add_single_object(&device, handle, type, sta,
-			       type == ACPI_BUS_TYPE_POWER);
+	acpi_add_single_object(&device, handle, type, sta, false);
 	if (!device)
 		return AE_CTRL_DEPTH;
 
Index: linux/drivers/acpi/internal.h
===================================================================
--- linux.orig/drivers/acpi/internal.h
+++ linux/drivers/acpi/internal.h
@@ -35,9 +35,22 @@ static inline void acpi_debugfs_init(voi
 #endif
 
 /* --------------------------------------------------------------------------
+                     Device Node Initialization / Removal
+   -------------------------------------------------------------------------- */
+#define ACPI_STA_DEFAULT (ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED | \
+			  ACPI_STA_DEVICE_UI | ACPI_STA_DEVICE_FUNCTIONING)
+
+int acpi_device_register(struct acpi_device *device,
+			 void (*release)(struct device *));
+void acpi_init_device_object(struct acpi_device *device, acpi_handle handle,
+			     int type, unsigned long long sta);
+void acpi_free_ids(struct acpi_device *device);
+
+/* --------------------------------------------------------------------------
                                   Power Resource
    -------------------------------------------------------------------------- */
 int acpi_power_init(void);
+void acpi_add_power_resource(acpi_handle handle);
 void acpi_power_add_remove_device(struct acpi_device *adev, bool add);
 int acpi_device_sleep_wake(struct acpi_device *dev,
                            int enable, int sleep_state, int dev_state);
Index: linux/drivers/acpi/power.c
===================================================================
--- linux.orig/drivers/acpi/power.c
+++ linux/drivers/acpi/power.c
@@ -58,8 +58,7 @@ ACPI_MODULE_NAME("power");
 #define ACPI_POWER_RESOURCE_STATE_ON	0x01
 #define ACPI_POWER_RESOURCE_STATE_UNKNOWN 0xFF
 
-static int acpi_power_add(struct acpi_device *device);
-static int acpi_power_remove(struct acpi_device *device, int type);
+static inline int acpi_power_add(struct acpi_device *device) { return 0; }
 
 static const struct acpi_device_id power_device_ids[] = {
 	{ACPI_POWER_HID, 0},
@@ -76,10 +75,7 @@ static struct acpi_driver acpi_power_dri
 	.name = "power",
 	.class = ACPI_POWER_CLASS,
 	.ids = power_device_ids,
-	.ops = {
-		.add = acpi_power_add,
-		.remove = acpi_power_remove,
-		},
+	.ops.add = acpi_power_add,
 	.drv.pm = &acpi_power_pm,
 };
 
@@ -90,9 +86,9 @@ struct acpi_power_dependent_device {
 };
 
 struct acpi_power_resource {
-	struct acpi_device *device;
+	struct acpi_device device;
 	struct list_head dependent;
-	acpi_bus_id name;
+	char *name;
 	u32 system_level;
 	u32 order;
 	unsigned int ref_count;
@@ -105,28 +101,14 @@ static struct list_head acpi_power_resou
                              Power Resource Management
    -------------------------------------------------------------------------- */
 
-static int
-acpi_power_get_context(acpi_handle handle,
-		       struct acpi_power_resource **resource)
+struct acpi_power_resource *acpi_power_get_context(acpi_handle handle)
 {
-	int result = 0;
-	struct acpi_device *device = NULL;
-
-
-	if (!resource)
-		return -ENODEV;
-
-	result = acpi_bus_get_device(handle, &device);
-	if (result) {
-		printk(KERN_WARNING PREFIX "Getting context [%p]\n", handle);
-		return result;
-	}
+	struct acpi_device *device;
 
-	*resource = acpi_driver_data(device);
-	if (!*resource)
-		return -ENODEV;
+	if (acpi_bus_get_device(handle, &device))
+		return NULL;
 
-	return 0;
+	return container_of(device, struct acpi_power_resource, device);
 }
 
 static int acpi_power_get_state(acpi_handle handle, int *state)
@@ -171,9 +153,9 @@ static int acpi_power_get_list_state(str
 		acpi_handle handle = list->handles[i];
 		int result;
 
-		result = acpi_power_get_context(handle, &resource);
-		if (result)
-			return result;
+		resource = acpi_power_get_context(handle);
+		if (!resource)
+			return -ENODEV;
 
 		mutex_lock(&resource->resource_lock);
 
@@ -226,12 +208,12 @@ static int __acpi_power_on(struct acpi_p
 {
 	acpi_status status = AE_OK;
 
-	status = acpi_evaluate_object(resource->device->handle, "_ON", NULL, NULL);
+	status = acpi_evaluate_object(resource->device.handle, "_ON", NULL, NULL);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
 	/* Update the power resource's _device_ power state */
-	resource->device->power.state = ACPI_STATE_D0;
+	resource->device.power.state = ACPI_STATE_D0;
 
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Power resource [%s] turned on\n",
 			  resource->name));
@@ -242,11 +224,11 @@ static int __acpi_power_on(struct acpi_p
 static int acpi_power_on(acpi_handle handle)
 {
 	int result = 0;
-	struct acpi_power_resource *resource = NULL;
+	struct acpi_power_resource *resource;
 
-	result = acpi_power_get_context(handle, &resource);
-	if (result)
-		return result;
+	resource = acpi_power_get_context(handle);
+	if (!resource)
+		return -ENODEV;
 
 	mutex_lock(&resource->resource_lock);
 
@@ -275,11 +257,11 @@ static int acpi_power_off(acpi_handle ha
 {
 	int result = 0;
 	acpi_status status = AE_OK;
-	struct acpi_power_resource *resource = NULL;
+	struct acpi_power_resource *resource;
 
-	result = acpi_power_get_context(handle, &resource);
-	if (result)
-		return result;
+	resource = acpi_power_get_context(handle);
+	if (!resource)
+		return -ENODEV;
 
 	mutex_lock(&resource->resource_lock);
 
@@ -297,12 +279,12 @@ static int acpi_power_off(acpi_handle ha
 		goto unlock;
 	}
 
-	status = acpi_evaluate_object(resource->device->handle, "_OFF", NULL, NULL);
+	status = acpi_evaluate_object(resource->device.handle, "_OFF", NULL, NULL);
 	if (ACPI_FAILURE(status)) {
 		result = -ENODEV;
 	} else {
 		/* Update the power resource's _device_ power state */
-		resource->device->power.state = ACPI_STATE_D3;
+		resource->device.power.state = ACPI_STATE_D3;
 
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Power resource [%s] turned off\n",
@@ -350,7 +332,11 @@ static void acpi_power_add_dependent(acp
 	struct acpi_power_dependent_device *dep;
 	struct acpi_power_resource *resource;
 
-	if (!rhandle || !adev || acpi_power_get_context(rhandle, &resource))
+	if (!rhandle || !adev)
+		return;
+
+	resource = acpi_power_get_context(rhandle);
+	if (!resource)
 		return;
 
 	mutex_lock(&resource->resource_lock);
@@ -378,7 +364,11 @@ static void acpi_power_remove_dependent(
 	struct acpi_power_resource *resource;
 	struct work_struct *work = NULL;
 
-	if (!rhandle || !adev || acpi_power_get_context(rhandle, &resource))
+	if (!rhandle || !adev)
+		return;
+
+	resource = acpi_power_get_context(rhandle);
+	if (!resource)
 		return;
 
 	mutex_lock(&resource->resource_lock);
@@ -648,46 +638,53 @@ int acpi_power_transition(struct acpi_de
 	return result;
 }
 
-/* --------------------------------------------------------------------------
-                                Driver Interface
-   -------------------------------------------------------------------------- */
+static void acpi_release_power_resource(struct device *dev)
+{
+	struct acpi_device *device = to_acpi_device(dev);
+	struct acpi_power_resource *resource;
 
-static int acpi_power_add(struct acpi_device *device)
+	acpi_free_ids(device);
+	resource = container_of(device, struct acpi_power_resource, device);
+	kfree(resource);
+}
+
+void acpi_add_power_resource(acpi_handle handle)
 {
-	int result = 0, state;
-	acpi_status status = AE_OK;
-	struct acpi_power_resource *resource = NULL;
+	struct acpi_power_resource *resource;
+	struct acpi_device *device = NULL;
 	union acpi_object acpi_object;
 	struct acpi_buffer buffer = { sizeof(acpi_object), &acpi_object };
+	acpi_status status;
+	int state, result = -ENODEV;
 
+	acpi_bus_get_device(handle, &device);
+	if (device)
+		return;
 
-	if (!device)
-		return -EINVAL;
-
-	resource = kzalloc(sizeof(struct acpi_power_resource), GFP_KERNEL);
+	resource = kzalloc(sizeof(*resource), GFP_KERNEL);
 	if (!resource)
-		return -ENOMEM;
+		return;
 
-	resource->device = device;
+	device = &resource->device;
+	acpi_init_device_object(device, handle, ACPI_BUS_TYPE_POWER,
+				ACPI_STA_DEFAULT);
 	mutex_init(&resource->resource_lock);
 	INIT_LIST_HEAD(&resource->dependent);
-	strcpy(resource->name, device->pnp.bus_id);
+	resource->name = device->pnp.bus_id;
 	strcpy(acpi_device_name(device), ACPI_POWER_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_POWER_CLASS);
-	device->driver_data = resource;
 
 	/* Evalute the object to get the system level and resource order. */
-	status = acpi_evaluate_object(device->handle, NULL, NULL, &buffer);
-	if (ACPI_FAILURE(status)) {
-		result = -ENODEV;
-		goto end;
-	}
+	status = acpi_evaluate_object(handle, NULL, NULL, &buffer);
+	if (ACPI_FAILURE(status))
+		goto out;
+
 	resource->system_level = acpi_object.power_resource.system_level;
 	resource->order = acpi_object.power_resource.resource_order;
 
-	result = acpi_power_get_state(device->handle, &state);
+	result = acpi_power_get_state(handle, &state);
 	if (result)
-		goto end;
+		goto out;
 
 	switch (state) {
 	case ACPI_POWER_RESOURCE_STATE_ON:
@@ -698,34 +695,24 @@ static int acpi_power_add(struct acpi_de
 		break;
 	default:
 		device->power.state = ACPI_STATE_UNKNOWN;
-		break;
 	}
 
 	printk(KERN_INFO PREFIX "%s [%s] (%s)\n", acpi_device_name(device),
 	       acpi_device_bid(device), state ? "on" : "off");
 
-      end:
+	device->flags.match_driver = true;
+	result = acpi_device_register(device, acpi_release_power_resource);
+
+ out:
 	if (result)
-		kfree(resource);
+		acpi_release_power_resource(&device->dev);
 
-	return result;
+	return;
 }
 
-static int acpi_power_remove(struct acpi_device *device, int type)
-{
-	struct acpi_power_resource *resource;
-
-	if (!device)
-		return -EINVAL;
-
-	resource = acpi_driver_data(device);
-	if (!resource)
-		return -EINVAL;
-
-	kfree(resource);
-
-	return 0;
-}
+/* --------------------------------------------------------------------------
+                                Driver Interface
+   -------------------------------------------------------------------------- */
 
 #ifdef CONFIG_PM_SLEEP
 static int acpi_power_resume(struct device *dev)

