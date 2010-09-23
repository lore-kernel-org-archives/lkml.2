Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab0IWWij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:38:39 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5485 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab0IWWig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:38:36 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 9/9] MIPS: Octeon: Rewrite DMA mapping functions.
Date: Thu, 23 Sep 2010 15:38:16 -0700
Message-Id: <1285281496-24696-10-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 23 Sep 2010 22:38:36.0096 (UTC) FILETIME=[0F46E400:01CB5B70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All Octeon chips can support more than 4GB of RAM.  Also due to how
Octeon PCI is setup, even some configurations with less than 4GB of
RAM will have portions that are not accessible from 32-bit devices.

Enable the swiotlb code to handle the cases where a device cannot
directly do DMA.  This is a complete rewrite of the Octeon DMA mapping
code.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/cavium-octeon/Kconfig                    |   12 +
 arch/mips/cavium-octeon/dma-octeon.c               |  529 +++++++++-----------
 .../include/asm/mach-cavium-octeon/dma-coherence.h |   19 +-
 arch/mips/include/asm/octeon/pci-octeon.h          |   10 +
 arch/mips/pci/pci-octeon.c                         |   60 ++-
 arch/mips/pci/pcie-octeon.c                        |    5 +
 6 files changed, 336 insertions(+), 299 deletions(-)

diff --git a/arch/mips/cavium-octeon/Kconfig b/arch/mips/cavium-octeon/Kconfig
index 47323ca..475156b 100644
--- a/arch/mips/cavium-octeon/Kconfig
+++ b/arch/mips/cavium-octeon/Kconfig
@@ -87,3 +87,15 @@ config ARCH_SPARSEMEM_ENABLE
 config CAVIUM_OCTEON_HELPER
 	def_bool y
 	depends on OCTEON_ETHERNET || PCI
+
+config IOMMU_HELPER
+	bool
+
+config NEED_SG_DMA_LENGTH
+	bool
+
+config SWIOTLB
+	def_bool y
+	depends on CPU_CAVIUM_OCTEON
+	select IOMMU_HELPER
+	select NEED_SG_DMA_LENGTH
diff --git a/arch/mips/cavium-octeon/dma-octeon.c b/arch/mips/cavium-octeon/dma-octeon.c
index d22b5a2..b94730a 100644
--- a/arch/mips/cavium-octeon/dma-octeon.c
+++ b/arch/mips/cavium-octeon/dma-octeon.c
@@ -8,335 +8,296 @@
  * Copyright (C) 2005 Ilya A. Volynets-Evenbakh <ilya@total-knowledge.com>
  * swiped from i386, and cloned for MIPS by Geert, polished by Ralf.
  * IP32 changes by Ilya.
- * Cavium Networks: Create new dma setup for Cavium Networks Octeon based on
- * the kernels original.
+ * Copyright (C) 2010 Cavium Networks, Inc.
  */
 #include <linux/types.h>
 #include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/string.h>
+#include <linux/init.h>
 #include <linux/dma-mapping.h>
-#include <linux/platform_device.h>
+#include <linux/swiotlb.h>
 #include <linux/scatterlist.h>
 
-#include <linux/cache.h>
-#include <linux/io.h>
+#include <asm/bootinfo.h>
 
 #include <asm/octeon/octeon.h>
-#include <asm/octeon/cvmx-npi-defs.h>
-#include <asm/octeon/cvmx-pci-defs.h>
 
 #include <dma-coherence.h>
 
 #ifdef CONFIG_PCI
 #include <asm/octeon/pci-octeon.h>
-#endif
+#include <asm/octeon/cvmx-npi-defs.h>
+#include <asm/octeon/cvmx-pci-defs.h>
 
-#define BAR2_PCI_ADDRESS 0x8000000000ul
+static dma_addr_t octeon_hole_phys_to_dma(phys_addr_t paddr)
+{
+	if (paddr >= CVMX_PCIE_BAR1_PHYS_BASE && paddr < (CVMX_PCIE_BAR1_PHYS_BASE + CVMX_PCIE_BAR1_PHYS_SIZE))
+		return paddr - CVMX_PCIE_BAR1_PHYS_BASE + CVMX_PCIE_BAR1_RC_BASE;
+	else
+		return paddr;
+}
 
-struct bar1_index_state {
-	int16_t ref_count;	/* Number of PCI mappings using this index */
-	uint16_t address_bits;	/* Upper bits of physical address. This is
-				   shifted 22 bits */
-};
+static phys_addr_t octeon_hole_dma_to_phys(dma_addr_t daddr)
+{
+	if (daddr >= CVMX_PCIE_BAR1_RC_BASE)
+		return daddr + CVMX_PCIE_BAR1_PHYS_BASE - CVMX_PCIE_BAR1_RC_BASE;
+	else
+		return daddr;
+}
 
-#ifdef CONFIG_PCI
-static DEFINE_RAW_SPINLOCK(bar1_lock);
-static struct bar1_index_state bar1_state[32];
-#endif
+static dma_addr_t octeon_gen1_phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	if (paddr >= 0x410000000ull && paddr < 0x420000000ull)
+		paddr -= 0x400000000ull;
+	return octeon_hole_phys_to_dma(paddr);
+}
+
+static phys_addr_t octeon_gen1_dma_to_phys(struct device *dev, dma_addr_t daddr)
+{
+	daddr = octeon_hole_dma_to_phys(daddr);
+
+	if (daddr >= 0x10000000ull && daddr < 0x20000000ull)
+		daddr += 0x400000000ull;
+
+	return daddr;
+}
+
+static dma_addr_t octeon_big_phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	if (paddr >= 0x410000000ull && paddr < 0x420000000ull)
+		paddr -= 0x400000000ull;
+
+	/* Anything in the BAR1 hole or above goes via BAR2 */
+	if (paddr >= 0xf0000000ull)
+		paddr = OCTEON_BAR2_PCI_ADDRESS + paddr;
+
+	return paddr;
+}
 
-dma_addr_t octeon_map_dma_mem(struct device *dev, void *ptr, size_t size)
+static phys_addr_t octeon_big_dma_to_phys(struct device *dev, dma_addr_t daddr)
 {
-#ifndef CONFIG_PCI
-	/* Without PCI/PCIe this function can be called for Octeon internal
-	   devices such as USB. These devices all support 64bit addressing */
+	if (daddr >= OCTEON_BAR2_PCI_ADDRESS)
+		daddr -= OCTEON_BAR2_PCI_ADDRESS;
+
+	if (daddr >= 0x10000000ull && daddr < 0x20000000ull)
+		daddr += 0x400000000ull;
+	return daddr;
+}
+
+static dma_addr_t octeon_small_phys_to_dma(struct device *dev,
+					   phys_addr_t paddr)
+{
+	if (paddr >= 0x410000000ull && paddr < 0x420000000ull)
+		paddr -= 0x400000000ull;
+
+	/* Anything not in the BAR1 range goes via BAR2 */
+	if (paddr >= octeon_bar1_pci_phys && paddr < octeon_bar1_pci_phys + 0x8000000ull)
+		paddr = paddr - octeon_bar1_pci_phys;
+	else
+		paddr = OCTEON_BAR2_PCI_ADDRESS + paddr;
+
+	return paddr;
+}
+
+static phys_addr_t octeon_small_dma_to_phys(struct device *dev,
+					    dma_addr_t daddr)
+{
+	if (daddr >= OCTEON_BAR2_PCI_ADDRESS)
+		daddr -= OCTEON_BAR2_PCI_ADDRESS;
+	else
+		daddr += octeon_bar1_pci_phys;
+
+	if (daddr >= 0x10000000ull && daddr < 0x20000000ull)
+		daddr += 0x400000000ull;
+	return daddr;
+}
+
+#endif /* CONFIG_PCI */
+
+static dma_addr_t octeon_dma_map_page(struct device *dev, struct page *page,
+	unsigned long offset, size_t size, enum dma_data_direction direction,
+	struct dma_attrs *attrs)
+{
+	dma_addr_t daddr = swiotlb_map_page(dev, page, offset, size,
+					    direction, attrs);
 	mb();
-	return virt_to_phys(ptr);
-#else
-	unsigned long flags;
-	uint64_t dma_mask;
-	int64_t start_index;
-	dma_addr_t result = -1;
-	uint64_t physical = virt_to_phys(ptr);
-	int64_t index;
 
+	return daddr;
+}
+
+static int octeon_dma_map_sg(struct device *dev, struct scatterlist *sg,
+	int nents, enum dma_data_direction direction, struct dma_attrs *attrs)
+{
+	int r = swiotlb_map_sg_attrs(dev, sg, nents, direction, attrs);
 	mb();
-	/*
-	 * Use the DMA masks to determine the allowed memory
-	 * region. For us it doesn't limit the actual memory, just the
-	 * address visible over PCI.  Devices with limits need to use
-	 * lower indexed Bar1 entries.
-	 */
-	if (dev) {
-		dma_mask = dev->coherent_dma_mask;
-		if (dev->dma_mask)
-			dma_mask = *dev->dma_mask;
-	} else {
-		dma_mask = 0xfffffffful;
-	}
+	return r;
+}
 
-	/*
-	 * Platform devices, such as the internal USB, skip all
-	 * translation and use Octeon physical addresses directly.
-	 */
-	if (!dev || dev->bus == &platform_bus_type)
-		return physical;
+static void octeon_dma_sync_single_for_device(struct device *dev,
+	dma_addr_t dma_handle, size_t size, enum dma_data_direction direction)
+{
+	swiotlb_sync_single_for_device(dev, dma_handle, size, direction);
+	mb();
+}
 
-	switch (octeon_dma_bar_type) {
-	case OCTEON_DMA_BAR_TYPE_PCIE:
-		if (unlikely(physical < (16ul << 10)))
-			panic("dma_map_single: Not allowed to map first 16KB."
-			      " It interferes with BAR0 special area\n");
-		else if ((physical + size >= (256ul << 20)) &&
-			 (physical < (512ul << 20)))
-			panic("dma_map_single: Not allowed to map bootbus\n");
-		else if ((physical + size >= 0x400000000ull) &&
-			 physical < 0x410000000ull)
-			panic("dma_map_single: "
-			      "Attempt to map illegal memory address 0x%llx\n",
-			      physical);
-		else if (physical >= 0x420000000ull)
-			panic("dma_map_single: "
-			      "Attempt to map illegal memory address 0x%llx\n",
-			      physical);
-		else if (physical >= CVMX_PCIE_BAR1_PHYS_BASE &&
-			 physical + size < (CVMX_PCIE_BAR1_PHYS_BASE + CVMX_PCIE_BAR1_PHYS_SIZE)) {
-			result = physical - CVMX_PCIE_BAR1_PHYS_BASE + CVMX_PCIE_BAR1_RC_BASE;
-
-			if (((result+size-1) & dma_mask) != result+size-1)
-				panic("dma_map_single: Attempt to map address 0x%llx-0x%llx, which can't be accessed according to the dma mask 0x%llx\n",
-				      physical, physical+size-1, dma_mask);
-			goto done;
-		}
-
-		/* The 2nd 256MB is mapped at 256<<20 instead of 0x410000000 */
-		if ((physical >= 0x410000000ull) && physical < 0x420000000ull)
-			result = physical - 0x400000000ull;
-		else
-			result = physical;
-		if (((result+size-1) & dma_mask) != result+size-1)
-			panic("dma_map_single: Attempt to map address "
-			      "0x%llx-0x%llx, which can't be accessed "
-			      "according to the dma mask 0x%llx\n",
-			      physical, physical+size-1, dma_mask);
-		goto done;
+static void octeon_dma_sync_sg_for_device(struct device *dev,
+	struct scatterlist *sg, int nelems, enum dma_data_direction direction)
+{
+	swiotlb_sync_sg_for_device(dev, sg, nelems, direction);
+	mb();
+}
 
-	case OCTEON_DMA_BAR_TYPE_BIG:
-#ifdef CONFIG_64BIT
-		/* If the device supports 64bit addressing, then use BAR2 */
-		if (dma_mask > BAR2_PCI_ADDRESS) {
-			result = physical + BAR2_PCI_ADDRESS;
-			goto done;
-		}
-#endif
-		if (unlikely(physical < (4ul << 10))) {
-			panic("dma_map_single: Not allowed to map first 4KB. "
-			      "It interferes with BAR0 special area\n");
-		} else if (physical < (256ul << 20)) {
-			if (unlikely(physical + size > (256ul << 20)))
-				panic("dma_map_single: Requested memory spans "
-				      "Bar0 0:256MB and bootbus\n");
-			result = physical;
-			goto done;
-		} else if (unlikely(physical < (512ul << 20))) {
-			panic("dma_map_single: Not allowed to map bootbus\n");
-		} else if (physical < (2ul << 30)) {
-			if (unlikely(physical + size > (2ul << 30)))
-				panic("dma_map_single: Requested memory spans "
-				      "Bar0 512MB:2GB and BAR1\n");
-			result = physical;
-			goto done;
-		} else if (physical < (2ul << 30) + (128 << 20)) {
-			/* Fall through */
-		} else if (physical <
-			   (4ul << 30) - (OCTEON_PCI_BAR1_HOLE_SIZE << 20)) {
-			if (unlikely
-			    (physical + size >
-			     (4ul << 30) - (OCTEON_PCI_BAR1_HOLE_SIZE << 20)))
-				panic("dma_map_single: Requested memory "
-				      "extends past Bar1 (4GB-%luMB)\n",
-				      OCTEON_PCI_BAR1_HOLE_SIZE);
-			result = physical;
-			goto done;
-		} else if ((physical >= 0x410000000ull) &&
-			   (physical < 0x420000000ull)) {
-			if (unlikely(physical + size > 0x420000000ull))
-				panic("dma_map_single: Requested memory spans "
-				      "non existant memory\n");
-			/* BAR0 fixed mapping 256MB:512MB ->
-			 * 16GB+256MB:16GB+512MB */
-			result = physical - 0x400000000ull;
-			goto done;
-		} else {
-			/* Continued below switch statement */
-		}
-		break;
+static void *octeon_dma_alloc_coherent(struct device *dev, size_t size,
+	dma_addr_t *dma_handle, gfp_t gfp)
+{
+	void *ret;
 
-	case OCTEON_DMA_BAR_TYPE_SMALL:
-#ifdef CONFIG_64BIT
-		/* If the device supports 64bit addressing, then use BAR2 */
-		if (dma_mask > BAR2_PCI_ADDRESS) {
-			result = physical + BAR2_PCI_ADDRESS;
-			goto done;
-		}
+	if (dma_alloc_from_coherent(dev, size, dma_handle, &ret))
+		return ret;
+
+	/* ignore region specifiers */
+	gfp &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);
+
+#ifdef CONFIG_ZONE_DMA
+	if (dev == NULL)
+		gfp |= __GFP_DMA;
+	else if (dev->coherent_dma_mask <= DMA_BIT_MASK(24))
+		gfp |= __GFP_DMA;
+	else
 #endif
-		/* Continued below switch statement */
-		break;
+#ifdef CONFIG_ZONE_DMA32
+	     if (dev->coherent_dma_mask <= DMA_BIT_MASK(32))
+		gfp |= __GFP_DMA32;
+	else
+#endif
+		;
 
-	default:
-		panic("dma_map_single: Invalid octeon_dma_bar_type\n");
-	}
+	/* Don't invoke OOM killer */
+	gfp |= __GFP_NORETRY;
 
-	/* Don't allow mapping to span multiple Bar entries. The hardware guys
-	   won't guarantee that DMA across boards work */
-	if (unlikely((physical >> 22) != ((physical + size - 1) >> 22)))
-		panic("dma_map_single: "
-		      "Requested memory spans more than one Bar1 entry\n");
+	ret = swiotlb_alloc_coherent(dev, size, dma_handle, gfp);
 
-	if (octeon_dma_bar_type == OCTEON_DMA_BAR_TYPE_BIG)
-		start_index = 31;
-	else if (unlikely(dma_mask < (1ul << 27)))
-		start_index = (dma_mask >> 22);
-	else
-		start_index = 31;
-
-	/* Only one processor can access the Bar register at once */
-	raw_spin_lock_irqsave(&bar1_lock, flags);
-
-	/* Look through Bar1 for existing mapping that will work */
-	for (index = start_index; index >= 0; index--) {
-		if ((bar1_state[index].address_bits == physical >> 22) &&
-		    (bar1_state[index].ref_count)) {
-			/* An existing mapping will work, use it */
-			bar1_state[index].ref_count++;
-			if (unlikely(bar1_state[index].ref_count < 0))
-				panic("dma_map_single: "
-				      "Bar1[%d] reference count overflowed\n",
-				      (int) index);
-			result = (index << 22) | (physical & ((1 << 22) - 1));
-			/* Large BAR1 is offset at 2GB */
-			if (octeon_dma_bar_type == OCTEON_DMA_BAR_TYPE_BIG)
-				result += 2ul << 30;
-			goto done_unlock;
-		}
-	}
+	mb();
 
-	/* No existing mappings, look for a free entry */
-	for (index = start_index; index >= 0; index--) {
-		if (unlikely(bar1_state[index].ref_count == 0)) {
-			union cvmx_pci_bar1_indexx bar1_index;
-			/* We have a free entry, use it */
-			bar1_state[index].ref_count = 1;
-			bar1_state[index].address_bits = physical >> 22;
-			bar1_index.u32 = 0;
-			/* Address bits[35:22] sent to L2C */
-			bar1_index.s.addr_idx = physical >> 22;
-			/* Don't put PCI accesses in L2. */
-			bar1_index.s.ca = 1;
-			/* Endian Swap Mode */
-			bar1_index.s.end_swp = 1;
-			/* Set '1' when the selected address range is valid. */
-			bar1_index.s.addr_v = 1;
-			octeon_npi_write32(CVMX_NPI_PCI_BAR1_INDEXX(index),
-					   bar1_index.u32);
-			/* An existing mapping will work, use it */
-			result = (index << 22) | (physical & ((1 << 22) - 1));
-			/* Large BAR1 is offset at 2GB */
-			if (octeon_dma_bar_type == OCTEON_DMA_BAR_TYPE_BIG)
-				result += 2ul << 30;
-			goto done_unlock;
-		}
-	}
+	return ret;
+}
+
+static void octeon_dma_free_coherent(struct device *dev, size_t size,
+	void *vaddr, dma_addr_t dma_handle)
+{
+	int order = get_order(size);
 
-	pr_err("dma_map_single: "
-	       "Can't find empty BAR1 index for physical mapping 0x%llx\n",
-	       (unsigned long long) physical);
+	if (dma_release_from_coherent(dev, order, vaddr))
+		return;
 
-done_unlock:
-	raw_spin_unlock_irqrestore(&bar1_lock, flags);
-done:
-	pr_debug("dma_map_single 0x%llx->0x%llx\n", physical, result);
-	return result;
-#endif
+	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
 }
 
-void octeon_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr)
+static struct mips_dma_map_ops octeon_linear_dma_map_ops = {
+	.dma_map_ops = {
+		.alloc_coherent = octeon_dma_alloc_coherent,
+		.free_coherent = octeon_dma_free_coherent,
+		.map_page = octeon_dma_map_page,
+		.unmap_page = swiotlb_unmap_page,
+		.map_sg = octeon_dma_map_sg,
+		.unmap_sg = swiotlb_unmap_sg_attrs,
+		.sync_single_for_cpu = swiotlb_sync_single_for_cpu,
+		.sync_single_for_device = octeon_dma_sync_single_for_device,
+		.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
+		.sync_sg_for_device = octeon_dma_sync_sg_for_device,
+		.mapping_error = swiotlb_dma_mapping_error,
+		.dma_supported = swiotlb_dma_supported
+	},
+	.phys_to_dma = mips_unity_phys_to_dma,
+	.dma_to_phys = mips_unity_dma_to_phys
+};
+
+void __init plat_swiotlb_setup(void)
 {
-#ifndef CONFIG_PCI
-	/*
-	 * Without PCI/PCIe this function can be called for Octeon internal
-	 * devices such as USB. These devices all support 64bit addressing.
-	 */
-	return;
-#else
-	unsigned long flags;
-	uint64_t index;
+	int i;
+	phys_t max_addr;
+	phys_t addr_size;
+	size_t swiotlbsize;
 
+	max_addr = 0;
+	addr_size = 0;
+
+	for (i = 0 ; i < boot_mem_map.nr_map; i++) {
+		struct boot_mem_map_entry *e = &boot_mem_map.map[i];
+		if (e->type != BOOT_MEM_RAM)
+			continue;
+
+		/* These addresses map low for PCI. */
+		if (e->addr > 0x410000000ull)
+			continue;
+
+		addr_size += e->size;
+
+		if (max_addr < e->addr + e->size)
+			max_addr = e->addr + e->size;
+
+	}
+
+	swiotlbsize = PAGE_SIZE;
+
+#ifdef CONFIG_PCI
 	/*
-	 * Platform devices, such as the internal USB, skip all
-	 * translation and use Octeon physical addresses directly.
+	 * For OCTEON_DMA_BAR_TYPE_SMALL, size the iotlb at 1/4 memory
+	 * size to a maximum of 64MB
 	 */
-	if (dev->bus == &platform_bus_type)
-		return;
+	if (OCTEON_IS_MODEL(OCTEON_CN31XX)
+	    || OCTEON_IS_MODEL(OCTEON_CN38XX_PASS2)) {
+		swiotlbsize = addr_size / 4;
+		if (swiotlbsize > 64 * (1<<20))
+			swiotlbsize = 64 * (1<<20);
+	} else if (max_addr > 0xf0000000ul) {
+		/*
+		 * Otherwise only allocate a big iotlb if there is
+		 * memory past the BAR1 hole.
+		 */
+		swiotlbsize = 64 * (1<<20);
+	}
+#endif
+
+	swiotlb_init_with_default_size(swiotlbsize, 1);
+
+	mips_dma_map_ops = &octeon_linear_dma_map_ops;
+}
+
+#ifdef CONFIG_PCI
+struct mips_dma_map_ops octeon_pci_dma_map_ops = {
+	.dma_map_ops = {
+		.alloc_coherent = octeon_dma_alloc_coherent,
+		.free_coherent = octeon_dma_free_coherent,
+		.map_page = octeon_dma_map_page,
+		.unmap_page = swiotlb_unmap_page,
+		.map_sg = octeon_dma_map_sg,
+		.unmap_sg = swiotlb_unmap_sg_attrs,
+		.sync_single_for_cpu = swiotlb_sync_single_for_cpu,
+		.sync_single_for_device = octeon_dma_sync_single_for_device,
+		.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
+		.sync_sg_for_device = octeon_dma_sync_sg_for_device,
+		.mapping_error = swiotlb_dma_mapping_error,
+		.dma_supported = swiotlb_dma_supported
+	},
+};
 
+void __init octeon_pci_dma_init(void)
+{
 	switch (octeon_dma_bar_type) {
 	case OCTEON_DMA_BAR_TYPE_PCIE:
-		/* Nothing to do, all mappings are static */
-		goto done;
-
+		octeon_pci_dma_map_ops.phys_to_dma = octeon_gen1_phys_to_dma;
+		octeon_pci_dma_map_ops.dma_to_phys = octeon_gen1_dma_to_phys;
+		break;
 	case OCTEON_DMA_BAR_TYPE_BIG:
-#ifdef CONFIG_64BIT
-		/* Nothing to do for addresses using BAR2 */
-		if (dma_addr >= BAR2_PCI_ADDRESS)
-			goto done;
-#endif
-		if (unlikely(dma_addr < (4ul << 10)))
-			panic("dma_unmap_single: Unexpect DMA address 0x%llx\n",
-			      dma_addr);
-		else if (dma_addr < (2ul << 30))
-			/* Nothing to do for addresses using BAR0 */
-			goto done;
-		else if (dma_addr < (2ul << 30) + (128ul << 20))
-			/* Need to unmap, fall through */
-			index = (dma_addr - (2ul << 30)) >> 22;
-		else if (dma_addr <
-			 (4ul << 30) - (OCTEON_PCI_BAR1_HOLE_SIZE << 20))
-			goto done;	/* Nothing to do for the rest of BAR1 */
-		else
-			panic("dma_unmap_single: Unexpect DMA address 0x%llx\n",
-			      dma_addr);
-		/* Continued below switch statement */
+		octeon_pci_dma_map_ops.phys_to_dma = octeon_big_phys_to_dma;
+		octeon_pci_dma_map_ops.dma_to_phys = octeon_big_dma_to_phys;
 		break;
-
 	case OCTEON_DMA_BAR_TYPE_SMALL:
-#ifdef CONFIG_64BIT
-		/* Nothing to do for addresses using BAR2 */
-		if (dma_addr >= BAR2_PCI_ADDRESS)
-			goto done;
-#endif
-		index = dma_addr >> 22;
-		/* Continued below switch statement */
+		octeon_pci_dma_map_ops.phys_to_dma = octeon_small_phys_to_dma;
+		octeon_pci_dma_map_ops.dma_to_phys = octeon_small_dma_to_phys;
 		break;
-
 	default:
-		panic("dma_unmap_single: Invalid octeon_dma_bar_type\n");
+		break;
 	}
-
-	if (unlikely(index > 31))
-		panic("dma_unmap_single: "
-		      "Attempt to unmap an invalid address (0x%llx)\n",
-		      dma_addr);
-
-	raw_spin_lock_irqsave(&bar1_lock, flags);
-	bar1_state[index].ref_count--;
-	if (bar1_state[index].ref_count == 0)
-		octeon_npi_write32(CVMX_NPI_PCI_BAR1_INDEXX(index), 0);
-	else if (unlikely(bar1_state[index].ref_count < 0))
-		panic("dma_unmap_single: Bar1[%u] reference count < 0\n",
-		      (int) index);
-	raw_spin_unlock_irqrestore(&bar1_lock, flags);
-done:
-	pr_debug("dma_unmap_single 0x%llx\n", dma_addr);
-	return;
-#endif
 }
+#endif /* CONFIG_PCI */
diff --git a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
index 17d5794..a0058fb 100644
--- a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
+++ b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
@@ -15,41 +15,40 @@
 
 struct device;
 
-dma_addr_t octeon_map_dma_mem(struct device *, void *, size_t);
-void octeon_unmap_dma_mem(struct device *, dma_addr_t);
+void octeon_pci_dma_init(void);
 
 static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
 	size_t size)
 {
-	return octeon_map_dma_mem(dev, addr, size);
+	BUG();
 }
 
 static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
 	struct page *page)
 {
-	return octeon_map_dma_mem(dev, page_address(page), PAGE_SIZE);
+	BUG();
 }
 
 static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
 {
-	return dma_addr;
+	BUG();
 }
 
 static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
 	size_t size, enum dma_data_direction direction)
 {
-	octeon_unmap_dma_mem(dev, dma_addr);
+	BUG();
 }
 
 static inline int plat_dma_supported(struct device *dev, u64 mask)
 {
-	return 1;
+	BUG();
 }
 
 static inline void plat_extra_sync_for_device(struct device *dev)
 {
-	mb();
+	BUG();
 }
 
 static inline int plat_device_is_coherent(struct device *dev)
@@ -60,7 +59,9 @@ static inline int plat_device_is_coherent(struct device *dev)
 static inline int plat_dma_mapping_error(struct device *dev,
 					 dma_addr_t dma_addr)
 {
-	return dma_addr == -1;
+	BUG();
 }
 
+extern struct mips_dma_map_ops octeon_pci_dma_map_ops;
+
 #endif /* __ASM_MACH_CAVIUM_OCTEON_DMA_COHERENCE_H */
diff --git a/arch/mips/include/asm/octeon/pci-octeon.h b/arch/mips/include/asm/octeon/pci-octeon.h
index ece7804..fba2ba2 100644
--- a/arch/mips/include/asm/octeon/pci-octeon.h
+++ b/arch/mips/include/asm/octeon/pci-octeon.h
@@ -36,6 +36,16 @@ extern int (*octeon_pcibios_map_irq)(const struct pci_dev *dev,
 				     u8 slot, u8 pin);
 
 /*
+ * For PCI (not PCIe) the BAR2 base address.
+ */
+#define OCTEON_BAR2_PCI_ADDRESS 0x8000000000ull
+
+/*
+ * For PCI (not PCIe) the base of the memory mapped by BAR1
+ */
+extern u64 octeon_bar1_pci_phys;
+
+/*
  * The following defines are used when octeon_dma_bar_type =
  * OCTEON_DMA_BAR_TYPE_BIG
  */
diff --git a/arch/mips/pci/pci-octeon.c b/arch/mips/pci/pci-octeon.c
index d248b70..311d808 100644
--- a/arch/mips/pci/pci-octeon.c
+++ b/arch/mips/pci/pci-octeon.c
@@ -11,6 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/delay.h>
+#include <linux/swiotlb.h>
 
 #include <asm/time.h>
 
@@ -19,6 +20,8 @@
 #include <asm/octeon/cvmx-pci-defs.h>
 #include <asm/octeon/pci-octeon.h>
 
+#include <dma-coherence.h>
+
 #define USE_OCTEON_INTERNAL_ARBITER
 
 /*
@@ -32,6 +35,8 @@
 /* Octeon't PCI controller uses did=3, subdid=3 for PCI memory. */
 #define OCTEON_PCI_MEMSPACE_OFFSET  (0x00011b0000000000ull)
 
+u64 octeon_bar1_pci_phys;
+
 /**
  * This is the bit decoding used for the Octeon PCI controller addresses
  */
@@ -170,6 +175,8 @@ int pcibios_plat_dev_init(struct pci_dev *dev)
 		pci_write_config_dword(dev, pos + PCI_ERR_ROOT_STATUS, dconfig);
 	}
 
+	dev->dev.archdata.dma_ops = &octeon_pci_dma_map_ops;
+
 	return 0;
 }
 
@@ -618,12 +625,10 @@ static int __init octeon_pci_setup(void)
 	 * before the readl()'s below. We don't want BAR2 overlapping
 	 * with BAR0/BAR1 during these reads.
 	 */
-	octeon_npi_write32(CVMX_NPI_PCI_CFG08, 0);
-	octeon_npi_write32(CVMX_NPI_PCI_CFG09, 0x80);
-
-	/* Disable the BAR1 movable mappings */
-	for (index = 0; index < 32; index++)
-		octeon_npi_write32(CVMX_NPI_PCI_BAR1_INDEXX(index), 0);
+	octeon_npi_write32(CVMX_NPI_PCI_CFG08,
+			   (u32)(OCTEON_BAR2_PCI_ADDRESS & 0xffffffffull));
+	octeon_npi_write32(CVMX_NPI_PCI_CFG09,
+			   (u32)(OCTEON_BAR2_PCI_ADDRESS >> 32));
 
 	if (octeon_dma_bar_type == OCTEON_DMA_BAR_TYPE_BIG) {
 		/* Remap the Octeon BAR 0 to 0-2GB */
@@ -637,6 +642,25 @@ static int __init octeon_pci_setup(void)
 		octeon_npi_write32(CVMX_NPI_PCI_CFG06, 2ul << 30);
 		octeon_npi_write32(CVMX_NPI_PCI_CFG07, 0);
 
+		/* BAR1 movable mappings set for identity mapping */
+		octeon_bar1_pci_phys = 0x80000000ull;
+		for (index = 0; index < 32; index++) {
+			union cvmx_pci_bar1_indexx bar1_index;
+
+			bar1_index.u32 = 0;
+			/* Address bits[35:22] sent to L2C */
+			bar1_index.s.addr_idx =
+				(octeon_bar1_pci_phys >> 22) + index;
+			/* Don't put PCI accesses in L2. */
+			bar1_index.s.ca = 1;
+			/* Endian Swap Mode */
+			bar1_index.s.end_swp = 1;
+			/* Set '1' when the selected address range is valid. */
+			bar1_index.s.addr_v = 1;
+			octeon_npi_write32(CVMX_NPI_PCI_BAR1_INDEXX(index),
+					   bar1_index.u32);
+		}
+
 		/* Devices go after BAR1 */
 		octeon_pci_mem_resource.start =
 			OCTEON_PCI_MEMSPACE_OFFSET + (4ul << 30) -
@@ -652,6 +676,27 @@ static int __init octeon_pci_setup(void)
 		octeon_npi_write32(CVMX_NPI_PCI_CFG06, 0);
 		octeon_npi_write32(CVMX_NPI_PCI_CFG07, 0);
 
+		/* BAR1 movable regions contiguous to cover the swiotlb */
+		octeon_bar1_pci_phys =
+			virt_to_phys(swiotlb_start) & ~((1ull << 22) - 1);
+
+		for (index = 0; index < 32; index++) {
+			union cvmx_pci_bar1_indexx bar1_index;
+
+			bar1_index.u32 = 0;
+			/* Address bits[35:22] sent to L2C */
+			bar1_index.s.addr_idx =
+				(octeon_bar1_pci_phys >> 22) + index;
+			/* Don't put PCI accesses in L2. */
+			bar1_index.s.ca = 1;
+			/* Endian Swap Mode */
+			bar1_index.s.end_swp = 1;
+			/* Set '1' when the selected address range is valid. */
+			bar1_index.s.addr_v = 1;
+			octeon_npi_write32(CVMX_NPI_PCI_BAR1_INDEXX(index),
+					   bar1_index.u32);
+		}
+
 		/* Devices go after BAR0 */
 		octeon_pci_mem_resource.start =
 			OCTEON_PCI_MEMSPACE_OFFSET + (128ul << 20) +
@@ -667,6 +712,9 @@ static int __init octeon_pci_setup(void)
 	 * was setup properly.
 	 */
 	cvmx_write_csr(CVMX_NPI_PCI_INT_SUM2, -1);
+
+	octeon_pci_dma_init();
+
 	return 0;
 }
 
diff --git a/arch/mips/pci/pcie-octeon.c b/arch/mips/pci/pcie-octeon.c
index 861361e..385f035 100644
--- a/arch/mips/pci/pcie-octeon.c
+++ b/arch/mips/pci/pcie-octeon.c
@@ -75,6 +75,8 @@ union cvmx_pcie_address {
 	} mem;
 };
 
+#include <dma-coherence.h>
+
 /**
  * Return the Core virtual base address for PCIe IO access. IOs are
  * read/written as an offset from this address.
@@ -1391,6 +1393,9 @@ static int __init octeon_pcie_setup(void)
 			cvmx_pcie_get_io_size(1) - 1;
 		register_pci_controller(&octeon_pcie1_controller);
 	}
+
+	octeon_pci_dma_init();
+
 	return 0;
 }
 
-- 
1.7.2.2

