Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab0DIXyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 19:54:41 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:50108 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab0DIXye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:54:34 -0400
Date: Sat, 10 Apr 2010 01:54:21 +0200
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
Message-ID: <20100409235421.GH28964@cmpxchg.org>
References: <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org> <20100409013012.GA8153@liondog.tnic> <20100409092111.GA998@a1.tnic> <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org> <20100409174041.GA10780@a1.tnic> <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org> <20100409191425.GB10780@a1.tnic> <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org> <20100409204328.GG28964@cmpxchg.org> <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 04:22:19PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 9 Apr 2010, Johannes Weiner wrote:
> > +	/*
> > +	 * 1. case: vma and next are split parts of one root vma.
> > +	 * Their anon_vma_chain is equal and we can drop that of next.
> > +	 *
> > +	 * 2. case: one vma was instantiated as mergeable with the
> > +	 * other one and inherited the other one's primary anon_vma as
> > +	 * the singleton in its chain.
> > +	 *
> > +	 * If next came after vma, vma's chain is already an unstrict
> > +	 * superset of next's and we can treat it like case 1.
> > +	 *
> > +	 * If vma has the singleton chain, we have to copy next's
> > +	 * unique anon_vmas over.
> > +	 */
> 
> This comment makes my head hurt. In fact, the whole anon_vma thing hurts 
> my head.

I can relate ;)

> Can we have some better high-level documentation on what happens for all 
> the cases.
> 
>  - split (mprotect, or munmap in the middle):
> 
> 	anon_vma_clone: the two vma's will have the same anon_vma, and the 
> 	anon_vma chains will be equivalent. 
> 
>  - merge (mprotect that creates a mergeable state):
> 
> 	anon_vma_merge: we're supposed to have a anon_vma_chain that is 
> 	a superset of the two chains of the merged entries.
> 
>  - fork:
> 
> 	anon_vma_fork: each new vma will have a _new_ anon_vma as it's 
> 	primary one, and will link to the old primary trough the 
> 	anon_vma_chain. It's doing this with a anon_vma_clone() followed 
> 	by adding an entra entry to the new anon_vma, and setting 
> 	vma->anon_vma to the new one.
> 
>  - create/mmap:
> 
> 	anon_vma_prepare: find a mergeable anon_vma and use that as a 
> 	singleton, because the other entries on the anon_vma chain won't 
> 	matter, since they cannot be associated with any pages associated 
> 	with the newly created vma..
> 
> Correct?
> 
> Quite frankly, just looking at that, I can't see how we get to your rules. 
> At least not trivially. Especially with multiple merges, I don't see 
> how "singleton" is such a special case.

The key is that merging is only possible if the primary anon_vmas are
equivalent.

This only happens if we split a vma in two and clone the old vma's
anon_vma_chain into the new vma.  So the chains are equivalent.

Or anon_vma_prepare() finds a mergeable anon_vma, in which case this
will be the singleton on the vma's chain.

If a split vma is merged, the old anon_vma_chains are equivalent, we
drop one completely and the one that stays has not changed.

If a mergeable vma (singleton anon_vma) is merged into another one,
this singleton is the primary anon_vma of the swallowing vma, thus
already linked and the swallowing vma's anon_vma_chain stays unchanged.

If it's the other way round and the singleton vma swallows the other
one, every anon_vma of the vanishing vma is moved over (except your
singleton anon_vma, you already have that).  The result should look
exactly like the chain we swallowed.  So in all this merging, no
unique and new combination of anon_vma_chains should have been
created!  Thus you can merge as much as you want, either you swallow
singletons and don't change yourself or you are the singleton and
after the merger have an equivalent anon_vma_chain to the vma you
swallowed.

Again: no new anon_vmas should enter the game for mergeable vmas and
no _new_ anon_vma_chains should be created while merging.  Thus it
is always true that you either merge with a singleton or the chains
are equivalent.

At least those are my assumptions.  Maybe they are crap, but I don't
see how right now.

And according to Boris' test, somewhere we still drop anon_vmas
where we let pages in the field pointing at them.

	Hannes
