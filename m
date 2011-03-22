Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab1CVCYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 22:24:03 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:33932 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299Ab1CVCYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 22:24:00 -0400
Date: Mon, 21 Mar 2011 19:19:35 -0700
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: dsd@laptop.org, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] mfd-core: add mfd_clone_cell(), convert cs5535-mfd/olpc-xo1
 to it
Message-ID: <20110321191935.7ddf0a70@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replace mfd_shared_platform_driver_register with mfd_clone_cell.  The
former was called by an mfd client, and registered both a platform driver
and device.  The latter is called by an mfd driver, and registers only a
platform device.

The downside of this is that mfd drivers need to be modified whenever
new clients are added that share a cell; the upside is that it fits
Linux's driver model better.  It's also simpler.

This also converts cs5535-mfd/olpc-xo1 from the old API.  cs5535-mfd
now creates the olpc-xo1-{acpi,pms} devices, while olpc-xo1 binds to
them via platform drivers.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/platform/olpc/olpc-xo1.c |   11 +++----
 drivers/mfd/cs5535-mfd.c          |   18 ++++++++++++
 drivers/mfd/mfd-core.c            |   53 +++++++-----------------------------
 include/linux/mfd/core.h          |   27 ++++++++++++------
 4 files changed, 52 insertions(+), 57 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo1.c b/arch/x86/platform/olpc/olpc-xo1.c
index 9951364..386e3a1 100644
--- a/arch/x86/platform/olpc/olpc-xo1.c
+++ b/arch/x86/platform/olpc/olpc-xo1.c
@@ -121,22 +121,21 @@ static int __init olpc_xo1_init(void)
 {
 	int r;
 
-	r = mfd_shared_platform_driver_register(&cs5535_pms_drv, "cs5535-pms");
+	r = platform_driver_register(&cs5535_pms_drv);
 	if (r)
 		return r;
 
-	r = mfd_shared_platform_driver_register(&cs5535_acpi_drv,
-			"cs5535-acpi");
+	r = platform_driver_register(&cs5535_acpi_drv);
 	if (r)
-		mfd_shared_platform_driver_unregister(&cs5535_pms_drv);
+		platform_driver_unregister(&cs5535_pms_drv);
 
 	return r;
 }
 
 static void __exit olpc_xo1_exit(void)
 {
-	mfd_shared_platform_driver_unregister(&cs5535_acpi_drv);
-	mfd_shared_platform_driver_unregister(&cs5535_pms_drv);
+	platform_driver_unregister(&cs5535_acpi_drv);
+	platform_driver_unregister(&cs5535_pms_drv);
 }
 
 MODULE_AUTHOR("Daniel Drake <dsd@laptop.org>");
diff --git a/drivers/mfd/cs5535-mfd.c b/drivers/mfd/cs5535-mfd.c
index 886a068..24959dd 100644
--- a/drivers/mfd/cs5535-mfd.c
+++ b/drivers/mfd/cs5535-mfd.c
@@ -27,6 +27,7 @@
 #include <linux/mfd/core.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <asm/olpc.h>
 
 #define DRV_NAME "cs5535-mfd"
 
@@ -111,6 +112,22 @@ static __devinitdata struct mfd_cell cs5535_mfd_cells[] = {
 	},
 };
 
+#ifdef CONFIG_OLPC
+static void __devinit cs5535_clone_olpc_cells(void)
+{
+	const char *acpi_clones[] = { "olpc-xo1-acpi" };
+	const char *pms_clones[] = { "olpc-xo1-pms" };
+
+	if (!machine_is_olpc())
+		return;
+
+	mfd_clone_cell("cs5535-acpi", acpi_clones, ARRAY_SIZE(acpi_clones));
+	mfd_clone_cell("cs5535-pms", pms_clones, ARRAY_SIZE(pms_clones));
+}
+#else
+static void cs5535_clone_olpc_cells(void) { }
+#endif
+
 static int __devinit cs5535_mfd_probe(struct pci_dev *pdev,
 		const struct pci_device_id *id)
 {
@@ -139,6 +156,7 @@ static int __devinit cs5535_mfd_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "MFD add devices failed: %d\n", err);
 		goto err_disable;
 	}
+	cs5535_clone_olpc_cells();
 
 	dev_info(&pdev->dev, "%zu devices registered.\n",
 			ARRAY_SIZE(cs5535_mfd_cells));
diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 79eda02..d01574d 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -184,16 +184,12 @@ void mfd_remove_devices(struct device *parent)
 }
 EXPORT_SYMBOL(mfd_remove_devices);
 
-static int add_shared_platform_device(const char *cell, const char *name)
+int mfd_clone_cell(const char *cell, const char **clones, size_t n_clones)
 {
 	struct mfd_cell cell_entry;
 	struct device *dev;
 	struct platform_device *pdev;
-	int err;
-
-	/* check if we've already registered a device (don't fail if we have) */
-	if (bus_find_device_by_name(&platform_bus_type, NULL, name))
-		return 0;
+	int i;
 
 	/* fetch the parent cell's device (should already be registered!) */
 	dev = bus_find_device_by_name(&platform_bus_type, NULL, cell);
@@ -206,44 +202,17 @@ static int add_shared_platform_device(const char *cell, const char *name)
 
 	WARN_ON(!cell_entry.enable);
 
-	cell_entry.name = name;
-	err = mfd_add_device(pdev->dev.parent, -1, &cell_entry, NULL, 0);
-	if (err)
-		dev_err(dev, "MFD add devices failed: %d\n", err);
-	return err;
-}
-
-int mfd_shared_platform_driver_register(struct platform_driver *drv,
-		const char *cellname)
-{
-	int err;
-
-	err = add_shared_platform_device(cellname, drv->driver.name);
-	if (err)
-		printk(KERN_ERR "failed to add platform device %s\n",
-				drv->driver.name);
-
-	err = platform_driver_register(drv);
-	if (err)
-		printk(KERN_ERR "failed to add platform driver %s\n",
-				drv->driver.name);
-
-	return err;
-}
-EXPORT_SYMBOL(mfd_shared_platform_driver_register);
-
-void mfd_shared_platform_driver_unregister(struct platform_driver *drv)
-{
-	struct device *dev;
-
-	dev = bus_find_device_by_name(&platform_bus_type, NULL,
-			drv->driver.name);
-	if (dev)
-		platform_device_unregister(to_platform_device(dev));
+	for (i = 0; i < n_clones; i++) {
+		cell_entry.name = clones[i];
+		/* don't give up if a single call fails; just report error */
+		if (mfd_add_device(pdev->dev.parent, -1, &cell_entry, NULL, 0))
+			dev_err(dev, "failed to create platform device '%s'\n",
+					clones[i]);
+	}
 
-	platform_driver_unregister(drv);
+	return 0;
 }
-EXPORT_SYMBOL(mfd_shared_platform_driver_unregister);
+EXPORT_SYMBOL(mfd_clone_cell);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ian Molton, Dmitry Baryshkov");
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 1408bf8..ad1b19a 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -63,6 +63,24 @@ extern int mfd_cell_enable(struct platform_device *pdev);
 extern int mfd_cell_disable(struct platform_device *pdev);
 
 /*
+ * "Clone" multiple platform devices for a single cell. This is to be used
+ * for devices that have multiple users of a cell.  For example, if an mfd
+ * driver wants the cell "foo" to be used by a GPIO driver, an MTD driver,
+ * and a platform driver, the following bit of code would be use after first
+ * calling mfd_add_devices():
+ *
+ * const char *fclones[] = { "foo-gpio", "foo-mtd" };
+ * err = mfd_clone_cells("foo", fclones, ARRAY_SIZE(fclones));
+ *
+ * Each driver (MTD, GPIO, and platform driver) would then register
+ * platform_drivers for "foo-mtd", "foo-gpio", and "foo", respectively.
+ * The cell's .enable/.disable hooks should be used to deal with hardware
+ * resource contention.
+ */
+extern int mfd_clone_cell(const char *cell, const char **clones,
+		size_t n_clones);
+
+/*
  * Given a platform device that's been created by mfd_add_devices(), fetch
  * the mfd_cell that created it.
  */
@@ -87,13 +105,4 @@ extern int mfd_add_devices(struct device *parent, int id,
 
 extern void mfd_remove_devices(struct device *parent);
 
-/*
- * For MFD drivers with clients sharing access to resources, these create
- * multiple platform devices per cell.  Contention handling must still be
- * handled via drivers (ie, with enable/disable hooks).
- */
-extern int mfd_shared_platform_driver_register(struct platform_driver *drv,
-		const char *cellname);
-extern void mfd_shared_platform_driver_unregister(struct platform_driver *drv);
-
 #endif
-- 
1.7.2.5

