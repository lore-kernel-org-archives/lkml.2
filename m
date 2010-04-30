Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0D3RBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:01:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:60359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758252Ab0D3RBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:01:12 -0400
Date: Fri, 30 Apr 2010 08:46:28 GMT
From: tip-bot for David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, davem@davemloft.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, davem@davemloft.net
In-Reply-To: <20100420.154711.11246950.davem@davemloft.net>
References: <20100420.154711.11246950.davem@davemloft.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] ring-buffer: Make non-consuming read less expensive with lots of cpus.
Message-ID: <tip-72c9ddfd4c5bf54ef03cfdf57026416cb678eeba@git.kernel.org>
Git-Commit-ID: 72c9ddfd4c5bf54ef03cfdf57026416cb678eeba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Apr 2010 08:46:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72c9ddfd4c5bf54ef03cfdf57026416cb678eeba
Gitweb:     http://git.kernel.org/tip/72c9ddfd4c5bf54ef03cfdf57026416cb678eeba
Author:     David Miller <davem@davemloft.net>
AuthorDate: Tue, 20 Apr 2010 15:47:11 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 27 Apr 2010 13:06:35 -0400

ring-buffer: Make non-consuming read less expensive with lots of cpus.

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
 
