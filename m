Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2CXJPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 05:15:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38152 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab2CXJPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 05:15:06 -0400
Date: Sat, 24 Mar 2012 10:15:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, mce: Add persistent MCE event
Message-ID: <20120324091501.GA29250@gmail.com>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
 <1332340496-21658-3-git-send-email-bp@amd64.org>
 <20120323123156.GF13920@gmail.com>
 <20120323133044.GA8115@aftab>
 <20120324073731.GD20145@gmail.com>
 <20120324090030.GB15993@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120324090030.GB15993@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> On Sat, Mar 24, 2012 at 08:37:31AM +0100, Ingo Molnar wrote:
> > I was mainly thinking of reducing this:
> > 
> >  arch/x86/kernel/cpu/mcheck/mce.c |   53 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 53 insertions(+)
> > 
> > to almost nothing. There doesn't seem to be much MCE specific in 
> > that code, right?
> 
> Yeah, this could be generalized even more, AFAICT.
> 
> > 
> > > Btw, the more important question is are we going to need 
> > > persistent events that much so that a generic approach is 
> > > warranted? I guess maybe the black box events recording deal 
> > > would be another user..
> > 
> > So, here's the big picture as I see it:
> > 
> > I think tracing could use persistent events: mark all the events 
> > we want to trace as persistent from bootup, and recover the 
> > bootup trace after the system has been booted up.
> 
> Right, but (more nasty questions):
> 
> Why would I do this, am I tracing the boot process? [...]

Correct, in essence the MCE persistent event is partially about 
that: we are starting to collect events well before there's any 
user-space available.

> [...] If so, then I need another syntax which enables those 
> events from the kernel command line which gets parsed the 
> moment ftrace and ring buffer get initialized.

Correct. Something really simple like:

  boot_trace=<event1>,<event2>...

... which could be all implicit within MCE too. (So I'm not 
suggesting some boot command trigger to provide the MCE case - 
but for more general boot tracing it would be the right 
solution.)

> IOW, I'd need userspace for perf otherwise but I don't have 
> that before booting...

Correct. In the case of MCE there's no "userspace" really needed 
- we just want to trace early enough. This model carries over to 
later as well: there's no *specific* process we want to attach 
the trace buffer to - we just want a persistent trace buffer 
that essentially never loses MCE events.

> Then, after having booted, do I stop the trace? If no, then I 
> can see the persistency in there so are you saying we want a 
> low overhead, low ressource utilization machinery which runs 
> all the time and traces the system? What are possible real 
> life use cases for that? Scheduler analysis probably, 
> long-term tracing of some stuff people are interested in how 
> it behaves over long periods of time... MCE is one use case, 
> definitely...

Boot tracing is a very real usecase, people use it to reduce 
boot times. Today printk timestamps are used as a substitute. 
(There's also a boot tracer plugin within ftrace, see the 
bootup_tracer.)

> > But other, runtime models of tracing could use it as well: 
> > basically the main difference that ftrace has to perf based 
> > tracing today is a system-wide persistent buffer with no 
> > particular owning process. (The rest is mostly UI and 
> > analysis features and scope of tracing differences, and of 
> > course a lot more love and detail went into ftrace so far.)
> > 
> > So MCE will in the end be just a minor user of such a 
> > facility - I think you should aim for enabling *any* set of 
> > events to have persistent recording properties, and add the 
> > APIs to recover that information sanely. It should also be 
> > possible for them to record into a shared mmap page in 
> > essence - instead of having per event persistent buffers.
> 
> Sounds like ftrace. But we have that already, we only need to 
> get to using it perf-side, no...? [...]

What we want is to extend the perf ring-buffer to be persistent 
*as well*. It's an evidently useful model of collecting events.

All the remaining perf tooling can be used after that point - if 
it's a bog-standard perf ring-buffer then it can be saved into a 
perf.data and can be analyzed in a rich fashion, etc.

Think about it: for example we could do not just boot tracing 
but also boot *profiling*, by using the PMU to sample into a 
persistent buffer which after bootup can be put into a perf.data 
and 'perf report' will do the right thing, etc...

Does it overlap with ftrace? Perf overlapped with ftrace from 
day one on and it's starting to become a maintenance problem: we 
want to remove that overlap not by keeping two separate entities 
(both of which suck and rule in their own ways) but having a 
unified facility.

Thanks,

	Ingo
