Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab1CXCLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 22:11:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45538 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1CXCLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 22:11:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/5] vmscan: remove all_unreclaimable check from direct reclaim path completely
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <AANLkTi=w62=WR5WACJGk6JNhyCYpgNhFQK3CyQ5Ag-Yj@mail.gmail.com>
References: <20110323174545.1AE2.A69D9226@jp.fujitsu.com> <AANLkTi=w62=WR5WACJGk6JNhyCYpgNhFQK3CyQ5Ag-Yj@mail.gmail.com>
Message-Id: <20110324111200.1AF4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 24 Mar 2011 11:11:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Mar 23, 2011 at 5:44 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> > Boo.
> >> > You seems forgot why you introduced current all_unreclaimable() function.
> >> > While hibernation, we can't trust all_unreclaimable.
> >>
> >> Hmm. AFAIR, the why we add all_unreclaimable is when the hibernation is going on,
> >> kswapd is freezed so it can't mark the zone->all_unreclaimable.
> >> So I think hibernation can't be a problem.
> >> Am I miss something?
> >
> > Ahh, I missed. thans correct me. Okay, I recognized both mine and your works.
> > Can you please explain why do you like your one than mine?
> 
> Just _simple_ :)
> I don't want to change many lines although we can do it simple and very clear.
>
> >
> > btw, Your one is very similar andrey's initial patch. If your one is
> > better, I'd like to ack with andrey instead.
> 
> When Andrey sent a patch, I though this as zone_reclaimable() is right
> place to check it than out of zone_reclaimable. Why I didn't ack is
> that Andrey can't explain root cause but you did so you persuade me.
> 
> I don't mind if Andrey move the check in zone_reclaimable and resend
> or I resend with concrete description.
> 
> Anyway, most important thing is good description to show the root cause.
> It is applied to your patch, too.
> You should have written down root cause in description.

honestly, I really dislike to use mixing zone->pages_scanned and 
zone->all_unreclaimable. because I think it's no simple. I don't 
think it's good taste nor easy to review. Even though you who VM 
expert didn't understand this issue at once, it's smell of too 
mess code.

therefore, I prefore to take either 1) just remove the function or
2) just only check zone->all_unreclaimable and oom_killer_disabled 
instead zone->pages_scanned.

And, I agree I need to rewrite the description. 
How's this?

==================================================
>From 216bcf3fb0476b453080debf8999c74c635ed72f Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Sun, 8 May 2011 17:39:44 +0900
Subject: [PATCH] vmscan: remove all_unreclaimable check from direct reclaim path completely

all_unreclaimable check in direct reclaim has been introduced at 2.6.19
by following commit.

	2006 Sep 25; commit 408d8544; oom: use unreclaimable info

And it went through strange history. firstly, following commit broke
the logic unintentionally.

	2008 Apr 29; commit a41f24ea; page allocator: smarter retry of
				      costly-order allocations

Two years later, I've found obvious meaningless code fragment and
restored original intention by following commit.

	2010 Jun 04; commit bb21c7ce; vmscan: fix do_try_to_free_pages()
				      return value when priority==0

But, the logic didn't works when 32bit highmem system goes hibernation
and Minchan slightly changed the algorithm and fixed it .

	2010 Sep 22: commit d1908362: vmscan: check all_unreclaimable
				      in direct reclaim path

But, recently, Andrey Vagin found the new corner case. Look,

	struct zone {
	  ..
	        int                     all_unreclaimable;
	  ..
	        unsigned long           pages_scanned;
	  ..
	}

zone->all_unreclaimable and zone->pages_scanned are neigher atomic
variables nor protected by lock. Therefore zones can become a state
of zone->page_scanned=0 and zone->all_unreclaimable=1. In this case,
current all_unreclaimable() return false even though
zone->all_unreclaimabe=1.

Is this ignorable minor issue? No. Unfortunatelly, x86 has very
small dma zone and it become zone->all_unreclamble=1 easily. and
if it become all_unreclaimable=1, it never restore all_unreclaimable=0.
Why? if all_unreclaimable=1, vmscan only try DEF_PRIORITY reclaim and
a-few-lru-pages>>DEF_PRIORITY always makes 0. that mean no page scan
at all!

Eventually, oom-killer never works on such systems.  Let's remove
this problematic logic completely.

Reported-by: Andrey Vagin <avagin@openvz.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   36 +-----------------------------------
 1 files changed, 1 insertions(+), 35 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 060e4c1..254aada 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1989,33 +1989,6 @@ static bool zone_reclaimable(struct zone *zone)
 }
 
 /*
- * As hibernation is going on, kswapd is freezed so that it can't mark
- * the zone into all_unreclaimable. It can't handle OOM during hibernation.
- * So let's check zone's unreclaimable in direct reclaim as well as kswapd.
- */
-static bool all_unreclaimable(struct zonelist *zonelist,
-		struct scan_control *sc)
-{
-	struct zoneref *z;
-	struct zone *zone;
-	bool all_unreclaimable = true;
-
-	for_each_zone_zonelist_nodemask(zone, z, zonelist,
-			gfp_zone(sc->gfp_mask), sc->nodemask) {
-		if (!populated_zone(zone))
-			continue;
-		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
-			continue;
-		if (zone_reclaimable(zone)) {
-			all_unreclaimable = false;
-			break;
-		}
-	}
-
-	return all_unreclaimable;
-}
-
-/*
  * This is the main entry point to direct page reclaim.
  *
  * If a full scan of the inactive list fails to free enough memory then we
@@ -2105,14 +2078,7 @@ out:
 	delayacct_freepages_end();
 	put_mems_allowed();
 
-	if (sc->nr_reclaimed)
-		return sc->nr_reclaimed;
-
-	/* top priority shrink_zones still had more to do? don't OOM, then */
-	if (scanning_global_lru(sc) && !all_unreclaimable(zonelist, sc))
-		return 1;
-
-	return 0;
+	return sc->nr_reclaimed;
 }
 
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-- 
1.6.5.2





