Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2F2DAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 23:00:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52473 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab2F2DAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 23:00:44 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FED19D5.5070508@jp.fujitsu.com>
Date: Fri, 29 Jun 2012 11:58:29 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org, akpm@linux-foundation.org,
        minchan@kernel.org, linux-kernel@vger.kernel.org, jaschut@sandia.gov
Subject: Re: [PATCH -mm] mm: have order>0 compaction start off where it left
References: <20120627233742.53225fc7@annuminas.surriel.com> <20120628102919.GQ8103@csn.ul.ie> <4FEC86BA.9050004@redhat.com>
In-Reply-To: <4FEC86BA.9050004@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/29 1:30), Rik van Riel wrote:
> On 06/28/2012 06:29 AM, Mel Gorman wrote:
>
>> Lets say there are two parallel compactions running. Process A meets
>> the migration PFN and moves to the end of the zone to restart. Process B
>> finishes scanning mid-way through the zone and updates last_free_pfn. This
>> will cause Process A to "jump" to where Process B left off which is not
>> necessarily desirable.
>>
>> Another side effect is that a workload that allocations/frees
>> aggressively will not compact as well as the "free" scanner is not
>> scanning the end of the zone each time. It would be better if
>> last_free_pfn was updated when a full pageblock was encountered
>>
>> So;
>>
>> 1. Initialise last_free_pfn to the end of the zone
>> 2. On compaction, scan from last_free_pfn and record where it started
>> 3. If a pageblock is full, update last_free_pfn
>> 4. If the migration and free scanner meet, reset last_free_pfn and
>>     the free scanner. Abort if the free scanner wraps to where it started
>>
>> Does that make sense?
>
> Yes, that makes sense.  We still have to keep track
> of whether we have wrapped around, but I guess that
> allows for a better name for the bool :)
>
> Maybe cc->wrapped?
>
> Does anyone have a better name?
>

cc->second_scan ? (I have no sense of naming ;)

> As for point (4), should we abort when we wrap
> around to where we started, or should we abort
> when free_pfn and migrate_pfn meet after we
> wrapped around?
>

I'd like to vote for aborting earlier.

Regards,
-Kame

