Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab2CEPnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:43:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50814 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2CEPnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:43:23 -0500
Date: Mon, 5 Mar 2012 16:43:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tracing: Track preempt disabling
Message-ID: <20120305154314.GA3823@elte.hu>
References: <1330643053.25686.244.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330643053.25686.244.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Hi Ingo,
> 
> I've been maintaining your PREEMPT_TRACE patch from the old 
> latency tracer for a long time. It some how was dropped from 
> the -rt patchset that Thomas maintains. Recently it came in 
> very handy debugging some of the hotplug issues that I was 
> dealing with in the -rt patch, and I was thinking, why isn't 
> this in mainline?
> 
> I'm not the author of it, but I have modified it to keep it 
> working all these years, and even updated some of the 
> documentation/comments. But it is your patch, and I was 
> wondering if you would please add it to your tree for 3.4 
> merge window. Feel free to modify it, if there's something you 
> don't like about it. Like I said, it is your patch ;-)

Hm, I have no deep objections - I just never found it useful 
enough myself to mainline it.

> --- linux-trace.git.orig/include/linux/preempt.h
> +++ linux-trace.git/include/linux/preempt.h
> @@ -10,7 +10,8 @@
>  #include <linux/linkage.h>
>  #include <linux/list.h>
>  
> -#if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
> +#if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER) || \
> +	defined(CONFIG_PREEMPT_TRACE)
>    extern void add_preempt_count(int val);
>    extern void sub_preempt_count(int val);

Such patterns are really crying out loud for a helper Kconfig 
variable that all these tracing variants could set - and which 
preempt tracking code could then use instead of the a || b || c 
maze.

> --- linux-trace.git.orig/include/linux/sched.h
> +++ linux-trace.git/include/linux/sched.h
> @@ -1461,6 +1461,14 @@ struct task_struct {
>  	int softirqs_enabled;
>  	int softirq_context;
>  #endif
> +
> +#define MAX_PREEMPT_TRACE 25
> +#define MAX_LOCK_STACK	MAX_PREEMPT_TRACE
> +#ifdef CONFIG_PREEMPT_TRACE
> +	unsigned long preempt_trace_eip[MAX_PREEMPT_TRACE];
> +	unsigned long preempt_trace_parent_eip[MAX_PREEMPT_TRACE];
> +#endif

Now I remember another reason why I never mainlined it - the per 
task preempt-off stack seemed overkill. At minimum we should add 
a 'struct preempt_trace_entry' and stuff ip and parent_ip into 
it. (the whole patch should do a s/eip/ip rename)

Also, it might make sense to also encapsulate the above into a 
'struct preempt_trace_context' helper structure which is 
zero-sized normally, and not infest sched.h with any of the 
above details which really just the preempt tracing code should 
care about.

> +#ifdef CONFIG_PREEMPT_TRACE
> +void print_preempt_trace(struct task_struct *tsk);
> +#else
> +static inline void print_preempt_trace(struct task_struct *tsk) { }
> +#endif

This too should be hidden in a tracing header I guess.

>  #if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
> -				defined(CONFIG_PREEMPT_TRACER))
> +				defined(CONFIG_PREEMPT_TRACER) || \
> +				defined(CONFIG_PREEMPT_TRACE))

the new Kconfig switch could be used here.

> @@ -3030,6 +3034,15 @@ void __kprobes add_preempt_count(int val
>  		return;
>  #endif
>  	preempt_count() += val;
> +#ifdef CONFIG_PREEMPT_TRACE
> +	if (val <= 10) {

where does that '10' limit come from and why is it significant? 
I don't remember the details anymore.

> +		unsigned int idx = preempt_count() & PREEMPT_MASK;
> +		if (idx < MAX_PREEMPT_TRACE) {
> +			current->preempt_trace_eip[idx] = eip;
> +			current->preempt_trace_parent_eip[idx] = parent_eip;
> +		}

It might make sense to detach this structure from struct 
task_struct and allocate it on demand?


> +config PREEMPT_TRACE
> +	bool "Keep a record of preempt disabled locations"

'keep a per task record'

We already do preempt off tracing - just not on a per task 
stack/history basis.

> +	depends on DEBUG_KERNEL
> +	depends on PREEMPT
> +	select TRACING
> +	help
> +	  When enabled, it keeps track of the last 25 locations that disabled
> +	  preemption. This is useful to debug a "scheduling while atomic" error.
> +	  Sometimes it is hard to find what left preemption disabled, and this
> +	  utility can help.

This is somewhat inaccurate. What we maintain is the *stack* of 
preemption disabling, at most 25 levels deep.

In most common cases this will not trace back 25 locations that 
disabled preemption.

So, having read this patch once again, I now have an even lower 
opinion of it :-/

Firstly, it's somewhat superfluous, because in theory a perfect 
preempt on/off trace recording of the whole system is an 
equivalent replacement of it.

Secondly, we already have a nested execution stack: the lockdep 
held-locks stack. Could we perhaps extend *that* facility and 
allow it to (optionally) also print preempt off sections?

So, my opinion about it is a firm dunno.

Thanks,

	Ingo
