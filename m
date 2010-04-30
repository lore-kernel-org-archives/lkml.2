Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab0D3UH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:07:56 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:34081 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932462Ab0D3UHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:07:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHLS2ktGGNqG/2dsb2JhbACdJHK+WoUSBA
Date: Fri, 30 Apr 2010 16:07:46 -0400
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
Message-ID: <20100430200746.GA12872@Krystal>
References: <20100429000528.GB30353@Krystal> <1272500422.9739.98.camel@gandalf.stny.rr.com> <20100429133649.GC14617@Krystal> <1272550009.9739.136.camel@gandalf.stny.rr.com> <20100429145559.GB24819@Krystal> <1272557188.9739.147.camel@gandalf.stny.rr.com> <20100430170938.GB25605@Krystal> <1272651414.9739.184.camel@gandalf.stny.rr.com> <20100430190613.GA6926@Krystal> <1272656885.9739.198.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1272656885.9739.198.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:54:43 up 23 days,  5:48,  4 users,  load average: 0.11, 0.10,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Fri, 2010-04-30 at 15:06 -0400, Mathieu Desnoyers wrote:
> 
> > > If it is possible sure, but that's the point. Where do you add the
> > > check? The typecast is in the C code that is constant for all trace
> > > events.
> > 
> > You can add the call to the static inline type check directly within the
> > generated probe function, right after the local variable declarations.
> 
> Well, one thing, the callback is not going to be the same as the
> DECLARE_TRACE() because the prototype ends with "void *data", and the
> function being called actually uses the type of that data.
> 
> We now will have:
> 
> 	DEFINE_TRACE(mytracepoint, int myarg, myarg);
> 
> 	void mycallback(int myarg, struct mystuct *mydata);
> 
> 	register_trace_mytracepoint_data(mycallback, mydata)
> 
> There's no place in DEFINE_TRACE to be able to test the type of data
> that is being passed back. I could make the calling function be:
> 
> 	void mycallback(int myarg, void *data)
> 	{
> 		struct mystruct *mydata = data;
> 	[...]
> 
> Because the data is defined uniquely by the caller that registers a
> callback. Each function can register its own data type.

Yep. There would need to be a cast from void * to struct mystruct *
at the beginning of the callback as you propose here. I prefer this cast
to be explicit (as proposed here) rather than hidden within the entire
function call (void *) cast.

> 
> > 
> > > 
> > > > 
> > > > I also don't trust that these complex TRACE_EVENT() preprocessor macros
> > > 
> > > Thanks for your vote of confidence.
> > 
> > Please don't take this personally. As I said above, I include myself in
> > the list of people I don't trust to write entirely bug-free code. I'm
> > just saying that we should not overlook a possibility to detect more
> > bugs automatically when we have one, especially if this results in no
> > object code change.
> 
> The point being is that this is not about buggy code, but the fact that
> the same data is being used in two places, you want to test to make sure
> it is the same. I don't see how this helps.

See my comment above about specifically casting the void *data parameter
rather than relying on casting of the whole callback function pointer
type to void *.

> 
> 
> 
> > 
> > > 
> > > > will never ever have bugs. That's just doomed to happen one day or
> > > > another. Again, call me paranoid if you like, but I think adding this
> > > > type checking is justified.
> > > 
> > > Where do you add the typecheck?? As I said before, if the TRACE_EVENT()
> > > macros are broken, then so will the typecheck, and it will not catch the
> > > errors.
> > > 
> > > Sure the event macros can have bugs, but if it does then it will have
> > > bugs for all. Because it is automated. If there is a bug, it wont be
> > > because of a missed type being passed in, it would be because of one of
> > > the extra macros we have that processes the same type incorrectly.
> > > 
> > > > 
> > > > I am providing the type check implementation in a separate email. It
> > > > will need to be extended to support the extra data parameter you plan to
> > > > add.
> > > 
> > > I saw the patch, but how does it help?
> > > 
> > > I use "proto" to make the tracepoint and the callback, so I can add
> > > somewhere this "check_trace_callback_type_##name(proto)", but if the
> > > macros break somehow, that means proto changed between two references of
> > > it, but what keeps proto from breaking at both callback creation and the
> > > typecheck.
> > > 
> > > Basically, you are saying that somehow the argument "proto" can change
> > > between two uses of it. I don't really see that happening, and I'm not
> > > paranoid enough to think that's an issue. Adding checks that don't
> > > really check anything, honestly I find a waste, and just more confusion
> > > in the macros.
> > 
> > In the TRACE_EVENT() case, without the extra "void *data" argument,
> > it is indeed checking that the "proto" of the callback you create is
> > that same as the "proto" expected by the tracepoint call. However, given
> > that you plan on adding other parameters besides "proto", then the added
> > type-checking makes more and more sense.
> 
> But you can not test it! That's my point.
> 
> The first part of proto will be the same, and that's all we can test.
> But the data parameter that the DECLARE_TRACE() is going to create will
> be void *. Which means we can't test it. This is something that C lacks,
> and we could test it in C++ if we did this with templates. The only way
> to test it is at runtime with a magic number in the data field.
> 
> This is the same as the file->private data. You can't test it at build
> time.
> 
> Let me explain this again:
> 
> 	DECLARE_TRACE(name, proto, args);
> 
> Will call the function like:
> 
> 	callback(args, data);
> 
> The callback will be at best:
> 
> 	int callback(proto, void *data);
> 
> 
> because the data being passed in is not defined yet. It is defined at
> the point of the registering of the callback. You can have two callbacks
> registered to the same tracepoint with two different types as the data
> field.
> 
> So what is it that this check is testing?

It's making sure that TRACE_EVENT() creates callbacks with the following
signature:

  void callback(proto, void *data)

rather than

  void callback(proto, struct somestruct *data)

and forces the cast to be done within the callback rather than casting
the whole function pointer type to void *, assuming types to match. I
prefer to leave the cast outside of the tracepoint infrastructure, so we
do not obfuscate the fact that an explicit type cast is needed there.

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
