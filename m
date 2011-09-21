Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1IUPKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:10:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26761 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1IUPKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:10:11 -0400
Date: Wed, 21 Sep 2011 10:58:53 -0400
From: konrad.wilk@oracle.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH v4 2/2] xen: modify kernel mappings corresponding to
 granted pages
Message-ID: <20110921145853.GA541@phenom.oracle.com>
References: <alpine.DEB.2.00.1109081944150.12963@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1109081944150.12963@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E79FE4C.0186:SCFMA922111,ss=1,re=-6.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 07:45:29PM +0100, Stefano Stabellini wrote:
> If we want to use granted pages for AIO, changing the mappings of a user
> vma and the corresponding p2m is not enough, we also need to update the
> kernel mappings accordingly.

Please add:"

But only for pages that are created for user usages through /dev/xen/gntdev.
As in, pages that have been in use by the kernel and use the P2M will not need
this special mapping."

Just so that it is quite clear when in a year somebody wants to debug
this code and wants to figure out if this patch causes issues.

.. more comments below. 
> In order to avoid the complexity of dealing with highmem, we allocated
> the pages lowmem.
> We issue a HYPERVISOR_grant_table_op right away in
> m2p_add_override and we remove the mappings using another
> HYPERVISOR_grant_table_op in m2p_remove_override.
> Considering that m2p_add_override and m2p_remove_override are called
> once per page we use multicalls and hypercall batching.
> 
> Use the kmap_op pointer directly as argument to do the mapping as it is
> guaranteed to be present up until the unmapping is done.
> Before issuing any unmapping multicalls, we need to make sure that the
> mapping has already being done, because we need the kmap->handle to be
> set correctly.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/include/asm/xen/page.h     |    5 ++-
>  arch/x86/xen/p2m.c                  |   68 +++++++++++++++++++++++++++++------
>  drivers/block/xen-blkback/blkback.c |    2 +-
>  drivers/xen/gntdev.c                |   27 +++++++++++++-
>  drivers/xen/grant-table.c           |    6 ++--
>  include/xen/grant_table.h           |    1 +
>  6 files changed, 92 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> index 7ff4669..0ce1884 100644
> --- a/arch/x86/include/asm/xen/page.h
> +++ b/arch/x86/include/asm/xen/page.h
> @@ -12,6 +12,7 @@
>  #include <asm/pgtable.h>
>  
>  #include <xen/interface/xen.h>
> +#include <xen/grant_table.h>
>  #include <xen/features.h>
>  
>  /* Xen machine address */
> @@ -31,8 +32,10 @@ typedef struct xpaddr {
>  #define INVALID_P2M_ENTRY	(~0UL)
>  #define FOREIGN_FRAME_BIT	(1UL<<(BITS_PER_LONG-1))
>  #define IDENTITY_FRAME_BIT	(1UL<<(BITS_PER_LONG-2))
> +#define GRANT_FRAME_BIT	(1UL<<(BITS_PER_LONG-3))
>  #define FOREIGN_FRAME(m)	((m) | FOREIGN_FRAME_BIT)
>  #define IDENTITY_FRAME(m)	((m) | IDENTITY_FRAME_BIT)
> +#define GRANT_FRAME(m)	((m) | GRANT_FRAME_BIT)
>  
>  /* Maximum amount of memory we can handle in a domain in pages */
>  #define MAX_DOMAIN_PAGES						\
> @@ -48,7 +51,7 @@ extern unsigned long set_phys_range_identity(unsigned long pfn_s,
>  					     unsigned long pfn_e);
>  
>  extern int m2p_add_override(unsigned long mfn, struct page *page,
> -			    bool clear_pte);
> +			    struct gnttab_map_grant_ref *kmap_op);
>  extern int m2p_remove_override(struct page *page, bool clear_pte);
>  extern struct page *m2p_find_override(unsigned long mfn);
>  extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 58efeb9..23f8465 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -161,7 +161,9 @@
>  #include <asm/xen/page.h>
>  #include <asm/xen/hypercall.h>
>  #include <asm/xen/hypervisor.h>
> +#include <xen/grant_table.h>
>  
> +#include "multicalls.h"
>  #include "xen-ops.h"
>  
>  static void __init m2p_override_init(void);
> @@ -676,7 +678,8 @@ static unsigned long mfn_hash(unsigned long mfn)
>  }
>  
>  /* Add an MFN override for a particular page */
> -int m2p_add_override(unsigned long mfn, struct page *page, bool clear_pte)
> +int m2p_add_override(unsigned long mfn, struct page *page,
> +		struct gnttab_map_grant_ref *kmap_op)
>  {
>  	unsigned long flags;
>  	unsigned long pfn;
> @@ -699,9 +702,20 @@ int m2p_add_override(unsigned long mfn, struct page *page, bool clear_pte)
>  	if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))))
>  		return -ENOMEM;
>  
> -	if (clear_pte && !PageHighMem(page))
> -		/* Just zap old mapping for now */
> -		pte_clear(&init_mm, address, ptep);
> +	if (kmap_op != NULL) {
> +		if (!PageHighMem(page)) {
> +			struct multicall_space mcs = xen_mc_entry(sizeof(*kmap_op));
> +
> +			MULTI_grant_table_op(mcs.mc,
> +					GNTTABOP_map_grant_ref, kmap_op, 1);
> +
> +			xen_mc_issue(PARAVIRT_LAZY_MMU);
> +		}
> +		page->private |= GRANT_FRAME_BIT;
> +		/* let's use dev_bus_addr to record the old mfn instead */
> +		kmap_op->dev_bus_addr = page->index;
> +		page->index = (unsigned long) kmap_op;
> +	}
>  	spin_lock_irqsave(&m2p_override_lock, flags);
>  	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
>  	spin_unlock_irqrestore(&m2p_override_lock, flags);
> @@ -735,13 +749,45 @@ int m2p_remove_override(struct page *page, bool clear_pte)
>  	spin_lock_irqsave(&m2p_override_lock, flags);
>  	list_del(&page->lru);
>  	spin_unlock_irqrestore(&m2p_override_lock, flags);
> -	set_phys_to_machine(pfn, page->index);
>  
> -	if (clear_pte && !PageHighMem(page))
> -		set_pte_at(&init_mm, address, ptep,
> -				pfn_pte(pfn, PAGE_KERNEL));
> -		/* No tlb flush necessary because the caller already
> -		 * left the pte unmapped. */
> +	if (clear_pte) {
> +		struct gnttab_map_grant_ref *map_op =
> +			(struct gnttab_map_grant_ref *) page->index;
> +		set_phys_to_machine(pfn, map_op->dev_bus_addr);
> +		if (!PageHighMem(page)) {
> +			struct multicall_space mcs;
> +			struct gnttab_unmap_grant_ref *unmap_op;
> +
> +			/*
> +			 * Has the grant_op mapping multicall being issued? If not,
> +			 * make sure it is called now.
> +			 */
> +			if (map_op->handle == -1)
> +				xen_mc_flush();

How do you trigger this case? The mapping looks to be set by "gntdev_add_map"
which is happening right after in gntdev_alloc_map..

If it had failed from the gntdev_alloc_map to gntdev_add_map this page would
have never been used in the m2p as we would not have provided the proper
op.index value to the user. Which mean that the user could not have mmaped
and gotten to this code.

> +			if (map_op->handle == -1) {

The other one I can understand, but this one I am baffled by. How
would the xen_mc_flush trigger the handle to be set to -1?

Is the hypercall writting that value in the op.handle after it has completed?

Also, we might want to document somwhere -1 now that I think of it.
It does not look like that is a value that is defined anywhere.

> +				printk(KERN_WARNING "m2p_remove_override: pfn %lx mfn %lx, "
> +						"failed to modify kernel mappings", pfn, mfn);
> +				return -1;
> +			}
> +
> +			mcs = xen_mc_entry(sizeof(struct gnttab_unmap_grant_ref));
> +			unmap_op = mcs.args;
> +			unmap_op->host_addr = map_op->host_addr;
> +			unmap_op->handle = map_op->handle;
> +			unmap_op->dev_bus_addr = 0;
> +
> +			MULTI_grant_table_op(mcs.mc,
> +					GNTTABOP_unmap_grant_ref, unmap_op, 1);
> +
> +			xen_mc_issue(PARAVIRT_LAZY_MMU);
> +
> +			set_pte_at(&init_mm, address, ptep,
> +					pfn_pte(pfn, PAGE_KERNEL));
> +			__flush_tlb_single(address);
> +			map_op->host_addr = 0;

I am not sure that is neccesseray? When we are done, err, when we end
up calling here that means the region has been unmapped or
IOCTL_GNTDEV_UNMAP_GRANT_REF called right?

And when we do end up here, then the a whole bunch of those pages
get free-ed? Don't they?

> +		}
> +	} else
> +		set_phys_to_machine(pfn, page->index);
>  
>  	return 0;
>  }
> @@ -758,7 +804,7 @@ struct page *m2p_find_override(unsigned long mfn)
>  	spin_lock_irqsave(&m2p_override_lock, flags);
>  
>  	list_for_each_entry(p, bucket, lru) {
> -		if (p->private == mfn) {
> +		if ((p->private & (~GRANT_FRAME_BIT)) == mfn) {
>  			ret = p;
>  			break;
>  		}
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index 2330a9a..1540792 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -396,7 +396,7 @@ static int xen_blkbk_map(struct blkif_request *req,
>  			continue;
>  
>  		ret = m2p_add_override(PFN_DOWN(map[i].dev_bus_addr),
> -			blkbk->pending_page(pending_req, i), false);
> +			blkbk->pending_page(pending_req, i), NULL);
>  		if (ret) {
>  			pr_alert(DRV_PFX "Failed to install M2P override for %lx (ret: %d)\n",
>  				 (unsigned long)map[i].dev_bus_addr, ret);
> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> index 7b9b1d1..bfe1271 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -83,6 +83,7 @@ struct grant_map {
>  	struct ioctl_gntdev_grant_ref *grants;
>  	struct gnttab_map_grant_ref   *map_ops;
>  	struct gnttab_unmap_grant_ref *unmap_ops;
> +	struct gnttab_map_grant_ref   *kmap_ops;
>  	struct page **pages;
>  };
>  
> @@ -116,10 +117,12 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
>  	add->grants    = kzalloc(sizeof(add->grants[0])    * count, GFP_KERNEL);
>  	add->map_ops   = kzalloc(sizeof(add->map_ops[0])   * count, GFP_KERNEL);
>  	add->unmap_ops = kzalloc(sizeof(add->unmap_ops[0]) * count, GFP_KERNEL);
> +	add->kmap_ops  = kzalloc(sizeof(add->kmap_ops[0])  * count, GFP_KERNEL);
>  	add->pages     = kzalloc(sizeof(add->pages[0])     * count, GFP_KERNEL);
>  	if (NULL == add->grants    ||
>  	    NULL == add->map_ops   ||
>  	    NULL == add->unmap_ops ||
> +	    NULL == add->kmap_ops  ||
>  	    NULL == add->pages)
>  		goto err;
>  
> @@ -129,6 +132,7 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
>  	for (i = 0; i < count; i++) {
>  		add->map_ops[i].handle = -1;
>  		add->unmap_ops[i].handle = -1;
> +		add->kmap_ops[i].handle = -1;
>  	}
>  
>  	add->index = 0;
> @@ -142,6 +146,7 @@ err:
>  	kfree(add->grants);
>  	kfree(add->map_ops);
>  	kfree(add->unmap_ops);
> +	kfree(add->kmap_ops);
>  	kfree(add);
>  	return NULL;
>  }
> @@ -243,10 +248,30 @@ static int map_grant_pages(struct grant_map *map)
>  			gnttab_set_unmap_op(&map->unmap_ops[i], addr,
>  				map->flags, -1 /* handle */);
>  		}
> +	} else {
> +		for (i = 0; i < map->count; i++) {
> +			unsigned level;
> +			unsigned long address = (unsigned long)
> +				pfn_to_kaddr(page_to_pfn(map->pages[i]));
> +			pte_t *ptep;
> +			u64 pte_maddr = 0;
> +			if (!PageHighMem(map->pages[i])) {
> +				ptep = lookup_address(address, &level);
> +				pte_maddr =
> +					arbitrary_virt_to_machine(ptep).maddr;
> +			}

And it looks like having kmap->ops.host_addr = 0 is valid
so that is good on the chance it is high map... but that begs
the question whether we should the hypercall at all?

As in, can we do anything with the grants if there is no PTE
or MFN associated with it - just the handle? Does Xen do something
special - like a relaxed "oh ok, we can handle that later on" ?


> +			gnttab_set_map_op(&map->kmap_ops[i], pte_maddr,
> +				map->flags |
> +				GNTMAP_host_map |
> +				GNTMAP_contains_pte,
> +				map->grants[i].ref,
> +				map->grants[i].domid);
> +		}

So, on startup.. (before this function is called) the
find_grant_ptes is called which pretty much does the exact thing for
each virtual address.  Except its flags are GNTMAP_application_map
instead of GNTMAP_host_map.

It even uses the same type structure.. It fills out map_ops[i] one.

Can we use that instead of adding a new structure?
>  	}
>  
>  	pr_debug("map %d+%d\n", map->index, map->count);
> -	err = gnttab_map_refs(map->map_ops, map->pages, map->count);
> +	err = gnttab_map_refs(map->map_ops, use_ptemod ? map->kmap_ops : NULL,
> +			map->pages, map->count);
>  	if (err)
>  		return err;
>  
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 4f44b34..8c71ab8 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -448,7 +448,8 @@ unsigned int gnttab_max_grant_frames(void)
>  EXPORT_SYMBOL_GPL(gnttab_max_grant_frames);
>  
>  int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
> -		    struct page **pages, unsigned int count)
> +			struct gnttab_map_grant_ref *kmap_ops,
> +			struct page **pages, unsigned int count)
>  {
>  	int i, ret;
>  	pte_t *pte;
> @@ -488,8 +489,7 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  			 */
>  			return -EOPNOTSUPP;
>  		}
> -		ret = m2p_add_override(mfn, pages[i],
> -				       map_ops[i].flags & GNTMAP_contains_pte);
> +		ret = m2p_add_override(mfn, pages[i], &kmap_ops[i]);
>  		if (ret)
>  			return ret;
>  	}
> diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
> index b1fab6b..6b99bfb 100644
> --- a/include/xen/grant_table.h
> +++ b/include/xen/grant_table.h
> @@ -156,6 +156,7 @@ unsigned int gnttab_max_grant_frames(void);
>  #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
>  
>  int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
> +			struct gnttab_map_grant_ref *kmap_ops,
>  		    struct page **pages, unsigned int count);
>  int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
>  		      struct page **pages, unsigned int count);
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
