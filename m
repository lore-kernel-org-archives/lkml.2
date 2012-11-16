Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab2KPQJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:09:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7249 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab2KPQJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:09:45 -0500
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=YI9JNWQxKtAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=mFLw-idZFWUA:10 a=LHvCI0dHU1p9FsTZJWEA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1353082183.7586.19.camel@gandalf.local.home>
Subject: Re: [PATCH 8/9] irq_work: Make self-IPIs optable
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Fri, 16 Nov 2012 11:09:43 -0500
In-Reply-To: <1353032491-16462-9-git-send-email-fweisbec@gmail.com>
References: <1353032491-16462-1-git-send-email-fweisbec@gmail.com>
	 <1353032491-16462-9-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 03:21 +0100, Frederic Weisbecker wrote:
>  
>  /*
>   * Claim the entry so that no one else will poke at it.
> @@ -68,14 +59,18 @@ void __weak arch_irq_work_raise(void)
>   */
>  static void __irq_work_queue(struct irq_work *work)
>  {
> -	bool empty;
> -
>  	preempt_disable();
>  
> -	empty = llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
> -	/* The list was empty, raise self-interrupt to start processing. */
> -	if (empty)
> -		arch_irq_work_raise();
> +	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
> +
> +	/*
> +	 * If the work is flagged as "lazy", just wait for the next tick
> +	 * to run it. Otherwise, or if the tick is stopped, raise the irq work.

Speaking more Greek? ;-)

How about:

	If the work is not "lazy" or the tick is stopped, raise the irq
	work interrupt (if supported by the arch), otherwise, just wait
	for the next tick.

Other than that, Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> +	 */
> +	if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
> +		if (!this_cpu_cmpxchg(irq_work_raised, 0, 1))
> +			arch_irq_work_raise();
> +	}
>  


