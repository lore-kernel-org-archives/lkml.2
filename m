Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab2FNSYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:24:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55136 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2FNSYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:24:06 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH]  perf script: format regression due to libtraceevent
Date: Thu, 14 Jun 2012 12:23:47 -0600
Message-Id: <1339698227-68683-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/trace-event-parse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 134eb3a..1043bf5d 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -198,7 +198,7 @@ void print_trace_event(int cpu, void *data, int size)
 	record.data = data;
 
 	trace_seq_init(&s);
-	pevent_print_event(pevent, &s, &record);
+	pevent_event_info(&s, event, &record);
 	trace_seq_do_printf(&s);
 	printf("\n");
 }
-- 
1.7.10.1

