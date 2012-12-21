Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab2LUEfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 23:35:47 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51027 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LUEfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 23:35:42 -0500
X-AuditID: 9c930179-b7becae000000e51-ad-50d3e71d402c
From: Namhyung Kim <namhyung@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, rob@landley.net,
        mingo@redhat.com, peterz@infradead.org, gregkh@linuxfoundation.org,
        andre.przywara@amd.com, rjw@sisk.pl, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        vincent.guittot@linaro.org
Subject: Re: [PATCH 07/18] sched: compute runnable load avg in cpu_load and cpu_avg_load_per_task
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
	<1355127754-8444-8-git-send-email-alex.shi@intel.com>
	<50C800B5.1080205@linux.vnet.ibm.com> <50C995B8.6020801@intel.com>
Date: Fri, 21 Dec 2012 13:35:40 +0900
In-Reply-To: <50C995B8.6020801@intel.com> (Alex Shi's message of "Thu, 13 Dec
	2012 16:45:44 +0800")
Message-ID: <87623wf2eb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2012 16:45:44 +0800, Alex Shi wrote:
> On 12/12/2012 11:57 AM, Preeti U Murthy wrote:
>> Hi Alex,
>> On 12/10/2012 01:52 PM, Alex Shi wrote:
>>> They are the base values in load balance, update them with rq runnable
>>> load average, then the load balance will consider runnable load avg
>>> naturally.
>>>
>
> updated with UP config fix:
>
>
> ==========
>> From d271c93b40411660dd0e54d99946367c87002cc8 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Sat, 17 Nov 2012 13:56:11 +0800
> Subject: [PATCH 07/18] sched: compute runnable load avg in cpu_load and
>  cpu_avg_load_per_task
>
> They are the base values in load balance, update them with rq runnable
> load average, then the load balance will consider runnable load avg
> naturally.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/core.c | 8 ++++++--
>  kernel/sched/fair.c | 4 ++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 96fa5f1..d306a84 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2487,7 +2487,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>  void update_idle_cpu_load(struct rq *this_rq)
>  {
>  	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
> -	unsigned long load = this_rq->load.weight;
> +	unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;

So shouldn't this line be guarded with CONFIG_SMP too?

Thanks,
Namhyung


>  	unsigned long pending_updates;
>  
>  	/*
> @@ -2537,8 +2537,12 @@ static void update_cpu_load_active(struct rq *this_rq)
>  	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
>  	 */
>  	this_rq->last_load_update_tick = jiffies;
> -	__update_cpu_load(this_rq, this_rq->load.weight, 1);
>  
> +#ifdef CONFIG_SMP
> +	__update_cpu_load(this_rq, this_rq->cfs.runnable_load_avg, 1);
> +#else
> +	__update_cpu_load(this_rq, this_rq->load.weight, 1);
> +#endif
>  	calc_load_account_active(this_rq);
>  }
