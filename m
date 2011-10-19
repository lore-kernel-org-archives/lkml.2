Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1JSHal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:30:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab1JSHak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:30:40 -0400
Date: Wed, 19 Oct 2011 09:30:36 +0200
From: Mel Gorman <mgorman@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: Pawel Sikora <pluto@agmk.net>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@vger.kernel.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
Message-ID: <20111019073036.GA3410@suse.de>
References: <201110122012.33767.pluto@agmk.net>
 <alpine.LSU.2.00.1110131547550.1346@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1110131547550.1346@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 04:16:01PM -0700, Hugh Dickins wrote:
> <SNIP>
> 
> I guess this is the only time you've seen this?  In which case, ideally
> I would try to devise a testcase to demonstrate the issue below instead;

Considering that mremap workloads have been tested fairly heavily and
this hasn't triggered before (or at least not reported), I would not be
confident it can be easily reproduced. Maybe reproducing is easier if
interrupts are also high.

> but that may involve more ingenuity than I can find time for, let's see
> see if people approve of this patch anyway (it applies to 3.1 or 3.0,
> and earlier releases except that i_mmap_mutex used to be i_mmap_lock).
> 
> 
> [PATCH] mm: add anon_vma locking to mremap move
> 
> I don't usually pay much attention to the stale "? " addresses in
> stack backtraces, but this lucky report from Pawel Sikora hints that
> mremap's move_ptes() has inadequate locking against page migration.
> 
>  3.0 BUG_ON(!PageLocked(p)) in migration_entry_to_page():
>  kernel BUG at include/linux/swapops.h:105!

This check is triggered if migration PTEs are left behind. In the few
cases I saw this during compaction development, it was because a VMA was
unreachable during remove_migration_pte. With the anon_vma changes, the
locking during VMA insertion is meant to protect it and the order VMAs
are linked is important so the right anon_vma lock is found.

I don't think it is an unreachable VMA problem because if it was, the
problem would trigger much more frequently and not be exclusive to
mremap.

>  RIP: 0010:[<ffffffff81127b76>]  [<ffffffff81127b76>]
>                        migration_entry_wait+0x156/0x160
>   [<ffffffff811016a1>] handle_pte_fault+0xae1/0xaf0
>   [<ffffffff810feee2>] ? __pte_alloc+0x42/0x120
>   [<ffffffff8112c26b>] ? do_huge_pmd_anonymous_page+0xab/0x310
>   [<ffffffff81102a31>] handle_mm_fault+0x181/0x310
>   [<ffffffff81106097>] ? vma_adjust+0x537/0x570
>   [<ffffffff81424bed>] do_page_fault+0x11d/0x4e0
>   [<ffffffff81109a05>] ? do_mremap+0x2d5/0x570
>   [<ffffffff81421d5f>] page_fault+0x1f/0x30
> 
> mremap's down_write of mmap_sem, together with i_mmap_mutex/lock,
> and pagetable locks, were good enough before page migration (with its
> requirement that every migration entry be found) came in; and enough
> while migration always held mmap_sem.  But not enough nowadays, when
> there's memory hotremove and compaction: anon_vma lock is also needed,
> to make sure a migration entry is not dodging around behind our back.
> 

migration holds the anon_vma lock while it unmaps the pages and keeps holding
it until after remove_migration_ptes is called.  There are two anon vmas
that should exist during mremap that were created for the move. They
should not be able to disappear while migration runs and right now, I'm
not seeing how the VMA can get lost :(

I think a consequence of this patch is that migration and mremap are now
serialised by anon_vma lock. As a result, it might still fix the problem
if there is some race between mremap and migration simply by stopping
them playing with each other.

> It appears that Mel's a8bef8ff6ea1 "mm: migration: avoid race between
> shift_arg_pages() and rmap_walk() during migration by not migrating
> temporary stacks" was actually a workaround for this in the special
> common case of exec's use of move_pagetables(); and we should probably
> now remove that VM_STACK_INCOMPLETE_SETUP stuff as a separate cleanup.
> 

The problem was that there was only one VMA for two page table
ranges. The neater fix was to create a second VMA but that required a
kmalloc and additional VMA work during exec which was considered too
heavy. VM_STACK_INCOMPLETE_SETUP is less clean but it is faster.
