Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab1GAPXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:23:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:57605 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab1GAPXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:23:13 -0400
Date: Fri, 1 Jul 2011 15:23:01 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-ee89cbc2d48150c7c0e9f2aaac00afde99af098c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110606145712.GA7304@quad>
References: <20110606145712.GA7304@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Add Intel Sandy Bridge offcore_response low-level support
Git-Commit-ID: ee89cbc2d48150c7c0e9f2aaac00afde99af098c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:23:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee89cbc2d48150c7c0e9f2aaac00afde99af098c
Gitweb:     http://git.kernel.org/tip/ee89cbc2d48150c7c0e9f2aaac00afde99af098c
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 6 Jun 2011 16:57:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:06:37 +0200

perf_events: Add Intel Sandy Bridge offcore_response low-level support

This patch adds Intel Sandy Bridge offcore_response support by
providing the low-level constraint table for those events.

On Sandy Bridge, there are two offcore_response events. Each uses
its own dedictated extra register. But those registers are NOT shared
between sibling CPUs when HT is on unlike Nehalem/Westmere. They are
always private to each CPU. But they still need to be controlled within
an event group. All events within an event group must use the same
value for the extra MSR. That's not controlled by the second patch in
this series.

Furthermore on Sandy Bridge, the offcore_response events have NO
counter constraints contrary to what the official documentation
indicates, so drop the events from the contraint table.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110606145712.GA7304@quad
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |    1 +
 arch/x86/kernel/cpu/perf_event_intel.c |   13 ++++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9a0f55c..583f311 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -327,6 +327,7 @@ struct x86_pmu {
 	 * Extra registers for events
 	 */
 	struct extra_reg *extra_regs;
+	bool regs_no_ht_sharing;
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index ac02b83..a674ae4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -100,8 +100,6 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
 	/* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
 	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
-	INTEL_EVENT_CONSTRAINT(0xb7, 0x1), /* OFF_CORE_RESPONSE_0 */
-	INTEL_EVENT_CONSTRAINT(0xbb, 0x8), /* OFF_CORE_RESPONSE_1 */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
 	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
 	EVENT_CONSTRAINT_END
@@ -122,6 +120,12 @@ static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 	EVENT_CONSTRAINT_END
 };
 
+static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffffffffull, RSP_0),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
+	EVENT_EXTRA_END
+};
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -1260,7 +1264,7 @@ static void intel_pmu_cpu_starting(int cpu)
 	 */
 	intel_pmu_lbr_reset();
 
-	if (!cpuc->shared_regs)
+	if (!cpuc->shared_regs || x86_pmu.regs_no_ht_sharing)
 		return;
 
 	for_each_cpu(i, topology_thread_cpumask(cpu)) {
@@ -1502,6 +1506,9 @@ static __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_events;
+		x86_pmu.extra_regs = intel_snb_extra_regs;
+		/* all extra regs are per-cpu when HT is on */
+		x86_pmu.regs_no_ht_sharing = true;
 
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
