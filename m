Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab0ECVVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:21:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47129 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab0ECVVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:21:07 -0400
Date: Mon, 3 May 2010 23:20:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: perf, ftrace and MCEs
Message-ID: <20100503212047.GA16301@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20100501181212.GA25352@liondog.tnic>
 <1272897672.9739.218.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1272897672.9739.218.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, May 03, 2010 at 10:41:12AM -0400

Hi Steven,

> On Sat, 2010-05-01 at 20:12 +0200, Borislav Petkov wrote:
> > Hi,
> > 
> > so I finally had some spare time to stare at perf/ftrace code and ponder
> > on how to use those facilities for MCE collecting and reporting. Btw, I
> > have to say, it took me quite a while to understand what goes where - my
> > suggestion to anyone who tries to understand how perf/ftrace works is
> > to do make <file.i> where there is at least one trace_XXX emit record
> > function call and start untangling code paths from there.
> > 
> > So anyway, here are some questions I had, I just as well may've missed
> > something so please correct me if I'm wrong:
> > 
> > 1. Since machine checks can happen at any time, we need to have the
> > MCE tracepoint (trace_mce_record() in <include/trace/events/mce.h>)
> > always enabled. This, in turn, means that we need the ftrace/perf
> > infrastructure always compiled in (lockless ring buffer, perf_event.c
> > stuff) on any x86 system so that MCEs can be handled at anytime. Is this
> > going to be ok to be enabled on _all_ machines, hmmm... I dunno, maybe
> > only a subset of those facilites at least.
> 
> I'm not exactly sure what you goal is, but if you need to do something
> directly, you can bypass ftrace and perf. All trace events can be
> connected by anything even when ftrace and perf are not enabled.

Right, so the idea is to use the perf/ftrace infrastructure to detect
failing hardware which is signalled through machine checks, among
others. I'm thinking a lockless ring buffer would be cool so we can
execute in any context... wait a minute, right, we have that already.

However, if I use the perf/ftrace facilities, I have to have them
enabled on every system since machine checks are core processor
functionality and the software support for those has to be always
enabled. And the code has to be small and execute fast since after a
critical mcheck happens all bets are off.

So I'm thinking maybe a core perf/ftrace stuff which is thin and is
always enabled... but I'm not sure for I haven't stared at the code
enough yet.

> That is, you need to connect to the tracepoint and write you own
> callback. This can be done pretty much at anytime during boot up. To see
> how to connect to a trace point, you can look at
> register_trace_sched_switch() in kernel/trace/ftrace.c. This registers a
> callback to the trace_sched_switch() trace point in sched.c.

The base tracepoint functionality should suffice for now but this is
definitely a cool point and good to know, thanks.

> > 
> > 2. Tangential to 1., we need that "thin" software layer prepared for
> > decoding and reporting them as early as possible. event_trace_init() is
> > an fs_initcall and executed too late, IMHO. The ->perf_event_enable in
> > the ftrace_event_call is enabled even later on the perf init path over
> > the sys_perf_even_open which is at userspace time. In our case, this is
> > going be executed by the error logging and decoding daemon I guess.
> > 
> > 3. Since we want to listen for MCEs all the time, the concept of
> > enabling and disabling those events does not apply in the sense of
> > performance profiling. IOW, MCEs need to be able to be logged to the
> > ring buffer at any time. I guess this is easily done - we simply enable
> > MCE events at the earliest moment possible and disable them on shutdown;
> > done.
> 
> This looks like a good reason to have your own handler. More than one
> callback may be registered to a tracepoint, so you do not need to worry
> about having other handlers affect your code.

Yep, good ideas, thanks. /me goes back to the drawing board.

-- 
Regards/Gruss,
    Boris.
