Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0JMXTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 19:19:36 -0400
Received: from smtp-out.google.com ([74.125.121.35]:17465 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab0JMXTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 19:19:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=EdYh01vu621K8sudUU8kT6NHKpJCRvQjOMXlRC1EqOZVHN6B2uYkqwEryZz2RNjPEE
         /LrbXH38+jPIga64ajgQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTikKwx6okpX4pxVzTvrVNm=KhUvLQGs0_ziwo6fX@mail.gmail.com>
References: <AANLkTikfYy-kYb1=KbsYwHd0_vcf20d2nPSfFynugz8z@mail.gmail.com> <AANLkTikKwx6okpX4pxVzTvrVNm=KhUvLQGs0_ziwo6fX@mail.gmail.com>
From: David Sharp <dhsharp@google.com>
Date: Wed, 13 Oct 2010 16:19:10 -0700
Message-ID: <AANLkTimnjun98phJ_KmwFG_ce3YGpmVGf5rufqPStWR-@mail.gmail.com>
Subject: Benchmarks of kernel tracing options (ftrace and ktrace)
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Google uses kernel tracing aggressively in the its data centers. We
wrote our own kernel tracer, ktrace. However ftrace, perf and LTTng
all have a better feature set than ktrace, so we are abandoning that
code.

We see several implementations of tracing aimed at the mainline kernel
and wanted a fair comparison of each of them to make sure they will
not significantly impact performance. A tracing toolkit that is too
expensive is not usable in our environment.

So we are sending out some benchmark results to compare the three
tracing subsystems we know of. In addition we included numbers for
ktrace, and a git tree for the source.

Some background on Ktrace: Ktrace uses the same ringbuffer as ftrace,
but has much fewer frontend features (filtering, formatted output
file). Trace events are always packed. ktrace has an mmap interface to
the per-cpu ring buffers instead of splice()  (the merits of these two
options have yet to be evaluated).

In order to test ktrace fairly, I forward ported it v2.6.36.r7. I also
made some minor changes to ftrace that don't significantly affect the
benchmark.

The tree with ktrace and the changes mentioned above is available here:

       git://google3-2.osuosl.org/kernel/tracing/ktrace.git  ktrace-forwardport

The benchmark used is rather synthetic, and aims to measure the
overhead of entering the kernel with a tracepoint enabled. It measures
the time to call getuid() 100,000 times, and returns the average time
per call. To infer the overhead of tracing, the benchmark is run with
tracing off, and with tracing on. The tracer is given a
generously-sized ring buffer so that overflows do not occur (no reader
is present). The "off" run essentially measures the cost of a ring
switch, as sys_getuid() is practically a nop syscall. Subtracting the
"off" result from the "on" result indicates the average amount of time
it takes to add a small item to the tracing ring buffer.

I wrote the benchmark as an Autotest test, so you can see the actual
code for yourself:
http://autotest.kernel.org/browser/trunk/client/tests/tracing_microbenchmark


This first set of benchmark results compares ftrace to ktrace. The
numbers below are the "on" result minus the "off" result for each
configuration.

ktrace: 200ns  (tracepoint: kernel_getuid)
ftrace: 224ns   (tracepoint: timer:sys_getuid)
ftrace: 587ns   (tracepoint: syscalls:sys_enter_getuid)

The "off" result for all configurations was about 231ns. I believe
that to be a meaningless number wrt this benchmark, however.

The "kernel_getuid" (ktrace) and "timer:sys_getuid" (ftrace)
tracepoints are normal tracepoints added to the body of sys_getuid.
syscalls:sys_enter_getuid is the existing syscall tracing event.

The first two results show that ftrace is about 12% slower than ktrace
at adding events to the ring buffer.

The last result shows that the syscall tracing is about twice as
expensive as a normal tracepoint, which is interesting.


Similar benchmarks for lttng and perf_events are coming. Expect at
least one of those by next week.

Thanks,
David Sharp
