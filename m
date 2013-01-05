Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3AEIzN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:55:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:12555 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab3AEIzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:55:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,415,1355126400"; 
   d="scan'208";a="240248003"
Message-ID: <50E7EAB1.6020302@intel.com>
Date: Sat, 05 Jan 2013 16:56:17 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: pjt@google.com
CC: Alex Shi <alex.shi@intel.com>, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/22] sched: compute runnable load avg in cpu_load
 and cpu_avg_load_per_task
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-10-git-send-email-alex.shi@intel.com>
In-Reply-To: <1357375071-11793-10-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2013 04:37 PM, Alex Shi wrote:
> They are the base values in load balance, update them with rq runnable
> load average, then the load balance will consider runnable load avg
> naturally.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/core.c | 8 ++++++++
>  kernel/sched/fair.c | 4 ++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 06d27af..5feed5e 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2544,7 +2544,11 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>  void update_idle_cpu_load(struct rq *this_rq)
>  {
>  	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
> +#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
> +	unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;
> +#else
>  	unsigned long load = this_rq->load.weight;
> +#endif
>  	unsigned long pending_updates;
>  
>  	/*
> @@ -2594,7 +2598,11 @@ static void update_cpu_load_active(struct rq *this_rq)
>  	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
>  	 */
>  	this_rq->last_load_update_tick = jiffies;
> +#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
> +	__update_cpu_load(this_rq, this_rq->cfs.runnable_load_avg, 1);
> +#else
>  	__update_cpu_load(this_rq, this_rq->load.weight, 1);
> +#endif
>  
>  	calc_load_account_active(this_rq);
>  }
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 5c545e4..84a6517 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2906,7 +2906,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  /* Used instead of source_load when we know the type == 0 */
>  static unsigned long weighted_cpuload(const int cpu)
>  {
> -	return cpu_rq(cpu)->load.weight;
> +	return (unsigned long)cpu_rq(cpu)->cfs.runnable_load_avg;

Above line change cause aim9 multitask benchmark drop about 10%
performance on many x86 machines. Profile just show there are more
cpuidle enter called.
The testing command:

#( echo $hostname ; echo test ; echo 1 ; echo 2000 ; echo 2 ; echo 2000
; echo 100 ) | ./multitask -nl

The oprofile output here:
with this patch set
101978 total                                      0.0134
 54406 cpuidle_wrap_enter                       499.1376
  2098 __do_page_fault                            2.0349
  1976 rwsem_wake                                29.0588
  1824 finish_task_switch                        12.4932
  1560 copy_user_generic_string                  24.3750
  1346 clear_page_c                              84.1250
  1249 unmap_single_vma                           0.6885
  1141 copy_page_rep                             71.3125
  1093 anon_vma_interval_tree_insert              8.1567

3.8-rc2
 68982 total                                      0.0090
 22166 cpuidle_wrap_enter                       203.3578
  2188 rwsem_wake                                32.1765
  2136 __do_page_fault                            2.0718
  1920 finish_task_switch                        13.1507
  1724 poll_idle                                 15.2566
  1433 copy_user_generic_string                  22.3906
  1237 clear_page_c                              77.3125
  1222 unmap_single_vma                           0.6736
  1053 anon_vma_interval_tree_insert              7.8582

Without load avg in periodic balancing, each cpu will weighted with all
tasks load.

with new load tracking, we just update the cfs_rq load avg with each
task at enqueue/dequeue moment, and with just update current task in
scheduler_tick. I am wondering if it's the sample is a bit rare.

What's your opinion of this, Paul?


>  }
>  
>  /*
> @@ -2953,7 +2953,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
>  	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
>  
>  	if (nr_running)
> -		return rq->load.weight / nr_running;
> +		return (unsigned long)rq->cfs.runnable_load_avg / nr_running;
>  
>  	return 0;
>  }
> 


-- 
Thanks Alex
