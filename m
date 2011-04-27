Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361Ab1D0PWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:22:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:34605 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757813Ab1D0PWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:22:53 -0400
Date: Wed, 27 Apr 2011 15:22:44 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-ee5e51f51be755830f57445e268ba50e88ccbdbb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <20110325110518.GC1922@jolsa.brq.redhat.com>
References: <20110325110518.GC1922@jolsa.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Avoid soft lockup in trace_pipe
Git-Commit-ID: ee5e51f51be755830f57445e268ba50e88ccbdbb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 15:22:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee5e51f51be755830f57445e268ba50e88ccbdbb
Gitweb:     http://git.kernel.org/tip/ee5e51f51be755830f57445e268ba50e88ccbdbb
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 25 Mar 2011 12:05:18 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 4 Apr 2011 12:18:24 -0400

tracing: Avoid soft lockup in trace_pipe

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
 
