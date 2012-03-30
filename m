Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135Ab2C3LT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:19:27 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:51544 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934055Ab2C3LSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:18:47 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 47/76] ACPI: Add interface to register/unregister device
 to/from power resources
Date: Fri, 30 Mar 2012 06:13:50 -0400
Message-id: <0090def6c37c8ea29508a435e581f2ef26fea10f.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

Devices may share same list of power resources in _PR0, for example

Device(Dev0)
{
	Name (_PR0, Package (0x01)
	{
		P0PR,
		P1PR
	})
}

Device(Dev1)
{
	Name (_PR0, Package (0x01)
	{
		P0PR,
		P1PR
	}
}

Assume Dev0 and Dev1 were runtime suspended.
Then Dev0 is resumed first and it goes into D0 state.
But Dev1 is left in D0_Uninitialised state.

This is wrong. In this case, Dev1 must be resumed too.

In order to hand this case, each power resource maintains a list of
devices which relies on it.

When power resource is ON, it will check if the devices on its list
can be resumed. The device can only be resumed when all the power
resouces of its _PR0 are ON.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/power.c    |  162 +++++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h |    2 +
 2 files changed, 164 insertions(+)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 0d681fb..7049a7d 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -40,9 +40,11 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include "sleep.h"
+#include "internal.h"
 
 #define PREFIX "ACPI: "
 
@@ -77,6 +79,20 @@ static struct acpi_driver acpi_power_driver = {
 		},
 };
 
+/*
+ * A power managed device
+ * A device may rely on multiple power resources.
+ * */
+struct acpi_power_managed_device {
+	struct device *dev; /* The physical device */
+	acpi_handle *handle;
+};
+
+struct acpi_power_resource_device {
+	struct acpi_power_managed_device *device;
+	struct acpi_power_resource_device *next;
+};
+
 struct acpi_power_resource {
 	struct acpi_device * device;
 	acpi_bus_id name;
@@ -84,6 +100,9 @@ struct acpi_power_resource {
 	u32 order;
 	unsigned int ref_count;
 	struct mutex resource_lock;
+
+	/* List of devices relying on this power resource */
+	struct acpi_power_resource_device *devices;
 };
 
 static struct list_head acpi_power_resource_list;
@@ -183,8 +202,26 @@ static int acpi_power_get_list_state(struct acpi_handle_list *list, int *state)
 	return 0;
 }
 
+/* Resume the device when all power resources in _PR0 are on */
+static void acpi_power_on_device(struct acpi_power_managed_device *device)
+{
+	struct acpi_device *acpi_dev;
+	acpi_handle handle = device->handle;
+	int state;
+
+	if (acpi_bus_get_device(handle, &acpi_dev))
+		return;
+
+	if(acpi_power_get_inferred_state(acpi_dev, &state))
+		return;
+
+	if (state == ACPI_STATE_D0 && pm_runtime_suspended(device->dev))
+		pm_request_resume(device->dev);
+}
+
 static int __acpi_power_on(struct acpi_power_resource *resource)
 {
+	struct acpi_power_resource_device *device_list = resource->devices;
 	acpi_status status = AE_OK;
 
 	status = acpi_evaluate_object(resource->device->handle, "_ON", NULL, NULL);
@@ -197,6 +234,12 @@ static int __acpi_power_on(struct acpi_power_resource *resource)
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Power resource [%s] turned on\n",
 			  resource->name));
 
+	while (device_list) {
+		acpi_power_on_device(device_list->device);
+
+		device_list = device_list->next;
+	}
+
 	return 0;
 }
 
@@ -299,6 +342,125 @@ static int acpi_power_on_list(struct acpi_handle_list *list)
 	return result;
 }
 
+static void __acpi_power_resource_unregister_device(struct device *dev,
+		acpi_handle res_handle)
+{
+	struct acpi_power_resource *resource = NULL;
+	struct acpi_power_resource_device *prev, *curr;
+
+	if (acpi_power_get_context(res_handle, &resource))
+		return;
+
+	mutex_lock(&resource->resource_lock);
+	prev = NULL;
+	curr = resource->devices;
+	while (curr) {
+		if (curr->device->dev == dev) {
+			if (!prev)
+				resource->devices = curr->next;
+			else
+				prev->next = curr->next;
+
+			kfree(curr);
+			break;
+		}
+
+		prev = curr;
+		curr = curr->next;
+	}
+	mutex_unlock(&resource->resource_lock);
+}
+
+/* Unlink dev from all power resources in _PR0 */
+void acpi_power_resource_unregister_device(struct device *dev, acpi_handle handle)
+{
+	struct acpi_device *acpi_dev;
+	struct acpi_handle_list *list;
+	int i;
+
+	if (!dev || !handle)
+		return;
+
+	if (acpi_bus_get_device(handle, &acpi_dev))
+		return;
+
+	list = &acpi_dev->power.states[ACPI_STATE_D0].resources;
+
+	for (i = 0; i < list->count; i++)
+		__acpi_power_resource_unregister_device(dev,
+			list->handles[i]);
+}
+
+static int __acpi_power_resource_register_device(
+	struct acpi_power_managed_device *powered_device, acpi_handle handle)
+{
+	struct acpi_power_resource *resource = NULL;
+	struct acpi_power_resource_device *power_resource_device;
+	int result;
+
+	result = acpi_power_get_context(handle, &resource);
+	if (result)
+		return result;
+
+	power_resource_device = kzalloc(
+		sizeof(*power_resource_device), GFP_KERNEL);
+	if (!power_resource_device)
+		return -ENOMEM;
+
+	power_resource_device->device = powered_device;
+
+	mutex_lock(&resource->resource_lock);
+	power_resource_device->next = resource->devices;
+	resource->devices = power_resource_device;
+	mutex_unlock(&resource->resource_lock);
+
+	return 0;
+}
+
+/* Link dev to all power resources in _PR0 */
+int acpi_power_resource_register_device(struct device *dev, acpi_handle handle)
+{
+	struct acpi_device *acpi_dev;
+	struct acpi_handle_list *list;
+	struct acpi_power_managed_device *powered_device;
+	int i, ret;
+
+	if (!dev || !handle)
+		return -ENODEV;
+
+	ret = acpi_bus_get_device(handle, &acpi_dev);
+	if (ret)
+		goto no_power_resource;
+
+	if (!acpi_dev->power.flags.power_resources)
+		goto no_power_resource;
+
+	powered_device = kzalloc(sizeof(*powered_device), GFP_KERNEL);
+	if (!powered_device)
+		return -ENOMEM;
+
+	powered_device->dev = dev;
+	powered_device->handle = handle;
+
+	list = &acpi_dev->power.states[ACPI_STATE_D0].resources;
+
+	for (i = 0; i < list->count; i++) {
+		ret = __acpi_power_resource_register_device(powered_device,
+			list->handles[i]);
+
+		if (ret) {
+			acpi_power_resource_unregister_device(dev, handle);
+			break;
+		}
+	}
+
+	return ret;
+
+no_power_resource:
+	printk(KERN_WARNING PREFIX "Invalid Power Resource to register!");
+	return -ENODEV;
+}
+
 /**
  * acpi_device_sleep_wake - execute _DSW (Device Sleep Wake) or (deprecated in
  *                          ACPI 3.0) _PSW (Power State Wake)
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 6cd5b64..e168fff 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -323,6 +323,8 @@ int acpi_bus_set_power(acpi_handle handle, int state);
 int acpi_bus_update_power(acpi_handle handle, int *state_p);
 bool acpi_bus_power_manageable(acpi_handle handle);
 bool acpi_bus_can_wakeup(acpi_handle handle);
+int acpi_power_resource_register_device(struct device *dev, acpi_handle handle);
+void acpi_power_resource_unregister_device(struct device *dev, acpi_handle handle);
 #ifdef CONFIG_ACPI_PROC_EVENT
 int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data);
 int acpi_bus_generate_proc_event4(const char *class, const char *bid, u8 type, int data);
-- 
1.7.10.rc2.19.gfae9d

