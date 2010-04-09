Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0DIUno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:43:44 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:60103 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab0DIUnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:43:43 -0400
Date: Fri, 9 Apr 2010 22:43:28 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas of a mergeable VMA
Message-ID: <20100409204328.GG28964@cmpxchg.org>
References: <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org> <20100408234721.GB25834@a1.tnic> <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org> <20100409013012.GA8153@liondog.tnic> <20100409092111.GA998@a1.tnic> <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org> <20100409174041.GA10780@a1.tnic> <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org> <20100409191425.GB10780@a1.tnic> <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 12:32:30PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 9 Apr 2010, Borislav Petkov wrote:
> > > 
> > > So what I _think_ will happen is that you'll be able to re-create the 
> > > problem that started this all.  But I'd like to verify that, just because 
> > > I'm anal and I'd like these things to be tested independently.
> > 
> > Heh, that was easy. Third hibernate cycle is a charm^Wboom :)
> 
> Ok, good to know that I'm still tracking ok on the issue.
> 
> > > So assuming that the original problem happens again, if you can then apply 
> > > Rik's patch, but add a
> > > 
> > > 	dst->anon_vma = src->anon_vma;
> > > 
> > > to just before the success case (the "return 0") in anon_vma_clone(), 
> > > that would be good.
> > 
> > It looks like this way we mangle the anon_vma chains somehow. From
> > what I can see and if I'm not mistaken, we save the anon_vmas alright
> > but end up in what seems like an endless list_for_each_entry()
> > loop having grabbed anon_vma->lock in page_lock_anon_vma() and we
> > can't seem to yield it through page_unlock_anon_vma() at the end of
> > page_referenced_anon() so it has to be that code in between iterating
> > over each list entry...
> 
> Ok. So scratch Rik's patch. It doesn't work even with the anon_vma set up.
> 
> Rik? I think it's back to you. I'm not going to bother committing the 
> change to the anon_vma locking unless you actually need the locking 
> guarantees for anon_vma_prepare().
> 
> And I've got the feeling that the proper fix is in the vma_adjust() 
> handling if your original idea was right.
> 
> Anybody?

Okay, I think I got it working.  I first thought we would need an
m^n loop to properly merge the anon_vma_chains, but we can actually
be cleverer than that:

---
Subject: mm: properly merge anon_vma_chains when merging vmas

Merging can happen when two VMAs were split from one root VMA or
a mergeable VMA was instantiated and reused a nearby VMA's anon_vma.

In both cases, none of the VMAs can grow any more anon_vmas and forked
VMAs can no longer get merged due to differing primary anon_vmas for
their private COW-broken pages.

In the split case, the anon_vma_chains are equal and we can just drop
the one of the VMA that is going away.

In the other case, the VMA that was instantiated later has only one
anon_vma on its chain: the primary anon_vma of its merge partner (due
to anon_vma_prepare()).

If the VMA that came later is going away, its anon_vma_chain is a
subset of the one that is staying, so it can be dropped like in the
split case.

Only if the VMA that came first is going away, its potential parent
anon_vmas need to be migrated to the VMA that is staying.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

It compiles and boots but I have not really excercised this code.
Boris, could you give it a spin?  Thanks!

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index d25bd22..ecef882 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -114,13 +114,7 @@ int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
 int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
 void __anon_vma_link(struct vm_area_struct *);
 void anon_vma_free(struct anon_vma *);
-
-static inline void anon_vma_merge(struct vm_area_struct *vma,
-				  struct vm_area_struct *next)
-{
-	VM_BUG_ON(vma->anon_vma != next->anon_vma);
-	unlink_anon_vmas(next);
-}
+void anon_vma_merge(struct vm_area_struct *, struct vm_area_struct *);
 
 /*
  * rmap interfaces called when adding or removing pte of page
diff --git a/mm/rmap.c b/mm/rmap.c
index eaa7a09..498a46e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -268,6 +268,58 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	}
 }
 
+void anon_vma_merge(struct vm_area_struct *vma, struct vm_area_struct *next)
+{
+	VM_BUG_ON(vma->anon_vma != next->anon_vma);
+	/*
+	 * 1. case: vma and next are split parts of one root vma.
+	 * Their anon_vma_chain is equal and we can drop that of next.
+	 *
+	 * 2. case: one vma was instantiated as mergeable with the
+	 * other one and inherited the other one's primary anon_vma as
+	 * the singleton in its chain.
+	 *
+	 * If next came after vma, vma's chain is already an unstrict
+	 * superset of next's and we can treat it like case 1.
+	 *
+	 * If vma has the singleton chain, we have to copy next's
+	 * unique anon_vmas over.
+	 */
+	if (!list_is_singular(&vma->anon_vma_chain)) {
+		unlink_anon_vmas(next);
+		return;
+	}
+	while (!list_empty(&next->anon_vma_chain)) {
+		struct anon_vma_chain *avc;
+
+		avc = list_first_entry(&next->anon_vma_chain,
+				struct anon_vma_chain, same_vma);
+		if (avc->anon_vma == vma->anon_vma) {
+			/*
+			 * The shared one that vma inherited in
+			 * anon_vma_prepare.  Don't copy it, we
+			 * already have it.
+			 */
+			spin_lock(&avc->anon_vma->lock);
+			list_del(&avc->same_anon_vma);
+			spin_unlock(&avc->anon_vma->lock);
+
+			list_del(&avc->same_vma);
+			anon_vma_chain_free(avc);
+		} else {
+			/*
+			 * One of the parent anon_vmas, move it over.
+			 * Make sure nobody walks the vma list while
+			 * the entries are in flux.
+			 */
+			spin_lock(&avc->anon_vma->lock);
+			avc->vma = vma;
+			list_move_tail(&avc->same_vma, &vma->anon_vma_chain);
+			spin_unlock(&avc->anon_vma->lock);
+		}
+	}
+}
+
 static void anon_vma_ctor(void *data)
 {
 	struct anon_vma *anon_vma = data;

