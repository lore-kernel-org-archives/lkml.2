Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab0KRTJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:09:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab0KRTJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:09:16 -0500
Date: Thu, 18 Nov 2010 20:08:39 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] mm: compaction: Perform a faster scan in
 try_to_compact_pages()
Message-ID: <20101118190839.GF30376@random.random>
References: <1290010969-26721-1-git-send-email-mel@csn.ul.ie>
 <1290010969-26721-7-git-send-email-mel@csn.ul.ie>
 <20101118183448.GC30376@random.random>
 <20101118185046.GQ8135@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118185046.GQ8135@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 06:50:46PM +0000, Mel Gorman wrote:
> For THP in general, I think we can abuse __GFP_NO_KSWAPD. For other callers,
> I'm not sure it's fair to push the responsibility of async/sync to them. We
> don't do it for reclaim for example and I'd worry the wrong decisions would
> be made or that they'd always select async for "performance" and then bitch
> about an allocation failure.

Ok, let's leave the __GFP and let's stick to the simplest for now
without alloc_pages caller knowledge.

> My only whinge about the lack of reclaimcompact_zone_order is that it
> makes it harder to even contemplate lumpy compaction in the future but
> it could always be reintroduced if absolutely necessary.

Ok. I don't know the plan of lumpy compaction and that's probably why
I didn't appreciate it...

So my preference as usual would be to remove lumpy. BTW, everything up
to patch 3 included should work fine with THP and solve my problem
with lumpy, thanks!

> GFP flags would be my last preference. 

yep. I'm just probably too paranoid at being lowlatency in the
hugepage allocation because I know it's the only spot where THP may
actually introduce a regression for short lived tasks if we do too
much work to create the hugepage. OTOH even for short lived allocation
on my westmire a bzero(1g) runs 250% (not 50% faster like in the older
hardware I was using) faster just thanks to the page being huge and
I'm talking about super short lived allocation here (the troublesome
one if we spend too much time in compaction and reclaim before
failing). Plus it only makes a difference when hugepages are so spread
across the whole system and it's still doing purely short lived
allocations. So again let's worry about the GFP flag later if
something... this is already an huge latency improvement (very
appreciated) compared to current upstream even without GPF flag ;)
like your .ps files show clearly.
