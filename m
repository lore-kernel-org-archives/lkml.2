Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab2J2O2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:28:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32701 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab2J2O2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:28:15 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=hRsL-1753NYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=HJ6F37ONaT0A:10 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8 a=5hiVd6c3ePlr2g4XzJ8A:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=2e6ZYRoF4I4A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351520894.8467.76.camel@gandalf.local.home>
Subject: Re: [RFC PATCH 7/9] irq_work: Make self-IPIs optable
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Mon, 29 Oct 2012 10:28:14 -0400
In-Reply-To: <1351517296-9173-8-git-send-email-fweisbec@gmail.com>
References: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
	 <1351517296-9173-8-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 14:28 +0100, Frederic Weisbecker wrote:
> On irq work initialization, let the user choose to define it
> as "lazy" or not. "Lazy" means that we don't want to send
> an IPI (provided the arch can anyway) when we enqueue this
> work but we rather prefer to wait for the next timer tick
> to execute our work if possible.
> 
> This is going to be a benefit for non-urgent enqueuers
> (like printk in the future) that may prefer not to raise
> an IPI storm in case of frequent enqueuing on short periods
> of time.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  include/linux/irq_work.h |   31 ++++++++++++++++++++++++++
>  kernel/irq_work.c        |   53 ++++++++++++++++++++++++++++++++-------------
>  kernel/time/tick-sched.c |    3 +-
>  3 files changed, 70 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
> index b39ea0b..7b60c87 100644
> --- a/include/linux/irq_work.h
> +++ b/include/linux/irq_work.h
> @@ -4,6 +4,20 @@
>  #include <linux/llist.h>
>  #include <asm/irq_work.h>
>  
> +/*
> + * An entry can be in one of four states:
> + *

Can you add a comment to what the pointer value is. I know you just
moved it to the header, but it's still confusing.


> + * free	     NULL, 0 -> {claimed}       : free to be used
> + * claimed   NULL, 3 -> {pending}       : claimed to be enqueued
> + * pending   next, 3 -> {busy}          : queued, pending callback
> + * busy      NULL, 2 -> {free, claimed} : callback in progress, can be claimed
> + */
> +
> +#define IRQ_WORK_PENDING	1UL
> +#define IRQ_WORK_BUSY		2UL
> +#define IRQ_WORK_FLAGS		3UL
> +#define IRQ_WORK_LAZY		4UL /* Doesn't want IPI, wait for tick */
> +
>  struct irq_work {
>  	unsigned long flags;
>  	struct llist_node llnode;
> @@ -17,8 +31,25 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
>  	work->func = func;
>  }
>  
> +#define DEFINE_IRQ_WORK(w, f)	\
> +	struct irq_work w = {	\
> +		.func = f,	\
> +	}
> +
> +#define DEFINE_IRQ_WORK_LAZY(w, f)	\
> +	struct irq_work w = {		\
> +		.flags = IRQ_WORK_LAZY, \
> +		.func = f,		\
> +	}
> +
>  bool irq_work_queue(struct irq_work *work);
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
> index d00011c..ce72b20 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -12,20 +12,10 @@
>  #include <linux/percpu.h>
>  #include <linux/hardirq.h>
>  #include <linux/irqflags.h>
> +#include <linux/tick.h>
> +#include <linux/sched.h>
>  #include <asm/processor.h>
>  
> -/*
> - * An entry can be in one of four states:
> - *
> - * free	     NULL, 0 -> {claimed}       : free to be used
> - * claimed   NULL, 3 -> {pending}       : claimed to be enqueued
> - * pending   next, 3 -> {busy}          : queued, pending callback
> - * busy      NULL, 2 -> {free, claimed} : callback in progress, can be claimed
> - */
> -
> -#define IRQ_WORK_PENDING	1UL
> -#define IRQ_WORK_BUSY		2UL
> -#define IRQ_WORK_FLAGS		3UL
>  
>  static DEFINE_PER_CPU(struct llist_head, irq_work_list);
>  
> @@ -66,10 +56,28 @@ static void __irq_work_queue(struct irq_work *work)
>  	preempt_disable();
>  
>  	empty = llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
> -	/* The list was empty, raise self-interrupt to start processing. */
> -	if (empty)
> +
> +	/*
> +	 * In any case, raise an IPI if requested and possible in case
> +	 * the queue is empty or it's filled with lazy works.
> +	 */
> +	if (!(work->flags & IRQ_WORK_LAZY) && arch_irq_work_has_ipi()) {
>  		arch_irq_work_raise();

Doesn't this mean that now if we queue up a bunch of work (say in
tracing), that we will send out an IPI for each queue? We only want to
send out an IPI if the list isn't empty. Perhaps we should make two
lists. One for lazy work and one for immediate work. Then, when adding a
non-lazy work item, we can check the empty variable for that. No need to
check the result for the lazy queue. That will be done during tick.

Perhaps then do:

	empty = false;

	if (work->flags & IRQ_WORK_LAZY)
		llist_add(&work->llnode, &__get_cpu_var(irq_work_lazy_list));
	else
		empty = llist_add(&work->llnode, &__get_cpu_var(irq_work_list));

	if (empty) {

	}

You can add your arch_irq_work_has_ipi() stuff as well.

-- Steve


> +		goto out;
> +	}llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
>  
> +	if (empty) {
> +		/*
> +		 * If the arch uses some other obscure way than IPI to raise
> +		 * an irq work, just raise and don't think further.
> +		 * Now if it can send an IPI, although not requested, and the tick
> +		 * is stopped, send it nonetheless otherwise we may wait a long while
> +		 * before that lazy work can run.
> +		 */
> +		if (!arch_irq_work_has_ipi() || tick_nohz_tick_stopped())
> +			arch_irq_work_raise();
> +	}
> +out:
>  	preempt_enable();
>  }
>  


