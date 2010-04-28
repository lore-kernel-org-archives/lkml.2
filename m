Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0D1BjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:39:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56598 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab0D1BiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:38:08 -0400
X-Authority-Analysis: v=1.1 cv=tamp8Om8S85MB4Qj1n2yU9kNzNdU9gdJUe8fX0YwrYg= c=1 sm=0 a=QuJZ-np7IGwA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=J1Y8HTJGAAAA:8 a=meVymXHHAAAA:8 a=hXTIyAAs-C40EB59ecAA:9 a=TC2-RsK6j6FO-wocQHgA:7 a=ZHqARUjbV0UYTw70X9Xi6eOAhqIA:4 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100428013806.448438469@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 27 Apr 2010 21:27:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4/8] ring-buffer: Make non-consuming read less expensive with lots of cpus.
References: <20100428012723.119106602@goodmis.org>
Content-Disposition: inline; filename=0004-ring-buffer-Make-non-consuming-read-less-expensive-w.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

When performing a non-consuming read, a synchronize_sched() is
performed once for every cpu which is actively tracing.

This is very expensive, and can make it take several seconds to open
up the 'trace' file with lots of cpus.

Only one synchronize_sched() call is actually necessary.  What is
desired is for all cpus to see the disabling state change.  So we
transform the existing sequence:

	for_each_cpu() {
		ring_buffer_read_start();
	}

where each ring_buffer_start() call performs a synchronize_sched(),
into the following:

	for_each_cpu() {
		ring_buffer_read_prepare();
	}
	ring_buffer_read_prepare_sync();
	for_each_cpu() {
		ring_buffer_read_start();
	}

wherein only the single ring_buffer_read_prepare_sync() call needs to
do the synchronize_sched().

The first phase, via ring_buffer_read_prepare(), allocates the 'iter'
memory and increments ->record_disabled.

In the second phase, ring_buffer_read_prepare_sync() makes sure this
->record_disabled state is visible fully to all cpus.

And in the final third phase, the ring_buffer_read_start() calls reset
the 'iter' objects allocated in the first phase since we now know that
none of the cpus are adding trace entries any more.

This makes openning the 'trace' file nearly instantaneous on a
sparc64 Niagara2 box with 128 cpus tracing.

Signed-off-by: David S. Miller <davem@davemloft.net>
LKML-Reference: <20100420.154711.11246950.davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |    4 ++-
 kernel/trace/ring_buffer.c  |   64 ++++++++++++++++++++++++++++++++++++-------
 kernel/trace/trace.c        |   11 +++++--
 3 files changed, 65 insertions(+), 14 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index c829776..25b4f68 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -127,7 +127,9 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts,
 		    unsigned long *lost_events);
 
 struct ring_buffer_iter *
-ring_buffer_read_start(struct ring_buffer *buffer, int cpu);
+ring_buffer_read_prepare(struct ring_buffer *buffer, int cpu);
+void ring_buffer_read_prepare_sync(void);
+void ring_buffer_read_start(struct ring_buffer_iter *iter);
 void ring_buffer_read_finish(struct ring_buffer_iter *iter);
 
 struct ring_buffer_event *
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 5885cdf..2a09044 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3332,23 +3332,30 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts,
 EXPORT_SYMBOL_GPL(ring_buffer_consume);
 
 /**
- * ring_buffer_read_start - start a non consuming read of the buffer
+ * ring_buffer_read_prepare - Prepare for a non consuming read of the buffer
  * @buffer: The ring buffer to read from
  * @cpu: The cpu buffer to iterate over
  *
- * This starts up an iteration through the buffer. It also disables
- * the recording to the buffer until the reading is finished.
- * This prevents the reading from being corrupted. This is not
- * a consuming read, so a producer is not expected.
+ * This performs the initial preparations necessary to iterate
+ * through the buffer.  Memory is allocated, buffer recording
+ * is disabled, and the iterator pointer is returned to the caller.
  *
- * Must be paired with ring_buffer_finish.
+ * Disabling buffer recordng prevents the reading from being
+ * corrupted. This is not a consuming read, so a producer is not
+ * expected.
+ *
+ * After a sequence of ring_buffer_read_prepare calls, the user is
+ * expected to make at least one call to ring_buffer_prepare_sync.
+ * Afterwards, ring_buffer_read_start is invoked to get things going
+ * for real.
+ *
+ * This overall must be paired with ring_buffer_finish.
  */
 struct ring_buffer_iter *
-ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
+ring_buffer_read_prepare(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_iter *iter;
-	unsigned long flags;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
@@ -3362,15 +3369,52 @@ ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
 	iter->cpu_buffer = cpu_buffer;
 
 	atomic_inc(&cpu_buffer->record_disabled);
+
+	return iter;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_read_prepare);
+
+/**
+ * ring_buffer_read_prepare_sync - Synchronize a set of prepare calls
+ *
+ * All previously invoked ring_buffer_read_prepare calls to prepare
+ * iterators will be synchronized.  Afterwards, read_buffer_read_start
+ * calls on those iterators are allowed.
+ */
+void
+ring_buffer_read_prepare_sync(void)
+{
 	synchronize_sched();
+}
+EXPORT_SYMBOL_GPL(ring_buffer_read_prepare_sync);
+
+/**
+ * ring_buffer_read_start - start a non consuming read of the buffer
+ * @iter: The iterator returned by ring_buffer_read_prepare
+ *
+ * This finalizes the startup of an iteration through the buffer.
+ * The iterator comes from a call to ring_buffer_read_prepare and
+ * an intervening ring_buffer_read_prepare_sync must have been
+ * performed.
+ *
+ * Must be paired with ring_buffer_finish.
+ */
+void
+ring_buffer_read_start(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long flags;
+
+	if (!iter)
+		return;
+
+	cpu_buffer = iter->cpu_buffer;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	arch_spin_lock(&cpu_buffer->lock);
 	rb_iter_reset(iter);
 	arch_spin_unlock(&cpu_buffer->lock);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
-
-	return iter;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_start);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8b9ba41..756d728 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2201,15 +2201,20 @@ __tracing_open(struct inode *inode, struct file *file)
 
 	if (iter->cpu_file == TRACE_PIPE_ALL_CPU) {
 		for_each_tracing_cpu(cpu) {
-
 			iter->buffer_iter[cpu] =
-				ring_buffer_read_start(iter->tr->buffer, cpu);
+				ring_buffer_read_prepare(iter->tr->buffer, cpu);
+		}
+		ring_buffer_read_prepare_sync();
+		for_each_tracing_cpu(cpu) {
+			ring_buffer_read_start(iter->buffer_iter[cpu]);
 			tracing_iter_reset(iter, cpu);
 		}
 	} else {
 		cpu = iter->cpu_file;
 		iter->buffer_iter[cpu] =
-				ring_buffer_read_start(iter->tr->buffer, cpu);
+			ring_buffer_read_prepare(iter->tr->buffer, cpu);
+		ring_buffer_read_prepare_sync();
+		ring_buffer_read_start(iter->buffer_iter[cpu]);
 		tracing_iter_reset(iter, cpu);
 	}
 
-- 
1.7.0


