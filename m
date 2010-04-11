Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab0DKNUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 09:20:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38361 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab0DKNUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 09:20:04 -0400
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: [PATCH 1/3] mm: make page freeing path RCU-safe
Date: Sun, 11 Apr 2010 15:19:56 +0200
Message-Id: <1270991999-4004-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100411130801.GA7189@a1.tnic>
References: <20100411130801.GA7189@a1.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

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
 
-- 
1.7.0.3

