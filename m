Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab2KOD7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 22:59:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19568 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab2KOD7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 22:59:43 -0500
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=dSWLLQtwMLwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=_2UvRtBX3U8A:10 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8 a=D7FtBBmPhq-9Irmde2wA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=2e6ZYRoF4I4A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352951981.18025.90.camel@gandalf.local.home>
Subject: Re: [PATCH 5/7] irq_work: Don't stop the tick with pending works
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 14 Nov 2012 22:59:41 -0500
In-Reply-To: <1352925457-15700-6-git-send-email-fweisbec@gmail.com>
References: <1352925457-15700-1-git-send-email-fweisbec@gmail.com>
	 <1352925457-15700-6-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 21:37 +0100, Frederic Weisbecker wrote:
> Don't stop the tick if we have pending irq works on the
> queue, otherwise if the arch can't raise self-IPIs, we may not
> find an opportunity to execute the pending works for a while.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  include/linux/irq_work.h |    6 ++++++
>  kernel/irq_work.c        |   11 +++++++++++
>  kernel/time/tick-sched.c |    3 ++-
>  3 files changed, 19 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
> index 6a9e8f5..a69704f 100644
> --- a/include/linux/irq_work.h
> +++ b/include/linux/irq_work.h
> @@ -20,4 +20,10 @@ bool irq_work_queue(struct irq_work *work);
>  void irq_work_run(void);
>  void irq_work_sync(struct irq_work *work);
>  
> +#ifdef CONFIG_IRQ_WORK
> +bool irq_work_needs_cpu(void);
> +#else
> +static bool irq_work_needs_cpu(void) { return false; }
> +#endif
> +
>  #endif /* _LINUX_IRQ_WORK_H */
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index 64eddd5..b3c113a 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -99,6 +99,17 @@ bool irq_work_queue(struct irq_work *work)
>  }
>  EXPORT_SYMBOL_GPL(irq_work_queue);
>  
> +bool irq_work_needs_cpu(void)
> +{
> +	struct llist_head *this_list;
> +
> +	this_list = &__get_cpu_var(irq_work_list);
> +	if (llist_empty(this_list))
> +		return false;
> +

I wounder if this should just be:

	return !llist_empty(&this_cpu_read(irq_work_list));

-- Steve


> +	return true;
> +}
> +
>  /*
>   * Run the irq_work entries on this cpu. Requires to be ran from hardirq
>   * context with local IRQs disabled.
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 9e945aa..f249e8c 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -20,6 +20,7 @@
>  #include <linux/profile.h>
>  #include <linux/sched.h>
>  #include <linux/module.h>
> +#include <linux/irq_work.h>
>  
>  #include <asm/irq_regs.h>
>  
> @@ -289,7 +290,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
>  	} while (read_seqretry(&xtime_lock, seq));
>  
>  	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) || printk_needs_cpu(cpu) ||
> -	    arch_needs_cpu(cpu)) {
> +	    arch_needs_cpu(cpu) || irq_work_needs_cpu()) {
>  		next_jiffies = last_jiffies + 1;
>  		delta_jiffies = 1;
>  	} else {


