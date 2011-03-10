Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1CJQCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:02:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1CJP7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:11 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=1co8koQfrx4A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=ZSGOrMa819lkr62Bis8A:9 a=jdqNSAsR1Hg09uRXWf0A:7 a=9drF1atrBAz9ZHuJ11cwKoxbuDcA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155909.702154861@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 03/15] tracing: Remove lock_depth from event entry
References: <20110310155800.478792851@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Remove-lock_depth-from-event-entry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The lock_depth field in the event headers was added as a temporary
data point for help in removing the BKL. Now that the BKL is pretty
much been removed, we can remove this field.

This in turn changes the header from 12 bytes to 8 bytes,
removing the 4 byte buffer that gcc would insert if the first field
in the data load was 8 bytes in size.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    1 -
 kernel/trace/trace.c         |    8 +++-----
 kernel/trace/trace_events.c  |    1 -
 kernel/trace/trace_output.c  |   10 ++--------
 4 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 1a99e79..22b32af 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -37,7 +37,6 @@ struct trace_entry {
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
-	int			lock_depth;
 };
 
 #define FTRACE_MAX_EVENT						\
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 85e3ee1..fd6e1b9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1101,7 +1101,6 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 
 	entry->preempt_count		= pc & 0xff;
 	entry->pid			= (tsk) ? tsk->pid : 0;
-	entry->lock_depth		= (tsk) ? tsk->lock_depth : 0;
 	entry->flags =
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
@@ -1748,10 +1747,9 @@ static void print_lat_help_header(struct seq_file *m)
 	seq_puts(m, "#                | / _----=> need-resched    \n");
 	seq_puts(m, "#                || / _---=> hardirq/softirq \n");
 	seq_puts(m, "#                ||| / _--=> preempt-depth   \n");
-	seq_puts(m, "#                |||| /_--=> lock-depth       \n");
-	seq_puts(m, "#                |||||/     delay             \n");
-	seq_puts(m, "#  cmd     pid   |||||| time  |   caller      \n");
-	seq_puts(m, "#     \\   /      ||||||   \\   |   /           \n");
+	seq_puts(m, "#                |||| /     delay             \n");
+	seq_puts(m, "#  cmd     pid   ||||| time  |   caller      \n");
+	seq_puts(m, "#     \\   /      |||||  \\    |   /           \n");
 }
 
 static void print_func_help_header(struct seq_file *m)
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 5f499e0..e1d579b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -116,7 +116,6 @@ static int trace_define_common_fields(void)
 	__common_field(unsigned char, flags);
 	__common_field(unsigned char, preempt_count);
 	__common_field(int, pid);
-	__common_field(int, lock_depth);
 
 	return ret;
 }
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 02272ba..151f32e 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -529,7 +529,7 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
  * @entry: The trace entry field from the ring buffer
  *
  * Prints the generic fields of irqs off, in hard or softirq, preempt
- * count and lock depth.
+ * count.
  */
 int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 {
@@ -554,13 +554,7 @@ int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 	else
 		ret = trace_seq_putc(s, '.');
 
-	if (!ret)
-		return 0;
-
-	if (entry->lock_depth < 0)
-		return trace_seq_putc(s, '.');
-
-	return trace_seq_printf(s, "%d", entry->lock_depth);
+	return ret;
 }
 
 static int
-- 
1.7.2.3


