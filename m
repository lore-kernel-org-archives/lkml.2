Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab0KKALR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:11:17 -0500
Received: from mail.openrapids.net ([64.15.138.104]:57018 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932100Ab0KKALQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:11:16 -0500
Date: Wed, 10 Nov 2010 19:11:10 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
	reporting)
Message-ID: <20101111001110.GA32564@Krystal>
References: <1289401781.12418.145.camel@gandalf.stny.rr.com> <1289403019.2084.17.camel@laptop> <20101110174852.GB4001@elte.hu> <1289412329.12418.177.camel@gandalf.stny.rr.com> <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu> <1289415645.12418.180.camel@gandalf.stny.rr.com> <20101110191127.GA6190@nowhere> <20101110202316.GA32396@Krystal> <20101110213033.GA7682@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110213033.GA7682@nowhere>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:30:55 up 49 days,  3:33,  4 users,  load average: 0.29, 0.19,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Wed, Nov 10, 2010 at 03:23:16PM -0500, Mathieu Desnoyers wrote:
> > * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > > On Wed, Nov 10, 2010 at 02:00:45PM -0500, Steven Rostedt wrote:
> > > > On Wed, 2010-11-10 at 19:41 +0100, Ingo Molnar wrote:
> > > > 
> > > > > We'll need to embark on this incremental path instead of a rewrite-the-world thing. 
> > > > > As a maintainer my task is to say 'no' to rewrite-the-world approaches - and we can 
> > > > > and will do better here.
> > > > 
> > > > Thus you are saying that we stick to the status quo, and also ignore the
> > > > fact that perf was a rewrite-the-world from ftrace to begin with.
> > > 
> > > Perhaps you and Mathieu can summarize your requirements here and then explain
> > > why extending the current ABI wouldn't work. It's quite normal that people
> > > try to find a solution fully backward compatible in the first place. If
> > > it's not possible, fine, but then justify it.
> > 
> > Sure, here are the requirements my user-base have, followed by a listing of Perf
> > and Ftrace pain points, some of which are directly derived from their respective
> > ABIs, others partially caused by their implementation and partially caused by
> > their ABI.
> 
> Yeah, but the main point here is to explain why/how reaching those goals is not
> efficiently possible through an extension of the current ABI, in practice.
> 
> I'm going to try for some of them. Note when I'll talk about ABI breakage,
> it actually means: create a new ABI and support the old one, schedule its
> deprecation in the long term.
> 
> Here we go:
> 
> 
> > 
> > - Low overhead is key
> >   - 150 ns per event (cache-hot)
> >   - Zero-copy (splice to disk/network, mmap for zero-copy in-place data
> >     analysis)
> 
> We could do splice in perf through an extension of the current ABI.
> The rest seems more about kernel internals.
> 
> => Abi breakage doesn't seem to be needed.
> 
> > - Compactness of traces
> >   - e.g. 96 bits per event (including typical 64-bit payload), no PID saved per
> >     event.
> 
> In perf we save the pid from two places:
> 
> - perf headers, see PERF_SAMPLE_TID
> - from the common fields of the trace events
> 
> Ftrace too for common fields.
> 
> It's useful to keep PERF_SAMPLE_TID for low overhead events (like
> perf little sampling). Otherwise we can certainly deduce the pid
> from context switch trace events.
> 
> But the pid in the trace event headers remains. We probably should
> get rid of that.
> 
> There are also the other common fields:
> 
> 	struct trace_entry {
> 		unsigned short		type;
> 
> 
> Type is needed by perf. If we have one buffer per event, we could
> retrieve which event we are dealing with. But if buffers are
> multiplexed per cpu, we need this.

Agreed, although 65536 types ID is probably overkill for the common case.
I prefer to go for approaches with a header that contains a smaller number of
bits, and use an extended header for those rare cases that need it.

> 	unsigned char		flags;
> 
> Useful for ftrace, not for perf which will be able to save regs
> soon.

Also useless for lttng.

> 	unsigned char		preempt_count;
> 
> 
> Dunno. Should be optional.

Ditto.

> 	int			pid;
> 
> 
> Kill!

Yep :)

> 
> 
> 	int			lock_depth;
> 
> 
> Killed ;)

Finally ;)

> };
> 
> 
> 
> => Abi breakage needed. Can be made through an ABI extension though, but
> wouldn't scale in the long term.

Yep, you'd have to support the two formats side-to-side for a while anyway. So
we can definitely call it a ABI breakage rather than extension.

> 
> > - Scalability to multi-core and multi-processor
> >   - Per-CPU buffers, time-stamp reading both scalable to many cpus *and* accurate
> 
> => Kernel internals

That's right. It's more in the trace-clock area. Let's keep this problem for
later, as we are focusing on the ABIs.

> > - Production-grace tracer reliability
> >   - Trace clock accuracy within 100ns, ordering can be inferred based on
> >     lock/interrupt handler knowledge, ability to know when ordering might be
> >     wrong.
> 
> => Seems to be kernel internals only. I may be missing your point though.

Yep, also trace-clock related. No effect on ABI.

> 
> 
> > - Flight recorder mode
> >   - Support concurrent read while writer is overwriting buffer data
> >     (Thomas Gleixner named these "trace-shots")
> 
> => Abi extension (overwriting mode)?

There were more details below on the impact of supporting flight recorder on the
trace format (using sub-buffers, etc). The ABI impact is more than just a flag,
although adding a flag is a good starting point. ;-)

> > - Support multiple trace sessions in parallel
> >   - Engineer + Operator + flight recorder for automated bug reports
> 
> => Doesn't seem to need ABI breakage.

This one could be done through ABI extension I guess.

> > - Availability of trace buffers for crash diagnosis
> >   - Save to disk, network, use kexec or persistent memory
> 
> Use splice for save to disk or network. But I don't understand the kexec
> thing.
> 
> => ABI extension (see splice)

This one is when the kernel is crashed. So there is not much still available,
certainly not splice(). :) The idea is to keep the trace buffers around in the
system after a OOPS (or hard lockup) so that they can be gathered later on.

> > - Heterogeneous environment support
> >   - Portability
> 
> What is missing?

Portable bitfields comes to my mind. And no, it's not enough to just reverse the
byte order across endianness.

> >   - Distinct host/target environment support
> 
> ditto.
> This works well for perf and ftrace currently. Have you
> a specific problem in mind?

The setup is that the traces are gathered on telecom switches, and brought to a
host machine for viewing. The user has to deal with traces gathered from various
kernel versions.

I did push Steven to support cross-endianness and self-describing types in
Ftrace in the past, and I have to admit that a large part of this requirement is
met, which is good.

> >   - Management of multiple target kernel versions
> 
> We all try to ensure backward compatibility. It only gets broken
> because of unwanted regressions or scheduled deprecation in the
> long term.
> 
> >   - No dependency on kernel image to analyze traces
> >     (traces contain complete information)
> 
> Trace format.

Yep, this one involves that the trace metadata (currently exported through
debugfs) should make its way along with the trace stream. One way to do it would
be to have a small separate buffer to transport the metadata.

> 
> > - Live view/analysis of trace streams via the network
> >   - Impact on buffer flushing, power saving, idle, ...
> 
> kernel internals

Being able to set the periodic timer flush impact the ABI (very slightly).

> 
> > - Synchronized system-wide (hypervisor, kernel and user-space) traces
> 
> kernel internals?

Yep. Mainly and largely has big impacts on trace clock implementation.

> > - Scalability of analysis tools to very large data sets (> 10GB)
> 
> => Userspace internals

There are ways to layout the trace data so that a userspace tool can dig through
it quickly. Therefore it impacts the trace format too.

> > - Standardization of trace format across analysis tools
> 
> Please detail.

I'm working for the Linux Foundation CELF group and Ericsson, with the
Multi-Core Association, to come up with a standardized trace format across
trace providers in the industry, so that we can use the same tools to analyze
traces taken from heterogeneous systems (hardware traces, OS traces, user-space
traces...).

Given the live analysis and low-overhead requirements, being able to generate
this trace format natively would be a great gain.

> > * Ring Buffer issues with Perf:
> > 
> > - Perf does not support flight recorder tracing (concurrent read/write)
> 
> Abi extension.

Nope, this one is an ABI breakage. The current mmap shared control head/tail
values used for synchronization between the kernel (writer) and user-space
(reader) does not allow concurrent read/write in flight recorder mode. We need,
at the very least, to call the kernel after we've finished reading a sub-buffer.

> >   - Sub-buffers are needed to support concurrent read/writes in flight recorder
> >     mode. Peter still has to convince me otherwise (if he cares).
> 
> ABI breakage needed

Yep.

> >   - Imply adding padding when an event does not fit in the current sub-buffer
> >     (ABI change). Note for Frederic: creating a single-subbuffer as large as the
> >     buffer does not solve this problem, because perf allows writing an event
> >     across the end of the buffer and its beginning. In a scheme where
> >     sub-buffers can be discarded, it makes it quite unreliable to try to figure
> >     out where partially overwritten events end.
> 
> Ok.
> 
> >   - Calling the kernel when finishing reading a sub-buffer is needed for flight
> >     recorder mode tracing. It is not possible with the mmap-head-tail-counter
> >     ABI Perf currently uses for reader-writer synchronization.
> 
> Why do you need to call the kernel for that?

Because we need to get exclusive access to the next sub-buffer (exchanging it
with the one we currently own). This operation is an atomic pointer CAS (or
exchange for ftrace), which should only be done by the kernel.

> > - Perf is 5 times slower than Ftrace/Generic Ring Buffer Library/LTTng.
> >   - Partially due to implementation.
> 
> Kernel internals
> 
> >   - Partially due to large event size.
> 
> (See my previous comments about pid and so).
> 
> > 
> > * Trace Format issues with Perf:
> > 
> > - Perf event headers are too large
> 
> You can select them independantly, except for trace events, for which
> I made comments before.
> 
> > - Handling of dynamically added instrumentation while trace is recorded is
> >   inexistent.
> 
> ???

This problem applies to both Ftrace and Perf. If you have the following
scenario:

1 - start tracing
2 - debugfs event descriptions are read
3 - load a module with tracepoints in it or add a dynamic kprobe
4 - hit the newly added events
5 - stop tracing

Then you end up being unable to parse the dynamically loaded information. That
is if the dynamically loaded instrumentation ends up being activated at all.

In a context where distributions load modules like KVM on demand, it does not
make sense to keep these events out of the trace just because they have been
dynamically loaded without the user knowledge. The problem is twofold here:

1 - we need to be able to specify which tracepoints are to be activated
independently of their location (kernel/modules) and of whether or not they
currently exist.

2 - we need to be able to append to the event list (metadata) while the trace is
being gathered.

> > 
> > * Ring Buffer issues with Ftrace:
> > 
> > - Ftrace needs an internal API cleanup.
> >   - "peek" is an unnecessary API duplication which complicates everything down
> >     to the buffer-level.
> 
> kernel internals

Yep.

> > - Ftrace does not support cross-pages event writes
> >   - Limits event size to less than 4kB
> 
> kernel internals?

Well, it all depends on how much the ftrace tools expect the sub-buffer size to
be 4kB.

> > * Trace Format issues with Ftrace:
> > 
> > - Ftrace timestamps are saved as delta from previous event
> >   - Only works for tracing where preemption can be disabled, unusable for
> >     user-space tracing.
> 
> What is this userspace tracing? Is this userspace tracing made in kernel
> space?
> 
> (tag me confused)

Nope, this is userspace tracing performed all in userspace. However, if we want
to share the same trace format, then we need to come up with a trace format that
is not inherently tied to a scheme where preemption can be disabled.

> >   - Creates an artificial data dependency between events, leading to odd
> >     side-effects when dealing with nesting over tracer
> 
> I wouldn't comment that, I'm not very experienced with the ring buffer
> 
> >     - 0 ns IRQ/SOFTIRQ handler duration side-effect
> 
> ditto.
> 
> If we need/want to cure that, then we need an:
> 
> => ABI breakage

Yep.

> > - Event size limited to one page
> 
> Perf too needs more (userspace stack dumps).

Yep.

> > - Ftrace event headers are still too large
> 
> 
> (described in the beginning)
> 
> 
> 
> > - Handling of dynamically added instrumentation while trace is recorded is
> >   inexistent.
> 
> I still don't understand this point
> 

Explained above.

> Now I'm too tired to sum up all the points that seem not to be
> solved through an ABI extension :)

Thanks for the feedback!

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
