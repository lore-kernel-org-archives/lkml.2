Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab0D3RUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:20:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54132 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642Ab0D3RUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:20:36 -0400
X-Authority-Analysis: v=1.1 cv=tamp8Om8S85MB4Qj1n2yU9kNzNdU9gdJUe8fX0YwrYg= c=1 sm=0 a=h2TIy-q3F9wA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=q7KUYPLRg9m38lMwXkIA:9 a=OR1WM8J9VmlOumdCmcMA:7 a=3VvsFtZeOBxBu9g66hbXG-TYlJgA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 04/10][RFC] tracing: Remove per event trace registering
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20100429145559.GB24819@Krystal>
References: <20100426195024.256424113@goodmis.org>
	 <20100426200242.214837703@goodmis.org> <20100428204448.GE8591@Krystal>
	 <1272499218.9739.86.camel@gandalf.stny.rr.com>
	 <20100429000528.GB30353@Krystal>
	 <1272500422.9739.98.camel@gandalf.stny.rr.com>
	 <20100429133649.GC14617@Krystal>
	 <1272550009.9739.136.camel@gandalf.stny.rr.com>
	 <20100429145559.GB24819@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 29 Apr 2010 12:06:28 -0400
Message-ID: <1272557188.9739.147.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-29 at 10:55 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> > 
> > The tracepoint is created in include/linux/tracepoint.h:
> > 
> > #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
> > 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> 
> Can we add something like this to DECLARE_TRACE ? (not convinced it is
> valid though)
> 
> static inline void check_trace_##name(cb_type)
> {
> 	BUILD_BUG_ON(!__same_type(void (*probe)(TP_PROTO(proto), void *data),
> 				  cb_type));
> }
> 

We could add it, but I'm not sure it would add any more protection. If
for some strange reason the prototype got out of sync, would would
prevent the cb_type from getting out of sync with it too, and not cause
this to fail, but still have the same bug.

Honestly, I find this a bit too paranoid. Again, the callback and the
tracepoint are made with the same data. I find it hard to think that it
would break somehow. Yes, perhaps it will break if you modify ftrace.h,
but then if you are doing that, you should know better than to break
things :-)


> > 
> > The callback is created in include/trace/ftrace.h:
> > 
> > #undef TRACE_EVENT
> > #define TRACE_EVENT(name, proto, args, tstuct, assign, print)	\
> > 	DECLARE_EVENT_CLASS(name,				\
> > 				PARAMS(proto),			\
> > 				PARAMS(args),			\
> > 				PARAMS(tstruct),		\
> > 				PARAMS(assign),			\
> > 				PARAMS(print));			\
> > 	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args));
> > 
> > #undef DECLARE_EVENT_CLASS
> > #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
> > 									\
> > static notrace void							\
> > ftrace_raw_event_##call(proto,						\
> > 			struct ftrace_event_call *event_call)		\
> > [...]
> > 
> 
> Either within this callback, or in a dummy static function after, we
> could add:
> 
> check_trace_##call(ftrace_raw_event_##call);
> 
> So.. you are the preprocessor expert, do you think this could fly ? ;)



Sure, the static function you did could be added, and hope that gcc is
smart enough to get rid of it (add __unused to it). But what are we
really checking here? If CPP works?

-- Steve


