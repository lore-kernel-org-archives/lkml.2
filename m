Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab2GBSIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:08:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:40737 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab2GBSID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:08:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf script: Fix format regression due to libtraceevent merge
Date: Mon,  2 Jul 2012 15:07:49 -0300
Message-Id: <1341252471-7834-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341252471-7834-1-git-send-email-acme@infradead.org>
References: <1341252471-7834-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Consider the commands:
    perf record -e sched:sched_switch -fo /tmp/perf.data  -a -- sleep 1
    perf script -i /tmp/perf.data

In v3.4 the output has the form (lines wrapped here)
    perf 29214 [005] 821043.582596: sched_switch:
prev_comm=perf prev_pid=29214 prev_prio=120
prev_state=S ==> next_comm=swapper/5 next_pid=0 next_prio=120

In 3.5 that same line has become:
    perf 29214 [005] 821043.582596: sched_switch:
<...>-29214 [005]     0.000000000: sched_switch:
prev_comm=perf prev_pid=29214 prev_prio=120
prev_state=S ==> next_comm=swapper/5 next_pid=0 next_prio=120

Note the duplicates in the output -- pid, cpu, event name. With
this patch the v3.4 output is restored:
    perf 29214 [005] 821043.582596: sched_switch:
prev_comm=perf prev_pid=29214 prev_prio=120
prev_state=S ==> next_comm=swapper/5 next_pid=0 next_prio=120

v3:
Remove that pesky newline too. Output now matches v3.4 (pre-libtracevent).

v2:
Change print_trace_event function local to perf per Steve's comments.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1339698977-68962-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index df2fddb..5dd3b5e 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -198,9 +198,8 @@ void print_trace_event(int cpu, void *data, int size)
 	record.data = data;
 
 	trace_seq_init(&s);
-	pevent_print_event(pevent, &s, &record);
+	pevent_event_info(&s, event, &record);
 	trace_seq_do_printf(&s);
-	printf("\n");
 }
 
 void print_event(int cpu, void *data, int size, unsigned long long nsecs,
-- 
1.7.1

