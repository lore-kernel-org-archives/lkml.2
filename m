Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab1BBSx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:53:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52492 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab1BBSx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:53:28 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=3_NjXNktB9YA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=etTzUb2bMPid_Qsn1p8A:9 a=PYoIh5oQtsI-NMZDnPYA:7 a=W1-IbuzKT6AgwZnDP6ql0vdDNN4A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] tracing: Replace trace_event struct array with
 pointer array
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20110202184201.GC27022@Krystal>
References: <20110202180613.978219945@goodmis.org>
	 <20110202180938.106599012@goodmis.org>  <20110202184201.GC27022@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 02 Feb 2011 13:53:27 -0500
Message-ID: <1296672807.10797.63.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 13:42 -0500, Mathieu Desnoyers wrote:

> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > index 6ebb810..f53708b 100644
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > @@ -124,7 +124,8 @@
> >  #endif
> >  
> >  #ifdef CONFIG_EVENT_TRACING
> > -#define FTRACE_EVENTS()	VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
> > +#define FTRACE_EVENTS()	. = ALIGN(8);					\
> > +			VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
> >  			*(_ftrace_events)				\
> >  			VMLINUX_SYMBOL(__stop_ftrace_events) = .;
> >  #else
> > @@ -179,9 +180,6 @@
> >  	TRACE_PRINTKS()							\
> >  									\
> >  	STRUCT_ALIGN();							\
> > -	FTRACE_EVENTS()							\
> > -									\
> > -	STRUCT_ALIGN();							\
> >  	TRACE_SYSCALLS()
> 
> You seem to have forgotten to fix the __syscalls_metadata table. Do you plan to
> do it in another patch ? Its code is pretty much interleaving with the ftrace
> code, so it might make sense to do both fixes in one go.

Thanks for reminding me. No that was going to be a separate patch (it
interleaves with ftrace but is a different entity - developed by two
different people). I was going to do it but got pulled off on a customer
item.

I'll fix that soon too.

> 
> [...]
> > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > index e16610c..3e68366 100644
> > --- a/include/trace/ftrace.h
> > +++ b/include/trace/ftrace.h
> > @@ -446,14 +446,16 @@ static inline notrace int ftrace_get_offsets_##call(			\
> >   *	.reg			= ftrace_event_reg,
> >   * };
> >   *
> > - * static struct ftrace_event_call __used
> > - * __attribute__((__aligned__(4)))
> > - * __attribute__((section("_ftrace_events"))) event_<call> = {
> > + * static struct ftrace_event_call event_<call> = {
> >   *	.name			= "<call>",
> >   *	.class			= event_class_<template>,
> >   *	.event			= &ftrace_event_type_<call>,
> >   *	.print_fmt		= print_fmt_<call>,
> >   * };
> > + * // its only safe to use pointers when doing linker tricks to
> > + * // create an array.
> 
> Odd comment style.
> 
> The rest looks good.

I knew someone would comment on this comment. Yes, it is an odd comment
stye. The comment is showing "code" that the macro produces. Thus, I
used the '//' to be a comment in the code comment. ;)

-- Steve


