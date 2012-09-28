Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab2I1P7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:59:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30633 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab2I1P7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:59:49 -0400
Date: Fri, 28 Sep 2012 12:07:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: andrew.cooper3@citrix.com, jbeulich@suse.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH 01/11] kexec: introduce kexec_ops struct
Message-ID: <20120928160728.GA16262@localhost.localdomain>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 08:06:28PM +0200, Daniel Kiper wrote:
> Some kexec/kdump implementations (e.g. Xen PVOPS) on different archs could
> not use default functions or require some changes in behavior of kexec/kdump
> generic code. To cope with that problem kexec_ops struct was introduced.
> It allows a developer to replace all or some functions and control some
> functionality of kexec/kdump generic code.
> 
> Default behavior of kexec/kdump generic code is not changed.
> 
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> ---
>  include/linux/kexec.h |   18 +++++++
>  kernel/kexec.c        |  125 ++++++++++++++++++++++++++++++++++++-------------
>  2 files changed, 111 insertions(+), 32 deletions(-)
> 
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index 37c5f72..beb08ca 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -165,7 +165,25 @@ struct kimage {
>  #endif
>  };
>  
> +struct kexec_ops {
> +	bool always_use_normal_alloc;

So most of these are self-explanatory. But the bool is not that clear
to me. Could you include a documentation comment explaining
its purpose and its implications?

> +	struct page *(*kimage_alloc_pages)(gfp_t gfp_mask,
> +						unsigned int order,
> +						unsigned long limit);
> +	void (*kimage_free_pages)(struct page *page);
> +	unsigned long (*page_to_pfn)(struct page *page);
> +	struct page *(*pfn_to_page)(unsigned long pfn);
> +	unsigned long (*virt_to_phys)(volatile void *address);
> +	void *(*phys_to_virt)(unsigned long address);
> +	int (*machine_kexec_prepare)(struct kimage *image);
> +	int (*machine_kexec_load)(struct kimage *image);
> +	void (*machine_kexec_cleanup)(struct kimage *image);
> +	void (*machine_kexec_unload)(struct kimage *image);
> +	void (*machine_kexec_shutdown)(void);
> +	void (*machine_kexec)(struct kimage *image);
> +};
>  
> +extern struct kexec_ops kexec_ops;

Is this neccessary?

>  
>  /* kexec interface functions */
>  extern void machine_kexec(struct kimage *image);
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 0668d58..98556f3 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -56,6 +56,47 @@ struct resource crashk_res = {
>  	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
>  };
>  
> +static struct page *kimage_alloc_pages(gfp_t gfp_mask,
> +					unsigned int order,
> +					unsigned long limit);
> +static void kimage_free_pages(struct page *page);
> +
> +static unsigned long generic_page_to_pfn(struct page *page)
> +{
> +	return page_to_pfn(page);
> +}
> +
> +static struct page *generic_pfn_to_page(unsigned long pfn)
> +{
> +	return pfn_to_page(pfn);
> +}
> +
> +static unsigned long generic_virt_to_phys(volatile void *address)
> +{
> +	return virt_to_phys(address);
> +}
> +
> +static void *generic_phys_to_virt(unsigned long address)
> +{
> +	return phys_to_virt(address);
> +}
> +
> +struct kexec_ops kexec_ops = {
> +	.always_use_normal_alloc = false,
> +	.kimage_alloc_pages = kimage_alloc_pages,
> +	.kimage_free_pages = kimage_free_pages,
> +	.page_to_pfn = generic_page_to_pfn,
> +	.pfn_to_page = generic_pfn_to_page,
> +	.virt_to_phys = generic_virt_to_phys,
> +	.phys_to_virt = generic_phys_to_virt,
> +	.machine_kexec_prepare = machine_kexec_prepare,
> +	.machine_kexec_load = NULL,

Instead of NULL should they just point to some nop function?

> +	.machine_kexec_cleanup = machine_kexec_cleanup,
> +	.machine_kexec_unload = NULL,
> +	.machine_kexec_shutdown = machine_shutdown,
> +	.machine_kexec = machine_kexec
> +};
> +
>  int kexec_should_crash(struct task_struct *p)
>  {
>  	if (in_interrupt() || !p->pid || is_global_init(p) || panic_on_oops)
> @@ -355,7 +396,9 @@ static int kimage_is_destination_range(struct kimage *image,
>  	return 0;
>  }
>  
> -static struct page *kimage_alloc_pages(gfp_t gfp_mask, unsigned int order)
> +static struct page *kimage_alloc_pages(gfp_t gfp_mask,
> +					unsigned int order,
> +					unsigned long limit)
>  {
>  	struct page *pages;
>  
> @@ -392,7 +435,7 @@ static void kimage_free_page_list(struct list_head *list)
>  
>  		page = list_entry(pos, struct page, lru);
>  		list_del(&page->lru);
> -		kimage_free_pages(page);
> +		(*kexec_ops.kimage_free_pages)(page);
>  	}
>  }
>  
> @@ -425,10 +468,11 @@ static struct page *kimage_alloc_normal_control_pages(struct kimage *image,
>  	do {
>  		unsigned long pfn, epfn, addr, eaddr;
>  
> -		pages = kimage_alloc_pages(GFP_KERNEL, order);
> +		pages = (*kexec_ops.kimage_alloc_pages)(GFP_KERNEL, order,
> +							KEXEC_CONTROL_MEMORY_LIMIT);
>  		if (!pages)
>  			break;
> -		pfn   = page_to_pfn(pages);
> +		pfn   = (*kexec_ops.page_to_pfn)(pages);
>  		epfn  = pfn + count;
>  		addr  = pfn << PAGE_SHIFT;
>  		eaddr = epfn << PAGE_SHIFT;
> @@ -515,7 +559,7 @@ static struct page *kimage_alloc_crash_control_pages(struct kimage *image,
>  		}
>  		/* If I don't overlap any segments I have found my hole! */
>  		if (i == image->nr_segments) {
> -			pages = pfn_to_page(hole_start >> PAGE_SHIFT);
> +			pages = (*kexec_ops.pfn_to_page)(hole_start >> PAGE_SHIFT);
>  			break;
>  		}
>  	}
> @@ -532,12 +576,13 @@ struct page *kimage_alloc_control_pages(struct kimage *image,
>  	struct page *pages = NULL;
>  
>  	switch (image->type) {
> +	case KEXEC_TYPE_CRASH:
> +		if (!kexec_ops.always_use_normal_alloc) {
> +			pages = kimage_alloc_crash_control_pages(image, order);
> +			break;
> +		}
>  	case KEXEC_TYPE_DEFAULT:
>  		pages = kimage_alloc_normal_control_pages(image, order);
> -		break;
> -	case KEXEC_TYPE_CRASH:
> -		pages = kimage_alloc_crash_control_pages(image, order);
> -		break;
>  	}
>  
>  	return pages;
> @@ -557,7 +602,7 @@ static int kimage_add_entry(struct kimage *image, kimage_entry_t entry)
>  			return -ENOMEM;
>  
>  		ind_page = page_address(page);
> -		*image->entry = virt_to_phys(ind_page) | IND_INDIRECTION;
> +		*image->entry = (*kexec_ops.virt_to_phys)(ind_page) | IND_INDIRECTION;
>  		image->entry = ind_page;
>  		image->last_entry = ind_page +
>  				      ((PAGE_SIZE/sizeof(kimage_entry_t)) - 1);
> @@ -616,14 +661,14 @@ static void kimage_terminate(struct kimage *image)
>  #define for_each_kimage_entry(image, ptr, entry) \
>  	for (ptr = &image->head; (entry = *ptr) && !(entry & IND_DONE); \
>  		ptr = (entry & IND_INDIRECTION)? \
> -			phys_to_virt((entry & PAGE_MASK)): ptr +1)
> +			(*kexec_ops.phys_to_virt)((entry & PAGE_MASK)): ptr +1)
>  
>  static void kimage_free_entry(kimage_entry_t entry)
>  {
>  	struct page *page;
>  
> -	page = pfn_to_page(entry >> PAGE_SHIFT);
> -	kimage_free_pages(page);
> +	page = (*kexec_ops.pfn_to_page)(entry >> PAGE_SHIFT);
> +	(*kexec_ops.kimage_free_pages)(page);
>  }
>  
>  static void kimage_free(struct kimage *image)
> @@ -653,7 +698,7 @@ static void kimage_free(struct kimage *image)
>  		kimage_free_entry(ind);
>  
>  	/* Handle any machine specific cleanup */
> -	machine_kexec_cleanup(image);
> +	(*kexec_ops.machine_kexec_cleanup)(image);
>  
>  	/* Free the kexec control pages... */
>  	kimage_free_page_list(&image->control_pages);
> @@ -709,7 +754,7 @@ static struct page *kimage_alloc_page(struct kimage *image,
>  	 * have a match.
>  	 */
>  	list_for_each_entry(page, &image->dest_pages, lru) {
> -		addr = page_to_pfn(page) << PAGE_SHIFT;
> +		addr = (*kexec_ops.page_to_pfn)(page) << PAGE_SHIFT;
>  		if (addr == destination) {
>  			list_del(&page->lru);
>  			return page;
> @@ -720,16 +765,17 @@ static struct page *kimage_alloc_page(struct kimage *image,
>  		kimage_entry_t *old;
>  
>  		/* Allocate a page, if we run out of memory give up */
> -		page = kimage_alloc_pages(gfp_mask, 0);
> +		page = (*kexec_ops.kimage_alloc_pages)(gfp_mask, 0,
> +							KEXEC_SOURCE_MEMORY_LIMIT);
>  		if (!page)
>  			return NULL;
>  		/* If the page cannot be used file it away */
> -		if (page_to_pfn(page) >
> +		if ((*kexec_ops.page_to_pfn)(page) >
>  				(KEXEC_SOURCE_MEMORY_LIMIT >> PAGE_SHIFT)) {
>  			list_add(&page->lru, &image->unuseable_pages);
>  			continue;
>  		}
> -		addr = page_to_pfn(page) << PAGE_SHIFT;
> +		addr = (*kexec_ops.page_to_pfn)(page) << PAGE_SHIFT;
>  
>  		/* If it is the destination page we want use it */
>  		if (addr == destination)
> @@ -752,7 +798,7 @@ static struct page *kimage_alloc_page(struct kimage *image,
>  			struct page *old_page;
>  
>  			old_addr = *old & PAGE_MASK;
> -			old_page = pfn_to_page(old_addr >> PAGE_SHIFT);
> +			old_page = (*kexec_ops.pfn_to_page)(old_addr >> PAGE_SHIFT);
>  			copy_highpage(page, old_page);
>  			*old = addr | (*old & ~PAGE_MASK);
>  
> @@ -762,7 +808,7 @@ static struct page *kimage_alloc_page(struct kimage *image,
>  			 */
>  			if (!(gfp_mask & __GFP_HIGHMEM) &&
>  			    PageHighMem(old_page)) {
> -				kimage_free_pages(old_page);
> +				(*kexec_ops.kimage_free_pages)(old_page);
>  				continue;
>  			}
>  			addr = old_addr;
> @@ -808,7 +854,7 @@ static int kimage_load_normal_segment(struct kimage *image,
>  			result  = -ENOMEM;
>  			goto out;
>  		}
> -		result = kimage_add_page(image, page_to_pfn(page)
> +		result = kimage_add_page(image, (*kexec_ops.page_to_pfn)(page)
>  								<< PAGE_SHIFT);
>  		if (result < 0)
>  			goto out;
> @@ -862,7 +908,7 @@ static int kimage_load_crash_segment(struct kimage *image,
>  		char *ptr;
>  		size_t uchunk, mchunk;
>  
> -		page = pfn_to_page(maddr >> PAGE_SHIFT);
> +		page = (*kexec_ops.pfn_to_page)(maddr >> PAGE_SHIFT);
>  		if (!page) {
>  			result  = -ENOMEM;
>  			goto out;
> @@ -901,12 +947,13 @@ static int kimage_load_segment(struct kimage *image,
>  	int result = -ENOMEM;
>  
>  	switch (image->type) {
> +	case KEXEC_TYPE_CRASH:
> +		if (!kexec_ops.always_use_normal_alloc) {
> +			result = kimage_load_crash_segment(image, segment);
> +			break;
> +		}
>  	case KEXEC_TYPE_DEFAULT:
>  		result = kimage_load_normal_segment(image, segment);
> -		break;
> -	case KEXEC_TYPE_CRASH:
> -		result = kimage_load_crash_segment(image, segment);
> -		break;
>  	}
>  
>  	return result;
> @@ -994,6 +1041,8 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>  			/* Free any current crash dump kernel before
>  			 * we corrupt it.
>  			 */
> +			if (kexec_ops.machine_kexec_unload)
> +				(*kexec_ops.machine_kexec_unload)(image);
>  			kimage_free(xchg(&kexec_crash_image, NULL));
>  			result = kimage_crash_alloc(&image, entry,
>  						     nr_segments, segments);
> @@ -1004,7 +1053,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>  
>  		if (flags & KEXEC_PRESERVE_CONTEXT)
>  			image->preserve_context = 1;
> -		result = machine_kexec_prepare(image);
> +		result = (*kexec_ops.machine_kexec_prepare)(image);
>  		if (result)
>  			goto out;
>  
> @@ -1017,11 +1066,23 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>  		if (flags & KEXEC_ON_CRASH)
>  			crash_unmap_reserved_pages();
>  	}
> +
> +	if (kexec_ops.machine_kexec_load) {
> +		result = (*kexec_ops.machine_kexec_load)(image);
> +
> +		if (result)
> +			goto out;
> +	}
> +
>  	/* Install the new kernel, and  Uninstall the old */
>  	image = xchg(dest_image, image);
>  
>  out:
>  	mutex_unlock(&kexec_mutex);
> +
> +	if (kexec_ops.machine_kexec_unload)
> +		(*kexec_ops.machine_kexec_unload)(image);
> +
>  	kimage_free(image);
>  
>  	return result;
> @@ -1095,7 +1156,7 @@ void crash_kexec(struct pt_regs *regs)
>  			crash_setup_regs(&fixed_regs, regs);
>  			crash_save_vmcoreinfo();
>  			machine_crash_shutdown(&fixed_regs);
> -			machine_kexec(kexec_crash_image);
> +			(*kexec_ops.machine_kexec)(kexec_crash_image);
>  		}
>  		mutex_unlock(&kexec_mutex);
>  	}
> @@ -1117,8 +1178,8 @@ void __weak crash_free_reserved_phys_range(unsigned long begin,
>  	unsigned long addr;
>  
>  	for (addr = begin; addr < end; addr += PAGE_SIZE) {
> -		ClearPageReserved(pfn_to_page(addr >> PAGE_SHIFT));
> -		init_page_count(pfn_to_page(addr >> PAGE_SHIFT));
> +		ClearPageReserved((*kexec_ops.pfn_to_page)(addr >> PAGE_SHIFT));
> +		init_page_count((*kexec_ops.pfn_to_page)(addr >> PAGE_SHIFT));
>  		free_page((unsigned long)__va(addr));
>  		totalram_pages++;
>  	}
> @@ -1572,10 +1633,10 @@ int kernel_kexec(void)
>  	{
>  		kernel_restart_prepare(NULL);
>  		printk(KERN_EMERG "Starting new kernel\n");
> -		machine_shutdown();
> +		(*kexec_ops.machine_kexec_shutdown)();
>  	}
>  
> -	machine_kexec(kexec_image);
> +	(*kexec_ops.machine_kexec)(kexec_image);
>  
>  #ifdef CONFIG_KEXEC_JUMP
>  	if (kexec_image->preserve_context) {
> -- 
> 1.5.6.5
