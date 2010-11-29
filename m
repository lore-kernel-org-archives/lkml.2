Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0K2CgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:36:04 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48011 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab0K2CgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:36:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH v2 1/3] deactivate invalidated pages
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <AANLkTikBvHn3Tc_RKTM8tGKjK1kgEZYsBCjXZSZ+Ri+-@mail.gmail.com>
References: <20101129090514.829C.A69D9226@jp.fujitsu.com> <AANLkTikBvHn3Tc_RKTM8tGKjK1kgEZYsBCjXZSZ+Ri+-@mail.gmail.com>
Message-Id: <20101129111900.82AB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 29 Nov 2010 11:35:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > I don't like this change because fadvise(DONT_NEED) is rarely used
> > function and this PG_reclaim trick doesn't improve so much. In the
> > other hand, It increase VM state mess.
> 
> Chick-egg problem.
> Why fadvise(DONT_NEED) is rarely used is it's hard to use effective.
> mincore + fdatasync + fadvise series is very ugly.
> This patch's goal is to solve it.

Well, I haven't put opposition to your previous patch for this reason.
I think every one have agree mincore + fdatasync + fadvise mess is ugly.

However I doubt PG_reclaim trick is so effective. I mean, _if_ it's effective, our current
streaming io heristics doesn't work so effective. It's bad. and if so, we should fix
it generically. That's the reason why I prefer to use simple add_page_to_lru_list().

Please remember why do we made this one. rsync has special io access pattern
then our streaming io detection doesn't work so good. therefore we decided to
improve manual knob. But, why do we need to make completely different behavior
manual DONT_NEED suggestion and automatic DONT_NEED detection?

That's my point.


> PG_reclaim trick would prevent working set eviction.
> If you fadvise call and there are the invalidated page which are
> dirtying in middle of inactive LRU,
> reclaimer would evict working set of inactive LRU's tail even if we
> have a invalidated page in LRU.
> It's bad.
> 
> About VM state mess, PG_readahead already have done it.
> But I admit this patch could make it worse and that's why I Cced Wu Fengguang.
> 
> The problem it can make is readahead confusing and working set
> eviction after writeback.
> I can add ClearPageReclaim of mark_page_accessed for clear flag if the
> page is accessed during race.
> But I didn't add it in this version because I think it's very rare case.
> 
> I don't want to add new page flag due to this function or revert merge
> patch of (PG_readahead and PG_reclaim)
> 
> 
> >
> > However, I haven't found any fault and unworked reason in this patch.
> >
> Thanks for the good review, KOSAKI. :)
> 
> 
> -- 
> Kind regards,
> Minchan Kim



