Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2BCNAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:00:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab2BCNAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:00:53 -0500
Date: Fri, 3 Feb 2012 14:00:43 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 5/7] ftrace, perf: Add support to use function tracepoint
 in perf
Message-ID: <20120203130043.GC1531@m.brq.redhat.com>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-6-git-send-email-jolsa@redhat.com>
 <20120202181409.GH9071@somewhere.redhat.com>
 <20120203125413.GB1531@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203125413.GB1531@m.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 01:54:13PM +0100, Jiri Olsa wrote:
> On Thu, Feb 02, 2012 at 07:14:12PM +0100, Frederic Weisbecker wrote:
> > On Sat, Jan 28, 2012 at 07:43:27PM +0100, Jiri Olsa wrote:
> > > Adding perf registration support for the ftrace function event,
> > > so it is now possible to register it via perf interface.
> > > 
> > > The perf_event struct statically contains ftrace_ops as a handle
> > > for function tracer. The function tracer is registered/unregistered
> > > in open/close actions.
> > > 
> > > To be efficient, we enable/disable ftrace_ops each time the traced
> 
> SNIP
> 
> > > +
> > > +	return -EINVAL;
> > > +}
> > 
> > All the above from perf_ftrace_function_call() to here should perhaps
> > go to trace_function.c.
> 
> hm, I'd call it rather trace_perf_function.c 
> 
> > 
> > > diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> > > index bbeec31..867653c 100644
> > > --- a/kernel/trace/trace_export.c
> > > +++ b/kernel/trace/trace_export.c
> > > @@ -131,6 +131,28 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
> > >  
> > >  #include "trace_entries.h"
> > >  
> > > +static int ftrace_event_class_register(struct ftrace_event_call *call,
> > > +				       enum trace_reg type, void *data)
> > > +{
> > > +	switch (type) {
> > > +	case TRACE_REG_PERF_REGISTER:
> > > +	case TRACE_REG_PERF_UNREGISTER:
> > > +		return 0;
> > > +	case TRACE_REG_PERF_OPEN:
> > > +	case TRACE_REG_PERF_CLOSE:
> > > +	case TRACE_REG_PERF_ADD:
> > > +	case TRACE_REG_PERF_DEL:
> > > +#ifdef CONFIG_PERF_EVENTS
> > > +		return perf_ftrace_event_register(call, type, data);
> > > +#endif
> > > +	case TRACE_REG_REGISTER:
> > > +	case TRACE_REG_UNREGISTER:
> > > +		break;
> > > +	}
> > > +
> > > +	return -EINVAL;
> > > +}
> > 
> > Hmm, one day we'll need to demux here. What about adding an argument to
> > FTRACE_ENTRY() to add the pointer to .reg ?
> 
> ok, would something like the attached change be ok?
> 
> thanks,
> jirka

and use FTRACE_ENTRY_REG for ftrace event like:

FTRACE_ENTRY_REG(function, ftrace_entry,
        TRACE_FN,
        F_STRUCT(
                __field(        unsigned long,  ip              )
                __field(        unsigned long,  parent_ip       )
        ),
        F_printk(" %lx <-- %lx", __entry->ip, __entry->parent_ip),
        perf_ftrace_event_register
);

jirka

> 
> 
> ---
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 55c6ea0..638476a 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -68,6 +68,10 @@ enum trace_type {
>  #undef FTRACE_ENTRY_DUP
>  #define FTRACE_ENTRY_DUP(name, name_struct, id, tstruct, printk)
>  
> +#undef FTRACE_ENTRY_REG
> +#define FTRACE_ENTRY_REG(name, struct_name, id, tstruct, print, regfn) \
> +	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
> +
>  #include "trace_entries.h"
>  
>  /*
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index bbeec31..f74de86 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -18,6 +18,14 @@
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM	ftrace
>  
> +/*
> + * The FTRACE_ENTRY_REG macro allows ftrace entry to define register
> + * function and thus become accesible via perf.
> + */
> +#undef FTRACE_ENTRY_REG
> +#define FTRACE_ENTRY_REG(name, struct_name, id, tstruct, print, regfn) \
> +	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
> +
>  /* not needed for this file */
>  #undef __field_struct
>  #define __field_struct(type, item)
> @@ -152,13 +160,14 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
>  #undef F_printk
>  #define F_printk(fmt, args...) #fmt ", "  __stringify(args)
>  
> -#undef FTRACE_ENTRY
> -#define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\
> +#undef FTRACE_ENTRY_REG
> +#define FTRACE_ENTRY_REG(call, struct_name, etype, tstruct, print, regfn)\
>  									\
>  struct ftrace_event_class event_class_ftrace_##call = {			\
>  	.system			= __stringify(TRACE_SYSTEM),		\
>  	.define_fields		= ftrace_define_fields_##call,		\
>  	.fields			= LIST_HEAD_INIT(event_class_ftrace_##call.fields),\
> +	.reg			= regfn,				\
>  };									\
>  									\
>  struct ftrace_event_call __used event_##call = {			\
> @@ -170,4 +179,9 @@ struct ftrace_event_call __used event_##call = {			\
>  struct ftrace_event_call __used						\
>  __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
>  
> +#undef FTRACE_ENTRY
> +#define FTRACE_ENTRY(call, struct_name, etype, tstruct, print)		\
> +	FTRACE_ENTRY_REG(call, struct_name, etype,			\
> +			 PARAMS(tstruct), PARAMS(print), NULL)
> +
>  #include "trace_entries.h"
