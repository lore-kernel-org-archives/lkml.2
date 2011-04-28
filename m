Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab1D1Xge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 19:36:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55310 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab1D1Xgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 19:36:33 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=8GXaHY6NXvoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=zSA864wJv_cWenj1PZgA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=qySrDixDG2gv-_1N:21 a=ZvAQ46Ci4zLhIzsI:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] trace: Add trap entry/exit tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jiaying Zhang <jiayingz@google.com>
In-Reply-To: <1303774765-13032-1-git-send-email-vnagarnaik@google.com>
References: <1303513438-26519-1-git-send-email-vnagarnaik@google.com>
	 <1303774765-13032-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Apr 2011 19:36:32 -0400
Message-ID: <1304033792.18763.214.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 16:39 -0700, Vaibhav Nagarnaik wrote:
> From: Jiaying Zhang <jiayingz@google.com>
> 
> For debugging and performance monitoring purpose, we often need to trace
> trap entry and exit events. The following patch adds the event
> definition for trap entry/exit and the instrumentation hooks for x86
> platforms. Other platforms should be able to use these events as well
> once they add the corresponding instrumentation.

I'm fine with this patch, but it requires Acks from Ingo or Thomas.


> 
> $ echo 1 > debug/tracing/events/trap/enable
> run gdb to genrate some trap events
> $ cat debug/tracing/trace
>           <...>-13619 [003]   917.726602: trap_entry: number=3
>           <...>-13619 [003]   917.726612: trap_exit: number=3
>           <...>-13619 [003]   917.747263: trap_entry: number=1
>           <...>-13619 [003]   917.747272: trap_exit: number=1
>           <...>-13619 [003]   917.747567: trap_entry: number=3
>           <...>-13619 [003]   917.747570: trap_exit: number=3
>           <...>-13619 [003]   917.748101: trap_entry: number=1
>           <...>-13619 [003]   917.748103: trap_exit: number=1
> 
> $ echo 1 > tracing_enabled; ~/trap pagefault; echo 0 > tracing_enabled
> $ cat trace | grep "trap-" | grep number=14 | head
>        trap-12528 [003]  1159.755792: trap_entry: number=14
>        trap-12528 [003]  1159.755801: trap_entry: number=14
>        trap-12528 [003]  1159.755804: trap_entry: number=14
>        trap-12528 [003]  1159.755807: trap_entry: number=14
>        trap-12528 [003]  1159.755810: trap_entry: number=14
>        trap-12528 [003]  1159.755817: trap_entry: number=14
>        trap-12528 [003]  1159.755819: trap_entry: number=14
>        trap-12528 [003]  1159.755821: trap_entry: number=14
>        trap-12528 [003]  1159.755824: trap_entry: number=14
>        trap-12528 [003]  1159.755826: trap_entry: number=14
> $ cat trace | grep "trap-" | grep number=7 | head
>        trap-12528 [003]  1159.756283: trap_entry: number=7
>        trap-12529 [003]  1159.757427: trap_entry: number=7
>        trap-12530 [003]  1159.758277: trap_entry: number=7
>        trap-12531 [003]  1159.759172: trap_entry: number=7
>        trap-12532 [003]  1159.768643: trap_entry: number=7
>        trap-12533 [003]  1159.778195: trap_entry: number=7
>        trap-15026 [001]  1557.877722: trap_entry: number=7
>        trap-15253 [001]  1621.395067: trap_entry: number=7
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>


> +++ b/include/trace/events/trap.h

As this is placed in the generic code, I wonder if a
"trace_trap_entry(id)" is sufficient for all archs.

-- Steve

> @@ -0,0 +1,44 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM trap
> +
> +#if !defined(_TRACE_TRAP_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_TRAP_H
> +
> +#include <linux/tracepoint.h>
> +
> +DECLARE_EVENT_CLASS(trap,
> +
> +	TP_PROTO(int id),
> +
> +	TP_ARGS(id),
> +
> +	TP_STRUCT__entry(
> +		__field(	int,	id	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->id = id;
> +	),
> +
> +	TP_printk("number=%d", __entry->id)
> +);
> +
> +DEFINE_EVENT(trap, trap_entry,
> +
> +	TP_PROTO(int id),
> +
> +	TP_ARGS(id)
> +);
> +
> +DEFINE_EVENT(trap, trap_exit,
> +
> +	TP_PROTO(int id),
> +
> +	TP_ARGS(id)
> +);
> +
> +#endif /* _TRACE_TRAP_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> +


