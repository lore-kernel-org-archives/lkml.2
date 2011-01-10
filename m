Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1AJOOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:14:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61234 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab1AJOOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:14:51 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=YGCV5_ce828A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=bCwPElMxWi0QCRWP4EAA:9 a=BAAq-hmf_nVX0fXsFmAA:7 a=8jeM7uJwjjMTFqL4po2o1rjfSDgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [tip:perf/urgent] tracing: Include module.h in define_trace.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        srostedt@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <1294667377.11896.3.camel@laptop>
References: <tip-3a9f987b3141f086de27832514aad9f50a53f754@git.kernel.org>
	 <1294667377.11896.3.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 10 Jan 2011 09:14:48 -0500
Message-ID: <1294668888.26623.238.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 14:49 +0100, Peter Zijlstra wrote:
> After I got everything building on that tree I was working on, the above
> was found to compile but not to link, since it makes every:
> 
>  #define CREATE_TRACE_POINTS
>  #include <trace/event/foo.h>
> 
> site also create the trace/event/module.h tracepoints, thus confusing
> the linker with tons of duplicate symbols.
> 
> The below patch makes things compile and link:
> 
> ---
>  include/trace/define_trace.h |   23 +++++++++++++----------
>  1 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
> index da39b22..9ebd0d3 100644
> --- a/include/trace/define_trace.h
> +++ b/include/trace/define_trace.h
> @@ -21,16 +21,6 @@
>  #undef CREATE_TRACE_POINTS

But here we undefine CREATE_TRACE_POINTS, why would this cause a problem
in module.h?

-- Steve

>  
>  #include <linux/stringify.h>
> -/*
> - * module.h includes tracepoints, and because ftrace.h
> - * pulls in module.h:
> - *  trace/ftrace.h -> linux/ftrace_event.h -> linux/perf_event.h ->
> - *  linux/ftrace.h -> linux/module.h
> - * we must include module.h here before we play with any of
> - * the TRACE_EVENT() macros, otherwise the tracepoints included
> - * by module.h may break the build.
> - */
> -#include <linux/module.h>
>  
>  #undef TRACE_EVENT
>  #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
> @@ -120,4 +110,17 @@
>  /* We may be processing more files */
>  #define CREATE_TRACE_POINTS
>  
> +#else /* CREATE_TRACE_POINTS */
> +
> +/*
> + * module.h includes tracepoints, and because ftrace.h
> + * pulls in module.h:
> + *  trace/ftrace.h -> linux/ftrace_event.h -> linux/perf_event.h ->
> + *  linux/ftrace.h -> linux/module.h
> + * we must include module.h here before we play with any of
> + * the TRACE_EVENT() macros, otherwise the tracepoints included
> + * by module.h may break the build.
> + */
> +#include <linux/module.h>
> +
>  #endif /* CREATE_TRACE_POINTS */


