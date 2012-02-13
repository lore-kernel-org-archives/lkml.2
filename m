Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2BMRa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:30:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41726 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab2BMRa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:30:28 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=RlPbyBo6Jk8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=jo_TM3XExF5Yc5t_ELEA:9 a=fBhqHm9xcf4OjbR4L7cA:7 a=PUjeQqilurYA:10 a=dGJ0OcVc7YAA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329154226.25686.4.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v3] printk: add console output tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 13 Feb 2012 12:30:26 -0500
In-Reply-To: <1322161388.5366.54.camel@jlt3.sipsolutions.net>
References: <20111117145502.GA18437@somewhere>
	 <1321541877.3997.31.camel@jlt3.sipsolutions.net>
	 <20111117150040.GB18437@somewhere>
	 <1321543268.3997.40.camel@jlt3.sipsolutions.net>
	 <20111118184401.GA24787@somewhere.redhat.com>
	 <1321641975.10266.73.camel@jlt3.sipsolutions.net>
	 <20111118185449.GB24787@somewhere.redhat.com>
	 <1321642752.10266.75.camel@jlt3.sipsolutions.net>
	 <20111123131622.GA10669@somewhere.redhat.com>
	 <1322140919.5366.17.camel@jlt3.sipsolutions.net>
	 <20111124154519.GB18579@somewhere.redhat.com>
	 (sfid-20111124_164601_383201_AB72557F) <1322161388.5366.54.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 20:03 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add a printk.console trace point to record any printk
> messages into the trace, regardless of the current
> console loglevel. This can help correlate (existing)
> printk debugging with other tracing.
> 

Looks like this patch got lost in the x-mas parade.

Is this the last version of the patch?

In the thread I also see:

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by-me (Thomas Gleixner)

-- Steve


> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> v2: remove extra file
> v3: simplify length of __dynamic_array, thanks Frederic
> 
>  include/trace/events/printk.h |   41 +++++++++++++++++++++++++++++++++++++++++
>  kernel/printk.c               |    5 +++++
>  2 files changed, 46 insertions(+)
> 
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ b/include/trace/events/printk.h	2011-11-24 20:02:21.000000000 +0100
> @@ -0,0 +1,41 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM printk
> +
> +#if !defined(_TRACE_PRINTK_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_PRINTK_H
> +
> +#include <linux/tracepoint.h>
> +
> +TRACE_EVENT_CONDITION(console,
> +	TP_PROTO(const char *log_buf, unsigned start, unsigned end,
> +		 unsigned log_buf_len),
> +
> +	TP_ARGS(log_buf, start, end, log_buf_len),
> +
> +	TP_CONDITION(start != end),
> +
> +	TP_STRUCT__entry(
> +		__dynamic_array(char, msg, end - start + 1)
> +	),
> +
> +	TP_fast_assign(
> +		if ((start & (log_buf_len - 1)) > (end & (log_buf_len - 1))) {
> +			memcpy(__get_dynamic_array(msg),
> +			       log_buf + (start & (log_buf_len - 1)),
> +			       log_buf_len - (start & (log_buf_len - 1)));
> +			memcpy((char *)__get_dynamic_array(msg) +
> +			       log_buf_len - (start & (log_buf_len - 1)),
> +			       log_buf, end & (log_buf_len - 1));
> +		} else
> +			memcpy(__get_dynamic_array(msg),
> +			       log_buf + (start & (log_buf_len - 1)),
> +			       end - start);
> +		((char *)__get_dynamic_array(msg))[end - start] = 0;
> +	),
> +
> +	TP_printk("%s", __get_str(msg))
> +);
> +#endif /* _TRACE_PRINTK_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> --- a/kernel/printk.c	2011-11-24 09:38:53.000000000 +0100
> +++ b/kernel/printk.c	2011-11-24 09:42:37.000000000 +0100
> @@ -44,6 +44,9 @@
>  
>  #include <asm/uaccess.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/printk.h>
> +
>  /*
>   * Architectures can override it:
>   */
> @@ -542,6 +545,8 @@ MODULE_PARM_DESC(ignore_loglevel, "ignor
>  static void _call_console_drivers(unsigned start,
>  				unsigned end, int msg_log_level)
>  {
> +	trace_console(&LOG_BUF(0), start, end, log_buf_len);
> +
>  	if ((msg_log_level < console_loglevel || ignore_loglevel) &&
>  			console_drivers && start != end) {
>  		if ((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK)) {
> 


