Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab1EZQym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:54:42 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35694 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472Ab1EZQyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:54:41 -0400
Date: Thu, 26 May 2011 09:54:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Subject: Re: [PATCH 12/12] ftrace: Add internal recursive checks
Message-ID: <20110526165424.GD2386@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110526152541.995963172@goodmis.org>
 <20110526152958.961788971@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526152958.961788971@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 11:25:54AM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Witold reported a reboot caused by the selftests of the dynamic function
> tracer. He sent me a config and I used ktest to do a config_bisect on it
> (as my config did not cause the crash). It pointed out that the problem
> config was CONFIG_PROVE_RCU.
> 
> What happened was that if multiple callbacks are attached to the
> function tracer, we iterate a list of callbacks. Because the list is
> managed by synchronize_sched() and preempt_disable, the access to the
> pointers uses rcu_dereference_raw().
> 
> When PROVE_RCU is enabled, the rcu_dereference_raw() calls some
> debugging functions, which happen to be traced. The tracing of the debug
> function would then call rcu_dereference_raw() which would then call the
> debug function and then... well you get the idea.
> 
> I first wrote two different patches to solve this bug.
> 
> 1) add a __rcu_dereference_raw() that would not do any checks.
> 2) add notrace to the offending debug functions.
> 
> Both of these patches worked.
> 
> Talking with Paul McKenney on IRC, he suggested to add recursion
> detection instead. This seemed to be a better solution, so I decided to
> implement it. As the task_struct already has a trace_recursion to detect
> recursion in the ring buffer, and that has a very small number it
> allows, I decided to use that same variable to add flags that can detect
> the recursion inside the infrastructure of the function tracer.
> 
> I plan to change it so that the task struct bit can be checked in
> mcount, but as that requires changes to all archs, I will hold that off
> to the next merge window.

Looks good to me.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Link: http://lkml.kernel.org/r/1306348063.1465.116.camel@gandalf.stny.rr.com
> Reported-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/sched.h      |    2 +-
>  kernel/trace/ftrace.c      |   13 ++++++++++++-
>  kernel/trace/ring_buffer.c |   10 +++++-----
>  kernel/trace/trace.h       |   15 +++++++++++++++
>  4 files changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index d8b2d0b..7b78d9c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1513,7 +1513,7 @@ struct task_struct {
>  #ifdef CONFIG_TRACING
>  	/* state flags for use by tracers */
>  	unsigned long trace;
> -	/* bitmask of trace recursion */
> +	/* bitmask and counter of trace recursion */
>  	unsigned long trace_recursion;
>  #endif /* CONFIG_TRACING */
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR /* memcg uses this to do batch job */
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 25949b3..1ee417f 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -109,12 +109,18 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
>  static void ftrace_global_list_func(unsigned long ip,
>  				    unsigned long parent_ip)
>  {
> -	struct ftrace_ops *op = rcu_dereference_raw(ftrace_global_list); /*see above*/
> +	struct ftrace_ops *op;
> +
> +	if (unlikely(trace_recursion_test(TRACE_GLOBAL_BIT)))
> +		return;
> 
> +	trace_recursion_set(TRACE_GLOBAL_BIT);
> +	op = rcu_dereference_raw(ftrace_global_list); /*see above*/
>  	while (op != &ftrace_list_end) {
>  		op->func(ip, parent_ip);
>  		op = rcu_dereference_raw(op->next); /*see above*/
>  	};
> +	trace_recursion_clear(TRACE_GLOBAL_BIT);
>  }
> 
>  static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip)
> @@ -3490,6 +3496,10 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
>  {
>  	struct ftrace_ops *op;
> 
> +	if (unlikely(trace_recursion_test(TRACE_INTERNAL_BIT)))
> +		return;
> +
> +	trace_recursion_set(TRACE_INTERNAL_BIT);
>  	/*
>  	 * Some of the ops may be dynamically allocated,
>  	 * they must be freed after a synchronize_sched().
> @@ -3502,6 +3512,7 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
>  		op = rcu_dereference_raw(op->next);
>  	};
>  	preempt_enable_notrace();
> +	trace_recursion_clear(TRACE_INTERNAL_BIT);
>  }
> 
>  static void clear_ftrace_swapper(void)
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 0ef7b4b..b0c7aa4 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2216,7 +2216,7 @@ static noinline void trace_recursive_fail(void)
> 
>  	printk_once(KERN_WARNING "Tracing recursion: depth[%ld]:"
>  		    "HC[%lu]:SC[%lu]:NMI[%lu]\n",
> -		    current->trace_recursion,
> +		    trace_recursion_buffer(),
>  		    hardirq_count() >> HARDIRQ_SHIFT,
>  		    softirq_count() >> SOFTIRQ_SHIFT,
>  		    in_nmi());
> @@ -2226,9 +2226,9 @@ static noinline void trace_recursive_fail(void)
> 
>  static inline int trace_recursive_lock(void)
>  {
> -	current->trace_recursion++;
> +	trace_recursion_inc();
> 
> -	if (likely(current->trace_recursion < TRACE_RECURSIVE_DEPTH))
> +	if (likely(trace_recursion_buffer() < TRACE_RECURSIVE_DEPTH))
>  		return 0;
> 
>  	trace_recursive_fail();
> @@ -2238,9 +2238,9 @@ static inline int trace_recursive_lock(void)
> 
>  static inline void trace_recursive_unlock(void)
>  {
> -	WARN_ON_ONCE(!current->trace_recursion);
> +	WARN_ON_ONCE(!trace_recursion_buffer());
> 
> -	current->trace_recursion--;
> +	trace_recursion_dec();
>  }
> 
>  #else
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 6b69c4b..229f859 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -784,4 +784,19 @@ extern const char *__stop___trace_bprintk_fmt[];
>  	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
>  #include "trace_entries.h"
> 
> +/* Only current can touch trace_recursion */
> +#define trace_recursion_inc() do { (current)->trace_recursion++; } while (0)
> +#define trace_recursion_dec() do { (current)->trace_recursion--; } while (0)
> +
> +/* Ring buffer has the 10 LSB bits to count */
> +#define trace_recursion_buffer() ((current)->trace_recursion & 0x3ff)
> +
> +/* for function tracing recursion */
> +#define TRACE_INTERNAL_BIT		(1<<11)
> +#define TRACE_GLOBAL_BIT		(1<<12)
> +
> +#define trace_recursion_set(bit)	do { (current)->trace_recursion |= (bit); } while (0)
> +#define trace_recursion_clear(bit)	do { (current)->trace_recursion &= ~(bit); } while (0)
> +#define trace_recursion_test(bit)	((current)->trace_recursion & (bit))
> +
>  #endif /* _LINUX_KERNEL_TRACE_H */
> -- 
> 1.7.4.4
> 
> 
