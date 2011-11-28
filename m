Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1K1T6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:58:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33762 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab1K1T6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:58:41 -0500
X-Authority-Analysis: v=2.0 cv=Xd0LPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=jMOZBfb3lLUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=20KFwNOVAAAA:8 a=O3ncQbarzBxRJo1qyd0A:9 a=gtA45S13avDDC1mruRsA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 7/9] ftrace, perf: Add support to use function
 tracepoint in perf
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1322417074-5834-8-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-8-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 14:58:38 -0500
Message-ID: <1322510318.17003.14.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-27 at 19:04 +0100, Jiri Olsa wrote:
> Adding perf registration support for the ftrace function event,
> so it is now possible to register it via perf interface.
> 
> The perf_event struct statically contains ftrace_ops as a handle
> for function tracer. The function tracer is registered/unregistered
> in open/close actions, and enabled/disabled in add/del actions.
> 
> It is now possible to use function trace within perf commands
> like:
> 
>   perf record -e ftrace:function ls
>   perf stat -e ftrace:function ls

Question. This is a root only command, correct? Otherwise, we are
allowing any user to create a large performance impact to the system.

> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  include/linux/perf_event.h      |    3 +
>  kernel/trace/trace_event_perf.c |   88 +++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_export.c     |   23 ++++++++++
>  3 files changed, 114 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 1e9ebe5..6071995 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -847,6 +847,9 @@ struct perf_event {
>  #ifdef CONFIG_EVENT_TRACING
>  	struct ftrace_event_call	*tp_event;
>  	struct event_filter		*filter;
> +#ifdef CONFIG_FUNCTION_TRACER
> +	struct ftrace_ops               ftrace_ops;
> +#endif
>  #endif
>  
>  #ifdef CONFIG_CGROUP_PERF
> diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> index d72af0b..4be0f73 100644
> --- a/kernel/trace/trace_event_perf.c
> +++ b/kernel/trace/trace_event_perf.c
> @@ -250,3 +250,91 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
>  	return raw_data;
>  }
>  EXPORT_SYMBOL_GPL(perf_trace_buf_prepare);
> +
> +
> +static void
> +perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip)
> +{
> +	struct ftrace_entry *entry;
> +	struct hlist_head *head;
> +	struct pt_regs regs;
> +	int rctx;
> +
> +#define ENTRY_SIZE (ALIGN(sizeof(struct ftrace_entry) + sizeof(u32), \
> +		    sizeof(u64)) - sizeof(u32))
> +
> +	BUILD_BUG_ON(ENTRY_SIZE > PERF_MAX_TRACE_SIZE);
> +
> +	perf_fetch_caller_regs(&regs);
> +
> +	entry = perf_trace_buf_prepare(ENTRY_SIZE, TRACE_FN, NULL, &rctx);
> +	if (!entry)
> +		return;
> +
> +	entry->ip = ip;
> +	entry->parent_ip = parent_ip;
> +
> +	head = this_cpu_ptr(event_function.perf_events);
> +	perf_trace_buf_submit(entry, ENTRY_SIZE, rctx, 0,
> +			      1, &regs, head);
> +
> +#undef ENTRY_SIZE
> +}
> +
> +static int perf_ftrace_function_register(struct perf_event *event)
> +{
> +	struct ftrace_ops *ops = &event->ftrace_ops;
> +
> +	ops->flags |= FTRACE_OPS_FL_CONTROL;
> +	atomic_set(&ops->disabled, 1);
> +	ops->func = perf_ftrace_function_call;
> +	return register_ftrace_function(ops);

When is ADD called? Because as soon as you register this function, even
though you have it "disabled" the system takes about a 13% impact on
performance just by calling this.

> +}
> +
> +static int perf_ftrace_function_unregister(struct perf_event *event)
> +{
> +	struct ftrace_ops *ops = &event->ftrace_ops;
> +	return unregister_ftrace_function(ops);
> +}
> +
> +static void perf_ftrace_function_enable(struct perf_event *event)
> +{
> +	struct ftrace_ops *ops = &event->ftrace_ops;
> +	enable_ftrace_function(ops);

Is it really an issue that we shouldn't call the full blown register
instead? I'm not really understanding why this is a problem. Note, one
of the improvements to ftrace in the near future is to enable ftrace
without stop_machine.

-- Steve

> +}
> +
> +static void perf_ftrace_function_disable(struct perf_event *event)
> +{
> +	struct ftrace_ops *ops = &event->ftrace_ops;
> +	disable_ftrace_function(ops);
> +}
> +
> +int perf_ftrace_event_register(struct ftrace_event_call *call,
> +			       enum trace_reg type, void *data)
> +{
> +	int etype = call->event.type;
> +
> +	if (etype != TRACE_FN)
> +		return -EINVAL;
> +
> +	switch (type) {
> +	case TRACE_REG_REGISTER:
> +	case TRACE_REG_UNREGISTER:
> +		break;
> +	case TRACE_REG_PERF_REGISTER:
> +	case TRACE_REG_PERF_UNREGISTER:
> +		return 0;
> +	case TRACE_REG_PERF_OPEN:
> +		return perf_ftrace_function_register(data);
> +	case TRACE_REG_PERF_CLOSE:
> +		return perf_ftrace_function_unregister(data);
> +	case TRACE_REG_PERF_ADD:
> +		perf_ftrace_function_enable(data);
> +		return 0;
> +	case TRACE_REG_PERF_DEL:
> +		perf_ftrace_function_disable(data);
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index bbeec31..62e86a5 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -131,6 +131,28 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
>  
>  #include "trace_entries.h"
>  
> +static int ftrace_event_class_register(struct ftrace_event_call *call,
> +				       enum trace_reg type, void *data)
> +{
> +	switch (type) {
> +	case TRACE_REG_PERF_REGISTER:
> +	case TRACE_REG_PERF_UNREGISTER:
> +		return 0;
> +	case TRACE_REG_PERF_OPEN:
> +	case TRACE_REG_PERF_CLOSE:
> +	case TRACE_REG_PERF_ADD:
> +	case TRACE_REG_PERF_DEL:
> +#ifdef CONFIG_PERF_EVENTS
> +		return perf_ftrace_event_register(call, type, data);
> +#endif
> +	case TRACE_REG_REGISTER:
> +	case TRACE_REG_UNREGISTER:
> +		break;
> +	}
> +
> +	return -EINVAL;
> +}
> +
>  #undef __entry
>  #define __entry REC
>  
> @@ -159,6 +181,7 @@ struct ftrace_event_class event_class_ftrace_##call = {			\
>  	.system			= __stringify(TRACE_SYSTEM),		\
>  	.define_fields		= ftrace_define_fields_##call,		\
>  	.fields			= LIST_HEAD_INIT(event_class_ftrace_##call.fields),\
> +	.reg			= ftrace_event_class_register,		\
>  };									\
>  									\
>  struct ftrace_event_call __used event_##call = {			\


