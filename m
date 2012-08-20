Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab2HTPbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:31:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53991 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab2HTPb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:31:28 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <mjg59@srcf.ucam.org>, David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andreas Heider <andreas@meetr.de>
Subject: [RFC PATCH 7/7] drm/pci: Defer initialization of secondary graphics devices until switcheroo is ready
Date: Mon, 20 Aug 2012 10:31:04 -0500
Message-Id: <1345476664-22066-8-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345476664-22066-1-git-send-email-seth.forshee@canonical.com>
References: <20120806045150.GA23652@thinkpad-t410>
 <1345476664-22066-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deferring initiailzation of the secondary GPU until switcheroo is ready
will allow successfully reading the EDID in systems which support muxing
the DDC seperately from the display.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/drm/drm_drv.c |    3 +
 drivers/gpu/drm/drm_pci.c |  141 +++++++++++++++++++++++++++++++++++++++------
 include/drm/drmP.h        |    2 +
 3 files changed, 129 insertions(+), 17 deletions(-)

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
index 4896c96..9da0cd2 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -40,6 +40,9 @@
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
+#include <linux/notifier.h>
+#include <linux/vgaarb.h>
+#include <linux/vga_switcheroo.h>
 #include "drmP.h"
 
 /**********************************************************************/
@@ -297,19 +300,8 @@ static struct drm_bus drm_pci_bus = {
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
@@ -334,8 +326,6 @@ int drm_get_pci_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
 	dev->hose = pdev->sysdata;
 #endif
 
-	mutex_lock(&drm_global_mutex);
-
 	if ((ret = drm_fill_in_dev(dev, ent, driver))) {
 		printk(KERN_ERR "DRM: Fill_in_dev failed.\n");
 		goto err_g2;
@@ -371,7 +361,6 @@ int drm_get_pci_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
 		 driver->name, driver->major, driver->minor, driver->patchlevel,
 		 driver->date, pci_name(pdev), dev->primary->index);
 
-	mutex_unlock(&drm_global_mutex);
 	return 0;
 
 err_g4:
@@ -386,10 +375,116 @@ err_g1:
 	mutex_unlock(&drm_global_mutex);
 	return ret;
 }
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
+static void drm_deferred_init_work_fn(struct work_struct *work)
+{
+	struct deferred_init_data *di_data, *temp;
+
+	mutex_lock(&drm_global_mutex);
+
+	if (!vga_switcheroo_handler_registered() ||
+	    !vga_switcheroo_get_active_client()) {
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
+static struct notifier_block drm_switcheroo_notifier = {
+	.notifier_call = drm_switcheroo_notifier_fn,
+};
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
+	 * For secondary graphics devices shouldn't be initialized
+	 * until the handler and primary graphics device have been
+	 * registered with vga_switcheroo.
+	 *
+	 * FIXME: Is vga_default_device() reliable enough for this
+	 * purpose?
+	 *
+	 * FIXME: If vga_switcheroo is disabled secondary devices
+	 * never gets initialized. Is this okay? Maybe it is, since
+	 * we can't switch to the secondary GPU anyway.
+	 */
+	if (vga_default_device() == pdev ||
+	    (vga_switcheroo_handler_registered() &&
+	     vga_switcheroo_get_active_client())) {
+		ret = __drm_get_pci_dev(pdev, ent, driver);
+	} else {
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
+	}
+
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
@@ -466,7 +561,7 @@ void drm_pci_exit(struct drm_driver *driver, struct pci_driver *pdriver)
 		pci_unregister_driver(pdriver);
 	} else {
 		list_for_each_entry_safe(dev, tmp, &driver->device_list, driver_item)
-			drm_put_dev(dev);
+			drm_put_pci_dev(dev);
 	}
 	DRM_INFO("Module unloaded\n");
 }
@@ -520,3 +615,15 @@ int drm_pcie_get_speed_cap_mask(struct drm_device *dev, u32 *mask)
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

