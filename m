Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab0LDAOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:14:55 -0500
Received: from smtp-out.google.com ([74.125.121.35]:16996 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab0LDANx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:13:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=F81k03SBcOY5gdTyG4DoyCgTGqTtq2IWegpC1zWEt+3+oHskOjcn/8n98qNwl3BIJ
	yE0tIT4XwVabQP8ZFMGcw==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH 15/15] small_traces: Remove 8 bytes from trace_entry.
Date: Fri,  3 Dec 2010 16:13:29 -0800
Message-Id: <1291421609-14665-16-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove flags, preempt_count, and lock_depth from trace_entry. These fields
were used only by the latency tracer output and are relatively unimportant,
while incurring high payload overhead.

Shrink pid to 16 bits. pid_max is usually 32768. The potential for loss of
fidelity here is minimal, and can be guaranteed by setting pid_max.

Google-Bug-Id: 3224547

Signed-off-by: David Sharp <dhsharp@google.com>
---
 include/linux/ftrace_event.h |    4 ++++
 kernel/trace/trace.c         |    7 ++++++-
 kernel/trace/trace_events.c  |    4 ++++
 3 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 8beabb9..3a0bdd1 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -34,10 +34,14 @@ const char *ftrace_print_hex_seq(struct trace_seq *p,
  */
 struct trace_entry {
 	unsigned short		type;
+#ifdef CONFIG_SMALL_TRACES
+	short		pid;
+#else
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
 	int			lock_depth;
+#endif
 };
 
 #define FTRACE_MAX_EVENT						\
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 177d4e5..73b6482 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1101,8 +1101,11 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 {
 	struct task_struct *tsk = current;
 
-	entry->preempt_count		= pc & 0xff;
+#ifdef CONFIG_SMALL_TRACES
+        entry->pid			= (tsk) ? (typeof(entry->pid))tsk->pid : 0;
+#else
 	entry->pid			= (tsk) ? tsk->pid : 0;
+	entry->preempt_count		= pc & 0xff;
 	entry->lock_depth		= (tsk) ? tsk->lock_depth : 0;
 	entry->flags =
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
@@ -1113,9 +1116,11 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
 		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
+#endif
 }
 EXPORT_SYMBOL_GPL(tracing_generic_entry_update);
 
+
 struct ring_buffer_event *
 trace_buffer_lock_reserve(struct ring_buffer *buffer,
 			  int type,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0725eea..3684a3e 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -107,10 +107,14 @@ static int trace_define_common_fields(void)
 	struct trace_entry ent;
 
 	__common_field(unsigned short, type);
+#ifdef CONFIG_SMALL_TRACES
+	__common_field(short, pid);
+#else
 	__common_field(unsigned char, flags);
 	__common_field(unsigned char, preempt_count);
 	__common_field(int, pid);
 	__common_field(int, lock_depth);
+#endif
 
 	return ret;
 }
-- 
1.7.3.1

