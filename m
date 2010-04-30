Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab0D3RJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:09:49 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:34637 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932762Ab0D3RJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:09:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMyn2ktGGNqG/2dsb2JhbACdH3K+e4USBA
Date: Fri, 30 Apr 2010 13:09:38 -0400
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
Subject: Re: [PATCH 04/10][RFC] tracing: Remove per event trace registering
Message-ID: <20100430170938.GB25605@Krystal>
References: <20100426195024.256424113@goodmis.org> <20100426200242.214837703@goodmis.org> <20100428204448.GE8591@Krystal> <1272499218.9739.86.camel@gandalf.stny.rr.com> <20100429000528.GB30353@Krystal> <1272500422.9739.98.camel@gandalf.stny.rr.com> <20100429133649.GC14617@Krystal> <1272550009.9739.136.camel@gandalf.stny.rr.com> <20100429145559.GB24819@Krystal> <1272557188.9739.147.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1272557188.9739.147.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:00:05 up 23 days,  2:53,  4 users,  load average: 0.18, 0.16,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-04-29 at 10:55 -0400, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> > > 
> > > The tracepoint is created in include/linux/tracepoint.h:
> > > 
> > > #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
> > > 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> > 
> > Can we add something like this to DECLARE_TRACE ? (not convinced it is
> > valid though)
> > 
> > static inline void check_trace_##name(cb_type)
> > {
> > 	BUILD_BUG_ON(!__same_type(void (*probe)(TP_PROTO(proto), void *data),
> > 				  cb_type));
> > }
> > 
> 
> We could add it, but I'm not sure it would add any more protection. If
> for some strange reason the prototype got out of sync, would would
> prevent the cb_type from getting out of sync with it too, and not cause
> this to fail, but still have the same bug.
> 
> Honestly, I find this a bit too paranoid. Again, the callback and the
> tracepoint are made with the same data. I find it hard to think that it
> would break somehow. Yes, perhaps it will break if you modify ftrace.h,
> but then if you are doing that, you should know better than to break
> things :-)

How can you be sure that the "void *data" type will match the type at
the same position in the generated callback ?

Honestly, I don't think kernel programmers write bug-free code. And I
include myself when I say that. So the best we can do, on top of code
review, is to use all the verification and debugging tools available to
minimize the amount of undetected bugs. Rather than try to find out the
cause of subtly broken tracepoint callbacks with their runtime
side-effects, I strongly prefer to let the compiler find this out as
early as possible.

I also don't trust that these complex TRACE_EVENT() preprocessor macros
will never ever have bugs. That's just doomed to happen one day or
another. Again, call me paranoid if you like, but I think adding this
type checking is justified.

I am providing the type check implementation in a separate email. It
will need to be extended to support the extra data parameter you plan to
add.

Thanks,

Mathieu

> 
> 
> > > 
> > > The callback is created in include/trace/ftrace.h:
> > > 
> > > #undef TRACE_EVENT
> > > #define TRACE_EVENT(name, proto, args, tstuct, assign, print)	\
> > > 	DECLARE_EVENT_CLASS(name,				\
> > > 				PARAMS(proto),			\
> > > 				PARAMS(args),			\
> > > 				PARAMS(tstruct),		\
> > > 				PARAMS(assign),			\
> > > 				PARAMS(print));			\
> > > 	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args));
> > > 
> > > #undef DECLARE_EVENT_CLASS
> > > #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
> > > 									\
> > > static notrace void							\
> > > ftrace_raw_event_##call(proto,						\
> > > 			struct ftrace_event_call *event_call)		\
> > > [...]
> > > 
> > 
> > Either within this callback, or in a dummy static function after, we
> > could add:
> > 
> > check_trace_##call(ftrace_raw_event_##call);
> > 
> > So.. you are the preprocessor expert, do you think this could fly ? ;)
> 
> 
> 
> Sure, the static function you did could be added, and hope that gcc is
> smart enough to get rid of it (add __unused to it). But what are we
> really checking here? If CPP works?
> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
