Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab0IGQ2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:28:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39565 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970Ab0IGQ2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:28:43 -0400
X-Authority-Analysis: v=1.1 cv=kSl6L8luU05z5mpL051isgeeLpAUfowbwuc/WIqEapw= c=1 sm=0 a=Ot0fQfLCyksA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=SFYaYuq8CTzIRaGbHk8A:9 a=kPy1I-iH8qCmmEhDDUIQAuHPM2UA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv2] trace: funcgraph tracer - adding funcgraph-irq option
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20100723131913.GB1829@jolsa.brq.redhat.com>
References: <1278951670-8133-1-git-send-email-jolsa@redhat.com>
	 <1279828821.3319.23.camel@gandalf.stny.rr.com>
	 <20100723131913.GB1829@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Sep 2010 12:28:40 -0400
Message-ID: <1283876920.5133.125.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes,

I think it was you that was testing this patch. Could you give me a
"Tested-by" if you have, and it worked out for you.

-- Steve


On Fri, 2010-07-23 at 15:19 +0200, Jiri Olsa wrote:
> On Thu, Jul 22, 2010 at 04:00:21PM -0400, Steven Rostedt wrote:
> > On Mon, 2010-07-12 at 18:21 +0200, Jiri Olsa wrote:
> > 
> SNIP
> 
> > 
> > What happens if we lose the return event? That is, due to buffer
> > overruns, the return of the trace is lost. Then we lose out on all
> > events until another event of the same IRQ happens and its return is not
> > lost.
> > 
> > You should save the depth instead of the function. When you are in a
> > interrupt, record the depth. Then when the depth is less than or equal
> > to the recorded depth you can restart printing. This may still suffer
> > from missed returns, but it would not have as much of a consequence when
> > it happens.
> hi,
> you're right, changed patch is attached
> 
> thanks,
> jirka
> 
> ---
> Adding funcgraph-irq option for function graph tracer.
> 
> It's handy to be able to disable the irq related output
> and not to have to jump over each irq related code, when
> you have no interrest in it.
> 
> The option is by default enabled, so there's no change to
> current behaviour. It affects only the final output, so all
> the irq related data stays in the ring buffer.
> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/trace_functions_graph.c |  101 +++++++++++++++++++++++++++++++++-
>  1 files changed, 100 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 6bff236..e66f71f 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -18,6 +18,7 @@
>  struct fgraph_cpu_data {
>  	pid_t		last_pid;
>  	int		depth;
> +	int		depth_irq;
>  	int		ignore;
>  	unsigned long	enter_funcs[FTRACE_RETFUNC_DEPTH];
>  };
> @@ -41,6 +42,7 @@ struct fgraph_data {
>  #define TRACE_GRAPH_PRINT_PROC		0x8
>  #define TRACE_GRAPH_PRINT_DURATION	0x10
>  #define TRACE_GRAPH_PRINT_ABS_TIME	0x20
> +#define TRACE_GRAPH_PRINT_IRQS		0x40
>  
>  static struct tracer_opt trace_opts[] = {
>  	/* Display overruns? (for self-debug purpose) */
> @@ -55,13 +57,15 @@ static struct tracer_opt trace_opts[] = {
>  	{ TRACER_OPT(funcgraph-duration, TRACE_GRAPH_PRINT_DURATION) },
>  	/* Display absolute time of an entry */
>  	{ TRACER_OPT(funcgraph-abstime, TRACE_GRAPH_PRINT_ABS_TIME) },
> +	/* Display interrupts */
> +	{ TRACER_OPT(funcgraph-irqs, TRACE_GRAPH_PRINT_IRQS) },
>  	{ } /* Empty entry */
>  };
>  
>  static struct tracer_flags tracer_flags = {
>  	/* Don't display overruns and proc by default */
>  	.val = TRACE_GRAPH_PRINT_CPU | TRACE_GRAPH_PRINT_OVERHEAD |
> -	       TRACE_GRAPH_PRINT_DURATION,
> +	       TRACE_GRAPH_PRINT_DURATION | TRACE_GRAPH_PRINT_IRQS,
>  	.opts = trace_opts
>  };
>  
> @@ -847,6 +851,92 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
>  	return 0;
>  }
>  
> +/*
> + * Entry check for irq code
> + *
> + * returns 1 if
> + *  - we are inside irq code
> + *  - we just extered irq code
> + *
> + * retunns 0 if
> + *  - funcgraph-interrupts option is set
> + *  - we are not inside irq code
> + */
> +static int
> +check_irq_entry(struct trace_iterator *iter, u32 flags,
> +		unsigned long addr, int depth)
> +{
> +	int cpu = iter->cpu;
> +	struct fgraph_data *data = iter->private;
> +	int *depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
> +
> +	if (flags & TRACE_GRAPH_PRINT_IRQS)
> +		return 0;
> +
> +	/*
> +	 * We are inside the irq code
> +	 */
> +	if (*depth_irq >= 0)
> +		return 1;
> +
> +	if ((addr < (unsigned long)__irqentry_text_start) ||
> +	    (addr >= (unsigned long)__irqentry_text_end))
> +		return 0;
> +
> +	/*
> +	 * We are entering irq code.
> +	 */
> +	*depth_irq = depth;
> +	return 1;
> +}
> +
> +/*
> + * Return check for irq code
> + *
> + * returns 1 if
> + *  - we are inside irq code
> + *  - we just left irq code
> + *
> + * returns 0 if
> + *  - funcgraph-interrupts option is set
> + *  - we are not inside irq code
> + */
> +static int
> +check_irq_return(struct trace_iterator *iter, u32 flags, int depth)
> +{
> +	int cpu = iter->cpu;
> +	struct fgraph_data *data = iter->private;
> +	int *depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
> +
> +	if (flags & TRACE_GRAPH_PRINT_IRQS)
> +		return 0;
> +
> +	/*
> +	 * We are not inside the irq code.
> +	 */
> +	if (*depth_irq == -1)
> +		return 0;
> +
> +	/*
> +	 * We are inside the irq code, and this is returning entry.
> +	 * Let's not trace it and clear the entry depth, since
> +	 * we are out of irq code.
> +	 *
> +	 * This condition ensures that we 'leave the irq code' once
> +	 * we are out of the entry depth. Thus protecting us from
> +	 * the RETURN entry loss.
> +	 */
> +	if (*depth_irq >= depth) {
> +		*depth_irq = -1;
> +		return 1;
> +	}
> +
> +	/*
> +	 * We are inside the irq code, and this is not the entry.
> +	 */
> +	return 1;
> +}
> +
>  static enum print_line_t
>  print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
>  			struct trace_iterator *iter, u32 flags)
> @@ -857,6 +947,9 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
>  	static enum print_line_t ret;
>  	int cpu = iter->cpu;
>  
> +	if (check_irq_entry(iter, flags, call->func, call->depth))
> +		return TRACE_TYPE_HANDLED;
> +
>  	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func, flags))
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> @@ -894,6 +987,9 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
>  	int ret;
>  	int i;
>  
> +	if (check_irq_return(iter, flags, trace->depth))
> +		return TRACE_TYPE_HANDLED;
> +
>  	if (data) {
>  		struct fgraph_cpu_data *cpu_data;
>  		int cpu = iter->cpu;
> @@ -1202,9 +1298,12 @@ void graph_trace_open(struct trace_iterator *iter)
>  		pid_t *pid = &(per_cpu_ptr(data->cpu_data, cpu)->last_pid);
>  		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
>  		int *ignore = &(per_cpu_ptr(data->cpu_data, cpu)->ignore);
> +		int *depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
> +
>  		*pid = -1;
>  		*depth = 0;
>  		*ignore = 0;
> +		*depth_irq = -1;
>  	}
>  
>  	iter->private = data;


