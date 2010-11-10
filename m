Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab0KJVan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:30:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64067 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab0KJVam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:30:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L4YLkKnaDAAMr+CNP71gEU9pKiisXGIKGR4bm3C7j/ZhVkRkV4myaAOB4BWS+jVNwe
         R+BdlCvKXb00akTY5GQ8k7FUHrnF3LdGptrvyLU/1qUFEpc3rbPnkzbKeEPnt29jDQz9
         JDQT2CsL+KTp1Sq00vRbPznQOJi7piiGzPfyg=
Date: Wed, 10 Nov 2010 22:30:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
	reporting)
Message-ID: <20101110213033.GA7682@nowhere>
References: <1289400234.2191.129.camel@laptop> <1289401781.12418.145.camel@gandalf.stny.rr.com> <1289403019.2084.17.camel@laptop> <20101110174852.GB4001@elte.hu> <1289412329.12418.177.camel@gandalf.stny.rr.com> <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu> <1289415645.12418.180.camel@gandalf.stny.rr.com> <20101110191127.GA6190@nowhere> <20101110202316.GA32396@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110202316.GA32396@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 03:23:16PM -0500, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > On Wed, Nov 10, 2010 at 02:00:45PM -0500, Steven Rostedt wrote:
> > > On Wed, 2010-11-10 at 19:41 +0100, Ingo Molnar wrote:
> > > 
> > > > We'll need to embark on this incremental path instead of a rewrite-the-world thing. 
> > > > As a maintainer my task is to say 'no' to rewrite-the-world approaches - and we can 
> > > > and will do better here.
> > > 
> > > Thus you are saying that we stick to the status quo, and also ignore the
> > > fact that perf was a rewrite-the-world from ftrace to begin with.
> > 
> > Perhaps you and Mathieu can summarize your requirements here and then explain
> > why extending the current ABI wouldn't work. It's quite normal that people
> > try to find a solution fully backward compatible in the first place. If
> > it's not possible, fine, but then justify it.
> 
> Sure, here are the requirements my user-base have, followed by a listing of Perf
> and Ftrace pain points, some of which are directly derived from their respective
> ABIs, others partially caused by their implementation and partially caused by
> their ABI.



Yeah, but the main point here is to explain why/how reaching those goals is not
efficiently possible through an extension of the current ABI, in practice.

I'm going to try for some of them. Note when I'll talk about ABI breakage,
it actually means: create a new ABI and support the old one, schedule its
deprecation in the long term.

Here we go:


> 
> - Low overhead is key
>   - 150 ns per event (cache-hot)
>   - Zero-copy (splice to disk/network, mmap for zero-copy in-place data
>     analysis)



We could do splice in perf through an extension of the current ABI.
The rest seems more about kernel internals.

=> Abi breakage doesn't seem to be needed.



> - Compactness of traces
>   - e.g. 96 bits per event (including typical 64-bit payload), no PID saved per
>     event.


In perf we save the pid from two places:

- perf headers, see PERF_SAMPLE_TID
- from the common fields of the trace events

Ftrace too for common fields.

It's useful to keep PERF_SAMPLE_TID for low overhead events (like
perf little sampling). Otherwise we can certainly deduce the pid
from context switch trace events.

But the pid in the trace event headers remains. We probably should
get rid of that.

There are also the other common fields:

	struct trace_entry {
		unsigned short		type;


Type is needed by perf. If we have one buffer per event, we could
retrieve which event we are dealing with. But if buffers are
multiplexed per cpu, we need this.


	unsigned char		flags;


Useful for ftrace, not for perf which will be able to save regs
soon.


	unsigned char		preempt_count;


Dunno. Should be optional.


	int			pid;


Kill!


	int			lock_depth;


Killed ;)


};



=> Abi breakage needed. Can be made through an ABI extension though, but
wouldn't scale in the long term.




> - Scalability to multi-core and multi-processor
>   - Per-CPU buffers, time-stamp reading both scalable to many cpus *and* accurate



=> Kernel internals




> - Production-grace tracer reliability
>   - Trace clock accuracy within 100ns, ordering can be inferred based on
>     lock/interrupt handler knowledge, ability to know when ordering might be
>     wrong.



=> Seems to be kernel internals only. I may be missing your point though.




> - Flight recorder mode
>   - Support concurrent read while writer is overwriting buffer data
>     (Thomas Gleixner named these "trace-shots")



=> Abi extension (overwriting mode)?




> - Support multiple trace sessions in parallel
>   - Engineer + Operator + flight recorder for automated bug reports



=> Doesn't seem to need ABI breakage.



> - Availability of trace buffers for crash diagnosis
>   - Save to disk, network, use kexec or persistent memory



Use splice for save to disk or network. But I don't understand the kexec
thing.

=> ABI extension (see splice)



> - Heterogeneous environment support
>   - Portability



What is missing?



>   - Distinct host/target environment support



ditto.
This works well for perf and ftrace currently. Have you
a specific problem in mind?



>   - Management of multiple target kernel versions


We all try to ensure backward compatibility. It only gets broken
because of unwanted regressions or scheduled deprecation in the
long term.


>   - No dependency on kernel image to analyze traces
>     (traces contain complete information)



Trace format.



> - Live view/analysis of trace streams via the network
>   - Impact on buffer flushing, power saving, idle, ...


kernel internals



> - Synchronized system-wide (hypervisor, kernel and user-space) traces



kernel internals?



> - Scalability of analysis tools to very large data sets (> 10GB)



=> Userspace internals



> - Standardization of trace format across analysis tools



Please detail.



> 
> * Ring Buffer issues with Perf:
> 
> - Perf does not support flight recorder tracing (concurrent read/write)



Abi extension.



>   - Sub-buffers are needed to support concurrent read/writes in flight recorder
>     mode. Peter still has to convince me otherwise (if he cares).



ABI breakage needed


>   - Imply adding padding when an event does not fit in the current sub-buffer
>     (ABI change). Note for Frederic: creating a single-subbuffer as large as the
>     buffer does not solve this problem, because perf allows writing an event
>     across the end of the buffer and its beginning. In a scheme where
>     sub-buffers can be discarded, it makes it quite unreliable to try to figure
>     out where partially overwritten events end.



Ok.




>   - Calling the kernel when finishing reading a sub-buffer is needed for flight
>     recorder mode tracing. It is not possible with the mmap-head-tail-counter
>     ABI Perf currently uses for reader-writer synchronization.



Why do you need to call the kernel for that?



> - Perf is 5 times slower than Ftrace/Generic Ring Buffer Library/LTTng.
>   - Partially due to implementation.


Kernel internals



>   - Partially due to large event size.



(See my previous comments about pid and so).



> 
> * Trace Format issues with Perf:
> 
> - Perf event headers are too large



You can select them independantly, except for trace events, for which
I made comments before.



> - Handling of dynamically added instrumentation while trace is recorded is
>   inexistent.



???



> 
> 
> * Ring Buffer issues with Ftrace:
> 
> - Ftrace needs an internal API cleanup.
>   - "peek" is an unnecessary API duplication which complicates everything down
>     to the buffer-level.



kernel internals



> - Ftrace does not support cross-pages event writes
>   - Limits event size to less than 4kB


kernel internals?




> * Trace Format issues with Ftrace:
> 
> - Ftrace timestamps are saved as delta from previous event
>   - Only works for tracing where preemption can be disabled, unusable for
>     user-space tracing.



What is this userspace tracing? Is this userspace tracing made in kernel
space?

(tag me confused)



>   - Creates an artificial data dependency between events, leading to odd
>     side-effects when dealing with nesting over tracer



I wouldn't comment that, I'm not very experienced with the ring buffer



>     - 0 ns IRQ/SOFTIRQ handler duration side-effect



ditto.

If we need/want to cure that, then we need an:

=> ABI breakage



> - Event size limited to one page



Perf too needs more (userspace stack dumps).



> - Ftrace event headers are still too large


(described in the beginning)



> - Handling of dynamically added instrumentation while trace is recorded is
>   inexistent.




I still don't understand this point


Now I'm too tired to sum up all the points that seem not to be
solved through an ABI extension :)

