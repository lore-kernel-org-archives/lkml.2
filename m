Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0GUXkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 19:40:51 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34692 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759081Ab0GUXkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 19:40:05 -0400
Subject: [PATCH 2/5] of: Merge of_platform_bus_type with platform_bus_type
To: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Jul 2010 17:40:00 -0600
Message-ID: <20100721233959.7782.17711.stgit@angua>
In-Reply-To: <20100721232817.7782.23410.stgit@angua>
References: <20100721232817.7782.23410.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_platform_bus was being used in the same manner as the platform_bus.
The only difference being that of_platform_bus devices are generated
from data in the device tree, and platform_bus devices are usually
statically allocated in platform code.  Having them separate causes
the problem of device drivers having to be registered twice if it
was possible for the same device to appear on either bus.

This patch removes of_platform_bus_type and registers all of_platform
bus devices and drivers on the platform bus instead.  A previous patch
made the of_device structure an alias for the platform_device structure,
and a shim is used to adapt of_platform_drivers to the platform bus.

After all of of_platform_bus drivers are converted to be normal platform
drivers, the shim code can be removed.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/microblaze/kernel/of_platform.c     |   11 -----
 arch/microblaze/kernel/setup.c           |    6 ---
 arch/powerpc/kernel/dma-swiotlb.c        |    8 ----
 arch/powerpc/kernel/of_platform.c        |   12 -----
 arch/powerpc/kernel/setup-common.c       |    7 ---
 arch/powerpc/platforms/cell/beat_iommu.c |    2 -
 arch/powerpc/platforms/cell/iommu.c      |    2 -
 arch/powerpc/sysdev/mv64x60_dev.c        |    7 ---
 arch/sparc/kernel/of_device_32.c         |   21 ++-------
 arch/sparc/kernel/of_device_64.c         |   21 ++-------
 arch/sparc/kernel/of_device_common.c     |    3 -
 drivers/base/platform.c                  |    6 +++
 drivers/of/device.c                      |    5 ++
 drivers/of/platform.c                    |   67 +++++++++++++++++++++++++++++-
 include/linux/of_device.h                |    6 +++
 include/linux/of_platform.h              |   21 ++++-----
 16 files changed, 102 insertions(+), 103 deletions(-)

diff --git a/arch/microblaze/kernel/of_platform.c b/arch/microblaze/kernel/of_platform.c
index da79edf..fb28661 100644
--- a/arch/microblaze/kernel/of_platform.c
+++ b/arch/microblaze/kernel/of_platform.c
@@ -26,17 +26,6 @@
 #include <linux/topology.h>
 #include <asm/atomic.h>
 
-struct bus_type of_platform_bus_type = {
-       .uevent	= of_device_uevent,
-};
-EXPORT_SYMBOL(of_platform_bus_type);
-
-static int __init of_bus_driver_init(void)
-{
-	return of_bus_type_init(&of_platform_bus_type, "of_platform");
-}
-postcore_initcall(of_bus_driver_init);
-
 /*
  * The list of OF IDs below is used for matching bus types in the
  * system whose devices are to be exposed as of_platform_devices.
diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
index 17c98db..f5f7688 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -213,15 +213,9 @@ static struct notifier_block dflt_plat_bus_notifier = {
 	.priority = INT_MAX,
 };
 
-static struct notifier_block dflt_of_bus_notifier = {
-	.notifier_call = dflt_bus_notify,
-	.priority = INT_MAX,
-};
-
 static int __init setup_bus_notifier(void)
 {
 	bus_register_notifier(&platform_bus_type, &dflt_plat_bus_notifier);
-	bus_register_notifier(&of_platform_bus_type, &dflt_of_bus_notifier);
 
 	return 0;
 }
diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
index e7fe218..c9fffd4 100644
--- a/arch/powerpc/kernel/dma-swiotlb.c
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -82,17 +82,9 @@ static struct notifier_block ppc_swiotlb_plat_bus_notifier = {
 	.priority = 0,
 };
 
-static struct notifier_block ppc_swiotlb_of_bus_notifier = {
-	.notifier_call = ppc_swiotlb_bus_notify,
-	.priority = 0,
-};
-
 int __init swiotlb_setup_bus_notifier(void)
 {
 	bus_register_notifier(&platform_bus_type,
 			      &ppc_swiotlb_plat_bus_notifier);
-	bus_register_notifier(&of_platform_bus_type,
-			      &ppc_swiotlb_of_bus_notifier);
-
 	return 0;
 }
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index 4e0a2f7..d3497cd 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -52,18 +52,6 @@ const struct of_device_id of_default_bus_ids[] = {
 	{},
 };
 
-struct bus_type of_platform_bus_type = {
-       .uevent	= of_device_uevent,
-};
-EXPORT_SYMBOL(of_platform_bus_type);
-
-static int __init of_bus_driver_init(void)
-{
-	return of_bus_type_init(&of_platform_bus_type, "of_platform");
-}
-
-postcore_initcall(of_bus_driver_init);
-
 static int of_dev_node_match(struct device *dev, void *data)
 {
 	return to_of_device(dev)->dev.of_node == data;
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 5e4d852..ba6fc87 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -701,16 +701,9 @@ static struct notifier_block ppc_dflt_plat_bus_notifier = {
 	.priority = INT_MAX,
 };
 
-static struct notifier_block ppc_dflt_of_bus_notifier = {
-	.notifier_call = ppc_dflt_bus_notify,
-	.priority = INT_MAX,
-};
-
 static int __init setup_bus_notifier(void)
 {
 	bus_register_notifier(&platform_bus_type, &ppc_dflt_plat_bus_notifier);
-	bus_register_notifier(&of_platform_bus_type, &ppc_dflt_of_bus_notifier);
-
 	return 0;
 }
 
diff --git a/arch/powerpc/platforms/cell/beat_iommu.c b/arch/powerpc/platforms/cell/beat_iommu.c
index 39d361c..beec405 100644
--- a/arch/powerpc/platforms/cell/beat_iommu.c
+++ b/arch/powerpc/platforms/cell/beat_iommu.c
@@ -108,7 +108,7 @@ static int __init celleb_init_iommu(void)
 	celleb_init_direct_mapping();
 	set_pci_dma_ops(&dma_direct_ops);
 	ppc_md.pci_dma_dev_setup = celleb_pci_dma_dev_setup;
-	bus_register_notifier(&of_platform_bus_type, &celleb_of_bus_notifier);
+	bus_register_notifier(&platform_bus_type, &celleb_of_bus_notifier);
 
 	return 0;
 }
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index 4326b73..eb474df 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -1204,7 +1204,7 @@ static int __init cell_iommu_init(void)
 	/* Register callbacks on OF platform device addition/removal
 	 * to handle linking them to the right DMA operations
 	 */
-	bus_register_notifier(&of_platform_bus_type, &cell_of_bus_notifier);
+	bus_register_notifier(&platform_bus_type, &cell_of_bus_notifier);
 
 	return 0;
 }
diff --git a/arch/powerpc/sysdev/mv64x60_dev.c b/arch/powerpc/sysdev/mv64x60_dev.c
index 31acd3b..1398bc4 100644
--- a/arch/powerpc/sysdev/mv64x60_dev.c
+++ b/arch/powerpc/sysdev/mv64x60_dev.c
@@ -20,12 +20,7 @@
 
 #include <asm/prom.h>
 
-/*
- * These functions provide the necessary setup for the mv64x60 drivers.
- * These drivers are unusual in that they work on both the MIPS and PowerPC
- * architectures.  Because of that, the drivers do not support the normal
- * PowerPC of_platform_bus_type.  They support platform_bus_type instead.
- */
+/* These functions provide the necessary setup for the mv64x60 drivers. */
 
 static struct of_device_id __initdata of_mv64x60_devices[] = {
 	{ .compatible = "marvell,mv64306-devctrl", },
diff --git a/arch/sparc/kernel/of_device_32.c b/arch/sparc/kernel/of_device_32.c
index 331de91..75fc9d5 100644
--- a/arch/sparc/kernel/of_device_32.c
+++ b/arch/sparc/kernel/of_device_32.c
@@ -424,7 +424,7 @@ build_resources:
 	build_device_resources(op, parent);
 
 	op->dev.parent = parent;
-	op->dev.bus = &of_platform_bus_type;
+	op->dev.bus = &platform_bus_type;
 	if (!parent)
 		dev_set_name(&op->dev, "root");
 	else
@@ -452,30 +452,19 @@ static void __init scan_tree(struct device_node *dp, struct device *parent)
 	}
 }
 
-static void __init scan_of_devices(void)
+static int __init scan_of_devices(void)
 {
 	struct device_node *root = of_find_node_by_path("/");
 	struct of_device *parent;
 
 	parent = scan_one_device(root, NULL);
 	if (!parent)
-		return;
+		return 0;
 
 	scan_tree(root->child, &parent->dev);
+	return 0;
 }
-
-static int __init of_bus_driver_init(void)
-{
-	int err;
-
-	err = of_bus_type_init(&of_platform_bus_type, "of");
-	if (!err)
-		scan_of_devices();
-
-	return err;
-}
-
-postcore_initcall(of_bus_driver_init);
+postcore_initcall(scan_of_devices);
 
 static int __init of_debug(char *str)
 {
diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
index 5e8cbb9..9743d1d 100644
--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -667,7 +667,7 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 		op->archdata.irqs[i] = build_one_device_irq(op, parent, op->archdata.irqs[i]);
 
 	op->dev.parent = parent;
-	op->dev.bus = &of_platform_bus_type;
+	op->dev.bus = &platform_bus_type;
 	if (!parent)
 		dev_set_name(&op->dev, "root");
 	else
@@ -695,30 +695,19 @@ static void __init scan_tree(struct device_node *dp, struct device *parent)
 	}
 }
 
-static void __init scan_of_devices(void)
+static int __init scan_of_devices(void)
 {
 	struct device_node *root = of_find_node_by_path("/");
 	struct of_device *parent;
 
 	parent = scan_one_device(root, NULL);
 	if (!parent)
-		return;
+		return 0;
 
 	scan_tree(root->child, &parent->dev);
+	return 0;
 }
-
-static int __init of_bus_driver_init(void)
-{
-	int err;
-
-	err = of_bus_type_init(&of_platform_bus_type, "of");
-	if (!err)
-		scan_of_devices();
-
-	return err;
-}
-
-postcore_initcall(of_bus_driver_init);
+postcore_initcall(scan_of_devices);
 
 static int __init of_debug(char *str)
 {
diff --git a/arch/sparc/kernel/of_device_common.c b/arch/sparc/kernel/of_device_common.c
index 016c947..01f380c 100644
--- a/arch/sparc/kernel/of_device_common.c
+++ b/arch/sparc/kernel/of_device_common.c
@@ -64,9 +64,6 @@ void of_propagate_archdata(struct of_device *bus)
 	}
 }
 
-struct bus_type of_platform_bus_type;
-EXPORT_SYMBOL(of_platform_bus_type);
-
 static void get_cells(struct device_node *dp, int *addrc, int *sizec)
 {
 	if (addrc)
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 6a9b3dd..ec22578 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -636,6 +636,12 @@ static struct device_attribute platform_dev_attrs[] = {
 static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct platform_device	*pdev = to_platform_device(dev);
+	int rc;
+
+	/* Some devices have extra OF data and an OF-style MODALIAS */
+	rc = of_device_uevent(dev,env);
+	if (rc != -ENODEV)
+		return rc;
 
 	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
 		(pdev->id_entry) ? pdev->id_entry->name : pdev->name);
diff --git a/drivers/of/device.c b/drivers/of/device.c
index 5282a20..12a44b4 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -104,6 +104,11 @@ int of_device_register(struct of_device *ofdev)
 
 	device_initialize(&ofdev->dev);
 
+	/* name and id have to be set so that the platform bus doesn't get
+	 * confused on matching */
+	ofdev->name = dev_name(&ofdev->dev);
+	ofdev->id = -1;
+
 	/* device_add will assume that this device is on the same node as
 	 * the parent. If there is no parent defined, set the node
 	 * explicitly */
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 9d3d932..712dfd8 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -20,6 +20,54 @@
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+static int platform_driver_probe_shim(struct platform_device *pdev)
+{
+	struct platform_driver *pdrv;
+	struct of_platform_driver *ofpdrv;
+	const struct of_device_id *match;
+
+	pdrv = container_of(pdev->dev.driver, struct platform_driver, driver);
+	ofpdrv = container_of(pdrv, struct of_platform_driver, platform_driver);
+	match = of_match_device(pdev->dev.driver->of_match_table, &pdev->dev);
+	return ofpdrv->probe(pdev, match);
+}
+
+static void platform_driver_shutdown_shim(struct platform_device *pdev)
+{
+	struct platform_driver *pdrv;
+	struct of_platform_driver *ofpdrv;
+
+	pdrv = container_of(pdev->dev.driver, struct platform_driver, driver);
+	ofpdrv = container_of(pdrv, struct of_platform_driver, platform_driver);
+	ofpdrv->shutdown(pdev);
+}
+
+/**
+ * of_register_platform_driver
+ */
+int of_register_platform_driver(struct of_platform_driver *drv)
+{
+	/* setup of_platform_driver to platform_driver adaptors */
+	drv->platform_driver.driver = drv->driver;
+	if (drv->probe)
+		drv->platform_driver.probe = platform_driver_probe_shim;
+	drv->platform_driver.remove = drv->remove;
+	if (drv->shutdown)
+		drv->platform_driver.shutdown = platform_driver_shutdown_shim;
+	drv->platform_driver.suspend = drv->suspend;
+	drv->platform_driver.resume = drv->resume;
+
+	return platform_driver_register(&drv->platform_driver);
+}
+EXPORT_SYMBOL(of_register_platform_driver);
+
+void of_unregister_platform_driver(struct of_platform_driver *drv)
+{
+	platform_driver_unregister(&drv->platform_driver);
+}
+EXPORT_SYMBOL(of_unregister_platform_driver);
 
 #if defined(CONFIG_PPC_DCR)
 #include <asm/dcr.h>
@@ -392,16 +440,29 @@ int of_bus_type_init(struct bus_type *bus, const char *name)
 
 int of_register_driver(struct of_platform_driver *drv, struct bus_type *bus)
 {
-	drv->driver.bus = bus;
+	/*
+	 * Temporary: of_platform_bus used to be distinct from the platform
+	 * bus.  It isn't anymore, and so drivers on the platform bus need
+	 * to be registered in a special way.
+	 *
+	 * After all of_platform_bus_type drivers are converted to
+	 * platform_drivers, this exception can be removed.
+	 */
+	if (bus == &platform_bus_type)
+		return of_register_platform_driver(drv);
 
 	/* register with core */
+	drv->driver.bus = bus;
 	return driver_register(&drv->driver);
 }
 EXPORT_SYMBOL(of_register_driver);
 
 void of_unregister_driver(struct of_platform_driver *drv)
 {
-	driver_unregister(&drv->driver);
+	if (drv->driver.bus == &platform_bus_type)
+		of_unregister_platform_driver(drv);
+	else
+		driver_unregister(&drv->driver);
 }
 EXPORT_SYMBOL(of_unregister_driver);
 
@@ -548,7 +609,7 @@ struct of_device *of_platform_device_create(struct device_node *np,
 	dev->archdata.dma_mask = 0xffffffffUL;
 #endif
 	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	dev->dev.bus = &of_platform_bus_type;
+	dev->dev.bus = &platform_bus_type;
 
 	/* We do not fill the DMA ops for platform devices by default.
 	 * This is currently the responsibility of the platform code
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index 7d27f5a..8cd1fe7 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -65,6 +65,12 @@ static inline int of_driver_match_device(struct device *dev,
 	return 0;
 }
 
+static inline int of_device_uevent(struct device *dev,
+				   struct kobj_uevent_env *env)
+{
+	return -ENODEV;
+}
+
 #endif /* CONFIG_OF_DEVICE */
 
 #endif /* _LINUX_OF_DEVICE_H */
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index a51fd30..133ecf3 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -17,19 +17,19 @@
 #include <linux/mod_devicetable.h>
 #include <linux/pm.h>
 #include <linux/of_device.h>
+#include <linux/platform_device.h>
 
 /*
- * The of_platform_bus_type is a bus type used by drivers that do not
- * attach to a macio or similar bus but still use OF probing
- * mechanism
+ * of_platform_bus_type isn't it's own bus anymore.  It's now just an alias
+ * for the platform bus.
  */
-extern struct bus_type of_platform_bus_type;
+#define of_platform_bus_type platform_bus_type
 
 extern const struct of_device_id of_default_bus_ids[];
 
 /*
  * An of_platform_driver driver is attached to a basic of_device on
- * the "platform bus" (of_platform_bus_type).
+ * the "platform bus" (platform_bus_type).
  */
 struct of_platform_driver
 {
@@ -42,6 +42,7 @@ struct of_platform_driver
 	int	(*shutdown)(struct of_device* dev);
 
 	struct device_driver	driver;
+	struct platform_driver	platform_driver;
 };
 #define	to_of_platform_driver(drv) \
 	container_of(drv,struct of_platform_driver, driver)
@@ -51,14 +52,8 @@ extern int of_register_driver(struct of_platform_driver *drv,
 extern void of_unregister_driver(struct of_platform_driver *drv);
 
 /* Platform drivers register/unregister */
-static inline int of_register_platform_driver(struct of_platform_driver *drv)
-{
-	return of_register_driver(drv, &of_platform_bus_type);
-}
-static inline void of_unregister_platform_driver(struct of_platform_driver *drv)
-{
-	of_unregister_driver(drv);
-}
+extern int of_register_platform_driver(struct of_platform_driver *drv);
+extern void of_unregister_platform_driver(struct of_platform_driver *drv);
 
 extern struct of_device *of_device_alloc(struct device_node *np,
 					 const char *bus_id,

