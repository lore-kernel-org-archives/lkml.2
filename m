Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0DTRE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:04:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:34207 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab0DTRE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:04:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,243,1270450800"; 
   d="scan'208";a="510769548"
Subject: Re: [patch v2 1/2] sched: check for prev_cpu == this_cpu before
 calling wake_affine()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1271753706.1676.402.camel@laptop>
References: <20100308221946.842728363@sbs-t61.sc.intel.com>
	 <1270031119.5003.93.camel@laptop>
	 <1270079265.7835.8.camel@sbs-t61.sc.intel.com>
	 <1271753212.1676.400.camel@laptop>  <1271753706.1676.402.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 20 Apr 2010 10:03:00 -0700
Message-Id: <1271782980.2871.6.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 01:55 -0700, Peter Zijlstra wrote:
> On Tue, 2010-04-20 at 10:46 +0200, Peter Zijlstra wrote:
> > So should we be using idle_cpu(i) instead?
> 
> something like the below..

Looks good to me.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

> 
> ---
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -1375,26 +1375,25 @@ find_idlest_cpu(struct sched_group *grou
>  /*
>   * Try and locate an idle CPU in the sched_domain.
>   */
> -static int
> -select_idle_sibling(struct task_struct *p, int target)
> +static int select_idle_sibling(struct task_struct *p, int target)
>  {
>  	int cpu = smp_processor_id();
>  	int prev_cpu = task_cpu(p);
> -	int i;
>  	struct sched_domain *sd;
> +	int i;
>  
>  	/*
>  	 * If the task is going to be woken-up on this cpu and if it is
>  	 * already idle, then it is the right target.
>  	 */
> -	if (target == cpu && !cpu_rq(cpu)->cfs.nr_running)
> +	if (target == cpu && idle_cpu(cpu))
>  		return cpu;
>  
>  	/*
>  	 * If the task is going to be woken-up on the cpu where it previously
>  	 * ran and if it is currently idle, then it the right target.
>  	 */
> -	if (target == prev_cpu && !cpu_rq(prev_cpu)->cfs.nr_running)
> +	if (target == prev_cpu && idle_cpu(prev_cpu))
>  		return prev_cpu;
>  
>  	/*
> @@ -1405,7 +1404,7 @@ select_idle_sibling(struct task_struct *
>  			break;
>  
>  		for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
> -			if (!cpu_rq(i)->cfs.nr_running) {
> +			if (idle_cpu(i)) {
>  				target = i;
>  				break;
>  			}
> @@ -1479,16 +1478,14 @@ select_task_rq_fair(struct rq *rq, struc
>  				want_sd = 0;
>  		}
>  
> -		if (want_affine) {
> -			/*
> -			 * If both cpu and prev_cpu are part of this domain,
> -			 * cpu is a valid SD_WAKE_AFFINE target.
> -			 */
> -			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))
> -			    && (tmp->flags & SD_WAKE_AFFINE)) {
> -				affine_sd = tmp;
> -				want_affine = 0;
> -			}
> +		/*
> +		 * If both cpu and prev_cpu are part of this domain,
> +		 * cpu is a valid SD_WAKE_AFFINE target.
> +		 */
> +		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
> +		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
> +			affine_sd = tmp;
> +			want_affine = 0;
>  		}
>  
>  		if (!want_sd && !want_affine)
> 
> 

