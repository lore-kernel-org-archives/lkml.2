Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab2CWMVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 08:21:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:61397 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab2CWMVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:21:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="80822126"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Topic: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Index: AQHNCO5ZgWjM4709EUuXKNY/vpMUB5Z3zEDQ
Date: Fri, 23 Mar 2012 12:21:09 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A05D697@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
	 <1331546307.18960.26.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
	 <1331654251.18960.78.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com>
	 <1331718197.18960.106.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com>
	 <1331808391.18960.160.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05806B@SHSMSX101.ccr.corp.intel.com>
	 <1331891364.18960.221.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A058AAE@SHSMSX101.ccr.corp.intel.com>
	 <1332151397.18960.252.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05A6BF@SHSMSX101.ccr.corp.intel.com>
	 <1332245842.18960.413.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05B485@SHSMSX101.ccr.corp.intel.com>
	 <1332332739.18960.488.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05C092@SHSMSX101.ccr.corp.intel.com>
	 <1332498333.16159.9.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05D65B@SHSMSX101.ccr.corp.intel.com>
	 <1332504120.16159.17.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05D689@SHSMSX101.ccr.corp.intel.com>
 <1332504800.16159.20.camel@twins>
In-Reply-To: <1332504800.16159.20.camel@twins>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, waiting for your test result.
And if possible, please correct my name Chuansheng Lui == > Chuansheng Liu,
Thanks.

> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Friday, March 23, 2012 8:13 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org; Yanmin Zhang; tglx@linutronix.de; Srivatsa S.
> Bhat
> Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
> 
> On Fri, 2012-03-23 at 12:06 +0000, Liu, Chuansheng wrote:
> > If so, I has something wrong about merging your change of
> select_fallback_rq()?
> > I am using 3.0.8.
> >
> > I indeed see the warning even with the change of select_fallback_rq().
> 
> Please use linus's current tree or tip/master with the below patch. I've no idea
> what 3.0.8 looks like and the important thing is to make sure Linus' tree (which
> will become 3.4) works correctly.
> 
> After that we can prod at -stable muck.
> 
> I've included my patch to select_fallback_rq() again.
> 
> ---
> Subject: sched: Fix select_fallback_rq vs cpu_active/cpu_online
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Mar 20 15:57:01 CET 2012
> 
> Commit 5fbd036b55 ("sched: Cleanup cpu_active madness"), which was
> supposed to finally sort the cpu_active mess, instead uncovered more.
> 
> Since CPU_STARTING is ran before setting the cpu online, there's a
> (small) window where the cpu has active,!online.
> 
> If during this time there's a wakeup of a task that used to reside on that cpu
> select_task_rq() will use select_fallback_rq() to compute an alternative cpu to
> run on since we find !online.
> 
> select_fallback_rq() however will compute the new cpu against cpu_active, this
> means that it can return the same cpu it started out with, the !online one,
> since that cpu is in fact marked active.
> 
> This results in us trying to scheduling a task on an offline cpu and triggering a
> WARN in the IPI code.
> 
> The solution proposed by Chuansheng Lui of setting cpu_active in
> set_cpu_online() is buggy, firstly not all archs actually use set_cpu_online(),
> secondly, not all archs call set_cpu_online() with IRQs disabled, this means we
> would introduce either the same race or the race from fd8a7de17 ("x86:
> cpu-hotplug: Prevent softirq wakeup on wrong CPU") -- albeit much narrower.
> 
> [ By setting online first and active later we have a window of
>   online,!active, fresh and bound kthreads have task_cpu() of 0 and
>   since cpu0 isn't in tsk_cpus_allowed() we end up in
>   select_fallback_rq() which excludes !active, resulting in a reset
>   of ->cpus_allowed and the thread running all over the place. ]
> 
> The solution is to re-work select_fallback_rq() to require active _and_ online.
> This makes the active,!online case work as expected, OTOH archs running
> CPU_STARTING after setting online are now vulnerable to the issue from
> fd8a7de17 -- these are alpha and blackfin.
> 
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: linux-alpha@vger.kernel.org
> Reported-by: Chuansheng Lui <chuansheng.liu@intel.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-hubqk1i10o4dpvlm06gq7v6j@git.kernel.org
> ---
>  include/linux/cpuset.h |    6 +---
>  kernel/cpuset.c        |   20 +++------------
>  kernel/sched/core.c    |   64
> +++++++++++++++++++++++++++++++++++--------------
>  3 files changed, 53 insertions(+), 37 deletions(-)
> 
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -22,7 +22,7 @@ extern int cpuset_init(void);  extern void
> cpuset_init_smp(void);  extern void cpuset_update_active_cpus(void);
> extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
> -extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
> +extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
>  extern nodemask_t cpuset_mems_allowed(struct task_struct *p);  #define
> cpuset_current_mems_allowed (current->mems_allowed)  void
> cpuset_init_current_mems_allowed(void);
> @@ -144,10 +144,8 @@ static inline void cpuset_cpus_allowed(s
>  	cpumask_copy(mask, cpu_possible_mask);  }
> 
> -static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
> +static inline void cpuset_cpus_allowed_fallback(struct task_struct *p)
>  {
> -	do_set_cpus_allowed(p, cpu_possible_mask);
> -	return cpumask_any(cpu_active_mask);
>  }
> 
>  static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2195,7 +2195,7 @@ void cpuset_cpus_allowed(struct task_str
>  	mutex_unlock(&callback_mutex);
>  }
> 
> -int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
> +void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
>  {
>  	const struct cpuset *cs;
>  	int cpu;
> @@ -2219,22 +2219,10 @@ int cpuset_cpus_allowed_fallback(struct
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
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1263,29 +1263,59 @@ EXPORT_SYMBOL_GPL(kick_process);
>   */
>  static int select_fallback_rq(int cpu, struct task_struct *p)  {
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
> +
> +	for (;;) {
> +		/* Any allowed, online CPU? */
> +		for_each_cpu_mask(dest_cpu, *tsk_cpus_allowed(p)) {
> +			if (!cpu_online(dest_cpu))
> +				continue;
> +			if (!cpu_active(dest_cpu))
> +				continue;
> +			goto out;
> +		}
> +
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
> 
> -	/* Any allowed, online CPU? */
> -	dest_cpu = cpumask_any_and(tsk_cpus_allowed(p), cpu_active_mask);
> -	if (dest_cpu < nr_cpu_ids)
> -		return dest_cpu;
> -
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

