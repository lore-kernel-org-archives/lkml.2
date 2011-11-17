Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1KQGV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 01:21:58 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64732 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab1KQGV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 01:21:57 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1111161540060.1861@sister.anvils>
References: <1320082040-1190-1-git-send-email-aarcange@redhat.com>
	<alpine.LSU.2.00.1111032318290.2058@sister.anvils>
	<20111104235603.GT18879@redhat.com>
	<CAPQyPG5i87VcnwU5UoKiT6_=tzqO_NOPXFvyEooA1Orbe_ztGQ@mail.gmail.com>
	<20111105013317.GU18879@redhat.com>
	<CAPQyPG5Y1e2dac38OLwZAinWb6xpPMWCya2vTaWLPi9+vp1JXQ@mail.gmail.com>
	<20111107131413.GA18279@suse.de>
	<20111107154235.GE3249@redhat.com>
	<20111107162808.GA3083@suse.de>
	<20111109012542.GC5075@redhat.com>
	<20111116140042.GD3306@redhat.com>
	<alpine.LSU.2.00.1111161540060.1861@sister.anvils>
Date: Thu, 17 Nov 2011 14:21:56 +0800
Message-ID: <CAPQyPG42q5A1J4VC69e2b72Hi4QcTcYs5-KOcwVaT8P_bsVPRw@mail.gmail.com>
Subject: Re: [PATCH] mremap: enforce rmap src/dst vma ordering in case of
 vma_merge succeeding in copy_vma
From: Nai Xia <nai.xia@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Pawel Sikora <pluto@agmk.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 8:16 AM, Hugh Dickins <hughd@google.com> wrote:
> On Wed, 16 Nov 2011, Andrea Arcangeli wrote:
>> On Wed, Nov 09, 2011 at 02:25:42AM +0100, Andrea Arcangeli wrote:
>> > Also note, if we find a way to enforce orderings in the prio tree (not
>> > sure if it's possible, apparently it's already using list_add_tail
>> > so..), then we could also remove the i_mmap_lock from mremap and fork.
>>
>> I'm not optimistic we can enforce ordering there. Being a tree it's
>> walked in range order.
>>
>> I thought of another solution that would avoid having to reorder the
>> list in mremap and avoid the i_mmap_mutex to be added to fork (and
>> then we can remove it from mremap too). The solution is to rmap_walk
>> twice. I mean two loops over the same_anon_vma for those rmap walks
>> that must be reliable (that includes two calls of
>> unmap_mapping_range). For both same_anon_vma and prio tree.
>>
>> Reading truncate_pagecache I see two loops already and a comment
>> saying it's for fork(), to avoid leaking ptes in the child. So fork is
>> probably ok already without having to take the i_mmap_mutex, but then
>> I wonder why that also doesn't fix mremap if we do two loops there and
>> why that i_mmap_mutex is really needed in mremap considering those two
>> calls already present in truncate_pagecache. I wonder if that was a
>> "theoretical" fix that missed the fact truncate already walks the prio
>> tree twice, so it doesn't matter if the rmap_walk goes in the opposite
>> direction of move_page_tables? That i_mmap_lock in mremap (now
>> i_mmap_mutex) is there since start of git history. The double loop was
>> introduced in d00806b183152af6d24f46f0c33f14162ca1262a. So it's very
>> possible that i_mmap_mutex is now useless (after
>> d00806b183152af6d24f46f0c33f14162ca1262a) and the fix for fork, was
>> already taking care of mremap too and that i_mmap_mutex can now be
>> removed.
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

I think this cannot happen either with proper ordering or with the tree lock
and Andrea was talking about if the two loops setup can avoid taking the
tree lock in mremap().

So, a simple answer would be: No, the two loops setup does not aim at
solving the PTE copy racing in fork() (it's lucky though), so can cannot
solve the problem of mremap either.

>
> Probably not an everyday occurrence :)
>
> But, setting that aside, I've always thought of that second call to
> unmap_mapping_range() as a regrettable expedient that we should try
> to eliminate e.g. by checking for private mappings in the first pass,
> and skipping the second call if there were none.

Don't you think this is only a partial solution? Given that
truncate_inode_page() does not shoot down cowed ptes,  the zap of
ptes and the cache pages are not atomic anyway,
so the second pass seems unavoidable for general cases....

Of course, if you let  truncate_inode_page()  has an option to unmap
cowed ptes, the second pass may not be needed, but then you may worry
about the performance.... a real dilemma, isn't it?  :)

>
> But since nobody ever complained about that added overhead, I never
> got around to bothering; and you may consider the i_mmap_mutex in
> move_ptes a more serious unnecessary overhead.
>
> By the way, you mention "a comment saying it's for fork()": I don't
> find "fork" anywhere in mm/truncate.c, my understanding is in this
> comment (probably mine) from truncate_pagecache():
>
>        /*
>         * unmap_mapping_range is called twice, first simply for
>         * efficiency so that truncate_inode_pages does fewer
>         * single-page unmaps.  However after this first call, and
>         * before truncate_inode_pages finishes, it is possible for
>         * private pages to be COWed, which remain after
>         * truncate_inode_pages finishes, hence the second
>         * unmap_mapping_range call must be made for correctness.
>         */
>
> The second call was not (I think) necessary when we relied upon
> truncate_count, but became necessary once Nick relied upon page lock
> (the page lock on the file page providing no guarantee for the COWed
> page).

Hmm, yes, do_wp_page() does not take the page lock when doing COW
(only the PTE lock), but I think another citical reason for the second pass
is that nothing can prevent a just zapped pte from launching a write fault
again and get COWed in __do_fault(), just *before* truncate_inode_pages()
can take the its page lock.., so even if we bring do_wp_page()  under control
of page lock, the second pass is still needed, right?

Nai
>
> Hugh
>
