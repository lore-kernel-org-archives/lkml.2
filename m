Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1EFBNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:13:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab1EFBNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 21:13:47 -0400
Date: Fri, 6 May 2011 03:13:19 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Thomas Sattler <tsattler@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.X)
Message-ID: <20110506011319.GH7838@random.random>
References: <4DAF6C0B.3070009@gmx.de>
 <20110427134613.GI32590@random.random>
 <4DC14474.9040001@gmx.de>
 <20110504143842.GK7838@random.random>
 <4DC31EDE.2020503@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC31EDE.2020503@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 12:04:14AM +0200, Thomas Sattler wrote:
> It happened again: This time with 2.6.38.4 after 13 days uptime.
> In fact it was "13 days after last boot", since this machine is
> hibernated quite often. I waited only two minutes before I run
> 'reboot' as root.
> 
> > Please next time can you run SYSRQ+t too in addition of SYSRQ+l?
> 
> See http://pastebin.com/raw.php?i=XnXXfC40 (It seems to me SYSRQ+l
> did not work at all? And does also not work on 2.6.38.5?)
> 
> see http://pastebin.com/raw.php?i=Zuv0VnUP for 'top/iotop'

Ok this time we're onto something.

The 3 tasks (khugepaged, thunderbird-bin, convert) are allocating
hugepages, and all 3 get stuck in the convestion_wait loop of
shrink_zone controlled by too_many_isolated() indefinitely in trying
to free memory (likely for compaction). kswapd is idle, rightfully so
because it's up to khugepaged the task to allocate hugepages in
background.

So to me it looks like either too_many_isolated is wrong, or maybe it
could be the loop of compaction_suitable that is insisting too much.

Admittedly if there are SWAP_CLUSTER_MAX 2M pages, the isolated pages
will rocket up fast to 64M (while if those were 4k pages it'd go up
max 128k), but if they're all in the loop nr_isolated_anon and they
never return should have been zero. Maybe they return but compaction
suitable makes them loop again. I'm uncertain what's going on yet.

The threshold of the per-cpu vmstat should be well under 512 pages, so
likely the lack of synchronization for the stats isn't to blame for
this. For now we'll assume the per-cpu stats aren't the problem.

Now the thing I want to rule out first is an accounting error in the
isolated pages, so when it hangs again I'd like to see the output of:

     grep anon /proc/zoneinfo

So we can see immediately what are the values of nr_isolated_anon and
nr_inactive_anon (the hang should only happen when nr_isolated_anon >
nr_inactive_anon).

You can already run "grep threshold /proc/zoneinfo" on the system
where you reproduced the hang the last time (the one running 2.6.38.4)
the one with 1.5G of ram. They all should be well below 512 (so in
theory not causing troubles because of the per-cpu stats, and with so
few cpus it shouldn't have been such a longstanding problem anyway).

If you didn't reboot that system after the last hang, you can already
run "grep anon /proc/zoneinfo" while the system is mostly idle, then
all nr_isolated_anon should be zero. If they're not zero and they stay
not zero on a idle system, we've an accounting bug to fix. If they're
all zero like they should, then we're likely looping in the compaction
suitable.

On my busy kernels:

grep nr_isolated_anon /proc/zoneinfo 
    nr_isolated_anon 0
    nr_isolated_anon 0
    nr_isolated_anon 0

grep nr_isolated_anon /proc/zoneinfo 
    nr_isolated_anon 0
    nr_isolated_anon 0

grep nr_isolated_anon /proc/zoneinfo 
    nr_isolated_anon 0
    nr_isolated_anon 0
    nr_isolated_anon 0

No apparent accounting problem here despite quite some load and
uptime.

I've already a patch to try for the compaction suitable loop but I'll
wait your feedback and I need to think a bit more about this.

This patch may help you to reproduce much quicker, I'll try that too
to see if I can reproduce... (ignore the sync_migration = true, it
won't hurt but it's unrelated to the debug patch, just apply it if
you've trouble reproducing it again, when compaction succeeds, and it
does 99% of the time even with the less reliable async initial mode,
it likely hides the problem very well)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9f8a97b..c2f3646 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2105,8 +2105,9 @@ rebalance:
 					sync_migration);
 	if (page)
 		goto got_pg;
-	sync_migration = !(gfp_mask & __GFP_NO_KSWAPD);
+	sync_migration = true;
 
+#if 0
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
@@ -2115,6 +2116,7 @@ rebalance:
 					migratetype, &did_some_progress);
 	if (page)
 		goto got_pg;
+#endif
 
 	/*
 	 * If we failed to make any progress reclaiming, then we are


CC'ed Mel so he can check this too.

Thanks a lot for the help.
Andrea
