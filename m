Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1KUO4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:56:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44746 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab1KUO4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:56:08 -0500
Message-Id: <20111121145337.817092864@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 15:51:19 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 5/6] perf: Extend the mmap control page with time (TSC) fields
References: <20111121145114.049265181@chello.nl>
Content-Disposition: inline; filename=perf-mmap-tsc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the mmap control page with fields so that userspace can compute
time deltas relative to the provided time fields.

Currently only implemented for x86 with constant and nonstop TSC.

Cc: Stephane Eranian <eranian@google.com>
Cc: Arun Sharma <asharma@fb.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c |   14 ++++++++++++++
 include/linux/perf_event.h       |    4 +++-
 kernel/events/core.c             |   21 ++++++++++++++-------
 3 files changed, 31 insertions(+), 8 deletions(-)
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -32,6 +32,7 @@
 #include <asm/compat.h>
 #include <asm/smp.h>
 #include <asm/alternative.h>
+#include <asm/timer.h>
 
 #include "perf_event.h"
 
@@ -1621,6 +1622,19 @@ static struct pmu pmu = {
 	.event_idx	= x86_pmu_event_idx,
 };
 
+void perf_update_user_clock(struct perf_event_mmap_page *userpg, u64 now)
+{
+	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+		return;
+
+	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
+		return;
+
+	userpg->time_mult = this_cpu_read(cyc2ns);
+	userpg->time_shift = CYC2NS_SCALE_FACTOR;
+	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
+}
+
 /*
  * callchain support
  */
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -290,12 +290,14 @@ struct perf_event_mmap_page {
 	__s64	offset;			/* add to hardware event value */
 	__u64	time_enabled;		/* time event active */
 	__u64	time_running;		/* time event on cpu */
+	__u32	time_mult, time_shift;
+	__u64	time_offset;
 
 		/*
 		 * Hole for extension of the self monitor capabilities
 		 */
 
-	__u64	__reserved[123];	/* align to 1k */
+	__u64	__reserved[121];	/* align to 1k */
 
 	/*
 	 * Control data for the mmap() data buffer.
Index: linux-2.6/kernel/events/core.c
===================================================================
--- linux-2.6.orig/kernel/events/core.c
+++ linux-2.6/kernel/events/core.c
@@ -3203,17 +3203,22 @@ static int perf_event_index(struct perf_
 }
 
 static void calc_timer_values(struct perf_event *event,
+				u64 *now,
 				u64 *enabled,
 				u64 *running)
 {
-	u64 now, ctx_time;
+	u64 ctx_time;
 
-	now = perf_clock();
-	ctx_time = event->shadow_ctx_time + now;
+	*now = perf_clock();
+	ctx_time = event->shadow_ctx_time + *now;
 	*enabled = ctx_time - event->tstamp_enabled;
 	*running = ctx_time - event->tstamp_running;
 }
 
+void __weak perf_update_user_clock(struct perf_event_mmap_page *userpg, u64 now)
+{
+}
+
 /*
  * Callers need to ensure there can be no nesting of this function, otherwise
  * the seqlock logic goes bad. We can not serialize this because the arch
@@ -3223,7 +3228,7 @@ void perf_event_update_userpage(struct p
 {
 	struct perf_event_mmap_page *userpg;
 	struct ring_buffer *rb;
-	u64 enabled, running;
+	u64 enabled, running, now;
 
 	rcu_read_lock();
 	/*
@@ -3235,7 +3240,7 @@ void perf_event_update_userpage(struct p
 	 * because of locking issue as we can be called in
 	 * NMI context
 	 */
-	calc_timer_values(event, &enabled, &running);
+	calc_timer_values(event, &now, &enabled, &running);
 	rb = rcu_dereference(event->rb);
 	if (!rb)
 		goto unlock;
@@ -3260,6 +3265,8 @@ void perf_event_update_userpage(struct p
 	userpg->time_running = running +
 			atomic64_read(&event->child_total_time_running);
 
+	perf_update_user_clock(userpg, now);
+
 	barrier();
 	++userpg->lock;
 	preempt_enable();
@@ -3692,7 +3699,7 @@ static void perf_output_read_group(struc
 static void perf_output_read(struct perf_output_handle *handle,
 			     struct perf_event *event)
 {
-	u64 enabled = 0, running = 0;
+	u64 enabled = 0, running = 0, now;
 	u64 read_format = event->attr.read_format;
 
 	/*
@@ -3705,7 +3712,7 @@ static void perf_output_read(struct perf
 	 * NMI context
 	 */
 	if (read_format & PERF_FORMAT_TOTAL_TIMES)
-		calc_timer_values(event, &enabled, &running);
+		calc_timer_values(event, &now, &enabled, &running);
 
 	if (event->attr.read_format & PERF_FORMAT_GROUP)
 		perf_output_read_group(handle, event, enabled, running);


