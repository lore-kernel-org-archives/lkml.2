Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab1KQBBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 20:01:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51439 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab1KQBBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 20:01:31 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=PQ8x_VTtLv8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=QyXUC8HyAAAA:8 a=LUYwL_blAIEk7dx4Ab0A:9 a=dNkM6LpkC2u1C6CToYQA:7 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH] printk: add console output tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1321478719.4502.20.camel@jlt3.sipsolutions.net>
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
	 <20111116151037.GA26166@infradead.org>
	 <1321456652.4502.12.camel@jlt3.sipsolutions.net>
	 <1321461693.4181.26.camel@frodo>
	 <1321461902.4502.14.camel@jlt3.sipsolutions.net>
	 <1321462856.4181.28.camel@frodo>
	 <1321468380.4502.16.camel@jlt3.sipsolutions.net>
	 <1321473443.4181.38.camel@frodo>
	 <1321478719.4502.20.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 20:01:28 -0500
Message-ID: <1321491688.4181.42.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, Peter, Frederic, Christoph,

Would you ack this patch please.

Thanks,

-- Steve


On Wed, 2011-11-16 at 22:25 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add a printk.console trace point to record any printk
> messages into the trace, regardless of the current
> console loglevel. This can help correlate (existing)
> printk debugging with other tracing.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/trace/events/printk.h |   44 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/printk.c               |    3 ++
>  kernel/trace/Makefile         |    1 
>  kernel/trace/printk-trace.c   |   14 +++++++++++++
>  4 files changed, 62 insertions(+)
> 
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ b/include/trace/events/printk.h	2011-11-16 22:06:43.000000000 +0100
> @@ -0,0 +1,44 @@
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
> +		__dynamic_array(char, msg,
> +				((end - start + log_buf_len) &
> +				 (log_buf_len - 1)) + 1)
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
> +			       (end - start + log_buf_len) & (log_buf_len - 1));
> +		((char *)__get_dynamic_array(msg))[(end - start + log_buf_len) &
> +						   (log_buf_len - 1)] = 0;
> +	),
> +
> +	TP_printk("%s", __get_str(msg))
> +);
> +#endif /* _TRACE_PRINTK_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> --- a/kernel/printk.c	2011-11-16 16:37:20.000000000 +0100
> +++ b/kernel/printk.c	2011-11-16 21:47:20.000000000 +0100
> @@ -41,6 +41,7 @@
>  #include <linux/cpu.h>
>  #include <linux/notifier.h>
>  #include <linux/rculist.h>
> +#include <trace/events/printk.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -542,6 +543,8 @@ MODULE_PARM_DESC(ignore_loglevel, "ignor
>  static void _call_console_drivers(unsigned start,
>  				unsigned end, int msg_log_level)
>  {
> +	trace_console(&LOG_BUF(0), start, end, log_buf_len);
> +
>  	if ((msg_log_level < console_loglevel || ignore_loglevel) &&
>  			console_drivers && start != end) {
>  		if ((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK)) {
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ b/kernel/trace/printk-trace.c	2011-11-16 21:22:20.000000000 +0100
> @@ -0,0 +1,14 @@
> +/*
> + * printk trace points
> + *
> + * Copyright (C) 2011 Johannes Berg <johannes.berg@intel.com>
> + */
> +
> +#include <linux/string.h>
> +#include <linux/types.h>
> +#include <linux/workqueue.h>
> +#include <linux/sched.h>
> +#include <linux/module.h>
> +
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/printk.h>
> --- a/kernel/trace/Makefile	2011-11-16 16:37:20.000000000 +0100
> +++ b/kernel/trace/Makefile	2011-11-16 21:38:49.000000000 +0100
> @@ -55,6 +55,7 @@ endif
>  obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
>  obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
>  obj-$(CONFIG_TRACEPOINTS) += power-traces.o
> +obj-$(CONFIG_TRACEPOINTS) += printk-trace.o
>  ifeq ($(CONFIG_PM_RUNTIME),y)
>  obj-$(CONFIG_TRACEPOINTS) += rpm-traces.o
>  endif
> 


