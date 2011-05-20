Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244Ab1ETPd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:33:57 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:48808 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab1ETPd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mmjh7kPix4Mc7ID2MCzVOZKLEDSPn0UJfKymOqeDOo4YahYF0WP7W5EiLXW5J7FVWl
         +dkizJWTVOSqip2556bZVLmHs52p3F2Pjj5KHTxssqQIKPViYkD8Ra1wi30V0VWzlyaJ
         R/h7uD4SvcKgMiBOxNsa4rJgtBOjl6DCM7Jq8=
Date: Sat, 21 May 2011 00:33:46 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        fengguang.wu@intel.com, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking
 vmlinux)
Message-ID: <20110520153346.GA1843@barrios-desktop>
References: <BANLkTikHMUru=w4zzRmosrg2bDbsFWrkTQ@mail.gmail.com>
 <BANLkTima0hPrPwe_x06afAh+zTi-bOcRMg@mail.gmail.com>
 <BANLkTi=NTLn4Lx7EkybuA8-diTVOvMDxBw@mail.gmail.com>
 <BANLkTinEDXHuRUYpYN0d95+fz4+F7ccL4w@mail.gmail.com>
 <4DD5DC06.6010204@jp.fujitsu.com>
 <BANLkTik=7C5qFZTsPQG4JYY-MEWDTHdc6A@mail.gmail.com>
 <BANLkTins7qxWVh0bEwtk1Vx+m98N=oYVtw@mail.gmail.com>
 <20110520140856.fdf4d1c8.kamezawa.hiroyu@jp.fujitsu.com>
 <20110520101120.GC11729@random.random>
 <BANLkTikAFMvpgHR2dopd+Nvjfyw_XT5=LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikAFMvpgHR2dopd+Nvjfyw_XT5=LA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 10:11:47AM -0400, Andrew Lutomirski wrote:
> On Fri, May 20, 2011 at 6:11 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> > I figure it's not easily reproducible but you can easily rule out THP
> > issues by reproducing at least once after booting with
> > transparent_hugepage=never or by building the kernel with
> > CONFIG_TRANSPARENT_HUGEPAGE=n.
> 
> Reproduced with CONFIG_TRANSPARENT_HUGEPAGE=n with and without
> compaction and migration.
> 
> I applied the attached patch (which includes Minchan's !pgdat_balanced
> and need_resched changes).  I see:
> 
> [  121.468339] firefox shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea00019217a8) w/ prev = 100000000002000D
> [  121.469236] firefox shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea00016596b8) w/ prev = 100000000002000D
> [  121.470207] firefox: shrink_page_list (nr_scanned=94
> nr_reclaimed=19 nr_to_reclaim=32 gfp_mask=201DA) found inactive page
> ffffea00019217a8 with flags=100000000002004D
> [  121.472451] firefox: shrink_page_list (nr_scanned=94
> nr_reclaimed=19 nr_to_reclaim=32 gfp_mask=201DA) found inactive page
> ffffea00016596b8 with flags=100000000002004D
> [  121.482782] dd shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea00013a8938) w/ prev = 100000000002000D
> [  121.489820] dd shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea00017a4e88) w/ prev = 1000000000000801
> [  121.490626] dd shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea000005edb0) w/ prev = 1000000000000801
> [  121.491499] dd: shrink_page_list (nr_scanned=62 nr_reclaimed=0
> nr_to_reclaim=32 gfp_mask=200D2) found inactive page ffffea00017a4e88
> with flags=1000000000000841
> [  121.494337] dd: shrink_page_list (nr_scanned=62 nr_reclaimed=0
> nr_to_reclaim=32 gfp_mask=200D2) found inactive page ffffea000005edb0
> with flags=1000000000000841
> [  121.499219] dd shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea000129c788) w/ prev = 1000000000080009
> [  121.500363] dd shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea000129c830) w/ prev = 1000000000080009
> [  121.502270] kswapd0 shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea0001146470) w/ prev = 100000000008001D
> [  121.661545] kworker/1:1 shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea0000058168) w/ prev = 1000000000000801
> [  121.662791] kworker/1:1 shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea000166f288) w/ prev = 1000000000000801
> [  121.665727] kworker/1:1 shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea0001681c40) w/ prev = 1000000000000801
> [  121.666857] kworker/1:1 shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea0001693130) w/ prev = 1000000000000801
> [  121.667988] kworker/1:1 shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea0000c790d8) w/ prev = 1000000000000801
> [  121.669105] kworker/1:1 shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea000113fe48) w/ prev = 1000000000000801
> [  121.670238] kworker/1:1: shrink_page_list (nr_scanned=102
> nr_reclaimed=20 nr_to_reclaim=32 gfp_mask=11212) found inactive page
> ffffea0000058168 with flags=1000000000000841
> [  121.674061] kworker/1:1: shrink_page_list (nr_scanned=102
> nr_reclaimed=20 nr_to_reclaim=32 gfp_mask=11212) found inactive page
> ffffea000166f288 with flags=1000000000000841
> [  121.678054] kworker/1:1: shrink_page_list (nr_scanned=102
> nr_reclaimed=20 nr_to_reclaim=32 gfp_mask=11212) found inactive page
> ffffea0001681c40 with flags=1000000000000841
> [  121.682069] kworker/1:1: shrink_page_list (nr_scanned=102
> nr_reclaimed=20 nr_to_reclaim=32 gfp_mask=11212) found inactive page
> ffffea0001693130 with flags=1000000000000841
> [  121.686074] kworker/1:1: shrink_page_list (nr_scanned=102
> nr_reclaimed=20 nr_to_reclaim=32 gfp_mask=11212) found inactive page
> ffffea0000c790d8 with flags=1000000000000841
> [  121.690045] kworker/1:1: shrink_page_list (nr_scanned=102
> nr_reclaimed=20 nr_to_reclaim=32 gfp_mask=11212) found inactive page
> ffffea000113fe48 with flags=1000000000000841
> [  121.866205] test_mempressur shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea000165d5b8) w/ prev = 100000000002000D
> [  121.868204] test_mempressur shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea0001661288) w/ prev = 100000000002000D
> [  121.870203] test_mempressur shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea0001661250) w/ prev = 100000000002000D
> [  121.872195] test_mempressur shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea000100cee8) w/ prev = 100000000002000D
> [  121.873486] test_mempressur shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea0000eafab8) w/ prev = 100000000002000D
> [  121.874718] test_mempressur shrink_page_list+0x4f3/0x5ca:
> SetPageActive(ffffea0000eafaf0) w/ prev = 100000000002000D
> 
> This is interesting: it looks like shrink_page_list is making its way
> through the list more than once.  It could be reentering itself
> somehow or it could have something screwed up with the linked list.
> 
> I'll keep slowly debugging, but maybe this is enough for someone
> familiar with this code to beat me to it.
> 
> Minchan, I think this means that your fixes are just hiding and not
> fixing the underlying problem.

Could you test with below patch?

If this patch fixes it, I don't know why we see this problem now.
It should be problem long time ago.

>From b7d7ca54b3ed914723cc54d1c3bcd937e5f08e3a Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan.kim@gmail.com>
Date: Sat, 21 May 2011 00:28:00 +0900
Subject: [BUG fix] vmscan: Clear PageActive before synchronous shrink_page_list

Normally, shrink_page_list doesn't reclaim working set page(ie, PG_referenced).
So it should return active lru list
For it, shrink_page_list does SetPageActive for them.
Sometime, we can ignore that and try to reclaim them when we reclaim high-order pages
through consecutive second call of synchronous shrink_page_list.
At that time, the pages which have PG_active could be caught by VM_BUG_ON(PageActive(page))
in shrink_page_list.

This patch clears PG_active before entering synchronous shrink_page_list.

Reported-by: Andrew Lutomirski <luto@mit.edu>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/vmscan.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8bfd450..a5c01e9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1430,7 +1430,10 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 
 	/* Check if we should syncronously wait for writeback */
 	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
+		unsigned long nr_active;
 		set_reclaim_mode(priority, sc, true);
+		nr_active = clear_active_flags(&page_list, NULL);
+		count_vm_events(PGDEACTIVATE, nr_active);
 		nr_reclaimed += shrink_page_list(&page_list, zone, sc);
 	}
 
-- 
1.7.1

-- 
Kind regards,
Minchan Kim
