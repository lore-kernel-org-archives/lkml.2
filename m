Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab0ERNr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 09:47:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:54189 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab0ERNqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:46:50 -0400
Message-Id: <20100518133726.214318408@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 18 May 2010 15:33:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 5/5] perf: Implement perf_output_addr()
References: <20100518133258.000434886@chello.nl>
Content-Disposition: inline; filename=perf-buffer-begin_ptr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_output_addr() will, for space allocated using PO_LINEAR, allow
one to get a linear address for writing its data to.

Tracepoints tend to want to do this, although when there is need to
multiplex the events it is of course possible that each event will get
different data due to having to construct the event multiple times.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    3 -
 include/linux/perf_event.h                |   18 ++++++-
 kernel/perf_event.c                       |   73 +++++++++++++++++++++++-------
 3 files changed, 74 insertions(+), 20 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -436,6 +436,14 @@ enum perf_event_type {
 	 */
 	PERF_RECORD_SAMPLE			= 9,
 
+	/*
+	 * struct {
+	 * 	struct perf_event_header	header;
+	 * 	u64				__null[];
+	 * };
+	 */
+	PERF_RECORD_NOP				= 10,
+
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
@@ -805,8 +813,7 @@ struct perf_output_handle {
 	unsigned long			head;
 	unsigned long			offset;
 	unsigned long			wakeup;
-	int				nmi;
-	int				sample;
+	unsigned int			flags;
 };
 
 #ifdef CONFIG_PERF_EVENTS
@@ -1002,12 +1009,17 @@ extern void perf_bp_event(struct perf_ev
 #define perf_instruction_pointer(regs)	instruction_pointer(regs)
 #endif
 
+#define PO_NOWAKE		0x01	/* can't do wakeups        */
+#define PO_SAMPLE		0x02	/* is a PERF_RECORD_SAMPLE */
+#define PO_LINEAR		0x03	/* linear addressable      */
+
 extern int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_event *event, unsigned int size,
-			     int nmi, int sample);
+			     unsigned int flags);
 extern void perf_output_end(struct perf_output_handle *handle);
 extern void perf_output_copy(struct perf_output_handle *handle,
 			     const void *buf, unsigned int len);
+extern void *perf_output_addr(struct perf_output_handle *handle);
 extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -2895,7 +2895,7 @@ static void perf_output_wakeup(struct pe
 {
 	atomic_set(&handle->data->poll, POLL_IN);
 
-	if (handle->nmi) {
+	if (handle->flags & PO_NOWAKE) {
 		handle->event->pending_wakeup = 1;
 		perf_pending_queue(&handle->event->pending,
 				   perf_pending_event);
@@ -2997,12 +2997,12 @@ void perf_output_copy(struct perf_output
 
 int perf_output_begin(struct perf_output_handle *handle,
 		      struct perf_event *event, unsigned int size,
-		      int nmi, int sample)
+		      unsigned int flags)
 {
 	struct perf_event *output_event;
 	struct perf_mmap_data *data;
 	unsigned long tail, offset, head;
-	int have_lost;
+	int have_lost, nop_size = 0;
 	struct {
 		struct perf_event_header header;
 		u64			 id;
@@ -3026,18 +3026,20 @@ int perf_output_begin(struct perf_output
 
 	handle->data	= data;
 	handle->event	= event;
-	handle->nmi	= nmi;
-	handle->sample	= sample;
+	handle->flags	= flags;
 
 	if (!data->nr_pages)
 		goto out;
 
+	perf_output_get_handle(handle);
+
+	if ((flags & PO_LINEAR) && size > (PAGE_SIZE << data->data_order))
+		goto fail;
+
 	have_lost = local_read(&data->lost);
 	if (have_lost)
 		size += sizeof(lost_event);
 
-	perf_output_get_handle(handle);
-
 	do {
 		/*
 		 * Userspace could choose to issue a mb() before updating the
@@ -3047,9 +3049,25 @@ int perf_output_begin(struct perf_output
 		tail = ACCESS_ONCE(data->user_page->data_tail);
 		smp_rmb();
 		offset = head = local_read(&data->head);
-		head += size;
+		head += size + nop_size;
 		if (unlikely(!perf_output_space(data, tail, offset, head)))
 			goto fail;
+
+		if ((flags & PO_LINEAR)) {
+			unsigned long mask = (PAGE_SIZE << data->data_order) - 1;
+			unsigned long start = offset + nop_size;
+
+			if (have_lost)
+				start += sizeof(lost_event);
+
+			if ((start & ~mask) != (head & ~mask)) {
+				nop_size = (head & ~mask) - offset;
+				if (have_lost)
+					nop_size -= sizeof(lost_event);
+				continue;
+			}
+		}
+
 	} while (local_cmpxchg(&data->head, offset, head) != offset);
 
 	handle->offset	= offset;
@@ -3068,6 +3086,15 @@ int perf_output_begin(struct perf_output
 		perf_output_put(handle, lost_event);
 	}
 
+	if (nop_size) {
+		lost_event.header.type = PERF_RECORD_NOP;
+		lost_event.header.misc = 0;
+		lost_event.header.size = nop_size;
+
+		perf_output_put(handle, lost_event.header);
+		handle->offset += nop_size - sizeof(lost_event.header);
+	}
+
 	return 0;
 
 fail:
@@ -3079,6 +3106,20 @@ out:
 	return -ENOSPC;
 }
 
+void *perf_output_addr(struct perf_output_handle *handle)
+{
+	unsigned long pages_mask = handle->data->nr_pages - 1;
+	unsigned long page_order = handle->data->data_order;
+	void **pages = handle->data->data_pages;
+	int nr;
+
+	if (!(handle->flags & PO_LINEAR))
+		return NULL;
+
+	nr = (handle->offset >> (PAGE_SHIFT + page_order)) & pages_mask;
+	return pages[nr] + (handle->offset & ((PAGE_SIZE << page_order) - 1));
+}
+
 void perf_output_end(struct perf_output_handle *handle)
 {
 	struct perf_event *event = handle->event;
@@ -3086,7 +3127,7 @@ void perf_output_end(struct perf_output_
 
 	int wakeup_events = event->attr.wakeup_events;
 
-	if (handle->sample && wakeup_events) {
+	if ((handle->flags & PO_SAMPLE) && wakeup_events) {
 		int events = local_inc_return(&data->events);
 		if (events >= wakeup_events) {
 			local_sub(wakeup_events, &data->events);
@@ -3359,11 +3400,11 @@ static void perf_event_output(struct per
 
 	perf_prepare_sample(&header, data, event, regs);
 
-	if (perf_output_begin(&handle, event, header.size, nmi, 1))
+	if (perf_output_begin(&handle, event, header.size,
+				(nmi ? PO_NOWAKE : 0) | PO_SAMPLE))
 		return;
 
 	perf_output_sample(&handle, &header, data, event);
-
 	perf_output_end(&handle);
 }
 
@@ -3394,7 +3435,7 @@ perf_event_read_event(struct perf_event 
 	};
 	int ret;
 
-	ret = perf_output_begin(&handle, event, read_event.header.size, 0, 0);
+	ret = perf_output_begin(&handle, event, read_event.header.size, 0);
 	if (ret)
 		return;
 
@@ -3433,7 +3474,7 @@ static void perf_event_task_output(struc
 	int size, ret;
 
 	size  = task_event->event_id.header.size;
-	ret = perf_output_begin(&handle, event, size, 0, 0);
+	ret = perf_output_begin(&handle, event, size, 0);
 
 	if (ret)
 		return;
@@ -3548,7 +3589,7 @@ static void perf_event_comm_output(struc
 {
 	struct perf_output_handle handle;
 	int size = comm_event->event_id.header.size;
-	int ret = perf_output_begin(&handle, event, size, 0, 0);
+	int ret = perf_output_begin(&handle, event, size, 0);
 
 	if (ret)
 		return;
@@ -3667,7 +3708,7 @@ static void perf_event_mmap_output(struc
 {
 	struct perf_output_handle handle;
 	int size = mmap_event->event_id.header.size;
-	int ret = perf_output_begin(&handle, event, size, 0, 0);
+	int ret = perf_output_begin(&handle, event, size, 0);
 
 	if (ret)
 		return;
@@ -3828,7 +3869,7 @@ static void perf_log_throttle(struct per
 	if (enable)
 		throttle_event.header.type = PERF_RECORD_UNTHROTTLE;
 
-	ret = perf_output_begin(&handle, event, sizeof(throttle_event), 1, 0);
+	ret = perf_output_begin(&handle, event, sizeof(throttle_event), PO_NOWAKE);
 	if (ret)
 		return;
 
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -255,7 +255,8 @@ static void intel_pmu_drain_bts_buffer(v
 	 */
 	perf_prepare_sample(&header, &data, event, &regs);
 
-	if (perf_output_begin(&handle, event, header.size * (top - at), 1, 1))
+	if (perf_output_begin(&handle, event, header.size * (top - at),
+				PO_NOWAKE|PO_SAMPLE))
 		return;
 
 	for (; at < top; at++) {


