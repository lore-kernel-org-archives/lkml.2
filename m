Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab0FVNXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 09:23:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37500 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab0FVNXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 09:23:08 -0400
X-Authority-Analysis: v=1.1 cv=zLGBfXKW/yOQN1c4qTdQUWouaSiWOaUUjRgOJi1LSJI= c=1 sm=0 a=tfuOg7tigZcA:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=N1F0neysESvApwy0UhMA:9 a=OostpT4gmt0OUxhVwCwA:7 a=wscTCpTiBQl_gXIcYc5RsNOXGLcA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=6wuwz1ELqKdHFLHs:21 a=YCujH8vKQ6tvMkXn:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH for stable] tracing: Consolidate protection of reader
 access to the ring buffer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 22 Jun 2010 09:23:03 -0400
Message-ID: <1277212983.9181.27.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Johannes has been hitting a bug in 2.6.33 that we believe is fixed with
the following patch. The bug is hit a few times a week, so it is hard to
verify. But we are only hitting it with .33 and not .34, and this patch
looks like it would be the one to fix it.

Can you apply this patch to the 2.6.33 stable series.

Thanks,

-- Steve

commit 7e53bd42d14c75192b99674c40fcc359392da59d
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Wed Jan 6 20:08:50 2010 +0800

    tracing: Consolidate protection of reader access to the ring buffer
    
    At the beginning, access to the ring buffer was fully serialized
    by trace_types_lock. Patch d7350c3f4569 gives more freedom to readers,
    and patch b04cc6b1f6 adds code to protect trace_pipe and cpu#/trace_pipe.
    
    But actually it is not enough, ring buffer readers are not always
    read-only, they may consume data.
    
    This patch makes accesses to trace, trace_pipe, trace_pipe_raw
    cpu#/trace, cpu#/trace_pipe and cpu#/trace_pipe_raw serialized.
    And removes tracing_reader_cpumask which is used to protect trace_pipe.
    
    Details:
    
    Ring buffer serializes readers, but it is low level protection.
    The validity of the events (which returns by ring_buffer_peek() ..etc)
    are not protected by ring buffer.
    
    The content of events may become garbage if we allow another process to consume
    these events concurrently:
      A) the page of the consumed events may become a normal page
         (not reader page) in ring buffer, and this page will be rewritten
         by the events producer.
      B) The page of the consumed events may become a page for splice_read,
         and this page will be returned to system.
    
    This patch adds trace_access_lock() and trace_access_unlock() primitives.
    
    These primitives allow multi process access to different cpu ring buffers
    concurrently.
    
    These primitives don't distinguish read-only and read-consume access.
    Multi read-only access is also serialized.
    
    And we don't use these primitives when we open files,
    we only use them when we read files.
    
    Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
    LKML-Reference: <4B447D52.1050602@cn.fujitsu.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0df1b0f..abdd333 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -32,6 +32,7 @@
 #include <linux/splice.h>
 #include <linux/kdebug.h>
 #include <linux/string.h>
+#include <linux/rwsem.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/poll.h>
@@ -102,9 +103,6 @@ static inline void ftrace_enable_cpu(void)
 
 static cpumask_var_t __read_mostly	tracing_buffer_mask;
 
-/* Define which cpu buffers are currently read in trace_pipe */
-static cpumask_var_t			tracing_reader_cpumask;
-
 #define for_each_tracing_cpu(cpu)	\
 	for_each_cpu(cpu, tracing_buffer_mask)
 
@@ -243,12 +241,91 @@ static struct tracer		*current_trace __read_mostly;
 
 /*
  * trace_types_lock is used to protect the trace_types list.
- * This lock is also used to keep user access serialized.
- * Accesses from userspace will grab this lock while userspace
- * activities happen inside the kernel.
  */
 static DEFINE_MUTEX(trace_types_lock);
 
+/*
+ * serialize the access of the ring buffer
+ *
+ * ring buffer serializes readers, but it is low level protection.
+ * The validity of the events (which returns by ring_buffer_peek() ..etc)
+ * are not protected by ring buffer.
+ *
+ * The content of events may become garbage if we allow other process consumes
+ * these events concurrently:
+ *   A) the page of the consumed events may become a normal page
+ *      (not reader page) in ring buffer, and this page will be rewrited
+ *      by events producer.
+ *   B) The page of the consumed events may become a page for splice_read,
+ *      and this page will be returned to system.
+ *
+ * These primitives allow multi process access to different cpu ring buffer
+ * concurrently.
+ *
+ * These primitives don't distinguish read-only and read-consume access.
+ * Multi read-only access are also serialized.
+ */
+
+#ifdef CONFIG_SMP
+static DECLARE_RWSEM(all_cpu_access_lock);
+static DEFINE_PER_CPU(struct mutex, cpu_access_lock);
+
+static inline void trace_access_lock(int cpu)
+{
+	if (cpu == TRACE_PIPE_ALL_CPU) {
+		/* gain it for accessing the whole ring buffer. */
+		down_write(&all_cpu_access_lock);
+	} else {
+		/* gain it for accessing a cpu ring buffer. */
+
+		/* Firstly block other trace_access_lock(TRACE_PIPE_ALL_CPU). */
+		down_read(&all_cpu_access_lock);
+
+		/* Secondly block other access to this @cpu ring buffer. */
+		mutex_lock(&per_cpu(cpu_access_lock, cpu));
+	}
+}
+
+static inline void trace_access_unlock(int cpu)
+{
+	if (cpu == TRACE_PIPE_ALL_CPU) {
+		up_write(&all_cpu_access_lock);
+	} else {
+		mutex_unlock(&per_cpu(cpu_access_lock, cpu));
+		up_read(&all_cpu_access_lock);
+	}
+}
+
+static inline void trace_access_lock_init(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		mutex_init(&per_cpu(cpu_access_lock, cpu));
+}
+
+#else
+
+static DEFINE_MUTEX(access_lock);
+
+static inline void trace_access_lock(int cpu)
+{
+	(void)cpu;
+	mutex_lock(&access_lock);
+}
+
+static inline void trace_access_unlock(int cpu)
+{
+	(void)cpu;
+	mutex_unlock(&access_lock);
+}
+
+static inline void trace_access_lock_init(void)
+{
+}
+
+#endif
+
 /* trace_wait is a waitqueue for tasks blocked on trace_poll */
 static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 
@@ -1580,12 +1657,6 @@ static void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 }
 
 /*
- * No necessary locking here. The worst thing which can
- * happen is loosing events consumed at the same time
- * by a trace_pipe reader.
- * Other than that, we don't risk to crash the ring buffer
- * because it serializes the readers.
- *
  * The current tracer is copied to avoid a global locking
  * all around.
  */
@@ -1640,12 +1711,16 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 	}
 
 	trace_event_read_lock();
+	trace_access_lock(cpu_file);
 	return p;
 }
 
 static void s_stop(struct seq_file *m, void *p)
 {
+	struct trace_iterator *iter = m->private;
+
 	atomic_dec(&trace_record_cmdline_disabled);
+	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 }
 
@@ -2836,22 +2911,6 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 
 	mutex_lock(&trace_types_lock);
 
-	/* We only allow one reader per cpu */
-	if (cpu_file == TRACE_PIPE_ALL_CPU) {
-		if (!cpumask_empty(tracing_reader_cpumask)) {
-			ret = -EBUSY;
-			goto out;
-		}
-		cpumask_setall(tracing_reader_cpumask);
-	} else {
-		if (!cpumask_test_cpu(cpu_file, tracing_reader_cpumask))
-			cpumask_set_cpu(cpu_file, tracing_reader_cpumask);
-		else {
-			ret = -EBUSY;
-			goto out;
-		}
-	}
-
 	/* create a buffer to store the information to pass to userspace */
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter) {
@@ -2907,12 +2966,6 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 
 	mutex_lock(&trace_types_lock);
 
-	if (iter->cpu_file == TRACE_PIPE_ALL_CPU)
-		cpumask_clear(tracing_reader_cpumask);
-	else
-		cpumask_clear_cpu(iter->cpu_file, tracing_reader_cpumask);
-
-
 	if (iter->trace->pipe_close)
 		iter->trace->pipe_close(iter);
 
@@ -3074,6 +3127,7 @@ waitagain:
 	iter->pos = -1;
 
 	trace_event_read_lock();
+	trace_access_lock(iter->cpu_file);
 	while (find_next_entry_inc(iter) != NULL) {
 		enum print_line_t ret;
 		int len = iter->seq.len;
@@ -3090,6 +3144,7 @@ waitagain:
 		if (iter->seq.len >= cnt)
 			break;
 	}
+	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 
 	/* Now copy what we have to the user */
@@ -3215,6 +3270,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 	}
 
 	trace_event_read_lock();
+	trace_access_lock(iter->cpu_file);
 
 	/* Fill as many pages as possible. */
 	for (i = 0, rem = len; i < PIPE_BUFFERS && rem; i++) {
@@ -3238,6 +3294,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		trace_seq_init(&iter->seq);
 	}
 
+	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 	mutex_unlock(&iter->mutex);
 
@@ -3539,10 +3596,12 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 
 	info->read = 0;
 
+	trace_access_lock(info->cpu);
 	ret = ring_buffer_read_page(info->tr->buffer,
 				    &info->spare,
 				    count,
 				    info->cpu, 0);
+	trace_access_unlock(info->cpu);
 	if (ret < 0)
 		return 0;
 
@@ -3670,6 +3729,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		len &= PAGE_MASK;
 	}
 
+	trace_access_lock(info->cpu);
 	entries = ring_buffer_entries_cpu(info->tr->buffer, info->cpu);
 
 	for (i = 0; i < PIPE_BUFFERS && len && entries; i++, len -= PAGE_SIZE) {
@@ -3717,6 +3777,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		entries = ring_buffer_entries_cpu(info->tr->buffer, info->cpu);
 	}
 
+	trace_access_unlock(info->cpu);
 	spd.nr_pages = i;
 
 	/* did we read anything? */
@@ -4153,6 +4214,8 @@ static __init int tracer_init_debugfs(void)
 	struct dentry *d_tracer;
 	int cpu;
 
+	trace_access_lock_init();
+
 	d_tracer = tracing_init_dentry();
 
 	trace_create_file("tracing_enabled", 0644, d_tracer,
@@ -4387,9 +4450,6 @@ __init static int tracer_alloc_buffers(void)
 	if (!alloc_cpumask_var(&tracing_cpumask, GFP_KERNEL))
 		goto out_free_buffer_mask;
 
-	if (!zalloc_cpumask_var(&tracing_reader_cpumask, GFP_KERNEL))
-		goto out_free_tracing_cpumask;
-
 	/* To save memory, keep the ring buffer size to its minimum */
 	if (ring_buffer_expanded)
 		ring_buf_size = trace_buf_size;
@@ -4447,8 +4507,6 @@ __init static int tracer_alloc_buffers(void)
 	return 0;
 
 out_free_cpumask:
-	free_cpumask_var(tracing_reader_cpumask);
-out_free_tracing_cpumask:
 	free_cpumask_var(tracing_cpumask);
 out_free_buffer_mask:
 	free_cpumask_var(tracing_buffer_mask);


