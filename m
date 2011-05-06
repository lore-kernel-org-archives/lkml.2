Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab1EFRUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 13:20:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab1EFRUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 13:20:47 -0400
Date: Fri, 6 May 2011 19:20:19 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Thomas Sattler <tsattler@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.X)
Message-ID: <20110506172019.GB6330@random.random>
References: <4DAF6C0B.3070009@gmx.de>
 <20110427134613.GI32590@random.random>
 <4DC14474.9040001@gmx.de>
 <20110504143842.GK7838@random.random>
 <4DC31EDE.2020503@gmx.de>
 <20110506011319.GH7838@random.random>
 <4DC3B629.7010409@gmx.de>
 <4DC3B72A.302@gmx.de>
 <4DC40484.3050205@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC40484.3050205@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 04:24:04PM +0200, Thomas Sattler wrote:
> > Aaarg, wrong kernel tree. I patched and compiled 2.6.38.5.
> > Do you think it is important to stay with 2.6.38.2, after
> > we know 2.6.38.4 is also affected?
> 
> I bootet 2.6.38.5.aa1 ("aa1" for the "make-it-worse-patch")

Sorry, unfortunately the make-it-worse-patch had a misplaced #if 0
which resulted in the VM not being able to reclaim, it should have
been around __alloc_pages_direct_compact and instead it was around
__alloc_pages_direct_reclaim (I noticed the hard way too).

The second patch (hotfix, not the make-it-worse) I sent should work
just fine instead.

Other ways we could fix it (if my vmstat per-cpu theory is right)
would be to call the equivalent of start_cpu_timer() to
schedule_delayed_work_on every CPU after congestion_wait returns
before re-evaluating too_many_isolated (however that would still add a
100msec latency here and there plus doing some overscheduling in
possibly no VM-congested situations where just one task quit releasing
all anon memory in the inactive list), or probably to always return
false from too_many_isolated if nr_isolated_anon <
threshold*CONFIG_NR_CPUS would be enough to sort the per-cpu
accounting error.. but personally I prefer to nuke the function for
all reasons mentioned in the prev email and go ahead and drop the
isolated counter too. However a more strict fix would give more
confirmation that we're not hiding a stat accounting error and confirm
my theory, but for the long run (after having spent a day reading that
function) I don't really like to keep it.

The correct make-it-worse patch would be this (and this time I tested
it before sending ;). This should speedup the time it takes to
reproduce as it'll always enter reclaim with __GFP_NO_KSWAPD
allocations (while previously it'd enter reclaim only if compaction
failed). And entering reclaim without kswapd running and churning over
the per-cpu stats and adding stuff from active to the inactive list
even when the inactive list gets trimmed to zero by an exit(), would
screw things up.

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9f8a97b..3dcd442 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2093,6 +2093,7 @@ rebalance:
 	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
 		goto nopage;
 
+#if 0
 	/*
 	 * Try direct compaction. The first pass is asynchronous. Subsequent
 	 * attempts after direct reclaim are synchronous
@@ -2105,7 +2106,8 @@ rebalance:
 					sync_migration);
 	if (page)
 		goto got_pg;
-	sync_migration = !(gfp_mask & __GFP_NO_KSWAPD);
+#endif
+	sync_migration = true;
 
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,

