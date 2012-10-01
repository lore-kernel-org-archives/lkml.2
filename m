Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab2JAAhQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 20:37:16 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:38442 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2JAAhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 20:37:13 -0400
Date: Sun, 30 Sep 2012 17:36:33 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Petr Holasek <pholasek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v4] KSM: numa awareness sysfs knob
In-Reply-To: <20120928112645.GX19474@redhat.com>
Message-ID: <alpine.LSU.2.00.1209301639240.6304@eggly.anvils>
References: <1348448166-1995-1-git-send-email-pholasek@redhat.com> <20120928112645.GX19474@redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for taking so long to look at Petr's nice work: it's more than
what I can think through in odd stolen moments; but yesterday at last
I managed to get down to remembering KSM and giving this some time.

On Fri, 28 Sep 2012, Andrea Arcangeli wrote:
> On Mon, Sep 24, 2012 at 02:56:06AM +0200, Petr Holasek wrote:
> > @@ -1758,7 +1800,12 @@ void ksm_migrate_page(struct page *newpage, struct page *oldpage)
> >  	stable_node = page_stable_node(newpage);
> >  	if (stable_node) {
> >  		VM_BUG_ON(stable_node->kpfn != page_to_pfn(oldpage));
> > -		stable_node->kpfn = page_to_pfn(newpage);
> > +
> > +		if (ksm_merge_across_nodes ||
> > +				page_to_nid(oldpage) == page_to_nid(newpage))
> > +			stable_node->kpfn = page_to_pfn(newpage);
> > +		else
> > +			remove_node_from_stable_tree(stable_node);
> >  	}
> >  }
> 
> This will result in memory corruption because the ksm page still
> points to the stable_node that has been freed (that is copied by the
> migrate code when the newpage->mapping = oldpage->mapping).

That is a very acute observation!  (And there was I searching for
where we copy over the PageKsm ;) which of course is in ->mapping.)

> 
> What should happen is that the ksm page of src_node is merged with
> the pre-existing ksm page in the dst_node of the migration. That's the
> complex case, the easy case is if there's no pre-existing page and
> that just requires an insert of the stable node in a different rbtree
> I think (without actual pagetable mangling).

I believe it's not as bad as "pagetable mangling" suggests.

> 
> It may be simpler to break cow across migrate and require the ksm
> scanner to re-merge it however.

I'm all for the simplest solution, but here in ksm_migrate_page()
is not a good place for COW breaking - we don't want to get into
an indefinite number of page allocations, and the risk of failure.

I was toying with the idea of leaving the new page in the old NUMAnode's
stable tree temporarily, until ksmd comes around again, and let that
clean it up.  Which would imply less reliance on get_kpfn_nid(),
and not skipping PageKsm in ksm_do_scan(), and...

But it's not all that simple, and I think we can do better.

> 
> Basically the above would remove the ability to rmap the ksm page
> (i.e. rmap crashes on a dangling pointer), but we need rmap to be
> functional at all times on all ksm pages.

Yes.

> 
> Hugh what's your views on this ksm_migrate_page NUMA aware that is
> giving trouble? What would you prefer? Merge two ksm pages together
> (something that has never happened before), break_cow (so we don't
> have to merge two ksm pages together in the first place and we
> fallback in the regular paths) etc...

It's only just fully dawned on me that ksm_migrate_page() is actually
a very convenient place: no pagetable mangling required, because we
know that neither old nor new page is at this instant mapped into
userspace at all - don't we?  Instead there are swap-like migration
entries plugging all ptes until we're ready to put in the new page.

So I think what we really want to do is change the ksm_migrate_page()
interface a little, and probably the precise position it's called from,
to allow it to update mm/migrate.c's newpage - in the collision case
when the new NUMAnode already has a stable copy of this page.  But when
it doesn't, just move KSMnode from old NUMAnode's stable tree to new.

How well the existing ksm.c primitives are suited to this, I've not
checked.  Probably not too well, but shouldn't be hard to add what's
needed.

What do you think?  Does that sound reasonable, Petr?

By the way, this is probably a good occasion to remind ourselves,
that page migration is still usually disabled on PageKsm pages:
ksm_migrate_page() is only being called for memory hotremove.  I had
been about to complain that calling remove_node_from_stable_tree()
from ksm_migrate_page() is also unsafe from a locking point of view;
until I remembered that MEM_GOING_OFFLINE has previously acquired
ksm_thread_mutex.

But page migration is much more important now than three years ago,
with compaction relying upon it, CMA and THP relying upon compaction,
and lumpy reclaim gone.

Whilst it should not be mixed up in the NUMA patch itself, I think we
need now to relax that restriction.  I found re-reading my 62b61f611e
"ksm: memory hotremove migration only" was helpful.  Petr, is that
something you could take on also?  I _think_ it's just a matter of
protecting the stable tree(s) with an additional mutex (which ought
not to be contended, since ksm_thread_mutex is normally held above
it, except in migration); then removing a number of PageKsm refusals
(and the offlining arg to unmap_and_move() etc).  But perhaps there's
more to it, I haven't gone over it properly.

> 
> All the rest looks very good, great work Petr!

Yes, I agree; but a few more comments I'll make against the v4 post.

Hugh
