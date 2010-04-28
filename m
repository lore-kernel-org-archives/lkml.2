Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab0D1VAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:00:12 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:59817 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856Ab0D1VAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:00:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPs+2EtGGNqG/2dsb2JhbACce3K+OIUOBA
Date: Wed, 28 Apr 2010 17:00:00 -0400
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
Subject: Re: [PATCH 06/10][RFC] tracing: Move raw_init from events to class
Message-ID: <20100428210000.GG8591@Krystal>
References: <20100426195024.256424113@goodmis.org> <20100426200242.757929062@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100426200242.757929062@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:59:48 up 21 days,  6:53,  4 users,  load average: 0.02, 0.14,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The raw_init function pointer in the event is used to initialize
> various kinds of events. The type of initialization needed is usually
> classed to the kind of event it is.
> 
> Two events with the same class will always have the same initialization
> function, so it makes sense to move this to the class structure.
> 
> Perhaps even making a special system structure would work since
> the initialization is the same for all events within a system.
> But since there's no system structure (yet), this will just move it
> to the class.
> 
>    text	   data	    bss	    dec	    hex	filename
> 5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
> 5774567	1297492	9351592	16423651	 fa9ae3	vmlinux.fields
> 5774510	1293204	9351592	16419306	 fa89ea	vmlinux.init
> 
> The text grew very slightly, but this is a constant growth that happened
> with the changing of the C files that call the init code.
> The bigger savings is the data which will be saved the more events share
> a class.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> ---
>  include/linux/ftrace_event.h  |    2 +-
>  include/linux/syscalls.h      |    2 --
>  include/trace/ftrace.h        |    8 ++++----
>  kernel/trace/trace_events.c   |   12 ++++++------
>  kernel/trace/trace_export.c   |    2 +-
>  kernel/trace/trace_kprobe.c   |    6 +++---
>  kernel/trace/trace_syscalls.c |    2 ++
>  7 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 1e2c8f5..655de69 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -131,6 +131,7 @@ struct ftrace_event_class {
>  	int			(*define_fields)(struct ftrace_event_call *);
>  	struct list_head	*(*get_fields)(struct ftrace_event_call *);
>  	struct list_head	fields;
> +	int			(*raw_init)(struct ftrace_event_call *);
>  };
>  
>  struct ftrace_event_call {
> @@ -142,7 +143,6 @@ struct ftrace_event_call {
>  	int			enabled;
>  	int			id;
>  	const char		*print_fmt;
> -	int			(*raw_init)(struct ftrace_event_call *);
>  	int			filter_active;
>  	struct event_filter	*filter;
>  	void			*mod;
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index ef4f81c..a0db1e8 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -135,7 +135,6 @@ extern struct ftrace_event_class event_class_syscall_exit;
>  		.name                   = "sys_enter"#sname,		\
>  		.class			= &event_class_syscall_enter,	\
>  		.event                  = &enter_syscall_print_##sname,	\
> -		.raw_init		= init_syscall_trace,		\
>  		.data			= (void *)&__syscall_meta_##sname,\
>  	}
>  
> @@ -153,7 +152,6 @@ extern struct ftrace_event_class event_class_syscall_exit;
>  		.name                   = "sys_exit"#sname,		\
>  		.class			= &event_class_syscall_exit,	\
>  		.event                  = &exit_syscall_print_##sname,	\
> -		.raw_init		= init_syscall_trace,		\
>  		.data			= (void *)&__syscall_meta_##sname,\
>  	}
>  
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index e6ec392..de0d96c 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -430,8 +430,9 @@ static inline notrace int ftrace_get_offsets_##call(			\
>   * static struct ftrace_event_class __used event_class_<template> = {
>   *	.system			= "<system>",
>   *	.define_fields		= ftrace_define_fields_<call>,
> -	.fields			= LIST_HEAD_INIT(event_class_##call.fields),\
> -	.probe			= ftrace_raw_event_##call,		\
> + *	.fields			= LIST_HEAD_INIT(event_class_##call.fields),
> + *	.raw_init		= trace_event_raw_init,
> + *	.probe			= ftrace_raw_event_##call,
>   * }
>   *
>   * static struct ftrace_event_call __used
> @@ -439,7 +440,6 @@ static inline notrace int ftrace_get_offsets_##call(			\
>   * __attribute__((section("_ftrace_events"))) event_<call> = {
>   *	.name			= "<call>",
>   *	.class			= event_class_<template>,
> - *	.raw_init		= trace_event_raw_init,
>   *	.event			= &ftrace_event_type_<call>,
>   *	.print_fmt		= print_fmt_<call>,
>   * }
> @@ -555,6 +555,7 @@ static struct ftrace_event_class __used event_class_##call = {		\
>  	.system			= __stringify(TRACE_SYSTEM),		\
>  	.define_fields		= ftrace_define_fields_##call,		\
>  	.fields			= LIST_HEAD_INIT(event_class_##call.fields),\
> +	.raw_init		= trace_event_raw_init,			\
>  	.probe			= ftrace_raw_event_##call,		\
>  	_TRACE_PERF_INIT(call)						\
>  }
> @@ -568,7 +569,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
>  	.name			= #call,				\
>  	.class			= &event_class_##template,		\
>  	.event			= &ftrace_event_type_##call,		\
> -	.raw_init		= trace_event_raw_init,			\
>  	.print_fmt		= print_fmt_##template,			\
>  }
>  
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index c31632e..c34a9bd 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1012,8 +1012,8 @@ static int __trace_add_event_call(struct ftrace_event_call *call)
>  	if (!call->name)
>  		return -EINVAL;
>  
> -	if (call->raw_init) {
> -		ret = call->raw_init(call);
> +	if (call->class->raw_init) {
> +		ret = call->class->raw_init(call);
>  		if (ret < 0) {
>  			if (ret != -ENOSYS)
>  				pr_warning("Could not initialize trace "
> @@ -1174,8 +1174,8 @@ static void trace_module_add_events(struct module *mod)
>  		/* The linker may leave blanks */
>  		if (!call->name)
>  			continue;
> -		if (call->raw_init) {
> -			ret = call->raw_init(call);
> +		if (call->class->raw_init) {
> +			ret = call->class->raw_init(call);
>  			if (ret < 0) {
>  				if (ret != -ENOSYS)
>  					pr_warning("Could not initialize trace "
> @@ -1328,8 +1328,8 @@ static __init int event_trace_init(void)
>  		/* The linker may leave blanks */
>  		if (!call->name)
>  			continue;
> -		if (call->raw_init) {
> -			ret = call->raw_init(call);
> +		if (call->class->raw_init) {
> +			ret = call->class->raw_init(call);
>  			if (ret < 0) {
>  				if (ret != -ENOSYS)
>  					pr_warning("Could not initialize trace "
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index e700a0c..e878d06 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -158,6 +158,7 @@ static int ftrace_raw_init_event(struct ftrace_event_call *call)
>  struct ftrace_event_class event_class_ftrace_##call = {			\
>  	.system			= __stringify(TRACE_SYSTEM),		\
>  	.define_fields		= ftrace_define_fields_##call,		\
> +	.raw_init		= ftrace_raw_init_event,		\
>  };									\
>  									\
>  struct ftrace_event_call __used						\
> @@ -166,7 +167,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
>  	.name			= #call,				\
>  	.id			= type,					\
>  	.class			= &event_class_ftrace_##call,		\
> -	.raw_init		= ftrace_raw_init_event,		\
>  	.print_fmt		= print,				\
>  };									\
>  
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index b14bf74..428f4a5 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1359,13 +1359,13 @@ static int register_probe_event(struct trace_probe *tp)
>  	/* Initialize ftrace_event_call */
>  	if (probe_is_return(tp)) {
>  		tp->event.trace = print_kretprobe_event;
> -		call->raw_init = probe_event_raw_init;
>  		INIT_LIST_HEAD(&call->class->fields);
> +		call->class->raw_init = probe_event_raw_init;
>  		call->class->define_fields = kretprobe_event_define_fields;
>  	} else {
> -		tp->event.trace = print_kprobe_event;
> -		call->raw_init = probe_event_raw_init;
>  		INIT_LIST_HEAD(&call->class->fields);
> +		tp->event.trace = print_kprobe_event;
> +		call->class->raw_init = probe_event_raw_init;
>  		call->class->define_fields = kprobe_event_define_fields;
>  	}
>  	if (set_print_fmt(tp) < 0)
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index eb535ba..7ee6086 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -35,6 +35,7 @@ struct ftrace_event_class event_class_syscall_enter = {
>  	.reg			= syscall_enter_register,
>  	.define_fields		= syscall_enter_define_fields,
>  	.get_fields		= syscall_get_fields,
> +	.raw_init		= init_syscall_trace,
>  };
>  
>  struct ftrace_event_class event_class_syscall_exit = {
> @@ -42,6 +43,7 @@ struct ftrace_event_class event_class_syscall_exit = {
>  	.reg			= syscall_exit_register,
>  	.define_fields		= syscall_exit_define_fields,
>  	.get_fields		= syscall_get_fields,
> +	.raw_init		= init_syscall_trace,
>  };
>  
>  extern unsigned long __start_syscalls_metadata[];
> -- 
> 1.7.0
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
