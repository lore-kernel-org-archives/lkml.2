Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2AZCNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 21:13:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab2AZCNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 21:13:06 -0500
Message-ID: <4F20B692.4080906@redhat.com>
Date: Wed, 25 Jan 2012 21:12:34 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        lkml <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH v2 -mm 1/3] mm: reclaim at order 0 when compaction is
 enabled
References: <20120124131822.4dc03524@annuminas.surriel.com> <20120124132136.3b765f0c@annuminas.surriel.com> <20120125150016.GB3901@csn.ul.ie> <4F201F60.8080808@redhat.com> <20120125221632.GL30782@redhat.com>
In-Reply-To: <20120125221632.GL30782@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 05:16 PM, Andrea Arcangeli wrote:
> On Wed, Jan 25, 2012 at 10:27:28AM -0500, Rik van Riel wrote:
>> On 01/25/2012 10:00 AM, Mel Gorman wrote:
>>> On Tue, Jan 24, 2012 at 01:21:36PM -0500, Rik van Riel wrote:
>>>> When built with CONFIG_COMPACTION, kswapd does not try to free
>>>> contiguous pages.
>>>
>>> balance_pgdat() gets its order from wakeup_kswapd(). This does not apply
>>> to THP because kswapd does not get woken for THP but it should be woken
>>> up for allocations like jumbo frames or order-1.
>>
>> In the kernel I run at home, I wake up kswapd for THP
>> as well. This is a larger change, which Andrea asked
>> me to delay submitting upstream for a bit.
>>
>> So far there seem to be no ill effects. I'll continue
>> watching for them.
>
> The only problem we had last time when we managed to add compaction in
> kswapd upstream, was a problem of that too high kswapd wakeup
> frequency that kept kswapd spinning at 100% load and destroying
> specsfs performance. It may have been a fundamental problem of
> compaction not being worthwhile to run to generate jumbo frames
> because the cost of migrating memory, copying, flushing ptes

I suspect the problem was much simpler back then.  Kswapd
invoked compaction inside the loop, instead of outside the
loop, and there was no throttling at all.

> About THP, it may not give problems for THP because the allocation
> rate is much slower.

> I'm still quite afraid that compaction in kswapd waken by jumbo frames
> may not work well,

THP allocations may be slower, but jumbo frames get freed
again quickly. We do not have to compact memory for every
few jumbo frame allocations, only when the number of packets
in flight is going up...

You are right that it should be tested, though :)

I will look into that.

-- 
All rights reversed
