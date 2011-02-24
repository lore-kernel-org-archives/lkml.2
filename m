Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1BXUr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:47:58 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52852 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1BXUrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:47:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=koJj2y76NRR+Fx/1LeARX4LEEa17n2lj1OFoZHt4NjW/aaTJTqsJHid8L8Qz+F+tpU
         ZuuPBdskRQF7UPOleoAA==
Date: Thu, 24 Feb 2011 12:47:32 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: PowerPC BUG: using smp_processor_id() in preemptible code
In-Reply-To: <1293705910.17779.60.camel@pasglop>
Message-ID: <alpine.LSU.2.00.1102241216420.1708@sister.anvils>
References: <alpine.LSU.2.00.1012291413360.22939@sister.anvils> <1293705910.17779.60.camel@pasglop>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010, Benjamin Herrenschmidt wrote:
> On Wed, 2010-12-29 at 14:54 -0800, Hugh Dickins wrote:
> > With recent 2.6.37-rc, with CONFIG_PREEMPT=y CONFIG_DEBUG_PREEMPT=y
> > on the PowerPC G5, I get spammed by BUG warnings each time I swapoff:
> > 
> > BUG: using smp_processor_id() in preemptible [00000000] code: swapoff/3974
> > caller is .hpte_need_flush+0x4c/0x2e8
> > Call Trace:
> > [c0000001b4a3f830] [c00000000000f3cc] .show_stack+0x6c/0x16c (unreliable)
> > [c0000001b4a3f8e0] [c00000000023eda0] .debug_smp_processor_id+0xe4/0x11c
> > [c0000001b4a3f970] [c00000000002f2f4] .hpte_need_flush+0x4c/0x2e8
> > [c0000001b4a3fa30] [c0000000000e7ef8] .vunmap_pud_range+0x148/0x200
> > [c0000001b4a3fb10] [c0000000000e8058] .vunmap_page_range+0xa8/0xd4
> > [c0000001b4a3fbb0] [c0000000000e80a4] .free_unmap_vmap_area+0x20/0x38
> > [c0000001b4a3fc40] [c0000000000e8138] .remove_vm_area+0x7c/0xb4
> > [c0000001b4a3fcd0] [c0000000000e8308] .__vunmap+0x50/0x104
> > [c0000001b4a3fd60] [c0000000000ef3fc] .SyS_swapoff+0x59c/0x6a8
> > [c0000001b4a3fe30] [c0000000000075a8] syscall_exit+0x0/0x40
> > 
> > I notice hpte_need_flush() itself acknowledges
> >  * Must be called from within some kind of spinlock/non-preempt region...
> 
> Yes, we assume that the PTE lock is always held when modifying page
> tables...

Right, not for the kernel page tables.  I remember when doing the
pte_offset_map_lock() stuff, that it appeared that the kernel would
already be in trouble if it did not have higher serialization for
its pte updates, so no point in using a page_table_lock for them.

> 
> > Though I didn't actually bisect, I believe this is since Jeremy's
> > 64141da587241301ce8638cc945f8b67853156ec "vmalloc: eagerly clear ptes
> > on vunmap", which moves a call to vunmap_page_range() from one place
> > (which happened to be inside a spinlock) to another (where it's not).
> > 
> > I guess my warnings would be easily silenced by moving that call to
> > vunmap_page_range() down just inside the spinlock below it; but I'm
> > dubious that that's the right fix - it looked as if there are other
> > paths through vmalloc.c where vunmap_page_range() has been getting
> > called without preemption disabled, long before Jeremy's change,
> > just paths that I never happen to go down in my limited testing.
> > 
> > For the moment I'm using the obvious patch below to keep it quiet;
> > but I doubt that this is the right patch either.  I'm hoping that
> > ye who understand the importance of hpte_need_flush() will be best
> > able to judge what to do.  Or might there be other architectures
> > expecting to be unpreemptible there?
> 
> Well, it looks like our kernel mappings tend to take some nasty
> shortcuts with the PTE locking, which I suppose are legit but do break
> some of my assumptions there. I need to have a closer look. Thanks for
> the report !

None of us have progressed this since late in 2.6.37-rc, and now
it's late in 2.6.38-rc and we're still in the same situation.

The patch I'm currently using to suppress all the noise (I suppose
I could just turn off DEBUG_PREEMPT but that would be cheating) is an
extract from Peter's preemptible mmu_gather patches, below, but I don't
really know if it's valid to extract it in this way.

Reading back, I see Jeremy suggested moving vb_free()'s call to
vunmap_page_range() back inside vb->lock: it certainly was his moving
the call out from under that lock that brought the issue to my notice;
but it looked as if there were other paths which would give preemptible
PowerPC the same issue, just paths I happen not to go down myself. I'm
not sure, I didn't take the time to follow it up properly, expecting
further insight to arrive shortly from Ben!

And, as threatened, Jeremy has further vmalloc changes queued up in
mmotm, which certainly make the patch below inadequate, and I imagine
the vunmap_page_range() movement too.  I'm currently (well, I think most
recent mmotm doesn't even boot on my ppc) having to disable preemption
in the kernel case of apply_to_pte_range().

What would be better for 2.6.38 and 2.6.37-stable?  Moving that call to
vunmap_page_range back under vb->lock, or the partial-Peter-patch below?
And then what should be done for 2.6.39?

Hugh

--- 2.6.38-rc5/arch/powerpc/mm/tlb_hash64.c	2010-02-24 10:52:17.000000000 -0800
+++ linux/arch/powerpc/mm/tlb_hash64.c	2011-02-15 23:27:21.000000000 -0800
@@ -38,13 +38,11 @@ DEFINE_PER_CPU(struct ppc64_tlb_batch, p
  * neesd to be flushed. This function will either perform the flush
  * immediately or will batch it up if the current CPU has an active
  * batch on it.
- *
- * Must be called from within some kind of spinlock/non-preempt region...
  */
 void hpte_need_flush(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, unsigned long pte, int huge)
 {
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = &get_cpu_var(ppc64_tlb_batch);
 	unsigned long vsid, vaddr;
 	unsigned int psize;
 	int ssize;
@@ -99,6 +97,7 @@ void hpte_need_flush(struct mm_struct *m
 	 */
 	if (!batch->active) {
 		flush_hash_page(vaddr, rpte, psize, ssize, 0);
+		put_cpu_var(ppc64_tlb_batch);
 		return;
 	}
 
@@ -127,6 +126,7 @@ void hpte_need_flush(struct mm_struct *m
 	batch->index = ++i;
 	if (i >= PPC64_TLB_BATCH_NR)
 		__flush_tlb_pending(batch);
+	put_cpu_var(ppc64_tlb_batch);
 }
 
 /*
