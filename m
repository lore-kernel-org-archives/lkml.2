Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966394Ab2FBHUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 03:20:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48261 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966371Ab2FBHUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 03:20:40 -0400
Date: Sat, 2 Jun 2012 00:20:13 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: WARNING: at mm/page-writeback.c:1990
 __set_page_dirty_nobuffers+0x13a/0x170()
In-Reply-To: <CA+55aFytGfGm2mmF-9BwjqiDCtNpz40AkQrmGOqduss2YAiEvQ@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1206012352390.1334@eggly.anvils>
References: <20120530163317.GA13189@redhat.com> <20120531005739.GA4532@redhat.com> <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils> <20120601161205.GA1918@redhat.com> <20120601171606.GA3794@redhat.com>
 <alpine.LSU.2.00.1206011511560.12839@eggly.anvils> <CA+55aFy2-X92EqpiuyvkBp_2-UaYDUpaC2c3XT3gXMN1O+T7sw@mail.gmail.com> <alpine.LSU.2.00.1206012108430.11308@eggly.anvils> <CA+55aFytGfGm2mmF-9BwjqiDCtNpz40AkQrmGOqduss2YAiEvQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2012, Linus Torvalds wrote:
> On Fri, Jun 1, 2012 at 9:40 PM, Hugh Dickins <hughd@google.com> wrote:
> >
> > Move the lock after the loop, I think you meant.
> 
> Well, I wasn't sure if anything inside the loop might need it. I don't
> *think* so, but at the same time, what protects "page_order(page)"
> (or, indeed PageBuddy()) from being stable while that loop content
> uses them?

Yes, I believe you're right, page_order(page) could supply nonsense
if it's not stabilized under zone->lock along with PageBuddy(page).

Though if this rescue_unmovable_pageblock() is just best-effort,
with a little more care we can probably avoid the lock in there.

> 
> I don't understand that code at all. It does that crazy iteration over
> page, and changes "page" in random ways,

I don't think they're random ways: when buddy it uses the order to skip
that block, otherwise it goes page by page, considering a free (I guess
on pcp) page or an lru page as good for movable.

> and then finishes up with a
> totally new "page" value that is some random thing that is *after* the
> end_page thing. WHAT?
> 
> The code makes no sense. It tests all those pages within the
> page-block, but then after it has done all those tests, it does the
> final
> 
>   set_pageblock_migratetype(..)
>   move_freepages_block(..)
> 
> using a page that is *beyond* the pageblock (and with the whole
> page_order() thing, who knows just how far beyond it?)

I totally missed that, thank goodness you did not.  Yes, it's rubbish.
It goes to this effort to find a suitable pageblock, then chooses the
next one instead (or possibly another).  Perhaps it would get even
better results using a random number generator in there.

> 
> It looks entirely too much like random-monkey code to me.

Presumably it should be passing start_page instead of page
to set_pageblock_migratetype() and move_freepages_block().

But this does seem to be code of the kind, that the longer you look
at it, the more bugs you find.  And I worry about what trouble it
might then cause, if it actually started to work in the way it was
intending.  I don't think fixing it up is wise for -rc1.

Commit 5ceb9ce6fe9462a298bb2cd5c9f1ca6cb80a0199
("mm: compaction: handle incorrect MIGRATE_UNMOVABLE type pageblocks")
appears to revert cleanly, and I'm running with it reverted now.

I'm not saying it shouldn't come back later, but does anyone see
an argument against reverting it now?

Hugh
