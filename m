Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2EYBly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 21:41:54 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52476 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab2EYBlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 21:41:50 -0400
Message-ID: <4FBEE352.3030101@ozlabs.ru>
Date: Fri, 25 May 2012 11:41:38 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>, Alex Graf <agraf@suse.de>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH] vfio-powerpc: enabled and supported on power
References: <4FBDA68B.30405@ozlabs.ru> <1337872323.4714.10.camel@ul30vt>
In-Reply-To: <1337872323.4714.10.camel@ul30vt>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/05/12 01:12, Alex Williamson wrote:
> On Thu, 2012-05-24 at 13:10 +1000, Alexey Kardashevskiy wrote:
>> The patch introduces support of VFIO on POWER.
>>
>> The patch consists of:
>>
>> 1. IOMMU driver for VFIO.
>> It does not use IOMMU API at all, instead it calls POWER
>> IOMMU API directly (ppc_md callbacks).
>>
>> 2. A piece of code (module_init) which creates IOMMU groups.
>> TBD: what is a better place for it?
>>
>> The patch is made on top of
>> git://github.com/awilliam/linux-vfio.git iommu-group-vfio-20120523
>> (which is iommu-group-vfio-20120521 + some fixes)
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>>  arch/powerpc/Kconfig             |    6 +
>>  arch/powerpc/include/asm/iommu.h |    3 +
>>  arch/powerpc/kernel/Makefile     |    1 +
>>  arch/powerpc/kernel/iommu_vfio.c |  371 ++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 381 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/powerpc/kernel/iommu_vfio.c
>>
>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> index feab3ba..13d12ac 100644
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>> @@ -319,6 +319,12 @@ config 8XX_MINIMAL_FPEMU
>>  config IOMMU_HELPER
>>  	def_bool PPC64
>>  
>> +config IOMMU_VFIO
>> +	select IOMMU_API
>> +	depends on PPC64
> 
> && VFIO?

Aaaaand get a loop:

drivers/vfio/Kconfig|6| error: recursive dependency detected!
drivers/vfio/Kconfig|6| symbol VFIO depends on IOMMU_API
drivers/iommu/Kconfig|2| symbol IOMMU_API is selected by IOMMU_VFIO
arch/powerpc/Kconfig|322| symbol IOMMU_VFIO depends on VFIO

because:

menuconfig VFIO
        tristate "VFIO Non-Privileged userspace driver framework"
        depends on IOMMU_API

But this is a minor issue, read below.


>> +	tristate "Enable IOMMU chardev to support user-space PCI"
>> +	default n
>> +
>>  config SWIOTLB
>>  	bool "SWIOTLB support"
>>  	default n
>> diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
>> index 957a83f..c64bce7 100644
>> --- a/arch/powerpc/include/asm/iommu.h
>> +++ b/arch/powerpc/include/asm/iommu.h
>> @@ -66,6 +66,9 @@ struct iommu_table {
>>  	unsigned long  it_halfpoint; /* Breaking point for small/large allocs */
>>  	spinlock_t     it_lock;      /* Protects it_map */
>>  	unsigned long *it_map;       /* A simple allocation bitmap for now */
>> +#ifdef CONFIG_IOMMU_API
>> +	struct iommu_group *it_group;
>> +#endif
>>  };
>>  
>>  struct scatterlist;
>> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
>> index f5808a3..7cfd68e 100644
>> --- a/arch/powerpc/kernel/Makefile
>> +++ b/arch/powerpc/kernel/Makefile
>> @@ -90,6 +90,7 @@ obj-$(CONFIG_RELOCATABLE_PPC32)	+= reloc_32.o
>>  
>>  obj-$(CONFIG_PPC32)		+= entry_32.o setup_32.o
>>  obj-$(CONFIG_PPC64)		+= dma-iommu.o iommu.o
>> +obj-$(CONFIG_IOMMU_VFIO)	+= iommu_vfio.o
>>  obj-$(CONFIG_KGDB)		+= kgdb.o
>>  obj-$(CONFIG_PPC_OF_BOOT_TRAMPOLINE)	+= prom_init.o
>>  obj-$(CONFIG_MODULES)		+= ppc_ksyms.o
>> diff --git a/arch/powerpc/kernel/iommu_vfio.c b/arch/powerpc/kernel/iommu_vfio.c
>> new file mode 100644
>> index 0000000..68a93dd
>> --- /dev/null
>> +++ b/arch/powerpc/kernel/iommu_vfio.c
> 
> Should this be drivers/vfio/vfio_iommu_powerpc.c?


I guess no.
We already have some IOMMU code in arch/powerpc/kernel/iommu.c and eventually when I get my patch
polished it all can go to arch/powerpc/kernel/iommu.c or use some code from it.


>> @@ -0,0 +1,371 @@
>> +/*
>> + * VFIO: IOMMU DMA mapping support for TCE on POWER
>> + *
>> + * Copyright (C) 2012 IBM Corp.  All rights reserved.
>> + *     Author: Alexey Kardashevskiy <aik@ozlabs.ru>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * Derived from original vfio_iommu_x86.c:
>> + * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
>> + *     Author: Alex Williamson <alex.williamson@redhat.com>
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/pci.h>
>> +#include <linux/slab.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/vfio.h>
>> +#include <linux/err.h>
>> +#include <linux/spinlock.h>
>> +#include <asm/iommu.h>
>> +
>> +#define DRIVER_VERSION  "0.1"
>> +#define DRIVER_AUTHOR   "aik@ozlabs.ru"
>> +#define DRIVER_DESC     "POWER IOMMU chardev for VFIO"
>> +
>> +#define IOMMU_CHECK_EXTENSION	_IO(VFIO_TYPE, VFIO_BASE + 1)
>> +
>> +/* -------- API for POWERPC IOMMU -------- */
>> +
>> +#define POWERPC_IOMMU		2
>> +
>> +struct tce_iommu_info {
>> +	__u32 argsz;
>> +	__u32 dma32_window_start;
>> +	__u32 dma32_window_size;
>> +};
>> +
>> +#define POWERPC_IOMMU_GET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
>> +
>> +struct tce_iommu_dma_map {
>> +	__u32 argsz;
>> +	__u64 va;
>> +	__u64 dmaaddr;
>> +};
>> +
>> +#define POWERPC_IOMMU_MAP_DMA	_IO(VFIO_TYPE, VFIO_BASE + 13)
>> +#define POWERPC_IOMMU_UNMAP_DMA	_IO(VFIO_TYPE, VFIO_BASE + 14)
> 
> We'd probably want to merge this into include/linux/vfio.h too?


Why? The vfio_iommu_driver_ops has nothing to do with VFIO actually, it is what IOMMU API should
look like rather than it is now when it is simpler for us (powerpc) not to use it at all.

I really like vfio_iommu_driver_ops to go separately and will try to avoid putting any platform
specific code to a platform independent driver (like VFIO).

And the IOMMU_VFIO config options should be like IOMMU_FD_API or something like this, no link to VFIO.


>> +/* ***************************************************************** */
>> +
>> +struct tce_iommu {
>> +	struct iommu_table *tbl;
>> +};
>> +
>> +static int tce_iommu_attach_group(void *iommu_data,
>> +		struct iommu_group *iommu_group)
>> +{
>> +	struct tce_iommu *tceiommu = iommu_data;
>> +
>> +	if (tceiommu->tbl) {
>> +		printk(KERN_ERR "Only one group per IOMMU instance is allowed\n");
>> +		return -EFAULT;
>> +	}
>> +	tceiommu->tbl = iommu_group_get_iommudata(iommu_group);
>> +
>> +	return 0;
>> +}
>> +
>> +static void tce_iommu_detach_group(void *iommu_data,
>> +		struct iommu_group *iommu_group)
>> +{
>> +	struct tce_iommu *tceiommu = iommu_data;
>> +
>> +	if (!tceiommu->tbl) {
>> +		printk(KERN_ERR "IOMMU already released\n");
>> +		return;
>> +	}
>> +	tceiommu->tbl = NULL;
>> +}
>> +
>> +static void *tce_iommu_open(unsigned long arg)
>> +{
>> +	struct tce_iommu *tceiommu;
>> +
>> +	if (arg != POWERPC_IOMMU)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	tceiommu = kzalloc(sizeof(*tceiommu), GFP_KERNEL);
>> +	if (!tceiommu)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	return tceiommu;
>> +}
>> +
>> +static void tce_iommu_release(void *iommu_data)
>> +{
>> +	struct tce_iommu *tceiommu = iommu_data;
>> +	kfree(tceiommu);
>> +}
>> +
>> +static int tce_iommu_map(struct iommu_table *tbl, unsigned long iova,
>> +		   phys_addr_t paddr)
>> +{
>> +	unsigned long entry, flags;
>> +	int build_fail;
>> +
>> +	spin_lock_irqsave(&(tbl->it_lock), flags);
>> +	entry = iova >> IOMMU_PAGE_SHIFT;
>> +	build_fail = ppc_md.tce_build(tbl, entry, 1/*pages*/,
>> +			(unsigned long)paddr & IOMMU_PAGE_MASK,
>> +			DMA_BIDIRECTIONAL, NULL/*attrs*/);
>> +
>> +	/* ppc_md.tce_build() only returns non-zero for transient errors.
>> +	 * Clean up the table bitmap in this case and return
>> +	 * DMA_ERROR_CODE. For all other errors the functionality is
>> +	 * not altered.
>> +	 */
>> +	if (unlikely(build_fail)) {
>> +		printk("Failed to add TCE\n");
>> +		spin_unlock_irqrestore(&(tbl->it_lock), flags);
>> +		return -EFAULT;
>> +	}
>> +	/* Flush/invalidate TLB caches if necessary */
>> +	if (ppc_md.tce_flush)
>> +		ppc_md.tce_flush(tbl);
>> +
>> +	spin_unlock_irqrestore(&(tbl->it_lock), flags);
>> +
>> +	/* Make sure updates are seen by hardware */
>> +	mb();
>> +
>> +	return 0;
>> +}
>> +
>> +static void tce_iommu_unmap(struct iommu_table *tbl, unsigned long iova)
>> +{
>> +	unsigned long entry, flags;
>> +	entry = iova >> IOMMU_PAGE_SHIFT;
>> +
>> +	spin_lock_irqsave(&(tbl->it_lock), flags);
>> +	ppc_md.tce_free(tbl, entry, 1);
>> +	/* Flush/invalidate TLB caches if necessary */
>> +	if (ppc_md.tce_flush)
>> +		ppc_md.tce_flush(tbl);
>> +
>> +	spin_unlock_irqrestore(&(tbl->it_lock), flags);
>> +
>> +	/* Make sure updates are seen by hardware */
>> +	mb();
>> +}
>> +
>> +static phys_addr_t tce_iommu_iova_to_va(struct iommu_table *tbl,
>> +		unsigned long iova)
>> +{
>> +	unsigned long entry = iova >> IOMMU_PAGE_SHIFT;
>> +	phys_addr_t ret = 0;
>> +
>> +	if (ppc_md.tce_get)
>> +		ret = ppc_md.tce_get(tbl, entry);
>> +
>> +	return ret;
>> +}
>> +
>> +static struct page *tceaddr_to_page(void *addr)
>> +{
>> +	return pfn_to_page(__pa(addr) >> PAGE_SHIFT);
>> +}
>> +
>> +static long tce_dmamap_page(struct iommu_table *tbl,
>> +		uint64_t va, uint64_t dmaaddr)
>> +{
>> +	int ret = -EFAULT;
>> +	phys_addr_t addr;
>> +	struct page *page[1];
>> +	int iswrite = 1;
>> +	void *kva;
>> +
>> +	if (NULL == tbl) {
>> +		printk(KERN_ERR"tce_iommu: (map) IOMMU table has not "
>> +				"been initialized yet!\n");
>> +		return -EFAULT;
>> +	}
>> +	addr = tce_iommu_iova_to_va(tbl, dmaaddr);
>> +	if (addr) {
>> +		printk(KERN_WARNING"tce_iommu: already mapped va=%llx "
>> +				"da=%llx addr=%llx\n",
>> +				va, dmaaddr, addr);
>> +		/*TODO: unmap! */
>> +	}
>> +
>> +	ret = get_user_pages_fast(va, 1, iswrite, page);
>> +	if (1 != ret) {
>> +		printk(KERN_ERR"tce_iommu: get_user_pages_fast failed "
>> +				"va=%llx da=%llx addr=%llx ret=%d\n",
>> +				va, dmaaddr, addr, ret);
>> +		return -EFAULT;
>> +	}
>> +	ret = -EFAULT;
>> +	kva = (void *) page_address(page[0]);
>> +	if (kva) {
>> +		ret = tce_iommu_map(tbl, dmaaddr, (phys_addr_t) kva);
>> +	}
>> +	if (ret) {
>> +		printk(KERN_ERR"tce_iommu: tce_iommu_map va=%llx "
>> +				"da=%llx kva=%p\n",
>> +				va, dmaaddr, kva);
>> +		if (iswrite)
>> +			SetPageDirty(page[0]);
>> +		put_page(page[0]);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static long tce_dmaunmap_page(struct iommu_table *tbl, uint64_t dmaaddr)
>> +{
>> +	int ret = 0;
>> +	phys_addr_t addr;
>> +	struct page *page;
>> +
>> +	if (NULL == tbl) {
>> +		printk(KERN_ERR"tce_iommu: (unmap) IOMMU table has not been "
>> +				"initialized yet!\n");
>> +		return -EFAULT;
>> +	}
>> +	addr = tce_iommu_iova_to_va(tbl, dmaaddr);
>> +	if (addr) {
>> +		page = tceaddr_to_page((void*)addr);
>> +		if (!page) {
>> +			printk(KERN_ERR"DMAUNMAP error: pfn_to_page(%llx) "
>> +					"failed\n", addr);
>> +			ret = -EFAULT;
>> +		} else {
>> +			SetPageDirty(page);
>> +			put_page(page);
>> +		}
>> +	}
>> +	tce_iommu_unmap(tbl, dmaaddr);
>> +	if (ret)
>> +		printk(KERN_ERR"Failed to DMAUNMAP: da=%llx pfn=%llx\n",
>> +				dmaaddr, addr);
>> +	return ret;
>> +}
>> +
>> +
>> +static long tce_iommu_ioctl(void *iommu_data,
>> +				 unsigned int cmd, unsigned long arg)
>> +{
>> +	struct tce_iommu *tceiommu = iommu_data;
>> +	unsigned long minsz;
>> +
>> +	if (cmd == IOMMU_CHECK_EXTENSION) {
>> +		switch (arg) {
>> +		case POWERPC_IOMMU:
>> +			return 1;
>> +		default:
>> +			return 0;
>> +		}
>> +	} else if (cmd == POWERPC_IOMMU_GET_INFO) {
>> +		struct tce_iommu_info info;
>> +
>> +		minsz = offsetofend(struct tce_iommu_info, dma32_window_size);
>> +
>> +		if (copy_from_user(&info, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (info.argsz < minsz)
>> +			return -EINVAL;
>> +
>> +		info.dma32_window_start =
>> +				tceiommu->tbl->it_offset << IOMMU_PAGE_SHIFT;
>> +		info.dma32_window_size =
>> +				tceiommu->tbl->it_size << IOMMU_PAGE_SHIFT;
>> +
>> +		return copy_to_user((void __user *)arg, &info, minsz);
>> +
>> +	} else if (cmd == POWERPC_IOMMU_MAP_DMA) {
>> +		struct tce_iommu_dma_map map;
>> +
>> +		minsz = offsetofend(struct tce_iommu_dma_map, dmaaddr);
>> +
>> +		if (copy_from_user(&map, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (map.argsz < minsz)
>> +			return -EINVAL;
>> +
>> +		return tce_dmamap_page(tceiommu->tbl, map.va, map.dmaaddr);
>> +
>> +	} else if (cmd == POWERPC_IOMMU_UNMAP_DMA) {
>> +		struct tce_iommu_dma_map unmap;
>> +
>> +		minsz = offsetofend(struct tce_iommu_dma_map, dmaaddr);
>> +
>> +		if (copy_from_user(&unmap, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (unmap.argsz < minsz)
>> +			return -EINVAL;
>> +
>> +		return tce_dmaunmap_page(tceiommu->tbl, unmap.dmaaddr);
>> +	}
>> +
>> +	return -ENOTTY;
>> +}
>> +
>> +const struct vfio_iommu_driver_ops tce_iommu_driver_ops = {
>> +	.name		= "vfio-iommu-powerpc",
>> +	.owner		= THIS_MODULE,
>> +	.open		= tce_iommu_open,
>> +	.release	= tce_iommu_release,
>> +	.ioctl		= tce_iommu_ioctl,
>> +	.attach_group	= tce_iommu_attach_group,
>> +	.detach_group	= tce_iommu_detach_group,
>> +};
>> +
>> +static int __init tce_iommu_init(void)
>> +{
>> +	struct pci_dev *pdev = NULL;
>> +	struct iommu_table *tbl = NULL;
>> +	struct iommu_group *grp = NULL;
>> +	int ret = 0;
>> +
>> +	/* TODO: Do this for all devices, not just for PCI */
>> +	for_each_pci_dev(pdev) {
>> +
>> +		tbl = get_iommu_table_base(&pdev->dev);
>> +		if (NULL == tbl) {
>> +			printk("Skipping device %s\n", pdev->dev.kobj.name);
>> +			continue;
>> +		}
>> +		if (!tbl->it_group) {
>> +			struct iommu_group *tmp = iommu_group_alloc();
>> +			if (IS_ERR(tmp)) {
>> +				printk("Failed to create new IOMMU group, "
>> +						"ret = %ld\n", PTR_ERR(tmp));
>> +				break;
>> +			}
>> +			tbl->it_group = tmp;
>> +			iommu_group_set_iommudata(tmp, tbl, NULL);
>> +		}
>> +
>> +		grp = iommu_group_get(&pdev->dev);
>> +		if (!grp) {
>> +			ret = iommu_group_add_device(tbl->it_group, &pdev->dev);
>> +			if (ret < 0)
>> +				printk("iommu_group_add_device(%s) failed "
>> +						"with %d\n",
>> +						pdev->dev.kobj.name, ret);
>> +		}
> 
> Are you intentionally holding on to the extra group references here?

Nope.

> iommu_group_alloc(), iommu_group_get(), and iommu_group_add_device() all
> increase the group reference count.  For dynamically dissolving groups
> when empty, we should put the alloc/get reference.


It is just an example, I need to review/rethink this :) Our groups are static so I do not care much
about it now. And it is a module now as it is easier to debug but I am not sure if we keep it as a
module.


> Looks nice overall and a good validation that vfio isn't just for x86.


Yes, cool. And I like the idea that I can do whatever I want with IOMMU in the kernel and not touch
VFIO source code.
In QEMU, I simply added a simple function to VFIO to get a container fd from a VFIODevice and do the
rest in spapr_iommu.c and I am happy that I do not have to argue with the world about GET_DMA_WINDOW
ioctls, etc :)



> Thanks!
> 
> Alex
> 
>> +	}
>> +
>> +	return vfio_register_iommu_driver(&tce_iommu_driver_ops);
>> +}
>> +
>> +static void __exit tce_iommu_cleanup(void)
>> +{
>> +	vfio_unregister_iommu_driver(&tce_iommu_driver_ops);
>> +}
>> +
>> +module_init(tce_iommu_init);
>> +module_exit(tce_iommu_cleanup);
>> +
>> +MODULE_VERSION(DRIVER_VERSION);
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_AUTHOR(DRIVER_AUTHOR);
>> +MODULE_DESCRIPTION(DRIVER_DESC);
>> +


-- 
Alexey
