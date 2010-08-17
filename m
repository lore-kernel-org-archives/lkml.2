Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab0HQXXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 19:23:37 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43558 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab0HQXXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 19:23:14 -0400
Message-Id: <20100817231619.277457797@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 17 Aug 2010 19:16:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [RFC PATCH 00/20] Generic Ring Buffer Library (v2)
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 17 Aug 2010 23:21:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements a generic ring buffer library, which provides a very
efficient, yet flexible, API to both tracers and drivers to move large amounts
of data within and outside of kernel-space.

It comes as a response to Linus mandate from the 2008 Kernel Summit. In May
2010, Steven Rostedt, author of the Ftrace ring buffer, came forward and asked
me if I could handle this task, which results in this patchset. In addition to
come up with a common ring buffer, this patchset takes into account the pressing
industry need for a blazingly fast, and reliable, ring buffer. Tracing, as we
know, is a very resource-hungry activity, which should be kept to small
percentage of system's resources in order to be useful on heavy workloads, which
are the most likely to reproduce bugs and performance problems.

It is derived from the LTTng ring buffer, heavily cleaned up and librarified to
become a generic kernel ring buffer. The flexibility provided by this library
does _not_ come at the expense of performance, because each library client
provides its own constant "configuration" structure passed along to each
fast-path inline function, therefore letting the compiler perform code selection
statically. The slow paths are shared amongst all clients, which allows overall
code size savings as the number of library clients increases.

Changelog since v1:
* Clean up "simple ring buffer API" following feedback received at LinuxCon.
* Allow read-side to take a snapshot of the buffers and walk sub-buffer in
  reverse, from newest to oldest (idea from Peter Zijlstra and Masami Hiramatsu)
* Allow a buffer snapshot to be read more than once (this should please Steven
  Rostedt). This could be used to implement ftrace ring buffer "peek" if needed.
* Rebase on kernel 2.6.36-rc1-tip


* History

As far back as May 2005, LTTng implemented its ring buffer from scratch,
learning lessons from K42, RelayFS and LTT. It became lock-less in October 2005.
It has been widely used by the industry and shipped with many embedded and
real-time distributions. Since then, Ftrace (2008, lock-less in 2009) and Perf
(2010) implemented their own ring buffer.

Ftrace ring buffer offers lock-less, per-cpu buffers, with good performance (at
least on x86, however Tim Bird reported that the amount of local_t operations on
the fast-path made did perform poorly on ARM). The main problems seen with this
ring buffer are linked with its complexity level, mainly caused by lack of
abstraction between the ring buffer format, locking, memory backend, and
time-stamping. Steven finally asked me to try coming forward with a generic ring
buffer in this post: http://lwn.net/Articles/389199/

Perf ring-buffer has lately seen some improvement regarding speed following
criticism from Steven and myself. Perf ring-buffer scheme was benchmarked by
Steven Rostedt, showing it was about 4 times slower than Ftrace and LTTng at
that point. Perf performance improved since then, but the monolithic nature
of its ring buffer, being inherently tied to the tracer, and the fact that it
does not implement a flight recorder mode required significant effort to come up
with numbers comparable with other ring buffers.

The state of the Perf ring buffer code is as we could expect from code having
being heavily modified in a short amount of time (a quick glance at the code
shows at least one clearly missing memory barrier in perf_output_put_handle() in
the 2.6.35-rc4-tip tree). The Perf user-space ABI comes as a pain point, as it
ties the ring buffer implementation to the control ABI exported to user-space
through a mmap'd page.  The user-space perf tool therefore interacts with the
kernel through reads and writes in a shared memory region without using system
calls.  This direct link between the kernel data structures and the user-space
ABI makes most abstractions impracticable and heavily constrains kernel-level
ring buffer design.


* Benchmarks

  * Throughput

These results shows the time it takes to write an entry to each ring buffer
implementation (generic library, Ftrace, Perf). The test is an adaptation of
kernel/trace/ring_buffer_benchmark.c, which stress-tests the ring buffer by
writing and reading data to/from it for 10 seconds.

  Setup:
  - Clock source:
    - trace_clock_local() for Generic Ring Buffer Library and Ftrace
    - perf_clock() for Perf
  - 1MB per-cpu buffers
  - 4 byte payload/event (contains the cpu id)
  - A single producer thread
  - On a Xeon 2.0GHz E5405, dual-socket, 4 cores/socket (8 cores total)
  - Using Ftrace ring_buffer_benchmark (adapted to the Ring Buffer Library)
    - producer_fifo=10
  - Kernel: 2.6.35-rc4-tip

    * Overwrite (flight-recorder) mode

Ring Buffer Library:       83 ns/entry (512kB sub-buffers, no reader)
                           84 ns/entry (128kB sub-buffers, no reader)
                           86 ns/entry (4kB sub-buffers,   no reader)
                           89 ns/entry (512kB sub-buffers: read 0.3M entries/s)
                          111 ns/entry (128kB sub-buffers: read 1.9M entries/s)
                          199 ns/entry (4kB sub-buffers:   read 4.8M entries/s)
   Reader wake-up: performed by per-cpu timer each 100ms.

Ftrace Ring Buffer:       103 ns/entry (no reader)
                          148 ns/entry (read by page:      read 6.6M entries/s)
                          187 ns/entry (read by event:     read 0.4M entries/s)
   Reader wake-up: each 100 events written (arbitrarily chosen by benchmark)

Perf record               (flight recorder mode unavailable)


    * Discard (producer-consumer) mode

Generic Ring Buffer Library:           (128kB sub-buffers: read 2.8M entries/s)

(in 10s)
Written:              28020143
Lost:                 28995757
Read:                 28017426

                           96 ns/entry discarded
                          257 ns/entry written

Perf record:
    (using patch from post http://lkml.org/lkml/2010/5/20/313)
# modprobe ring_buffer_benchmark producer_fifo=10 trace_event=1
# perf record -e rb_bench:rb_benchmark -c1 -a sleep 30

[ perf record: Woken up 169 times to write data ]
[ perf record: Captured and wrote 1623.336 MB perf.data (~70924640 samples) ]

# cat /debug/tracing/trace
   Note: output of the benchmark module is incorrect, because it does not take
into account events discarded by Perf.

Using the perf output approximation of 70924640 entries written in 30 seconds
leads to:
                         423 ns/entry (read: 2.3M entries/s)

Note that these numbers are based on the perf event approximation output (based
on a 24 bytes/entry estimation) rather than the benchmark module count due to
the inaccuracy discussed earlier.


  * Scalability

    * Generic Ring Buffer Library

I modified the ring buffer benchmark module for the "basic API" of the ring
buffer library (pre-built clients) to support multiple writer threads. The
following test uses 1MB per-cpu buffers (128kB sub-buffers) with local per-cpu
read iterators. It does not use any time-stamp; we notice that the numbers are
quite close to those of the throughput benchmark section above, meaning that the
extra overhead of the basic API compensates for the removal of
trace_clock_local() calls.

1 writer thread :  83 ns CPU time/record
2 writer threads: 116 ns CPU time/record
4 writer threads: 116 ns CPU time/record
8 writer threads: 118 ns CPU time/record

So basically the write-side scales almost linearly with the number of cores,
with the exception of L2 cache hits. This is because we are using 1MB per-core
buffers; we therefore hit the L2 cache shared amongst pairs of cores.

Saving a time-stamp taken with trace_clock() with each event (generic library
per-cpu buffers with support for channel-wide iterator) moves the scalability
drop point at 4 writer threads. The higher overhead and scalability change is
caused by the use of trace_clock() rather than trace_clock_local():

1 writer thread : 191 ns CPU time/record
2 writer threads: 189 ns CPU time/record
4 writer threads: 260 ns CPU time/record
8 writer threads: 265 ns CPU time/record


    * Ftrace

With a similar benchmark module, with time-stamps taken with
trace_clock_local(), Ftrace gives:

1 writer thread : 104 ns CPU time/record
2 writer threads: 165 ns CPU time/record
4 writer threads: 146 ns CPU time/record
8 writer threads: 153 ns CPU time/record


  * Formal Verification with Model-Checking

In addition to thorough testing, the Ring Buffer Library lock-less buffering
algorithm has been modeled and checked for races using the SPIN verifier on a
model detecting concurrent memory accesses in for all execution paths. This
model covers all the ring-buffer corner-cases. Note that this model assumes a
sequentially coherent machine; therefore memory barriers should be carefully
reviewed. I plan on enhancing this model with memory ordering awareness in the
future, but just did not have the time on my hand to tackle this task yet.

Even though it does not take away the risk of having discrepancy between the
implementation and the actual implementation and behavior on real hardware, this
additional level of formal verification provides a good level of confidence in
the ring buffer algorithm reliability.

Feedback is welcome,

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
