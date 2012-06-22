Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761501Ab2FVHWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 03:22:42 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42836 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759983Ab2FVHWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 03:22:40 -0400
MIME-Version: 1.0
In-Reply-To: <4FE3C4E4.2050107@kernel.org>
References: <4FE169B1.7020600@kernel.org> <4FE16E80.9000306@gmail.com>
 <4FE18187.3050103@kernel.org> <4FE23069.5030702@gmail.com>
 <4FE26470.90401@kernel.org> <CAHGf_=pjoiHQ9vxXXe-GtbkYRzhxdDhu3pf6pwDsCe5pBQE8Nw@mail.gmail.com>
 <4FE27F15.8050102@kernel.org> <CAHGf_=pDw4axwG2tQ+B5hPks-sz2S5+G1Kk-=HSDmo=DSXOkEw@mail.gmail.com>
 <4FE2A937.6040701@kernel.org> <4FE2FCFB.4040808@jp.fujitsu.com> <4FE3C4E4.2050107@kernel.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Fri, 22 Jun 2012 03:22:19 -0400
Message-ID: <CAHGf_=oo5GrsbjTRPF2vC-g8R1XVOhjLAMQg6ik49-fr8D=Q+g@mail.gmail.com>
Subject: Re: Accounting problem of MIGRATE_ISOLATED freed page
To: Minchan Kim <minchan@kernel.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Aaditya Kumar <aaditya.kumar.30@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Let me summary again.
>
> The problem:
>
> when hotplug offlining happens on zone A, it starts to freed page as MIGRATE_ISOLATE type in buddy.
> (MIGRATE_ISOLATE is very irony type because it's apparently on buddy but we can't allocate them)
> When the memory shortage happens during hotplug offlining, current task starts to reclaim, then wake up kswapd.
> Kswapd checks watermark, then go sleep BECAUSE current zone_watermark_ok_safe doesn't consider
> MIGRATE_ISOLATE freed page count. Current task continue to reclaim in direct reclaim path without kswapd's help.
> The problem is that zone->all_unreclaimable is set by only kswapd so that current task would be looping forever
> like below.
>
> __alloc_pages_slowpath
> restart:
>        wake_all_kswapd
> rebalance:
>        __alloc_pages_direct_reclaim
>                do_try_to_free_pages
>                        if global_reclaim && !all_unreclaimable
>                                return 1; /* It means we did did_some_progress */
>        skip __alloc_pages_may_oom
>        should_alloc_retry
>                goto rebalance;
>
> If we apply KOSAKI's patch[1] which doesn't depends on kswapd about setting zone->all_unreclaimable,
> we can solve this problem by killing some task. But it doesn't wake up kswapd, still.
> It could be a problem still if other subsystem needs GFP_ATOMIC request.
> So kswapd should consider MIGRATE_ISOLATE when it calculate free pages before going sleep.

I agree. And I believe we should remove rebalance label and alloc
retrying should always wake up kswapd.
because wake_all_kswapd is unreliable, it have no guarantee to success
to wake up kswapd. then this
micro optimization is NOT optimization. Just trouble source. Our
memory reclaim logic has a lot of race
by design. then any reclaim code shouldn't believe some one else works fine.



> Firstly I tried to solve this problem by this.
> https://lkml.org/lkml/2012/6/20/30
> The patch's goal was to NOT increase nr_free and NR_FREE_PAGES when we free page into MIGRATE_ISOLATED.
> But it increases little overhead in higher order free page but I think it's not a big deal.
> More problem is duplicated codes for handling only MIGRATE_ISOLATE freed page.
>
> Second approach which is suggested by KOSAKI is what you mentioned.
> But the concern about second approach is how to make sure matched count increase/decrease of nr_isolated_areas.
> I mean how to make sure nr_isolated_areas would be zero when isolation is done.
> Of course, we can investigate all of current caller and make sure they don't make mistake
> now. But it's very error-prone if we consider future's user.
> So we might need test_set_pageblock_migratetype(page, MIGRATE_ISOLATE);
>
> IMHO, ideal solution is that we remove MIGRATE_ISOLATE type totally in buddy.
> For it, there is no problem to isolate already freed page in buddy allocator but the concern is how to handle
> freed page later by do_migrate_range in memory_hotplug.c.
> We can create custom putback_lru_pages
>
> put_page_hotplug(page)
> {
>        int migratetype = get_pageblock_migratetype(page)
>        VM_BUG_ON(migratetype != MIGRATE_ISOLATE);
>        __page_cache_release(page);
>        free_one_page(zone, page, 0, MIGRATE_ISOLATE);
> }
>
> putback_lru_pages_hotplug(&source)
> {
>        foreach page from source
>                put_page_hotplug(page)
> }
>
> do_migrate_range()
> {
>        migrate_pages(&source);
>        putback_lru_pages_hotplug(&source);
> }
>
> I hope this summary can help you, Kame and If I miss something, please let me know it.

I disagree this. Because of, memory hotplug intentionally don't use
stopmachine. It is because
we don't stop any system service when memory is being unpluged. That's
said various subsystem
try to allocate memory during page migration for memory unplug. IOW,
we shouldn't do_migrate_page()
is only one caller.
