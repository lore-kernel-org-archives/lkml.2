Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab2DNLK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 07:10:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42602 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab2DNLK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 07:10:58 -0400
Message-ID: <1334401847.2528.65.camel@twins>
Subject: Re: RFC [patch] sched,cgroup_sched: convince RT_GROUP_SCHED
 throttle to work
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Date: Sat, 14 Apr 2012 13:10:47 +0200
In-Reply-To: <1334048925.7524.21.camel@marge.simpson.net>
References: <1333444106.9072.4.camel@marge.simpson.net>
	 <1333444788.9072.9.camel@marge.simpson.net>
	 <1333789124.12677.15.camel@marge.simpson.net>
	 <1333792489.12677.58.camel@marge.simpson.net>
	 <1334048925.7524.21.camel@marge.simpson.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 11:08 +0200, Mike Galbraith wrote:

> sched,rt: fix isolated CPUs leaving root_task_group indefinitely throttled
> 
> Root task group bandwidth replenishment must service all CPUs regardless of
> where it was last started.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> ---
>  kernel/sched/rt.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -782,6 +782,19 @@ static int do_sched_rt_period_timer(stru
>  	const struct cpumask *span;
>  
>  	span = sched_rt_period_mask();
> +#ifdef CONFIG_RT_GROUP_SCHED
> +	/*
> +	 * FIXME: isolated CPUs should really leave the root task group,

No no, that's the wrong fix, the right fix is to remove isolcpus :-)

> +	 * whether they are isolcpus or were isolated via cpusets, lest
> +	 * the timer run on a CPU which does not service all runqueues,
> +	 * potentially leaving other CPUs indefinitely throttled.  If
> +	 * isolation is really required, the user will turn the throttle
> +	 * off to kill the perturbations it causes anyway.  Meanwhile,
> +	 * this maintains functionality for boot and/or troubleshooting.
> +	 */
> +	if (rt_b == &root_task_group.rt_bandwidth)
> +		span = cpu_online_mask;
> +#endif
>  	for_each_cpu(i, span) {
>  		int enqueue = 0;
>  		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);

I guess the alternative 'fix' is to not account the rt_runtime on
isolated cpus.. does something like the below actually work?

---
 kernel/sched/rt.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 44af55e..dc2b5b6 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -922,6 +922,9 @@ static void update_curr_rt(struct rq *rq)
 	if (!rt_bandwidth_enabled())
 		return;
 
+	if (cpumask_test_cpu(cpu_of(rq), cpu_isolated_map))
+		return;
+
 	for_each_sched_rt_entity(rt_se) {
 		rt_rq = rt_rq_of_se(rt_se);
 

