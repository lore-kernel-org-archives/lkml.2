Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab3ADAIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:08:04 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59164 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab3ADAHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:07:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/12] ACPI / scan: Consolidate extraction of power resources lists
Date: Fri, 04 Jan 2013 01:08:42 +0100
Message-ID: <2939343.yy8nX2pUPY@vostro.rjw.lan>
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

The lists of ACPI power resources are currently extracted in two
different ways, one for wakeup power resources and one for power
resources that device power states depend on.  There is no reason
why it should be done differently in those two cases, so introduce
a common routine for extracting power resources lists from data
returned by AML, acpi_extract_power_resources(), and make the
namespace scanning code use it for both wakeup and device power
states power resources.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |    4 ++-
 drivers/acpi/power.c    |   32 +++++++++++++++++++++++++++++-
 drivers/acpi/scan.c     |   51 +++++++++++++++++++-----------------------------
 3 files changed, 55 insertions(+), 32 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -904,7 +904,6 @@ acpi_bus_extract_wakeup_device_power_pac
 	union acpi_object *package = NULL;
 	union acpi_object *element = NULL;
 	acpi_status status;
-	int i = 0;
 
 	if (!wakeup)
 		return AE_BAD_PARAMETER;
@@ -957,18 +956,9 @@ acpi_bus_extract_wakeup_device_power_pac
 	}
 	wakeup->sleep_state = element->integer.value;
 
-	for (i = 2; i < package->package.count; i++) {
-		acpi_handle rhandle;
-
-		element = &(package->package.elements[i]);
-		if (element->type != ACPI_TYPE_LOCAL_REFERENCE) {
-			status = AE_BAD_DATA;
-			goto out;
-		}
-		rhandle = element->reference.handle;
-		acpi_add_power_resource(rhandle);
-		acpi_power_resources_list_add(rhandle, &wakeup->resources);
-	}
+	status = acpi_extract_power_resources(package, 2, &wakeup->resources);
+	if (ACPI_FAILURE(status))
+		goto out;
 
 	acpi_setup_gpe_for_wake(handle, wakeup->gpe_device, wakeup->gpe_number);
 
@@ -1025,7 +1015,6 @@ static void acpi_bus_get_wakeup_device_f
 	status = acpi_bus_extract_wakeup_device_power_package(device->handle,
 							      &device->wakeup);
 	if (ACPI_FAILURE(status)) {
-		acpi_power_resources_list_free(&device->wakeup.resources);
 		ACPI_EXCEPTION((AE_INFO, status, "Extracting _PRW package"));
 		return;
 	}
@@ -1048,30 +1037,32 @@ static void acpi_bus_get_wakeup_device_f
 static void acpi_bus_init_power_state(struct acpi_device *device, int state)
 {
 	struct acpi_device_power_state *ps = &device->power.states[state];
-	char object_name[5] = { '_', 'P', 'R', '0' + state, '\0' };
-	struct acpi_handle_list resources;
+	char pathname[5] = { '_', 'P', 'R', '0' + state, '\0' };
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	acpi_handle handle;
 	acpi_status status;
 
 	INIT_LIST_HEAD(&ps->resources);
 
-	/* Evaluate "_PRx" to se if power resources are referenced */
-	acpi_evaluate_reference(device->handle, object_name, NULL, &resources);
-	if (resources.count) {
-		int j;
-
-		device->power.flags.power_resources = 1;
-		for (j = 0; j < resources.count; j++) {
-			acpi_handle rhandle = resources.handles[j];
-
-			acpi_add_power_resource(rhandle);
-			acpi_power_resources_list_add(rhandle, &ps->resources);
+	/* Evaluate "_PRx" to get referenced power resources */
+	status = acpi_evaluate_object(device->handle, pathname, NULL, &buffer);
+	if (ACPI_SUCCESS(status)) {
+		union acpi_object *package = buffer.pointer;
+
+		if (buffer.length && package
+		    && package->type == ACPI_TYPE_PACKAGE
+		    && package->package.count) {
+			status = acpi_extract_power_resources(package, 0,
+							      &ps->resources);
+			if (ACPI_SUCCESS(status))
+				device->power.flags.power_resources = 1;
 		}
+		ACPI_FREE(buffer.pointer);
 	}
 
 	/* Evaluate "_PSx" to see if we can do explicit sets */
-	object_name[2] = 'S';
-	status = acpi_get_handle(device->handle, object_name, &handle);
+	pathname[2] = 'S';
+	status = acpi_get_handle(device->handle, pathname, &handle);
 	if (ACPI_SUCCESS(status))
 		ps->flags.explicit_set = 1;
 
@@ -1079,7 +1070,7 @@ static void acpi_bus_init_power_state(st
 	 * State is valid if there are means to put the device into it.
 	 * D3hot is only valid if _PR3 present.
 	 */
-	if (resources.count
+	if (!list_empty(&ps->resources)
 	    || (ps->flags.explicit_set && state < ACPI_STATE_D3_HOT)) {
 		ps->flags.valid = 1;
 		ps->flags.os_accessible = 1;
Index: linux/drivers/acpi/internal.h
===================================================================
--- linux.orig/drivers/acpi/internal.h
+++ linux/drivers/acpi/internal.h
@@ -50,8 +50,10 @@ void acpi_free_ids(struct acpi_device *d
                                   Power Resource
    -------------------------------------------------------------------------- */
 int acpi_power_init(void);
-void acpi_power_resources_list_add(acpi_handle handle, struct list_head *list);
 void acpi_power_resources_list_free(struct list_head *list);
+acpi_status acpi_extract_power_resources(union acpi_object *package,
+					 unsigned int start,
+					 struct list_head *list);
 void acpi_add_power_resource(acpi_handle handle);
 void acpi_power_add_remove_device(struct acpi_device *adev, bool add);
 int acpi_device_sleep_wake(struct acpi_device *dev,
Index: linux/drivers/acpi/power.c
===================================================================
--- linux.orig/drivers/acpi/power.c
+++ linux/drivers/acpi/power.c
@@ -97,7 +97,8 @@ struct acpi_power_resource *acpi_power_g
 	return container_of(device, struct acpi_power_resource, device);
 }
 
-void acpi_power_resources_list_add(acpi_handle handle, struct list_head *list)
+static void acpi_power_resources_list_add(acpi_handle handle,
+					  struct list_head *list)
 {
 	struct acpi_power_resource *resource = acpi_power_get_context(handle);
 	struct acpi_power_resource_entry *entry;
@@ -132,6 +133,35 @@ void acpi_power_resources_list_free(stru
 	}
 }
 
+acpi_status acpi_extract_power_resources(union acpi_object *package,
+					 unsigned int start,
+					 struct list_head *list)
+{
+	acpi_status status = AE_OK;
+	unsigned int i;
+
+	for (i = start; i < package->package.count; i++) {
+		union acpi_object *element = &package->package.elements[i];
+		acpi_handle rhandle;
+
+		if (element->type != ACPI_TYPE_LOCAL_REFERENCE) {
+			status = AE_BAD_DATA;
+			break;
+		}
+		rhandle = element->reference.handle;
+		if (!rhandle) {
+			status = AE_NULL_ENTRY;
+			break;
+		}
+		acpi_add_power_resource(rhandle);
+		acpi_power_resources_list_add(rhandle, list);
+	}
+	if (ACPI_FAILURE(status))
+		acpi_power_resources_list_free(list);
+
+	return status;
+}
+
 static int acpi_power_get_state(acpi_handle handle, int *state)
 {
 	acpi_status status = AE_OK;

