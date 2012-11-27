Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab2K0TDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 14:03:16 -0500
Received: from relay.parallels.com ([195.214.232.42]:43214 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab2K0TDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 14:03:14 -0500
From: Vladimir Davydov <VDavydov@parallels.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>
CC: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Nikhil Rao <ncrao@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
Thread-Topic: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
Thread-Index: Ac1CPEUTh/lV6P3VRrixwX5TYQAVZCKc/94A
Date: Tue, 27 Nov 2012 19:02:50 +0000
Message-ID: <049D7A4CCB8B694CACDEEB03BE35F3061800D5@MSK-EXCH.sw.swsoft.com>
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
In-Reply-To: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.21.38]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CC59A73A24D7E745A5AC70898F2AC737@sw.swsoft.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again

Playing with cpu cgroups, I've found that performance of various workloads running inside cgroups can be significantly improved by increasing sched load resolution and that this improvement has already been committed to the kernel (c8b281161dfa4bb5d5be63fb036ce19347b88c63). Unfortunately, it turned out that the commit triggered power usage regression and as a result was reverted until the root cause of the regression was found (see commit e4c2fb0d5776b58049d2556b456144a4db3fe5a9). And the root cause is still unknown...

I guess that the behavior of the cpuidle menu governor, which is stated in the patch below, can explain the regression. The governor uses this_cpu_load() to estimate idleness of the system. After commit c8b281161dfa4bb5d5be63fb036ce19347b88c63, which increases sched load resolution, this_cpu_load() seems to return large values even for small loads, which would probably lead to the cpuidle governor making wrong decisions due to overestimating the system load.

So, this seems to be another reason to use some different performance multiplier in cpuidle governor.

On Jun 4, 2012, at 2:24 PM, Vladimir Davydov <VDavydov@parallels.com> wrote:

> rq->cpuload strongly depends on cgroup hierarchy. For example, if hundreds of
> tasks are running inside cpu:/test cgroup, the sum of cpuload over all cpus
> won't exceed 1024 (by default). That makes the cpuidle menu governor take wrong
> decisions, which can negatively affect overall performance.
> 
> To cope this, use nr_running last seen in __update_cpu_load() instead of
> cpuload for calculating performance multiplier.
> ---
> drivers/cpuidle/governors/menu.c |   17 +++--------------
> include/linux/sched.h            |    2 +-
> kernel/sched/core.c              |    7 ++++---
> kernel/sched/sched.h             |    3 +++
> 4 files changed, 11 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index 0633575..2aa2625 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -123,17 +123,6 @@ struct menu_device {
> };
> 
> 
> -#define LOAD_INT(x) ((x) >> FSHIFT)
> -#define LOAD_FRAC(x) LOAD_INT(((x) & (FIXED_1-1)) * 100)
> -
> -static int get_loadavg(void)
> -{
> -	unsigned long this = this_cpu_load();
> -
> -
> -	return LOAD_INT(this) * 10 + LOAD_FRAC(this) / 10;
> -}
> -
> static inline int which_bucket(unsigned int duration)
> {
> 	int bucket = 0;
> @@ -170,13 +159,13 @@ static inline int which_bucket(unsigned int duration)
> static inline int performance_multiplier(void)
> {
> 	int mult = 1;
> +	int this_cpu = smp_processor_id();
> 
> 	/* for higher loadavg, we are more reluctant */
> -
> -	mult += 2 * get_loadavg();
> +	mult += 10 * nr_active_cpu(this_cpu);
> 
> 	/* for IO wait tasks (per cpu!) we add 5x each */
> -	mult += 10 * nr_iowait_cpu(smp_processor_id());
> +	mult += 10 * nr_iowait_cpu(this_cpu);
> 
> 	return mult;
> }
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index f45c0b2..fb83d22 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -141,7 +141,7 @@ extern unsigned long nr_running(void);
> extern unsigned long nr_uninterruptible(void);
> extern unsigned long nr_iowait(void);
> extern unsigned long nr_iowait_cpu(int cpu);
> -extern unsigned long this_cpu_load(void);
> +extern unsigned long nr_active_cpu(int cpu);
> 
> 
> extern void calc_global_load(unsigned long ticks);
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 39eb601..8cc2011 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2155,10 +2155,10 @@ unsigned long nr_iowait_cpu(int cpu)
> 	return atomic_read(&this->nr_iowait);
> }
> 
> -unsigned long this_cpu_load(void)
> +unsigned long nr_active_cpu(int cpu)
> {
> -	struct rq *this = this_rq();
> -	return this->cpu_load[0];
> +	struct rq *this = cpu_rq(cpu);
> +	return this->nr_active;
> }
> 
> 
> @@ -2494,6 +2494,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
> 	this_rq->nr_load_updates++;
> 
> 	/* Update our load: */
> +	this_rq->nr_active = this_rq->nr_running;
> 	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
> 	for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
> 		unsigned long old_load, new_load;
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index ba9dccf..2564712 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -379,6 +379,9 @@ struct rq {
> 	struct list_head leaf_rt_rq_list;
> #endif
> 
> +	/* nr_running last seen in __update_cpu_load() */
> +	unsigned long nr_active;
> +
> 	/*
> 	 * This is part of a global counter where only the total sum
> 	 * over all CPUs matters. A task can increase this counter on
> -- 
> 1.7.1
> 

