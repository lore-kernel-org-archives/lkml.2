Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab0IHPpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:45:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60931 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab0IHPpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:45:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T5tDBjRMPDyOnfucipCCwtVYBBBLs052OvnqS//9HgzJZOhc0SqNtNyy9DJj+LBlyo
         FsXlvgblZq0KTnkgFd2+mwYieAZj/6aGUDYZUDdtfgZ8q3R1/DIkFC5oEdTBinATgMVi
         iXrRrPcrLGDHaVWbSmeTNS0CWZSEw2DfuqA+A=
Date: Thu, 9 Sep 2010 00:45:27 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "M. Vefa Bicakci" <bicave@superonline.com>, stable@kernel.org
Subject: Re: [PATCH] vmscan: check all_unreclaimable in direct reclaim path
Message-ID: <20100908154527.GA5936@barrios-desktop>
References: <1283697637-3117-1-git-send-email-minchan.kim@gmail.com>
 <20100908054831.GB20955@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908054831.GB20955@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 07:48:31AM +0200, Johannes Weiner wrote:
> On Sun, Sep 05, 2010 at 11:40:37PM +0900, Minchan Kim wrote:
> > M. Vefa Bicakci reported 2.6.35 kernel hang up when hibernation on his
> > 32bit 3GB mem machine. (https://bugzilla.kernel.org/show_bug.cgi?id=16771)
> > Also he was bisected first bad commit is below
> > 
> >   commit bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
> >   Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >   Date:   Fri Jun 4 14:15:05 2010 -0700
> > 
> >      vmscan: fix do_try_to_free_pages() return value when priority==0 reclaim failure
> > 
> > At first impression, this seemed very strange because the above commit only
> > chenged function return value and hibernate_preallocate_memory() ignore
> > return value of shrink_all_memory(). But it's related.
> > 
> > Now, page allocation from hibernation code may enter infinite loop if
> > the system has highmem. The reasons are that vmscan don't care enough 
> > OOM case when oom_killer_disabled. 
> > 
> > The problem sequence is following as. 
> > 
> > 1. hibernation
> > 2. oom_disable
> > 3. alloc_pages
> > 4. do_try_to_free_pages
> >        if (scanning_global_lru(sc) && !all_unreclaimable)
> >                return 1;
> > 
> > If kswapd is not freezed, it would set zone->all_unreclaimable to 1 and then
> > shrink_zones maybe return true(ie, all_unreclaimable is true). 
> > so at last, alloc_pages could go to _nopage_. If it is, it should have no problem.
> > 
> > This patch adds all_unreclaimable check to protect in direct reclaim path, too.
> > It can care of hibernation OOM case and help bailout all_unreclaimable case slightly.
> > 
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Cc: M. Vefa Bicakci <bicave@superonline.com>
> > Cc: stable@kernel.org
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > ---
> >  mm/vmscan.c |   33 +++++++++++++++++++++++++++------
> >  1 files changed, 27 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index f620ab3..53b23a7 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1893,12 +1893,11 @@ static void shrink_zone(int priority, struct zone *zone,
> >   * If a zone is deemed to be full of pinned pages then just give it a light
> >   * scan then give up on it.
> >   */
> > -static bool shrink_zones(int priority, struct zonelist *zonelist,
> > +static void shrink_zones(int priority, struct zonelist *zonelist,
> >  					struct scan_control *sc)
> >  {
> >  	struct zoneref *z;
> >  	struct zone *zone;
> > -	bool all_unreclaimable = true;
> >  
> >  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
> >  					gfp_zone(sc->gfp_mask), sc->nodemask) {
> > @@ -1916,8 +1915,31 @@ static bool shrink_zones(int priority, struct zonelist *zonelist,
> >  		}
> >  
> >  		shrink_zone(priority, zone, sc);
> > -		all_unreclaimable = false;
> >  	}
> > +}
> > +
> > +static inline bool all_unreclaimable(struct zonelist *zonelist,
> > +		struct scan_control *sc)
> > +{
> > +	struct zoneref *z;
> > +	struct zone *zone;
> > +	bool all_unreclaimable = true;
> > +
> > +	if (!scanning_global_lru(sc))
> > +		return false;
> > +
> > +	for_each_zone_zonelist_nodemask(zone, z, zonelist,
> > +			gfp_zone(sc->gfp_mask), sc->nodemask) {
> > +		if (!populated_zone(zone))
> > +			continue;
> > +		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
> > +			continue;
> > +		if (zone->pages_scanned < (zone_reclaimable_pages(zone) * 6)) {
> 
> Small nitpick: kswapd does the same check against the magic number,
> could you move it into a separate function?  zone_reclaimable()?

Nice cleanup. 
Thanks, Hannes. 

> 
> Otherwise,
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> 

== CUT HERE ==

Changelog 

v2
 * cleanup zone_reclaimable(suggested by Johannes)
 * rebase on mmotm-08-27
 

>From 7b47ffbc9ce89daa44f16bdf447d63ce94dd5f9a Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan.kim@gmail.com>
Date: Thu, 9 Sep 2010 00:37:52 +0900
Subject: [PATCH v2] vmscan: check all_unreclaimable in direct reclaim path

M. Vefa Bicakci reported 2.6.35 kernel hang up when hibernation on his
32bit 3GB mem machine. (https://bugzilla.kernel.org/show_bug.cgi?id=16771)
Also he was bisected first bad commit is below

  commit bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
  Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
  Date:   Fri Jun 4 14:15:05 2010 -0700

     vmscan: fix do_try_to_free_pages() return value when priority==0 reclaim failure

At first impression, this seemed very strange because the above commit only
chenged function return value and hibernate_preallocate_memory() ignore
return value of shrink_all_memory(). But it's related.

Now, page allocation from hibernation code may enter infinite loop if
the system has highmem. The reasons are that vmscan don't care enough
OOM case when oom_killer_disabled.

The problem sequence is following as.

1. hibernation
2. oom_disable
3. alloc_pages
4. do_try_to_free_pages
       if (scanning_global_lru(sc) && !all_unreclaimable)
               return 1;

If kswapd is not freezed, it would set zone->all_unreclaimable to 1 and then
shrink_zones maybe return true(ie, all_unreclaimable is true).
so at last, alloc_pages could go to _nopage_. If it is, it should have no problem.

This patch adds all_unreclaimable check to protect in direct reclaim path, too.
It can care of hibernation OOM case and help bailout all_unreclaimable case slightly.

Cc: Rik van Riel <riel@redhat.com>
Cc: M. Vefa Bicakci <bicave@superonline.com>
Cc: stable@kernel.org
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/vmscan.c |   41 +++++++++++++++++++++++++++++++++--------
 1 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7870893..9a45758 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1877,12 +1877,11 @@ static void shrink_zone(int priority, struct zone *zone,
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
  */
-static bool shrink_zones(int priority, struct zonelist *zonelist,
+static void shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
-	bool all_unreclaimable = true;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
@@ -1900,8 +1899,36 @@ static bool shrink_zones(int priority, struct zonelist *zonelist,
 		}
 
 		shrink_zone(priority, zone, sc);
-		all_unreclaimable = false;
 	}
+}
+
+static inline bool zone_reclaimable(struct zone *zone)
+{
+	return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
+}
+
+static inline bool all_unreclaimable(struct zonelist *zonelist,
+		struct scan_control *sc)
+{
+	struct zoneref *z;
+	struct zone *zone;
+	bool all_unreclaimable = true;
+
+	if (!scanning_global_lru(sc))
+		return false;
+
+	for_each_zone_zonelist_nodemask(zone, z, zonelist,
+			gfp_zone(sc->gfp_mask), sc->nodemask) {
+		if (!populated_zone(zone))
+			continue;
+		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
+			continue;
+		if (zone_reclaimable(zone)) {
+			all_unreclaimable = false;
+			break;
+		}
+	}
+
 	return all_unreclaimable;
 }
 
@@ -1925,7 +1952,6 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 					struct scan_control *sc)
 {
 	int priority;
-	bool all_unreclaimable;
 	unsigned long total_scanned = 0;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct zoneref *z;
@@ -1942,7 +1968,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token();
-		all_unreclaimable = shrink_zones(priority, zonelist, sc);
+		shrink_zones(priority, zonelist, sc);
 		/*
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
@@ -2004,7 +2030,7 @@ out:
 		return sc->nr_reclaimed;
 
 	/* top priority shrink_zones still had more to do? don't OOM, then */
-	if (scanning_global_lru(sc) && !all_unreclaimable)
+	if (!all_unreclaimable(zonelist, sc))
 		return 1;
 
 	return 0;
@@ -2270,8 +2296,7 @@ loop_again:
 			total_scanned += sc.nr_scanned;
 			if (zone->all_unreclaimable)
 				continue;
-			if (nr_slab == 0 &&
-			    zone->pages_scanned >= (zone_reclaimable_pages(zone) * 6))
+			if (nr_slab == 0 && !zone_reclaimable(zone))
 				zone->all_unreclaimable = 1;
 			/*
 			 * If we've done a decent amount of scanning and
-- 
1.7.0.5

-- 
Kind regards,
Minchan Kim
