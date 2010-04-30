Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab0D3TsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:48:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab0D3TsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:48:10 -0400
X-Authority-Analysis: v=1.1 cv=elpKMhBbP+pQyLZqL930WohJ6E0KICKd8OrLrcMNK78= c=1 sm=0 a=h2TIy-q3F9wA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=q8EurDk91oM0GgLG4O4A:9 a=PvSgU0-j3x2r7p3AEnIA:7 a=KpqD8B0C1lL7nSlZpYwsW6dnJx4A:4 a=PUjeQqilurYA:10 a=-CS-33gaMAb-YFA1:21 a=aXAltwu9ngDyjcnW:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
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
In-Reply-To: <20100430190613.GA6926@Krystal>
References: <20100428204448.GE8591@Krystal>
	 <1272499218.9739.86.camel@gandalf.stny.rr.com>
	 <20100429000528.GB30353@Krystal>
	 <1272500422.9739.98.camel@gandalf.stny.rr.com>
	 <20100429133649.GC14617@Krystal>
	 <1272550009.9739.136.camel@gandalf.stny.rr.com>
	 <20100429145559.GB24819@Krystal>
	 <1272557188.9739.147.camel@gandalf.stny.rr.com>
	 <20100430170938.GB25605@Krystal>
	 <1272651414.9739.184.camel@gandalf.stny.rr.com>
	 <20100430190613.GA6926@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 30 Apr 2010 15:48:05 -0400
Message-ID: <1272656885.9739.198.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-30 at 15:06 -0400, Mathieu Desnoyers wrote:

> > If it is possible sure, but that's the point. Where do you add the
> > check? The typecast is in the C code that is constant for all trace
> > events.
> 
> You can add the call to the static inline type check directly within the
> generated probe function, right after the local variable declarations.

Well, one thing, the callback is not going to be the same as the
DECLARE_TRACE() because the prototype ends with "void *data", and the
function being called actually uses the type of that data.

We now will have:

	DEFINE_TRACE(mytracepoint, int myarg, myarg);

	void mycallback(int myarg, struct mystuct *mydata);

	register_trace_mytracepoint_data(mycallback, mydata)

There's no place in DEFINE_TRACE to be able to test the type of data
that is being passed back. I could make the calling function be:

	void mycallback(int myarg, void *data)
	{
		struct mystruct *mydata = data;
	[...]

Because the data is defined uniquely by the caller that registers a
callback. Each function can register its own data type.

> 
> > 
> > > 
> > > I also don't trust that these complex TRACE_EVENT() preprocessor macros
> > 
> > Thanks for your vote of confidence.
> 
> Please don't take this personally. As I said above, I include myself in
> the list of people I don't trust to write entirely bug-free code. I'm
> just saying that we should not overlook a possibility to detect more
> bugs automatically when we have one, especially if this results in no
> object code change.

The point being is that this is not about buggy code, but the fact that
the same data is being used in two places, you want to test to make sure
it is the same. I don't see how this helps.



> 
> > 
> > > will never ever have bugs. That's just doomed to happen one day or
> > > another. Again, call me paranoid if you like, but I think adding this
> > > type checking is justified.
> > 
> > Where do you add the typecheck?? As I said before, if the TRACE_EVENT()
> > macros are broken, then so will the typecheck, and it will not catch the
> > errors.
> > 
> > Sure the event macros can have bugs, but if it does then it will have
> > bugs for all. Because it is automated. If there is a bug, it wont be
> > because of a missed type being passed in, it would be because of one of
> > the extra macros we have that processes the same type incorrectly.
> > 
> > > 
> > > I am providing the type check implementation in a separate email. It
> > > will need to be extended to support the extra data parameter you plan to
> > > add.
> > 
> > I saw the patch, but how does it help?
> > 
> > I use "proto" to make the tracepoint and the callback, so I can add
> > somewhere this "check_trace_callback_type_##name(proto)", but if the
> > macros break somehow, that means proto changed between two references of
> > it, but what keeps proto from breaking at both callback creation and the
> > typecheck.
> > 
> > Basically, you are saying that somehow the argument "proto" can change
> > between two uses of it. I don't really see that happening, and I'm not
> > paranoid enough to think that's an issue. Adding checks that don't
> > really check anything, honestly I find a waste, and just more confusion
> > in the macros.
> 
> In the TRACE_EVENT() case, without the extra "void *data" argument,
> it is indeed checking that the "proto" of the callback you create is
> that same as the "proto" expected by the tracepoint call. However, given
> that you plan on adding other parameters besides "proto", then the added
> type-checking makes more and more sense.

But you can not test it! That's my point.

The first part of proto will be the same, and that's all we can test.
But the data parameter that the DECLARE_TRACE() is going to create will
be void *. Which means we can't test it. This is something that C lacks,
and we could test it in C++ if we did this with templates. The only way
to test it is at runtime with a magic number in the data field.

This is the same as the file->private data. You can't test it at build
time.

Let me explain this again:

	DECLARE_TRACE(name, proto, args);

Will call the function like:

	callback(args, data);

The callback will be at best:

	int callback(proto, void *data);


because the data being passed in is not defined yet. It is defined at
the point of the registering of the callback. You can have two callbacks
registered to the same tracepoint with two different types as the data
field.

So what is it that this check is testing?

-- Steve


