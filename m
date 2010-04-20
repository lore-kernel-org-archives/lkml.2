Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0DTIyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 04:54:45 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:41676 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab0DTIyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 04:54:43 -0400
Message-ID: <4BCD6BCB.4040403@linux.vnet.ibm.com>
Date: Tue, 20 Apr 2010 10:54:35 +0200
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       gregkh@novell.com, Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone pressure
References: <20100322235053.GD9590@csn.ul.ie> <4BA940E7.2030308@redhat.com> <20100324145028.GD2024@csn.ul.ie> <4BCC4B0C.8000602@linux.vnet.ibm.com> <20100419214412.GB5336@cmpxchg.org> <4BCD55DA.2020000@linux.vnet.ibm.com>
In-Reply-To: <4BCD55DA.2020000@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Christian Ehrhardt wrote:
> 
> 
> Johannes Weiner wrote:
[...]

>>>
>>> It stays at ~85M with more writes which is approx 50% of my free 160M 
>>> memory.
>>
>> Ok, so I am the idiot that got quoted on 'the active set is not too 
>> big, so
>> buffer heads are not a problem when avoiding to scan it' in eternal 
>> history.
>>
>> But the threshold inactive/active ratio for skipping active file pages is
>> actually 1:1.
>>
>> The easiest 'fix' is probably to change that ratio, 2:1 (or even 3:1?) 
>> appears
>> to be a bit more natural anyway?  Below is a patch that changes it to 
>> 2:1.
>> Christian, can you check if it fixes your regression?
> 
> I'll check it out.
> from the numbers I have up to now I know that the good->bad transition 
> for my case is somewhere between 30M/60M e.g. first and second write.
> The ratio 2:1 will eat max 53M of my ~160M that gets split up.
> 
> That means setting the ratio to 2:1 or whatever else might help or not, 
> but eventually there is just another setting of workload vs. memory 
> constraints that would still be affected. Still I guess 3:1 (and I'll 
> try that as well) should be enough to be a bit more towards the save side.

For "my case" 2:1 is not enough, 3:1 almost and 4:1 fixes the issue.
Still as I mentioned before I think any value carved in stone can and 
will be bad to some use case - as 1:1 is for mine.

If we end up being unable to fix it internally by allowing the system to 
"forget" and eventually free old unused buffers at least somewhen - then 
we should neither implement it as 2:1 nor 3:1 nor whatsoever, but as 
userspace configurable e.g. /proc/sys/vm/active_inactive_ratio.

I hope your suggestion below or an extension to it will allow the kernel 
to free the buffers somewhen. Depending on how good/fast this solution 
then will work we can still modify the ratio if needed.

>> Additionally, we can always scan active file pages but only deactivate 
>> them
>> when the ratio is off and otherwise strip buffers of clean pages.
> 
> In think we need something that allows the system to forget its history 
> somewhen - be it 1:1 or x:1 - if the workload changes "long enough"(tm) 
> it should eventually throw all old things out.
> Like I described before many systems have different usage patterns when 
> e.g. comparing day/night workload. So it is far from optimal if e.g. day 
> write loads eat so much cache and never give it back for nightly huge 
> reads tasks or something similar.
> 
> Would your suggestion achieve that already?
> If not what kind change could?
> 
[...]
-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance
