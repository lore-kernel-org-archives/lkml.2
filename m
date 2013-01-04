Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab3ADAHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:07:52 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59167 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab3ADAHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:07:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/12]  ACPI: Drop power resources driver
Date: Fri, 04 Jan 2013 01:03:51 +0100
Message-ID: <7004074.B04ltYkyn5@vostro.rjw.lan>
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

The ACPI power resources driver is not very useful, because the only
thing it really does is to restore the state of the power resources
that were "on" before system suspend or hibernation, but that may be
achieved in a different way.

Drop the ACPI power resources driver entirely and add
acpi_resume_power_resources() that will walk the list of all
registered power resources during system resume and turn on the ones
that were "on" before the preceding system suspend or hibernation.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/power.c |   91 ++++++++++++++++++---------------------------------
 drivers/acpi/scan.c  |    1 
 drivers/acpi/sleep.c |    2 +
 drivers/acpi/sleep.h |    2 +
 4 files changed, 37 insertions(+), 59 deletions(-)

Index: linux/drivers/acpi/power.c
===================================================================
--- linux.orig/drivers/acpi/power.c
+++ linux/drivers/acpi/power.c
@@ -58,27 +58,6 @@ ACPI_MODULE_NAME("power");
 #define ACPI_POWER_RESOURCE_STATE_ON	0x01
 #define ACPI_POWER_RESOURCE_STATE_UNKNOWN 0xFF
 
-static inline int acpi_power_add(struct acpi_device *device) { return 0; }
-
-static const struct acpi_device_id power_device_ids[] = {
-	{ACPI_POWER_HID, 0},
-	{"", 0},
-};
-MODULE_DEVICE_TABLE(acpi, power_device_ids);
-
-#ifdef CONFIG_PM_SLEEP
-static int acpi_power_resume(struct device *dev);
-#endif
-static SIMPLE_DEV_PM_OPS(acpi_power_pm, NULL, acpi_power_resume);
-
-static struct acpi_driver acpi_power_driver = {
-	.name = "power",
-	.class = ACPI_POWER_CLASS,
-	.ids = power_device_ids,
-	.ops.add = acpi_power_add,
-	.drv.pm = &acpi_power_pm,
-};
-
 struct acpi_power_dependent_device {
 	struct list_head node;
 	struct acpi_device *adev;
@@ -87,6 +66,7 @@ struct acpi_power_dependent_device {
 
 struct acpi_power_resource {
 	struct acpi_device device;
+	struct list_head list_node;
 	struct list_head dependent;
 	char *name;
 	u32 system_level;
@@ -95,7 +75,8 @@ struct acpi_power_resource {
 	struct mutex resource_lock;
 };
 
-static struct list_head acpi_power_resource_list;
+static LIST_HEAD(acpi_power_resource_list);
+static DEFINE_MUTEX(power_resource_list_lock);
 
 /* --------------------------------------------------------------------------
                              Power Resource Management
@@ -643,8 +624,13 @@ static void acpi_release_power_resource(
 	struct acpi_device *device = to_acpi_device(dev);
 	struct acpi_power_resource *resource;
 
-	acpi_free_ids(device);
 	resource = container_of(device, struct acpi_power_resource, device);
+
+	mutex_lock(&power_resource_list_lock);
+	list_del(&resource->list_node);
+	mutex_unlock(&power_resource_list_lock);
+
+	acpi_free_ids(device);
 	kfree(resource);
 }
 
@@ -677,14 +663,14 @@ void acpi_add_power_resource(acpi_handle
 	/* Evalute the object to get the system level and resource order. */
 	status = acpi_evaluate_object(handle, NULL, NULL, &buffer);
 	if (ACPI_FAILURE(status))
-		goto out;
+		goto err;
 
 	resource->system_level = acpi_object.power_resource.system_level;
 	resource->order = acpi_object.power_resource.resource_order;
 
 	result = acpi_power_get_state(handle, &state);
 	if (result)
-		goto out;
+		goto err;
 
 	switch (state) {
 	case ACPI_POWER_RESOURCE_STATE_ON:
@@ -702,51 +688,40 @@ void acpi_add_power_resource(acpi_handle
 
 	device->flags.match_driver = true;
 	result = acpi_device_register(device, acpi_release_power_resource);
-
- out:
 	if (result)
-		acpi_release_power_resource(&device->dev);
+		goto err;
 
+	mutex_lock(&power_resource_list_lock);
+	list_add(&resource->list_node, &acpi_power_resource_list);
+	mutex_unlock(&power_resource_list_lock);
 	return;
-}
 
-/* --------------------------------------------------------------------------
-                                Driver Interface
-   -------------------------------------------------------------------------- */
+ err:
+	acpi_release_power_resource(&device->dev);
+}
 
-#ifdef CONFIG_PM_SLEEP
-static int acpi_power_resume(struct device *dev)
+#ifdef CONFIG_ACPI_SLEEP
+void acpi_resume_power_resources(void)
 {
-	int result = 0, state;
-	struct acpi_device *device;
 	struct acpi_power_resource *resource;
 
-	if (!dev)
-		return -EINVAL;
-
-	device = to_acpi_device(dev);
-	resource = acpi_driver_data(device);
-	if (!resource)
-		return -EINVAL;
+	mutex_lock(&power_resource_list_lock);
 
-	mutex_lock(&resource->resource_lock);
+	list_for_each_entry(resource, &acpi_power_resource_list, list_node) {
+		int result, state;
 
-	result = acpi_power_get_state(device->handle, &state);
-	if (result)
-		goto unlock;
+		mutex_lock(&resource->resource_lock);
 
-	if (state == ACPI_POWER_RESOURCE_STATE_OFF && resource->ref_count)
-		result = __acpi_power_on(resource);
+		result = acpi_power_get_state(resource->device.handle, &state);
+		if (!result && state == ACPI_POWER_RESOURCE_STATE_OFF
+		    && resource->ref_count) {
+			dev_info(&resource->device.dev, "Turning ON\n");
+			__acpi_power_on(resource);
+		}
 
- unlock:
-	mutex_unlock(&resource->resource_lock);
+		mutex_unlock(&resource->resource_lock);
+	}
 
-	return result;
+	mutex_unlock(&power_resource_list_lock);
 }
 #endif
-
-int __init acpi_power_init(void)
-{
-	INIT_LIST_HEAD(&acpi_power_resource_list);
-	return acpi_bus_register_driver(&acpi_power_driver);
-}
Index: linux/drivers/acpi/sleep.c
===================================================================
--- linux.orig/drivers/acpi/sleep.c
+++ linux/drivers/acpi/sleep.c
@@ -386,6 +386,8 @@ static void acpi_pm_finish(void)
 
 	acpi_target_sleep_state = ACPI_STATE_S0;
 
+	acpi_resume_power_resources();
+
 	/* If we were woken with the fixed power button, provide a small
 	 * hint to userspace in the form of a wakeup event on the fixed power
 	 * button device (if it can be found).
Index: linux/drivers/acpi/sleep.h
===================================================================
--- linux.orig/drivers/acpi/sleep.h
+++ linux/drivers/acpi/sleep.h
@@ -6,3 +6,5 @@ extern void acpi_disable_wakeup_devices(
 
 extern struct list_head acpi_wakeup_device_list;
 extern struct mutex acpi_device_lock;
+
+extern void acpi_resume_power_resources(void);
Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -1670,7 +1670,6 @@ int __init acpi_scan_init(void)
 		printk(KERN_ERR PREFIX "Could not register bus type\n");
 	}
 
-	acpi_power_init();
 	acpi_pci_root_init();
 
 	/*

