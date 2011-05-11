Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab1EKAOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 20:14:50 -0400
Received: from smtp-out.google.com ([74.125.121.67]:16980 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1EKAOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 20:14:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ocPyap6Smmz6c2grUcBFvUIp6eBMNtVCDrDO/tJYzM0KpTutxExoJYZxSb++jTBKKI
         ySW/xB8xyCEWXKV8UqpQ==
MIME-Version: 1.0
In-Reply-To: <20110506065959.GB23166@elte.hu>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
 <20110502061411.GA16682@elte.hu> <BANLkTiktch2mHDLXZCdCED3XoqmkVRfghA@mail.gmail.com>
 <20110504111355.GC5914@elte.hu> <BANLkTi=rnOZb-E35SC5B9Xb3SXMwFZi=Fg@mail.gmail.com>
 <20110506065959.GB23166@elte.hu>
From: Nikhil Rao <ncrao@google.com>
Date: Tue, 10 May 2011 17:14:25 -0700
Message-ID: <BANLkTimevJFjvoDSE2q0bu6gQaajmaZATw@mail.gmail.com>
Subject: Re: [PATCH v1 00/19] Increase resolution of load weights
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 5, 2011 at 11:59 PM, Ingo Molnar <mingo@elte.hu> wrote:
> * Nikhil Rao <ncrao@google.com> wrote:
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index f4b4679..3dae6c5 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -293,7 +293,7 @@ static DEFINE_SPINLOCK(task_group_lock);
>>   *  limitation from this.)
>>   */
>>  #define MIN_SHARES   2
>> -#define MAX_SHARES   (1UL << 18)
>> +#define MAX_SHARES   (1UL << (18 + SCHED_LOAD_RESOLUTION))
>>
>>  static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
>>  #endif
>> @@ -1307,14 +1307,18 @@ calc_delta_mine(unsigned long delta_exec, u64
>> weight, struct load_weight *lw)
>>       u64 tmp;
>>
>>       if (!lw->inv_weight) {
>> -             if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
>> +             unsigned long w = scale_down_load_resolution(lw->weight);
>> +             if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
>>                       lw->inv_weight = 1;
>>               else
>> -                     lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)
>> -                             / (lw->weight+1);
>> +                     lw->inv_weight = 1 + (WMULT_CONST - w/2) / (w + 1);
>>       }
>>
>> -     tmp = (u64)delta_exec * weight;
>> +     if (likely(weight > (1UL << SCHED_LOAD_RESOLUTION)))
>> +             tmp = (u64)delta_exec * scale_down_load_resolution(weight);
>> +     else
>> +             tmp = (u64)delta_exec;
>
> Couldnt the compiler figure out that on 32-bit, this:
>
>> +             tmp = (u64)delta_exec * scale_down_load_resolution(weight);
>
> is equivalent to:
>
>> +             tmp = (u64)delta_exec;
>
> ?
>
> I.e. it would be nice to check whether a reasonably recent version of GCC
> figures out this optimization by itself - in that case we can avoid the
> branching ugliness, right?
>

We added the branch to take care of the case when weight < 1024 (i..e
2^SCHED_LOAD_RESOLUTION). We downshift the weight by 10 bits so that
we do not lose accuracy/performance in calc_delta_mine(), and try to
keep the mult within 64-bits. Task groups with low shares values can
have sched entities with weight less than 1024 since MIN_SHARES is
still 2 (we don't scale that up). To prevent scaling down weight to 0,
we add this check and force a lower bound of 1.

I think we need the branch for 64-bit kernels. I don't like the branch
but I can't think of a better way to avoid it. Do you have any
suggestion?

For 32-bit systems, the compiler should ideally optimize this branch
away. Unfortunately gcc-4.4.3 doesn't do that (and I'm not sure if a
later version does it either). We could add a macro around this check
to avoid the branch for 32-bit and do the check for 64-bit kernels?

> Also, the above (and the other scale-adjustment changes) probably explains why
> the instruction count went up on 64-bit.

Yes, that makes sense. We see an increase in instruction count of
about 2% with the new version of the patchset, down from 5.8% (will
post the new patchset soon). Assuming 30% of the cost of pipe test is
scheduling, that is an effective increase of approx. 6.7%. I'll post
the data and some analysis along with the new version.

>
>> @@ -1758,12 +1762,13 @@ static void set_load_weight(struct task_struct *p)
>>        * SCHED_IDLE tasks get minimal weight:
>>        */
>>       if (p->policy == SCHED_IDLE) {
>> -             p->se.load.weight = WEIGHT_IDLEPRIO;
>> +             p->se.load.weight = scale_up_load_resolution(WEIGHT_IDLEPRIO);
>>               p->se.load.inv_weight = WMULT_IDLEPRIO;
>>               return;
>>       }
>>
>> -     p->se.load.weight = prio_to_weight[p->static_prio - MAX_RT_PRIO];
>> +     p->se.load.weight = scale_up_load_resolution(
>> +                     prio_to_weight[p->static_prio - MAX_RT_PRIO]);
>>       p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
>
> Please create a local 'load' variable that is equal to &p->se.load, and also
> create a 'prio = p->static_prio - MAX_RT_PRIO' variable.
>
> Furthermore, please rename 'scale_up_load_resolution' to something shorter:
> scale_load() is not used within the scheduler yet so it's free for taking.
>
> Then a lot of the above repetitious code could be written as a much nicer:
>
>        load->weight = scale_load(prio_to_weight[prio]);
>        load->inv_weight = prio_to_wmult[prio];
>
> ... and the logic becomes a *lot* more readable and the ugly linebreak is gone
> as well.
>
> Please make such a set_load_weight() cleanup patch separate from the main
> patch, so that your main patch can still be reviewed in separation.
>

Sure, will do.

-Thanks,
Nikhil
