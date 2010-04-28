Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab0D1VGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:06:50 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:44440 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753626Ab0D1VGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:06:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPs+2EtGGNqG/2dsb2JhbACce3K+OIUOBA
Date: Wed, 28 Apr 2010 17:06:42 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/10][RFC] tracing: Remove duplicate id information in
	event structure
Message-ID: <20100428210642.GJ8591@Krystal>
References: <20100426195024.256424113@goodmis.org> <20100426200243.649349066@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100426200243.649349066@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:06:05 up 21 days,  6:59,  4 users,  load average: 0.17, 0.24,
	0.22
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Now that the trace_event structure is embedded in the ftrace_event_call
> structure, there is no need for the ftrace_event_call id field.
> The id field is the same as the trace_event type field.
> 
> Removing the id and re-arranging the structure brings down the tracepoint
> footprint by another 5K.

I might have missed it, but how exactly is the event type allocated
uniquely ? Is it barely a duplicate of the call "id" field ?

Thanks,

Mathieu

> 
>    text	   data	    bss	    dec	    hex	filename
> 5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
> 5761154	1268356	9351592	16381102	 f9f4ae	vmlinux.print
> 5761074	1262596	9351592	16375262	 f9ddde	vmlinux.id
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/ftrace_event.h       |    5 ++---
>  include/trace/ftrace.h             |   12 ++++++------
>  kernel/trace/trace_event_perf.c    |    4 ++--
>  kernel/trace/trace_events.c        |    7 +++----
>  kernel/trace/trace_events_filter.c |    2 +-
>  kernel/trace/trace_export.c        |    4 ++--
>  kernel/trace/trace_kprobe.c        |   18 ++++++++++--------
>  kernel/trace/trace_syscalls.c      |   14 ++++++++------
>  8 files changed, 34 insertions(+), 32 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index aa3695a..b26507f 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -147,14 +147,13 @@ struct ftrace_event_call {
>  	char			*name;
>  	struct dentry		*dir;
>  	struct trace_event	event;
> -	int			enabled;
> -	int			id;
>  	const char		*print_fmt;
> -	int			filter_active;
>  	struct event_filter	*filter;
>  	void			*mod;
>  	void			*data;
>  
> +	int			enabled;
> +	int			filter_active;
>  	int			perf_refcount;
>  };
>  
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index d7b3b56..246b05e 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -150,7 +150,7 @@
>   *
>   *	entry = iter->ent;
>   *
> - *	if (entry->type != event_<call>.id) {
> + *	if (entry->type != event_<call>->event.type) {
>   *		WARN_ON_ONCE(1);
>   *		return TRACE_TYPE_UNHANDLED;
>   *	}
> @@ -221,7 +221,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
>  									\
>  	entry = iter->ent;						\
>  									\
> -	if (entry->type != event->id) {					\
> +	if (entry->type != event->event.type) {				\
>  		WARN_ON_ONCE(1);					\
>  		return TRACE_TYPE_UNHANDLED;				\
>  	}								\
> @@ -257,7 +257,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
>  									\
>  	entry = iter->ent;						\
>  									\
> -	if (entry->type != event_##call.id) {				\
> +	if (entry->type != event_##call.event.type) {			\
>  		WARN_ON_ONCE(1);					\
>  		return TRACE_TYPE_UNHANDLED;				\
>  	}								\
> @@ -408,7 +408,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
>   *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
>   *
>   *	event = trace_current_buffer_lock_reserve(&buffer,
> - *				  event_<call>.id,
> + *				  event_<call>->event.type,
>   *				  sizeof(*entry) + __data_size,
>   *				  irq_flags, pc);
>   *	if (!event)
> @@ -509,7 +509,7 @@ ftrace_raw_event_##call(proto,						\
>  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
>  									\
>  	event = trace_current_buffer_lock_reserve(&buffer,		\
> -				 event_call->id,			\
> +				 event_call->event.type,		\
>  				 sizeof(*entry) + __data_size,		\
>  				 irq_flags, pc);			\
>  	if (!event)							\
> @@ -700,7 +700,7 @@ perf_trace_##call(proto, struct ftrace_event_call *event_call)		\
>  		      "profile buffer not large enough"))		\
>  		return;							\
>  	entry = (struct ftrace_raw_##call *)perf_trace_buf_prepare(	\
> -		__entry_size, event_call->id, &rctx, &irq_flags);	\
> +		__entry_size, event_call->event.type, &rctx, &irq_flags); \
>  	if (!entry)							\
>  		return;							\
>  	tstruct								\
> diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> index 95df5a7..b8febf0 100644
> --- a/kernel/trace/trace_event_perf.c
> +++ b/kernel/trace/trace_event_perf.c
> @@ -75,7 +75,7 @@ int perf_trace_enable(int event_id)
>  
>  	mutex_lock(&event_mutex);
>  	list_for_each_entry(event, &ftrace_events, list) {
> -		if (event->id == event_id &&
> +		if (event->event.type == event_id &&
>  		    event->class && event->class->perf_probe &&
>  		    try_module_get(event->mod)) {
>  			ret = perf_trace_event_enable(event);
> @@ -123,7 +123,7 @@ void perf_trace_disable(int event_id)
>  
>  	mutex_lock(&event_mutex);
>  	list_for_each_entry(event, &ftrace_events, list) {
> -		if (event->id == event_id) {
> +		if (event->event.type == event_id) {
>  			perf_trace_event_disable(event);
>  			module_put(event->mod);
>  			break;
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 9aa298e..8d2e28e 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -132,7 +132,6 @@ int trace_event_raw_init(struct ftrace_event_call *call)
>  	id = register_ftrace_event(&call->event);
>  	if (!id)
>  		return -ENODEV;
> -	call->id = id;
>  
>  	return 0;
>  }
> @@ -574,7 +573,7 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
>  	trace_seq_init(s);
>  
>  	trace_seq_printf(s, "name: %s\n", call->name);
> -	trace_seq_printf(s, "ID: %d\n", call->id);
> +	trace_seq_printf(s, "ID: %d\n", call->event.type);
>  	trace_seq_printf(s, "format:\n");
>  
>  	head = trace_get_fields(call);
> @@ -648,7 +647,7 @@ event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
>  		return -ENOMEM;
>  
>  	trace_seq_init(s);
> -	trace_seq_printf(s, "%d\n", call->id);
> +	trace_seq_printf(s, "%d\n", call->event.type);
>  
>  	r = simple_read_from_buffer(ubuf, cnt, ppos,
>  				    s->buffer, s->len);
> @@ -974,7 +973,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
>  		trace_create_file("enable", 0644, call->dir, call,
>  				  enable);
>  
> -	if (call->id && (call->class->perf_probe || call->class->reg))
> +	if (call->event.type && (call->class->perf_probe || call->class->reg))
>  		trace_create_file("id", 0444, call->dir, call,
>  		 		  id);
>  
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 560683d..b8e3bf3 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -1394,7 +1394,7 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
>  	mutex_lock(&event_mutex);
>  
>  	list_for_each_entry(call, &ftrace_events, list) {
> -		if (call->id == event_id)
> +		if (call->event.type == event_id)
>  			break;
>  	}
>  
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index e878d06..8536e2a 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -153,7 +153,7 @@ static int ftrace_raw_init_event(struct ftrace_event_call *call)
>  #define F_printk(fmt, args...) #fmt ", "  __stringify(args)
>  
>  #undef FTRACE_ENTRY
> -#define FTRACE_ENTRY(call, struct_name, type, tstruct, print)		\
> +#define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\
>  									\
>  struct ftrace_event_class event_class_ftrace_##call = {			\
>  	.system			= __stringify(TRACE_SYSTEM),		\
> @@ -165,7 +165,7 @@ struct ftrace_event_call __used						\
>  __attribute__((__aligned__(4)))						\
>  __attribute__((section("_ftrace_events"))) event_##call = {		\
>  	.name			= #call,				\
> -	.id			= type,					\
> +	.event.type		= etype,				\
>  	.class			= &event_class_ftrace_##call,		\
>  	.print_fmt		= print,				\
>  };									\
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index d8061c3..934078b 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -960,8 +960,8 @@ static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
>  
>  	size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
>  
> -	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
> -						  irq_flags, pc);
> +	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
> +						  size, irq_flags, pc);
>  	if (!event)
>  		return;
>  
> @@ -992,8 +992,8 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
>  
>  	size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
>  
> -	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
> -						  irq_flags, pc);
> +	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
> +						  size, irq_flags, pc);
>  	if (!event)
>  		return;
>  
> @@ -1228,7 +1228,8 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
>  		     "profile buffer not large enough"))
>  		return;
>  
> -	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
> +	entry = perf_trace_buf_prepare(size, call->event.type,
> +				       &rctx, &irq_flags);
>  	if (!entry)
>  		return;
>  
> @@ -1258,7 +1259,8 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
>  		     "profile buffer not large enough"))
>  		return;
>  
> -	entry = perf_trace_buf_prepare(size, call->id, &rctx, &irq_flags);
> +	entry = perf_trace_buf_prepare(size, call->event.type,
> +				       &rctx, &irq_flags);
>  	if (!entry)
>  		return;
>  
> @@ -1375,8 +1377,8 @@ static int register_probe_event(struct trace_probe *tp)
>  	}
>  	if (set_print_fmt(tp) < 0)
>  		return -ENOMEM;
> -	call->id = register_ftrace_event(&call->event);
> -	if (!call->id) {
> +	ret = register_ftrace_event(&call->event);
> +	if (!ret) {
>  		kfree(call->print_fmt);
>  		return -ENODEV;
>  	}
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index a4bed39..23fad22 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -108,7 +108,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
>  	if (!entry)
>  		goto end;
>  
> -	if (entry->enter_event->id != ent->type) {
> +	if (entry->enter_event->event.type != ent->type) {
>  		WARN_ON_ONCE(1);
>  		goto end;
>  	}
> @@ -164,7 +164,7 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
>  		return TRACE_TYPE_HANDLED;
>  	}
>  
> -	if (entry->exit_event->id != ent->type) {
> +	if (entry->exit_event->event.type != ent->type) {
>  		WARN_ON_ONCE(1);
>  		return TRACE_TYPE_UNHANDLED;
>  	}
> @@ -306,7 +306,7 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
>  	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
>  
>  	event = trace_current_buffer_lock_reserve(&buffer,
> -			sys_data->enter_event->id, size, 0, 0);
> +			sys_data->enter_event->event.type, size, 0, 0);
>  	if (!event)
>  		return;
>  
> @@ -338,7 +338,7 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
>  		return;
>  
>  	event = trace_current_buffer_lock_reserve(&buffer,
> -			sys_data->exit_event->id, sizeof(*entry), 0, 0);
> +			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
>  	if (!event)
>  		return;
>  
> @@ -502,7 +502,8 @@ static void perf_syscall_enter(struct pt_regs *regs, long id)
>  		return;
>  
>  	rec = (struct syscall_trace_enter *)perf_trace_buf_prepare(size,
> -				sys_data->enter_event->id, &rctx, &flags);
> +				sys_data->enter_event->event.type,
> +				&rctx, &flags);
>  	if (!rec)
>  		return;
>  
> @@ -577,7 +578,8 @@ static void perf_syscall_exit(struct pt_regs *regs, long ret)
>  		return;
>  
>  	rec = (struct syscall_trace_exit *)perf_trace_buf_prepare(size,
> -				sys_data->exit_event->id, &rctx, &flags);
> +				sys_data->exit_event->event.type,
> +				&rctx, &flags);
>  	if (!rec)
>  		return;
>  
> -- 
> 1.7.0
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
