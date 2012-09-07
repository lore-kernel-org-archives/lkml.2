Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2IGPWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:22:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50066 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab2IGPWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:22:33 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 7/7] drm/pci: Defer initialization of secondary graphics devices until switcheroo is ready
Date: Fri,  7 Sep 2012 10:22:10 -0500
Message-Id: <1347031330-19657-8-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347031330-19657-1-git-send-email-seth.forshee@canonical.com>
References: <1347031330-19657-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many Apple laptops with hybrid graphics require switching the i2c mux to
the integrated GPU when that device is being initialized in order to get
correct mode information for the LVDS panel. This requires that switcheroo
is ready at the time the device is initialized, which is not guaranteed.

To support this, delay calling the driver load() callback until the
vga_switcheroo handler and active client have been registered. This is
restricted to Apple notebooks via DMI data to avoid causing problems on
machines without switcheroo support.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/drm/drm_drv.c |    3 +
 drivers/gpu/drm/drm_pci.c |  164 ++++++++++++++++++++++++++++++++++++++++-----
 include/drm/drmP.h        |    2 +
 3 files changed, 153 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 9238de4..124fd8a 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -276,6 +276,8 @@ static int __init drm_core_init(void)
 		goto err_p3;
 	}
 
+	drm_pci_module_init();
+
 	DRM_INFO("Initialized %s %d.%d.%d %s\n",
 		 CORE_NAME, CORE_MAJOR, CORE_MINOR, CORE_PATCHLEVEL, CORE_DATE);
 	return 0;
@@ -291,6 +293,7 @@ err_p1:
 
 static void __exit drm_core_exit(void)
 {
+	drm_pci_module_exit();
 	remove_proc_entry("dri", NULL);
 	debugfs_remove(drm_debugfs_root);
 	drm_sysfs_destroy();
diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index 55eb824..a5c9068 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -40,6 +40,10 @@
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
+#include <linux/dmi.h>
+#include <linux/notifier.h>
+#include <linux/vgaarb.h>
+#include <linux/vga_switcheroo.h>
 #include "drmP.h"
 
 /**********************************************************************/
@@ -297,19 +301,8 @@ static struct drm_bus drm_pci_bus = {
 	.agp_init = drm_pci_agp_init,
 };
 
-/**
- * Register.
- *
- * \param pdev - PCI device structure
- * \param ent entry from the PCI ID table with device type flags
- * \return zero on success or a negative number on failure.
- *
- * Attempt to gets inter module "drm" information. If we are first
- * then register the character device and inter module information.
- * Try and register, if we fail to register, backout previous work.
- */
-int drm_get_pci_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
-		    struct drm_driver *driver)
+int __drm_get_pci_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
+		      struct drm_driver *driver)
 {
 	struct drm_device *dev;
 	int ret;
@@ -334,8 +327,6 @@ int drm_get_pci_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
 	dev->hose = pdev->sysdata;
 #endif
 
-	mutex_lock(&drm_global_mutex);
-
 	if ((ret = drm_fill_in_dev(dev, ent, driver))) {
 		printk(KERN_ERR "DRM: Fill_in_dev failed.\n");
 		goto err_g2;
@@ -371,7 +362,6 @@ int drm_get_pci_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
 		 driver->name, driver->major, driver->minor, driver->patchlevel,
 		 driver->date, pci_name(pdev), dev->primary->index);
 
-	mutex_unlock(&drm_global_mutex);
 	return 0;
 
 err_g4:
@@ -386,10 +376,140 @@ err_g1:
 	mutex_unlock(&drm_global_mutex);
 	return ret;
 }
+
+/*
+ * List of machines that require delaying initialization of the secondary
+ * GPU until vga_switcheroo is ready.
+ */
+static struct dmi_system_id deferred_init_dmi_table[] = {
+	{
+		.ident = "Apple Laptop",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "10"), /* Notebook */
+		},
+	},
+};
+
+struct deferred_init_data {
+	struct list_head list;
+	struct pci_dev *pdev;
+	const struct pci_device_id *ent;
+	struct drm_driver *driver;
+};
+
+static LIST_HEAD(deferred_init_list);
+
+static bool drm_pci_switcheroo_ready(void)
+{
+	if (!vga_switcheroo_handler_registered())
+		return false;
+	if (!vga_switcheroo_get_active_client())
+		return false;
+	return true;
+}
+
+static void drm_deferred_init_work_fn(struct work_struct *work)
+{
+	struct deferred_init_data *di_data, *temp;
+
+	mutex_lock(&drm_global_mutex);
+
+	if (!drm_pci_switcheroo_ready()) {
+		mutex_unlock(&drm_global_mutex);
+		return;
+	}
+
+	list_for_each_entry_safe(di_data, temp, &deferred_init_list, list) {
+		if (__drm_get_pci_dev(di_data->pdev, di_data->ent,
+				      di_data->driver))
+			DRM_ERROR("pci device initialization failed\n");
+		list_del(&di_data->list);
+		kfree(di_data);
+	}
+	mutex_unlock(&drm_global_mutex);
+}
+static DECLARE_WORK(deferred_init_work, drm_deferred_init_work_fn);
+
+static int drm_switcheroo_notifier_fn(struct notifier_block *nb,
+				      unsigned long val, void *unused)
+{
+	if (val == VGA_SWITCHEROO_CLIENT_REGISTERED ||
+	    val == VGA_SWITCHEROO_HANDLER_REGISTERED)
+		queue_work(system_nrt_wq, &deferred_init_work);
+	return NOTIFY_OK;
+}
+
+static struct notifier_block drm_switcheroo_notifier = {
+	.notifier_call = drm_switcheroo_notifier_fn,
+};
+
+static bool drm_pci_needs_deferred_init(struct pci_dev *pdev)
+{
+	if (!dmi_check_system(deferred_init_dmi_table))
+		return false;
+	if (vga_default_device() == pdev)
+		return false;
+	return !drm_pci_switcheroo_ready();
+}
+
+/**
+ * Register.
+ *
+ * \param pdev - PCI device structure
+ * \param ent entry from the PCI ID table with device type flags
+ * \return zero on success or a negative number on failure.
+ *
+ * Attempt to gets inter module "drm" information. If we are first
+ * then register the character device and inter module information.
+ * Try and register, if we fail to register, backout previous work.
+ */
+int drm_get_pci_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
+		    struct drm_driver *driver)
+{
+	int ret = 0;
+
+	mutex_lock(&drm_global_mutex);
+
+	/*
+	 * On some machines secondary graphics devices shouldn't be
+	 * initialized until the handler and primary graphics device
+	 * have been registered with vga_switcheroo.
+	 */
+	if (drm_pci_needs_deferred_init(pdev)) {
+		struct deferred_init_data *di_data =
+			kmalloc(sizeof(*di_data), GFP_KERNEL);
+		if (!di_data) {
+			ret = -ENOMEM;
+		} else {
+			di_data->pdev = pdev;
+			di_data->ent = ent;
+			di_data->driver = driver;
+			list_add_tail(&di_data->list, &deferred_init_list);
+		}
+	} else {
+		ret = __drm_get_pci_dev(pdev, ent, driver);
+	}
+
+	mutex_unlock(&drm_global_mutex);
+	return ret;
+}
 EXPORT_SYMBOL(drm_get_pci_dev);
 
 void drm_put_pci_dev(struct drm_device *dev)
 {
+	struct deferred_init_data *di_data;
+
+	mutex_lock(&drm_global_mutex);
+	list_for_each_entry(di_data, &deferred_init_list, list) {
+		if (di_data->pdev == dev->pdev) {
+			list_del(&di_data->list);
+			kfree(di_data);
+			break;
+		}
+	}
+	mutex_unlock(&drm_global_mutex);
+
 	drm_put_dev(dev);
 }
 EXPORT_SYMBOL(drm_put_pci_dev);
@@ -520,3 +640,15 @@ int drm_pcie_get_speed_cap_mask(struct drm_device *dev, u32 *mask)
 	return 0;
 }
 EXPORT_SYMBOL(drm_pcie_get_speed_cap_mask);
+
+int drm_pci_module_init(void)
+{
+	return vga_switcheroo_register_notifier(&drm_switcheroo_notifier);
+}
+EXPORT_SYMBOL(drm_pci_module_init);
+
+void drm_pci_module_exit(void)
+{
+	vga_switcheroo_unregister_notifier(&drm_switcheroo_notifier);
+}
+EXPORT_SYMBOL(drm_pci_module_exit);
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index eb99e96..0e9401f 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1749,6 +1749,8 @@ extern int drm_get_pci_dev(struct pci_dev *pdev,
 			   const struct pci_device_id *ent,
 			   struct drm_driver *driver);
 extern void drm_put_pci_dev(struct drm_device *dev);
+extern int drm_pci_module_init(void);
+extern void drm_pci_module_exit(void);
 
 #define DRM_PCIE_SPEED_25 1
 #define DRM_PCIE_SPEED_50 2
-- 
1.7.9.5

