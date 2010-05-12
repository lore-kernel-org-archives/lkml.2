Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0ELSbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:31:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63696 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab0ELSbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:31:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FJuImf8iPGcwnfXTWYwJisc6jBqJ8R+bmxl/FTsOMlUeqfY/mDPHJFnDX9Udj0wUug
         k76zmM0rxBZvjSnbSJgs+t35vmPaYFngnk+syme+g4JpwV/dqDhciOtBc9292k3ZckOf
         GMlP731O8kM81kS2b2wEPpzGrDZ51MAaatOjU=
Date: Wed, 12 May 2010 20:31:04 +0200
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
Subject: Re: [PATCH 07/10 final] tracing: Allow events to share their print
	functions
Message-ID: <20100512183100.GA10028@nowhere>
References: <20100512152810.819338250@goodmis.org> <20100512152854.079439206@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512152854.079439206@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 11:28:17AM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Multiple events may use the same method to print their data.
> Instead of having all events have a pointer to their print funtions,
> the trace_event structure now points to a trace_event_functions structure
> that will hold the way to print ouf the event.
> 
> The event itself is now passed to the print function to let the print
> function know what kind of event it should print.
> 
> This opens the door to consolidating the way several events print
> their output.
> 
>    text	   data	    bss	    dec	    hex	filename
> 4913961	1088356	 861512	6863829	 68bbd5	vmlinux.orig
> 4900382	1048964	 861512	6810858	 67ecea	vmlinux.init
> 4900446	1049028	 861512	6810986	 67ed6a	vmlinux.preprint
> 
> This change slightly increases the size but is needed for the next change.
> 
> v2: Fix the new function graph tracer event calls to handle this change.
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/ftrace_event.h         |   17 +++-
>  include/linux/syscalls.h             |   10 ++-
>  include/trace/ftrace.h               |   13 ++-
>  include/trace/syscall.h              |    6 +-
>  kernel/trace/blktrace.c              |   13 ++-
>  kernel/trace/kmemtrace.c             |   28 +++++--
>  kernel/trace/trace.c                 |    9 +-
>  kernel/trace/trace_functions_graph.c |   13 ++-
>  kernel/trace/trace_kprobe.c          |   22 ++++--
>  kernel/trace/trace_output.c          |  137 +++++++++++++++++++++++-----------
>  kernel/trace/trace_output.h          |    2 +-
>  kernel/trace/trace_syscalls.c        |    6 +-
>  12 files changed, 186 insertions(+), 90 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 393a839..4f77932 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -70,18 +70,25 @@ struct trace_iterator {
>  };
>  
>  
> +struct trace_event;
> +
>  typedef enum print_line_t (*trace_print_func)(struct trace_iterator *iter,
> -					      int flags);
> -struct trace_event {
> -	struct hlist_node	node;
> -	struct list_head	list;
> -	int			type;
> +				      int flags, struct trace_event *event);
> +
> +struct trace_event_functions {
>  	trace_print_func	trace;
>  	trace_print_func	raw;
>  	trace_print_func	hex;
>  	trace_print_func	binary;
>  };
>  
> +struct trace_event {
> +	struct hlist_node		node;
> +	struct list_head		list;
> +	int				type;
> +	struct trace_event_functions	*funcs;
> +};
> +
>  extern int register_ftrace_event(struct trace_event *event);
>  extern int unregister_ftrace_event(struct trace_event *event);
>  
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 211c704..f725677 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -125,9 +125,12 @@ extern struct ftrace_event_class event_class_syscall_exit;
>  	static struct syscall_metadata __syscall_meta_##sname;		\
>  	static struct ftrace_event_call					\
>  	__attribute__((__aligned__(4))) event_enter_##sname;		\
> -	static struct trace_event enter_syscall_print_##sname = {	\
> +	static struct trace_event_functions enter_syscall_print_funcs_##sname = { \
>  		.trace                  = print_syscall_enter,		\
>  	};								\
> +	static struct trace_event enter_syscall_print_##sname = {	\
> +		.funcs                  = &enter_syscall_print_funcs_##sname, \
> +	};								\



It looks like having a generic enter_syscall_print_func and enter_syscall_print
would reduce the footprint even more.

I'll make an incremental patch.

