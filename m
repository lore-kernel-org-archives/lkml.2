Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab2J2NTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:19:09 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:52327 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab2J2NTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:19:07 -0400
MIME-Version: 1.0
In-Reply-To: <5088076D.6080208@ti.com>
References: <1349595838-31274-1-git-send-email-vincent.guittot@linaro.org>
	<1349595838-31274-5-git-send-email-vincent.guittot@linaro.org>
	<5088076D.6080208@ti.com>
Date: Mon, 29 Oct 2012 14:18:42 +0100
Message-ID: <CAKfTPtBjbatruCrEqgHqeXnje4hyXWJRmG4Pp44ZtSZKXg7L1w@mail.gmail.com>
Subject: Re: [RFC 4/6] sched: secure access to other CPU statistics
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, peterz@infradead.org, mingo@redhat.com,
        pjt@google.com, linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 October 2012 17:21, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> $subject is bit confusing here.
>
>
> On Sunday 07 October 2012 01:13 PM, Vincent Guittot wrote:
>>
>> The atomic update of runnable_avg_sum and runnable_avg_period are ensured
>> by their size and the toolchain. But we must ensure to not read an old
>> value
>> for one field and a newly updated value for the other field. As we don't
>> want to lock other CPU while reading these fields, we read twice each
>> fields
>> and check that no change have occured in the middle.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>   kernel/sched/fair.c |   19 +++++++++++++++++--
>>   1 file changed, 17 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 8c9d3ed..6df53b5 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -3133,13 +3133,28 @@ static int select_idle_sibling(struct task_struct
>> *p, int target)
>>   static inline bool is_buddy_busy(int cpu)
>>   {
>>         struct rq *rq = cpu_rq(cpu);
>> +       volatile u32 *psum = &rq->avg.runnable_avg_sum;
>> +       volatile u32 *pperiod = &rq->avg.runnable_avg_period;
>> +       u32 sum, new_sum, period, new_period;
>> +       int timeout = 10;
>
> So it can be 2 times read or more as well.
>
>> +
>> +       while (timeout) {
>> +               sum = *psum;
>> +               period = *pperiod;
>> +               new_sum = *psum;
>> +               new_period = *pperiod;
>> +
>> +               if ((sum == new_sum) && (period == new_period))
>> +                       break;
>> +
>> +               timeout--;
>> +       }
>>
> Seems like you did notice incorrect pair getting read
> for rq runnable_avg_sum and runnable_avg_period. Seems
> like the fix is to update them together under some lock
> to avoid such issues.

My goal is to have a lock free mechanism because I don't want to lock
another CPU while reading its statistic

>
> Regards
> Santosh
>
