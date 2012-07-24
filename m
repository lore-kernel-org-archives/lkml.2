Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2GXVv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:51:58 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50687 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab2GXVv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:51:56 -0400
Date: Tue, 24 Jul 2012 14:51:05 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Peter Zijlstra <peterz@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] page-table walkers vs memory order
In-Reply-To: <1343064870.26034.23.camel@twins>
Message-ID: <alpine.LSU.2.00.1207241356350.2094@eggly.anvils>
References: <1343064870.26034.23.camel@twins>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012, Peter Zijlstra wrote:
> 
> While staring at mm/huge_memory.c I found a very under-commented
> smp_wmb() in __split_huge_page_map(). It turns out that its copied from
> __{pte,pmd,pud}_alloc() but forgot the useful comment (or a reference
> thereto).
> 
> Now, afaict we're not good, as per that comment. Paul has since
> convinced some of us that compiler writers are pure evil and out to get
> us.
> 
> Therefore we should do what rcu_dereference() does and use
> ACCESS_ONCE()/barrier() followed smp_read_barrier_depends() every time
> we dereference a page-table pointer.
> 
> 
> In particular it looks like things like
> mm/memcontrol.c:mem_cgroup_count_precharge(), which use
> walk_page_range() under down_read(&mm->mmap_sem) and can thus be
> concurrent with __{pte,pmd,pud}_alloc() from faults (and possibly
> itself) are quite broken on Alpha

The Alpha pmd_offset() and pte_offset_map() already contain an
smp_read_barrier_depends() (362a61ad from Nick); with comment that
it's not needed on the pgd, and I presume the pud level is folded.
Does Alpha really need more of them, as you have put below?

> and subtly broken for those of us with 'creative' compilers.

I don't want to fight against ACCESS_ONCE() (or barrier(): that's
interesting, thank you, I hadn't seen it used as an ACCESS_ONCE()
substitute before); but I do want to question it a little.

I'm totally unclear whether the kernel ever gets built with these
'creative' compilers that you refer to.  Is ACCESS_ONCE() a warning
of where some future compiler would be permitted to mess with our
assumptions?  Or is it actually saving us already today?  Would we
know?  Could there be a boottime test that would tell us?  Is it
likely that a future compiler would have an "--access_once"
option that the kernel build would want to turn on?

Those may all be questions for Paul!

> 
> Should I go do a more extensive audit of page-table walkers or are we
> happy with the status quo?

I do love the status quo, but an audit would be welcome.  When
it comes to patches, personally I tend to prefer ACCESS_ONCE() and
smp_read_barrier_depends() and accompanying comments to be hidden away
in the underlying macros or inlines where reasonable, rather than
repeated all over; but I may have my priorities wrong on that.

The last time we rewrote the main pgd-pud-pmd-pte walkers,
we believed that no ACCESS_ONCE() was necessary, because although a
pgd-pud-pmd entry might be racily instantiated at any instant, it
could never change beneath us - the freeing of page tables happens
only when we cannot reach them by other routes.

(Never quite true: those _clear_bad() things can zero entries at any
instant, but we're already in a bad place when those come into play,
so we never worried about racing against them.)

Since then, I think THP has made the rules more complicated; but I
believe Andrea paid a great deal of attention to that kind of issue.

I suspect your arch/x86/mm/gup.c ACCESS_ONCE()s are necessary:
gup_fast() breaks as many rules as it can, and in particular may
be racing with the freeing of page tables; but I'm not so sure
about the pagewalk mods - we could say "cannot do any harm",
but I don't like adding lines on that basis.

Hugh

> 
> ---
>  arch/x86/mm/gup.c |    6 +++---
>  mm/pagewalk.c     |   24 ++++++++++++++++++++++++
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> index dd74e46..4958fb1 100644
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -150,7 +150,7 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
>  
>  	pmdp = pmd_offset(&pud, addr);
>  	do {
> -		pmd_t pmd = *pmdp;
> +		pmd_t pmd = ACCESS_ONCE(*pmdp);
>  
>  		next = pmd_addr_end(addr, end);
>  		/*
> @@ -220,7 +220,7 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
>  
>  	pudp = pud_offset(&pgd, addr);
>  	do {
> -		pud_t pud = *pudp;
> +		pud_t pud = ACCESS_ONCE(*pudp);
>  
>  		next = pud_addr_end(addr, end);
>  		if (pud_none(pud))
> @@ -280,7 +280,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  	local_irq_save(flags);
>  	pgdp = pgd_offset(mm, addr);
>  	do {
> -		pgd_t pgd = *pgdp;
> +		pgd_t pgd = ACCESS_ONCE(*pgdp);
>  
>  		next = pgd_addr_end(addr, end);
>  		if (pgd_none(pgd))
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 6c118d0..2ba2a74 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -10,6 +10,14 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	int err = 0;
>  
>  	pte = pte_offset_map(pmd, addr);
> +	/*
> +	 * Pairs with the smp_wmb() in __{pte,pmd,pud}_alloc() and
> +	 * __split_huge_page_map(). Ideally we'd use ACCESS_ONCE() on the
> +	 * actual dereference of p[gum]d, but that's hidden deep within the
> +	 * bowels of {pte,pmd,pud}_offset.
> +	 */
> +	barrier();
> +	smp_read_barrier_depends();
>  	for (;;) {
>  		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, walk);
>  		if (err)
> @@ -32,6 +40,14 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>  	int err = 0;
>  
>  	pmd = pmd_offset(pud, addr);
> +	/*
> +	 * Pairs with the smp_wmb() in __{pte,pmd,pud}_alloc() and
> +	 * __split_huge_page_map(). Ideally we'd use ACCESS_ONCE() on the
> +	 * actual dereference of p[gum]d, but that's hidden deep within the
> +	 * bowels of {pte,pmd,pud}_offset.
> +	 */
> +	barrier();
> +	smp_read_barrier_depends();
>  	do {
>  again:
>  		next = pmd_addr_end(addr, end);
> @@ -77,6 +93,14 @@ static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>  	int err = 0;
>  
>  	pud = pud_offset(pgd, addr);
> +	/*
> +	 * Pairs with the smp_wmb() in __{pte,pmd,pud}_alloc() and
> +	 * __split_huge_page_map(). Ideally we'd use ACCESS_ONCE() on the
> +	 * actual dereference of p[gum]d, but that's hidden deep within the
> +	 * bowels of {pte,pmd,pud}_offset.
> +	 */
> +	barrier();
> +	smp_read_barrier_depends();
>  	do {
>  		next = pud_addr_end(addr, end);
>  		if (pud_none_or_clear_bad(pud)) {
> 
> 
