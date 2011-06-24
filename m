Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1FXTFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 15:05:54 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52641 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839Ab1FXTFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 15:05:51 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, Paul Mackerras <paulus@samba.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Nishanth Aravamudan <nacc@us.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Will Schmidt <will_schmidt@vnet.ibm.com>, cbe-oss-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 1/4] powerpc: override dma_get_required_mask by platform hook and ops
Date: Fri, 24 Jun 2011 12:05:22 -0700
Message-Id: <1308942325-4813-2-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308942325-4813-1-git-send-email-nacc@us.ibm.com>
References: <1308942325-4813-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milton Miller <miltonm@bga.com>

The hook dma_get_required_mask is supposed to return the mask required
by the platform to operate efficently.  The generic version of
dma_get_required_mask in driver/base/platform.c returns a mask based
only on max_pfn.  However, this is likely too big for iommu systems
and could be too small for platforms that require a dma offset or have
a secondary window at a high offset.

Override the default, provide a hook in ppc_md used by pseries lpar and
cell, and provide the default answer based on memblock_end_of_DRAM(),
with hooks for get_dma_offset, and provide an implementation for iommu
that looks at the defined table size.  Coverting from the end address
to the required bit mask is based on the generic implementation.

The need for this was discovered when the qla2xxx driver switched to
64 bit dma then reverted to 32 bit when dma_get_required_mask said
32 bits was sufficient.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org
---
 arch/powerpc/include/asm/dma-mapping.h |    3 ++
 arch/powerpc/include/asm/machdep.h     |    3 +-
 arch/powerpc/kernel/dma-iommu.c        |   13 ++++++++++
 arch/powerpc/kernel/dma.c              |   39 ++++++++++++++++++++++++++++++++
 arch/powerpc/platforms/cell/iommu.c    |   12 +++++++++
 arch/powerpc/platforms/pseries/iommu.c |   27 ++++++++++++++++++++++
 6 files changed, 96 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index dd70fac..8135e66 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -20,6 +20,8 @@
 
 #define DMA_ERROR_CODE		(~(dma_addr_t)0x0)
 
+#define ARCH_HAS_DMA_GET_REQUIRED_MASK
+
 /* Some dma direct funcs must be visible for use in other dma_ops */
 extern void *dma_direct_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag);
@@ -69,6 +71,7 @@ static inline unsigned long device_to_mask(struct device *dev)
  */
 #ifdef CONFIG_PPC64
 extern struct dma_map_ops dma_iommu_ops;
+extern u64 dma_iommu_get_required_mask(struct device *dev);
 #endif
 extern struct dma_map_ops dma_direct_ops;
 
diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index 47cacdd..58fc216 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -85,8 +85,9 @@ struct machdep_calls {
 	void		(*pci_dma_dev_setup)(struct pci_dev *dev);
 	void		(*pci_dma_bus_setup)(struct pci_bus *bus);
 
-	/* Platform set_dma_mask override */
+	/* Platform set_dma_mask and dma_get_required_mask overrides */
 	int		(*dma_set_mask)(struct device *dev, u64 dma_mask);
+	u64		(*dma_get_required_mask)(struct device *dev);
 
 	int		(*probe)(void);
 	void		(*setup_arch)(void); /* Optional, may be NULL */
diff --git a/arch/powerpc/kernel/dma-iommu.c b/arch/powerpc/kernel/dma-iommu.c
index e755415..1f2a711 100644
--- a/arch/powerpc/kernel/dma-iommu.c
+++ b/arch/powerpc/kernel/dma-iommu.c
@@ -90,6 +90,19 @@ static int dma_iommu_dma_supported(struct device *dev, u64 mask)
 		return 1;
 }
 
+u64 dma_iommu_get_required_mask(struct device *dev)
+{
+	struct iommu_table *tbl = get_iommu_table_base(dev);
+	u64 mask;
+	if (!tbl)
+		return 0;
+
+	mask = 1ULL < (fls_long(tbl->it_offset + tbl->it_size) - 1);
+	mask += mask - 1;
+
+	return mask;
+}
+
 struct dma_map_ops dma_iommu_ops = {
 	.alloc_coherent	= dma_iommu_alloc_coherent,
 	.free_coherent	= dma_iommu_free_coherent,
diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
index d238c08..97fe867 100644
--- a/arch/powerpc/kernel/dma.c
+++ b/arch/powerpc/kernel/dma.c
@@ -172,6 +172,45 @@ int dma_set_mask(struct device *dev, u64 dma_mask)
 }
 EXPORT_SYMBOL(dma_set_mask);
 
+u64 dma_get_required_mask(struct device *dev)
+{
+	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	u64 mask, end = 0;
+
+	if (ppc_md.dma_get_required_mask)
+		return ppc_md.dma_get_required_mask(dev);
+
+	if (unlikely(dma_ops == NULL))
+		return 0;
+
+#ifdef CONFIG_PPC64
+	else if (dma_ops == &dma_iommu_ops)
+		return dma_iommu_get_required_mask(dev);
+#endif
+#ifdef CONFIG_SWIOTLB
+	else if (dma_ops == &swiotlb_dma_ops) {
+		u64 max_direct_dma_addr = dev->archdata.max_direct_dma_addr;
+
+		end = memblock_end_of_DRAM();
+		if (max_direct_dma_addr && end > max_direct_dma_addr)
+			end = max_direct_dma_addr;
+		end += get_dma_offset(dev);
+	}
+#endif
+	else if (dma_ops == &dma_direct_ops)
+		end = memblock_end_of_DRAM() + get_dma_offset(dev);
+	else {
+		WARN_ONCE(1, "%s: unknown ops %p\n", __func__, dma_ops);
+		end = memblock_end_of_DRAM();
+	}
+
+	mask = 1ULL << (fls64(end) - 1);
+	mask += mask - 1;
+
+	return mask;
+}
+EXPORT_SYMBOL_GPL(dma_get_required_mask);
+
 static int __init dma_init(void)
 {
        dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index 26a0671..5ef55f3 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -1159,6 +1159,17 @@ static int __init setup_iommu_fixed(char *str)
 }
 __setup("iommu_fixed=", setup_iommu_fixed);
 
+static u64 cell_dma_get_required_mask(struct device *dev)
+{
+	if (!dev->dma_mask)
+		return 0;
+
+	if (iommu_fixed_disabled && get_dma_ops(dev) == &dma_iommu_ops)
+		return dma_iommu_get_required_mask(dev);
+
+	return DMA_BIT_MASK(64);
+}
+
 static int __init cell_iommu_init(void)
 {
 	struct device_node *np;
@@ -1175,6 +1186,7 @@ static int __init cell_iommu_init(void)
 
 	/* Setup various ppc_md. callbacks */
 	ppc_md.pci_dma_dev_setup = cell_pci_dma_dev_setup;
+	ppc_md.dma_get_required_mask = cell_dma_get_required_mask;
 	ppc_md.tce_build = tce_build_cell;
 	ppc_md.tce_free = tce_free_cell;
 
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 01faab9..fe5eded 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -1077,12 +1077,38 @@ check_mask:
 	return 0;
 }
 
+static u64 dma_get_required_mask_pSeriesLP(struct device *dev)
+{
+	if (!dev->dma_mask)
+		return 0;
+
+	if (!disable_ddw && dev_is_pci(dev)) {
+		struct pci_dev *pdev = to_pci_dev(dev);
+		struct device_node *dn;
+
+		dn = pci_device_to_OF_node(pdev);
+
+		/* search upwards for ibm,dma-window */
+		for (; dn && PCI_DN(dn) && !PCI_DN(dn)->iommu_table;
+				dn = dn->parent)
+			if (of_get_property(dn, "ibm,dma-window", NULL))
+				break;
+		/* if there is a ibm,ddw-applicable property require 64 bits */
+		if (dn && PCI_DN(dn) &&
+				of_get_property(dn, "ibm,ddw-applicable", NULL))
+			return DMA_BIT_MASK(64);
+	}
+
+	return dma_iommu_get_required_mask(dev);
+}
+
 #else  /* CONFIG_PCI */
 #define pci_dma_bus_setup_pSeries	NULL
 #define pci_dma_dev_setup_pSeries	NULL
 #define pci_dma_bus_setup_pSeriesLP	NULL
 #define pci_dma_dev_setup_pSeriesLP	NULL
 #define dma_set_mask_pSeriesLP		NULL
+#define dma_get_required_mask_pSeriesLP	NULL
 #endif /* !CONFIG_PCI */
 
 static int iommu_mem_notifier(struct notifier_block *nb, unsigned long action,
@@ -1186,6 +1212,7 @@ void iommu_init_early_pSeries(void)
 		ppc_md.pci_dma_bus_setup = pci_dma_bus_setup_pSeriesLP;
 		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_pSeriesLP;
 		ppc_md.dma_set_mask = dma_set_mask_pSeriesLP;
+		ppc_md.dma_get_required_mask = dma_get_required_mask_pSeriesLP;
 	} else {
 		ppc_md.tce_build = tce_build_pSeries;
 		ppc_md.tce_free  = tce_free_pSeries;
-- 
1.7.4.1

