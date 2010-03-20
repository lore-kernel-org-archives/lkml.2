Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab0CTADa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 20:03:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52890 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab0CTAD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 20:03:29 -0400
Date: Sat, 20 Mar 2010 01:03:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, robert.richter@amd.com, rostedt@goodmis.org
Subject: [PATCH] oprofile: remove double ring buffering
Message-ID: <20100320000323.GA8411@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This is currently being tested if it fixes the excessive samples
dropping I have been complaining about for some time. Still wanted
to post the patch for review.]

commit 49e66e8ab54f1114237e6dc24dc32ac912870c41
Author: Andi Kleen <ak@linux.intel.com>
Date:   Fri Mar 19 21:03:48 2010 +0100

    oprofile: remove double ring buffering
    
    oprofile used a double buffer scheme for its cpu event buffer
    to avoid races on reading with the old lock less ring buffer.
    
    But that is obsolete now with the new ring buffer, so simply
    use a single buffer. This greatly simplifies the code and avoids
    some situations where samples could be dropped.
    
    Based on suggestions from Steven Rostedt
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 166b67e..de82183 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -30,23 +30,7 @@
 
 #define OP_BUFFER_FLAGS	0
 
-/*
- * Read and write access is using spin locking. Thus, writing to the
- * buffer by NMI handler (x86) could occur also during critical
- * sections when reading the buffer. To avoid this, there are 2
- * buffers for independent read and write access. Read access is in
- * process context only, write access only in the NMI handler. If the
- * read buffer runs empty, both buffers are swapped atomically. There
- * is potentially a small window during swapping where the buffers are
- * disabled and samples could be lost.
- *
- * Using 2 buffers is a little bit overhead, but the solution is clear
- * and does not require changes in the ring buffer implementation. It
- * can be changed to a single buffer solution when the ring buffer
- * access is implemented as non-locking atomic code.
- */
-static struct ring_buffer *op_ring_buffer_read;
-static struct ring_buffer *op_ring_buffer_write;
+static struct ring_buffer *op_ring_buffer;
 DEFINE_PER_CPU(struct oprofile_cpu_buffer, op_cpu_buffer);
 
 static void wq_sync_buffer(struct work_struct *work);
@@ -68,12 +52,9 @@ void oprofile_cpu_buffer_inc_smpl_lost(void)
 
 void free_cpu_buffers(void)
 {
-	if (op_ring_buffer_read)
-		ring_buffer_free(op_ring_buffer_read);
-	op_ring_buffer_read = NULL;
-	if (op_ring_buffer_write)
-		ring_buffer_free(op_ring_buffer_write);
-	op_ring_buffer_write = NULL;
+	if (op_ring_buffer)
+		ring_buffer_free(op_ring_buffer);
+	op_ring_buffer = NULL;
 }
 
 #define RB_EVENT_HDR_SIZE 4
@@ -86,11 +67,8 @@ int alloc_cpu_buffers(void)
 	unsigned long byte_size = buffer_size * (sizeof(struct op_sample) +
 						 RB_EVENT_HDR_SIZE);
 
-	op_ring_buffer_read = ring_buffer_alloc(byte_size, OP_BUFFER_FLAGS);
-	if (!op_ring_buffer_read)
-		goto fail;
-	op_ring_buffer_write = ring_buffer_alloc(byte_size, OP_BUFFER_FLAGS);
-	if (!op_ring_buffer_write)
+	op_ring_buffer = ring_buffer_alloc(byte_size, OP_BUFFER_FLAGS);
+	if (!op_ring_buffer)
 		goto fail;
 
 	for_each_possible_cpu(i) {
@@ -162,16 +140,11 @@ struct op_sample
 *op_cpu_buffer_write_reserve(struct op_entry *entry, unsigned long size)
 {
 	entry->event = ring_buffer_lock_reserve
-		(op_ring_buffer_write, sizeof(struct op_sample) +
+		(op_ring_buffer, sizeof(struct op_sample) +
 		 size * sizeof(entry->sample->data[0]));
-	if (entry->event)
-		entry->sample = ring_buffer_event_data(entry->event);
-	else
-		entry->sample = NULL;
-
-	if (!entry->sample)
+	if (!entry->event)
 		return NULL;
-
+	entry->sample = ring_buffer_event_data(entry->event);
 	entry->size = size;
 	entry->data = entry->sample->data;
 
@@ -180,25 +153,16 @@ struct op_sample
 
 int op_cpu_buffer_write_commit(struct op_entry *entry)
 {
-	return ring_buffer_unlock_commit(op_ring_buffer_write, entry->event);
+	return ring_buffer_unlock_commit(op_ring_buffer, entry->event);
 }
 
 struct op_sample *op_cpu_buffer_read_entry(struct op_entry *entry, int cpu)
 {
 	struct ring_buffer_event *e;
-	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
-	if (e)
-		goto event;
-	if (ring_buffer_swap_cpu(op_ring_buffer_read,
-				 op_ring_buffer_write,
-				 cpu))
+	e = ring_buffer_consume(op_ring_buffer, cpu, NULL);
+	if (!e)
 		return NULL;
-	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
-	if (e)
-		goto event;
-	return NULL;
 
-event:
 	entry->event = e;
 	entry->sample = ring_buffer_event_data(e);
 	entry->size = (ring_buffer_event_length(e) - sizeof(struct op_sample))
@@ -209,8 +173,7 @@ event:
 
 unsigned long op_cpu_buffer_entries(int cpu)
 {
-	return ring_buffer_entries_cpu(op_ring_buffer_read, cpu)
-		+ ring_buffer_entries_cpu(op_ring_buffer_write, cpu);
+	return ring_buffer_entries_cpu(op_ring_buffer, cpu);
 }
 
 static int
