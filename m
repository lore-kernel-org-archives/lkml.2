Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2JVLDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:03:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:51060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab2JVLDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:03:16 -0400
Message-ID: <1350903750.2768.90.camel@twins>
Subject: Re: [tip:numa/core] x86, mm: Prevent gcc to re-read the pagetables
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        torvalds@linux-foundation.org, riel@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Date: Mon, 22 Oct 2012 13:02:30 +0200
In-Reply-To: <tip-cee8868763f827194e3b8ef1371ff9a96eae3b48@git.kernel.org>
References: <tip-cee8868763f827194e3b8ef1371ff9a96eae3b48@git.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-21 at 05:56 -0700, tip-bot for Andrea Arcangeli wrote:

> In get_user_pages_fast() the TLB shootdown code can clear the pagetables
> before firing any TLB flush (the page can't be freed until the TLB
> flushing IPI has been delivered but the pagetables will be cleared well
> before sending any TLB flushing IPI).

I think we want to do this for all gup_fast() implementations. When I
reported this issue I also proposed adding something like
page_table_deref() which we could use through-out. Not sure we want to,
but at least all archs need an audit for this.


> ---
>  arch/x86/mm/gup.c |   23 ++++++++++++++++++++---
>  mm/memory.c       |    2 +-
>  2 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> index dd74e46..6dc9921 100644
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -150,7 +150,13 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
>  
>  	pmdp = pmd_offset(&pud, addr);
>  	do {
> -		pmd_t pmd = *pmdp;
> +		/*
> +		 * With THP and hugetlbfs the pmd can change from
> +		 * under us and it can be cleared as well by the TLB
> +		 * shootdown, so read it with ACCESS_ONCE to do all
> +		 * computations on the same sampling.
> +		 */
> +		pmd_t pmd = ACCESS_ONCE(*pmdp);
>  
>  		next = pmd_addr_end(addr, end);
>  		/*
> @@ -220,7 +226,13 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
>  
>  	pudp = pud_offset(&pgd, addr);
>  	do {
> -		pud_t pud = *pudp;
> +		/*
> +		 * With hugetlbfs giga pages the pud can change from
> +		 * under us and it can be cleared as well by the TLB
> +		 * shootdown, so read it with ACCESS_ONCE to do all
> +		 * computations on the same sampling.
> +		 */
> +		pud_t pud = ACCESS_ONCE(*pudp);
>  
>  		next = pud_addr_end(addr, end);
>  		if (pud_none(pud))
> @@ -280,7 +292,12 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  	local_irq_save(flags);
>  	pgdp = pgd_offset(mm, addr);
>  	do {
> -		pgd_t pgd = *pgdp;
> +		/*
> +		 * The pgd could be cleared by the TLB shootdown from
> +		 * under us so read it with ACCESS_ONCE to do all
> +		 * computations on the same sampling.
> +		 */
> +		pgd_t pgd = ACCESS_ONCE(*pgdp);
>  
>  		next = pgd_addr_end(addr, end);
>  		if (pgd_none(pgd))
> diff --git a/mm/memory.c b/mm/memory.c
> index cc8e280..c0de477 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3555,7 +3555,7 @@ int handle_pte_fault(struct mm_struct *mm,
>  	pte_t entry;
>  	spinlock_t *ptl;
>  
> -	entry = *pte;
> +	entry = ACCESS_ONCE(*pte);
>  	if (!pte_present(entry)) {
>  		if (pte_none(entry)) {
>  			if (vma->vm_ops) {

