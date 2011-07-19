Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab1GSWVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:21:25 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:25850 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1GSWVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:21:24 -0400
Message-ID: <4E26036E.1070903@hp.com>
Date: Tue, 19 Jul 2011 16:21:34 -0600
From: Terry Loftin <terry.loftin@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Bob Montgomery <bob.montgomery@hp.com>
Subject: Re: [PATCH 2/2] sched: Fix "divide error: 0000" in find_busiest_group
References: <4E25F009.1040309@hp.com> <1311110290.2617.3.camel@laptop>
In-Reply-To: <1311110290.2617.3.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/19/2011 03:18 PM, Peter Zijlstra wrote:
> On Tue, 2011-07-19 at 14:58 -0600, Terry Loftin wrote:
>> Add a check to sched_avg_update() to detect and reset age_stamp if the
>> clock value has wrapped.  Because __cycles_2_ns() includes an offset
>> to account for start up time, the clock may not wrap to zero, so use
>> the current clock value instead.
> 
> So you're running on a platform (unspecified) where we use a raw
> sched_clock() that is buggy. Again, you're fixing symptoms not causes. 
> 
This x86_64.  This is the actual cause, unless the rq->clock
value should never roll, in which case, the clock roll is the
actual cause and you can disregard these patches.

-T
>> Signed-off-by: Terry Loftin <terry.loftin@hp.com>
>> Signed-off-by: Bob Montgomery <bob.montgomery@hp.com>
>> ---
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 18d38e4..b39cae1 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -1256,6 +1256,8 @@ static void sched_avg_update(struct rq *rq)
>>  {
>>  	s64 period = sched_avg_period();
>>
>> +	if (unlikely(rq->age_stamp > rq->clock))
>> +		rq->age_stamp = rq->clock;
>>  	while ((s64)(rq->clock - rq->age_stamp) > period) {
>>  		/*
>>  		 * Inline assembly required to prevent the compiler
> 
> 
> 
