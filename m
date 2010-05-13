Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab0EMBXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:23:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63144 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881Ab0EMBXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:23:07 -0400
X-Authority-Analysis: v=1.1 cv=RZg5C6NCKrCZril9sGGnsuGk01/OiP2z3O3lo0hXATg= c=1 sm=0 a=0RO5Ue31tdsA:10 a=yQWWgrYGNuUA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=D_SbEOMbAAAA:8 a=meVymXHHAAAA:8 a=cOhARaSxlioixC67Y-UA:9 a=MrWSiKneR56avW7zQ9v8pyUt6vcA:4 a=7KbvKZvEaC0A:10 a=jeBq3FmKZ4MA:10 a=cNcyB7tm9-wZFMDQ:21 a=SUl_OfzVQFiHrS6u:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100513012301.719314329@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 12 May 2010 21:21:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 2/4] tracing/sched: Fix task states in sched switch event
References: <20100513012110.558313399@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-sched-Fix-task-states-in-sched-switch-event.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Emde <C.Emde@osadl.org>

The sched_switch trace event displays erroneous character codes of task
states, after a new task state was added in the scheduler code but
omitted to add in the trace event code.

Define character codes of task states individually. In addition, define
task state descriptions needed in /proc at the same place. This will
help to keep the task state bits, characters and descriptions in sync
should they ever need to be changed again.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
LKML-Reference: <20100311122822.678489605@osadl.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/proc/array.c              |   25 +++++++++++++------------
 include/linux/sched.h        |   38 ++++++++++++++++++++++++++++++++++++--
 include/trace/events/sched.h |   12 +++++++++---
 3 files changed, 58 insertions(+), 17 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index e51f2ec..6ececdd 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -128,21 +128,22 @@ static inline void task_name(struct seq_file *m, struct task_struct *p)
 
 /*
  * The task state array is a strange "bitmap" of
- * reasons to sleep. Thus "running" is zero, and
- * you can test for combinations of others with
+ * reasons to sleep. Thus, the first element is zero,
+ * and you can test for combinations of others with
  * simple bit tests.
  */
+#define TASK_STATE_X(num) TASK_STATE_##num " (" DESCR_TASK_STATE_##num ")"
 static const char *task_state_array[] = {
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
+	TASK_STATE_X(0),
+	TASK_STATE_X(1),
+	TASK_STATE_X(2),
+	TASK_STATE_X(4),
+	TASK_STATE_X(8),
+	TASK_STATE_X(16),
+	TASK_STATE_X(32),
+	TASK_STATE_X(64),
+	TASK_STATE_X(128),
+	TASK_STATE_X(256)
 };
 
 static inline const char *get_task_state(struct task_struct *tsk)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dad7f66..1d0b0ab 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -172,7 +172,9 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 
 /*
  * Task state bitmask. NOTE! These bits are also
- * encoded in fs/proc/array.c: get_task_state().
+ * used in fs/proc/array.c: get_task_state() and
+ * in include/trace/events/sched.h in the
+ * sched_switch trace event.
  *
  * We have two separate sets of flags: task->state
  * is about runnability, while task->exit_state are
@@ -181,20 +183,52 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
  * mistake.
  */
 #define TASK_RUNNING		0
+#define TASK_STATE_0		"R"
+#define DESCR_TASK_STATE_0	"running"
+
 #define TASK_INTERRUPTIBLE	1
+#define TASK_STATE_1		"S"
+#define DESCR_TASK_STATE_1	"sleeping"
+
 #define TASK_UNINTERRUPTIBLE	2
+#define TASK_STATE_2		"D"
+#define DESCR_TASK_STATE_2	"disk sleep"
+
 #define __TASK_STOPPED		4
+#define TASK_STATE_4		"T"
+#define DESCR_TASK_STATE_4	"stopped"
+
 #define __TASK_TRACED		8
+#define TASK_STATE_8		"t"
+#define DESCR_TASK_STATE_8	"tracing stop"
+
 /* in tsk->exit_state */
 #define EXIT_ZOMBIE		16
+#define TASK_STATE_16		"Z"
+#define DESCR_TASK_STATE_16	"zombie"
+
 #define EXIT_DEAD		32
+#define TASK_STATE_32		"X"
+#define DESCR_TASK_STATE_32	"dead"
+
 /* in tsk->state again */
 #define TASK_DEAD		64
+#define TASK_STATE_64		"x"
+#define DESCR_TASK_STATE_64	"dead"
+
 #define TASK_WAKEKILL		128
+#define TASK_STATE_128		"K"
+#define DESCR_TASK_STATE_128	"wakekill"
+
 #define TASK_WAKING		256
+#define TASK_STATE_256		"W"
+#define DESCR_TASK_STATE_256	"waking"
+
 #define TASK_STATE_MAX		512
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKW"
+#define TASK_STATE_TO_CHAR_STR \
+  TASK_STATE_0 TASK_STATE_1 TASK_STATE_2 TASK_STATE_4 TASK_STATE_8 \
+  TASK_STATE_16 TASK_STATE_32 TASK_STATE_64 TASK_STATE_128 TASK_STATE_256
 
 extern char ___assert_task_state[1 - 2*!!(
 		sizeof(TASK_STATE_TO_CHAR_STR)-1 != ilog2(TASK_STATE_MAX)+1)];
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index cfceb0b..d073711 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -161,11 +161,17 @@ TRACE_EVENT(sched_switch,
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
-- 
1.7.0


