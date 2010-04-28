Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0D1BiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:38:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47941 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab0D1BiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:38:10 -0400
X-Authority-Analysis: v=1.1 cv=elpKMhBbP+pQyLZqL930WohJ6E0KICKd8OrLrcMNK78= c=1 sm=0 a=ZDKRiCE6BGAA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=5t2KIU6oRZ6ec4kXgFcA:9 a=Z8r_IvVJjLRPN_q-wzsA:7 a=CMwsfsxMPWvD-Z9lYPuJnGakgHAA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100428013807.530671968@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 27 Apr 2010 21:27:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 8/8] tracing: Fix sleep time function profiling
References: <20100428012723.119106602@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Fix-sleep-time-function-profiling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When sleep_time is off the function profiler ignores the time that a task
is scheduled out. When the task is scheduled out a timestamp is taken.
When the task is scheduled back in, the timestamp is compared to the
current time and the saved calltimes are adjusted accordingly.

But when stopping the function profiler, the sched switch hook that
does this adjustment was stopped before shutting down the tracer.
This allowed some tasks to not get their timestamps set when they
scheduled out. When the function profiler started again, this would
skew the times of the scheduler functions.

This patch moves the stopping of the sched switch to after the function
profiler is stopped. It also ignores zero set calltimes, which may
happen on start up.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3bcb340..8c9c293 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -666,6 +666,10 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
 
+	/* If the calltime was zero'd ignore it */
+	if (!trace->calltime)
+		goto out;
+
 	calltime = trace->rettime - trace->calltime;
 
 	if (!(trace_flags & TRACE_ITER_GRAPH_TIME)) {
@@ -3357,11 +3361,11 @@ void unregister_ftrace_graph(void)
 		goto out;
 
 	ftrace_graph_active--;
-	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch);
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
 	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
+	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch);
 
  out:
 	mutex_unlock(&ftrace_lock);
-- 
1.7.0


