Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1A1HYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 02:24:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38363 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab1A1HYU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 02:24:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NdRRKRZ9ZXLnP3ZPzgCFbKL/fOZFbAa/G8+uY+tWdcNpMSt216Ge5uVRG0KIYLzCbo
         JLJ3jkxs6Em/Mdz1OmfEH8f+5fBE/wP4QIBK9L4RKwbubRGaHNrz3jMP4QFxFJmLoWei
         iV5zZIHSlEvYbIgPh0FxCzu4iZCJ1kD/Rvr6s=
MIME-Version: 1.0
In-Reply-To: <20110128064851.GB5054@balbir.in.ibm.com>
References: <20110125051003.13762.35120.stgit@localhost6.localdomain6>
	<20110125051015.13762.13429.stgit@localhost6.localdomain6>
	<AANLkTikHLw0Qg+odOB-bDtBSB-5UbTJ5ZOM-ZAdMqXgh@mail.gmail.com>
	<AANLkTi=qXsDjN5Jp4m3QMgVnckoAM7uE9_Hzn6CajP+c@mail.gmail.com>
	<AANLkTinfxXc04S9VwQcJ9thFff=cP=icroaiVLkN-GeH@mail.gmail.com>
	<20110128064851.GB5054@balbir.in.ibm.com>
Date: Fri, 28 Jan 2011 16:24:19 +0900
Message-ID: <AANLkTikw_j0JJVqEsj1xThoashiOARg+8BgcLKrvkV3U@mail.gmail.com>
Subject: Re: [PATCH 3/3] Provide control over unmapped pages (v4)
From: Minchan Kim <minchan.kim@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 3:48 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * MinChan Kim <minchan.kim@gmail.com> [2011-01-28 14:44:50]:
>
>> On Fri, Jan 28, 2011 at 11:56 AM, Balbir Singh
>> <balbir@linux.vnet.ibm.com> wrote:
>> > On Thu, Jan 27, 2011 at 4:42 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
>> > [snip]
>> >
>> >>> index 7b56473..2ac8549 100644
>> >>> --- a/mm/page_alloc.c
>> >>> +++ b/mm/page_alloc.c
>> >>> @@ -1660,6 +1660,9 @@ zonelist_scan:
>> >>>                        unsigned long mark;
>> >>>                        int ret;
>> >>>
>> >>> +                       if (should_reclaim_unmapped_pages(zone))
>> >>> +                               wakeup_kswapd(zone, order, classzone_idx);
>> >>> +
>> >>
>> >> Do we really need the check in fastpath?
>> >> There are lost of caller of alloc_pages.
>> >> Many of them are not related to mapped pages.
>> >> Could we move the check into add_to_page_cache_locked?
>> >
>> > The check is a simple check to see if the unmapped pages need
>> > balancing, the reason I placed this check here is to allow other
>> > allocations to benefit as well, if there are some unmapped pages to be
>> > freed. add_to_page_cache_locked (check under a critical section) is
>> > even worse, IMHO.
>>
>> It just moves the overhead from general into specific case(ie,
>> allocates page for just page cache).
>> Another cases(ie, allocates pages for other purpose except page cache,
>> ex device drivers or fs allocation for internal using) aren't
>> affected.
>> So, It would be better.
>>
>> The goal in this patch is to remove only page cache page, isn't it?
>> So I think we could the balance check in add_to_page_cache and trigger reclaim.
>> If we do so, what's the problem?
>>
>
> I see it as a tradeoff of when to check? add_to_page_cache or when we
> are want more free memory (due to allocation). It is OK to wakeup
> kswapd while allocating memory, somehow for this purpose (global page
> cache), add_to_page_cache or add_to_page_cache_locked does not seem
> the right place to hook into. I'd be open to comments/suggestions
> though from others as well.
>
>> >
>> >
>> >>
>> >>>                        mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
>> >>>                        if (zone_watermark_ok(zone, order, mark,
>> >>>                                    classzone_idx, alloc_flags))
>> >>> @@ -4167,8 +4170,12 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
>> >>>
>> >>>                zone->spanned_pages = size;
>> >>>                zone->present_pages = realsize;
>> >>> +#if defined(CONFIG_UNMAPPED_PAGE_CONTROL) || defined(CONFIG_NUMA)
>> >>>                zone->min_unmapped_pages = (realsize*sysctl_min_unmapped_ratio)
>> >>>                                                / 100;
>> >>> +               zone->max_unmapped_pages = (realsize*sysctl_max_unmapped_ratio)
>> >>> +                                               / 100;
>> >>> +#endif
>> >>>  #ifdef CONFIG_NUMA
>> >>>                zone->node = nid;
>> >>>                zone->min_slab_pages = (realsize * sysctl_min_slab_ratio) / 100;
>> >>> @@ -5084,6 +5091,7 @@ int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
>> >>>        return 0;
>> >>>  }
>> >>>
>> >>> +#if defined(CONFIG_UNMAPPED_PAGE_CONTROL) || defined(CONFIG_NUMA)
>> >>>  int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
>> >>>        void __user *buffer, size_t *length, loff_t *ppos)
>> >>>  {
>> >>> @@ -5100,6 +5108,23 @@ int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
>> >>>        return 0;
>> >>>  }
>> >>>
>> >>> +int sysctl_max_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
>> >>> +       void __user *buffer, size_t *length, loff_t *ppos)
>> >>> +{
>> >>> +       struct zone *zone;
>> >>> +       int rc;
>> >>> +
>> >>> +       rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
>> >>> +       if (rc)
>> >>> +               return rc;
>> >>> +
>> >>> +       for_each_zone(zone)
>> >>> +               zone->max_unmapped_pages = (zone->present_pages *
>> >>> +                               sysctl_max_unmapped_ratio) / 100;
>> >>> +       return 0;
>> >>> +}
>> >>> +#endif
>> >>> +
>> >>>  #ifdef CONFIG_NUMA
>> >>>  int sysctl_min_slab_ratio_sysctl_handler(ctl_table *table, int write,
>> >>>        void __user *buffer, size_t *length, loff_t *ppos)
>> >>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> >>> index 02cc82e..6377411 100644
>> >>> --- a/mm/vmscan.c
>> >>> +++ b/mm/vmscan.c
>> >>> @@ -159,6 +159,29 @@ static DECLARE_RWSEM(shrinker_rwsem);
>> >>>  #define scanning_global_lru(sc)        (1)
>> >>>  #endif
>> >>>
>> >>> +#if defined(CONFIG_UNMAPPED_PAGECACHE_CONTROL)
>> >>> +static unsigned long reclaim_unmapped_pages(int priority, struct zone *zone,
>> >>> +                                               struct scan_control *sc);
>> >>> +static int unmapped_page_control __read_mostly;
>> >>> +
>> >>> +static int __init unmapped_page_control_parm(char *str)
>> >>> +{
>> >>> +       unmapped_page_control = 1;
>> >>> +       /*
>> >>> +        * XXX: Should we tweak swappiness here?
>> >>> +        */
>> >>> +       return 1;
>> >>> +}
>> >>> +__setup("unmapped_page_control", unmapped_page_control_parm);
>> >>> +
>> >>> +#else /* !CONFIG_UNMAPPED_PAGECACHE_CONTROL */
>> >>> +static inline unsigned long reclaim_unmapped_pages(int priority,
>> >>> +                               struct zone *zone, struct scan_control *sc)
>> >>> +{
>> >>> +       return 0;
>> >>> +}
>> >>> +#endif
>> >>> +
>> >>>  static struct zone_reclaim_stat *get_reclaim_stat(struct zone *zone,
>> >>>                                                  struct scan_control *sc)
>> >>>  {
>> >>> @@ -2359,6 +2382,12 @@ loop_again:
>> >>>                                shrink_active_list(SWAP_CLUSTER_MAX, zone,
>> >>>                                                        &sc, priority, 0);
>> >>>
>> >>> +                       /*
>> >>> +                        * We do unmapped page reclaim once here and once
>> >>> +                        * below, so that we don't lose out
>> >>> +                        */
>> >>> +                       reclaim_unmapped_pages(priority, zone, &sc);
>> >>> +
>> >>>                        if (!zone_watermark_ok_safe(zone, order,
>> >>>                                        high_wmark_pages(zone), 0, 0)) {
>> >>>                                end_zone = i;
>> >>> @@ -2396,6 +2425,11 @@ loop_again:
>> >>>                                continue;
>> >>>
>> >>>                        sc.nr_scanned = 0;
>> >>> +                       /*
>> >>> +                        * Reclaim unmapped pages upfront, this should be
>> >>> +                        * really cheap
>> >>> +                        */
>> >>> +                       reclaim_unmapped_pages(priority, zone, &sc);
>> >>
>> >> Why should we do by two phase?
>> >> It's not a direct reclaim path. I mean it doesn't need to reclaim tighly
>> >> If we can't reclaim enough, next allocation would wake up kswapd again
>> >> and kswapd try it again.
>> >>
>> >
>> > I am not sure I understand, the wakeup will occur only if the unmapped
>> > pages are still above the max_unmapped_ratio. They are tunable control
>> > points.
>>
>> I mean you try to reclaim twice in one path.
>> one is when select highest zone to reclaim.
>> one is when VM reclaim the zone.
>>
>> What's your intention?
>>
>
> That is because some zones can be skipped, we need to ensure we go
> through all zones, rather than selective zones (limited via search for
> end_zone).

If kswapd is wake up by unmapped memory of some zone, we have to
include the zone while selective victim zones to prevent miss the
zone.
I think it would be better than reclaiming twice

>
>>
>> >
>> >> And I have a concern. I already pointed out.
>> >> If memory pressure is heavy and unmappd_pages is more than our
>> >> threshold, this can move inactive's tail pages which are mapped into
>> >> heads by reclaim_unmapped_pages. It can make confusing LRU order so
>> >> working set can be evicted.
>> >>
>> >
>> > Sorry, not sure  I understand completely? The LRU order is disrupted
>> > because we selectively scan unmapped pages. shrink_page_list() will
>> > ignore mapped pages and put them back in the LRU at head? Here is a
>> > quick take on what happens
>> >
>> > zone_reclaim() will be invoked as a result of these patches and the
>> > pages it tries to reclaim is very few (1 << order). Active list will
>> > be shrunk only when the inactive anon or inactive list is low in size.
>> > I don't see a major churn happening unless we keep failing to reclaim
>> > unmapped pages. In any case we isolate inactive pages and try to
>> > reclaim minimal memory, the churn is mostly in the inactive list if
>> > the page is not reclaimed (am I missing anything?).
>>
>> You understand my question completely. :)
>> In inactive list, page order is important, too although it's weak
>> lumpy and compaction as time goes by.
>> If threshold up and down happens  frequently, victim pages in inactive
>> list could move into head and it's not good.
>
> But the assumption for LRU order to change happens only if the page
> cannot be successfully freed, which means it is in some way active..
> and needs to be moved no?

1. holded page by someone
2. mapped pages
3. active pages

1 is rare so it isn't the problem.
Of course, in case of 3, we have to activate it so no problem.
The problem is 2.

>
> Thanks for the detailed review!

Thanks for giving the fun to me. :)

>
> --
>        Three Cheers,
>        Balbir
>



-- 
Kind regards,
Minchan Kim
