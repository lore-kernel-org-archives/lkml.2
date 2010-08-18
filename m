Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab0HRK2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 06:28:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:52904 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab0HRK2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 06:28:17 -0400
Date: Wed, 18 Aug 2010 10:27:44 GMT
From: "tip-bot for Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        arjan@linux.intel.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, arjan@linux.intel.com,
        yanmin_zhang@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1281073148.2125.63.camel@ymzhang.sh.intel.com>
References: <1281073148.2125.63.camel@ymzhang.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Fix Intel-nhm PMU programming errata workaround
Message-ID: <tip-351af0725e5222e35741011d1ea62215c1ed06db@git.kernel.org>
Git-Commit-ID: 351af0725e5222e35741011d1ea62215c1ed06db
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 Aug 2010 10:27:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  351af0725e5222e35741011d1ea62215c1ed06db
Gitweb:     http://git.kernel.org/tip/351af0725e5222e35741011d1ea62215c1ed06db
Author:     Zhang, Yanmin <yanmin_zhang@linux.intel.com>
AuthorDate: Fri, 6 Aug 2010 13:39:08 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Aug 2010 11:17:39 +0200

perf, x86: Fix Intel-nhm PMU programming errata workaround

Fix the Errata AAK100/AAP53/BD53 workaround, the officialy documented
workaround we implemented in:

 11164cd: perf, x86: Add Nehelem PMU programming errata workaround

doesn't actually work fully and causes a stuck PMU state
under load and non-functioning perf profiling.

A functional workaround was found by trial & error.

Affects all Nehalem-class Intel PMUs.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1281073148.2125.63.camel@ymzhang.sh.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@kernel.org> # .35.x
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   81 +++++++++++++++++++++++++-------
 1 files changed, 63 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 214ac86..d8d86d0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -491,33 +491,78 @@ static void intel_pmu_enable_all(int added)
  *   Intel Errata AAP53  (model 30)
  *   Intel Errata BD53   (model 44)
  *
- * These chips need to be 'reset' when adding counters by programming
- * the magic three (non counting) events 0x4300D2, 0x4300B1 and 0x4300B5
- * either in sequence on the same PMC or on different PMCs.
+ * The official story:
+ *   These chips need to be 'reset' when adding counters by programming the
+ *   magic three (non-counting) events 0x4300B5, 0x4300D2, and 0x4300B1 either
+ *   in sequence on the same PMC or on different PMCs.
+ *
+ * In practise it appears some of these events do in fact count, and
+ * we need to programm all 4 events.
  */
-static void intel_pmu_nhm_enable_all(int added)
+static void intel_pmu_nhm_workaround(void)
 {
-	if (added) {
-		struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-		int i;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	static const unsigned long nhm_magic[4] = {
+		0x4300B5,
+		0x4300D2,
+		0x4300B1,
+		0x4300B1
+	};
+	struct perf_event *event;
+	int i;
+
+	/*
+	 * The Errata requires below steps:
+	 * 1) Clear MSR_IA32_PEBS_ENABLE and MSR_CORE_PERF_GLOBAL_CTRL;
+	 * 2) Configure 4 PERFEVTSELx with the magic events and clear
+	 *    the corresponding PMCx;
+	 * 3) set bit0~bit3 of MSR_CORE_PERF_GLOBAL_CTRL;
+	 * 4) Clear MSR_CORE_PERF_GLOBAL_CTRL;
+	 * 5) Clear 4 pairs of ERFEVTSELx and PMCx;
+	 */
+
+	/*
+	 * The real steps we choose are a little different from above.
+	 * A) To reduce MSR operations, we don't run step 1) as they
+	 *    are already cleared before this function is called;
+	 * B) Call x86_perf_event_update to save PMCx before configuring
+	 *    PERFEVTSELx with magic number;
+	 * C) With step 5), we do clear only when the PERFEVTSELx is
+	 *    not used currently.
+	 * D) Call x86_perf_event_set_period to restore PMCx;
+	 */
 
-		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 0, 0x4300D2);
-		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300B1);
-		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B5);
+	/* We always operate 4 pairs of PERF Counters */
+	for (i = 0; i < 4; i++) {
+		event = cpuc->events[i];
+		if (event)
+			x86_perf_event_update(event);
+	}
 
-		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
-		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
+	for (i = 0; i < 4; i++) {
+		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, nhm_magic[i]);
+		wrmsrl(MSR_ARCH_PERFMON_PERFCTR0 + i, 0x0);
+	}
 
-		for (i = 0; i < 3; i++) {
-			struct perf_event *event = cpuc->events[i];
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0xf);
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
 
-			if (!event)
-				continue;
+	for (i = 0; i < 4; i++) {
+		event = cpuc->events[i];
 
+		if (event) {
+			x86_perf_event_set_period(event);
 			__x86_pmu_enable_event(&event->hw,
-					       ARCH_PERFMON_EVENTSEL_ENABLE);
-		}
+					ARCH_PERFMON_EVENTSEL_ENABLE);
+		} else
+			wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0x0);
 	}
+}
+
+static void intel_pmu_nhm_enable_all(int added)
+{
+	if (added)
+		intel_pmu_nhm_workaround();
 	intel_pmu_enable_all(added);
 }
 
