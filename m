Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab2KMVRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:17:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31170 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab2KMVRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:17:11 -0500
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_3A2DYtsFPYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=uakuW5ncBZAA:10 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8 a=a6akZcwmem_EKuyHJtcA:9 a=PUjeQqilurYA:10 a=xHGlPx4t150A:10 a=kqIustGqszkA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=LI9Vle30uBYA:10 a=Zh68SRI7RUMA:10 a=jbrJJM5MRmoA:10 a=2e6ZYRoF4I4A:10 a=2jTZwDku-5bvklKa:21 a=ZwVAnlze79fuq7Z8:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352841428.18025.45.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] irq_work: Fix racy check on work pending flag
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anish Kumar <anish198519851985@gmail.com>
Date: Tue, 13 Nov 2012 16:17:08 -0500
In-Reply-To: <1351877716-28911-2-git-send-email-fweisbec@gmail.com>
References: <1351877609-28856-1-git-send-email-fweisbec@gmail.com>
	 <1351877716-28911-1-git-send-email-fweisbec@gmail.com>
	 <1351877716-28911-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 18:35 +0100, Frederic Weisbecker wrote:
> Work claiming wants to be SMP-safe.
> 
> And by the time we try to claim a work, if it is already executing
> concurrently on another CPU, we want to succeed the claiming and queue
> the work again because the other CPU may have missed the data we wanted
> to handle in our work if it's about to complete there.
> 
> This scenario is summarized below:
> 
>         CPU 1                                   CPU 2
>         -----                                   -----
>         (flags = 0)
>         cmpxchg(flags, 0, IRQ_WORK_FLAGS)
>         (flags = 3)
>         [...]
>         xchg(flags, IRQ_WORK_BUSY)
>         (flags = 2)
>         func()
>                                                 if (flags & IRQ_WORK_PENDING)
>                                                         (not true)
>                                                 cmpxchg(flags, flags, IRQ_WORK_FLAGS)
>                                                 (flags = 3)
>                                                 [...]
>         cmpxchg(flags, IRQ_WORK_BUSY, 0);
>         (fail, pending on CPU 2)
> 
> This state machine is synchronized using [cmp]xchg() on the flags.
> As such, the early IRQ_WORK_PENDING check in CPU 2 above is racy.
> By the time we check it, we may be dealing with a stale value because
> we aren't using an atomic accessor. As a result, CPU 2 may "see"
> that the work is still pending on another CPU while it may be
> actually completing the work function exection already, leaving
> our data unprocessed.
> 
> To fix this, we start by speculating about the value we wish to be
> in the work->flags but we only make any conclusion after the value
> returned by the cmpxchg() call that either claims the work or let
> the current owner handle the pending work for us.
> 
> Changelog-heavily-inspired-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Anish Kumar <anish198519851985@gmail.com>
> ---
>  kernel/irq_work.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index 57be1a6..64eddd5 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -34,15 +34,21 @@ static DEFINE_PER_CPU(struct llist_head, irq_work_list);
>   */
>  static bool irq_work_claim(struct irq_work *work)
>  {
> -	unsigned long flags, nflags;
> +	unsigned long flags, oflags, nflags;
>  
> +	/*
> +	 * Start with our best wish as a premise but only trust any
> +	 * flag value after cmpxchg() result.
> +	 */
> +	flags = work->flags & ~IRQ_WORK_PENDING;
>  	for (;;) {
> -		flags = work->flags;
> -		if (flags & IRQ_WORK_PENDING)
> -			return false;
>  		nflags = flags | IRQ_WORK_FLAGS;
> -		if (cmpxchg(&work->flags, flags, nflags) == flags)
> +		oflags = cmpxchg(&work->flags, flags, nflags);
> +		if (oflags == flags)
>  			break;
> +		if (oflags & IRQ_WORK_PENDING)
> +			return false;
> +		flags = oflags;
>  		cpu_relax();
>  	}
>  


