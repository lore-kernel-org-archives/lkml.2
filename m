Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1DTQAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:00:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35382 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab1DTQAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:00:34 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=vhdKIqpQuCYA:10 a=NN3dVZqmgpIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=pc_eyObelX_Hb3W4ZDIA:9 a=g9WCVhkPnjGQwvDdFCQA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=mK4YuaWWMZrgA5sm:21 a=yYdysxRdVOkCkuKu:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110420160030.571278817@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 11:58:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 2/6] tracing: Print trace_bprintk() formats for modules too
References: <20110420155838.640017971@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Print-trace_bprintk-formats-for-modules-too.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The file debugfs/tracing/printk_formats maps the addresses
to the formats that are used by trace_bprintk() so that userspace
tools can read the buffer and be able to decode trace_bprintk events
to get the format saved when reading the ring buffer directly.

This is because trace_bprintk() does not store the format into the
buffer, but just the address of the format, which is hidden in
the kernel memory.

But currently it only exports trace_bprintk()s from the kernel core
and not for modules. The modules need their formats exported
as well.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_printk.c |  103 ++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 97 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index b8b2681..dff763b 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -89,6 +89,76 @@ static int module_trace_bprintk_format_notify(struct notifier_block *self,
 	return 0;
 }
 
+/*
+ * The debugfs/tracing/printk_formats file maps the addresses with
+ * the ASCII formats that are used in the bprintk events in the
+ * buffer. For userspace tools to be able to decode the events from
+ * the buffer, they need to be able to map the address with the format.
+ *
+ * The addresses of the bprintk formats are in their own section
+ * __trace_printk_fmt. But for modules we copy them into a link list.
+ * The code to print the formats and their addresses passes around the
+ * address of the fmt string. If the fmt address passed into the seq
+ * functions is within the kernel core __trace_printk_fmt section, then
+ * it simply uses the next pointer in the list.
+ *
+ * When the fmt pointer is outside the kernel core __trace_printk_fmt
+ * section, then we need to read the link list pointers. The trick is
+ * we pass the address of the string to the seq function just like
+ * we do for the kernel core formats. To get back the structure that
+ * holds the format, we simply use containerof() and then go to the
+ * next format in the list.
+ */
+static const char **
+find_next_mod_format(int start_index, void *v, const char **fmt, loff_t *pos)
+{
+	struct trace_bprintk_fmt *mod_fmt;
+
+	if (list_empty(&trace_bprintk_fmt_list))
+		return NULL;
+
+	/*
+	 * v will point to the address of the fmt record from t_next
+	 * v will be NULL from t_start.
+	 * If this is the first pointer or called from start
+	 * then we need to walk the list.
+	 */
+	if (!v || start_index == *pos) {
+		struct trace_bprintk_fmt *p;
+
+		/* search the module list */
+		list_for_each_entry(p, &trace_bprintk_fmt_list, list) {
+			if (start_index == *pos)
+				return &p->fmt;
+			start_index++;
+		}
+		/* pos > index */
+		return NULL;
+	}
+
+	/*
+	 * v points to the address of the fmt field in the mod list
+	 * structure that holds the module print format.
+	 */
+	mod_fmt = container_of(v, typeof(*mod_fmt), fmt);
+	if (mod_fmt->list.next == &trace_bprintk_fmt_list)
+		return NULL;
+
+	mod_fmt = container_of(mod_fmt->list.next, typeof(*mod_fmt), list);
+
+	return &mod_fmt->fmt;
+}
+
+static void format_mod_start(void)
+{
+	mutex_lock(&btrace_mutex);
+}
+
+static void format_mod_stop(void)
+{
+	mutex_unlock(&btrace_mutex);
+}
+
 #else /* !CONFIG_MODULES */
 __init static int
 module_trace_bprintk_format_notify(struct notifier_block *self,
@@ -96,6 +166,13 @@ module_trace_bprintk_format_notify(struct notifier_block *self,
 {
 	return 0;
 }
+static inline const char **
+find_next_mod_format(int start_index, void *v, const char **fmt, loff_t *pos)
+{
+	return NULL;
+}
+static inline void format_mod_start(void) { }
+static inline void format_mod_stop(void) { }
 #endif /* CONFIG_MODULES */
 
 
@@ -158,20 +235,33 @@ int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
 }
 EXPORT_SYMBOL_GPL(__ftrace_vprintk);
 
+static const char **find_next(void *v, loff_t *pos)
+{
+	const char **fmt = v;
+	int start_index;
+
+	if (!fmt)
+		fmt = __start___trace_bprintk_fmt + *pos;
+
+	start_index = __stop___trace_bprintk_fmt - __start___trace_bprintk_fmt;
+
+	if (*pos < start_index)
+		return fmt;
+
+	return find_next_mod_format(start_index, v, fmt, pos);
+}
+
 static void *
 t_start(struct seq_file *m, loff_t *pos)
 {
-	const char **fmt = __start___trace_bprintk_fmt + *pos;
-
-	if ((unsigned long)fmt >= (unsigned long)__stop___trace_bprintk_fmt)
-		return NULL;
-	return fmt;
+	format_mod_start();
+	return find_next(NULL, pos);
 }
 
 static void *t_next(struct seq_file *m, void * v, loff_t *pos)
 {
 	(*pos)++;
-	return t_start(m, pos);
+	return find_next(v, pos);
 }
 
 static int t_show(struct seq_file *m, void *v)
@@ -210,6 +300,7 @@ static int t_show(struct seq_file *m, void *v)
 
 static void t_stop(struct seq_file *m, void *p)
 {
+	format_mod_stop();
 }
 
 static const struct seq_operations show_format_seq_ops = {
-- 
1.7.2.3


