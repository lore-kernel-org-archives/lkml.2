Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1GZXAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 19:00:11 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58395 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab1GZXAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 19:00:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=VBLpx670jAWFOBmUBWULk9f5FhIPxY2sbjlWGqv8tOt1eXBnFQSuqww4ZcKi01zzn
	yqlGRGVeNd4YbIbPDY2Gg==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 2/5] trace: Add ring buffer stats to measure rate of events
Date: Tue, 26 Jul 2011 15:59:51 -0700
Message-Id: <1311721194-12164-3-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stats file under per_cpu folder provides the number of entries,
overruns and other statistics about the CPU ring buffer. However, the
numbers do not provide any indication of how full the ring buffer is in
bytes compared to the overall size in bytes. Also, it is helpful to know
the rate at which the cpu buffer is filling up.

This patch adds an entry "bytes: " in printed stats for per_cpu ring
buffer which provides the actual bytes consumed in the ring buffer. This
field includes the number of bytes used by recorded events and the
padding bytes added when moving the tail pointer to next page.

It also adds the following time stamps:
"head ts:" - the oldest timestamp in the ring buffer
"now ts:"  - the timestamp at the time of reading

The field "now ts" provides a consistent time snapshot to the userspace
when being read. This is read from the same trace clock used by tracing
event timestamps.

Together, these values provide the rate at which the buffer is filling
up, from the formula:
bytes / (now_ts - head_ts)

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 include/linux/ring_buffer.h |    2 +
 kernel/trace/ring_buffer.c  |   70 ++++++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace.c        |   13 ++++++++
 3 files changed, 84 insertions(+), 1 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index b891de9..af635cf 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -154,6 +154,8 @@ void ring_buffer_record_enable(struct ring_buffer *buffer);
 void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu);
 void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu);
 
+unsigned long ring_buffer_head_ts(struct ring_buffer *buffer, int cpu);
+unsigned long ring_buffer_bytes_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_entries(struct ring_buffer *buffer);
 unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
 unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 731201b..3e49dde 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -488,12 +488,14 @@ struct ring_buffer_per_cpu {
 	struct buffer_page		*reader_page;
 	unsigned long			lost_events;
 	unsigned long			last_overrun;
+	local_t				entries_bytes;
 	local_t				commit_overrun;
 	local_t				overrun;
 	local_t				entries;
 	local_t				committing;
 	local_t				commits;
 	unsigned long			read;
+	unsigned long			read_bytes;
 	u64				write_stamp;
 	u64				read_stamp;
 };
@@ -1708,6 +1710,7 @@ rb_handle_head_page(struct ring_buffer_per_cpu *cpu_buffer,
 		 * the counters.
 		 */
 		local_add(entries, &cpu_buffer->overrun);
+		local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
 
 		/*
 		 * The entries will be zeroed out when we move the
@@ -1863,6 +1866,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	event = __rb_page_index(tail_page, tail);
 	kmemcheck_annotate_bitfield(event, bitfield);
 
+	/* account for padding bytes */
+	local_add(BUF_PAGE_SIZE - tail, &cpu_buffer->entries_bytes);
+
 	/*
 	 * Save the original length to the meta data.
 	 * This will be used by the reader to add lost event
@@ -2054,6 +2060,9 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	if (!tail)
 		tail_page->page->time_stamp = ts;
 
+	/* account for these added bytes */
+	local_add(length, &cpu_buffer->entries_bytes);
+
 	return event;
 }
 
@@ -2076,6 +2085,7 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
 		unsigned long write_mask =
 			local_read(&bpage->write) & ~RB_WRITE_MASK;
+		unsigned long event_length = rb_event_length(event);
 		/*
 		 * This is on the tail page. It is possible that
 		 * a write could come in and move the tail page
@@ -2085,8 +2095,11 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 		old_index += write_mask;
 		new_index += write_mask;
 		index = local_cmpxchg(&bpage->write, old_index, new_index);
-		if (index == old_index)
+		if (index == old_index) {
+			/* update counters */
+			local_sub(event_length, &cpu_buffer->entries_bytes);
 			return 1;
+		}
 	}
 
 	/* could not discard */
@@ -2661,6 +2674,58 @@ rb_num_of_entries(struct ring_buffer_per_cpu *cpu_buffer)
 }
 
 /**
+ * ring_buffer_head_ts - get the oldest event timestamp from the buffer
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to read from.
+ */
+unsigned long ring_buffer_head_ts(struct ring_buffer *buffer, int cpu)
+{
+	unsigned long flags;
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct buffer_page *bpage;
+	unsigned long ret;
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer = buffer->buffers[cpu];
+	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	/*
+	 * if the tail is on reader_page, oldest time stamp is on the reader
+	 * page
+	 */
+	if (cpu_buffer->tail_page == cpu_buffer->reader_page)
+		bpage = cpu_buffer->reader_page;
+	else
+		bpage = rb_set_head_page(cpu_buffer);
+	ret = bpage->page->time_stamp;
+	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_head_ts);
+
+/**
+ * ring_buffer_bytes_cpu - get the number of bytes consumed in a cpu buffer
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to read from.
+ */
+unsigned long ring_buffer_bytes_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long ret;
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer = buffer->buffers[cpu];
+	ret = local_read(&cpu_buffer->entries_bytes) - cpu_buffer->read_bytes;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_bytes_cpu);
+
+/**
  * ring_buffer_entries_cpu - get the number of entries in a cpu buffer
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the entries from.
@@ -3527,11 +3592,13 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->reader_page->read = 0;
 
 	local_set(&cpu_buffer->commit_overrun, 0);
+	local_set(&cpu_buffer->entries_bytes, 0);
 	local_set(&cpu_buffer->overrun, 0);
 	local_set(&cpu_buffer->entries, 0);
 	local_set(&cpu_buffer->committing, 0);
 	local_set(&cpu_buffer->commits, 0);
 	cpu_buffer->read = 0;
+	cpu_buffer->read_bytes = 0;
 
 	cpu_buffer->write_stamp = 0;
 	cpu_buffer->read_stamp = 0;
@@ -3918,6 +3985,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	} else {
 		/* update the entry counter */
 		cpu_buffer->read += rb_page_entries(reader);
+		cpu_buffer->read_bytes += BUF_PAGE_SIZE;
 
 		/* swap the pages */
 		rb_init_page(bpage);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ce57c55..f5b95e9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4050,6 +4050,8 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	struct trace_array *tr = &global_trace;
 	struct trace_seq *s;
 	unsigned long cnt;
+	unsigned long long t;
+	unsigned long usec_rem;
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
@@ -4066,6 +4068,17 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_commit_overrun_cpu(tr->buffer, cpu);
 	trace_seq_printf(s, "commit overrun: %ld\n", cnt);
 
+	cnt = ring_buffer_bytes_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "bytes: %ld\n", cnt);
+
+	t = ns2usecs(ring_buffer_head_ts(tr->buffer, cpu));
+	usec_rem = do_div(t, USEC_PER_SEC);
+	trace_seq_printf(s, "head ts: %5llu.%06lu\n", t, usec_rem);
+
+	t = ns2usecs(ring_buffer_time_stamp(tr->buffer, cpu));
+	usec_rem = do_div(t, USEC_PER_SEC);
+	trace_seq_printf(s, "now ts: %5llu.%06lu\n", t, usec_rem);
+
 	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
 
 	kfree(s);
-- 
1.7.3.1

