Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1CQJk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 05:40:27 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:46419 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752890Ab1CQJkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 05:40:22 -0400
From: <philippe.langlais@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: <rostedt@goodmis.org>, <STEricsson_nomadik_linux@list.st.com>,
        <pierre.peiffer@stericsson.com>, <lee.jones@linaro.org>,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: [PATCH 3/3] trace: add STM trace hooks for printk, trace_printk, trace_function, stack trace and scheduler wakeup/context switch tracing
Date: Thu, 17 Mar 2011 10:36:54 +0100
Message-ID: <1300354614-24056-4-git-send-email-philippe.langlais@stericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300354614-24056-1-git-send-email-philippe.langlais@stericsson.com>
References: <1300354614-24056-1-git-send-email-philippe.langlais@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@linaro.org>

Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
---
 kernel/printk.c                   |    4 ++++
 kernel/trace/trace.c              |   10 ++++++++++
 kernel/trace/trace_events.c       |    3 +++
 kernel/trace/trace_sched_switch.c |   10 ++++++++++
 4 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 3623152..e36d0e4 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -40,6 +40,7 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/rculist.h>
+#include <trace/stm.h>
 
 #include <asm/uaccess.h>
 
@@ -776,6 +777,9 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 
 	p = printk_buf;
 
+	/* Send printk buffer to MIPI STM trace hardware too if enable */
+	stm_dup_printk(printk_buf, printed_len);
+
 	/* Do we have a loglevel in the string? */
 	if (p[0] == '<') {
 		unsigned char c = p[1];
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dc53ecb..fac980b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -37,6 +37,7 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/fs.h>
+#include <trace/stm.h>
 
 #include "trace.h"
 #include "trace_output.h"
@@ -1214,6 +1215,8 @@ trace_function(struct trace_array *tr,
 
 	if (!filter_check_discard(call, entry, buffer, event))
 		ring_buffer_unlock_commit(buffer, event);
+
+	stm_ftrace(ip, parent_ip);
 }
 
 void
@@ -1248,8 +1251,11 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 	trace.entries		= entry->caller;
 
 	save_stack_trace(&trace);
+
 	if (!filter_check_discard(call, entry, buffer, event))
 		ring_buffer_unlock_commit(buffer, event);
+
+	stm_stack_trace(trace.entries);
 }
 
 void ftrace_trace_stack(struct ring_buffer *buffer, unsigned long flags,
@@ -1405,6 +1411,8 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
 
+	stm_trace_bprintk_buf(ip, fmt, trace_buf, sizeof(u32) * len);
+
 out_unlock:
 	arch_spin_unlock(&trace_buf_lock);
 	local_irq_restore(flags);
@@ -1481,6 +1489,8 @@ int trace_array_vprintk(struct trace_array *tr,
 		ftrace_trace_stack(buffer, irq_flags, 6, pc);
 	}
 
+	stm_trace_printk_buf(ip, trace_buf, len);
+
  out_unlock:
 	arch_spin_unlock(&trace_buf_lock);
 	raw_local_irq_restore(irq_flags);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 5f499e0..be9223a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -19,6 +19,7 @@
 #include <linux/delay.h>
 
 #include <asm/setup.h>
+#include <trace/stm.h>
 
 #include "trace_output.h"
 
@@ -1644,6 +1645,8 @@ function_test_events_call(unsigned long ip, unsigned long parent_ip)
 
 	trace_nowake_buffer_unlock_commit(buffer, event, flags, pc);
 
+	stm_ftrace(ip, parent_ip);
+
  out:
 	atomic_dec(&per_cpu(ftrace_test_event_disable, cpu));
 	preempt_enable_notrace();
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 8f758d0..1c8eb37 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -11,6 +11,7 @@
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
 #include <trace/events/sched.h>
+#include <trace/stm.h>
 
 #include "trace.h"
 
@@ -47,6 +48,10 @@ tracing_sched_switch_trace(struct trace_array *tr,
 
 	if (!filter_check_discard(call, entry, buffer, event))
 		trace_buffer_unlock_commit(buffer, event, flags, pc);
+
+	stm_sched_switch(entry->prev_pid, entry->prev_prio, entry->prev_state,
+			entry->next_pid, entry->next_prio, entry->next_state,
+			entry->next_cpu);
 }
 
 static void
@@ -103,6 +108,11 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 
 	if (!filter_check_discard(call, entry, buffer, event))
 		ring_buffer_unlock_commit(buffer, event);
+
+	stm_sched_wakeup(entry->prev_pid, entry->prev_prio, entry->prev_state,
+			entry->next_pid, entry->next_prio, entry->next_state,
+			entry->next_cpu);
+
 	ftrace_trace_stack(tr->buffer, flags, 6, pc);
 	ftrace_trace_userstack(tr->buffer, flags, pc);
 }
-- 
1.7.3.1

