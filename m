Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab2FTKuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:50:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34513 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab2FTKuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:50:13 -0400
Date: Wed, 20 Jun 2012 03:49:59 -0700
From: "tip-bot for Yan, Zheng" <zheng.z.yan@intel.com>
Message-ID: <tip-4b4969b14490a4f65b572b8f180164181104b5e1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <1339741902-8449-2-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-2-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Export perf_assign_events()
Git-Commit-ID: 4b4969b14490a4f65b572b8f180164181104b5e1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 03:50:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b4969b14490a4f65b572b8f180164181104b5e1
Gitweb:     http://git.kernel.org/tip/4b4969b14490a4f65b572b8f180164181104b5e1
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Fri, 15 Jun 2012 14:31:30 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Jun 2012 12:13:20 +0200

perf: Export perf_assign_events()

Export perf_assign_events() so the uncore code can use it to
schedule events.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1339741902-8449-2-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |    6 +++---
 arch/x86/kernel/cpu/perf_event.h |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index d1f38c9..6d32aef 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -626,7 +626,7 @@ static bool __perf_sched_find_counter(struct perf_sched *sched)
 	c = sched->constraints[sched->state.event];
 
 	/* Prefer fixed purpose counters */
-	if (x86_pmu.num_counters_fixed) {
+	if (c->idxmsk64 & (~0ULL << X86_PMC_IDX_FIXED)) {
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
