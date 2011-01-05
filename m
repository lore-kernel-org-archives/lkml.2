Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab1AEUXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:23:48 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:50653 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1AEUXr (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 5 Jan 2011 15:23:47 -0500
Date: Wed, 5 Jan 2011 15:23:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 11/11] xen p2m: clear the old pte when adding a page to
 m2p_override
Message-ID: <20110105202321.GA25875@dumpdata.com>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
 <1292420446-3348-11-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292420446-3348-11-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 01:40:46PM +0000, stefano.stabellini@eu.citrix.com wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> When adding a page to m2p_override we change the p2m of the page so we
> need to also clear the old pte of the kernel linear mapping because it
> doesn't correspond anymore.
> 
> When we remove the page from m2p_override we restore the original p2m of
> the page and we also restore the old pte of the kernel linear mapping.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/xen/p2m.c |   35 ++++++++++++++++++++++++++++++++++-
>  1 files changed, 34 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 7dde8e4..ca6552d 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -29,6 +29,7 @@
>  #include <linux/module.h>
>  #include <linux/list.h>
>  #include <linux/hash.h>
> +#include <linux/sched.h>
>  
>  #include <asm/cache.h>
>  #include <asm/setup.h>
> @@ -412,6 +413,22 @@ void m2p_add_override(unsigned long mfn, struct page *page)
>  	page->index = pfn_to_mfn(pfn);
>  
>  	__set_phys_to_machine(pfn, FOREIGN_FRAME(mfn));
> +	if (!PageHighMem(page)) {
> +		unsigned long address = (unsigned long)__va(pfn << PAGE_SHIFT);
> +		unsigned level;
> +		pte_t *ptep = lookup_address(address, &level);
> +
> +		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
> +					"m2p_add_override: pfn %lx not mapped", pfn)) {

And if we hit this,  then the 'page_to_pfn' must have returned a pretty bogus PFN
for us to not be able to find the PFN in the &init_mm pagetable.
Or it truly is at the wrong level.
> +			__free_page(page);

Anyhow, if we are in this trouble, and if you free it here, won't that mess up
add->pages[x] ? Maybe we should change this function to return an error?

> +
> +			return;
> +		}
> +
> +		/* Just zap old mapping for now */
> +		pte_clear(&init_mm, address, ptep);
> +	}
> +
>  	spin_lock_irqsave(&m2p_override_lock, flags);
>  	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
>  	spin_unlock_irqrestore(&m2p_override_lock, flags);
> @@ -420,10 +437,26 @@ void m2p_add_override(unsigned long mfn, struct page *page)
>  void m2p_remove_override(struct page *page)
>  {
>  	unsigned long flags;
> +	unsigned long pfn = page_to_pfn(page);
>  	spin_lock_irqsave(&m2p_override_lock, flags);
>  	list_del(&page->lru);
>  	spin_unlock_irqrestore(&m2p_override_lock, flags);
> -	__set_phys_to_machine(page_to_pfn(page), page->index);
> +	__set_phys_to_machine(pfn, page->index);

Ok, so you set the old 'mfn' value back for the pfn.
> +
> +	if (!PageHighMem(page)) {
> +		unsigned long address = (unsigned long)__va(pfn << PAGE_SHIFT);
> +		unsigned level;
> +		pte_t *ptep = lookup_address(address, &level);
> +
> +		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
> +					"m2p_remove_override: pfn %lx not mapped", pfn))

So 'lookup_address' is using the M2P, and you are using the PFN from the
the page. So the only condition we could in which this ends up being 
ptep == NULL or a complete bogus value (0x55555555 or 0xfffffff) is if the
page is still shared or an I/O (so PFN ends up in the PCI BAR space for example)
page.

The latter is not going to happen since there are no pages for that region. So
is it possible that the page is still in M2P as shared? Or is that only possible
if something has gone horribly wrong in the hypervisor?

If it has gone wrong, should we reset in the P2M the old MFN?

> +			return;
> +
> +		set_pte_at(&init_mm, address, ptep,
> +				pfn_pte(pfn, PAGE_KERNEL));
> +		/* No tlb flush necessary because the caller already
> +		 * left the pte unmapped. */
> +	}
>  }
>  
>  struct page *m2p_find_override(unsigned long mfn)
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
