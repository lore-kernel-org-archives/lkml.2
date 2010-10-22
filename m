Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab0JVAhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:37:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42236 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196Ab0JVAhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:37:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI / PM: Fix reference counting of power resources
Date: Fri, 22 Oct 2010 02:35:54 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010220235.55050.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The reference counting of ACPI power resources is currently broken
for a few reasons.  First, instead of using a simple reference
counter per power resource it uses a list of objects representing
refereces to the given power resource from devices.  This leads to
the second breakage, because it prevents power resources from
being referenced more than once by one device, which is necessary
if the device is configured to signal wakeup.  Namely, when putting
the device into a low power state we first call
acpi_enable_wakeup_device_power() that should reference count power
resources needed for signaling wakeup and then we call
acpi_power_transition() to power off the device.  The latter call
drops references to the device's power resources, possibly including
the ones added by acpi_enable_wakeup_device_power(), so the device
can't signal wakeup as a result.  Apart from this, the locking
in acpi_power_on() and acpi_power_off_device() doesn't prevent
all possible races from happening, which may be problematic for
runtime PM and asynchronous suspend and resume.

Fix the problem by using a counter for power resources reference
counting and putting the evaluation of ACPI _ON and _OFF methods
under the power resource mutex.

Reported-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/power.c |  167 +++++++++++++++++++++------------------------------
 1 file changed, 70 insertions(+), 97 deletions(-)

Index: linux-2.6/drivers/acpi/power.c
===================================================================
--- linux-2.6.orig/drivers/acpi/power.c
+++ linux-2.6/drivers/acpi/power.c
@@ -80,18 +80,13 @@ static struct acpi_driver acpi_power_dri
 		},
 };
 
-struct acpi_power_reference {
-	struct list_head node;
-	struct acpi_device *device;
-};
-
 struct acpi_power_resource {
 	struct acpi_device * device;
 	acpi_bus_id name;
 	u32 system_level;
 	u32 order;
+	unsigned int ref_count;
 	struct mutex resource_lock;
-	struct list_head reference;
 };
 
 static struct list_head acpi_power_resource_list;
@@ -184,101 +179,89 @@ static int acpi_power_get_list_state(str
 	return result;
 }
 
-static int acpi_power_on(acpi_handle handle, struct acpi_device *dev)
+static int __acpi_power_on(struct acpi_power_resource *resource)
 {
-	int result = 0;
-	int found = 0;
 	acpi_status status = AE_OK;
-	struct acpi_power_resource *resource = NULL;
-	struct list_head *node, *next;
-	struct acpi_power_reference *ref;
 
+	status = acpi_evaluate_object(resource->device->handle, "_ON", NULL, NULL);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	/* Update the power resource's _device_ power state */
+	resource->device->power.state = ACPI_STATE_D0;
+
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Power resource [%s] turned on\n",
+			  resource->name));
+
+	return 0;
+}
+
+static int acpi_power_on(acpi_handle handle)
+{
+	int result = 0;
+	struct acpi_power_resource *resource = NULL;
 
 	result = acpi_power_get_context(handle, &resource);
 	if (result)
 		return result;
 
 	mutex_lock(&resource->resource_lock);
-	list_for_each_safe(node, next, &resource->reference) {
-		ref = container_of(node, struct acpi_power_reference, node);
-		if (dev->handle == ref->device->handle) {
-			ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] already referenced by resource [%s]\n",
-				  dev->pnp.bus_id, resource->name));
-			found = 1;
-			break;
-		}
-	}
 
-	if (!found) {
-		ref = kmalloc(sizeof (struct acpi_power_reference),
-		    irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL);
-		if (!ref) {
-			ACPI_DEBUG_PRINT((ACPI_DB_INFO, "kmalloc() failed\n"));
-			mutex_unlock(&resource->resource_lock);
-			return -ENOMEM;
-		}
-		list_add_tail(&ref->node, &resource->reference);
-		ref->device = dev;
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] added to resource [%s] references\n",
-			  dev->pnp.bus_id, resource->name));
+	if (resource->ref_count++) {
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				  "Power resource [%s] already on",
+				  resource->name));
+	} else {
+		result = __acpi_power_on(resource);
 	}
-	mutex_unlock(&resource->resource_lock);
 
-	status = acpi_evaluate_object(resource->device->handle, "_ON", NULL, NULL);
-	if (ACPI_FAILURE(status))
-		return -ENODEV;
-
-	/* Update the power resource's _device_ power state */
-	resource->device->power.state = ACPI_STATE_D0;
+	mutex_unlock(&resource->resource_lock);
 
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Resource [%s] turned on\n",
-			  resource->name));
 	return 0;
 }
 
-static int acpi_power_off_device(acpi_handle handle, struct acpi_device *dev)
+static int acpi_power_off_device(acpi_handle handle)
 {
 	int result = 0;
 	acpi_status status = AE_OK;
 	struct acpi_power_resource *resource = NULL;
-	struct list_head *node, *next;
-	struct acpi_power_reference *ref;
 
 	result = acpi_power_get_context(handle, &resource);
 	if (result)
 		return result;
 
 	mutex_lock(&resource->resource_lock);
-	list_for_each_safe(node, next, &resource->reference) {
-		ref = container_of(node, struct acpi_power_reference, node);
-		if (dev->handle == ref->device->handle) {
-			list_del(&ref->node);
-			kfree(ref);
-			ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] removed from resource [%s] references\n",
-			    dev->pnp.bus_id, resource->name));
-			break;
-		}
+
+	if (!resource->ref_count) {
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				  "Power resource [%s] already off",
+				  resource->name));
+		goto unlock;
 	}
 
-	if (!list_empty(&resource->reference)) {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Cannot turn resource [%s] off - resource is in use\n",
-		    resource->name));
-		mutex_unlock(&resource->resource_lock);
-		return 0;
+	if (--resource->ref_count) {
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				  "Power resource [%s] still in use\n",
+				  resource->name));
+		goto unlock;
 	}
-	mutex_unlock(&resource->resource_lock);
 
 	status = acpi_evaluate_object(resource->device->handle, "_OFF", NULL, NULL);
-	if (ACPI_FAILURE(status))
-		return -ENODEV;
+	if (ACPI_FAILURE(status)) {
+		result = -ENODEV;
+	} else {
+		/* Update the power resource's _device_ power state */
+		resource->device->power.state = ACPI_STATE_D3;
 
-	/* Update the power resource's _device_ power state */
-	resource->device->power.state = ACPI_STATE_D3;
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				  "Power resource [%s] turned off\n",
+				  resource->name));
+	}
 
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Resource [%s] turned off\n",
-			  resource->name));
+ unlock:
+	mutex_unlock(&resource->resource_lock);
 
-	return 0;
+	return result;
 }
 
 /**
@@ -364,7 +347,7 @@ int acpi_enable_wakeup_device_power(stru
 
 	/* Open power resource */
 	for (i = 0; i < dev->wakeup.resources.count; i++) {
-		int ret = acpi_power_on(dev->wakeup.resources.handles[i], dev);
+		int ret = acpi_power_on(dev->wakeup.resources.handles[i]);
 		if (ret) {
 			printk(KERN_ERR PREFIX "Transition power state\n");
 			dev->wakeup.flags.valid = 0;
@@ -420,7 +403,7 @@ int acpi_disable_wakeup_device_power(str
 	/* Close power resource */
 	for (i = 0; i < dev->wakeup.resources.count; i++) {
 		int ret = acpi_power_off_device(
-				dev->wakeup.resources.handles[i], dev);
+				dev->wakeup.resources.handles[i]);
 		if (ret) {
 			printk(KERN_ERR PREFIX "Transition power state\n");
 			dev->wakeup.flags.valid = 0;
@@ -500,7 +483,7 @@ int acpi_power_transition(struct acpi_de
 	 * (e.g. so the device doesn't lose power while transitioning).
 	 */
 	for (i = 0; i < tl->count; i++) {
-		result = acpi_power_on(tl->handles[i], device);
+		result = acpi_power_on(tl->handles[i]);
 		if (result)
 			goto end;
 	}
@@ -513,7 +496,7 @@ int acpi_power_transition(struct acpi_de
 	 * Then we dereference all power resources used in the current list.
 	 */
 	for (i = 0; i < cl->count; i++) {
-		result = acpi_power_off_device(cl->handles[i], device);
+		result = acpi_power_off_device(cl->handles[i]);
 		if (result)
 			goto end;
 	}
@@ -551,7 +534,6 @@ static int acpi_power_add(struct acpi_de
 
 	resource->device = device;
 	mutex_init(&resource->resource_lock);
-	INIT_LIST_HEAD(&resource->reference);
 	strcpy(resource->name, device->pnp.bus_id);
 	strcpy(acpi_device_name(device), ACPI_POWER_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_POWER_CLASS);
@@ -594,22 +576,14 @@ static int acpi_power_add(struct acpi_de
 
 static int acpi_power_remove(struct acpi_device *device, int type)
 {
-	struct acpi_power_resource *resource = NULL;
-	struct list_head *node, *next;
+	struct acpi_power_resource *resource;
 
-
-	if (!device || !acpi_driver_data(device))
+	if (!device)
 		return -EINVAL;
 
 	resource = acpi_driver_data(device);
-
-	mutex_lock(&resource->resource_lock);
-	list_for_each_safe(node, next, &resource->reference) {
-		struct acpi_power_reference *ref = container_of(node, struct acpi_power_reference, node);
-		list_del(&ref->node);
-		kfree(ref);
-	}
-	mutex_unlock(&resource->resource_lock);
+	if (!resource)
+		return -EINVAL;
 
 	kfree(resource);
 
@@ -619,29 +593,28 @@ static int acpi_power_remove(struct acpi
 static int acpi_power_resume(struct acpi_device *device)
 {
 	int result = 0, state;
-	struct acpi_power_resource *resource = NULL;
-	struct acpi_power_reference *ref;
+	struct acpi_power_resource *resource;
 
-	if (!device || !acpi_driver_data(device))
+	if (!device)
 		return -EINVAL;
 
 	resource = acpi_driver_data(device);
+	if (!resource)
+		return -EINVAL;
+
+	mutex_lock(&resource->resource_lock);
 
 	result = acpi_power_get_state(device->handle, &state);
 	if (result)
-		return result;
+		goto unlock;
 
-	mutex_lock(&resource->resource_lock);
-	if (state == ACPI_POWER_RESOURCE_STATE_OFF &&
-	    !list_empty(&resource->reference)) {
-		ref = container_of(resource->reference.next, struct acpi_power_reference, node);
-		mutex_unlock(&resource->resource_lock);
-		result = acpi_power_on(device->handle, ref->device);
-		return result;
-	}
+	if (state == ACPI_POWER_RESOURCE_STATE_OFF && resource->ref_count)
+		result = __acpi_power_on(resource);
 
+ unlock:
 	mutex_unlock(&resource->resource_lock);
-	return 0;
+
+	return result;
 }
 
 int __init acpi_power_init(void)
