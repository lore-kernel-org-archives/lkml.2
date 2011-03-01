Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab1CAWFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:05:43 -0500
Received: from usmamail.tilera.com ([206.83.70.70]:32825 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab1CAWFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:05:42 -0500
Message-ID: <4D6D6DB4.5020603@tilera.com>
Date: Tue, 1 Mar 2011 17:05:40 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Russell King <rmk@arm.linux.org.uk>,
        Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <linux-mm@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "Luck,Tony" <tony.luck@intel.com>, PaulMundt <lethal@linux-sh.org>
Subject: Re: [PATCH 06/17] arm: mmu_gather rework
References: <20110217162327.434629380@chello.nl>	 <20110217163235.106239192@chello.nl> <1298565253.2428.288.camel@twins>	 <1298657083.2428.2483.camel@twins>	 <20110225215123.GA10026@flint.arm.linux.org.uk> <1298893487.2428.10537.camel@twins>
In-Reply-To: <1298893487.2428.10537.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/28/2011 6:44 AM, Peter Zijlstra wrote:
> [...]
> Now, if we want to track ranges _and_ have hardware page table walkers
> (ARM seems to be one such), we must flush TLBs at tlb_end_vma() because
> flush_tlb_range() requires a vma pointer (ARM and TILE actually use more
> than ->vm_mm), and on tlb_finish_mmu() issue a full mm wide invalidate
> because the hardware walker could have re-populated the cache after
> clearing the PTEs but before freeing the page tables.
>
> What ARM does is it retains the last vma pointer and tracks
> pte_free_tlb() range and uses that in tlb_finish_mmu(), which is a tad
> hacky.
>
> Mostly because of shift_arg_pages(), where we have:
>
>   shift_arg_pages()
>     tlb_gather_mmu()
>     free_*_range()
>     tlb_finish_mmu()
>
> For which ARM now punts and does a full tlb invalidate (no vma pointer).
> But also because it drags along that vma pointer, which might not at all
> match the range its actually going to invalidate (and hence its vm_flags
> might not accurately reflect things -- at worst more expensive than
> needed).
>
> The reason I wanted flush_tlb_range() to take an mm_struct and not the
> current vm_area_struct is because we can avoid doing the
> flush_tlb_range() from tlb_end_vma() and delay the thing until
> tlb_finish_mmu() without having to resort to such games as above. We
> could simply track the full range over all VMAs and free'd page-tables
> and do one range invalidate.
>
> ARM uses vm_flags & VM_EXEC to see if it also needs to invalidate
> I-TLBs, and TILE uses VM_EXEC and VM_HUGETLB.
>
> For the I-TLBs we could easily use
> ptep_get_and_clear_full()/tlb_remove_tlb_entry() and see if any of the
> cleared pte's had its executable bit set (both ARM and TILE seem to have
> such a PTE bit).

For Tile, the concern is that we want to make sure to invalidate the
i-cache.  The I-TLB is handled by the regular TLB flush just fine, like the
other architectures.  So our concern is that once we have cleared the page
table entries and invalidated the TLBs, we still have to deal with i-cache
lines in any core that may have run code from that page.  The risk is that
the kernel might free, reallocate, and then run code from one of those
pages, all before the stale i-cache lines happened to be evicted.

The current Tile code flushes the icache explicitly at two different times:

1. Whenever we flush the TLB, since this is one time when we know who might
currently be using the page (via cpu_vm_mask) and we can flush all of them
easily, piggybacking on the infrastructure we use to flush remote TLBs.

2. Whenever we context switch, to handle the case where cpu 1 is running
process A, then switches to B, but another cpu still running process A
unmaps an executable page that was in cpu 1's icache.  This way when cpu 1
switches back to A, it doesn't have to worry about any unmaps that occurred
while it was switched out.


> I'm not sure what we can do about TILE's VM_HUGETLB usage though, if it
> needs explicit flushes for huge ptes it might just have to issue
> multiple tlb invalidates and do them from tlb_start_vma()/tlb_end_vma().

I'm not too concerned about this.  We can make the flush code check both
page sizes at a small cost in efficiency, relative to the overall cost of
global TLB invalidation.

>   CONFIG_HAVE_MMU_GATHER_ITLB - will use
> ptep_get_and_clear_full()/tlb_remove_tlb_entry() to test pte_exec() and
> issue flush_itlb_range(mm,start,end).

So it sounds like the proposal for tile would be to piggy-back on
flush_itlb_range() and use it to flush the i-cache?  It does seem like
there must be other Linux architectures with incoherent icache out there,
and some existing solution we could just repurpose.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

