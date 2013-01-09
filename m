Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab3AIIWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:22:19 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:58142 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315Ab3AIIWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:22:15 -0500
Message-ID: <50ED286C.6070601@linux.vnet.ibm.com>
Date: Wed, 09 Jan 2013 13:51:00 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Alex Shi <alex.shi@intel.com>
Subject: Re: [PATCH] sched: Get rid of unnecessary checks from select_idle_sibling
References: <1357714256-24373-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1357714256-24373-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010908-2674-0000-0000-00000764896E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 12:20 PM, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> AFAICS @target cpu of select_idle_sibling() is always either prev_cpu
> or this_cpu.  So no need to check it again and the conditionals can be
> consolidated.
> 
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Alex Shi <alex.shi@intel.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/sched/fair.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 5eea8707234a..af665814c216 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3254,25 +3254,16 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>   */
>  static int select_idle_sibling(struct task_struct *p, int target)
>  {
> -	int cpu = smp_processor_id();
> -	int prev_cpu = task_cpu(p);
>  	struct sched_domain *sd;
>  	struct sched_group *sg;
>  	int i;
> 
>  	/*
> -	 * If the task is going to be woken-up on this cpu and if it is
> -	 * already idle, then it is the right target.
> -	 */
> -	if (target == cpu && idle_cpu(cpu))
> -		return cpu;
> -
> -	/*
> -	 * If the task is going to be woken-up on the cpu where it previously
> -	 * ran and if it is currently idle, then it the right target.
> +	 * If the task is going to be woken-up on this cpu or the cpu where it
> +	 * previously ran and it is already idle, then it is the right target.
>  	 */
> -	if (target == prev_cpu && idle_cpu(prev_cpu))
> -		return prev_cpu;
> +	if (idle_cpu(target))
> +		return target;
> 
>  	/*
>  	 * Otherwise, iterate the domains and find an elegible idle cpu.
> 
If NUMA_TTWU_BIAS or NUMA_TTWU_TO is true(it is false by
default),cpu/prev_cpu can be changed to be a random node_cpu(the node
that 'this_cpu' is on). In which case even if the node cpu is idle,it
would not be a viable target,looks like.Maybe that is why
select_idle_sibling() makes the check if the target is prev_cpu/this cpu.

Regards
Preeti U Murthy

