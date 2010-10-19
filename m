Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0JSTmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 15:42:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61217 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab0JSTmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 15:42:07 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=cKzrcQuIe7AA:10 a=HRn4fpiT8EsA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=-84boDTTk8JS8LrG4KoA:9 a=scxQ6eS_rHImn-0OrFIA:7 a=6hBiBKuh24Fz9V0RFSoG4XDwy78A:4 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=fpgiLFfS29IPReRN:21 a=UXy5c2hYZqF7w2UP:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101019194203.807907304@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 13:54:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/5] ring-buffer: Bind time extend and data events together
References: <20101019175432.854431527@goodmis.org>
Content-Disposition: inline; filename=0002-ring-buffer-Bind-time-extend-and-data-events-togethe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When the time between two timestamps is greater than
2^27 nanosecs (~134 ms) a time extend event is added that extends
the time difference to 59 bits (~18 years). This is due to
events only having a 27 bit field to store time.

Currently this time extend is a separate event. We add it just before
the event data that is being written to the buffer. But before
the event data is committed, the event data can also be discarded (as
with the case of filters). But because the time extend has already been
committed, it will stay in the buffer.

If lots of events are being filtered and no event is being
written, then every 134ms a time extend can be added to the buffer
without any data attached. To keep from filling the entire buffer
with time extends, a time extend will never be the first event
in a page because the page timestamp can be used. Time extends can
only fill the rest of a page with some data at the beginning.

This patch binds the time extend with the data. The difference here
is that the time extend is not committed before the data is added.
Instead, when a time extend is needed, the space reserved on
the ring buffer is the time extend + the data event size. The
time extend is added to the first part of the reserved block and
the data is added to the second. The time extend event is passed
back to the reserver, but since the reserver also uses a function
to find the data portion of the reserved block, no changes to the
ring buffer interface need to be made.

When a commit is discarded, we now remove both the time extend and
the event. With this approach no more than one time extend can
be in the buffer in a row. Data must always follow a time extend.

Thanks to Mathieu Desnoyers for suggesting this idea.

This patch also removes the static inline function
ring_buffer_event_time_delta() since it had no users. I was
going to update it to handle this change, but found that to be
a waste of time, and just removed the function instead.

Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |   12 --
 kernel/trace/ring_buffer.c  |  283 +++++++++++++++++++++++--------------------
 2 files changed, 154 insertions(+), 141 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 25b4f68..8d3a248 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -62,18 +62,6 @@ enum ring_buffer_type {
 unsigned ring_buffer_event_length(struct ring_buffer_event *event);
 void *ring_buffer_event_data(struct ring_buffer_event *event);
 
-/**
- * ring_buffer_event_time_delta - return the delta timestamp of the event
- * @event: the event to get the delta timestamp of
- *
- * The delta timestamp is the 27 bit timestamp since the last event.
- */
-static inline unsigned
-ring_buffer_event_time_delta(struct ring_buffer_event *event)
-{
-	return event->time_delta;
-}
-
 /*
  * ring_buffer_discard_commit will remove an event that has not
  *   ben committed yet. If this is used, then ring_buffer_unlock_commit
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 0b88df8..4fc1577 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -224,6 +224,9 @@ enum {
 	RB_LEN_TIME_STAMP = 16,
 };
 
+#define skip_time_extend(event) \
+	((struct ring_buffer_event *)((char *)event + RB_LEN_TIME_EXTEND))
+
 static inline int rb_null_event(struct ring_buffer_event *event)
 {
 	return event->type_len == RINGBUF_TYPE_PADDING && !event->time_delta;
@@ -250,7 +253,7 @@ rb_event_data_length(struct ring_buffer_event *event)
 
 /* inline for ring buffer fast paths */
 static unsigned
-rb_event_length(struct ring_buffer_event *event)
+__rb_event_length(struct ring_buffer_event *event)
 {
 	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
@@ -274,13 +277,52 @@ rb_event_length(struct ring_buffer_event *event)
 	return 0;
 }
 
+/*
+ * Return total length of time extend and data,
+ *   or just the event length for all other events.
+ */
+static unsigned
+rb_event_ts_length(struct ring_buffer_event *event)
+{
+	unsigned len = 0;
+
+	if (event->type_len == RINGBUF_TYPE_TIME_EXTEND) {
+		/* time extends include the data event after it */
+		len = RB_LEN_TIME_EXTEND;
+		event = skip_time_extend(event);
+	}
+	return len + __rb_event_length(event);
+}
+
+/*
+ * Return the length of the given event. Will return
+ * the length of the time extend if the event is a
+ * time extend.
+ */
+static unsigned
+rb_event_real_length(struct ring_buffer_event *event)
+{
+	return __rb_event_length(event);
+}
+
 /**
  * ring_buffer_event_length - return the length of the event
  * @event: the event to get the length of
+ *
+ * Returns the size of the data load of a data event.
+ * If the event is something other than a data event, it
+ * returns the size of the event itself. With the exception
+ * of a TIME EXTEND, where it still returns the size of the
+ * data load of the data event after it.
  */
 unsigned ring_buffer_event_length(struct ring_buffer_event *event)
 {
-	unsigned length = rb_event_length(event);
+	unsigned length;
+
+	if (event->type_len == RINGBUF_TYPE_TIME_EXTEND)
+		event = skip_time_extend(event);
+
+	length = rb_event_real_length(event);
 	if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 		return length;
 	length -= RB_EVNT_HDR_SIZE;
@@ -294,6 +336,8 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_length);
 static void *
 rb_event_data(struct ring_buffer_event *event)
 {
+	if (event->type_len == RINGBUF_TYPE_TIME_EXTEND)
+		event = skip_time_extend(event);
 	BUG_ON(event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX);
 	/* If length is in len field, then array[0] has the data */
 	if (event->type_len)
@@ -1546,6 +1590,25 @@ static void rb_inc_iter(struct ring_buffer_iter *iter)
 	iter->head = 0;
 }
 
+/* Slow path, do not inline */
+static noinline struct ring_buffer_event *
+rb_add_time_stamp(struct ring_buffer_event *event, u64 delta)
+{
+	event->type_len = RINGBUF_TYPE_TIME_EXTEND;
+
+	/* Not the first event on the page? */
+	if (rb_event_index(event)) {
+		event->time_delta = delta & TS_MASK;
+		event->array[0] = delta >> TS_SHIFT;
+	} else {
+		/* nope, just zero it */
+		event->time_delta = 0;
+		event->array[0] = 0;
+	}
+
+	return skip_time_extend(event);
+}
+
 /**
  * ring_buffer_update_event - update event type and data
  * @event: the even to update
@@ -1558,28 +1621,31 @@ static void rb_inc_iter(struct ring_buffer_iter *iter)
  * data field.
  */
 static void
-rb_update_event(struct ring_buffer_event *event,
-			 unsigned type, unsigned length)
+rb_update_event(struct ring_buffer_per_cpu *cpu_buffer,
+		struct ring_buffer_event *event, unsigned length,
+		int add_timestamp, u64 delta)
 {
-	event->type_len = type;
-
-	switch (type) {
-
-	case RINGBUF_TYPE_PADDING:
-	case RINGBUF_TYPE_TIME_EXTEND:
-	case RINGBUF_TYPE_TIME_STAMP:
-		break;
+	/* Only a commit updates the timestamp */
+	if (unlikely(!rb_event_is_commit(cpu_buffer, event)))
+		delta = 0;
 
-	case 0:
-		length -= RB_EVNT_HDR_SIZE;
-		if (length > RB_MAX_SMALL_DATA || RB_FORCE_8BYTE_ALIGNMENT)
-			event->array[0] = length;
-		else
-			event->type_len = DIV_ROUND_UP(length, RB_ALIGNMENT);
-		break;
-	default:
-		BUG();
+	/*
+	 * If we need to add a timestamp, then we
+	 * add it to the start of the resevered space.
+	 */
+	if (unlikely(add_timestamp)) {
+		event = rb_add_time_stamp(event, delta);
+		length -= RB_LEN_TIME_EXTEND;
+		delta = 0;
 	}
+
+	event->time_delta = delta;
+	length -= RB_EVNT_HDR_SIZE;
+	if (length > RB_MAX_SMALL_DATA || RB_FORCE_8BYTE_ALIGNMENT) {
+		event->type_len = 0;
+		event->array[0] = length;
+	} else
+		event->type_len = DIV_ROUND_UP(length, RB_ALIGNMENT);
 }
 
 /*
@@ -1829,7 +1895,7 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 static noinline struct ring_buffer_event *
 rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	     unsigned long length, unsigned long tail,
-	     struct buffer_page *tail_page, u64 *ts)
+	     struct buffer_page *tail_page, u64 ts)
 {
 	struct buffer_page *commit_page = cpu_buffer->commit_page;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
@@ -1912,8 +1978,8 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 		 * Nested commits always have zero deltas, so
 		 * just reread the time stamp
 		 */
-		*ts = rb_time_stamp(buffer);
-		next_page->page->time_stamp = *ts;
+		ts = rb_time_stamp(buffer);
+		next_page->page->time_stamp = ts;
 	}
 
  out_again:
@@ -1932,12 +1998,21 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 
 static struct ring_buffer_event *
 __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
-		  unsigned type, unsigned long length, u64 *ts)
+		  unsigned long length, u64 ts,
+		  u64 delta, int add_timestamp)
 {
 	struct buffer_page *tail_page;
 	struct ring_buffer_event *event;
 	unsigned long tail, write;
 
+	/*
+	 * If the time delta since the last event is too big to
+	 * hold in the time field of the event, then we append a
+	 * TIME EXTEND event ahead of the data event.
+	 */
+	if (unlikely(add_timestamp))
+		length += RB_LEN_TIME_EXTEND;
+
 	tail_page = cpu_buffer->tail_page;
 	write = local_add_return(length, &tail_page->write);
 
@@ -1954,18 +2029,16 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 
 	event = __rb_page_index(tail_page, tail);
 	kmemcheck_annotate_bitfield(event, bitfield);
-	rb_update_event(event, type, length);
+	rb_update_event(cpu_buffer, event, length, add_timestamp, delta);
 
-	/* The passed in type is zero for DATA */
-	if (likely(!type))
-		local_inc(&tail_page->entries);
+	local_inc(&tail_page->entries);
 
 	/*
 	 * If this is the first commit on the page, then update
 	 * its timestamp.
 	 */
 	if (!tail)
-		tail_page->page->time_stamp = *ts;
+		tail_page->page->time_stamp = ts;
 
 	return event;
 }
@@ -1980,7 +2053,7 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 	unsigned long addr;
 
 	new_index = rb_event_index(event);
-	old_index = new_index + rb_event_length(event);
+	old_index = new_index + rb_event_ts_length(event);
 	addr = (unsigned long)event;
 	addr &= PAGE_MASK;
 
@@ -2006,69 +2079,6 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 	return 0;
 }
 
-static int
-rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
-		  u64 *ts, u64 *delta)
-{
-	struct ring_buffer_event *event;
-	int ret;
-
-	WARN_ONCE(*delta > (1ULL << 59),
-		  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n",
-		  (unsigned long long)*delta,
-		  (unsigned long long)*ts,
-		  (unsigned long long)cpu_buffer->write_stamp);
-
-	/*
-	 * The delta is too big, we to add a
-	 * new timestamp.
-	 */
-	event = __rb_reserve_next(cpu_buffer,
-				  RINGBUF_TYPE_TIME_EXTEND,
-				  RB_LEN_TIME_EXTEND,
-				  ts);
-	if (!event)
-		return -EBUSY;
-
-	if (PTR_ERR(event) == -EAGAIN)
-		return -EAGAIN;
-
-	/* Only a commited time event can update the write stamp */
-	if (rb_event_is_commit(cpu_buffer, event)) {
-		/*
-		 * If this is the first on the page, then it was
-		 * updated with the page itself. Try to discard it
-		 * and if we can't just make it zero.
-		 */
-		if (rb_event_index(event)) {
-			event->time_delta = *delta & TS_MASK;
-			event->array[0] = *delta >> TS_SHIFT;
-		} else {
-			/* try to discard, since we do not need this */
-			if (!rb_try_to_discard(cpu_buffer, event)) {
-				/* nope, just zero it */
-				event->time_delta = 0;
-				event->array[0] = 0;
-			}
-		}
-		cpu_buffer->write_stamp = *ts;
-		/* let the caller know this was the commit */
-		ret = 1;
-	} else {
-		/* Try to discard the event */
-		if (!rb_try_to_discard(cpu_buffer, event)) {
-			/* Darn, this is just wasted space */
-			event->time_delta = 0;
-			event->array[0] = 0;
-		}
-		ret = 0;
-	}
-
-	*delta = 0;
-
-	return ret;
-}
-
 static void rb_start_commit(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	local_inc(&cpu_buffer->committing);
@@ -2113,9 +2123,9 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 		      unsigned long length)
 {
 	struct ring_buffer_event *event;
-	u64 ts, delta = 0;
-	int commit = 0;
+	u64 ts, delta;
 	int nr_loops = 0;
+	int add_timestamp;
 
 	rb_start_commit(cpu_buffer);
 
@@ -2136,6 +2146,9 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 
 	length = rb_calculate_event_length(length);
  again:
+	add_timestamp = 0;
+	delta = 0;
+
 	/*
 	 * We allow for interrupts to reenter here and do a trace.
 	 * If one does, it will cause this original code to loop
@@ -2174,31 +2187,24 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 
 		delta = diff;
 		if (unlikely(test_time_stamp(delta))) {
-
-			commit = rb_add_time_stamp(cpu_buffer, &ts, &delta);
-			if (commit == -EBUSY)
-				goto out_fail;
-
-			if (commit == -EAGAIN)
-				goto again;
-
-			RB_WARN_ON(cpu_buffer, commit < 0);
+			WARN_ONCE(delta > (1ULL << 59),
+				  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n",
+				  (unsigned long long)delta,
+				  (unsigned long long)ts,
+				  (unsigned long long)cpu_buffer->write_stamp);
+			add_timestamp = 1;
 		}
 	}
 
  get_event:
-	event = __rb_reserve_next(cpu_buffer, 0, length, &ts);
+	event = __rb_reserve_next(cpu_buffer, length, ts,
+				  delta, add_timestamp);
 	if (unlikely(PTR_ERR(event) == -EAGAIN))
 		goto again;
 
 	if (!event)
 		goto out_fail;
 
-	if (!rb_event_is_commit(cpu_buffer, event))
-		delta = 0;
-
-	event->time_delta = delta;
-
 	return event;
 
  out_fail:
@@ -2311,12 +2317,28 @@ static void
 rb_update_write_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 		      struct ring_buffer_event *event)
 {
+	u64 delta;
+
 	/*
 	 * The event first in the commit queue updates the
 	 * time stamp.
 	 */
-	if (rb_event_is_commit(cpu_buffer, event))
-		cpu_buffer->write_stamp += event->time_delta;
+	if (rb_event_is_commit(cpu_buffer, event)) {
+		/*
+		 * A commit event that is first on a page
+		 * updates the write timestamp with the page stamp
+		 */
+		if (!rb_event_index(event))
+			cpu_buffer->write_stamp =
+				cpu_buffer->commit_page->page->time_stamp;
+		else if (event->type_len == RINGBUF_TYPE_TIME_EXTEND) {
+			delta = event->array[0];
+			delta <<= TS_SHIFT;
+			delta += event->time_delta;
+			cpu_buffer->write_stamp += delta;
+		} else
+			cpu_buffer->write_stamp += event->time_delta;
+	}
 }
 
 static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
@@ -2356,6 +2378,9 @@ EXPORT_SYMBOL_GPL(ring_buffer_unlock_commit);
 
 static inline void rb_event_discard(struct ring_buffer_event *event)
 {
+	if (event->type_len == RINGBUF_TYPE_TIME_EXTEND)
+		event = skip_time_extend(event);
+
 	/* array[0] holds the actual length for the discarded event */
 	event->array[0] = rb_event_data_length(event) - RB_EVNT_HDR_SIZE;
 	event->type_len = RINGBUF_TYPE_PADDING;
@@ -2982,7 +3007,7 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 
 	rb_update_read_stamp(cpu_buffer, event);
 
-	length = rb_event_length(event);
+	length = rb_event_real_length(event);
 	cpu_buffer->reader_page->read += length;
 }
 
@@ -3007,7 +3032,7 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 
 	event = rb_iter_head_event(iter);
 
-	length = rb_event_length(event);
+	length = rb_event_real_length(event);
 
 	/*
 	 * This should not be called to advance the header if we are
@@ -3043,12 +3068,12 @@ rb_buffer_peek(struct ring_buffer_per_cpu *cpu_buffer, u64 *ts,
 
  again:
 	/*
-	 * We repeat when a timestamp is encountered. It is possible
-	 * to get multiple timestamps from an interrupt entering just
-	 * as one timestamp is about to be written, or from discarded
-	 * commits. The most that we can have is the number on a single page.
+	 * We repeat when a time extend is encountered.
+	 * Since the time extend is always attached to a data event,
+	 * we should never loop more than once.
+	 * (We never hit the following condition more than twice).
 	 */
-	if (RB_WARN_ON(cpu_buffer, ++nr_loops > RB_TIMESTAMPS_PER_PAGE))
+	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 2))
 		return NULL;
 
 	reader = rb_get_reader_page(cpu_buffer);
@@ -3124,14 +3149,12 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 		return NULL;
 
 	/*
-	 * We repeat when a timestamp is encountered.
-	 * We can get multiple timestamps by nested interrupts or also
-	 * if filtering is on (discarding commits). Since discarding
-	 * commits can be frequent we can get a lot of timestamps.
-	 * But we limit them by not adding timestamps if they begin
-	 * at the start of a page.
+	 * We repeat when a time extend is encountered.
+	 * Since the time extend is always attached to a data event,
+	 * we should never loop more than once.
+	 * (We never hit the following condition more than twice).
 	 */
-	if (RB_WARN_ON(cpu_buffer, ++nr_loops > RB_TIMESTAMPS_PER_PAGE))
+	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 2))
 		return NULL;
 
 	if (rb_per_cpu_empty(cpu_buffer))
@@ -3829,7 +3852,8 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		if (len > (commit - read))
 			len = (commit - read);
 
-		size = rb_event_length(event);
+		/* Always keep the time extend and data together */
+		size = rb_event_ts_length(event);
 
 		if (len < size)
 			goto out_unlock;
@@ -3851,7 +3875,8 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 				break;
 
 			event = rb_reader_event(cpu_buffer);
-			size = rb_event_length(event);
+			/* Always keep the time extend and data together */
+			size = rb_event_ts_length(event);
 		} while (len > size);
 
 		/* update bpage */
-- 
1.7.1


