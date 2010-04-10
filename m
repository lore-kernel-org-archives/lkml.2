Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab0DJS1B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 14:27:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091Ab0DJS07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 14:26:59 -0400
Date: Sat, 10 Apr 2010 11:21:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
References: <20100409191425.GB10780@a1.tnic> <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org> <20100409204328.GG28964@cmpxchg.org> <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
 <20100410003110.GI28964@cmpxchg.org> <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org> <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic> <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org> <20100410163828.GA25579@a1.tnic>
 <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Apr 2010, Linus Torvalds wrote:
> On Sat, 10 Apr 2010, Borislav Petkov wrote:
> > 
> > And I got an oops again, this time the #GP from couple of days ago.
> 
> Oh damn. So the list corruption really does happen still.

Ho humm.

Maybe I'm crazy, but something started bothering me. And I started 
wondering: when is the 'page->mapping' of an anonymous page actually 
cleared?

The thing is, the mapping of an anonymous page is actually cleared only 
when the page is _freed_, in "free_hot_cold_page()". 

Now, let's think about that. And in particular, let's think about how that 
relates to the freeing of the 'anon_vma' that the page->mapping points to. 

The way the anon_vma is freed is when the mapping is torn down, and we do 
roughly:

	tlb = tlb_gather_mmu(mm,..)
	..
	unmap_vmas(&tlb, vma ..
	..
	free_pgtables()
	..
	tlb_finish_mmu(tlb, start, end);

and we actually unmap all the pages in "unmap_vmas()", and then _after_ 
unmapping all the pages we do the "unlink_anon_vmas(vma);" in 
"free_pgtables()". Fine so far - the anon_vma stay around until after the 
page has been happily unmapped.

But "unmapped all the pages" is _not_ actually the same as "free'd all the 
pages". The actual _freeing_ of the page happens generally in 
tlb_finish_mmu(), because we can free the page only after we've flushed 
any TLB entries.

So what we have in that tlb_gather structure is a list of _pending_ pages 
to be freed, while we already actually free'd the anon_vmas earlier!

Now, the thing is, tlb_gather_mmu() begins a preempt-safe region (because 
we use a per-cpu variable), but as far as I can tell it is _not_ an 
RCU-safe region.

So I think we might actually get a real RCU freeing event while this all
happens. So now the 'anon_vma' that 'page->mapping' points to has not just 
been released back to the SLUB caches, the page itself might have been 
released too.

I dunno. Does the above sound at all sane? Or am I just raving?

Something hacky like the above might fix it if I'm not just raving. I 
really might be missing something here.

		Linus

---
 include/asm-generic/tlb.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index e43f976..2678118 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -14,6 +14,7 @@
 #define _ASM_GENERIC__TLB_H
 
 #include <linux/swap.h>
+#include <linux/rcupdate.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
@@ -62,6 +63,7 @@ tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
 
 	tlb->fullmm = full_mm_flush;
 
+	rcu_read_lock();
 	return tlb;
 }
 
@@ -90,6 +92,7 @@ tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
+	rcu_read_unlock();
 	put_cpu_var(mmu_gathers);
 }
 
