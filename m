Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2LLD6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 22:58:38 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58890 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab2LLD6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 22:58:37 -0500
Message-ID: <50C800B5.1080205@linux.vnet.ibm.com>
Date: Wed, 12 Dec 2012 09:27:41 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: Re: [PATCH 07/18] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <1355127754-8444-8-git-send-email-alex.shi@intel.com>
In-Reply-To: <1355127754-8444-8-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121203-1618-0000-0000-00000302C00C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,
On 12/10/2012 01:52 PM, Alex Shi wrote:
> They are the base values in load balance, update them with rq runnable
> load average, then the load balance will consider runnable load avg
> naturally.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/core.c |    4 ++--
>  kernel/sched/fair.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 96fa5f1..0ecb907 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2487,7 +2487,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>  void update_idle_cpu_load(struct rq *this_rq)
>  {
>  	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
> -	unsigned long load = this_rq->load.weight;
> +	unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;
>  	unsigned long pending_updates;
>  
>  	/*
> @@ -2537,7 +2537,7 @@ static void update_cpu_load_active(struct rq *this_rq)
>  	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
>  	 */
>  	this_rq->last_load_update_tick = jiffies;
> -	__update_cpu_load(this_rq, this_rq->load.weight, 1);
> +	__update_cpu_load(this_rq, this_rq->cfs.runnable_load_avg, 1);
>  
>  	calc_load_account_active(this_rq);
>  }
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 61c8d24..6d893a6 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2680,7 +2680,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  /* Used instead of source_load when we know the type == 0 */
>  static unsigned long weighted_cpuload(const int cpu)
>  {
> -	return cpu_rq(cpu)->load.weight;
> +	return (unsigned long)cpu_rq(cpu)->cfs.runnable_load_avg;

I was wondering why you have typecasted the cfs.runnable_load_avg to
unsigned long.Have you looked into why it was declared as u64 in the
first place?

>  }
>  
>  /*
> @@ -2727,7 +2727,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
>  	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
>  
>  	if (nr_running)
> -		return rq->load.weight / nr_running;
> +		return rq->cfs.runnable_load_avg / nr_running;

rq->cfs.runnable_load_avg is u64 type.you will need to typecast it here
also right? how does this division work? because the return type is
unsigned long.
>  
>  	return 0;
>  }
> 

Regards
Preeti U Murthy

