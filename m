Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2IXJjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:39:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36033 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab2IXJjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:39:08 -0400
Message-ID: <1348479536.11847.25.camel@twins>
Subject: Re: [PATCH] Update sched_domains_numa_masks when new cpus are
 onlined.
From: Peter Zijlstra <peterz@infradead.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-numa@vger.kernel.org,
        wency@cn.fujitsu.com, mingo@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 24 Sep 2012 11:38:56 +0200
In-Reply-To: <1347963128-25942-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1347963128-25942-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why are you cc'ing x86 and numa folks but not a single scheduler person
when you're patching scheduler stuff?

On Tue, 2012-09-18 at 18:12 +0800, Tang Chen wrote:
> Once array sched_domains_numa_masks is defined, it is never updated.
> When a new cpu on a new node is onlined,

Hmm, so there's hardware where you can boot with smaller nr_node_ids
than possible.. I guess that makes sense.

>  the coincident member in
> sched_domains_numa_masks is not initialized, and all the masks are 0.
> As a result, the build_overlap_sched_groups() will initialize a NULL
> sched_group for the new cpu on the new node, which will lead to kernel panic.

<snip>

> This patch registers a new notifier for cpu hotplug notify chain, and
> updates sched_domains_numa_masks every time a new cpu is onlined or offlined.

Urgh, more hotplug notifiers.. a well.

> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  kernel/sched/core.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 62 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index fbf1fd0..66b36ab 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6711,6 +6711,14 @@ static void sched_init_numa(void)
>  	 * numbers.
>  	 */
>  
> +	/*
> +	 * Since sched_domains_numa_levels is also used in other functions as
> +	 * an index for sched_domains_numa_masks[][], we should reset it here in
> +	 * case sched_domains_numa_masks[][] fails to be initialized. And set it
> +	 * to 'level' when sched_domains_numa_masks[][] is fully initialized.
> +	 */
> +	sched_domains_numa_levels = 0;

This isn't strictly needed for this patch right? I don't see anybody
calling sched_init_numa() a second time (although they should)..

>  	sched_domains_numa_masks = kzalloc(sizeof(void *) * level, GFP_KERNEL);
>  	if (!sched_domains_numa_masks)
>  		return;
> @@ -6765,11 +6773,64 @@ static void sched_init_numa(void)
>  	}
>  
>  	sched_domain_topology = tl;
> +
> +	sched_domains_numa_levels = level;
> +}
> +
> +static void sched_domains_numa_masks_set(int cpu)
> +{
> +	int i, j;
> +	int node = cpu_to_node(cpu);
> +
> +	for (i = 0; i < sched_domains_numa_levels; i++)
> +		for (j = 0; j < nr_node_ids; j++)
> +			if (node_distance(j, node) <= sched_domains_numa_distance[i])
> +				cpumask_set_cpu(cpu, sched_domains_numa_masks[i][j]);
> +}
> +
> +static void sched_domains_numa_masks_clear(int cpu)
> +{
> +	int i, j;
> +	for (i = 0; i < sched_domains_numa_levels; i++)
> +		for (j = 0; j < nr_node_ids; j++)
> +			cpumask_clear_cpu(cpu, sched_domains_numa_masks[i][j]);
> +}

Aside from the coding style nit of wanting braces over multi-line
statements even though not strictly required, I really don't see how
this could possibly be right.. 

We do this because nr_node_ids changed, right? This means the entire
distance table grew/shrunk, which means we should do the level scan
again.

> @@ -7218,6 +7279,7 @@ void __init sched_init_smp(void)
>         mutex_unlock(&sched_domains_mutex);
>         put_online_cpus();
>  
> +       hotcpu_notifier(sched_domains_numa_masks_update, CPU_PRI_SCHED_ACTIVE);
>         hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
>         hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);

OK, so you really want your notifier to run before cpuset_cpu_active
because otherwise you get that crash, yet you fail with the whole order
thing.. You should not _ever_ rely on registration order.

