Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab1BWFeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:34:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:3276 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab1BWFeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:34:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,210,1297065600"; 
   d="scan'208";a="712084500"
Message-ID: <4D649C44.80107@linux.intel.com>
Date: Tue, 22 Feb 2011 21:33:56 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        richard.purdie@linuxfoundation.org
Subject: Re: [PATCH 1/2] sched: allow SCHED_BATCH to preempt SCHED_IDLE tasks
References: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>	 <1298408674-3130-2-git-send-email-dvhart@linux.intel.com> <1298434854.7856.24.camel@marge.simson.net>
In-Reply-To: <1298434854.7856.24.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 08:20 PM, Mike Galbraith wrote:
> On Tue, 2011-02-22 at 13:04 -0800, Darren Hart wrote:
>> Perform the test for SCHED_IDLE before testing for SCHED_BATCH (and ensure idle
>> tasks don't preempt idle tasks) so the non-interactive, but still important,
>> SCHED_BATCH tasks will run in favor of the very low priority SCHED_IDLE tasks.
>
> Yeah, that could be construed as a fairness fix for light SCHED_BATCH vs
> a heavy SCHED_IDLE.  It should lower latencies for both when mixed.
>
> Acked-by: Mike Galbraith<efault@gmx.de>
>
> Nit below.
>
>> Signed-off-by: Darren Hart<dvhart@linux.intel.com>
>> CC: Peter Zijlstra<peterz@infradead.org>
>> CC: Ingo Molnar<mingo@elte.hu>
>> CC: Richard Purdie<richard.purdie@linuxfoundation.org>
>> ---
>>   kernel/sched_fair.c |   12 +++++++-----
>>   1 files changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index 0c26e2d..ff04bbd 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -1857,16 +1857,18 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
>>   	if (test_tsk_need_resched(curr))
>>   		return;
>>
>> +	/* Idle tasks are by definition preempted by non-idle tasks. */
>> +	if (unlikely(curr->policy == SCHED_IDLE)&&
>> +	    likely(p->policy != SCHED_IDLE))
>> +		goto preempt;
>> +
>
> if (unlikely(curr->policy == SCHED_IDLE&&  p->policy != curr->policy))
> 	goto preempt;
>
> Looks better to me.

I have no opinion on the unlikely/likely optimizations. I chose the way 
I did as I thought it was more consistent with the existing code. I'll 
leave that to Peter and Ingo - let me know if I should resend.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
