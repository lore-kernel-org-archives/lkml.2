Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab1EGRVZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 13:21:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39238 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1EGRVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 13:21:24 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=UZYI7n2t75YA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=JfrnYn6hAAAA:8 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=jvnojqIPBO8feV3NjEMA:9 a=mQgGrqePzwYX112SlWcA:7 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=3Rfx1nUSh_UA:10 a=UTB_XpHje0EA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=o3bgFf7P9ji2_AyG:21 a=ajEMdvU16i8v_7mU:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110507144402.GC2859@elte.hu>
References: <4DC45537.6070609@linux.intel.com>
	 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
	 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
	 <20110507065803.GA23414@elte.hu>
	 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
	 <20110507144402.GC2859@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 May 2011 13:20:29 -0400
Message-ID: <1304788829.11129.57.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-07 at 16:44 +0200, Ingo Molnar wrote: 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 2) we separate perf from ftrace and keep the "stable" ABI for perf, and let 
> > ftrace advance into a more efficient tracer.
> 
> The thing is, ftrace is still largely separated from perf, and this is why this 
> regression came in: a random tracing 'cleanup' churn was done to 'tracing' 
> which broke PowerTop.
> 
> Look at the commit itself:
> 
>   e6e1e2593592: tracing: Remove lock_depth from event entry
> 
> Clearly you didnt even *realize* that there's a whole tooling world behind this 
> mechanism ...

Note, I discussed this change with Frederic and he totally agreed with
me on removing it. In fact, we are in discussions about getting rid of
pid, preempt-count, and irq flags as well. But according to your logic,
that is a no go. I guess Frederic also does not *realize* there's a
whole tooling world behind this mechanism too.

> 
> The core perf ABI is set up in a way that makes it rather hard to break the ABI 
> accidentally. I can bisect back kernel release after kernel release and old 
> tooling will work on new kernel and new tooling will work on old kernels.

and I could do the same with ftrace/trace-cmd/kernelshark

> 
> PowerTop uses the perf ABI because it's a rather convenient and unified method 
> to get a rich selection of events via the same facility, same ring-buffer, 
> using a system call ABI, etc.

It seams that Arjan read the perf kernel code to see how the raw data
was laid out and read it directly.

> 
> The ftrace event bits on the other hand, still somewhat glued on to the perf 
> ABI are still very fragile to such spurious changes like the one that caused 
> the regression here.

Note also that perf glued to ftrace, ftrace did not glue to perf.
Perhaps perf should have not used the ftrace infrastructure. Or more
exactly, it should not have exported the ftrace infrastructure out to
userspace.

I wrote the TRACE_EVENT() macros not to be tied down with ftrace, but
that it could benefit other utilities, including LTTng, and every one
knows that Mathieu and I do not agree on that project. But
never-the-less, I did not make TRACE_EVENT() bound to ftrace, but made
it agnostic to all utilities.

Ironically, perf benefited from this agnostic approach and easily bound
to the TRACE_EVENT() macro. But instead of writing its own
include/trace/perf.h code, it just hacked into the already existing
ftrace user of TRACE_EVENT(). This caused perf to read unnecessary
things like pid, preempt_count, interrupt flags and even lockdepth.


> 
> I raised this issue in the past. ftrace and perf has to be unified sooner 
> rather than later.

We agree on a unification, just that we do not agree on the path it
takes. Every time I take one step forward, you slam me backwards two
steps. At kernel summit, we all agreed on a stable event layout, or just
a new way to move the events out of debugfs, but you nacked it. You
wanted me to work with Peter Zijlstra with sysfs, and that was just too
complex. Peter seemed to agree with me as he wasn't working on software
events for it, but hardware events as that's where hardware lives.


> 
> > Here's the choices then:
> > 
> > 1) we get libparsevent.so out into the world and all tools can use it, and 
> > the raw formats of the trace events will no longer be an issue as long as the 
> > names of events and fields stay the same.
> 
> Firstly, such an event parser already exists in 
> tools/perf/util/parse-events.[ch], so if you want to librarize it please talk 
> to Arnaldo to create tools/perf/lib/ and a libperf.so.

The pares-events.[ch] file in perf just parses the command line options
to denote what events need to be recorded. The real work lies in
trace-event-parse.c that does the real parsing, and that file was copied
from libparsevent.so. I purposely wrote that as a library that perf
could use (again, being open to other ideologies), but instead of using
the library, the code was hard coded into perf, which guaranteed the
forking of this code.

> 
> There's 10 separate contributors to that file already:
> 
>  earth4:~/tip> git-authors-email tools/perf/util/parse-events.c 
>       2  Peter Zijlstra <peterz@infradead.org>
>       2  Stephane Eranian <eranian@google.com>
>       2  Ulrich Drepper <drepper@redhat.com>
>       3  Jason Baron <jbaron@redhat.com>
>       3  Li Zefan <lizf@cn.fujitsu.com>
>       3  Peter Zijlstra <a.p.zijlstra@chello.nl>
>       7  Frederic Weisbecker <fweisbec@gmail.com>
>       7  Jaswinder Singh Rajput <jaswinder@kernel.org>
>      13  Arnaldo Carvalho de Melo <acme@redhat.com>
>      15  Ingo Molnar <mingo@elte.hu>
> 
> Most notably *you* are not amongst them. Not a single commit out of close to a 
> hundred commits. Why not? This really demonstrates the level of disinterest you 
> are showing towards perf based tooling, still you keep modifying the underlying 
> code in the kernel.

You are judging my interest with a single file that is used to parse
command line options to perf?

I just recently posted a patch set to the function tracer that allows it
to have users agnostic to each other. That took me more than a week to
write. The main reason I wrote that was to allow perf to use function
tracing.

> Secondly, you are solving the wrong problem and you are not seeing the real 
> problems. We can keep and we *will* keep ABIs, it's not hard. 4 bytes padding 
> is not an issue and it never was for PowerTop nor for any other real person who 
> relies on tracing.

I've Cc'd the Google folks that are very interested in tracing, to let
them respond to that comment.

Do you think that "other real person"s are only kernel developers or
desktop users that are not using production systems?

And it's not just 4 bytes, its the entire useless header. Who cares
about preempt counts? I examine that field only 1% of the time. In most
other cases its totally useless. Same with interrupt flags, although I
do look at them more often than preempt count. We (Frederic and I) still
want to get rid of the pid for every event.


> 
> As i see it the problem is the thought-less ftrace churn and the fragility of 
> how TRACE_EVENT() can be changed.

Now you are just insulting me. There has not been any "thought-less"
churn.

I *designed* TRACE_EVENT() to be changed. That's why I wrote all that
code to export the event formats. If you think all raw data of events
are to be an ABI, then lets rip out all the event formats and make
everything hard-coded.

I'm sorry, but that mentality seems to encourage thoughtless churn.

> 
> Really, ftrace and in particular you are showing a huge disconnect and i'm 
> increasingly unhappy about it. Look at this very thread: you fought tooth and 
> nail to even *acknowledge* that there is a problem...

I agree there is a problem, but what each of us think the problem is, is
different. I say there's a problem with tools depending on a layout of
raw data that is internal to the kernel, especially when it was designed
to allow robustness. If we make it easy for tools to extract the data
properly, then there should not be any issues if the raw format changes.

Linus said:

> If you made an interface that can be used without parsing the
> interface description, then we're stuck with the interface. Theory
> simply doesn't matter.
> 
> You could help fix the tools, and try to avoid the compatibility
> issues that way. There aren't that many of them.

To me this seems that we have a way to have the tools do the right
thing. If a library can be used that allows a more robust interface,
then why not use it? The library already exists, I talked to Arjan, and
he's willing to use it. I'm willing to put the effort in fixing powerTop
and pushing this library to distributions. What's the problem?

You are entering a very dangerous precedence by stating that the raw
format is now the ABI, end of story. This will bite us in the future. It
just did, and it will just get worse.
 
> 
> As things look like from my side it appears you want to keep ftrace a messy, 
> forked project with no regard to perf based tooling and this will fragment 
> Linux instrumentation, the many technical disadvantages be damned.

ftrace is not a fork and never was. To be a fork, we need a common
ancestor. Ftrace and perf do not have that. Perf was created (after
Ftrace) to profile events, and did so very well. It just happened to
expand into the tracing area, where you want me to abandon all my ftrace
work and rewrite it on top of something that was not designed to do
tracing.

Now that perf has entered the tracing field, I would be happy to bring
the two together. But we disagree on how to do that. I will not drop
ftrace totally just to work on perf. There's too many users of ftrace
that want enhancements, and I will still support that. The reason being
is that I honestly do not believe that perf can do what these users want
anytime in the near future (if at all). I will not abandon a successful
project just because you feel that it is a fork.


> 
> I simply do not see that you understand this whole problem space, i do not see 
> that you are driving towards unifying ftrace and perf - i only see that you are 
> hacking in random, sometimes harmful directions and that you are stubornly 
> ignoring my negative feedback about this.


Exactly, *you* do not see it. I've been bending over backwards trying to
find common ground to get to an end result that will satisfy everyone.
When I talk with Frederic, Peter, Arnaldo, or Thomas, we move forward.
For some reason, I hit a wall with you. I can't move forward with you
because, unless we do it entirely your way, we can't do it at all.

You do not even realize that I worked my butt off this past week to get
function tracing for perf.

> 
> If problems like this continue i will have to stop pulling new ftrace
> features from you.

This is the difference between us. You are the gate-keeper. I can't get
in the kernel unless you agree. This means that, because you think
ftrace is a fork of perf, and that unless I do everything with the sole
purpose of making perf do what ftrace can, none of my work will get into
the kernel. Thus, even though I want to support ftrace, you will not let
me. I'm glad that's out in the public.


> Thanks,

Your welcome.

Note, I'm about to hop on a plane to start my journey to Budapest.
Perhaps we can sit down and discuss this over a beer. I'm still
optimistic that we can work this out.

-- Steve


