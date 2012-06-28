Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2F1VZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 17:25:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab2F1VZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 17:25:01 -0400
Message-ID: <4FECCB89.2050400@redhat.com>
Date: Thu, 28 Jun 2012 17:24:25 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, jaschut@sandia.gov, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH -mm v2] mm: have order > 0 compaction start off where
 it left
References: <20120628135520.0c48b066@annuminas.surriel.com> <20120628135940.2c26ada9.akpm@linux-foundation.org>
In-Reply-To: <20120628135940.2c26ada9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 04:59 PM, Andrew Morton wrote:
> On Thu, 28 Jun 2012 13:55:20 -0400
> Rik van Riel<riel@redhat.com>  wrote:
>
>> Order>  0 compaction stops when enough free pages of the correct
>> page order have been coalesced. When doing subsequent higher order
>> allocations, it is possible for compaction to be invoked many times.
>>
>> However, the compaction code always starts out looking for things to
>> compact at the start of the zone, and for free pages to compact things
>> to at the end of the zone.
>>
>> This can cause quadratic behaviour, with isolate_freepages starting
>> at the end of the zone each time, even though previous invocations
>> of the compaction code already filled up all free memory on that end
>> of the zone.
>>
>> This can cause isolate_freepages to take enormous amounts of CPU
>> with certain workloads on larger memory systems.
>>
>> The obvious solution is to have isolate_freepages remember where
>> it left off last time, and continue at that point the next time
>> it gets invoked for an order>  0 compaction. This could cause
>> compaction to fail if cc->free_pfn and cc->migrate_pfn are close
>> together initially, in that case we restart from the end of the
>> zone and try once more.
>>
>> Forced full (order == -1) compactions are left alone.
>
> Is there a quality of service impact here?  Newly-compactable pages
> at lower pfns than compact_cached_free_pfn will now get missed, leading
> to a form of fragmentation?

The compaction side of the zone always starts at the
very beginning of the zone.  I believe we can get
away with this, because skipping a whole transparent
hugepage or non-movable block is 512 times faster than
scanning an entire block for target pages in
isolate_freepages.

>> @@ -463,6 +474,8 @@ static void isolate_freepages(struct zone *zone,
>>   		 */
>>   		if (isolated)
>>   			high_pfn = max(high_pfn, pfn);
>> +		if (cc->order>  0)
>> +			zone->compact_cached_free_pfn = high_pfn;
>
> Is high_pfn guaranteed to be aligned to pageblock_nr_pages here?  I
> assume so, if lots of code in other places is correct but it's
> unobvious from reading this function.

Reading the code a few more times, I believe that it is
indeed aligned to pageblock size.

>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -118,8 +118,10 @@ struct compact_control {
>>   	unsigned long nr_freepages;	/* Number of isolated free pages */
>>   	unsigned long nr_migratepages;	/* Number of pages to migrate */
>>   	unsigned long free_pfn;		/* isolate_freepages search base */
>> +	unsigned long start_free_pfn;	/* where we started the search */
>>   	unsigned long migrate_pfn;	/* isolate_migratepages search base */
>>   	bool sync;			/* Synchronous migration */
>> +	bool wrapped;			/* Last round for order>0 compaction */
>
> This comment is incomprehensible :(

Agreed.  I'm not sure how to properly describe that variable
in 30 or so characters :)

It denotes whether the current invocation of compaction,
called with order > 0, has had free_pfn and migrate_pfn
meet, resulting in free_pfn being reset to the top of
the zone.

Now, how to describe that briefly?

-- 
All rights reversed
