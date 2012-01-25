Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab2AYP4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 10:56:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab2AYP4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 10:56:08 -0500
Message-ID: <4F2025D9.9050409@redhat.com>
Date: Wed, 25 Jan 2012 10:55:05 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH v2 -mm 3/3] mm: only defer compaction for failed order
 and higher
References: <20120124131822.4dc03524@annuminas.surriel.com> <20120124132332.0c18d346@annuminas.surriel.com> <20120125154108.GD3901@csn.ul.ie>
In-Reply-To: <20120125154108.GD3901@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 10:41 AM, Mel Gorman wrote:

>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -673,9 +673,18 @@ static int __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
>>   		INIT_LIST_HEAD(&cc->freepages);
>>   		INIT_LIST_HEAD(&cc->migratepages);
>>
>> -		if (cc->order<  0 || !compaction_deferred(zone))
>> +		if (cc->order<  0 || !compaction_deferred(zone, cc->order))
>>   			compact_zone(zone, cc);
>>
>> +		if (cc->order>  0) {
>> +			int ok = zone_watermark_ok(zone, cc->order,
>> +						low_wmark_pages(zone), 0, 0);
>> +			if (ok&&  cc->order>  zone->compact_order_failed)
>> +				zone->compact_order_failed = cc->order + 1;
>> +			else if (!ok&&  cc->sync)
>> +				defer_compaction(zone, cc->order);
>> +		}
>> +
>
> That needs a comment. I think what you're trying to do is reset
> compat_order_failed once compaction is successful.
>
> The "!ok&&  cc->sync" check may be broken. __compact_pgdat() is
> called from kswapd, not direct compaction so cc->sync will not be true.

The problem with doing that is that we would be deferring
synchronous compaction (by allocators), just because
asynchronous compaction from kswapd failed...

That is the reason the code is like it is above.  And
indeed, it will not defer compaction from this code path
right now.

Then again, neither does async compaction from page
allocators defer compaction - only sync compaction does.

If it turns out we need a separate compaction deferral
for async compaction, we can always introduce that later,
and this code will be ready for it.

If you prefer, I can replace the whole "else if" bit with
a big fat comment explaining why we cannot currently
defer compaction from this point.
