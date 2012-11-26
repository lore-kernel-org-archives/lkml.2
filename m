Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2KZPI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 10:08:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab2KZPIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 10:08:54 -0500
Message-ID: <1353942518.1809.23.camel@bling.home>
Subject: Re: [PATCH] vfio powerpc: enabled and supported on powernv platform
From: Alex Williamson <alex.williamson@redhat.com>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        David Gibson <david@gibson.dropbear.id.au>
Date: Mon, 26 Nov 2012 08:08:38 -0700
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D294605@039-SN2MPN1-013.039d.mgd.msft.net>
References: <20121113033832.GW4696@truffula.fritz.box>
	 <1353372530-25205-1-git-send-email-aik@ozlabs.ru>
	 <1353435584.2234.87.camel@bling.home>
	 <C5ECD7A89D1DC44195F34B25E172658D294605@039-SN2MPN1-013.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-22 at 11:56 +0000, Sethi Varun-B16395 wrote:
> 
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Alex Williamson
> > Sent: Tuesday, November 20, 2012 11:50 PM
> > To: Alexey Kardashevskiy
> > Cc: Benjamin Herrenschmidt; Paul Mackerras; linuxppc-
> > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> > David Gibson
> > Subject: Re: [PATCH] vfio powerpc: enabled and supported on powernv
> > platform
> > 
> > On Tue, 2012-11-20 at 11:48 +1100, Alexey Kardashevskiy wrote:
> > > VFIO implements platform independent stuff such as a PCI driver, BAR
> > > access (via read/write on a file descriptor or direct mapping when
> > > possible) and IRQ signaling.
> > > The platform dependent part includes IOMMU initialization and
> > > handling.
> > >
> > > This patch initializes IOMMU groups based on the IOMMU configuration
> > > discovered during the PCI scan, only POWERNV platform is supported at
> > > the moment.
> > >
> > > Also the patch implements an VFIO-IOMMU driver which manages DMA
> > > mapping/unmapping requests coming from the client (now QEMU). It also
> > > returns a DMA window information to let the guest initialize the
> > > device tree for a guest OS properly. Although this driver has been
> > > tested only on POWERNV, it should work on any platform supporting TCE
> > > tables.
> > >
> > > To enable VFIO on POWER, enable SPAPR_TCE_IOMMU config option.
> > >
> > > Cc: David Gibson <david@gibson.dropbear.id.au>
> > > Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> > > ---
> > >  arch/powerpc/include/asm/iommu.h     |    6 +
> > >  arch/powerpc/kernel/iommu.c          |  140 +++++++++++++++++++
> > >  arch/powerpc/platforms/powernv/pci.c |  135 +++++++++++++++++++
> > >  drivers/iommu/Kconfig                |    8 ++
> > >  drivers/vfio/Kconfig                 |    6 +
> > >  drivers/vfio/Makefile                |    1 +
> > >  drivers/vfio/vfio_iommu_spapr_tce.c  |  247
> > ++++++++++++++++++++++++++++++++++
> > >  include/linux/vfio.h                 |   20 +++
> > >  8 files changed, 563 insertions(+)
> > >  create mode 100644 drivers/vfio/vfio_iommu_spapr_tce.c
> > >
> > > diff --git a/arch/powerpc/include/asm/iommu.h
> > > b/arch/powerpc/include/asm/iommu.h
> > > index cbfe678..5ba66cb 100644
> > > --- a/arch/powerpc/include/asm/iommu.h
> > > +++ b/arch/powerpc/include/asm/iommu.h
> > > @@ -64,30 +64,33 @@ struct iommu_pool {  }
> > > ____cacheline_aligned_in_smp;
> > >
> > >  struct iommu_table {
> > >  	unsigned long  it_busno;     /* Bus number this table belongs to */
> > >  	unsigned long  it_size;      /* Size of iommu table in entries */
> > >  	unsigned long  it_offset;    /* Offset into global table */
> > >  	unsigned long  it_base;      /* mapped address of tce table */
> > >  	unsigned long  it_index;     /* which iommu table this is */
> > >  	unsigned long  it_type;      /* type: PCI or Virtual Bus */
> > >  	unsigned long  it_blocksize; /* Entries in each block (cacheline)
> > */
> > >  	unsigned long  poolsize;
> > >  	unsigned long  nr_pools;
> > >  	struct iommu_pool large_pool;
> > >  	struct iommu_pool pools[IOMMU_NR_POOLS];
> > >  	unsigned long *it_map;       /* A simple allocation bitmap for now
> > */
> > > +#ifdef CONFIG_IOMMU_API
> > > +	struct iommu_group *it_group;
> > > +#endif
> > >  };
> > >
> > >  struct scatterlist;
> > >
> > >  static inline void set_iommu_table_base(struct device *dev, void
> > > *base)  {
> > >  	dev->archdata.dma_data.iommu_table_base = base;  }
> > >
> > >  static inline void *get_iommu_table_base(struct device *dev)  {
> > >  	return dev->archdata.dma_data.iommu_table_base;
> > >  }
> > >
> > >  /* Frees table for an individual device node */ @@ -135,17 +138,20 @@
> > > static inline void pci_iommu_init(void) { }  extern void
> > > alloc_dart_table(void);  #if defined(CONFIG_PPC64) &&
> > > defined(CONFIG_PM)  static inline void iommu_save(void)  {
> > >  	if (ppc_md.iommu_save)
> > >  		ppc_md.iommu_save();
> > >  }
> > >
> > >  static inline void iommu_restore(void)  {
> > >  	if (ppc_md.iommu_restore)
> > >  		ppc_md.iommu_restore();
> > >  }
> > >  #endif
> > >
> > > +extern long iommu_put_tces(struct iommu_table *tbl, unsigned long
> > entry, uint64_t tce,
> > > +		enum dma_data_direction direction, unsigned long pages);
> > > +
> > >  #endif /* __KERNEL__ */
> > >  #endif /* _ASM_IOMMU_H */
> > > diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> > > index ff5a6ce..94f614b 100644
> > > --- a/arch/powerpc/kernel/iommu.c
> > > +++ b/arch/powerpc/kernel/iommu.c
> > > @@ -32,30 +32,31 @@
> > >  #include <linux/dma-mapping.h>
> > >  #include <linux/bitmap.h>
> > >  #include <linux/iommu-helper.h>
> > >  #include <linux/crash_dump.h>
> > >  #include <linux/hash.h>
> > >  #include <linux/fault-inject.h>
> > >  #include <linux/pci.h>
> > >  #include <asm/io.h>
> > >  #include <asm/prom.h>
> > >  #include <asm/iommu.h>
> > >  #include <asm/pci-bridge.h>
> > >  #include <asm/machdep.h>
> > >  #include <asm/kdump.h>
> > >  #include <asm/fadump.h>
> > >  #include <asm/vio.h>
> > > +#include <asm/tce.h>
> > >
> > >  #define DBG(...)
> > >
> > >  static int novmerge;
> > >
> > >  static void __iommu_free(struct iommu_table *, dma_addr_t, unsigned
> > > int);
> > >
> > >  static int __init setup_iommu(char *str)  {
> > >  	if (!strcmp(str, "novmerge"))
> > >  		novmerge = 1;
> > >  	else if (!strcmp(str, "vmerge"))
> > >  		novmerge = 0;
> > >  	return 1;
> > >  }
> > > @@ -844,15 +845,154 @@ void *iommu_alloc_coherent(struct device *dev,
> > > struct iommu_table *tbl,  }
> > >
> > >  void iommu_free_coherent(struct iommu_table *tbl, size_t size,
> > >  			 void *vaddr, dma_addr_t dma_handle)  {
> > >  	if (tbl) {
> > >  		unsigned int nio_pages;
> > >
> > >  		size = PAGE_ALIGN(size);
> > >  		nio_pages = size >> IOMMU_PAGE_SHIFT;
> > >  		iommu_free(tbl, dma_handle, nio_pages);
> > >  		size = PAGE_ALIGN(size);
> > >  		free_pages((unsigned long)vaddr, get_order(size));
> > >  	}
> > >  }
> > > +
> > > +#ifdef CONFIG_IOMMU_API
> > > +/*
> > > + * SPAPR TCE API
> > > + */
> > > +static struct page *free_tce(struct iommu_table *tbl, unsigned long
> > > +entry) {
> > > +	struct page *page = NULL;
> > 
> > NULL initialization doesn't appear to be necessary
> > 
> > > +	unsigned long oldtce;
> > > +
> > > +	oldtce = ppc_md.tce_get(tbl, entry);
> > > +
> > > +	if (!(oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)))
> > > +		return NULL;
> > > +
> > > +	page = pfn_to_page(oldtce >> PAGE_SHIFT);
> > > +
> > > +	WARN_ON(!page);
> > > +	if (page && (oldtce & TCE_PCI_WRITE))
> > > +		SetPageDirty(page);
> > > +	ppc_md.tce_free(tbl, entry, 1);
> > > +
> > > +	return page;
> > > +}
> > > +
> > > +static int put_tce(struct iommu_table *tbl, unsigned long entry,
> > > +		uint64_t tce, enum dma_data_direction direction) {
> > > +	int ret;
> > > +	struct page *page = NULL;
> > > +	unsigned long kva, offset;
> > > +
> > > +	/* Map new TCE */
> > > +	offset = (tce & IOMMU_PAGE_MASK) - (tce & PAGE_MASK);
> > > +	ret = get_user_pages_fast(tce & PAGE_MASK, 1,
> > > +			direction != DMA_TO_DEVICE, &page);
> > > +	if (ret < 1) {
> > > +		printk(KERN_ERR "tce_vfio: get_user_pages_fast failed
> > tce=%llx ioba=%lx ret=%d\n",
> > > +				tce, entry << IOMMU_PAGE_SHIFT, ret);
> > > +		if (!ret)
> > > +			ret = -EFAULT;
> > 
> > Missing return ret?  Otherwise we've got some bogus uses of page below
> > and we're setting ret for no reason here.
> > 
> > > +	}
> > > +
> > > +	kva = (unsigned long) page_address(page);
> > > +	kva += offset;
> > > +
> > > +	/* tce_build receives a virtual address */
> > > +	entry += tbl->it_offset; /* Offset into real TCE table */
> > > +	ret = ppc_md.tce_build(tbl, entry, 1, kva, direction, NULL);
> > > +
> > > +	/* tce_build() only returns non-zero for transient errors */
> > > +	if (unlikely(ret)) {
> > > +		printk(KERN_ERR "tce_vfio: tce_put failed on tce=%llx
> > ioba=%lx kva=%lx ret=%d\n",
> > > +				tce, entry << IOMMU_PAGE_SHIFT, kva, ret);
> > > +		put_page(page);
> > > +		return -EIO;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static void tce_flush(struct iommu_table *tbl) {
> > > +	/* Flush/invalidate TLB caches if necessary */
> > > +	if (ppc_md.tce_flush)
> > > +		ppc_md.tce_flush(tbl);
> > > +
> > > +	/* Make sure updates are seen by hardware */
> > > +	mb();
> > > +}
> > > +
> > > +long iommu_put_tces(struct iommu_table *tbl, unsigned long entry,
> > uint64_t tce,
> > > +		enum dma_data_direction direction, unsigned long pages) {
> > > +	int i, ret = 0, pages_to_put = 0;
> > > +	struct page *page;
> > > +	struct iommu_pool *pool = get_pool(tbl, entry);
> > > +	struct page **oldpages;
> > > +	const int oldpagesnum = PAGE_SIZE/sizeof(*oldpages);
> > > +
> > > +	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
> > > +
> > > +	/* Handle a single page request without allocation
> > > +	   of pages-to-release array */
> > > +	if (pages == 1) {
> > > +		spin_lock(&(pool->lock));
> > > +		page = free_tce(tbl, entry);
> > > +
> > > +		if (direction != DMA_NONE)
> > > +			ret = put_tce(tbl, entry, tce, direction);
> > > +
> > > +		tce_flush(tbl);
> > > +
> > > +		if (page)
> > > +			put_page(page);
> > > +
> > > +		spin_unlock(&(pool->lock));
> > > +		return ret;
> > > +	}
> > > +
> > > +	/* Releasing multiple pages */
> > > +	/* Allocate an array for pages to be released after TCE table
> > > +	   is updated */
> > > +	oldpages = kmalloc(PAGE_SIZE, GFP_KERNEL);
> > > +	if (!oldpages)
> > > +		return -ENOMEM;
> > > +
> > > +	spin_lock(&(pool->lock));
> > > +
> > > +	for (i = 0; (i < pages) && !ret; ++i, ++entry, tce +=
> > IOMMU_PAGE_SIZE) {
> > > +		page = free_tce(tbl, entry);
> > > +		if (page) {
> > > +			oldpages[pages_to_put] = page;
> > > +			++pages_to_put;
> > > +		}
> > > +
> > > +		if (direction != DMA_NONE)
> > > +			ret = put_tce(tbl, entry, tce, direction);
> > > +
> > > +		/* Release old pages if we reached the end of oldpages[] or
> > > +		   it is the last page or we are about to exit the loop */
> > > +		if ((pages_to_put == oldpagesnum) || (i == pages - 1) || ret)
> > {
> > > +			tce_flush(tbl);
> > 
> > Avoiding tce_flush() is the reason for all this extra overhead, right?
> > I wonder if it'd be cleaner separating map vs unmap, where the map case
> > can avoid the oldpages array... but that means inserting new mappings on
> > top of old ones wouldn't put the pages.
> > 
> > > +
> > > +			/* Release pages after removing them from TCE table */
> > > +			while (pages_to_put) {
> > > +				--pages_to_put;
> > > +				put_page(oldpages[pages_to_put]);
> > > +			}
> > > +		}
> > > +	}
> > > +
> > > +	spin_unlock(&(pool->lock));
> > > +	kfree(oldpages);
> > > +
> > > +	return ret;
> > > +}
> > > +EXPORT_SYMBOL_GPL(iommu_put_tces);
> > > +#endif /* CONFIG_IOMMU_API */
> > > diff --git a/arch/powerpc/platforms/powernv/pci.c
> > > b/arch/powerpc/platforms/powernv/pci.c
> > > index 05205cf..676f4d9 100644
> > > --- a/arch/powerpc/platforms/powernv/pci.c
> > > +++ b/arch/powerpc/platforms/powernv/pci.c
> > > @@ -8,30 +8,31 @@
> > >   * This program is free software; you can redistribute it and/or
> > >   * modify it under the terms of the GNU General Public License
> > >   * as published by the Free Software Foundation; either version
> > >   * 2 of the License, or (at your option) any later version.
> > >   */
> > >
> > >  #include <linux/kernel.h>
> > >  #include <linux/pci.h>
> > >  #include <linux/delay.h>
> > >  #include <linux/string.h>
> > >  #include <linux/init.h>
> > >  #include <linux/bootmem.h>
> > >  #include <linux/irq.h>
> > >  #include <linux/io.h>
> > >  #include <linux/msi.h>
> > > +#include <linux/iommu.h>
> > >
> > >  #include <asm/sections.h>
> > >  #include <asm/io.h>
> > >  #include <asm/prom.h>
> > >  #include <asm/pci-bridge.h>
> > >  #include <asm/machdep.h>
> > >  #include <asm/ppc-pci.h>
> > >  #include <asm/opal.h>
> > >  #include <asm/iommu.h>
> > >  #include <asm/tce.h>
> > >  #include <asm/abs_addr.h>
> > >  #include <asm/firmware.h>
> > >
> > >  #include "powernv.h"
> > >  #include "pci.h"
> > > @@ -601,15 +602,149 @@ void __init pnv_pci_init(void)
> > >  	/* Configure IOMMU DMA hooks */
> > >  	ppc_md.pci_dma_dev_setup = pnv_pci_dma_dev_setup;
> > >  	ppc_md.tce_build = pnv_tce_build;
> > >  	ppc_md.tce_free = pnv_tce_free;
> > >  	ppc_md.tce_get = pnv_tce_get;
> > >  	ppc_md.pci_probe_mode = pnv_pci_probe_mode;
> > >  	set_pci_dma_ops(&dma_iommu_ops);
> > >
> > >  	/* Configure MSIs */
> > >  #ifdef CONFIG_PCI_MSI
> > >  	ppc_md.msi_check_device = pnv_msi_check_device;
> > >  	ppc_md.setup_msi_irqs = pnv_setup_msi_irqs;
> > >  	ppc_md.teardown_msi_irqs = pnv_teardown_msi_irqs;  #endif  }
> > > +
> > > +#ifdef CONFIG_IOMMU_API
> > > +/*
> > > + * IOMMU groups support required by VFIO  */ static int
> > > +add_device(struct device *dev) {
> > > +	struct iommu_table *tbl;
> > > +	int ret = 0;
> > > +
> > > +	if (WARN_ON(dev->iommu_group)) {
> > > +		printk(KERN_WARNING "tce_vfio: device %s is already in iommu
> > group %d, skipping\n",
> > > +				dev->kobj.name,
> > 
> > dev_name(dev)
> > 
> > > +				iommu_group_id(dev->iommu_group));
> > > +		return -EBUSY;
> > > +	}
> > > +
> > > +	tbl = get_iommu_table_base(dev);
> > > +	if (!tbl) {
> > > +		pr_debug("tce_vfio: skipping device %s with no tbl\n",
> > > +				dev->kobj.name);
> > > +		return 0;
> > > +	}
> > > +
> > > +	pr_debug("tce_vfio: adding %s to iommu group %d\n",
> > > +			dev->kobj.name, iommu_group_id(tbl->it_group));
> > > +
> > > +	ret = iommu_group_add_device(tbl->it_group, dev);
> > > +	if (ret < 0)
> > > +		printk(KERN_ERR "tce_vfio: %s has not been added, ret=%d\n",
> > > +				dev->kobj.name, ret);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static void del_device(struct device *dev) {
> > > +	iommu_group_remove_device(dev);
> > > +}
> > > +
> > > +static int iommu_bus_notifier(struct notifier_block *nb,
> > > +			      unsigned long action, void *data) {
> > > +	struct device *dev = data;
> > > +
> > > +	switch (action) {
> > > +	case BUS_NOTIFY_ADD_DEVICE:
> > > +		return add_device(dev);
> > > +	case BUS_NOTIFY_DEL_DEVICE:
> > > +		del_device(dev);
> > > +		return 0;
> > > +	default:
> > > +		return 0;
> > > +	}
> > > +}
> > > +
> > > +static struct notifier_block tce_iommu_bus_nb = {
> > > +	.notifier_call = iommu_bus_notifier, };
> > > +
> > > +static void group_release(void *iommu_data) {
> > > +	struct iommu_table *tbl = iommu_data;
> > > +	tbl->it_group = NULL;
> > > +}
> > > +
> > > +static int __init tce_iommu_init(void) {
> > > +	struct pci_dev *pdev = NULL;
> > > +	struct iommu_table *tbl;
> > > +	struct iommu_group *grp;
> > > +
> > > +	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);
> > 
> > There's already a notifier in the iommu code if you were to register an
> > iommu_ops with the add/remove_device entries.  That would allow you to
> > remove the notifier block and notifier function below and the second loop
> > below.  Are you avoiding that to avoid the rest of iommu_ops?
> > 
> [Sethi Varun-B16395] Could be one reason, also they are associating
> the iommu group with the tce table entry and not the device.

That's fine, the tce is the level they claim to have isolation.

> 
> > Also, shouldn't this notifier only be registered after the first loop
> > below?  Otherwise ADD_DEVICE could race with setting up groups, which we
> > assume are present in the add_device() above.
> [Sethi Varun-B16395] Isn't this similar to how how the notifier is
> registered in iommu_bus_init? First a notifier is registered and then
> we check for devices that have already been probed.

It's not quite the same because the existing notifier callbacks to add
devices also creates groups as necessary.  My point here was that we
register a notifier that assumes a group prior to setting up the groups.
In the existing code the order doesn't matter so much because the system
isn't susceptible to hot device adds at that point.  That's likely the
case here too, but registering a notifier before setting up the data the
callback references seems unnecessary.  Thanks,

Alex

