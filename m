Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127Ab0IDEh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 00:37:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:63215 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab0IDEhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 00:37:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,316,1280732400"; 
   d="scan'208";a="654115280"
Date: Sat, 4 Sep 2010 12:37:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Mel Gorman <mel@csn.ul.ie>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 3/3] mm: page allocator: Drain per-cpu lists after
 direct reclaim allocation fails
Message-ID: <20100904043712.GA17217@localhost>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie>
 <1283504926-2120-4-git-send-email-mel@csn.ul.ie>
 <20100903160026.564fdcc9.akpm@linux-foundation.org>
 <20100904022545.GD705@dastard>
 <20100904032311.GA14222@localhost>
 <20100903205945.44e1aa38.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100903205945.44e1aa38.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 11:59:45AM +0800, Andrew Morton wrote:
> On Sat, 4 Sep 2010 11:23:11 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > > Still, given the improvements in performance from this patchset,
> > > I'd say inclusion is a no-braniner....
> > 
> > In your case it's not really high memory pressure, but maybe too many
> > concurrent direct reclaimers, so that when one reclaimed some free
> > pages, others kick in and "steal" the free pages. So we need to kill
> > the second cond_resched() call (which effectively gives other tasks a
> > good chance to steal this task's vmscan fruits), and only do
> > drain_all_pages() when nothing was reclaimed (instead of allocated).
> 
> Well...  cond_resched() will only resched when this task has been
> marked for preemption.  If that's happening at such a high frequency
> then Something Is Up with the scheduler, and the reported context
> switch rate will be high.

Yes it may not necessarily schedule away. But if ever this happens,
the task will likely run into drain_all_pages() when re-gain CPU.
Because the drain_all_pages() cost is very high, it don't need too
many reschedules to create the IPI storm..

> > Dave, will you give a try of this patch? It's based on Mel's.
> > 
> > 
> > --- linux-next.orig/mm/page_alloc.c	2010-09-04 11:08:03.000000000 +0800
> > +++ linux-next/mm/page_alloc.c	2010-09-04 11:16:33.000000000 +0800
> > @@ -1850,6 +1850,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
> >  
> >  	cond_resched();
> >  
> > +retry:
> >  	/* We now go into synchronous reclaim */
> >  	cpuset_memory_pressure_bump();
> >  	p->flags |= PF_MEMALLOC;
> > @@ -1863,26 +1864,23 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
> >  	lockdep_clear_current_reclaim_state();
> >  	p->flags &= ~PF_MEMALLOC;
> >  
> > -	cond_resched();
> > -
> > -	if (unlikely(!(*did_some_progress)))
> > +	if (unlikely(!(*did_some_progress))) {
> > +		if (!drained) {
> > +			drain_all_pages();
> > +			drained = true;
> > +			goto retry;
> > +		}
> >  		return NULL;
> > +	}
> >  
> > -retry:
> >  	page = get_page_from_freelist(gfp_mask, nodemask, order,
> >  					zonelist, high_zoneidx,
> >  					alloc_flags, preferred_zone,
> >  					migratetype);
> >  
> > -	/*
> > -	 * If an allocation failed after direct reclaim, it could be because
> > -	 * pages are pinned on the per-cpu lists. Drain them and try again
> > -	 */
> > -	if (!page && !drained) {
> > -		drain_all_pages();
> > -		drained = true;
> > +	/* someone steal our vmscan fruits? */
> > +	if (!page && *did_some_progress)
> >  		goto retry;
> > -	}
> 
> Perhaps the fruit-stealing event is worth adding to the
> userspace-exposed vm stats somewhere.  But not in /proc - somewhere
> more temporary, in debugfs.

There are no existing debugfs interfaces for vm stats, and I need to
go out right now.. So I did the following quick (and temporary) hack
to allow Dave to collect the information. Will revisit the proper
interface to use later :)

Thanks,
Fengguang
---
 include/linux/mmzone.h |    1 +
 mm/page_alloc.c        |    4 +++-
 mm/vmstat.c            |    1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

--- linux-next.orig/include/linux/mmzone.h	2010-09-04 12:30:26.000000000 +0800
+++ linux-next/include/linux/mmzone.h	2010-09-04 12:30:36.000000000 +0800
@@ -104,6 +104,7 @@ enum zone_stat_item {
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
 	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
+	NR_RECLAIM_STEAL,
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
 	NUMA_MISS,		/* allocated in non intended node */
--- linux-next.orig/mm/page_alloc.c	2010-09-04 12:28:09.000000000 +0800
+++ linux-next/mm/page_alloc.c	2010-09-04 12:33:39.000000000 +0800
@@ -1879,8 +1879,10 @@ retry:
 					migratetype);
 
 	/* someone steal our vmscan fruits? */
-	if (!page && *did_some_progress)
+	if (!page && *did_some_progress) {
+		inc_zone_state(preferred_zone, NR_RECLAIM_STEAL);
 		goto retry;
+	}
 
 	return page;
 }
--- linux-next.orig/mm/vmstat.c	2010-09-04 12:31:30.000000000 +0800
+++ linux-next/mm/vmstat.c	2010-09-04 12:31:42.000000000 +0800
@@ -732,6 +732,7 @@ static const char * const vmstat_text[] 
 	"nr_isolated_anon",
 	"nr_isolated_file",
 	"nr_shmem",
+	"nr_reclaim_steal",
 #ifdef CONFIG_NUMA
 	"numa_hit",
 	"numa_miss",
