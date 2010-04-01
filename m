Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab0DADTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:19:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0DADSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:18:22 -0400
X-Authority-Analysis: v=1.1 cv=pKw63bS+wPQ6BxbjPFuXko/1Hb8f7lpGL8zfzHecwYY= c=1 sm=0 a=54r_4y0BUYkA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=o7NdWspj0FROsDDf1rMA:9 a=GUyFiN6jLgD8WfS1Y9wA:7 a=O2B7qRbvT90VheVujkmoJCEKWS8A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100401031820.313194600@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 31 Mar 2010 23:17:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 6/7] tracing: Show the lost events in the trace_pipe output
References: <20100401031735.683626160@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Show-the-lost-events-in-the-trace_pipe-outpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Now that the ring buffer can keep track of where events are lost.
Use this information to the output of trace_pipe:

       hackbench-3588  [001]  1326.701660: lock_acquire: ffffffff816591e0 read rcu_read_lock
       hackbench-3588  [001]  1326.701661: lock_acquire: ffff88003f4091f0 &(&dentry->d_lock)->rlock
       hackbench-3588  [001]  1326.701664: lock_release: ffff88003f4091f0 &(&dentry->d_lock)->rlock
CPU:1 [LOST 673 EVENTS]
       hackbench-3588  [001]  1326.702711: kmem_cache_free: call_site=ffffffff81102b85 ptr=ffff880026d96738
       hackbench-3588  [001]  1326.702712: lock_release: ffff88003e1480a8 &mm->mmap_sem
       hackbench-3588  [001]  1326.702713: lock_acquire: ffff88003e1480a8 &mm->mmap_sem

Even works with the function graph tracer:

 2) ! 170.098 us  |                                            }
 2)   4.036 us    |                                            rcu_irq_exit();
 2)   3.657 us    |                                            idle_cpu();
 2) ! 190.301 us  |                                          }
CPU:2 [LOST 2196 EVENTS]
 2)   0.853 us    |                            } /* cancel_dirty_page */
 2)               |                            remove_from_page_cache() {
 2)   1.578 us    |                              _raw_spin_lock_irq();
 2)               |                              __remove_from_page_cache() {

Note, it does not work with the iterator "trace" file, since it requires
the use of consuming the page from the ring buffer to determine how many
events were lost, which the iterator does not do.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    1 +
 kernel/trace/trace.c         |   30 ++++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index c0f4b36..39e71b0 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -58,6 +58,7 @@ struct trace_iterator {
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
 	struct trace_entry	*ent;
+	unsigned long		lost_events;
 	int			leftover;
 	int			cpu;
 	u64			ts;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fabb003..0498beb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1545,7 +1545,8 @@ static void trace_iterator_increment(struct trace_iterator *iter)
 }
 
 static struct trace_entry *
-peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
+peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts,
+		unsigned long *lost_events)
 {
 	struct ring_buffer_event *event;
 	struct ring_buffer_iter *buf_iter = iter->buffer_iter[cpu];
@@ -1556,7 +1557,8 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
 	if (buf_iter)
 		event = ring_buffer_iter_peek(buf_iter, ts);
 	else
-		event = ring_buffer_peek(iter->tr->buffer, cpu, ts, NULL);
+		event = ring_buffer_peek(iter->tr->buffer, cpu, ts,
+					 lost_events);
 
 	ftrace_enable_cpu();
 
@@ -1564,10 +1566,12 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
 }
 
 static struct trace_entry *
-__find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
+__find_next_entry(struct trace_iterator *iter, int *ent_cpu,
+		  unsigned long *missing_events, u64 *ent_ts)
 {
 	struct ring_buffer *buffer = iter->tr->buffer;
 	struct trace_entry *ent, *next = NULL;
+	unsigned long lost_events, next_lost = 0;
 	int cpu_file = iter->cpu_file;
 	u64 next_ts = 0, ts;
 	int next_cpu = -1;
@@ -1580,7 +1584,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 	if (cpu_file > TRACE_PIPE_ALL_CPU) {
 		if (ring_buffer_empty_cpu(buffer, cpu_file))
 			return NULL;
-		ent = peek_next_entry(iter, cpu_file, ent_ts);
+		ent = peek_next_entry(iter, cpu_file, ent_ts, missing_events);
 		if (ent_cpu)
 			*ent_cpu = cpu_file;
 
@@ -1592,7 +1596,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 		if (ring_buffer_empty_cpu(buffer, cpu))
 			continue;
 
-		ent = peek_next_entry(iter, cpu, &ts);
+		ent = peek_next_entry(iter, cpu, &ts, &lost_events);
 
 		/*
 		 * Pick the entry with the smallest timestamp:
@@ -1601,6 +1605,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 			next = ent;
 			next_cpu = cpu;
 			next_ts = ts;
+			next_lost = lost_events;
 		}
 	}
 
@@ -1610,6 +1615,9 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 	if (ent_ts)
 		*ent_ts = next_ts;
 
+	if (missing_events)
+		*missing_events = next_lost;
+
 	return next;
 }
 
@@ -1617,13 +1625,14 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 					  int *ent_cpu, u64 *ent_ts)
 {
-	return __find_next_entry(iter, ent_cpu, ent_ts);
+	return __find_next_entry(iter, ent_cpu, NULL, ent_ts);
 }
 
 /* Find the next real entry, and increment the iterator to the next entry */
 static void *find_next_entry_inc(struct trace_iterator *iter)
 {
-	iter->ent = __find_next_entry(iter, &iter->cpu, &iter->ts);
+	iter->ent = __find_next_entry(iter, &iter->cpu,
+				      &iter->lost_events, &iter->ts);
 
 	if (iter->ent)
 		trace_iterator_increment(iter);
@@ -1635,7 +1644,8 @@ static void trace_consume(struct trace_iterator *iter)
 {
 	/* Don't allow ftrace to trace into the ring buffers */
 	ftrace_disable_cpu();
-	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts, NULL);
+	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts,
+			    &iter->lost_events);
 	ftrace_enable_cpu();
 }
 
@@ -2030,6 +2040,10 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
 
+	if (iter->lost_events)
+		trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
+				 iter->cpu, iter->lost_events);
+
 	if (iter->trace && iter->trace->print_line) {
 		ret = iter->trace->print_line(iter);
 		if (ret != TRACE_TYPE_UNHANDLED)
-- 
1.7.0


