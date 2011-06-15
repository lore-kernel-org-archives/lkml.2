Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab1FONxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:53:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab1FONwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:52:42 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=iWIfls2rmAYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=OoJzPF_Tohxa1ixE2hoA:9 a=GG6pQ-E8yzCWQ_lAicMA:7 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110615135236.886897355@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 15 Jun 2011 09:48:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 16/16 v2] tracing/kprobes: Fix kprobe-tracer to support stack trace
References: <20110615134841.767565350@goodmis.org>
Content-Disposition: inline; filename=0016-tracing-kprobes-Fix-kprobe-tracer-to-support-stack-t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@gmail.com>
Link: http://lkml.kernel.org/r/20110608070934.17777.17116.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
index c977018..d9c1612 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1193,6 +1193,18 @@ void trace_nowake_buffer_unlock_commit(struct ring_buffer *buffer,
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
@@ -1238,7 +1250,7 @@ ftrace(struct trace_array *tr, struct trace_array_cpu *data,
 #ifdef CONFIG_STACKTRACE
 static void __ftrace_trace_stack(struct ring_buffer *buffer,
 				 unsigned long flags,
-				 int skip, int pc)
+				 int skip, int pc, struct pt_regs *regs)
 {
 	struct ftrace_event_call *call = &event_kernel_stack;
 	struct ring_buffer_event *event;
@@ -1257,24 +1269,36 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
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
@@ -1290,7 +1314,7 @@ void trace_dump_stack(void)
 	local_save_flags(flags);
 
 	/* skipping 3 traces, seems to get us at the caller of this function */
-	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count());
+	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count(), NULL);
 }
 
 static DEFINE_PER_CPU(int, user_stack_count);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 742f545..a3e2db7 100644
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
index f925c45..7053ef3 100644
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
-- 
1.7.4.4


