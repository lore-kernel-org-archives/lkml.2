Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0IBDFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 23:05:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51503 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab0IBDFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 23:05:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [BUGFIX][PATCH] vmscan: don't use return value trick when oom_killer_disabled
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "M. Vefa Bicakci" <bicave@superonline.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTiknTqHw11xRXNP4X-0yN1=rWyCh3MJV=HjRiZQJ@mail.gmail.com>
References: <20100902091206.D053.A69D9226@jp.fujitsu.com> <AANLkTiknTqHw11xRXNP4X-0yN1=rWyCh3MJV=HjRiZQJ@mail.gmail.com>
Message-Id: <20100902115640.D071.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  2 Sep 2010 12:05:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't want to send risky patch to -stable.
> 
> Still I don't want to use oom_killer_disabled magic.
> But I don't want to prevent urgent stable patch due to my just nitpick.
> 
> This is my last try(just quick patch, even I didn't tried compile test).

Looks like conceptually correct. If you will test it and fix whitespace damage,
I'll ack this one gladly.

Thanks.



> If this isn't good, first of all, let's try merge yours.
> And then we can fix it later.
> 
> Thanks for comment.
> 
> -- CUT HERE --
> 
> Why do we check zone->all_unreclaimable in only kswapd?
> If kswapd is freezed in hibernation, OOM can happen.
> Let's the check in direct reclaim path, too.
> 
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3109ff7..41493ba 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1878,12 +1878,11 @@ static void shrink_zone(int priority, struct zone *zone,
>  * If a zone is deemed to be full of pinned pages then just give it a light
>   * scan then give up on it.
>   */
> -static bool shrink_zones(int priority, struct zonelist *zonelist,
> +static void shrink_zones(int priority, struct zonelist *zonelist,
>                                         struct scan_control *sc)
>  {
>         struct zoneref *z;
>         struct zone *zone;
> -       bool all_unreclaimable = true;
> 
>         for_each_zone_zonelist_nodemask(zone, z, zonelist,
>                                         gfp_zone(sc->gfp_mask), sc->nodemask) {
> @@ -1901,8 +1900,25 @@ static bool shrink_zones(int priority, struct
> zonelist *zonelist,
>                 }
> 
>                 shrink_zone(priority, zone, sc);
> -               all_unreclaimable = false;
>         }
> +}
> +
> +static inline int all_unreclaimable(struct zonelist *zonelist, struct
> scan_control *sc)
> +{
> +       struct zoneref *z;
> +       struct zone *zone;
> +       bool all_unreclaimable = true;
> +
> +       for_each_zone_zonelist_nodemask(zone, z, zonelist,
> +                                       gfp_zone(sc->gfp_mask), sc->nodemask) {
> +               if (!populated_zone(zone))
> +                       continue;
> +               if (zone->pages_scanned < (zone_reclaimable_pages(zone) * 6)) {
> +                       all_unreclaimable = false;
> +                       break;
> +               }
> +       }
> +
>         return all_unreclaimable;
>  }
> 
> @@ -1926,7 +1942,6 @@ static unsigned long do_try_to_free_pages(struct
> zonelist *zonelist,
>                                         struct scan_control *sc)
>  {
>         int priority;
> -       bool all_unreclaimable;
>         unsigned long total_scanned = 0;
>         struct reclaim_state *reclaim_state = current->reclaim_state;
>         struct zoneref *z;
> @@ -1943,7 +1958,7 @@ static unsigned long do_try_to_free_pages(struct
> zonelist *zonelist,
>                 sc->nr_scanned = 0;
>                 if (!priority)
>                         disable_swap_token();
> -               all_unreclaimable = shrink_zones(priority, zonelist, sc);
> +               shrink_zones(priority, zonelist, sc);
>                 /*
>                  * Don't shrink slabs when reclaiming memory from
>                  * over limit cgroups
> @@ -2005,7 +2020,7 @@ out:
>                 return sc->nr_reclaimed;
> 
>         /* top priority shrink_zones still had more to do? don't OOM, then */
> -       if (scanning_global_lru(sc) && !all_unreclaimable)
> +       if (scanning_global_lru(sc) && !all_unreclaimable(zonelist, sc))
>                 return 1;
> 
>         return 0;
> 
> 
> -- 
> Kind regards,
> Minchan Kim



