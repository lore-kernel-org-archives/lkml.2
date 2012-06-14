Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab2FNXiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:38:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2FNXiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:38:06 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=G0s97Kyuy1EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=07d9gI8wAAAA:8 a=5BE8Kr9kklMZdMAaoD8A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339717084.13377.275.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: Fix the outmost stupidity of tracing_off()
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Thu, 14 Jun 2012 19:38:04 -0400
In-Reply-To: <alpine.LFD.2.02.1206150047510.3086@ionos>
References: <alpine.LFD.2.02.1206142345100.3086@ionos>
	 <alpine.LFD.2.02.1206150047510.3086@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 00:50 +0200, Thomas Gleixner wrote:
> Steven,
> 
> On Fri, 15 Jun 2012, Thomas Gleixner wrote:
> >  void tracing_off(void)
> >  {
> >  	if (global_trace.buffer)
> > -		ring_buffer_record_on(global_trace.buffer);
> > +		ring_buffer_record_off(global_trace.buffer);
> 
> this is the gazillionst time that I wasted valuable time relying on
> the not so extraordinary expectation that the kernel tracer stays
> functional at least in the most basic ways.

I admit this bug should have never made it in. I'm not sure how it did
because I know I tested the tracing_off() code before submitting it. But
it could have been something stupid as making the fix but never pushing
it. There were some conflicts I had with updating to the latest tip and
I may not have checked that what made it into the tip repo was what was
in my latest.

That's not my normal workflow. I usually use git to make sure I can fast
forward all my changes to tip/perf/core, but it may have missed this
case.

> 
> I'm really tired of wasting hours and days just because you are unable
> to keep your stuff straight and functional.
> 
> I avoided to make public fuzz about that so far, but my patience is
> exhausted now.

I'm fine with you making your complaints public. I prefer it that way.
To get things out in the open, whether good or bad.

> 
> You know yourself how many times I ranted to you on IRC or in private
> conversations, but you just keep on to bask in your egocentric
> mastering the uber complexity treat.
> 
> Your self description (https://lwn.net/Articles/500388/):
> 
>  Complexity is my Sun, and I am the planet that orbits around it.

Actually, that saying was inspired by your previous comments to me.
Although, I didn't mean that to be that I like to do things in complex
ways, but that complex tasks seem to draw me in. There is a difference.



> 
> is pretty accurate.
> 
> You can orbit around whatever you want and as long as you want, just
> please do that on your own playground and not on the expense of
> others.

This isn't my own playground. That change happened to come about when
someone else started implementing using the ring buffer for something
completely different than tracing. I found that the tracing 'tracing_on'
file was interfering with that code. I had to make it so that the file
would only disable tracing, not all users of the ring buffer facility.

That's actually something I thought you would respect. As why would
echoing 0 into tracing_on for ftrace disable recording of data that has
nothing to do with tracing.

That file should have never been part of the ringbuffer, it should have
been contained by ftrace from day one. Yes, that was my own fault that I
did not do that.


> 
> I always held up to ftrace, but the repeating experience of
> disfunctionality caused by your refusal to put your priorites straight
> is just too annoying.
> 
> It's not the first time, that tracing_off() or other stuff I'm
> depending on has been broken and caused me exhaustive loss of time.

I remember the beginning with 'tracing_enabled' which was heavy weight
and required knowledge of the tracers. You hated it because this complex
tie in to the tracers made it difficult to stop and start tracing
between kernel and userspace. I agreed, and added the quick approach to
the ring buffer. But the ring buffer is generic, and that file should
have never been a big hammer to disable all ring buffer users. Just
ftrace's buffer.

> 
> I know that I'm not the average user of tracing, but that's not an
> excuse for pushing out crap over and over again.

I haven't used that excuse in a long time. Just when new code went in
and you were able to find all the corner cases. This bug was not a
corner case and I admit, this bug caused me a red face. When I saw it, I
really did crap. I said to myself, "I know I tested this, how the hell
did it get in like this??". I really think I pushed the wrong branch. As
I have used tracing_off() recently and it did work. But that was with my
own stale code. This failure was a hiccup in my work flow, and I have no
excuse for it.

> 
> I'm tired of it and to be honest, I'm going to spend some quality time
> on evaluating LLTNG. If it can do what I need then I switch over and
> see whether it can hold up to the basic expectations of a primary
> user. AFAICT from previous experience it can do that, and if Matthieu
> is willing and able to cooperate on integrating with perf, then I
> happily kick you off into your self chosen complexity orbit forever.

I'm all for competition. That's what open source is all about. If it
does come in and satisfies everyone's needs, I'll back off, and maybe
even contribute. In the past, I have tried to make contributions to
integrate perf and ftrace, but things did not go so well.

But a lot of my "complex" code gave perf the ability to do function
tracing. That was a lot of work and its main purpose was to give perf
that ability. With the integration of the libtraceevents library, things
are about to move faster as well.

I wanted to let perf have access to the ftrace ring buffering too, such
that we can get perf and ftrace events integrated. That was one of my
works in progress. We'll see how that goes.

-- Steve

