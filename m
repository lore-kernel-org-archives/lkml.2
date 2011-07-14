Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab1GNWJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:09:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44781 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1GNWJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:09:51 -0400
Date: Fri, 15 Jul 2011 00:09:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 3/6] trace: Add tracepoints to IRQ work run handler
Message-ID: <20110714220944.GE26786@somewhere.redhat.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
 <1310679495-29104-4-git-send-email-vnagarnaik@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310679495-29104-4-git-send-email-vnagarnaik@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 02:38:12PM -0700, Vaibhav Nagarnaik wrote:
> This is a part of overall effort to trace all the interrupts happening
> in a system to figure out what time is spent in kernel space versus user
> space.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  include/trace/events/irq.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  kernel/irq_work.c          |    4 ++++
>  2 files changed, 48 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
> index e6e72e0..d8fab89 100644
> --- a/include/trace/events/irq.h
> +++ b/include/trace/events/irq.h
> @@ -295,6 +295,50 @@ DEFINE_EVENT(timer_interrupt, timer_nohz_exit,
>  	TP_ARGS(ignore)
>  );
>  
> +DECLARE_EVENT_CLASS(irq_work,
> +
> +	TP_PROTO(unsigned int ignore),
> +
> +	TP_ARGS(ignore),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned int,	ignore	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->ignore = ignore;
> +	),
> +
> +	TP_printk("%u", __entry->ignore)
> +);
> +
> +/**
> + * irq_work_run_entry - called immediately after entering the irq work
> + * handler
> + *
> + * When used in combination with the irq_work_run_exit tracepoint
> + * we can determine the irq work handler runtime.
> + */
> +DEFINE_EVENT(irq_work, irq_work_run_entry,
> +
> +	TP_PROTO(unsigned int ignore),
> +
> +	TP_ARGS(ignore)
> +);
> +
> +/**
> + * irq_work_run_exit - called just before the irq work handler returns
> + *
> + * When used in combination with the irq_work_run_entry tracepoint
> + * we can determine the irq work handler runtime.
> + */
> +DEFINE_EVENT(irq_work, irq_work_run_exit,
> +
> +	TP_PROTO(unsigned int ignore),
> +
> +	TP_ARGS(ignore)
> +);
> +
>  #endif /*  _TRACE_IRQ_H */
>  
>  /* This part must be outside protection */
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index c58fa7d..7e78122 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -9,6 +9,7 @@
>  #include <linux/module.h>
>  #include <linux/irq_work.h>
>  #include <linux/hardirq.h>
> +#include <trace/events/irq.h>
>  
>  /*
>   * An entry can be in one of four states:
> @@ -125,6 +126,8 @@ void irq_work_run(void)
>  	if (this_cpu_read(irq_work_list) == NULL)
>  		return;

If you don't want to miss any of these interrupts, I suggest you
call trace_irq_work_run_entry(0) before the above check.

Also I'm adding Peter who maintains this.

>  
> +	trace_irq_work_run_entry(0);
> +
>  	BUG_ON(!in_irq());
>  	BUG_ON(!irqs_disabled());
>  
> @@ -149,6 +152,7 @@ void irq_work_run(void)
>  			      next_flags(NULL, IRQ_WORK_BUSY),
>  			      NULL);
>  	}
> +	trace_irq_work_run_exit(0);
>  }
>  EXPORT_SYMBOL_GPL(irq_work_run);
>  
> -- 
> 1.7.3.1
> 
