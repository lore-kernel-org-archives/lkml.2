Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445Ab0D3TG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:06:29 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:62590 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934243Ab0D3TGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:06:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMvF2ktGGNqG/2dsb2JhbACdJHK+WIUSBA
Date: Fri, 30 Apr 2010 15:06:13 -0400
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
Message-ID: <20100430190613.GA6926@Krystal>
References: <20100428204448.GE8591@Krystal> <1272499218.9739.86.camel@gandalf.stny.rr.com> <20100429000528.GB30353@Krystal> <1272500422.9739.98.camel@gandalf.stny.rr.com> <20100429133649.GC14617@Krystal> <1272550009.9739.136.camel@gandalf.stny.rr.com> <20100429145559.GB24819@Krystal> <1272557188.9739.147.camel@gandalf.stny.rr.com> <20100430170938.GB25605@Krystal> <1272651414.9739.184.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1272651414.9739.184.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:53:52 up 23 days,  4:47,  3 users,  load average: 0.02, 0.02,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Fri, 2010-04-30 at 13:09 -0400, Mathieu Desnoyers wrote:
> 
> > How can you be sure that the "void *data" type will match the type at
> > the same position in the generated callback ?
> 
> 
> We do it all the time in the kernel with no type checking. Just look at
> all the users of file->private.
> 
> 
> > 
> > Honestly, I don't think kernel programmers write bug-free code. And I
> > include myself when I say that. So the best we can do, on top of code
> > review, is to use all the verification and debugging tools available to
> > minimize the amount of undetected bugs. Rather than try to find out the
> > cause of subtly broken tracepoint callbacks with their runtime
> > side-effects, I strongly prefer to let the compiler find this out as
> > early as possible.
> 
> If it is possible sure, but that's the point. Where do you add the
> check? The typecast is in the C code that is constant for all trace
> events.

You can add the call to the static inline type check directly within the
generated probe function, right after the local variable declarations.

> 
> > 
> > I also don't trust that these complex TRACE_EVENT() preprocessor macros
> 
> Thanks for your vote of confidence.

Please don't take this personally. As I said above, I include myself in
the list of people I don't trust to write entirely bug-free code. I'm
just saying that we should not overlook a possibility to detect more
bugs automatically when we have one, especially if this results in no
object code change.

> 
> > will never ever have bugs. That's just doomed to happen one day or
> > another. Again, call me paranoid if you like, but I think adding this
> > type checking is justified.
> 
> Where do you add the typecheck?? As I said before, if the TRACE_EVENT()
> macros are broken, then so will the typecheck, and it will not catch the
> errors.
> 
> Sure the event macros can have bugs, but if it does then it will have
> bugs for all. Because it is automated. If there is a bug, it wont be
> because of a missed type being passed in, it would be because of one of
> the extra macros we have that processes the same type incorrectly.
> 
> > 
> > I am providing the type check implementation in a separate email. It
> > will need to be extended to support the extra data parameter you plan to
> > add.
> 
> I saw the patch, but how does it help?
> 
> I use "proto" to make the tracepoint and the callback, so I can add
> somewhere this "check_trace_callback_type_##name(proto)", but if the
> macros break somehow, that means proto changed between two references of
> it, but what keeps proto from breaking at both callback creation and the
> typecheck.
> 
> Basically, you are saying that somehow the argument "proto" can change
> between two uses of it. I don't really see that happening, and I'm not
> paranoid enough to think that's an issue. Adding checks that don't
> really check anything, honestly I find a waste, and just more confusion
> in the macros.

In the TRACE_EVENT() case, without the extra "void *data" argument,
it is indeed checking that the "proto" of the callback you create is
that same as the "proto" expected by the tracepoint call. However, given
that you plan on adding other parameters besides "proto", then the added
type-checking makes more and more sense.

Thanks,

Mathieu

> 
> -- Steve
> 
> 
> > > 
> > > 
> > > > > 
> > > > > The callback is created in include/trace/ftrace.h:
> > > > > 
> > > > > #undef TRACE_EVENT
> > > > > #define TRACE_EVENT(name, proto, args, tstuct, assign, print)	\
> > > > > 	DECLARE_EVENT_CLASS(name,				\
> > > > > 				PARAMS(proto),			\
> > > > > 				PARAMS(args),			\
> > > > > 				PARAMS(tstruct),		\
> > > > > 				PARAMS(assign),			\
> > > > > 				PARAMS(print));			\
> > > > > 	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args));
> > > > > 
> > > > > #undef DECLARE_EVENT_CLASS
> > > > > #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
> > > > > 									\
> > > > > static notrace void							\
> > > > > ftrace_raw_event_##call(proto,						\
> > > > > 			struct ftrace_event_call *event_call)		\
> > > > > [...]
> > > > > 
> > > > 
> > > > Either within this callback, or in a dummy static function after, we
> > > > could add:
> > > > 
> > > > check_trace_##call(ftrace_raw_event_##call);
> > > > 
> > > > So.. you are the preprocessor expert, do you think this could fly ? ;)
> > > 
> > > 
> > > 
> > > Sure, the static function you did could be added, and hope that gcc is
> > > smart enough to get rid of it (add __unused to it). But what are we
> > > really checking here? If CPP works?
> > > 
> > > -- Steve
> > > 
> > > 
> > 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
