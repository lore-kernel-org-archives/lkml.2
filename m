Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046Ab0J1SZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:25:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10271 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965Ab0J1SZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:25:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=nfGOlHxYhnplVxRu8wkw4fr4E47T47tzdxUtILamUG9N4aOC06McE75O1nobPt25/2
         6xtk7JIP3rlYevdu/Jdg==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Dw-dxkUgYLZYBKb5sGYcdGcpS0OH_fEHW51Jr@mail.gmail.com>
References: <AANLkTim8c+FLo11XJbTmTjiuucn-9UJD0Vui=fvUgCd+@mail.gmail.com>
 <AANLkTikd6sawwJeBm76QLeowXj0GBAf=wpRVgG8x5MOp@mail.gmail.com> <AANLkTi=Dw-dxkUgYLZYBKb5sGYcdGcpS0OH_fEHW51Jr@mail.gmail.com>
From: David Sharp <dhsharp@google.com>
Date: Thu, 28 Oct 2010 11:20:06 -0700
Message-ID: <AANLkTi=6EBZeZ+56z_wbDuU1xTmC0saSTMDmqbqDS4Jr@mail.gmail.com>
Subject: Benchmarks of kernel tracing options (ftrace, ktrace, lttng and perf)
To: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

I now have some benchmark results for two more tracers, lttng and
perf. Thanks to Mathieu for helping me with the lttng test.

To restate our objectives:
> Google uses kernel tracing aggressively in the its data centers. We
> wrote our own kernel tracer, ktrace. However ftrace, perf and LTTng
> all have a better feature set than ktrace, so we are abandoning that
> code.
>
> We see several implementations of tracing aimed at the mainline kernel
> and wanted a fair comparison of each of them to make sure they will
> not significantly impact performance. A tracing toolkit that is too
> expensive is not usable in our environment.
>
> So we are sending out some benchmark results to compare the three
> tracing subsystems we know of. In addition we included numbers for
> ktrace, and a git tree for the source.
>
> The benchmark used is rather synthetic, and aims to measure the
> overhead of entering the kernel with a tracepoint enabled. It measures
> the time to call getuid() 100,000 times, and returns the average time
> per call. To infer the overhead of tracing, the benchmark is run with
> tracing off, and with tracing on. The tracer is given a
> generously-sized ring buffer so that overflows do not occur (no reader
> is present). The "off" run essentially measures the cost of a ring
> switch, as sys_getuid() is practically a nop syscall. Subtracting the
> "off" result from the "on" result indicates the average amount of time
> it takes to add a small item to the tracing ring buffer.

I hope this produces a fair comparison. I've detailed my steps below
for all of the tracers in case there are improvements to be made.

This is the code used for the getuid microbenchmark:
http://autotest.kernel.org/browser/trunk/client/tests/tracing_microbenchmark/src/getuid_microbench.c

The numbers below are the "on" minus "off" average results over at
least 10 runs each.

Results for amount of time to execute a tracepoint (includes previous results):
ktrace: 200ns   (old)
ftrace: 224ns   (old, w/ handcoded tracepoint, not syscall tracing)
lttng: 449ns    (new)
perf: 1047ns    (new)

Also interesting:
ftrace: 587ns   (old, w/ syscall tracing)
This just shows that syscall tracing is much slower than a normal tracepoint.


The rest of this email is a lot of details about the benchmark runs
for each tracer.

I look forward to your feedback.

Thanks,
David Sharp



Here are the details of the steps for the two new results (lttng,
perf) first, and then some repeated details of the previous ftrace and
ktrace results.

LTTng
-----

I use lttng in flight-recorder mode to avoid the overhead of a reader
while tracing.

The benchmark was run with these versions:
- lttng kernel 0.233 based on v.2.6.36
 + the sys_getuid tracepoint patch [0]
- ltt-modules v0.19.1
 + a probe for sys_getuid [1]
- ltt-control v0.88

I ran the benchmark like this:

#setup:
modprobe ltt-trace-control
modprobe syscall-trace
/sys/kernel/debug/ltt/markers/kernel/sys_getuid/enable
#run:
for n in $(seq 10) ; do \
 lttctl -C -w $PWD/$n \
   -o channel.all.bufsize=$((8*1024*1024)) \
   -o channel.all.overwrite=1 trace1 && \
 getuid_microbench 100000 >> results.traced && \
 lttctl -D -w $PWD/$n trace1 ; \
done
for n in $(seq 10) ; do \
 getuid_microbench 100000 >> results.notrace ; \
done

Perf
----

This was run with a vanilla v2.6.36 kernel plus the sys_getuid
tracepoint patch, and perf 0.0.2. I used a large number of pages and
observed that perf reported it woke up only once to write data. I'm
assuming that it woke up at the end, so it was out of the way during
the tracing.

for n in $(seq 10) ; do \
 perf record -e timer:sys_getuid -a -m 4096 -- \
 getuid_microbench 100000 >> results.perf ; \
done
for n in $(seq 10) ; \
 do getuid_microbench 100000 >> results.notrace ; \
done


ftrace
------

ftrace and ktrace benchmarks were run using Autotest. The commands
below approximate what the autotest does. The Autotest test itself is
here:
http://autotest.kernel.org/browser/trunk/client/tests/tracing_microbenchmark

#setup:
tracedir="/sys/kernel/debug/tracing"
echo '$((8*1024)) > $tracedir/buffer_size_kb
echo '1' > $tracedir/events/timer/sys_getuid/enable
#run:
for n in $(seq 10) ; do \
 echo '1' > $tracing/tracing_enabled && \
 getuid_microbench 100000 >> results.ftrace && \
 echo '0' > $tracing/tracing_enabled && \
 echo > $tracing/trace ; \
done
for n in $(seq 10) ; do \
 getuid_microbench 100000 >> results.notrace && \
done

ktrace
------

> Some background on Ktrace: Ktrace uses the same ringbuffer as ftrace,
> but has much fewer frontend features (filtering, formatted output
> file). Trace events are always packed. ktrace has an mmap interface to
> the per-cpu ring buffers instead of splice()  (the merits of these two
> options have yet to be evaluated).
>
> In order to test ktrace fairly, I forward ported it v2.6.36-r7. I also
> made some minor changes to ftrace that don't significantly affect the
> benchmark.
>
> The tree with ktrace and the changes mentioned above is available here:
>
>        git://google3-2.osuosl.org/kernel/tracing/ktrace.git  ktrace-forwardport

I didn't push the ktrace tracer to the public kernel.org Autotest, but
it is quite similar to the ftrace tracer. Once again, I'll approximate
it with shell commands:

#setup:
tracedir="/sys/kernel/debug/ktrace"
echo '$((8*1024*1024)) > $tracedir/bufsize
echo '1' > $tracedir/events/kernel_getuid
#run:
for n in $(seq 10) ; do \
 echo '1' > $tracing/enabled && \
 getuid_microbench 100000 >> results.ftrace && \
 echo '0' > $tracing/enabled && \
 echo '1' > $tracing/reset ; \
done
for n in $(seq 10) ; do \
 getuid_microbench 100000 >> results.notrace && \
done


Footnotes
---------
[0] sys_getuid tracepoint:
http://google3-2.osuosl.org/?p=kernel/tracing/ktrace.git;a=commitdiff;h=872088a6e482ce0288d8fe9f02726df82173de0e

[1] sys_getuid ltt probe, diff against ltt-module v0.19.1 (forgive
gmail's patch mangling):
diff --git a/probes/syscall-trace.c b/probes/syscall-trace.c
index 9ae419f..1409a74 100644
--- a/probes/syscall-trace.c
+++ b/probes/syscall-trace.c
@@ -49,6 +49,20 @@ notrace void probe_syscall_exit(void *_data, long ret)
               &ret, sizeof(ret), sizeof(ret));
 }

+void probe_getuid(void *_data, uid_t uid);
+
+DEFINE_MARKER_TP(kernel, sys_getuid, sys_getuid,
+       probe_getuid, "uid %d");
+
+notrace void probe_getuid(void *_data, uid_t uid)
+{
+       struct marker *marker;
+
+       marker = &GET_MARKER(kernel, sys_getuid);
+       ltt_specialized_trace(marker, marker->single.probe_private,
+               &uid, sizeof(uid), sizeof(uid));
+}
+
 MODULE_LICENSE("GPL and additional rights");
 MODULE_AUTHOR("Mathieu Desnoyers");
 MODULE_DESCRIPTION("syscall Tracepoint Probes");
--
1.7.1
