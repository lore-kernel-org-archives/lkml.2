Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab2FYAOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 20:14:44 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63988 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2FYAOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 20:14:43 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-17-4fe7ad6ffbfb
Message-ID: <4FE7AD8A.2080508@kernel.org>
Date: Mon, 25 Jun 2012 09:15:06 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: John Stultz <john.stultz@linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Pekka Enberg <penberg@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Hugh Dickins <hughd@google.com>
Subject: Re: RFC:  Easy-Reclaimable LRU list
References: <4FE012CD.6010605@kernel.org> <4FE37434.808@linaro.org> <4FE41752.8050305@kernel.org> <4FE549E8.2050905@jp.fujitsu.com>
In-Reply-To: <4FE549E8.2050905@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kame,

On 06/23/2012 01:45 PM, Kamezawa Hiroyuki wrote:

> (2012/06/22 15:57), Minchan Kim wrote:
>> Hi John,
>>
>> On 06/22/2012 04:21 AM, John Stultz wrote:
>>
>>> On 06/18/2012 10:49 PM, Minchan Kim wrote:
>>>> Hi everybody!
>>>>
>>>> Recently, there are some efforts to handle system memory pressure.
>>>>
>>>> 1) low memory notification - [1]
>>>> 2) fallocate(VOLATILE) - [2]
>>>> 3) fadvise(NOREUSE) - [3]
>>>>
>>>> For them, I would like to add new LRU list, aka "Ereclaimable" which
>>>> is opposite of "unevictable".
>>>> Reclaimable LRU list includes _easy_ reclaimable pages.
>>>> For example, easy reclaimable pages are following as.
>>>>
>>>> 1. invalidated but remained LRU list.
>>>> 2. pageout pages for reclaim(PG_reclaim pages)
>>>> 3. fadvise(NOREUSE)
>>>> 4. fallocate(VOLATILE)
>>>>
>>>> Their pages shouldn't stir normal LRU list and compaction might not
>>>> migrate them, even.
>>>> Reclaimer can reclaim Ereclaimable pages before normal lru list and
>>>> will avoid unnecessary
>>>> swapout in anon pages in easy-reclaimable LRU list.
>>>
>>> I was hoping there would be further comment on this by more core VM
>>> devs, but so far things have been quiet (is everyone on vacation?).
>>
>>
>> At least, there are no dissent comment until now.
>> Let be a positive. :)
> 
> I think this is interesting approach. Major concern is how to guarantee
> EReclaimable
> pages are really EReclaimable...Do you have any idea ? madviced pages
> are really
> EReclaimable ?


I would like to select just discardable pages.

1. unmapped file page 
2. PG_reclaimed page - (that pages would have no mapped and a candidate 
   for reclaim ASAP)
3. fallocate(VOLATILE) - (We can just discard them without swapout)
4. madvise(MADV_DONTNEED)/fadvise(NOREUSE) -
   (It could be difficult than (1,2,3) but it's very likely to reclaim easily than others.

> 
> A (very) small concern is will you use one more page-flags for this ? ;)


Maybe and it could be a serious problem on 32 bit machine.
I didn't dive into that but I guess we can reuse PG_reclaim bit.
PG_reclaim is always used by with !PageActive and Ereclaimable LRU list doesn't have 
active LRU list. so we can change following as

- #define PG_reclaim
+ #define PG_Ereclaim

SetPageReclaim(page)
{
	page->flags |= (PG_Ereclaim|PG_active);
}

TestPageReclaim(page)
{
	if (((page->flags && PG_Ereclaim|PG_active)) == (PG_Ereclaim|PG_active)) 
		return true;
	return false;
}

SetPageEreclaim(page)
{
	page->flags |= PG_Ereclaim;
}

Thanks for the comment, Kame.
-- 
Kind regards,
Minchan Kim
