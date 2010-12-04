Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0LDAPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:15:38 -0500
Received: from smtp-out.google.com ([74.125.121.35]:16979 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab0LDANw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:13:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=TmXHYBfUe99jk/nwzMEU4y2VS+Z2swhVJZ3Jh2AoH6zqV1ZlBM0/RABSTMWbLlro3
	BS1z/PTc3zliFxtY813nA==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH 14/15] small_traces: Remove trace output of large fields.
Date: Fri,  3 Dec 2010 16:13:28 -0800
Message-Id: <1291421609-14665-15-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Google-Bug-Id: 3224547

Signed-off-by: David Sharp <dhsharp@google.com>
---
 kernel/trace/trace.c        |    6 ++++++
 kernel/trace/trace_output.c |   18 ++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ed5c14f..177d4e5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1747,6 +1747,7 @@ static void s_stop(struct seq_file *m, void *p)
 
 static void print_lat_help_header(struct seq_file *m)
 {
+#ifndef CONFIG_SMALL_TRACES
 	seq_puts(m, "#                  _------=> CPU#            \n");
 	seq_puts(m, "#                 / _-----=> irqs-off        \n");
 	seq_puts(m, "#                | / _----=> need-resched    \n");
@@ -1756,6 +1757,11 @@ static void print_lat_help_header(struct seq_file *m)
 	seq_puts(m, "#                |||||/     delay             \n");
 	seq_puts(m, "#  cmd     pid   |||||| time  |   caller      \n");
 	seq_puts(m, "#     \\   /      ||||||   \\   |   /           \n");
+#else
+	seq_puts(m, "#               CPU#   delay             \n");
+	seq_puts(m, "#  cmd     pid   | time  |   caller      \n");
+	seq_puts(m, "#     \\   /      |   \\   |   /           \n");
+#endif
 }
 
 static void print_func_help_header(struct seq_file *m)
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 9e33b1f..d5d7575 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -531,6 +531,7 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
  * Prints the generic fields of irqs off, in hard or softirq, preempt
  * count and lock depth.
  */
+#ifndef CONFIG_SMALL_TRACES
 int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 {
 	int ret;
@@ -566,6 +567,12 @@ int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 
 	return trace_seq_printf(s, "%d", entry->lock_depth);
 }
+#else
+int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
+{
+	return 1;
+}
+#endif
 
 static int
 lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
@@ -628,6 +635,7 @@ int trace_print_lat_context(struct trace_iterator *iter)
 
 		trace_find_cmdline(entry->pid, comm);
 
+#ifndef CONFIG_SMALL_TRACES
 		ret = trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08llx]"
 				       " %ld.%03ldms (+%ld.%03ldms): ", comm,
 				       entry->pid, iter->cpu, entry->flags,
@@ -637,6 +645,16 @@ int trace_print_lat_context(struct trace_iterator *iter)
 				       abs_usecs % USEC_PER_MSEC,
 				       rel_usecs / USEC_PER_MSEC,
 				       rel_usecs % USEC_PER_MSEC);
+#else
+		ret = trace_seq_printf(s, "%16s %5d %3d %08lx [%08llx]"
+				       " %ld.%03ldms (+%ld.%03ldms): ", comm,
+				       entry->pid, iter->cpu, iter->idx,
+				       ns2usecs(iter->ts),
+				       abs_usecs / USEC_PER_MSEC,
+				       abs_usecs % USEC_PER_MSEC,
+				       rel_usecs / USEC_PER_MSEC,
+				       rel_usecs % USEC_PER_MSEC);
+#endif
 	} else {
 		ret = lat_print_generic(s, entry, iter->cpu);
 		if (ret)
-- 
1.7.3.1

