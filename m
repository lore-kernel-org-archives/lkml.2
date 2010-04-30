Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab0D3SRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:17:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020Ab0D3SQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:16:57 -0400
X-Authority-Analysis: v=1.1 cv=m27xf9DC4olkrNDaWzGlhfWN1WyLlD0+t5Z5YaFh7bA= c=1 sm=0 a=h2TIy-q3F9wA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=oHd9ysDjwbRu6ZkuoTsA:9 a=oifFlqahhL-6c4UussgA:7 a=2M6Hnewh-HvuZpG5nirs6aDE3NwA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
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
In-Reply-To: <20100430170938.GB25605@Krystal>
References: <20100426195024.256424113@goodmis.org>
	 <20100426200242.214837703@goodmis.org> <20100428204448.GE8591@Krystal>
	 <1272499218.9739.86.camel@gandalf.stny.rr.com>
	 <20100429000528.GB30353@Krystal>
	 <1272500422.9739.98.camel@gandalf.stny.rr.com>
	 <20100429133649.GC14617@Krystal>
	 <1272550009.9739.136.camel@gandalf.stny.rr.com>
	 <20100429145559.GB24819@Krystal>
	 <1272557188.9739.147.camel@gandalf.stny.rr.com>
	 <20100430170938.GB25605@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 30 Apr 2010 14:16:54 -0400
Message-ID: <1272651414.9739.184.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-30 at 13:09 -0400, Mathieu Desnoyers wrote:

> How can you be sure that the "void *data" type will match the type at
> the same position in the generated callback ?


We do it all the time in the kernel with no type checking. Just look at
all the users of file->private.


> 
> Honestly, I don't think kernel programmers write bug-free code. And I
> include myself when I say that. So the best we can do, on top of code
> review, is to use all the verification and debugging tools available to
> minimize the amount of undetected bugs. Rather than try to find out the
> cause of subtly broken tracepoint callbacks with their runtime
> side-effects, I strongly prefer to let the compiler find this out as
> early as possible.

If it is possible sure, but that's the point. Where do you add the
check? The typecast is in the C code that is constant for all trace
events.

> 
> I also don't trust that these complex TRACE_EVENT() preprocessor macros

Thanks for your vote of confidence.

> will never ever have bugs. That's just doomed to happen one day or
> another. Again, call me paranoid if you like, but I think adding this
> type checking is justified.

Where do you add the typecheck?? As I said before, if the TRACE_EVENT()
macros are broken, then so will the typecheck, and it will not catch the
errors.

Sure the event macros can have bugs, but if it does then it will have
bugs for all. Because it is automated. If there is a bug, it wont be
because of a missed type being passed in, it would be because of one of
the extra macros we have that processes the same type incorrectly.

> 
> I am providing the type check implementation in a separate email. It
> will need to be extended to support the extra data parameter you plan to
> add.

I saw the patch, but how does it help?

I use "proto" to make the tracepoint and the callback, so I can add
somewhere this "check_trace_callback_type_##name(proto)", but if the
macros break somehow, that means proto changed between two references of
it, but what keeps proto from breaking at both callback creation and the
typecheck.

Basically, you are saying that somehow the argument "proto" can change
between two uses of it. I don't really see that happening, and I'm not
paranoid enough to think that's an issue. Adding checks that don't
really check anything, honestly I find a waste, and just more confusion
in the macros.

-- Steve


> > 
> > 
> > > > 
> > > > The callback is created in include/trace/ftrace.h:
> > > > 
> > > > #undef TRACE_EVENT
> > > > #define TRACE_EVENT(name, proto, args, tstuct, assign, print)	\
> > > > 	DECLARE_EVENT_CLASS(name,				\
> > > > 				PARAMS(proto),			\
> > > > 				PARAMS(args),			\
> > > > 				PARAMS(tstruct),		\
> > > > 				PARAMS(assign),			\
> > > > 				PARAMS(print));			\
> > > > 	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args));
> > > > 
> > > > #undef DECLARE_EVENT_CLASS
> > > > #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
> > > > 									\
> > > > static notrace void							\
> > > > ftrace_raw_event_##call(proto,						\
> > > > 			struct ftrace_event_call *event_call)		\
> > > > [...]
> > > > 
> > > 
> > > Either within this callback, or in a dummy static function after, we
> > > could add:
> > > 
> > > check_trace_##call(ftrace_raw_event_##call);
> > > 
> > > So.. you are the preprocessor expert, do you think this could fly ? ;)
> > 
> > 
> > 
> > Sure, the static function you did could be added, and hope that gcc is
> > smart enough to get rid of it (add __unused to it). But what are we
> > really checking here? If CPP works?
> > 
> > -- Steve
> > 
> > 
> 


