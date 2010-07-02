Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab0GBDEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 23:04:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65387 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab0GBDEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 23:04:09 -0400
Message-ID: <4C2D57F4.2050204@cn.fujitsu.com>
Date: Fri, 02 Jul 2010 11:07:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: Allow to disable cmdline recording
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index cc90ccd..e0fd494 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -597,6 +597,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_LATENCY_FMT		= 0x20000,
 	TRACE_ITER_SLEEP_TIME		= 0x40000,
 	TRACE_ITER_GRAPH_TIME		= 0x80000,
+	TRACE_ITER_RECORD_CMD		= 0x100000,
 };
 
 /*
@@ -729,6 +730,8 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
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
-- 
1.6.3

