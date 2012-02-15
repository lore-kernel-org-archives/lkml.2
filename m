Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab2BOPN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:13:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41566 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab2BOPNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:13:25 -0500
Date: Wed, 15 Feb 2012 16:13:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 4/7] ftrace: Add FTRACE_ENTRY_REG macro to allow event
 registration
Message-ID: <20120215151318.GB23684@somewhere>
References: <1329317514-8131-1-git-send-email-jolsa@redhat.com>
 <1329317514-8131-5-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329317514-8131-5-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 03:51:51PM +0100, Jiri Olsa wrote:
> Adding FTRACE_ENTRY_REG macro so particular ftrace entries
> could specify registration function and thus become accesible
> via perf.
> 
> This will be used in upcomming patch for function trace.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

> ---
>  kernel/trace/trace.h        |    4 ++++
>  kernel/trace/trace_export.c |   18 ++++++++++++++++--
>  2 files changed, 20 insertions(+), 2 deletions(-)
> 
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
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
