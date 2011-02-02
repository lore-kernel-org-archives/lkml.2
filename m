Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1BBSmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:42:05 -0500
Received: from mail.openrapids.net ([64.15.138.104]:53959 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754681Ab1BBSmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:42:04 -0500
Date: Wed, 2 Feb 2011 13:42:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] tracing: Replace trace_event struct array with
	pointer array
Message-ID: <20110202184201.GC27022@Krystal>
References: <20110202180613.978219945@goodmis.org> <20110202180938.106599012@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202180938.106599012@goodmis.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:36:16 up 70 days, 23:39,  3 users,  load average: 0.06, 0.04,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Currently the trace_event structures are placed in the _ftrace_events
> section, and at link time, the linker makes one large array of all
> the trace_event structures. On boot up, this array is read (much like
> the initcall sections) and the events are processed.
> 
> The problem is that there is no guarantee that gcc will place complex
> structures nicely together in an array format. Two structures in the
> same file may be placed awkwardly, because gcc has no clue that they
> are suppose to be in an array.
> 
> A hack was used previous to force the alignment to 4, to pack the
> structures together. But this caused alignment issues with other
> architectures (sparc).
> 
> Instead of packing the structures into an array, the structures' addresses
> are now put into the _ftrace_event section. As pointers are always the
> natural alignment, gcc should always pack them tightly together
> (otherwise initcall, extable, etc would also fail).
> 
> By having the pointers to the structures in the section, we can still
> iterate the trace_events without causing unnecessary alignment problems
> with other architectures, or depending on the current behaviour of
> gcc that will likely change in the future just to tick us kernel developers
> off a little more.
> 
> The _ftrace_event section is also moved into the .init.data section
> as it is now only needed at boot up.
> 
> Suggested-by: David Miller <davem@davemloft.net>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/asm-generic/vmlinux.lds.h |    7 +++----
>  include/linux/module.h            |    2 +-
>  include/linux/syscalls.h          |   10 ++++++----
>  include/trace/ftrace.h            |   24 +++++++++++++-----------
>  kernel/trace/trace_events.c       |   12 ++++++------
>  kernel/trace/trace_export.c       |    6 +++---
>  6 files changed, 32 insertions(+), 29 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 6ebb810..f53708b 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -124,7 +124,8 @@
>  #endif
>  
>  #ifdef CONFIG_EVENT_TRACING
> -#define FTRACE_EVENTS()	VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
> +#define FTRACE_EVENTS()	. = ALIGN(8);					\
> +			VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
>  			*(_ftrace_events)				\
>  			VMLINUX_SYMBOL(__stop_ftrace_events) = .;
>  #else
> @@ -179,9 +180,6 @@
>  	TRACE_PRINTKS()							\
>  									\
>  	STRUCT_ALIGN();							\
> -	FTRACE_EVENTS()							\
> -									\
> -	STRUCT_ALIGN();							\
>  	TRACE_SYSCALLS()

You seem to have forgotten to fix the __syscalls_metadata table. Do you plan to
do it in another patch ? Its code is pretty much interleaving with the ftrace
code, so it might make sense to do both fixes in one go.

[...]
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index e16610c..3e68366 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -446,14 +446,16 @@ static inline notrace int ftrace_get_offsets_##call(			\
>   *	.reg			= ftrace_event_reg,
>   * };
>   *
> - * static struct ftrace_event_call __used
> - * __attribute__((__aligned__(4)))
> - * __attribute__((section("_ftrace_events"))) event_<call> = {
> + * static struct ftrace_event_call event_<call> = {
>   *	.name			= "<call>",
>   *	.class			= event_class_<template>,
>   *	.event			= &ftrace_event_type_<call>,
>   *	.print_fmt		= print_fmt_<call>,
>   * };
> + * // its only safe to use pointers when doing linker tricks to
> + * // create an array.

Odd comment style.

The rest looks good.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
