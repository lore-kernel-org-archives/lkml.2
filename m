Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0CRPXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:23:34 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:59266 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab0CRPWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:22:53 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [V2 PATCH 08/10] arch/powerpc: Remove obsolete dev_archdata.of_node
	and of_devce.node
To: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Date: Thu, 18 Mar 2010 09:22:50 -0600
Message-ID: <20100318152250.21082.35352.stgit@angua>
In-Reply-To: <20100318144836.21082.93040.stgit@angua>
References: <20100318144836.21082.93040.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both dev_archdata.of_node and of_device.node are duplications of the
device.of_node value.  This patch removes them.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 arch/powerpc/include/asm/device.h       |   15 ---------------
 arch/powerpc/include/asm/of_device.h    |    1 -
 arch/powerpc/kernel/of_device.c         |    4 +---
 arch/powerpc/kernel/pci-common.c        |    1 -
 arch/powerpc/kernel/vio.c               |   17 ++++++++---------
 arch/powerpc/platforms/cell/iommu.c     |    5 ++---
 arch/powerpc/platforms/pasemi/setup.c   |    4 ++--
 arch/powerpc/platforms/ps3/system-bus.c |    1 -
 arch/powerpc/platforms/pseries/iommu.c  |    2 +-
 9 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
index 6d94d27..f23f8d8 100644
--- a/arch/powerpc/include/asm/device.h
+++ b/arch/powerpc/include/asm/device.h
@@ -10,9 +10,6 @@ struct dma_map_ops;
 struct device_node;
 
 struct dev_archdata {
-	/* Optional pointer to an OF device node */
-	struct device_node	*of_node;
-
 	/* DMA operations on that device */
 	struct dma_map_ops	*dma_ops;
 
@@ -30,18 +27,6 @@ struct dev_archdata {
 #endif
 };
 
-static inline void dev_archdata_set_node(struct dev_archdata *ad,
-					 struct device_node *np)
-{
-	ad->of_node = np;
-}
-
-static inline struct device_node *
-dev_archdata_get_node(const struct dev_archdata *ad)
-{
-	return ad->of_node;
-}
-
 struct pdev_archdata {
 };
 
diff --git a/arch/powerpc/include/asm/of_device.h b/arch/powerpc/include/asm/of_device.h
index a64debf..8b26f96 100644
--- a/arch/powerpc/include/asm/of_device.h
+++ b/arch/powerpc/include/asm/of_device.h
@@ -12,7 +12,6 @@
  */
 struct of_device
 {
-	struct device_node	*node;		/* to be obsoleted */
 	u64			dma_mask;	/* DMA mask */
 	struct device		dev;		/* Generic device interface */
 };
diff --git a/arch/powerpc/kernel/of_device.c b/arch/powerpc/kernel/of_device.c
index 285c849..20b3474 100644
--- a/arch/powerpc/kernel/of_device.c
+++ b/arch/powerpc/kernel/of_device.c
@@ -69,12 +69,10 @@ struct of_device *of_device_alloc(struct device_node *np,
 	if (!dev)
 		return NULL;
 
-	dev->node = of_node_get(np);
+	dev->dev.of_node = of_node_get(np);
 	dev->dev.dma_mask = &dev->dma_mask;
 	dev->dev.parent = parent;
 	dev->dev.release = of_release_dev;
-	dev->dev.archdata.of_node = np;
-	dev->dev.of_node = np;
 
 	if (bus_id)
 		dev_set_name(&dev->dev, "%s", bus_id);
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 5f9e2c8..ba3bb42 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1112,7 +1112,6 @@ void __devinit pcibios_setup_bus_devices(struct pci_bus *bus)
 			continue;
 
 		/* Setup OF node pointer in the device */
-		sd->of_node = pci_device_to_OF_node(dev);
 		dev->dev.of_node = pci_device_to_OF_node(dev);
 
 		/* Fixup NUMA node as it may not be setup yet by the generic
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 0670843..d4981c6 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -704,7 +704,7 @@ static int vio_cmo_bus_probe(struct vio_dev *viodev)
 	 * Check to see that device has a DMA window and configure
 	 * entitlement for the device.
 	 */
-	if (of_get_property(viodev->dev.archdata.of_node,
+	if (of_get_property(viodev->dev.of_node,
 	                    "ibm,my-dma-window", NULL)) {
 		/* Check that the driver is CMO enabled and get desired DMA */
 		if (!viodrv->get_desired_dma) {
@@ -1048,7 +1048,7 @@ static struct iommu_table *vio_build_iommu_table(struct vio_dev *dev)
 	if (firmware_has_feature(FW_FEATURE_ISERIES))
 		return vio_build_iommu_table_iseries(dev);
 
-	dma_window = of_get_property(dev->dev.archdata.of_node,
+	dma_window = of_get_property(dev->dev.of_node,
 				  "ibm,my-dma-window", NULL);
 	if (!dma_window)
 		return NULL;
@@ -1057,7 +1057,7 @@ static struct iommu_table *vio_build_iommu_table(struct vio_dev *dev)
 	if (tbl == NULL)
 		return NULL;
 
-	of_parse_dma_window(dev->dev.archdata.of_node, dma_window,
+	of_parse_dma_window(dev->dev.of_node, dma_window,
 			    &tbl->it_index, &offset, &size);
 
 	/* TCE table size - measured in tce entries */
@@ -1085,7 +1085,7 @@ static const struct vio_device_id *vio_match_device(
 {
 	while (ids->type[0] != '\0') {
 		if ((strncmp(dev->type, ids->type, strlen(ids->type)) == 0) &&
-		    of_device_is_compatible(dev->dev.archdata.of_node,
+		    of_device_is_compatible(dev->dev.of_node,
 					 ids->compat))
 			return ids;
 		ids++;
@@ -1178,7 +1178,7 @@ EXPORT_SYMBOL(vio_unregister_driver);
 static void __devinit vio_dev_release(struct device *dev)
 {
 	/* XXX should free TCE table */
-	of_node_put(dev->archdata.of_node);
+	of_node_put(dev->of_node);
 	kfree(to_vio_dev(dev));
 }
 
@@ -1230,7 +1230,6 @@ struct vio_dev *vio_register_device_node(struct device_node *of_node)
 			viodev->unit_address = *unit_address;
 	}
 	viodev->dev.of_node = of_node_get(of_node);
-	viodev->dev.archdata.of_node = viodev->dev.of_node;
 
 	if (firmware_has_feature(FW_FEATURE_CMO))
 		vio_cmo_set_dma_ops(viodev);
@@ -1315,7 +1314,7 @@ static ssize_t name_show(struct device *dev,
 static ssize_t devspec_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct device_node *of_node = dev->archdata.of_node;
+	struct device_node *of_node = dev->of_node;
 
 	return sprintf(buf, "%s\n", of_node ? of_node->full_name : "none");
 }
@@ -1347,7 +1346,7 @@ static int vio_hotplug(struct device *dev, struct kobj_uevent_env *env)
 	struct device_node *dn;
 	const char *cp;
 
-	dn = dev->archdata.of_node;
+	dn = dev->of_node;
 	if (!dn)
 		return -ENODEV;
 	cp = of_get_property(dn, "compatible", NULL);
@@ -1378,7 +1377,7 @@ static struct bus_type vio_bus_type = {
 */
 const void *vio_get_attribute(struct vio_dev *vdev, char *which, int *length)
 {
-	return of_get_property(vdev->dev.archdata.of_node, which, length);
+	return of_get_property(vdev->dev.of_node, which, length);
 }
 EXPORT_SYMBOL(vio_get_attribute);
 
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index ca5bfdf..b610122 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -544,7 +544,6 @@ static struct iommu_table *cell_get_iommu_table(struct device *dev)
 {
 	struct iommu_window *window;
 	struct cbe_iommu *iommu;
-	struct dev_archdata *archdata = &dev->archdata;
 
 	/* Current implementation uses the first window available in that
 	 * node's iommu. We -might- do something smarter later though it may
@@ -553,7 +552,7 @@ static struct iommu_table *cell_get_iommu_table(struct device *dev)
 	iommu = cell_iommu_for_node(dev_to_node(dev));
 	if (iommu == NULL || list_empty(&iommu->windows)) {
 		printk(KERN_ERR "iommu: missing iommu for %s (node %d)\n",
-		       archdata->of_node ? archdata->of_node->full_name : "?",
+		       dev->of_node ? dev->of_node->full_name : "?",
 		       dev_to_node(dev));
 		return NULL;
 	}
@@ -896,7 +895,7 @@ static u64 cell_iommu_get_fixed_address(struct device *dev)
 	const u32 *ranges = NULL;
 	int i, len, best, naddr, nsize, pna, range_size;
 
-	np = of_node_get(dev->archdata.of_node);
+	np = of_node_get(dev->of_node);
 	while (1) {
 		naddr = of_n_addr_cells(np);
 		nsize = of_n_size_cells(np);
diff --git a/arch/powerpc/platforms/pasemi/setup.c b/arch/powerpc/platforms/pasemi/setup.c
index 242f809..0ba5f86 100644
--- a/arch/powerpc/platforms/pasemi/setup.c
+++ b/arch/powerpc/platforms/pasemi/setup.c
@@ -359,10 +359,10 @@ static int pcmcia_notify(struct notifier_block *nb, unsigned long action,
 	/* We know electra_cf devices will always have of_node set, since
 	 * electra_cf is an of_platform driver.
 	 */
-	if (!parent->archdata.of_node)
+	if (!parent->of_node)
 		return 0;
 
-	if (!of_device_is_compatible(parent->archdata.of_node, "electra-cf"))
+	if (!of_device_is_compatible(parent->of_node, "electra-cf"))
 		return 0;
 
 	/* We use the direct ops for localbus */
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 2171a5b..1a96243 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -766,7 +766,6 @@ int ps3_system_bus_device_register(struct ps3_system_bus_device *dev)
 	};
 
 	dev->core.of_node = NULL;
-	dev->core.archdata.of_node = NULL;
 	set_dev_node(&dev->core, 0);
 
 	pr_debug("%s:%d add %s\n", __func__, __LINE__, dev_name(&dev->core));
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 1a0000a..d26182d 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -468,7 +468,7 @@ static void pci_dma_dev_setup_pSeries(struct pci_dev *dev)
 
 	pr_debug("pci_dma_dev_setup_pSeries: %s\n", pci_name(dev));
 
-	dn = dev->dev.archdata.of_node;
+	dn = dev->dev.of_node;
 
 	/* If we're the direct child of a root bus, then we need to allocate
 	 * an iommu table ourselves. The bus setup code should have setup

