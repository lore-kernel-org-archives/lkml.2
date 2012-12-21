Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084Ab2LUFLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:11:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6679 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2LUFLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:11:42 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=BDNqrsFge44A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=-V7fij46oSQA:10 a=o1VdtP4Gw7yDHObwThwA:9 a=PUjeQqilurYA:10 a=4OhlYjbsDToTLMtN:21 a=rs3c4bfwSMBzanLP:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356066698.5896.90.camel@gandalf.local.home>
Subject: Re: [PATCH 02/24] cputime: Generic on-demand virtual cputime
 accounting
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
Date: Fri, 21 Dec 2012 00:11:38 -0500
In-Reply-To: <1356028391-14427-3-git-send-email-fweisbec@gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
	 <1356028391-14427-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-20 at 19:32 +0100, Frederic Weisbecker wrote:

> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 293b202..da0a9e7 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -3,6 +3,7 @@
>  #include <linux/tsacct_kern.h>
>  #include <linux/kernel_stat.h>
>  #include <linux/static_key.h>
> +#include <linux/context_tracking.h>
>  #include "sched.h"
>  
> 
> @@ -495,10 +496,24 @@ void vtime_task_switch(struct task_struct *prev)
>  #ifndef __ARCH_HAS_VTIME_ACCOUNT
>  void vtime_account(struct task_struct *tsk)
>  {
> -	if (in_interrupt() || !is_idle_task(tsk))
> -		vtime_account_system(tsk);
> -	else
> -		vtime_account_idle(tsk);
> +	if (!in_interrupt()) {
> +		/*
> +		 * If we interrupted user, context_tracking_in_user()
> +		 * is 1 because the context tracking don't hook
> +		 * on irq entry/exit. This way we know if
> +		 * we need to flush user time on kernel entry.
> +		 */
> +		if (context_tracking_in_user()) {
> +			vtime_account_user(tsk);
> +			return;
> +		}
> +
> +		if (is_idle_task(tsk)) {
> +			vtime_account_idle(tsk);
> +			return;
> +		}
> +	}
> +	vtime_account_system(tsk);
>  }
>  EXPORT_SYMBOL_GPL(vtime_account);
>  #endif /* __ARCH_HAS_VTIME_ACCOUNT */
> @@ -586,4 +601,72 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
>  	thread_group_cputime(p, &cputime);
>  	cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
>  }
> -#endif

Deleted #endif here.

> +
> +#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN

Added #ifdef here.

> +static DEFINE_PER_CPU(long, last_jiffies) = INITIAL_JIFFIES;
> +
> +static cputime_t get_vtime_delta(void)
> +{
> +	long delta;
> +
> +	delta = jiffies - __this_cpu_read(last_jiffies);
> +	__this_cpu_add(last_jiffies, delta);
> +
> +	return jiffies_to_cputime(delta);
> +}
> +
> +void vtime_account_system(struct task_struct *tsk)
> +{
> +	cputime_t delta_cpu = get_vtime_delta();
> +
> +	account_system_time(tsk, irq_count(), delta_cpu, cputime_to_scaled(delta_cpu));
> +}
> +
> +void vtime_account_user(struct task_struct *tsk)
> +{
> +	cputime_t delta_cpu = get_vtime_delta();
> +
> +	/*
> +	 * This is an unfortunate hack: if we flush user time only on
> +	 * irq entry, we miss the jiffies update and the time is spuriously
> +	 * accounted to system time.
> +	 */
> +	if (context_tracking_in_user())
> +		account_user_time(tsk, delta_cpu, cputime_to_scaled(delta_cpu));
> +}
> +
> +void vtime_account_idle(struct task_struct *tsk)
> +{
> +	cputime_t delta_cpu = get_vtime_delta();
> +
> +	account_idle_time(delta_cpu);
> +}
> +
> +static int __cpuinit vtime_cpu_notify(struct notifier_block *self,
> +				      unsigned long action, void *hcpu)
> +{
> +	long cpu = (long)hcpu;
> +	long *last_jiffies_cpu = per_cpu_ptr(&last_jiffies, cpu);
> +
> +	switch (action) {
> +	case CPU_UP_PREPARE:
> +	case CPU_UP_PREPARE_FROZEN:
> +		/*
> +		 * CHECKME: ensure that's visible by the CPU
> +		 * once it wakes up
> +		 */
> +		*last_jiffies_cpu = jiffies;
> +	default:
> +		break;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static int __init init_vtime(void)
> +{
> +	cpu_notifier(vtime_cpu_notify, 0);
> +	return 0;
> +}
> +early_initcall(init_vtime);
> +#endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */

Added #endif here

Hmm, missing #endif somewhere. Must explain my error message:

  kernel/sched/cputime.c:448:0: error: unterminated #else

Looks like a possible mismerge.

-- Steve



