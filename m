Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1IWPJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:09:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46585 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab1IWPJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:09:38 -0400
Message-ID: <4E7CA1BA.5020701@cantab.net>
Date: Fri, 23 Sep 2011 16:11:54 +0100
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH 0/6] xen: don't call vmalloc_sync_all()
 when mapping foreign pages
References: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com>	<4E727017.4030001@goop.org> <4E79F867.2020909@citrix.com>
In-Reply-To: <4E79F867.2020909@citrix.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/09/11 15:44, David Vrabel wrote:
> On 15/09/11 22:37, Jeremy Fitzhardinge wrote:
>> On 09/15/2011 05:40 AM, David Vrabel wrote:
>>> This set of pages avoids the need to call vmalloc_sync_all() when
>>> mapping foreign pages.  Two new functions are adding for mapping
>>> foreign pages onto RAM pages instead of vmalloc space.
>>>
>>> [...]
>>
>> But that said, if you want to allocate virtual addresses for mapping
>> granted pages, then alloc_vm_area() is the right thing to use.  You need
>> to make sure you touch the pages from within the kernel before passing
>> those addresses to a hypercall to make sure the mappings are established
>> within the current task (possibly within a no-preempt region to
>> guarantee that nothing odd happens). Or alternatively, you could switch
>> the current pagetable to init_mm for the hypercall (if it isn't already)
>> - since that's the reference pagetable - assuming you're not passing
>> usermode virtual addresses to the hypercall.
> 
> Making alloc_vm_area() fill in a array of pte_t *'s and passing the pointer
> to the PTE (using the GNTMAP_contains_pte flag) in the hypercall should
> allow Xen to update the PTEs in init_mm directly.
> 
> However, I'm not sure what to do about ia64 where GNTMAP_contains_pte
> is not supported.  Any ideas?
> 
> Here's the untested patch I have so far.

This (sort of) works with some hacks/changes (described below).

> diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
> index 49ba9b5..77348e8 100644
> --- a/arch/x86/xen/grant-table.c
> +++ b/arch/x86/xen/grant-table.c
> @@ -71,7 +71,7 @@ int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
>  
>  	if (shared == NULL) {
>  		struct vm_struct *area =
> -			alloc_vm_area(PAGE_SIZE * max_nr_gframes);
> +			alloc_vm_area(PAGE_SIZE * max_nr_gframes, NULL);
>  		BUG_ON(area == NULL);
>  		shared = area->addr;
>  		*__shared = shared;
> diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
> index cdacf92..75eb179 100644
> --- a/drivers/xen/xenbus/xenbus_client.c
> +++ b/drivers/xen/xenbus/xenbus_client.c
> @@ -435,19 +435,20 @@ EXPORT_SYMBOL_GPL(xenbus_free_evtchn);
>  int xenbus_map_ring_valloc(struct xenbus_device *dev, int gnt_ref, void **vaddr)
>  {
>  	struct gnttab_map_grant_ref op = {
> -		.flags = GNTMAP_host_map,
> +		.flags = GNTMAP_host_map | GNTMAP_contains_pte,
>  		.ref   = gnt_ref,
>  		.dom   = dev->otherend_id,
>  	};
>  	struct vm_struct *area;
> +	pte_t *pte;

alloc_vm_area() is allocating two pages instead of the one we ask for.
I hacked this with

       pte_t *pte[2];

>  	*vaddr = NULL;
>  
> -	area = alloc_vm_area(PAGE_SIZE);
> +	area = alloc_vm_area(PAGE_SIZE, &pte);
>  	if (!area)
>  		return -ENOMEM;
>  
> -	op.host_addr = (unsigned long)area->addr;
> +	op.host_addr = (unsigned long)pte;

With the GNTMAP_contains_pte flags this needs a machine address here so:

        op.host_addr = arbitrary_virt_to_machine(pte).maddr;

>  	if (HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, &op, 1))
>  		BUG();

Also need to do something with xenbus_map_ring_vfree() which doesn't work.

> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 9332e52..1a77252 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -118,7 +118,7 @@ unmap_kernel_range(unsigned long addr, unsigned long size)
>  #endif
>  
>  /* Allocate/destroy a 'vmalloc' VM area. */
> -extern struct vm_struct *alloc_vm_area(size_t size);
> +extern struct vm_struct *alloc_vm_area(size_t size, pte_t **ptes);
>  extern void free_vm_area(struct vm_struct *area);
>  
>  /* for /dev/kmem */
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 5016f19..786b4f6 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2105,23 +2105,30 @@ void  __attribute__((weak)) vmalloc_sync_all(void)
>  
>  static int f(pte_t *pte, pgtable_t table, unsigned long addr, void *data)
>  {
> -	/* apply_to_page_range() does all the hard work. */
> +	pte_t ***p = data;
> +
> +	if (p) {
> +		*(*p) = pte;
> +		(*p)++;
> +	}
>  	return 0;
>  }
>  
>  /**
>   *	alloc_vm_area - allocate a range of kernel address space
>   *	@size:		size of the area
> + *	@ptes:		returns the PTEs for the address space
>   *
>   *	Returns:	NULL on failure, vm_struct on success
>   *
>   *	This function reserves a range of kernel address space, and
>   *	allocates pagetables to map that range.  No actual mappings
> - *	are created.  If the kernel address space is not shared
> - *	between processes, it syncs the pagetable across all
> - *	processes.
> + *	are created.
> + *
> + *	If @ptes is non-NULL, pointers to the PTEs (in init_mm)
> + *	allocated for the VM area are returned.
>   */
> -struct vm_struct *alloc_vm_area(size_t size)
> +struct vm_struct *alloc_vm_area(size_t size, pte_t **ptes)
>  {
>  	struct vm_struct *area;
>  
> @@ -2135,19 +2142,11 @@ struct vm_struct *alloc_vm_area(size_t size)
>  	 * of kernel virtual address space and mapped into init_mm.
>  	 */
>  	if (apply_to_page_range(&init_mm, (unsigned long)area->addr,
> -				area->size, f, NULL)) {
> +				area->size, f, ptes ? &ptes : NULL)) {
>  		free_vm_area(area);
>  		return NULL;
>  	}
>  
> -	/*
> -	 * If the allocated address space is passed to a hypercall
> -	 * before being used then we cannot rely on a page fault to
> -	 * trigger an update of the page tables.  So sync all the page
> -	 * tables here.
> -	 */
> -	vmalloc_sync_all();
> -
>  	return area;
>  }
>  EXPORT_SYMBOL_GPL(alloc_vm_area);

