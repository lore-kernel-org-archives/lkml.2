Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab1EXSR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:17:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38088 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab1EXSRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:17:22 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=dlAkdW-D3HcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=YiqaoiNiF0WxVtPnJ5YA:9 a=LWBlpq9il500r-ptMbAA:7 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110524181721.108350131@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 14:10:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/12] tracing/kprobes: Fix kprobe-tracer to support stack trace
References: <20110524181032.382259739@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-kprobes-Fix-kprobe-tracer-to-support-stack-t.patch
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

 # echo p schedule > /sys/kernel/debug/tracing/kprobe_events
 # echo 1 > /sys/kernel/debug/tracing/options/stacktrace
 # echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
 # head -n 20 /sys/kernel/debug/tracing/trace
            sshd-1549  [001]   857.326335: p_schedule_0: (schedule+0x0/0x900)
            sshd-1549  [001]   857.326337: <stack trace>
 => schedule_hrtimeout_range
 => poll_schedule_timeout
 => do_select
 => core_sys_select
 => sys_select
 => system_call_fastpath
             tee-1751  [000]   857.326394: p_schedule_0: (schedule+0x0/0x900)
             tee-1751  [000]   857.326395: <stack trace>
 => do_group_exit
 => sys_exit_group
 => system_call_fastpath
          <idle>-0     [001]   857.326406: p_schedule_0: (schedule+0x0/0x900)
          <idle>-0     [001]   857.326407: <stack trace>
 => start_secondary

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/20110512102255.2540.88867.stgit@ltc-x64-VirtualBox
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    4 ++++
 kernel/trace/trace.c         |   35 ++++++++++++++++++++++++++++++-----
 kernel/trace/trace.h         |    9 +++++++++
 kernel/trace/trace_kprobe.c  |    6 ++++--
 4 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index b5a550a..bca2499 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -117,6 +117,10 @@ void trace_current_buffer_unlock_commit(struct ring_buffer *buffer,
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
index 2af132e..bbcf6dd 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1192,6 +1192,18 @@ void trace_nowake_buffer_unlock_commit(struct ring_buffer *buffer,
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
@@ -1237,7 +1249,7 @@ ftrace(struct trace_array *tr, struct trace_array_cpu *data,
 #ifdef CONFIG_STACKTRACE
 static void __ftrace_trace_stack(struct ring_buffer *buffer,
 				 unsigned long flags,
-				 int skip, int pc)
+				 int skip, int pc, struct pt_regs *regs)
 {
 	struct ftrace_event_call *call = &event_kernel_stack;
 	struct ring_buffer_event *event;
@@ -1256,24 +1268,36 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 	trace.skip		= skip;
 	trace.entries		= entry->caller;
 
-	save_stack_trace(&trace);
+	if (regs)
+		save_stack_trace_regs(&trace, regs);
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
@@ -1289,7 +1313,8 @@ void trace_dump_stack(void)
 	local_save_flags(flags);
 
 	/* skipping 3 traces, seems to get us at the caller of this function */
-	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count());
+	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count(),
+			     NULL);
 }
 
 static DEFINE_PER_CPU(int, user_stack_count);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6b69c4b..53e15ed 100644
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


