Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab1CKASY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:18:24 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45785 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab1CKASW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:18:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tqZ5RYWOP2KRppbQQ57j8RBSePQcQe/bFSteEr8eG1AwNCpERaw5IZO+0reGjSCbDv
         SHNGb+vBbwyqhRpMKSjFcJ6RsMiM8hPEFIOIlz+OYrR9yRVPsqtxLnz3ASYZ1lFbyVkO
         4xWRxrR+PkLcQ7M49a+2zEN976z4gIzy30LYQ=
MIME-Version: 1.0
In-Reply-To: <20110311085833.874c6c0e.kamezawa.hiroyu@jp.fujitsu.com>
References: <1299325456-2687-1-git-send-email-avagin@openvz.org>
	<20110305152056.GA1918@barrios-desktop>
	<4D72580D.4000208@gmail.com>
	<20110305155316.GB1918@barrios-desktop>
	<4D7267B6.6020406@gmail.com>
	<20110305170759.GC1918@barrios-desktop>
	<20110307135831.9e0d7eaa.akpm@linux-foundation.org>
	<AANLkTinDhorLusBju=Gn3bh1VsH1jrv0qixbU3SGWiqa@mail.gmail.com>
	<20110309143704.194e8ee1.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=q=YMrT7Uta+wGm47VZ5N6meybAQTgjKGsDWFw@mail.gmail.com>
	<20110311085833.874c6c0e.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 11 Mar 2011 09:18:21 +0900
Message-ID: <AANLkTi=1695Wp9UheV_OKk5MixNUY2aHWfQ2WO1evSe2@mail.gmail.com>
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in all_unreclaimable()
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrew Vagin <avagin@gmail.com>,
        Andrey Vagin <avagin@openvz.org>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 8:58 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 10 Mar 2011 15:58:29 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> Hi Kame,
>>
>> Sorry for late response.
>> I had a time to test this issue shortly because these day I am very busy.
>> This issue was interesting to me.
>> So I hope taking a time for enough testing when I have a time.
>> I should find out root cause of livelock.
>>
>
> Thanks. I and Kosaki-san reproduced the bug with swapless system.
> Now, Kosaki-san is digging and found some issue with scheduler boost at OOM
> and lack of enough "wait" in vmscan.c.
>
> I myself made patch like attached one. This works well for returning TRUE at
> all_unreclaimable() but livelock(deadlock?) still happens.

I saw the deadlock.
It seems to happen by following code by my quick debug but not sure. I
need to investigate further but don't have a time now. :(


                 * Note: this may have a chance of deadlock if it gets
                 * blocked waiting for another task which itself is waiting
                 * for memory. Is there a better alternative?
                 */
                if (test_tsk_thread_flag(p, TIF_MEMDIE))
                        return ERR_PTR(-1UL);
It would be wait to die the task forever without another victim selection.
If it's right, It's a known BUG and we have no choice until now. Hmm.

> I wonder vmscan itself isn't a key for fixing issue.

I agree.

> Then, I'd like to wait for Kosaki-san's answer ;)

Me, too. :)

>
> I'm now wondering how to catch fork-bomb and stop it (without using cgroup).

Yes. Fork throttling without cgroup is very important.
And as off-topic, mem_notify without memcontrol you mentioned is
important to embedded people, I gues.

> I think the problem is that fork-bomb is faster than killall...

And deadlock problem I mentioned.

>
> Thanks,
> -Kame

Thanks for the investigation, Kame.

> ==
>
> This is just a debug patch.
>
> ---
>  mm/vmscan.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 54 insertions(+), 4 deletions(-)
>
> Index: mmotm-0303/mm/vmscan.c
> ===================================================================
> --- mmotm-0303.orig/mm/vmscan.c
> +++ mmotm-0303/mm/vmscan.c
> @@ -1983,9 +1983,55 @@ static void shrink_zones(int priority, s
>        }
>  }
>
> -static bool zone_reclaimable(struct zone *zone)
> +static bool zone_seems_empty(struct zone *zone, struct scan_control *sc)
>  {
> -       return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
> +       unsigned long nr, wmark, free, isolated, lru;
> +
> +       /*
> +        * If scanned, zone->pages_scanned is incremented and this can
> +        * trigger OOM.
> +        */
> +       if (sc->nr_scanned)
> +               return false;
> +
> +       free = zone_page_state(zone, NR_FREE_PAGES);
> +       isolated = zone_page_state(zone, NR_ISOLATED_FILE);
> +       if (nr_swap_pages)
> +               isolated += zone_page_state(zone, NR_ISOLATED_ANON);
> +
> +       /* In we cannot do scan, don't count LRU pages. */
> +       if (!zone->all_unreclaimable) {
> +               lru = zone_page_state(zone, NR_ACTIVE_FILE);
> +               lru += zone_page_state(zone, NR_INACTIVE_FILE);
> +               if (nr_swap_pages) {
> +                       lru += zone_page_state(zone, NR_ACTIVE_ANON);
> +                       lru += zone_page_state(zone, NR_INACTIVE_ANON);
> +               }
> +       } else
> +               lru = 0;
> +       nr = free + isolated + lru;
> +       wmark = min_wmark_pages(zone);
> +       wmark += zone->lowmem_reserve[gfp_zone(sc->gfp_mask)];
> +       wmark += 1 << sc->order;
> +       printk("thread %d/%ld all %d scanned %ld pages %ld/%ld/%ld/%ld/%ld/%ld\n",
> +               current->pid, sc->nr_scanned, zone->all_unreclaimable,
> +               zone->pages_scanned,
> +               nr,free,isolated,lru,
> +               zone_reclaimable_pages(zone), wmark);
> +       /*
> +        * In some case (especially noswap), almost all page cache are paged out
> +        * and we'll see the amount of reclaimable+free pages is smaller than
> +        * zone->min. In this case, we canoot expect any recovery other
> +        * than OOM-KILL. We can't reclaim memory enough for usual tasks.
> +        */
> +
> +       return nr <= wmark;
> +}
> +
> +static bool zone_reclaimable(struct zone *zone, struct scan_control *sc)
> +{
> +       /* zone_reclaimable_pages() can return 0, we need <= */
> +       return zone->pages_scanned <= zone_reclaimable_pages(zone) * 6;
>  }
>
>  /*
> @@ -2006,11 +2052,15 @@ static bool all_unreclaimable(struct zon
>                        continue;
>                if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
>                        continue;
> -               if (zone_reclaimable(zone)) {
> +               if (zone_seems_empty(zone, sc))
> +                       continue;
> +               if (zone_reclaimable(zone, sc)) {
>                        all_unreclaimable = false;
>                        break;
>                }
>        }
> +       if (all_unreclaimable)
> +               printk("all_unreclaimable() returns TRUE\n");
>
>        return all_unreclaimable;
>  }
> @@ -2456,7 +2506,7 @@ loop_again:
>                        if (zone->all_unreclaimable)
>                                continue;
>                        if (!compaction && nr_slab == 0 &&
> -                           !zone_reclaimable(zone))
> +                           !zone_reclaimable(zone, &sc))
>                                zone->all_unreclaimable = 1;
>                        /*
>                         * If we've done a decent amount of scanning and
>
>



-- 
Kind regards,
Minchan Kim
