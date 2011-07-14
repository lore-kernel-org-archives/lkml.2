Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab1GNWCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:02:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65083 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab1GNWCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:02:39 -0400
Date: Fri, 15 Jul 2011 00:02:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/6] trace: Add tracepoints to reschedule interrupt
 handler
Message-ID: <20110714220233.GC26786@somewhere.redhat.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
 <1310679495-29104-5-git-send-email-vnagarnaik@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310679495-29104-5-git-send-email-vnagarnaik@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me. But I'm adding Peter in Cc.

On Thu, Jul 14, 2011 at 02:38:13PM -0700, Vaibhav Nagarnaik wrote:
> This is a part of overall effort to trace all the interrupts happening
> in a system to figure out what time is spent in kernel space versus user
> space.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  include/trace/events/irq.h |   45 ++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched.c             |    4 +++
>  2 files changed, 49 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
> index d8fab89..a2a0a49 100644
> --- a/include/trace/events/irq.h
> +++ b/include/trace/events/irq.h
> @@ -339,6 +339,51 @@ DEFINE_EVENT(irq_work, irq_work_run_exit,
>  	TP_ARGS(ignore)
>  );
>  
> +DECLARE_EVENT_CLASS(reschedule_interrupt,
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
> + * reschedule_interrupt_entry - called immediately after entering the
> + * reschedule interrupt handler
> + *
> + * When used in combination with the reschedule_interrupt_exit tracepoint
> + * we can determine the reschedule interrupt handler runtime.
> + */
> +DEFINE_EVENT(reschedule_interrupt, reschedule_interrupt_entry,
> +
> +	TP_PROTO(unsigned int ignore),
> +
> +	TP_ARGS(ignore)
> +);
> +
> +/**
> + * reschedule_interrupt_exit - called just before the reschedule interrupt
> + * handler returns
> + *
> + * When used in combination with the reschedule_interrupt_entry tracepoint
> + * we can determine the reschedule interrupt handler runtime.
> + */
> +DEFINE_EVENT(reschedule_interrupt, reschedule_interrupt_exit,
> +
> +	TP_PROTO(unsigned int ignore),
> +
> +	TP_ARGS(ignore)
> +);
> +
>  #endif /*  _TRACE_IRQ_H */
>  
>  /* This part must be outside protection */
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 9769c75..605c938 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -79,6 +79,8 @@
>  #include "sched_cpupri.h"
>  #include "workqueue_sched.h"
>  #include "sched_autogroup.h"
> +#include <trace/events/irq.h>
> +
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/sched.h>
> @@ -2565,7 +2567,9 @@ static void sched_ttwu_pending(void)
>  
>  void scheduler_ipi(void)
>  {
> +	trace_reschedule_interrupt_entry(0);
>  	sched_ttwu_pending();
> +	trace_reschedule_interrupt_exit(0);
>  }
>  
>  static void ttwu_queue_remote(struct task_struct *p, int cpu)
> -- 
> 1.7.3.1
> 
