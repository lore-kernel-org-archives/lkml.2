Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab0CRPWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:22:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53376 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0CRPWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:22:14 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [V2 PATCH 01/10] driver-core: Add device node pointer to struct device
To: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Date: Thu, 18 Mar 2010 09:22:11 -0600
Message-ID: <20100318152210.21082.2549.stgit@angua>
In-Reply-To: <20100318144836.21082.93040.stgit@angua>
References: <20100318144836.21082.93040.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, platforms using CONFIG_OF add a 'struct device_node *of_node'
to dev->archdata.  However, with CONFIG_OF becoming generic for all
architectures, it makes sense for commonality to move it out of archdata
and into struct device proper.

This patch adds a struct device_node *of_node member to struct device
and updates all locations which currently write the device_node pointer
into archdata to also update dev->of_node.  Subsequent patches will
modify callers to use the archdata location and ultimately remove
the archdata member entirely.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 arch/microblaze/kernel/of_device.c      |    1 +
 arch/powerpc/kernel/of_device.c         |    1 +
 arch/powerpc/kernel/pci-common.c        |    3 ++-
 arch/powerpc/kernel/vio.c               |    3 ++-
 arch/powerpc/platforms/ps3/system-bus.c |    1 +
 arch/sparc/kernel/of_device_32.c        |    1 +
 arch/sparc/kernel/of_device_64.c        |    1 +
 arch/sparc/kernel/pci.c                 |    1 +
 drivers/of/of_mdio.c                    |    1 +
 drivers/of/of_spi.c                     |    1 +
 include/linux/device.h                  |    4 ++++
 11 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/kernel/of_device.c b/arch/microblaze/kernel/of_device.c
index 9a0f763..f6c5218 100644
--- a/arch/microblaze/kernel/of_device.c
+++ b/arch/microblaze/kernel/of_device.c
@@ -54,6 +54,7 @@ struct of_device *of_device_alloc(struct device_node *np,
 	dev->dev.parent = parent;
 	dev->dev.release = of_release_dev;
 	dev->dev.archdata.of_node = np;
+	dev->dev.of_node = np;
 
 	if (bus_id)
 		dev_set_name(&dev->dev, bus_id);
diff --git a/arch/powerpc/kernel/of_device.c b/arch/powerpc/kernel/of_device.c
index a359cb0..9577e6f 100644
--- a/arch/powerpc/kernel/of_device.c
+++ b/arch/powerpc/kernel/of_device.c
@@ -74,6 +74,7 @@ struct of_device *of_device_alloc(struct device_node *np,
 	dev->dev.parent = parent;
 	dev->dev.release = of_release_dev;
 	dev->dev.archdata.of_node = np;
+	dev->dev.of_node = np;
 
 	if (bus_id)
 		dev_set_name(&dev->dev, "%s", bus_id);
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 2597f95..5f9e2c8 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1111,8 +1111,9 @@ void __devinit pcibios_setup_bus_devices(struct pci_bus *bus)
 		if (dev->is_added)
 			continue;
 
-		/* Setup OF node pointer in archdata */
+		/* Setup OF node pointer in the device */
 		sd->of_node = pci_device_to_OF_node(dev);
+		dev->dev.of_node = pci_device_to_OF_node(dev);
 
 		/* Fixup NUMA node as it may not be setup yet by the generic
 		 * code and is needed by the DMA init
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 77f6421..0670843 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1229,7 +1229,8 @@ struct vio_dev *vio_register_device_node(struct device_node *of_node)
 		if (unit_address != NULL)
 			viodev->unit_address = *unit_address;
 	}
-	viodev->dev.archdata.of_node = of_node_get(of_node);
+	viodev->dev.of_node = of_node_get(of_node);
+	viodev->dev.archdata.of_node = viodev->dev.of_node;
 
 	if (firmware_has_feature(FW_FEATURE_CMO))
 		vio_cmo_set_dma_ops(viodev);
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index e34b305..2171a5b 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -765,6 +765,7 @@ int ps3_system_bus_device_register(struct ps3_system_bus_device *dev)
 		BUG();
 	};
 
+	dev->core.of_node = NULL;
 	dev->core.archdata.of_node = NULL;
 	set_dev_node(&dev->core, 0);
 
diff --git a/arch/sparc/kernel/of_device_32.c b/arch/sparc/kernel/of_device_32.c
index da527b3..4926c1b 100644
--- a/arch/sparc/kernel/of_device_32.c
+++ b/arch/sparc/kernel/of_device_32.c
@@ -348,6 +348,7 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 	sd->prom_node = dp;
 	sd->op = op;
 
+	op->dev.of_node = dp;
 	op->node = dp;
 
 	op->clock_freq = of_getintprop_default(dp, "clock-frequency",
diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
index b3d4cb5..5bc7416 100644
--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -643,6 +643,7 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 	sd->prom_node = dp;
 	sd->op = op;
 
+	op->dev.of_node = dp;
 	op->node = dp;
 
 	op->clock_freq = of_getintprop_default(dp, "clock-frequency",
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 5ac539a..0c92014 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -262,6 +262,7 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 	sd->stc = &pbm->stc;
 	sd->host_controller = pbm;
 	sd->prom_node = node;
+	dev->dev.of_node = node;
 	sd->op = op = of_find_device_by_node(node);
 	sd->numa_node = pbm->numa_node;
 
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 18ecae4..12090f5 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -80,6 +80,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 		 * can be looked up later */
 		of_node_get(child);
 		dev_archdata_set_node(&phy->dev.archdata, child);
+		phy->dev.of_node = child;
 
 		/* All data is now stored in the phy struct; register it */
 		rc = phy_device_register(phy);
diff --git a/drivers/of/of_spi.c b/drivers/of/of_spi.c
index f65f48b..f3119a0 100644
--- a/drivers/of/of_spi.c
+++ b/drivers/of/of_spi.c
@@ -79,6 +79,7 @@ void of_register_spi_devices(struct spi_master *master, struct device_node *np)
 
 		/* Store a pointer to the node in the device structure */
 		of_node_get(nc);
+		spi->dev.of_node = nc;
 		spi->dev.archdata.of_node = nc;
 
 		/* Register the new device */
diff --git a/include/linux/device.h b/include/linux/device.h
index 1821928..7a968bd 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -34,6 +34,7 @@ struct class;
 struct class_private;
 struct bus_type;
 struct bus_type_private;
+struct device_node;
 
 struct bus_attribute {
 	struct attribute	attr;
@@ -433,6 +434,9 @@ struct device {
 					     override */
 	/* arch specific additions */
 	struct dev_archdata	archdata;
+#ifdef CONFIG_OF
+	struct device_node	*of_node;
+#endif
 
 	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
 

