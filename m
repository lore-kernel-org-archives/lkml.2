Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab0CXC5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:57:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56635 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab0CXC5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:57:21 -0400
Message-ID: <4BA97FD0.7090202@cn.fujitsu.com>
Date: Wed, 24 Mar 2010 10:58:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tracing: Update comments
References: <4BA97FA7.6040406@cn.fujitsu.com>
In-Reply-To: <4BA97FA7.6040406@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make some comments consistent with the code.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.6.3

