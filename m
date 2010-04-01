Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0DADT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:19:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab0DADSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:18:23 -0400
X-Authority-Analysis: v=1.1 cv=W8jVbnnOFeMnsvu+vJfVVAGaiNyfzTaRLlU2b8ifu+8= c=1 sm=0 a=l8bajC0GTp8A:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Q24619ZD6TGFmvFZwAsA:9 a=MYJNIHMBaUQe14Cb-GsQEQEXRF4A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100401031820.590115556@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 31 Mar 2010 23:17:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 7/7] ring-buffer: Add lost event count to end of sub buffer
References: <20100401031735.683626160@goodmis.org>
Content-Disposition: inline; filename=0007-ring-buffer-Add-lost-event-count-to-end-of-sub-buffe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently, binary readers of the ring buffer only know where events were
lost, but not how many events were lost at that location.
This information is available, but it would require adding another
field to the sub buffer header to include it.

But when a event can not fit at the end of a sub buffer, it is written
to the next sub buffer. This means there is a good chance that the
buffer may have room to hold this counter. If it does, write
the counter at the end of the sub buffer and set another flag
in the data size field that states that this information exists.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   37 +++++++++++++++++++++++++++++++++----
 1 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 8295650..dc6d563 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -320,6 +320,8 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 
 /* Flag when events were overwritten */
 #define RB_MISSED_EVENTS	(1 << 31)
+/* Missed count stored at end */
+#define RB_MISSED_STORED	(1 << 30)
 
 struct buffer_data_page {
 	u64		 time_stamp;	/* page time stamp */
@@ -340,6 +342,7 @@ struct buffer_page {
 	local_t		 write;		/* index for next write */
 	unsigned	 read;		/* index for next read */
 	local_t		 entries;	/* entries on this page */
+	unsigned long	 real_end;	/* real end of data */
 	struct buffer_data_page *page;	/* Actual data page */
 };
 
@@ -1770,6 +1773,13 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	kmemcheck_annotate_bitfield(event, bitfield);
 
 	/*
+	 * Save the original length to the meta data.
+	 * This will be used by the reader to add lost event
+	 * counter.
+	 */
+	tail_page->real_end = tail;
+
+	/*
 	 * If this event is bigger than the minimum size, then
 	 * we need to be careful that we don't subtract the
 	 * write counter enough to allow another writer to slip
@@ -2888,6 +2898,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->reader_page->write, 0);
 	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
+	cpu_buffer->reader_page->real_end = 0;
 
  spin:
 	/*
@@ -3728,11 +3739,11 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	struct ring_buffer_event *event;
 	struct buffer_data_page *bpage;
 	struct buffer_page *reader;
+	unsigned long missed_events;
 	unsigned long flags;
 	unsigned int commit;
 	unsigned int read;
 	u64 save_timestamp;
-	int missed_events = 0;
 	int ret = -1;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -3766,8 +3777,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	commit = rb_page_commit(reader);
 
 	/* Check if any events were dropped */
-	if (cpu_buffer->lost_events)
-		missed_events = 1;
+	missed_events = cpu_buffer->lost_events;
 
 	/*
 	 * If this page has been partially read or
@@ -3829,6 +3839,14 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		local_set(&reader->entries, 0);
 		reader->read = 0;
 		*data_page = bpage;
+
+		/*
+		 * Use the real_end for the data size,
+		 * This gives us a chance to store the lost events
+		 * on the page.
+		 */
+		if (reader->real_end)
+			local_set(&bpage->commit, reader->real_end);
 	}
 	ret = read;
 
@@ -3836,8 +3854,19 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	/*
 	 * Set a flag in the commit field if we lost events
 	 */
-	if (missed_events)
+	if (missed_events) {
+		commit = local_read(&bpage->commit);
+
+		/* If there is room at the end of the page to save the
+		 * missed events, then record it there.
+		 */
+		if (BUF_PAGE_SIZE - commit >= sizeof(missed_events)) {
+			memcpy(&bpage->data[commit], &missed_events,
+			       sizeof(missed_events));
+			local_add(RB_MISSED_STORED, &bpage->commit);
+		}
 		local_add(RB_MISSED_EVENTS, &bpage->commit);
+	}
 
  out_unlock:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
-- 
1.7.0


