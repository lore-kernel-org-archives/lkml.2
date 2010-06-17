Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260Ab0FQPz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:55:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34301 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab0FQPz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:55:26 -0400
X-Authority-Analysis: v=1.1 cv=zLGBfXKW/yOQN1c4qTdQUWouaSiWOaUUjRgOJi1LSJI= c=1 sm=0 a=U6fyK1BqOE0A:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=e7TJZTf_D57YIyi_fUYA:9 a=vHD72SPuxvD7ocCyU6KzViXMDzYA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing, function graph: Remove the noisy output when
 use function graph filter
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4C19E3C3.2060900@cn.fujitsu.com>
References: <4C19E3C3.2060900@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 17 Jun 2010 11:55:23 -0400
Message-ID: <1276790123.3556.111.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-17 at 16:58 +0800, Lai Jiangshan wrote:
> If we use function graph filter(echo some_functions >> set_graph_function)
> we are only interested in the graph of some_functions.
> 
> But if a interrupt occurs when these functions are being traced(or preparing),
> the graphs of the handlers of this interrupt are also recorded.
> These events that we aren't interested in are totally noisy.

Umm, sorry, I prefer the noise.  When analyzing the network stack, I
like to see the interrupts that preempt the code.

What you could do is add an function_graph option that disables it, but
do not make it the default.

> 
> This patch remove them(very very seldom noise is still left,
> It's OK for tracing, doesn't it?).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 79f4bac..9c130b3 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -12,6 +12,8 @@
>  #include <linux/slab.h>
>  #include <linux/fs.h>
>  
> +#include <asm/irq_regs.h>
> +
>  #include "trace.h"
>  #include "trace_output.h"
>  
> @@ -213,13 +215,19 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
>  	int ret;
>  	int cpu;
>  	int pc;
> +	int depth = trace->depth;
> +	unsigned long long cntxt = (unsigned long)(void *)get_irq_regs();
>  
>  	if (!ftrace_trace_task(current))
>  		return 0;
>  
>  	/* trace it when it is-nested-in or is a function enabled. */
> -	if (!(trace->depth || ftrace_graph_addr(trace->func)))
> -		return 0;
> +	if (!ftrace_graph_addr(trace->func)) {
> +		if (!depth || current->ret_stack[depth - 1].subtime != cntxt)
> +			return 0;
> +	}

This will slow down the tracing when inside the function. You are
testing every function to see if we should show the trace, even when we
are inside a function we are tracing.


> +	/* We don't use subtime here, reuse it to save context. */
> +	current->ret_stack[depth].subtime = cntxt;

This should then be a union if it is used for two things. That documents
it better.


>  
>  	local_irq_save(flags);
>  	cpu = raw_smp_processor_id();

If you make the above into an option, then we can have

	int no_irqs = tracer_flags.val & TRACE_GRAPH_NO_IRQS;
	[...]

	if (!(trace->depth || ftrace_graph_addr(trace->func)))
		return 0;

	if (no_irqs) {
		cntx = (unsigned long)(void *)get_irq_regs();
		if (trace->depth &&
		    current->ret_stack[depth - 1].subtime != cntxt)
			return 0;
		current->ret_stack[depth].subtime = cntxt;
	}

Also, I'm not really happy about the double use of subtime. It pevents
the function graph from ever ignoring the time it calls the child
functions.

-- Steve


