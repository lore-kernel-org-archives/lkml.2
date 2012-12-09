Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab2LIL3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 06:29:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56242 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522Ab2LIL3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 06:29:13 -0500
Date: Sun, 9 Dec 2012 03:28:40 -0800
From: tip-bot for Shan Wei <davidshan@tencent.com>
Message-ID: <tip-1c7d66732458dc187008e3f5b2f71e019e320fc2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davidshan@tencent.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davidshan@tencent.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <50949FC9.6050202@gmail.com>
References: <50949FC9.6050202@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing:
  Kill unused and puzzled sample code in ftrace.h
Git-Commit-ID: 1c7d66732458dc187008e3f5b2f71e019e320fc2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 09 Dec 2012 03:28:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c7d66732458dc187008e3f5b2f71e019e320fc2
Gitweb:     http://git.kernel.org/tip/1c7d66732458dc187008e3f5b2f71e019e320fc2
Author:     Shan Wei <davidshan@tencent.com>
AuthorDate: Sat, 3 Nov 2012 12:38:33 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 13 Nov 2012 15:51:21 -0500

tracing: Kill unused and puzzled sample code in ftrace.h

When doing per-cpu helper optimizing work, find that this code is so puzzled.
1. It's mark as comment text, maybe a sample function for guidelines
   or a todo work.
2. But, this sample code is odd where struct perf_trace_buf is nonexistent.
   commit ce71b9 delete struct perf_trace_buf definition.

   Author: Frederic Weisbecker <fweisbec@gmail.com>
   Date:   Sun Nov 22 05:26:55 2009 +0100

   tracing: Use the perf recursion protection from trace event

Is it necessary to keep there?
just compile test.

Link: http://lkml.kernel.org/r/50949FC9.6050202@gmail.com

Signed-off-by: Shan Wei <davidshan@tencent.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h | 73 --------------------------------------------------
 1 file changed, 73 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 698f2a8..40dc5e8 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -619,79 +619,6 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-/*
- * Define the insertion callback to perf events
- *
- * The job is very similar to ftrace_raw_event_<call> except that we don't
- * insert in the ring buffer but in a perf counter.
- *
- * static void ftrace_perf_<call>(proto)
- * {
- *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
- *	struct ftrace_event_call *event_call = &event_<call>;
- *	extern void perf_tp_event(int, u64, u64, void *, int);
- *	struct ftrace_raw_##call *entry;
- *	struct perf_trace_buf *trace_buf;
- *	u64 __addr = 0, __count = 1;
- *	unsigned long irq_flags;
- *	struct trace_entry *ent;
- *	int __entry_size;
- *	int __data_size;
- *	int __cpu
- *	int pc;
- *
- *	pc = preempt_count();
- *
- *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
- *
- *	// Below we want to get the aligned size by taking into account
- *	// the u32 field that will later store the buffer size
- *	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),
- *			     sizeof(u64));
- *	__entry_size -= sizeof(u32);
- *
- *	// Protect the non nmi buffer
- *	// This also protects the rcu read side
- *	local_irq_save(irq_flags);
- *	__cpu = smp_processor_id();
- *
- *	if (in_nmi())
- *		trace_buf = rcu_dereference_sched(perf_trace_buf_nmi);
- *	else
- *		trace_buf = rcu_dereference_sched(perf_trace_buf);
- *
- *	if (!trace_buf)
- *		goto end;
- *
- *	trace_buf = per_cpu_ptr(trace_buf, __cpu);
- *
- * 	// Avoid recursion from perf that could mess up the buffer
- * 	if (trace_buf->recursion++)
- *		goto end_recursion;
- *
- * 	raw_data = trace_buf->buf;
- *
- *	// Make recursion update visible before entering perf_tp_event
- *	// so that we protect from perf recursions.
- *
- *	barrier();
- *
- *	//zero dead bytes from alignment to avoid stack leak to userspace:
- *	*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;
- *	entry = (struct ftrace_raw_<call> *)raw_data;
- *	ent = &entry->ent;
- *	tracing_generic_entry_update(ent, irq_flags, pc);
- *	ent->type = event_call->id;
- *
- *	<tstruct> <- do some jobs with dynamic arrays
- *
- *	<assign>  <- affect our values
- *
- *	perf_tp_event(event_call->id, __addr, __count, entry,
- *		     __entry_size);  <- submit them to perf counter
- *
- * }
- */
 
 #ifdef CONFIG_PERF_EVENTS
 
