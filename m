Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab2FLJeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 05:34:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57028 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2FLJeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 05:34:16 -0400
Message-ID: <4FD70D12.5030404@gmail.com>
Date: Tue, 12 Jun 2012 17:34:10 +0800
From: Charles Wang <muming.wq@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Charles Wang <muming.wq@taobao.com>, Tao Ma <tm@tao.ma>,
        =?UTF-8?B?5ZCr6bub?= <handai.szj@taobao.com>
Subject: Re: [PATCH] sched: Folding nohz load accounting more accurate
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com> <1339429374.30462.54.camel@twins>
In-Reply-To: <1339429374.30462.54.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK! Configure the Thunderbird as Documentation/email-clients.txt saying.
Sorry for last email contained with html. No html now.

On Monday, June 11, 2012 11:42 PM, Peter Zijlstra wrote:

> On Sat, 2012-06-09 at 18:54 +0800, Charles Wang wrote:
>> After patch 453494c3d4 (sched: Fix nohz load accounting -- again!), we can fold
>> the idle into calc_load_tasks_idle between the last cpu load calculating and
>> calc_global_load calling. However problem still exits between the first cpu 
>> load calculating and the last cpu load calculating. Every time when we do load 
>> calculating, calc_load_tasks_idle will be added into calc_load_tasks, even if
>> the idle load is caused by calculated cpus. This problem is also described in
>> the following link:
>>
>> https://lkml.org/lkml/2012/5/24/419
> 
> Don't put links in like this, if its useful describe it. As it stands I
> think your paragraph and that link are trying to say the same.
> 
> Also, since you found Tao's email, why didn't you CC him?
> 

My mistake! And this problem is first reported by Sha Zhengju
<handai.szj@taobao.com>, so i also add her in.

> I find it hard to understand either description.
> 
> Are you in fact saying:
> 
> 
> cpu0		cpu1		cpu2
> 
> calc_load_account_active()
> 
> 		calc_load_account_active()
> 		-> idle
> 	,----	   calc_load_account_idle()
> 	|
> 	|			calc_load_account_active()
> 	`--------->		  calc_load_fold_idle()
> 
> 
> That when a cpu goes idle during the per-cpu active folding window
> it might happen that a cpu goes idle after its fold, but before a next
> cpu's fold, so that its calc_load_tasks_idle contribution gets folded
> back in. As per the above picture.
> 
> Now _why_ is this a problem? 
> 

consider following case:

5HZ+1
| cpu0_load	cpu1	cpu2	cpu3	calc_load_tasks
|    1		 1	 1	 1	
|  -->calc_load				    1
|    1		 1	 1	 1	
|       	     -->calc_load	    2
|    0		 0	 1	 0
|		     -->calc_load	    2+1-3=1
|    1		 1	 0	 1	
|			     -->calc_load   1-1=0
V
5HZ+11     -->calc_global_load              0



actually the load should be around 3, but shows nearly 0.

1 tick is much long for some workloads.

> All this code tries to do is:
> 
>   nr_active = 0;
>   for_each_possible_cpu(cpu)
> 	nr_active += cpu_rq(cpu)->nr_running + cpu_rq(cpu)
> 
> Without actually iterating all cpus because on large systems that's
> prohibitively expensive.
> 
> So instead we do the calc_load_fold_active() thing on each individual
> cpu:
> 
>   nr_active = this_rq->nr_running + this_rq->nr_uninterruptible;
>   delta = nr_active - this_rq->calc_load_active;
>   this_rq->calc_load_active = nr_active;
> 
>   atomic_long_add(delta, &calc_load_tasks);
> 
> The first does a straight sum, the second does a sum of deltas, both
> should give the same number.
> 
> 
>   \Sum_i x_i(t) = \Sum_i x_i(t) - x_i(t_0) | x_i(t_0) := 0
>                 = \Sum_i { \Sum_j=1 x_i(t_j) - x_i(t_j-1) }
> 
> The whole NO_HZ thing complicates this a little further in order to not
> have to wake an idle cpu. I'll try and do the above sum with the nohz
> thing in.. maybe something obvious falls out.
> 
> Now all this is sampling.. we take a nr_active sample once every
> LOAD_FREQ (5s). Anything that happens inside this doesn't exist.
> 
> So how is the above scenario different from the cpu going idle right
> before we take the sample?
> 
>> This bug can be found in our work load. The average running processes number 
>> is about 15, but the load only shows about 4.
> 
> Right,. still not really sure what the bug is though.
> 
>> The patch provides a solution, by taking calculated load cpus' idle away from
>>  real effective idle. 
> 
> -ENOPARSE
> 
>> First adds a cpumask to record those cpus that alread 
>> calculated their load, and then adds a calc_unmask_cpu_load_idle to record 
>> thoses not marked cpus' go-idle load. Calc_unmask_cpu_load_idle takes place 
>> of calc_load_tasks_idle to be added into calc_load_tasks every 5HZ
> 
> 5 seconds
> 
>>  when cpu 
>> calculate its load. Go-idle load on those cpus which load alread has been calculated 
>> will only be added into calc_load_tasks_idle, no in calc_unmask_cpu_load_idle.
> 
> I don't like the solution, keeping that mask is expensive. Also, I still
> don't understand what the problem is.
> 

It's a problem. And I plan to use per-cpu var to take place of cpumask.

> A few nits on the patch below..
> 
>> ---
>>  include/linux/sched.h     |    1 +
>>  kernel/sched/core.c       |   83 ++++++++++++++++++++++++++++++++++++++++++++-
>>  kernel/time/timekeeping.c |    1 +
>>  3 files changed, 84 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 6029d8c..a2b8df2 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -145,6 +145,7 @@ extern unsigned long this_cpu_load(void);
>>  
>>
>>  extern void calc_global_load(unsigned long ticks);
>> +extern void prepare_idle_mask(unsigned long ticks);
>>  extern void update_cpu_load_nohz(void);
>>  
>>  extern unsigned long get_parent_ip(unsigned long addr);
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index c46958e..bdfe3c2 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -2164,6 +2164,7 @@ unsigned long this_cpu_load(void)
>>  /* Variables and functions for calc_load */
>>  static atomic_long_t calc_load_tasks;
>>  static unsigned long calc_load_update;
>> +static unsigned long idle_mask_update;
>>  unsigned long avenrun[3];
>>  EXPORT_SYMBOL(avenrun);
>>  
>> @@ -2199,13 +2200,38 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
>>   */
>>  static atomic_long_t calc_load_tasks_idle;
>>  
>> +/* 
>> + * Those cpus whose load alread has been calculated in this LOAD_FREQ 
>> + * period will be masked.
>> + */
>> +struct cpumask  cpu_load_update_mask;
> 
> This should be a cpumask_var_t and allocated somewhere..
> 
>> +
>> +/* 
>> + * Fold unmask cpus' idle load
>> + */
>> +static atomic_long_t calc_unmask_cpu_load_idle;
>> +
>> +
>>  void calc_load_account_idle(struct rq *this_rq)
>>  {
>>  	long delta;
>> +	int cpu = smp_processor_id();
>> +
>>  
>>  	delta = calc_load_fold_active(this_rq);
>>  	if (delta)
>> +	{
> 
> wrong bracket placement
> 
>>  		atomic_long_add(delta, &calc_load_tasks_idle);
>> +		/*
>> +		 * calc_unmask_cpu_load_idle is only used between the first cpu load accounting
>> +		 * and the last cpu load accounting in every LOAD_FREQ period, and records idle load on
>> +		 * those unmask cpus.
>> +		 */
>> +		if (!cpumask_empty(&cpu_load_update_mask) && !cpumask_test_cpu(cpu, &cpu_load_update_mask))
>> +		{
>> +			atomic_long_add(delta, &calc_unmask_cpu_load_idle);
> 
> lines are too long, brackets are placed wrong and brackets are
> superfluous.
> 
> 
>> +		}
>> +       }
>>  }
>>  
> 
> and many more similar nits.
> 

Thanks for pointing these out!

>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>> index 6e46cac..afbc06a 100644
>> --- a/kernel/time/timekeeping.c
>> +++ b/kernel/time/timekeeping.c
>> @@ -1222,6 +1222,7 @@ void do_timer(unsigned long ticks)
>>  	jiffies_64 += ticks;
>>  	update_wall_time();
>>  	calc_global_load(ticks);
>> +	prepare_idle_mask(ticks);
> 
> Why not add this to calc_global_load() ? 
> 

If some CPUs go into nohz and get up after calc_global_load,
then calc_load_account_active will be called after calc_global_load.
This will cause identifying of first calc_load_account_active cpu being
much more complicated.

>>  }
>>  
>>  /**
> 


