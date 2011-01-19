Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab1ASRKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:10:41 -0500
Received: from canuck.infradead.org ([134.117.69.58]:56463 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1ASRKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:10:39 -0500
Subject: Re: [PATCH 00/21] mm: Preemptibility -v6
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, Nick Piggin <npiggin@kernel.dk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <alpine.LSU.2.00.1101172301340.2899@sister.anvils>
References: <20101126143843.801484792@chello.nl>
	 <alpine.LSU.2.00.1101172301340.2899@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 Jan 2011 18:10:39 +0100
Message-ID: <1295457039.28776.137.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 23:12 -0800, Hugh Dickins wrote:

> However, there's one more-than-cleanup that I think you will need to add:
> the ZAP_BLOCK_SIZE zap_work stuff is still there, but I think it needs
> to be removed now, with the need_resched() and other checks moved down
> from unmap_vmas() to inside the pagetable spinlock in zap_pte_range().
> 
> Because you're now accumulating more work than ever in the mmu_gather's
> buffer, and the more so with the 20/21 extended list: but this amounts
> to a backlog of work which will *usually* be done at the tlb_finish_mmu,
> but when memory is low (no extra buffers) may need flushing earlier -
> as things stand, while holding the pagetable spinlock, so introducing
> a large unpreemptible latency under those conditions.
> 
> I believe that along with the need_resched() check moved inside
> zap_pte_range(), you need to check if the mmu_gather buffer is full,
> and if so drop pagetable spinlock while you flush it.  Hmm, but if
> it's extensible, then it wasn't full: I've not worked out how this
> would actually fit together.

Very good point!! I'll work on this, I'll probably do a few of those
cleanups previously left undone too, I'm seriously doubting the
usefulness of the whole restart_addr muck now that its preemptible.

> (I also believe that when memory is low, we *ought* to be freeing up
> the pages sooner: perhaps all the GFP_ATOMICs should be GFP_NOWAITs.)

Agreed, I've moved everything to: GFP_NOWAIT | __GFP_NOWARN. 

> I found patch ordering a bit odd: I'm going to comment on them in
> what seems a more natural ordering to me: if Andrew folds your 00
> comments into 01 as he usually does, then I'd rather see them on the
> main preemptible mmu_gather patch, than on reverting some anon_vma
> annotations! 

Shouldn't we simply ask for better changelogs instead of Andrew doing
that? That said, I do like your order better, so did indeed reorder as
you suggest.

>  And with anon_vma->lock already nested inside i_mmap_lock,
> I think the anon_vma mods are secondary, and can just follow after.
> 
> 08/21 mm-preemptible_mmu_gather.patch
>       Acked-by: Hugh Dickins <hughd@google.com>
>       But I'd prefer __tlb_alloc_pages() be named __tlb_alloc_page(),
>       and think it should pass __GFP_NOWARN with its GFP_ATOMIC (same
>       remark would apply in several other patches too).

Did the rename, and like mentioned, switched to GFP_NOWAIT |
__GFP_NOWARN for everything.

> 09/21 powerpc-preemptible_mmu_gather.patch
>       I'll leave Acking to Ben, but it looked okay so far as I could tell.
>       I worry how much (unpreemptible) work happens in __flush_tlb_pending
>       in __switch_to, whether PPC64_TLB_BATCH_NR 192 ought to be smaller
>       now (I wonder where 192 came from originally); move the _TLF_LAZY_MMU
>       block below _switch() to after the local_irq_restore(flags)?
>       The mods to hpte_need_flush() look like what we need in 2.6.37-stable
>       to keep CONFIG_DEBUG_PREEMPT vfree() quiet, perhaps should be separated
>       out - but perhaps they're inappropriate and Ben has another fix in mind.

I'll await Ben's answer on this, but yeah, he might consider tuning the
192.

> 10/21 sparc-preemptible_mmu_gather.patch
>       Similarly, looked okay so far as I could tell, and this one was
>       already doing flush_tlb_pending in switch_to; more of the 192
>       (not from you, of course).  tlb_batch_add() has some commented-out
>       (tb->fullmm) code that you probably meant to come back to.
>       mm/init_32.c still has DEFINE_PER_CPU(struct mmu_gather, mmu_gathers).

Ah, right.. XXX

> 11/21 s390-preemptible_mmu_gather.patch
>       I'd prefer __tlb_alloc_page(), with __GFP_NOWARN as suggested above.
>       mm/pgtable.c still has DEFINE_PER_CPU(struct mmu_gather, mmu_gathers).

Martin, while doing the below DEFINE_PER_CPU removal I saw you had a
bunch of RCU table removal thingies in arch/s390/mm/pgtable.c, could
s390 use the generic bits like sparc and powerpc (see patch 16)?

> 12/21 arm-preemptible_mmu_gather.patch
> 13/21 sh-preemptible_mmu_gather.patch
> 14/21 um-preemptible_mmu_gather.patch
> 15/21 ia64-preemptible_mmu_gather.patch
>       All straightforward, but DEFINE_PER_CPU(struct mmu_gather, mmu_gathers)
>       still to be removed from these and other arches.

I've added a patch removing all the DEFINE_PER_CPU(struct mmu_gather,
mmu_gathers) thingies.

One thing I was wondering about, should I fold all these patches into
one big patch to improve bisectability? Because after the first patch
all !generic-tlb archs won't compile anymore due to the mm/* changes.

> 16/21 mm_powerpc-move_the_rcu_page-table_freeing_into.patch
>       Seems good, prefer Ben and Dave to Ack.  "copmletion" -> "completion".

Fixed the typo, thanks!

> 18/21 mutex-provide_mutex_is_contended.patch
>       I suppose so, though if we use it in the truncate path, then we are
>       stuck with the vm_truncate_count stuff I'd rather hoped would go away;
>       but I guess you're right, that if we did spin_needbreak/need_lockbreak
>       before, then we ought to do this now - though I suspect I only added
>       it because I had to insert a resched-point anyway, and it seemed a good
>       idea at the time to check lockbreak too since that had just been added.

Since its now preemptable we might consider simply removing that. I
simply wanted to keep the changes to a minimum for now.

> 19/21 mm-convert_i_mmap_lock_and_anon_vma-_lock_to_mutexes.patch
>       I suggest doing just the i_mmap_lock->mutex conversion at this point.
>       Acked-by: Hugh Dickins <hughd@google.com>
>       except that in the past we have renamed a lock when we've done this
>       kind of conversion, so I'd expect i_mmap_mutex throughout now.
>       Or am I just out of date?  I don't feel very strongly about it.

Done, split the conversion and did the s/_lock/_mutex/ thing.

> 20/21 mm-extended_batches_for_generic_mmu_gather.patch
>       Acked-by: Hugh Dickins <hughd@google.com>
>       though it struck me as overdesign at first: I guess Nick wanted it
>       because he had an implementation that used the pagetables themselves,
>       hence an assured supply of these buffers.  tlb_finish_mmu(), and
>       perhaps others, looking rather too big for inline by this stage.

Yeah, they are a bit beefy, maybe I should move some of that into
mm/memory.c.

> 04/21 mm-rename_drop_anon_vma_to_put_anon_vma.patch
>       Acked-by: Hugh Dickins <hughd@google.com>
>       but (if you don't mind: leave it to me if you prefer) in mm/ksm.c
>       please just remove wrappers hold_anon_vma() and ksm_put_anon_vma():
>       they had a point when they originated the refcount but no point now.
>       Note there are now two places to update in mm/migrate.c in 38-rc1.

Done, zapped those wrappers.

> 05/21 mm-move_anon_vma_ref_out_from_under_config_ksm.patch
>       Acked-by: Hugh Dickins <hughd@google.com>
>       but you shouldn't need to touch mm/migrate.c again here with 38-rc1.
>       Didn't you end up double-decrementing refcount in the huge_page case?

I'm afraid I need a little help here, what huge_page case? I tried
applying this comment to both patches 5 and 6, but failed to find a
huge_page case..

> 06/21 mm-simplify_anon_vma_refcounts.patch
>       Acked-by: Hugh Dickins <hughd@google.com>
>       except page_get_anon_vma() is being declared in rmap.h a patch early,
>       and you shouldn't need to touch mm/ksm.c again here with 38-rc1.
>       Did wonder if __put_anon_vma() is right to put anon_vma->root *before*
>       freeing anon_vma, but suppose your not_zero strictness makes it safe.

It seemed like the natural order to do things, release the reference we
hold on ->root right before we free ourselves.

The race you're worried about is the page_lock_anon_vma() where we
access ->root? Afaict that's ok because we check page_mapped() and
decrementing that should be done _before_ the last put_anon_vma(),
otherwise that function is already racy.

> 07/21 mm-use_refcounts_for_page_lock_anon_vma.patch
>       Acked-by: Hugh Dickins <hughd@google.com>
>       but here I'm expecting you to use your page_get_anon_vma() in
>       mm/migrate.c too, to replace my 38-rc1 lock/get/unlock sequences.

done

>       Second page_mapped() test in page_get_anon_vma(): remove "goto out;"
>       from that block, it's already reached "out".  

Paranoia on my side, done.

>       In patch description,
>       didn't understand "for each of convertion": "for sake of conversion"?

Uhm.. yeah my brain must have slipped there or something, not quite sure
what I meant, let me make that:

 "This is done to prepare for the conversion of anon_vma from spinlock
to mutex."

>       This brings us to a nice point, ready for the lock->mutex conversion:
>       the only defect being the doubled atomics in page_(un)lock_anon_vma.

Yeah, that double atomic is sadness, you've seen what I've come up with
to avoid that..

> 19/21 mm-convert_i_mmap_lock_and_anon_vma-_lock_to_mutexes.patch
>       I suggest doing the anon_vma lock->mutex conversion separately here.
>       Acked-by: Hugh Dickins <hughd@google.com>
>       except that in the past we have renamed a lock when we've done this
>       kind of conversion, so I'd expect anon_vma->mutex throughout now.
>       Or am I just out of date?  I don't feel very strongly about it.

Done.. however:

Index: linux-2.6/include/linux/huge_mm.h
===================================================================
--- linux-2.6.orig/include/linux/huge_mm.h
+++ linux-2.6/include/linux/huge_mm.h
@@ -91,12 +91,8 @@ extern void __split_huge_page_pmd(struct
 #define wait_split_huge_page(__anon_vma, __pmd)				\
 	do {								\
 		pmd_t *____pmd = (__pmd);				\
-		spin_unlock_wait(&(__anon_vma)->root->lock);		\
-		/*							\
-		 * spin_unlock_wait() is just a loop in C and so the	\
-		 * CPU can reorder anything around it.			\
-		 */							\
-		smp_mb();						\
+		anon_vma_lock(__anon_vma);				\
+		anon_vma_unlock(__anon_vma);				\
 		BUG_ON(pmd_trans_splitting(*____pmd) ||			\
 		       pmd_trans_huge(*____pmd));			\
 	} while (0)

Andrea, is that smp_mb() simply to avoid us doing anything before the
lock is free? Why isn't there an mb() before to ensure nothing leaks
past it from the other end?

> 21/21 mm-optimize_page_lock_anon_vma_fast-path.patch
>       I certainly see the call for this patch, I want to eliminate those
>       doubled atomics too.  This appears correct to me, and I've not dreamt
>       up an alternative; but I do dislike it, and I suspect you don't like
>       it much either.  I'm ambivalent about it, would love a better patch.

Like said, I fully agree with that sentiment, just haven't been able to
come up with anything saner :/ Although I can optimize the
__put_anon_vma() path a bit by doing something like:

  if (mutex_is_locked()) { anon_vma_lock(); anon_vma_unlock(); }

But I bet that wants a barrier someplace and my head hurts.. 

> sparc64-Kill_page_table_quicklists.patch
> sparc64-Use_RCU_page_table_freeing.patch
> sparc64-Add_support_for__PAGE_SPECIA.patch
> sparc64-Implement_get_user_pages_fast.patch
>       I did not spend very long looking at these, none of my business really!
>       but did notice one thing I didn't like, that pte_special() is declared
>       unsigned long in the third, whereas int in every other architecture. I
>       think it should follow the ia64-style there, use != 0 to return an int.

Dave, do you want me to make those changes, or will you once the rest of
this stuff makes it upstream?

> A few checkpatch warnings, many of which I don't particularly agree with -
> though I do get annoyed by comments going over 80-cols without any need!

Agreed, although I didn't spot any comments crossing the 80-column
boundary.


