Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab0ERNqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 09:46:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:54182 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab0ERNqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:46:45 -0400
Message-Id: <20100518133726.044269924@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 18 May 2010 15:33:01 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/5] perf: Convert the perf output buffer to local_t
References: <20100518133258.000434886@chello.nl>
Content-Disposition: inline; filename=perf-buffer-local_t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is now only a single writer, we can use local_t instead
and avoid all these pesky LOCK insn.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |   15 +++++++--------
 kernel/perf_event.c        |   30 +++++++++++++++---------------
 2 files changed, 22 insertions(+), 23 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -485,6 +485,7 @@ struct perf_guest_info_callbacks {
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
 #include <asm/atomic.h>
+#include <asm/local.h>
 
 #define PERF_MAX_STACK_DEPTH		255
 
@@ -588,20 +589,18 @@ struct perf_mmap_data {
 #ifdef CONFIG_PERF_USE_VMALLOC
 	struct work_struct		work;
 #endif
-	int				data_order;
+	int				data_order;	/* allocation order  */
 	int				nr_pages;	/* nr of data pages  */
 	int				writable;	/* are we writable   */
 	int				nr_locked;	/* nr pages mlocked  */
 
 	atomic_t			poll;		/* POLL_ for wakeups */
-	atomic_t			events;		/* event_id limit       */
 
-	atomic_long_t			head;		/* write position    */
-
-	atomic_t			wakeup;		/* needs a wakeup    */
-	atomic_t			lost;		/* nr records lost   */
-
-	atomic_t			nest;		/* nested writers    */
+	local_t				head;		/* write position    */
+	local_t				nest;		/* nested writers    */
+	local_t				events;		/* event limit       */
+	local_t				wakeup;		/* needs a wakeup    */
+	local_t				lost;		/* nr records lost   */
 
 	long				watermark;	/* wakeup watermark  */
 
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -2916,7 +2916,7 @@ static void perf_output_get_handle(struc
 	struct perf_mmap_data *data = handle->data;
 
 	preempt_disable();
-	atomic_inc(&data->nest);
+	local_inc(&data->nest);
 }
 
 static void perf_output_put_handle(struct perf_output_handle *handle)
@@ -2925,13 +2925,13 @@ static void perf_output_put_handle(struc
 	unsigned long head;
 
 again:
-	head = atomic_long_read(&data->head);
+	head = local_read(&data->head);
 
 	/*
 	 * IRQ/NMI can happen here, which means we can miss a head update.
 	 */
 
-	if (!atomic_dec_and_test(&data->nest))
+	if (!local_dec_and_test(&data->nest))
 		return;
 
 	/*
@@ -2945,12 +2945,12 @@ again:
 	 * Now check if we missed an update, rely on the (compiler)
 	 * barrier in atomic_dec_and_test() to re-read data->head.
 	 */
-	if (unlikely(head != atomic_long_read(&data->head))) {
-		atomic_inc(&data->nest);
+	if (unlikely(head != local_read(&data->head))) {
+		local_inc(&data->nest);
 		goto again;
 	}
 
-	if (atomic_xchg(&data->wakeup, 0))
+	if (local_xchg(&data->wakeup, 0))
 		perf_output_wakeup(handle);
 
 	preempt_enable();
@@ -3031,7 +3031,7 @@ int perf_output_begin(struct perf_output
 	if (!data->nr_pages)
 		goto out;
 
-	have_lost = atomic_read(&data->lost);
+	have_lost = local_read(&data->lost);
 	if (have_lost)
 		size += sizeof(lost_event);
 
@@ -3045,24 +3045,24 @@ int perf_output_begin(struct perf_output
 		 */
 		tail = ACCESS_ONCE(data->user_page->data_tail);
 		smp_rmb();
-		offset = head = atomic_long_read(&data->head);
+		offset = head = local_read(&data->head);
 		head += size;
 		if (unlikely(!perf_output_space(data, tail, offset, head)))
 			goto fail;
-	} while (atomic_long_cmpxchg(&data->head, offset, head) != offset);
+	} while (local_cmpxchg(&data->head, offset, head) != offset);
 
 	handle->offset	= offset;
 	handle->head	= head;
 
 	if (head - tail > data->watermark)
-		atomic_inc(&data->wakeup);
+		local_inc(&data->wakeup);
 
 	if (have_lost) {
 		lost_event.header.type = PERF_RECORD_LOST;
 		lost_event.header.misc = 0;
 		lost_event.header.size = sizeof(lost_event);
 		lost_event.id          = event->id;
-		lost_event.lost        = atomic_xchg(&data->lost, 0);
+		lost_event.lost        = local_xchg(&data->lost, 0);
 
 		perf_output_put(handle, lost_event);
 	}
@@ -3070,7 +3070,7 @@ int perf_output_begin(struct perf_output
 	return 0;
 
 fail:
-	atomic_inc(&data->lost);
+	local_inc(&data->lost);
 	perf_output_put_handle(handle);
 out:
 	rcu_read_unlock();
@@ -3086,10 +3086,10 @@ void perf_output_end(struct perf_output_
 	int wakeup_events = event->attr.wakeup_events;
 
 	if (handle->sample && wakeup_events) {
-		int events = atomic_inc_return(&data->events);
+		int events = local_inc_return(&data->events);
 		if (events >= wakeup_events) {
-			atomic_sub(wakeup_events, &data->events);
-			atomic_inc(&data->wakeup);
+			local_sub(wakeup_events, &data->events);
+			local_inc(&data->wakeup);
 		}
 	}
 


