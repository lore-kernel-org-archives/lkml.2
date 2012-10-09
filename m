Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2JIQQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:16:31 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60063 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2JIQQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:16:27 -0400
Date: Tue, 9 Oct 2012 12:04:39 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] x86, mm: Don't clear page table if next range is
 ram
Message-ID: <20121009160438.GG7639@phenom.dumpdata.com>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
 <1349757558-10856-5-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349757558-10856-5-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 09:39:12PM -0700, Yinghai Lu wrote:
> After we add code use BRK to map buffer for final page table,

.. mention the name of the patch that adds this.

What is 'final page table'? Isn't this just the existing
bootup tables modified to cover more memory.
> 
> It should be safe to remove early_memmap for page table accessing.
> 
> But we get panic with that.

Can you rewrite that please. For example it can be:
"With that it should have been safe to remove the call to early_memmap
but sadly it panics. The panic is due to .."
> 
> It turns out we clear the initial page table wrongly for next range that is
> separated by holes.

How do we clean it wrongly?
> And it only happens when we are trying to map range one by one range separately.
> 
> After we add checking before clearing the related page table, that panic will
> not happen anymore.

So we do not clean the pages anymore. Is the cleaning of the pages
addressed somewhere?
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
