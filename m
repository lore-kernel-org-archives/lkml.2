Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062Ab0GWMKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:10:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:43000 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab0GWMKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:10:04 -0400
Date: Fri, 23 Jul 2010 12:09:45 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4C2D57F4.2050204@cn.fujitsu.com>
References: <4C2D57F4.2050204@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Allow to disable cmdline recording
Message-ID: <tip-e870e9a1240bcef1157ffaaf71dac63362e71904@git.kernel.org>
Git-Commit-ID: e870e9a1240bcef1157ffaaf71dac63362e71904
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Jul 2010 12:09:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e870e9a1240bcef1157ffaaf71dac63362e71904
Gitweb:     http://git.kernel.org/tip/e870e9a1240bcef1157ffaaf71dac63362e71904
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 2 Jul 2010 11:07:32 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 20 Jul 2010 21:52:33 -0400

tracing: Allow to disable cmdline recording

We found that even enabling a single trace event that will rarely be
triggered can add big overhead to context switch.

(lmbench context switch test)
 -------------------------------------------------
 2p/0K 2p/16K 2p/64K 8p/16K 8p/64K 16p/16K 16p/64K
 ctxsw  ctxsw  ctxsw ctxsw  ctxsw   ctxsw   ctxsw
------ ------ ------ ------ ------ ------- -------
  2.19   2.3   2.21   2.56   2.13     2.54    2.07
  2.39   2.51  2.35   2.75   2.27     2.81    2.24

The overhead is 6% ~ 11%.

It's because when a trace event is enabled 3 tracepoints (sched_switch,
sched_wakeup, sched_wakeup_new) will be activated to map pid to cmdname.

We'd like to avoid this overhead, so add a trace option '(no)record-cmd'
to allow to disable cmdline recording.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4C2D57F4.2050204@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    7 +++++--
 kernel/trace/trace.c         |    6 +++++-
 kernel/trace/trace.h         |    3 +++
 kernel/trace/trace_events.c  |   30 ++++++++++++++++++++++++++++--
 4 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 01df7ca..2b7b139 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -152,11 +152,13 @@ extern int ftrace_event_reg(struct ftrace_event_call *event,
 enum {
 	TRACE_EVENT_FL_ENABLED_BIT,
 	TRACE_EVENT_FL_FILTERED_BIT,
+	TRACE_EVENT_FL_RECORDED_CMD_BIT,
 };
 
 enum {
-	TRACE_EVENT_FL_ENABLED	= (1 << TRACE_EVENT_FL_ENABLED_BIT),
-	TRACE_EVENT_FL_FILTERED	= (1 << TRACE_EVENT_FL_FILTERED_BIT),
+	TRACE_EVENT_FL_ENABLED		= (1 << TRACE_EVENT_FL_ENABLED_BIT),
+	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
+	TRACE_EVENT_FL_RECORDED_CMD	= (1 << TRACE_EVENT_FL_RECORDED_CMD_BIT),
 };
 
 struct ftrace_event_call {
@@ -174,6 +176,7 @@ struct ftrace_event_call {
 	 * 32 bit flags:
 	 *   bit 1:		enabled
 	 *   bit 2:		filter_active
+	 *   bit 3:		enabled cmd record
 	 *
 	 * Changes to flags must hold the event_mutex.
 	 *
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8683dec..af90429 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -344,7 +344,7 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
-	TRACE_ITER_GRAPH_TIME;
+	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD;
 
 static int trace_stop_count;
 static DEFINE_SPINLOCK(tracing_start_lock);
@@ -428,6 +428,7 @@ static const char *trace_options[] = {
 	"latency-format",
 	"sleep-time",
 	"graph-time",
+	"record-cmd",
 	NULL
 };
 
@@ -2561,6 +2562,9 @@ static void set_tracer_flags(unsigned int mask, int enabled)
 		trace_flags |= mask;
 	else
 		trace_flags &= ~mask;
+
+	if (mask == TRACE_ITER_RECORD_CMD)
+		trace_event_enable_cmd_record(enabled);
 }
 
 static ssize_t
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 84d3f12..7778f06 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -591,6 +591,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_LATENCY_FMT		= 0x20000,
 	TRACE_ITER_SLEEP_TIME		= 0x40000,
 	TRACE_ITER_GRAPH_TIME		= 0x80000,
+	TRACE_ITER_RECORD_CMD		= 0x100000,
 };
 
 /*
@@ -723,6 +724,8 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 	return 0;
 }
 
+extern void trace_event_enable_cmd_record(bool enable);
+
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index e8e6043..09b4fa6 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -170,6 +170,26 @@ int ftrace_event_reg(struct ftrace_event_call *call, enum trace_reg type)
 }
 EXPORT_SYMBOL_GPL(ftrace_event_reg);
 
+void trace_event_enable_cmd_record(bool enable)
+{
+	struct ftrace_event_call *call;
+
+	mutex_lock(&event_mutex);
+	list_for_each_entry(call, &ftrace_events, list) {
+		if (!(call->flags & TRACE_EVENT_FL_ENABLED))
+			continue;
+
+		if (enable) {
+			tracing_start_cmdline_record();
+			call->flags |= TRACE_EVENT_FL_RECORDED_CMD;
+		} else {
+			tracing_stop_cmdline_record();
+			call->flags &= ~TRACE_EVENT_FL_RECORDED_CMD;
+		}
+	}
+	mutex_unlock(&event_mutex);
+}
+
 static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 					int enable)
 {
@@ -179,13 +199,19 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 	case 0:
 		if (call->flags & TRACE_EVENT_FL_ENABLED) {
 			call->flags &= ~TRACE_EVENT_FL_ENABLED;
-			tracing_stop_cmdline_record();
+			if (call->flags & TRACE_EVENT_FL_RECORDED_CMD) {
+				tracing_stop_cmdline_record();
+				call->flags &= ~TRACE_EVENT_FL_RECORDED_CMD;
+			}
 			call->class->reg(call, TRACE_REG_UNREGISTER);
 		}
 		break;
 	case 1:
 		if (!(call->flags & TRACE_EVENT_FL_ENABLED)) {
-			tracing_start_cmdline_record();
+			if (trace_flags & TRACE_ITER_RECORD_CMD) {
+				tracing_start_cmdline_record();
+				call->flags |= TRACE_EVENT_FL_RECORDED_CMD;
+			}
 			ret = call->class->reg(call, TRACE_REG_REGISTER);
 			if (ret) {
 				tracing_stop_cmdline_record();
