Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab1CNWyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:54:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:43190 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab1CNWyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:54:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=waaJZ41safpRlEIO2e4qNI4nx74FDRsQuvUWXYkt31UyJ26Fq9FBwfXSl0vaP9n/t
	igRp77/QFM89sD+fLOmQQ==
From: Slava Pestov <slavapestov@google.com>
To: linux-kernel@vger.kernel.org
Cc: mrubin@google.com, dhsharp@google.com, rostedt@goodmis.org,
        Slava Pestov <slavapestov@google.com>
Subject: [PATCH] ftrace: add a new 'tail drops' counter for overflow events
Date: Mon, 14 Mar 2011 15:53:56 -0700
Message-Id: <1300143236-23233-1-git-send-email-slavapestov@google.com>
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
index 8d3a248..155c665 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -157,6 +157,7 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
 unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu);
+unsigned long ring_buffer_tail_drops_cpu(struct ring_buffer *buffer, int cpu);
 
 u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu);
 void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bd1c35a..2b9eae7 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -489,9 +489,10 @@ struct ring_buffer_per_cpu {
 	struct buffer_page		*reader_page;
 	unsigned long			lost_events;
 	unsigned long			last_overrun;
-	local_t				commit_overrun;
-	local_t				overrun;
 	local_t				entries;
+	local_t				overrun;
+	local_t				commit_overrun;
+	local_t				tail_drops;
 	local_t				committing;
 	local_t				commits;
 	unsigned long			read;
@@ -1931,8 +1932,10 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 			 * If we are not in overwrite mode,
 			 * this is easy, just stop here.
 			 */
-			if (!(buffer->flags & RB_FL_OVERWRITE))
-				goto out_reset;
+			if (!(buffer->flags & RB_FL_OVERWRITE)) {
+				local_inc(&cpu_buffer->tail_drops);
+			 	goto out_reset;
+			}
 
 			ret = rb_handle_head_page(cpu_buffer,
 						  tail_page,
@@ -2647,7 +2650,8 @@ unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_entries_cpu);
 
 /**
- * ring_buffer_overrun_cpu - get the number of overruns in a cpu_buffer
+ * ring_buffer_overrun_cpu - get the number of overruns caused by the ring
+ * buffer wrapping around (only if RB_FL_OVERWRITE is on).
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the number of overruns from
  */
@@ -2667,7 +2671,9 @@ unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_overrun_cpu);
 
 /**
- * ring_buffer_commit_overrun_cpu - get the number of overruns caused by commits
+ * ring_buffer_commit_overrun_cpu - get the number of overruns caused by
+ * commits failing due to the buffer wrapping around while there are uncommitted
+ * events, such as during an interrupt storm.
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the number of overruns from
  */
@@ -2688,6 +2694,28 @@ ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_commit_overrun_cpu);
 
 /**
+ * ring_buffer_tail_drops_cpu - get the number of tail drops caused by
+ * the ring buffer filling up (only if RB_FL_OVERWRITE is off).
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the number of overruns from
+ */
+unsigned long
+ring_buffer_tail_drops_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long ret;
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer = buffer->buffers[cpu];
+	ret = local_read(&cpu_buffer->tail_drops);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_tail_drops_cpu);
+
+/**
  * ring_buffer_entries - get the number of entries in a buffer
  * @buffer: The ring buffer
  *
@@ -3494,8 +3522,9 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
 	cpu_buffer->reader_page->read = 0;
 
-	local_set(&cpu_buffer->commit_overrun, 0);
 	local_set(&cpu_buffer->overrun, 0);
+	local_set(&cpu_buffer->commit_overrun, 0);
+	local_set(&cpu_buffer->tail_drops, 0);
 	local_set(&cpu_buffer->entries, 0);
 	local_set(&cpu_buffer->committing, 0);
 	local_set(&cpu_buffer->commits, 0);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dc53ecb..3677c8a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3916,6 +3916,9 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_commit_overrun_cpu(tr->buffer, cpu);
 	trace_seq_printf(s, "commit overrun: %ld\n", cnt);
 
+	cnt = ring_buffer_tail_drops_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "tail drops: %ld\n", cnt);
+
 	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
 
 	kfree(s);
-- 
1.7.3.1

