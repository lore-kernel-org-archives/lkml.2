Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab3ADAIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:08:00 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59168 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab3ADAHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:07:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/12] ACPI / PM: Take order attribute of power resources into account
Date: Fri, 04 Jan 2013 01:05:33 +0100
Message-ID: <1635307.F2xdNSFsg7@vostro.rjw.lan>
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

ACPI power resources have an order attribute that should be taken
into account when turning them on and off, but it is not used now.

Modify the power resources management code to preserve the
spec-compliant ordering of power resources that power states of
devices depend on (analogous changes will be done separately for
power resources used for wakeup).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |    2 
 drivers/acpi/power.c    |  159 ++++++++++++++++++++++++++----------------------
 drivers/acpi/scan.c     |   31 +++++++--
 include/acpi/acpi_bus.h |    2 
 4 files changed, 117 insertions(+), 77 deletions(-)

Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -201,7 +201,7 @@ struct acpi_device_power_state {
 	} flags;
 	int power;		/* % Power (compared to D0) */
 	int latency;		/* Dx->D0 time (microseconds) */
-	struct acpi_handle_list resources;	/* Power resources referenced */
+	struct list_head resources;	/* Power resources referenced */
 };
 
 struct acpi_device_power {
Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -481,11 +481,25 @@ void acpi_free_ids(struct acpi_device *d
 	kfree(device->pnp.unique_id);
 }
 
+static void acpi_free_power_resources_lists(struct acpi_device *device)
+{
+	int i;
+
+	if (!device->flags.power_manageable)
+		return;
+
+	for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
+		struct acpi_device_power_state *ps = &device->power.states[i];
+		acpi_power_resources_list_free(&ps->resources);
+	}
+}
+
 static void acpi_device_release(struct device *dev)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 
 	acpi_free_ids(acpi_dev);
+	acpi_free_power_resources_lists(acpi_dev);
 	kfree(acpi_dev);
 }
 
@@ -1061,17 +1075,22 @@ static void acpi_bus_get_power_flags(str
 	for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
 		struct acpi_device_power_state *ps = &device->power.states[i];
 		char object_name[5] = { '_', 'P', 'R', '0' + i, '\0' };
+		struct acpi_handle_list resources;
 
+		INIT_LIST_HEAD(&ps->resources);
 		/* Evaluate "_PRx" to se if power resources are referenced */
 		acpi_evaluate_reference(device->handle, object_name, NULL,
-					&ps->resources);
-		if (ps->resources.count) {
+					&resources);
+		if (resources.count) {
 			int j;
 
 			device->power.flags.power_resources = 1;
-			for (j = 0; j < ps->resources.count; j++) {
-				acpi_handle rhandle = ps->resources.handles[j];
+			for (j = 0; j < resources.count; j++) {
+				acpi_handle rhandle = resources.handles[j];
+
 				acpi_add_power_resource(rhandle);
+				acpi_power_resources_list_add(rhandle,
+							      &ps->resources);
 			}
 		}
 
@@ -1085,7 +1104,7 @@ static void acpi_bus_get_power_flags(str
 		 * State is valid if there are means to put the device into it.
 		 * D3hot is only valid if _PR3 present.
 		 */
-		if (ps->resources.count ||
+		if (resources.count ||
 		    (ps->flags.explicit_set && i < ACPI_STATE_D3_HOT)) {
 			ps->flags.valid = 1;
 			ps->flags.os_accessible = 1;
@@ -1095,6 +1114,8 @@ static void acpi_bus_get_power_flags(str
 		ps->latency = -1;	/* Unknown - driver assigned */
 	}
 
+	INIT_LIST_HEAD(&device->power.states[ACPI_STATE_D3_COLD].resources);
+
 	/* Set defaults for D0 and D3 states (always valid) */
 	device->power.states[ACPI_STATE_D0].flags.valid = 1;
 	device->power.states[ACPI_STATE_D0].power = 100;
Index: linux/drivers/acpi/internal.h
===================================================================
--- linux.orig/drivers/acpi/internal.h
+++ linux/drivers/acpi/internal.h
@@ -50,6 +50,8 @@ void acpi_free_ids(struct acpi_device *d
                                   Power Resource
    -------------------------------------------------------------------------- */
 int acpi_power_init(void);
+void acpi_power_resources_list_add(acpi_handle handle, struct list_head *list);
+void acpi_power_resources_list_free(struct list_head *list);
 void acpi_add_power_resource(acpi_handle handle);
 void acpi_power_add_remove_device(struct acpi_device *adev, bool add);
 int acpi_device_sleep_wake(struct acpi_device *dev,
Index: linux/drivers/acpi/power.c
===================================================================
--- linux.orig/drivers/acpi/power.c
+++ linux/drivers/acpi/power.c
@@ -75,6 +75,11 @@ struct acpi_power_resource {
 	struct mutex resource_lock;
 };
 
+struct acpi_power_resource_entry {
+	struct list_head node;
+	struct acpi_power_resource *resource;
+};
+
 static LIST_HEAD(acpi_power_resource_list);
 static DEFINE_MUTEX(power_resource_list_lock);
 
@@ -92,6 +97,41 @@ struct acpi_power_resource *acpi_power_g
 	return container_of(device, struct acpi_power_resource, device);
 }
 
+void acpi_power_resources_list_add(acpi_handle handle, struct list_head *list)
+{
+	struct acpi_power_resource *resource = acpi_power_get_context(handle);
+	struct acpi_power_resource_entry *entry;
+
+	if (!resource || !list)
+		return;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return;
+
+	entry->resource = resource;
+	if (!list_empty(list)) {
+		struct acpi_power_resource_entry *e;
+
+		list_for_each_entry(e, list, node)
+			if (e->resource->order > resource->order) {
+				list_add_tail(&entry->node, &e->node);
+				return;
+			}
+	}
+	list_add_tail(&entry->node, list);
+}
+
+void acpi_power_resources_list_free(struct list_head *list)
+{
+	struct acpi_power_resource_entry *entry, *e;
+
+	list_for_each_entry_safe(entry, e, list, node) {
+		list_del(&entry->node);
+		kfree(entry);
+	}
+}
+
 static int acpi_power_get_state(acpi_handle handle, int *state)
 {
 	acpi_status status = AE_OK;
@@ -119,31 +159,23 @@ static int acpi_power_get_state(acpi_han
 	return 0;
 }
 
-static int acpi_power_get_list_state(struct acpi_handle_list *list, int *state)
+static int acpi_power_get_list_state(struct list_head *list, int *state)
 {
+	struct acpi_power_resource_entry *entry;
 	int cur_state;
-	int i = 0;
 
 	if (!list || !state)
 		return -EINVAL;
 
 	/* The state of the list is 'on' IFF all resources are 'on'. */
-
-	for (i = 0; i < list->count; i++) {
-		struct acpi_power_resource *resource;
-		acpi_handle handle = list->handles[i];
+	list_for_each_entry(entry, list, node) {
+		struct acpi_power_resource *resource = entry->resource;
+		acpi_handle handle = resource->device.handle;
 		int result;
 
-		resource = acpi_power_get_context(handle);
-		if (!resource)
-			return -ENODEV;
-
 		mutex_lock(&resource->resource_lock);
-
 		result = acpi_power_get_state(handle, &cur_state);
-
 		mutex_unlock(&resource->resource_lock);
-
 		if (result)
 			return result;
 
@@ -155,7 +187,6 @@ static int acpi_power_get_list_state(str
 			  cur_state ? "on" : "off"));
 
 	*state = cur_state;
-
 	return 0;
 }
 
@@ -199,14 +230,9 @@ static int __acpi_power_on(struct acpi_p
 	return 0;
 }
 
-static int acpi_power_on(acpi_handle handle)
+static int acpi_power_on(struct acpi_power_resource *resource)
 {
-	int result = 0;
-	struct acpi_power_resource *resource;
-
-	resource = acpi_power_get_context(handle);
-	if (!resource)
-		return -ENODEV;
+	int result = 0;;
 
 	mutex_lock(&resource->resource_lock);
 
@@ -231,15 +257,10 @@ static int acpi_power_on(acpi_handle han
 	return result;
 }
 
-static int acpi_power_off(acpi_handle handle)
+static int acpi_power_off(struct acpi_power_resource *resource)
 {
-	int result = 0;
 	acpi_status status = AE_OK;
-	struct acpi_power_resource *resource;
-
-	resource = acpi_power_get_context(handle);
-	if (!resource)
-		return -ENODEV;
+	int result = 0;
 
 	mutex_lock(&resource->resource_lock);
 
@@ -271,47 +292,48 @@ static int acpi_power_off(acpi_handle ha
 	return result;
 }
 
-static void __acpi_power_off_list(struct acpi_handle_list *list, int num_res)
+static int acpi_power_off_list(struct list_head *list)
 {
-	int i;
+	struct acpi_power_resource_entry *entry;
+	int result = 0;
 
-	for (i = num_res - 1; i >= 0 ; i--)
-		acpi_power_off(list->handles[i]);
-}
+	list_for_each_entry_reverse(entry, list, node) {
+		result = acpi_power_off(entry->resource);
+		if (result)
+			goto err;
+	}
+	return 0;
 
-static void acpi_power_off_list(struct acpi_handle_list *list)
-{
-	__acpi_power_off_list(list, list->count);
+ err:
+	list_for_each_entry_continue(entry, list, node)
+		acpi_power_on(entry->resource);
+
+	return result;
 }
 
-static int acpi_power_on_list(struct acpi_handle_list *list)
+static int acpi_power_on_list(struct list_head *list)
 {
+	struct acpi_power_resource_entry *entry;
 	int result = 0;
-	int i;
 
-	for (i = 0; i < list->count; i++) {
-		result = acpi_power_on(list->handles[i]);
-		if (result) {
-			__acpi_power_off_list(list, i);
-			break;
-		}
+	list_for_each_entry(entry, list, node) {
+		result = acpi_power_on(entry->resource);
+		if (result)
+			goto err;
 	}
+	return 0;
+
+ err:
+	list_for_each_entry_continue_reverse(entry, list, node)
+		acpi_power_off(entry->resource);
 
 	return result;
 }
 
-static void acpi_power_add_dependent(acpi_handle rhandle,
+static void acpi_power_add_dependent(struct acpi_power_resource *resource,
 				     struct acpi_device *adev)
 {
 	struct acpi_power_dependent_device *dep;
-	struct acpi_power_resource *resource;
-
-	if (!rhandle || !adev)
-		return;
-
-	resource = acpi_power_get_context(rhandle);
-	if (!resource)
-		return;
 
 	mutex_lock(&resource->resource_lock);
 
@@ -331,20 +353,12 @@ static void acpi_power_add_dependent(acp
 	mutex_unlock(&resource->resource_lock);
 }
 
-static void acpi_power_remove_dependent(acpi_handle rhandle,
+static void acpi_power_remove_dependent(struct acpi_power_resource *resource,
 					struct acpi_device *adev)
 {
 	struct acpi_power_dependent_device *dep;
-	struct acpi_power_resource *resource;
 	struct work_struct *work = NULL;
 
-	if (!rhandle || !adev)
-		return;
-
-	resource = acpi_power_get_context(rhandle);
-	if (!resource)
-		return;
-
 	mutex_lock(&resource->resource_lock);
 
 	list_for_each_entry(dep, &resource->dependent, node)
@@ -366,16 +380,16 @@ void acpi_power_add_remove_device(struct
 {
 	if (adev->power.flags.power_resources) {
 		struct acpi_device_power_state *ps;
-		int j;
+		struct acpi_power_resource_entry *entry;
 
 		ps = &adev->power.states[ACPI_STATE_D0];
-		for (j = 0; j < ps->resources.count; j++) {
-			acpi_handle rhandle = ps->resources.handles[j];
+		list_for_each_entry(entry, &ps->resources, node) {
+			struct acpi_power_resource *resource = entry->resource;
 
 			if (add)
-				acpi_power_add_dependent(rhandle, adev);
+				acpi_power_add_dependent(resource, adev);
 			else
-				acpi_power_remove_dependent(rhandle, adev);
+				acpi_power_remove_dependent(resource, adev);
 		}
 	}
 }
@@ -539,7 +553,6 @@ int acpi_disable_wakeup_device_power(str
 int acpi_power_get_inferred_state(struct acpi_device *device, int *state)
 {
 	int result = 0;
-	struct acpi_handle_list *list = NULL;
 	int list_state = 0;
 	int i = 0;
 
@@ -551,8 +564,9 @@ int acpi_power_get_inferred_state(struct
 	 * required for a given D-state are 'on'.
 	 */
 	for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
-		list = &device->power.states[i].resources;
-		if (list->count < 1)
+		struct list_head *list = &device->power.states[i].resources;
+
+		if (list_empty(list))
 			continue;
 
 		result = acpi_power_get_list_state(list, &list_state);
@@ -571,9 +585,12 @@ int acpi_power_get_inferred_state(struct
 
 int acpi_power_on_resources(struct acpi_device *device, int state)
 {
-	if (!device || state < ACPI_STATE_D0 || state > ACPI_STATE_D3)
+	if (!device || state < ACPI_STATE_D0 || state > ACPI_STATE_D3_COLD)
 		return -EINVAL;
 
+	if (state == ACPI_STATE_D3_COLD)
+		return 0;
+
 	return acpi_power_on_list(&device->power.states[state].resources);
 }
 

