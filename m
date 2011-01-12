Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab1ALJ3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 04:29:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:43895 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab1ALJ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 04:29:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=nBGJ8zIkd7k/WjTYcw2SurUXG9221h/qnAaifT0hSYk3kBLVZAECfr1jXwru+TEDs+
         rbBpsFWyep6t937Wz7dw==
MIME-Version: 1.0
Date: Wed, 12 Jan 2011 10:29:05 +0100
Message-ID: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
Subject: [BUG] perf sched broken
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to use perf sched from tip-x86 but it fails for all my attempts.

First of, I think the event list is stale. This is not so much the
events themselves
but rather the flags.

Looks to me like the :r modifier is not supported anymore, so a patch like the
one below is needed. That helps collect a trace. But then, you can dump
the trace.

$ perf sched rec dd if=/dev/zero of=/dev/null count=1000000
1000000+0 records in
1000000+0 records out
512000000 bytes (512 MB) copied, 0.589981 s, 868 MB/s
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.481 MB perf.data (~20997 samples) ]

$ perf sched rep
run measurement overhead: 2934 nsecs
sleep measurement overhead: 90502 nsecs
the run test took 999149 nsecs
the sleep test took 1092248 nsecs
  Fatal: no trace data in the file

$ perf sched trace -D
 usage: perf sched [<options>] {record|latency|map|replay|trace}

    -i, --input <file>    input file name
    -v, --verbose         be more verbose (show symbol address, etc)
    -D, --dump-raw-trace  dump raw trace in ASCII

Note that this is not specific to pref sched. If I use perf record directly,
I run into the same issue:
$ perf record -R -a -c 1 -e sched:sched_switch -- sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.365 MB perf.data (~15962 samples) ]
$./perf report -D
  Fatal: no trace data in the file

Now that perf trace is gone, how to I dump the trace?


Drop :r modifier for tracepoints

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index abd4b84..29e7ffd 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1843,15 +1843,15 @@ static const char *record_args[] = {
        "-f",
        "-m", "1024",
        "-c", "1",
-       "-e", "sched:sched_switch:r",
-       "-e", "sched:sched_stat_wait:r",
-       "-e", "sched:sched_stat_sleep:r",
-       "-e", "sched:sched_stat_iowait:r",
-       "-e", "sched:sched_stat_runtime:r",
-       "-e", "sched:sched_process_exit:r",
-       "-e", "sched:sched_process_fork:r",
-       "-e", "sched:sched_wakeup:r",
-       "-e", "sched:sched_migrate_task:r",
+       "-e", "sched:sched_switch",
+       "-e", "sched:sched_stat_wait",
+       "-e", "sched:sched_stat_sleep",
+       "-e", "sched:sched_stat_iowait",
+       "-e", "sched:sched_stat_runtime",
+       "-e", "sched:sched_process_exit",
+       "-e", "sched:sched_process_fork",
+       "-e", "sched:sched_wakeup",
+       "-e", "sched:sched_migrate_task",
 };
