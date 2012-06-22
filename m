Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345Ab2FVG5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 02:57:10 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61574 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760678Ab2FVG5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 02:57:09 -0400
X-AuditID: 9c930197-b7b87ae000000e4d-cc-4fe41740ebdc
Message-ID: <4FE41752.8050305@kernel.org>
Date: Fri, 22 Jun 2012 15:57:22 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.mm
To: John Stultz <john.stultz@linaro.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Pekka Enberg <penberg@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Hugh Dickins <hughd@google.com>
Subject: Re: RFC:  Easy-Reclaimable LRU list
References: <4FE012CD.6010605@kernel.org> <4FE37434.808@linaro.org>
In-Reply-To: <4FE37434.808@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On 06/22/2012 04:21 AM, John Stultz wrote:

> On 06/18/2012 10:49 PM, Minchan Kim wrote:
>> Hi everybody!
>>
>> Recently, there are some efforts to handle system memory pressure.
>>
>> 1) low memory notification - [1]
>> 2) fallocate(VOLATILE) - [2]
>> 3) fadvise(NOREUSE) - [3]
>>
>> For them, I would like to add new LRU list, aka "Ereclaimable" which
>> is opposite of "unevictable".
>> Reclaimable LRU list includes _easy_ reclaimable pages.
>> For example, easy reclaimable pages are following as.
>>
>> 1. invalidated but remained LRU list.
>> 2. pageout pages for reclaim(PG_reclaim pages)
>> 3. fadvise(NOREUSE)
>> 4. fallocate(VOLATILE)
>>
>> Their pages shouldn't stir normal LRU list and compaction might not
>> migrate them, even.
>> Reclaimer can reclaim Ereclaimable pages before normal lru list and
>> will avoid unnecessary
>> swapout in anon pages in easy-reclaimable LRU list.
> 
> I was hoping there would be further comment on this by more core VM
> devs, but so far things have been quiet (is everyone on vacation?).


At least, there are no dissent comment until now.
Let be a positive. :)

> 
> Overall this seems reasonable for the volatile ranges functionality. 
> The one down-side being that dealing with the ranges on a per-page basis
> can make marking and unmarking larger ranges as volatile fairly
> expensive. In my tests with my last patchset, it was over 75x slower
> (~1.5ms) marking and umarking a 1meg range when we deactivate and
> activate all of the pages, instead of just inserting the volatile range
> into an interval tree and purge via the shrinker (~20us).  Granted, my
> initial approach is somewhat naive, and some pagevec batching has
> improved things three-fold (down to ~500us) , but I'm still ~25x slower
> when iterating over all the pages.
> 
> There's surely further improvements to be made, but this added cost
> worries me, as users are unlikely to generously volunteer up memory to
> the kernel as volatile if doing so frequently adds significant overhead.
> 
> This makes me wonder if having something like an early-shrinker which
> gets called prior to shrinking the lrus might be a better approach for
> volatile ranges. It would still be numa-unaware, but would keep the
> overhead very light to both volatile users and non users.


How about doing it in background?
In your process context, you can schedule your work to workqueue and when work is executed,
you can move the pages into lru list you want.
Just an idea.

> 
> Even so, I'd be interested in seeing more about your approach, in the
> hopes that it might not be as costly as my initial attempt. Do you have
> any plans to start prototyping this?


I will wait response a few day and if anyone doesn't raise critical problems, will start.
But please keep in mind.I guess it's never trivial so you shouldn't depend on my schedule.
Thanks.

> 
> thanks
> -john
> 



-- 
Kind regards,
Minchan Kim
