Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183Ab2HJDrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 23:47:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27311 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab2HJDrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 23:47:09 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=_wxSFJxKOogA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=NK2P5TpvuAyqg8U-CD0A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120810034707.378538034@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 09 Aug 2012 23:43:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 1/4] tracing: Move print code from macro to standalone function
References: <20120810034302.758092203@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Move-print-code-from-macro-to-standalone-fun.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code for trace events to format the raw recorded event data
into human readable format in the 'trace' file is repeated for every
event in the system. When you have over 700 events, this can add up
quite a bit.

By making helper functions in the core kernel to do the work
instead, we can shrink the size of the kernel down a bit.

With a kernel configured with 707 events, the change in size was:

   text    data     bss     dec     hex filename
20016471        2594648 1945600 24556719        176b4af vmlinux-before
19994715        2594648 1945600 24534963        1765fb3 vmlinux-after

That's a total of 21756 bytes, which comes down to 30 bytes per event.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    5 +++++
 include/trace/ftrace.h       |   21 ++------------------
 kernel/trace/trace_output.c  |   44 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index af961d6..56d1e53 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -139,6 +139,11 @@ void trace_current_buffer_discard_commit(struct ring_buffer *buffer,
 
 void tracing_record_cmdline(struct task_struct *tsk);
 
+int ftrace_output_event(struct trace_iterator *iter, struct ftrace_event_call *event,
+			char *fmt, ...);
+
+int ftrace_output_call(struct trace_iterator *iter, char *name, char *fmt, ...);
+
 struct event_filter;
 
 enum trace_reg {
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index c6bc2fa..cb85747 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -228,11 +228,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 			 struct trace_event *trace_event)		\
 {									\
 	struct ftrace_event_call *event;				\
-	struct trace_seq *s = &iter->seq;				\
 	struct ftrace_raw_##call *field;				\
 	struct trace_entry *entry;					\
 	struct trace_seq *p = &iter->tmp_seq;				\
-	int ret;							\
 									\
 	event = container_of(trace_event, struct ftrace_event_call,	\
 			     event);					\
@@ -245,15 +243,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 	}								\
 									\
 	field = (typeof(field))entry;					\
-									\
 	trace_seq_init(p);						\
-	ret = trace_seq_printf(s, "%s: ", event->name);			\
-	if (ret)							\
-		ret = trace_seq_printf(s, print);			\
-	if (!ret)							\
-		return TRACE_TYPE_PARTIAL_LINE;				\
-									\
-	return TRACE_TYPE_HANDLED;					\
+	return ftrace_output_event(iter, event, print);			\
 }									\
 static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 	.trace			= ftrace_raw_output_##call,		\
@@ -265,11 +256,9 @@ static notrace enum print_line_t					\
 ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 			 struct trace_event *event)			\
 {									\
-	struct trace_seq *s = &iter->seq;				\
 	struct ftrace_raw_##template *field;				\
 	struct trace_entry *entry;					\
 	struct trace_seq *p = &iter->tmp_seq;				\
-	int ret;							\
 									\
 	entry = iter->ent;						\
 									\
@@ -281,13 +270,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 	field = (typeof(field))entry;					\
 									\
 	trace_seq_init(p);						\
-	ret = trace_seq_printf(s, "%s: ", #call);			\
-	if (ret)							\
-		ret = trace_seq_printf(s, print);			\
-	if (!ret)							\
-		return TRACE_TYPE_PARTIAL_LINE;				\
-									\
-	return TRACE_TYPE_HANDLED;					\
+	return ftrace_output_call(iter, #call, print);			\
 }									\
 static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 	.trace			= ftrace_raw_output_##call,		\
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 123b189..b927f45 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -397,6 +397,50 @@ ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
 }
 EXPORT_SYMBOL(ftrace_print_hex_seq);
 
+static int ftrace_output_raw(struct trace_iterator *iter, char *name,
+			     char *fmt, va_list ap)
+{
+	struct trace_seq *s = &iter->seq;
+	int ret;
+
+	ret = trace_seq_printf(s, "%s: ", name);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	ret = trace_seq_vprintf(s, fmt, ap);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
+int ftrace_output_call(struct trace_iterator *iter, char *name, char *fmt, ...)
+{
+	va_list ap;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = ftrace_output_raw(iter, name, fmt, ap);
+	va_end(ap);
+
+	return ret;
+}
+
+int ftrace_output_event(struct trace_iterator *iter, struct ftrace_event_call *event,
+			char *fmt, ...)
+{
+	va_list ap;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = ftrace_output_raw(iter, event->name, fmt, ap);
+	va_end(ap);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ftrace_output_event);
+
 #ifdef CONFIG_KRETPROBES
 static inline const char *kretprobed(const char *name)
 {
-- 
1.7.10.4


