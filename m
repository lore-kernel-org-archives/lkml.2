Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab2LLXa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 18:30:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab2LLXa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 18:30:56 -0500
Message-ID: <1355355035.3224.343.camel@bling.home>
Subject: Re: [PATCH] vfio powerpc: enabled on powernv platform
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Date: Wed, 12 Dec 2012 16:30:35 -0700
In-Reply-To: <1355315657-31153-1-git-send-email-aik@ozlabs.ru>
References: <1354901926.3224.96.camel@bling.home>
	 <1355315657-31153-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 23:34 +1100, Alexey Kardashevskiy wrote:
> This patch initializes IOMMU groups based on the IOMMU
> configuration discovered during the PCI scan on POWERNV
> (POWER non virtualized) platform. The IOMMU groups are
> to be used later by VFIO driver (PCI pass through).
> 
> It also implements an API for mapping/unmapping pages for
> guest PCI drivers and providing DMA window properties.
> This API is going to be used later by QEMU-VFIO to handle
> h_put_tce hypercalls from the KVM guest.
> 
> Although this driver has been tested only on the POWERNV
> platform, it should work on any platform which supports
> TCE tables.
> 
> To enable VFIO on POWER, enable SPAPR_TCE_IOMMU config
> option and configure VFIO as required.
> 
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  arch/powerpc/include/asm/iommu.h     |   10 ++
>  arch/powerpc/kernel/iommu.c          |  329 ++++++++++++++++++++++++++++++++++
>  arch/powerpc/platforms/powernv/pci.c |  134 ++++++++++++++
>  drivers/iommu/Kconfig                |    8 +
>  4 files changed, 481 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
> index cbfe678..3c861ae 100644
> --- a/arch/powerpc/include/asm/iommu.h
> +++ b/arch/powerpc/include/asm/iommu.h
> @@ -76,6 +76,9 @@ struct iommu_table {
>  	struct iommu_pool large_pool;
>  	struct iommu_pool pools[IOMMU_NR_POOLS];
>  	unsigned long *it_map;       /* A simple allocation bitmap for now */
> +#ifdef CONFIG_IOMMU_API
> +	struct iommu_group *it_group;
> +#endif
>  };
>  
>  struct scatterlist;
> @@ -147,5 +150,12 @@ static inline void iommu_restore(void)
>  }
>  #endif
>  
> +extern void iommu_reset_table(struct iommu_table *tbl, bool restore);
> +extern long iommu_clear_tces(struct iommu_table *tbl, unsigned long ioba,
> +		unsigned long size);
> +extern long iommu_put_tces(struct iommu_table *tbl, unsigned long ioba,
> +		uint64_t tce, enum dma_data_direction direction,
> +		unsigned long size);
> +
>  #endif /* __KERNEL__ */
>  #endif /* _ASM_IOMMU_H */
> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> index ff5a6ce..f3bb2e7 100644
> --- a/arch/powerpc/kernel/iommu.c
> +++ b/arch/powerpc/kernel/iommu.c
> @@ -36,6 +36,7 @@
>  #include <linux/hash.h>
>  #include <linux/fault-inject.h>
>  #include <linux/pci.h>
> +#include <linux/uaccess.h>
>  #include <asm/io.h>
>  #include <asm/prom.h>
>  #include <asm/iommu.h>
> @@ -44,6 +45,7 @@
>  #include <asm/kdump.h>
>  #include <asm/fadump.h>
>  #include <asm/vio.h>
> +#include <asm/tce.h>
>  
>  #define DBG(...)
>  
> @@ -856,3 +858,330 @@ void iommu_free_coherent(struct iommu_table *tbl, size_t size,
>  		free_pages((unsigned long)vaddr, get_order(size));
>  	}
>  }
> +
> +#ifdef CONFIG_IOMMU_API
> +/*
> + * SPAPR TCE API
> + */
> +
> +struct vwork {
> +	struct mm_struct	*mm;
> +	long			npage;
> +	struct work_struct	work;
> +};
> +
> +/* delayed decrement/increment for locked_vm */
> +static void lock_acct_bg(struct work_struct *work)
> +{
> +	struct vwork *vwork = container_of(work, struct vwork, work);
> +	struct mm_struct *mm;
> +
> +	mm = vwork->mm;
> +	down_write(&mm->mmap_sem);
> +	mm->locked_vm += vwork->npage;
> +	up_write(&mm->mmap_sem);
> +	mmput(mm);
> +	kfree(vwork);
> +}
> +
> +static void lock_acct(long npage)
> +{
> +	struct vwork *vwork;
> +	struct mm_struct *mm;
> +
> +	if (!current->mm)
> +		return; /* process exited */
> +
> +	if (down_write_trylock(&current->mm->mmap_sem)) {
> +		current->mm->locked_vm += npage;
> +		up_write(&current->mm->mmap_sem);
> +		return;
> +	}
> +
> +	/*
> +	 * Couldn't get mmap_sem lock, so must setup to update
> +	 * mm->locked_vm later. If locked_vm were atomic, we
> +	 * wouldn't need this silliness
> +	 */
> +	vwork = kmalloc(sizeof(struct vwork), GFP_KERNEL);
> +	if (!vwork)
> +		return;
> +	mm = get_task_mm(current);
> +	if (!mm) {
> +		kfree(vwork);
> +		return;
> +	}
> +	INIT_WORK(&vwork->work, lock_acct_bg);
> +	vwork->mm = mm;
> +	vwork->npage = npage;
> +	schedule_work(&vwork->work);
> +}

Locked page accounting in this version is very, very broken.  How do
powerpc folks feel about seemingly generic kernel iommu interfaces
messing with the current task mm?  Besides that, more problems below...

> +
> +/*
> + * iommu_reset_table is called when it started/stopped being used.
> + *
> + * restore==true says to bring the iommu_table into the state as it was
> + * before being used by VFIO.
> + */
> +void iommu_reset_table(struct iommu_table *tbl, bool restore)
> +{
> +	/* Page#0 is marked as used in iommu_init_table, so we clear it... */
> +	if (!restore && (tbl->it_offset == 0))
> +		clear_bit(0, tbl->it_map);
> +
> +	iommu_clear_tces(tbl, tbl->it_offset, tbl->it_size);

This does locked page accounting and unpins pages, even on startup when
the pages aren't necessarily pinned or accounted against the current
process.

> +
> +	/* ... or restore  */
> +	if (restore && (tbl->it_offset == 0))
> +		set_bit(0, tbl->it_map);
> +}
> +EXPORT_SYMBOL_GPL(iommu_reset_table);
> +
> +/*
> + * Returns the number of used IOMMU pages (4K) within
> + * the same system page (4K or 64K).
> + *
> + * syspage_weight_zero is optimized for expected case == 0
> + * syspage_weight_one is optimized for expected case > 1
> + * Other case are not used in this file.
> + */
> +#if PAGE_SIZE == IOMMU_PAGE_SIZE
> +
> +#define syspage_weight_zero(map, offset)	test_bit((map), (offset))
> +#define syspage_weight_one(map, offset)		test_bit((map), (offset))
> +
> +#elif PAGE_SIZE/IOMMU_PAGE_SIZE == 16
> +
> +static int syspage_weight_zero(unsigned long *map, unsigned long offset)
> +{
> +	offset &= PAGE_MASK >> IOMMU_PAGE_SHIFT;
> +	return 0xffffUL & (map[BIT_WORD(offset)] >>
> +			(offset & (BITS_PER_LONG-1)));
> +}

I would have expected these to be bools and return true if the weight
matches the value.

If you replaced 0xffff above w/ this, would you need the #error below?

(1UL << (PAGE_SIZE/IOMMU_PAGE_SIZE)) - 1)

> +
> +static int syspage_weight_one(unsigned long *map, unsigned long offset)
> +{
> +	int ret = 0, nbits = PAGE_SIZE/IOMMU_PAGE_SIZE;
> +
> +	/* Aligns TCE entry number to system page boundary */
> +	offset &= PAGE_MASK >> IOMMU_PAGE_SHIFT;
> +
> +	/* Count used 4K pages */
> +	while (nbits && (ret < 2)) {

Don't you have a ffs()?  Could also be used for _zero.  Surely there are
some bitops helpers that could help here even on big endian.  hweight
really doesn't work?

> +		if (test_bit(offset, map))
> +			++ret;
> +
> +		--nbits;
> +		++offset;
> +	}
> +
> +	return ret;
> +}
> +#else
> +#error TODO: support other page size
> +#endif
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
> +/*
> + * iommu_clear_tces clears tces and returned the number of system pages
> + * which it called put_page() on
> + */
> +static long clear_tces_nolock(struct iommu_table *tbl, unsigned long entry,
> +		unsigned long pages)
> +{
> +	int i, retpages = 0, clr;
> +	unsigned long oldtce, oldweight;
> +	struct page *page;
> +
> +	for (i = 0; i < pages; ++i, ++entry) {
> +		if (!test_bit(entry - tbl->it_offset, tbl->it_map))
> +			continue;
> +
> +		oldtce = ppc_md.tce_get(tbl, entry);
> +		ppc_md.tce_free(tbl, entry, 1);
> +
> +		oldweight = syspage_weight_one(tbl->it_map,
> +				entry - tbl->it_offset);
> +		clr = __test_and_clear_bit(entry - tbl->it_offset,
> +				tbl->it_map);
> +
> +		if (WARN_ON(!(oldtce & (TCE_PCI_WRITE | TCE_PCI_READ))))
> +			continue;
> +
> +		page = pfn_to_page(oldtce >> PAGE_SHIFT);
> +
> +		if (WARN_ON(!page))
> +			continue;
> +
> +		if (oldtce & TCE_PCI_WRITE)
> +			SetPageDirty(page);
> +
> +		put_page(page);
> +
> +		/* That was the last IOMMU page within the system page */
> +		if ((oldweight == 1) && clr)
> +			++retpages;
> +	}
> +
> +	return retpages;
> +}
> +
> +/*
> + * iommu_clear_tces clears tces and returned the number
> + * of released system pages
> + */
> +long iommu_clear_tces(struct iommu_table *tbl, unsigned long ioba,
> +		unsigned long size)
> +{
> +	int ret;
> +	unsigned long entry = ioba >> IOMMU_PAGE_SHIFT;
> +	unsigned long npages = size >> IOMMU_PAGE_SHIFT;
> +	struct iommu_pool *pool = get_pool(tbl, entry);
> +
> +	if ((size & ~IOMMU_PAGE_MASK) || (ioba & ~IOMMU_PAGE_MASK))
> +		return -EINVAL;
> +
> +	if ((ioba + size) > ((tbl->it_offset + tbl->it_size)
> +			<< IOMMU_PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	if (ioba < (tbl->it_offset << IOMMU_PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	spin_lock(&(pool->lock));
> +	ret = clear_tces_nolock(tbl, entry, npages);
> +	tce_flush(tbl);
> +	spin_unlock(&(pool->lock));
> +
> +	if (ret > 0) {
> +		lock_acct(-ret);
> +		return 0;
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_clear_tces);
> +
> +static int put_tce(struct iommu_table *tbl, unsigned long entry,
> +		uint64_t tce, enum dma_data_direction direction)
> +{
> +	int ret;
> +	struct page *page = NULL;
> +	unsigned long kva, offset, oldweight;
> +
> +	/* Map new TCE */
> +	offset = tce & IOMMU_PAGE_MASK & ~PAGE_MASK;
> +	ret = get_user_pages_fast(tce & PAGE_MASK, 1,
> +			direction != DMA_TO_DEVICE, &page);
> +	if (ret != 1) {
> +		pr_err("tce_vfio: get_user_pages_fast failed tce=%llx ioba=%lx ret=%d\n",
> +				tce, entry << IOMMU_PAGE_SHIFT, ret);
> +		return -EFAULT;
> +	}
> +
> +	kva = (unsigned long) page_address(page);
> +	kva += offset;
> +
> +	/* tce_build receives a virtual address */
> +	ret = ppc_md.tce_build(tbl, entry, 1, kva, direction, NULL);
> +
> +	/* tce_build() only returns non-zero for transient errors */
> +	if (unlikely(ret)) {
> +		pr_err("tce_vfio: tce_put failed on tce=%llx ioba=%lx kva=%lx ret=%d\n",
> +				tce, entry << IOMMU_PAGE_SHIFT, kva, ret);
> +		put_page(page);
> +		return -EIO;
> +	}
> +
> +	/* Calculate if new system page has been locked */
> +	oldweight = syspage_weight_zero(tbl->it_map, entry - tbl->it_offset);
> +	__set_bit(entry - tbl->it_offset, tbl->it_map);
> +
> +	return (oldweight == 0) ? 1 : 0;
> +}
> +
> +/*
> + * iommu_put_tces builds tces and returned the number of actually
> + * locked system pages
> + */
> +long iommu_put_tces(struct iommu_table *tbl, unsigned long ioba,
> +		uint64_t tce, enum dma_data_direction direction,
> +		unsigned long size)
> +{
> +	int i, ret = 0, retpages = 0;
> +	unsigned long entry = ioba >> IOMMU_PAGE_SHIFT;
> +	unsigned long npages = size >> IOMMU_PAGE_SHIFT;
> +	struct iommu_pool *pool = get_pool(tbl, entry);
> +	unsigned long locked, lock_limit;
> +
> +	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
> +	BUG_ON(direction == DMA_NONE);
> +
> +	if ((size & ~IOMMU_PAGE_MASK) ||
> +			(ioba & ~IOMMU_PAGE_MASK) ||
> +			(tce & ~IOMMU_PAGE_MASK))
> +		return -EINVAL;
> +
> +	if ((ioba + size) > ((tbl->it_offset + tbl->it_size)
> +			 << IOMMU_PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	if (ioba < (tbl->it_offset << IOMMU_PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	/* Account for locked pages */
> +	locked = current->mm->locked_vm +
> +		(_ALIGN_UP(size, PAGE_SIZE) >> PAGE_SHIFT);

Looks like we just over penalize upfront and correct when mapped, that's
better, but not great.

> +	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> +	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
> +		pr_warn("RLIMIT_MEMLOCK (%ld) exceeded\n",
> +				rlimit(RLIMIT_MEMLOCK));
> +		return -ENOMEM;
> +	}
> +
> +	spin_lock(&(pool->lock));
> +
> +	/* Check if any is in use */
> +	for (i = 0; i < npages; ++i) {
> +		if (test_bit(entry + i - tbl->it_offset, tbl->it_map)) {
> +			spin_unlock(&(pool->lock));
> +			return -EBUSY;
> +		}
> +	}
> +
> +	/* Put tces to the table */
> +	for (i = 0; (i < npages) && (ret >= 0); ++i, tce += IOMMU_PAGE_SIZE) {
> +		ret = put_tce(tbl, entry + i, tce, direction);
> +		if (ret == 1)
> +			++retpages;
> +	}
> +
> +	/*
> +	 * If failed, release locked pages, otherwise return the number
> +	 * of locked system pages
> +	 */
> +	if (ret < 0) {
> +		clear_tces_nolock(tbl, entry, i);
> +	} else {
> +		if (retpages)
> +			lock_acct(retpages);
> +		ret = 0;
> +	}

Bug, if it fails we clear, which decrements our locked pages, but we
haven't incremented them yet.  Thanks,

Alex

> +
> +	tce_flush(tbl);
> +	spin_unlock(&(pool->lock));
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_put_tces);
> +
> +#endif /* CONFIG_IOMMU_API */
> diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
> index 05205cf..1b970bf 100644
> --- a/arch/powerpc/platforms/powernv/pci.c
> +++ b/arch/powerpc/platforms/powernv/pci.c
> @@ -20,6 +20,7 @@
>  #include <linux/irq.h>
>  #include <linux/io.h>
>  #include <linux/msi.h>
> +#include <linux/iommu.h>
>  
>  #include <asm/sections.h>
>  #include <asm/io.h>
> @@ -613,3 +614,136 @@ void __init pnv_pci_init(void)
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
> +		pr_warn("tce_vfio: device %s is already in iommu group %d, skipping\n",
> +				dev_name(dev),
> +				iommu_group_id(dev->iommu_group));
> +		return -EBUSY;
> +	}
> +
> +	tbl = get_iommu_table_base(dev);
> +	if (!tbl) {
> +		pr_debug("tce_vfio: skipping device %s with no tbl\n",
> +				dev_name(dev));
> +		return 0;
> +	}
> +
> +	pr_debug("tce_vfio: adding %s to iommu group %d\n",
> +			dev_name(dev), iommu_group_id(tbl->it_group));
> +
> +	ret = iommu_group_add_device(tbl->it_group, dev);
> +	if (ret < 0)
> +		pr_err("tce_vfio: %s has not been added, ret=%d\n",
> +				dev_name(dev), ret);
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
> +			pr_info("tce_vfio: cannot create new IOMMU group, ret=%ld\n",
> +					PTR_ERR(grp));
> +			return PTR_ERR(grp);
> +		}
> +		tbl->it_group = grp;
> +		iommu_group_set_iommudata(grp, tbl, group_release);
> +	}
> +
> +	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);
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
> @@ -187,4 +187,12 @@ config EXYNOS_IOMMU_DEBUG
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



