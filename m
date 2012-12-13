Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2LMCpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:45:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:36107 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152Ab2LMCpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:45:50 -0500
Message-ID: <1355366373.19932.81.camel@pasglop>
Subject: Re: [PATCH] vfio powerpc: enabled on powernv platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Date: Thu, 13 Dec 2012 13:39:33 +1100
In-Reply-To: <1355355035.3224.343.camel@bling.home>
References: <1354901926.3224.96.camel@bling.home>
	 <1355315657-31153-1-git-send-email-aik@ozlabs.ru>
	 <1355355035.3224.343.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 16:30 -0700, Alex Williamson wrote:

> Locked page accounting in this version is very, very broken.  How do
> powerpc folks feel about seemingly generic kernel iommu interfaces
> messing with the current task mm?  Besides that, more problems below...

Not good at all :-)

I don't understand tho ... H_PUT_TCE calls should be in the qemu context
(or the guest) as current at the point of the call, so everything should
be accounted fine on the *current* task when those calls occur, what's
the point of the work queue Alexey ?

This code looks horribly complicated ... where does it come from ?

> > +/*
> > + * iommu_reset_table is called when it started/stopped being used.
> > + *
> > + * restore==true says to bring the iommu_table into the state as it was
> > + * before being used by VFIO.
> > + */
> > +void iommu_reset_table(struct iommu_table *tbl, bool restore)
> > +{
> > +	/* Page#0 is marked as used in iommu_init_table, so we clear it... */
> > +	if (!restore && (tbl->it_offset == 0))
> > +		clear_bit(0, tbl->it_map);
> > +
> > +	iommu_clear_tces(tbl, tbl->it_offset, tbl->it_size);
> 
> This does locked page accounting and unpins pages, even on startup when
> the pages aren't necessarily pinned or accounted against the current
> process.

Not sure what you mean Alex, and not sure either what Alexey
implementation actually does but indeed, pages inside an iommu table
that was used by the host don't have their refcount elevated by the fact
that they are there.

So when taking ownership of an iommu for vfio, you probably need to FAIL
if any page is already mapped. Only once you know the iommu is clear for
use, then you can start populating it and account for anything you put
in it (and de-account anything you remove from it when cleaning things
up).

> > +
> > +	/* ... or restore  */
> > +	if (restore && (tbl->it_offset == 0))
> > +		set_bit(0, tbl->it_map);
> > +}
> > +EXPORT_SYMBOL_GPL(iommu_reset_table);
> > +
> > +/*
> > + * Returns the number of used IOMMU pages (4K) within
> > + * the same system page (4K or 64K).
> > + *
> > + * syspage_weight_zero is optimized for expected case == 0
> > + * syspage_weight_one is optimized for expected case > 1
> > + * Other case are not used in this file.
> > + */
> > +#if PAGE_SIZE == IOMMU_PAGE_SIZE
> > +
> > +#define syspage_weight_zero(map, offset)	test_bit((map), (offset))
> > +#define syspage_weight_one(map, offset)		test_bit((map), (offset))
> > +
> > +#elif PAGE_SIZE/IOMMU_PAGE_SIZE == 16
> > +
> > +static int syspage_weight_zero(unsigned long *map, unsigned long offset)
> > +{
> > +	offset &= PAGE_MASK >> IOMMU_PAGE_SHIFT;
> > +	return 0xffffUL & (map[BIT_WORD(offset)] >>
> > +			(offset & (BITS_PER_LONG-1)));
> > +}
> 
> I would have expected these to be bools and return true if the weight
> matches the value.

What is that business anyway ? It's very obscure.

> If you replaced 0xffff above w/ this, would you need the #error below?
> 
> (1UL << (PAGE_SIZE/IOMMU_PAGE_SIZE)) - 1)
> 
> > +
> > +static int syspage_weight_one(unsigned long *map, unsigned long offset)
> > +{
> > +	int ret = 0, nbits = PAGE_SIZE/IOMMU_PAGE_SIZE;
> > +
> > +	/* Aligns TCE entry number to system page boundary */
> > +	offset &= PAGE_MASK >> IOMMU_PAGE_SHIFT;
> > +
> > +	/* Count used 4K pages */
> > +	while (nbits && (ret < 2)) {
> 
> Don't you have a ffs()?  Could also be used for _zero.  Surely there are
> some bitops helpers that could help here even on big endian.  hweight
> really doesn't work?
> 
> > +		if (test_bit(offset, map))
> > +			++ret;
> > +
> > +		--nbits;
> > +		++offset;
> > +	}
> > +
> > +	return ret;
> > +}
> > +#else
> > +#error TODO: support other page size
> > +#endif

What combinations do you support ?

> > +static void tce_flush(struct iommu_table *tbl)
> > +{
> > +	/* Flush/invalidate TLB caches if necessary */
> > +	if (ppc_md.tce_flush)
> > +		ppc_md.tce_flush(tbl);
> > +
> > +	/* Make sure updates are seen by hardware */
> > +	mb();
> > +}
>> +
> > +/*
> > + * iommu_clear_tces clears tces and returned the number of system pages
> > + * which it called put_page() on
> > + */
> > +static long clear_tces_nolock(struct iommu_table *tbl, unsigned long entry,
> > +		unsigned long pages)
> > +{
> > +	int i, retpages = 0, clr;
> > +	unsigned long oldtce, oldweight;
> > +	struct page *page;
> > +
> > +	for (i = 0; i < pages; ++i, ++entry) {
> > +		if (!test_bit(entry - tbl->it_offset, tbl->it_map))
> > +			continue;
> > +
> > +		oldtce = ppc_md.tce_get(tbl, entry);
> > +		ppc_md.tce_free(tbl, entry, 1);
> > +
> > +		oldweight = syspage_weight_one(tbl->it_map,
> > +				entry - tbl->it_offset);
> > +		clr = __test_and_clear_bit(entry - tbl->it_offset,
> > +				tbl->it_map);
> > +
> > +		if (WARN_ON(!(oldtce & (TCE_PCI_WRITE | TCE_PCI_READ))))
> > +			continue;
> > +
> > +		page = pfn_to_page(oldtce >> PAGE_SHIFT);
> > +
> > +		if (WARN_ON(!page))
> > +			continue;
> > +
> > +		if (oldtce & TCE_PCI_WRITE)
> > +			SetPageDirty(page);
> > +
> > +		put_page(page);
> > +
> > +		/* That was the last IOMMU page within the system page */
> > +		if ((oldweight == 1) && clr)
> > +			++retpages;
> > +	}
> > +
> > +	return retpages;
> > +}
> > +
> > +/*
> > + * iommu_clear_tces clears tces and returned the number
> > + * of released system pages
> > + */
> > +long iommu_clear_tces(struct iommu_table *tbl, unsigned long ioba,
> > +		unsigned long size)
> > +{
> > +	int ret;
> > +	unsigned long entry = ioba >> IOMMU_PAGE_SHIFT;
> > +	unsigned long npages = size >> IOMMU_PAGE_SHIFT;
> > +	struct iommu_pool *pool = get_pool(tbl, entry);
> > +
> > +	if ((size & ~IOMMU_PAGE_MASK) || (ioba & ~IOMMU_PAGE_MASK))
> > +		return -EINVAL;
> > +
> > +	if ((ioba + size) > ((tbl->it_offset + tbl->it_size)
> > +			<< IOMMU_PAGE_SHIFT))
> > +		return -EINVAL;
> > +
> > +	if (ioba < (tbl->it_offset << IOMMU_PAGE_SHIFT))
> > +		return -EINVAL;
> > +
> > +	spin_lock(&(pool->lock));
> > +	ret = clear_tces_nolock(tbl, entry, npages);
> > +	tce_flush(tbl);
> > +	spin_unlock(&(pool->lock));

Why are you messing with the pools and their locks ? These are only
relevant for the in-kernel use of the table. The table should be locked
out of kernel use when given to vfio (we could add a flag to make any
kernel dma mapping attempt to fail).

> > +	if (ret > 0) {
> > +		lock_acct(-ret);
> > +		return 0;
> > +	}
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(iommu_clear_tces);
> > +
> > +static int put_tce(struct iommu_table *tbl, unsigned long entry,
> > +		uint64_t tce, enum dma_data_direction direction)
> > +{
> > +	int ret;
> > +	struct page *page = NULL;
> > +	unsigned long kva, offset, oldweight;
> > +
> > +	/* Map new TCE */
> > +	offset = tce & IOMMU_PAGE_MASK & ~PAGE_MASK;
> > +	ret = get_user_pages_fast(tce & PAGE_MASK, 1,
> > +			direction != DMA_TO_DEVICE, &page);
> > +	if (ret != 1) {
> > +		pr_err("tce_vfio: get_user_pages_fast failed tce=%llx ioba=%lx ret=%d\n",
> > +				tce, entry << IOMMU_PAGE_SHIFT, ret);
> > +		return -EFAULT;
> > +	}
> > +
> > +	kva = (unsigned long) page_address(page);
> > +	kva += offset;
> > +
> > +	/* tce_build receives a virtual address */
> > +	ret = ppc_md.tce_build(tbl, entry, 1, kva, direction, NULL);
> > +
> > +	/* tce_build() only returns non-zero for transient errors */
> > +	if (unlikely(ret)) {
> > +		pr_err("tce_vfio: tce_put failed on tce=%llx ioba=%lx kva=%lx ret=%d\n",
> > +				tce, entry << IOMMU_PAGE_SHIFT, kva, ret);
> > +		put_page(page);
> > +		return -EIO;
> > +	}
> > +
> > +	/* Calculate if new system page has been locked */
> > +	oldweight = syspage_weight_zero(tbl->it_map, entry - tbl->it_offset);
> > +	__set_bit(entry - tbl->it_offset, tbl->it_map);
> > +
> > +	return (oldweight == 0) ? 1 : 0;
> > +}
> > +
> > +/*
> > + * iommu_put_tces builds tces and returned the number of actually
> > + * locked system pages
> > + */
> > +long iommu_put_tces(struct iommu_table *tbl, unsigned long ioba,
> > +		uint64_t tce, enum dma_data_direction direction,
> > +		unsigned long size)
> > +{
> > +	int i, ret = 0, retpages = 0;
> > +	unsigned long entry = ioba >> IOMMU_PAGE_SHIFT;
> > +	unsigned long npages = size >> IOMMU_PAGE_SHIFT;
> > +	struct iommu_pool *pool = get_pool(tbl, entry);
> > +	unsigned long locked, lock_limit;
> > +
> > +	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
> > +	BUG_ON(direction == DMA_NONE);
> > +
> > +	if ((size & ~IOMMU_PAGE_MASK) ||
> > +			(ioba & ~IOMMU_PAGE_MASK) ||
> > +			(tce & ~IOMMU_PAGE_MASK))
> > +		return -EINVAL;
> > +
> > +	if ((ioba + size) > ((tbl->it_offset + tbl->it_size)
> > +			 << IOMMU_PAGE_SHIFT))
> > +		return -EINVAL;
> > +
> > +	if (ioba < (tbl->it_offset << IOMMU_PAGE_SHIFT))
> > +		return -EINVAL;
> > +
> > +	/* Account for locked pages */
> > +	locked = current->mm->locked_vm +
> > +		(_ALIGN_UP(size, PAGE_SIZE) >> PAGE_SHIFT);
> 
> Looks like we just over penalize upfront and correct when mapped, that's
> better, but not great.
> 
> > +	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > +	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
> > +		pr_warn("RLIMIT_MEMLOCK (%ld) exceeded\n",
> > +				rlimit(RLIMIT_MEMLOCK));
> > +		return -ENOMEM;
> > +	}
> > +
> > +	spin_lock(&(pool->lock));
> > +
> > +	/* Check if any is in use */
> > +	for (i = 0; i < npages; ++i) {
> > +		if (test_bit(entry + i - tbl->it_offset, tbl->it_map)) {
> > +			spin_unlock(&(pool->lock));
> > +			return -EBUSY;
> > +		}
> > +	}
> > +
> > +	/* Put tces to the table */
> > +	for (i = 0; (i < npages) && (ret >= 0); ++i, tce += IOMMU_PAGE_SIZE) {
> > +		ret = put_tce(tbl, entry + i, tce, direction);
> > +		if (ret == 1)
> > +			++retpages;
> > +	}
> > +
> > +	/*
> > +	 * If failed, release locked pages, otherwise return the number
> > +	 * of locked system pages
> > +	 */
> > +	if (ret < 0) {
> > +		clear_tces_nolock(tbl, entry, i);
> > +	} else {
> > +		if (retpages)
> > +			lock_acct(retpages);
> > +		ret = 0;
> > +	}
> 
> Bug, if it fails we clear, which decrements our locked pages, but we
> haven't incremented them yet.  Thanks,
> 
> Alex
> 
> > +
> > +	tce_flush(tbl);
> > +	spin_unlock(&(pool->lock));
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(iommu_put_tces);
> > +
> > +#endif /* CONFIG_IOMMU_API */
> > diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
> > index 05205cf..1b970bf 100644
> > --- a/arch/powerpc/platforms/powernv/pci.c
> > +++ b/arch/powerpc/platforms/powernv/pci.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/irq.h>
> >  #include <linux/io.h>
> >  #include <linux/msi.h>
> > +#include <linux/iommu.h>
> >  
> >  #include <asm/sections.h>
> >  #include <asm/io.h>
> > @@ -613,3 +614,136 @@ void __init pnv_pci_init(void)
> >  	ppc_md.teardown_msi_irqs = pnv_teardown_msi_irqs;
> >  #endif
> >  }
> > +
> > +#ifdef CONFIG_IOMMU_API
> > +/*
> > + * IOMMU groups support required by VFIO
> > + */
> > +static int add_device(struct device *dev)
> > +{
> > +	struct iommu_table *tbl;
> > +	int ret = 0;
> > +
> > +	if (WARN_ON(dev->iommu_group)) {
> > +		pr_warn("tce_vfio: device %s is already in iommu group %d, skipping\n",
> > +				dev_name(dev),
> > +				iommu_group_id(dev->iommu_group));
> > +		return -EBUSY;
> > +	}
> > +
> > +	tbl = get_iommu_table_base(dev);
> > +	if (!tbl) {
> > +		pr_debug("tce_vfio: skipping device %s with no tbl\n",
> > +				dev_name(dev));
> > +		return 0;
> > +	}
> > +
> > +	pr_debug("tce_vfio: adding %s to iommu group %d\n",
> > +			dev_name(dev), iommu_group_id(tbl->it_group));
> > +
> > +	ret = iommu_group_add_device(tbl->it_group, dev);
> > +	if (ret < 0)
> > +		pr_err("tce_vfio: %s has not been added, ret=%d\n",
> > +				dev_name(dev), ret);
> > +
> > +	return ret;
> > +}
> > +
> > +static void del_device(struct device *dev)
> > +{
> > +	iommu_group_remove_device(dev);
> > +}
> > +
> > +static int iommu_bus_notifier(struct notifier_block *nb,
> > +			      unsigned long action, void *data)
> > +{
> > +	struct device *dev = data;
> > +
> > +	switch (action) {
> > +	case BUS_NOTIFY_ADD_DEVICE:
> > +		return add_device(dev);
> > +	case BUS_NOTIFY_DEL_DEVICE:
> > +		del_device(dev);
> > +		return 0;
> > +	default:
> > +		return 0;
> > +	}
> > +}
> > +
> > +static struct notifier_block tce_iommu_bus_nb = {
> > +	.notifier_call = iommu_bus_notifier,
> > +};
> > +
> > +static void group_release(void *iommu_data)
> > +{
> > +	struct iommu_table *tbl = iommu_data;
> > +	tbl->it_group = NULL;
> > +}
> > +
> > +static int __init tce_iommu_init(void)
> > +{
> > +	struct pci_dev *pdev = NULL;
> > +	struct iommu_table *tbl;
> > +	struct iommu_group *grp;
> > +
> > +	/* Allocate and initialize IOMMU groups */
> > +	for_each_pci_dev(pdev) {
> > +		tbl = get_iommu_table_base(&pdev->dev);
> > +		if (!tbl)
> > +			continue;
> > +
> > +		/* Skip already initialized */
> > +		if (tbl->it_group)
> > +			continue;
> > +
> > +		grp = iommu_group_alloc();
> > +		if (IS_ERR(grp)) {
> > +			pr_info("tce_vfio: cannot create new IOMMU group, ret=%ld\n",
> > +					PTR_ERR(grp));
> > +			return PTR_ERR(grp);
> > +		}
> > +		tbl->it_group = grp;
> > +		iommu_group_set_iommudata(grp, tbl, group_release);
> > +	}
> > +
> > +	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);
> > +
> > +	/* Add PCI devices to VFIO groups */
> > +	for_each_pci_dev(pdev)
> > +		add_device(&pdev->dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static void __exit tce_iommu_cleanup(void)
> > +{
> > +	struct pci_dev *pdev = NULL;
> > +	struct iommu_table *tbl;
> > +	struct iommu_group *grp = NULL;
> > +
> > +	bus_unregister_notifier(&pci_bus_type, &tce_iommu_bus_nb);
> > +
> > +	/* Delete PCI devices from VFIO groups */
> > +	for_each_pci_dev(pdev)
> > +		del_device(&pdev->dev);
> > +
> > +	/* Release VFIO groups */
> > +	for_each_pci_dev(pdev) {
> > +		tbl = get_iommu_table_base(&pdev->dev);
> > +		if (!tbl)
> > +			continue;
> > +		grp = tbl->it_group;
> > +
> > +		/* Skip (already) uninitialized */
> > +		if (!grp)
> > +			continue;
> > +
> > +		/* Do actual release, group_release() is expected to work */
> > +		iommu_group_put(grp);
> > +		BUG_ON(tbl->it_group);
> > +	}
> > +}
> > +
> > +module_init(tce_iommu_init);
> > +module_exit(tce_iommu_cleanup);
> > +#endif /* CONFIG_IOMMU_API */
> > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > index 9f69b56..29d11dc 100644
> > --- a/drivers/iommu/Kconfig
> > +++ b/drivers/iommu/Kconfig
> > @@ -187,4 +187,12 @@ config EXYNOS_IOMMU_DEBUG
> >  
> >  	  Say N unless you need kernel log message for IOMMU debugging
> >  
> > +config SPAPR_TCE_IOMMU
> > +	bool "sPAPR TCE IOMMU Support"
> > +	depends on PPC_POWERNV
> > +	select IOMMU_API
> > +	help
> > +	  Enables bits of IOMMU API required by VFIO. The iommu_ops is
> > +	  still not implemented.
> > +
> >  endif # IOMMU_SUPPORT
> 
> 


