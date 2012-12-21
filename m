Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab2LUPGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:06:02 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15782 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2LUPF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:05:57 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=qhS-nMSZf7AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Us6X52BAl8YA:10 a=c1Xaz6PBgEsprd19-VoA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356102354.5896.103.camel@gandalf.local.home>
Subject: Re: [PATCH 03/24] cputime: Allow dynamic switch between
 tick/virtual based cputime accounting
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 21 Dec 2012 10:05:54 -0500
In-Reply-To: <1356028391-14427-4-git-send-email-fweisbec@gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
	 <1356028391-14427-4-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-20 at 19:32 +0100, Frederic Weisbecker wrote:

> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index da0a9e7..e1fcab4 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -317,8 +317,6 @@ out:
>  	rcu_read_unlock();
>  }
>  
> -#ifndef CONFIG_VIRT_CPU_ACCOUNTING
> -
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>  /*
>   * Account a tick to a process and cpustat
> @@ -388,6 +386,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
>  						struct rq *rq) {}
>  #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
>  
> +#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
>  /*
>   * Account a single tick of cpu time.
>   * @p: the process that the cpu time gets accounted to
> @@ -398,6 +397,11 @@ void account_process_tick(struct task_struct *p, int user_tick)
>  	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
>  	struct rq *rq = this_rq();
>  
> +	if (vtime_accounting()) {
> +		vtime_account_user(p);
> +		return;
> +	}
> +
>  	if (sched_clock_irqtime) {
>  		irqtime_account_process_tick(p, user_tick, rq);
>  		return;
> @@ -439,29 +443,13 @@ void account_idle_ticks(unsigned long ticks)
>  
>  	account_idle_time(jiffies_to_cputime(ticks));
>  }
> -
>  #endif
>  
> +
>  /*
>   * Use precise platform statistics if available:
>   */
>  #ifdef CONFIG_VIRT_CPU_ACCOUNTING
> -void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
> -{
> -	*ut = p->utime;
> -	*st = p->stime;
> -}
> -
> -void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
> -{
> -	struct task_cputime cputime;
> -
> -	thread_group_cputime(p, &cputime);
> -
> -	*ut = cputime.utime;
> -	*st = cputime.stime;
> -}
> -
>  void vtime_account_system_irqsafe(struct task_struct *tsk)
>  {
>  	unsigned long flags;
> @@ -517,8 +505,25 @@ void vtime_account(struct task_struct *tsk)
>  }
>  EXPORT_SYMBOL_GPL(vtime_account);
>  #endif /* __ARCH_HAS_VTIME_ACCOUNT */
> +#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
>  
> -#else
> +#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
> +void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
> +{
> +	*ut = p->utime;
> +	*st = p->stime;
> +}
> +
> +void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
> +{
> +	struct task_cputime cputime;
> +
> +	thread_group_cputime(p, &cputime);
> +
> +	*ut = cputime.utime;
> +	*st = cputime.stime;
> +}
> +#else /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
>  
>  #ifndef nsecs_to_cputime
>  # define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
> @@ -548,6 +553,12 @@ static void cputime_adjust(struct task_cputime *curr,
>  {
>  	cputime_t rtime, utime, total;
>  
> +	if (vtime_accounting()) {
> +		*ut = curr->utime;
> +		*st = curr->stime;
> +		return;
> +	}
> +
>  	utime = curr->utime;
>  	total = utime + curr->stime;
>  
> @@ -601,6 +612,7 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
>  	thread_group_cputime(p, &cputime);
>  	cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
>  }
> +#endif /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */

Ah, the missing #endif gets added back here.

-- Steve

>  
>  #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
>  static DEFINE_PER_CPU(long, last_jiffies) = INITIAL_JIFFIES;
> @@ -642,6 +654,11 @@ void vtime_account_idle(struct task_struct *tsk)
>  	account_idle_time(delta_cpu);
>  }
>  
> +bool vtime_accounting(void)
> +{
> +	return context_tracking_active();
> +}
> +
>  static int __cpuinit vtime_cpu_notify(struct notifier_block *self,
>  				      unsigned long action, void *hcpu)
>  {
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index fb8e5e4..ad0e6fa 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -632,8 +632,11 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
>  
>  static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
>  {
> -#ifndef CONFIG_VIRT_CPU_ACCOUNTING
> +#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
>  	unsigned long ticks;
> +
> +	if (vtime_accounting())
> +		return;
>  	/*
>  	 * We stopped the tick in idle. Update process times would miss the
>  	 * time we slept as update_process_times does only a 1 tick


