Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0EPWZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:25:32 -0400
Received: from toro.web-alm.net ([62.245.132.31]:49357 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab0EPWZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:25:29 -0400
Message-Id: <20100516222207.541520625@osadl.org>
User-Agent: quilt/0.47-1
Date: Mon, 17 May 2010 00:18:45 +0200
From: Carsten Emde <C.Emde@osadl.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 1/1] fix-task-states-in-sched_switch-event.patch
References: <20100516221844.515632338@osadl.org>
Content-Disposition: inline; filename=fix-task-states-in-sched_switch-event.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sched_switch trace event displays erroneous character codes of task
states, after a new task state was added in the scheduler code but
omitted to add in the trace event code.

Define character codes of task states individually. In addition, define
task state descriptions needed in /proc and in the sched_switch trace
event at the same place. This will help to keep the task state bits,
characters and descriptions in sync should they ever need to be changed
again.

CC: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100513133539.GA17107@elte.hu>
Signed-off-by: Carsten Emde <C.Emde@osadl.org>
---
 fs/proc/array.c              |   19 -------------
 include/linux/sched.h        |   62 ++++++++++++++++++++++++++++++++++++++++---
 include/trace/events/sched.h |   12 ++++++--
 3 files changed, 69 insertions(+), 24 deletions(-)

Index: head/fs/proc/array.c
===================================================================
--- head.orig/fs/proc/array.c
+++ head/fs/proc/array.c
@@ -125,24 +125,7 @@ static inline void task_name(struct seq_
 	seq_printf(m, "\n");
 }
 
-/*
- * The task state array is a strange "bitmap" of
- * reasons to sleep. Thus "running" is zero, and
- * you can test for combinations of others with
- * simple bit tests.
- */
-static const char *task_state_array[] = {
-	"R (running)",		/*   0 */
-	"S (sleeping)",		/*   1 */
-	"D (disk sleep)",	/*   2 */
-	"T (stopped)",		/*   4 */
-	"t (tracing stop)",	/*   8 */
-	"Z (zombie)",		/*  16 */
-	"X (dead)",		/*  32 */
-	"x (dead)",		/*  64 */
-	"K (wakekill)",		/* 128 */
-	"W (waking)",		/* 256 */
-};
+static const char *task_state_array[] = TASK_STATE_STRINGS_INIT;
 
 static inline const char *get_task_state(struct task_struct *tsk)
 {
Index: head/include/linux/sched.h
===================================================================
--- head.orig/include/linux/sched.h
+++ head/include/linux/sched.h
@@ -170,34 +170,90 @@ print_cfs_rq(struct seq_file *m, int cpu
 #endif
 
 /*
- * Task state bitmask. NOTE! These bits are also
- * encoded in fs/proc/array.c: get_task_state().
+ * The task state array is a strange "bitmap" of
+ * reasons to sleep. Thus, the first element is zero,
+ * and you can test for combinations of others with
+ * simple bit tests.
  *
  * We have two separate sets of flags: task->state
  * is about runnability, while task->exit_state are
  * about the task exiting. Confusing, but this way
  * modifying one set can't modify the other one by
  * mistake.
+ *
+ * NOTE: When adding or removing task_states, the
+ * variables TASK_STATE_MAX, TASK_STATE_TO_CHAR_STR,
+ * and TASK_STATE_STRINGS_INIT (below) and the
+ * TP_printk function of the sched_switch event
+ * (in include/trace/events/sched.h) must be adapted
+ * as well.
  */
 #define TASK_RUNNING		0
+#define TASK_STATE_0		"R"
+#define TASK_STATE_NAME_0	"running"
+
 #define TASK_INTERRUPTIBLE	1
+#define TASK_STATE_1		"S"
+#define TASK_STATE_NAME_1	"sleeping"
+
 #define TASK_UNINTERRUPTIBLE	2
+#define TASK_STATE_2		"D"
+#define TASK_STATE_NAME_2	"disk sleep"
+
 #define __TASK_STOPPED		4
+#define TASK_STATE_4		"T"
+#define TASK_STATE_NAME_4	"stopped"
+
 #define __TASK_TRACED		8
+#define TASK_STATE_8		"t"
+#define TASK_STATE_NAME_8	"tracing stop"
+
 /* in tsk->exit_state */
 #define EXIT_ZOMBIE		16
+#define TASK_STATE_16		"Z"
+#define TASK_STATE_NAME_16	"zombie"
+
 #define EXIT_DEAD		32
+#define TASK_STATE_32		"X"
+#define TASK_STATE_NAME_32	"dead"
+
 /* in tsk->state again */
 #define TASK_DEAD		64
+#define TASK_STATE_64		"x"
+#define TASK_STATE_NAME_64	"dead"
+
 #define TASK_WAKEKILL		128
+#define TASK_STATE_128		"K"
+#define TASK_STATE_NAME_128	"wakekill"
+
 #define TASK_WAKING		256
+#define TASK_STATE_256		"W"
+#define TASK_STATE_NAME_256	"waking"
+
 #define TASK_STATE_MAX		512
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKW"
+#define TASK_STATE_TO_CHAR_STR \
+  TASK_STATE_0 TASK_STATE_1 TASK_STATE_2 TASK_STATE_4 TASK_STATE_8 \
+  TASK_STATE_16 TASK_STATE_32 TASK_STATE_64 TASK_STATE_128 TASK_STATE_256
 
 extern char ___assert_task_state[1 - 2*!!(
 		sizeof(TASK_STATE_TO_CHAR_STR)-1 != ilog2(TASK_STATE_MAX)+1)];
 
+#define TASK_STATE_STRING(num) TASK_STATE_##num " (" TASK_STATE_NAME_##num ")"
+#define TASK_STATE_STRINGS_INIT	\
+	{			\
+	TASK_STATE_STRING(0),	\
+	TASK_STATE_STRING(1),	\
+	TASK_STATE_STRING(2),	\
+	TASK_STATE_STRING(4),	\
+	TASK_STATE_STRING(8),	\
+	TASK_STATE_STRING(16),	\
+	TASK_STATE_STRING(32),	\
+	TASK_STATE_STRING(64),	\
+	TASK_STATE_STRING(128),	\
+	TASK_STATE_STRING(256)	\
+	}
+
 /* Convenience macros for the sake of set_task_state */
 #define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
 #define TASK_STOPPED		(TASK_WAKEKILL | __TASK_STOPPED)
Index: head/include/trace/events/sched.h
===================================================================
--- head.orig/include/trace/events/sched.h
+++ head/include/trace/events/sched.h
@@ -149,11 +149,17 @@ TRACE_EVENT(sched_switch,
 		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
 		__entry->prev_state ?
 		  __print_flags(__entry->prev_state, "|",
-				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
-				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
-				{ 128, "W" }) : "R",
+			{ 1, TASK_STATE_1} , { 2, TASK_STATE_2 },
+			{ 4, TASK_STATE_4 }, { 8, TASK_STATE_8 },
+			{ 16, TASK_STATE_16 }, { 32, TASK_STATE_32 },
+			{ 64, TASK_STATE_64 }, { 128, TASK_STATE_128 },
+			{ 256, TASK_STATE_256 }
+			) : TASK_STATE_0,
 		__entry->next_comm, __entry->next_pid, __entry->next_prio)
 );
+#if TASK_STATE_MAX != 512
+#error "Please add new task state array in __print_flags() above."
+#endif
 
 /*
  * Tracepoint for a task being migrated:

