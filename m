Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab3AHHDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 02:03:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab3AHHDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 02:03:33 -0500
Message-ID: <50EBC4BD.7010700@redhat.com>
Date: Tue, 08 Jan 2013 02:03:25 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Shaohua Li <shli@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mingo@redhat.com, hughd@google.com
Subject: Re: [RFC]x86: clearing access bit don't flush tlb
References: <20130107081213.GA21779@kernel.org> <50EAE66B.1020804@redhat.com> <50EB4CB9.9010104@zytor.com> <20130108045519.GB2459@kernel.org> <50EBA8AB.2060003@zytor.com> <50EBA9DC.9070400@redhat.com> <50EBAA27.7030506@zytor.com>
In-Reply-To: <50EBAA27.7030506@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 12:09 AM, H. Peter Anvin wrote:
> On 01/07/2013 09:08 PM, Rik van Riel wrote:
>> On 01/08/2013 12:03 AM, H. Peter Anvin wrote:
>>> On 01/07/2013 08:55 PM, Shaohua Li wrote:
>>>>
>>>> I searched a little bit, the change (doing TLB flush to clear access
>>>> bit) is
>>>> made between 2.6.7 - 2.6.8, I can't find the changelog, but I found a
>>>> patch:
>>>> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.7-rc2/2.6.7-rc2-mm2/broken-out/mm-flush-tlb-when-clearing-young.patch
>>>>
>>>>
>>>> The changelog declaims this is for arm/ppc/ppc64.
>>>>
>>>
>>> Not really.  It says that those have stumbled over it already.  It is
>>> true in general that this change will make very frequently used pages
>>> (which stick in the TLB) candidates for eviction.
>>
>> That is only true if the pages were to stay in the TLB for a
>> very very long time.  Probably multiple seconds.
>>
>>> x86 would seem to be just as affected, although possibly with a
>>> different frequency.
>>>
>>> Do we have any actual metrics on anything here?
>>
>> I suspect that if we do need to force a TLB flush for page
>> reclaim purposes, it may make sense to do that TLB flush
>> asynchronously. For example, kswapd could kick off a TLB
>> flush of every CPU in the system once a second, when the
>> system is under pageout pressure.
>>
>> We would have to do this in a smart way, so the kswapds
>> from multiple nodes do not duplicate the work.
>>
>> If people want that kind of functionality, I would be
>> happy to cook up an RFC patch.
>>
>
> So it sounds like you're saying that this patch should never have been
> applied in the first place?

It made sense at the time.

However, with larger SMP systems, we may need a different
mechanism to get the TLB flushes done after we clear a bunch
of accessed bits.

One thing we could do is mark bits in a bitmap, keeping track
of which CPUs should have their TLB flushed due to accessed bit
scanning.

Then we could set a timer for eg. a 1 second timeout, after
which the TLB flush IPIs get sent. If the timer is already
pending, we do not start it, but piggyback on the invocation
that is already scheduled to happen.

Does something like that make sense?

-- 
All rights reversed
