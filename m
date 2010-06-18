Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab0FRPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 11:16:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab0FRPQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 11:16:54 -0400
X-Authority-Analysis: v=1.1 cv=zLGBfXKW/yOQN1c4qTdQUWouaSiWOaUUjRgOJi1LSJI= c=1 sm=0 a=Tri4-pEeJE0A:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=GTxr0ohDlGXFqFoZmQcA:9 a=oG_Y1ZDUAGmDzXNSYsDZzuPFk0kA:4 a=PUjeQqilurYA:10 a=ZPDR8wsO0E-ufLjS:21 a=r_FgOosqfjtAcTJW:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH V2] tracing, function graph: Remove the noisy output
 when use function graph filter
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4C1B2B0E.1050101@cn.fujitsu.com>
References: <4C1B2B0E.1050101@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 18 Jun 2010 11:16:52 -0400
Message-ID: <1276874212.3556.135.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 16:15 +0800, Lai Jiangshan wrote:
> If we use function graph filter(echo some_functions >> set_graph_function)
> we are only interested in the graph of some_functions.
> 
> But if a interrupt occurs when these functions are being traced(or preparing),
> the graphs of the handlers of this interrupt are also recorded.
> These events that we aren't interested in are totally noisy.
> 
> This patch skip the noise when TRACE_GRAPH_FILTER_SKIP_INTR flag is on
> (very very seldom noise is still left, It's OK for tracing, doesn't it?).
> 
> changed from v1:
> Add a TRACE_GRAPH_FILTER_SKIP_INTR flag which is default off
> to control it.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 79f4bac..d4fa4a4 100644
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
> @@ -41,6 +43,7 @@ struct fgraph_data {
>  #define TRACE_GRAPH_PRINT_PROC		0x8
>  #define TRACE_GRAPH_PRINT_DURATION	0x10
>  #define TRACE_GRAPH_PRINT_ABS_TIME	0x20
> +#define TRACE_GRAPH_FILTER_SKIP_INTR	0x40
>  
>  static struct tracer_opt trace_opts[] = {
>  	/* Display overruns? (for self-debug purpose) */
> @@ -55,6 +58,8 @@ static struct tracer_opt trace_opts[] = {
>  	{ TRACER_OPT(funcgraph-duration, TRACE_GRAPH_PRINT_DURATION) },
>  	/* Display absolute time of an entry */
>  	{ TRACER_OPT(funcgraph-abstime, TRACE_GRAPH_PRINT_ABS_TIME) },
> +	/* Skip the graph nested in interrupts when funcgraph filter enabled */
> +	{ TRACER_OPT(funcgraph-filter-skip-intr, TRACE_GRAPH_FILTER_SKIP_INTR) },
>  	{ } /* Empty entry */
>  };
>  
> @@ -213,13 +218,22 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
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
> +		if (!depth)
> +			return 0;

Note, as I mentioned in my last email, ftrace_graph_addr() is not that
cheap of a function. If we can bypass it, then lets do it. The cheap
things to check are depth and flags. Do them first.

If depth is set, then there's no reason to do the ftrace_graph_addr()
(which is a loop of checking functions!).

The only time we need to do ftrace_graph_addr() is when depth is zero,
or flags is set to TRACE_GRAPH_FILTER_SKIP_INTR and the context does not
match.

This gets called by _every_function_, it needs to be micro optimized.


> +		if ((tracer_flags.val & TRACE_GRAPH_FILTER_SKIP_INTR)
> +		    && (current->ret_stack[depth - 1].subtime != cntxt))
> +			return 0;
> +	}
> +	/* We don't use subtime here, reuse it to save context. */
> +	current->ret_stack[depth].subtime = cntxt;


I still don't like this double use of subtime. It seems too much of a
hack.

What we could also do, which would probably be even better yet, is to
have two functions. One for when TRACE_GRAPH_FILTER_SKIP_INTR is set and
one when it is not. This will avoid the conditionals. Then just register
the proper function with register_ftrace_graph() depending on what the
options are.

You can even change the function if the options are set.

-- Steve

>  
>  	local_irq_save(flags);
>  	cpu = raw_smp_processor_id();
> 


