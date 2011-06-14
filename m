Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab1FNIgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 04:36:22 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43693 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab1FNIgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 04:36:17 -0400
X-AuditID: b753bd60-a0ac3ba000003bac-a2-4df71d7ea94b
X-AuditID: b753bd60-a0ac3ba000003bac-a2-4df71d7ea94b
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v3 3/3] [BUGFIX]tracing/kprobes: Fix kprobe-tracer to
 support stack trace
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>
Date: Tue, 14 Jun 2011 16:03:11 +0900
Message-ID: <20110614070311.3628.98620.stgit@fedora15>
In-Reply-To: <20110614070250.3628.94917.stgit@fedora15>
References: <20110614070250.3628.94917.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to support kernel stack trace correctly on kprobe-tracer.
Since the execution path of kprobe-based dynamic events is different
from other tracepoint-based events, normal ftrace_trace_stack() doesn't
work correctly. To fix that, this introduces ftrace_trace_stack_regs()
which traces stack via pt_regs instead of current stack register.

e.g.

 # echo p schedule+4 > /sys/kernel/debug/tracing/kprobe_events
 # echo 1 > /sys/kernel/debug/tracing/options/stacktrace
 # echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
 # head -n 20 /sys/kernel/debug/tracing/trace
# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
            bash-2968  [000] 10297.050245: p_schedule_4: (schedule+0x4/0x4ca)
            bash-2968  [000] 10297.050247: <stack trace>
 => schedule_timeout
 => n_tty_read
 => tty_read
 => vfs_read
 => sys_read
 => system_call_fastpath
     kworker/0:1-2940  [000] 10297.050265: p_schedule_4: (schedule+0x4/0x4ca)
     kworker/0:1-2940  [000] 10297.050266: <stack trace>
 => worker_thread
 => kthread
 => kernel_thread_helper
            sshd-1132  [000] 10297.050365: p_schedule_4: (schedule+0x4/0x4ca)
            sshd-1132  [000] 10297.050365: <stack trace>
 => sysret_careful

Note: Even with this fix, the first entry will be skipped
if the probe is put on the function entry area before
the frame pointer is set up (usually, that is 4 bytes
 (push %bp; mov %sp %bp) on x86), because stack unwinder
depends on the frame pointer.

Changes in v3:
- Just removes an 80 char limit line break.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@gmail.com>
---

 include/linux/ftrace_event.h |    4 ++++
 kernel/trace/trace.c         |   34 +++++++++++++++++++++++++++++-----
 kernel/trace/trace.h         |    9 +++++++++
 kernel/trace/trace_kprobe.c  |    6 ++++--
 4 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 59d3ef1..b1e69ee 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -129,6 +129,10 @@ void trace_current_buffer_unlock_commit(struct ring_buffer *buffer,
 void trace_nowake_buffer_unlock_commit(struct ring_buffer *buffer,
 				       struct ring_buffer_event *event,
 					unsigned long flags, int pc);
+void trace_nowake_buffer_unlock_commit_regs(struct ring_buffer *buffer,
+					    struct ring_buffer_event *event,
+					    unsigned long flags, int pc,
+					    struct pt_regs *regs);
 void trace_current_buffer_discard_commit(struct ring_buffer *buffer,
 					 struct ring_buffer_event *event);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee9c921..c399722 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1191,6 +1191,18 @@ void trace_nowake_buffer_unlock_commit(struct ring_buffer *buffer,
 }
 EXPORT_SYMBOL_GPL(trace_nowake_buffer_unlock_commit);
 
+void trace_nowake_buffer_unlock_commit_regs(struct ring_buffer *buffer,
+					    struct ring_buffer_event *event,
+					    unsigned long flags, int pc,
+					    struct pt_regs *regs)
+{
+	ring_buffer_unlock_commit(buffer, event);
+
+	ftrace_trace_stack_regs(buffer, flags, 0, pc, regs);
+	ftrace_trace_userstack(buffer, flags, pc);
+}
+EXPORT_SYMBOL_GPL(trace_nowake_buffer_unlock_commit_regs);
+
 void trace_current_buffer_discard_commit(struct ring_buffer *buffer,
 					 struct ring_buffer_event *event)
 {
@@ -1236,7 +1248,7 @@ ftrace(struct trace_array *tr, struct trace_array_cpu *data,
 #ifdef CONFIG_STACKTRACE
 static void __ftrace_trace_stack(struct ring_buffer *buffer,
 				 unsigned long flags,
-				 int skip, int pc)
+				 int skip, int pc, struct pt_regs *regs)
 {
 	struct ftrace_event_call *call = &event_kernel_stack;
 	struct ring_buffer_event *event;
@@ -1255,24 +1267,36 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 	trace.skip		= skip;
 	trace.entries		= entry->caller;
 
-	save_stack_trace(&trace);
+	if (regs)
+		save_stack_trace_regs(regs, &trace);
+	else
+		save_stack_trace(&trace);
 	if (!filter_check_discard(call, entry, buffer, event))
 		ring_buffer_unlock_commit(buffer, event);
 }
 
+void ftrace_trace_stack_regs(struct ring_buffer *buffer, unsigned long flags,
+			     int skip, int pc, struct pt_regs *regs)
+{
+	if (!(trace_flags & TRACE_ITER_STACKTRACE))
+		return;
+
+	__ftrace_trace_stack(buffer, flags, skip, pc, regs);
+}
+
 void ftrace_trace_stack(struct ring_buffer *buffer, unsigned long flags,
 			int skip, int pc)
 {
 	if (!(trace_flags & TRACE_ITER_STACKTRACE))
 		return;
 
-	__ftrace_trace_stack(buffer, flags, skip, pc);
+	__ftrace_trace_stack(buffer, flags, skip, pc, NULL);
 }
 
 void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
 		   int pc)
 {
-	__ftrace_trace_stack(tr->buffer, flags, skip, pc);
+	__ftrace_trace_stack(tr->buffer, flags, skip, pc, NULL);
 }
 
 /**
@@ -1288,7 +1312,7 @@ void trace_dump_stack(void)
 	local_save_flags(flags);
 
 	/* skipping 3 traces, seems to get us at the caller of this function */
-	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count());
+	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count(), NULL);
 }
 
 static DEFINE_PER_CPU(int, user_stack_count);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 229f859..caee141 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -389,6 +389,9 @@ void update_max_tr_single(struct trace_array *tr,
 void ftrace_trace_stack(struct ring_buffer *buffer, unsigned long flags,
 			int skip, int pc);
 
+void ftrace_trace_stack_regs(struct ring_buffer *buffer, unsigned long flags,
+			     int skip, int pc, struct pt_regs *regs);
+
 void ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags,
 			    int pc);
 
@@ -400,6 +403,12 @@ static inline void ftrace_trace_stack(struct ring_buffer *buffer,
 {
 }
 
+static inline void ftrace_trace_stack_regs(struct ring_buffer *buffer,
+					   unsigned long flags, int skip,
+					   int pc, struct pt_regs *regs)
+{
+}
+
 static inline void ftrace_trace_userstack(struct ring_buffer *buffer,
 					  unsigned long flags, int pc)
 {
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 27d13b3..7db7b68 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1397,7 +1397,8 @@ static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
-		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
+		trace_nowake_buffer_unlock_commit_regs(buffer, event,
+						       irq_flags, pc, regs);
 }
 
 /* Kretprobe handler */
@@ -1429,7 +1430,8 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
-		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
+		trace_nowake_buffer_unlock_commit_regs(buffer, event,
+						       irq_flags, pc, regs);
 }
 
 /* Event entry printers */

