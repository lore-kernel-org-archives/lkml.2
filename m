Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab1LBDeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 22:34:31 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:40423 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756506Ab1LBDeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 22:34:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1944lkm83p4BsIHozfJA6z/tQJQr5S0+NeMovP0aY
	Q98d9eta9sgiRR
Subject: Re: [patch v3 5/6] sched, ttwu_queue: queue remote wakeups only
 when crossing cache domains
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com
In-Reply-To: <20111202010832.714874234@sbsiddha-desk.sc.intel.com>
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
	 <20111202010832.714874234@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 04:34:24 +0100
Message-ID: <1322796864.4755.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 17:07 -0800, Suresh Siddha wrote:
> plain text document attachment
> (use_ttwu_queue_when_crossing_cache_domains.patch)
> From: Mike Galbraith <efault@gmx.de>
> 
> Context-switch intensive microbenchmark on a 8-socket system had
> ~600K times more resched IPI's on each logical CPU because of the
> TTWU_QUEUE sched feature, which queues the task on the remote cpu's
> queue and completes the wakeup locally using an IPI.
> 
> As the TTWU_QUEUE sched feature is for minimizing the cache-misses
> associated with the remote wakeups, use the IPI only when the local and
> the remote cpu's are from different cache domains. Otherwise use the
> traditional remote wakeup.

FYI, Peter has already (improved and) queued this patch.

> With this, context-switch microbenchmark performed 5 times better on the
> 8-socket NHM-EX system.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  kernel/sched/core.c |   25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> Index: tip/kernel/sched/core.c
> ===================================================================
> --- tip.orig/kernel/sched/core.c
> +++ tip/kernel/sched/core.c
> @@ -1481,12 +1481,35 @@ static int ttwu_activate_remote(struct t
>  #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
>  #endif /* CONFIG_SMP */
>  
> +static int ttwu_share_cache(int this_cpu, int cpu)
> +{
> +#ifndef CONFIG_X86
> +	struct sched_domain *sd;
> +	int ret = 0;
> +
> +	rcu_read_lock();
> +	for_each_domain(this_cpu, sd) {
> +		if (!cpumask_test_cpu(cpu, sched_domain_span(sd)))
> +			continue;
> +
> +		ret = (sd->flags & SD_SHARE_PKG_RESOURCES);
> +		break;
> +	}
> +	rcu_read_unlock();
> +
> +	return ret;
> +#else
> +	return per_cpu(cpu_llc_id, this_cpu) == per_cpu(cpu_llc_id, cpu);
> +#endif
> +}
> +
>  static void ttwu_queue(struct task_struct *p, int cpu)
>  {
>  	struct rq *rq = cpu_rq(cpu);
>  
>  #if defined(CONFIG_SMP)
> -	if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
> +	if (sched_feat(TTWU_QUEUE) &&
> +	    !ttwu_share_cache(smp_processor_id(), cpu)) {
>  		sched_clock_cpu(cpu); /* sync clocks x-cpu */
>  		ttwu_queue_remote(p, cpu);
>  		return;
> 
> 


