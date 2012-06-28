Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab2F1Awq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 20:52:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10791 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab2F1Awp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 20:52:45 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=pf8V27uzMmYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=SKBzyUd3OZRTJhgoc0oA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=dM68ZfjBud_p8Hj6:21 a=jIy4PLGBer9pg5vY:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340844763.16702.54.camel@gandalf.stny.rr.com>
Subject: Re: big allocation failure during tracing init.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 27 Jun 2012 20:52:43 -0400
In-Reply-To: <20120622193650.GA20098@redhat.com>
References: <20120622193650.GA20098@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 15:36 -0400, Dave Jones wrote:

> I guess the problem is on kernels built with CONFIG_MAXCPUS, struct trace_iterator
> can be pretty large due to this embedded in it..
> 
> 	struct ring_buffer_iter *buffer_iter[NR_CPUS];
> 
> Any thoughts on how to change that to a smaller dynamic data structure,
> without adding too much overhead to tracing ? (I'm assuming a linked-list walk
> for eg would be excessive?)
> 

Does this patch fix it for you?

-- Steve

commit 0339abcabbef5f1fc57a8af046861a04e0a0ef9f
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Jun 27 20:46:14 2012 -0400

    tracing: Remove NR_CPUS array from trace_iterator
    
    Replace the NR_CPUS array of buffer_iter from the trace_iterator
    with an allocated array. This will just create an array of
    possible CPUS instead of the max number specified.
    
    Added a helper function called 'trace_buffer_iter()' that returns
    the buffer_iter item or NULL if it is not defined or the array was
    not allocated. Some routines do not require the array
    (tracing_open_pipe() for one).
    
    Reported-by: Dave Jones <davej@redhat.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 1aff183..af961d6 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -65,7 +65,7 @@ struct trace_iterator {
 	void			*private;
 	int			cpu_file;
 	struct mutex		mutex;
-	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
+	struct ring_buffer_iter	**buffer_iter;
 	unsigned long		iter_flags;
 
 	/* trace_seq for __print_flags() and __print_symbolic() etc. */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a8d5654..85073f9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1710,9 +1710,11 @@ EXPORT_SYMBOL_GPL(trace_vprintk);
 
 static void trace_iterator_increment(struct trace_iterator *iter)
 {
+	struct ring_buffer_iter *buf_iter = trace_buffer_iter(iter, iter->cpu);
+
 	iter->idx++;
-	if (iter->buffer_iter[iter->cpu])
-		ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
+	if (buf_iter)
+		ring_buffer_read(buf_iter, NULL);
 }
 
 static struct trace_entry *
@@ -1720,7 +1722,7 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts,
 		unsigned long *lost_events)
 {
 	struct ring_buffer_event *event;
-	struct ring_buffer_iter *buf_iter = iter->buffer_iter[cpu];
+	struct ring_buffer_iter *buf_iter = trace_buffer_iter(iter, cpu);
 
 	if (buf_iter)
 		event = ring_buffer_iter_peek(buf_iter, ts);
@@ -1858,10 +1860,10 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 
 	tr->data[cpu]->skipped_entries = 0;
 
-	if (!iter->buffer_iter[cpu])
+	buf_iter = trace_buffer_iter(iter, cpu);
+	if (!buf_iter)
 		return;
 
-	buf_iter = iter->buffer_iter[cpu];
 	ring_buffer_iter_reset(buf_iter);
 
 	/*
@@ -2207,13 +2209,15 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 
 int trace_empty(struct trace_iterator *iter)
 {
+	struct ring_buffer_iter *buf_iter;
 	int cpu;
 
 	/* If we are looking at one CPU buffer, only check that one */
 	if (iter->cpu_file != TRACE_PIPE_ALL_CPU) {
 		cpu = iter->cpu_file;
-		if (iter->buffer_iter[cpu]) {
-			if (!ring_buffer_iter_empty(iter->buffer_iter[cpu]))
+		buf_iter = trace_buffer_iter(iter, cpu);
+		if (buf_iter) {
+			if (!ring_buffer_iter_empty(buf_iter))
 				return 0;
 		} else {
 			if (!ring_buffer_empty_cpu(iter->tr->buffer, cpu))
@@ -2223,8 +2227,9 @@ int trace_empty(struct trace_iterator *iter)
 	}
 
 	for_each_tracing_cpu(cpu) {
-		if (iter->buffer_iter[cpu]) {
-			if (!ring_buffer_iter_empty(iter->buffer_iter[cpu]))
+		buf_iter = trace_buffer_iter(iter, cpu);
+		if (buf_iter) {
+			if (!ring_buffer_iter_empty(buf_iter))
 				return 0;
 		} else {
 			if (!ring_buffer_empty_cpu(iter->tr->buffer, cpu))
@@ -2383,6 +2388,8 @@ __tracing_open(struct inode *inode, struct file *file)
 	if (!iter)
 		return ERR_PTR(-ENOMEM);
 
+	iter->buffer_iter = kzalloc(sizeof(*iter->buffer_iter) * num_possible_cpus(),
+				    GFP_KERNEL);
 	/*
 	 * We make a copy of the current tracer to avoid concurrent
 	 * changes on it while we are reading.
@@ -2443,6 +2450,7 @@ __tracing_open(struct inode *inode, struct file *file)
  fail:
 	mutex_unlock(&trace_types_lock);
 	kfree(iter->trace);
+	kfree(iter->buffer_iter);
 	seq_release_private(inode, file);
 	return ERR_PTR(-ENOMEM);
 }
@@ -2483,6 +2491,7 @@ static int tracing_release(struct inode *inode, struct file *file)
 	mutex_destroy(&iter->mutex);
 	free_cpumask_var(iter->started);
 	kfree(iter->trace);
+	kfree(iter->buffer_iter);
 	seq_release_private(inode, file);
 	return 0;
 }
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 5aec220..55e1f7f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -317,6 +317,14 @@ struct tracer {
 
 #define TRACE_PIPE_ALL_CPU	-1
 
+static inline struct ring_buffer_iter *
+trace_buffer_iter(struct trace_iterator *iter, int cpu)
+{
+	if (iter->buffer_iter && iter->buffer_iter[cpu])
+		return iter->buffer_iter[cpu];
+	return NULL;
+}
+
 int tracer_init(struct tracer *t, struct trace_array *tr);
 int tracing_is_enabled(void);
 void trace_wake_up(void);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index a7d2a4c..ce27c8b 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -538,7 +538,7 @@ get_return_for_leaf(struct trace_iterator *iter,
 		next = &data->ret;
 	} else {
 
-		ring_iter = iter->buffer_iter[iter->cpu];
+		ring_iter = trace_buffer_iter(iter, iter->cpu);
 
 		/* First peek to compare current entry and the next one */
 		if (ring_iter)


