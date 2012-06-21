Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab2FURXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 13:23:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49591 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759957Ab2FURXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 13:23:00 -0400
MIME-Version: 1.0
In-Reply-To: <4FE2FCFB.4040808@jp.fujitsu.com>
References: <4FE169B1.7020600@kernel.org> <4FE16E80.9000306@gmail.com>
 <4FE18187.3050103@kernel.org> <4FE23069.5030702@gmail.com>
 <4FE26470.90401@kernel.org> <CAHGf_=pjoiHQ9vxXXe-GtbkYRzhxdDhu3pf6pwDsCe5pBQE8Nw@mail.gmail.com>
 <4FE27F15.8050102@kernel.org> <CAHGf_=pDw4axwG2tQ+B5hPks-sz2S5+G1Kk-=HSDmo=DSXOkEw@mail.gmail.com>
 <4FE2A937.6040701@kernel.org> <4FE2FCFB.4040808@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 21 Jun 2012 13:22:37 -0400
Message-ID: <CAHGf_=rZm8JhyQg_Fuovw3STR=bZBUpUvAXH2yYtNn0phjOU5g@mail.gmail.com>
Subject: Re: Accounting problem of MIGRATE_ISOLATED freed page
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Aaditya Kumar <aaditya.kumar.30@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Hm. I'm sorry if I couldn't chase the disucussion...Can I make summary ?
>
> As you shown, it seems to be not difficult to counting free pages under
> MIGRATE_ISOLATE.
> And we can know the zone contains MIGRATE_ISOLATE area or not by simple
> check.
> for example.
> ==
>                set_pageblock_migratetype(page, MIGRATE_ISOLATE);
>                move_freepages_block(zone, page, MIGRATE_ISOLATE);
>                zone->nr_isolated_areas++;
> =
>
> Then, the solution will be adding a function like following
> =
> u64 zone_nr_free_pages(struct zone *zone) {
>        unsigned long free_pages;
>
>        free_pages = zone_page_state(NR_FREE_PAGES);
>        if (unlikely(z->nr_isolated_areas)) {
>                isolated = count_migrate_isolated_pages(zone);
>                free_pages -= isolated;
>        }
>        return free_pages;
> }
> =
>
> Right ?

This represent my intention exactly. :)

> and... zone->all_unreclaimable is a different problem ?

Yes, all_unreclaimable derived livelock don't depend on memory hotplug.
