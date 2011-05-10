Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab1EJDJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 23:09:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39556 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab1EJDJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 23:09:00 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=UZYI7n2t75YA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=D19gQVrFAAAA:8 a=YbADEvPHE7XSDCzyDSQA:9 a=giL2IKhM2Ye7GJDels8A:7 a=QEXdDO2ut3YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20110507190033.GA11465@elte.hu>
References: <4DC45537.6070609@linux.intel.com>
	 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
	 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
	 <20110507065803.GA23414@elte.hu>
	 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
	 <20110507144402.GC2859@elte.hu> <1304788829.11129.57.camel@frodo>
	 <20110507190033.GA11465@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 23:07:27 -0400
Message-ID: <1304996847.2969.151.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-07 at 21:00 +0200, Ingo Molnar wrote:

> > Note, I discussed this change with Frederic and he totally agreed with
> > me on removing it. In fact, we are in discussions about getting rid of
> > pid, preempt-count, and irq flags as well. But according to your logic,
> > that is a no go. I guess Frederic also does not *realize* there's a
> > whole tooling world behind this mechanism too.
> 
> Well, there's no sign of that in the changelog, Frederic did not write this 
> change nor did he ack it or otherwise sign off on it. There is a whole world of 
> difference between 'agreeing on IRC' and actually pushing such a commit 
> upstream.

You're right that this discussion was not in the change log, but
Frederic did recommend this change in email.

https://lkml.org/lkml/2010/12/9/195

"The first thing is that we need to get rid of the lock_depth field, the
bkl is dying."


> > > PowerTop uses the perf ABI because it's a rather convenient and unified 
> > > method to get a rich selection of events via the same facility, same 
> > > ring-buffer, using a system call ABI, etc.
> > 
> > It seams that Arjan read the perf kernel code to see how the raw data was 
> > laid out and read it directly.
> 
> Yes, of course - i also have code that uses the syscall directly, it's easier 
> to code up ad-hoc than to parse some XML-lookalike descriptor from 
> /debug/tracing/events/.

So you admit this is a ad-hoc way of doing things. Thus a library is a
perfect solution. And the event formats are far from XML-look-a-like.
You really think this:

name: sched_switch
ID: 57
format:
	field:unsigned short common_type;	offset:0;	size:2;
	field:unsigned char common_flags;	offset:2;	size:1;
	field:unsigned char common_preempt_count;	offset:3;	size:1;
	field:int common_pid;	offset:4;	size:4;
	field:int common_lock_depth;	offset:8;	size:4;

	field:char prev_comm[TASK_COMM_LEN];	offset:12;	size:16;
	field:pid_t prev_pid;	offset:28;	size:4;
	field:int prev_prio;	offset:32;	size:4;
	field:long prev_state;	offset:40;	size:8;
	field:char next_comm[TASK_COMM_LEN];	offset:48;	size:16;
	field:pid_t next_pid;	offset:64;	size:4;
	field:int next_prio;	offset:68;	size:4;

Is equivalent to this:

<?xml version="1.0" encoding="UTF-8"?>
<KernelShark><CaptureSettings><Events><CaptureType>Events</CaptureType><System>sched</System></Events><Plugin>function_graph</Plugin><File>/tmp/trace.dat</File></CaptureSettings></KernelShark>

??


> > > I raised this issue in the past. ftrace and perf has to be unified sooner 
> > > rather than later.
> > 
> > We agree on a unification, just that we do not agree on the path it takes. 
> > Every time I take one step forward, you slam me backwards two steps. At 
> > kernel summit, we all agreed on a stable event layout, or just a new way to 
> > move the events out of debugfs, but you nacked it. You wanted me to work with 
> > Peter Zijlstra with sysfs, and that was just too complex. Peter seemed to 
> > agree with me as he wasn't working on software events for it, but hardware 
> > events as that's where hardware lives.
> 
> I think its rather obvious how the unification should be done: check 
> tip:tmp.perf/trace for the 'trace' command that does tracing.

I'll tell you what. I've been talking with other developers and one
thing we came up with that we all seem to agree with is that ftrace is
designed to trace the entire system, and it does it very well. Perf is
designed to trace individual tasks, and it does it very well (trace is
an example of this. It's focus is on tasks not the system). Ftrace can
also trace individual tasks and perf can also trace the entire system,
but they both do those poorly.

If we can agree to keep ftrace as the "system view" and perf as the
"task view", I will gladly work on perf, and specifically this trace
utility. And where I can share infrastructures of the two, I will also
do that as well. Thus I can work on getting things like function tracing
for tasks in perf, and even PMU recording into ftrace. I always say,
"use the proper tool for the job". I believe this could work and I would
make a big effort in doing so.


> 
> Check whether there's any feature missing from it that you'd like to see, add 
> it. Rinse, repeat.

Again, the design of trace/perf is task oriented. Ftrace is system
oriented. Could we agree on that?

> 
> There is nothing inherently hard nor complex about it.
> 
> > > As i see it the problem is the thought-less ftrace churn and the fragility 
> > > of how TRACE_EVENT() can be changed.
> > 
> > Now you are just insulting me. There has not been any "thought-less" churn.
> > 
> > I *designed* TRACE_EVENT() to be changed. That's why I wrote all that code to 
> > export the event formats. If you think all raw data of events are to be an 
> > ABI, then lets rip out all the event formats and make everything hard-coded.
> 
> You are quite mistaken there.
> 
> There are two main advantages of TRACE_EVENT():
> 
>  - it allows easy, C-alike tracepoint definitions that are unintrusive to
>    kernel developers
> 
>  - it is easy to *EXTEND* it, so that tools can pick up new events
> 
> And yes, you must remember that we two kept iterating the early prototype of 
> TRACE_EVENT() until those two requirements were met.

But the work to create the event format files was for the sole purpose
of allowing a way to have events change to reflect kernel design
changes.

> 
> 'Changing' a tracepoint is obviously easy if extending it transparently is 
> easy, it's a side effect - an unfortunate one.
> 
> Changing tracepoints is definitely frowned upon. We do not change tracepoints 
> if we can avoid it - we introduce new ones and we *maybe* phase out old, 
> obsolete ones.

You mean that we should have two trace-points in code at the same
location? And maintaining the old one, especially when the old one no
longer reflects what the kernel is doing?

The reluctance to trace points in the first place was this fear that
they would be immutable, and be even more intrusive and a major burden
than maintaining old syscalls. Arnd told me that keeping things like
old_readdir around is a total burden on every filesystem. Can you
imagine what would happen if a user tool started depending on
information inside the kernel. This information would have to be
maintained indefinitely! Over time, tracepoints will start getting loads
of useless data.

> 
> We had this exact discussion about the power events a couple of months ago!

And it was a discussion of making some events and fields "stable", and
at KS, we all agreed to designate what fields and events make sense in a
separate file system (or anything). But you disagreed with that it it
never happened. Now we are discussing that the entire raw event format
is the ABI. Thus if a tool raw maps an event just to get one single
field from that event, if that is not the first field of the event, this
means the offset of that field must stay the same, and makes all fields
before it permanent even though those other fields become useless data
over time.

Fields that get used by tools are probably good candidates of those
things that should not change, because some tool found use with them
(like PowerTop has with the power and sched events). But even PowerTop
does not use all the fields (like lock_depth). If we keep this raw
binary requirement, all fields of an event, where that event is being
used by a tool, are now permanent ABI.

> 
> > Linus said:
> > 
> > > If you made an interface that can be used without parsing the interface 
> > > description, then we're stuck with the interface. Theory simply doesn't 
> > > matter.
> > > 
> > > You could help fix the tools, and try to avoid the compatibility issues 
> > > that way. There aren't that many of them.
> > 
> > To me this seems that we have a way to have the tools do the right thing. 
> > [...]
> 
> Your whole premise is that we want to churn the tracepoints - and that premise 
> is *utterly wrong*.
> 
> In practice we very rarely want to change tracepoints: in the past 2 years we 
> had maybe 2-3 attempts.
> 
> *Adding* new tracepoints and *extending* functionality is the main action, 
> dozens are added per year. We can also phase out tracepoints. Both of these 
> things can be done without breaking the ABI.

Phasing out tracepoints is not something likely if it becomes an ABI.
Look at the example of getting rid of old_readdir. It may be the case
that no one uses it anymore, but we can't be sure.


> 
> Especially when there's tooling use it's not really desirable to fiddle with 
> the tracepoint, even if in theory we could reorder fields and not see tools 
> break. It's too easy to break the tool.

"even if in theory we could reorder fields and not see tools 
break. It's too easy to break the tool."

I'm sorry but that sounds like a contradiction to me.

> 
> > [...] If a library can be used that allows a more robust interface, then why 
> > not use it? [...]
> 
> But there is no library available in distros and realistically it wont be 
> widely available within a year, even if you released and packaged one up 
> overnight.

Luckily I came to Budapest, which happens to be having the Linaro@UDS
conference going on, and the Ubuntu package maintainer is here. I
already talked to him and his willing to get this out ASAP (going
through the proper procedure). You can come and discuss this with us
too.

Also having discussions with various people here I was thinking of,
instead of a "libparsevent.so" make a full "libperf.so". I could work
with Arnaldo and others on this. Not only could this have an interface
to read the events, but it will basically get rid of the need for
PowerTop to have its own perf.cpp files. Have the entire interaction
with perf be a user library shipped with the distros. I'm willing to
make this happen. Imagine the tools that will appear using the perf ABI
if we have a library for it!


>  Nor do you really seem to see the problem that changing tracepoints 
> brings with itself.

I am not for changing tracepoints on a whim. But I would like
tracepoints to change as the kernel design changes. The reason
tracepoints have currently been stable is that kernel design changes do
not happen often. But they do happen, and I foresee that in the future,
the kernel will have a large number of "legacy tracepoints", and we will
be stuck maintaining them forever.

What happens if someone designs a tool that analyzes the XFS
filesystem's 200+ tracepoints? Will all those tracepoints now become
ABI?


> 
> The main property of TRACE_EVENT() is that new tracepoints can be picked up by 
> scripting engines and other tools. You are concentrating on an aspect that is 
> rarely done, unimportant and causes pain. Why?

Because it is rarely done, and if done correctly through a library, it
will not cause pain.

Why? Because I worry that this precedence that we set today will have
huge consequences for Linux in the future. Trace events are too easy to
create. Much easier to create than a new syscall. And we do not put the
time nor effort into these events to verify that they can last as a long
term ABI.

As I stated, with keeping the "raw format" as an ABI, then an event can
never change. Which will lead to dozens of these legacy tracepoints all
over the place. As tracepoints become more popular (as they are quickly
becoming), more tools will be developed that will interact with them.
Lets give these tools a library now that they can use to easily read
these tracepoints the proper way. We could also mark fields in the
TRACE_EVENT() that we would consider "stable" for tools to use. Then
this library could have an interface to read "stable" events/fields, and
"debug" events/fields. This will allow developers to mark events and
fields that they plan on maintaining for the future.

The approach I'm suggesting is to give tools a generic way to extract
these "useful" events, and not be bothered if that event has a "non
useful" field removed. And I would like a way to let applications know
which fields are stable and which are not. If an application developer
wants one of the non stable fields to become stable, then can request
it, the maintainer of that event could make the decision or help the
user find a way to not need this field as stable. We can document this
all in the man pages of this library.

To enforce the stable vs debug events even more, the library could
provide two interfaces. One is to get stable events and would print a
warning if they do not exist. The other is to get debug events, where
the idea behind the call is that these events/fields may not exist, and
it would not warn about them not existing, but instead quietly fail
(with a error return code).

> 
> > [...] The library already exists, I talked to Arjan, and he's willing to use 
> > it. I'm willing to put the effort in fixing powerTop and pushing this library 
> > to distributions. What's the problem?
> 
> I can see a couple of problems right away:
> 
>  - i do not actually want to see people change trace events all that often. It's
>    a bad practice and even with a library it can break stuff.

I do not see trace events changing very often either, but I do see them
changing. If we have a library it can still break, but if we implement
the "stable" vs "debug" perhaps we could avoid this issue too.

> 
>  - old binaries and other tools that might already make use of these events.

Currently it's perf and PowerTop. Perf uses and old version of the
libparsevent.so library, and is not affected by the lock_depth change.

PowerTop parsed the raw binary, which required the skills of a competent
kernel developer to be skilled enough to dig into the kernel source and
find how the event layout is done. There's not many userspace tools out
there that are developed by competent kernel developers. My fear is
someone may cut and paste the code of PowerTop and start with that.
Although mapping new events may be beyond non-competent kernel
developers abilities.

If we can make PowerTop use a library ASAP, then hopefully those
copy-cats will do it the right thing.


> 
>  - you are complicating an otherwise really simple and dependable facility.

It's simple today. But will be a burden in the future. And I actually
think that a library will make PowerTop (et al) even simpler.

> 
> So you can write the library if it's more convenient to some people, that's not 
> a problem (it is good) - just do not use it as an *excuse* to break the ABI. We 
> cannot break the ABI today and we will likely not be able to do it for a long 
> time.

It's not about breaking an ABI, it's about coming up with a robust ABI.
If we implement a library, and perhaps even implement "stable" events
and fields, then I believe in the long term, Linux will be much better
off.

> 
> > You are entering a very dangerous precedence by stating that the raw format 
> > is now the ABI, end of story. This will bite us in the future. It just did, 
> > and it will just get worse.
> 
> What is 'dangerous' about a stable ABI? I can only see many upsides and few 
> downsides.

If the stable ABI is not correctly done (and new trace events are not
added with the thought that they are a stable ABI), it will haunt us
forever.

> 
> Again, your whole premise is wrong.
> 
> > > As things look like from my side it appears you want to keep ftrace a 
> > > messy, forked project with no regard to perf based tooling and this will 
> > > fragment Linux instrumentation, the many technical disadvantages be damned.
> > 
> > ftrace is not a fork and never was. To be a fork, we need a common ancestor. 
> > Ftrace and perf do not have that. Perf was created (after Ftrace) to profile 
> > events, and did so very well. It just happened to expand into the tracing 
> > area, where you want me to abandon all my ftrace work and rewrite it on top 
> > of something that was not designed to do tracing.
> 
> perf did not 'expand into tracing' - it was always a tracer from day 1 on, you 
> cannot do profiling without having a trace to build a histogram out of :-)
> 
> I told you that as early as 1 months into the perf project. I also told you why 
> we didnt use the ftrace ring buffer, 2 months into the perf project and asked 
> you to please help out. We are now 30+ months later ...
> 
> perf is basically the ftrace UI and APIs done better, cleaner and more 
> robustly. Look at all the tooling that sprang up around that ABI, almost 
> overnight.

I could pretty much say the same for the ftrace tracers.  But as we
realize now, there was better ways of doing it (events). The reason for
perf's UI and APIs taking off was that it was so much easier than
oprofile and friends. But perf is still struggling with the tracing
front. Perhaps "trace" will fix that.

> 
> ftrace evolved through many iterations in the past and perf was simply the next 
> logical step.

Perf did not seem to follow any of the "lessons learned" of ftrace, but
instead it was a "lessons learned" of oprofile.

>  You were happy when the original iotrace code was replaced by 
> ftrace, right?

Honestly, my reaction was nothing more that "cool!", and then I forgot
about it. I was also happy when I found that oprofile used the ftrace
ring buffer.


>  Now you seem to be a lot more reluctant to let go of ftrace's 
> current iteration in favor of a clearly superior tooling approach, and that is 
> rather sad to see.

Unfortunately, I do not see it as a "clearly superior tooling approach".
In fact, I see it as quite the opposite, and we've had these discussions
before. Sure, I think a userspace tool to read ftrace is required,
whether it is trace-cmd or perf. But I find myself constantly using the
debugfs system as I still find it sometimes more convenient.

If the only way to read the ftrace data is through a tool (and this
includes ftrace_dump_on_oops console output), there would be times that
I would go back to using logdev. This means, I would stop using ftrace
for certain tasks. I find that bad if the maintainer doesn't use the
tool that he maintains.

Perhaps the only real upside of keeping the debugfs pretty printing is
convenience in kernel development/debugging.

But I see no upside for getting rid of it, besides some developers
saying "I don't like it".


> 
> > Now that perf has entered the tracing field, I would be happy to bring the 
> > two together. [...]
> 
> Great - please see tip:tmp.perf/trace, that would be a very good point to 
> start. It's a working prototype for an ftrace-alike tracing workflow.

I'll do it, if we can agree about the ftrace as system
tracing/debugging, and trace can focus on user specific tracing.

-- Steve


