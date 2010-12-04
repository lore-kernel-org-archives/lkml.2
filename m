Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0LDANq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:13:46 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58442 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab0LDANp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:13:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=qRvi3tJFMqI2fUHcn1IPHvKEh+xseibWS1vTzi864P0z0NoyNUJlG8S1CiLEnWdPk
	bBvOaGmXB3gCkWvecllrA==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, Jiaying Zhang <jiayingz@google.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 01/15] tracing: Add a 'buffer_overwrite' debugfs file
Date: Fri,  3 Dec 2010 16:13:15 -0800
Message-Id: <1291421609-14665-2-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiaying Zhang <jiayingz@google.com>

Add a "buffer_overwrite" debugfs file for ftrace to control whether the buffer
should be overwritten on overflow or not. The default remains to overwrite old
events when the buffer is full. This patch adds the option to instead discard
newest events when the buffer is full. This is useful to get a snapshot of
traces just after enabling traces. Dropping the current event is also a simpler
code path.

Signed-off-by: David Sharp <dhsharp@google.com>
---
 Documentation/trace/ftrace.txt |    6 ++++
 include/linux/ring_buffer.h    |    2 +
 kernel/trace/ring_buffer.c     |   11 +++++++
 kernel/trace/trace.c           |   59 +++++++++++++++++++++++++++++++++++++---
 4 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 557c1ed..9237da3 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -138,6 +138,12 @@ of ftrace. Here is a list of some of the key files:
 	This can only be updated when the current_tracer
 	is set to "nop".
 
+  buffer_overwrite:
+
+	This controls what happens when the trace buffer is full.
+	If "1" (default), the oldest events are discarded and 
+	overwritten. If "0", then the newest events are discarded.
+
   tracing_cpumask:
 
 	This is a mask that lets the user only trace
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 8d3a248..ab38ac8 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -100,6 +100,8 @@ void ring_buffer_free(struct ring_buffer *buffer);
 
 int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size);
 
+void ring_buffer_change_overwrite(struct ring_buffer *buffer, int val);
+
 struct ring_buffer_event *ring_buffer_lock_reserve(struct ring_buffer *buffer,
 						   unsigned long length);
 int ring_buffer_unlock_commit(struct ring_buffer *buffer,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9ed509a..3207147 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1429,6 +1429,17 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_resize);
 
+void ring_buffer_change_overwrite(struct ring_buffer *buffer, int val)
+{
+	mutex_lock(&buffer->mutex);
+	if (val)
+		buffer->flags |= RB_FL_OVERWRITE;
+	else
+		buffer->flags &= ~RB_FL_OVERWRITE;
+	mutex_unlock(&buffer->mutex);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_change_overwrite);
+
 static inline void *
 __rb_data_page_index(struct buffer_data_page *bpage, unsigned index)
 {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c380612..ed5c14f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -41,8 +41,6 @@
 #include "trace.h"
 #include "trace_output.h"
 
-#define TRACE_BUFFER_FLAGS	(RB_FL_OVERWRITE)
-
 /*
  * On boot up, the ring buffer is set to the minimum size, so that
  * we do not waste memory on systems that are not using tracing.
@@ -241,6 +239,9 @@ int tracing_is_enabled(void)
 
 static unsigned long		trace_buf_size = TRACE_BUF_SIZE_DEFAULT;
 
+/* whether the trace buffer should be overwritten on overflow or not. */
+static enum ring_buffer_flags  trace_buffer_flags = RB_FL_OVERWRITE;
+
 /* trace_types holds a link list of available tracers. */
 static struct tracer		*trace_types __read_mostly;
 
@@ -3466,6 +3467,47 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static ssize_t
+tracing_overwrite_read(struct file *filp, char __user *ubuf,
+		     size_t cnt, loff_t *ppos)
+{
+	char buf[64];
+	int r;
+	r = snprintf(buf, 64, "%u\n", trace_buffer_flags);
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
+tracing_overwrite_write(struct file *filp, const char __user *ubuf,
+		      size_t cnt, loff_t *ppos)
+{
+	unsigned long val;
+	char buf[64];
+	int ret;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+	*ppos += cnt;
+
+	if (val != 0 && val != 1)
+		return -EINVAL;
+
+	if (trace_buffer_flags != val) {
+		trace_buffer_flags = val;
+		ring_buffer_change_overwrite(global_trace.buffer, val);
+	}
+	return cnt;
+}
+
 static int mark_printk(const char *fmt, ...)
 {
 	int ret;
@@ -3611,6 +3653,12 @@ static const struct file_operations tracing_entries_fops = {
 	.llseek		= generic_file_llseek,
 };
 
+static const struct file_operations tracing_overwrite_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_overwrite_read,
+	.write		= tracing_overwrite_write,
+};
+
 static const struct file_operations tracing_mark_fops = {
 	.open		= tracing_open_generic,
 	.write		= tracing_mark_write,
@@ -4336,6 +4384,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("buffer_size_kb", 0644, d_tracer,
 			&global_trace, &tracing_entries_fops);
 
+	trace_create_file("buffer_overwrite", 0644, d_tracer,
+			&global_trace, &tracing_overwrite_fops);
+
 	trace_create_file("trace_marker", 0220, d_tracer,
 			NULL, &tracing_mark_fops);
 
@@ -4565,7 +4616,7 @@ __init static int tracer_alloc_buffers(void)
 
 	/* TODO: make the number of buffers hot pluggable with CPUS */
 	global_trace.buffer = ring_buffer_alloc(ring_buf_size,
-						   TRACE_BUFFER_FLAGS);
+						   trace_buffer_flags);
 	if (!global_trace.buffer) {
 		printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
 		WARN_ON(1);
@@ -4575,7 +4626,7 @@ __init static int tracer_alloc_buffers(void)
 
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-	max_tr.buffer = ring_buffer_alloc(1, TRACE_BUFFER_FLAGS);
+	max_tr.buffer = ring_buffer_alloc(1, trace_buffer_flags);
 	if (!max_tr.buffer) {
 		printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
 		WARN_ON(1);
-- 
1.7.3.1

