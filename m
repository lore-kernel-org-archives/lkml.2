Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab1IBCTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 22:19:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51177 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105Ab1IBCTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 22:19:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110831173031.GA21571@redhat.com>
References: <1321285043-3470-1-git-send-email-minchan.kim@gmail.com>
	<20110831173031.GA21571@redhat.com>
Date: Fri, 2 Sep 2011 11:19:49 +0900
Message-ID: <CAEwNFnDcNqLvo=oyXXkxgFxs8wNc+WTLwot0qeru1VfQKmUYDQ@mail.gmail.com>
Subject: Re: [PATCH] vmscan: Do reclaim stall in case of mlocked page.
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 2:30 AM, Johannes Weiner <jweiner@redhat.com> wrote:
> On Tue, Nov 15, 2011 at 12:37:23AM +0900, Minchan Kim wrote:
>> [1] made avoid unnecessary reclaim stall when second shrink_page_list(ie, synchronous
>> shrink_page_list) try to reclaim page_list which has not-dirty pages.
>> But it seems rather awkawrd on unevictable page.
>> The unevictable page in shrink_page_list would be moved into unevictable lru from page_list.
>> So it would be not on page_list when shrink_page_list returns.
>> Nevertheless it skips reclaim stall.
>>
>> This patch fixes it so that it can do reclaim stall in case of mixing mlocked pages
>> and writeback pages on page_list.
>>
>> [1] 7d3579e,vmscan: narrow the scenarios in whcih lumpy reclaim uses synchrounous reclaim
>
> Lumpy isolates physically contiguous in the hope to free a bunch of
> pages that can be merged to a bigger page.  If an unevictable page is
> encountered, the chance of that is gone.  Why invest the allocation
> latency when we know it won't pay off anymore?
>

Good point!

Except some cases, when we require higher orer page, we used zone
defensive algorithm by zone_watermark_ok. So the number of fewer
higher order pages would be factor of failure of allocation. If it was
problem, we could rescue the situation by only reclaim part of the
block in the hope to free fewer higher order pages.

I thought the lumpy was designed to consider the case.(I might be wrong).
Why I thought is that when we isolate the pages for lumpy and found
the page isn't able to isolate, we don't rollback the isolated pages
in the lumpy phsyical block. It's very pointless to get a higher order
pages.

If we consider that, we have to fix other reset_reclaim_mode cases as
well as mlocked pages.
Or
fix isolataion logic for the lumpy? (When we find the page isn't able
to isolate, rollback the pages in the lumpy block to the LRU)
Or
Nothing and wait to remove lumpy completely.

What do you think about it?

-- 
Kind regards,
Minchan Kim
