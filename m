Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab2EBCHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:07:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:46532 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556Ab2EBCH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:07:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="138970365"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] perf: Export perf_assign_events
Date: Wed,  2 May 2012 10:07:12 +0800
Message-Id: <1335924440-11242-2-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Export perf_assign_events so the uncore code can use it to
schedule events.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |    6 +++---
 arch/x86/kernel/cpu/perf_event.h |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e33e9cf..eec3d09 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -637,7 +637,7 @@ static bool __perf_sched_find_counter(struct perf_sched *sched)
 	c = sched->constraints[sched->state.event];
 
 	/* Prefer fixed purpose counters */
-	if (x86_pmu.num_counters_fixed) {
+	if (c->idxmsk64 & ((u64)-1 << X86_PMC_IDX_FIXED)) {
 		idx = X86_PMC_IDX_FIXED;
 		for_each_set_bit_from(idx, c->idxmsk, X86_PMC_IDX_MAX) {
 			if (!__test_and_set_bit(idx, sched->state.used))
@@ -704,8 +704,8 @@ static bool perf_sched_next_event(struct perf_sched *sched)
 /*
  * Assign a counter for each event.
  */
-static int perf_assign_events(struct event_constraint **constraints, int n,
-			      int wmin, int wmax, int *assign)
+int perf_assign_events(struct event_constraint **constraints, int n,
+			int wmin, int wmax, int *assign)
 {
 	struct perf_sched sched;
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 6638aaf..e6dfc00 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -466,6 +466,8 @@ static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 
 void x86_pmu_enable_all(int added);
 
+int perf_assign_events(struct event_constraint **constraints, int n,
+			int wmin, int wmax, int *assign);
 int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign);
 
 void x86_pmu_stop(struct perf_event *event, int flags);
-- 
1.7.7.6

