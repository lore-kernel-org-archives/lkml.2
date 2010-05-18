Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab0ERRR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:17:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:60767 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab0ERRRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:17:53 -0400
Date: Tue, 18 May 2010 17:17:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize the hotpath by converting the perf output buffer to local_t
Message-ID: <tip-fa5881514ef9c9bcb29319aad85cf2d8889d91f1@git.kernel.org>
Git-Commit-ID: fa5881514ef9c9bcb29319aad85cf2d8889d91f1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 17:17:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa5881514ef9c9bcb29319aad85cf2d8889d91f1
Gitweb:     http://git.kernel.org/tip/fa5881514ef9c9bcb29319aad85cf2d8889d91f1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 18 May 2010 10:54:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 May 2010 18:35:49 +0200

perf: Optimize the hotpath by converting the perf output buffer to local_t

Since there is now only a single writer, we can use
local_t instead and avoid all these pesky LOCK insn.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |   15 +++++++--------
 kernel/perf_event.c        |   30 +++++++++++++++---------------
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f1f853a..ce76676 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
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
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8cf737d..1f98c78 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2916,7 +2916,7 @@ static void perf_output_get_handle(struct perf_output_handle *handle)
 	struct perf_mmap_data *data = handle->data;
 
 	preempt_disable();
-	atomic_inc(&data->nest);
+	local_inc(&data->nest);
 }
 
 static void perf_output_put_handle(struct perf_output_handle *handle)
@@ -2925,13 +2925,13 @@ static void perf_output_put_handle(struct perf_output_handle *handle)
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
@@ -3031,7 +3031,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 	if (!data->nr_pages)
 		goto out;
 
-	have_lost = atomic_read(&data->lost);
+	have_lost = local_read(&data->lost);
 	if (have_lost)
 		size += sizeof(lost_event);
 
@@ -3045,24 +3045,24 @@ int perf_output_begin(struct perf_output_handle *handle,
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
@@ -3070,7 +3070,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 	return 0;
 
 fail:
-	atomic_inc(&data->lost);
+	local_inc(&data->lost);
 	perf_output_put_handle(handle);
 out:
 	rcu_read_unlock();
@@ -3086,10 +3086,10 @@ void perf_output_end(struct perf_output_handle *handle)
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
 
