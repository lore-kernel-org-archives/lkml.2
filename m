Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1IVWLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:11:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab1IVWKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:33 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=GzBEd_g_Rr8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ZZoUqqbgIFapVa-vX_4A:9 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221028.698511684@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>
Subject: [PATCH 15/21] trace: Add a new readonly entry to report total buffer size
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0015-trace-Add-a-new-readonly-entry-to-report-total-buffe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

The current file "buffer_size_kb" reports the size of per-cpu buffer and
not the overall memory allocated which could be misleading. A new file
"buffer_total_size_kb" adds up all the enabled CPU buffer sizes and
reports it. This is only a readonly entry.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: David Sharp <dhsharp@google.com>
Link: http://lkml.kernel.org/r/1313531179-9323-2-git-send-email-vnagarnaik@google.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e5df02c..0117678 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3569,6 +3569,30 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 }
 
 static ssize_t
+tracing_total_entries_read(struct file *filp, char __user *ubuf,
+				size_t cnt, loff_t *ppos)
+{
+	struct trace_array *tr = filp->private_data;
+	char buf[64];
+	int r, cpu;
+	unsigned long size = 0, expanded_size = 0;
+
+	mutex_lock(&trace_types_lock);
+	for_each_tracing_cpu(cpu) {
+		size += tr->entries >> 10;
+		if (!ring_buffer_expanded)
+			expanded_size += trace_buf_size >> 10;
+	}
+	if (ring_buffer_expanded)
+		r = sprintf(buf, "%lu\n", size);
+	else
+		r = sprintf(buf, "%lu (expanded: %lu)\n", size, expanded_size);
+	mutex_unlock(&trace_types_lock);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
 tracing_free_buffer_write(struct file *filp, const char __user *ubuf,
 			  size_t cnt, loff_t *ppos)
 {
@@ -3739,6 +3763,12 @@ static const struct file_operations tracing_entries_fops = {
 	.llseek		= generic_file_llseek,
 };
 
+static const struct file_operations tracing_total_entries_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_total_entries_read,
+	.llseek		= generic_file_llseek,
+};
+
 static const struct file_operations tracing_free_buffer_fops = {
 	.write		= tracing_free_buffer_write,
 	.release	= tracing_free_buffer_release,
@@ -4450,6 +4480,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("buffer_size_kb", 0644, d_tracer,
 			&global_trace, &tracing_entries_fops);
 
+	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
+			&global_trace, &tracing_total_entries_fops);
+
 	trace_create_file("free_buffer", 0644, d_tracer,
 			&global_trace, &tracing_free_buffer_fops);
 
-- 
1.7.5.4


