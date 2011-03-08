Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab1CHCdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 21:33:07 -0500
Received: from smtp-out.google.com ([74.125.121.67]:56598 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab1CHCdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 21:33:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xd8Oe7B+w46aUlQQYDZ136KYH7YOcKvocK7qnqCY4bYsK3Y0ElINx5XZjo2iMF5jJf
         y1nrhHCrxaTy7mMKdkEA==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=dSdnn0p8973C5-URTLbTkJ2XROV9XePrQezJ3@mail.gmail.com>
References: <AANLkTi=hy8mHp=RLkKbfc2nw0VGX65ZCmk89r3U-rb4-@mail.gmail.com>
	<1299545997-26304-1-git-send-email-venki@google.com>
	<AANLkTi=dSdnn0p8973C5-URTLbTkJ2XROV9XePrQezJ3@mail.gmail.com>
Date: Mon, 7 Mar 2011 18:33:00 -0800
Message-ID: <AANLkTikrU6Bfnh8xq-AwAAReQjPhQ7TE=4gC=Th=252Y@mail.gmail.com>
Subject: Re: [PATCH] sched: next buddy hint on sleep and preempt path - v1
From: Venkatesh Pallipadi <venki@google.com>
To: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 5:29 PM, Paul Turner <pjt@google.com> wrote:
> On Mon, Mar 7, 2011 at 4:59 PM, Venkatesh Pallipadi <venki@google.com> wrote:
>> When a task in a taskgroup sleeps, pick_next_task starts all the way back at
>> the root and picks the task/taskgroup with the min vruntime across all
>> runnable tasks. But, when there are many frequently sleeping tasks
>> across different taskgroups, it makes better sense to stay with same taskgroup
>> for its slice period (or until all tasks in the taskgroup sleeps) instead of
>> switching cross taskgroup on each sleep after a short runtime.
>> This helps specifically where taskgroups corresponds to a process with
>> multiple threads. The change reduces the number of CR3 switches in this case.
>>
>> Example:
>> Two taskgroups with 2 threads each which are running for 2ms and
>> sleeping for 1ms. Looking at sched:sched_switch shows -
>>
>> BEFORE: taskgroup_1 threads [5004, 5005], taskgroup_2 threads [5016, 5017]
>>      cpu-soaker-5004  [003]  3683.391089
>>      cpu-soaker-5016  [003]  3683.393106
>>      cpu-soaker-5005  [003]  3683.395119
>>      cpu-soaker-5017  [003]  3683.397130
>>      cpu-soaker-5004  [003]  3683.399143
>>      cpu-soaker-5016  [003]  3683.401155
>>      cpu-soaker-5005  [003]  3683.403168
>>      cpu-soaker-5017  [003]  3683.405170
>>
>> AFTER: taskgroup_1 threads [21890, 21891], taskgroup_2 threads [21934, 21935]
>>      cpu-soaker-21890 [003]   865.895494
>>      cpu-soaker-21935 [003]   865.897506
>>      cpu-soaker-21934 [003]   865.899520
>>      cpu-soaker-21935 [003]   865.901532
>>      cpu-soaker-21934 [003]   865.903543
>>      cpu-soaker-21935 [003]   865.905546
>>      cpu-soaker-21891 [003]   865.907548
>>      cpu-soaker-21890 [003]   865.909560
>>      cpu-soaker-21891 [003]   865.911571
>>      cpu-soaker-21890 [003]   865.913582
>>      cpu-soaker-21891 [003]   865.915594
>>      cpu-soaker-21934 [003]   865.917606
>>
>> Similar problem is there when there are multiple taskgroups and say a task A
>> preempts currently running task B of taskgroup_1. On schedule, pick_next_task
>> can pick an unrelated task on taskgroup_2. Here it would be better to give some
>> preference to task B on pick_next_task.
>>
>> A simple (may be extreme case) benchmark I tried was tbench with 2 tbench
>> client processes with 2 threads each running on a single CPU. Avg throughput
>> across 5 50 sec runs was -
>> BEFORE: 105.84 MB/sec
>> AFTER: 112.42 MB/sec
>>
>> Changes from v0:
>> * Always pass task se to set_next_buddy
>> * Avoid repeated set_next_buddy in check_preempt_wakeup
>> * Minor flag cleanup in dequeue_task_fair
>>
>> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
>> ---
>>  kernel/sched_fair.c |   41 ++++++++++++++++++++++++++++++++++++++---
>>  1 files changed, 38 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index 3a88dee..cbe442e 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -1339,6 +1339,20 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>>        hrtick_update(rq);
>>  }
>>
>> +static struct sched_entity *pick_next_taskse_on_cfsrq(struct cfs_rq *cfs_rq)
>> +{
>> +       struct sched_entity *se;
>> +
>> +       do {
>> +               se = pick_next_entity(cfs_rq);
>> +               cfs_rq = group_cfs_rq(se);
>> +       } while (cfs_rq);
>> +
>> +       return se;
>> +}
>> +
>
> I think the original approach was much cleaner; the notion of a
> SCHED_IDLE task is only relative versus siblings in group scheduling

Looking at the related code,
static void set_skip_buddy(struct sched_entity *se)
{
	if (likely(task_of(se)->policy != SCHED_IDLE)) {
		for_each_sched_entity(se)
			cfs_rq_of(se)->skip = se;
	}
}

Shouldn't it be always set skip se irrespective of current task's
SCHED_IDLE setting.

Thanks,
Venki
