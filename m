Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab0JSN4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:56:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:45083 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab0JSNzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:55:13 -0400
Message-Id: <20101019134808.404167262@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 19 Oct 2010 15:43:01 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/7] perf, x86: Less disastrous PEBS/BTS buffer allocation failure
References: <20101019134256.087045503@chello.nl>
Content-Disposition: inline; filename=perf-perf-event-improve-ds-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently PEBS/BTS buffers are allocated when we instantiate the first
event, when this fails everything fails.

This is a problem because esp. BTS tries to allocate a rather large
buffer (64K), which can easily fail.

This patches changes the logic such that when either buffer allocation
fails, we simply don't allow events that would use these facilities,
but continue functioning for all other events.

This logic comes from a much larger patch proposed by Stephane.

Suggested-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event.c          |    5 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   58 ++++++++++++++++++++++--------
 2 files changed, 47 insertions(+), 16 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -238,6 +238,7 @@ struct x86_pmu {
 	 * Intel DebugStore bits
 	 */
 	int		bts, pebs;
+	int		bts_active, pebs_active;
 	int		pebs_record_size;
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
@@ -478,7 +479,7 @@ static int x86_setup_perfctr(struct perf
 	if ((attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
 	    (hwc->sample_period == 1)) {
 		/* BTS is not supported by this architecture. */
-		if (!x86_pmu.bts)
+		if (!x86_pmu.bts_active)
 			return -EOPNOTSUPP;
 
 		/* BTS is currently only allowed for user-mode. */
@@ -497,7 +498,7 @@ static int x86_pmu_hw_config(struct perf
 		int precise = 0;
 
 		/* Support for constant skid */
-		if (x86_pmu.pebs) {
+		if (x86_pmu.pebs_active) {
 			precise++;
 
 			/* Support for IP fixup */
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -193,36 +193,66 @@ static void release_ds_buffers(void)
 
 static int reserve_ds_buffers(void)
 {
-	int cpu, err = 0;
+	int bts_err = 0, pebs_err = 0;
+	int cpu;
+
+	x86_pmu.bts_active = 0;
+	x86_pmu.pebs_active = 0;
 
 	if (!x86_pmu.bts && !x86_pmu.pebs)
 		return 0;
 
+	if (!x86_pmu.bts)
+		bts_err = 1;
+
+	if (!x86_pmu.pebs)
+		pebs_err = 1;
+
 	get_online_cpus();
 
 	for_each_possible_cpu(cpu) {
-		if (alloc_ds_buffer(cpu))
-			break;
+		if (alloc_ds_buffer(cpu)) {
+			bts_err = 1;
+			pebs_err = 1;
+		}
 
-		if (alloc_bts_buffer(cpu))
-			break;
+		if (!bts_err && alloc_bts_buffer(cpu))
+			bts_err = 1;
+
+		if (!pebs_err && alloc_pebs_buffer(cpu))
+			pebs_err = 1;
 
-		if (alloc_pebs_buffer(cpu))
+		if (bts_err && pebs_err)
 			break;
+	}
+
+	if (bts_err) {
+		for_each_possible_cpu(cpu)
+			release_bts_buffer(cpu);
+	}
 
-		err = 0;
+	if (pebs_err) {
+		for_each_possible_cpu(cpu)
+			release_pebs_buffer(cpu);
 	}
 
-	if (err)
-		release_ds_buffers();
-	else {
+	if (bts_err && pebs_err) {
+		for_each_possible_cpu(cpu)
+			release_ds_buffer(cpu);
+	} else {
+		if (x86_pmu.bts && !bts_err)
+			x86_pmu.bts_active = 1;
+
+		if (x86_pmu.pebs && !pebs_err)
+			x86_pmu.pebs_active = 1;
+
 		for_each_online_cpu(cpu)
 			init_debug_store_on_cpu(cpu);
 	}
 
 	put_online_cpus();
 
-	return err;
+	return 0;
 }
 
 /*
@@ -287,7 +317,7 @@ static int intel_pmu_drain_bts_buffer(vo
 	if (!event)
 		return 0;
 
-	if (!ds)
+	if (!x86_pmu.bts_active)
 		return 0;
 
 	at  = (struct bts_record *)(unsigned long)ds->bts_buffer_base;
@@ -557,7 +587,7 @@ static void intel_pmu_drain_pebs_core(st
 	struct pebs_record_core *at, *top;
 	int n;
 
-	if (!ds || !x86_pmu.pebs)
+	if (!x86_pmu.pebs_active)
 		return;
 
 	at  = (struct pebs_record_core *)(unsigned long)ds->pebs_buffer_base;
@@ -599,7 +629,7 @@ static void intel_pmu_drain_pebs_nhm(str
 	u64 status = 0;
 	int bit, n;
 
-	if (!ds || !x86_pmu.pebs)
+	if (!x86_pmu.pebs_active)
 		return;
 
 	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;


