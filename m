Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab0DADTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:19:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54680 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0DADSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:18:23 -0400
X-Authority-Analysis: v=1.1 cv=8Rq9yliVGc3GxcN10kx+g7e/eWPAtZnInWtRlahw0rA= c=1 sm=0 a=Vc2bshOTYeAA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=zd2uoN0lAAAA:8 a=WfulkdPnAAAA:8 a=omOdbC7AAAAA:8 a=oExj5NFNAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=uCC6hK4lLgxmKMSL-S8A:9 a=kVKVgpEBjnPxQ1M2M6cA:7 a=NboVWdxIt7yW95MOoeioRZULNsEA:4 a=jEp0ucaQiEUA:10 a=wu_e27o_rKQA:10 a=l29vjEC0CZ8A:10 a=r0HesoeFUbUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=TAKOy-iqv0nZQo6Y:21 a=UgIrJdf4HCm5720m:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100401031820.065197531@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 31 Mar 2010 23:17:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: [PATCH 5/7] ring-buffer: Add place holder recording of dropped events
References: <20100401031735.683626160@goodmis.org>
Content-Disposition: inline; filename=0005-ring-buffer-Add-place-holder-recording-of-dropped-ev.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently, when the ring buffer drops events, it does not record
the fact that it did so. It does inform the writer that the event
was dropped by returning a NULL event, but it does not put in any
place holder where the event was dropped.

This is not a trivial thing to add because the ring buffer mostly
runs in overwrite (flight recorder) mode. That is, when the ring
buffer is full, new data will overwrite old data.

In a produce/consumer mode, where new data is simply dropped when
the ring buffer is full, it is trivial to add the placeholder
for dropped events. When there's more room to write new data, then
a special event can be added to notify the reader about the dropped
events.

But in overwrite mode, any new write can overwrite events. A place
holder can not be inserted into the ring buffer since there never
may be room. A reader could also come in at anytime and miss the
placeholder.

Luckily, the way the ring buffer works, the read side can find out
if events were lost or not, and how many events. Everytime a write
takes place, if it overwrites the header page (the next read) it
updates a "overrun" variable that keeps track of the number of
lost events. When a reader swaps out a page from the ring buffer,
it can record this number, perfom the swap, and then check to
see if the number changed, and take the diff if it has, which would be
the number of events dropped. This can be stored by the reader
and returned to callers of the reader.

Since the reader page swap will fail if the writer moved the head
page since the time the reader page set up the swap, this gives room
to record the overruns without worrying about races. If the reader
sets up the pages, records the overrun, than performs the swap,
if the swap succeeds, then the overrun variable has not been
updated since the setup before the swap.

For binary readers of the ring buffer, a flag is set in the header
of each sub page (sub buffer) of the ring buffer. This flag is embedded
in the size field of the data on the sub buffer, in the 31st bit (the size
can be 32 or 64 bits depending on the architecture), but only 27
bits needs to be used for the actual size (less actually).

We could add a new field in the sub buffer header to also record the
number of events dropped since the last read, but this will change the
format of the binary ring buffer a bit too much. Perhaps this change can
be made if the information on the number of events dropped is considered
important enough.

Note, the notification of dropped events is only used by consuming reads
or peeking at the ring buffer. Iterating over the ring buffer does not
keep this information because the necessary data is only available when
a page swap is made, and the iterator does not swap out pages.

Cc: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/oprofile/cpu_buffer.c        |    4 +-
 include/linux/ring_buffer.h          |    6 ++-
 kernel/trace/ring_buffer.c           |   72 +++++++++++++++++++++++++++++++---
 kernel/trace/ring_buffer_benchmark.c |    2 +-
 kernel/trace/trace.c                 |    4 +-
 kernel/trace/trace_functions_graph.c |    5 +-
 kernel/trace/trace_selftest.c        |    2 +-
 7 files changed, 79 insertions(+), 16 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 166b67e..7581dbe 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -186,14 +186,14 @@ int op_cpu_buffer_write_commit(struct op_entry *entry)
 struct op_sample *op_cpu_buffer_read_entry(struct op_entry *entry, int cpu)
 {
 	struct ring_buffer_event *e;
-	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
+	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL, NULL);
 	if (e)
 		goto event;
 	if (ring_buffer_swap_cpu(op_ring_buffer_read,
 				 op_ring_buffer_write,
 				 cpu))
 		return NULL;
-	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
+	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL, NULL);
 	if (e)
 		goto event;
 	return NULL;
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 5fcc31e..c829776 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -120,9 +120,11 @@ int ring_buffer_write(struct ring_buffer *buffer,
 		      unsigned long length, void *data);
 
 struct ring_buffer_event *
-ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts);
+ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts,
+		 unsigned long *lost_events);
 struct ring_buffer_event *
-ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts);
+ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts,
+		    unsigned long *lost_events);
 
 struct ring_buffer_iter *
 ring_buffer_read_start(struct ring_buffer *buffer, int cpu);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d1187ef..8295650 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -318,6 +318,9 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 #define TS_MASK		((1ULL << TS_SHIFT) - 1)
 #define TS_DELTA_TEST	(~TS_MASK)
 
+/* Flag when events were overwritten */
+#define RB_MISSED_EVENTS	(1 << 31)
+
 struct buffer_data_page {
 	u64		 time_stamp;	/* page time stamp */
 	local_t		 commit;	/* write committed index */
@@ -416,6 +419,12 @@ int ring_buffer_print_page_header(struct trace_seq *s)
 			       (unsigned int)sizeof(field.commit),
 			       (unsigned int)is_signed_type(long));
 
+	ret = trace_seq_printf(s, "\tfield: int overwrite;\t"
+			       "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			       (unsigned int)offsetof(typeof(field), commit),
+			       1,
+			       (unsigned int)is_signed_type(long));
+
 	ret = trace_seq_printf(s, "\tfield: char data;\t"
 			       "offset:%u;\tsize:%u;\tsigned:%u;\n",
 			       (unsigned int)offsetof(typeof(field), data),
@@ -439,6 +448,8 @@ struct ring_buffer_per_cpu {
 	struct buffer_page		*tail_page;	/* write to tail */
 	struct buffer_page		*commit_page;	/* committed pages */
 	struct buffer_page		*reader_page;
+	unsigned long			lost_events;
+	unsigned long			last_overrun;
 	local_t				commit_overrun;
 	local_t				overrun;
 	local_t				entries;
@@ -2835,6 +2846,7 @@ static struct buffer_page *
 rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *reader = NULL;
+	unsigned long overwrite;
 	unsigned long flags;
 	int nr_loops = 0;
 	int ret;
@@ -2896,6 +2908,18 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	rb_set_list_to_head(cpu_buffer, &cpu_buffer->reader_page->list);
 
 	/*
+	 * We want to make sure we read the overruns after we set up our
+	 * pointers to the next object. The writer side does a
+	 * cmpxchg to cross pages which acts as the mb on the writer
+	 * side. Note, the reader will constantly fail the swap
+	 * while the writer is updating the pointers, so this
+	 * guarantees that the overwrite recorded here is the one we
+	 * want to compare with the last_overrun.
+	 */
+	smp_mb();
+	overwrite = local_read(&(cpu_buffer->overrun));
+
+	/*
 	 * Here's the tricky part.
 	 *
 	 * We need to move the pointer past the header page.
@@ -2926,6 +2950,11 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->reader_page = reader;
 	rb_reset_reader_page(cpu_buffer);
 
+	if (overwrite != cpu_buffer->last_overrun) {
+		cpu_buffer->lost_events = overwrite - cpu_buffer->last_overrun;
+		cpu_buffer->last_overrun = overwrite;
+	}
+
 	goto again;
 
  out:
@@ -3002,8 +3031,14 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 		rb_advance_iter(iter);
 }
 
+static int rb_lost_events(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return cpu_buffer->lost_events;
+}
+
 static struct ring_buffer_event *
-rb_buffer_peek(struct ring_buffer_per_cpu *cpu_buffer, u64 *ts)
+rb_buffer_peek(struct ring_buffer_per_cpu *cpu_buffer, u64 *ts,
+	       unsigned long *lost_events)
 {
 	struct ring_buffer_event *event;
 	struct buffer_page *reader;
@@ -3055,6 +3090,8 @@ rb_buffer_peek(struct ring_buffer_per_cpu *cpu_buffer, u64 *ts)
 			ring_buffer_normalize_time_stamp(cpu_buffer->buffer,
 							 cpu_buffer->cpu, ts);
 		}
+		if (lost_events)
+			*lost_events = rb_lost_events(cpu_buffer);
 		return event;
 
 	default:
@@ -3165,12 +3202,14 @@ static inline int rb_ok_to_lock(void)
  * @buffer: The ring buffer to read
  * @cpu: The cpu to peak at
  * @ts: The timestamp counter of this event.
+ * @lost_events: a variable to store if events were lost (may be NULL)
  *
  * This will return the event that will be read next, but does
  * not consume the data.
  */
 struct ring_buffer_event *
-ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
+ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts,
+		 unsigned long *lost_events)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	struct ring_buffer_event *event;
@@ -3185,7 +3224,7 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	local_irq_save(flags);
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
-	event = rb_buffer_peek(cpu_buffer, ts);
+	event = rb_buffer_peek(cpu_buffer, ts, lost_events);
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		rb_advance_reader(cpu_buffer);
 	if (dolock)
@@ -3227,13 +3266,17 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 /**
  * ring_buffer_consume - return an event and consume it
  * @buffer: The ring buffer to get the next event from
+ * @cpu: the cpu to read the buffer from
+ * @ts: a variable to store the timestamp (may be NULL)
+ * @lost_events: a variable to store if events were lost (may be NULL)
  *
  * Returns the next event in the ring buffer, and that event is consumed.
  * Meaning, that sequential reads will keep returning a different event,
  * and eventually empty the ring buffer if the producer is slower.
  */
 struct ring_buffer_event *
-ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
+ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts,
+		    unsigned long *lost_events)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event = NULL;
@@ -3254,9 +3297,11 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
 
-	event = rb_buffer_peek(cpu_buffer, ts);
-	if (event)
+	event = rb_buffer_peek(cpu_buffer, ts, lost_events);
+	if (event) {
+		cpu_buffer->lost_events = 0;
 		rb_advance_reader(cpu_buffer);
+	}
 
 	if (dolock)
 		spin_unlock(&cpu_buffer->reader_lock);
@@ -3405,6 +3450,9 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->write_stamp = 0;
 	cpu_buffer->read_stamp = 0;
 
+	cpu_buffer->lost_events = 0;
+	cpu_buffer->last_overrun = 0;
+
 	rb_head_page_activate(cpu_buffer);
 }
 
@@ -3684,6 +3732,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	unsigned int commit;
 	unsigned int read;
 	u64 save_timestamp;
+	int missed_events = 0;
 	int ret = -1;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -3716,6 +3765,10 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	read = reader->read;
 	commit = rb_page_commit(reader);
 
+	/* Check if any events were dropped */
+	if (cpu_buffer->lost_events)
+		missed_events = 1;
+
 	/*
 	 * If this page has been partially read or
 	 * if len is not big enough to read the rest of the page or
@@ -3779,6 +3832,13 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	}
 	ret = read;
 
+	cpu_buffer->lost_events = 0;
+	/*
+	 * Set a flag in the commit field if we lost events
+	 */
+	if (missed_events)
+		local_add(RB_MISSED_EVENTS, &bpage->commit);
+
  out_unlock:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index df74c79..dc56556 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -81,7 +81,7 @@ static enum event_status read_event(int cpu)
 	int *entry;
 	u64 ts;
 
-	event = ring_buffer_consume(buffer, cpu, &ts);
+	event = ring_buffer_consume(buffer, cpu, &ts, NULL);
 	if (!event)
 		return EVENT_DROPPED;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3ec2ee6..fabb003 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1556,7 +1556,7 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
 	if (buf_iter)
 		event = ring_buffer_iter_peek(buf_iter, ts);
 	else
-		event = ring_buffer_peek(iter->tr->buffer, cpu, ts);
+		event = ring_buffer_peek(iter->tr->buffer, cpu, ts, NULL);
 
 	ftrace_enable_cpu();
 
@@ -1635,7 +1635,7 @@ static void trace_consume(struct trace_iterator *iter)
 {
 	/* Don't allow ftrace to trace into the ring buffers */
 	ftrace_disable_cpu();
-	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts);
+	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts, NULL);
 	ftrace_enable_cpu();
 }
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index e6989d9..a7f75fb 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -489,9 +489,10 @@ get_return_for_leaf(struct trace_iterator *iter,
 			 * We need to consume the current entry to see
 			 * the next one.
 			 */
-			ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
+			ring_buffer_consume(iter->tr->buffer, iter->cpu,
+					    NULL, NULL);
 			event = ring_buffer_peek(iter->tr->buffer, iter->cpu,
-						 NULL);
+						 NULL, NULL);
 		}
 
 		if (!event)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 280fea4..e501808 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -29,7 +29,7 @@ static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
 	struct trace_entry *entry;
 	unsigned int loops = 0;
 
-	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL))) {
+	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL, NULL))) {
 		entry = ring_buffer_event_data(event);
 
 		/*
-- 
1.7.0


