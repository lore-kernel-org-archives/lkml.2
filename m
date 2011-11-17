Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1KQCud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 21:50:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60271 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab1KQCuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 21:50:32 -0500
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
To: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mremap: enforce rmap src/dst vma ordering in case of vma_merge succeeding in copy_vma
Date: Thu, 17 Nov 2011 10:49:24 +0800
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic-pae; KDE/4.6.5; i686; ; )
Cc: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Pawel Sikora <pluto@agmk.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
References: <1320082040-1190-1-git-send-email-aarcange@redhat.com> <20111116140042.GD3306@redhat.com> <alpine.LSU.2.00.1111161540060.1861@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1111161540060.1861@sister.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111171049.24779.nai.xia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 November 2011 08:16:57 Hugh Dickins wrote:
> On Wed, 16 Nov 2011, Andrea Arcangeli wrote:
> > On Wed, Nov 09, 2011 at 02:25:42AM +0100, Andrea Arcangeli wrote:
> > > Also note, if we find a way to enforce orderings in the prio tree (not
> > > sure if it's possible, apparently it's already using list_add_tail
> > > so..), then we could also remove the i_mmap_lock from mremap and fork.
> > 
> > I'm not optimistic we can enforce ordering there. Being a tree it's
> > walked in range order.
> > 
> > I thought of another solution that would avoid having to reorder the
> > list in mremap and avoid the i_mmap_mutex to be added to fork (and
> > then we can remove it from mremap too). The solution is to rmap_walk
> > twice. I mean two loops over the same_anon_vma for those rmap walks
> > that must be reliable (that includes two calls of
> > unmap_mapping_range). For both same_anon_vma and prio tree.
> > 
> > Reading truncate_pagecache I see two loops already and a comment
> > saying it's for fork(), to avoid leaking ptes in the child. So fork is
> > probably ok already without having to take the i_mmap_mutex, but then
> > I wonder why that also doesn't fix mremap if we do two loops there and
> > why that i_mmap_mutex is really needed in mremap considering those two
> > calls already present in truncate_pagecache. I wonder if that was a
> > "theoretical" fix that missed the fact truncate already walks the prio
> > tree twice, so it doesn't matter if the rmap_walk goes in the opposite
> > direction of move_page_tables? That i_mmap_lock in mremap (now
> > i_mmap_mutex) is there since start of git history. The double loop was
> > introduced in d00806b183152af6d24f46f0c33f14162ca1262a. So it's very
> > possible that i_mmap_mutex is now useless (after
> > d00806b183152af6d24f46f0c33f14162ca1262a) and the fix for fork, was
> > already taking care of mremap too and that i_mmap_mutex can now be
> > removed.
> 
> As you found, the mremap locking long predates truncation's double unmap.
> 
> That's an interesting point, and you may be right - though, what about
> the *very* unlikely case where unmap_mapping_range looks at new vma
> when pte is in old, then at old vma when pte is in new, then
> move_page_tables runs out of memory and cannot complete, then the
> second unmap_mapping_range looks at old vma while pte is still in new
> (I guess this needs some other activity to have jumbled the prio_tree,
> and may just be impossible), then at new (to be abandoned) vma after
> pte has moved back to old.
> 
> Probably not an everyday occurrence :)
> 
> But, setting that aside, I've always thought of that second call to
> unmap_mapping_range() as a regrettable expedient that we should try
> to eliminate e.g. by checking for private mappings in the first pass,
> and skipping the second call if there were none.
> 
> But since nobody ever complained about that added overhead, I never
> got around to bothering; and you may consider the i_mmap_mutex in
> move_ptes a more serious unnecessary overhead.
> 
> By the way, you mention "a comment saying it's for fork()": I don't
> find "fork" anywhere in mm/truncate.c, my understanding is in this
> comment (probably mine) from truncate_pagecache():

I think you guys are talking about two different COWs:

Andrea's question is that if a new VMA is created by fork() between
the two loops and PTEs are getting copied.

And you are refering to the new PTEs get COWed by __do_fault() in 
the same VMA before the cache pages are really dropped.

>From my point of view, the two loops there are really fork() 
irrelevant, as you said, they are only for missed COWed ptes in the 
same VMA before a cache page is really blind for find_get_page(). 




As for Andrea's reasoning, I think I deem this racing story as below:

1. fork() is safe without tree lock/mutex after the second loop, the 
reason is just why it's safe for the try_to_unmap_file: the new VMA is
really linked as list tail in a *same* tree node as the old VMA in 
vma prio_tree. The old and new are traveled by vma_prio_tree_foreach() 
in a proper order. And fork() does not include a error path requiring 
backward page table copy operation which needs a reverse order.

2. Partial mremap is not safe for this without tree lock/mutex, because the src
and dst VMA are different prio_tree nodes, and their order are not meant to 
be screwed.



Nai

> 
> 	/*
> 	 * unmap_mapping_range is called twice, first simply for
> 	 * efficiency so that truncate_inode_pages does fewer
> 	 * single-page unmaps.  However after this first call, and
> 	 * before truncate_inode_pages finishes, it is possible for
> 	 * private pages to be COWed, which remain after
> 	 * truncate_inode_pages finishes, hence the second
> 	 * unmap_mapping_range call must be made for correctness.
> 	 */
> 
> The second call was not (I think) necessary when we relied upon
> truncate_count, but became necessary once Nick relied upon page lock
> (the page lock on the file page providing no guarantee for the COWed
> page).
> 
> Hugh
> 
