Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab1CBRHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:07:35 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:28809 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab1CBRHe (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 2 Mar 2011 12:07:34 -0500
Date: Wed, 2 Mar 2011 12:06:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: "x86-64, mm: Put early page table high" causes crash on Xen
Message-ID: <20110302170628.GA9268@dumpdata.com>
References: <alpine.DEB.2.00.1103011517280.2917@kaball-desktop>
 <4D6D6980.7060304@kernel.org>
 <alpine.DEB.2.00.1103021123140.2968@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103021123140.2968@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D6E7922.005C,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 03:23:48PM +0000, Stefano Stabellini wrote:
> On Tue, 1 Mar 2011, Yinghai Lu wrote:
> > We do need map_low_page ( BTW, that name is totally misleading...)
> > 
> > the reason is we put page_table high and at that time is not under max_pfn_mapped. (aka not mapped).
> > 
> > So have to use 
> > 	adr = early_memremap(phys & PAGE_MASK, PAGE_SIZE);
> > to early map it and Read/Write to it.
>  
> I think I have figured out a way to update the logic of mask_rw_pte to
> account for the new way of allocating kernel pagetables.
> The appended patch fix the boot crash for me.
> 
> ---
> 
> xen: update mask_rw_pte after kernel page tables init changes
> 
> Already existing kernel page table pages can now be mapped using
> early_ioremap too so we need to update mask_rw_pte to make sure these
> pages are still mapped RO.
> We do that by mapping RO all the pages mapped using early_ioremap apart
> from the last one that has been allocated because it is not a page table
> page yet (it has been hooked into the page tables yet).
                  ^- has not?

..this is b/c the initial_kernel_mapping and its family of calls update
the pgt_buf_end (used to be called e820_table_end), _before__
it calls the Xen MMU to set the PTE entries and then after it is done
update the PMD?. Hence the simple check to see if the PFN is the _old_
value of the pgt_buf_end and if so skip altering the mapping from RW to RO
and leave them be?

On subsequent passes we fall within the first conditional
and update the PTE to RO? When is that pass done?


You also might want to mention the git commits that inspired this patch
and include the nice description you provided in the first email of this
thread.


> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 62192cd..2ff68be 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1440,10 +1440,12 @@ static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
>  	/*
>  	 * If the new pfn is within the range of the newly allocated
>  	 * kernel pagetable, and it isn't being mapped into an
> -	 * early_ioremap fixmap slot, make sure it is RO.
> +	 * early_ioremap fixmap slot as a freshly allocated page, make sure
> +	 * it is RO.
>  	 */
> -	if (!is_early_ioremap_ptep(ptep) &&
> -	    pfn >= pgt_buf_start && pfn < pgt_buf_end)
> +	if (((!is_early_ioremap_ptep(ptep) &&
> +			pfn >= pgt_buf_start && pfn < pgt_buf_end)) ||
> +			(is_early_ioremap_ptep(ptep) && pfn != (pgt_buf_end - 1)))
>  		pte = pte_wrprotect(pte);
>  
>  	return pte;
