Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab2KTSUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:20:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab2KTST7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:19:59 -0500
Message-ID: <1353435584.2234.87.camel@bling.home>
Subject: Re: [PATCH] vfio powerpc: enabled and supported on powernv platform
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Date: Tue, 20 Nov 2012 11:19:44 -0700
In-Reply-To: <1353372530-25205-1-git-send-email-aik@ozlabs.ru>
References: <20121113033832.GW4696@truffula.fritz.box>
	 <1353372530-25205-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 11:48 +1100, Alexey Kardashevskiy wrote:
> VFIO implements platform independent stuff such as
> a PCI driver, BAR access (via read/write on a file descriptor
> or direct mapping when possible) and IRQ signaling.
> The platform dependent part includes IOMMU initialization
> and handling.
> 
> This patch initializes IOMMU groups based on the IOMMU
> configuration discovered during the PCI scan, only POWERNV
> platform is supported at the moment.
> 
> Also the patch implements an VFIO-IOMMU driver which
> manages DMA mapping/unmapping requests coming from
> the client (now QEMU). It also returns a DMA window
> information to let the guest initialize the device tree
> for a guest OS properly. Although this driver has been
> tested only on POWERNV, it should work on any platform
> supporting TCE tables.
> 
> To enable VFIO on POWER, enable SPAPR_TCE_IOMMU config
> option.
> 
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  arch/powerpc/include/asm/iommu.h     |    6 +
>  arch/powerpc/kernel/iommu.c          |  140 +++++++++++++++++++
>  arch/powerpc/platforms/powernv/pci.c |  135 +++++++++++++++++++
>  drivers/iommu/Kconfig                |    8 ++
>  drivers/vfio/Kconfig                 |    6 +
>  drivers/vfio/Makefile                |    1 +
>  drivers/vfio/vfio_iommu_spapr_tce.c  |  247 ++++++++++++++++++++++++++++++++++
>  include/linux/vfio.h                 |   20 +++
>  8 files changed, 563 insertions(+)
>  create mode 100644 drivers/vfio/vfio_iommu_spapr_tce.c
> 
> diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
> index cbfe678..5ba66cb 100644
> --- a/arch/powerpc/include/asm/iommu.h
> +++ b/arch/powerpc/include/asm/iommu.h
> @@ -64,30 +64,33 @@ struct iommu_pool {
>  } ____cacheline_aligned_in_smp;
>  
>  struct iommu_table {
>  	unsigned long  it_busno;     /* Bus number this table belongs to */
>  	unsigned long  it_size;      /* Size of iommu table in entries */
>  	unsigned long  it_offset;    /* Offset into global table */
>  	unsigned long  it_base;      /* mapped address of tce table */
>  	unsigned long  it_index;     /* which iommu table this is */
>  	unsigned long  it_type;      /* type: PCI or Virtual Bus */
>  	unsigned long  it_blocksize; /* Entries in each block (cacheline) */
>  	unsigned long  poolsize;
>  	unsigned long  nr_pools;
>  	struct iommu_pool large_pool;
>  	struct iommu_pool pools[IOMMU_NR_POOLS];
>  	unsigned long *it_map;       /* A simple allocation bitmap for now */
> +#ifdef CONFIG_IOMMU_API
> +	struct iommu_group *it_group;
> +#endif
>  };
>  
>  struct scatterlist;
>  
>  static inline void set_iommu_table_base(struct device *dev, void *base)
>  {
>  	dev->archdata.dma_data.iommu_table_base = base;
>  }
>  
>  static inline void *get_iommu_table_base(struct device *dev)
>  {
>  	return dev->archdata.dma_data.iommu_table_base;
>  }
>  
>  /* Frees table for an individual device node */
> @@ -135,17 +138,20 @@ static inline void pci_iommu_init(void) { }
>  extern void alloc_dart_table(void);
>  #if defined(CONFIG_PPC64) && defined(CONFIG_PM)
>  static inline void iommu_save(void)
>  {
>  	if (ppc_md.iommu_save)
>  		ppc_md.iommu_save();
>  }
>  
>  static inline void iommu_restore(void)
>  {
>  	if (ppc_md.iommu_restore)
>  		ppc_md.iommu_restore();
>  }
>  #endif
>  
> +extern long iommu_put_tces(struct iommu_table *tbl, unsigned long entry, uint64_t tce,
> +		enum dma_data_direction direction, unsigned long pages);
> +
>  #endif /* __KERNEL__ */
>  #endif /* _ASM_IOMMU_H */
> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> index ff5a6ce..94f614b 100644
> --- a/arch/powerpc/kernel/iommu.c
> +++ b/arch/powerpc/kernel/iommu.c
> @@ -32,30 +32,31 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/bitmap.h>
>  #include <linux/iommu-helper.h>
>  #include <linux/crash_dump.h>
>  #include <linux/hash.h>
>  #include <linux/fault-inject.h>
>  #include <linux/pci.h>
>  #include <asm/io.h>
>  #include <asm/prom.h>
>  #include <asm/iommu.h>
>  #include <asm/pci-bridge.h>
>  #include <asm/machdep.h>
>  #include <asm/kdump.h>
>  #include <asm/fadump.h>
>  #include <asm/vio.h>
> +#include <asm/tce.h>
>  
>  #define DBG(...)
>  
>  static int novmerge;
>  
>  static void __iommu_free(struct iommu_table *, dma_addr_t, unsigned int);
>  
>  static int __init setup_iommu(char *str)
>  {
>  	if (!strcmp(str, "novmerge"))
>  		novmerge = 1;
>  	else if (!strcmp(str, "vmerge"))
>  		novmerge = 0;
>  	return 1;
>  }
> @@ -844,15 +845,154 @@ void *iommu_alloc_coherent(struct device *dev, struct iommu_table *tbl,
>  }
>  
>  void iommu_free_coherent(struct iommu_table *tbl, size_t size,
>  			 void *vaddr, dma_addr_t dma_handle)
>  {
>  	if (tbl) {
>  		unsigned int nio_pages;
>  
>  		size = PAGE_ALIGN(size);
>  		nio_pages = size >> IOMMU_PAGE_SHIFT;
>  		iommu_free(tbl, dma_handle, nio_pages);
>  		size = PAGE_ALIGN(size);
>  		free_pages((unsigned long)vaddr, get_order(size));
>  	}
>  }
> +
> +#ifdef CONFIG_IOMMU_API
> +/*
> + * SPAPR TCE API
> + */
> +static struct page *free_tce(struct iommu_table *tbl, unsigned long entry)
> +{
> +	struct page *page = NULL;

NULL initialization doesn't appear to be necessary

> +	unsigned long oldtce;
> +
> +	oldtce = ppc_md.tce_get(tbl, entry);
> +
> +	if (!(oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)))
> +		return NULL;
> +
> +	page = pfn_to_page(oldtce >> PAGE_SHIFT);
> +
> +	WARN_ON(!page);
> +	if (page && (oldtce & TCE_PCI_WRITE))
> +		SetPageDirty(page);
> +	ppc_md.tce_free(tbl, entry, 1);
> +
> +	return page;
> +}
> +
> +static int put_tce(struct iommu_table *tbl, unsigned long entry,
> +		uint64_t tce, enum dma_data_direction direction)
> +{
> +	int ret;
> +	struct page *page = NULL;
> +	unsigned long kva, offset;
> +
> +	/* Map new TCE */
> +	offset = (tce & IOMMU_PAGE_MASK) - (tce & PAGE_MASK);
> +	ret = get_user_pages_fast(tce & PAGE_MASK, 1,
> +			direction != DMA_TO_DEVICE, &page);
> +	if (ret < 1) {
> +		printk(KERN_ERR "tce_vfio: get_user_pages_fast failed tce=%llx ioba=%lx ret=%d\n",
> +				tce, entry << IOMMU_PAGE_SHIFT, ret);
> +		if (!ret)
> +			ret = -EFAULT;

Missing return ret?  Otherwise we've got some bogus uses of page below
and we're setting ret for no reason here.

> +	}
> +
> +	kva = (unsigned long) page_address(page);
> +	kva += offset;
> +
> +	/* tce_build receives a virtual address */
> +	entry += tbl->it_offset; /* Offset into real TCE table */
> +	ret = ppc_md.tce_build(tbl, entry, 1, kva, direction, NULL);
> +
> +	/* tce_build() only returns non-zero for transient errors */
> +	if (unlikely(ret)) {
> +		printk(KERN_ERR "tce_vfio: tce_put failed on tce=%llx ioba=%lx kva=%lx ret=%d\n",
> +				tce, entry << IOMMU_PAGE_SHIFT, kva, ret);
> +		put_page(page);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static void tce_flush(struct iommu_table *tbl)
> +{
> +	/* Flush/invalidate TLB caches if necessary */
> +	if (ppc_md.tce_flush)
> +		ppc_md.tce_flush(tbl);
> +
> +	/* Make sure updates are seen by hardware */
> +	mb();
> +}
> +
> +long iommu_put_tces(struct iommu_table *tbl, unsigned long entry, uint64_t tce,
> +		enum dma_data_direction direction, unsigned long pages)
> +{
> +	int i, ret = 0, pages_to_put = 0;
> +	struct page *page;
> +	struct iommu_pool *pool = get_pool(tbl, entry);
> +	struct page **oldpages;
> +	const int oldpagesnum = PAGE_SIZE/sizeof(*oldpages);
> +
> +	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
> +
> +	/* Handle a single page request without allocation
> +	   of pages-to-release array */
> +	if (pages == 1) {
> +		spin_lock(&(pool->lock));
> +		page = free_tce(tbl, entry);
> +
> +		if (direction != DMA_NONE)
> +			ret = put_tce(tbl, entry, tce, direction);
> +
> +		tce_flush(tbl);
> +
> +		if (page)
> +			put_page(page);
> +
> +		spin_unlock(&(pool->lock));
> +		return ret;
> +	}
> +
> +	/* Releasing multiple pages */
> +	/* Allocate an array for pages to be released after TCE table
> +	   is updated */
> +	oldpages = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!oldpages)
> +		return -ENOMEM;
> +
> +	spin_lock(&(pool->lock));
> +
> +	for (i = 0; (i < pages) && !ret; ++i, ++entry, tce += IOMMU_PAGE_SIZE) {
> +		page = free_tce(tbl, entry);
> +		if (page) {
> +			oldpages[pages_to_put] = page;
> +			++pages_to_put;
> +		}
> +
> +		if (direction != DMA_NONE)
> +			ret = put_tce(tbl, entry, tce, direction);
> +
> +		/* Release old pages if we reached the end of oldpages[] or
> +		   it is the last page or we are about to exit the loop */
> +		if ((pages_to_put == oldpagesnum) || (i == pages - 1) || ret) {
> +			tce_flush(tbl);

Avoiding tce_flush() is the reason for all this extra overhead, right?
I wonder if it'd be cleaner separating map vs unmap, where the map case
can avoid the oldpages array... but that means inserting new mappings on
top of old ones wouldn't put the pages.

> +
> +			/* Release pages after removing them from TCE table */
> +			while (pages_to_put) {
> +				--pages_to_put;
> +				put_page(oldpages[pages_to_put]);
> +			}
> +		}
> +	}
> +
> +	spin_unlock(&(pool->lock));
> +	kfree(oldpages);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_put_tces);
> +#endif /* CONFIG_IOMMU_API */
> diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
> index 05205cf..676f4d9 100644
> --- a/arch/powerpc/platforms/powernv/pci.c
> +++ b/arch/powerpc/platforms/powernv/pci.c
> @@ -8,30 +8,31 @@
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License
>   * as published by the Free Software Foundation; either version
>   * 2 of the License, or (at your option) any later version.
>   */
>  
>  #include <linux/kernel.h>
>  #include <linux/pci.h>
>  #include <linux/delay.h>
>  #include <linux/string.h>
>  #include <linux/init.h>
>  #include <linux/bootmem.h>
>  #include <linux/irq.h>
>  #include <linux/io.h>
>  #include <linux/msi.h>
> +#include <linux/iommu.h>
>  
>  #include <asm/sections.h>
>  #include <asm/io.h>
>  #include <asm/prom.h>
>  #include <asm/pci-bridge.h>
>  #include <asm/machdep.h>
>  #include <asm/ppc-pci.h>
>  #include <asm/opal.h>
>  #include <asm/iommu.h>
>  #include <asm/tce.h>
>  #include <asm/abs_addr.h>
>  #include <asm/firmware.h>
>  
>  #include "powernv.h"
>  #include "pci.h"
> @@ -601,15 +602,149 @@ void __init pnv_pci_init(void)
>  	/* Configure IOMMU DMA hooks */
>  	ppc_md.pci_dma_dev_setup = pnv_pci_dma_dev_setup;
>  	ppc_md.tce_build = pnv_tce_build;
>  	ppc_md.tce_free = pnv_tce_free;
>  	ppc_md.tce_get = pnv_tce_get;
>  	ppc_md.pci_probe_mode = pnv_pci_probe_mode;
>  	set_pci_dma_ops(&dma_iommu_ops);
>  
>  	/* Configure MSIs */
>  #ifdef CONFIG_PCI_MSI
>  	ppc_md.msi_check_device = pnv_msi_check_device;
>  	ppc_md.setup_msi_irqs = pnv_setup_msi_irqs;
>  	ppc_md.teardown_msi_irqs = pnv_teardown_msi_irqs;
>  #endif
>  }
> +
> +#ifdef CONFIG_IOMMU_API
> +/*
> + * IOMMU groups support required by VFIO
> + */
> +static int add_device(struct device *dev)
> +{
> +	struct iommu_table *tbl;
> +	int ret = 0;
> +
> +	if (WARN_ON(dev->iommu_group)) {
> +		printk(KERN_WARNING "tce_vfio: device %s is already in iommu group %d, skipping\n",
> +				dev->kobj.name,

dev_name(dev)

> +				iommu_group_id(dev->iommu_group));
> +		return -EBUSY;
> +	}
> +
> +	tbl = get_iommu_table_base(dev);
> +	if (!tbl) {
> +		pr_debug("tce_vfio: skipping device %s with no tbl\n",
> +				dev->kobj.name);
> +		return 0;
> +	}
> +
> +	pr_debug("tce_vfio: adding %s to iommu group %d\n",
> +			dev->kobj.name, iommu_group_id(tbl->it_group));
> +
> +	ret = iommu_group_add_device(tbl->it_group, dev);
> +	if (ret < 0)
> +		printk(KERN_ERR "tce_vfio: %s has not been added, ret=%d\n",
> +				dev->kobj.name, ret);
> +
> +	return ret;
> +}
> +
> +static void del_device(struct device *dev)
> +{
> +	iommu_group_remove_device(dev);
> +}
> +
> +static int iommu_bus_notifier(struct notifier_block *nb,
> +			      unsigned long action, void *data)
> +{
> +	struct device *dev = data;
> +
> +	switch (action) {
> +	case BUS_NOTIFY_ADD_DEVICE:
> +		return add_device(dev);
> +	case BUS_NOTIFY_DEL_DEVICE:
> +		del_device(dev);
> +		return 0;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static struct notifier_block tce_iommu_bus_nb = {
> +	.notifier_call = iommu_bus_notifier,
> +};
> +
> +static void group_release(void *iommu_data)
> +{
> +	struct iommu_table *tbl = iommu_data;
> +	tbl->it_group = NULL;
> +}
> +
> +static int __init tce_iommu_init(void)
> +{
> +	struct pci_dev *pdev = NULL;
> +	struct iommu_table *tbl;
> +	struct iommu_group *grp;
> +
> +	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);

There's already a notifier in the iommu code if you were to register an
iommu_ops with the add/remove_device entries.  That would allow you to
remove the notifier block and notifier function below and the second
loop below.  Are you avoiding that to avoid the rest of iommu_ops?

Also, shouldn't this notifier only be registered after the first loop
below?  Otherwise ADD_DEVICE could race with setting up groups, which we
assume are present in the add_device() above.

> +
> +	/* Allocate and initialize IOMMU groups */
> +	for_each_pci_dev(pdev) {
> +		tbl = get_iommu_table_base(&pdev->dev);
> +		if (!tbl)
> +			continue;
> +
> +		/* Skip already initialized */
> +		if (tbl->it_group)
> +			continue;
> +
> +		grp = iommu_group_alloc();
> +		if (IS_ERR(grp)) {
> +			printk(KERN_INFO "tce_vfio: cannot create "
> +					"new IOMMU group, ret=%ld\n",
> +					PTR_ERR(grp));
> +			return PTR_ERR(grp);
> +		}
> +		tbl->it_group = grp;
> +		iommu_group_set_iommudata(grp, tbl, group_release);
> +	}
> +
> +	/* Add PCI devices to VFIO groups */
> +	for_each_pci_dev(pdev)
> +		add_device(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +static void __exit tce_iommu_cleanup(void)
> +{
> +	struct pci_dev *pdev = NULL;
> +	struct iommu_table *tbl;
> +	struct iommu_group *grp = NULL;
> +
> +	bus_unregister_notifier(&pci_bus_type, &tce_iommu_bus_nb);
> +
> +	/* Delete PCI devices from VFIO groups */
> +	for_each_pci_dev(pdev)
> +		del_device(&pdev->dev);
> +
> +	/* Release VFIO groups */
> +	for_each_pci_dev(pdev) {
> +		tbl = get_iommu_table_base(&pdev->dev);
> +		if (!tbl)
> +			continue;
> +		grp = tbl->it_group;
> +
> +		/* Skip (already) uninitialized */
> +		if (!grp)
> +			continue;
> +
> +		/* Do actual release, group_release() is expected to work */
> +		iommu_group_put(grp);
> +		BUG_ON(tbl->it_group);
> +	}
> +}
> +
> +module_init(tce_iommu_init);
> +module_exit(tce_iommu_cleanup);
> +#endif /* CONFIG_IOMMU_API */
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 9f69b56..29d11dc 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -175,16 +175,24 @@ config EXYNOS_IOMMU
>  	  processor family. This enables H/W multimedia accellerators to see
>  	  non-linear physical memory chunks as a linear memory in their
>  	  address spaces
>  
>  	  If unsure, say N here.
>  
>  config EXYNOS_IOMMU_DEBUG
>  	bool "Debugging log for Exynos IOMMU"
>  	depends on EXYNOS_IOMMU
>  	help
>  	  Select this to see the detailed log message that shows what
>  	  happens in the IOMMU driver
>  
>  	  Say N unless you need kernel log message for IOMMU debugging
>  
> +config SPAPR_TCE_IOMMU
> +	bool "sPAPR TCE IOMMU Support"
> +	depends on PPC_POWERNV
> +	select IOMMU_API
> +	help
> +	  Enables bits of IOMMU API required by VFIO. The iommu_ops is
> +	  still not implemented.
> +
>  endif # IOMMU_SUPPORT

How are you planning to split this up among maintainers?  A powerpc
patch, an iommu kconfig patch, then the vfio changes below for me?

> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 7cd5dec..b464687 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -1,16 +1,22 @@
>  config VFIO_IOMMU_TYPE1
>  	tristate
>  	depends on VFIO
>  	default n
>  
> +config VFIO_IOMMU_SPAPR_TCE
> +	tristate
> +	depends on VFIO && SPAPR_TCE_IOMMU
> +	default n
> +
>  menuconfig VFIO
>  	tristate "VFIO Non-Privileged userspace driver framework"
>  	depends on IOMMU_API
>  	select VFIO_IOMMU_TYPE1 if X86
> +	select VFIO_IOMMU_SPAPR_TCE if PPC_POWERNV
>  	help
>  	  VFIO provides a framework for secure userspace device drivers.
>  	  See Documentation/vfio.txt for more details.
>  
>  	  If you don't know what to do here, say N.
>  
>  source "drivers/vfio/pci/Kconfig"
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 2398d4a..72bfabc 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -1,3 +1,4 @@
>  obj-$(CONFIG_VFIO) += vfio.o
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> +obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>  obj-$(CONFIG_VFIO_PCI) += pci/
> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
> new file mode 100644
> index 0000000..ac72c74d
> --- /dev/null
> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> @@ -0,0 +1,247 @@
> +/*
> + * VFIO: IOMMU DMA mapping support for TCE on POWER
> + *
> + * Copyright (C) 2012 IBM Corp.  All rights reserved.
> + *     Author: Alexey Kardashevskiy <aik@ozlabs.ru>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Derived from original vfio_iommu_type1.c:
> + * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
> + *     Author: Alex Williamson <alex.williamson@redhat.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <linux/err.h>
> +#include <linux/vfio.h>
> +#include <asm/iommu.h>
> +
> +#define DRIVER_VERSION  "0.1"
> +#define DRIVER_AUTHOR   "aik@ozlabs.ru"
> +#define DRIVER_DESC     "VFIO IOMMU SPAPR TCE"
> +
> +static void tce_iommu_detach_group(void *iommu_data,
> +		struct iommu_group *iommu_group);
> +
> +/*
> + * VFIO IOMMU fd for SPAPR_TCE IOMMU implementation
> + */
> +
> +/*
> + * The container descriptor supports only a single group per container.
> + * Required by the API as the container is not supplied with the IOMMU group
> + * at the moment of initialization.
> + */
> +struct tce_container {
> +	struct mutex lock;
> +	struct iommu_table *tbl;
> +};
> +
> +static void *tce_iommu_open(unsigned long arg)
> +{
> +	struct tce_container *container;
> +
> +	if (arg != VFIO_SPAPR_TCE_IOMMU) {
> +		printk(KERN_ERR "tce_vfio: Wrong IOMMU type\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	container = kzalloc(sizeof(*container), GFP_KERNEL);
> +	if (!container)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mutex_init(&container->lock);
> +
> +	return container;
> +}
> +
> +static void tce_iommu_release(void *iommu_data)
> +{
> +	struct tce_container *container = iommu_data;
> +
> +	WARN_ON(container->tbl && !container->tbl->it_group);
> +	if (container->tbl && container->tbl->it_group)
> +		tce_iommu_detach_group(iommu_data, container->tbl->it_group);
> +
> +	mutex_destroy(&container->lock);
> +
> +	kfree(container);
> +}
> +
> +static long tce_iommu_ioctl(void *iommu_data,
> +				 unsigned int cmd, unsigned long arg)
> +{
> +	struct tce_container *container = iommu_data;
> +	unsigned long minsz;
> +
> +	switch (cmd) {
> +	case VFIO_CHECK_EXTENSION: {
> +		return (arg == VFIO_SPAPR_TCE_IOMMU) ? 1 : 0;
> +	}
> +	case VFIO_IOMMU_SPAPR_TCE_GET_INFO: {
> +		struct vfio_iommu_spapr_tce_info info;
> +		struct iommu_table *tbl = container->tbl;
> +
> +		if (WARN_ON(!tbl))
> +			return -ENXIO;
> +
> +		minsz = offsetofend(struct vfio_iommu_spapr_tce_info,
> +				dma64_window_size);
> +
> +		if (copy_from_user(&info, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (info.argsz < minsz)
> +			return -EINVAL;
> +
> +		info.dma32_window_start = tbl->it_offset << IOMMU_PAGE_SHIFT;
> +		info.dma32_window_size = tbl->it_size << IOMMU_PAGE_SHIFT;
> +		info.dma64_window_start = 0;
> +		info.dma64_window_size = 0;
> +		info.flags = 0;
> +
> +		if (copy_to_user((void __user *)arg, &info, minsz))
> +			return -EFAULT;
> +
> +		return 0;
> +	}
> +	case VFIO_IOMMU_MAP_DMA: {
> +		vfio_iommu_spapr_tce_dma_map par;

What does "par" stand for?

> +		struct iommu_table *tbl = container->tbl;
> +		enum dma_data_direction direction = DMA_NONE;
> +
> +		if (WARN_ON(!tbl))
> +			return -ENXIO;
> +
> +		minsz = offsetofend(vfio_iommu_spapr_tce_dma_map, size);
> +
> +		if (copy_from_user(&par, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (par.argsz < minsz)
> +			return -EINVAL;
> +
> +		if ((par.flags & VFIO_DMA_MAP_FLAG_READ) &&
> +				(par.flags & VFIO_DMA_MAP_FLAG_WRITE)) {
> +			direction = DMA_BIDIRECTIONAL;
> +		} else if (par.flags & VFIO_DMA_MAP_FLAG_READ) {
> +			direction = DMA_TO_DEVICE;
> +		} else if (par.flags & VFIO_DMA_MAP_FLAG_WRITE) {
> +			direction = DMA_FROM_DEVICE;
> +		}
> +
> +		par.size += par.iova & ~IOMMU_PAGE_MASK;
> +		par.size = _ALIGN_UP(par.size, IOMMU_PAGE_SIZE);
> +
> +		return iommu_put_tces(tbl, par.iova >> IOMMU_PAGE_SHIFT,
> +				par.vaddr & IOMMU_PAGE_MASK, direction,
> +				par.size >> IOMMU_PAGE_SHIFT);
> +	}
> +	case VFIO_IOMMU_UNMAP_DMA: {
> +		vfio_iommu_spapr_tce_dma_unmap par;
> +		struct iommu_table *tbl = container->tbl;
> +
> +		if (WARN_ON(!tbl))
> +			return -ENXIO;
> +
> +		minsz = offsetofend(vfio_iommu_spapr_tce_dma_unmap, size);
> +
> +		if (copy_from_user(&par, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (par.argsz < minsz)
> +			return -EINVAL;
> +
> +		par.size += par.iova & ~IOMMU_PAGE_MASK;
> +		par.size = _ALIGN_UP(par.size, IOMMU_PAGE_SIZE);
> +
> +		return iommu_put_tces(tbl, par.iova >> IOMMU_PAGE_SHIFT,
> +				0, DMA_NONE, par.size >> IOMMU_PAGE_SHIFT);
> +	}
> +	default:
> +		printk(KERN_WARNING "tce_vfio: unexpected cmd %x\n", cmd);
> +	}
> +
> +	return -ENOTTY;
> +}
> +
> +static int tce_iommu_attach_group(void *iommu_data,
> +		struct iommu_group *iommu_group)
> +{
> +	struct tce_container *container = iommu_data;
> +	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
> +
> +	BUG_ON(!tbl);
> +	mutex_lock(&container->lock);
> +	pr_debug("tce_vfio: Attaching group #%u to iommu %p\n",
> +			iommu_group_id(iommu_group), iommu_group);
> +	if (container->tbl) {
> +		printk(KERN_WARNING "tce_vfio: Only one group per IOMMU container is allowed, existing id=%d, attaching id=%d\n",
> +				iommu_group_id(container->tbl->it_group),
> +				iommu_group_id(iommu_group));
> +		mutex_unlock(&container->lock);
> +		return -EBUSY;
> +	}
> +
> +	container->tbl = tbl;
> +	mutex_unlock(&container->lock);
> +
> +	return 0;
> +}
> +
> +static void tce_iommu_detach_group(void *iommu_data,
> +		struct iommu_group *iommu_group)
> +{
> +	struct tce_container *container = iommu_data;
> +	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
> +
> +	BUG_ON(!tbl);
> +	mutex_lock(&container->lock);
> +	if (tbl != container->tbl) {
> +		printk(KERN_WARNING "tce_vfio: detaching group #%u, expected group is #%u\n",
> +				iommu_group_id(iommu_group),
> +				iommu_group_id(tbl->it_group));
> +	} else {
> +
> +		pr_debug("tce_vfio: detaching group #%u from iommu %p\n",
> +				iommu_group_id(iommu_group), iommu_group);
> +
> +		iommu_put_tces(tbl, tbl->it_offset, 0, DMA_NONE, tbl->it_size);
> +		container->tbl = NULL;
> +	}
> +	mutex_unlock(&container->lock);
> +}
> +
> +const struct vfio_iommu_driver_ops tce_iommu_driver_ops = {
> +	.name		= "iommu-vfio-powerpc",
> +	.owner		= THIS_MODULE,
> +	.open		= tce_iommu_open,
> +	.release	= tce_iommu_release,
> +	.ioctl		= tce_iommu_ioctl,
> +	.attach_group	= tce_iommu_attach_group,
> +	.detach_group	= tce_iommu_detach_group,
> +};
> +
> +static int __init tce_iommu_init(void)
> +{
> +	return vfio_register_iommu_driver(&tce_iommu_driver_ops);
> +}
> +
> +static void __exit tce_iommu_cleanup(void)
> +{
> +	vfio_unregister_iommu_driver(&tce_iommu_driver_ops);
> +}
> +
> +module_init(tce_iommu_init);
> +module_exit(tce_iommu_cleanup);
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 0a4f180..3ecd65c 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -87,30 +87,31 @@ extern void vfio_unregister_iommu_driver(
>   * Simple helper macro for dealing with variable sized structures passed
>   * from user space.  This allows us to easily determine if the provided
>   * structure is sized to include various fields.
>   */
>  #define offsetofend(TYPE, MEMBER) ({				\
>  	TYPE tmp;						\
>  	offsetof(TYPE, MEMBER) + sizeof(tmp.MEMBER); })		\
>  
>  #endif /* __KERNEL__ */
>  
>  /* Kernel & User level defines for VFIO IOCTLs. */
>  
>  /* Extensions */
>  
>  #define VFIO_TYPE1_IOMMU		1
> +#define VFIO_SPAPR_TCE_IOMMU		2
>  
>  /*
>   * The IOCTL interface is designed for extensibility by embedding the
>   * structure length (argsz) and flags into structures passed between
>   * kernel and userspace.  We therefore use the _IO() macro for these
>   * defines to avoid implicitly embedding a size into the ioctl request.
>   * As structure fields are added, argsz will increase to match and flag
>   * bits will be defined to indicate additional fields with valid data.
>   * It's *always* the caller's responsibility to indicate the size of
>   * the structure passed by setting argsz appropriately.
>   */
>  
>  #define VFIO_TYPE	(';')
>  #define VFIO_BASE	100
>  
> @@ -430,16 +431,35 @@ struct vfio_iommu_type1_dma_map {
>  /**
>   * VFIO_IOMMU_UNMAP_DMA - _IOW(VFIO_TYPE, VFIO_BASE + 14, struct vfio_dma_unmap)
>   *
>   * Unmap IO virtual addresses using the provided struct vfio_dma_unmap.
>   * Caller sets argsz.
>   */
>  struct vfio_iommu_type1_dma_unmap {
>  	__u32	argsz;
>  	__u32	flags;
>  	__u64	iova;				/* IO virtual address */
>  	__u64	size;				/* Size of mapping (bytes) */
>  };
>  
>  #define VFIO_IOMMU_UNMAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 14)
>  
> +/* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
> +
> +struct vfio_iommu_spapr_tce_info {
> +	__u32 argsz;
> +	__u32 flags;
> +	__u32 dma32_window_start;
> +	__u32 dma32_window_size;
> +	__u64 dma64_window_start;
> +	__u64 dma64_window_size;
> +};
> +
> +#define VFIO_IOMMU_SPAPR_TCE_GET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
> +
> +/* Reuse type1 map/unmap structs as they are the same at the moment */
> +typedef struct vfio_iommu_type1_dma_map vfio_iommu_spapr_tce_dma_map;
> +typedef struct vfio_iommu_type1_dma_unmap vfio_iommu_spapr_tce_dma_unmap;
> +
> +/* ***************************************************************** */
> +
>  #endif /* VFIO_H */

I'm glad you were able to reuse these, after this gets merged we can
rename the structure to something more common and typedef for both type1
and spapr_tce so we don't forget it's shared.  Thanks,

Alex

