Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab0IGOSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:18:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37819 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab0IGOSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=flZdlZr7MBgZmGqQUVK8HHBTE/aSRRjIdeFTlezgLBAQxWOjKn4KlXKy7TjdCW0Hnq
         fSXlfApwmJH0BNACSL12n+LSOXuPAyVMp6E5iM4xVgZ5wSIkOJo34/j+apMgyLzxUPWo
         SFaNtOY8eOkujVENSZZFcEWjo3hOfsx7Gp8EU=
Date: Tue, 7 Sep 2010 16:18:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace: add graph output support for wakeup tracer
Message-ID: <20100907141846.GC5375@nowhere>
References: <1281020247-5756-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281020247-5756-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 04:57:27PM +0200, Jiri Olsa wrote:
> hi,
> 
> adding function graph output to irqsoff tracer.
> The graph output is enabled by setting new 'display-graph' trace option.
> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/trace_sched_wakeup.c |  274 +++++++++++++++++++++++++++++++++++--
>  1 files changed, 264 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
> index 4086eae..b576141 100644
> --- a/kernel/trace/trace_sched_wakeup.c
> +++ b/kernel/trace/trace_sched_wakeup.c
> @@ -31,13 +31,33 @@ static int			wakeup_rt;
>  static arch_spinlock_t wakeup_lock =
>  	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
>  
> +static void wakeup_reset(struct trace_array *tr);
>  static void __wakeup_reset(struct trace_array *tr);
> +static int wakeup_graph_entry(struct ftrace_graph_ent *trace);
> +static void wakeup_graph_return(struct ftrace_graph_ret *trace);
>  
>  static int save_lat_flag;
>  
> +#define TRACE_DISPLAY_GRAPH     1
> +
> +static struct tracer_opt trace_opts[] = {
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	/* display latency trace as call graph */
> +	{ TRACER_OPT(display-graph, TRACE_DISPLAY_GRAPH) },
> +#endif
> +	{ } /* Empty entry */
> +};
> +
> +static struct tracer_flags tracer_flags = {
> +	.val  = 0,
> +	.opts = trace_opts,
> +};
> +
> +#define is_graph() (tracer_flags.val & TRACE_DISPLAY_GRAPH)
> +
>  #ifdef CONFIG_FUNCTION_TRACER
>  /*
> - * irqsoff uses its own tracer function to keep the overhead down:
> + * wakeup uses its own tracer function to keep the overhead down:
>   */
>  static void
>  wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
> @@ -80,8 +100,234 @@ static struct ftrace_ops trace_ops __read_mostly =
>  {
>  	.func = wakeup_tracer_call,
>  };
> +
> +static int start_func_tracer(int graph)
> +{
> +	int ret;
> +
> +	if (!graph)
> +		ret = register_ftrace_function(&trace_ops);
> +	else
> +		ret = register_ftrace_graph(&wakeup_graph_return,
> +					    &wakeup_graph_entry);
> +
> +	if (!ret && tracing_is_enabled())
> +		tracer_enabled = 1;
> +	else
> +		tracer_enabled = 0;
> +
> +	return ret;
> +}
> +
> +static void stop_func_tracer(int graph)
> +{
> +	tracer_enabled = 0;
> +
> +	if (!graph)
> +		unregister_ftrace_function(&trace_ops);
> +	else
> +		unregister_ftrace_graph();
> +}
> +
>  #endif /* CONFIG_FUNCTION_TRACER */
>  
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +static int wakeup_set_flag(u32 old_flags, u32 bit, int set)
> +{
> +
> +	if (!(bit & TRACE_DISPLAY_GRAPH))
> +		return -EINVAL;
> +
> +	if (!(is_graph() ^ set))
> +		return 0;
> +
> +	stop_func_tracer(!set);
> +	wakeup_reset(wakeup_trace);
> +
> +	return start_func_tracer(set);
> +}
> +
> +static int wakeup_graph_entry(struct ftrace_graph_ent *trace)
> +{
> +	struct trace_array *tr = wakeup_trace;
> +	struct trace_array_cpu *data;
> +	unsigned long flags;
> +	long disabled;
> +	int cpu, pc, ret = 0;
> +
> +	if (likely(!wakeup_task))
> +		return 0;
> +
> +	pc = preempt_count();
> +	preempt_disable_notrace();
> +
> +	cpu = raw_smp_processor_id();
> +	if (cpu != wakeup_current_cpu)
> +		goto out_enable;
> +
> +	data = tr->data[cpu];
> +	disabled = atomic_inc_return(&data->disabled);
> +	if (unlikely(disabled != 1))
> +		goto out;
> +
> +	local_irq_save(flags);
> +	ret = __trace_graph_entry(tr, trace, flags, pc);
> +	local_irq_restore(flags);
> +
> + out:
> +	atomic_dec(&data->disabled);
> +
> + out_enable:
> +	preempt_enable_notrace();
> +	return ret;
> +}
> +
> +static void wakeup_graph_return(struct ftrace_graph_ret *trace)
> +{
> +	struct trace_array *tr = wakeup_trace;
> +	struct trace_array_cpu *data;
> +	unsigned long flags;
> +	long disabled;
> +	int cpu, pc;
> +
> +	if (likely(!wakeup_task))
> +		return;
> +
> +	pc = preempt_count();
> +	preempt_disable_notrace();
> +
> +	cpu = raw_smp_processor_id();
> +	if (cpu != wakeup_current_cpu)
> +		goto out_enable;
> +
> +	data = tr->data[cpu];
> +	disabled = atomic_inc_return(&data->disabled);
> +	if (unlikely(disabled != 1))
> +		goto out;
> +
> +	local_irq_save(flags);
> +	__trace_graph_return(tr, trace, flags, pc);
> +	local_irq_restore(flags);



Do you disable irqs to avoid losing traces? If so there is a race
window between the recursion barrier in data->disabled and the
time you disable irqs.

If you don't want to lose anything (except NMIs), you need to
replace the preempt_disable by the local_irq_save, ie disable
irqs before the recursion protection.



> +
> + out:
> +	atomic_dec(&data->disabled);
> +
> + out_enable:
> +	preempt_enable_notrace();
> +	return;
> +}
> +
> +static void wakeup_trace_open(struct trace_iterator *iter)
> +{
> +	if (is_graph())
> +		graph_trace_open(iter);
> +}
> +
> +static void wakeup_trace_close(struct trace_iterator *iter)
> +{
> +	if (iter->private)
> +		graph_trace_close(iter);
> +}
> +
> +#define GRAPH_TRACER_FLAGS (TRACE_GRAPH_PRINT_PROC)
> +
> +static enum print_line_t wakeup_print_line(struct trace_iterator *iter)
> +{
> +	u32 flags = GRAPH_TRACER_FLAGS;
> +
> +	if (trace_flags & TRACE_ITER_LATENCY_FMT)
> +		flags |= TRACE_GRAPH_PRINT_DURATION;
> +	else
> +		flags |= TRACE_GRAPH_PRINT_ABS_TIME;
> +
> +	/*
> +	 * In graph mode call the graph tracer output function,
> +	 * otherwise go with the TRACE_FN event handler
> +	 */
> +	if (is_graph())
> +		return print_graph_function_flags(iter, flags);
> +
> +	return TRACE_TYPE_UNHANDLED;
> +}
> +
> +static void wakeup_print_header(struct seq_file *s)
> +{
> +	if (is_graph()) {
> +		struct trace_iterator *iter = s->private;
> +		u32 flags = GRAPH_TRACER_FLAGS;
> +
> +		if (trace_flags & TRACE_ITER_LATENCY_FMT) {
> +			/* print nothing if the buffers are empty */
> +			if (trace_empty(iter))
> +				return;
> +
> +			print_trace_header(s, iter);
> +			flags |= TRACE_GRAPH_PRINT_DURATION;
> +		} else
> +			flags |= TRACE_GRAPH_PRINT_ABS_TIME;
> +
> +		print_graph_headers_flags(s, flags);
> +	} else
> +		trace_default_header(s);
> +}
> +
> +static void
> +trace_graph_function(struct trace_array *tr,
> +		 unsigned long ip, unsigned long flags, int pc)
> +{
> +	u64 time = trace_clock_local();
> +	struct ftrace_graph_ent ent = {
> +		.func  = ip,
> +		.depth = 0,
> +	};
> +	struct ftrace_graph_ret ret = {
> +		.func     = ip,
> +		.depth    = 0,
> +		.calltime = time,
> +		.rettime  = time,
> +	};
> +
> +	__trace_graph_entry(tr, &ent, flags, pc);
> +	__trace_graph_return(tr, &ret, flags, pc);
> +}



Please reuse the existing one in trace_irqsoff.c, you can
librarize it in the graph tracer file.

Thnaks.

