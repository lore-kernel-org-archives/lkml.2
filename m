Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab3AJL2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:28:21 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45243 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3AJL2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:28:19 -0500
Date: Thu, 10 Jan 2013 11:28:17 +0000
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 11/22] sched: consider runnable load average in
 effective_load
Message-ID: <20130110112817.GD2046@e103034-lin>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
 <1357375071-11793-12-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
In-Reply-To: <1357375071-11793-12-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 10 Jan 2013 11:28:13.0738 (UTC) FILETIME=[93E020A0:01CDEF25]
X-MC-Unique: 113011011281405601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 08:37:40AM +0000, Alex Shi wrote:
> effective_load calculates the load change as seen from the
> root_task_group. It needs to multiple cfs_rq's tg_runnable_contrib
> when we turn to runnable load average balance.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index cab62aa..247d6a8 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2982,7 +2982,8 @@ static void task_waking_fair(struct task_struct *p)
>  
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  /*
> - * effective_load() calculates the load change as seen from the root_task_group
> + * effective_load() calculates the runnable load average change as seen from
> + * the root_task_group
>   *
>   * Adding load to a group doesn't make a group heavier, but can cause movement
>   * of group shares between cpus. Assuming the shares were perfectly aligned one
> @@ -3030,13 +3031,17 @@ static void task_waking_fair(struct task_struct *p)
>   * Therefore the effective change in loads on CPU 0 would be 5/56 (3/8 - 2/7)
>   * times the weight of the group. The effect on CPU 1 would be -4/56 (4/8 -
>   * 4/7) times the weight of the group.
> + *
> + * After get effective_load of the load moving, will multiple the cpu own
> + * cfs_rq's runnable contrib of root_task_group.
>   */
>  static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
>  {
>  	struct sched_entity *se = tg->se[cpu];
>  
>  	if (!tg->parent)	/* the trivial, non-cgroup case */
> -		return wl;
> +		return wl * tg->cfs_rq[cpu]->tg_runnable_contrib
> +						>> NICE_0_SHIFT;

Why do we need to scale the load of the task (wl) by runnable_contrib
when the task is in the root task group? Wouldn't the load change still
just be wl?

>  
>  	for_each_sched_entity(se) {
>  		long w, W;
> @@ -3084,7 +3089,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
>  		wg = 0;
>  	}
>  
> -	return wl;
> +	return wl * tg->cfs_rq[cpu]->tg_runnable_contrib >> NICE_0_SHIFT;

I believe that effective_load() is only used in wake_affine() to compare
load scenarios of the same task group. Since the task group is the same
the effective load is scaled by the same factor and should not make any
difference?

Also, in wake_affine() the result of effective_load() is added with
target_load() which is load.weight of the cpu and not a tracked load
based on runnable_avg_*/contrib?

Finally, you have not scaled the result of effective_load() in the
function used when FAIR_GROUP_SCHED is disabled. Should that be scaled
too?

Morten

>  }
>  #else
>  
> -- 
> 1.7.12
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

