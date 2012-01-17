Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab2AQDFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 22:05:48 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:34159 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2AQDFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 22:05:47 -0500
Message-ID: <4F14E54E.80904@linux.vnet.ibm.com>
Date: Tue, 17 Jan 2012 11:04:46 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Xiaotian Feng <xtfeng@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sched: Accelerate "pick_next_entity" under special
 condition
References: <4F13EFBE.1030002@linux.vnet.ibm.com> <1326707503.2442.219.camel@twins>	<4F14DEAE.60702@linux.vnet.ibm.com> <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com>
In-Reply-To: <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011617-3568-0000-0000-00000110AC67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 10:58 AM, Xiaotian Feng wrote:

> On Tue, Jan 17, 2012 at 10:36 AM, Michael Wang
> <wangyun@linux.vnet.ibm.com> wrote:
>> From: wangyun <wangyun@linux.vnet.ibm.com>
>>
>> In original code, we get the next entity in this way:
>>
>>        if(condition1)
>>                result=value1;
>>        if(condition2)
>>                result=value2;
>>        if(condition3)
>>                result=value3;
>>        return result;
>>
>> So if condition3 is true, we will get value3, but still
>> need to check condition1 and condition2, this will waste
>> our time.
>>
>> This patch will change the way like:
>>
>>        if(condition3) {
>>                result=value3;
>>                goto out;
>>        }
>>        if(condition2) {
>>                result=value2;
>>                goto out;
>>        }
>>        if(condition1) {
>>                result=value1;
>>                goto out;
>>        }
>>
>>        out:
>>        return result;
>>
>> So we can avoid check condition2 and condition1 when
>> condition3 is true now.
> 
> Then what if condition 1 is true now?


Hi, Xiaotian

Thanks for your reply.

We can see in original code, even condition 1 is true, we
still will use value3 if condition3 is true, like this:

original:

condition1	condition3	result
true		true		value3
true		false		value1

That means if condition3 is true, we don't care whether
condition1 is true or not because we will finally use value3.

Regards,
Michael Wang

> 
>>
>> v2:
>>        1. do not use ugly macro any more.
>>        2. add more description.
>>
>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
>> ---
>>  kernel/sched/fair.c |   26 +++++++++++++++-----------
>>  1 files changed, 15 insertions(+), 11 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 84adb2d..e8a72b2 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -1308,29 +1308,33 @@ static struct sched_entity
>> *pick_next_entity(struct cfs_rq *cfs_rq)
>>        struct sched_entity *left = se;
>>
>>        /*
>> -        * Avoid running the skip buddy, if running something else can
>> -        * be done without getting too unfair.
>> +        * Someone really wants this to run. If it's not unfair, run it.
>>         */
>> -       if (cfs_rq->skip == se) {
>> -               struct sched_entity *second = __pick_next_entity(se);
>> -               if (second && wakeup_preempt_entity(second, left) < 1)
>> -                       se = second;
>> +       if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
>> +               se = cfs_rq->next;
>> +               goto out;
>>        }
>>
>>        /*
>>         * Prefer last buddy, try to return the CPU to a preempted task.
>>         */
>> -       if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
>> +       if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1) {
>>                se = cfs_rq->last;
>> +               goto out;
>> +       }
>>
>>        /*
>> -        * Someone really wants this to run. If it's not unfair, run it.
>> +        * Avoid running the skip buddy, if running something else can
>> +        * be done without getting too unfair.
>>         */
>> -       if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
>> -               se = cfs_rq->next;
>> +       if (cfs_rq->skip == se) {
>> +               struct sched_entity *second = __pick_next_entity(se);
>> +               if (second && wakeup_preempt_entity(second, left) < 1)
>> +                       se = second;
>> +       }
>>
>> +out:
>>        clear_buddies(cfs_rq, se);
>> -
>>        return se;
>>  }
>>
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 


