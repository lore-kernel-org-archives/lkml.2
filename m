Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab2FWEkP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:40:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60459 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab2FWEkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:40:13 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FE5482C.3010501@jp.fujitsu.com>
Date: Sat, 23 Jun 2012 13:38:04 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: undisclosed-recipients:";
	KOSAKI Motohiro" <kosaki.motohiro@gmail.com>,
        Aaditya Kumar <aaditya.kumar.30@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	undisclosed-recipients:;KOSAKI Motohiro <kosaki.motohiro@gmail.com>
						^-missing end of address
Subject: Re: Accounting problem of MIGRATE_ISOLATED freed page
References: <4FE169B1.7020600@kernel.org> <4FE16E80.9000306@gmail.com> <4FE18187.3050103@kernel.org> <4FE23069.5030702@gmail.com> <4FE26470.90401@kernel.org> <CAHGf_=pjoiHQ9vxXXe-GtbkYRzhxdDhu3pf6pwDsCe5pBQE8Nw@mail.gmail.com> <4FE27F15.8050102@kernel.org> <CAHGf_=pDw4axwG2tQ+B5hPks-sz2S5+G1Kk-=HSDmo=DSXOkEw@mail.gmail.com> <4FE2A937.6040701@kernel.org> <4FE2FCFB.4040808@jp.fujitsu.com> <4FE3C4E4.2050107@kernel.org> <4FE414A2.3000700@kernel.org>
In-Reply-To: <4FE414A2.3000700@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/22 15:45), Minchan Kim wrote:
> On 06/22/2012 10:05 AM, Minchan Kim wrote:
>
>> Second approach which is suggested by KOSAKI is what you mentioned.
>> But the concern about second approach is how to make sure matched count increase/decrease of nr_isolated_areas.
>> I mean how to make sure nr_isolated_areas would be zero when isolation is done.
>> Of course, we can investigate all of current caller and make sure they don't make mistake
>> now. But it's very error-prone if we consider future's user.
>> So we might need test_set_pageblock_migratetype(page, MIGRATE_ISOLATE);
>
>
> It's an implementation about above approach.
>

I like this approach.


> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index bf3404e..3e9a9e1 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -474,6 +474,11 @@ struct zone {
>           * rarely used fields:
>           */
>          const char              *name;
> +       /*
> +        * the number of MIGRATE_ISOLATE pageblock
> +        * We need this for accurate free page counting.
> +        */
> +       atomic_t                nr_migrate_isolate;
>   } ____cacheline_internodealigned_in_smp;

Isn't this counter modified only under zone->lock ?


>
>   typedef enum {
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2c29b1c..6cb1f9f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -219,6 +219,11 @@ EXPORT_SYMBOL(nr_online_nodes);
>
>   int page_group_by_mobility_disabled __read_mostly;
>
> +/*
> + * NOTE:
> + * Don't use set_pageblock_migratetype(page, MIGRATE_ISOLATE) direclty.
> + * Instead, use {un}set_pageblock_isolate.
> + */
>   void set_pageblock_migratetype(struct page *page, int migratetype)
>   {
>          if (unlikely(page_group_by_mobility_disabled))
> @@ -1622,6 +1627,28 @@ bool zone_watermark_ok(struct zone *z, int order, unsigned long mark,
>                                          zone_page_state(z, NR_FREE_PAGES));
>   }

I'm glad if this function can be static...Hm. With easy grep, I think it can be...

Thanks,
-Kame

