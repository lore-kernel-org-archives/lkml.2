Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1FMXOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:14:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23639 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab1FMXON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:14:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=w/2fwFyI92jM96dchM5kI6m2ufmS4KgXk12L2u/xji7OqS5ksSihaXIYkJ1dKBSii
	AXvG3ufXQRkbEdHa/U4zQ==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH] trace: Add a proc file to stop tracing and free buffer
Date: Mon, 13 Jun 2011 16:13:51 -0700
Message-Id: <1308006831-6219-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The proc file entry buffer_size_kb is used to set the size of tracing
buffer. The memory to expand the buffer size is kernel memory. Consider
a use case where tracing is handled by a user space utility, which acts
as a gate keeper for tracing requests. In an OOM condition, tracing is
considered a low priority task and if the utility gets killed the ring
buffer memory cannot be released back to the kernel.

This patch adds a proc file called "free_ring_buffer" whose whole
purpose is to stop tracing and free up the ring buffer when it is
closed.

The user space process can then set the desired size in buffer_size_kb
file and open the fd to the "free_ring_buffer" file. Under OOM
condition, if the process gets killed, the kernel closes the file
descriptor. The release handler stops the tracing and releases the
kernel memory automatically.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 kernel/trace/trace.c |  108 +++++++++++++++++++++++++++++++++----------------
 1 files changed, 73 insertions(+), 35 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee9c921..3df944c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2767,7 +2767,7 @@ int tracer_init(struct tracer *t, struct trace_array *tr)
 	return t->init(tr);
 }
 
-static int tracing_resize_ring_buffer(unsigned long size)
+static int __tracing_resize_ring_buffer(unsigned long size)
 {
 	int ret;
 
@@ -2819,6 +2819,41 @@ static int tracing_resize_ring_buffer(unsigned long size)
 	return ret;
 }
 
+static ssize_t tracing_resize_ring_buffer(unsigned long size)
+{
+	int cpu, ret = size;
+
+	mutex_lock(&trace_types_lock);
+
+	tracing_stop();
+
+	/* disable all cpu buffers */
+	for_each_tracing_cpu(cpu) {
+		if (global_trace.data[cpu])
+			atomic_inc(&global_trace.data[cpu]->disabled);
+		if (max_tr.data[cpu])
+			atomic_inc(&max_tr.data[cpu]->disabled);
+	}
+
+	if (size != global_trace.entries)
+		ret = __tracing_resize_ring_buffer(size);
+
+	if (ret < 0)
+		ret = -ENOMEM;
+
+	for_each_tracing_cpu(cpu) {
+		if (global_trace.data[cpu])
+			atomic_dec(&global_trace.data[cpu]->disabled);
+		if (max_tr.data[cpu])
+			atomic_dec(&max_tr.data[cpu]->disabled);
+	}
+
+	tracing_start();
+	mutex_unlock(&trace_types_lock);
+
+	return ret;
+}
+
 
 /**
  * tracing_update_buffers - used by tracing facility to expand ring buffers
@@ -2836,7 +2871,7 @@ int tracing_update_buffers(void)
 
 	mutex_lock(&trace_types_lock);
 	if (!ring_buffer_expanded)
-		ret = tracing_resize_ring_buffer(trace_buf_size);
+		ret = __tracing_resize_ring_buffer(trace_buf_size);
 	mutex_unlock(&trace_types_lock);
 
 	return ret;
@@ -2860,7 +2895,7 @@ static int tracing_set_tracer(const char *buf)
 	mutex_lock(&trace_types_lock);
 
 	if (!ring_buffer_expanded) {
-		ret = tracing_resize_ring_buffer(trace_buf_size);
+		ret = __tracing_resize_ring_buffer(trace_buf_size);
 		if (ret < 0)
 			goto out;
 		ret = 0;
@@ -3435,7 +3470,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 {
 	unsigned long val;
 	char buf[64];
-	int ret, cpu;
+	int ret;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -3453,48 +3488,43 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	if (!val)
 		return -EINVAL;
 
-	mutex_lock(&trace_types_lock);
-
-	tracing_stop();
-
-	/* disable all cpu buffers */
-	for_each_tracing_cpu(cpu) {
-		if (global_trace.data[cpu])
-			atomic_inc(&global_trace.data[cpu]->disabled);
-		if (max_tr.data[cpu])
-			atomic_inc(&max_tr.data[cpu]->disabled);
-	}
-
 	/* value is in KB */
 	val <<= 10;
 
-	if (val != global_trace.entries) {
-		ret = tracing_resize_ring_buffer(val);
-		if (ret < 0) {
-			cnt = ret;
-			goto out;
-		}
-	}
+	ret = tracing_resize_ring_buffer(val);
+	if (ret < 0)
+		return ret;
 
 	*ppos += cnt;
 
-	/* If check pages failed, return ENOMEM */
-	if (tracing_disabled)
-		cnt = -ENOMEM;
- out:
-	for_each_tracing_cpu(cpu) {
-		if (global_trace.data[cpu])
-			atomic_dec(&global_trace.data[cpu]->disabled);
-		if (max_tr.data[cpu])
-			atomic_dec(&max_tr.data[cpu]->disabled);
-	}
+	return cnt;
+}
 
-	tracing_start();
-	mutex_unlock(&trace_types_lock);
+static ssize_t
+tracing_free_ring_buffer_write(struct file *filp, const char __user *ubuf,
+			  size_t cnt, loff_t *ppos)
+{
+	/*
+	 * There is no need to read what the user has written, this function
+	 * is just to make sure that there is no error when "echo" is used
+	 */
+
+	*ppos += cnt;
 
 	return cnt;
 }
 
+static int
+tracing_free_ring_buffer_release(struct inode *inode, struct file *filp)
+{
+	/* disable tracing */
+	tracing_off();
+	/* resize the ring buffer to 0 */
+	tracing_resize_ring_buffer(0);
+
+	return 0;
+}
+
 static int mark_printk(const char *fmt, ...)
 {
 	int ret;
@@ -3640,6 +3670,11 @@ static const struct file_operations tracing_entries_fops = {
 	.llseek		= generic_file_llseek,
 };
 
+static const struct file_operations tracing_free_ring_buffer_fops = {
+	.write		= tracing_free_ring_buffer_write,
+	.release	= tracing_free_ring_buffer_release,
+};
+
 static const struct file_operations tracing_mark_fops = {
 	.open		= tracing_open_generic,
 	.write		= tracing_mark_write,
@@ -4365,6 +4400,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("buffer_size_kb", 0644, d_tracer,
 			&global_trace, &tracing_entries_fops);
 
+	trace_create_file("free_ring_buffer", 0644, d_tracer,
+			&global_trace, &tracing_free_ring_buffer_fops);
+
 	trace_create_file("trace_marker", 0220, d_tracer,
 			NULL, &tracing_mark_fops);
 
-- 
1.7.3.1

