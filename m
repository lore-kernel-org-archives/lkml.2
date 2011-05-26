Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab1EZSR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:17:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:19213 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758356Ab1EZSRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:17:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=S9bpPOimuZlkjBZw+wHvYbf4EoBBP6RsF+7dBlhNsMytNQ93cvhOptisTEYfyuPFm
	jHUMr4jCmsZm/6sgFh0VQ==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH v2] trace: Add a free on close control mechanism for buffer_size_kb
Date: Thu, 26 May 2011 11:16:50 -0700
Message-Id: <1306433810-15091-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1304118968-6620-1-git-send-email-vnagarnaik@google.com>
References: <1304118968-6620-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The proc file entry buffer_size_kb is used to set the size of tracing
buffer. The memory to expand the buffer size is kernel memory. Consider
a use case where tracing is handled by a user space utility, which acts
as a gate keeper for tracing requests. In an OOM condition, tracing is
considered a low priority task and if the utility gets killed the ring
buffer memory cannot be released back to the kernel.

This patch adds an IOCTL on the buffer_size_kb file to set a boolean.
When this boolean is enabled, closing buffer_size_kb file will cause
tracing to stop and free up the ring buffer memory.

The user space process can then open the buffer_size_kb file to set the
new buffer size for tracing, enable the boolean through IOCTL and keep
the file open. Under OOM condition, if the process gets killed, the
kernel closes the file descriptor for buffer_size_kb. The release
handler stops the tracing and releases the kernel memory automatically.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
Changelog:
v2-v1
* Fixed the return value according to comments

 include/linux/ftrace.h |    3 +
 kernel/trace/trace.c   |  137 +++++++++++++++++++++++++++++++++++-------------
 2 files changed, 104 insertions(+), 36 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9d88e1c..72a2f0d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -127,6 +127,9 @@ struct ftrace_func_command {
 					char *params, int enable);
 };
 
+/* enable/disable auto free ring buffer on file close */
+#define TRACE_RINGBUF_FREE_ON_CLOSE _IOW('t', 0x01, int)
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 int ftrace_arch_code_modify_prepare(void);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee9c921..6335e75 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2767,7 +2767,7 @@ int tracer_init(struct tracer *t, struct trace_array *tr)
 	return t->init(tr);
 }
 
-static int tracing_resize_ring_buffer(unsigned long size)
+static int __tracing_resize_ring_buffer(unsigned long size)
 {
 	int ret;
 
@@ -2819,6 +2819,38 @@ static int tracing_resize_ring_buffer(unsigned long size)
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
@@ -2836,7 +2868,7 @@ int tracing_update_buffers(void)
 
 	mutex_lock(&trace_types_lock);
 	if (!ring_buffer_expanded)
-		ret = tracing_resize_ring_buffer(trace_buf_size);
+		ret = __tracing_resize_ring_buffer(trace_buf_size);
 	mutex_unlock(&trace_types_lock);
 
 	return ret;
@@ -2860,7 +2892,7 @@ static int tracing_set_tracer(const char *buf)
 	mutex_lock(&trace_types_lock);
 
 	if (!ring_buffer_expanded) {
-		ret = tracing_resize_ring_buffer(trace_buf_size);
+		ret = __tracing_resize_ring_buffer(trace_buf_size);
 		if (ret < 0)
 			goto out;
 		ret = 0;
@@ -3409,11 +3441,37 @@ out_err:
 	goto out;
 }
 
+struct ftrace_entries_info {
+	struct trace_array	*tr;
+	int			free_buffer_on_close;
+};
+
+static int
+tracing_entries_open(struct inode *inode, struct file *filp)
+{
+	struct ftrace_entries_info *info;
+
+	if (tracing_disabled)
+		return -ENODEV;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->tr = (struct trace_array *)inode->i_private;
+	info->free_buffer_on_close = 0;
+
+	filp->private_data = info;
+
+	return 0;
+}
+
 static ssize_t
 tracing_entries_read(struct file *filp, char __user *ubuf,
 		     size_t cnt, loff_t *ppos)
 {
-	struct trace_array *tr = filp->private_data;
+	struct ftrace_entries_info *info = filp->private_data;
+	struct trace_array *tr = info->tr;
 	char buf[96];
 	int r;
 
@@ -3435,7 +3493,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 {
 	unsigned long val;
 	char buf[64];
-	int ret, cpu;
+	int ret;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -3453,46 +3511,50 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	if (!val)
 		return -EINVAL;
 
-	mutex_lock(&trace_types_lock);
+	/* value is in KB */
+	val <<= 10;
 
-	tracing_stop();
+	ret = tracing_resize_ring_buffer(val);
+	if (ret < 0)
+		return ret;
 
-	/* disable all cpu buffers */
-	for_each_tracing_cpu(cpu) {
-		if (global_trace.data[cpu])
-			atomic_inc(&global_trace.data[cpu]->disabled);
-		if (max_tr.data[cpu])
-			atomic_inc(&max_tr.data[cpu]->disabled);
-	}
+	*ppos += cnt;
 
-	/* value is in KB */
-	val <<= 10;
+	return cnt;
+}
 
-	if (val != global_trace.entries) {
-		ret = tracing_resize_ring_buffer(val);
-		if (ret < 0) {
-			cnt = ret;
-			goto out;
-		}
+static long
+tracing_entries_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	int ret = -ENOIOCTLCMD;
+	struct ftrace_entries_info *info = filp->private_data;
+
+	switch (cmd) {
+	case TRACE_RINGBUF_FREE_ON_CLOSE: {
+		info->free_buffer_on_close = !!arg;
+		ret = 0;
+		break;
+	}
 	}
 
-	*ppos += cnt;
+	return ret;
+}
 
-	/* If check pages failed, return ENOMEM */
-	if (tracing_disabled)
-		cnt = -ENOMEM;
- out:
-	for_each_tracing_cpu(cpu) {
-		if (global_trace.data[cpu])
-			atomic_dec(&global_trace.data[cpu]->disabled);
-		if (max_tr.data[cpu])
-			atomic_dec(&max_tr.data[cpu]->disabled);
+static int
+tracing_entries_release(struct inode *inode, struct file *filp)
+{
+	struct ftrace_entries_info *info = filp->private_data;
+
+	if (info->free_buffer_on_close) {
+		/* disable tracing */
+		tracing_off();
+		/* resize the ring buffer to 0 */
+		tracing_resize_ring_buffer(0);
 	}
 
-	tracing_start();
-	mutex_unlock(&trace_types_lock);
+	kfree(info);
 
-	return cnt;
+	return 0;
 }
 
 static int mark_printk(const char *fmt, ...)
@@ -3634,9 +3696,12 @@ static const struct file_operations tracing_pipe_fops = {
 };
 
 static const struct file_operations tracing_entries_fops = {
-	.open		= tracing_open_generic,
+	.open		= tracing_entries_open,
 	.read		= tracing_entries_read,
 	.write		= tracing_entries_write,
+	.unlocked_ioctl	= tracing_entries_ioctl,
+	.compat_ioctl	= tracing_entries_ioctl,
+	.release	= tracing_entries_release,
 	.llseek		= generic_file_llseek,
 };
 
-- 
1.7.3.1

