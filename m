Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090Ab0KRSVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:21:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598Ab0KRSVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:21:46 -0500
Date: Thu, 18 Nov 2010 19:21:06 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] mm: migration: Allow migration to operate
 asynchronously and avoid synchronous compaction in the faster path
Message-ID: <20101118182105.GB30376@random.random>
References: <1290010969-26721-1-git-send-email-mel@csn.ul.ie>
 <1290010969-26721-5-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290010969-26721-5-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 04:22:45PM +0000, Mel Gorman wrote:
> @@ -484,6 +486,7 @@ static unsigned long compact_zone_order(struct zone *zone,
>  		.order = order,
>  		.migratetype = allocflags_to_migratetype(gfp_mask),
>  		.zone = zone,
> +		.sync = false,
>  	};
>  	INIT_LIST_HEAD(&cc.freepages);
>  	INIT_LIST_HEAD(&cc.migratepages);

I like this because I'm very afraid to avoid wait-I/O latencies
introduced into hugepage allocations that I prefer to fail quickly and
be handled later by khugepaged ;).

But I could have khugepaged call this with sync=true... so I'd need a
__GFP_ flag that only khugepaged would use to notify compaction should
be synchronous for khugepaged (not for the regular allocations in page
faults). Can we do this through gfp_mask only?

> @@ -500,6 +503,7 @@ unsigned long reclaimcompact_zone_order(struct zone *zone,
>  		.order = order,
>  		.migratetype = allocflags_to_migratetype(gfp_mask),
>  		.zone = zone,
> +		.sync = true,
>  	};
>  	INIT_LIST_HEAD(&cc.freepages);
>  	INIT_LIST_HEAD(&cc.migratepages);

Is this intentional? That inner compaction invocation is
equivalent to the one one interleaved with the shrinker tried before
invoking the shrinker. So I don't see why they should differ (one sync
and one async).

Anyway I'd prefer the inner invocation to be removed as a whole and to
keep only going with the interleaving and to keep the two jobs of
compaction and shrinking memory fully separated and to stick to the
interleaving. If this reclaimcompact_zone_order helps maybe it means
compact_zone_order isn't doing the right thing and we're hiding it by
randomly calling it more frequently...

I can see a point however in doing:

compaction async
shrink (may wait) (scan 500 pages, freed 32 pages)
compaction sync (may wait)

to:

compaction async
shrink (scan 32 pages, freed 0 pages)
compaction sync (hugepage generated nobody noticed)
shrink (scan 32 pages, freed 0 pages)
compaction sync
shrink (scan 32 pages, freed 0 pages)
[..]
