Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0FYI3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 04:29:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40443 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0FYI3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 04:29:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 05/12] vmscan: kill prev_priority completely
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100616163709.1e0f6b56.akpm@linux-foundation.org>
References: <1276514273-27693-6-git-send-email-mel@csn.ul.ie> <20100616163709.1e0f6b56.akpm@linux-foundation.org>
Message-Id: <20100624211413.802B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 25 Jun 2010 17:29:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sorry for the long delay.
(and I'm a bit wonder why I was not CCed this thread ;)

> On Mon, 14 Jun 2010 12:17:46 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> > Since 2.6.28 zone->prev_priority is unused. Then it can be removed
> > safely. It reduce stack usage slightly.
> > 
> > Now I have to say that I'm sorry. 2 years ago, I thought prev_priority
> > can be integrate again, it's useful. but four (or more) times trying
> > haven't got good performance number. Thus I give up such approach.
> 
> This would have been badder in earlier days when we were using the
> scanning priority to decide when to start unmapping pte-mapped pages -
> page reclaim would have been recirculating large blobs of mapped pages
> around the LRU until the priority had built to the level where we
> started to unmap them.
> 
> However that priority-based decision got removed and right now I don't
> recall what it got replaced with.  Aren't we now unmapping pages way
> too early and suffering an increased major&minor fault rate?  Worried.
> 
> 
> Things which are still broken after we broke prev_priority:
> 
> - If page reclaim is having a lot of trouble, prev_priority would
>   have permitted do_try_to_free_pages() to call disable_swap_token()
>   earlier on.  As things presently stand, we'll do a lot of
>   thrash-detection stuff before (presumably correctly) dropping the
>   swap token.
> 
>   So.  What's up with that?  I don't even remember _why_ we disable
>   the swap token once the scanning priority gets severe and the code
>   comments there are risible.  And why do we wait until priority==0
>   rather than priority==1?
> 
> - Busted prev_priority means that lumpy reclaim will act oddly. 
>   Every time someone goes into do some recalim, they'll start out not
>   doing lumpy reclaim.  Then, after a while, they'll get a clue and
>   will start doing the lumpy thing.  Then they return from reclaim and
>   the next recalim caller will again forget that he should have done
>   lumpy reclaim.
> 
>   I dunno what the effects of this are in the real world, but it
>   seems dumb.
> 
> And one has to wonder: if we're making these incorrect decisions based
> upon a bogus view of the current scanning difficulty, why are these
> various priority-based thresholding heuristics even in there?  Are they
> doing anything useful?
> 
> So..  either we have a load of useless-crap-and-cruft in there which
> should be lopped out, or we don't have a load of useless-crap-and-cruft
> in there, and we should fix prev_priority.

May I explain my experience? I'd like to explain why prev_priority wouldn't
works nowadays. 

First of all, Yes, current vmscan still a lot of UP centric code. it 
expose some weakness on some dozens CPUs machine. I think we need 
more and more improvement.

The problem is, current vmscan mix up per-system-pressure, per-zone-pressure
and per-task-pressure a bit. example, prev_priority try to boost priority to
other concurrent priority. but If the another task have mempolicy restriction,
It's unnecessary, but also makes wrong big latency and exceeding reclaim.
per-task based priority + prev_priority adjustment make the emulation of
per-system pressure. but it have two issue 1) too rough and brutal emulation
2) we need per-zone pressure, not per-system.

another example, currently DEF_PRIORITY is 12. it mean the lru rotate about
2 cycle (1/4096 + 1/2048 + 1/1024 + .. + 1) before invoking OOM-Killer.
but if 10,0000 thrreads enter DEF_PRIORITY reclaim at the same time, the
system have higher memory pressure than priority==0 (1/4096*10,000 > 2).
prev_priority can't solve such multithreads workload issue.

In other word, prev_priority concept assume the sysmtem don't have lots
threads.

And, I don't think lumpy reclaim threshold is big matter, because It was
introduced to case aim7 corner case issue. I don't think such situation
will occur frequently in the real workload. thus end users can't observe
such logic.

For mapped-vs-unmapped thing, I dunnno the exactly reason. That was
introduced by Rik, unfortunatelly I had not joined its activity at 
making design time. I can only say, while my testing the current code 
works good.

That said, my conclusion is opposite. For long term view, we should
consider to kill reclaim priority completely. Instead, we should
consider to introduce per-zone pressure statistics.



> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > ---
> >  include/linux/mmzone.h |   15 ------------
> >  mm/page_alloc.c        |    2 -
> >  mm/vmscan.c            |   57 ------------------------------------------------
> >  mm/vmstat.c            |    2 -
> 
> The patch forgot to remove mem_cgroup_get_reclaim_priority() and friends.

Sure. thanks.
Will fix.


btw, current zone reclaim have wrong swap token usage.

	static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
	{
	(snip)
	        disable_swap_token();
	        cond_resched();


I can't understand the reason why zone reclaim _always_ disable swap token.
that's mean, if the system is enabled zone reclaim, swap token don't works 
at all.

Perhaps, original author's intention was following, I guess.

                priority = ZONE_RECLAIM_PRIORITY;
                do {
                        if ((zone_reclaim_mode & RECLAIM_SWAP) && !priority)	// here
			        disable_swap_token();				// here

                        note_zone_scanning_priority(zone, priority);
                        shrink_zone(priority, zone, &sc);
                        priority--;
                } while (priority >= 0 && sc.nr_reclaimed < nr_pages);


However, if my understanding is correct, we can remove this 
disable_swap_token() completely. because zone reclaim failure don't bring 
to OOM-Killer, instead melery cause normal try_to_free_pages().




