Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab1CBKwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:52:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:47554 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab1CBKwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:52:41 -0500
Subject: Re: [PATCH 06/17] arm: mmu_gather rework
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "Luck,Tony" <tony.luck@intel.com>, PaulMundt <lethal@linux-sh.org>
In-Reply-To: <4D6D6DB4.5020603@tilera.com>
References: <20110217162327.434629380@chello.nl>
	 <20110217163235.106239192@chello.nl> <1298565253.2428.288.camel@twins>
	 <1298657083.2428.2483.camel@twins>
	 <20110225215123.GA10026@flint.arm.linux.org.uk>
	 <1298893487.2428.10537.camel@twins>  <4D6D6DB4.5020603@tilera.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 11:54:03 +0100
Message-ID: <1299063243.1310.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 17:05 -0500, Chris Metcalf wrote:

> For Tile, the concern is that we want to make sure to invalidate the
> i-cache.  The I-TLB is handled by the regular TLB flush just fine, like the
> other architectures.  So our concern is that once we have cleared the page
> table entries and invalidated the TLBs, we still have to deal with i-cache
> lines in any core that may have run code from that page.  The risk is that
> the kernel might free, reallocate, and then run code from one of those
> pages, all before the stale i-cache lines happened to be evicted.

>From reading Documentation/cachetlb.txt, update_mmu_cache() can be used
to flush i-cache whenever you install a pte with executable permissions,
and covers the particular case you mention above.

DaveM any comment? You seem to be the one who wrote that document :-)

> The current Tile code flushes the icache explicitly at two different times:
> 
> 1. Whenever we flush the TLB, since this is one time when we know who might
> currently be using the page (via cpu_vm_mask) and we can flush all of them
> easily, piggybacking on the infrastructure we use to flush remote TLBs.
> 
> 2. Whenever we context switch, to handle the case where cpu 1 is running
> process A, then switches to B, but another cpu still running process A
> unmaps an executable page that was in cpu 1's icache.  This way when cpu 1
> switches back to A, it doesn't have to worry about any unmaps that occurred
> while it was switched out.
> 
> 
> > I'm not sure what we can do about TILE's VM_HUGETLB usage though, if it
> > needs explicit flushes for huge ptes it might just have to issue
> > multiple tlb invalidates and do them from tlb_start_vma()/tlb_end_vma().
> 
> I'm not too concerned about this.  We can make the flush code check both
> page sizes at a small cost in efficiency, relative to the overall cost of
> global TLB invalidation.

OK, that's basically what I made it do now:

Index: linux-2.6/arch/tile/kernel/tlb.c
===================================================================
--- linux-2.6.orig/arch/tile/kernel/tlb.c
+++ linux-2.6/arch/tile/kernel/tlb.c
@@ -64,14 +64,13 @@ void flush_tlb_page(const struct vm_area
 }
 EXPORT_SYMBOL(flush_tlb_page);

-void flush_tlb_range(const struct vm_area_struct *vma,
+void flush_tlb_range(const struct mm_struct *mm,
                     unsigned long start, unsigned long end)
 {
-       unsigned long size = hv_page_size(vma);
-       struct mm_struct *mm = vma->vm_mm;
-       int cache = (vma->vm_flags & VM_EXEC) ? HV_FLUSH_EVICT_L1I : 0;
-       flush_remote(0, cache, &mm->cpu_vm_mask, start, end - start, size,
-                    &mm->cpu_vm_mask, NULL, 0);
+       flush_remote(0, HV_FLUSH_EVICT_L1I, &mm->cpu_vm_mask,
+                    start, end - start, PAGE_SIZE, &mm->cpu_vm_mask, NULL, 0);
+       flush_remote(0, 0, &mm->cpu_vm_mask,
+                    start, end - start, HPAGE_SIZE, &mm->cpu_vm_mask, NULL, 0);
 }

And I guess that if the update_mmu_cache() thing works out we can remove
the HV_FLUSH_EVICT_L1I thing.



