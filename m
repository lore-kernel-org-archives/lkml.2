Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab2LLFzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 00:55:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:42597 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab2LLFzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 00:55:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,264,1355126400"; 
   d="scan'208";a="230320652"
Message-ID: <50C81BB0.1020602@intel.com>
Date: Wed, 12 Dec 2012 13:52:48 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>, pjt@google.com
CC: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        vincent.guittot@linaro.org
Subject: Re: [PATCH 07/18] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <1355127754-8444-8-git-send-email-alex.shi@intel.com> <50C800B5.1080205@linux.vnet.ibm.com>
In-Reply-To: <50C800B5.1080205@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 11:57 AM, Preeti U Murthy wrote:
> Hi Alex,
> On 12/10/2012 01:52 PM, Alex Shi wrote:
>> They are the base values in load balance, update them with rq runnable
>> load average, then the load balance will consider runnable load avg
>> naturally.
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>> ---
>>  kernel/sched/core.c |    4 ++--
>>  kernel/sched/fair.c |    4 ++--
>>  2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 96fa5f1..0ecb907 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -2487,7 +2487,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>>  void update_idle_cpu_load(struct rq *this_rq)
>>  {
>>  	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
>> -	unsigned long load = this_rq->load.weight;
>> +	unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;
>>  	unsigned long pending_updates;
>>  
>>  	/*
>> @@ -2537,7 +2537,7 @@ static void update_cpu_load_active(struct rq *this_rq)
>>  	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
>>  	 */
>>  	this_rq->last_load_update_tick = jiffies;
>> -	__update_cpu_load(this_rq, this_rq->load.weight, 1);
>> +	__update_cpu_load(this_rq, this_rq->cfs.runnable_load_avg, 1);
>>  
>>  	calc_load_account_active(this_rq);
>>  }
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 61c8d24..6d893a6 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -2680,7 +2680,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>>  /* Used instead of source_load when we know the type == 0 */
>>  static unsigned long weighted_cpuload(const int cpu)
>>  {
>> -	return cpu_rq(cpu)->load.weight;
>> +	return (unsigned long)cpu_rq(cpu)->cfs.runnable_load_avg;
> 
> I was wondering why you have typecasted the cfs.runnable_load_avg to
> unsigned long.Have you looked into why it was declared as u64 in the
> first place?

PJT:
Could we changed the cfs.runnable_load_avg to unsigned long?  since it's
a unsigned long value multiple a value less then 1.

> 
>>  }
>>  
>>  /*
>> @@ -2727,7 +2727,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
>>  	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
>>  
>>  	if (nr_running)
>> -		return rq->load.weight / nr_running;
>> +		return rq->cfs.runnable_load_avg / nr_running;
> 
> rq->cfs.runnable_load_avg is u64 type.you will need to typecast it here
> also right? how does this division work? because the return type is
> unsigned long.

Yes, a clear cast is better.
>>  
>>  	return 0;
>>  }
>>
> 
> Regards
> Preeti U Murthy
> 

