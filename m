Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab0GVUAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:00:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50042 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab0GVUA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:00:29 -0400
X-Authority-Analysis: v=1.1 cv=0ETVU5ClxBlG/P3Ky9ZuhqraSVIot/cIDNO6awFX9oc= c=1 sm=0 a=T_j1L3QSKLIA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=8Il30ee_kaXwIMsGqCIA:9 a=nLFx0UzW-Hpcr1Aa770oPy2WK80A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] trace: funcgraph tracer - adding funcgraph-irq option
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <1278951670-8133-1-git-send-email-jolsa@redhat.com>
References: <1278951670-8133-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 22 Jul 2010 16:00:21 -0400
Message-ID: <1279828821.3319.23.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 18:21 +0200, Jiri Olsa wrote:

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
> +check_irq_entry(struct trace_iterator *iter, u32 flags, unsigned long addr)
> +{
> +	struct fgraph_data *data = iter->private;
> +	int cpu = iter->cpu;
> +	unsigned long *irq_entry_addr;
> +
> +	if (flags & TRACE_GRAPH_PRINT_IRQS)
> +		return 0;
> +
> +	/*
> +	 * We are inside the irq code
> +	 */
> +	irq_entry_addr = &(per_cpu_ptr(data->cpu_data, cpu)->irq_entry_addr);
> +	if (*irq_entry_addr)
> +		return 1;
> +
> +	if ((addr < (unsigned long)__irqentry_text_start) ||
> +	    (addr >= (unsigned long)__irqentry_text_end))
> +		return 0;
> +
> +	/*
> +	 * We are entering irq code.
> +	 */
> +	*irq_entry_addr = addr;
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
> +check_irq_return(struct trace_iterator *iter, u32 flags, unsigned long addr)
> +{
> +	struct fgraph_data *data = iter->private;
> +	int cpu = iter->cpu;
> +	unsigned long *irq_entry_addr;
> +
> +	if (flags & TRACE_GRAPH_PRINT_IRQS)
> +		return 0;
> +
> +	/*
> +	 * We are not inside the irq code.
> +	 */
> +	irq_entry_addr = &(per_cpu_ptr(data->cpu_data, cpu)->irq_entry_addr);
> +	if (!(*irq_entry_addr))
> +		return 0;
> +
> +	/*
> +	 * We are inside the irq code, and this is not the entry.
> +	 */
> +	if (*irq_entry_addr != addr)
> +		return 1;
> +
> +	/*
> +	 * We are inside the irq code, and this is returning entry.
> +	 * Let's not trace it and clear the entry address, since
> +	 * we are out of irq code.
> +	 */
> +	*irq_entry_addr = 0;
> +	return 1;
> +}
> +
>  static enum print_line_t
>  print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
>  			struct trace_iterator *iter, u32 flags)
> @@ -857,6 +943,9 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
>  	static enum print_line_t ret;
>  	int cpu = iter->cpu;
>  
> +	if (check_irq_entry(iter, flags, call->func))
> +		return TRACE_TYPE_HANDLED;
> +
>  	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func, flags))
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> @@ -894,6 +983,9 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
>  	int ret;
>  	int i;
>  
> +	if (check_irq_return(iter, flags, trace->func))
> +		return TRACE_TYPE_HANDLED;

What happens if we lose the return event? That is, due to buffer
overruns, the return of the trace is lost. Then we lose out on all
events until another event of the same IRQ happens and its return is not
lost.

You should save the depth instead of the function. When you are in a
interrupt, record the depth. Then when the depth is less than or equal
to the recorded depth you can restart printing. This may still suffer
from missed returns, but it would not have as much of a consequence when
it happens.

-- Steve

> +
>  	if (data) {
>  		struct fgraph_cpu_data *cpu_data;
>  		int cpu = iter->cpu;


