Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0CXBTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 21:19:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65318 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab0CXBTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 21:19:18 -0400
X-Authority-Analysis: v=1.0 c=1 a=m7YZiQa2OjEA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=NDV0eE1Daag--fiZiWsA:9 a=GzkZzacdS2uqY0Y8JAAA:7 a=iOt44oadfYY4ka1MgPtKYOZccqcA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCHv2 2/4] tracing: graph output support for irqsoff tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1268207470-2880-3-git-send-email-jolsa@redhat.com>
References: <1268207470-2880-1-git-send-email-jolsa@redhat.com>
	 <1268207470-2880-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 23 Mar 2010 21:19:16 -0400
Message-ID: <1269393556.2957.1823.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 08:51 +0100, Jiri Olsa wrote:

> @@ -993,14 +991,6 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
>  		if (ret != TRACE_TYPE_HANDLED)
>  			return ret;
>  		break;
> -	default:
> -		event = ftrace_find_event(ent->type);
> -		if (!event)
> -			return TRACE_TYPE_UNHANDLED;
> -
> -		ret = event->trace(iter, sym_flags);
> -		if (ret != TRACE_TYPE_HANDLED)
> -			return ret;
>  	}
>  

This has the same effect as the problem with the first patch:

was:

 2)               |                                  _raw_spin_unlock_irqrestore() {
 2)               |                                  /* lock_release: ffffffff816969a8 random_read_wait.lock */
 2)   6.022 us    |                                  }
 2) + 27.632 us   |                                }
 2)   2.939 us    |                                kill_fasync();
 2)               |                                _raw_spin_unlock_irqrestore() {
 2)               |                                /* lock_release: ffffffff816967f0 &input_pool.lock */
 2)   5.471 us    |                                }
 2) + 56.740 us   |                              }
 2) + 88.357 us   |                            }
 2) + 94.026 us   |                          }


is now:

 2)               |                                  _raw_spin_unlock_irqrestore() {
          <idle>-0     [002]   411.798721: lock_release: ffffffff816969a8 random_read_wait.lock
 2)   6.022 us    |                                  }
 2) + 27.632 us   |                                }
 2)   2.939 us    |                                kill_fasync();
 2)               |                                _raw_spin_unlock_irqrestore() {
          <idle>-0     [002]   411.798741: lock_release: ffffffff816967f0 &input_pool.lock
 2)   5.471 us    |                                }
 2) + 56.740 us   |                              }
 2) + 88.357 us   |                            }
 2) + 94.026 us   |                          }


Please, before you apply any patch do the following:

(assuming debugfs is at /debug)

# echo 1 > /debug/tracing/events/enable
# echo function_graph > /debug/tracing/current_tracer
# cat /debug/tracing/trace

Examine what you see.

Then apply all your patches, and repeat the above. Make sure the
formatting is the same.

Thanks,

-- Steve


>  	/* Strip ending newline */
> @@ -1066,8 +1056,11 @@ print_graph_function(struct trace_iterator *iter)
>  		trace_assign_type(field, entry);
>  		return print_graph_return(&field->ret, s, entry, iter);
>  	}
> -	default:
> +	case TRACE_BPRINT:
> +	case TRACE_PRINT:
>  		return print_graph_comment(s, entry, iter);
> +	default:
> +		return TRACE_TYPE_UNHANDLED;
>  	}
>  
>  	return TRACE_TYPE_HANDLED;
> @@ -1101,7 +1094,7 @@ static void print_lat_header(struct seq_file *s)
>  	seq_printf(s, "#%.*s|||| /                     \n", size, spaces);
>  }
>  
> -static void print_graph_headers(struct seq_file *s)
> +void print_graph_headers(struct seq_file *s)
>  {
>  	int lat = trace_flags & TRACE_ITER_LATENCY_FMT;
>  
> @@ -1137,7 +1130,7 @@ static void print_graph_headers(struct seq_file *s)
>  	seq_printf(s, "               |   |   |   |\n");
>  }
>  
> -static void graph_trace_open(struct trace_iterator *iter)
> +void graph_trace_open(struct trace_iterator *iter)
>  {
>  	/* pid and depth on the last trace processed */
>  	struct fgraph_data *data;
> @@ -1172,7 +1165,7 @@ static void graph_trace_open(struct trace_iterator *iter)
>  	pr_warning("function graph tracer: not enough memory\n");
>  }
>  
> -static void graph_trace_close(struct trace_iterator *iter)
> +void graph_trace_close(struct trace_iterator *iter)
>  {
>  	struct fgraph_data *data = iter->private;
>  
> diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
> index 2974bc7..d0c6d6c 100644
> --- a/kernel/trace/trace_irqsoff.c
> +++ b/kernel/trace/trace_irqsoff.c
> @@ -34,6 +34,9 @@ static int trace_type __read_mostly;
>  
>  static int save_lat_flag;
>  
> +static void stop_irqsoff_tracer(struct trace_array *tr, int graph);
> +static int start_irqsoff_tracer(struct trace_array *tr, int graph);
> +
>  #ifdef CONFIG_PREEMPT_TRACER
>  static inline int
>  preempt_trace(void)
> @@ -55,6 +58,23 @@ irq_trace(void)
>  # define irq_trace() (0)
>  #endif
>  
> +#define TRACE_DISPLAY_GRAPH	1
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
> +	.val = 0,
> +	.opts = trace_opts,
> +};
> +
> +#define is_graph() (tracer_flags.val & TRACE_DISPLAY_GRAPH)
> +
>  /*
>   * Sequence count - we record it when starting a measurement and
>   * skip the latency if the sequence has changed - some other section
> @@ -108,6 +128,109 @@ static struct ftrace_ops trace_ops __read_mostly =
>  };
>  #endif /* CONFIG_FUNCTION_TRACER */
>  
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
> +{
> +	int cpu;
> +
> +	if (!(bit & TRACE_DISPLAY_GRAPH))
> +		return -EINVAL;
> +
> +	if (!(is_graph() ^ set))
> +		return 0;
> +
> +	stop_irqsoff_tracer(irqsoff_trace, !set);
> +
> +	for_each_possible_cpu(cpu)
> +		per_cpu(tracing_cpu, cpu) = 0;
> +
> +	tracing_max_latency = 0;
> +	tracing_reset_online_cpus(irqsoff_trace);
> +
> +	return start_irqsoff_tracer(irqsoff_trace, set);
> +}
> +
> +static int irqsoff_graph_entry(struct ftrace_graph_ent *trace)
> +{
> +	struct trace_array *tr = irqsoff_trace;
> +	struct trace_array_cpu *data;
> +	unsigned long flags;
> +	long disabled;
> +	int ret;
> +	int cpu;
> +	int pc;
> +
> +	cpu = raw_smp_processor_id();
> +	if (likely(!per_cpu(tracing_cpu, cpu)))
> +		return 0;
> +
> +	local_save_flags(flags);
> +	/* slight chance to get a false positive on tracing_cpu */
> +	if (!irqs_disabled_flags(flags))
> +		return 0;
> +
> +	data = tr->data[cpu];
> +	disabled = atomic_inc_return(&data->disabled);
> +
> +	if (likely(disabled == 1)) {
> +		pc = preempt_count();
> +		ret = __trace_graph_entry(tr, trace, flags, pc);
> +	} else
> +		ret = 0;
> +
> +	atomic_dec(&data->disabled);
> +	return ret;
> +}
> +
> +static void irqsoff_graph_return(struct ftrace_graph_ret *trace)
> +{
> +	struct trace_array *tr = irqsoff_trace;
> +	struct trace_array_cpu *data;
> +	unsigned long flags;
> +	long disabled;
> +	int cpu;
> +	int pc;
> +
> +	cpu = raw_smp_processor_id();
> +	if (likely(!per_cpu(tracing_cpu, cpu)))
> +		return;
> +
> +	local_save_flags(flags);
> +	/* slight chance to get a false positive on tracing_cpu */
> +	if (!irqs_disabled_flags(flags))
> +		return;
> +
> +	data = tr->data[cpu];
> +	disabled = atomic_inc_return(&data->disabled);
> +
> +	if (likely(disabled == 1)) {
> +		pc = preempt_count();
> +		__trace_graph_return(tr, trace, flags, pc);
> +	}
> +
> +	atomic_dec(&data->disabled);
> +}
> +
> +static void irqsoff_trace_open(struct trace_iterator *iter)
> +{
> +	if (is_graph())
> +		graph_trace_open(iter);
> +
> +}
> +
> +static void irqsoff_trace_close(struct trace_iterator *iter)
> +{
> +	if (iter->private)
> +		graph_trace_close(iter);
> +}
> +
> +#else
> +static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
> +{
> +	return -EINVAL;
> +}
> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> +
>  /*
>   * Should this new latency be reported/recorded?
>   */
> @@ -347,19 +470,36 @@ void trace_preempt_off(unsigned long a0, unsigned long a1)
>  }
>  #endif /* CONFIG_PREEMPT_TRACER */
>  
> -static void start_irqsoff_tracer(struct trace_array *tr)
> +static int start_irqsoff_tracer(struct trace_array *tr, int graph)
>  {
> -	register_ftrace_function(&trace_ops);
> -	if (tracing_is_enabled())
> +	int ret = 0;
> +
> +	if (!graph)
> +		ret = register_ftrace_function(&trace_ops);
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	else
> +		ret = register_ftrace_graph(&irqsoff_graph_return,
> +					    &irqsoff_graph_entry);
> +#endif
> +
> +	if (!ret && tracing_is_enabled())
>  		tracer_enabled = 1;
>  	else
>  		tracer_enabled = 0;
> +
> +	return ret;
>  }
>  
> -static void stop_irqsoff_tracer(struct trace_array *tr)
> +static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
>  {
>  	tracer_enabled = 0;
> -	unregister_ftrace_function(&trace_ops);
> +
> +	if (!graph)
> +		unregister_ftrace_function(&trace_ops);
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	else
> +		unregister_ftrace_graph();
> +#endif
>  }
>  
>  static void __irqsoff_tracer_init(struct trace_array *tr)
> @@ -372,12 +512,14 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
>  	/* make sure that the tracer is visible */
>  	smp_wmb();
>  	tracing_reset_online_cpus(tr);
> -	start_irqsoff_tracer(tr);
> +
> +	if (start_irqsoff_tracer(tr, is_graph()))
> +		printk(KERN_ERR "failed to start irqsoff tracer\n");
>  }
>  
>  static void irqsoff_tracer_reset(struct trace_array *tr)
>  {
> -	stop_irqsoff_tracer(tr);
> +	stop_irqsoff_tracer(tr, is_graph());
>  
>  	if (!save_lat_flag)
>  		trace_flags &= ~TRACE_ITER_LATENCY_FMT;
> @@ -409,9 +551,15 @@ static struct tracer irqsoff_tracer __read_mostly =
>  	.start		= irqsoff_tracer_start,
>  	.stop		= irqsoff_tracer_stop,
>  	.print_max	= 1,
> +	.flags		= &tracer_flags,
> +	.set_flag	= irqsoff_set_flag,
>  #ifdef CONFIG_FTRACE_SELFTEST
>  	.selftest    = trace_selftest_startup_irqsoff,
>  #endif
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	.open           = irqsoff_trace_open,
> +	.close          = irqsoff_trace_close,
> +#endif
>  };
>  # define register_irqsoff(trace) register_tracer(&trace)
>  #else


