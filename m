Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435Ab2IMPw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:52:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758397Ab2IMPwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:52:55 -0400
Message-ID: <50520156.4010508@redhat.com>
Date: Thu, 13 Sep 2012 11:52:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Jim Schutt <jaschut@sandia.gov>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] mm: have order > 0 compaction start near a pageblock
 with free pages
References: <1344962492-1914-1-git-send-email-mgorman@suse.de> <1344962492-1914-5-git-send-email-mgorman@suse.de>
In-Reply-To: <1344962492-1914-5-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 12:41 PM, Mel Gorman wrote:
> commit [7db8889a: mm: have order > 0 compaction start off where it left]
> introduced a caching mechanism to reduce the amount work the free page
> scanner does in compaction. However, it has a problem. Consider two process
> simultaneously scanning free pages
>
> 				    			C
> Process A		M     S     			F
> 		|---------------------------------------|
> Process B		M 	FS
>
> C is zone->compact_cached_free_pfn
> S is cc->start_pfree_pfn
> M is cc->migrate_pfn
> F is cc->free_pfn

> There is not an obvious way around this problem without introducing new
> locking and state so this patch takes a different approach.

... actually, unless I am mistaken there may be a simple
approach to keep my "skip ahead" logic but make it proof
against the above scenario.

> First, it gets rid of the skip logic because it's not clear that it matters
> if two free scanners happen to be in the same block

It is not so much about being in the same block, as it is
about multiple invocations starting at the same block over
and over again.

> but with racing updates
> it's too easy for it to skip over blocks it should not.

If one thread stops compaction free page scanning in one
block, the next invocation will start by scanning that
block again, until it is exhausted.

We just need to make the code proof against the race you
described.

> @@ -475,17 +489,6 @@ static void isolate_freepages(struct zone *zone,
>   					pfn -= pageblock_nr_pages) {
>   		unsigned long isolated;
>
> -		/*
> -		 * Skip ahead if another thread is compacting in the area
> -		 * simultaneously. If we wrapped around, we can only skip
> -		 * ahead if zone->compact_cached_free_pfn also wrapped to
> -		 * above our starting point.
> -		 */
> -		if (cc->order > 0 && (!cc->wrapped ||
> -				      zone->compact_cached_free_pfn >
> -				      cc->start_free_pfn))
> -			pfn = min(pfn, zone->compact_cached_free_pfn);
> -
>   		if (!pfn_valid(pfn))
>   			continue;

I think the skipping logic should look something like this:

static bool compaction_may_skip(struct zone *zone,
                         struct compaction_control *cc)
{
	/* If we have not wrapped, we can only skip downwards. */
	if (!cc->wrapped && zone->compact_cached_free_pfn < cc->start_free_pfn)
		return true;

	/* If we have wrapped, we can skip ahead to our start point. */
	if (cc->wrapped && zone->compact_cached_free_pfn > cc->start_free_pfn)
		return true;

	return false;
}

		if (cc->order > 0 && compaction_may_skip(zone, cc))
			pfn = min(pfn, zone->compact_cached_free_pfn);


I believe that would close the hole you described, while
not re-introducing the quadratic "start at the same block
every invocation, until we wrap" behaviour.
