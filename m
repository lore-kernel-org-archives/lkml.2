Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0LIPIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:08:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60076 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0LIPIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:08:20 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=_hCqAiHmeU0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=0WPWU4OF-EoKZY-wUkQA:9 a=HxyebNC07qGsPvAkXEYA:7 a=UNjwh2x5k2V7kmx8ha-1J5iLvMYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 13/15] small_traces: Add config option to shrink trace
 events.
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101209145541.GC1712@nowhere>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-14-git-send-email-dhsharp@google.com>
	 <1291427770.16223.15.camel@gandalf.stny.rr.com>
	 <AANLkTimiMtdfXag6bukxDo21uSDzs0nj4YG-35M2ioiP@mail.gmail.com>
	 <1291431252.16223.28.camel@gandalf.stny.rr.com>
	 <20101209145541.GC1712@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 09 Dec 2010 10:08:17 -0500
Message-ID: <1291907297.5015.1526.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 15:55 +0100, Frederic Weisbecker wrote:
> On Fri, Dec 03, 2010 at 09:54:12PM -0500, Steven Rostedt wrote:
> > On Fri, 2010-12-03 at 18:33 -0800, David Sharp wrote:
> > > I considered that, and I generally thing it's a good idea. However, I
> > > also want to use this switch to shrink individual tracepoint event
> > > structures.
> > > 
> > > eg: sched switch is a high frequency event and it is 68 bytes (60
> > > after these patches)
> > > 
> > > Can you suggest a syntax for TRACE_EVENT, DECLARE_EVENT_CLASS, etc,
> > > that could express the two versions and produce the right code?
> > > 
> > > I'm worried about adding even further complexity to the TRACE_EVENT
> > > macros. I could add TRACE_EVENT_SMALL that takes two versions of
> > > TP_STRUCT__entry, TP_fast_assign, and TP_printk each, but then this
> > > will need to be permuted with your TP_CONDITIONAL patches as well.
> > 
> > I would not touch the TRACE_EVENT() structures. They are there as is and
> > I would not think about changing them. Something like that would never
> > make it into mainline.
> > 
> > Now what you can do, is to make your own events based off of the same
> > tracepoints. For example, the TRACE_EVENT(sched_switch...) has in
> > sched.c:
> > 
> > 	trace_sched_switch(prev, next);
> > 
> > 
> > You could even write a module that does something like this:
> > 
> > 	register_trace_sched_switch(probe_sched_switch, mydata);
> > 
> > 
> > 
> > void probe_sched_switch(void *mydata,
> > 		struct task_struct *prev,
> > 		struct task_struct *next)
> > {
> > 	struct ring_buffer *buffer;
> > 	struct ring_buffer_event *event;
> > 	struct myentry *entry;
> > 
> > 	event = trace_current_buffer_lock_reserve(buffer,
> > 			mytype, sizeof(*entry),
> > 			0, 0);
> > 
> > 	if (!event)
> > 		return;
> > 
> > 	entry = ring_buffer_event_data(event);
> > 
> > 	entry->myfield = prev->x;
> > 	...
> > 
> > 	trace_nowake_buffer_unlock_commit(buffer, event,
> > 					0, 0);
> > }
> > 
> > You will need to do a register_ftrace_event() to register that 'mytype'
> > and how to output it. Otherwise it would just be ignored in the "trace"
> > file.
> > 
> > All of the above would work fine as a loadable module that you could
> > easily maintain out of tree, and still uses the internals of the system.
> > 
> > -- Steve
> > 
> > 
> 
> 
> But this would improve only google's tracing while this is a general
> mainline tracing problem.
> 
> The first thing is that we need to get rid of the lock_depth field, the bkl
> is dying.

Yeah that needs to go :-)

> 
> For the rest what about having a bitmap of the fields we want to ignore,
> which can be setup from a trace file for ftrace and as an ioctl for perf.
> 
> So this bitmap is easy to implement on the common fields.
> 
> For the rest, one could choose between using TP_fast_assign()
> and TP_cond_assign().
> 
> TP_fast_assign() stays as is and doesn't implement bitmap field
> ignoring. Those who want conditional record will need
> TP_cond_assign().
> Well, unfortunately this probably requires us to play
> the same trickery than SYSCALL_DEFINE() in that we'll probably
> need TP_cond_assign1(), TP_cond_assign2(), TP_cond_assign3(), etc...
> 
> #define TP_cond_assignx(nr, assign)	\
> 	if (call->bitmask & nr)	{	\
> 		assign
> 	}
> 
> #define TP_cond_assign2(nr, assign, ...)	\
> 	TP_cond_assignx(nr, assign)		\
> 	TP_cond_assign1(nr + 1, __VA_ARGS__)
> 
> #define TP_cond_assign3(nr, assign, ...)        \
>         TP_cond_assignx(nr, assign)             \
>         TP_cond_assign2(nr + 1, __VA_ARGS__)
> 
> That will also require a bit more trickery to dynamically
> pre-compute the size of the trace entry.

Mathieu is working on encapsulating the assignments in their own macros.

Instead of doing:

	__entry->foo = bar;

We will have:

	tp_assign(foo, bar);

This way we could probably use this to dynamically figure out what to
assign.

-- Steve


