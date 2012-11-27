Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab2K0W1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 17:27:41 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35245 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab2K0W1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 17:27:40 -0500
Date: Tue, 27 Nov 2012 17:26:37 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, George Spelvin <linux@horizon.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Tomas Racek <tracek@redhat.com>, Jan Kara <jack@suse.cz>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Jiri Slaby <jslaby@suse.cz>, Thorsten Leemhuis <fedora@leemhuis.info>,
        Zdenek Kabelac <zkabelac@redhat.com>, Bruno Wolff III <bruno@wolff.to>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kswapd craziness in 3.7
Message-ID: <20121127222637.GG2301@cmpxchg.org>
References: <1354049315-12874-1-git-send-email-hannes@cmpxchg.org>
 <CA+55aFywygqWUBNWtZYa+vk8G0cpURZbFdC7+tOzyWk6tLi=WA@mail.gmail.com>
 <50B52DC4.5000109@redhat.com>
 <20121127214928.GA20253@cmpxchg.org>
 <50B5387C.1030005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B5387C.1030005@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 05:02:36PM -0500, Rik van Riel wrote:
> On 11/27/2012 04:49 PM, Johannes Weiner wrote:
> >On Tue, Nov 27, 2012 at 04:16:52PM -0500, Rik van Riel wrote:
> >>On 11/27/2012 03:58 PM, Linus Torvalds wrote:
> >>>Note that in the meantime, I've also applied (through Andrew) the
> >>>patch that reverts commit c654345924f7 (see commit 82b212f40059
> >>>'Revert "mm: remove __GFP_NO_KSWAPD"').
> >>>
> >>>I wonder if that revert may be bogus, and a result of this same issue.
> >>>Maybe that revert should be reverted, and replaced with your patch?
> >>>
> >>>Mel? Zdenek? What's the status here?
> >>
> >>Mel posted several patches to fix the kswapd issue.  This one is
> >>slightly more risky than the outright revert, but probably preferred
> >>from a performance point of view:
> >>
> >>https://lkml.org/lkml/2012/11/12/151
> >>
> >>It works by skipping the kswapd wakeup for THP allocations, only
> >>if compaction is deferred or contended.
> >
> >Just to clarify, this would be a replacement strictly for the
> >__GFP_NO_KSWAPD removal revert, to control how often kswapd is woken
> >up for higher order allocations like THP.
> >
> >My patch is to fix how kswapd actually does higher order reclaim, and
> >it is required either way.
> >
> >[ But isn't the _reason_ why the "wake up kswapd more carefully for
> >   THP" patch was written kind of moot now since it was developed
> >   against a crazy kswapd?  It would certainly need to be re-evaluated.
> >   My (limited) testing didn't show any issues anymore with waking
> >   kswapd unconditionally once it's fixed. ]
> 
> Kswapd going crazy is certainly a large part of the problem.
> 
> However, that leaves the issue of page_alloc.c waking up
> kswapd when the system is not actually low on memory.
> 
> Instead, kswapd is woken up because memory compaction failed,
> potentially even due to lock contention during compaction!
> 
> Ideally the allocation code would only wake up kswapd if
> memory needs to be freed, or in order for kswapd to do
> memory compaction (so the allocator does not have to).

Maybe I missed something, but shouldn't this be solved with my patch?

The first scan over the zones finds the higher order watermark
breached, but the reclaim scan over the zones tests against order-0
(testorder) watermarks when compaction is suitable, i.e. no reclaim if
there are enough order-0 pages for compaction to work.  It should just
fall through to that zones_need_compaction condition at the end and
run compaction.

As such, it should always be approriate to wake kswapd if allocations
fail.
