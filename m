Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0IBA5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 20:57:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43105 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab0IBA5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 20:57:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [BUGFIX][PATCH] vmscan: don't use return value trick when oom_killer_disabled
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "M. Vefa Bicakci" <bicave@superonline.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100901155644.GA10246@barrios-desktop>
References: <AANLkTinxHbeCUh80i515FPMpF-GY4S0kh9PHqUNtYP-m@mail.gmail.com> <20100901155644.GA10246@barrios-desktop>
Message-Id: <20100902091206.D053.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  2 Sep 2010 09:57:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Sep 01, 2010 at 11:01:43AM +0900, Minchan Kim wrote:
> > On Wed, Sep 1, 2010 at 10:55 AM, KOSAKI Motohiro
> > <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > Hi
> > >
> > > Thank you for good commenting!
> > >
> > >
> > >> I don't like use oom_killer_disabled directly.
> > >> That's because we have wrapper inline functions to handle the
> > >> variable(ex, oom_killer_[disable/enable]).
> > >> It means we are reluctant to use the global variable directly.
> > >> So should we make new function as is_oom_killer_disable?
> > >>
> > >> I think NO.
> > >>
> > >> As I read your description, this problem is related to only hibernation.
> > >> Since hibernation freezes all processes(include kswapd), this problem
> > >> happens. Of course, now oom_killer_disabled is used by only
> > >> hibernation. But it can be used others in future(Off-topic : I don't
> > >> want it). Others can use it without freezing processes. Then kswapd
> > >> can set zone->all_unreclaimable and the problem can't happen.
> > >>
> > >> So I want to use sc->hibernation_mode which is already used
> > >> do_try_to_free_pages instead of oom_killer_disabled.
> > >
> > > Unfortunatelly, It's impossible. shrink_all_memory() turn on
> > > sc->hibernation_mode. but other hibernation caller merely call
> > > alloc_pages(). so we don't have any hint.
> > >
> > Ahh.. True. Sorry for that.
> > I will think some better method.
> > if I can't find it, I don't mind this patch. :)
> 
> It seems that the poblem happens following as. 
> (I might miss something since I just read theyour description)
> 
> hibernation
> oom_disable
> alloc_pages
> do_try_to_free_pages
>         if (scanning_global_lru(sc) && !all_unreclaimable)
>                 return 1;
> If kswapd is not freezed, it would set zone->all_unreclaimable to 1 and then
> shrink_zones maybe return true. so alloc_pages could go to _nopage_.
> If it is, it's no problem. 
> Right?
> 
> I think the problem would come from shrink_zones. 
> It set false to all_unreclaimable blindly even though shrink_zone can't reclaim
> any page. It doesn't make sense. 
> How about this?
> I think we need this regardless of the problem.
> What do you think about?
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d8fd87d..22017b3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1901,7 +1901,8 @@ static bool shrink_zones(int priority, struct zonelist *zonelist,
>                 }
>  
>                 shrink_zone(priority, zone, sc);
> -               all_unreclaimable = false;
> +               if (sc->nr_reclaimed)
> +                       all_unreclaimable = false;
>         }
>         return all_unreclaimable;
>  }

here is brief of shrink_zones().

        for_each_zone_zonelist_nodemask(zone, z, zonelist,
                                        gfp_zone(sc->gfp_mask), sc->nodemask) {
                if (!populated_zone(zone))
                        continue;
                if (zone->all_unreclaimable && priority != DEF_PRIORITY)
                            continue;       /* Let kswapd poll it */
                shrink_zone(priority, zone, sc);
                all_unreclaimable = false;
        }

That said,
	all zone's zone->all_unreclaimable are true
		-> all_unreclaimable local variable become true.
	otherwise
		-> all_unreclaimable local variable become false.

The intention is, we don't want to invoke oom-killer if there are
!all_unreclaimable zones. So your patch makes big design change and
seems to increase OOM risk.

I don't want to send risky patch to -stable. 




