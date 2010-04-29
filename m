Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab0D3RVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:21:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54132 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab0D3RUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:20:40 -0400
X-Authority-Analysis: v=1.1 cv=2/WNtoURsBD4grC4Rqfj62/w1mAETqRJkFX1sgq41IM= c=1 sm=0 a=h2TIy-q3F9wA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=h9dnMnpQQzdQQcJ08mwA:9 a=D8nthtIxD_e4LRTE_cEA:7 a=R2wwljC2oqZ0T7gqO4gq4phoHboA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
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
In-Reply-To: <20100429133649.GC14617@Krystal>
References: <20100426195024.256424113@goodmis.org>
	 <20100426200242.214837703@goodmis.org> <20100428204448.GE8591@Krystal>
	 <1272499218.9739.86.camel@gandalf.stny.rr.com>
	 <20100429000528.GB30353@Krystal>
	 <1272500422.9739.98.camel@gandalf.stny.rr.com>
	 <20100429133649.GC14617@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 29 Apr 2010 10:06:49 -0400
Message-ID: <1272550009.9739.136.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-29 at 09:36 -0400, Mathieu Desnoyers wrote:

> > Instead of calling register_trace_##name that is created for each
> > tracepoint, we now call the tracepoint_probe_register() directly in the
> > C file with the generated probe.
> > 
> > Both the probe and the tracepoint are created from the same data. I'm
> > not seeing where you want to add this check.
> 
> So if they are created from the same data, we can expect this test to
> always pass, which is good (and expected).
> 
> I'd add this extra check before casting the callback to (void *) before
> it is passed to tracepoint_probe_register(). Let's just call this
> internal preprocessing macro integrity check. As long as it does not add
> a runtime cost, there is no reason not to put this extra check.

The problem is, the cast is now performed in a C file for all events.
There's no way to know what to cast it to there. This is out of the
automation of the macro.

We use to have the cast check by creating code that would create the
"register_trace_##call", and the typecheck was doing by passing the data
to this function. But we removed this code out of the per event, it was
adding lots of text footprint, and moved it to one single function that
handles all events. It is just expected that the callback created
matches the function it was done.

If you are overly paranoid, we could create a special function that
tests that the callback format that is created matches the tracepoint
that is created, and make it so GCC sees that nothing calls it and
removes it at final link. But I still see this as a waste.


The tracepoint is created in include/linux/tracepoint.h:

#define TRACE_EVENT(name, proto, args, struct, assign, print)	\
	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))

The callback is created in include/trace/ftrace.h:

#undef TRACE_EVENT
#define TRACE_EVENT(name, proto, args, tstuct, assign, print)	\
	DECLARE_EVENT_CLASS(name,				\
				PARAMS(proto),			\
				PARAMS(args),			\
				PARAMS(tstruct),		\
				PARAMS(assign),			\
				PARAMS(print));			\
	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args));

#undef DECLARE_EVENT_CLASS
#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
									\
static notrace void							\
ftrace_raw_event_##call(proto,						\
			struct ftrace_event_call *event_call)		\
[...]


Thus the "proto" field of the TRACE_EVENT() is used to make both the
tracepoint and the callback. We add the struct ftrace_event_call
*event_call which is the data we pass to the callback.

Now, where this gets called is in kernel/trace/trace_events.c:

	tracepoint_probe_register(call->name,
				  call->class->probe,
				  call);

This is where we lose the typecheck. So my question is... where do you
want to put in a check?

-- Steve

	


