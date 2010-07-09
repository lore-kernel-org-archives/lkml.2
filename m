Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0GIImS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:42:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:52208 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab0GIIjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:39:54 -0400
Message-Id: <20100709083247.867449426@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 09 Jul 2010 10:21:22 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/13] perf, powerpc: Convert the FSL driver to use local64_t
References: <20100709082117.631541128@chello.nl>
Content-Disposition: inline; filename=perf-fsl-fix-local64_t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason the FSL driver got left out when we converted perf
to use local64_t instead of atomic64_t.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/kernel/perf_event_fsl_emb.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -162,15 +162,15 @@ static void fsl_emb_pmu_read(struct perf
 	 * Therefore we treat them like NMIs.
 	 */
 	do {
-		prev = atomic64_read(&event->hw.prev_count);
+		prev = local64_read(&event->hw.prev_count);
 		barrier();
 		val = read_pmc(event->hw.idx);
-	} while (atomic64_cmpxchg(&event->hw.prev_count, prev, val) != prev);
+	} while (local64_cmpxchg(&event->hw.prev_count, prev, val) != prev);
 
 	/* The counters are only 32 bits wide */
 	delta = (val - prev) & 0xfffffffful;
-	atomic64_add(delta, &event->count);
-	atomic64_sub(delta, &event->hw.period_left);
+	local64_add(delta, &event->count);
+	local64_sub(delta, &event->hw.period_left);
 }
 
 /*
@@ -296,11 +296,11 @@ static int fsl_emb_pmu_enable(struct per
 
 	val = 0;
 	if (event->hw.sample_period) {
-		s64 left = atomic64_read(&event->hw.period_left);
+		s64 left = local64_read(&event->hw.period_left);
 		if (left < 0x80000000L)
 			val = 0x80000000L - left;
 	}
-	atomic64_set(&event->hw.prev_count, val);
+	local64_set(&event->hw.prev_count, val);
 	write_pmc(i, val);
 	perf_event_update_userpage(event);
 
@@ -371,8 +371,8 @@ static void fsl_emb_pmu_unthrottle(struc
 	if (left < 0x80000000L)
 		val = 0x80000000L - left;
 	write_pmc(event->hw.idx, val);
-	atomic64_set(&event->hw.prev_count, val);
-	atomic64_set(&event->hw.period_left, left);
+	local64_set(&event->hw.prev_count, val);
+	local64_set(&event->hw.period_left, left);
 	perf_event_update_userpage(event);
 	perf_enable();
 	local_irq_restore(flags);
@@ -500,7 +500,7 @@ const struct pmu *hw_perf_event_init(str
 		return ERR_PTR(-ENOTSUPP);
 
 	event->hw.last_period = event->hw.sample_period;
-	atomic64_set(&event->hw.period_left, event->hw.last_period);
+	local64_set(&event->hw.period_left, event->hw.last_period);
 
 	/*
 	 * See if we need to reserve the PMU.
@@ -541,16 +541,16 @@ static void record_and_restart(struct pe
 	int record = 0;
 
 	/* we don't have to worry about interrupts here */
-	prev = atomic64_read(&event->hw.prev_count);
+	prev = local64_read(&event->hw.prev_count);
 	delta = (val - prev) & 0xfffffffful;
-	atomic64_add(delta, &event->count);
+	local64_add(delta, &event->count);
 
 	/*
 	 * See if the total period for this event has expired,
 	 * and update for the next period.
 	 */
 	val = 0;
-	left = atomic64_read(&event->hw.period_left) - delta;
+	left = local64_read(&event->hw.period_left) - delta;
 	if (period) {
 		if (left <= 0) {
 			left += period;
@@ -584,8 +584,8 @@ static void record_and_restart(struct pe
 	}
 
 	write_pmc(event->hw.idx, val);
-	atomic64_set(&event->hw.prev_count, val);
-	atomic64_set(&event->hw.period_left, left);
+	local64_set(&event->hw.prev_count, val);
+	local64_set(&event->hw.period_left, left);
 	perf_event_update_userpage(event);
 }
 


