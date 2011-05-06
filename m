Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab1EFGgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 02:36:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab1EFGgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 02:36:18 -0400
Date: Fri, 6 May 2011 08:35:50 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Thomas Sattler <tsattler@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.X)
Message-ID: <20110506063550.GA6330@random.random>
References: <4DAF6C0B.3070009@gmx.de>
 <20110427134613.GI32590@random.random>
 <4DC14474.9040001@gmx.de>
 <20110504143842.GK7838@random.random>
 <4DC31EDE.2020503@gmx.de>
 <20110506011319.GH7838@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506011319.GH7838@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 03:13:19AM +0200, Andrea Arcangeli wrote:
> this. For now we'll assume the per-cpu stats aren't the problem.

Well, after more thinking on this I changed my mind about that
assumption... (the stats looks all good w.r.t. to split_huge_page and
stuff).

If two increases of NR_ISOLATED_ANON stats happen on the same CPU but
the decreases happen on two different CPUs, NR_ISOLATED_ANON may
remain boosted. If then a process quits releasing all inactive anon
pages sitting on the inactive list the too_many_isolated may start the
congestion loop at the first invocation despite NR_ISOLATED_ANON
should have been zero (but two decrements are pending on two different
CPUs so the global value isn't zeroed yet).

What made the difference I think is that in normal circumstances
kswapd would be running too (see the current_is_kswapd()), mangling
over all the per-cpu lists, and it would avoid an indefinite hang. But
here there are only 3 tasks entering reclaim running THP allocations
(with __GFP_NO_KSWAPD), and they all 3 stop in the loop, nothing else
in the system touching the vmstat, it can take a while for the per-cpu
info to be flushed global by some other VM activity (and anon page
allocations will go in the active list, they won't mangle over the
nr_inactive_anon vmstat). On large systems this will not be easily
visible because of the inactive list size would rarely be trimmed down
to a value < vmstat threshold.

To fix this I've been wondering if to use "isolated >
zone->present_pages/2" or something big (but I don't want to depend on
threshold vs present_pages value which might again fail with weird
mem= commands creating the smallest possible highmem zone, max order
should be good enough but it still feels flakey). I thought of reading
the threshold and taking it into account in the comparison but the two
reads are out of order anyway so it could still fail regardless of the
threshold being taken into account.

Plus inactive (or zone->present_pages) can be huge or tiny, regardless
of the number of CPUs. So too_many_isolated is a bad check and I can't
craft a better one without adding some other counters in replacement
of this.

If it's really an issue, we could limit reclaim in function of the
number of tasks and CPUs, not in function of the inactive list
size. With huge memory the inactive list may be huge too even when
there's memory pressure and swapping allowing lots of tasks to enter
regardless the number of CPUs. And stopping there looks bad because
it's also preventing any later VM shrinking activity indefinitely,
including the shrinking activity of all other other zones that may be
huge. So as a quick hotfix I can't think of anything better than the
below... this too_many_isolated looks bad from too many standpoints,
the LRU_ISOLATE_* stats likely can go too with it making the code
simpler.

But to verify this theory, please "cat /proc/zoneinfo" (whole file)
during the hang, so we can verify if the above theory is right or
not. If it's right you will find nr_isolated_* small (like surely
<100) but bigger than zero and also bigger than the corresponding
nr_inactive_* for one of the zones, for the whole duration of the
hang. After verifying this with /proc/zoneinfo during the hang, I can
try a more complete patch... but if the theory is correct, the below
should fix it already and should be safe.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f6b435c..c69f4fa 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1218,31 +1218,6 @@ int isolate_lru_page(struct page *page)
 }
 
 /*
- * Are there way too many processes in the direct reclaim path already?
- */
-static int too_many_isolated(struct zone *zone, int file,
-		struct scan_control *sc)
-{
-	unsigned long inactive, isolated;
-
-	if (current_is_kswapd())
-		return 0;
-
-	if (!scanning_global_lru(sc))
-		return 0;
-
-	if (file) {
-		inactive = zone_page_state(zone, NR_INACTIVE_FILE);
-		isolated = zone_page_state(zone, NR_ISOLATED_FILE);
-	} else {
-		inactive = zone_page_state(zone, NR_INACTIVE_ANON);
-		isolated = zone_page_state(zone, NR_ISOLATED_ANON);
-	}
-
-	return isolated > inactive;
-}
-
-/*
  * TODO: Try merging with migrations version of putback_lru_pages
  */
 static noinline_for_stack void
@@ -1379,14 +1354,6 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 	unsigned long nr_anon;
 	unsigned long nr_file;
 
-	while (unlikely(too_many_isolated(zone, file, sc))) {
-		congestion_wait(BLK_RW_ASYNC, HZ/10);
-
-		/* We are about to die and free our memory. Return now. */
-		if (fatal_signal_pending(current))
-			return SWAP_CLUSTER_MAX;
-	}
-
 	set_reclaim_mode(priority, sc, false);
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
