Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938Ab2CTNdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:33:41 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:58764 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759463Ab2CTNdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:33:39 -0400
Message-ID: <4F6882BA.2040000@linux.vnet.ibm.com>
Date: Tue, 20 Mar 2012 18:44:34 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] Fix the race between smp_call_function and CPU booting
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com> <1331546307.18960.26.camel@twins> <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com> <1331654251.18960.78.camel@twins> <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com> <1331718197.18960.106.camel@twins> <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com> <1331808391.18960.160.camel@twins> <27240C0AC20F114CBF8149A2696CBE4A05806B@SHSMSX101.ccr.corp.intel.com> <1331891364.18960.221.camel@twins> <27240C0AC20F114CBF8149A2696CBE4A058AAE@SHSMSX101.ccr.corp.intel.com> <1332151397.18960.252.camel@twins> <27240C0AC20F114CBF8149A2696CBE4A05A6BF@SHSMSX101.ccr.corp.intel.com> <1332245842.18960.413.camel@twins>
In-Reply-To: <1332245842.18960.413.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12032013-8256-0000-0000-000001B8A7A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Adding a few more Cc's since this affects suspend/resume. ]

On 03/20/2012 05:47 PM, Peter Zijlstra wrote:

> On Tue, 2012-03-20 at 00:22 +0000, Liu, Chuansheng wrote:
>> Thanks to give some time to have a look.
>>
> Does the below on top of current tip/master work?


I don't think this patch would change anything, atleast it wouldn't get
rid of the warning that Liu reported. Because, he is running his stress
tests on a machine which has only 2 CPUs. So effectively, we are hotplugging
only CPU1 (since CPU0 can't be taken offline, on Intel boxes).

Also, CPU1 is removed from cpu_active_mask during CPU_DOWN_PREPARE time itself,
and migrate_tasks() comes much later (during CPU_DYING). And in any case,
dest_cpu will never be CPU1, because it is the CPU that is going down. So it
*has* to be CPU0 anyway.

So, I don't think changes to select_fallback_rq() to make it more careful is
going to make any difference in the particular scenario that Liu is testing.

That said, even I don't know what the root cause of the warning is.. :-(

Regards,
Srivatsa S. Bhat

>>
> ---
>  include/linux/cpuset.h |    6 +---
>  kernel/cpuset.c        |   20 +++------------
>  kernel/sched/core.c    |   62 +++++++++++++++++++++++++++++++++++------------
>  3 files changed, 52 insertions(+), 36 deletions(-)
> 
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index e9eaec5..e0ffaf0 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -22,7 +22,7 @@ extern int cpuset_init(void);
>  extern void cpuset_init_smp(void);
>  extern void cpuset_update_active_cpus(void);
>  extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
> -extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
> +extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
>  extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
>  #define cpuset_current_mems_allowed (current->mems_allowed)
>  void cpuset_init_current_mems_allowed(void);
> @@ -144,10 +144,8 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
>  	cpumask_copy(mask, cpu_possible_mask);
>  }
> 
> -static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
> +static inline void cpuset_cpus_allowed_fallback(struct task_struct *p)
>  {
> -	do_set_cpus_allowed(p, cpu_possible_mask);
> -	return cpumask_any(cpu_active_mask);
>  }
> 
>  static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index a09ac2b..c9837b7 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2195,7 +2195,7 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
>  	mutex_unlock(&callback_mutex);
>  }
> 
> -int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
> +void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
>  {
>  	const struct cpuset *cs;
>  	int cpu;
> @@ -2219,22 +2219,10 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
>  	 * changes in tsk_cs()->cpus_allowed. Otherwise we can temporary
>  	 * set any mask even if it is not right from task_cs() pov,
>  	 * the pending set_cpus_allowed_ptr() will fix things.
> +	 *
> +	 * select_fallback_rq() will fix things ups and set cpu_possible_mask
> +	 * if required.
>  	 */
> -
> -	cpu = cpumask_any_and(&tsk->cpus_allowed, cpu_active_mask);
> -	if (cpu >= nr_cpu_ids) {
> -		/*
> -		 * Either tsk->cpus_allowed is wrong (see above) or it
> -		 * is actually empty. The latter case is only possible
> -		 * if we are racing with remove_tasks_in_empty_cpuset().
> -		 * Like above we can temporary set any mask and rely on
> -		 * set_cpus_allowed_ptr() as synchronization point.
> -		 */
> -		do_set_cpus_allowed(tsk, cpu_possible_mask);
> -		cpu = cpumask_any(cpu_active_mask);
> -	}
> -
> -	return cpu;
>  }
> 
>  void cpuset_init_current_mems_allowed(void)
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index e37c9af..04d3f7f 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1263,29 +1263,59 @@ EXPORT_SYMBOL_GPL(kick_process);
>   */
>  static int select_fallback_rq(int cpu, struct task_struct *p)
>  {
> -	int dest_cpu;
>  	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
> +	enum { cpuset, possible, fail } state = cpuset;
> +	int dest_cpu;
> 
>  	/* Look for allowed, online CPU in same node. */
> -	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
> +	for_each_cpu_mask(dest_cpu, *nodemask) {
> +		if (!cpu_online(dest_cpu))
> +			continue;
> +		if (!cpu_active(dest_cpu))
> +			continue;
>  		if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
>  			return dest_cpu;
> +	}
> 
> -	/* Any allowed, online CPU? */
> -	dest_cpu = cpumask_any_and(tsk_cpus_allowed(p), cpu_active_mask);
> -	if (dest_cpu < nr_cpu_ids)
> -		return dest_cpu;
> +	for (;;) {
> +		/* Any allowed, online CPU? */
> +		for_each_cpu_mask(dest_cpu, *tsk_cpus_allowed(p)) {
> +			if (!cpu_online(dest_cpu))
> +				continue;
> +			if (!cpu_active(dest_cpu))
> +				continue;
> +			goto out;
> +		}
> 
> -	/* No more Mr. Nice Guy. */
> -	dest_cpu = cpuset_cpus_allowed_fallback(p);
> -	/*
> -	 * Don't tell them about moving exiting tasks or
> -	 * kernel threads (both mm NULL), since they never
> -	 * leave kernel.
> -	 */
> -	if (p->mm && printk_ratelimit()) {
> -		printk_sched("process %d (%s) no longer affine to cpu%d\n",
> -				task_pid_nr(p), p->comm, cpu);
> +		switch (state) {
> +		case cpuset:
> +			/* No more Mr. Nice Guy. */
> +			cpuset_cpus_allowed_fallback(p);
> +			state = possible;
> +			break;
> +
> +		case possible:
> +			do_set_cpus_allowed(p, cpu_possible_mask);
> +			state = fail;
> +			break;
> +
> +		case fail:
> +			BUG();
> +			break;
> +		}
> +	}
> +
> +out:
> +	if (state != cpuset) {
> +		/*
> +		 * Don't tell them about moving exiting tasks or
> +		 * kernel threads (both mm NULL), since they never
> +		 * leave kernel.
> +		 */
> +		if (p->mm && printk_ratelimit()) {
> +			printk_sched("process %d (%s) no longer affine to cpu%d\n",
> +					task_pid_nr(p), p->comm, cpu);
> +		}
>  	}
> 
>  	return dest_cpu;
> 


