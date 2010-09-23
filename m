Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab0IWTsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:48:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab0IWTsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:48:15 -0400
X-Authority-Analysis: v=1.1 cv=Yii9LXZpONf3Dl4H+sCjsa4WyoNNo7yi1hAau1xJxWE= c=1 sm=0 a=j3BmvocXj5oA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=TGN09ExEHsm_9JlE2ccA:9 a=3FdH9tCXoxJFtJqBDqMppi3dhdYA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv2 1/3] tracing: proper check for irq_depth routines
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <1285243253-7372-2-git-send-email-jolsa@redhat.com>
References: <1285243253-7372-1-git-send-email-jolsa@redhat.com>
	 <1285243253-7372-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Sep 2010 15:48:13 -0400
Message-ID: <1285271293.26872.1613.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 14:00 +0200, Jiri Olsa wrote:
> The check_irq_entry and check_irq_return could be called
> from graph event context. In such case there's no graph
> private data allocated. Adding checks to handle this case.
> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/trace_functions_graph.c |   24 ++++++++++++++++++++----
>  1 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 02c708a..1390159 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -887,12 +887,20 @@ check_irq_entry(struct trace_iterator *iter, u32 flags,
>  		unsigned long addr, int depth)
>  {
>  	int cpu = iter->cpu;
> +	int *depth_irq;
>  	struct fgraph_data *data = iter->private;
> -	int *depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
>  
> -	if (flags & TRACE_GRAPH_PRINT_IRQS)
> +	/*
> +	 * We either display irqs, or we got called as
> +	 * graph event, and out private data do no exist.

"out private data do no exist" makes no sense.

> +	 * In both cases we bypass the irq check.
> +	 */
> +	if ((flags & TRACE_GRAPH_PRINT_IRQS) ||
> +	    (!data))
>  		return 0;
>  
> +	depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
> +
>  	/*
>  	 * We are inside the irq code
>  	 */
> @@ -925,12 +933,20 @@ static int
>  check_irq_return(struct trace_iterator *iter, u32 flags, int depth)
>  {
>  	int cpu = iter->cpu;
> +	int *depth_irq;
>  	struct fgraph_data *data = iter->private;
> -	int *depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
>  
> -	if (flags & TRACE_GRAPH_PRINT_IRQS)
> +	/*
> +	 * We either display irqs, or we got called as
> +	 * graph event, and out private data do no exist.

ditto.

-- Steve

> +	 * In both cases we bypass the irq check.
> +	 */
> +	if ((flags & TRACE_GRAPH_PRINT_IRQS) ||
> +	    (!data))
>  		return 0;
>  
> +	depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
> +
>  	/*
>  	 * We are not inside the irq code.
>  	 */


