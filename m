Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1LULvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:51:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34124 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab1LULvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:51:03 -0500
Date: Wed, 21 Dec 2011 03:50:30 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-3u1jucza77j3wuvs0x2bic0f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        asharma@fb.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, asharma@fb.com, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/fast] perf: Extend the mmap control page with time (TSC)
  fields
Git-Commit-ID: e3f3541c19c89a4daae39300defba68943301949
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:50:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3f3541c19c89a4daae39300defba68943301949
Gitweb:     http://git.kernel.org/tip/e3f3541c19c89a4daae39300defba68943301949
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 21 Nov 2011 11:43:53 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 11:01:13 +0100

perf: Extend the mmap control page with time (TSC) fields

Extend the mmap control page with fields so that userspace can compute
time deltas relative to the provided time fields.

Currently only implemented for x86 with constant and nonstop TSC.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arun Sharma <asharma@fb.com>
Link: http://lkml.kernel.org/n/tip-3u1jucza77j3wuvs0x2bic0f@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   14 ++++++++++++++
 include/linux/perf_event.h       |    4 +++-
 kernel/events/core.c             |   21 ++++++++++++++-------
 3 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 116b040..f8bddb5 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -32,6 +32,7 @@
 #include <asm/compat.h>
 #include <asm/smp.h>
 #include <asm/alternative.h>
+#include <asm/timer.h>
 
 #include "perf_event.h"
 
@@ -1627,6 +1628,19 @@ static struct pmu pmu = {
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
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 5311b79..0b91db2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -291,12 +291,14 @@ struct perf_event_mmap_page {
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
diff --git a/kernel/events/core.c b/kernel/events/core.c
index dcd4049..3a9c7d8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3220,17 +3220,22 @@ static int perf_event_index(struct perf_event *event)
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
@@ -3240,7 +3245,7 @@ void perf_event_update_userpage(struct perf_event *event)
 {
 	struct perf_event_mmap_page *userpg;
 	struct ring_buffer *rb;
-	u64 enabled, running;
+	u64 enabled, running, now;
 
 	rcu_read_lock();
 	/*
@@ -3252,7 +3257,7 @@ void perf_event_update_userpage(struct perf_event *event)
 	 * because of locking issue as we can be called in
 	 * NMI context
 	 */
-	calc_timer_values(event, &enabled, &running);
+	calc_timer_values(event, &now, &enabled, &running);
 	rb = rcu_dereference(event->rb);
 	if (!rb)
 		goto unlock;
@@ -3277,6 +3282,8 @@ void perf_event_update_userpage(struct perf_event *event)
 	userpg->time_running = running +
 			atomic64_read(&event->child_total_time_running);
 
+	perf_update_user_clock(userpg, now);
+
 	barrier();
 	++userpg->lock;
 	preempt_enable();
@@ -3763,7 +3770,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 static void perf_output_read(struct perf_output_handle *handle,
 			     struct perf_event *event)
 {
-	u64 enabled = 0, running = 0;
+	u64 enabled = 0, running = 0, now;
 	u64 read_format = event->attr.read_format;
 
 	/*
@@ -3776,7 +3783,7 @@ static void perf_output_read(struct perf_output_handle *handle,
 	 * NMI context
 	 */
 	if (read_format & PERF_FORMAT_TOTAL_TIMES)
-		calc_timer_values(event, &enabled, &running);
+		calc_timer_values(event, &now, &enabled, &running);
 
 	if (event->attr.read_format & PERF_FORMAT_GROUP)
 		perf_output_read_group(handle, event, enabled, running);
