Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab1GEMuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:50:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:58273 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab1GEMuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:50:00 -0400
Date: Tue, 5 Jul 2011 12:49:51 GMT
From: tip-bot for Vaibhav Nagarnaik <vnagarnaik@google.com>
Message-ID: <tip-4f271a2a60c748599b30bb4dafff30d770439b96@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com, hpa@zytor.com,
        mingo@redhat.com, dhsharp@google.com, fweisbec@gmail.com,
        rostedt@goodmis.org, mrubin@google.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, vnagarnaik@google.com,
        linux-kernel@vger.kernel.org, dhsharp@google.com, fweisbec@gmail.com,
        rostedt@goodmis.org, mrubin@google.com, tglx@linutronix.de
In-Reply-To: <1308012717-11148-1-git-send-email-vnagarnaik@google.com>
References: <1308012717-11148-1-git-send-email-vnagarnaik@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Add a proc file to stop tracing and free buffer
Git-Commit-ID: 4f271a2a60c748599b30bb4dafff30d770439b96
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:49:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f271a2a60c748599b30bb4dafff30d770439b96
Gitweb:     http://git.kernel.org/tip/4f271a2a60c748599b30bb4dafff30d770439b96
Author:     Vaibhav Nagarnaik <vnagarnaik@google.com>
AuthorDate: Mon, 13 Jun 2011 17:51:57 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 14 Jun 2011 22:48:37 -0400

tracing: Add a proc file to stop tracing and free buffer

The proc file entry buffer_size_kb is used to set the size of tracing
buffer. The memory to expand the buffer size is kernel memory. Consider
a use case where tracing is handled by a user space utility, which acts
as a gate keeper for tracing requests. In an OOM condition, tracing is
considered a low priority task and if the utility gets killed the ring
buffer memory cannot be released back to the kernel.

This patch adds a proc file called "free_buffer" whose purpose is to
stop tracing and free up the ring buffer when it is closed.

The user space process can then set the desired size in buffer_size_kb
file and open the fd to the "free_buffer" file. Under OOM condition, if
the process gets killed, the kernel closes the file descriptor. The
release handler stops the tracing and releases the kernel memory
automatically.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Link: http://lkml.kernel.org/r/1308012717-11148-1-git-send-email-vnagarnaik@google.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |  108 +++++++++++++++++++++++++++++++++----------------
 1 files changed, 73 insertions(+), 35 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 61fda6b..9c557ae 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2768,7 +2768,7 @@ int tracer_init(struct tracer *t, struct trace_array *tr)
 	return t->init(tr);
 }
 
-static int tracing_resize_ring_buffer(unsigned long size)
+static int __tracing_resize_ring_buffer(unsigned long size)
 {
 	int ret;
 
@@ -2820,6 +2820,41 @@ static int tracing_resize_ring_buffer(unsigned long size)
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
@@ -2837,7 +2872,7 @@ int tracing_update_buffers(void)
 
 	mutex_lock(&trace_types_lock);
 	if (!ring_buffer_expanded)
-		ret = tracing_resize_ring_buffer(trace_buf_size);
+		ret = __tracing_resize_ring_buffer(trace_buf_size);
 	mutex_unlock(&trace_types_lock);
 
 	return ret;
@@ -2861,7 +2896,7 @@ static int tracing_set_tracer(const char *buf)
 	mutex_lock(&trace_types_lock);
 
 	if (!ring_buffer_expanded) {
-		ret = tracing_resize_ring_buffer(trace_buf_size);
+		ret = __tracing_resize_ring_buffer(trace_buf_size);
 		if (ret < 0)
 			goto out;
 		ret = 0;
@@ -3436,7 +3471,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 {
 	unsigned long val;
 	char buf[64];
-	int ret, cpu;
+	int ret;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -3454,48 +3489,43 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
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
+tracing_free_buffer_write(struct file *filp, const char __user *ubuf,
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
+tracing_free_buffer_release(struct inode *inode, struct file *filp)
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
@@ -3641,6 +3671,11 @@ static const struct file_operations tracing_entries_fops = {
 	.llseek		= generic_file_llseek,
 };
 
+static const struct file_operations tracing_free_buffer_fops = {
+	.write		= tracing_free_buffer_write,
+	.release	= tracing_free_buffer_release,
+};
+
 static const struct file_operations tracing_mark_fops = {
 	.open		= tracing_open_generic,
 	.write		= tracing_mark_write,
@@ -4365,6 +4400,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("buffer_size_kb", 0644, d_tracer,
 			&global_trace, &tracing_entries_fops);
 
+	trace_create_file("free_buffer", 0644, d_tracer,
+			&global_trace, &tracing_free_buffer_fops);
+
 	trace_create_file("trace_marker", 0220, d_tracer,
 			NULL, &tracing_mark_fops);
 
