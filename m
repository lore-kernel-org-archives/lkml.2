Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1EGTAx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 15:00:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54490 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977Ab1EGTAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 15:00:52 -0400
Date: Sat, 7 May 2011 21:00:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
Message-ID: <20110507190033.GA11465@elte.hu>
References: <4DC45537.6070609@linux.intel.com>
 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
 <20110507065803.GA23414@elte.hu>
 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
 <20110507144402.GC2859@elte.hu>
 <1304788829.11129.57.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304788829.11129.57.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 2011-05-07 at 16:44 +0200, Ingo Molnar wrote: 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > 2) we separate perf from ftrace and keep the "stable" ABI for perf, and let 
> > > ftrace advance into a more efficient tracer.
> > 
> > The thing is, ftrace is still largely separated from perf, and this is why this 
> > regression came in: a random tracing 'cleanup' churn was done to 'tracing' 
> > which broke PowerTop.
> > 
> > Look at the commit itself:
> > 
> >   e6e1e2593592: tracing: Remove lock_depth from event entry
> > 
> > Clearly you didnt even *realize* that there's a whole tooling world behind this 
> > mechanism ...
> 
> Note, I discussed this change with Frederic and he totally agreed with
> me on removing it. In fact, we are in discussions about getting rid of
> pid, preempt-count, and irq flags as well. But according to your logic,
> that is a no go. I guess Frederic also does not *realize* there's a
> whole tooling world behind this mechanism too.

Well, there's no sign of that in the changelog, Frederic did not write this 
change nor did he ack it or otherwise sign off on it. There is a whole world of 
difference between 'agreeing on IRC' and actually pushing such a commit 
upstream.

> > The core perf ABI is set up in a way that makes it rather hard to break the 
> > ABI accidentally. I can bisect back kernel release after kernel release and 
> > old tooling will work on new kernel and new tooling will work on old 
> > kernels.
> 
> and I could do the same with ftrace/trace-cmd/kernelshark

All created by you well after my repeated request for you to unify ftrace and 
perf.

You could have done all that based on a unified ABI. Instead you created forked 
tools.

> > PowerTop uses the perf ABI because it's a rather convenient and unified 
> > method to get a rich selection of events via the same facility, same 
> > ring-buffer, using a system call ABI, etc.
> 
> It seams that Arjan read the perf kernel code to see how the raw data was 
> laid out and read it directly.

Yes, of course - i also have code that uses the syscall directly, it's easier 
to code up ad-hoc than to parse some XML-lookalike descriptor from 
/debug/tracing/events/.

> [...]
> 
> > I raised this issue in the past. ftrace and perf has to be unified sooner 
> > rather than later.
> 
> We agree on a unification, just that we do not agree on the path it takes. 
> Every time I take one step forward, you slam me backwards two steps. At 
> kernel summit, we all agreed on a stable event layout, or just a new way to 
> move the events out of debugfs, but you nacked it. You wanted me to work with 
> Peter Zijlstra with sysfs, and that was just too complex. Peter seemed to 
> agree with me as he wasn't working on software events for it, but hardware 
> events as that's where hardware lives.

I think its rather obvious how the unification should be done: check 
tip:tmp.perf/trace for the 'trace' command that does tracing.

Check whether there's any feature missing from it that you'd like to see, add 
it. Rinse, repeat.

There is nothing inherently hard nor complex about it.

> > As i see it the problem is the thought-less ftrace churn and the fragility 
> > of how TRACE_EVENT() can be changed.
> 
> Now you are just insulting me. There has not been any "thought-less" churn.
> 
> I *designed* TRACE_EVENT() to be changed. That's why I wrote all that code to 
> export the event formats. If you think all raw data of events are to be an 
> ABI, then lets rip out all the event formats and make everything hard-coded.

You are quite mistaken there.

There are two main advantages of TRACE_EVENT():

 - it allows easy, C-alike tracepoint definitions that are unintrusive to
   kernel developers

 - it is easy to *EXTEND* it, so that tools can pick up new events

And yes, you must remember that we two kept iterating the early prototype of 
TRACE_EVENT() until those two requirements were met.

'Changing' a tracepoint is obviously easy if extending it transparently is 
easy, it's a side effect - an unfortunate one.

Changing tracepoints is definitely frowned upon. We do not change tracepoints 
if we can avoid it - we introduce new ones and we *maybe* phase out old, 
obsolete ones.

We had this exact discussion about the power events a couple of months ago!

> Linus said:
> 
> > If you made an interface that can be used without parsing the interface 
> > description, then we're stuck with the interface. Theory simply doesn't 
> > matter.
> > 
> > You could help fix the tools, and try to avoid the compatibility issues 
> > that way. There aren't that many of them.
> 
> To me this seems that we have a way to have the tools do the right thing. 
> [...]

Your whole premise is that we want to churn the tracepoints - and that premise 
is *utterly wrong*.

In practice we very rarely want to change tracepoints: in the past 2 years we 
had maybe 2-3 attempts.

*Adding* new tracepoints and *extending* functionality is the main action, 
dozens are added per year. We can also phase out tracepoints. Both of these 
things can be done without breaking the ABI.

Especially when there's tooling use it's not really desirable to fiddle with 
the tracepoint, even if in theory we could reorder fields and not see tools 
break. It's too easy to break the tool.

> [...] If a library can be used that allows a more robust interface, then why 
> not use it? [...]

But there is no library available in distros and realistically it wont be 
widely available within a year, even if you released and packaged one up 
overnight. Nor do you really seem to see the problem that changing tracepoints 
brings with itself.

The main property of TRACE_EVENT() is that new tracepoints can be picked up by 
scripting engines and other tools. You are concentrating on an aspect that is 
rarely done, unimportant and causes pain. Why?

> [...] The library already exists, I talked to Arjan, and he's willing to use 
> it. I'm willing to put the effort in fixing powerTop and pushing this library 
> to distributions. What's the problem?

I can see a couple of problems right away:

 - i do not actually want to see people change trace events all that often. It's
   a bad practice and even with a library it can break stuff.

 - old binaries and other tools that might already make use of these events.

 - you are complicating an otherwise really simple and dependable facility.

So you can write the library if it's more convenient to some people, that's not 
a problem (it is good) - just do not use it as an *excuse* to break the ABI. We 
cannot break the ABI today and we will likely not be able to do it for a long 
time.

> You are entering a very dangerous precedence by stating that the raw format 
> is now the ABI, end of story. This will bite us in the future. It just did, 
> and it will just get worse.

What is 'dangerous' about a stable ABI? I can only see many upsides and few 
downsides.

Again, your whole premise is wrong.

> > As things look like from my side it appears you want to keep ftrace a 
> > messy, forked project with no regard to perf based tooling and this will 
> > fragment Linux instrumentation, the many technical disadvantages be damned.
> 
> ftrace is not a fork and never was. To be a fork, we need a common ancestor. 
> Ftrace and perf do not have that. Perf was created (after Ftrace) to profile 
> events, and did so very well. It just happened to expand into the tracing 
> area, where you want me to abandon all my ftrace work and rewrite it on top 
> of something that was not designed to do tracing.

perf did not 'expand into tracing' - it was always a tracer from day 1 on, you 
cannot do profiling without having a trace to build a histogram out of :-)

I told you that as early as 1 months into the perf project. I also told you why 
we didnt use the ftrace ring buffer, 2 months into the perf project and asked 
you to please help out. We are now 30+ months later ...

perf is basically the ftrace UI and APIs done better, cleaner and more 
robustly. Look at all the tooling that sprang up around that ABI, almost 
overnight.

ftrace evolved through many iterations in the past and perf was simply the next 
logical step. You were happy when the original iotrace code was replaced by 
ftrace, right? Now you seem to be a lot more reluctant to let go of ftrace's 
current iteration in favor of a clearly superior tooling approach, and that is 
rather sad to see.

> Now that perf has entered the tracing field, I would be happy to bring the 
> two together. [...]

Great - please see tip:tmp.perf/trace, that would be a very good point to 
start. It's a working prototype for an ftrace-alike tracing workflow.

Thanks,

	Ingo
