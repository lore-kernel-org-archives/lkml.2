Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1DTQAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:00:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35397 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab1DTQAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:00:34 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=vhdKIqpQuCYA:10 a=To5htxnoGzYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=q6rQUnKnsQDmuxrwYP4A:9 a=33Wmf6nklRFcBIzi2asA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110420160030.866666479@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 11:58:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/6] tracing: Avoid soft lockup in trace_pipe
References: <20110420155838.640017971@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Avoid-soft-lockup-in-trace_pipe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

running following commands:

  # enable the binary option
  echo 1 > ./options/bin
  # disable context info option
  echo 0 > ./options/context-info
  # tracing only events
  echo 1 > ./events/enable
  cat trace_pipe

plus forcing system to generate many tracing events,
is causing lockup (in NON preemptive kernels) inside
tracing_read_pipe function.

The issue is also easily reproduced by running ltp stress test.
(ftrace_stress_test.sh)

The reasons are:
 - bin/hex/raw output functions for events are set to
   trace_nop_print function, which prints nothing and
   returns TRACE_TYPE_HANDLED value
 - LOST EVENT trace do not handle trace_seq overflow

These reasons force the while loop in tracing_read_pipe
function never to break.

The attached patch fixies handling of lost event trace, and
changes trace_nop_print to print minimal info, which is needed
for the correct tracing_read_pipe processing.

v2 changes:
 - omit the cond_resched changes by trace_nop_print changes
 - WARN changed to WARN_ONCE and added info to be able
   to find out the culprit

v3 changes:
 - make more accurate patch comment

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <20110325110518.GC1922@jolsa.brq.redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c        |   15 ++++++++++++---
 kernel/trace/trace_output.c |    3 +++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9541c27..5af42f4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2013,9 +2013,10 @@ enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
 
-	if (iter->lost_events)
-		trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
-				 iter->cpu, iter->lost_events);
+	if (iter->lost_events &&
+	    !trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
+				 iter->cpu, iter->lost_events))
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	if (iter->trace && iter->trace->print_line) {
 		ret = iter->trace->print_line(iter);
@@ -3229,6 +3230,14 @@ waitagain:
 
 		if (iter->seq.len >= cnt)
 			break;
+
+		/*
+		 * Setting the full flag means we reached the trace_seq buffer
+		 * size and we should leave by partial output condition above.
+		 * One of the trace_seq_* functions is not used properly.
+		 */
+		WARN_ONCE(iter->seq.full, "full flag set for trace type %d",
+			  iter->ent->type);
 	}
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 456be90..cf535cc 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -830,6 +830,9 @@ EXPORT_SYMBOL_GPL(unregister_ftrace_event);
 enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags,
 				  struct trace_event *event)
 {
+	if (!trace_seq_printf(&iter->seq, "type: %d\n", iter->ent->type))
+		return TRACE_TYPE_PARTIAL_LINE;
+
 	return TRACE_TYPE_HANDLED;
 }
 
-- 
1.7.2.3


