Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab0DBTEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:04:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:47554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab0DBTEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:04:24 -0400
Date: Fri, 2 Apr 2010 19:04:05 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4BA97FD0.7090202@cn.fujitsu.com>
References: <4BA97FD0.7090202@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Update comments
Message-ID: <tip-50354a8a28d0c91695a2d6d25b5a821bfe557a07@git.kernel.org>
Git-Commit-ID: 50354a8a28d0c91695a2d6d25b5a821bfe557a07
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:04:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50354a8a28d0c91695a2d6d25b5a821bfe557a07
Gitweb:     http://git.kernel.org/tip/50354a8a28d0c91695a2d6d25b5a821bfe557a07
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 24 Mar 2010 10:58:24 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 31 Mar 2010 22:56:56 -0400

tracing: Update comments

Make some comments consistent with the code.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4BA97FD0.7090202@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index ea6f9d4..75dd778 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -154,9 +154,11 @@
  *
  *	field = (typeof(field))entry;
  *
- *	p = get_cpu_var(ftrace_event_seq);
+ *	p = &get_cpu_var(ftrace_event_seq);
  *	trace_seq_init(p);
- *	ret = trace_seq_printf(s, <TP_printk> "\n");
+ *	ret = trace_seq_printf(s, "%s: ", <call>);
+ *	if (ret)
+ *		ret = trace_seq_printf(s, <TP_printk> "\n");
  *	put_cpu();
  *	if (!ret)
  *		return TRACE_TYPE_PARTIAL_LINE;
@@ -450,38 +452,38 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *
  * static void ftrace_raw_event_<call>(proto)
  * {
+ *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
  *	struct ring_buffer_event *event;
  *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
  *	struct ring_buffer *buffer;
  *	unsigned long irq_flags;
+ *	int __data_size;
  *	int pc;
  *
  *	local_save_flags(irq_flags);
  *	pc = preempt_count();
  *
+ *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
+ *
  *	event = trace_current_buffer_lock_reserve(&buffer,
  *				  event_<call>.id,
- *				  sizeof(struct ftrace_raw_<call>),
+ *				  sizeof(*entry) + __data_size,
  *				  irq_flags, pc);
  *	if (!event)
  *		return;
  *	entry	= ring_buffer_event_data(event);
  *
- *	<assign>;  <-- Here we assign the entries by the __field and
- *			__array macros.
+ *	{ <assign>; }  <-- Here we assign the entries by the __field and
+ *			   __array macros.
  *
- *	trace_current_buffer_unlock_commit(buffer, event, irq_flags, pc);
+ *	if (!filter_current_check_discard(buffer, event_call, entry, event))
+ *		trace_current_buffer_unlock_commit(buffer,
+ *						   event, irq_flags, pc);
  * }
  *
  * static int ftrace_raw_reg_event_<call>(struct ftrace_event_call *unused)
  * {
- *	int ret;
- *
- *	ret = register_trace_<call>(ftrace_raw_event_<call>);
- *	if (!ret)
- *		pr_info("event trace: Could not activate trace point "
- *			"probe to <call>");
- *	return ret;
+ *	return register_trace_<call>(ftrace_raw_event_<call>);
  * }
  *
  * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
@@ -493,6 +495,8 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *	.trace			= ftrace_raw_output_<call>, <-- stage 2
  * };
  *
+ * static const char print_fmt_<call>[] = <TP_printk>;
+ *
  * static struct ftrace_event_call __used
  * __attribute__((__aligned__(4)))
  * __attribute__((section("_ftrace_events"))) event_<call> = {
@@ -501,6 +505,8 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *	.raw_init		= trace_event_raw_init,
  *	.regfunc		= ftrace_reg_event_<call>,
  *	.unregfunc		= ftrace_unreg_event_<call>,
+ *	.print_fmt		= print_fmt_<call>,
+ *	.define_fields		= ftrace_define_fields_<call>,
  * }
  *
  */
@@ -569,7 +575,6 @@ ftrace_raw_event_id_##call(struct ftrace_event_call *event_call,	\
 		return;							\
 	entry	= ring_buffer_event_data(event);			\
 									\
-									\
 	tstruct								\
 									\
 	{ assign; }							\
