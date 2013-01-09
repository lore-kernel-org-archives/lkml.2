Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab3AIHdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 02:33:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:56106 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab3AIHdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 02:33:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,435,1355126400"; 
   d="scan'208";a="274591514"
Message-ID: <50ED1D54.70208@intel.com>
Date: Wed, 09 Jan 2013 15:33:40 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Mike Galbraith <efault@gmx.de>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] sched: Get rid of unnecessary checks from select_idle_sibling
References: <1357714256-24373-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1357714256-24373-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 02:50 PM, Namhyung Kim wrote:
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

Uh, we don't know if the target is this_cpu or previous cpu, If we just
check the target idle status, we may miss another idle cpu. So this
patch change the logical in this function.

>  
>  	/*
>  	 * Otherwise, iterate the domains and find an elegible idle cpu.
> 


-- 
Thanks Alex
