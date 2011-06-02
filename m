Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab1FBWEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 18:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab1FBWE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 18:04:28 -0400
Date: Fri, 3 Jun 2011 00:03:56 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Mel Gorman <mel@csn.ul.ie>,
        akpm@linux-foundation.org, Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110602220356.GG2802@random.random>
References: <20110530175334.GI19505@random.random>
 <20110531121620.GA3490@barrios-laptop>
 <20110531122437.GJ19505@random.random>
 <20110531133340.GB3490@barrios-laptop>
 <20110531141402.GK19505@random.random>
 <20110531143734.GB13418@barrios-laptop>
 <20110531143830.GC13418@barrios-laptop>
 <20110602182302.GA2802@random.random>
 <20110602202156.GA23486@barrios-laptop>
 <20110602205912.GA24579@barrios-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602205912.GA24579@barrios-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 05:59:13AM +0900, Minchan Kim wrote:
> Now that I look code more, it would meet VM_BUG_ON of get_page if the page is really
> freed. I think if we hold zone->lock to prevent prep_new_page racing, it would be okay.

There would be problems with split_huge_page too, we can't even use
get_page_unless_zero unless it's a lru page and we hold the lru_lock
and that's an hot lock too.

> But it's rather overkill so I will add my sign to your patch if we don't have better idea
> until tomorrow. :)

Things like compound_trans_head are made to protect against
split_huge_page like in ksm, not exactly to get to the head page when
the page is being freed, so it's a little tricky. If we could get to
the head page safe starting from a tail page it'd solve some issues
for memory-failure too, which is currently using compound_head unsafe
too, but at least that's running after a catastrophic hardware failure
so the safer the better but the little race is unlikely to ever be an
issue for memory-failure (and it's same issue for hugetlbfs and slub
order 3).
