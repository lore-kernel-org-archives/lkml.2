Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0EQUlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:41:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab0EQUlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:41:44 -0400
Message-ID: <4BF1A9D9.7040004@redhat.com>
Date: Mon, 17 May 2010 16:40:57 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Conflict between tip/tracing/core and tip/perf/core
References: <1274122242.26328.375.camel@gandalf.stny.rr.com>
In-Reply-To: <1274122242.26328.375.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Hi,
> 
> Ingo asked me to resolve a conflict between tip/tracing/core and
> perf/core, and I came up with the below solution.
> 
> The conflict stems from the shrinking of TRACE_EVENT(), which affects
> both ftrace and perf (saves size on both too). It conflicts with:
> 
> 6cc8a7c1d8560c042f486b23318a6291569ab96b
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date:   Fri Mar 19 01:23:53 2010 +0100
> perf: Fetch hot regs from the template caller
> 
> 
> The shrinking code removed the per event caller to the template
> (TRACE_CLASS). This was done because the shrinking code allows the trace
> event to be passed to the tracepoint probe, and removed the need to have
> a separate function for every event because the class can now have the
> event passed to it.
> 
> The conflicting code added the regs to the per event probe, which no
> longer exists.
> 
> Masami,
> 
> It also conflicted with the kprobe code, which is also in the fix up.

Nice! thank you for fixing conflicts.
This looks good for me! :)

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> 
> 
> Here's my conflict resolution:
> 
> is everyone fine with it?
> 
> -- Steve
> 
> 
> diff --cc include/trace/ftrace.h
> index 4866c10,882c648..0000000
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@@ -690,18 -757,17 +690,20 @@@ __attribute__((section("_ftrace_events"
>   #undef DECLARE_EVENT_CLASS
>   #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
>   static notrace void							\
>  -perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
>  -			struct pt_regs *__regs, proto)			\
>  +perf_trace_##call(void *__data, proto)					\
>   {									\
>  +	struct ftrace_event_call *event_call = __data;			\
>   	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
>   	struct ftrace_raw_##call *entry;				\
> ++	struct pt_regs *__regs = &get_cpu_var(perf_trace_regs);		\
>   	u64 __addr = 0, __count = 1;					\
>   	unsigned long irq_flags;					\
> - 	struct pt_regs *__regs;						\
>   	int __entry_size;						\
>   	int __data_size;						\
>   	int rctx;							\
>   									\
> ++	perf_fetch_caller_regs(__regs, 1);				\
> ++									\
>   	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
>   	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
>   			     sizeof(u64));				\
> @@@ -718,27 -784,24 +720,25 @@@
>   									\
>   	{ assign; }							\
>   									\
> - 	__regs = &__get_cpu_var(perf_trace_regs);			\
> - 	perf_fetch_caller_regs(__regs, 2);				\
> - 									\
>   	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
>   			       __count, irq_flags, __regs);		\
> ++	put_cpu_var(perf_trace_regs);					\
>   }
>   
>  +/*
>  + * This part is compiled out, it is only here as a build time check
>  + * to make sure that if the tracepoint handling changes, the
>  + * perf probe will fail to compile unless it too is updated.
>  + */
>   #undef DEFINE_EVENT
>   #define DEFINE_EVENT(template, call, proto, args)			\
>  -static notrace void perf_trace_##call(proto)				\
>  +static inline void perf_test_probe_##call(void)				\
>   {									\
>  -	struct ftrace_event_call *event_call = &event_##call;		\
>  -	struct pt_regs *__regs = &get_cpu_var(perf_trace_regs);		\
>  -									\
>  -	perf_fetch_caller_regs(__regs, 1);				\
>  +	check_trace_callback_type_##call(perf_trace_##template);	\
>   									\
>  -	perf_trace_templ_##template(event_call, __regs, args);		\
>  -									\
>  -	put_cpu_var(perf_trace_regs);					\
>   }
>   
>  +
>   #undef DEFINE_EVENT_PRINT
>   #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
>   	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
> diff --cc kernel/trace/trace_kprobe.c
> index 0e3ded6,a751432..0000000
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@@ -202,8 -324,9 +324,9 @@@ struct trace_probe 
>   	unsigned long 		nhit;
>   	unsigned int		flags;	/* For TP_FLAG_* */
>   	const char		*symbol;	/* symbol name */
>  +	struct ftrace_event_class	class;
>   	struct ftrace_event_call	call;
>  -	struct trace_event		event;
> + 	ssize_t			size;		/* trace entry size */
>   	unsigned int		nr_args;
>   	struct probe_arg	args[];
>   };
> @@@ -795,11 -901,10 +902,10 @@@ static void probes_seq_stop(struct seq_
>   static int probes_seq_show(struct seq_file *m, void *v)
>   {
>   	struct trace_probe *tp = v;
> - 	int i, ret;
> - 	char buf[MAX_ARGSTR_LEN + 1];
> + 	int i;
>   
>   	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
>  -	seq_printf(m, ":%s/%s", tp->call.system, tp->call.name);
>  +	seq_printf(m, ":%s/%s", tp->call.class->system, tp->call.name);
>   
>   	if (!tp->symbol)
>   		seq_printf(m, " 0x%p", tp->rp.kp.addr);
> @@@ -958,10 -1059,10 +1060,10 @@@ static __kprobes void kprobe_trace_func
>   	local_save_flags(irq_flags);
>   	pc = preempt_count();
>   
> - 	size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
> + 	size = sizeof(*entry) + tp->size;
>   
>  -	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
>  -						  irq_flags, pc);
>  +	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
>  +						  size, irq_flags, pc);
>   	if (!event)
>   		return;
>   
> @@@ -990,10 -1092,10 +1093,10 @@@ static __kprobes void kretprobe_trace_f
>   	local_save_flags(irq_flags);
>   	pc = preempt_count();
>   
> - 	size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
> + 	size = sizeof(*entry) + tp->size;
>   
>  -	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
>  -						  irq_flags, pc);
>  +	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
>  +						  size, irq_flags, pc);
>   	if (!event)
>   		return;
>   
> @@@ -1010,16 -1112,18 +1113,17 @@@
>   
>   /* Event entry printers */
>   enum print_line_t
>  -print_kprobe_event(struct trace_iterator *iter, int flags)
>  +print_kprobe_event(struct trace_iterator *iter, int flags,
>  +		   struct trace_event *event)
>   {
> - 	struct kprobe_trace_entry *field;
> + 	struct kprobe_trace_entry_head *field;
>   	struct trace_seq *s = &iter->seq;
>  -	struct trace_event *event;
>   	struct trace_probe *tp;
> + 	u8 *data;
>   	int i;
>   
> - 	field = (struct kprobe_trace_entry *)iter->ent;
> + 	field = (struct kprobe_trace_entry_head *)iter->ent;
>  -	event = ftrace_find_event(field->ent.type);
>  -	tp = container_of(event, struct trace_probe, event);
>  +	tp = container_of(event, struct trace_probe, call.event);
>   
>   	if (!trace_seq_printf(s, "%s: (", tp->call.name))
>   		goto partial;
> @@@ -1044,16 -1149,18 +1149,17 @@@ partial
>   }
>   
>   enum print_line_t
>  -print_kretprobe_event(struct trace_iterator *iter, int flags)
>  +print_kretprobe_event(struct trace_iterator *iter, int flags,
>  +		      struct trace_event *event)
>   {
> - 	struct kretprobe_trace_entry *field;
> + 	struct kretprobe_trace_entry_head *field;
>   	struct trace_seq *s = &iter->seq;
>  -	struct trace_event *event;
>   	struct trace_probe *tp;
> + 	u8 *data;
>   	int i;
>   
> - 	field = (struct kretprobe_trace_entry *)iter->ent;
> + 	field = (struct kretprobe_trace_entry_head *)iter->ent;
>  -	event = ftrace_find_event(field->ent.type);
>  -	tp = container_of(event, struct trace_probe, event);
>  +	tp = container_of(event, struct trace_probe, call.event);
>   
>   	if (!trace_seq_printf(s, "%s: (", tp->call.name))
>   		goto partial;
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
