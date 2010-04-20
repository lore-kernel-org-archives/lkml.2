Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0DTIq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 04:46:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:47994 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab0DTIqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 04:46:55 -0400
Subject: Re: [patch v2 1/2] sched: check for prev_cpu == this_cpu before
 calling wake_affine()
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1270079265.7835.8.camel@sbs-t61.sc.intel.com>
References: <20100308221946.842728363@sbs-t61.sc.intel.com>
	 <1270031119.5003.93.camel@laptop>
	 <1270079265.7835.8.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 10:46:52 +0200
Message-ID: <1271753212.1676.400.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 16:47 -0700, Suresh Siddha wrote:

> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: sched: fix select_idle_sibling() logic in select_task_rq_fair()
> 
> Issues in the current select_idle_sibling() logic in select_task_rq_fair()
> in the context of a task wake-up:
> 
> a) Once we select the idle sibling, we use that domain (spanning the cpu that
>    the task is currently woken-up and the idle sibling that we found) in our
>    wake_affine() decisions. This domain is completely different from the
>    domain(we are supposed to use) that spans the cpu that the task currently
>    woken-up and the cpu where the task previously ran.
> 
> b) We do select_idle_sibling() check only for the cpu that the task is
>    currently woken-up on. If select_task_rq_fair() selects the previously run
>    cpu for waking the task, doing a select_idle_sibling() check
>    for that cpu also helps and we don't do this currently.
> 
> c) In the scenarios where the cpu that the task is woken-up is busy but
>    with its HT siblings are idle, we are selecting the task be woken-up
>    on the idle HT sibling instead of a core that it previously ran
>    and currently completely idle. i.e., we are not taking decisions based on
>    wake_affine() but directly selecting an idle sibling that can cause
>    an imbalance at the SMT/MC level which will be later corrected by the
>    periodic load balancer.
> 
> Fix this by first going through the load imbalance calculations using
> wake_affine() and once we make a decision of woken-up cpu vs previously-ran cpu,
> then choose a possible idle sibling for waking up the task on.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

OK, so I'm going to take this, but I had one concern, see below:

> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 49ad993..f905a4b 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1385,28 +1385,48 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>   * Try and locate an idle CPU in the sched_domain.
>   */
>  static int
> +select_idle_sibling(struct task_struct *p, int target)
>  {
>  	int cpu = smp_processor_id();
>  	int prev_cpu = task_cpu(p);
>  	int i;
> +	struct sched_domain *sd;
>  
>  	/*
> +	 * If the task is going to be woken-up on this cpu and if it is
> +	 * already idle, then it is the right target.
>  	 */
> +	if (target == cpu && !cpu_rq(cpu)->cfs.nr_running)
> +		return cpu;
> +
> +	/*
> +	 * If the task is going to be woken-up on the cpu where it previously
> +	 * ran and if it is currently idle, then it the right target.
> +	 */
> +	if (target == prev_cpu && !cpu_rq(prev_cpu)->cfs.nr_running)
>  		return prev_cpu;
>  
>  	/*
> +	 * Otherwise, iterate the domains and find an elegible idle cpu.
>  	 */
> +	for_each_domain(target, sd) {
> +		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
>  			break;
> +
> +		for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
> +			if (!cpu_rq(i)->cfs.nr_running) {
> +				target = i;
> +				break;
> +			}
>  		}
> +
> +		/*
> +		 * Lets stop looking for an idle sibling when we reached
> +		 * the domain that spans the current cpu and prev_cpu.
> +		 */
> +		if (cpumask_test_cpu(cpu, sched_domain_span(sd)) &&
> +		    cpumask_test_cpu(prev_cpu, sched_domain_span(sd)))
> +			break;
>  	}
>  
>  	return target;

So here we keep using !cfs.nr_running to mean idle, which might not at
all be true when there's real-time tasks around.

So should we be using idle_cpu(i) instead?

> @@ -1429,7 +1449,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
>  	int cpu = smp_processor_id();
>  	int prev_cpu = task_cpu(p);
>  	int new_cpu = cpu;
> +	int want_affine = 0;
>  	int want_sd = 1;
>  	int sync = wake_flags & WF_SYNC;
>  
> @@ -1467,36 +1487,15 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
>  				want_sd = 0;
>  		}
>  
>                 if (want_affine) {
>                         /*
>                          * If both cpu and prev_cpu are part of this domain,
>                          * cpu is a valid SD_WAKE_AFFINE target.
>                          */
> +			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))
> +			    && (tmp->flags & SD_WAKE_AFFINE)) {
> +				affine_sd = tmp;
> +				want_affine = 0;
>  			}
>  		}
>  
> @@ -1527,8 +1526,10 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
>  #endif
>  
>  	if (affine_sd) {
> +		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
> +			return select_idle_sibling(p, cpu);
> +		else
> +			return select_idle_sibling(p, prev_cpu);
>  	}
>  
>  	while (sd) {
> 
> 



