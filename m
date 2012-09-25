Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab2IYR5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 13:57:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34120 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab2IYR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 13:57:01 -0400
Date: Tue, 25 Sep 2012 10:56:57 -0700
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, paul.mckenney@linaro.org,
        tglx@linutronix.de, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH 3/3] workqueue: Schedule work on non-idle cpu instead
 of current one
Message-ID: <20120925175657.GB16296@google.com>
References: <cover.1348568074.git.viresh.kumar@linaro.org>
 <3232b3192e2e373cc4aaf43359d454c5ad53cddb.1348568074.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3232b3192e2e373cc4aaf43359d454c5ad53cddb.1348568074.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 25, 2012 at 04:06:08PM +0530, Viresh Kumar wrote:
> +config MIGRATE_WQ
> +	bool "(EXPERIMENTAL) Migrate Workqueues to non-idle cpu"
> +	depends on SMP && EXPERIMENTAL
> +	help
> +	  Workqueues queues work on current cpu, if the caller haven't passed a
> +	  preferred cpu. This may wake up an idle CPU, which is actually not
> +	  required. This work can be processed by any CPU and so we must select
> +	  a non-idle CPU here.  This patch adds in support in workqueue
> +	  framework to get preferred CPU details from the scheduler, instead of
> +	  using current CPU.

I don't think it's a good idea to make behavior like this a config
option.  The behavior difference is subtle and may induce incorrect
behavior.

> +/* This enables migration of a work to a non-IDLE cpu instead of current cpu */
> +#ifdef CONFIG_MIGRATE_WQ
> +static int wq_select_cpu(void)
> +{
> +	return sched_select_cpu(SD_NUMA, -1);
> +}
> +#else
> +#define wq_select_cpu()		smp_processor_id()
> +#endif
> +
>  /* Serializes the accesses to the list of workqueues. */
>  static DEFINE_SPINLOCK(workqueue_lock);
>  static LIST_HEAD(workqueues);
> @@ -995,7 +1005,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
>  		struct global_cwq *last_gcwq;
>  
>  		if (unlikely(cpu == WORK_CPU_UNBOUND))
> -			cpu = raw_smp_processor_id();
> +			cpu = wq_select_cpu();
>  
>  		/*
>  		 * It's multi cpu.  If @wq is non-reentrant and @work
> @@ -1066,8 +1076,9 @@ int queue_work(struct workqueue_struct *wq, struct work_struct *work)
>  {
>  	int ret;
>  
> -	ret = queue_work_on(get_cpu(), wq, work);
> -	put_cpu();
> +	preempt_disable();
> +	ret = queue_work_on(wq_select_cpu(), wq, work);
> +	preempt_enable();

First of all, I'm not entirely sure this is safe.  queue_work() used
to *guarantee* that the work item would execute on the local CPU.  I
don't think there are many which depend on that but I'd be surprised
if this doesn't lead to some subtle problems somewhere.  It might not
be realistic to audit all users and we might have to just let it
happen and watch for the fallouts.  Dunno, still wanna see some level
of auditing.

Also, I'm wondering why this is necessary at all for workqueues.  For
schedule/queue_work(), you pretty much know the current cpu is not
idle.  For delayed workqueue, sure but for immediate scheduling, why?

Thanks.

-- 
tejun
