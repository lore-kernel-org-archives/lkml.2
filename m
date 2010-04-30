Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab0D3VC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 17:02:26 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:61441 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155Ab0D3VCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 17:02:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOrh2ktGGNqG/2dsb2JhbACdI3K+aYUSBA
Date: Fri, 30 Apr 2010 17:02:22 -0400
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
Message-ID: <20100430210222.GA18071@Krystal>
References: <20100429133649.GC14617@Krystal> <1272550009.9739.136.camel@gandalf.stny.rr.com> <20100429145559.GB24819@Krystal> <1272557188.9739.147.camel@gandalf.stny.rr.com> <20100430170938.GB25605@Krystal> <1272651414.9739.184.camel@gandalf.stny.rr.com> <20100430190613.GA6926@Krystal> <1272656885.9739.198.camel@gandalf.stny.rr.com> <20100430200746.GA12872@Krystal> <1272658477.9739.201.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1272658477.9739.201.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:54:23 up 23 days,  6:48,  3 users,  load average: 0.40, 0.23,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Fri, 2010-04-30 at 16:07 -0400, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > On Fri, 2010-04-30 at 15:06 -0400, Mathieu Desnoyers wrote:
> > > 
> > > > > If it is possible sure, but that's the point. Where do you add the
> > > > > check? The typecast is in the C code that is constant for all trace
> > > > > events.
> > > > 
> > > > You can add the call to the static inline type check directly within the
> > > > generated probe function, right after the local variable declarations.
> > > 
> > > Well, one thing, the callback is not going to be the same as the
> > > DECLARE_TRACE() because the prototype ends with "void *data", and the
> > > function being called actually uses the type of that data.
> > > 
> > > We now will have:
> > > 
> > > 	DEFINE_TRACE(mytracepoint, int myarg, myarg);
> > > 
> > > 	void mycallback(int myarg, struct mystuct *mydata);
> > > 
> > > 	register_trace_mytracepoint_data(mycallback, mydata)
> > > 
> > > There's no place in DEFINE_TRACE to be able to test the type of data
> > > that is being passed back. I could make the calling function be:
> > > 
> > > 	void mycallback(int myarg, void *data)
> > > 	{
> > > 		struct mystruct *mydata = data;
> > > 	[...]
> > > 
> > > Because the data is defined uniquely by the caller that registers a
> > > callback. Each function can register its own data type.
> > 
> > Yep. There would need to be a cast from void * to struct mystruct *
> > at the beginning of the callback as you propose here. I prefer this cast
> > to be explicit (as proposed here) rather than hidden within the entire
> > function call (void *) cast.
> > 
> 
> OK, so you prefer that, I don't, but I also don't care, so I could
> easily change it.
> 
> 
> > > Let me explain this again:
> > > 
> > > 	DECLARE_TRACE(name, proto, args);
> > > 
> > > Will call the function like:
> > > 
> > > 	callback(args, data);
> > > 
> > > The callback will be at best:
> > > 
> > > 	int callback(proto, void *data);
> > > 
> > > 
> > > because the data being passed in is not defined yet. It is defined at
> > > the point of the registering of the callback. You can have two callbacks
> > > registered to the same tracepoint with two different types as the data
> > > field.
> > > 
> > > So what is it that this check is testing?
> > 
> > It's making sure that TRACE_EVENT() creates callbacks with the following
> > signature:
> > 
> >   void callback(proto, void *data)
> > 
> > rather than
> > 
> >   void callback(proto, struct somestruct *data)
> > 
> > and forces the cast to be done within the callback rather than casting
> > the whole function pointer type to void *, assuming types to match. I
> > prefer to leave the cast outside of the tracepoint infrastructure, so we
> > do not obfuscate the fact that an explicit type cast is needed there.
> 
> Fine, but I hardly see it as obfuscation. But my question again, even if
> we do change this. What is this test testing? To me, it is checking that
> CPP works.

It's checking that the macros generated compatible call/callback
prototypes, yes. It comes down to using the compiler type-checking to
double-check that the macros are fine.

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
