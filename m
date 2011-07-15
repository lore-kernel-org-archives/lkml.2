Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1GOVYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 17:24:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27200 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab1GOVYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 17:24:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=AQdgWl1uImxZsunVmcdMbDS+lW4GifJASWOmgvOYwaHNjR1uCnrIle9LyIJzNXi3v
	00Uygsd4yGDP5n6+eOPUA==
From: Slava Pestov <slavapestov@google.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Slava Pestov <slavapestov@google.com>
Subject: [PATCH] ftrace: add a 'dropped events' counter
Date: Fri, 15 Jul 2011 14:23:58 -0700
Message-Id: <1310765038-26399-1-git-send-email-slavapestov@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing 'overrun' counter is incremented when the ring
buffer wraps around, with overflow on (the default). We wanted
a way to count requests lost from the buffer filling up with
overflow off, too. I decided to add a new counter instead
of retro-fitting the existing one because it seems like a
different statistic to count conceptually, and also because
of how the code was structured.

Signed-Off-By: Slava Pestov <slavapestov@google.com>
---
 include/linux/ring_buffer.h |    1 +
 kernel/trace/ring_buffer.c  |   43 ++++++++++++++++++++++++++++++++++++-------
 kernel/trace/trace.c        |    3 +++
 3 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index ab38ac8..a6dea58 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -159,6 +159,7 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
 unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu);
+unsigned long ring_buffer_dropped_events_cpu(struct ring_buffer *buffer, int cpu);
 
 u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu);
 void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b0c7aa4..393254e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -488,9 +488,10 @@ struct ring_buffer_per_cpu {
 	struct buffer_page		*reader_page;
 	unsigned long			lost_events;
 	unsigned long			last_overrun;
-	local_t				commit_overrun;
-	local_t				overrun;
 	local_t				entries;
+	local_t				overrun;
+	local_t				commit_overrun;
+	local_t				dropped_events;
 	local_t				committing;
 	local_t				commits;
 	unsigned long			read;
@@ -1941,8 +1942,10 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 			 * If we are not in overwrite mode,
 			 * this is easy, just stop here.
 			 */
-			if (!(buffer->flags & RB_FL_OVERWRITE))
-				goto out_reset;
+			if (!(buffer->flags & RB_FL_OVERWRITE)) {
+				local_inc(&cpu_buffer->dropped_events);
+			 	goto out_reset;
+			}
 
 			ret = rb_handle_head_page(cpu_buffer,
 						  tail_page,
@@ -2665,7 +2668,8 @@ unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_entries_cpu);
 
 /**
- * ring_buffer_overrun_cpu - get the number of overruns in a cpu_buffer
+ * ring_buffer_overrun_cpu - get the number of overruns caused by the ring
+ * buffer wrapping around (only if RB_FL_OVERWRITE is on).
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the number of overruns from
  */
@@ -2685,7 +2689,9 @@ unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_overrun_cpu);
 
 /**
- * ring_buffer_commit_overrun_cpu - get the number of overruns caused by commits
+ * ring_buffer_commit_overrun_cpu - get the number of overruns caused by
+ * commits failing due to the buffer wrapping around while there are uncommitted
+ * events, such as during an interrupt storm.
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the number of overruns from
  */
@@ -2706,6 +2712,28 @@ ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_commit_overrun_cpu);
 
 /**
+ * ring_buffer_dropped_events_cpu - get the number of dropped events caused by
+ * the ring buffer filling up (only if RB_FL_OVERWRITE is off).
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the number of overruns from
+ */
+unsigned long
+ring_buffer_dropped_events_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long ret;
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer = buffer->buffers[cpu];
+	ret = local_read(&cpu_buffer->dropped_events);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_dropped_events_cpu);
+
+/**
  * ring_buffer_entries - get the number of entries in a buffer
  * @buffer: The ring buffer
  *
@@ -3512,8 +3540,9 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
 	cpu_buffer->reader_page->read = 0;
 
-	local_set(&cpu_buffer->commit_overrun, 0);
 	local_set(&cpu_buffer->overrun, 0);
+	local_set(&cpu_buffer->commit_overrun, 0);
+	local_set(&cpu_buffer->dropped_events, 0);
 	local_set(&cpu_buffer->entries, 0);
 	local_set(&cpu_buffer->committing, 0);
 	local_set(&cpu_buffer->commits, 0);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee9c921..fe8c1d3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3939,6 +3939,9 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_commit_overrun_cpu(tr->buffer, cpu);
 	trace_seq_printf(s, "commit overrun: %ld\n", cnt);
 
+	cnt = ring_buffer_dropped_events_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "dropped events: %ld\n", cnt);
+
 	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
 
 	kfree(s);
-- 
1.7.3.1

