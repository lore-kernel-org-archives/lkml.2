Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0HCGjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 02:39:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:56571 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173Ab0HCGjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 02:39:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,308,1278313200"; 
   d="scan'208";a="592328926"
Date: Tue, 3 Aug 2010 14:39:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Chris Webb <chris@arachsys.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Over-eager swapping
Message-ID: <20100803063929.GB17955@localhost>
References: <20100802124734.GI2486@arachsys.com>
 <AANLkTinnWQA-K6r_+Y+giEC9zs-MbY6GFs8dWadSq0kh@mail.gmail.com>
 <20100803033108.GA23117@arachsys.com>
 <AANLkTinjmZOOaq7FgwJOZ=UNGS8x8KtQWZg6nv7fqJMe@mail.gmail.com>
 <20100803042835.GA17377@localhost>
 <AANLkTimC1z0MwTxUjxED7N1-R4D_YXtvnPSbiKXdR+4W@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimC1z0MwTxUjxED7N1-R4D_YXtvnPSbiKXdR+4W@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 12:47:36PM +0800, Minchan Kim wrote:
> On Tue, Aug 3, 2010 at 1:28 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > On Tue, Aug 03, 2010 at 12:09:18PM +0800, Minchan Kim wrote:
> >> On Tue, Aug 3, 2010 at 12:31 PM, Chris Webb <chris@arachsys.com> wrote:
> >> > Minchan Kim <minchan.kim@gmail.com> writes:
> >> >
> >> >> Another possibility is _zone_reclaim_ in NUMA.
> >> >> Your working set has many anonymous page.
> >> >>
> >> >> The zone_reclaim set priority to ZONE_RECLAIM_PRIORITY.
> >> >> It can make reclaim mode to lumpy so it can page out anon pages.
> >> >>
> >> >> Could you show me /proc/sys/vm/[zone_reclaim_mode/min_unmapped_ratio] ?
> >> >
> >> > Sure, no problem. On the machine with the /proc/meminfo I showed earlier,
> >> > these are
> >> >
> >> >  # cat /proc/sys/vm/zone_reclaim_mode
> >> >  0
> >> >  # cat /proc/sys/vm/min_unmapped_ratio
> >> >  1
> >>
> >> if zone_reclaim_mode is zero, it doesn't swap out anon_pages.
> >
> > If there are lots of order-1 or higher allocations, anonymous pages
> > will be randomly evicted, regardless of their LRU ages. This is
> 
> I thought swapped out page is huge (ie, 3G) even though it enters lumpy mode.
> But it's possible. :)
> 
> > probably another factor why the users claim. Are there easy ways to
> > confirm this other than patching the kernel?
> 
> cat /proc/buddyinfo can help?

Some high order slab caches may show up there :)

> Off-topic:
> It would be better to add new vmstat of lumpy entrance.

I think it's a good debug entry. Although convenient, lumpy reclaim
is accompanied with some bad side effects. When something goes wrong,
it helps to check the number of lumpy reclaims.

Thanks,
Fengguang

> Pseudo code.
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0f9f624..d10ff4e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1641,7 +1641,7 @@ out:
>         }
>  }
> 
> -static void set_lumpy_reclaim_mode(int priority, struct scan_control *sc)
> +static void set_lumpy_reclaim_mode(int priority, struct scan_control
> *sc, struct zone *zone)
>  {
>         /*
>          * If we need a large contiguous chunk of memory, or have
> @@ -1654,6 +1654,9 @@ static void set_lumpy_reclaim_mode(int priority,
> struct scan_control *sc)
>                 sc->lumpy_reclaim_mode = 1;
>         else
>                 sc->lumpy_reclaim_mode = 0;
> +
> +       if (sc->lumpy_reclaim_mode)
> +               inc_zone_state(zone, NR_LUMPY);
>  }
> 
>  /*
> @@ -1670,7 +1673,7 @@ static void shrink_zone(int priority, struct zone *zone,
> 
>         get_scan_count(zone, sc, nr, priority);
> 
> -       set_lumpy_reclaim_mode(priority, sc);
> +       set_lumpy_reclaim_mode(priority, sc, zone);
> 
>         while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
>                                         nr[LRU_INACTIVE_FILE]) {
> 
> -- 
> Kind regards,
> Minchan Kim
