Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab0KWIBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:01:18 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37166 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab0KWIBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:01:17 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC 1/2] deactive invalidated pages
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
In-Reply-To: <AANLkTinZmv540r+EkjwUu6cd9c1u7qG9iR+pvp3YqZC1@mail.gmail.com>
References: <20101122143817.E242.A69D9226@jp.fujitsu.com> <AANLkTinZmv540r+EkjwUu6cd9c1u7qG9iR+pvp3YqZC1@mail.gmail.com>
Message-Id: <20101123165240.7BC2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 17:01:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi KOSAKI,
> 
> 2010/11/23 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> >> By Other approach, app developer uses POSIX_FADV_DONTNEED.
> >> But it has a problem. If kernel meets page is writing
> >> during invalidate_mapping_pages, it can't work.
> >> It is very hard for application programmer to use it.
> >> Because they always have to sync data before calling
> >> fadivse(..POSIX_FADV_DONTNEED) to make sure the pages could
> >> be discardable. At last, they can't use deferred write of kernel
> >> so that they could see performance loss.
> >> (http://insights.oetiker.ch/linux/fadvise.html)
> >
> > If rsync use the above url patch, we don't need your patch.
> > fdatasync() + POSIX_FADV_DONTNEED should work fine.
> 
> It works well. But it needs always fdatasync before calling fadvise.
> For small file, it hurt performance since we can't use the deferred write.

I doubt rsync need to call fdatasync. Why?

If rsync continue to do following loop, some POSIX_FADV_DONTNEED
may not drop some dirty pages. But they can be dropped at next loop's
POSIX_FADV_DONTNEED. Then, It doesn't make serious issue.

1) read
2) write
3) POSIX_FADV_DONTNEED
4) goto 1


Am I missing anything?


> > So, I think the core worth of previous PeterZ's patch is in readahead
> > based heuristics. I'm curious why you drop it.
> >
> 
> In previous peter's patch, it couldn't move active page into inactive list.
> So it's not what i want and I think invalidation is stronger hint than
> the readahead heuristic.
> But if we need it, I will add it in my series. It can help reclaiming
> unnecessary inactive page asap.
> but before that, I hope we make sure fadvise works well enough.

I've got it.Yeah, 1) implement manual  oepration 2) add automatic heuristic 
is right order. I think. we can easily test your one.



> >> In fact, invalidate is very big hint to reclaimer.
> >> It means we don't use the page any more. So let's move
> >> the writing page into inactive list's head.
> >
> > But, I agree this.
> 
> Thank you.
>
> >> +static void __pagevec_lru_deactive(struct pagevec *pvec)
> >> +{
> >> +     int i, lru, file;
> >> +
> >> +     struct zone *zone = NULL;
> >> +
> >> +     for (i = 0; i < pagevec_count(pvec); i++) {
> >> +             struct page *page = pvec->pages[i];
> >> +             struct zone *pagezone = page_zone(page);
> >> +
> >> +             if (pagezone != zone) {
> >> +                     if (zone)
> >> +                             spin_unlock_irq(&zone->lru_lock);
> >> +                     zone = pagezone;
> >> +                     spin_lock_irq(&zone->lru_lock);
> >> +             }
> >> +
> >> +             if (PageLRU(page)) {
> >> +                     if (PageActive(page)) {
> >> +                             file = page_is_file_cache(page);
> >> +                             lru = page_lru_base_type(page);
> >> +                             del_page_from_lru_list(zone, page,
> >> +                                             lru + LRU_ACTIVE);
> >> +                             ClearPageActive(page);
> >> +                             ClearPageReferenced(page);
> >> +                             add_page_to_lru_list(zone, page, lru);
> >> +                             __count_vm_event(PGDEACTIVATE);
> >> +
> >> +                             update_page_reclaim_stat(zone, page, file, 0);
> >
> > When PageActive is unset, we need to change cgroup lru too.
> 
> Doesn't add_page_to_lru_list/del_page_from_lru_list do it?

Grr, my fault. I've forgot to we changed add_page_to_lru_list. 



