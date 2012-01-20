Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab2ATRCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:02:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63102 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2ATRCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:02:41 -0500
Date: Fri, 20 Jan 2012 18:02:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
Message-ID: <20120120170232.GF18056@somewhere>
References: <1325495060-6402-1-git-send-email-jolsa@redhat.com>
 <1326912275-26405-1-git-send-email-jolsa@redhat.com>
 <1326912275-26405-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326912275-26405-3-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 07:44:30PM +0100, Jiri Olsa wrote:
> Adding a way to temporarily enable/disable ftrace_ops. The change
> follows the same way as 'global' ftrace_ops are done.
> 
> Introducing 2 global ftrace_ops - control_ops and ftrace_control_list
> which take over all ftrace_ops registered with FTRACE_OPS_FL_CONTROL
> flag. In addition new per cpu flag called 'disabled' is also added to
> ftrace_ops to provide the control information for each cpu.
> 
> When ftrace_ops with FTRACE_OPS_FL_CONTROL is registered, it is
> set as disabled for all cpus.
> 
> The ftrace_control_list contains all the registered 'control' ftrace_ops.
> The control_ops provides function which iterates ftrace_control_list
> and does the check for 'disabled' flag on current cpu.
> 
> Adding 2 inline functions ftrace_function_enable/ftrace_function_disable,
> which enable/disable the ftrace_ops for given cpu.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  include/linux/ftrace.h |   56 ++++++++++++++++++++++
>  kernel/trace/ftrace.c  |  119 +++++++++++++++++++++++++++++++++++++++++++++---
>  kernel/trace/trace.h   |    2 +
>  3 files changed, 170 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index f33fb3b..d3f529c 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -31,16 +31,32 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
>  
>  typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
>  
> +/*
> + * FTRACE_OPS_FL_* bits denote the state of ftrace_ops struct and are
> + * set in the flags member.
> + *
> + * ENABLED - set/unset when ftrace_ops is registered/unregistered
> + * GLOBAL  - set manualy by ftrace_ops user to denote the ftrace_ops
> + *           is part of the global tracers sharing the same filter
> + *           via set_ftrace_* debugfs files.
> + * DYNAMIC - set when ftrace_ops is registered to denote dynamically
> + *           allocated ftrace_ops which need special care
> + * CONTROL - set manualy by ftrace_ops user to denote the ftrace_ops
> + *           could be controled by following calls:
> + *           ftrace_function_enable, ftrace_function_disable
> + */

Nice!

But I have some more comments:


>  enum {
>  	FTRACE_OPS_FL_ENABLED		= 1 << 0,
>  	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
>  	FTRACE_OPS_FL_DYNAMIC		= 1 << 2,
> +	FTRACE_OPS_FL_CONTROL		= 1 << 3,
>  };
>  
>  struct ftrace_ops {
>  	ftrace_func_t			func;
>  	struct ftrace_ops		*next;
>  	unsigned long			flags;
> +	void __percpu			*disabled;
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  	struct ftrace_hash		*notrace_hash;
>  	struct ftrace_hash		*filter_hash;
> @@ -97,6 +113,46 @@ int register_ftrace_function(struct ftrace_ops *ops);
>  int unregister_ftrace_function(struct ftrace_ops *ops);
>  void clear_ftrace_function(void);
>  
> +/**
> + * ftrace_function_enable - enable controlled ftrace_ops on given cpu
> + *
> + * This function enables tracing on given cpu by decreasing
> + * the per cpu control variable.
> + * It must be called with preemption disabled and only on
> + * ftrace_ops registered with FTRACE_OPS_FL_CONTROL.
> + */
> +static inline void ftrace_function_enable(struct ftrace_ops *ops, int cpu)
> +{
> +	atomic_t *disabled;
> +
> +	if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL) ||
> +			 !preempt_count()))
> +		return;
> +
> +	disabled = per_cpu_ptr(ops->disabled, cpu);
> +	atomic_dec(disabled);
> +}

As you're using this for the local CPU exclusively, I suggest you rather
rename it to "ftrace_function_{dis,en}able_cpu(struct ftrace_ops *ops)"
and use __get_cpu_var() that does the preempt check for you.

[...]
> +static void control_ops_disable_all(struct ftrace_ops *ops)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		atomic_set(per_cpu_ptr(ops->disabled, cpu), 1);
> +}
> +
> +static int control_ops_alloc(struct ftrace_ops *ops)
> +{
> +	atomic_t *disabled;
> +
> +	disabled = alloc_percpu(atomic_t);
> +	if (!disabled)
> +		return -ENOMEM;
> +
> +	ops->disabled = disabled;
> +	control_ops_disable_all(ops);
> +	return 0;
> +}
> +
> +static void control_ops_free(struct ftrace_ops *ops)
> +{
> +	free_percpu(ops->disabled);
> +}
> +
> +static int control_ops_is_disabled(struct ftrace_ops *ops, int cpu)
> +{
> +	atomic_t *disabled = per_cpu_ptr(ops->disabled, cpu);
> +	return atomic_read(disabled);

I think this is checked only locally. Better use __get_cpu_var().
Also note atomic_read() doesn't involve an smp barrier.

atomic_inc/dec are smp safe wrt. ordering. But atomic_set() and atomic_read()
are not. I believe this is safe because we still have PERF_HES_STOPPED check.

And also it seems we read the value from the same CPU we have set it. So
we actually don't need SMP ordering. But then this raise the question of
the relevance of using atomic ops. Normal values would do the trick.

[...]
>  static void
> +ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip)
> +{
> +	struct ftrace_ops *op;
> +	int cpu;
> +
> +	if (unlikely(trace_recursion_test(TRACE_CONTROL_BIT)))
> +		return;
> +
> +	/*
> +	 * Some of the ops may be dynamically allocated,
> +	 * they must be freed after a synchronize_sched().
> +	 */
> +	preempt_disable_notrace();
> +	trace_recursion_set(TRACE_CONTROL_BIT);
> +	cpu = smp_processor_id();
> +	op = rcu_dereference_raw(ftrace_control_list);
> +	while (op != &ftrace_list_end) {
> +		if (!control_ops_is_disabled(op, cpu) &&
> +		    ftrace_ops_test(op, ip))
> +			op->func(ip, parent_ip);
> +
> +		op = rcu_dereference_raw(op->next);

Should it be rcu_dereference_sched() ?

> +	};
> +	trace_recursion_clear(TRACE_CONTROL_BIT);
> +	preempt_enable_notrace();
> +}
> +
> +static struct ftrace_ops control_ops = {
> +	.func = ftrace_ops_control_func,
> +};

So note this patch is optimizing for the off case (when
we have called pmu->del()), but at the cost of having an
impact in the on case with having at least one level
of multiplexing (and two on the worst case if we have ftrace
running in parallel but this is enough a corner case that we
don't care).

But this is perhaps still a win.

> +
> +static void
>  ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
>  {
>  	struct ftrace_ops *op;
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 2c26574..41c54e3 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -288,6 +288,8 @@ struct tracer {
>  /* for function tracing recursion */
>  #define TRACE_INTERNAL_BIT		(1<<11)
>  #define TRACE_GLOBAL_BIT		(1<<12)
> +#define TRACE_CONTROL_BIT		(1<<13)
> +
>  /*
>   * Abuse of the trace_recursion.
>   * As we need a way to maintain state if we are tracing the function
> -- 
> 1.7.1
> 
