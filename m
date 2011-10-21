Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab1JUMoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:44:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab1JUMoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:44:20 -0400
Date: Fri, 21 Oct 2011 14:44:15 +0200
From: Mel Gorman <mgorman@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: Pawel Sikora <pluto@agmk.net>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@vger.kernel.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
Message-ID: <20111021124415.GB4082@suse.de>
References: <201110122012.33767.pluto@agmk.net>
 <alpine.LSU.2.00.1110131547550.1346@sister.anvils>
 <20111019073036.GA3410@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20111019073036.GA3410@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 09:30:36AM +0200, Mel Gorman wrote:
> >  RIP: 0010:[<ffffffff81127b76>]  [<ffffffff81127b76>]
> >                        migration_entry_wait+0x156/0x160
> >   [<ffffffff811016a1>] handle_pte_fault+0xae1/0xaf0
> >   [<ffffffff810feee2>] ? __pte_alloc+0x42/0x120
> >   [<ffffffff8112c26b>] ? do_huge_pmd_anonymous_page+0xab/0x310
> >   [<ffffffff81102a31>] handle_mm_fault+0x181/0x310
> >   [<ffffffff81106097>] ? vma_adjust+0x537/0x570
> >   [<ffffffff81424bed>] do_page_fault+0x11d/0x4e0
> >   [<ffffffff81109a05>] ? do_mremap+0x2d5/0x570
> >   [<ffffffff81421d5f>] page_fault+0x1f/0x30
> > 
> > mremap's down_write of mmap_sem, together with i_mmap_mutex/lock,
> > and pagetable locks, were good enough before page migration (with its
> > requirement that every migration entry be found) came in; and enough
> > while migration always held mmap_sem.  But not enough nowadays, when
> > there's memory hotremove and compaction: anon_vma lock is also needed,
> > to make sure a migration entry is not dodging around behind our back.
> > 
> 
> migration holds the anon_vma lock while it unmaps the pages and keeps holding
> it until after remove_migration_ptes is called. 

I reread this today and realised I was sloppy with my writing. migration
holds the anon_vma lock while it unmaps the pages. It also holds the
anon_vma lock during remove_migration_ptes. For the migration operation,
a reference count is held on anon_vma but not the lock itself.

> There are two anon vmas
> that should exist during mremap that were created for the move. They
> should not be able to disappear while migration runs and right now,

And what is preventing them disappearing is not the lock but the
reference count.
