Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868Ab2FVLY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:24:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43253 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab2FVLYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:24:25 -0400
MIME-Version: 1.0
In-Reply-To: <201206162037.q5GKbFg0017781@lab-41.internal.tilera.com>
References: <201206162036.q5GKacEK017774@lab-41.internal.tilera.com> <201206162037.q5GKbFg0017781@lab-41.internal.tilera.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 22 Jun 2012 05:24:02 -0600
Message-ID: <CAErSpo6Sws6AeZiW=-OW-6_wUO0LuJ1FMxU=yuu-7srN0+TL3g@mail.gmail.com>
Subject: Re: [PATCH 3/3] tile pci: enable IOMMU to support DMA for legacy devices
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 1:23 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> This change uses the TRIO IOMMU to map the PCI DMA space and physical
> memory at different addresses.  We also now use the dma_mapping_ops
> to provide support for non-PCI DMA, PCIe DMA (64-bit) and legacy PCI
> DMA (32-bit).  We use the kernel's software I/O TLB framework
> (i.e. bounce buffers) for the legacy 32-bit PCI device support since
> there are a limited number of TLB entries in the IOMMU and it is
> non-trivial to handle indexing, searching, matching, etc.  For 32-bit
> devices the performance impact of bounce buffers should not be a concern.
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/Kconfig                   |   18 ++
>  arch/tile/include/asm/Kbuild        |    1 -
>  arch/tile/include/asm/device.h      |   33 ++++
>  arch/tile/include/asm/dma-mapping.h |  146 +++++++++-----
>  arch/tile/include/asm/pci.h         |   76 +++++++-
>  arch/tile/kernel/pci-dma.c          |  369 ++++++++++++++++++++++++++++-------
>  arch/tile/kernel/pci_gx.c           |  113 +++++------
>  arch/tile/kernel/setup.c            |   35 ++--
>  8 files changed, 588 insertions(+), 203 deletions(-)
>  create mode 100644 arch/tile/include/asm/device.h
>
> diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
> index 0ad771f..557e3a3 100644
> --- a/arch/tile/Kconfig
> +++ b/arch/tile/Kconfig
> @@ -3,6 +3,8 @@
>
>  config TILE
>        def_bool y
> +       select HAVE_DMA_ATTRS
> +       select HAVE_DMA_API_DEBUG
>        select HAVE_KVM if !TILEGX
>        select GENERIC_FIND_FIRST_BIT
>        select USE_GENERIC_SMP_HELPERS
> @@ -79,6 +81,9 @@ config ARCH_DMA_ADDR_T_64BIT
>  config NEED_DMA_MAP_STATE
>        def_bool y
>
> +config ARCH_HAS_DMA_SET_COHERENT_MASK
> +       bool
> +
>  config LOCKDEP_SUPPORT
>        def_bool y
>
> @@ -215,6 +220,19 @@ config HIGHMEM
>  config ZONE_DMA
>        def_bool y
>
> +config IOMMU_HELPER
> +       bool
> +
> +config NEED_SG_DMA_LENGTH
> +       bool
> +
> +config SWIOTLB
> +       bool
> +       default TILEGX
> +       select IOMMU_HELPER
> +       select NEED_SG_DMA_LENGTH
> +       select ARCH_HAS_DMA_SET_COHERENT_MASK
> +
>  # We do not currently support disabling NUMA.
>  config NUMA
>        bool # "NUMA Memory Allocation and Scheduler Support"
> diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
> index 143473e..fb7c65a 100644
> --- a/arch/tile/include/asm/Kbuild
> +++ b/arch/tile/include/asm/Kbuild
> @@ -9,7 +9,6 @@ header-y += hardwall.h
>  generic-y += bug.h
>  generic-y += bugs.h
>  generic-y += cputime.h
> -generic-y += device.h
>  generic-y += div64.h
>  generic-y += emergency-restart.h
>  generic-y += errno.h
> diff --git a/arch/tile/include/asm/device.h b/arch/tile/include/asm/device.h
> new file mode 100644
> index 0000000..5182705
> --- /dev/null
> +++ b/arch/tile/include/asm/device.h
> @@ -0,0 +1,33 @@
> +/*
> + * Copyright 2010 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + * Arch specific extensions to struct device
> + */
> +
> +#ifndef _ASM_TILE_DEVICE_H
> +#define _ASM_TILE_DEVICE_H
> +
> +struct dev_archdata {
> +       /* DMA operations on that device */
> +        struct dma_map_ops     *dma_ops;
> +
> +       /* Offset of the DMA address from the PA. */
> +       dma_addr_t              dma_offset;
> +
> +       /* Highest DMA address that can be generated by this device. */
> +       dma_addr_t              max_direct_dma_addr;
> +};
> +
> +struct pdev_archdata {
> +};
> +
> +#endif /* _ASM_TILE_DEVICE_H */
> diff --git a/arch/tile/include/asm/dma-mapping.h b/arch/tile/include/asm/dma-mapping.h
> index eaa06d1..4b6247d 100644
> --- a/arch/tile/include/asm/dma-mapping.h
> +++ b/arch/tile/include/asm/dma-mapping.h
> @@ -20,69 +20,80 @@
>  #include <linux/cache.h>
>  #include <linux/io.h>
>
> -/*
> - * Note that on x86 and powerpc, there is a "struct dma_mapping_ops"
> - * that is used for all the DMA operations.  For now, we don't have an
> - * equivalent on tile, because we only have a single way of doing DMA.
> - * (Tilera bug 7994 to use dma_mapping_ops.)
> - */
> +extern struct dma_map_ops *tile_dma_map_ops;
> +extern struct dma_map_ops *gx_pci_dma_map_ops;
> +extern struct dma_map_ops *gx_legacy_pci_dma_map_ops;
> +
> +static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> +{
> +       if (dev && dev->archdata.dma_ops)
> +               return dev->archdata.dma_ops;
> +       else
> +               return tile_dma_map_ops;
> +}
> +
> +static inline dma_addr_t get_dma_offset(struct device *dev)
> +{
> +       return dev->archdata.dma_offset;
> +}
> +
> +static inline void set_dma_offset(struct device *dev, dma_addr_t off)
> +{
> +       dev->archdata.dma_offset = off;
> +}
>
> -#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
> -#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
> -
> -extern dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
> -                         enum dma_data_direction);
> -extern void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
> -                            size_t size, enum dma_data_direction);
> -extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
> -              enum dma_data_direction);
> -extern void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
> -                        int nhwentries, enum dma_data_direction);
> -extern dma_addr_t dma_map_page(struct device *dev, struct page *page,
> -                              unsigned long offset, size_t size,
> -                              enum dma_data_direction);
> -extern void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
> -                          size_t size, enum dma_data_direction);
> -extern void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
> -                               int nelems, enum dma_data_direction);
> -extern void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
> -                                  int nelems, enum dma_data_direction);
> -
> -
> -void *dma_alloc_coherent(struct device *dev, size_t size,
> -                          dma_addr_t *dma_handle, gfp_t flag);
> -
> -void dma_free_coherent(struct device *dev, size_t size,
> -                        void *vaddr, dma_addr_t dma_handle);
> -
> -extern void dma_sync_single_for_cpu(struct device *, dma_addr_t, size_t,
> -                                   enum dma_data_direction);
> -extern void dma_sync_single_for_device(struct device *, dma_addr_t,
> -                                      size_t, enum dma_data_direction);
> -extern void dma_sync_single_range_for_cpu(struct device *, dma_addr_t,
> -                                         unsigned long offset, size_t,
> -                                         enum dma_data_direction);
> -extern void dma_sync_single_range_for_device(struct device *, dma_addr_t,
> -                                            unsigned long offset, size_t,
> -                                            enum dma_data_direction);
> -extern void dma_cache_sync(struct device *dev, void *vaddr, size_t,
> -                          enum dma_data_direction);
> +static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
> +{
> +       return paddr + get_dma_offset(dev);
> +}
> +
> +static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
> +{
> +       return daddr - get_dma_offset(dev);
> +}
> +
> +static inline void dma_mark_clean(void *addr, size_t size) {}
> +
> +#include <asm-generic/dma-mapping-common.h>
> +
> +static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
> +{
> +       dev->archdata.dma_ops = ops;
> +}
> +
> +static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
> +{
> +       if (!dev->dma_mask)
> +               return 0;
> +
> +       return addr + size - 1 <= *dev->dma_mask;
> +}
>
>  static inline int
>  dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>  {
> -       return 0;
> +       return get_dma_ops(dev)->mapping_error(dev, dma_addr);
>  }
>
>  static inline int
>  dma_supported(struct device *dev, u64 mask)
>  {
> -       return 1;
> +       return get_dma_ops(dev)->dma_supported(dev, mask);
>  }
>
>  static inline int
>  dma_set_mask(struct device *dev, u64 mask)
>  {
> +       struct dma_map_ops *dma_ops = get_dma_ops(dev);
> +
> +       /* Handle legacy PCI devices with limited memory addressability. */
> +       if ((dma_ops == gx_pci_dma_map_ops) && (mask <= DMA_BIT_MASK(32))) {
> +               set_dma_ops(dev, gx_legacy_pci_dma_map_ops);
> +               set_dma_offset(dev, 0);
> +               if (mask > dev->archdata.max_direct_dma_addr)
> +                       mask = dev->archdata.max_direct_dma_addr;
> +       }
> +
>        if (!dev->dma_mask || !dma_supported(dev, mask))
>                return -EIO;
>
> @@ -91,4 +102,43 @@ dma_set_mask(struct device *dev, u64 mask)
>        return 0;
>  }
>
> +static inline void *dma_alloc_attrs(struct device *dev, size_t size,
> +                                   dma_addr_t *dma_handle, gfp_t flag,
> +                                   struct dma_attrs *attrs)
> +{
> +       struct dma_map_ops *dma_ops = get_dma_ops(dev);
> +       void *cpu_addr;
> +
> +       cpu_addr = dma_ops->alloc(dev, size, dma_handle, flag, attrs);
> +
> +       debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr);
> +
> +       return cpu_addr;
> +}
> +
> +static inline void dma_free_attrs(struct device *dev, size_t size,
> +                                 void *cpu_addr, dma_addr_t dma_handle,
> +                                 struct dma_attrs *attrs)
> +{
> +       struct dma_map_ops *dma_ops = get_dma_ops(dev);
> +
> +       debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
> +
> +       dma_ops->free(dev, size, cpu_addr, dma_handle, attrs);
> +}
> +
> +#define dma_alloc_coherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
> +#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
> +#define dma_free_coherent(d, s, v, h) dma_free_attrs(d, s, v, h, NULL)
> +#define dma_free_noncoherent(d, s, v, h) dma_free_attrs(d, s, v, h, NULL)
> +
> +/*
> + * dma_alloc_noncoherent() is #defined to return coherent memory,
> + * so there's no need to do any flushing here.
> + */
> +static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
> +                                 enum dma_data_direction direction)
> +{
> +}
> +
>  #endif /* _ASM_TILE_DMA_MAPPING_H */
> diff --git a/arch/tile/include/asm/pci.h b/arch/tile/include/asm/pci.h
> index 2c224c4..553b7ff 100644
> --- a/arch/tile/include/asm/pci.h
> +++ b/arch/tile/include/asm/pci.h
> @@ -15,6 +15,7 @@
>  #ifndef _ASM_TILE_PCI_H
>  #define _ASM_TILE_PCI_H
>
> +#include <linux/dma-mapping.h>
>  #include <linux/pci.h>
>  #include <linux/numa.h>
>  #include <asm-generic/pci_iomap.h>
> @@ -53,6 +54,16 @@ static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr) {}
>
>  #define        TILE_NUM_PCIE   2
>
> +/*
> + * The hypervisor maps the entirety of CPA-space as bus addresses, so
> + * bus addresses are physical addresses.  The networking and block
> + * device layers use this boolean for bounce buffer decisions.
> + */
> +#define PCI_DMA_BUS_IS_PHYS     1
> +
> +/* generic pci stuff */
> +#include <asm-generic/pci.h>
> +
>  #else
>
>  #include <asm/page.h>
> @@ -85,7 +96,47 @@ static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr) {}
>  /*
>  * Each Mem-Map interrupt region occupies 4KB.
>  */
> -#define        MEM_MAP_INTR_REGION_SIZE        (1<< TRIO_MAP_MEM_LIM__ADDR_SHIFT)
> +#define        MEM_MAP_INTR_REGION_SIZE        (1 << TRIO_MAP_MEM_LIM__ADDR_SHIFT)
> +
> +/*
> + * Allocate the PCI BAR window right below 4GB.
> + */
> +#define        TILE_PCI_BAR_WINDOW_TOP         (1ULL << 32)
> +
> +/*
> + * Allocate 1GB for the PCI BAR window.
> + */
> +#define        TILE_PCI_BAR_WINDOW_SIZE        (1 << 30)
> +
> +/*
> + * This is the highest bus address targeting the host memory that
> + * can be generated by legacy PCI devices with 32-bit or less
> + * DMA capability, dictated by the BAR window size and location.
> + */
> +#define        TILE_PCI_MAX_DIRECT_DMA_ADDRESS \
> +       (TILE_PCI_BAR_WINDOW_TOP - TILE_PCI_BAR_WINDOW_SIZE - 1)
> +
> +/*
> + * We shift the PCI bus range for all the physical memory up by the whole PA
> + * range. The corresponding CPA of an incoming PCI request will be the PCI
> + * address minus TILE_PCI_MEM_MAP_BASE_OFFSET. This also implies
> + * that the 64-bit capable devices will be given DMA addresses as
> + * the CPA plus TILE_PCI_MEM_MAP_BASE_OFFSET. To support 32-bit
> + * devices, we create a separate map region that handles the low
> + * 4GB.
> + */
> +#define        TILE_PCI_MEM_MAP_BASE_OFFSET    (1ULL << CHIP_PA_WIDTH())
> +
> +/*
> + * End of the PCI memory resource.
> + */
> +#define        TILE_PCI_MEM_END        \
> +               ((1ULL << CHIP_PA_WIDTH()) + TILE_PCI_BAR_WINDOW_TOP)
> +
> +/*
> + * Start of the PCI memory resource.
> + */
> +#define        TILE_PCI_MEM_START      (TILE_PCI_MEM_END - TILE_PCI_BAR_WINDOW_SIZE)
>
>  /*
>  * Structure of a PCI controller (host bridge) on Gx.
> @@ -108,6 +159,8 @@ struct pci_controller {
>        int index;              /* PCI domain number */
>        struct pci_bus *root_bus;
>
> +       uint64_t mem_offset;    /* cpu->bus memory mapping offset. */
> +
>        int last_busno;
>
>        struct pci_ops *ops;
> @@ -126,14 +179,22 @@ extern gxio_trio_context_t trio_contexts[TILEGX_NUM_TRIO];
>
>  extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
>
> -#endif /* __tilegx__ */
> +extern void
> +pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
> +                       struct resource *res);
> +
> +extern void
> +pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
> +                       struct pci_bus_region *region);

These extern declarations look like leftovers that shouldn't be needed.

>  /*
> - * The hypervisor maps the entirety of CPA-space as bus addresses, so
> - * bus addresses are physical addresses.  The networking and block
> - * device layers use this boolean for bounce buffer decisions.
> + * The PCI address space does not equal the physical memory address
> + * space (we have an IOMMU). The IDE and SCSI device layers use this
> + * boolean for bounce buffer decisions.
>  */
> -#define PCI_DMA_BUS_IS_PHYS     1
> +#define PCI_DMA_BUS_IS_PHYS     0
> +
> +#endif /* __tilegx__ */
>
>  int __init tile_pci_init(void);
>  int __init pcibios_init(void);
> @@ -169,7 +230,4 @@ static inline int pcibios_assign_all_busses(void)
>  /* implement the pci_ DMA API in terms of the generic device dma_ one */
>  #include <asm-generic/pci-dma-compat.h>
>
> -/* generic pci stuff */
> -#include <asm-generic/pci.h>
> -
>  #endif /* _ASM_TILE_PCI_H */
> diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
> index edd856a..b9fe80e 100644
> --- a/arch/tile/kernel/pci-dma.c
> +++ b/arch/tile/kernel/pci-dma.c
> @@ -14,6 +14,7 @@
>
>  #include <linux/mm.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/swiotlb.h>
>  #include <linux/vmalloc.h>
>  #include <linux/export.h>
>  #include <asm/tlbflush.h>
> @@ -31,10 +32,9 @@
>  #define PAGE_HOME_DMA PAGE_HOME_HASH
>  #endif
>
> -void *dma_alloc_coherent(struct device *dev,
> -                        size_t size,
> -                        dma_addr_t *dma_handle,
> -                        gfp_t gfp)
> +static void *tile_dma_alloc_coherent(struct device *dev, size_t size,
> +                                    dma_addr_t *dma_handle, gfp_t gfp,
> +                                    struct dma_attrs *attrs)
>  {
>        u64 dma_mask = dev->coherent_dma_mask ?: DMA_BIT_MASK(32);
>        int node = dev_to_node(dev);
> @@ -68,19 +68,19 @@ void *dma_alloc_coherent(struct device *dev,
>        }
>
>        *dma_handle = addr;
> +
>        return page_address(pg);
>  }
> -EXPORT_SYMBOL(dma_alloc_coherent);
>
>  /*
> - * Free memory that was allocated with dma_alloc_coherent.
> + * Free memory that was allocated with tile_dma_alloc_coherent.
>  */
> -void dma_free_coherent(struct device *dev, size_t size,
> -                 void *vaddr, dma_addr_t dma_handle)
> +static void tile_dma_free_coherent(struct device *dev, size_t size,
> +                                  void *vaddr, dma_addr_t dma_handle,
> +                                  struct dma_attrs *attrs)
>  {
>        homecache_free_pages((unsigned long)vaddr, get_order(size));
>  }
> -EXPORT_SYMBOL(dma_free_coherent);
>
>  /*
>  * The map routines "map" the specified address range for DMA
> @@ -199,38 +199,182 @@ static void __dma_complete_pa_range(dma_addr_t dma_addr, size_t size,
>        }
>  }
>
> +static int tile_dma_map_sg(struct device *dev, struct scatterlist *sglist,
> +                          int nents, enum dma_data_direction direction,
> +                          struct dma_attrs *attrs)
> +{
> +       struct scatterlist *sg;
> +       int i;
>
> -/*
> - * dma_map_single can be passed any memory address, and there appear
> - * to be no alignment constraints.
> - *
> - * There is a chance that the start of the buffer will share a cache
> - * line with some other data that has been touched in the meantime.
> - */
> -dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
> -                         enum dma_data_direction direction)
> +       BUG_ON(!valid_dma_direction(direction));
> +
> +       WARN_ON(nents == 0 || sglist->length == 0);
> +
> +       for_each_sg(sglist, sg, nents, i) {
> +               sg->dma_address = sg_phys(sg);
> +               __dma_prep_pa_range(sg->dma_address, sg->length, direction);
> +#ifdef CONFIG_NEED_SG_DMA_LENGTH
> +               sg->dma_length = sg->length;
> +#endif
> +       }
> +
> +       return nents;
> +}
> +
> +static void tile_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
> +                             int nents, enum dma_data_direction direction,
> +                             struct dma_attrs *attrs)
> +{
> +       struct scatterlist *sg;
> +       int i;
> +
> +       BUG_ON(!valid_dma_direction(direction));
> +       for_each_sg(sglist, sg, nents, i) {
> +               sg->dma_address = sg_phys(sg);
> +               __dma_complete_pa_range(sg->dma_address, sg->length,
> +                                       direction);
> +       }
> +}
> +
> +static dma_addr_t tile_dma_map_page(struct device *dev, struct page *page,
> +                                   unsigned long offset, size_t size,
> +                                   enum dma_data_direction direction,
> +                                   struct dma_attrs *attrs)
>  {
> -       dma_addr_t dma_addr = __pa(ptr);
> +       BUG_ON(!valid_dma_direction(direction));
> +
> +       BUG_ON(offset + size > PAGE_SIZE);
> +       __dma_prep_page(page, offset, size, direction);
> +
> +       return page_to_pa(page) + offset;
> +}
> +
> +static void tile_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
> +                               size_t size, enum dma_data_direction direction,
> +                               struct dma_attrs *attrs)
> +{
> +       BUG_ON(!valid_dma_direction(direction));
> +
> +       __dma_complete_page(pfn_to_page(PFN_DOWN(dma_address)),
> +                           dma_address & PAGE_OFFSET, size, direction);
> +}
>
> +static void tile_dma_sync_single_for_cpu(struct device *dev,
> +                                        dma_addr_t dma_handle,
> +                                        size_t size,
> +                                        enum dma_data_direction direction)
> +{
>        BUG_ON(!valid_dma_direction(direction));
> -       WARN_ON(size == 0);
>
> -       __dma_prep_pa_range(dma_addr, size, direction);
> +       __dma_complete_pa_range(dma_handle, size, direction);
> +}
>
> -       return dma_addr;
> +static void tile_dma_sync_single_for_device(struct device *dev,
> +                                           dma_addr_t dma_handle, size_t size,
> +                                           enum dma_data_direction direction)
> +{
> +       __dma_prep_pa_range(dma_handle, size, direction);
>  }
> -EXPORT_SYMBOL(dma_map_single);
>
> -void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
> -                     enum dma_data_direction direction)
> +static void tile_dma_sync_sg_for_cpu(struct device *dev,
> +                                    struct scatterlist *sglist, int nelems,
> +                                    enum dma_data_direction direction)
>  {
> +       struct scatterlist *sg;
> +       int i;
> +
>        BUG_ON(!valid_dma_direction(direction));
> -       __dma_complete_pa_range(dma_addr, size, direction);
> +       WARN_ON(nelems == 0 || sglist->length == 0);
> +
> +       for_each_sg(sglist, sg, nelems, i) {
> +               dma_sync_single_for_cpu(dev, sg->dma_address,
> +                                       sg_dma_len(sg), direction);
> +       }
>  }
> -EXPORT_SYMBOL(dma_unmap_single);
>
> -int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
> -              enum dma_data_direction direction)
> +static void tile_dma_sync_sg_for_device(struct device *dev,
> +                                       struct scatterlist *sglist, int nelems,
> +                                       enum dma_data_direction direction)
> +{
> +       struct scatterlist *sg;
> +       int i;
> +
> +       BUG_ON(!valid_dma_direction(direction));
> +       WARN_ON(nelems == 0 || sglist->length == 0);
> +
> +       for_each_sg(sglist, sg, nelems, i) {
> +               dma_sync_single_for_device(dev, sg->dma_address,
> +                                          sg_dma_len(sg), direction);
> +       }
> +}
> +
> +static inline int
> +tile_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> +{
> +       return 0;
> +}
> +
> +static inline int
> +tile_dma_supported(struct device *dev, u64 mask)
> +{
> +       return 1;
> +}
> +
> +static struct dma_map_ops tile_default_dma_map_ops = {
> +       .alloc = tile_dma_alloc_coherent,
> +       .free = tile_dma_free_coherent,
> +       .map_page = tile_dma_map_page,
> +       .unmap_page = tile_dma_unmap_page,
> +       .map_sg = tile_dma_map_sg,
> +       .unmap_sg = tile_dma_unmap_sg,
> +       .sync_single_for_cpu = tile_dma_sync_single_for_cpu,
> +       .sync_single_for_device = tile_dma_sync_single_for_device,
> +       .sync_sg_for_cpu = tile_dma_sync_sg_for_cpu,
> +       .sync_sg_for_device = tile_dma_sync_sg_for_device,
> +       .mapping_error = tile_dma_mapping_error,
> +       .dma_supported = tile_dma_supported
> +};
> +
> +struct dma_map_ops *tile_dma_map_ops = &tile_default_dma_map_ops;
> +EXPORT_SYMBOL(tile_dma_map_ops);
> +
> +/* Generic PCI DMA mapping functions */
> +
> +static void *tile_pci_dma_alloc_coherent(struct device *dev, size_t size,
> +                                        dma_addr_t *dma_handle, gfp_t gfp,
> +                                        struct dma_attrs *attrs)
> +{
> +       int node = dev_to_node(dev);
> +       int order = get_order(size);
> +       struct page *pg;
> +       dma_addr_t addr;
> +
> +       gfp |= __GFP_ZERO;
> +
> +       pg = homecache_alloc_pages_node(node, gfp, order, PAGE_HOME_DMA);
> +       if (pg == NULL)
> +               return NULL;
> +
> +       addr = page_to_phys(pg);
> +
> +       *dma_handle = phys_to_dma(dev, addr);
> +
> +       return page_address(pg);
> +}
> +
> +/*
> + * Free memory that was allocated with tile_pci_dma_alloc_coherent.
> + */
> +static void tile_pci_dma_free_coherent(struct device *dev, size_t size,
> +                                      void *vaddr, dma_addr_t dma_handle,
> +                                      struct dma_attrs *attrs)
> +{
> +       homecache_free_pages((unsigned long)vaddr, get_order(size));
> +}
> +
> +static int tile_pci_dma_map_sg(struct device *dev, struct scatterlist *sglist,
> +                              int nents, enum dma_data_direction direction,
> +                              struct dma_attrs *attrs)
>  {
>        struct scatterlist *sg;
>        int i;
> @@ -242,14 +386,20 @@ int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
>        for_each_sg(sglist, sg, nents, i) {
>                sg->dma_address = sg_phys(sg);
>                __dma_prep_pa_range(sg->dma_address, sg->length, direction);
> +
> +               sg->dma_address = phys_to_dma(dev, sg->dma_address);
> +#ifdef CONFIG_NEED_SG_DMA_LENGTH
> +               sg->dma_length = sg->length;
> +#endif
>        }
>
>        return nents;
>  }
> -EXPORT_SYMBOL(dma_map_sg);
>
> -void dma_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
> -                 enum dma_data_direction direction)
> +static void tile_pci_dma_unmap_sg(struct device *dev,
> +                                 struct scatterlist *sglist, int nents,
> +                                 enum dma_data_direction direction,
> +                                 struct dma_attrs *attrs)
>  {
>        struct scatterlist *sg;
>        int i;
> @@ -261,46 +411,60 @@ void dma_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
>                                        direction);
>        }
>  }
> -EXPORT_SYMBOL(dma_unmap_sg);
>
> -dma_addr_t dma_map_page(struct device *dev, struct page *page,
> -                       unsigned long offset, size_t size,
> -                       enum dma_data_direction direction)
> +static dma_addr_t tile_pci_dma_map_page(struct device *dev, struct page *page,
> +                                       unsigned long offset, size_t size,
> +                                       enum dma_data_direction direction,
> +                                       struct dma_attrs *attrs)
>  {
>        BUG_ON(!valid_dma_direction(direction));
>
>        BUG_ON(offset + size > PAGE_SIZE);
>        __dma_prep_page(page, offset, size, direction);
> -       return page_to_pa(page) + offset;
> +
> +       return phys_to_dma(dev, page_to_pa(page) + offset);
>  }
> -EXPORT_SYMBOL(dma_map_page);
>
> -void dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
> -                   enum dma_data_direction direction)
> +static void tile_pci_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
> +                                   size_t size,
> +                                   enum dma_data_direction direction,
> +                                   struct dma_attrs *attrs)
>  {
>        BUG_ON(!valid_dma_direction(direction));
> +
> +       dma_address = dma_to_phys(dev, dma_address);
> +
>        __dma_complete_page(pfn_to_page(PFN_DOWN(dma_address)),
>                            dma_address & PAGE_OFFSET, size, direction);
>  }
> -EXPORT_SYMBOL(dma_unmap_page);
>
> -void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
> -                            size_t size, enum dma_data_direction direction)
> +static void tile_pci_dma_sync_single_for_cpu(struct device *dev,
> +                                            dma_addr_t dma_handle,
> +                                            size_t size,
> +                                            enum dma_data_direction direction)
>  {
>        BUG_ON(!valid_dma_direction(direction));
> +
> +       dma_handle = dma_to_phys(dev, dma_handle);
> +
>        __dma_complete_pa_range(dma_handle, size, direction);
>  }
> -EXPORT_SYMBOL(dma_sync_single_for_cpu);
>
> -void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
> -                               size_t size, enum dma_data_direction direction)
> +static void tile_pci_dma_sync_single_for_device(struct device *dev,
> +                                               dma_addr_t dma_handle,
> +                                               size_t size,
> +                                               enum dma_data_direction
> +                                               direction)
>  {
> +       dma_handle = dma_to_phys(dev, dma_handle);
> +
>        __dma_prep_pa_range(dma_handle, size, direction);
>  }
> -EXPORT_SYMBOL(dma_sync_single_for_device);
>
> -void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sglist,
> -                        int nelems, enum dma_data_direction direction)
> +static void tile_pci_dma_sync_sg_for_cpu(struct device *dev,
> +                                        struct scatterlist *sglist,
> +                                        int nelems,
> +                                        enum dma_data_direction direction)
>  {
>        struct scatterlist *sg;
>        int i;
> @@ -313,10 +477,11 @@ void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sglist,
>                                        sg_dma_len(sg), direction);
>        }
>  }
> -EXPORT_SYMBOL(dma_sync_sg_for_cpu);
>
> -void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
> -                           int nelems, enum dma_data_direction direction)
> +static void tile_pci_dma_sync_sg_for_device(struct device *dev,
> +                                           struct scatterlist *sglist,
> +                                           int nelems,
> +                                           enum dma_data_direction direction)
>  {
>        struct scatterlist *sg;
>        int i;
> @@ -329,31 +494,93 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
>                                           sg_dma_len(sg), direction);
>        }
>  }
> -EXPORT_SYMBOL(dma_sync_sg_for_device);
>
> -void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
> -                                  unsigned long offset, size_t size,
> -                                  enum dma_data_direction direction)
> +static inline int
> +tile_pci_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>  {
> -       dma_sync_single_for_cpu(dev, dma_handle + offset, size, direction);
> +       return 0;
>  }
> -EXPORT_SYMBOL(dma_sync_single_range_for_cpu);
>
> -void dma_sync_single_range_for_device(struct device *dev,
> -                                     dma_addr_t dma_handle,
> -                                     unsigned long offset, size_t size,
> -                                     enum dma_data_direction direction)
> +static inline int
> +tile_pci_dma_supported(struct device *dev, u64 mask)
>  {
> -       dma_sync_single_for_device(dev, dma_handle + offset, size, direction);
> +       return 1;
>  }
> -EXPORT_SYMBOL(dma_sync_single_range_for_device);
>
> -/*
> - * dma_alloc_noncoherent() is #defined to return coherent memory,
> - * so there's no need to do any flushing here.
> - */
> -void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
> -                   enum dma_data_direction direction)
> +static struct dma_map_ops tile_pci_default_dma_map_ops = {
> +       .alloc = tile_pci_dma_alloc_coherent,
> +       .free = tile_pci_dma_free_coherent,
> +       .map_page = tile_pci_dma_map_page,
> +       .unmap_page = tile_pci_dma_unmap_page,
> +       .map_sg = tile_pci_dma_map_sg,
> +       .unmap_sg = tile_pci_dma_unmap_sg,
> +       .sync_single_for_cpu = tile_pci_dma_sync_single_for_cpu,
> +       .sync_single_for_device = tile_pci_dma_sync_single_for_device,
> +       .sync_sg_for_cpu = tile_pci_dma_sync_sg_for_cpu,
> +       .sync_sg_for_device = tile_pci_dma_sync_sg_for_device,
> +       .mapping_error = tile_pci_dma_mapping_error,
> +       .dma_supported = tile_pci_dma_supported
> +};
> +
> +struct dma_map_ops *gx_pci_dma_map_ops = &tile_pci_default_dma_map_ops;
> +EXPORT_SYMBOL(gx_pci_dma_map_ops);
> +
> +/* PCI DMA mapping functions for legacy PCI devices */
> +
> +#ifdef CONFIG_SWIOTLB
> +static void *tile_swiotlb_alloc_coherent(struct device *dev, size_t size,
> +                                        dma_addr_t *dma_handle, gfp_t gfp,
> +                                        struct dma_attrs *attrs)
> +{
> +       gfp |= GFP_DMA;
> +       return swiotlb_alloc_coherent(dev, size, dma_handle, gfp);
> +}
> +
> +static void tile_swiotlb_free_coherent(struct device *dev, size_t size,
> +                                      void *vaddr, dma_addr_t dma_addr,
> +                                      struct dma_attrs *attrs)
>  {
> +       swiotlb_free_coherent(dev, size, vaddr, dma_addr);
>  }
> -EXPORT_SYMBOL(dma_cache_sync);
> +
> +static struct dma_map_ops pci_swiotlb_dma_ops = {
> +       .alloc = tile_swiotlb_alloc_coherent,
> +       .free = tile_swiotlb_free_coherent,
> +       .map_page = swiotlb_map_page,
> +       .unmap_page = swiotlb_unmap_page,
> +       .map_sg = swiotlb_map_sg_attrs,
> +       .unmap_sg = swiotlb_unmap_sg_attrs,
> +       .sync_single_for_cpu = swiotlb_sync_single_for_cpu,
> +       .sync_single_for_device = swiotlb_sync_single_for_device,
> +       .sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
> +       .sync_sg_for_device = swiotlb_sync_sg_for_device,
> +       .dma_supported = swiotlb_dma_supported,
> +       .mapping_error = swiotlb_dma_mapping_error,
> +};
> +
> +struct dma_map_ops *gx_legacy_pci_dma_map_ops = &pci_swiotlb_dma_ops;
> +#else
> +struct dma_map_ops *gx_legacy_pci_dma_map_ops;
> +#endif
> +EXPORT_SYMBOL(gx_legacy_pci_dma_map_ops);
> +
> +#ifdef CONFIG_ARCH_HAS_DMA_SET_COHERENT_MASK
> +int dma_set_coherent_mask(struct device *dev, u64 mask)
> +{
> +       struct dma_map_ops *dma_ops = get_dma_ops(dev);
> +
> +       /* Handle legacy PCI devices with limited memory addressability. */
> +       if (((dma_ops == gx_pci_dma_map_ops) ||
> +           (dma_ops == gx_legacy_pci_dma_map_ops)) &&
> +           (mask <= DMA_BIT_MASK(32))) {
> +               if (mask > dev->archdata.max_direct_dma_addr)
> +                       mask = dev->archdata.max_direct_dma_addr;
> +       }
> +
> +       if (!dma_supported(dev, mask))
> +               return -EIO;
> +       dev->coherent_dma_mask = mask;
> +       return 0;
> +}
> +EXPORT_SYMBOL(dma_set_coherent_mask);
> +#endif
> diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
> index 1b996bb..27f7ab0 100644
> --- a/arch/tile/kernel/pci_gx.c
> +++ b/arch/tile/kernel/pci_gx.c
> @@ -40,22 +40,8 @@
>  #include <arch/sim.h>
>
>  /*
> - * Initialization flow and process
> - * -------------------------------
> - *
> - * This files containes the routines to search for PCI buses,
> + * This file containes the routines to search for PCI buses,
>  * enumerate the buses, and configure any attached devices.
> - *
> - * There are two entry points here:
> - * 1) tile_pci_init
> - *    This sets up the pci_controller structs, and opens the
> - *    FDs to the hypervisor.  This is called from setup_arch() early
> - *    in the boot process.
> - * 2) pcibios_init
> - *    This probes the PCI bus(es) for any attached hardware.  It's
> - *    called by subsys_initcall.  All of the real work is done by the
> - *    generic Linux PCI layer.
> - *
>  */
>
>  #define DEBUG_PCI_CFG  0
> @@ -110,6 +96,21 @@ static struct pci_ops tile_cfg_ops;
>  /* Mask of CPUs that should receive PCIe interrupts. */
>  static struct cpumask intr_cpus_map;
>
> +/* PCI I/O space support is not implemented. */
> +static struct resource pci_ioport_resource = {
> +       .name   = "PCI IO",
> +       .start  = 0,
> +       .end    = 0,
> +       .flags  = IORESOURCE_IO,
> +};

You don't need to define pci_ioport_resource at all if you don't
support I/O space.

> +
> +static struct resource pci_iomem_resource = {
> +       .name   = "PCI mem",
> +       .start  = TILE_PCI_MEM_START,
> +       .end    = TILE_PCI_MEM_END,
> +       .flags  = IORESOURCE_MEM,
> +};
> +
>  /*
>  * We don't need to worry about the alignment of resources.
>  */
> @@ -334,8 +335,6 @@ free_irqs:
>  }
>
>  /*
> - * First initialization entry point, called from setup_arch().
> - *
>  * Find valid controllers and fill in pci_controller structs for each
>  * of them.
>  *
> @@ -583,10 +582,7 @@ static int __devinit setup_pcie_rc_delay(char *str)
>  early_param("pcie_rc_delay", setup_pcie_rc_delay);
>
>  /*
> - * Second PCI initialization entry point, called by subsys_initcall.
> - *
> - * The controllers have been set up by the time we get here, by a call to
> - * tile_pci_init.
> + * PCI initialization entry point, called by subsys_initcall.
>  */
>  int __init pcibios_init(void)
>  {
> @@ -594,15 +590,13 @@ int __init pcibios_init(void)
>        LIST_HEAD(resources);
>        int i;
>
> +       tile_pci_init();
> +
>        if (num_rc_controllers == 0 && num_ep_controllers == 0)
>                return 0;
>
> -       pr_info("PCI: Probing PCI hardware\n");
> -
>        /*
>         * We loop over all the TRIO shims and set up the MMIO mappings.
> -        * This step can't be done in tile_pci_init because the MM subsystem
> -        * hasn't been initialized then.
>         */
>        for (i = 0; i < TILEGX_NUM_TRIO; i++) {
>                gxio_trio_context_t *context = &trio_contexts[i];
> @@ -645,9 +639,7 @@ int __init pcibios_init(void)
>                unsigned int class_code_revision;
>                int trio_index;
>                int mac;
> -#ifndef USE_SHARED_PCIE_CONFIG_REGION
>                int ret;
> -#endif
>
>                if (trio_context->fd < 0)
>                        continue;
> @@ -802,8 +794,6 @@ int __init pcibios_init(void)
>                        pr_err("PCI: PCI CFG PIO alloc failure for mac %d "
>                                "on TRIO %d, give up\n", mac, trio_index);
>
> -                       /* TBD: cleanup ... */
> -
>                        continue;
>                }
>
> @@ -819,8 +809,6 @@ int __init pcibios_init(void)
>                        pr_err("PCI: PCI CFG PIO init failure for mac %d "
>                                "on TRIO %d, give up\n", mac, trio_index);
>
> -                       /* TBD: cleanup ... */
> -
>                        continue;
>                }
>
> @@ -837,8 +825,6 @@ int __init pcibios_init(void)
>                        pr_err("PCI: PIO map failure for mac %d on TRIO %d\n",
>                                mac, trio_index);
>
> -                       /* TBD: cleanup ... */
> -
>                        continue;
>                }
>
> @@ -852,7 +838,14 @@ int __init pcibios_init(void)
>                        continue;
>                }
>
> -               pci_add_resource(&resources, &iomem_resource);
> +               /*
> +                * The PCI memory resource is located above the PA space.
> +                * The memory range for the PCI root bus should not overlap
> +                * with the physical RAM
> +                */
> +               pci_add_resource_offset(&resources, &iomem_resource,
> +                                       1ULL << CHIP_PA_WIDTH());

This says that your entire physical address space (currently
0x0-0xffffffff_ffffffff) is routed to the PCI bus, which is not true.
I think what you want here is pci_iomem_resource, but I'm not sure
that's set up correctly.  It should contain the CPU physical address
that are routed to the PCI bus.  Since you mention an offset, the PCI
bus addresses will "CPU physical address - offset".

I don't understand the CHIP_PA_WIDTH() usage -- that seems to be the
physical address width, but you define TILE_PCI_MEM_END as "((1ULL <<
CHIP_PA_WIDTH()) + TILE_PCI_BAR_WINDOW_TOP)", which would mean the CPU
could never generate that address.

I might understand this better if you could give a concrete example of
the CPU address range and the corresponding PCI bus address range.
For example, I have a box where CPU physical address range [mem
0xf0000000000-0xf007edfffff] is routed to PCI bus address range
[0x80000000-0xfedfffff].  In this case, the struct resource contains
0xf0000000000-0xf007edfffff, and the offset is 0xf0000000000 -
0x80000000 or 0xeff80000000.

The comments at TILE_PCI_MEM_MAP_BASE_OFFSET suggest that you have two
MMIO regions (one for bus addresses <4GB), so there should be two
resources on the list here.

The list should also include a bus number resource describing the bus
numbers claimed by the host bridge.  Since you don't have that, we'll
default to [bus 00-ff], but that's wrong if you have more than one
host bridge.

In fact, since it appears that you *do* have multiple host bridges,
the "resources" list should be constructed so it contains the bus
number and MMIO apertures for each bridge, which should be
non-overlapping.

> +
>                bus = pci_scan_root_bus(NULL, 0, controller->ops,
>                                        controller, &resources);
>                controller->root_bus = bus;
> @@ -923,11 +916,6 @@ int __init pcibios_init(void)
>                }
>
>                /*
> -                * We always assign 32-bit PCI bus BAR ranges.
> -                */
> -               BUG_ON(bus_address_hi != 0);
> -
> -               /*
>                 * Alloc a PIO region for PCI memory access for each RC port.
>                 */
>                ret = gxio_trio_alloc_pio_regions(trio_context, 1, 0, 0);
> @@ -936,8 +924,6 @@ int __init pcibios_init(void)
>                                "give up\n", controller->trio_index,
>                                controller->mac);
>
> -                       /* TBD: cleanup ... */
> -
>                        continue;
>                }
>
> @@ -950,15 +936,13 @@ int __init pcibios_init(void)
>                ret = gxio_trio_init_pio_region_aux(trio_context,
>                                                    controller->pio_mem_index,
>                                                    controller->mac,
> -                                                   bus_address_hi,
> +                                                   0,
>                                                    0);
>                if (ret < 0) {
>                        pr_err("PCI: MEM PIO init failure on TRIO %d mac %d, "
>                                "give up\n", controller->trio_index,
>                                controller->mac);
>
> -                       /* TBD: cleanup ... */
> -
>                        continue;
>                }
>
> @@ -980,8 +964,6 @@ int __init pcibios_init(void)
>                                        controller->trio_index,
>                                        controller->mac, j);
>
> -                               /* TBD: cleanup ... */
> -
>                                goto alloc_mem_map_failed;
>                        }
>
> @@ -991,9 +973,13 @@ int __init pcibios_init(void)
>                         * Initialize the Mem-Map and the I/O MMU so that all
>                         * the physical memory can be accessed by the endpoint
>                         * devices. The base bus address is set to the base CPA
> -                        * of this memory controller, so is the base VA. The
> +                        * of this memory controller plus an offset (see pci.h).
> +                        * The region's base VA is set to the base CPA. The
>                         * I/O MMU table essentially translates the CPA to
> -                        * the real PA.
> +                        * the real PA. Implicitly, for node 0, we create
> +                        * a separate Mem-Map region that serves as the inbound
> +                        * window for legacy 32-bit devices. This is a direct
> +                        * map of the low 4GB CPA space.
>                         */
>                        ret = gxio_trio_init_memory_map_mmu_aux(trio_context,
>                                controller->mem_maps[j],
> @@ -1001,7 +987,8 @@ int __init pcibios_init(void)
>                                nr_pages << PAGE_SHIFT,
>                                trio_context->asid,
>                                controller->mac,
> -                               start_pfn << PAGE_SHIFT,
> +                               (start_pfn << PAGE_SHIFT) +
> +                               TILE_PCI_MEM_MAP_BASE_OFFSET,
>                                j,
>                                GXIO_TRIO_ORDER_MODE_UNORDERED);
>                        if (ret < 0) {
> @@ -1010,11 +997,8 @@ int __init pcibios_init(void)
>                                        controller->trio_index,
>                                        controller->mac, j);
>
> -                               /* TBD: cleanup ... */
> -
>                                goto alloc_mem_map_failed;
>                        }
> -
>                        continue;
>
>  alloc_mem_map_failed:
> @@ -1028,11 +1012,19 @@ alloc_mem_map_failed:
>  subsys_initcall(pcibios_init);
>
>  /*
> - * No bus fixups needed.
> + * PCI scan code calls the arch specific pcibios_fixup_bus() each time it scans
> + * a new bridge. Called after each bus is probed, but before its children are
> + * examined.
>  */
>  void __devinit pcibios_fixup_bus(struct pci_bus *bus)
>  {
> -       /* Nothing needs to be done. */
> +       struct pci_dev *dev = bus->self;
> +
> +       if (!dev) {
> +               /* This is the root bus. */
> +               bus->resource[0] = &pci_ioport_resource;
> +               bus->resource[1] = &pci_iomem_resource;
> +       }

Please don't add this.  I'm in the process of removing
pcibios_fixup_bus() altogether.  Instead, you should put
pci_iomem_resource on a resources list and use pci_scan_root_bus().

>  }
>
>  /*
> @@ -1069,6 +1061,17 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
>        return pci_enable_resources(dev, mask);
>  }
>
> +/* Called for each device after PCI setup is done. */
> +static void __init
> +pcibios_fixup_final(struct pci_dev *pdev)
> +{
> +       set_dma_ops(&pdev->dev, gx_pci_dma_map_ops);
> +       set_dma_offset(&pdev->dev, TILE_PCI_MEM_MAP_BASE_OFFSET);
> +       pdev->dev.archdata.max_direct_dma_addr =
> +               TILE_PCI_MAX_DIRECT_DMA_ADDRESS;
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pcibios_fixup_final);
> +
>  /* Map a PCI MMIO bus address into VA space. */
>  void __iomem *ioremap(resource_size_t phys_addr, unsigned long size)
>  {
> @@ -1127,7 +1130,7 @@ got_it:
>         * We need to keep the PCI bus address's in-page offset in the VA.
>         */
>        return iorpc_ioremap(trio_fd, offset, size) +
> -                                       (phys_addr & (PAGE_SIZE - 1));
> +               (phys_addr & (PAGE_SIZE - 1));
>  }
>  EXPORT_SYMBOL(ioremap);
>
> diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
> index fdde3b6..2b8b689 100644
> --- a/arch/tile/kernel/setup.c
> +++ b/arch/tile/kernel/setup.c
> @@ -23,6 +23,7 @@
>  #include <linux/irq.h>
>  #include <linux/kexec.h>
>  #include <linux/pci.h>
> +#include <linux/swiotlb.h>
>  #include <linux/initrd.h>
>  #include <linux/io.h>
>  #include <linux/highmem.h>
> @@ -109,7 +110,7 @@ static unsigned int __initdata maxnodemem_pfn[MAX_NUMNODES] = {
>  };
>  static nodemask_t __initdata isolnodes;
>
> -#ifdef CONFIG_PCI
> +#if defined(CONFIG_PCI) && !defined(__tilegx__)
>  enum { DEFAULT_PCI_RESERVE_MB = 64 };
>  static unsigned int __initdata pci_reserve_mb = DEFAULT_PCI_RESERVE_MB;
>  unsigned long __initdata pci_reserve_start_pfn = -1U;
> @@ -160,7 +161,7 @@ static int __init setup_isolnodes(char *str)
>  }
>  early_param("isolnodes", setup_isolnodes);
>
> -#ifdef CONFIG_PCI
> +#if defined(CONFIG_PCI) && !defined(__tilegx__)
>  static int __init setup_pci_reserve(char* str)
>  {
>        unsigned long mb;
> @@ -171,7 +172,7 @@ static int __init setup_pci_reserve(char* str)
>
>        pci_reserve_mb = mb;
>        pr_info("Reserving %dMB for PCIE root complex mappings\n",
> -              pci_reserve_mb);
> +               pci_reserve_mb);
>        return 0;
>  }
>  early_param("pci_reserve", setup_pci_reserve);
> @@ -411,7 +412,7 @@ static void __init setup_memory(void)
>                        continue;
>                }
>  #endif
> -#ifdef CONFIG_PCI
> +#if defined(CONFIG_PCI) && !defined(__tilegx__)
>                /*
>                 * Blocks that overlap the pci reserved region must
>                 * have enough space to hold the maximum percpu data
> @@ -604,11 +605,9 @@ static void __init setup_bootmem_allocator_node(int i)
>        /* Free all the space back into the allocator. */
>        free_bootmem(PFN_PHYS(start), PFN_PHYS(end - start));
>
> -#if defined(CONFIG_PCI)
> +#if defined(CONFIG_PCI) && !defined(__tilegx__)
>        /*
> -        * Throw away any memory aliased by the PCI region.  FIXME: this
> -        * is a temporary hack to work around bug 10502, and needs to be
> -        * fixed properly.
> +        * Throw away any memory aliased by the PCI region.
>         */
>        if (pci_reserve_start_pfn < end && pci_reserve_end_pfn > start)
>                reserve_bootmem(PFN_PHYS(pci_reserve_start_pfn),
> @@ -1353,8 +1352,7 @@ void __init setup_arch(char **cmdline_p)
>        setup_cpu_maps();
>
>
> -#ifdef CONFIG_PCI
> -#if !defined (__tilegx__)
> +#if defined(CONFIG_PCI) && !defined(__tilegx__)
>        /*
>         * Initialize the PCI structures.  This is done before memory
>         * setup so that we know whether or not a pci_reserve region
> @@ -1362,7 +1360,6 @@ void __init setup_arch(char **cmdline_p)
>         */
>        if (tile_pci_init() == 0)
>                pci_reserve_mb = 0;
> -#endif
>
>        /* PCI systems reserve a region just below 4GB for mapping iomem. */
>        pci_reserve_end_pfn  = (1 << (32 - PAGE_SHIFT));
> @@ -1384,6 +1381,10 @@ void __init setup_arch(char **cmdline_p)
>         * any memory using the bootmem allocator.
>         */
>
> +#ifdef CONFIG_SWIOTLB
> +       swiotlb_init(0);
> +#endif
> +
>        paging_init();
>        setup_numa_mapping();
>        zone_sizes_init();
> @@ -1391,10 +1392,6 @@ void __init setup_arch(char **cmdline_p)
>        setup_cpu(1);
>        setup_clock();
>        load_hv_initrd();
> -
> -#if defined(CONFIG_PCI) && defined (__tilegx__)
> -       tile_pci_init();
> -#endif
>  }
>
>
> @@ -1538,11 +1535,11 @@ static struct resource code_resource = {
>  };
>
>  /*
> - * We reserve all resources above 4GB so that PCI won't try to put
> + * On Pro, we reserve all resources above 4GB so that PCI won't try to put
>  * mappings above 4GB; the standard allows that for some devices but
>  * the probing code trunates values to 32 bits.

I think this comment about probing code truncating values is out of
date.  Or if it's not, please point me to it so we can fix it :)

>  */
> -#ifdef CONFIG_PCI
> +#if defined(CONFIG_PCI) && !defined(__tilegx__)
>  static struct resource* __init
>  insert_non_bus_resource(void)
>  {
> @@ -1588,7 +1585,7 @@ static int __init request_standard_resources(void)
>        enum { CODE_DELTA = MEM_SV_INTRPT - PAGE_OFFSET };
>
>        iomem_resource.end = -1LL;

This patch isn't touching iomem_resource, but iomem_resource.end
*should* be set to the highest physical address your CPU can generate,
which is probably smaller than this.

> -#ifdef CONFIG_PCI
> +#if defined(CONFIG_PCI) && !defined(__tilegx__)
>        insert_non_bus_resource();
>  #endif
>
> @@ -1596,7 +1593,7 @@ static int __init request_standard_resources(void)
>                u64 start_pfn = node_start_pfn[i];
>                u64 end_pfn = node_end_pfn[i];
>
> -#ifdef CONFIG_PCI
> +#if defined(CONFIG_PCI) && !defined(__tilegx__)
>                if (start_pfn <= pci_reserve_start_pfn &&
>                    end_pfn > pci_reserve_start_pfn) {
>                        if (end_pfn > pci_reserve_end_pfn)
> --
> 1.7.10.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
