Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab0G1Cbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 22:31:52 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39233 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab0G1Cbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 22:31:40 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Munsie <imunsie@au1.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 2/2] Revert "tracing: Allow to disable cmdline recording"
Date: Wed, 28 Jul 2010 12:29:39 +1000
Message-Id: <1280284180-17863-2-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280284180-17863-1-git-send-email-imunsie@au1.ibm.com>
References: <1280284180-17863-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This reverts commit e870e9a1240bcef1157ffaaf71dac63362e71904.

That patch was submitted to provide an option to disable recording
command lines since we were using a hack to record them using the
sched_switch probes which added significant overhead to context
switching.

Since we no longer use that hack and command lines are now recorded when
a ring buffer entry is reserved (at the same time the PID is recorded),
the original purpose of this patch is no longer present and the option
to disable command line recording is not really required any more.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 include/linux/ftrace_event.h |    7 ++-----
 kernel/trace/trace.c         |    6 +-----
 kernel/trace/trace.h         |    3 ---
 kernel/trace/trace_events.c  |   18 ------------------
 4 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 02b8b24..b7915d6 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -153,13 +153,11 @@ extern int ftrace_event_reg(struct ftrace_event_call *event,
 enum {
 	TRACE_EVENT_FL_ENABLED_BIT,
 	TRACE_EVENT_FL_FILTERED_BIT,
-	TRACE_EVENT_FL_RECORDED_CMD_BIT,
 };
 
 enum {
-	TRACE_EVENT_FL_ENABLED		= (1 << TRACE_EVENT_FL_ENABLED_BIT),
-	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
-	TRACE_EVENT_FL_RECORDED_CMD	= (1 << TRACE_EVENT_FL_RECORDED_CMD_BIT),
+	TRACE_EVENT_FL_ENABLED	= (1 << TRACE_EVENT_FL_ENABLED_BIT),
+	TRACE_EVENT_FL_FILTERED	= (1 << TRACE_EVENT_FL_FILTERED_BIT),
 };
 
 struct ftrace_event_call {
@@ -177,7 +175,6 @@ struct ftrace_event_call {
 	 * 32 bit flags:
 	 *   bit 1:		enabled
 	 *   bit 2:		filter_active
-	 *   bit 3:		enabled cmd record
 	 *
 	 * Changes to flags must hold the event_mutex.
 	 *
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f8458c3..7fe152a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -344,7 +344,7 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
-	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD;
+	TRACE_ITER_GRAPH_TIME;
 
 static int trace_stop_count;
 static DEFINE_SPINLOCK(tracing_start_lock);
@@ -428,7 +428,6 @@ static const char *trace_options[] = {
 	"latency-format",
 	"sleep-time",
 	"graph-time",
-	"record-cmd",
 	NULL
 };
 
@@ -2517,9 +2516,6 @@ static void set_tracer_flags(unsigned int mask, int enabled)
 		trace_flags |= mask;
 	else
 		trace_flags &= ~mask;
-
-	if (mask == TRACE_ITER_RECORD_CMD)
-		trace_event_enable_cmd_record(enabled);
 }
 
 static ssize_t
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d05c873..a6f61bd 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -582,7 +582,6 @@ enum trace_iterator_flags {
 	TRACE_ITER_LATENCY_FMT		= 0x20000,
 	TRACE_ITER_SLEEP_TIME		= 0x40000,
 	TRACE_ITER_GRAPH_TIME		= 0x80000,
-	TRACE_ITER_RECORD_CMD		= 0x100000,
 };
 
 /*
@@ -715,8 +714,6 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 	return 0;
 }
 
-extern void trace_event_enable_cmd_record(bool enable);
-
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 2c0cf38..8f8dd73 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -170,24 +170,6 @@ int ftrace_event_reg(struct ftrace_event_call *call, enum trace_reg type)
 }
 EXPORT_SYMBOL_GPL(ftrace_event_reg);
 
-void trace_event_enable_cmd_record(bool enable)
-{
-	struct ftrace_event_call *call;
-
-	mutex_lock(&event_mutex);
-	list_for_each_entry(call, &ftrace_events, list) {
-		if (!(call->flags & TRACE_EVENT_FL_ENABLED))
-			continue;
-
-		if (enable) {
-			call->flags |= TRACE_EVENT_FL_RECORDED_CMD;
-		} else {
-			call->flags &= ~TRACE_EVENT_FL_RECORDED_CMD;
-		}
-	}
-	mutex_unlock(&event_mutex);
-}
-
 static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 					int enable)
 {
-- 
1.7.1

