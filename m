Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212Ab2BBSOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 13:14:18 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37979 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab2BBSOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:14:16 -0500
Date: Thu, 2 Feb 2012 19:14:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 5/7] ftrace, perf: Add support to use function tracepoint
 in perf
Message-ID: <20120202181409.GH9071@somewhere.redhat.com>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-6-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327776209-4883-6-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 07:43:27PM +0100, Jiri Olsa wrote:
> Adding perf registration support for the ftrace function event,
> so it is now possible to register it via perf interface.
> 
> The perf_event struct statically contains ftrace_ops as a handle
> for function tracer. The function tracer is registered/unregistered
> in open/close actions.
> 
> To be efficient, we enable/disable ftrace_ops each time the traced
> process is scheduled in/out (via TRACE_REG_PERF_(ADD|DELL) handlers).
> This way tracing is enabled only when the process is running.
> Intentionally using this way instead of the event's hw state
> PERF_HES_STOPPED, which would not disable the ftrace_ops.
> 
> It is now possible to use function trace within perf commands
> like:
> 
>   perf record -e ftrace:function ls
>   perf stat -e ftrace:function ls
> 
> Allowed only for root.

Good idea. We probably don't want to leak the rate of calls of a kernel
function to userspace.

[...]
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
> +	ops->func = perf_ftrace_function_call;
> +	return register_ftrace_function(ops);
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
> +	ftrace_function_local_enable(&event->ftrace_ops);
> +}
> +
> +static void perf_ftrace_function_disable(struct perf_event *event)
> +{
> +	ftrace_function_local_disable(&event->ftrace_ops);
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

All the above from perf_ftrace_function_call() to here should perhaps
go to trace_function.c.

> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index bbeec31..867653c 100644
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

Hmm, one day we'll need to demux here. What about adding an argument to
FTRACE_ENTRY() to add the pointer to .reg ?

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
> @@ -170,4 +193,9 @@ struct ftrace_event_call __used event_##call = {			\
>  struct ftrace_event_call __used						\
>  __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
>  
> +int ftrace_event_is_function(struct ftrace_event_call *call)
> +{
> +	return call == &event_function;
> +}
> +
>  #include "trace_entries.h"
> -- 
> 1.7.1
> 
