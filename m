Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab2LHMUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 07:20:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:26619 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933103Ab2LHMUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 07:20:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,243,1355126400"; 
   d="scan'208";a="259051022"
Message-ID: <50C33095.9030702@intel.com>
Date: Sat, 08 Dec 2012 20:20:37 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Alex Shi <lkml.alex@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>, Tejun Heo <tj@kernel.org>
Subject: Re: weakness of runnable load tracking?
References: <CAGjg+kFZ2+tzxOS4SVo3PTzEDJJ=B0gZJ0aEOhNHvTycFuVT6Q@mail.gmail.com> <50C00D41.1010800@intel.com> <CAPM31RKV-2arH6Jd+6XE0PyeicPJzWkuJ__A9XBj0VHaYCesDQ@mail.gmail.com> <50C0B579.3040602@intel.com>
In-Reply-To: <50C0B579.3040602@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 11:10 PM, Alex Shi wrote:
> 
>>> Hi Paul & Ingo:
>>>
>>> In a short word of this issue: burst forking/waking tasks have no time
>>> accumulate the load contribute, their runnable load are taken as zero.
>>> that make select_task_rq do a wrong decision on which group is idlest.
>>
>> So these aren't strictly comparable; bursting and forking tasks have
>> fairly different characteristics here.
> 
> Many thanks for looking into this. :)
>>
>> When we fork a task we intentionally reset the previous history.  This
>> means that a forked task that immediately runs is going to show up as
>> 100% runnable and then converge to it's true value.  This was fairly
>> intentionally chosen so that tasks would "start" fast rather than
>> having to worry about ramp up.
> 
> I am sorry for didn't see the 100% runnable for a new forked task. 
> I believe the code need the following patch to initialize decay_count, 
> and load_avg_contrib. otherwise they are random value. 
> In enqueue_entity_load_avg() p->se.avg.runnable_avg_sum for new forked 
> task is always zero, either because se.avg.last_runnable_update is set
>  as clock_task due to decay_count <=0, or just do 
> __synchronize_entity_decay not update_entity_load_avg.

Paul:
Would you like to give some comments for the following patches?

> 
> ===========
> From a161000dbece6e95bf3b81e9246d51784589d393 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Mon, 3 Dec 2012 17:30:39 +0800
> Subject: [PATCH 05/12] sched: load tracking bug fix
> 
> We need initialize the se.avg.{decay_count, load_avg_contrib} to zero
> after a new task forked.
> Otherwise random values of above variable give a incorrect statistic
> data when do new task enqueue:
>     enqueue_task_fair
>         enqueue_entity
>             enqueue_entity_load_avg
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 5dae0d2..e6533e1 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1534,6 +1534,8 @@ static void __sched_fork(struct task_struct *p)
>  #if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
>  	p->se.avg.runnable_avg_period = 0;
>  	p->se.avg.runnable_avg_sum = 0;
> +	p->se.avg.decay_count = 0;
> +	p->se.avg.load_avg_contrib = 0;
>  #endif
>  #ifdef CONFIG_SCHEDSTATS
>  	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
> 


-- 
Thanks
    Alex
