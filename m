Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0LGBPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 20:15:52 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49089 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0LGBPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 20:15:51 -0500
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record/report: Process events in order
From: Ian Munsie <imunsie@au1.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
In-reply-to: <alpine.LFD.2.00.1012061447080.2653@localhost6.localdomain6>
References: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6> <1291603026-11785-4-git-send-email-imunsie@au1.ibm.com> <alpine.LFD.2.00.1012061014180.2653@localhost6.localdomain6> <1291637998-sup-4601@au1.ibm.com> <alpine.LFD.2.00.1012061359140.2653@localhost6.localdomain6> <1291640985-sup-4443@au1.ibm.com> <alpine.LFD.2.00.1012061447080.2653@localhost6.localdomain6>
Date: Tue, 07 Dec 2010 12:15:45 +1100
Message-Id: <1291679635-sup-9860@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Excerpts from Thomas Gleixner's message of Tue Dec 07 01:41:22 +1100 2010:
> Does the patch below on top of my previous one work for you ?

Not quite. It does work on a patched kernel, but has some problems on
unpatched kernels and issues with perf report -D.

I set ordered_samples and ordering_requires_timestamps in perf report to
test this (I've included the changes below). Since you don't move the
dump_printfs like my patches, we can't set those flags unconditionally
in perf report, otherwise perf report -D would be completely broken.

That's OK, we can just set it conditionally on !dump_trace and report -D
will then always display events in file order. Personally I think it's
handy to see which order events are being processed in to track down why
samples aren't being attributed, but that's mostly important during
debugging the timestamp ordering, and perhaps not as useful otherwise.


>      case PERF_RECORD_HEADER_ATTR:
> -        return ops->attr(event, session);
> +        /* This updates session->sample_id_all */
> +        ret = ops->attr(event, session);
> +        if (ops->ordering_requires_timestamps &&
> +            ops->ordered_samples && !session->sample_id_all) {
> +            session->ordered_samples.next_flush = ULLONG_MAX;
> +            flush_sample_queue(session, ops);
> +            ops->ordered_samples = false;
> +        }

Makes sense. I did something similar in the report layer that I was
about to send when I saw this email, but this way we have a generic
solution for other parts of perf that might want this.
The problem here is that we only get the PERF_RECORD_HEADER_ATTR if perf
record has been piped somewhere, so running perf record <load>; perf
report on an unpatched kernel results in the COMM, MMAP, etc events
being processed last (timestamp -1ULL) and no userspace samples are
attributed at all:

$ ./perf report|cat
# Events: 1K cycles
#
# Overhead  Command  Shared Object                 Symbol
# ........  .......  .............  .....................
#
    99.42%  cachetest  [unknown]      [.] 0xf75e0ccb
     0.45%  cachetest  [kernel]       [k] page_fault
     0.06%  cachetest  [kernel]       [k] hpet_next_event
     0.06%  cachetest  [kernel]       [k] run_timer_softirq
     0.01%  cachetest  [kernel]       [k] flush_signal_handlers
     0.00%  cachetest  [kernel]       [k] native_write_msr_safe

> +    /*
> +     * For all non synthetized events we get the sample data

s/synthetized/synthesized/

> +    event__parse_sample(event, session, &sample);
> +    if (dump_trace)
> +        perf_session__print_tstamp(session, event, &sample);

Moving this here after the dump_printf("%#Lx [%#x]: PERF_RECORD_%s"...
changes the output of perf report -D in a bad way. Changing the spacing
in dump_printf can make up for it, or juggle the code around some more.


How do you want to proceed? At this point either version of the patches
are pretty functionally equivelant. Mine does the perf report -D
reordering as well, but that isn't really necessary to solve the bug.
Either way we only have a few minor fixups left.


If we want to use yours, here's my v3 patch respun on top of them to
enable ordering by timestamps in record & report:

>From 581eb3fbad176a83d1830a792174ff5087015897 Mon Sep 17 00:00:00 2001
From: Ian Munsie <imunsie@au1.ibm.com>
Date: Tue, 7 Dec 2010 10:20:44 +1100
Subject: [PATCH v3] perf record/report: Process events in order

This patch changes perf report to ask for the ID info on all events be
default if recording from multiple CPUs.

Perf report (without -D) will now process the events in order if the
kernel is able to provide timestamps on all events. This ensures that
events such as COMM and MMAP which are necessary to correctly interpret
samples are processed prior to those samples so that they are attributed
correctly.

Before:
 # perf record ./cachetest
 # perf report

 # Events: 6K cycles
 #
 # Overhead  Command      Shared Object                           Symbol
 # ........  .......  .................  ...............................
 #
     74.11%    :3259  [unknown]          [k] 0x4a6c
      1.50%  cachetest  ld-2.11.2.so       [.] 0x1777c
      1.46%    :3259  [kernel.kallsyms]  [k] .perf_event_mmap_ctx
      1.25%    :3259  [kernel.kallsyms]  [k] restore
      0.74%    :3259  [kernel.kallsyms]  [k] ._raw_spin_lock
      0.71%    :3259  [kernel.kallsyms]  [k] .filemap_fault
      0.66%    :3259  [kernel.kallsyms]  [k] .memset
      0.54%  cachetest  [kernel.kallsyms]  [k] .sha_transform
      0.54%    :3259  [kernel.kallsyms]  [k] .copy_4K_page
      0.54%    :3259  [kernel.kallsyms]  [k] .find_get_page
      0.52%    :3259  [kernel.kallsyms]  [k] .trace_hardirqs_off
      0.50%    :3259  [kernel.kallsyms]  [k] .__do_fault
<SNIP>

After:
 # perf report

 # Events: 6K cycles
 #
 # Overhead  Command      Shared Object                           Symbol
 # ........  .......  .................  ...............................
 #
     44.28%  cachetest  cachetest          [.] sumArrayNaive
     22.53%  cachetest  cachetest          [.] sumArrayOptimal
      6.59%  cachetest  ld-2.11.2.so       [.] 0x1777c
      2.13%  cachetest  [unknown]          [k] 0x340
      1.46%  cachetest  [kernel.kallsyms]  [k] .perf_event_mmap_ctx
      1.25%  cachetest  [kernel.kallsyms]  [k] restore
      0.74%  cachetest  [kernel.kallsyms]  [k] ._raw_spin_lock
      0.71%  cachetest  [kernel.kallsyms]  [k] .filemap_fault
      0.66%  cachetest  [kernel.kallsyms]  [k] .memset
      0.54%  cachetest  [kernel.kallsyms]  [k] .copy_4K_page
      0.54%  cachetest  [kernel.kallsyms]  [k] .find_get_page
      0.54%  cachetest  [kernel.kallsyms]  [k] .sha_transform
      0.52%  cachetest  [kernel.kallsyms]  [k] .trace_hardirqs_off
      0.50%  cachetest  [kernel.kallsyms]  [k] .__do_fault
<SNIP>

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/builtin-record.c |    5 ++++-
 tools/perf/builtin-report.c |    5 +++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 699dd21..310dd21 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -285,7 +285,7 @@ static void create_counter(int counter, int cpu)
 	if (system_wide)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
-	if (sample_time)
+	if (sample_time || system_wide || !no_inherit || cpu_list)
 		attr->sample_type	|= PERF_SAMPLE_TIME;
 
 	if (raw_samples) {
@@ -327,6 +327,9 @@ try_again:
 				 * Old kernel, no attr->sample_id_type_all field
 				 */
 				sample_id_all_avail = false;
+				if (!sample_time && !raw_samples)
+					attr->sample_type &= ~PERF_SAMPLE_TIME;
+
 				goto retry_sample_id;
 			}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 904519f..d1ad782 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -244,6 +244,8 @@ static struct perf_event_ops event_ops = {
 	.event_type = event__process_event_type,
 	.tracing_data = event__process_tracing_data,
 	.build_id = event__process_build_id,
+	/* { .ordered_samples && !dump_trace } */
+	/* { .ordering_requires_timestamps && !dump_trace } */
 };
 
 extern volatile int session_done;
@@ -319,6 +321,9 @@ static int __cmd_report(void)
 	if (ret)
 		goto out_delete;
 
+	event_ops.ordered_samples = event_ops.ordering_requires_timestamps =
+		!dump_trace;
+
 	ret = perf_session__process_events(session, &event_ops);
 	if (ret)
 		goto out_delete;
-- 
1.7.2.3
