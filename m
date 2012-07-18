Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab2GRRLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:11:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44953 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab2GRRLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:11:04 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 1/3] perf tools: Fix trace events storms due to weight demux
Date: Wed, 18 Jul 2012 19:10:54 +0200
Message-Id: <1342631456-7233-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace events have a period (weight) of 1 by default. This can
be overriden on events definition by using the __perf_count()
macro.

For example, the sched_stat_runtime() is weighted with the runtime
of the task that fired the event.

By default, perf handles such weighted event by dividing it into
individual events carrying a weight of 1. For example if
sched_stat_runtime is fired and the task has run 5000000 nsecs,
perf divides it into 5000000 events in the buffer.

This behaviour makes weighted events unusable because they quickly
fullfill the buffers and we lose most events.

commit 5d81e5cfb37a174e8ddc0413e2e70cdf05807ace
("events: Don't divide events if it has field period") solves this
problem by sending only one event when PERF_SAMPLE_PERIOD flag
is set. The weight is carried in the sample itself such that we don't
need to demultiplex it anymore.

This patch provides the last missing piece to use this feature by setting
PERF_SAMPLE_PERIOD from perf tools when we deal with trace events.

Before:
	$ ./perf record -e sched:* -a sleep 1
	[ perf record: Woken up 3 times to write data ]
	[ perf record: Captured and wrote 1.619 MB perf.data (~70749 samples) ]
	Warning:
	Processed 16909 events and lost 1 chunks!

	Check IO/CPU overload!

	$ ./perf script
	perf  1894 [003]   824.898327: sched_migrate_task: comm=perf pid=1898 prio=120 orig_cpu=2 dest_cpu=0
	perf  1894 [003]   824.898335: sched_stat_sleep: comm=perf pid=1898 delay=113179500 [ns]
	perf  1894 [003]   824.898336: sched_stat_sleep: comm=perf pid=1898 delay=113179500 [ns]
	perf  1894 [003]   824.898337: sched_stat_sleep: comm=perf pid=1898 delay=113179500 [ns]
	perf  1894 [003]   824.898338: sched_stat_sleep: comm=perf pid=1898 delay=113179500 [ns]
	perf  1894 [003]   824.898339: sched_stat_sleep: comm=perf pid=1898 delay=113179500 [ns]
	perf  1894 [003]   824.898340: sched_stat_sleep: comm=perf pid=1898 delay=113179500 [ns]
	perf  1894 [003]   824.898341: sched_stat_sleep: comm=perf pid=1898 delay=113179500 [ns]
	[...]

After:
	$ ./perf record -e sched:* -a sleep 1
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.074 MB perf.data (~3228 samples) ]

	$ ./perf script

	perf  1461 [000]   554.286957: sched_migrate_task: comm=perf pid=1465 prio=120 orig_cpu=3 dest_cpu=1
	perf  1461 [000]   554.286964: sched_stat_sleep: comm=perf pid=1465 delay=133047190 [ns]
	perf  1461 [000]   554.286967: sched_wakeup: comm=perf pid=1465 prio=120 success=1 target_cpu=001
	swapper     0 [001]   554.286976: sched_stat_wait: comm=perf pid=1465 delay=0 [ns]
	swapper     0 [001]   554.286983: sched_switch: prev_comm=swapper/1 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=perf
	[...]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/util/evlist.c       |    2 +-
 tools/perf/util/parse-events.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f74e956..3edfd34 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -214,7 +214,7 @@ int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
 		attrs[i].type	       = PERF_TYPE_TRACEPOINT;
 		attrs[i].config	       = err;
 	        attrs[i].sample_type   = (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME |
-					  PERF_SAMPLE_CPU);
+					  PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD);
 		attrs[i].sample_period = 1;
 	}
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1aa721d..a729945 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -377,6 +377,7 @@ static int add_tracepoint(struct list_head **list, int *idx,
 	attr.sample_type |= PERF_SAMPLE_RAW;
 	attr.sample_type |= PERF_SAMPLE_TIME;
 	attr.sample_type |= PERF_SAMPLE_CPU;
+	attr.sample_type |= PERF_SAMPLE_PERIOD;
 	attr.sample_period = 1;
 
 	snprintf(name, MAX_NAME_LEN, "%s:%s", sys_name, evt_name);
-- 
1.7.5.4

