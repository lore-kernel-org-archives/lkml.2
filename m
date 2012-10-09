Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2JIGVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:21:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64144 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab2JIGVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:21:40 -0400
Date: Mon, 8 Oct 2012 23:21:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tang Chen <tangchen@cn.fujitsu.com>
cc: mingo@redhat.com, peterz@infradead.org, miaox@cn.fujitsu.com,
        wency@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's
 node.
In-Reply-To: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1210082308230.360@chino.kir.corp.google.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2012, Tang Chen wrote:

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 66b36ab..e76dce9 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1263,18 +1263,24 @@ EXPORT_SYMBOL_GPL(kick_process);
>   */
>  static int select_fallback_rq(int cpu, struct task_struct *p)
>  {
> -	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
> +	int nid = cpu_to_node(cpu);
> +	const struct cpumask *nodemask = NULL;
>  	enum { cpuset, possible, fail } state = cpuset;
>  	int dest_cpu;
>  
> -	/* Look for allowed, online CPU in same node. */
> -	for_each_cpu(dest_cpu, nodemask) {
> -		if (!cpu_online(dest_cpu))
> -			continue;
> -		if (!cpu_active(dest_cpu))
> -			continue;
> -		if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
> -			return dest_cpu;
> +	/* If the cpu has been offlined, its nid was set to -1. */
> +	if (nid != -1) {

NUMA_NO_NODE.

Eek, the nid shouldn't be -1 yet, though, for cpu hotplug since this 
should be called at CPU_DYING level and migrate_tasks() still sees a valid 
cpu.

On x86, cpumask_of_node() is always guaranteed to return a valid cpumask 
after boot so presumably this is a problem in some non-x86 arch code and 
isn't actually a sched problem.

> +		nodemask = cpumask_of_node(nid);
> +
> +		/* Look for allowed, online CPU in same node. */
> +		for_each_cpu(dest_cpu, nodemask) {
> +			if (!cpu_online(dest_cpu))
> +				continue;
> +			if (!cpu_active(dest_cpu))
> +				continue;
> +			if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
> +				return dest_cpu;
> +		}
>  	}
>  
>  	for (;;) {
