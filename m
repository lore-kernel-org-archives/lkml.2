Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab1KRNuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:50:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37523 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919Ab1KRNup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:50:45 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=bld6Cl09aJV4sZ3SSjkA:9 a=VF6Nvi1XXHHPLZbr3DUA:7 a=QEXdDO2ut3YA:10 a=Kw0oQSCfRH7OzOqa:21 a=-9EhNBvnkgyptK-B:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: tracing vs. string formatting
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1321610382.10266.19.camel@jlt3.sipsolutions.net>
References: <1321610382.10266.19.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 08:50:41 -0500
Message-ID: <1321624241.3533.45.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 10:59 +0100, Johannes Berg wrote:
> Hi,
> 
> I'm thinking about adding tracing to all debug messages in our driver
> (iwlwifi) so we can ask people to record all debug messages (which are
> way too many, some can be removed), and then we could post-process it
> and only show selectively the ones we care about.
> 
> Converting all the messages and/or adding tracing at all the points
> where we have messages now would be a huge effort, and sometimes the
> messages are all that we can get from users, so we wouldn't want to get
> rid of them either.
> 
> Therefore I was thinking we should just trace the messages.
> 
> The issue I ran into is that obviously almost all messages need string
> formatting. But to put them into the trace, we have two choices now that
> I can see:
> 
> 1) format the messages into a temporary buffer, then copy into the trace
> 2) format the messages into the ringbuffer, reserving the max length we
>    think we might need

I'm confused? Is this a different topic than printk tracing? As with
printk, if you put the trace point where I mentioned before, you let
printk figure out the size already and all it takes is a string and
length, and it will allocate just enough for the ring buffer to place it
there.

But if you are talking about something else, then sure this is an issue.
Currently trace_printk() uses a temporary buffer. Why waste 200 bytes in
the ring buffer that's not needed.

> 
> Both have obvious problems: The trivial implementation of 1) is stupid
> if tracing is disabled and at least incurs an extra copy. 2) means that
> I need to reserve say 200 bytes for each entry and then will end up not
> using a large chunk of it in most cases.
> 
> Is there any way to reserve those 200 bytes, but then when we commit
> update the trace entry length and also un-reserve whatever size we
> didn't need? Then we could directly vsnprintf into the ring-buffer and
> use the return value to update from 200 bytes reserved to say 20.
> 
> The API I'm envisioning would look a bit like this:
> 
> TRACE_EVENT(foo_dbg,
>         TP_PROTO(const char *fmt, va_list args),
>         TP_ARGS(fmt, args),
>         TP_STRUCT__entry(
> 		/* 200 is the max length we expect/reserve */
>                 __fmt_string(msg, 200)
>         ),
>         TP_fast_assign(
>                 __vprint_str(msg, fmt, args);
>         ),
>         TP_printk("%s", __get_str(msg))
> );
> 
> 
> Behind the scenes somehow the 200 would get reserved, propagated,
> __vprint_str would call something like
> 	r = vsnprintf(__get_str(msg), 200, fmt, args);
> 
> and use r to shrink the entry if possible.

This is interesting. Now we could add an API to ftrace (and maybe even
perf?) that can shrink the buffer if the space isn't needed. We do that
already if we decide to filter out the trace ponit, the allocated buffer
is freed if no interrupt came in and added data after it. If that
happens than we just convert the event into dead space.

But another issue with this is that when you get to an end of a buffer
page (internal buffers which currently are just page sizes). If you
don't have enough space, it will go to the next buffer page and the
space on the previous page is now wasted and can't be reclaimed.


> 
> 
> 
> Now obviously I have no idea if it's even possible to shrink an entry
> afterwards :-) It seems like it should be since the local CPU buffer is
> locked in some way, but ... what do I know. Interrupts coming in would
> probably have to make it not shrink the entry, but that seems feasible
> too -- in that case you'd just have the 200 bytes used but not filled
> except for the message (though then maybe you have to memset the
> remainder to 0).
> 
> 
> Does this sound completely stupid? Yes maybe adding tracing (is there a
> way to cause certain tracepoints to be printk'ed?) would be better but
> converting all the messages to like a few hundred tracepoints would be a
> huge waste as well.

Wait? I'm confused again. Maybe I read you wrong. Do you mean to make
trace points printk'd? I think just make the current printk into a
tracepoint and be done with it. But it would be all printks or none. We
even still have ftrace_dump_on_oops if we need this information on a
system crash.


> 
> 
> If you made it this far -- thanks! :-)

I did, but I'm still on meds ;)

-- Steve


