Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab2K0EXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 23:23:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab2K0EXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 23:23:24 -0500
Message-ID: <1353990186.1809.144.camel@bling.home>
Subject: Re: [PATCH] vfio powerpc: enabled and supported on powernv platform
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Sethi Varun-B16395 <B16395@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        David Gibson <david@gibson.dropbear.id.au>
Date: Mon, 26 Nov 2012 21:23:06 -0700
In-Reply-To: <50B4334E.2010802@ozlabs.ru>
References: <20121113033832.GW4696@truffula.fritz.box>
	  <1353372530-25205-1-git-send-email-aik@ozlabs.ru>
	  <1353435584.2234.87.camel@bling.home>
	  <C5ECD7A89D1DC44195F34B25E172658D294605@039-SN2MPN1-013.039d.mgd.msft.net>
	  <50AED94E.4000006@ozlabs.ru> <1353943130.1809.29.camel@bling.home>
	 <1353953070.1809.103.camel@bling.home> <50B4334E.2010802@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-27 at 14:28 +1100, Alexey Kardashevskiy wrote:
> On 27/11/12 05:04, Alex Williamson wrote:
> > On Mon, 2012-11-26 at 08:18 -0700, Alex Williamson wrote:
> >> On Fri, 2012-11-23 at 13:02 +1100, Alexey Kardashevskiy wrote:
> >>> On 22/11/12 22:56, Sethi Varun-B16395 wrote:
> >>>>
> >>>>
> >>>>> -----Original Message-----
> >>>>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> >>>>> owner@vger.kernel.org] On Behalf Of Alex Williamson
> >>>>> Sent: Tuesday, November 20, 2012 11:50 PM
> >>>>> To: Alexey Kardashevskiy
> >>>>> Cc: Benjamin Herrenschmidt; Paul Mackerras; linuxppc-
> >>>>> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> >>>>> David Gibson
> >>>>> Subject: Re: [PATCH] vfio powerpc: enabled and supported on powernv
> >>>>> platform
> >>>>>
> >>>>> On Tue, 2012-11-20 at 11:48 +1100, Alexey Kardashevskiy wrote:
> >>>>>> VFIO implements platform independent stuff such as a PCI driver, BAR
> >>>>>> access (via read/write on a file descriptor or direct mapping when
> >>>>>> possible) and IRQ signaling.
> >>>>>> The platform dependent part includes IOMMU initialization and
> >>>>>> handling.
> >>>>>>
> >>>>>> This patch initializes IOMMU groups based on the IOMMU configuration
> >>>>>> discovered during the PCI scan, only POWERNV platform is supported at
> >>>>>> the moment.
> >>>>>>
> >>>>>> Also the patch implements an VFIO-IOMMU driver which manages DMA
> >>>>>> mapping/unmapping requests coming from the client (now QEMU). It also
> >>>>>> returns a DMA window information to let the guest initialize the
> >>>>>> device tree for a guest OS properly. Although this driver has been
> >>>>>> tested only on POWERNV, it should work on any platform supporting TCE
> >>>>>> tables.
> >>>>>>
> >>>>>> To enable VFIO on POWER, enable SPAPR_TCE_IOMMU config option.
> >>>>>>
> >>>>>> Cc: David Gibson <david@gibson.dropbear.id.au>
> >>>>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> >>>>>> ---
> >>>>>>    arch/powerpc/include/asm/iommu.h     |    6 +
> >>>>>>    arch/powerpc/kernel/iommu.c          |  140 +++++++++++++++++++
> >>>>>>    arch/powerpc/platforms/powernv/pci.c |  135 +++++++++++++++++++
> >>>>>>    drivers/iommu/Kconfig                |    8 ++
> >>>>>>    drivers/vfio/Kconfig                 |    6 +
> >>>>>>    drivers/vfio/Makefile                |    1 +
> >>>>>>    drivers/vfio/vfio_iommu_spapr_tce.c  |  247
> >>>>> ++++++++++++++++++++++++++++++++++
> >>>>>>    include/linux/vfio.h                 |   20 +++
> >>>>>>    8 files changed, 563 insertions(+)
> >>>>>>    create mode 100644 drivers/vfio/vfio_iommu_spapr_tce.c
> >>>>>>
> >>>>>> diff --git a/arch/powerpc/include/asm/iommu.h
> >>>>>> b/arch/powerpc/include/asm/iommu.h
> >>>>>> index cbfe678..5ba66cb 100644
> >>>>>> --- a/arch/powerpc/include/asm/iommu.h
> >>>>>> +++ b/arch/powerpc/include/asm/iommu.h
> >>>>>> @@ -64,30 +64,33 @@ struct iommu_pool {  }
> >>>>>> ____cacheline_aligned_in_smp;
> >>>>>>
> >>>>>>    struct iommu_table {
> >>>>>>    	unsigned long  it_busno;     /* Bus number this table belongs to */
> >>>>>>    	unsigned long  it_size;      /* Size of iommu table in entries */
> >>>>>>    	unsigned long  it_offset;    /* Offset into global table */
> >>>>>>    	unsigned long  it_base;      /* mapped address of tce table */
> >>>>>>    	unsigned long  it_index;     /* which iommu table this is */
> >>>>>>    	unsigned long  it_type;      /* type: PCI or Virtual Bus */
> >>>>>>    	unsigned long  it_blocksize; /* Entries in each block (cacheline)
> >>>>> */
> >>>>>>    	unsigned long  poolsize;
> >>>>>>    	unsigned long  nr_pools;
> >>>>>>    	struct iommu_pool large_pool;
> >>>>>>    	struct iommu_pool pools[IOMMU_NR_POOLS];
> >>>>>>    	unsigned long *it_map;       /* A simple allocation bitmap for now
> >>>>> */
> >>>>>> +#ifdef CONFIG_IOMMU_API
> >>>>>> +	struct iommu_group *it_group;
> >>>>>> +#endif
> >>>>>>    };
> >>>>>>
> >>>>>>    struct scatterlist;
> >>>>>>
> >>>>>>    static inline void set_iommu_table_base(struct device *dev, void
> >>>>>> *base)  {
> >>>>>>    	dev->archdata.dma_data.iommu_table_base = base;  }
> >>>>>>
> >>>>>>    static inline void *get_iommu_table_base(struct device *dev)  {
> >>>>>>    	return dev->archdata.dma_data.iommu_table_base;
> >>>>>>    }
> >>>>>>
> >>>>>>    /* Frees table for an individual device node */ @@ -135,17 +138,20 @@
> >>>>>> static inline void pci_iommu_init(void) { }  extern void
> >>>>>> alloc_dart_table(void);  #if defined(CONFIG_PPC64) &&
> >>>>>> defined(CONFIG_PM)  static inline void iommu_save(void)  {
> >>>>>>    	if (ppc_md.iommu_save)
> >>>>>>    		ppc_md.iommu_save();
> >>>>>>    }
> >>>>>>
> >>>>>>    static inline void iommu_restore(void)  {
> >>>>>>    	if (ppc_md.iommu_restore)
> >>>>>>    		ppc_md.iommu_restore();
> >>>>>>    }
> >>>>>>    #endif
> >>>>>>
> >>>>>> +extern long iommu_put_tces(struct iommu_table *tbl, unsigned long
> >>>>> entry, uint64_t tce,
> >>>>>> +		enum dma_data_direction direction, unsigned long pages);
> >>>>>> +
> >>>>>>    #endif /* __KERNEL__ */
> >>>>>>    #endif /* _ASM_IOMMU_H */
> >>>>>> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> >>>>>> index ff5a6ce..94f614b 100644
> >>>>>> --- a/arch/powerpc/kernel/iommu.c
> >>>>>> +++ b/arch/powerpc/kernel/iommu.c
> >>>>>> @@ -32,30 +32,31 @@
> >>>>>>    #include <linux/dma-mapping.h>
> >>>>>>    #include <linux/bitmap.h>
> >>>>>>    #include <linux/iommu-helper.h>
> >>>>>>    #include <linux/crash_dump.h>
> >>>>>>    #include <linux/hash.h>
> >>>>>>    #include <linux/fault-inject.h>
> >>>>>>    #include <linux/pci.h>
> >>>>>>    #include <asm/io.h>
> >>>>>>    #include <asm/prom.h>
> >>>>>>    #include <asm/iommu.h>
> >>>>>>    #include <asm/pci-bridge.h>
> >>>>>>    #include <asm/machdep.h>
> >>>>>>    #include <asm/kdump.h>
> >>>>>>    #include <asm/fadump.h>
> >>>>>>    #include <asm/vio.h>
> >>>>>> +#include <asm/tce.h>
> >>>>>>
> >>>>>>    #define DBG(...)
> >>>>>>
> >>>>>>    static int novmerge;
> >>>>>>
> >>>>>>    static void __iommu_free(struct iommu_table *, dma_addr_t, unsigned
> >>>>>> int);
> >>>>>>
> >>>>>>    static int __init setup_iommu(char *str)  {
> >>>>>>    	if (!strcmp(str, "novmerge"))
> >>>>>>    		novmerge = 1;
> >>>>>>    	else if (!strcmp(str, "vmerge"))
> >>>>>>    		novmerge = 0;
> >>>>>>    	return 1;
> >>>>>>    }
> >>>>>> @@ -844,15 +845,154 @@ void *iommu_alloc_coherent(struct device *dev,
> >>>>>> struct iommu_table *tbl,  }
> >>>>>>
> >>>>>>    void iommu_free_coherent(struct iommu_table *tbl, size_t size,
> >>>>>>    			 void *vaddr, dma_addr_t dma_handle)  {
> >>>>>>    	if (tbl) {
> >>>>>>    		unsigned int nio_pages;
> >>>>>>
> >>>>>>    		size = PAGE_ALIGN(size);
> >>>>>>    		nio_pages = size >> IOMMU_PAGE_SHIFT;
> >>>>>>    		iommu_free(tbl, dma_handle, nio_pages);
> >>>>>>    		size = PAGE_ALIGN(size);
> >>>>>>    		free_pages((unsigned long)vaddr, get_order(size));
> >>>>>>    	}
> >>>>>>    }
> >>>>>> +
> >>>>>> +#ifdef CONFIG_IOMMU_API
> >>>>>> +/*
> >>>>>> + * SPAPR TCE API
> >>>>>> + */
> >>>>>> +static struct page *free_tce(struct iommu_table *tbl, unsigned long
> >>>>>> +entry) {
> >>>>>> +	struct page *page = NULL;
> >>>>>
> >>>>> NULL initialization doesn't appear to be necessary
> >>>>>
> >>>>>> +	unsigned long oldtce;
> >>>>>> +
> >>>>>> +	oldtce = ppc_md.tce_get(tbl, entry);
> >>>>>> +
> >>>>>> +	if (!(oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)))
> >>>>>> +		return NULL;
> >>>>>> +
> >>>>>> +	page = pfn_to_page(oldtce >> PAGE_SHIFT);
> >>>>>> +
> >>>>>> +	WARN_ON(!page);
> >>>>>> +	if (page && (oldtce & TCE_PCI_WRITE))
> >>>>>> +		SetPageDirty(page);
> >>>>>> +	ppc_md.tce_free(tbl, entry, 1);
> >>>>>> +
> >>>>>> +	return page;
> >>>>>> +}
> >>>>>> +
> >>>>>> +static int put_tce(struct iommu_table *tbl, unsigned long entry,
> >>>>>> +		uint64_t tce, enum dma_data_direction direction) {
> >>>>>> +	int ret;
> >>>>>> +	struct page *page = NULL;
> >>>>>> +	unsigned long kva, offset;
> >>>>>> +
> >>>>>> +	/* Map new TCE */
> >>>>>> +	offset = (tce & IOMMU_PAGE_MASK) - (tce & PAGE_MASK);
> >>>>>> +	ret = get_user_pages_fast(tce & PAGE_MASK, 1,
> >>>>>> +			direction != DMA_TO_DEVICE, &page);
> >>>>>> +	if (ret < 1) {
> >>>>>> +		printk(KERN_ERR "tce_vfio: get_user_pages_fast failed
> >>>>> tce=%llx ioba=%lx ret=%d\n",
> >>>>>> +				tce, entry << IOMMU_PAGE_SHIFT, ret);
> >>>>>> +		if (!ret)
> >>>>>> +			ret = -EFAULT;
> >>>>>
> >>>>> Missing return ret?  Otherwise we've got some bogus uses of page below
> >>>>> and we're setting ret for no reason here.
> >>>>>
> >>>>>> +	}
> >>>>>> +
> >>>>>> +	kva = (unsigned long) page_address(page);
> >>>>>> +	kva += offset;
> >>>>>> +
> >>>>>> +	/* tce_build receives a virtual address */
> >>>>>> +	entry += tbl->it_offset; /* Offset into real TCE table */
> >>>>>> +	ret = ppc_md.tce_build(tbl, entry, 1, kva, direction, NULL);
> >>>>>> +
> >>>>>> +	/* tce_build() only returns non-zero for transient errors */
> >>>>>> +	if (unlikely(ret)) {
> >>>>>> +		printk(KERN_ERR "tce_vfio: tce_put failed on tce=%llx
> >>>>> ioba=%lx kva=%lx ret=%d\n",
> >>>>>> +				tce, entry << IOMMU_PAGE_SHIFT, kva, ret);
> >>>>>> +		put_page(page);
> >>>>>> +		return -EIO;
> >>>>>> +	}
> >>>>>> +
> >>>>>> +	return 0;
> >>>>>> +}
> >>>>>> +
> >>>>>> +static void tce_flush(struct iommu_table *tbl) {
> >>>>>> +	/* Flush/invalidate TLB caches if necessary */
> >>>>>> +	if (ppc_md.tce_flush)
> >>>>>> +		ppc_md.tce_flush(tbl);
> >>>>>> +
> >>>>>> +	/* Make sure updates are seen by hardware */
> >>>>>> +	mb();
> >>>>>> +}
> >>>>>> +
> >>>>>> +long iommu_put_tces(struct iommu_table *tbl, unsigned long entry,
> >>>>> uint64_t tce,
> >>>>>> +		enum dma_data_direction direction, unsigned long pages) {
> >>>>>> +	int i, ret = 0, pages_to_put = 0;
> >>>>>> +	struct page *page;
> >>>>>> +	struct iommu_pool *pool = get_pool(tbl, entry);
> >>>>>> +	struct page **oldpages;
> >>>>>> +	const int oldpagesnum = PAGE_SIZE/sizeof(*oldpages);
> >>>>>> +
> >>>>>> +	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
> >>>>>> +
> >>>>>> +	/* Handle a single page request without allocation
> >>>>>> +	   of pages-to-release array */
> >>>>>> +	if (pages == 1) {
> >>>>>> +		spin_lock(&(pool->lock));
> >>>>>> +		page = free_tce(tbl, entry);
> >>>>>> +
> >>>>>> +		if (direction != DMA_NONE)
> >>>>>> +			ret = put_tce(tbl, entry, tce, direction);
> >>>>>> +
> >>>>>> +		tce_flush(tbl);
> >>>>>> +
> >>>>>> +		if (page)
> >>>>>> +			put_page(page);
> >>>>>> +
> >>>>>> +		spin_unlock(&(pool->lock));
> >>>>>> +		return ret;
> >>>>>> +	}
> >>>>>> +
> >>>>>> +	/* Releasing multiple pages */
> >>>>>> +	/* Allocate an array for pages to be released after TCE table
> >>>>>> +	   is updated */
> >>>>>> +	oldpages = kmalloc(PAGE_SIZE, GFP_KERNEL);
> >>>>>> +	if (!oldpages)
> >>>>>> +		return -ENOMEM;
> >>>>>> +
> >>>>>> +	spin_lock(&(pool->lock));
> >>>>>> +
> >>>>>> +	for (i = 0; (i < pages) && !ret; ++i, ++entry, tce +=
> >>>>> IOMMU_PAGE_SIZE) {
> >>>>>> +		page = free_tce(tbl, entry);
> >>>>>> +		if (page) {
> >>>>>> +			oldpages[pages_to_put] = page;
> >>>>>> +			++pages_to_put;
> >>>>>> +		}
> >>>>>> +
> >>>>>> +		if (direction != DMA_NONE)
> >>>>>> +			ret = put_tce(tbl, entry, tce, direction);
> >>>>>> +
> >>>>>> +		/* Release old pages if we reached the end of oldpages[] or
> >>>>>> +		   it is the last page or we are about to exit the loop */
> >>>>>> +		if ((pages_to_put == oldpagesnum) || (i == pages - 1) || ret)
> >>>>> {
> >>>>>> +			tce_flush(tbl);
> >>>>>
> >>>>> Avoiding tce_flush() is the reason for all this extra overhead, right?
> >>>>> I wonder if it'd be cleaner separating map vs unmap, where the map case
> >>>>> can avoid the oldpages array... but that means inserting new mappings on
> >>>>> top of old ones wouldn't put the pages.
> >>>
> >>>
> >>> Yes, we do not want to loose pages if the guest forgot to unmap them.
> >>
> >> Hmm, does that mean we're not actively clearing tce entries or somehow
> >> disabling the iommu window when the iommu is released through vfio?
> >
> > Ok, I see tces are put on shutdown via tce_iommu_detach_group, so you're
> > more concerned about the guest simply mapping over top of it's own
> > mappings.  Is that common?  Is it common enough for every multi-page
> > mapping to assume it will happen?  I know this is a performance
> > sensitive path for you and it seems like a map-only w/ fallback to
> > unmap, remap would be better in the general case.
> 
> 
> I do not get it. Where exactly does the performance suffer?
> iommu_put_tces() with non zero "tce" (i.e. "map") has to check if the entry 
> is not used, at least to return EBUSY when it is, and this check is 
> performed. If it is zero, there is no overhead at all. And it is going to 
> be the 99.(9)% case as the guest (un)maps one page per call.

I was mostly concerned about the kmalloc in your mapping path.  If you
had a map-only path it could scan the whole range to verify it's clear
and return EBUSY w/o allocating a buffer.  A second pass could do the
actual mappings.  Maybe it's not much of a win if you expect 99% of the
mappings to be single pages but since you effectively have a pv iommu
interface I wouldn't be surprised if they get batched in the guest.

> Generally speaking we want to move "put tce" completely to the kernel for 
> the (much) better performance and vfio won't be dealing with it all.

Right, but let's not use that as an excuse to be lazy and not ask if we
can do better here.

> We already agreed that SPAPR TCE driver uses x86 (aka type1) API but I do 
> not see why the powerpc implementation should look x86 alike as it still 
> operates with powerpc machine dependent callbacks so the reader has to have 
> some powerpc knowledge.

I'm only using x86 as an example because it's the only one we have.  I
don't think anything we're talking about here is x86-ish or powerpc-ish.
There's a kmalloc in a performance path and I'm asking if we can get rid
of it.  I'm also nervous that we're silently doing fixups on user
parameters to adjust mapping sizes and clear overlaps without any
warning to the user.  Thanks,

Alex

