Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab2LLElr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 23:41:47 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59818 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab2LLElq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 23:41:46 -0500
Message-ID: <50C80ADF.8050504@linux.vnet.ibm.com>
Date: Wed, 12 Dec 2012 10:11:03 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: Re: [PATCH 08/18] sched: consider runnable load average in move_tasks
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <1355127754-8444-9-git-send-email-alex.shi@intel.com>
In-Reply-To: <1355127754-8444-9-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121204-5816-0000-0000-000005CD8E01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,
On 12/10/2012 01:52 PM, Alex Shi wrote:
> Except using runnable load average in background, move_tasks is also
> the key functions in load balance. We need consider the runnable load
> average in it in order to the apple to apple load comparison.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 6d893a6..bbb069c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3741,6 +3741,15 @@ static unsigned long task_h_load(struct task_struct *p);
>  
>  static const unsigned int sched_nr_migrate_break = 32;
>  
> +static unsigned long task_h_load_avg(struct task_struct *p)
> +{
> +	u32 period = p->se.avg.runnable_avg_period;
> +	if (!period)
> +		return 0;
> +
> +	return task_h_load(p) * p->se.avg.runnable_avg_sum / period;
                        ^^^^^^^^^^^^
This might result in an overflow,considering you are multiplying two 32
bit integers.Below is how this is handled in
__update_task_entity_contrib in kernel/sched/fair.c

u32 contrib;
/* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
contrib /= (se->avg.runnable_avg_period + 1);
se->avg.load_avg_contrib = scale_load(contrib);

Also why can't p->se.load_avg_contrib be used directly? as a return
value for task_h_load_avg? since this is already updated in
update_task_entity_contrib and update_group_entity_contrib.
> +}
> +
>  /*
>   * move_tasks tries to move up to imbalance weighted load from busiest to
>   * this_rq, as part of a balancing operation within domain "sd".
> @@ -3776,7 +3785,7 @@ static int move_tasks(struct lb_env *env)
>  		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
>  			goto next;
>  
> -		load = task_h_load(p);
> +		load = task_h_load_avg(p);
>  
>  		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
>  			goto next;
> 

Regards
Preeti U Murthy

