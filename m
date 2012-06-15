Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2FOGc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 02:32:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:19105 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab2FOGc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 02:32:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156658679"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, jolsa@redhat.com,
        eranian@google.com, andi@firstfloor.org, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V6 01/13] perf: Export perf_assign_events
Date: Fri, 15 Jun 2012 14:31:30 +0800
Message-Id: <1339741902-8449-2-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
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
index 9000590..0c9041c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -626,7 +626,7 @@ static bool __perf_sched_find_counter(struct perf_sched *sched)
 	c = sched->constraints[sched->state.event];
 
 	/* Prefer fixed purpose counters */
-	if (x86_pmu.num_counters_fixed) {
+	if (c->idxmsk64 & ((u64)-1 << X86_PMC_IDX_FIXED)) {
 		idx = X86_PMC_IDX_FIXED;
 		for_each_set_bit_from(idx, c->idxmsk, X86_PMC_IDX_MAX) {
 			if (!__test_and_set_bit(idx, sched->state.used))
@@ -693,8 +693,8 @@ static bool perf_sched_next_event(struct perf_sched *sched)
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
index 3df3de9..83238f2 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -481,6 +481,8 @@ static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 
 void x86_pmu_enable_all(int added);
 
+int perf_assign_events(struct event_constraint **constraints, int n,
+			int wmin, int wmax, int *assign);
 int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign);
 
 void x86_pmu_stop(struct perf_event *event, int flags);
-- 
1.7.6.5

