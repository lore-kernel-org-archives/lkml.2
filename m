Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab1KROFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 09:05:42 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:55603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab1KROFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 09:05:42 -0500
Subject: Re: tracing vs. string formatting
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1321624241.3533.45.camel@frodo>
References: <1321610382.10266.19.camel@jlt3.sipsolutions.net>
	 <1321624241.3533.45.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 15:05:38 +0100
Message-ID: <1321625138.10266.56.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 08:50 -0500, Steven Rostedt wrote:

> > The issue I ran into is that obviously almost all messages need string
> > formatting. But to put them into the trace, we have two choices now that
> > I can see:
> > 
> > 1) format the messages into a temporary buffer, then copy into the trace
> > 2) format the messages into the ringbuffer, reserving the max length we
> >    think we might need
> 
> I'm confused? Is this a different topic than printk tracing? As with
> printk, if you put the trace point where I mentioned before, you let
> printk figure out the size already and all it takes is a string and
> length, and it will allocate just enough for the ring buffer to place it
> there.

Yes it's a different topic. With the printk tracing I can today (with
the trace console I posted initially that can even be done out of tree)
get all those messages. But if at the same time you have a slow serial
console connected, printk'ing all the messages to the console can be
expensive.

> But if you are talking about something else, then sure this is an issue.
> Currently trace_printk() uses a temporary buffer. Why waste 200 bytes in
> the ring buffer that's not needed.

I hadn't even thought about trace_printk, but yeah, d'oh, it obviously
has the same issue.

> > TRACE_EVENT(foo_dbg,
> >         TP_PROTO(const char *fmt, va_list args),
> >         TP_ARGS(fmt, args),
> >         TP_STRUCT__entry(
> > 		/* 200 is the max length we expect/reserve */
> >                 __fmt_string(msg, 200)
> >         ),
> >         TP_fast_assign(
> >                 __vprint_str(msg, fmt, args);
> >         ),
> >         TP_printk("%s", __get_str(msg))
> > );
> > 
> > 
> > Behind the scenes somehow the 200 would get reserved, propagated,
> > __vprint_str would call something like
> > 	r = vsnprintf(__get_str(msg), 200, fmt, args);
> > 
> > and use r to shrink the entry if possible.
> 
> This is interesting. Now we could add an API to ftrace (and maybe even
> perf?) that can shrink the buffer if the space isn't needed. We do that
> already if we decide to filter out the trace ponit, the allocated buffer
> is freed if no interrupt came in and added data after it. If that
> happens than we just convert the event into dead space.
> 
> But another issue with this is that when you get to an end of a buffer
> page (internal buffers which currently are just page sizes). If you
> don't have enough space, it will go to the next buffer page and the
> space on the previous page is now wasted and can't be reclaimed.

Right. That's not *too* bad though because you're (hopefully!) not going
to have like 1024 here for the size of the messages.


> > Does this sound completely stupid? Yes maybe adding tracing (is there a
> > way to cause certain tracepoints to be printk'ed?) would be better but
> > converting all the messages to like a few hundred tracepoints would be a
> > huge waste as well.
> 
> Wait? I'm confused again. Maybe I read you wrong. Do you mean to make
> trace points printk'd? I think just make the current printk into a
> tracepoint and be done with it. But it would be all printks or none. We
> even still have ftrace_dump_on_oops if we need this information on a
> system crash.

No I'm just thinking into too many different directions at once.

If you assume my mail is about optimising trace_printk() to directly
format into the ring buffer, you'll be much happier ;-)

What my last paragraph was trying to say was: In theory I wouldn't need
to do
	trace_fmt_msg(fmt, va_args);
because I'd have a
	trace_foo(arg1, arg2, arg3);

with the right format in TP_printk(), but I'm trying to get existing
debug infrastructure into the trace *without* getting it into the kernel
messages (!)

johannes

