Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab2LLG3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:29:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:29575 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab2LLG3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:29:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,264,1355126400"; 
   d="scan'208";a="232639913"
Message-ID: <50C823A4.109@intel.com>
Date: Wed, 12 Dec 2012 14:26:44 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: Re: [PATCH 08/18] sched: consider runnable load average in move_tasks
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <1355127754-8444-9-git-send-email-alex.shi@intel.com> <50C80ADF.8050504@linux.vnet.ibm.com>
In-Reply-To: <50C80ADF.8050504@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 12:41 PM, Preeti U Murthy wrote:
> Hi Alex,
> On 12/10/2012 01:52 PM, Alex Shi wrote:
>> Except using runnable load average in background, move_tasks is also
>> the key functions in load balance. We need consider the runnable load
>> average in it in order to the apple to apple load comparison.
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>> ---
>>  kernel/sched/fair.c |   11 ++++++++++-
>>  1 files changed, 10 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 6d893a6..bbb069c 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -3741,6 +3741,15 @@ static unsigned long task_h_load(struct task_struct *p);
>>  
>>  static const unsigned int sched_nr_migrate_break = 32;
>>  
>> +static unsigned long task_h_load_avg(struct task_struct *p)
>> +{
>> +	u32 period = p->se.avg.runnable_avg_period;
>> +	if (!period)
>> +		return 0;
>> +
>> +	return task_h_load(p) * p->se.avg.runnable_avg_sum / period;
>                         ^^^^^^^^^^^^
> This might result in an overflow,considering you are multiplying two 32
> bit integers.Below is how this is handled in
> __update_task_entity_contrib in kernel/sched/fair.c
> 
> u32 contrib;
> /* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
> contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
> contrib /= (se->avg.runnable_avg_period + 1);
> se->avg.load_avg_contrib = scale_load(contrib);

scale_load_down is do nothing.
> 
> Also why can't p->se.load_avg_contrib be used directly? as a return
> value for task_h_load_avg? since this is already updated in
> update_task_entity_contrib and update_group_entity_contrib.

No, only non task entity goes to  update_group_entity_contrib. not task
entity.


>> +}
>> +
>>  /*
>>   * move_tasks tries to move up to imbalance weighted load from busiest to
>>   * this_rq, as part of a balancing operation within domain "sd".
>> @@ -3776,7 +3785,7 @@ static int move_tasks(struct lb_env *env)
>>  		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
>>  			goto next;
>>  
>> -		load = task_h_load(p);
>> +		load = task_h_load_avg(p);
>>  
>>  		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
>>  			goto next;
>>
> 
> Regards
> Preeti U Murthy
> 

