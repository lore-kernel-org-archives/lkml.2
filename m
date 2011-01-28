Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1A1C4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 21:56:34 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41987 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab1A1C4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 21:56:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lS0Bhn28+yuWMIQ0HQm6xM7w7aFi+Y4p5U559xfRpkUH8lnTm/SlAQ/cB70CkHTsSt
         WkBxo55hWe+x63ho3KE/6Km9wa8uiuDXZBxzxG0m1Zi2zXpkRHg/cW0F/4a5/LgtxYuc
         2qH/yAqFeEsqxMWY8ssV6fj2KOU0dkxcGPz80=
MIME-Version: 1.0
In-Reply-To: <AANLkTikHLw0Qg+odOB-bDtBSB-5UbTJ5ZOM-ZAdMqXgh@mail.gmail.com>
References: <20110125051003.13762.35120.stgit@localhost6.localdomain6>
	<20110125051015.13762.13429.stgit@localhost6.localdomain6>
	<AANLkTikHLw0Qg+odOB-bDtBSB-5UbTJ5ZOM-ZAdMqXgh@mail.gmail.com>
Date: Fri, 28 Jan 2011 08:26:32 +0530
X-Google-Sender-Auth: pJM5TmtZr86m0u1k54pa0cwppPg
Message-ID: <AANLkTi=qXsDjN5Jp4m3QMgVnckoAM7uE9_Hzn6CajP+c@mail.gmail.com>
Subject: Re: [PATCH 3/3] Provide control over unmapped pages (v4)
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 4:42 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
[snip]

>> index 7b56473..2ac8549 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1660,6 +1660,9 @@ zonelist_scan:
>>                        unsigned long mark;
>>                        int ret;
>>
>> +                       if (should_reclaim_unmapped_pages(zone))
>> +                               wakeup_kswapd(zone, order, classzone_idx);
>> +
>
> Do we really need the check in fastpath?
> There are lost of caller of alloc_pages.
> Many of them are not related to mapped pages.
> Could we move the check into add_to_page_cache_locked?

The check is a simple check to see if the unmapped pages need
balancing, the reason I placed this check here is to allow other
allocations to benefit as well, if there are some unmapped pages to be
freed. add_to_page_cache_locked (check under a critical section) is
even worse, IMHO.


>
>>                        mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
>>                        if (zone_watermark_ok(zone, order, mark,
>>                                    classzone_idx, alloc_flags))
>> @@ -4167,8 +4170,12 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
>>
>>                zone->spanned_pages = size;
>>                zone->present_pages = realsize;
>> +#if defined(CONFIG_UNMAPPED_PAGE_CONTROL) || defined(CONFIG_NUMA)
>>                zone->min_unmapped_pages = (realsize*sysctl_min_unmapped_ratio)
>>                                                / 100;
>> +               zone->max_unmapped_pages = (realsize*sysctl_max_unmapped_ratio)
>> +                                               / 100;
>> +#endif
>>  #ifdef CONFIG_NUMA
>>                zone->node = nid;
>>                zone->min_slab_pages = (realsize * sysctl_min_slab_ratio) / 100;
>> @@ -5084,6 +5091,7 @@ int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
>>        return 0;
>>  }
>>
>> +#if defined(CONFIG_UNMAPPED_PAGE_CONTROL) || defined(CONFIG_NUMA)
>>  int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
>>        void __user *buffer, size_t *length, loff_t *ppos)
>>  {
>> @@ -5100,6 +5108,23 @@ int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
>>        return 0;
>>  }
>>
>> +int sysctl_max_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
>> +       void __user *buffer, size_t *length, loff_t *ppos)
>> +{
>> +       struct zone *zone;
>> +       int rc;
>> +
>> +       rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
>> +       if (rc)
>> +               return rc;
>> +
>> +       for_each_zone(zone)
>> +               zone->max_unmapped_pages = (zone->present_pages *
>> +                               sysctl_max_unmapped_ratio) / 100;
>> +       return 0;
>> +}
>> +#endif
>> +
>>  #ifdef CONFIG_NUMA
>>  int sysctl_min_slab_ratio_sysctl_handler(ctl_table *table, int write,
>>        void __user *buffer, size_t *length, loff_t *ppos)
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 02cc82e..6377411 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -159,6 +159,29 @@ static DECLARE_RWSEM(shrinker_rwsem);
>>  #define scanning_global_lru(sc)        (1)
>>  #endif
>>
>> +#if defined(CONFIG_UNMAPPED_PAGECACHE_CONTROL)
>> +static unsigned long reclaim_unmapped_pages(int priority, struct zone *zone,
>> +                                               struct scan_control *sc);
>> +static int unmapped_page_control __read_mostly;
>> +
>> +static int __init unmapped_page_control_parm(char *str)
>> +{
>> +       unmapped_page_control = 1;
>> +       /*
>> +        * XXX: Should we tweak swappiness here?
>> +        */
>> +       return 1;
>> +}
>> +__setup("unmapped_page_control", unmapped_page_control_parm);
>> +
>> +#else /* !CONFIG_UNMAPPED_PAGECACHE_CONTROL */
>> +static inline unsigned long reclaim_unmapped_pages(int priority,
>> +                               struct zone *zone, struct scan_control *sc)
>> +{
>> +       return 0;
>> +}
>> +#endif
>> +
>>  static struct zone_reclaim_stat *get_reclaim_stat(struct zone *zone,
>>                                                  struct scan_control *sc)
>>  {
>> @@ -2359,6 +2382,12 @@ loop_again:
>>                                shrink_active_list(SWAP_CLUSTER_MAX, zone,
>>                                                        &sc, priority, 0);
>>
>> +                       /*
>> +                        * We do unmapped page reclaim once here and once
>> +                        * below, so that we don't lose out
>> +                        */
>> +                       reclaim_unmapped_pages(priority, zone, &sc);
>> +
>>                        if (!zone_watermark_ok_safe(zone, order,
>>                                        high_wmark_pages(zone), 0, 0)) {
>>                                end_zone = i;
>> @@ -2396,6 +2425,11 @@ loop_again:
>>                                continue;
>>
>>                        sc.nr_scanned = 0;
>> +                       /*
>> +                        * Reclaim unmapped pages upfront, this should be
>> +                        * really cheap
>> +                        */
>> +                       reclaim_unmapped_pages(priority, zone, &sc);
>
> Why should we do by two phase?
> It's not a direct reclaim path. I mean it doesn't need to reclaim tighly
> If we can't reclaim enough, next allocation would wake up kswapd again
> and kswapd try it again.
>

I am not sure I understand, the wakeup will occur only if the unmapped
pages are still above the max_unmapped_ratio. They are tunable control
points.

> And I have a concern. I already pointed out.
> If memory pressure is heavy and unmappd_pages is more than our
> threshold, this can move inactive's tail pages which are mapped into
> heads by reclaim_unmapped_pages. It can make confusing LRU order so
> working set can be evicted.
>

Sorry, not sure  I understand completely? The LRU order is disrupted
because we selectively scan unmapped pages. shrink_page_list() will
ignore mapped pages and put them back in the LRU at head? Here is a
quick take on what happens

zone_reclaim() will be invoked as a result of these patches and the
pages it tries to reclaim is very few (1 << order). Active list will
be shrunk only when the inactive anon or inactive list is low in size.
I don't see a major churn happening unless we keep failing to reclaim
unmapped pages. In any case we isolate inactive pages and try to
reclaim minimal memory, the churn is mostly in the inactive list if
the page is not reclaimed (am I missing anything?).


> zone_reclaim is used by only NUMA until now but you are opening it in the world.
> I think it would be a good feature in embedded system, too.
> I hope we care of working set eviction problem.
>

I hope the above answers your questions

Balbir
