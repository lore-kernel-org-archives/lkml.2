Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118Ab2HWPq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:46:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:56136 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab2HWPqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:46:25 -0400
Date: Thu, 23 Aug 2012 17:46:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Attilio Rao <attilio.rao@citrix.com>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, Stefano.Stabellini@eu.citrix.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for
 x86_init.mapping.pagetable_reserve
In-Reply-To: <1345648122-11935-2-git-send-email-attilio.rao@citrix.com>
Message-ID: <alpine.LFD.2.02.1208231722040.2856@ionos>
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com> <1345648122-11935-2-git-send-email-attilio.rao@citrix.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012, Attilio Rao wrote:

> - Allow xen_mapping_pagetable_reserve() to handle a start different from
>   pgt_buf_start, but still bigger than it.

What's the purpose of this and how is this going to be used and how is
it useful at all?

> - Add checks to xen_mapping_pagetable_reserve() and native_pagetable_reserve()
>   for verifying start and end are contained in the range
>   [pgt_buf_start, pgt_buf_top].
> - In xen_mapping_pagetable_reserve(), change printk into pr_debug.
> - In xen_mapping_pagetable_reserve(), print out diagnostic only if there is
>   an actual need to do that (or, in other words, if there are actually some
>   pages going to switch from RO to RW).

Please stop telling what the patch is doing. I can read that from the
patch itself. Please tell _WHY_ it is doing it.
 
> Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/mm/init.c |    4 ++++
>  arch/x86/xen/mmu.c |   22 ++++++++++++++++++++--
>  2 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index e0e6990..f4b750d 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -92,6 +92,10 @@ static void __init find_early_table_space(struct map_range *mr, unsigned long en
>  
>  void __init native_pagetable_reserve(u64 start, u64 end)
>  {
> +	if (start < PFN_PHYS(pgt_buf_start) || end > PFN_PHYS(pgt_buf_top))

This check is useless. We initialize pgt_buf_start,end,top to:

        pgt_buf_start = base >> PAGE_SHIFT;
        pgt_buf_end = pgt_buf_start;
        pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);

in find_early_table_space(). pgt_buf_end gets modified only in
alloc_low_page()

        unsigned long pfn = pgt_buf_end++;

And both implementations (32/64bit) have the following check:

        if (pfn >= pgt_buf_top)
                panic("alloc_low_page: ran out of memory");

So we panic way before we reach this check. Extra panic safety or what
are you trying to do here? 

I also have a hard time to understand the first part of the check.
There is only one callsite which feeds PFN_PHYS(pgt_buf_start) as
first argument. And as long as you don't explain WHY it would be
useful and a good idea to change that, this is pointless.

> +		panic("Invalid address range: [%#llx-%#llx] should be a subset of [%#llx-%#llx]\n",
> +			start, end, (u64)PFN_PHYS(pgt_buf_start),
> +			(u64)PFN_PHYS(pgt_buf_top));
>  	memblock_reserve(start, end - start);
>  }
>  
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index b65a761..dfae43a 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1180,12 +1180,30 @@ static void __init xen_pagetable_setup_start(pgd_t *base)
>  
>  static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
>  {
> +	u64 begin;
> +
> +	begin = PFN_PHYS(pgt_buf_start);
> +
> +	if (start < begin || end > PFN_PHYS(pgt_buf_top))
> +		panic("Invalid address range: [%#llx-%#llx] should be a subset of [%#llx-%#llx]\n",
> +			start, end, begin, (u64)PFN_PHYS(pgt_buf_top));
> +
> +	/* set RW the initial range */
> +	if  (start != begin)

And how does this happen? Again, that function is called from one
place and start _IS_ equal to PFN_PHYS(pgt_buf_start).

> +		pr_debug("xen: setting RW the range [%#llx-%#llx]\n",
> +			begin, start);
> +	while (begin < start) {
> +		make_lowmem_page_readwrite(__va(begin));
> +		begin += PAGE_SIZE;
> +	}
> +
>  	/* reserve the range used */
>  	native_pagetable_reserve(start, end);
>  
>  	/* set as RW the rest */
> -	printk(KERN_DEBUG "xen: setting RW the range %llx - %llx\n", end,
> -			PFN_PHYS(pgt_buf_top));
> +	if (end != PFN_PHYS(pgt_buf_top))

So this check is the only useful addition of this patch so far, unless
you come up with some useful explanations.

> +		pr_debug("xen: setting RW the range [%#llx-%#llx]\n",
> +			end, (u64)PFN_PHYS(pgt_buf_top));

Thanks,

	tglx
