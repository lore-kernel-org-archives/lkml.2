Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab2JVO2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:28:21 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41000 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab2JVO2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:28:20 -0400
Date: Mon, 22 Oct 2012 10:28:14 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/19] x86, mm: Don't clear page table if range is ram
Message-ID: <20121022142814.GD14193@konrad-lan.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
 <1350593430-24470-7-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350593430-24470-7-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 01:50:14PM -0700, Yinghai Lu wrote:
> After we add code use buffer in BRK to pre-map page table,
                   ^- to

So .. which patch is that? Can you include the title of the
patch here?

> it should be safe to remove early_memmap for page table accessing.
> Instead we get panic with that.
> 
> It turns out we clear the initial page table wrongly for next range that is
              ^- that

> separated by holes.
> And it only happens when we are trying to map range one by one range separately.
                                                     ^-s

> 
> We need to check if the range is ram before clearing page table.

Ok, so that sounds like a bug-fix... but
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init_64.c |   37 ++++++++++++++++---------------------
>  1 files changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index f40f383..61b3c44 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -363,20 +363,19 @@ static unsigned long __meminit
>  phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
>  	      pgprot_t prot)
>  {
> -	unsigned pages = 0;
> +	unsigned long pages = 0, next;
>  	unsigned long last_map_addr = end;
>  	int i;
>  
>  	pte_t *pte = pte_page + pte_index(addr);
>  
> -	for(i = pte_index(addr); i < PTRS_PER_PTE; i++, addr += PAGE_SIZE, pte++) {
> -
> +	for (i = pte_index(addr); i < PTRS_PER_PTE; i++, addr = next, pte++) {
> +		next = (addr & PAGE_MASK) + PAGE_SIZE;
>  		if (addr >= end) {
> -			if (!after_bootmem) {
> -				for(; i < PTRS_PER_PTE; i++, pte++)
> -					set_pte(pte, __pte(0));
> -			}
> -			break;
> +			if (!after_bootmem &&
> +			    !e820_any_mapped(addr & PAGE_MASK, next, 0))
> +				set_pte(pte, __pte(0));
> +			continue;

.. Interestingly, you also removed the extra loop. How come? Why not
retain the little loop? (which could call e820_any_mapped?) Is that
an improvement and cleanup? If so, I would think you should at least
explain in the git commit:

"And while we are at it, also axe the extra loop and instead depend on
the top loop which we can safely piggyback on."

>  		}
>  
>  		/*
> @@ -418,16 +417,14 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
>  		pte_t *pte;
>  		pgprot_t new_prot = prot;
>  
> +		next = (address & PMD_MASK) + PMD_SIZE;
>  		if (address >= end) {
> -			if (!after_bootmem) {
> -				for (; i < PTRS_PER_PMD; i++, pmd++)
> -					set_pmd(pmd, __pmd(0));
> -			}
> -			break;
> +			if (!after_bootmem &&
> +			    !e820_any_mapped(address & PMD_MASK, next, 0))
> +				set_pmd(pmd, __pmd(0));
> +			continue;
>  		}
>  
> -		next = (address & PMD_MASK) + PMD_SIZE;
> -
>  		if (pmd_val(*pmd)) {
>  			if (!pmd_large(*pmd)) {
>  				spin_lock(&init_mm.page_table_lock);
> @@ -494,13 +491,11 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
>  		pmd_t *pmd;
>  		pgprot_t prot = PAGE_KERNEL;
>  
> -		if (addr >= end)
> -			break;
> -
>  		next = (addr & PUD_MASK) + PUD_SIZE;
> -
> -		if (!after_bootmem && !e820_any_mapped(addr, next, 0)) {
> -			set_pud(pud, __pud(0));
> +		if (addr >= end) {
> +			if (!after_bootmem &&
> +			    !e820_any_mapped(addr & PUD_MASK, next, 0))
> +				set_pud(pud, __pud(0));
>  			continue;
>  		}
>  
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
