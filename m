Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab0ELShj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:37:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64876 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab0ELShh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wlJb/Ko8V86W15pyu5UU5rWK0+BtMv/IHZWuiOBvjP6cwBndzCHYqbNOmtdMkAvIp4
         QEUBfjYnG3CaeNMjorX4TgffjXTB6KVpn7jnl1uBY4x44Ekp7igH98PeqJKr3cLW1Yhe
         w4R9GarqxuJgQVkOIepgsV7hdkzmn8h9fiseM=
Date: Wed, 12 May 2010 20:37:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 08/10 final] tracing: Move print functions into event
	class
Message-ID: <20100512183733.GB10028@nowhere>
References: <20100512152810.819338250@goodmis.org> <20100512152854.333118709@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512152854.333118709@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 11:28:18AM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Currently, every event has its own trace_event structure. This is
> fine since the structure is needed anyway. But the print function
> structure (trace_event_functions) is now separate. Since the output
> of the trace event is done by the class (with the exception of events
> defined by DEFINE_EVENT_PRINT), it makes sense to have the class
> define the print functions that all events in the class can use.
> 
> This makes a bigger deal with the syscall events since all syscall events
> use the same class. The savings here is another 30K.
> 
>    text	   data	    bss	    dec	    hex	filename
> 4913961	1088356	 861512	6863829	 68bbd5	vmlinux.orig
> 4900382	1048964	 861512	6810858	 67ecea	vmlinux.init
> 4900446	1049028	 861512	6810986	 67ed6a	vmlinux.preprint
> 4895024	1023812	 861512	6780348	 6775bc	vmlinux.print
> 
> To accomplish this, and to let the class know what event is being
> printed, the event structure is embedded in the ftrace_event_call
> structure. This should not be an issues since the event structure
> was created for each event anyway.
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/ftrace_event.h  |    2 +-
>  include/linux/syscalls.h      |   18 +++------------
>  include/trace/ftrace.h        |   45 +++++++++++++++++-----------------------
>  kernel/trace/trace_events.c   |    6 ++--
>  kernel/trace/trace_kprobe.c   |   14 +++++-------
>  kernel/trace/trace_syscalls.c |    8 +++++++
>  6 files changed, 41 insertions(+), 52 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 4f77932..b1a007d 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -148,7 +148,7 @@ struct ftrace_event_call {
>  	struct ftrace_event_class *class;
>  	char			*name;
>  	struct dentry		*dir;
> -	struct trace_event	*event;
> +	struct trace_event	event;
>  	int			enabled;
>  	int			id;
>  	const char		*print_fmt;
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index f725677..a1a86a5 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -120,24 +120,20 @@ struct perf_event_attr;
>  
>  extern struct ftrace_event_class event_class_syscall_enter;
>  extern struct ftrace_event_class event_class_syscall_exit;
> +extern struct trace_event_functions enter_syscall_print_funcs;
> +extern struct trace_event_functions exit_syscall_print_funcs;
>  
>  #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
>  	static struct syscall_metadata __syscall_meta_##sname;		\
>  	static struct ftrace_event_call					\
>  	__attribute__((__aligned__(4))) event_enter_##sname;		\
> -	static struct trace_event_functions enter_syscall_print_funcs_##sname = { \
> -		.trace                  = print_syscall_enter,		\
> -	};								\
> -	static struct trace_event enter_syscall_print_##sname = {	\
> -		.funcs                  = &enter_syscall_print_funcs_##sname, \
> -	};								\
>  	static struct ftrace_event_call __used				\
>  	  __attribute__((__aligned__(4)))				\
>  	  __attribute__((section("_ftrace_events")))			\
>  	  event_enter_##sname = {					\
>  		.name                   = "sys_enter"#sname,		\
>  		.class			= &event_class_syscall_enter,	\
> -		.event                  = &enter_syscall_print_##sname,	\
> +		.event.funcs            = &enter_syscall_print_funcs,	\



Ah ok, looks like I don't need to write this patch in fact :)

