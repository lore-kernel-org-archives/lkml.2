Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455Ab2JYHsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:48:24 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39317 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab2JYHsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:48:22 -0400
Date: Thu, 25 Oct 2012 09:48:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 2/5] vtime: Provide an irq safe version of
 vtime_account_system()
Message-ID: <20121025074815.GC3712@gmail.com>
References: <1351126313-17804-1-git-send-email-fweisbec@gmail.com>
 <1351126313-17804-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351126313-17804-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've Cc:-ed the S390 folks - patch is quoted below.

Thanks,

	Ingo

* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> vtime_account_system() currently has only one caller with
> vtime_account() that is irq safe.
> 
> Now we are going to call it from other places like kvm, so
> let's provide an irqsafe version.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  arch/s390/kernel/vtime.c |    4 ++++
>  include/linux/vtime.h    |    2 ++
>  kernel/sched/cputime.c   |    9 +++++++++
>  3 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
> index 7903344..80d1dbc 100644
> --- a/arch/s390/kernel/vtime.c
> +++ b/arch/s390/kernel/vtime.c
> @@ -140,6 +140,10 @@ void vtime_account(struct task_struct *tsk)
>  }
>  EXPORT_SYMBOL_GPL(vtime_account);
>  
> +void vtime_account_system(struct task_struct *tsk)
> +__attribute__((alias("vtime_account")));
> +EXPORT_SYMBOL_GPL(vtime_account_system);
> +
>  void __kprobes vtime_stop_cpu(void)
>  {
>  	struct s390_idle_data *idle = &__get_cpu_var(s390_idle);
> diff --git a/include/linux/vtime.h b/include/linux/vtime.h
> index 7199c24..57f290e 100644
> --- a/include/linux/vtime.h
> +++ b/include/linux/vtime.h
> @@ -6,9 +6,11 @@ struct task_struct;
>  #ifdef CONFIG_VIRT_CPU_ACCOUNTING
>  extern void vtime_task_switch(struct task_struct *prev);
>  extern void vtime_account_system(struct task_struct *tsk);
> +extern void vtime_account_system_irqsafe(struct task_struct *tsk);
>  extern void vtime_account_idle(struct task_struct *tsk);
>  #else
>  static inline void vtime_task_switch(struct task_struct *prev) { }
> +static inline void vtime_account_system_irqsafe(struct task_struct *tsk) { }
>  #endif
>  
>  #if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 81b763b..3ccbea0 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -433,6 +433,15 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
>  	*st = cputime.stime;
>  }
>  
> +void vtime_account_system_irqsafe(struct task_struct *tsk)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	vtime_account_system(tsk);
> +	local_irq_restore(flags);
> +}
> +
>  /*
>   * Archs that account the whole time spent in the idle task
>   * (outside irq) as idle time can rely on this and just implement
> -- 
> 1.7.5.4
> 
