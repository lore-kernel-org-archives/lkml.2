Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0KJUXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:23:23 -0500
Received: from mail.openrapids.net ([64.15.138.104]:60295 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756281Ab0KJUXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:23:21 -0500
Date: Wed, 10 Nov 2010 15:23:16 -0500
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
Message-ID: <20101110202316.GA32396@Krystal>
References: <1289400056.12418.139.camel@gandalf.stny.rr.com> <1289400234.2191.129.camel@laptop> <1289401781.12418.145.camel@gandalf.stny.rr.com> <1289403019.2084.17.camel@laptop> <20101110174852.GB4001@elte.hu> <1289412329.12418.177.camel@gandalf.stny.rr.com> <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu> <1289415645.12418.180.camel@gandalf.stny.rr.com> <20101110191127.GA6190@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110191127.GA6190@nowhere>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:33:01 up 48 days, 23:35,  5 users,  load average: 0.05, 0.11,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Wed, Nov 10, 2010 at 02:00:45PM -0500, Steven Rostedt wrote:
> > On Wed, 2010-11-10 at 19:41 +0100, Ingo Molnar wrote:
> > 
> > > We'll need to embark on this incremental path instead of a rewrite-the-world thing. 
> > > As a maintainer my task is to say 'no' to rewrite-the-world approaches - and we can 
> > > and will do better here.
> > 
> > Thus you are saying that we stick to the status quo, and also ignore the
> > fact that perf was a rewrite-the-world from ftrace to begin with.
> 
> Perhaps you and Mathieu can summarize your requirements here and then explain
> why extending the current ABI wouldn't work. It's quite normal that people
> try to find a solution fully backward compatible in the first place. If
> it's not possible, fine, but then justify it.

Sure, here are the requirements my user-base have, followed by a listing of Perf
and Ftrace pain points, some of which are directly derived from their respective
ABIs, others partially caused by their implementation and partially caused by
their ABI.

- Low overhead is key
  - 150 ns per event (cache-hot)
  - Zero-copy (splice to disk/network, mmap for zero-copy in-place data
    analysis)
- Compactness of traces
  - e.g. 96 bits per event (including typical 64-bit payload), no PID saved per
    event.
- Scalability to multi-core and multi-processor
  - Per-CPU buffers, time-stamp reading both scalable to many cpus *and* accurate
- Production-grace tracer reliability
  - Trace clock accuracy within 100ns, ordering can be inferred based on
    lock/interrupt handler knowledge, ability to know when ordering might be
    wrong.
- Flight recorder mode
  - Support concurrent read while writer is overwriting buffer data
    (Thomas Gleixner named these "trace-shots")
- Support multiple trace sessions in parallel
  - Engineer + Operator + flight recorder for automated bug reports
- Availability of trace buffers for crash diagnosis
  - Save to disk, network, use kexec or persistent memory
- Heterogeneous environment support
  - Portability
  - Distinct host/target environment support
  - Management of multiple target kernel versions
  - No dependency on kernel image to analyze traces
    (traces contain complete information)
- Live view/analysis of trace streams via the network
  - Impact on buffer flushing, power saving, idle, ...
- Synchronized system-wide (hypervisor, kernel and user-space) traces
- Scalability of analysis tools to very large data sets (> 10GB)
- Standardization of trace format across analysis tools


* Ring Buffer issues with Perf:

- Perf does not support flight recorder tracing (concurrent read/write)
  - Sub-buffers are needed to support concurrent read/writes in flight recorder
    mode. Peter still has to convince me otherwise (if he cares).
  - Imply adding padding when an event does not fit in the current sub-buffer
    (ABI change). Note for Frederic: creating a single-subbuffer as large as the
    buffer does not solve this problem, because perf allows writing an event
    across the end of the buffer and its beginning. In a scheme where
    sub-buffers can be discarded, it makes it quite unreliable to try to figure
    out where partially overwritten events end.
  - Calling the kernel when finishing reading a sub-buffer is needed for flight
    recorder mode tracing. It is not possible with the mmap-head-tail-counter
    ABI Perf currently uses for reader-writer synchronization.
- Perf is 5 times slower than Ftrace/Generic Ring Buffer Library/LTTng.
  - Partially due to implementation.
  - Partially due to large event size.

* Trace Format issues with Perf:

- Perf event headers are too large
- Handling of dynamically added instrumentation while trace is recorded is
  inexistent.


* Ring Buffer issues with Ftrace:

- Ftrace needs an internal API cleanup.
  - "peek" is an unnecessary API duplication which complicates everything down
    to the buffer-level.
- Ftrace does not support cross-pages event writes
  - Limits event size to less than 4kB

* Trace Format issues with Ftrace:

- Ftrace timestamps are saved as delta from previous event
  - Only works for tracing where preemption can be disabled, unusable for
    user-space tracing.
  - Creates an artificial data dependency between events, leading to odd
    side-effects when dealing with nesting over tracer
    - 0 ns IRQ/SOFTIRQ handler duration side-effect
- Event size limited to one page
- Ftrace event headers are still too large
- Handling of dynamically added instrumentation while trace is recorded is
  inexistent.

So given that fixing these issues requires a large ABI rework of both Ftrace and
Perf, creating a new ABI rather than building on top of an ABI not initially
designed to meet these requirements seems to really make sense here.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
