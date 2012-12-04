Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2LDPv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:51:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab2LDPvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:51:54 -0500
Message-ID: <1354636299.1809.431.camel@bling.home>
Subject: Re: [PATCH 1/2] vfio powerpc: enabled on powernv platform
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Tue, 04 Dec 2012 08:51:39 -0700
In-Reply-To: <50BDB074.1000403@ozlabs.ru>
References: <1353661396-14374-1-git-send-email-aik@ozlabs.ru>
	  <1354503178-2602-1-git-send-email-aik@ozlabs.ru>
	  <1354503178-2602-2-git-send-email-aik@ozlabs.ru>
	 <1354556112.1809.369.camel@bling.home> <50BDB074.1000403@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-04 at 19:12 +1100, Alexey Kardashevskiy wrote:
> On 04/12/12 04:35, Alex Williamson wrote:
> > On Mon, 2012-12-03 at 13:52 +1100, Alexey Kardashevskiy wrote:
> >> This patch initializes IOMMU groups based on the IOMMU
> >> configuration discovered during the PCI scan on POWERNV
> >> (POWER non virtualized) platform. The IOMMU groups are
> >> to be used later by VFIO driver (PCI pass through).
> >>
> >> It also implements an API for mapping/unmapping pages for
> >> guest PCI drivers and providing DMA window properties.
> >> This API is going to be used later by QEMU-VFIO to handle
> >> h_put_tce hypercalls from the KVM guest.
> >>
> >> Although this driver has been tested only on the POWERNV
> >> platform, it should work on any platform which supports
> >> TCE tables.
> >>
> >> To enable VFIO on POWER, enable SPAPR_TCE_IOMMU config
> >> option and configure VFIO as required.
> >>
> >> Cc: David Gibson <david@gibson.dropbear.id.au>
> >> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> >> ---
> >>   arch/powerpc/include/asm/iommu.h     |    9 ++
> >>   arch/powerpc/kernel/iommu.c          |  186 ++++++++++++++++++++++++++++++++++
> >>   arch/powerpc/platforms/powernv/pci.c |  135 ++++++++++++++++++++++++
> >>   drivers/iommu/Kconfig                |    8 ++
> >>   4 files changed, 338 insertions(+)
> >>
> >> diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
> >> index cbfe678..5c7087a 100644
> >> --- a/arch/powerpc/include/asm/iommu.h
> >> +++ b/arch/powerpc/include/asm/iommu.h
> >> @@ -76,6 +76,9 @@ struct iommu_table {
> >>   	struct iommu_pool large_pool;
> >>   	struct iommu_pool pools[IOMMU_NR_POOLS];
> >>   	unsigned long *it_map;       /* A simple allocation bitmap for now */
> >> +#ifdef CONFIG_IOMMU_API
> >> +	struct iommu_group *it_group;
> >> +#endif
> >>   };
> >>
> >>   struct scatterlist;
> >> @@ -147,5 +150,11 @@ static inline void iommu_restore(void)
> >>   }
> >>   #endif
> >>
> >> +extern long iommu_clear_tces(struct iommu_table *tbl, unsigned long entry,
> >> +		unsigned long pages);
> >> +extern long iommu_put_tces(struct iommu_table *tbl, unsigned long entry,
> >> +		uint64_t tce, enum dma_data_direction direction,
> >> +		unsigned long pages);
> >> +
> >>   #endif /* __KERNEL__ */
> >>   #endif /* _ASM_IOMMU_H */
> >> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> >> index ff5a6ce..2738aa4 100644
> >> --- a/arch/powerpc/kernel/iommu.c
> >> +++ b/arch/powerpc/kernel/iommu.c
> >> @@ -44,6 +44,7 @@
> >>   #include <asm/kdump.h>
> >>   #include <asm/fadump.h>
> >>   #include <asm/vio.h>
> >> +#include <asm/tce.h>
> >>
> >>   #define DBG(...)
> >>
> >> @@ -856,3 +857,188 @@ void iommu_free_coherent(struct iommu_table *tbl, size_t size,
> >>   		free_pages((unsigned long)vaddr, get_order(size));
> >>   	}
> >>   }
> >> +
> >> +#ifdef CONFIG_IOMMU_API
> >> +/*
> >> + * SPAPR TCE API
> >> + */
> >> +
> >> +/*
> >> + * Returns the number of used IOMMU pages (4K) within
> >> + * the same system page (4K or 64K).
> >> + * bitmap_weight is not used as it does not support bigendian maps.
> >> + */
> >> +static int syspage_weight(unsigned long *map, unsigned long entry)
> >> +{
> >> +	int ret = 0, nbits = PAGE_SIZE/IOMMU_PAGE_SIZE;
> >> +
> >> +	/* Aligns TCE entry number to system page boundary */
> >> +	entry &= PAGE_MASK >> IOMMU_PAGE_SHIFT;
> >> +
> >> +	/* Count used 4K pages */
> >> +	while (nbits--)
> >> +		ret += (test_bit(entry++, map) == 0) ? 0 : 1;
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static void tce_flush(struct iommu_table *tbl)
> >> +{
> >> +	/* Flush/invalidate TLB caches if necessary */
> >> +	if (ppc_md.tce_flush)
> >> +		ppc_md.tce_flush(tbl);
> >> +
> >> +	/* Make sure updates are seen by hardware */
> >> +	mb();
> >> +}
> >> +
> >> +/*
> >> + * iommu_clear_tces clears tces and returned the number of system pages
> >> + * which it called put_page() on
> >> + */
> >> +static long clear_tces_nolock(struct iommu_table *tbl, unsigned long entry,
> >> +		unsigned long pages)
> >> +{
> >> +	int i, retpages = 0;
> >> +	unsigned long oldtce, oldweight;
> >> +	struct page *page;
> >> +
> >> +	for (i = 0; i < pages; ++i) {
> >> +		oldtce = ppc_md.tce_get(tbl, entry + i);
> >> +		ppc_md.tce_free(tbl, entry + i, 1);
> >> +
> >> +		oldweight = syspage_weight(tbl->it_map, entry);
> >> +		__clear_bit(entry - tbl->it_offset, tbl->it_map);
> >> +
> >> +		if (!(oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)))
> >> +			continue;
> >
> > Could this happen earlier, above syspage_weight() and __clear_bit()?
> 
> 
> Want to clear it anyway if it is not cleared by some reason. Added WARN_ON.

The map shouldn't be set unless read/write is enabled, right?  It seems
like we don't have a lot of trust in this bitmap.

> >> +
> >> +		page = pfn_to_page(oldtce >> PAGE_SHIFT);
> >> +
> >> +		WARN_ON(!page);
> >> +		if (!page)
> >> +			continue;
> >> +
> >> +		if (oldtce & TCE_PCI_WRITE)
> >> +			SetPageDirty(page);
> >> +
> >> +		put_page(page);
> >> +
> >> +		/* That was the last IOMMU page within the system page */
> >> +		if ((oldweight == 1) && !syspage_weight(tbl->it_map, entry))
> >> +			++retpages;
> >
> > If you used __test_and_clear_bit() above I think you could avoid this
> > 2nd call to syspage_weight.  A minor optimization though.
> >
> >> +	}
> >> +
> >> +	return retpages;
> >> +}
> >> +
> >> +/*
> >> + * iommu_clear_tces clears tces and returned the number
> >> + / of released system pages
> >> + */
> >
> > Something bad happened to your comments here.
> >
> >> +long iommu_clear_tces(struct iommu_table *tbl, unsigned long entry,
> >> +		unsigned long pages)
> >> +{
> >> +	int ret;
> >> +	struct iommu_pool *pool = get_pool(tbl, entry);
> >> +
> >> +	spin_lock(&(pool->lock));
> >> +	ret = clear_tces_nolock(tbl, entry, pages);
> >> +	tce_flush(tbl);
> >> +	spin_unlock(&(pool->lock));
> >> +
> >> +	return ret;
> >> +}
> >> +EXPORT_SYMBOL_GPL(iommu_clear_tces);
> >> +
> >> +static int put_tce(struct iommu_table *tbl, unsigned long entry,
> >> +		uint64_t tce, enum dma_data_direction direction)
> >> +{
> >> +	int ret;
> >> +	struct page *page = NULL;
> >> +	unsigned long kva, offset, oldweight;
> >> +
> >> +	/* Map new TCE */
> >> +	offset = (tce & IOMMU_PAGE_MASK) - (tce & PAGE_MASK);
> >
> > Maybe the compiler will figure this out, but isn't this the same as tce
> > & (IOMMU_PAGE_MASK & PAGE_MASK)?
> 
> 
> it is rather (tce & (IOMMU_PAGE_MASK & ~PAGE_MASK)) but I cannot see how it 
> is simpler and I doubt that it is faster enough to notice it anyhow :)

Yes, ~PAGE_MASK.  IMHO, it's more intuitive.

> >> +	ret = get_user_pages_fast(tce & PAGE_MASK, 1,
> >> +			direction != DMA_TO_DEVICE, &page);
> >> +	if (ret < 1) {
> >
> > Probably (ret != 1) here or else we never get to your >1 case below.
> >
> >> +		printk(KERN_ERR "tce_vfio: get_user_pages_fast failed tce=%llx ioba=%lx ret=%d\n",
> >> +				tce, entry << IOMMU_PAGE_SHIFT, ret);
> >
> > Use pr_err
>  >
> >> +		if (!ret || (ret > 1))
> >
> > Then (ret >= 0) here.  Or return (ret >= 0) ? -EFAULT : ret
> >
> >> +			ret = -EFAULT;
> >> +		return ret;
> >> +	}
> >
> > You're missing the code from x86 that handles mapping mmap'd ranges.
> > This is intended to allow peer-to-peer DMA between devices.  Is that
> > intentional?
> 
> I am not following you here. What code exactly are talking about? We do not 
> track ranges at all and I do not see how it helps with p2p dma.

The code in type1 that checks PFNMAP and reserved pages that I only
sometimes remember how it works ;)  The idea there is to allow p2p dma
by inserting iommu translations for non-page backed memory, ie. the
mmap'd BARs of other devices.  It may be that the POWER topology is not
amenable to this since you have a whole PCI bus in your group and
intra-group p2p isn't iommu translated.  I'm not sure how useful it is
even on x86, but KVM device assignment does it, so I added it to type1.

> >> +
> >> +	kva = (unsigned long) page_address(page);
> >> +	kva += offset;
> >> +
> >> +	/* tce_build receives a virtual address */
> >> +	entry += tbl->it_offset; /* Offset into real TCE table */
> >
> > Here's what makes me call the entry "relative" rather than zero-based.
> 
> This is the bug actually, I overlooked it and I removed it now. Thanks for 
> being so picky :)

Ah, ok.  I'll look for it on the next round and make sure I understand
it.

> > The iova is relative to the start of dma32_window_start, ie. if the
> > window starts at bus address 512MB and I want to create a translation at
> > bus address 512MB, I pass in an iova of 0, right?  The above adds the
> > window offset.  So you've removed dma64 window, but we really need to
> > define iova better.
> 
> 
> 
> 
> >> +	ret = ppc_md.tce_build(tbl, entry, 1, kva, direction, NULL);
> >> +
> >> +	/* tce_build() only returns non-zero for transient errors */
> >> +	if (unlikely(ret)) {
> >> +		printk(KERN_ERR "tce_vfio: tce_put failed on tce=%llx ioba=%lx kva=%lx ret=%d\n",
> >> +				tce, entry << IOMMU_PAGE_SHIFT, kva, ret);
> >
> > Use pr_err
> >
> >> +		put_page(page);
> >> +		return -EIO;
> >> +	}
> >> +
> >> +	/* Calculate if new system page has been locked */
> >> +	oldweight = syspage_weight(tbl->it_map, entry);
> >> +	__set_bit(entry - tbl->it_offset, tbl->it_map);
> >> +
> >> +	return (oldweight == 0) ? 1 : 0;
> >> +}
> >> +
> >> +/*
> >> + * iommu_put_tces builds tces and returned the number of actually
> >> + * locked system pages
> >> + */
> >> +long iommu_put_tces(struct iommu_table *tbl, unsigned long entry,
> >> +		uint64_t tce, enum dma_data_direction direction,
> >> +		unsigned long pages)
> >> +{
> >> +	int i, ret = 0, retpages = 0;
> >> +	struct iommu_pool *pool = get_pool(tbl, entry);
> >> +
> >> +	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
> >> +	BUG_ON(direction == DMA_NONE);
> >
> > This doesn't seem BUG worthy, -EINVAL?  We can't assume tce_iommu_ioctl
> > will always be the only caller of this function.
> 
> 
> This is what other function does in this file.

Blech, ok.

> >> +
> >> +	spin_lock(&(pool->lock));
> >> +
> >> +	/* Check if any is in use */
> >> +	for (i = 0; i < pages; ++i) {
> >> +		unsigned long oldtce = ppc_md.tce_get(tbl, entry + i);
> >> +		if ((oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)) ||
> >> +				test_bit(entry + i, tbl->it_map)) {
> >> +			WARN_ON(test_bit(entry + i, tbl->it_map));
> >
> > The WARN_ON seems to confirm that these are redundant tests, does that
> > imply we don't trust it_map?  It would be a lot faster if we could rely
> > on it_map exclusively here.
> 
> 
> As for me, pretty minor optimization. I'm testing it now to see if I do not 
> miss bits.

It would be a lot more re-assuring if we didn't need it ;)  Thanks,

Alex

> >> +			spin_unlock(&(pool->lock));
> >> +			return -EBUSY;
> >> +		}
> >> +	}
> >> +
> >> +	/* Put tces to the table */
> >> +	for (i = 0; (i < pages) && (ret >= 0); ++i, tce += IOMMU_PAGE_SIZE) {
> >> +		ret = put_tce(tbl, entry + i, tce, direction);
> >> +		if (ret == 1)
> >> +			++retpages;
> >> +	}
> >> +
> >> +	/*
> >> +	 * If failed, release locked pages, otherwise return the number
> >> +	 * of locked system pages
> >> +	 */
> >> +	if (ret < 0)
> >> +		clear_tces_nolock(tbl, entry, i);
> >> +	else
> >> +		ret = retpages;
> >> +
> >> +	tce_flush(tbl);
> >> +	spin_unlock(&(pool->lock));
> >> +
> >> +	return ret;
> >> +}
> >> +EXPORT_SYMBOL_GPL(iommu_put_tces);
> >> +#endif /* CONFIG_IOMMU_API */
> >> diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
> >> index 05205cf..21250ef 100644
> >> --- a/arch/powerpc/platforms/powernv/pci.c
> >> +++ b/arch/powerpc/platforms/powernv/pci.c
> >> @@ -20,6 +20,7 @@
> >>   #include <linux/irq.h>
> >>   #include <linux/io.h>
> >>   #include <linux/msi.h>
> >> +#include <linux/iommu.h>
> >>
> >>   #include <asm/sections.h>
> >>   #include <asm/io.h>
> >> @@ -613,3 +614,137 @@ void __init pnv_pci_init(void)
> >>   	ppc_md.teardown_msi_irqs = pnv_teardown_msi_irqs;
> >>   #endif
> >>   }
> >> +
> >> +#ifdef CONFIG_IOMMU_API
> >> +/*
> >> + * IOMMU groups support required by VFIO
> >> + */
> >> +static int add_device(struct device *dev)
> >> +{
> >> +	struct iommu_table *tbl;
> >> +	int ret = 0;
> >> +
> >> +	if (WARN_ON(dev->iommu_group)) {
> >> +		printk(KERN_WARNING "tce_vfio: device %s is already in iommu group %d, skipping\n",
> >> +				dev_name(dev),
> >> +				iommu_group_id(dev->iommu_group));
> >
> > Use pr_warn
> >
> >> +		return -EBUSY;
> >> +	}
> >> +
> >> +	tbl = get_iommu_table_base(dev);
> >> +	if (!tbl) {
> >> +		pr_debug("tce_vfio: skipping device %s with no tbl\n",
> >> +				dev_name(dev));
> >> +		return 0;
> >> +	}
> >> +
> >> +	pr_debug("tce_vfio: adding %s to iommu group %d\n",
> >> +			dev_name(dev), iommu_group_id(tbl->it_group));
> >> +
> >> +	ret = iommu_group_add_device(tbl->it_group, dev);
> >> +	if (ret < 0)
> >> +		printk(KERN_ERR "tce_vfio: %s has not been added, ret=%d\n",
> >> +				dev_name(dev), ret);
> >
> > Use pr_err
> >
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static void del_device(struct device *dev)
> >> +{
> >> +	iommu_group_remove_device(dev);
> >> +}
> >> +
> >> +static int iommu_bus_notifier(struct notifier_block *nb,
> >> +			      unsigned long action, void *data)
> >> +{
> >> +	struct device *dev = data;
> >> +
> >> +	switch (action) {
> >> +	case BUS_NOTIFY_ADD_DEVICE:
> >> +		return add_device(dev);
> >> +	case BUS_NOTIFY_DEL_DEVICE:
> >> +		del_device(dev);
> >> +		return 0;
> >> +	default:
> >> +		return 0;
> >> +	}
> >> +}
> >> +
> >> +static struct notifier_block tce_iommu_bus_nb = {
> >> +	.notifier_call = iommu_bus_notifier,
> >> +};
> >> +
> >> +static void group_release(void *iommu_data)
> >> +{
> >> +	struct iommu_table *tbl = iommu_data;
> >> +	tbl->it_group = NULL;
> >> +}
> >> +
> >> +static int __init tce_iommu_init(void)
> >> +{
> >> +	struct pci_dev *pdev = NULL;
> >> +	struct iommu_table *tbl;
> >> +	struct iommu_group *grp;
> >> +
> >> +	/* Allocate and initialize IOMMU groups */
> >> +	for_each_pci_dev(pdev) {
> >> +		tbl = get_iommu_table_base(&pdev->dev);
> >> +		if (!tbl)
> >> +			continue;
> >> +
> >> +		/* Skip already initialized */
> >> +		if (tbl->it_group)
> >> +			continue;
> >> +
> >> +		grp = iommu_group_alloc();
> >> +		if (IS_ERR(grp)) {
> >> +			printk(KERN_INFO "tce_vfio: cannot create "
> >> +					"new IOMMU group, ret=%ld\n",
> >> +					PTR_ERR(grp));
> >
> > Use pr_info
> >
> >> +			return PTR_ERR(grp);
> >> +		}
> >> +		tbl->it_group = grp;
> >> +		iommu_group_set_iommudata(grp, tbl, group_release);
> >> +	}
> >> +
> >> +	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);
> >> +
> >> +	/* Add PCI devices to VFIO groups */
> >> +	for_each_pci_dev(pdev)
> >> +		add_device(&pdev->dev);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static void __exit tce_iommu_cleanup(void)
> >> +{
> >> +	struct pci_dev *pdev = NULL;
> >> +	struct iommu_table *tbl;
> >> +	struct iommu_group *grp = NULL;
> >> +
> >> +	bus_unregister_notifier(&pci_bus_type, &tce_iommu_bus_nb);
> >> +
> >> +	/* Delete PCI devices from VFIO groups */
> >> +	for_each_pci_dev(pdev)
> >> +		del_device(&pdev->dev);
> >> +
> >> +	/* Release VFIO groups */
> >> +	for_each_pci_dev(pdev) {
> >> +		tbl = get_iommu_table_base(&pdev->dev);
> >> +		if (!tbl)
> >> +			continue;
> >> +		grp = tbl->it_group;
> >> +
> >> +		/* Skip (already) uninitialized */
> >> +		if (!grp)
> >> +			continue;
> >> +
> >> +		/* Do actual release, group_release() is expected to work */
> >> +		iommu_group_put(grp);
> >> +		BUG_ON(tbl->it_group);
> >> +	}
> >> +}
> >> +
> >> +module_init(tce_iommu_init);
> >> +module_exit(tce_iommu_cleanup);
> >> +#endif /* CONFIG_IOMMU_API */
> >> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> >> index 9f69b56..29d11dc 100644
> >> --- a/drivers/iommu/Kconfig
> >> +++ b/drivers/iommu/Kconfig
> >> @@ -187,4 +187,12 @@ config EXYNOS_IOMMU_DEBUG
> >>
> >>   	  Say N unless you need kernel log message for IOMMU debugging
> >>
> >> +config SPAPR_TCE_IOMMU
> >> +	bool "sPAPR TCE IOMMU Support"
> >> +	depends on PPC_POWERNV
> >> +	select IOMMU_API
> >> +	help
> >> +	  Enables bits of IOMMU API required by VFIO. The iommu_ops is
> >> +	  still not implemented.
> >> +
> >>   endif # IOMMU_SUPPORT
> >
> > Thanks,
> >
> > Alex
> >
> 
> 



