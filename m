Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab3AIOyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:54:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5870 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3AIOyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:54:14 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XKXav5T6WuoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=KWSkTqdrn6sA:10 a=xlF9WQ4TmFDUzrlBv0gA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357743251.5190.57.camel@gandalf.local.home>
Subject: Re: [PATCH 06/33] cputime: Safely read cputime of full dynticks CPUs
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 09 Jan 2013 09:54:11 -0500
In-Reply-To: <1357610913-1080-7-git-send-email-fweisbec@gmail.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
	 <1357610913-1080-7-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-08 at 03:08 +0100, Frederic Weisbecker wrote:

> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 07912dd..bf4f72d 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -484,7 +484,7 @@ void vtime_task_switch(struct task_struct *prev)
>   * vtime_account().
>   */
>  #ifndef __ARCH_HAS_VTIME_ACCOUNT
> -void vtime_account(struct task_struct *tsk)
> +void vtime_account_irq_enter(struct task_struct *tsk)
>  {
>  	if (!in_interrupt()) {
>  		/*
> @@ -505,7 +505,7 @@ void vtime_account(struct task_struct *tsk)
>  	}
>  	vtime_account_system(tsk);
>  }
> -EXPORT_SYMBOL_GPL(vtime_account);
> +EXPORT_SYMBOL_GPL(vtime_account_irq_enter);
>  #endif /* __ARCH_HAS_VTIME_ACCOUNT */
>  #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
>  
> @@ -616,41 +616,67 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
>  #endif /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
>  
>  #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
> -static DEFINE_PER_CPU(long, last_jiffies) = INITIAL_JIFFIES;
> -
> -static cputime_t get_vtime_delta(void)
> +static cputime_t get_vtime_delta(struct task_struct *tsk)
>  {
>  	long delta;
>  
> -	delta = jiffies - __this_cpu_read(last_jiffies);
> -	__this_cpu_add(last_jiffies, delta);
> +	delta = jiffies - tsk->prev_jiffies;
> +	tsk->prev_jiffies += delta;
>  
>  	return jiffies_to_cputime(delta);
>  }
>  
> -void vtime_account_system(struct task_struct *tsk)
> +static void __vtime_account_system(struct task_struct *tsk)
>  {
> -	cputime_t delta_cpu = get_vtime_delta();
> +	cputime_t delta_cpu = get_vtime_delta(tsk);
>  
>  	account_system_time(tsk, irq_count(), delta_cpu, cputime_to_scaled(delta_cpu));
>  }
>  
> +void vtime_account_system(struct task_struct *tsk)
> +{
> +	write_seqlock(&tsk->vtime_seqlock);
> +	__vtime_account_system(tsk);

__vtime_account_system() calls account_system_time()
account_system_time() calls __account_system_time()
__account_system_time() calls acct_update_integrals()
(when CONFIG_TASK_XACCT is set)
acct_update_integrals() calls task_cputime()
task_cputime() grabs t->vtime_seqlock for read

 DEADLOCK

ironically the subject says *Safely* read cputime ;-)

-- Steve

> +	write_sequnlock(&tsk->vtime_seqlock);
> +}
> +
> +void vtime_account_irq_exit(struct task_struct *tsk)
> +{
> +	write_seqlock(&tsk->vtime_seqlock);
> +	if (context_tracking_in_user())
> +		tsk->prev_jiffies_whence = JIFFIES_USER;
> +	__vtime_account_system(tsk);
> +	write_sequnlock(&tsk->vtime_seqlock);
> +}
> +


