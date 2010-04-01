Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab0DADSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:18:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61807 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0DADSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:18:21 -0400
X-Authority-Analysis: v=1.1 cv=3DUlJUu7qWFNpNttJVwyA1nQS84iC7EN/BDLX6qJweI= c=1 sm=0 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=3cle5ga1sM4LiNWvmr4A:9 a=zSzFIPg7BO0KBRB1UNUA:7 a=vFK37wbAqPP3kFA4fuGSTXsY5aUA:4 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100401031819.313072389@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 31 Mar 2010 23:17:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/7] tracing: Update comments
References: <20100401031735.683626160@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Update-comments.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

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
-- 
1.7.0


