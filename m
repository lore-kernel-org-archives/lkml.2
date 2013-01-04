Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab3ADAHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:07:45 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59169 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab3ADAHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:07:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/12] ACPI / PM: Rework the handling of devices depending on power resources
Date: Fri, 04 Jan 2013 01:01:33 +0100
Message-ID: <1637260.lmDsosM5TA@vostro.rjw.lan>
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

Commit 0090def6 (ACPI: Add interface to register/unregister device
to/from power resources) made it possible to indicate to the ACPI
core that if the given device depends on any power resources, then
it should be resumed as soon as all of the power resources required
by it to transition to the D0 power state have been turned on.

Unfortunately, however, this was a mistake, because all devices
depending on power resources should be treated this way (i.e. they
should be resumed when all power resources required by their D0
state have been turned on) and for the majority of those devices
the ACPI core can figure out by itself which (physical) devices
depend on what power resources.

For this reason, replace the code added by commit 0090def6 with a
new, much more straightforward, mechanism that will be used
internally by the ACPI core and remove all references to that code
from kernel subsystems using ACPI.

For the cases when there are (physical) devices that should be
resumed whenever a not directly related ACPI device node goes into
D0 as a result of power resources configuration changes, like in
the SATA case, add two new routines, acpi_dev_pm_add_dependent()
and acpi_dev_pm_remove_dependent(), allowing subsystems to manage
such dependencies.  Convert the SATA subsystem to use the new
functions accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

This patch supersedes https://patchwork.kernel.org/patch/1920551/ and all
previous versions of it.

Thanks,
Rafael

---
 drivers/acpi/device_pm.c  |   56 +++++++++++
 drivers/acpi/internal.h   |    1 
 drivers/acpi/power.c      |  219 +++++++++++++++++-----------------------------
 drivers/acpi/scan.c       |    8 +
 drivers/ata/libata-acpi.c |   18 ---
 drivers/pci/pci-acpi.c    |    2 
 include/acpi/acpi_bus.h   |    3 
 include/linux/acpi.h      |    6 +
 8 files changed, 158 insertions(+), 155 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -639,6 +639,7 @@ static int acpi_device_register(struct a
 	INIT_LIST_HEAD(&device->wakeup_list);
 	INIT_LIST_HEAD(&device->physical_node_list);
 	mutex_init(&device->physical_node_lock);
+	INIT_LIST_HEAD(&device->power_dependent);
 
 	new_bus_id = kzalloc(sizeof(struct acpi_device_bus_id), GFP_KERNEL);
 	if (!new_bus_id) {
@@ -712,8 +713,14 @@ static void acpi_device_unregister(struc
 
 	acpi_detach_data(device->handle, acpi_bus_data_handler);
 
+	acpi_power_add_remove_device(device, false);
 	acpi_device_remove_files(device);
 	device_unregister(&device->dev);
+	/*
+	 * Drop the reference counts of all power resources the device depends
+	 * on and turn off the ones that have no more references.
+	 */
+	acpi_power_transition(device, ACPI_STATE_D3_COLD);
 }
 
 /* --------------------------------------------------------------------------
@@ -1463,6 +1470,7 @@ static int acpi_add_single_object(struct
 
 end:
 	if (!result) {
+		acpi_power_add_remove_device(device, true);
 		acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			"Adding %s [%s] parent %s\n", dev_name(&device->dev),
Index: linux/drivers/acpi/power.c
===================================================================
--- linux.orig/drivers/acpi/power.c
+++ linux/drivers/acpi/power.c
@@ -83,31 +83,20 @@ static struct acpi_driver acpi_power_dri
 	.drv.pm = &acpi_power_pm,
 };
 
-/*
- * A power managed device
- * A device may rely on multiple power resources.
- * */
-struct acpi_power_managed_device {
-	struct device *dev; /* The physical device */
-	acpi_handle *handle;
-};
-
-struct acpi_power_resource_device {
-	struct acpi_power_managed_device *device;
-	struct acpi_power_resource_device *next;
+struct acpi_power_dependent_device {
+	struct list_head node;
+	struct acpi_device *adev;
+	struct work_struct work;
 };
 
 struct acpi_power_resource {
-	struct acpi_device * device;
+	struct acpi_device *device;
+	struct list_head dependent;
 	acpi_bus_id name;
 	u32 system_level;
 	u32 order;
 	unsigned int ref_count;
 	struct mutex resource_lock;
-
-	/* List of devices relying on this power resource */
-	struct acpi_power_resource_device *devices;
-	struct mutex devices_lock;
 };
 
 static struct list_head acpi_power_resource_list;
@@ -207,21 +196,30 @@ static int acpi_power_get_list_state(str
 	return 0;
 }
 
-/* Resume the device when all power resources in _PR0 are on */
-static void acpi_power_on_device(struct acpi_power_managed_device *device)
+static void acpi_power_resume_dependent(struct work_struct *work)
 {
-	struct acpi_device *acpi_dev;
-	acpi_handle handle = device->handle;
+	struct acpi_power_dependent_device *dep;
+	struct acpi_device_physical_node *pn;
+	struct acpi_device *adev;
 	int state;
 
-	if (acpi_bus_get_device(handle, &acpi_dev))
+	dep = container_of(work, struct acpi_power_dependent_device, work);
+	adev = dep->adev;
+	if (acpi_power_get_inferred_state(adev, &state))
 		return;
 
-	if(acpi_power_get_inferred_state(acpi_dev, &state))
+	if (state > ACPI_STATE_D0)
 		return;
 
-	if (state == ACPI_STATE_D0 && pm_runtime_suspended(device->dev))
-		pm_request_resume(device->dev);
+	mutex_lock(&adev->physical_node_lock);
+
+	list_for_each_entry(pn, &adev->physical_node_list, node)
+		pm_request_resume(pn->dev);
+
+	list_for_each_entry(pn, &adev->power_dependent, node)
+		pm_request_resume(pn->dev);
+
+	mutex_unlock(&adev->physical_node_lock);
 }
 
 static int __acpi_power_on(struct acpi_power_resource *resource)
@@ -244,9 +242,7 @@ static int __acpi_power_on(struct acpi_p
 static int acpi_power_on(acpi_handle handle)
 {
 	int result = 0;
-	bool resume_device = false;
 	struct acpi_power_resource *resource = NULL;
-	struct acpi_power_resource_device *device_list;
 
 	result = acpi_power_get_context(handle, &resource);
 	if (result)
@@ -260,26 +256,17 @@ static int acpi_power_on(acpi_handle han
 				  resource->name));
 	} else {
 		result = __acpi_power_on(resource);
-		if (result)
+		if (result) {
 			resource->ref_count--;
-		else
-			resume_device = true;
-	}
-
-	mutex_unlock(&resource->resource_lock);
-
-	if (!resume_device)
-		return result;
-
-	mutex_lock(&resource->devices_lock);
+		} else {
+			struct acpi_power_dependent_device *dep;
 
-	device_list = resource->devices;
-	while (device_list) {
-		acpi_power_on_device(device_list->device);
-		device_list = device_list->next;
+			list_for_each_entry(dep, &resource->dependent, node)
+				schedule_work(&dep->work);
+		}
 	}
 
-	mutex_unlock(&resource->devices_lock);
+	mutex_unlock(&resource->resource_lock);
 
 	return result;
 }
@@ -357,119 +344,81 @@ static int acpi_power_on_list(struct acp
 	return result;
 }
 
-static void __acpi_power_resource_unregister_device(struct device *dev,
-		acpi_handle res_handle)
+static void acpi_power_add_dependent(acpi_handle rhandle,
+				     struct acpi_device *adev)
 {
-	struct acpi_power_resource *resource = NULL;
-	struct acpi_power_resource_device *prev, *curr;
+	struct acpi_power_dependent_device *dep;
+	struct acpi_power_resource *resource;
 
-	if (acpi_power_get_context(res_handle, &resource))
+	if (!rhandle || !adev || acpi_power_get_context(rhandle, &resource))
 		return;
 
-	mutex_lock(&resource->devices_lock);
-	prev = NULL;
-	curr = resource->devices;
-	while (curr) {
-		if (curr->device->dev == dev) {
-			if (!prev)
-				resource->devices = curr->next;
-			else
-				prev->next = curr->next;
-
-			kfree(curr);
-			break;
-		}
-
-		prev = curr;
-		curr = curr->next;
-	}
-	mutex_unlock(&resource->devices_lock);
-}
-
-/* Unlink dev from all power resources in _PR0 */
-void acpi_power_resource_unregister_device(struct device *dev, acpi_handle handle)
-{
-	struct acpi_device *acpi_dev;
-	struct acpi_handle_list *list;
-	int i;
+	mutex_lock(&resource->resource_lock);
 
-	if (!dev || !handle)
-		return;
+	list_for_each_entry(dep, &resource->dependent, node)
+		if (dep->adev == adev)
+			goto out;
 
-	if (acpi_bus_get_device(handle, &acpi_dev))
-		return;
+	dep = kzalloc(sizeof(*dep), GFP_KERNEL);
+	if (!dep)
+		goto out;
 
-	list = &acpi_dev->power.states[ACPI_STATE_D0].resources;
+	dep->adev = adev;
+	INIT_WORK(&dep->work, acpi_power_resume_dependent);
+	list_add_tail(&dep->node, &resource->dependent);
 
-	for (i = 0; i < list->count; i++)
-		__acpi_power_resource_unregister_device(dev,
-			list->handles[i]);
+ out:
+	mutex_unlock(&resource->resource_lock);
 }
-EXPORT_SYMBOL_GPL(acpi_power_resource_unregister_device);
 
-static int __acpi_power_resource_register_device(
-	struct acpi_power_managed_device *powered_device, acpi_handle handle)
+static void acpi_power_remove_dependent(acpi_handle rhandle,
+					struct acpi_device *adev)
 {
-	struct acpi_power_resource *resource = NULL;
-	struct acpi_power_resource_device *power_resource_device;
-	int result;
+	struct acpi_power_dependent_device *dep;
+	struct acpi_power_resource *resource;
+	struct work_struct *work = NULL;
 
-	result = acpi_power_get_context(handle, &resource);
-	if (result)
-		return result;
+	if (!rhandle || !adev || acpi_power_get_context(rhandle, &resource))
+		return;
 
-	power_resource_device = kzalloc(
-		sizeof(*power_resource_device), GFP_KERNEL);
-	if (!power_resource_device)
-		return -ENOMEM;
+	mutex_lock(&resource->resource_lock);
 
-	power_resource_device->device = powered_device;
+	list_for_each_entry(dep, &resource->dependent, node)
+		if (dep->adev == adev) {
+			list_del(&dep->node);
+			work = &dep->work;
+			break;
+		}
 
-	mutex_lock(&resource->devices_lock);
-	power_resource_device->next = resource->devices;
-	resource->devices = power_resource_device;
-	mutex_unlock(&resource->devices_lock);
+	mutex_unlock(&resource->resource_lock);
 
-	return 0;
+	if (work) {
+		cancel_work_sync(work);
+		kfree(dep);
+	}
 }
 
-/* Link dev to all power resources in _PR0 */
-int acpi_power_resource_register_device(struct device *dev, acpi_handle handle)
+void acpi_power_add_remove_device(struct acpi_device *adev, bool add)
 {
-	struct acpi_device *acpi_dev;
-	struct acpi_handle_list *list;
-	struct acpi_power_managed_device *powered_device;
-	int i, ret;
-
-	if (!dev || !handle)
-		return -ENODEV;
-
-	ret = acpi_bus_get_device(handle, &acpi_dev);
-	if (ret || !acpi_dev->power.flags.power_resources)
-		return -ENODEV;
+	if (adev->power.flags.power_resources) {
+		struct acpi_device_power_state *ps;
+		int j;
 
-	powered_device = kzalloc(sizeof(*powered_device), GFP_KERNEL);
-	if (!powered_device)
-		return -ENOMEM;
-
-	powered_device->dev = dev;
-	powered_device->handle = handle;
-
-	list = &acpi_dev->power.states[ACPI_STATE_D0].resources;
-
-	for (i = 0; i < list->count; i++) {
-		ret = __acpi_power_resource_register_device(powered_device,
-			list->handles[i]);
+		ps = &adev->power.states[ACPI_STATE_D0];
+		for (j = 0; j < ps->resources.count; j++) {
+			acpi_handle rhandle = ps->resources.handles[j];
 
-		if (ret) {
-			acpi_power_resource_unregister_device(dev, handle);
-			break;
+			if (add)
+				acpi_power_add_dependent(rhandle, adev);
+			else
+				acpi_power_remove_dependent(rhandle, adev);
 		}
 	}
-
-	return ret;
 }
-EXPORT_SYMBOL_GPL(acpi_power_resource_register_device);
+
+/* --------------------------------------------------------------------------
+                             Device Power Management
+   -------------------------------------------------------------------------- */
 
 /**
  * acpi_device_sleep_wake - execute _DSW (Device Sleep Wake) or (deprecated in
@@ -623,10 +572,6 @@ int acpi_disable_wakeup_device_power(str
 	return err;
 }
 
-/* --------------------------------------------------------------------------
-                             Device Power Management
-   -------------------------------------------------------------------------- */
-
 int acpi_power_get_inferred_state(struct acpi_device *device, int *state)
 {
 	int result = 0;
@@ -725,7 +670,7 @@ static int acpi_power_add(struct acpi_de
 
 	resource->device = device;
 	mutex_init(&resource->resource_lock);
-	mutex_init(&resource->devices_lock);
+	INIT_LIST_HEAD(&resource->dependent);
 	strcpy(resource->name, device->pnp.bus_id);
 	strcpy(acpi_device_name(device), ACPI_POWER_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_POWER_CLASS);
Index: linux/drivers/acpi/internal.h
===================================================================
--- linux.orig/drivers/acpi/internal.h
+++ linux/drivers/acpi/internal.h
@@ -38,6 +38,7 @@ static inline void acpi_debugfs_init(voi
                                   Power Resource
    -------------------------------------------------------------------------- */
 int acpi_power_init(void);
+void acpi_power_add_remove_device(struct acpi_device *adev, bool add);
 int acpi_device_sleep_wake(struct acpi_device *dev,
                            int enable, int sleep_state, int dev_state);
 int acpi_power_get_inferred_state(struct acpi_device *device, int *state);
Index: linux/drivers/pci/pci-acpi.c
===================================================================
--- linux.orig/drivers/pci/pci-acpi.c
+++ linux/drivers/pci/pci-acpi.c
@@ -327,7 +327,6 @@ static void pci_acpi_setup(struct device
 		acpi_pci_irq_add_prt(handle, pci_domain_nr(pci_dev->bus), bus);
 	}
 
-	acpi_power_resource_register_device(dev, handle);
 	if (acpi_bus_get_device(handle, &adev) || !adev->wakeup.flags.valid)
 		return;
 
@@ -350,7 +349,6 @@ static void pci_acpi_cleanup(struct devi
 		device_set_run_wake(dev, false);
 		pci_acpi_remove_pm_notifier(adev);
 	}
-	acpi_power_resource_unregister_device(dev, handle);
 
 	if (pci_dev->subordinate)
 		acpi_pci_irq_del_prt(pci_domain_nr(pci_dev->bus),
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -282,6 +282,7 @@ struct acpi_device {
 	struct list_head physical_node_list;
 	struct mutex physical_node_lock;
 	DECLARE_BITMAP(physical_node_id_bitmap, ACPI_MAX_PHYSICAL_NODE);
+	struct list_head power_dependent;
 };
 
 static inline void *acpi_driver_data(struct acpi_device *d)
@@ -337,8 +338,6 @@ int acpi_device_set_power(struct acpi_de
 int acpi_bus_update_power(acpi_handle handle, int *state_p);
 bool acpi_bus_power_manageable(acpi_handle handle);
 bool acpi_bus_can_wakeup(acpi_handle handle);
-int acpi_power_resource_register_device(struct device *dev, acpi_handle handle);
-void acpi_power_resource_unregister_device(struct device *dev, acpi_handle handle);
 #ifdef CONFIG_ACPI_PROC_EVENT
 int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data);
 int acpi_bus_generate_proc_event4(const char *class, const char *bid, u8 type, int data);
Index: linux/drivers/ata/libata-acpi.c
===================================================================
--- linux.orig/drivers/ata/libata-acpi.c
+++ linux/drivers/ata/libata-acpi.c
@@ -1029,30 +1029,20 @@ static void ata_acpi_register_power_reso
 {
 	struct scsi_device *sdev = dev->sdev;
 	acpi_handle handle;
-	struct device *device;
 
 	handle = ata_dev_acpi_handle(dev);
-	if (!handle)
-		return;
-
-	device = &sdev->sdev_gendev;
-
-	acpi_power_resource_register_device(device, handle);
+	if (handle)
+		acpi_dev_pm_remove_dependent(handle, &sdev->sdev_gendev);
 }
 
 static void ata_acpi_unregister_power_resource(struct ata_device *dev)
 {
 	struct scsi_device *sdev = dev->sdev;
 	acpi_handle handle;
-	struct device *device;
 
 	handle = ata_dev_acpi_handle(dev);
-	if (!handle)
-		return;
-
-	device = &sdev->sdev_gendev;
-
-	acpi_power_resource_unregister_device(device, handle);
+	if (handle)
+		acpi_dev_pm_remove_dependent(handle, &sdev->sdev_gendev);
 }
 
 void ata_acpi_bind(struct ata_device *dev)
Index: linux/drivers/acpi/device_pm.c
===================================================================
--- linux.orig/drivers/acpi/device_pm.c
+++ linux/drivers/acpi/device_pm.c
@@ -665,3 +665,59 @@ void acpi_dev_pm_detach(struct device *d
 	}
 }
 EXPORT_SYMBOL_GPL(acpi_dev_pm_detach);
+
+/**
+ * acpi_dev_pm_add_dependent - Add physical device depending for PM.
+ * @handle: Handle of ACPI device node.
+ * @depdev: Device depending on that node for PM.
+ */
+void acpi_dev_pm_add_dependent(acpi_handle handle, struct device *depdev)
+{
+	struct acpi_device_physical_node *dep;
+	struct acpi_device *adev;
+
+	if (!depdev || acpi_bus_get_device(handle, &adev))
+		return;
+
+	mutex_lock(&adev->physical_node_lock);
+
+	list_for_each_entry(dep, &adev->power_dependent, node)
+		if (dep->dev == depdev)
+			goto out;
+
+	dep = kzalloc(sizeof(*dep), GFP_KERNEL);
+	if (dep) {
+		dep->dev = depdev;
+		list_add_tail(&dep->node, &adev->power_dependent);
+	}
+
+ out:
+	mutex_unlock(&adev->physical_node_lock);
+}
+EXPORT_SYMBOL_GPL(acpi_dev_pm_add_dependent);
+
+/**
+ * acpi_dev_pm_remove_dependent - Remove physical device depending for PM.
+ * @handle: Handle of ACPI device node.
+ * @depdev: Device depending on that node for PM.
+ */
+void acpi_dev_pm_remove_dependent(acpi_handle handle, struct device *depdev)
+{
+	struct acpi_device_physical_node *dep;
+	struct acpi_device *adev;
+
+	if (!depdev || acpi_bus_get_device(handle, &adev))
+		return;
+
+	mutex_lock(&adev->physical_node_lock);
+
+	list_for_each_entry(dep, &adev->power_dependent, node)
+		if (dep->dev == depdev) {
+			list_del(&dep->node);
+			kfree(dep);
+			break;
+		}
+
+	mutex_unlock(&adev->physical_node_lock);
+}
+EXPORT_SYMBOL_GPL(acpi_dev_pm_remove_dependent);
Index: linux/include/linux/acpi.h
===================================================================
--- linux.orig/include/linux/acpi.h
+++ linux/include/linux/acpi.h
@@ -529,6 +529,8 @@ static inline int acpi_subsys_resume_ear
 struct acpi_device *acpi_dev_pm_get_node(struct device *dev);
 int acpi_dev_pm_attach(struct device *dev, bool power_on);
 void acpi_dev_pm_detach(struct device *dev, bool power_off);
+void acpi_dev_pm_add_dependent(acpi_handle handle, struct device *depdev);
+void acpi_dev_pm_remove_dependent(acpi_handle handle, struct device *depdev);
 #else
 static inline struct acpi_device *acpi_dev_pm_get_node(struct device *dev)
 {
@@ -539,6 +541,10 @@ static inline int acpi_dev_pm_attach(str
 	return -ENODEV;
 }
 static inline void acpi_dev_pm_detach(struct device *dev, bool power_off) {}
+static inline void acpi_dev_pm_add_dependent(acpi_handle handle,
+					     struct device *depdev) {}
+static inline void acpi_dev_pm_remove_dependent(acpi_handle handle,
+						struct device *depdev) {}
 #endif
 
 #ifdef CONFIG_ACPI

