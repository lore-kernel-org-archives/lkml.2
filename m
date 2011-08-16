Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1HPVqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:46:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39815 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab1HPVq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:46:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=Psbwn+KPLSM82Ad5Wk/fNdc1pzIUWhJAUNUvGAKiwG9e5o0kyepnUfKr/wCK5LRwP
	FhP+kDUXELKd60mmSYM1Q==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH v2 1/5] trace: Add a new readonly entry to report total buffer size
Date: Tue, 16 Aug 2011 14:46:15 -0700
Message-Id: <1313531179-9323-2-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current file "buffer_size_kb" reports the size of per-cpu buffer and
not the overall memory allocated which could be misleading. A new file
"buffer_total_size_kb" adds up all the enabled CPU buffer sizes and
reports it. This is only a readonly entry.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
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
1.7.3.1

